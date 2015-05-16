#define MAX_STACK_SIZE 4000
#define MAX_MUTEXES 64

/********************************
        The API of the KLT package
 ********************************/


// Per-process state


struct kthread_mutex_t {

  enum mutex_state state;           // mutex state
  int id;                     // mutex ID
  int locked;
  struct thread *threads_queue[NTHREAD]; //threads queue in the mutex
  int first; // first in threads queue
  int last; // last in threads queue
  struct spinlock * queueLock ;

};

int kthread_create(void*(*start_func)(), void* stack, uint stack_size);
int kthread_id();
void kthread_exit();
int kthread_join(int thread_id);

int kthread_mutex_alloc();
int kthread_mutex_dealloc(int mutex_id);
int kthread_mutex_lock(int mutex_id);
int kthread_mutex_unlock(int mutex_id);
int kthread_mutex_yieldlock(int mutex_id1, int mutex_id2);
