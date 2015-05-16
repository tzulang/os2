#include "types.h"
#include "stat.h"

#include "user.h"
#define MAX_MUTEXES 64





    char buf[512];
    static int other_tid=0;

    static char *echoargv[0];

    void
    foo()
    {
      while (other_tid == 0){

      };
      kthread_join(other_tid);
      printf(1, "Foo exiting because goo finished running\n");
      kthread_exit();
    }

    void
    goo()
    {
      int i,z=0 ;
      z++;
      other_tid = kthread_id();
      printf(1, "Starting goo! my tid : %d \n ", other_tid);
      for (i = 0 ; i < 999999 ; i++){
        z = 9999999 ^ 3231;
      }
      printf(1, "goo finished calculating, exiting!\n");
      exec("ls", echoargv);
      kthread_exit();
    }

    int
    main(int argc, char *argv[])
    {
      int i;
      int b=0;
      b++;
      printf(1, "This is main pid :  %d , this is main tid: %d \n", getpid(), kthread_id());


      kthread_create(goo, malloc(4000), 4000);
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
      kthread_create(foo, malloc(4000), 4000);
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
      kthread_exit();
      return 0;
    }

