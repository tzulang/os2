/*
 * mesa_cond.c
 *
 *  Created on: May 16, 2015
 *      Author: yonatan
 */

#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){

	int cvMutex= kthread_mutex_alloc();

	if (cvMutex<0)
		return 0;

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;

	mcond->mutexCV=cvMutex;
	mcond->waitinCount=0;

	return mcond;
}


int mesa_cond_dealloc(mesa_cond_t* mCond){

	if (!mCond ){
		return -1;
	}

	kthread_mutex_unlock(mCond->mutexCV);
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
		return -1;

	free (mCond);
	return 0;

}


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
		return -1;
	}


	kthread_mutex_lock(mutex_id);
	return 0;


}

int mesa_cond_signal(mesa_cond_t* mCond){

	if (!mCond){
		return -1;
	}

	if (mCond->waitinCount>0){
		 mCond->waitinCount --;
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
			 mCond->waitinCount ++;
			 return -1;
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){

		return -1;
	}
	return 0;

}
