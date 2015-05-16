/*
 * hoare_slots_monitor.c
 *
 *  Created on: May 16, 2015
 *      Author: yonatan
 */

#include "hoare_slots_monitor.h"
#include "hoare_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){


	int mutex=  kthread_mutex_alloc() ;

	if( mutex < 0)
		return 0;

	struct hoare_cond * empty = hoare_cond_alloc();

	if (empty == 0){
		kthread_mutex_dealloc(mutex);
		return 0;
	}

	hoare_cond_t * full = hoare_cond_alloc();

	if (full == 0)
	{
		kthread_mutex_dealloc(mutex);
		hoare_cond_dealloc(empty);
		return 0;
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));

	monitor->empty= empty;
	monitor->full= full;
	monitor->Monitormutex= mutex;
	monitor->slots=0;
	monitor->active=1;

	return monitor;

}


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
	}

	free(monitor);
	return 0;
}

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){

	if (!monitor->active)
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	if ( monitor->active && monitor->slots > 0 )
				hoare_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
			monitor->slots+= n;

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
	kthread_mutex_unlock( monitor->Monitormutex );

	return 1;


}


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){


	if (!monitor->active)
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	if ( monitor->active && monitor->slots == 0 )
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
			monitor->slots--;

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
	kthread_mutex_unlock( monitor->Monitormutex );

	return 1;

}
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){


		if (!monitor->active)
			return -1;

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
			return -1;

		monitor->active = 0;

		kthread_mutex_unlock( monitor->Monitormutex );

		return 0;
}


