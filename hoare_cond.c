/*
 * hoare_cond.c
 *
 *  Created on: May 16, 2015
 *      Author: yonatan
 */

#include  "hoare_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){

	int cvMutex= kthread_mutex_alloc();

	if (cvMutex<0)
		return 0;

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;

	hcond->mutexCV=cvMutex;
	hcond->waitinCount=0;

	return hcond;
}


int hoare_cond_dealloc(hoare_cond_t* hCond){

	if (!hCond ){
			return -1;
		}

		kthread_mutex_unlock(hCond->mutexCV);
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
			return -1;

		free (hCond);
		return 0;
}


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){

	if (!hCond){
			return -1;
		}

	hCond->waitinCount++;


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
		{
			hCond->waitinCount--;
			return -1;
		}

	return 0;
}



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{

	if (!hCond){
		return -1;
	}

    if ( hCond->waitinCount >0){
    	hCond->waitinCount--;
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
			hCond->waitinCount++;
			return -1;
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){

    			return -1;
    }

	return 0;

}


