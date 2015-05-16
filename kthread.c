
#ifndef KTHREAD_H_
#define KTHREAD_H_

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "spinlock.h"
#include "proc.h"
#include "kthread.h"


extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;



int nextpid = 1;
extern void forkret(void);
extern void trapret(void);
extern void forkret(void);


extern void wakeup1(void *chan);


void
increaseNumOfThreadsAlive(void){
	int i = thread->proc->numOfThreads++;
	//cprintf("num o threads %d \n" , i);
	if(i > NTHREAD)
		panic("Too many threads");
}


void
decreaseNumOfThreadsAlive(void){

	int i = thread->proc->numOfThreads--;
	//cprintf("num o threads %d 0\n" , i);
	if(i < 0)
		panic("Not enough threads");
}


struct {
	struct kthread_mutex_t mutexes[MAX_MUTEXES];
	struct spinlock mutexspinLock[MAX_MUTEXES];
} mutextable;





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





int EmptyQueue(struct kthread_mutex_t *m){

  return (m->threads_queue[0]==0);

}

void pushThreadToMutexQueue(struct thread *t , struct kthread_mutex_t *m){

  if (m->last == NTHREAD)
	  panic ("Mutex oveflow\n");


  m->threads_queue[m->last]= t;

  m->last++;

}


struct thread * popThreadToMutexQueue(struct kthread_mutex_t *m){

  struct thread * toReturn = m->threads_queue[m->first];
  int i;


  if (toReturn==0)
	  	  panic("Mutex over pop. Can't pop this... \n");


  for (i =1 ; i< NTHREAD ; i++){

	  m->threads_queue[i-1]= m->threads_queue[i];

	  if (m->threads_queue[i]==0)
		  break;

  }
  m->last--;
  m->threads_queue[NTHREAD-1]=0;


  return toReturn;
}


int kthread_mutex_alloc(void){

    int index=0;
    struct kthread_mutex_t *m;

    for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){

        if(m->state == UNUSED_MUTEX){
          m->state = USED_MUTEX;
          m->id = index;
          m->queueLock= &mutextable.mutexspinLock[index];
          initlock(m->queueLock, "mutexLock");
          m->last = 0;
          m->first = 0;
          return m->id;
        } else {
        	index++;
        }
    }

  return -1;
}

int kthread_mutex_dealloc(int mutex_id){

  struct kthread_mutex_t *m;

  //cprintf("1- %d\n", mutex_id);
  for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){


	  if(  m->id== mutex_id ){    //mutesx is not locked
		  //cprintf("id-%d  st-%d  locked %d\n", m->id , m->state, m->locked);
		  if(  m->state==USED_MUTEX &&  !m->locked ){
					  m->state = UNUSED_MUTEX;
					  m->id= -1;
					  //cprintf("dealoc\n");
					  return 0;
		  }
		  return -1;
        }
  }

  return -1;
}

int kthread_mutex_lock(int mutex_id){

 // pushcli(); // disable interrupts to avoid deadlock.
  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];



  if (m->state==UNUSED_MUTEX){

		return -1;
  }
  acquire(m->queueLock);
  if (m->locked == 1){ //mutex is locked so push the thread into the queue
	 //   cprintf("the mutax is locked so thread %d is queued\n", thread->pid);
		pushThreadToMutexQueue(thread, m);
		acquire(&ptable.lock);
		thread->state =BLOCKED;
		release(m->queueLock);
		//cprintf("***************** %d \n", cpu->ncli);
		sched();
		acquire(m->queueLock);
		release(&ptable.lock);

  }
 //cprintf("the mutax is unlocked so thread %d is locking it\n", thread->pid);
  m->locked = 1;

  release(m->queueLock);
  return 0;
}

int kthread_mutex_unlock(int mutex_id){



  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];
  struct thread *t;

  if (m->state==UNUSED_MUTEX){

			return -1;
	  }
  acquire(m->queueLock);

  if(m->locked == 0){   //mutex is unlocked already
	  release(m->queueLock);
	  return -1;
  }

  if(!EmptyQueue(m)){ // someone is waiting
      t =  popThreadToMutexQueue(m);
      acquire(&ptable.lock);
      t->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
  }

  //no one is waiting
  m->locked = 0;
  release(m->queueLock);
  return 0;
}



int kthread_mutex_yieldlock(int mutex_id1, int mutex_id2){
  struct kthread_mutex_t *m1, *m2;
  struct thread *t=0;

  m1 = &mutextable.mutexes[mutex_id1];
  m2 = &mutextable.mutexes[mutex_id2];

  if(m1->locked == 0){
    return -1;
  }

  acquire(m2->queueLock);
  if (!EmptyQueue(m2)){ 					//someone is waiting in mutex_id2


	    t =  popThreadToMutexQueue( m2);

	    acquire(&ptable.lock);
	    thread->state =BLOCKED;
	    t->state = RUNNABLE;
	    pushThreadToMutexQueue(thread, m2);
		release(m2->queueLock);
		sched();

		release(&ptable.lock);

		return 0;

  }


   // no one is waiting in mutex_id2

   release(m2->queueLock);
   kthread_mutex_unlock(m2->id);
   kthread_mutex_unlock(m1->id);


   return 0;
}

#endif /* KTHREAD_H */

















