/*
 * mesaSimulation.c
 *
 *  Created on: May 16, 2015
 *      Author: yonatan
 */


#include "mesa_slots_monitor.h"
#include "types.h"
#include "stat.h"
#include "user.h"

#define MAXSTACKSIZE 4000

mesa_slots_monitor_t * monitor ;
int m;
int n;

void getSlot(void);


void addSlot(void);

int  main (int argc, char* argv[]){



	if (argc <3){
		 printf (1, "Not enough arguments to run simulation\n");
		 exit();
	}

	m= atoi(argv[1]);
	n= atoi(argv[2]);

	if (n==0 ||m==0){
		 printf (1, "Error reading arguments. Insert numbers greater then 0 to run simulation\n");
		 exit();
	}

	monitor = mesa_slots_monitor_alloc();

	if (monitor==0){
		 printf (1, "Error creating monitor \n");
		 exit();
	}

	int studentsThread[m];
	char* stacks[m];
	int graderThread;



	int index=0;
	while (index <m){

		stacks[index]= malloc (MAXSTACKSIZE);
		if ( (studentsThread[index] =kthread_create(getSlot, stacks[index], MAXSTACKSIZE) )< 0){
			printf(1,"%p \n", getSlot);
			printf(1, "Error Allocating threads for students\n ");
			exit();
		}
		index++;

	}

	if ( (graderThread=kthread_create(addSlot, stacks[index], MAXSTACKSIZE))< 0){
				printf(1, "Error Allocating threads for grader");
				exit();
	}


	index=0;
	while (index <m){

		kthread_join( studentsThread[index]);
		free(stacks[index]);
	}

	mesa_slots_monitor_stopadding(monitor);

	kthread_join( graderThread);

	exit();
	return 0;
}


void getSlot(void){

	mesa_slots_monitor_takeslot (monitor);
	printf (1, " student %d got a slot \n",kthread_id());
	kthread_exit();
}

void addSlot(void){

	while (monitor->active){
		mesa_slots_monitor_addslots(monitor, n);
	}
	printf (1, " grader stopped producing slots \n",kthread_id());
	kthread_exit();
}
