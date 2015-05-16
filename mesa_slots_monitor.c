/*
 * mesa_slots_monitor.c
 *
 *  Created on: May 16, 2015
 *      Author: yonatan
 */

#include "mesa_slots_monitor.h"
#include "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){

	int mutex=  kthread_mutex_alloc() ;
	if( mutex < 0){

		return 0;
	}

	struct mesa_cond * empty = mesa_cond_alloc();

	if (empty == 0){
		kthread_mutex_dealloc(mutex);
		return 0;
	}

	struct mesa_cond * full = mesa_cond_alloc();


	if (full == 0){
		kthread_mutex_dealloc(mutex);
		mesa_cond_dealloc(empty);
		return 0;
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));

	monitor->empty= empty;
	monitor->full= full;
	monitor->Monitormutex= mutex;
	monitor->slots=0;
	monitor->active=1;

	return monitor;

}


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
	}

	free(monitor);
	return 0;
}

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){

	if (!monitor->active)
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
			monitor->slots+= n;

	mesa_cond_signal(monitor->empty);
	kthread_mutex_unlock( monitor->Monitormutex );

	return 1;


}


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){


	if (!monitor->active)
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
			monitor->slots--;

	mesa_cond_signal(monitor->full);
	kthread_mutex_unlock( monitor->Monitormutex );

	return 1;

}
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){


		if (!monitor->active)
			return -1;

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
			return -1;

		monitor->active = 0;

		kthread_mutex_unlock( monitor->Monitormutex );

		return 0;
}
