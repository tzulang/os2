#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"



struct {
  struct spinlock lock;
  struct proc proc[NPROC];

} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);



void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  struct thread *threads;
  char *sp;



  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  threads = p->threads;
  p->numOfThreads = 0;

  threads->state=EMBRYO;
  threads->proc=p;

  p->pid = nextpid++;
  threads->pid =nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((threads->kstack = kalloc()) == 0){
    p->state = UNUSED;
    threads->state = UNUSED;
    return 0;
  }

  sp = threads->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *threads->tf;
  threads->tf = (struct trapframe*)sp;


  // which returns to trapret.
  // Set up new context to start executing at forkret,

  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *threads->context;
  threads->context = (struct context*)sp;
  memset(threads->context, 0, sizeof *threads->context);
  threads->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->threads->tf, 0, sizeof(*p->threads->tf));
  p->threads->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->threads->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->threads->tf->es = p->threads->tf->ds;
  p->threads->tf->ss = p->threads->tf->ds;
  p->threads->tf->eflags = FL_IF;
  p->threads->tf->esp = PGSIZE;
  p->threads->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->numOfThreads = 0;

  p->state = RUNNABLE;
  p->threads->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *proc= thread->proc;
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(thread);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *proc=thread->proc;
  struct thread *nt;




  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  nt= np->threads;

  // Copy process state from p.



  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(nt->kstack);

    nt->kstack = 0;
    np->state = UNUSED;
    nt->state = UNUSED;

    return -1;
  }

  np->sz = proc->sz;
  nt->proc= np;
  np->parent = proc;
  *nt->tf = *thread->tf;

  // Clear %eax so that fork returns 0 in the child.
  nt->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;
  nt->pid= nextpid++;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->numOfThreads = 1;
  np->state = RUNNABLE;
  nt->state = RUNNABLE;
  release(&ptable.lock);
  
  return pid;
}


void
increaseNumOfThreadsAlive(void){
	int i = thread->proc->numOfThreads++;
	if(i > NTHREAD)
		panic("Too many threads");
}


void
decreaseNumOfThreadsAlive(void){
	int i = thread->proc->numOfThreads--;
	if(i < 0)
		panic("Not enough threads");
}

int
procIsAlive(){
	return thread->proc->numOfThreads > 0;
}


// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  struct proc *proc =thread->proc;
  struct thread *t;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
  decreaseNumOfThreadsAlive();
  proc->killed = 1;
  for (t = proc->threads; t < &proc->threads[NTHREAD]; t++){
  		if (t->state != RUNNING && t->state != UNUSED){
  			t->state = ZOMBIE;
  			decreaseNumOfThreadsAlive();

  		}
  	}

  // Jump into the scheduler, never to return.
 if(!procIsAlive())
	  proc->state = ZOMBIE;
 thread->state = ZOMBIE;

  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *proc=thread->proc;
  struct thread *t;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){

    		  if (t->state == ZOMBIE){
				  t->chan= 0;
				  t->context = 0;
				  t->pid = 0;
				  t->proc = 0;
				  t->state = 0;
				 // t->tf = 0;
				  t->state= UNUSED;
				  if (t->kstack)
					  kfree(t->kstack);
    		  }
    	  }

        pid = p->pid;

        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
  return -1;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct thread *t;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
					continue;
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){

				  if(t->state != RUNNABLE)
					continue;
				  // Switch to chosen process.  It is the process's job
				  // to release ptable.lock and then reacquire it
				  // before jumping back to us.
				  thread = t;
				  switchuvm(thread);
				  t->state = RUNNING;
				  swtch(&cpu->scheduler, thread->context);
				  switchkvm();

				  // Process is done running for now.
				  // It should have changed its p->state before coming back.
				  thread = 0;
			  }

    }

    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(thread->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  swtch(&thread->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{

  acquire(&ptable.lock);  //DOC: yieldlock
  thread->state = RUNNABLE;

  sched();

  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(thread == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  thread->chan = chan;
  thread->state = SLEEPING;
  sched();

  // Tidy up.
  thread->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
		if(t->state == SLEEPING && t->chan == chan)
		  t->state = RUNNABLE;
	 }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
			 if(t->state == SLEEPING)
					t->state = RUNNABLE;
      }
      // Wake process from sleep if necessary.

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)thread->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}



void
wakeupThreads(void *chan)
{


  struct thread *t;
  for(t= thread->proc->threads; t < &thread->proc->threads[NTHREAD]; t++){
		  if(t->state == SLEEPING && t->chan == chan){
			  t->state =  RUNNABLE;
			  }
   }
}


int
kthread_create(void*(*start_func)(), void* stack, uint stack_size){

	  struct thread *t ;


	  char *sp;

	  acquire(&ptable.lock);
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
	    if(t->state == UNUSED){
	       goto found;
	    }
	  }
	  release(&ptable.lock);
	  return -1;

	  found:
	       t->state=EMBRYO;
	       t->pid= nextpid++;
	       increaseNumOfThreadsAlive();
	       release(&ptable.lock);
	       if((t->kstack = kalloc()) == 0){
	        t->state = UNUSED;
	        return -1;
	       }
	       sp = t->kstack + KSTACKSIZE;
	       sp -= sizeof *t->tf;

	       t->tf = (struct trapframe*)sp ;
	       sp -= 4;
	       *(uint*)sp = (uint)trapret;
	       sp -= sizeof *t->context;
	       t->context = (struct context*)sp;
	       memset(t->context, 0, sizeof *t->context);


	       t->context->eip = (uint)forkret;
	       *t->tf=*thread->tf;
	       t->tf->eip = (uint)start_func;
	       t->tf->esp = (uint)(stack+stack_size);
	       t->tf->eflags = FL_IF;
	       t->proc = thread->proc;
	       t->state = RUNNABLE;
	       return t->pid;


}

int kthread_id(){

	return thread->pid;
}

void kthread_exit(){




	 struct proc *proc =thread->proc;


	 acquire(&ptable.lock);

	 thread->state= ZOMBIE;

	 if (proc->numOfThreads == 1 ){  //tis is ta lst tred
		 	release(&ptable.lock);
		 	exit();

	 }

	 decreaseNumOfThreadsAlive();

	 wakeup1(thread);

	 sched();
	 panic("zombie exit");
}

int kthread_join(int thread_id){


	//printf( "thread id : %d ", thread_id);
	  int found;
	  struct thread *t;
	  struct thread *threadFound;

	  acquire(&ptable.lock);

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){

	      if(t->pid != thread_id)
	        continue;
	      found = 1;
	      threadFound= t;

	      if(t->state == ZOMBIE){
	        // Found one.
	        t->chan= 0;
			t->context = 0;
			t->pid = 0;
			t->proc = 0;
			t->state = 0;
			t->state= UNUSED;
			if (t->kstack)
				kfree(t->kstack);

	        release(&ptable.lock);
	        return 0;
	      }
	    }


	    if(!found || thread->proc->killed){

	      release(&ptable.lock);
	      return -1;
	    }

	    // Wait for thread to exit
	    sleep(threadFound, &ptable.lock);  //DOC: wait-sleep

	  }


	  return -1;
}

























