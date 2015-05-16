
_t:     file format elf32-i386


Disassembly of section .text:

00000000 <safeThread>:
      printf(2, "\n"); \
      exit(); \
    }


void* safeThread(){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 24             	sub    $0x24,%esp
  int i;

  /* part one use mutual array of resources */
  ASSERT((kthread_mutex_lock(mutex1) == -1), "kthread_mutex_lock(%d) fail", mutex1);
       7:	a1 d0 31 00 00       	mov    0x31d0,%eax
       c:	89 04 24             	mov    %eax,(%esp)
       f:	e8 ae 20 00 00       	call   20c2 <kthread_mutex_lock>
      14:	83 f8 ff             	cmp    $0xffffffff,%eax
      17:	75 5a                	jne    73 <safeThread+0x73>
      19:	c7 44 24 0c 7b 00 00 	movl   $0x7b,0xc(%esp)
      20:	00 
      21:	c7 44 24 08 f9 2b 00 	movl   $0x2bf9,0x8(%esp)
      28:	00 
      29:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
      30:	00 
      31:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      38:	e8 7d 21 00 00       	call   21ba <printf>
      3d:	a1 d0 31 00 00       	mov    0x31d0,%eax
      42:	89 44 24 08          	mov    %eax,0x8(%esp)
      46:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
      4d:	00 
      4e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      55:	e8 60 21 00 00       	call   21ba <printf>
      5a:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
      61:	00 
      62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      69:	e8 4c 21 00 00       	call   21ba <printf>
      6e:	e8 7f 1f 00 00       	call   1ff2 <exit>

  resource1[0] = kthread_id();
      73:	e8 22 20 00 00       	call   209a <kthread_id>
      78:	a3 80 31 00 00       	mov    %eax,0x3180
  for(i = 1 ;i < 20; i++){
      7d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      84:	eb 31                	jmp    b7 <safeThread+0xb7>
    sleep(i % 2);   // make some more troubles
      86:	8b 45 f4             	mov    -0xc(%ebp),%eax
      89:	99                   	cltd   
      8a:	c1 ea 1f             	shr    $0x1f,%edx
      8d:	01 d0                	add    %edx,%eax
      8f:	83 e0 01             	and    $0x1,%eax
      92:	29 d0                	sub    %edx,%eax
      94:	89 04 24             	mov    %eax,(%esp)
      97:	e8 e6 1f 00 00       	call   2082 <sleep>
    resource1[i] = resource1[i-1];
      9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
      9f:	83 e8 01             	sub    $0x1,%eax
      a2:	8b 14 85 80 31 00 00 	mov    0x3180(,%eax,4),%edx
      a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
      ac:	89 14 85 80 31 00 00 	mov    %edx,0x3180(,%eax,4)

  /* part one use mutual array of resources */
  ASSERT((kthread_mutex_lock(mutex1) == -1), "kthread_mutex_lock(%d) fail", mutex1);

  resource1[0] = kthread_id();
  for(i = 1 ;i < 20; i++){
      b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      b7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
      bb:	7e c9                	jle    86 <safeThread+0x86>
    sleep(i % 2);   // make some more troubles
    resource1[i] = resource1[i-1];
  }
  sleep(kthread_id() % 2);   // make some more troubles
      bd:	e8 d8 1f 00 00       	call   209a <kthread_id>
      c2:	99                   	cltd   
      c3:	c1 ea 1f             	shr    $0x1f,%edx
      c6:	01 d0                	add    %edx,%eax
      c8:	83 e0 01             	and    $0x1,%eax
      cb:	29 d0                	sub    %edx,%eax
      cd:	89 04 24             	mov    %eax,(%esp)
      d0:	e8 ad 1f 00 00       	call   2082 <sleep>
  ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id:%d) fail", i, kthread_id());
      d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d8:	83 e8 01             	sub    $0x1,%eax
      db:	8b 1c 85 80 31 00 00 	mov    0x3180(,%eax,4),%ebx
      e2:	e8 b3 1f 00 00       	call   209a <kthread_id>
      e7:	39 c3                	cmp    %eax,%ebx
      e9:	74 61                	je     14c <safeThread+0x14c>
      eb:	c7 44 24 0c 83 00 00 	movl   $0x83,0xc(%esp)
      f2:	00 
      f3:	c7 44 24 08 f9 2b 00 	movl   $0x2bf9,0x8(%esp)
      fa:	00 
      fb:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     102:	00 
     103:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     10a:	e8 ab 20 00 00       	call   21ba <printf>
     10f:	e8 86 1f 00 00       	call   209a <kthread_id>
     114:	89 44 24 0c          	mov    %eax,0xc(%esp)
     118:	8b 45 f4             	mov    -0xc(%ebp),%eax
     11b:	89 44 24 08          	mov    %eax,0x8(%esp)
     11f:	c7 44 24 04 80 28 00 	movl   $0x2880,0x4(%esp)
     126:	00 
     127:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     12e:	e8 87 20 00 00       	call   21ba <printf>
     133:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     13a:	00 
     13b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     142:	e8 73 20 00 00       	call   21ba <printf>
     147:	e8 a6 1e 00 00       	call   1ff2 <exit>

  ASSERT((kthread_mutex_unlock(mutex1) == -1), "kthread_mutex_unlock(%d) fail", mutex1);
     14c:	a1 d0 31 00 00       	mov    0x31d0,%eax
     151:	89 04 24             	mov    %eax,(%esp)
     154:	e8 71 1f 00 00       	call   20ca <kthread_mutex_unlock>
     159:	83 f8 ff             	cmp    $0xffffffff,%eax
     15c:	75 5a                	jne    1b8 <safeThread+0x1b8>
     15e:	c7 44 24 0c 85 00 00 	movl   $0x85,0xc(%esp)
     165:	00 
     166:	c7 44 24 08 f9 2b 00 	movl   $0x2bf9,0x8(%esp)
     16d:	00 
     16e:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     175:	00 
     176:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     17d:	e8 38 20 00 00       	call   21ba <printf>
     182:	a1 d0 31 00 00       	mov    0x31d0,%eax
     187:	89 44 24 08          	mov    %eax,0x8(%esp)
     18b:	c7 44 24 04 a6 28 00 	movl   $0x28a6,0x4(%esp)
     192:	00 
     193:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     19a:	e8 1b 20 00 00       	call   21ba <printf>
     19f:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     1a6:	00 
     1a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1ae:	e8 07 20 00 00       	call   21ba <printf>
     1b3:	e8 3a 1e 00 00       	call   1ff2 <exit>

  /* part two - mutual calculation */
  ASSERT((kthread_mutex_lock(mutex2) == -1), "kthread_mutex_lock(%d) fail", mutex2);
     1b8:	a1 60 31 00 00       	mov    0x3160,%eax
     1bd:	89 04 24             	mov    %eax,(%esp)
     1c0:	e8 fd 1e 00 00       	call   20c2 <kthread_mutex_lock>
     1c5:	83 f8 ff             	cmp    $0xffffffff,%eax
     1c8:	75 5a                	jne    224 <safeThread+0x224>
     1ca:	c7 44 24 0c 88 00 00 	movl   $0x88,0xc(%esp)
     1d1:	00 
     1d2:	c7 44 24 08 f9 2b 00 	movl   $0x2bf9,0x8(%esp)
     1d9:	00 
     1da:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     1e1:	00 
     1e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1e9:	e8 cc 1f 00 00       	call   21ba <printf>
     1ee:	a1 60 31 00 00       	mov    0x3160,%eax
     1f3:	89 44 24 08          	mov    %eax,0x8(%esp)
     1f7:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
     1fe:	00 
     1ff:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     206:	e8 af 1f 00 00       	call   21ba <printf>
     20b:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     212:	00 
     213:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21a:	e8 9b 1f 00 00       	call   21ba <printf>
     21f:	e8 ce 1d 00 00       	call   1ff2 <exit>
  sleep(kthread_id() % 2);   // make some more troubles
     224:	e8 71 1e 00 00       	call   209a <kthread_id>
     229:	99                   	cltd   
     22a:	c1 ea 1f             	shr    $0x1f,%edx
     22d:	01 d0                	add    %edx,%eax
     22f:	83 e0 01             	and    $0x1,%eax
     232:	29 d0                	sub    %edx,%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 46 1e 00 00       	call   2082 <sleep>
  resource2 = resource2 + kthread_id();
     23c:	e8 59 1e 00 00       	call   209a <kthread_id>
     241:	8b 15 64 31 00 00    	mov    0x3164,%edx
     247:	01 d0                	add    %edx,%eax
     249:	a3 64 31 00 00       	mov    %eax,0x3164
  ASSERT((kthread_mutex_unlock(mutex2) == -1), "kthread_mutex_unlock(%d) fail", mutex2);
     24e:	a1 60 31 00 00       	mov    0x3160,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 6f 1e 00 00       	call   20ca <kthread_mutex_unlock>
     25b:	83 f8 ff             	cmp    $0xffffffff,%eax
     25e:	75 5a                	jne    2ba <safeThread+0x2ba>
     260:	c7 44 24 0c 8b 00 00 	movl   $0x8b,0xc(%esp)
     267:	00 
     268:	c7 44 24 08 f9 2b 00 	movl   $0x2bf9,0x8(%esp)
     26f:	00 
     270:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     277:	00 
     278:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     27f:	e8 36 1f 00 00       	call   21ba <printf>
     284:	a1 60 31 00 00       	mov    0x3160,%eax
     289:	89 44 24 08          	mov    %eax,0x8(%esp)
     28d:	c7 44 24 04 a6 28 00 	movl   $0x28a6,0x4(%esp)
     294:	00 
     295:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     29c:	e8 19 1f 00 00       	call   21ba <printf>
     2a1:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     2a8:	00 
     2a9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     2b0:	e8 05 1f 00 00       	call   21ba <printf>
     2b5:	e8 38 1d 00 00       	call   1ff2 <exit>

  kthread_exit();
     2ba:	e8 e3 1d 00 00       	call   20a2 <kthread_exit>
  return 0;
     2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2c4:	83 c4 24             	add    $0x24,%esp
     2c7:	5b                   	pop    %ebx
     2c8:	5d                   	pop    %ebp
     2c9:	c3                   	ret    

000002ca <unsafeThread>:

void* unsafeThread(){
     2ca:	55                   	push   %ebp
     2cb:	89 e5                	mov    %esp,%ebp
     2cd:	83 ec 28             	sub    $0x28,%esp
  int i;

  resource1[0] = kthread_id();
     2d0:	e8 c5 1d 00 00       	call   209a <kthread_id>
     2d5:	a3 80 31 00 00       	mov    %eax,0x3180
  for(i = 1 ;i < 20; i++){
     2da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     2e1:	eb 31                	jmp    314 <unsafeThread+0x4a>
    sleep(i % 2);   // make some more troubles
     2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2e6:	99                   	cltd   
     2e7:	c1 ea 1f             	shr    $0x1f,%edx
     2ea:	01 d0                	add    %edx,%eax
     2ec:	83 e0 01             	and    $0x1,%eax
     2ef:	29 d0                	sub    %edx,%eax
     2f1:	89 04 24             	mov    %eax,(%esp)
     2f4:	e8 89 1d 00 00       	call   2082 <sleep>
    resource1[i] = resource1[i-1];
     2f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2fc:	83 e8 01             	sub    $0x1,%eax
     2ff:	8b 14 85 80 31 00 00 	mov    0x3180(,%eax,4),%edx
     306:	8b 45 f4             	mov    -0xc(%ebp),%eax
     309:	89 14 85 80 31 00 00 	mov    %edx,0x3180(,%eax,4)

void* unsafeThread(){
  int i;

  resource1[0] = kthread_id();
  for(i = 1 ;i < 20; i++){
     310:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     314:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     318:	7e c9                	jle    2e3 <unsafeThread+0x19>
    sleep(i % 2);   // make some more troubles
    resource1[i] = resource1[i-1];
  }
  sleep(kthread_id());   // make some more troubles
     31a:	e8 7b 1d 00 00       	call   209a <kthread_id>
     31f:	89 04 24             	mov    %eax,(%esp)
     322:	e8 5b 1d 00 00       	call   2082 <sleep>
  //ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id()) fail", i);

  resource2 = resource2 + resource1[i-1];
     327:	8b 45 f4             	mov    -0xc(%ebp),%eax
     32a:	83 e8 01             	sub    $0x1,%eax
     32d:	8b 14 85 80 31 00 00 	mov    0x3180(,%eax,4),%edx
     334:	a1 64 31 00 00       	mov    0x3164,%eax
     339:	01 d0                	add    %edx,%eax
     33b:	a3 64 31 00 00       	mov    %eax,0x3164

  kthread_exit();
     340:	e8 5d 1d 00 00       	call   20a2 <kthread_exit>
  return 0;
     345:	b8 00 00 00 00       	mov    $0x0,%eax
}
     34a:	c9                   	leave  
     34b:	c3                   	ret    

0000034c <loopThread>:

void* loopThread(){
     34c:	55                   	push   %ebp
     34d:	89 e5                	mov    %esp,%ebp
  for(;;){};
     34f:	eb fe                	jmp    34f <loopThread+0x3>

00000351 <stressTest1>:
  return 0;
}

void stressTest1(int count){
     351:	55                   	push   %ebp
     352:	89 e5                	mov    %esp,%ebp
     354:	56                   	push   %esi
     355:	53                   	push   %ebx
     356:	83 ec 30             	sub    $0x30,%esp
     359:	89 e0                	mov    %esp,%eax
     35b:	89 c3                	mov    %eax,%ebx
  int tid[count];
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8d 50 ff             	lea    -0x1(%eax),%edx
     363:	89 55 ec             	mov    %edx,-0x14(%ebp)
     366:	c1 e0 02             	shl    $0x2,%eax
     369:	8d 50 03             	lea    0x3(%eax),%edx
     36c:	b8 10 00 00 00       	mov    $0x10,%eax
     371:	83 e8 01             	sub    $0x1,%eax
     374:	01 d0                	add    %edx,%eax
     376:	be 10 00 00 00       	mov    $0x10,%esi
     37b:	ba 00 00 00 00       	mov    $0x0,%edx
     380:	f7 f6                	div    %esi
     382:	6b c0 10             	imul   $0x10,%eax,%eax
     385:	29 c4                	sub    %eax,%esp
     387:	8d 44 24 10          	lea    0x10(%esp),%eax
     38b:	83 c0 03             	add    $0x3,%eax
     38e:	c1 e8 02             	shr    $0x2,%eax
     391:	c1 e0 02             	shl    $0x2,%eax
     394:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int i,ans;
  int c=0;
     397:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);
     39e:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     3a5:	00 
     3a6:	c7 44 24 04 c4 28 00 	movl   $0x28c4,0x4(%esp)
     3ad:	00 
     3ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3b5:	e8 00 1e 00 00       	call   21ba <printf>

  for (i = 0 ; i < 20; i++)
     3ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c1:	eb 12                	jmp    3d5 <stressTest1+0x84>
    resource1[i] = 0;
     3c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3c6:	c7 04 85 80 31 00 00 	movl   $0x0,0x3180(,%eax,4)
     3cd:	00 00 00 00 
  int c=0;
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);

  for (i = 0 ; i < 20; i++)
     3d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3d5:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     3d9:	7e e8                	jle    3c3 <stressTest1+0x72>
    resource1[i] = 0;
  resource2 = 0;
     3db:	c7 05 64 31 00 00 00 	movl   $0x0,0x3164
     3e2:	00 00 00 
  mutex1 = kthread_mutex_alloc();
     3e5:	e8 c8 1c 00 00       	call   20b2 <kthread_mutex_alloc>
     3ea:	a3 d0 31 00 00       	mov    %eax,0x31d0
  mutex2 = kthread_mutex_alloc();
     3ef:	e8 be 1c 00 00       	call   20b2 <kthread_mutex_alloc>
     3f4:	a3 60 31 00 00       	mov    %eax,0x3160
  ASSERT((mutex1 == mutex2), "(mutex1 == mutex2)");
     3f9:	8b 15 d0 31 00 00    	mov    0x31d0,%edx
     3ff:	a1 60 31 00 00       	mov    0x3160,%eax
     404:	39 c2                	cmp    %eax,%edx
     406:	75 51                	jne    459 <stressTest1+0x108>
     408:	c7 44 24 0c b4 00 00 	movl   $0xb4,0xc(%esp)
     40f:	00 
     410:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     417:	00 
     418:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     41f:	00 
     420:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     427:	e8 8e 1d 00 00       	call   21ba <printf>
     42c:	c7 44 24 04 d6 28 00 	movl   $0x28d6,0x4(%esp)
     433:	00 
     434:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     43b:	e8 7a 1d 00 00       	call   21ba <printf>
     440:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     447:	00 
     448:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     44f:	e8 66 1d 00 00       	call   21ba <printf>
     454:	e8 99 1b 00 00       	call   1ff2 <exit>

  for (i = 0 ; i < count; i++){
     459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     460:	e9 d0 00 00 00       	jmp    535 <stressTest1+0x1e4>
    stack = malloc(STACK_SIZE);
     465:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     46c:	e8 35 20 00 00       	call   24a6 <malloc>
     471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    tid[i] = kthread_create(&safeThread, stack+STACK_SIZE, STACK_SIZE);
     474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     477:	05 e8 03 00 00       	add    $0x3e8,%eax
     47c:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     483:	00 
     484:	89 44 24 04          	mov    %eax,0x4(%esp)
     488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     48f:	e8 fe 1b 00 00       	call   2092 <kthread_create>
     494:	8b 55 e8             	mov    -0x18(%ebp),%edx
     497:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     49a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     49d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     4a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4a3:	8b 04 90             	mov    (%eax,%edx,4),%eax
     4a6:	85 c0                	test   %eax,%eax
     4a8:	7f 65                	jg     50f <stressTest1+0x1be>
     4aa:	c7 44 24 0c b9 00 00 	movl   $0xb9,0xc(%esp)
     4b1:	00 
     4b2:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     4b9:	00 
     4ba:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     4c1:	00 
     4c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4c9:	e8 ec 1c 00 00       	call   21ba <printf>
     4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
     4d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d4:	8b 04 90             	mov    (%eax,%edx,4),%eax
     4d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4da:	89 54 24 0c          	mov    %edx,0xc(%esp)
     4de:	89 44 24 08          	mov    %eax,0x8(%esp)
     4e2:	c7 44 24 04 ec 28 00 	movl   $0x28ec,0x4(%esp)
     4e9:	00 
     4ea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4f1:	e8 c4 1c 00 00       	call   21ba <printf>
     4f6:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     4fd:	00 
     4fe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     505:	e8 b0 1c 00 00       	call   21ba <printf>
     50a:	e8 e3 1a 00 00       	call   1ff2 <exit>
    c += tid[i];
     50f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     512:	8b 55 f4             	mov    -0xc(%ebp),%edx
     515:	8b 04 90             	mov    (%eax,%edx,4),%eax
     518:	01 45 f0             	add    %eax,-0x10(%ebp)
    sleep(i % 2);   // make some more troubles
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	99                   	cltd   
     51f:	c1 ea 1f             	shr    $0x1f,%edx
     522:	01 d0                	add    %edx,%eax
     524:	83 e0 01             	and    $0x1,%eax
     527:	29 d0                	sub    %edx,%eax
     529:	89 04 24             	mov    %eax,(%esp)
     52c:	e8 51 1b 00 00       	call   2082 <sleep>
  resource2 = 0;
  mutex1 = kthread_mutex_alloc();
  mutex2 = kthread_mutex_alloc();
  ASSERT((mutex1 == mutex2), "(mutex1 == mutex2)");

  for (i = 0 ; i < count; i++){
     531:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     535:	8b 45 f4             	mov    -0xc(%ebp),%eax
     538:	3b 45 08             	cmp    0x8(%ebp),%eax
     53b:	0f 8c 24 ff ff ff    	jl     465 <stressTest1+0x114>
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
    c += tid[i];
    sleep(i % 2);   // make some more troubles
  }

  for (i = 0 ; i < count; i++){
     541:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     548:	e9 83 00 00 00       	jmp    5d0 <stressTest1+0x27f>
    ans = kthread_join(tid[i]);
     54d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     550:	8b 55 f4             	mov    -0xc(%ebp),%edx
     553:	8b 04 90             	mov    (%eax,%edx,4),%eax
     556:	89 04 24             	mov    %eax,(%esp)
     559:	e8 4c 1b 00 00       	call   20aa <kthread_join>
     55e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
     561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     565:	74 65                	je     5cc <stressTest1+0x27b>
     567:	c7 44 24 0c c1 00 00 	movl   $0xc1,0xc(%esp)
     56e:	00 
     56f:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     576:	00 
     577:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     57e:	00 
     57f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     586:	e8 2f 1c 00 00       	call   21ba <printf>
     58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     58e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     591:	8b 04 90             	mov    (%eax,%edx,4),%eax
     594:	8b 55 e0             	mov    -0x20(%ebp),%edx
     597:	89 54 24 0c          	mov    %edx,0xc(%esp)
     59b:	89 44 24 08          	mov    %eax,0x8(%esp)
     59f:	c7 44 24 04 1c 29 00 	movl   $0x291c,0x4(%esp)
     5a6:	00 
     5a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5ae:	e8 07 1c 00 00       	call   21ba <printf>
     5b3:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     5ba:	00 
     5bb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5c2:	e8 f3 1b 00 00       	call   21ba <printf>
     5c7:	e8 26 1a 00 00       	call   1ff2 <exit>
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
    c += tid[i];
    sleep(i % 2);   // make some more troubles
  }

  for (i = 0 ; i < count; i++){
     5cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d3:	3b 45 08             	cmp    0x8(%ebp),%eax
     5d6:	0f 8c 71 ff ff ff    	jl     54d <stressTest1+0x1fc>
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
  }

  // free the mutexes
  ASSERT( (kthread_mutex_dealloc(mutex1) != 0), "dealloc");
     5dc:	a1 d0 31 00 00       	mov    0x31d0,%eax
     5e1:	89 04 24             	mov    %eax,(%esp)
     5e4:	e8 d1 1a 00 00       	call   20ba <kthread_mutex_dealloc>
     5e9:	85 c0                	test   %eax,%eax
     5eb:	74 51                	je     63e <stressTest1+0x2ed>
     5ed:	c7 44 24 0c c5 00 00 	movl   $0xc5,0xc(%esp)
     5f4:	00 
     5f5:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     5fc:	00 
     5fd:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     604:	00 
     605:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     60c:	e8 a9 1b 00 00       	call   21ba <printf>
     611:	c7 44 24 04 3d 29 00 	movl   $0x293d,0x4(%esp)
     618:	00 
     619:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     620:	e8 95 1b 00 00       	call   21ba <printf>
     625:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     62c:	00 
     62d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     634:	e8 81 1b 00 00       	call   21ba <printf>
     639:	e8 b4 19 00 00       	call   1ff2 <exit>
  ASSERT( (kthread_mutex_dealloc(mutex2) != 0), "dealloc");
     63e:	a1 60 31 00 00       	mov    0x3160,%eax
     643:	89 04 24             	mov    %eax,(%esp)
     646:	e8 6f 1a 00 00       	call   20ba <kthread_mutex_dealloc>
     64b:	85 c0                	test   %eax,%eax
     64d:	74 51                	je     6a0 <stressTest1+0x34f>
     64f:	c7 44 24 0c c6 00 00 	movl   $0xc6,0xc(%esp)
     656:	00 
     657:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     65e:	00 
     65f:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     666:	00 
     667:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     66e:	e8 47 1b 00 00       	call   21ba <printf>
     673:	c7 44 24 04 3d 29 00 	movl   $0x293d,0x4(%esp)
     67a:	00 
     67b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     682:	e8 33 1b 00 00       	call   21ba <printf>
     687:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     68e:	00 
     68f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     696:	e8 1f 1b 00 00       	call   21ba <printf>
     69b:	e8 52 19 00 00       	call   1ff2 <exit>

  ASSERT((c != resource2), "(c != resource2) : (%d != %d)" , c, resource2);
     6a0:	a1 64 31 00 00       	mov    0x3164,%eax
     6a5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     6a8:	74 61                	je     70b <stressTest1+0x3ba>
     6aa:	c7 44 24 0c c8 00 00 	movl   $0xc8,0xc(%esp)
     6b1:	00 
     6b2:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     6b9:	00 
     6ba:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     6c1:	00 
     6c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6c9:	e8 ec 1a 00 00       	call   21ba <printf>
     6ce:	a1 64 31 00 00       	mov    0x3164,%eax
     6d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     6d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6da:	89 44 24 08          	mov    %eax,0x8(%esp)
     6de:	c7 44 24 04 45 29 00 	movl   $0x2945,0x4(%esp)
     6e5:	00 
     6e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6ed:	e8 c8 1a 00 00       	call   21ba <printf>
     6f2:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     6f9:	00 
     6fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     701:	e8 b4 1a 00 00       	call   21ba <printf>
     706:	e8 e7 18 00 00       	call   1ff2 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
     70b:	c7 44 24 08 04 2c 00 	movl   $0x2c04,0x8(%esp)
     712:	00 
     713:	c7 44 24 04 63 29 00 	movl   $0x2963,0x4(%esp)
     71a:	00 
     71b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     722:	e8 93 1a 00 00       	call   21ba <printf>
     727:	89 dc                	mov    %ebx,%esp

}
     729:	8d 65 f8             	lea    -0x8(%ebp),%esp
     72c:	5b                   	pop    %ebx
     72d:	5e                   	pop    %esi
     72e:	5d                   	pop    %ebp
     72f:	c3                   	ret    

00000730 <stressTest2Fail>:

/* this test should fail most of the time because synchronization error */
void stressTest2Fail(int count){
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
     733:	56                   	push   %esi
     734:	53                   	push   %ebx
     735:	83 ec 30             	sub    $0x30,%esp
     738:	89 e0                	mov    %esp,%eax
     73a:	89 c3                	mov    %eax,%ebx
  int tid[count];
     73c:	8b 45 08             	mov    0x8(%ebp),%eax
     73f:	8d 50 ff             	lea    -0x1(%eax),%edx
     742:	89 55 ec             	mov    %edx,-0x14(%ebp)
     745:	c1 e0 02             	shl    $0x2,%eax
     748:	8d 50 03             	lea    0x3(%eax),%edx
     74b:	b8 10 00 00 00       	mov    $0x10,%eax
     750:	83 e8 01             	sub    $0x1,%eax
     753:	01 d0                	add    %edx,%eax
     755:	be 10 00 00 00       	mov    $0x10,%esi
     75a:	ba 00 00 00 00       	mov    $0x0,%edx
     75f:	f7 f6                	div    %esi
     761:	6b c0 10             	imul   $0x10,%eax,%eax
     764:	29 c4                	sub    %eax,%esp
     766:	8d 44 24 10          	lea    0x10(%esp),%eax
     76a:	83 c0 03             	add    $0x3,%eax
     76d:	c1 e8 02             	shr    $0x2,%eax
     770:	c1 e0 02             	shl    $0x2,%eax
     773:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int i,ans;
  int c=0;
     776:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);
     77d:	c7 44 24 08 10 2c 00 	movl   $0x2c10,0x8(%esp)
     784:	00 
     785:	c7 44 24 04 c4 28 00 	movl   $0x28c4,0x4(%esp)
     78c:	00 
     78d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     794:	e8 21 1a 00 00       	call   21ba <printf>

  for (i = 0 ; i < 20; i++)
     799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7a0:	eb 12                	jmp    7b4 <stressTest2Fail+0x84>
    resource1[i] = 0;
     7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a5:	c7 04 85 80 31 00 00 	movl   $0x0,0x3180(,%eax,4)
     7ac:	00 00 00 00 
  int c=0;
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);

  for (i = 0 ; i < 20; i++)
     7b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7b4:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     7b8:	7e e8                	jle    7a2 <stressTest2Fail+0x72>
    resource1[i] = 0;
  resource2 = 0;
     7ba:	c7 05 64 31 00 00 00 	movl   $0x0,0x3164
     7c1:	00 00 00 

  for (i = 0 ; i < count; i++){
     7c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7cb:	e9 df 00 00 00       	jmp    8af <stressTest2Fail+0x17f>
    stack = malloc(STACK_SIZE);
     7d0:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     7d7:	e8 ca 1c 00 00       	call   24a6 <malloc>
     7dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    tid[i] = kthread_create(&unsafeThread, stack+STACK_SIZE, STACK_SIZE);
     7df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7e2:	05 e8 03 00 00       	add    $0x3e8,%eax
     7e7:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     7ee:	00 
     7ef:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f3:	c7 04 24 ca 02 00 00 	movl   $0x2ca,(%esp)
     7fa:	e8 93 18 00 00       	call   2092 <kthread_create>
     7ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
     802:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     805:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    sleep(i %3);   // make some more troubles
     808:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     80b:	ba 56 55 55 55       	mov    $0x55555556,%edx
     810:	89 c8                	mov    %ecx,%eax
     812:	f7 ea                	imul   %edx
     814:	89 c8                	mov    %ecx,%eax
     816:	c1 f8 1f             	sar    $0x1f,%eax
     819:	29 c2                	sub    %eax,%edx
     81b:	89 d0                	mov    %edx,%eax
     81d:	01 c0                	add    %eax,%eax
     81f:	01 d0                	add    %edx,%eax
     821:	29 c1                	sub    %eax,%ecx
     823:	89 ca                	mov    %ecx,%edx
     825:	89 14 24             	mov    %edx,(%esp)
     828:	e8 55 18 00 00       	call   2082 <sleep>
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     830:	8b 55 f4             	mov    -0xc(%ebp),%edx
     833:	8b 04 90             	mov    (%eax,%edx,4),%eax
     836:	85 c0                	test   %eax,%eax
     838:	7f 65                	jg     89f <stressTest2Fail+0x16f>
     83a:	c7 44 24 0c df 00 00 	movl   $0xdf,0xc(%esp)
     841:	00 
     842:	c7 44 24 08 10 2c 00 	movl   $0x2c10,0x8(%esp)
     849:	00 
     84a:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     851:	00 
     852:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     859:	e8 5c 19 00 00       	call   21ba <printf>
     85e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     861:	8b 55 f4             	mov    -0xc(%ebp),%edx
     864:	8b 04 90             	mov    (%eax,%edx,4),%eax
     867:	8b 55 f4             	mov    -0xc(%ebp),%edx
     86a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     86e:	89 44 24 08          	mov    %eax,0x8(%esp)
     872:	c7 44 24 04 ec 28 00 	movl   $0x28ec,0x4(%esp)
     879:	00 
     87a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     881:	e8 34 19 00 00       	call   21ba <printf>
     886:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     88d:	00 
     88e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     895:	e8 20 19 00 00       	call   21ba <printf>
     89a:	e8 53 17 00 00       	call   1ff2 <exit>
    c += tid[i];
     89f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8a5:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8a8:	01 45 f0             	add    %eax,-0x10(%ebp)

  for (i = 0 ; i < 20; i++)
    resource1[i] = 0;
  resource2 = 0;

  for (i = 0 ; i < count; i++){
     8ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b2:	3b 45 08             	cmp    0x8(%ebp),%eax
     8b5:	0f 8c 15 ff ff ff    	jl     7d0 <stressTest2Fail+0xa0>
    sleep(i %3);   // make some more troubles
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
    c += tid[i];
  }

  for (i = 0 ; i < count; i++){
     8bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8c2:	e9 83 00 00 00       	jmp    94a <stressTest2Fail+0x21a>
    ans = kthread_join(tid[i]);
     8c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8cd:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8d0:	89 04 24             	mov    %eax,(%esp)
     8d3:	e8 d2 17 00 00       	call   20aa <kthread_join>
     8d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
     8db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     8df:	74 65                	je     946 <stressTest2Fail+0x216>
     8e1:	c7 44 24 0c e6 00 00 	movl   $0xe6,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 10 2c 00 	movl   $0x2c10,0x8(%esp)
     8f0:	00 
     8f1:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     8f8:	00 
     8f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     900:	e8 b5 18 00 00       	call   21ba <printf>
     905:	8b 45 e8             	mov    -0x18(%ebp),%eax
     908:	8b 55 f4             	mov    -0xc(%ebp),%edx
     90b:	8b 04 90             	mov    (%eax,%edx,4),%eax
     90e:	8b 55 e0             	mov    -0x20(%ebp),%edx
     911:	89 54 24 0c          	mov    %edx,0xc(%esp)
     915:	89 44 24 08          	mov    %eax,0x8(%esp)
     919:	c7 44 24 04 1c 29 00 	movl   $0x291c,0x4(%esp)
     920:	00 
     921:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     928:	e8 8d 18 00 00       	call   21ba <printf>
     92d:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     934:	00 
     935:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     93c:	e8 79 18 00 00       	call   21ba <printf>
     941:	e8 ac 16 00 00       	call   1ff2 <exit>
    sleep(i %3);   // make some more troubles
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
    c += tid[i];
  }

  for (i = 0 ; i < count; i++){
     946:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94d:	3b 45 08             	cmp    0x8(%ebp),%eax
     950:	0f 8c 71 ff ff ff    	jl     8c7 <stressTest2Fail+0x197>
    ans = kthread_join(tid[i]);
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
  }

  ASSERT((c == resource2), "(c == resource2) : (%d != %d), we expect to fail here!!" , c, resource2);
     956:	a1 64 31 00 00       	mov    0x3164,%eax
     95b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     95e:	75 61                	jne    9c1 <stressTest2Fail+0x291>
     960:	c7 44 24 0c e9 00 00 	movl   $0xe9,0xc(%esp)
     967:	00 
     968:	c7 44 24 08 10 2c 00 	movl   $0x2c10,0x8(%esp)
     96f:	00 
     970:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     977:	00 
     978:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     97f:	e8 36 18 00 00       	call   21ba <printf>
     984:	a1 64 31 00 00       	mov    0x3164,%eax
     989:	89 44 24 0c          	mov    %eax,0xc(%esp)
     98d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     990:	89 44 24 08          	mov    %eax,0x8(%esp)
     994:	c7 44 24 04 74 29 00 	movl   $0x2974,0x4(%esp)
     99b:	00 
     99c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9a3:	e8 12 18 00 00       	call   21ba <printf>
     9a8:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     9af:	00 
     9b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9b7:	e8 fe 17 00 00       	call   21ba <printf>
     9bc:	e8 31 16 00 00       	call   1ff2 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
     9c1:	c7 44 24 08 10 2c 00 	movl   $0x2c10,0x8(%esp)
     9c8:	00 
     9c9:	c7 44 24 04 63 29 00 	movl   $0x2963,0x4(%esp)
     9d0:	00 
     9d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9d8:	e8 dd 17 00 00       	call   21ba <printf>
     9dd:	89 dc                	mov    %ebx,%esp

}
     9df:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9e2:	5b                   	pop    %ebx
     9e3:	5e                   	pop    %esi
     9e4:	5d                   	pop    %ebp
     9e5:	c3                   	ret    

000009e6 <stressTest3toMuchTreads>:

/* this test check that we can't create more then 16(count) threads  */
void stressTest3toMuchTreads(int count){
     9e6:	55                   	push   %ebp
     9e7:	89 e5                	mov    %esp,%ebp
     9e9:	53                   	push   %ebx
     9ea:	83 ec 24             	sub    $0x24,%esp
  int tid[count*2];
     9ed:	8b 45 08             	mov    0x8(%ebp),%eax
     9f0:	01 c0                	add    %eax,%eax
     9f2:	8d 50 ff             	lea    -0x1(%eax),%edx
     9f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
     9f8:	c1 e0 02             	shl    $0x2,%eax
     9fb:	8d 50 03             	lea    0x3(%eax),%edx
     9fe:	b8 10 00 00 00       	mov    $0x10,%eax
     a03:	83 e8 01             	sub    $0x1,%eax
     a06:	01 d0                	add    %edx,%eax
     a08:	bb 10 00 00 00       	mov    $0x10,%ebx
     a0d:	ba 00 00 00 00       	mov    $0x0,%edx
     a12:	f7 f3                	div    %ebx
     a14:	6b c0 10             	imul   $0x10,%eax,%eax
     a17:	29 c4                	sub    %eax,%esp
     a19:	8d 44 24 10          	lea    0x10(%esp),%eax
     a1d:	83 c0 03             	add    $0x3,%eax
     a20:	c1 e8 02             	shr    $0x2,%eax
     a23:	c1 e0 02             	shl    $0x2,%eax
     a26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int i;
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);
     a29:	c7 44 24 08 20 2c 00 	movl   $0x2c20,0x8(%esp)
     a30:	00 
     a31:	c7 44 24 04 c4 28 00 	movl   $0x28c4,0x4(%esp)
     a38:	00 
     a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a40:	e8 75 17 00 00       	call   21ba <printf>

  for (i = 0 ; i < count; i++){
     a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a4c:	e9 ae 00 00 00       	jmp    aff <stressTest3toMuchTreads+0x119>
    stack = malloc(STACK_SIZE);
     a51:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     a58:	e8 49 1a 00 00       	call   24a6 <malloc>
     a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    tid[i] = kthread_create(&loopThread, stack+STACK_SIZE, STACK_SIZE);
     a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a63:	05 e8 03 00 00       	add    $0x3e8,%eax
     a68:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     a6f:	00 
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	c7 04 24 4c 03 00 00 	movl   $0x34c,(%esp)
     a7b:	e8 12 16 00 00       	call   2092 <kthread_create>
     a80:	8b 55 e8             	mov    -0x18(%ebp),%edx
     a83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a86:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a8f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a92:	85 c0                	test   %eax,%eax
     a94:	7f 65                	jg     afb <stressTest3toMuchTreads+0x115>
     a96:	c7 44 24 0c fa 00 00 	movl   $0xfa,0xc(%esp)
     a9d:	00 
     a9e:	c7 44 24 08 20 2c 00 	movl   $0x2c20,0x8(%esp)
     aa5:	00 
     aa6:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     aad:	00 
     aae:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ab5:	e8 00 17 00 00       	call   21ba <printf>
     aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
     abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac0:	8b 04 90             	mov    (%eax,%edx,4),%eax
     ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac6:	89 54 24 0c          	mov    %edx,0xc(%esp)
     aca:	89 44 24 08          	mov    %eax,0x8(%esp)
     ace:	c7 44 24 04 ec 28 00 	movl   $0x28ec,0x4(%esp)
     ad5:	00 
     ad6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     add:	e8 d8 16 00 00       	call   21ba <printf>
     ae2:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     ae9:	00 
     aea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     af1:	e8 c4 16 00 00       	call   21ba <printf>
     af6:	e8 f7 14 00 00       	call   1ff2 <exit>
  int i;
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);

  for (i = 0 ; i < count; i++){
     afb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b02:	3b 45 08             	cmp    0x8(%ebp),%eax
     b05:	0f 8c 46 ff ff ff    	jl     a51 <stressTest3toMuchTreads+0x6b>
    stack = malloc(STACK_SIZE);
    tid[i] = kthread_create(&loopThread, stack+STACK_SIZE, STACK_SIZE);
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
  }

  if(kthread_create(&loopThread, stack+STACK_SIZE, STACK_SIZE) >= 0){
     b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b0e:	05 e8 03 00 00       	add    $0x3e8,%eax
     b13:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     b1a:	00 
     b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
     b1f:	c7 04 24 4c 03 00 00 	movl   $0x34c,(%esp)
     b26:	e8 67 15 00 00       	call   2092 <kthread_create>
     b2b:	85 c0                	test   %eax,%eax
     b2d:	78 1e                	js     b4d <stressTest3toMuchTreads+0x167>
    printf(1, "%s test FAIL!\n", __FUNCTION__);
     b2f:	c7 44 24 08 20 2c 00 	movl   $0x2c20,0x8(%esp)
     b36:	00 
     b37:	c7 44 24 04 ac 29 00 	movl   $0x29ac,0x4(%esp)
     b3e:	00 
     b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b46:	e8 6f 16 00 00       	call   21ba <printf>
     b4b:	eb 1c                	jmp    b69 <stressTest3toMuchTreads+0x183>
  } else {
    printf(1, "%s test PASS!\n", __FUNCTION__);
     b4d:	c7 44 24 08 20 2c 00 	movl   $0x2c20,0x8(%esp)
     b54:	00 
     b55:	c7 44 24 04 63 29 00 	movl   $0x2963,0x4(%esp)
     b5c:	00 
     b5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b64:	e8 51 16 00 00       	call   21ba <printf>
  }

  // the threads do not kill themself
  exit();
     b69:	e8 84 14 00 00       	call   1ff2 <exit>

00000b6e <yieldThread>:

}

void* yieldThread(){
     b6e:	55                   	push   %ebp
     b6f:	89 e5                	mov    %esp,%ebp
     b71:	53                   	push   %ebx
     b72:	83 ec 24             	sub    $0x24,%esp
  int i;

  sleep(kthread_id() % 3);  // change the order of the waiters threads
     b75:	e8 20 15 00 00       	call   209a <kthread_id>
     b7a:	89 c1                	mov    %eax,%ecx
     b7c:	ba 56 55 55 55       	mov    $0x55555556,%edx
     b81:	89 c8                	mov    %ecx,%eax
     b83:	f7 ea                	imul   %edx
     b85:	89 c8                	mov    %ecx,%eax
     b87:	c1 f8 1f             	sar    $0x1f,%eax
     b8a:	29 c2                	sub    %eax,%edx
     b8c:	89 d0                	mov    %edx,%eax
     b8e:	01 c0                	add    %eax,%eax
     b90:	01 d0                	add    %edx,%eax
     b92:	29 c1                	sub    %eax,%ecx
     b94:	89 ca                	mov    %ecx,%edx
     b96:	89 14 24             	mov    %edx,(%esp)
     b99:	e8 e4 14 00 00       	call   2082 <sleep>

  /* part one use mutual array of resources */
  ASSERT((kthread_mutex_lock(mutex2) == -1), "kthread_mutex_lock(%d) fail", mutex2);
     b9e:	a1 60 31 00 00       	mov    0x3160,%eax
     ba3:	89 04 24             	mov    %eax,(%esp)
     ba6:	e8 17 15 00 00       	call   20c2 <kthread_mutex_lock>
     bab:	83 f8 ff             	cmp    $0xffffffff,%eax
     bae:	75 5a                	jne    c0a <yieldThread+0x9c>
     bb0:	c7 44 24 0c 0e 01 00 	movl   $0x10e,0xc(%esp)
     bb7:	00 
     bb8:	c7 44 24 08 38 2c 00 	movl   $0x2c38,0x8(%esp)
     bbf:	00 
     bc0:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     bc7:	00 
     bc8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     bcf:	e8 e6 15 00 00       	call   21ba <printf>
     bd4:	a1 60 31 00 00       	mov    0x3160,%eax
     bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bdd:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
     be4:	00 
     be5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     bec:	e8 c9 15 00 00       	call   21ba <printf>
     bf1:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     bf8:	00 
     bf9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c00:	e8 b5 15 00 00       	call   21ba <printf>
     c05:	e8 e8 13 00 00       	call   1ff2 <exit>

  resource1[0] = kthread_id();
     c0a:	e8 8b 14 00 00       	call   209a <kthread_id>
     c0f:	a3 80 31 00 00       	mov    %eax,0x3180
  for(i = 1 ;i < 20; i++){
     c14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     c1b:	eb 31                	jmp    c4e <yieldThread+0xe0>
    sleep(i % 2);   // make some more troubles
     c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c20:	99                   	cltd   
     c21:	c1 ea 1f             	shr    $0x1f,%edx
     c24:	01 d0                	add    %edx,%eax
     c26:	83 e0 01             	and    $0x1,%eax
     c29:	29 d0                	sub    %edx,%eax
     c2b:	89 04 24             	mov    %eax,(%esp)
     c2e:	e8 4f 14 00 00       	call   2082 <sleep>
    resource1[i] = resource1[i-1];
     c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c36:	83 e8 01             	sub    $0x1,%eax
     c39:	8b 14 85 80 31 00 00 	mov    0x3180(,%eax,4),%edx
     c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c43:	89 14 85 80 31 00 00 	mov    %edx,0x3180(,%eax,4)

  /* part one use mutual array of resources */
  ASSERT((kthread_mutex_lock(mutex2) == -1), "kthread_mutex_lock(%d) fail", mutex2);

  resource1[0] = kthread_id();
  for(i = 1 ;i < 20; i++){
     c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c4e:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     c52:	7e c9                	jle    c1d <yieldThread+0xaf>
    sleep(i % 2);   // make some more troubles
    resource1[i] = resource1[i-1];
  }
  sleep(kthread_id() % 2);   // make some more troubles
     c54:	e8 41 14 00 00       	call   209a <kthread_id>
     c59:	99                   	cltd   
     c5a:	c1 ea 1f             	shr    $0x1f,%edx
     c5d:	01 d0                	add    %edx,%eax
     c5f:	83 e0 01             	and    $0x1,%eax
     c62:	29 d0                	sub    %edx,%eax
     c64:	89 04 24             	mov    %eax,(%esp)
     c67:	e8 16 14 00 00       	call   2082 <sleep>
  ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id:%d) fail", i, kthread_id());
     c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6f:	83 e8 01             	sub    $0x1,%eax
     c72:	8b 1c 85 80 31 00 00 	mov    0x3180(,%eax,4),%ebx
     c79:	e8 1c 14 00 00       	call   209a <kthread_id>
     c7e:	39 c3                	cmp    %eax,%ebx
     c80:	74 61                	je     ce3 <yieldThread+0x175>
     c82:	c7 44 24 0c 16 01 00 	movl   $0x116,0xc(%esp)
     c89:	00 
     c8a:	c7 44 24 08 38 2c 00 	movl   $0x2c38,0x8(%esp)
     c91:	00 
     c92:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     c99:	00 
     c9a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ca1:	e8 14 15 00 00       	call   21ba <printf>
     ca6:	e8 ef 13 00 00       	call   209a <kthread_id>
     cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
     caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
     cb6:	c7 44 24 04 80 28 00 	movl   $0x2880,0x4(%esp)
     cbd:	00 
     cbe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     cc5:	e8 f0 14 00 00       	call   21ba <printf>
     cca:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     cd1:	00 
     cd2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     cd9:	e8 dc 14 00 00       	call   21ba <printf>
     cde:	e8 0f 13 00 00       	call   1ff2 <exit>

  /* part two - mutual calculation */
  sleep(kthread_id() % 2);   // make some more troubles
     ce3:	e8 b2 13 00 00       	call   209a <kthread_id>
     ce8:	99                   	cltd   
     ce9:	c1 ea 1f             	shr    $0x1f,%edx
     cec:	01 d0                	add    %edx,%eax
     cee:	83 e0 01             	and    $0x1,%eax
     cf1:	29 d0                	sub    %edx,%eax
     cf3:	89 04 24             	mov    %eax,(%esp)
     cf6:	e8 87 13 00 00       	call   2082 <sleep>
  resource2 = resource2 + kthread_id();
     cfb:	e8 9a 13 00 00       	call   209a <kthread_id>
     d00:	8b 15 64 31 00 00    	mov    0x3164,%edx
     d06:	01 d0                	add    %edx,%eax
     d08:	a3 64 31 00 00       	mov    %eax,0x3164

  // pass the mutex to the next thread
  ASSERT((kthread_mutex_yieldlock(mutex1, mutex2) != 0), "mutex yield");
     d0d:	8b 15 60 31 00 00    	mov    0x3160,%edx
     d13:	a1 d0 31 00 00       	mov    0x31d0,%eax
     d18:	89 54 24 04          	mov    %edx,0x4(%esp)
     d1c:	89 04 24             	mov    %eax,(%esp)
     d1f:	e8 ae 13 00 00       	call   20d2 <kthread_mutex_yieldlock>
     d24:	85 c0                	test   %eax,%eax
     d26:	74 51                	je     d79 <yieldThread+0x20b>
     d28:	c7 44 24 0c 1d 01 00 	movl   $0x11d,0xc(%esp)
     d2f:	00 
     d30:	c7 44 24 08 38 2c 00 	movl   $0x2c38,0x8(%esp)
     d37:	00 
     d38:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     d3f:	00 
     d40:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d47:	e8 6e 14 00 00       	call   21ba <printf>
     d4c:	c7 44 24 04 bb 29 00 	movl   $0x29bb,0x4(%esp)
     d53:	00 
     d54:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d5b:	e8 5a 14 00 00       	call   21ba <printf>
     d60:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     d67:	00 
     d68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d6f:	e8 46 14 00 00       	call   21ba <printf>
     d74:	e8 79 12 00 00       	call   1ff2 <exit>


  kthread_exit();
     d79:	e8 24 13 00 00       	call   20a2 <kthread_exit>
  return 0;
     d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d83:	83 c4 24             	add    $0x24,%esp
     d86:	5b                   	pop    %ebx
     d87:	5d                   	pop    %ebp
     d88:	c3                   	ret    

00000d89 <trubleThread>:

void* trubleThread(){
     d89:	55                   	push   %ebp
     d8a:	89 e5                	mov    %esp,%ebp
     d8c:	83 ec 18             	sub    $0x18,%esp

  ASSERT((kthread_mutex_lock(mutex1) == -1), "kthread_mutex_lock(%d) fail", mutex1);
     d8f:	a1 d0 31 00 00       	mov    0x31d0,%eax
     d94:	89 04 24             	mov    %eax,(%esp)
     d97:	e8 26 13 00 00       	call   20c2 <kthread_mutex_lock>
     d9c:	83 f8 ff             	cmp    $0xffffffff,%eax
     d9f:	75 5a                	jne    dfb <trubleThread+0x72>
     da1:	c7 44 24 0c 26 01 00 	movl   $0x126,0xc(%esp)
     da8:	00 
     da9:	c7 44 24 08 44 2c 00 	movl   $0x2c44,0x8(%esp)
     db0:	00 
     db1:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     db8:	00 
     db9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     dc0:	e8 f5 13 00 00       	call   21ba <printf>
     dc5:	a1 d0 31 00 00       	mov    0x31d0,%eax
     dca:	89 44 24 08          	mov    %eax,0x8(%esp)
     dce:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
     dd5:	00 
     dd6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ddd:	e8 d8 13 00 00       	call   21ba <printf>
     de2:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     de9:	00 
     dea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     df1:	e8 c4 13 00 00       	call   21ba <printf>
     df6:	e8 f7 11 00 00       	call   1ff2 <exit>
  resource2 = -10;
     dfb:	c7 05 64 31 00 00 f6 	movl   $0xfffffff6,0x3164
     e02:	ff ff ff 

  ASSERT((kthread_mutex_unlock(mutex1) == -1), "kthread_mutex_unlock(%d) fail", mutex1);
     e05:	a1 d0 31 00 00       	mov    0x31d0,%eax
     e0a:	89 04 24             	mov    %eax,(%esp)
     e0d:	e8 b8 12 00 00       	call   20ca <kthread_mutex_unlock>
     e12:	83 f8 ff             	cmp    $0xffffffff,%eax
     e15:	75 5a                	jne    e71 <trubleThread+0xe8>
     e17:	c7 44 24 0c 29 01 00 	movl   $0x129,0xc(%esp)
     e1e:	00 
     e1f:	c7 44 24 08 44 2c 00 	movl   $0x2c44,0x8(%esp)
     e26:	00 
     e27:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     e2e:	00 
     e2f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e36:	e8 7f 13 00 00       	call   21ba <printf>
     e3b:	a1 d0 31 00 00       	mov    0x31d0,%eax
     e40:	89 44 24 08          	mov    %eax,0x8(%esp)
     e44:	c7 44 24 04 a6 28 00 	movl   $0x28a6,0x4(%esp)
     e4b:	00 
     e4c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e53:	e8 62 13 00 00       	call   21ba <printf>
     e58:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     e5f:	00 
     e60:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e67:	e8 4e 13 00 00       	call   21ba <printf>
     e6c:	e8 81 11 00 00       	call   1ff2 <exit>

  kthread_exit();
     e71:	e8 2c 12 00 00       	call   20a2 <kthread_exit>
  return 0;
     e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e7b:	c9                   	leave  
     e7c:	c3                   	ret    

00000e7d <mutexYieldTest>:

void mutexYieldTest(){
     e7d:	55                   	push   %ebp
     e7e:	89 e5                	mov    %esp,%ebp
     e80:	83 ec 58             	sub    $0x58,%esp
  int tid[10], ttid =0;
     e83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int i,ans;
  int c=0;
     e8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);
     e91:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
     e98:	00 
     e99:	c7 44 24 04 c4 28 00 	movl   $0x28c4,0x4(%esp)
     ea0:	00 
     ea1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ea8:	e8 0d 13 00 00       	call   21ba <printf>

  for (i = 0 ; i < 20; i++)
     ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb4:	eb 12                	jmp    ec8 <mutexYieldTest+0x4b>
    resource1[i] = 0;
     eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb9:	c7 04 85 80 31 00 00 	movl   $0x0,0x3180(,%eax,4)
     ec0:	00 00 00 00 
  int c=0;
  char* stack;

  printf(1, "starting %s test\n", __FUNCTION__);

  for (i = 0 ; i < 20; i++)
     ec4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ec8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     ecc:	7e e8                	jle    eb6 <mutexYieldTest+0x39>
    resource1[i] = 0;
  resource2 = 0;
     ece:	c7 05 64 31 00 00 00 	movl   $0x0,0x3164
     ed5:	00 00 00 
  mutex1 = kthread_mutex_alloc();
     ed8:	e8 d5 11 00 00       	call   20b2 <kthread_mutex_alloc>
     edd:	a3 d0 31 00 00       	mov    %eax,0x31d0
  mutex2 = kthread_mutex_alloc();
     ee2:	e8 cb 11 00 00       	call   20b2 <kthread_mutex_alloc>
     ee7:	a3 60 31 00 00       	mov    %eax,0x3160
  ASSERT((mutex1 < 0), "(mutex1 < 0)");
     eec:	a1 d0 31 00 00       	mov    0x31d0,%eax
     ef1:	85 c0                	test   %eax,%eax
     ef3:	79 51                	jns    f46 <mutexYieldTest+0xc9>
     ef5:	c7 44 24 0c 3c 01 00 	movl   $0x13c,0xc(%esp)
     efc:	00 
     efd:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
     f04:	00 
     f05:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     f0c:	00 
     f0d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f14:	e8 a1 12 00 00       	call   21ba <printf>
     f19:	c7 44 24 04 c7 29 00 	movl   $0x29c7,0x4(%esp)
     f20:	00 
     f21:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f28:	e8 8d 12 00 00       	call   21ba <printf>
     f2d:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     f34:	00 
     f35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f3c:	e8 79 12 00 00       	call   21ba <printf>
     f41:	e8 ac 10 00 00       	call   1ff2 <exit>
  ASSERT((mutex2 < 0), "(mutex2 < 0)");
     f46:	a1 60 31 00 00       	mov    0x3160,%eax
     f4b:	85 c0                	test   %eax,%eax
     f4d:	79 51                	jns    fa0 <mutexYieldTest+0x123>
     f4f:	c7 44 24 0c 3d 01 00 	movl   $0x13d,0xc(%esp)
     f56:	00 
     f57:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
     f5e:	00 
     f5f:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     f66:	00 
     f67:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f6e:	e8 47 12 00 00       	call   21ba <printf>
     f73:	c7 44 24 04 d4 29 00 	movl   $0x29d4,0x4(%esp)
     f7a:	00 
     f7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f82:	e8 33 12 00 00       	call   21ba <printf>
     f87:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     f8e:	00 
     f8f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f96:	e8 1f 12 00 00       	call   21ba <printf>
     f9b:	e8 52 10 00 00       	call   1ff2 <exit>
  ASSERT((mutex1 == mutex2), "(mutex1 == mutex2)");
     fa0:	8b 15 d0 31 00 00    	mov    0x31d0,%edx
     fa6:	a1 60 31 00 00       	mov    0x3160,%eax
     fab:	39 c2                	cmp    %eax,%edx
     fad:	75 51                	jne    1000 <mutexYieldTest+0x183>
     faf:	c7 44 24 0c 3e 01 00 	movl   $0x13e,0xc(%esp)
     fb6:	00 
     fb7:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
     fbe:	00 
     fbf:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
     fc6:	00 
     fc7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     fce:	e8 e7 11 00 00       	call   21ba <printf>
     fd3:	c7 44 24 04 d6 28 00 	movl   $0x28d6,0x4(%esp)
     fda:	00 
     fdb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     fe2:	e8 d3 11 00 00       	call   21ba <printf>
     fe7:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
     fee:	00 
     fef:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ff6:	e8 bf 11 00 00       	call   21ba <printf>
     ffb:	e8 f2 0f 00 00       	call   1ff2 <exit>

  ASSERT((kthread_mutex_lock(mutex1) != 0), "mutex lock");
    1000:	a1 d0 31 00 00       	mov    0x31d0,%eax
    1005:	89 04 24             	mov    %eax,(%esp)
    1008:	e8 b5 10 00 00       	call   20c2 <kthread_mutex_lock>
    100d:	85 c0                	test   %eax,%eax
    100f:	74 51                	je     1062 <mutexYieldTest+0x1e5>
    1011:	c7 44 24 0c 40 01 00 	movl   $0x140,0xc(%esp)
    1018:	00 
    1019:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    1020:	00 
    1021:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1028:	00 
    1029:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1030:	e8 85 11 00 00       	call   21ba <printf>
    1035:	c7 44 24 04 e1 29 00 	movl   $0x29e1,0x4(%esp)
    103c:	00 
    103d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1044:	e8 71 11 00 00       	call   21ba <printf>
    1049:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1058:	e8 5d 11 00 00       	call   21ba <printf>
    105d:	e8 90 0f 00 00       	call   1ff2 <exit>
  ASSERT((kthread_mutex_lock(mutex2) != 0), "mutex lock");
    1062:	a1 60 31 00 00       	mov    0x3160,%eax
    1067:	89 04 24             	mov    %eax,(%esp)
    106a:	e8 53 10 00 00       	call   20c2 <kthread_mutex_lock>
    106f:	85 c0                	test   %eax,%eax
    1071:	74 51                	je     10c4 <mutexYieldTest+0x247>
    1073:	c7 44 24 0c 41 01 00 	movl   $0x141,0xc(%esp)
    107a:	00 
    107b:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    1082:	00 
    1083:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    108a:	00 
    108b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1092:	e8 23 11 00 00       	call   21ba <printf>
    1097:	c7 44 24 04 e1 29 00 	movl   $0x29e1,0x4(%esp)
    109e:	00 
    109f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10a6:	e8 0f 11 00 00       	call   21ba <printf>
    10ab:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    10b2:	00 
    10b3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10ba:	e8 fb 10 00 00       	call   21ba <printf>
    10bf:	e8 2e 0f 00 00       	call   1ff2 <exit>

  stack = malloc(STACK_SIZE);
    10c4:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    10cb:	e8 d6 13 00 00       	call   24a6 <malloc>
    10d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  ttid = kthread_create(&trubleThread, stack+STACK_SIZE, STACK_SIZE);
    10d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d6:	05 e8 03 00 00       	add    $0x3e8,%eax
    10db:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
    10e2:	00 
    10e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e7:	c7 04 24 89 0d 00 00 	movl   $0xd89,(%esp)
    10ee:	e8 9f 0f 00 00       	call   2092 <kthread_create>
    10f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = 0 ; i < 10; i++){
    10f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10fd:	eb 69                	jmp    1168 <mutexYieldTest+0x2eb>
    stack = malloc(STACK_SIZE);
    10ff:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    1106:	e8 9b 13 00 00       	call   24a6 <malloc>
    110b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    tid[i] = kthread_create(&yieldThread, stack+STACK_SIZE, STACK_SIZE);
    110e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1111:	05 e8 03 00 00       	add    $0x3e8,%eax
    1116:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
    111d:	00 
    111e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1122:	c7 04 24 6e 0b 00 00 	movl   $0xb6e,(%esp)
    1129:	e8 64 0f 00 00       	call   2092 <kthread_create>
    112e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1131:	89 44 95 bc          	mov    %eax,-0x44(%ebp,%edx,4)
    sleep(i %3);   // make some more troubles
    1135:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1138:	ba 56 55 55 55       	mov    $0x55555556,%edx
    113d:	89 c8                	mov    %ecx,%eax
    113f:	f7 ea                	imul   %edx
    1141:	89 c8                	mov    %ecx,%eax
    1143:	c1 f8 1f             	sar    $0x1f,%eax
    1146:	29 c2                	sub    %eax,%edx
    1148:	89 d0                	mov    %edx,%eax
    114a:	01 c0                	add    %eax,%eax
    114c:	01 d0                	add    %edx,%eax
    114e:	29 c1                	sub    %eax,%ecx
    1150:	89 ca                	mov    %ecx,%edx
    1152:	89 14 24             	mov    %edx,(%esp)
    1155:	e8 28 0f 00 00       	call   2082 <sleep>
    c += tid[i];
    115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115d:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
    1161:	01 45 f0             	add    %eax,-0x10(%ebp)
  ASSERT((kthread_mutex_lock(mutex2) != 0), "mutex lock");

  stack = malloc(STACK_SIZE);
  ttid = kthread_create(&trubleThread, stack+STACK_SIZE, STACK_SIZE);

  for (i = 0 ; i < 10; i++){
    1164:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1168:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    116c:	7e 91                	jle    10ff <mutexYieldTest+0x282>
    tid[i] = kthread_create(&yieldThread, stack+STACK_SIZE, STACK_SIZE);
    sleep(i %3);   // make some more troubles
    c += tid[i];
  }

  sleep(1);   // wait all threads to sleep on mutex2
    116e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1175:	e8 08 0f 00 00       	call   2082 <sleep>
  ASSERT((kthread_mutex_yieldlock(mutex1, mutex2) != 0), "mutex yield");
    117a:	8b 15 60 31 00 00    	mov    0x3160,%edx
    1180:	a1 d0 31 00 00       	mov    0x31d0,%eax
    1185:	89 54 24 04          	mov    %edx,0x4(%esp)
    1189:	89 04 24             	mov    %eax,(%esp)
    118c:	e8 41 0f 00 00       	call   20d2 <kthread_mutex_yieldlock>
    1191:	85 c0                	test   %eax,%eax
    1193:	74 51                	je     11e6 <mutexYieldTest+0x369>
    1195:	c7 44 24 0c 4e 01 00 	movl   $0x14e,0xc(%esp)
    119c:	00 
    119d:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    11a4:	00 
    11a5:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    11ac:	00 
    11ad:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11b4:	e8 01 10 00 00       	call   21ba <printf>
    11b9:	c7 44 24 04 bb 29 00 	movl   $0x29bb,0x4(%esp)
    11c0:	00 
    11c1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11c8:	e8 ed 0f 00 00       	call   21ba <printf>
    11cd:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    11d4:	00 
    11d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11dc:	e8 d9 0f 00 00       	call   21ba <printf>
    11e1:	e8 0c 0e 00 00       	call   1ff2 <exit>


  for (i = 0 ; i < 10; i++){
    11e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ed:	e9 d9 00 00 00       	jmp    12cb <mutexYieldTest+0x44e>
    ASSERT((resource2 < 0), "(resource2 < 0)")
    11f2:	a1 64 31 00 00       	mov    0x3164,%eax
    11f7:	85 c0                	test   %eax,%eax
    11f9:	79 51                	jns    124c <mutexYieldTest+0x3cf>
    11fb:	c7 44 24 0c 52 01 00 	movl   $0x152,0xc(%esp)
    1202:	00 
    1203:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    120a:	00 
    120b:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1212:	00 
    1213:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    121a:	e8 9b 0f 00 00       	call   21ba <printf>
    121f:	c7 44 24 04 ec 29 00 	movl   $0x29ec,0x4(%esp)
    1226:	00 
    1227:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    122e:	e8 87 0f 00 00       	call   21ba <printf>
    1233:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    123a:	00 
    123b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1242:	e8 73 0f 00 00       	call   21ba <printf>
    1247:	e8 a6 0d 00 00       	call   1ff2 <exit>
    ans = kthread_join(tid[i]);
    124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124f:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 4f 0e 00 00       	call   20aa <kthread_join>
    125b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
    125e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1262:	74 63                	je     12c7 <mutexYieldTest+0x44a>
    1264:	c7 44 24 0c 55 01 00 	movl   $0x155,0xc(%esp)
    126b:	00 
    126c:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    1273:	00 
    1274:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    127b:	00 
    127c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1283:	e8 32 0f 00 00       	call   21ba <printf>
    1288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128b:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
    128f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1292:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1296:	89 44 24 08          	mov    %eax,0x8(%esp)
    129a:	c7 44 24 04 1c 29 00 	movl   $0x291c,0x4(%esp)
    12a1:	00 
    12a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    12a9:	e8 0c 0f 00 00       	call   21ba <printf>
    12ae:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    12b5:	00 
    12b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    12bd:	e8 f8 0e 00 00       	call   21ba <printf>
    12c2:	e8 2b 0d 00 00       	call   1ff2 <exit>

  sleep(1);   // wait all threads to sleep on mutex2
  ASSERT((kthread_mutex_yieldlock(mutex1, mutex2) != 0), "mutex yield");


  for (i = 0 ; i < 10; i++){
    12c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    12cb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    12cf:	0f 8e 1d ff ff ff    	jle    11f2 <mutexYieldTest+0x375>
    ans = kthread_join(tid[i]);
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
  }

  kthread_mutex_lock(mutex1);
    12d5:	a1 d0 31 00 00       	mov    0x31d0,%eax
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 e0 0d 00 00       	call   20c2 <kthread_mutex_lock>
  ASSERT((resource2 != -10), "expect resource2=-10, but resource2=%d, c=%d" , resource2, c);
    12e2:	a1 64 31 00 00       	mov    0x3164,%eax
    12e7:	83 f8 f6             	cmp    $0xfffffff6,%eax
    12ea:	74 61                	je     134d <mutexYieldTest+0x4d0>
    12ec:	c7 44 24 0c 59 01 00 	movl   $0x159,0xc(%esp)
    12f3:	00 
    12f4:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    12fb:	00 
    12fc:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1303:	00 
    1304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    130b:	e8 aa 0e 00 00       	call   21ba <printf>
    1310:	a1 64 31 00 00       	mov    0x3164,%eax
    1315:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1318:	89 54 24 0c          	mov    %edx,0xc(%esp)
    131c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1320:	c7 44 24 04 fc 29 00 	movl   $0x29fc,0x4(%esp)
    1327:	00 
    1328:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    132f:	e8 86 0e 00 00       	call   21ba <printf>
    1334:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    133b:	00 
    133c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1343:	e8 72 0e 00 00       	call   21ba <printf>
    1348:	e8 a5 0c 00 00       	call   1ff2 <exit>
  kthread_mutex_unlock(mutex1);
    134d:	a1 d0 31 00 00       	mov    0x31d0,%eax
    1352:	89 04 24             	mov    %eax,(%esp)
    1355:	e8 70 0d 00 00       	call   20ca <kthread_mutex_unlock>

  // wait for the truble thread
  kthread_join(ttid);
    135a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    135d:	89 04 24             	mov    %eax,(%esp)
    1360:	e8 45 0d 00 00       	call   20aa <kthread_join>

  // check that the last yield release the mutexes
  ASSERT((kthread_mutex_lock(mutex1) != 0), "mutex lock");
    1365:	a1 d0 31 00 00       	mov    0x31d0,%eax
    136a:	89 04 24             	mov    %eax,(%esp)
    136d:	e8 50 0d 00 00       	call   20c2 <kthread_mutex_lock>
    1372:	85 c0                	test   %eax,%eax
    1374:	74 51                	je     13c7 <mutexYieldTest+0x54a>
    1376:	c7 44 24 0c 60 01 00 	movl   $0x160,0xc(%esp)
    137d:	00 
    137e:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    1385:	00 
    1386:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    138d:	00 
    138e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1395:	e8 20 0e 00 00       	call   21ba <printf>
    139a:	c7 44 24 04 e1 29 00 	movl   $0x29e1,0x4(%esp)
    13a1:	00 
    13a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13a9:	e8 0c 0e 00 00       	call   21ba <printf>
    13ae:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    13b5:	00 
    13b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13bd:	e8 f8 0d 00 00       	call   21ba <printf>
    13c2:	e8 2b 0c 00 00       	call   1ff2 <exit>
  ASSERT((kthread_mutex_lock(mutex2) != 0), "mutex lock");
    13c7:	a1 60 31 00 00       	mov    0x3160,%eax
    13cc:	89 04 24             	mov    %eax,(%esp)
    13cf:	e8 ee 0c 00 00       	call   20c2 <kthread_mutex_lock>
    13d4:	85 c0                	test   %eax,%eax
    13d6:	74 51                	je     1429 <mutexYieldTest+0x5ac>
    13d8:	c7 44 24 0c 61 01 00 	movl   $0x161,0xc(%esp)
    13df:	00 
    13e0:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    13e7:	00 
    13e8:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    13ef:	00 
    13f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13f7:	e8 be 0d 00 00       	call   21ba <printf>
    13fc:	c7 44 24 04 e1 29 00 	movl   $0x29e1,0x4(%esp)
    1403:	00 
    1404:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    140b:	e8 aa 0d 00 00       	call   21ba <printf>
    1410:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1417:	00 
    1418:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    141f:	e8 96 0d 00 00       	call   21ba <printf>
    1424:	e8 c9 0b 00 00       	call   1ff2 <exit>
  ASSERT((kthread_mutex_unlock(mutex1) != 0), "mutex unlock");
    1429:	a1 d0 31 00 00       	mov    0x31d0,%eax
    142e:	89 04 24             	mov    %eax,(%esp)
    1431:	e8 94 0c 00 00       	call   20ca <kthread_mutex_unlock>
    1436:	85 c0                	test   %eax,%eax
    1438:	74 51                	je     148b <mutexYieldTest+0x60e>
    143a:	c7 44 24 0c 62 01 00 	movl   $0x162,0xc(%esp)
    1441:	00 
    1442:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    1449:	00 
    144a:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1451:	00 
    1452:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1459:	e8 5c 0d 00 00       	call   21ba <printf>
    145e:	c7 44 24 04 29 2a 00 	movl   $0x2a29,0x4(%esp)
    1465:	00 
    1466:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    146d:	e8 48 0d 00 00       	call   21ba <printf>
    1472:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1479:	00 
    147a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1481:	e8 34 0d 00 00       	call   21ba <printf>
    1486:	e8 67 0b 00 00       	call   1ff2 <exit>
  ASSERT((kthread_mutex_unlock(mutex2) != 0), "mutex unlock");
    148b:	a1 60 31 00 00       	mov    0x3160,%eax
    1490:	89 04 24             	mov    %eax,(%esp)
    1493:	e8 32 0c 00 00       	call   20ca <kthread_mutex_unlock>
    1498:	85 c0                	test   %eax,%eax
    149a:	74 51                	je     14ed <mutexYieldTest+0x670>
    149c:	c7 44 24 0c 63 01 00 	movl   $0x163,0xc(%esp)
    14a3:	00 
    14a4:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    14ab:	00 
    14ac:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    14b3:	00 
    14b4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14bb:	e8 fa 0c 00 00       	call   21ba <printf>
    14c0:	c7 44 24 04 29 2a 00 	movl   $0x2a29,0x4(%esp)
    14c7:	00 
    14c8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14cf:	e8 e6 0c 00 00       	call   21ba <printf>
    14d4:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    14db:	00 
    14dc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14e3:	e8 d2 0c 00 00       	call   21ba <printf>
    14e8:	e8 05 0b 00 00       	call   1ff2 <exit>

  // free the mutexes
  ASSERT( (kthread_mutex_dealloc(mutex1) != 0), "dealloc");
    14ed:	a1 d0 31 00 00       	mov    0x31d0,%eax
    14f2:	89 04 24             	mov    %eax,(%esp)
    14f5:	e8 c0 0b 00 00       	call   20ba <kthread_mutex_dealloc>
    14fa:	85 c0                	test   %eax,%eax
    14fc:	74 51                	je     154f <mutexYieldTest+0x6d2>
    14fe:	c7 44 24 0c 66 01 00 	movl   $0x166,0xc(%esp)
    1505:	00 
    1506:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    150d:	00 
    150e:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1515:	00 
    1516:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    151d:	e8 98 0c 00 00       	call   21ba <printf>
    1522:	c7 44 24 04 3d 29 00 	movl   $0x293d,0x4(%esp)
    1529:	00 
    152a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1531:	e8 84 0c 00 00       	call   21ba <printf>
    1536:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    153d:	00 
    153e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1545:	e8 70 0c 00 00       	call   21ba <printf>
    154a:	e8 a3 0a 00 00       	call   1ff2 <exit>
  ASSERT( (kthread_mutex_dealloc(mutex2) != 0), "dealloc");
    154f:	a1 60 31 00 00       	mov    0x3160,%eax
    1554:	89 04 24             	mov    %eax,(%esp)
    1557:	e8 5e 0b 00 00       	call   20ba <kthread_mutex_dealloc>
    155c:	85 c0                	test   %eax,%eax
    155e:	74 51                	je     15b1 <mutexYieldTest+0x734>
    1560:	c7 44 24 0c 67 01 00 	movl   $0x167,0xc(%esp)
    1567:	00 
    1568:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    156f:	00 
    1570:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1577:	00 
    1578:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    157f:	e8 36 0c 00 00       	call   21ba <printf>
    1584:	c7 44 24 04 3d 29 00 	movl   $0x293d,0x4(%esp)
    158b:	00 
    158c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1593:	e8 22 0c 00 00       	call   21ba <printf>
    1598:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    159f:	00 
    15a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    15a7:	e8 0e 0c 00 00       	call   21ba <printf>
    15ac:	e8 41 0a 00 00       	call   1ff2 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
    15b1:	c7 44 24 08 51 2c 00 	movl   $0x2c51,0x8(%esp)
    15b8:	00 
    15b9:	c7 44 24 04 63 29 00 	movl   $0x2963,0x4(%esp)
    15c0:	00 
    15c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c8:	e8 ed 0b 00 00       	call   21ba <printf>

}
    15cd:	c9                   	leave  
    15ce:	c3                   	ret    

000015cf <senaty>:

void senaty(int count){
    15cf:	55                   	push   %ebp
    15d0:	89 e5                	mov    %esp,%ebp
    15d2:	81 ec 28 01 00 00    	sub    $0x128,%esp
  int i, j;
  int mutex[MAX_MUTEXES];

  printf(1, "starting %s test\n", __FUNCTION__);
    15d8:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    15df:	00 
    15e0:	c7 44 24 04 c4 28 00 	movl   $0x28c4,0x4(%esp)
    15e7:	00 
    15e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ef:	e8 c6 0b 00 00       	call   21ba <printf>
  for(j=0 ; j<2 ; j++){ // run the test twice to check that mutexes can be reused
    15f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15fb:	e9 83 05 00 00       	jmp    1b83 <senaty+0x5b4>
    for(i=0 ; i < count ; i++){
    1600:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1607:	e9 dc 01 00 00       	jmp    17e8 <senaty+0x219>
      mutex[i] = kthread_mutex_alloc();
    160c:	e8 a1 0a 00 00       	call   20b2 <kthread_mutex_alloc>
    1611:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1614:	89 84 95 f0 fe ff ff 	mov    %eax,-0x110(%ebp,%edx,4)
      ASSERT((mutex[i] == -1), "kthread_mutex_alloc fail, i=%d", i);
    161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161e:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1625:	83 f8 ff             	cmp    $0xffffffff,%eax
    1628:	75 58                	jne    1682 <senaty+0xb3>
    162a:	c7 44 24 0c 75 01 00 	movl   $0x175,0xc(%esp)
    1631:	00 
    1632:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1639:	00 
    163a:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1641:	00 
    1642:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1649:	e8 6c 0b 00 00       	call   21ba <printf>
    164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1651:	89 44 24 08          	mov    %eax,0x8(%esp)
    1655:	c7 44 24 04 38 2a 00 	movl   $0x2a38,0x4(%esp)
    165c:	00 
    165d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1664:	e8 51 0b 00 00       	call   21ba <printf>
    1669:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1670:	00 
    1671:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1678:	e8 3d 0b 00 00       	call   21ba <printf>
    167d:	e8 70 09 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
    1682:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1685:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    168c:	89 04 24             	mov    %eax,(%esp)
    168f:	e8 2e 0a 00 00       	call   20c2 <kthread_mutex_lock>
    1694:	83 f8 ff             	cmp    $0xffffffff,%eax
    1697:	75 5f                	jne    16f8 <senaty+0x129>
    1699:	c7 44 24 0c 76 01 00 	movl   $0x176,0xc(%esp)
    16a0:	00 
    16a1:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    16a8:	00 
    16a9:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    16b0:	00 
    16b1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16b8:	e8 fd 0a 00 00       	call   21ba <printf>
    16bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c0:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    16c7:	89 44 24 08          	mov    %eax,0x8(%esp)
    16cb:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
    16d2:	00 
    16d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16da:	e8 db 0a 00 00       	call   21ba <printf>
    16df:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    16e6:	00 
    16e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16ee:	e8 c7 0a 00 00       	call   21ba <printf>
    16f3:	e8 fa 08 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
    16f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16fb:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1702:	89 04 24             	mov    %eax,(%esp)
    1705:	e8 c0 09 00 00       	call   20ca <kthread_mutex_unlock>
    170a:	83 f8 ff             	cmp    $0xffffffff,%eax
    170d:	75 5f                	jne    176e <senaty+0x19f>
    170f:	c7 44 24 0c 77 01 00 	movl   $0x177,0xc(%esp)
    1716:	00 
    1717:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    171e:	00 
    171f:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1726:	00 
    1727:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    172e:	e8 87 0a 00 00       	call   21ba <printf>
    1733:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1736:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    173d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1741:	c7 44 24 04 a6 28 00 	movl   $0x28a6,0x4(%esp)
    1748:	00 
    1749:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1750:	e8 65 0a 00 00       	call   21ba <printf>
    1755:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    175c:	00 
    175d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1764:	e8 51 0a 00 00       	call   21ba <printf>
    1769:	e8 84 08 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1771:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1778:	89 04 24             	mov    %eax,(%esp)
    177b:	e8 4a 09 00 00       	call   20ca <kthread_mutex_unlock>
    1780:	83 f8 ff             	cmp    $0xffffffff,%eax
    1783:	74 5f                	je     17e4 <senaty+0x215>
    1785:	c7 44 24 0c 78 01 00 	movl   $0x178,0xc(%esp)
    178c:	00 
    178d:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1794:	00 
    1795:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    179c:	00 
    179d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17a4:	e8 11 0a 00 00       	call   21ba <printf>
    17a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ac:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    17b3:	89 44 24 08          	mov    %eax,0x8(%esp)
    17b7:	c7 44 24 04 58 2a 00 	movl   $0x2a58,0x4(%esp)
    17be:	00 
    17bf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17c6:	e8 ef 09 00 00       	call   21ba <printf>
    17cb:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    17d2:	00 
    17d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17da:	e8 db 09 00 00       	call   21ba <printf>
    17df:	e8 0e 08 00 00       	call   1ff2 <exit>
  int i, j;
  int mutex[MAX_MUTEXES];

  printf(1, "starting %s test\n", __FUNCTION__);
  for(j=0 ; j<2 ; j++){ // run the test twice to check that mutexes can be reused
    for(i=0 ; i < count ; i++){
    17e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    17e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17eb:	3b 45 08             	cmp    0x8(%ebp),%eax
    17ee:	0f 8c 18 fe ff ff    	jl     160c <senaty+0x3d>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    17f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    17fb:	eb 7a                	jmp    1877 <senaty+0x2a8>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
    17fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1800:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1807:	89 04 24             	mov    %eax,(%esp)
    180a:	e8 b3 08 00 00       	call   20c2 <kthread_mutex_lock>
    180f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1812:	75 5f                	jne    1873 <senaty+0x2a4>
    1814:	c7 44 24 0c 7c 01 00 	movl   $0x17c,0xc(%esp)
    181b:	00 
    181c:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1823:	00 
    1824:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    182b:	00 
    182c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1833:	e8 82 09 00 00       	call   21ba <printf>
    1838:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183b:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1842:	89 44 24 08          	mov    %eax,0x8(%esp)
    1846:	c7 44 24 04 61 28 00 	movl   $0x2861,0x4(%esp)
    184d:	00 
    184e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1855:	e8 60 09 00 00       	call   21ba <printf>
    185a:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1861:	00 
    1862:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1869:	e8 4c 09 00 00       	call   21ba <printf>
    186e:	e8 7f 07 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    1873:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1877:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187a:	3b 45 08             	cmp    0x8(%ebp),%eax
    187d:	0f 8c 7a ff ff ff    	jl     17fd <senaty+0x22e>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    1883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    188a:	e9 f0 00 00 00       	jmp    197f <senaty+0x3b0>
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
    188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1892:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1899:	89 04 24             	mov    %eax,(%esp)
    189c:	e8 29 08 00 00       	call   20ca <kthread_mutex_unlock>
    18a1:	83 f8 ff             	cmp    $0xffffffff,%eax
    18a4:	75 5f                	jne    1905 <senaty+0x336>
    18a6:	c7 44 24 0c 80 01 00 	movl   $0x180,0xc(%esp)
    18ad:	00 
    18ae:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    18b5:	00 
    18b6:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    18bd:	00 
    18be:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18c5:	e8 f0 08 00 00       	call   21ba <printf>
    18ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cd:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    18d4:	89 44 24 08          	mov    %eax,0x8(%esp)
    18d8:	c7 44 24 04 a6 28 00 	movl   $0x28a6,0x4(%esp)
    18df:	00 
    18e0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18e7:	e8 ce 08 00 00       	call   21ba <printf>
    18ec:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    18f3:	00 
    18f4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18fb:	e8 ba 08 00 00       	call   21ba <printf>
    1900:	e8 ed 06 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    1905:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1908:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    190f:	89 04 24             	mov    %eax,(%esp)
    1912:	e8 b3 07 00 00       	call   20ca <kthread_mutex_unlock>
    1917:	83 f8 ff             	cmp    $0xffffffff,%eax
    191a:	74 5f                	je     197b <senaty+0x3ac>
    191c:	c7 44 24 0c 81 01 00 	movl   $0x181,0xc(%esp)
    1923:	00 
    1924:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    192b:	00 
    192c:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1933:	00 
    1934:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    193b:	e8 7a 08 00 00       	call   21ba <printf>
    1940:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1943:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    194a:	89 44 24 08          	mov    %eax,0x8(%esp)
    194e:	c7 44 24 04 58 2a 00 	movl   $0x2a58,0x4(%esp)
    1955:	00 
    1956:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    195d:	e8 58 08 00 00       	call   21ba <printf>
    1962:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1969:	00 
    196a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1971:	e8 44 08 00 00       	call   21ba <printf>
    1976:	e8 77 06 00 00       	call   1ff2 <exit>

    for(i=0 ; i < count ; i++){
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    197b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1982:	3b 45 08             	cmp    0x8(%ebp),%eax
    1985:	0f 8c 04 ff ff ff    	jl     188f <senaty+0x2c0>
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    198b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1992:	e9 dc 01 00 00       	jmp    1b73 <senaty+0x5a4>
      ASSERT((kthread_mutex_dealloc(mutex[i]) == -1), "kthread_mutex_dealloc(%d) fail", mutex[i]);
    1997:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199a:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    19a1:	89 04 24             	mov    %eax,(%esp)
    19a4:	e8 11 07 00 00       	call   20ba <kthread_mutex_dealloc>
    19a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    19ac:	75 5f                	jne    1a0d <senaty+0x43e>
    19ae:	c7 44 24 0c 85 01 00 	movl   $0x185,0xc(%esp)
    19b5:	00 
    19b6:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    19bd:	00 
    19be:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    19c5:	00 
    19c6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    19cd:	e8 e8 07 00 00       	call   21ba <printf>
    19d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d5:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    19dc:	89 44 24 08          	mov    %eax,0x8(%esp)
    19e0:	c7 44 24 04 90 2a 00 	movl   $0x2a90,0x4(%esp)
    19e7:	00 
    19e8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    19ef:	e8 c6 07 00 00       	call   21ba <printf>
    19f4:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    19fb:	00 
    19fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a03:	e8 b2 07 00 00       	call   21ba <printf>
    1a08:	e8 e5 05 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_dealloc(mutex[i]) != -1), "second kthread_mutex_dealloc(%d) didn't fail as expected", mutex[i]);
    1a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a10:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a17:	89 04 24             	mov    %eax,(%esp)
    1a1a:	e8 9b 06 00 00       	call   20ba <kthread_mutex_dealloc>
    1a1f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1a22:	74 5f                	je     1a83 <senaty+0x4b4>
    1a24:	c7 44 24 0c 86 01 00 	movl   $0x186,0xc(%esp)
    1a2b:	00 
    1a2c:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1a33:	00 
    1a34:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1a3b:	00 
    1a3c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a43:	e8 72 07 00 00       	call   21ba <printf>
    1a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4b:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a52:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a56:	c7 44 24 04 b0 2a 00 	movl   $0x2ab0,0x4(%esp)
    1a5d:	00 
    1a5e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a65:	e8 50 07 00 00       	call   21ba <printf>
    1a6a:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1a71:	00 
    1a72:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a79:	e8 3c 07 00 00       	call   21ba <printf>
    1a7e:	e8 6f 05 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_lock(mutex[i]) != -1), "kthread_mutex_lock(%d) didn't fail after dealloc", mutex[i]);
    1a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a86:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a8d:	89 04 24             	mov    %eax,(%esp)
    1a90:	e8 2d 06 00 00       	call   20c2 <kthread_mutex_lock>
    1a95:	83 f8 ff             	cmp    $0xffffffff,%eax
    1a98:	74 5f                	je     1af9 <senaty+0x52a>
    1a9a:	c7 44 24 0c 87 01 00 	movl   $0x187,0xc(%esp)
    1aa1:	00 
    1aa2:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1aa9:	00 
    1aaa:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1ab1:	00 
    1ab2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1ab9:	e8 fc 06 00 00       	call   21ba <printf>
    1abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac1:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
    1acc:	c7 44 24 04 ec 2a 00 	movl   $0x2aec,0x4(%esp)
    1ad3:	00 
    1ad4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1adb:	e8 da 06 00 00       	call   21ba <printf>
    1ae0:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1ae7:	00 
    1ae8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1aef:	e8 c6 06 00 00       	call   21ba <printf>
    1af4:	e8 f9 04 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "kthread_mutex_unlock(%d) didn't fail after dealloc", mutex[i]);
    1af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afc:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1b03:	89 04 24             	mov    %eax,(%esp)
    1b06:	e8 bf 05 00 00       	call   20ca <kthread_mutex_unlock>
    1b0b:	83 f8 ff             	cmp    $0xffffffff,%eax
    1b0e:	74 5f                	je     1b6f <senaty+0x5a0>
    1b10:	c7 44 24 0c 88 01 00 	movl   $0x188,0xc(%esp)
    1b17:	00 
    1b18:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1b1f:	00 
    1b20:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1b27:	00 
    1b28:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b2f:	e8 86 06 00 00       	call   21ba <printf>
    1b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b37:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b42:	c7 44 24 04 20 2b 00 	movl   $0x2b20,0x4(%esp)
    1b49:	00 
    1b4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b51:	e8 64 06 00 00       	call   21ba <printf>
    1b56:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1b5d:	00 
    1b5e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b65:	e8 50 06 00 00       	call   21ba <printf>
    1b6a:	e8 83 04 00 00       	call   1ff2 <exit>
    for(i=0 ; i < count ; i++){
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    }

    for(i=0 ; i < count ; i++){
    1b6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b76:	3b 45 08             	cmp    0x8(%ebp),%eax
    1b79:	0f 8c 18 fe ff ff    	jl     1997 <senaty+0x3c8>
void senaty(int count){
  int i, j;
  int mutex[MAX_MUTEXES];

  printf(1, "starting %s test\n", __FUNCTION__);
  for(j=0 ; j<2 ; j++){ // run the test twice to check that mutexes can be reused
    1b7f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b83:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    1b87:	0f 8e 73 fa ff ff    	jle    1600 <senaty+0x31>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "kthread_mutex_unlock(%d) didn't fail after dealloc", mutex[i]);
    }
  }

  /* chack that mutexes are really limited by MAX_MUTEXES */
  for (i=0 ; i<MAX_MUTEXES ; i++){
    1b8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b94:	e9 82 00 00 00       	jmp    1c1b <senaty+0x64c>
    mutex[i] = kthread_mutex_alloc();
    1b99:	e8 14 05 00 00       	call   20b2 <kthread_mutex_alloc>
    1b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ba1:	89 84 95 f0 fe ff ff 	mov    %eax,-0x110(%ebp,%edx,4)
    ASSERT((mutex[i] == -1), "kthread_mutex_alloc (limit) fail, i=%d, expected fail at:%d", i, MAX_MUTEXES);
    1ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bab:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1bb2:	83 f8 ff             	cmp    $0xffffffff,%eax
    1bb5:	75 60                	jne    1c17 <senaty+0x648>
    1bb7:	c7 44 24 0c 8f 01 00 	movl   $0x18f,0xc(%esp)
    1bbe:	00 
    1bbf:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1bc6:	00 
    1bc7:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1bce:	00 
    1bcf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bd6:	e8 df 05 00 00       	call   21ba <printf>
    1bdb:	c7 44 24 0c 40 00 00 	movl   $0x40,0xc(%esp)
    1be2:	00 
    1be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1bea:	c7 44 24 04 54 2b 00 	movl   $0x2b54,0x4(%esp)
    1bf1:	00 
    1bf2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bf9:	e8 bc 05 00 00       	call   21ba <printf>
    1bfe:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1c05:	00 
    1c06:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c0d:	e8 a8 05 00 00       	call   21ba <printf>
    1c12:	e8 db 03 00 00       	call   1ff2 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "kthread_mutex_unlock(%d) didn't fail after dealloc", mutex[i]);
    }
  }

  /* chack that mutexes are really limited by MAX_MUTEXES */
  for (i=0 ; i<MAX_MUTEXES ; i++){
    1c17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c1b:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    1c1f:	0f 8e 74 ff ff ff    	jle    1b99 <senaty+0x5ca>
    mutex[i] = kthread_mutex_alloc();
    ASSERT((mutex[i] == -1), "kthread_mutex_alloc (limit) fail, i=%d, expected fail at:%d", i, MAX_MUTEXES);
  }

  ASSERT((kthread_mutex_alloc() != -1), "limit test didn't fail as expected create %d mutexes instad of %d", i+1, MAX_MUTEXES);
    1c25:	e8 88 04 00 00       	call   20b2 <kthread_mutex_alloc>
    1c2a:	83 f8 ff             	cmp    $0xffffffff,%eax
    1c2d:	74 63                	je     1c92 <senaty+0x6c3>
    1c2f:	c7 44 24 0c 92 01 00 	movl   $0x192,0xc(%esp)
    1c36:	00 
    1c37:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1c3e:	00 
    1c3f:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1c46:	00 
    1c47:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c4e:	e8 67 05 00 00       	call   21ba <printf>
    1c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c56:	83 c0 01             	add    $0x1,%eax
    1c59:	c7 44 24 0c 40 00 00 	movl   $0x40,0xc(%esp)
    1c60:	00 
    1c61:	89 44 24 08          	mov    %eax,0x8(%esp)
    1c65:	c7 44 24 04 90 2b 00 	movl   $0x2b90,0x4(%esp)
    1c6c:	00 
    1c6d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c74:	e8 41 05 00 00       	call   21ba <printf>
    1c79:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1c80:	00 
    1c81:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c88:	e8 2d 05 00 00       	call   21ba <printf>
    1c8d:	e8 60 03 00 00       	call   1ff2 <exit>

  // release all mutexes
  for (i=0 ; i<MAX_MUTEXES ; i++){
    1c92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c99:	e9 81 00 00 00       	jmp    1d1f <senaty+0x750>
    ASSERT((kthread_mutex_dealloc(mutex[i]) == -1), "kthread_mutex_dealloc(%d) fail, i=%d", mutex[i], i);
    1c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ca1:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ca8:	89 04 24             	mov    %eax,(%esp)
    1cab:	e8 0a 04 00 00       	call   20ba <kthread_mutex_dealloc>
    1cb0:	83 f8 ff             	cmp    $0xffffffff,%eax
    1cb3:	75 66                	jne    1d1b <senaty+0x74c>
    1cb5:	c7 44 24 0c 96 01 00 	movl   $0x196,0xc(%esp)
    1cbc:	00 
    1cbd:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1cc4:	00 
    1cc5:	c7 44 24 04 50 28 00 	movl   $0x2850,0x4(%esp)
    1ccc:	00 
    1ccd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1cd4:	e8 e1 04 00 00       	call   21ba <printf>
    1cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cdc:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ce6:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1cea:	89 44 24 08          	mov    %eax,0x8(%esp)
    1cee:	c7 44 24 04 d4 2b 00 	movl   $0x2bd4,0x4(%esp)
    1cf5:	00 
    1cf6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1cfd:	e8 b8 04 00 00       	call   21ba <printf>
    1d02:	c7 44 24 04 7d 28 00 	movl   $0x287d,0x4(%esp)
    1d09:	00 
    1d0a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1d11:	e8 a4 04 00 00       	call   21ba <printf>
    1d16:	e8 d7 02 00 00       	call   1ff2 <exit>
  }

  ASSERT((kthread_mutex_alloc() != -1), "limit test didn't fail as expected create %d mutexes instad of %d", i+1, MAX_MUTEXES);

  // release all mutexes
  for (i=0 ; i<MAX_MUTEXES ; i++){
    1d1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1d1f:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    1d23:	0f 8e 75 ff ff ff    	jle    1c9e <senaty+0x6cf>
    ASSERT((kthread_mutex_dealloc(mutex[i]) == -1), "kthread_mutex_dealloc(%d) fail, i=%d", mutex[i], i);
  }

  printf(1, "%s test PASS!\n", __FUNCTION__);
    1d29:	c7 44 24 08 60 2c 00 	movl   $0x2c60,0x8(%esp)
    1d30:	00 
    1d31:	c7 44 24 04 63 29 00 	movl   $0x2963,0x4(%esp)
    1d38:	00 
    1d39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d40:	e8 75 04 00 00       	call   21ba <printf>
}
    1d45:	c9                   	leave  
    1d46:	c3                   	ret    

00001d47 <main>:

int main(){
    1d47:	55                   	push   %ebp
    1d48:	89 e5                	mov    %esp,%ebp
    1d4a:	83 e4 f0             	and    $0xfffffff0,%esp
    1d4d:	83 ec 10             	sub    $0x10,%esp
  senaty(MAX_MUTEXES);
    1d50:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
    1d57:	e8 73 f8 ff ff       	call   15cf <senaty>
  stressTest1(15);
    1d5c:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
    1d63:	e8 e9 e5 ff ff       	call   351 <stressTest1>
  mutexYieldTest();
    1d68:	e8 10 f1 ff ff       	call   e7d <mutexYieldTest>
  stressTest2Fail(15);
    1d6d:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
    1d74:	e8 b7 e9 ff ff       	call   730 <stressTest2Fail>
  stressTest3toMuchTreads(15); //this test must be the last
    1d79:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
    1d80:	e8 61 ec ff ff       	call   9e6 <stressTest3toMuchTreads>

  exit();
    1d85:	e8 68 02 00 00       	call   1ff2 <exit>

00001d8a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1d8a:	55                   	push   %ebp
    1d8b:	89 e5                	mov    %esp,%ebp
    1d8d:	57                   	push   %edi
    1d8e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1d92:	8b 55 10             	mov    0x10(%ebp),%edx
    1d95:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d98:	89 cb                	mov    %ecx,%ebx
    1d9a:	89 df                	mov    %ebx,%edi
    1d9c:	89 d1                	mov    %edx,%ecx
    1d9e:	fc                   	cld    
    1d9f:	f3 aa                	rep stos %al,%es:(%edi)
    1da1:	89 ca                	mov    %ecx,%edx
    1da3:	89 fb                	mov    %edi,%ebx
    1da5:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1da8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1dab:	5b                   	pop    %ebx
    1dac:	5f                   	pop    %edi
    1dad:	5d                   	pop    %ebp
    1dae:	c3                   	ret    

00001daf <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1daf:	55                   	push   %ebp
    1db0:	89 e5                	mov    %esp,%ebp
    1db2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1db5:	8b 45 08             	mov    0x8(%ebp),%eax
    1db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1dbb:	90                   	nop
    1dbc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dbf:	8d 50 01             	lea    0x1(%eax),%edx
    1dc2:	89 55 08             	mov    %edx,0x8(%ebp)
    1dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
    1dc8:	8d 4a 01             	lea    0x1(%edx),%ecx
    1dcb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1dce:	0f b6 12             	movzbl (%edx),%edx
    1dd1:	88 10                	mov    %dl,(%eax)
    1dd3:	0f b6 00             	movzbl (%eax),%eax
    1dd6:	84 c0                	test   %al,%al
    1dd8:	75 e2                	jne    1dbc <strcpy+0xd>
    ;
  return os;
    1dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1ddd:	c9                   	leave  
    1dde:	c3                   	ret    

00001ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1ddf:	55                   	push   %ebp
    1de0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1de2:	eb 08                	jmp    1dec <strcmp+0xd>
    p++, q++;
    1de4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1de8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1dec:	8b 45 08             	mov    0x8(%ebp),%eax
    1def:	0f b6 00             	movzbl (%eax),%eax
    1df2:	84 c0                	test   %al,%al
    1df4:	74 10                	je     1e06 <strcmp+0x27>
    1df6:	8b 45 08             	mov    0x8(%ebp),%eax
    1df9:	0f b6 10             	movzbl (%eax),%edx
    1dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
    1dff:	0f b6 00             	movzbl (%eax),%eax
    1e02:	38 c2                	cmp    %al,%dl
    1e04:	74 de                	je     1de4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1e06:	8b 45 08             	mov    0x8(%ebp),%eax
    1e09:	0f b6 00             	movzbl (%eax),%eax
    1e0c:	0f b6 d0             	movzbl %al,%edx
    1e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e12:	0f b6 00             	movzbl (%eax),%eax
    1e15:	0f b6 c0             	movzbl %al,%eax
    1e18:	29 c2                	sub    %eax,%edx
    1e1a:	89 d0                	mov    %edx,%eax
}
    1e1c:	5d                   	pop    %ebp
    1e1d:	c3                   	ret    

00001e1e <strlen>:

uint
strlen(char *s)
{
    1e1e:	55                   	push   %ebp
    1e1f:	89 e5                	mov    %esp,%ebp
    1e21:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1e24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1e2b:	eb 04                	jmp    1e31 <strlen+0x13>
    1e2d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1e31:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1e34:	8b 45 08             	mov    0x8(%ebp),%eax
    1e37:	01 d0                	add    %edx,%eax
    1e39:	0f b6 00             	movzbl (%eax),%eax
    1e3c:	84 c0                	test   %al,%al
    1e3e:	75 ed                	jne    1e2d <strlen+0xf>
    ;
  return n;
    1e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1e43:	c9                   	leave  
    1e44:	c3                   	ret    

00001e45 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1e45:	55                   	push   %ebp
    1e46:	89 e5                	mov    %esp,%ebp
    1e48:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1e4b:	8b 45 10             	mov    0x10(%ebp),%eax
    1e4e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e52:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e55:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e59:	8b 45 08             	mov    0x8(%ebp),%eax
    1e5c:	89 04 24             	mov    %eax,(%esp)
    1e5f:	e8 26 ff ff ff       	call   1d8a <stosb>
  return dst;
    1e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1e67:	c9                   	leave  
    1e68:	c3                   	ret    

00001e69 <strchr>:

char*
strchr(const char *s, char c)
{
    1e69:	55                   	push   %ebp
    1e6a:	89 e5                	mov    %esp,%ebp
    1e6c:	83 ec 04             	sub    $0x4,%esp
    1e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e72:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1e75:	eb 14                	jmp    1e8b <strchr+0x22>
    if(*s == c)
    1e77:	8b 45 08             	mov    0x8(%ebp),%eax
    1e7a:	0f b6 00             	movzbl (%eax),%eax
    1e7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1e80:	75 05                	jne    1e87 <strchr+0x1e>
      return (char*)s;
    1e82:	8b 45 08             	mov    0x8(%ebp),%eax
    1e85:	eb 13                	jmp    1e9a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1e87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1e8b:	8b 45 08             	mov    0x8(%ebp),%eax
    1e8e:	0f b6 00             	movzbl (%eax),%eax
    1e91:	84 c0                	test   %al,%al
    1e93:	75 e2                	jne    1e77 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1e9a:	c9                   	leave  
    1e9b:	c3                   	ret    

00001e9c <gets>:

char*
gets(char *buf, int max)
{
    1e9c:	55                   	push   %ebp
    1e9d:	89 e5                	mov    %esp,%ebp
    1e9f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1ea2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ea9:	eb 4c                	jmp    1ef7 <gets+0x5b>
    cc = read(0, &c, 1);
    1eab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1eb2:	00 
    1eb3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
    1eba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1ec1:	e8 44 01 00 00       	call   200a <read>
    1ec6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1ec9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1ecd:	7f 02                	jg     1ed1 <gets+0x35>
      break;
    1ecf:	eb 31                	jmp    1f02 <gets+0x66>
    buf[i++] = c;
    1ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ed4:	8d 50 01             	lea    0x1(%eax),%edx
    1ed7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1eda:	89 c2                	mov    %eax,%edx
    1edc:	8b 45 08             	mov    0x8(%ebp),%eax
    1edf:	01 c2                	add    %eax,%edx
    1ee1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1ee5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1ee7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1eeb:	3c 0a                	cmp    $0xa,%al
    1eed:	74 13                	je     1f02 <gets+0x66>
    1eef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1ef3:	3c 0d                	cmp    $0xd,%al
    1ef5:	74 0b                	je     1f02 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1efa:	83 c0 01             	add    $0x1,%eax
    1efd:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1f00:	7c a9                	jl     1eab <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1f05:	8b 45 08             	mov    0x8(%ebp),%eax
    1f08:	01 d0                	add    %edx,%eax
    1f0a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1f0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1f10:	c9                   	leave  
    1f11:	c3                   	ret    

00001f12 <stat>:

int
stat(char *n, struct stat *st)
{
    1f12:	55                   	push   %ebp
    1f13:	89 e5                	mov    %esp,%ebp
    1f15:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1f18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f1f:	00 
    1f20:	8b 45 08             	mov    0x8(%ebp),%eax
    1f23:	89 04 24             	mov    %eax,(%esp)
    1f26:	e8 07 01 00 00       	call   2032 <open>
    1f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1f32:	79 07                	jns    1f3b <stat+0x29>
    return -1;
    1f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1f39:	eb 23                	jmp    1f5e <stat+0x4c>
  r = fstat(fd, st);
    1f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
    1f3e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f45:	89 04 24             	mov    %eax,(%esp)
    1f48:	e8 fd 00 00 00       	call   204a <fstat>
    1f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f53:	89 04 24             	mov    %eax,(%esp)
    1f56:	e8 bf 00 00 00       	call   201a <close>
  return r;
    1f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1f5e:	c9                   	leave  
    1f5f:	c3                   	ret    

00001f60 <atoi>:

int
atoi(const char *s)
{
    1f60:	55                   	push   %ebp
    1f61:	89 e5                	mov    %esp,%ebp
    1f63:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1f66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1f6d:	eb 25                	jmp    1f94 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1f6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1f72:	89 d0                	mov    %edx,%eax
    1f74:	c1 e0 02             	shl    $0x2,%eax
    1f77:	01 d0                	add    %edx,%eax
    1f79:	01 c0                	add    %eax,%eax
    1f7b:	89 c1                	mov    %eax,%ecx
    1f7d:	8b 45 08             	mov    0x8(%ebp),%eax
    1f80:	8d 50 01             	lea    0x1(%eax),%edx
    1f83:	89 55 08             	mov    %edx,0x8(%ebp)
    1f86:	0f b6 00             	movzbl (%eax),%eax
    1f89:	0f be c0             	movsbl %al,%eax
    1f8c:	01 c8                	add    %ecx,%eax
    1f8e:	83 e8 30             	sub    $0x30,%eax
    1f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1f94:	8b 45 08             	mov    0x8(%ebp),%eax
    1f97:	0f b6 00             	movzbl (%eax),%eax
    1f9a:	3c 2f                	cmp    $0x2f,%al
    1f9c:	7e 0a                	jle    1fa8 <atoi+0x48>
    1f9e:	8b 45 08             	mov    0x8(%ebp),%eax
    1fa1:	0f b6 00             	movzbl (%eax),%eax
    1fa4:	3c 39                	cmp    $0x39,%al
    1fa6:	7e c7                	jle    1f6f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1fab:	c9                   	leave  
    1fac:	c3                   	ret    

00001fad <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1fad:	55                   	push   %ebp
    1fae:	89 e5                	mov    %esp,%ebp
    1fb0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1fb3:	8b 45 08             	mov    0x8(%ebp),%eax
    1fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
    1fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1fbf:	eb 17                	jmp    1fd8 <memmove+0x2b>
    *dst++ = *src++;
    1fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1fc4:	8d 50 01             	lea    0x1(%eax),%edx
    1fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1fca:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1fcd:	8d 4a 01             	lea    0x1(%edx),%ecx
    1fd0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1fd3:	0f b6 12             	movzbl (%edx),%edx
    1fd6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1fd8:	8b 45 10             	mov    0x10(%ebp),%eax
    1fdb:	8d 50 ff             	lea    -0x1(%eax),%edx
    1fde:	89 55 10             	mov    %edx,0x10(%ebp)
    1fe1:	85 c0                	test   %eax,%eax
    1fe3:	7f dc                	jg     1fc1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1fe5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1fe8:	c9                   	leave  
    1fe9:	c3                   	ret    

00001fea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1fea:	b8 01 00 00 00       	mov    $0x1,%eax
    1fef:	cd 40                	int    $0x40
    1ff1:	c3                   	ret    

00001ff2 <exit>:
SYSCALL(exit)
    1ff2:	b8 02 00 00 00       	mov    $0x2,%eax
    1ff7:	cd 40                	int    $0x40
    1ff9:	c3                   	ret    

00001ffa <wait>:
SYSCALL(wait)
    1ffa:	b8 03 00 00 00       	mov    $0x3,%eax
    1fff:	cd 40                	int    $0x40
    2001:	c3                   	ret    

00002002 <pipe>:
SYSCALL(pipe)
    2002:	b8 04 00 00 00       	mov    $0x4,%eax
    2007:	cd 40                	int    $0x40
    2009:	c3                   	ret    

0000200a <read>:
SYSCALL(read)
    200a:	b8 05 00 00 00       	mov    $0x5,%eax
    200f:	cd 40                	int    $0x40
    2011:	c3                   	ret    

00002012 <write>:
SYSCALL(write)
    2012:	b8 10 00 00 00       	mov    $0x10,%eax
    2017:	cd 40                	int    $0x40
    2019:	c3                   	ret    

0000201a <close>:
SYSCALL(close)
    201a:	b8 15 00 00 00       	mov    $0x15,%eax
    201f:	cd 40                	int    $0x40
    2021:	c3                   	ret    

00002022 <kill>:
SYSCALL(kill)
    2022:	b8 06 00 00 00       	mov    $0x6,%eax
    2027:	cd 40                	int    $0x40
    2029:	c3                   	ret    

0000202a <exec>:
SYSCALL(exec)
    202a:	b8 07 00 00 00       	mov    $0x7,%eax
    202f:	cd 40                	int    $0x40
    2031:	c3                   	ret    

00002032 <open>:
SYSCALL(open)
    2032:	b8 0f 00 00 00       	mov    $0xf,%eax
    2037:	cd 40                	int    $0x40
    2039:	c3                   	ret    

0000203a <mknod>:
SYSCALL(mknod)
    203a:	b8 11 00 00 00       	mov    $0x11,%eax
    203f:	cd 40                	int    $0x40
    2041:	c3                   	ret    

00002042 <unlink>:
SYSCALL(unlink)
    2042:	b8 12 00 00 00       	mov    $0x12,%eax
    2047:	cd 40                	int    $0x40
    2049:	c3                   	ret    

0000204a <fstat>:
SYSCALL(fstat)
    204a:	b8 08 00 00 00       	mov    $0x8,%eax
    204f:	cd 40                	int    $0x40
    2051:	c3                   	ret    

00002052 <link>:
SYSCALL(link)
    2052:	b8 13 00 00 00       	mov    $0x13,%eax
    2057:	cd 40                	int    $0x40
    2059:	c3                   	ret    

0000205a <mkdir>:
SYSCALL(mkdir)
    205a:	b8 14 00 00 00       	mov    $0x14,%eax
    205f:	cd 40                	int    $0x40
    2061:	c3                   	ret    

00002062 <chdir>:
SYSCALL(chdir)
    2062:	b8 09 00 00 00       	mov    $0x9,%eax
    2067:	cd 40                	int    $0x40
    2069:	c3                   	ret    

0000206a <dup>:
SYSCALL(dup)
    206a:	b8 0a 00 00 00       	mov    $0xa,%eax
    206f:	cd 40                	int    $0x40
    2071:	c3                   	ret    

00002072 <getpid>:
SYSCALL(getpid)
    2072:	b8 0b 00 00 00       	mov    $0xb,%eax
    2077:	cd 40                	int    $0x40
    2079:	c3                   	ret    

0000207a <sbrk>:
SYSCALL(sbrk)
    207a:	b8 0c 00 00 00       	mov    $0xc,%eax
    207f:	cd 40                	int    $0x40
    2081:	c3                   	ret    

00002082 <sleep>:
SYSCALL(sleep)
    2082:	b8 0d 00 00 00       	mov    $0xd,%eax
    2087:	cd 40                	int    $0x40
    2089:	c3                   	ret    

0000208a <uptime>:
SYSCALL(uptime)
    208a:	b8 0e 00 00 00       	mov    $0xe,%eax
    208f:	cd 40                	int    $0x40
    2091:	c3                   	ret    

00002092 <kthread_create>:




SYSCALL(kthread_create)
    2092:	b8 16 00 00 00       	mov    $0x16,%eax
    2097:	cd 40                	int    $0x40
    2099:	c3                   	ret    

0000209a <kthread_id>:
SYSCALL(kthread_id)
    209a:	b8 17 00 00 00       	mov    $0x17,%eax
    209f:	cd 40                	int    $0x40
    20a1:	c3                   	ret    

000020a2 <kthread_exit>:
SYSCALL(kthread_exit)
    20a2:	b8 18 00 00 00       	mov    $0x18,%eax
    20a7:	cd 40                	int    $0x40
    20a9:	c3                   	ret    

000020aa <kthread_join>:
SYSCALL(kthread_join)
    20aa:	b8 19 00 00 00       	mov    $0x19,%eax
    20af:	cd 40                	int    $0x40
    20b1:	c3                   	ret    

000020b2 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
    20b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    20b7:	cd 40                	int    $0x40
    20b9:	c3                   	ret    

000020ba <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
    20ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
    20bf:	cd 40                	int    $0x40
    20c1:	c3                   	ret    

000020c2 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
    20c2:	b8 1c 00 00 00       	mov    $0x1c,%eax
    20c7:	cd 40                	int    $0x40
    20c9:	c3                   	ret    

000020ca <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
    20ca:	b8 1d 00 00 00       	mov    $0x1d,%eax
    20cf:	cd 40                	int    $0x40
    20d1:	c3                   	ret    

000020d2 <kthread_mutex_yieldlock>:
    20d2:	b8 1e 00 00 00       	mov    $0x1e,%eax
    20d7:	cd 40                	int    $0x40
    20d9:	c3                   	ret    

000020da <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    20da:	55                   	push   %ebp
    20db:	89 e5                	mov    %esp,%ebp
    20dd:	83 ec 18             	sub    $0x18,%esp
    20e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    20e3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    20e6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20ed:	00 
    20ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
    20f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    20f5:	8b 45 08             	mov    0x8(%ebp),%eax
    20f8:	89 04 24             	mov    %eax,(%esp)
    20fb:	e8 12 ff ff ff       	call   2012 <write>
}
    2100:	c9                   	leave  
    2101:	c3                   	ret    

00002102 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    2102:	55                   	push   %ebp
    2103:	89 e5                	mov    %esp,%ebp
    2105:	56                   	push   %esi
    2106:	53                   	push   %ebx
    2107:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    210a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    2111:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    2115:	74 17                	je     212e <printint+0x2c>
    2117:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    211b:	79 11                	jns    212e <printint+0x2c>
    neg = 1;
    211d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    2124:	8b 45 0c             	mov    0xc(%ebp),%eax
    2127:	f7 d8                	neg    %eax
    2129:	89 45 ec             	mov    %eax,-0x14(%ebp)
    212c:	eb 06                	jmp    2134 <printint+0x32>
  } else {
    x = xx;
    212e:	8b 45 0c             	mov    0xc(%ebp),%eax
    2131:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    2134:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    213b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    213e:	8d 41 01             	lea    0x1(%ecx),%eax
    2141:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2144:	8b 5d 10             	mov    0x10(%ebp),%ebx
    2147:	8b 45 ec             	mov    -0x14(%ebp),%eax
    214a:	ba 00 00 00 00       	mov    $0x0,%edx
    214f:	f7 f3                	div    %ebx
    2151:	89 d0                	mov    %edx,%eax
    2153:	0f b6 80 14 31 00 00 	movzbl 0x3114(%eax),%eax
    215a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    215e:	8b 75 10             	mov    0x10(%ebp),%esi
    2161:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2164:	ba 00 00 00 00       	mov    $0x0,%edx
    2169:	f7 f6                	div    %esi
    216b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    216e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2172:	75 c7                	jne    213b <printint+0x39>
  if(neg)
    2174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2178:	74 10                	je     218a <printint+0x88>
    buf[i++] = '-';
    217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    217d:	8d 50 01             	lea    0x1(%eax),%edx
    2180:	89 55 f4             	mov    %edx,-0xc(%ebp)
    2183:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    2188:	eb 1f                	jmp    21a9 <printint+0xa7>
    218a:	eb 1d                	jmp    21a9 <printint+0xa7>
    putc(fd, buf[i]);
    218c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2192:	01 d0                	add    %edx,%eax
    2194:	0f b6 00             	movzbl (%eax),%eax
    2197:	0f be c0             	movsbl %al,%eax
    219a:	89 44 24 04          	mov    %eax,0x4(%esp)
    219e:	8b 45 08             	mov    0x8(%ebp),%eax
    21a1:	89 04 24             	mov    %eax,(%esp)
    21a4:	e8 31 ff ff ff       	call   20da <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    21a9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    21ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21b1:	79 d9                	jns    218c <printint+0x8a>
    putc(fd, buf[i]);
}
    21b3:	83 c4 30             	add    $0x30,%esp
    21b6:	5b                   	pop    %ebx
    21b7:	5e                   	pop    %esi
    21b8:	5d                   	pop    %ebp
    21b9:	c3                   	ret    

000021ba <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    21ba:	55                   	push   %ebp
    21bb:	89 e5                	mov    %esp,%ebp
    21bd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    21c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    21c7:	8d 45 0c             	lea    0xc(%ebp),%eax
    21ca:	83 c0 04             	add    $0x4,%eax
    21cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    21d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    21d7:	e9 7c 01 00 00       	jmp    2358 <printf+0x19e>
    c = fmt[i] & 0xff;
    21dc:	8b 55 0c             	mov    0xc(%ebp),%edx
    21df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    21e2:	01 d0                	add    %edx,%eax
    21e4:	0f b6 00             	movzbl (%eax),%eax
    21e7:	0f be c0             	movsbl %al,%eax
    21ea:	25 ff 00 00 00       	and    $0xff,%eax
    21ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    21f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    21f6:	75 2c                	jne    2224 <printf+0x6a>
      if(c == '%'){
    21f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    21fc:	75 0c                	jne    220a <printf+0x50>
        state = '%';
    21fe:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    2205:	e9 4a 01 00 00       	jmp    2354 <printf+0x19a>
      } else {
        putc(fd, c);
    220a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    220d:	0f be c0             	movsbl %al,%eax
    2210:	89 44 24 04          	mov    %eax,0x4(%esp)
    2214:	8b 45 08             	mov    0x8(%ebp),%eax
    2217:	89 04 24             	mov    %eax,(%esp)
    221a:	e8 bb fe ff ff       	call   20da <putc>
    221f:	e9 30 01 00 00       	jmp    2354 <printf+0x19a>
      }
    } else if(state == '%'){
    2224:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    2228:	0f 85 26 01 00 00    	jne    2354 <printf+0x19a>
      if(c == 'd'){
    222e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    2232:	75 2d                	jne    2261 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    2234:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2237:	8b 00                	mov    (%eax),%eax
    2239:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    2240:	00 
    2241:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2248:	00 
    2249:	89 44 24 04          	mov    %eax,0x4(%esp)
    224d:	8b 45 08             	mov    0x8(%ebp),%eax
    2250:	89 04 24             	mov    %eax,(%esp)
    2253:	e8 aa fe ff ff       	call   2102 <printint>
        ap++;
    2258:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    225c:	e9 ec 00 00 00       	jmp    234d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    2261:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    2265:	74 06                	je     226d <printf+0xb3>
    2267:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    226b:	75 2d                	jne    229a <printf+0xe0>
        printint(fd, *ap, 16, 0);
    226d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2270:	8b 00                	mov    (%eax),%eax
    2272:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    2279:	00 
    227a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    2281:	00 
    2282:	89 44 24 04          	mov    %eax,0x4(%esp)
    2286:	8b 45 08             	mov    0x8(%ebp),%eax
    2289:	89 04 24             	mov    %eax,(%esp)
    228c:	e8 71 fe ff ff       	call   2102 <printint>
        ap++;
    2291:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2295:	e9 b3 00 00 00       	jmp    234d <printf+0x193>
      } else if(c == 's'){
    229a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    229e:	75 45                	jne    22e5 <printf+0x12b>
        s = (char*)*ap;
    22a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    22a3:	8b 00                	mov    (%eax),%eax
    22a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    22a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    22ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22b0:	75 09                	jne    22bb <printf+0x101>
          s = "(null)";
    22b2:	c7 45 f4 67 2c 00 00 	movl   $0x2c67,-0xc(%ebp)
        while(*s != 0){
    22b9:	eb 1e                	jmp    22d9 <printf+0x11f>
    22bb:	eb 1c                	jmp    22d9 <printf+0x11f>
          putc(fd, *s);
    22bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22c0:	0f b6 00             	movzbl (%eax),%eax
    22c3:	0f be c0             	movsbl %al,%eax
    22c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    22ca:	8b 45 08             	mov    0x8(%ebp),%eax
    22cd:	89 04 24             	mov    %eax,(%esp)
    22d0:	e8 05 fe ff ff       	call   20da <putc>
          s++;
    22d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    22d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22dc:	0f b6 00             	movzbl (%eax),%eax
    22df:	84 c0                	test   %al,%al
    22e1:	75 da                	jne    22bd <printf+0x103>
    22e3:	eb 68                	jmp    234d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    22e5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    22e9:	75 1d                	jne    2308 <printf+0x14e>
        putc(fd, *ap);
    22eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    22ee:	8b 00                	mov    (%eax),%eax
    22f0:	0f be c0             	movsbl %al,%eax
    22f3:	89 44 24 04          	mov    %eax,0x4(%esp)
    22f7:	8b 45 08             	mov    0x8(%ebp),%eax
    22fa:	89 04 24             	mov    %eax,(%esp)
    22fd:	e8 d8 fd ff ff       	call   20da <putc>
        ap++;
    2302:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2306:	eb 45                	jmp    234d <printf+0x193>
      } else if(c == '%'){
    2308:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    230c:	75 17                	jne    2325 <printf+0x16b>
        putc(fd, c);
    230e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2311:	0f be c0             	movsbl %al,%eax
    2314:	89 44 24 04          	mov    %eax,0x4(%esp)
    2318:	8b 45 08             	mov    0x8(%ebp),%eax
    231b:	89 04 24             	mov    %eax,(%esp)
    231e:	e8 b7 fd ff ff       	call   20da <putc>
    2323:	eb 28                	jmp    234d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2325:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    232c:	00 
    232d:	8b 45 08             	mov    0x8(%ebp),%eax
    2330:	89 04 24             	mov    %eax,(%esp)
    2333:	e8 a2 fd ff ff       	call   20da <putc>
        putc(fd, c);
    2338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    233b:	0f be c0             	movsbl %al,%eax
    233e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2342:	8b 45 08             	mov    0x8(%ebp),%eax
    2345:	89 04 24             	mov    %eax,(%esp)
    2348:	e8 8d fd ff ff       	call   20da <putc>
      }
      state = 0;
    234d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2354:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2358:	8b 55 0c             	mov    0xc(%ebp),%edx
    235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    235e:	01 d0                	add    %edx,%eax
    2360:	0f b6 00             	movzbl (%eax),%eax
    2363:	84 c0                	test   %al,%al
    2365:	0f 85 71 fe ff ff    	jne    21dc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    236b:	c9                   	leave  
    236c:	c3                   	ret    

0000236d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    236d:	55                   	push   %ebp
    236e:	89 e5                	mov    %esp,%ebp
    2370:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2373:	8b 45 08             	mov    0x8(%ebp),%eax
    2376:	83 e8 08             	sub    $0x8,%eax
    2379:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    237c:	a1 48 31 00 00       	mov    0x3148,%eax
    2381:	89 45 fc             	mov    %eax,-0x4(%ebp)
    2384:	eb 24                	jmp    23aa <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2386:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2389:	8b 00                	mov    (%eax),%eax
    238b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    238e:	77 12                	ja     23a2 <free+0x35>
    2390:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2393:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    2396:	77 24                	ja     23bc <free+0x4f>
    2398:	8b 45 fc             	mov    -0x4(%ebp),%eax
    239b:	8b 00                	mov    (%eax),%eax
    239d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    23a0:	77 1a                	ja     23bc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    23a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23a5:	8b 00                	mov    (%eax),%eax
    23a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    23aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    23b0:	76 d4                	jbe    2386 <free+0x19>
    23b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23b5:	8b 00                	mov    (%eax),%eax
    23b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    23ba:	76 ca                	jbe    2386 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    23bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23bf:	8b 40 04             	mov    0x4(%eax),%eax
    23c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    23c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23cc:	01 c2                	add    %eax,%edx
    23ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23d1:	8b 00                	mov    (%eax),%eax
    23d3:	39 c2                	cmp    %eax,%edx
    23d5:	75 24                	jne    23fb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    23d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23da:	8b 50 04             	mov    0x4(%eax),%edx
    23dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23e0:	8b 00                	mov    (%eax),%eax
    23e2:	8b 40 04             	mov    0x4(%eax),%eax
    23e5:	01 c2                	add    %eax,%edx
    23e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23ea:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    23ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23f0:	8b 00                	mov    (%eax),%eax
    23f2:	8b 10                	mov    (%eax),%edx
    23f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23f7:	89 10                	mov    %edx,(%eax)
    23f9:	eb 0a                	jmp    2405 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    23fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23fe:	8b 10                	mov    (%eax),%edx
    2400:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2403:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    2405:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2408:	8b 40 04             	mov    0x4(%eax),%eax
    240b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    2412:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2415:	01 d0                	add    %edx,%eax
    2417:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    241a:	75 20                	jne    243c <free+0xcf>
    p->s.size += bp->s.size;
    241c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    241f:	8b 50 04             	mov    0x4(%eax),%edx
    2422:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2425:	8b 40 04             	mov    0x4(%eax),%eax
    2428:	01 c2                	add    %eax,%edx
    242a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    242d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    2430:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2433:	8b 10                	mov    (%eax),%edx
    2435:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2438:	89 10                	mov    %edx,(%eax)
    243a:	eb 08                	jmp    2444 <free+0xd7>
  } else
    p->s.ptr = bp;
    243c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    243f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    2442:	89 10                	mov    %edx,(%eax)
  freep = p;
    2444:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2447:	a3 48 31 00 00       	mov    %eax,0x3148
}
    244c:	c9                   	leave  
    244d:	c3                   	ret    

0000244e <morecore>:

static Header*
morecore(uint nu)
{
    244e:	55                   	push   %ebp
    244f:	89 e5                	mov    %esp,%ebp
    2451:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    2454:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    245b:	77 07                	ja     2464 <morecore+0x16>
    nu = 4096;
    245d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    2464:	8b 45 08             	mov    0x8(%ebp),%eax
    2467:	c1 e0 03             	shl    $0x3,%eax
    246a:	89 04 24             	mov    %eax,(%esp)
    246d:	e8 08 fc ff ff       	call   207a <sbrk>
    2472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    2475:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    2479:	75 07                	jne    2482 <morecore+0x34>
    return 0;
    247b:	b8 00 00 00 00       	mov    $0x0,%eax
    2480:	eb 22                	jmp    24a4 <morecore+0x56>
  hp = (Header*)p;
    2482:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2485:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    2488:	8b 45 f0             	mov    -0x10(%ebp),%eax
    248b:	8b 55 08             	mov    0x8(%ebp),%edx
    248e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    2491:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2494:	83 c0 08             	add    $0x8,%eax
    2497:	89 04 24             	mov    %eax,(%esp)
    249a:	e8 ce fe ff ff       	call   236d <free>
  return freep;
    249f:	a1 48 31 00 00       	mov    0x3148,%eax
}
    24a4:	c9                   	leave  
    24a5:	c3                   	ret    

000024a6 <malloc>:

void*
malloc(uint nbytes)
{
    24a6:	55                   	push   %ebp
    24a7:	89 e5                	mov    %esp,%ebp
    24a9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    24ac:	8b 45 08             	mov    0x8(%ebp),%eax
    24af:	83 c0 07             	add    $0x7,%eax
    24b2:	c1 e8 03             	shr    $0x3,%eax
    24b5:	83 c0 01             	add    $0x1,%eax
    24b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    24bb:	a1 48 31 00 00       	mov    0x3148,%eax
    24c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    24c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    24c7:	75 23                	jne    24ec <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    24c9:	c7 45 f0 40 31 00 00 	movl   $0x3140,-0x10(%ebp)
    24d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    24d3:	a3 48 31 00 00       	mov    %eax,0x3148
    24d8:	a1 48 31 00 00       	mov    0x3148,%eax
    24dd:	a3 40 31 00 00       	mov    %eax,0x3140
    base.s.size = 0;
    24e2:	c7 05 44 31 00 00 00 	movl   $0x0,0x3144
    24e9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    24ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    24ef:	8b 00                	mov    (%eax),%eax
    24f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    24f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24f7:	8b 40 04             	mov    0x4(%eax),%eax
    24fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    24fd:	72 4d                	jb     254c <malloc+0xa6>
      if(p->s.size == nunits)
    24ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2502:	8b 40 04             	mov    0x4(%eax),%eax
    2505:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    2508:	75 0c                	jne    2516 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    250d:	8b 10                	mov    (%eax),%edx
    250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2512:	89 10                	mov    %edx,(%eax)
    2514:	eb 26                	jmp    253c <malloc+0x96>
      else {
        p->s.size -= nunits;
    2516:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2519:	8b 40 04             	mov    0x4(%eax),%eax
    251c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    251f:	89 c2                	mov    %eax,%edx
    2521:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2524:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    2527:	8b 45 f4             	mov    -0xc(%ebp),%eax
    252a:	8b 40 04             	mov    0x4(%eax),%eax
    252d:	c1 e0 03             	shl    $0x3,%eax
    2530:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    2533:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2536:	8b 55 ec             	mov    -0x14(%ebp),%edx
    2539:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    253f:	a3 48 31 00 00       	mov    %eax,0x3148
      return (void*)(p + 1);
    2544:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2547:	83 c0 08             	add    $0x8,%eax
    254a:	eb 38                	jmp    2584 <malloc+0xde>
    }
    if(p == freep)
    254c:	a1 48 31 00 00       	mov    0x3148,%eax
    2551:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    2554:	75 1b                	jne    2571 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    2556:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2559:	89 04 24             	mov    %eax,(%esp)
    255c:	e8 ed fe ff ff       	call   244e <morecore>
    2561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2568:	75 07                	jne    2571 <malloc+0xcb>
        return 0;
    256a:	b8 00 00 00 00       	mov    $0x0,%eax
    256f:	eb 13                	jmp    2584 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2571:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2574:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2577:	8b 45 f4             	mov    -0xc(%ebp),%eax
    257a:	8b 00                	mov    (%eax),%eax
    257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    257f:	e9 70 ff ff ff       	jmp    24f4 <malloc+0x4e>
}
    2584:	c9                   	leave  
    2585:	c3                   	ret    

00002586 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
    2586:	55                   	push   %ebp
    2587:	89 e5                	mov    %esp,%ebp
    2589:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    258c:	e8 21 fb ff ff       	call   20b2 <kthread_mutex_alloc>
    2591:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    2594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2598:	79 07                	jns    25a1 <hoare_cond_alloc+0x1b>
		return 0;
    259a:	b8 00 00 00 00       	mov    $0x0,%eax
    259f:	eb 24                	jmp    25c5 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    25a1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    25a8:	e8 f9 fe ff ff       	call   24a6 <malloc>
    25ad:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    25b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    25b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    25b6:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    25b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    25bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    25c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    25c5:	c9                   	leave  
    25c6:	c3                   	ret    

000025c7 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    25c7:	55                   	push   %ebp
    25c8:	89 e5                	mov    %esp,%ebp
    25ca:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    25cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    25d1:	75 07                	jne    25da <hoare_cond_dealloc+0x13>
			return -1;
    25d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    25d8:	eb 35                	jmp    260f <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    25da:	8b 45 08             	mov    0x8(%ebp),%eax
    25dd:	8b 00                	mov    (%eax),%eax
    25df:	89 04 24             	mov    %eax,(%esp)
    25e2:	e8 e3 fa ff ff       	call   20ca <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    25e7:	8b 45 08             	mov    0x8(%ebp),%eax
    25ea:	8b 00                	mov    (%eax),%eax
    25ec:	89 04 24             	mov    %eax,(%esp)
    25ef:	e8 c6 fa ff ff       	call   20ba <kthread_mutex_dealloc>
    25f4:	85 c0                	test   %eax,%eax
    25f6:	79 07                	jns    25ff <hoare_cond_dealloc+0x38>
			return -1;
    25f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    25fd:	eb 10                	jmp    260f <hoare_cond_dealloc+0x48>

		free (hCond);
    25ff:	8b 45 08             	mov    0x8(%ebp),%eax
    2602:	89 04 24             	mov    %eax,(%esp)
    2605:	e8 63 fd ff ff       	call   236d <free>
		return 0;
    260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    260f:	c9                   	leave  
    2610:	c3                   	ret    

00002611 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    2611:	55                   	push   %ebp
    2612:	89 e5                	mov    %esp,%ebp
    2614:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    2617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    261b:	75 07                	jne    2624 <hoare_cond_wait+0x13>
			return -1;
    261d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2622:	eb 42                	jmp    2666 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    2624:	8b 45 08             	mov    0x8(%ebp),%eax
    2627:	8b 40 04             	mov    0x4(%eax),%eax
    262a:	8d 50 01             	lea    0x1(%eax),%edx
    262d:	8b 45 08             	mov    0x8(%ebp),%eax
    2630:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    2633:	8b 45 08             	mov    0x8(%ebp),%eax
    2636:	8b 00                	mov    (%eax),%eax
    2638:	89 44 24 04          	mov    %eax,0x4(%esp)
    263c:	8b 45 0c             	mov    0xc(%ebp),%eax
    263f:	89 04 24             	mov    %eax,(%esp)
    2642:	e8 8b fa ff ff       	call   20d2 <kthread_mutex_yieldlock>
    2647:	85 c0                	test   %eax,%eax
    2649:	79 16                	jns    2661 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    264b:	8b 45 08             	mov    0x8(%ebp),%eax
    264e:	8b 40 04             	mov    0x4(%eax),%eax
    2651:	8d 50 ff             	lea    -0x1(%eax),%edx
    2654:	8b 45 08             	mov    0x8(%ebp),%eax
    2657:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    265a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    265f:	eb 05                	jmp    2666 <hoare_cond_wait+0x55>
		}

	return 0;
    2661:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2666:	c9                   	leave  
    2667:	c3                   	ret    

00002668 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    2668:	55                   	push   %ebp
    2669:	89 e5                	mov    %esp,%ebp
    266b:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    266e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2672:	75 07                	jne    267b <hoare_cond_signal+0x13>
		return -1;
    2674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2679:	eb 6b                	jmp    26e6 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    267b:	8b 45 08             	mov    0x8(%ebp),%eax
    267e:	8b 40 04             	mov    0x4(%eax),%eax
    2681:	85 c0                	test   %eax,%eax
    2683:	7e 3d                	jle    26c2 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    2685:	8b 45 08             	mov    0x8(%ebp),%eax
    2688:	8b 40 04             	mov    0x4(%eax),%eax
    268b:	8d 50 ff             	lea    -0x1(%eax),%edx
    268e:	8b 45 08             	mov    0x8(%ebp),%eax
    2691:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    2694:	8b 45 08             	mov    0x8(%ebp),%eax
    2697:	8b 00                	mov    (%eax),%eax
    2699:	89 44 24 04          	mov    %eax,0x4(%esp)
    269d:	8b 45 0c             	mov    0xc(%ebp),%eax
    26a0:	89 04 24             	mov    %eax,(%esp)
    26a3:	e8 2a fa ff ff       	call   20d2 <kthread_mutex_yieldlock>
    26a8:	85 c0                	test   %eax,%eax
    26aa:	79 16                	jns    26c2 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    26ac:	8b 45 08             	mov    0x8(%ebp),%eax
    26af:	8b 40 04             	mov    0x4(%eax),%eax
    26b2:	8d 50 01             	lea    0x1(%eax),%edx
    26b5:	8b 45 08             	mov    0x8(%ebp),%eax
    26b8:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    26bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    26c0:	eb 24                	jmp    26e6 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    26c2:	8b 45 08             	mov    0x8(%ebp),%eax
    26c5:	8b 00                	mov    (%eax),%eax
    26c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    26cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    26ce:	89 04 24             	mov    %eax,(%esp)
    26d1:	e8 fc f9 ff ff       	call   20d2 <kthread_mutex_yieldlock>
    26d6:	85 c0                	test   %eax,%eax
    26d8:	79 07                	jns    26e1 <hoare_cond_signal+0x79>

    			return -1;
    26da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    26df:	eb 05                	jmp    26e6 <hoare_cond_signal+0x7e>
    }

	return 0;
    26e1:	b8 00 00 00 00       	mov    $0x0,%eax

}
    26e6:	c9                   	leave  
    26e7:	c3                   	ret    

000026e8 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    26e8:	55                   	push   %ebp
    26e9:	89 e5                	mov    %esp,%ebp
    26eb:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    26ee:	e8 bf f9 ff ff       	call   20b2 <kthread_mutex_alloc>
    26f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    26f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    26fa:	79 07                	jns    2703 <mesa_cond_alloc+0x1b>
		return 0;
    26fc:	b8 00 00 00 00       	mov    $0x0,%eax
    2701:	eb 24                	jmp    2727 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    2703:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    270a:	e8 97 fd ff ff       	call   24a6 <malloc>
    270f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    2712:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2715:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2718:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    271d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    2724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    2727:	c9                   	leave  
    2728:	c3                   	ret    

00002729 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    2729:	55                   	push   %ebp
    272a:	89 e5                	mov    %esp,%ebp
    272c:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    272f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2733:	75 07                	jne    273c <mesa_cond_dealloc+0x13>
		return -1;
    2735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    273a:	eb 35                	jmp    2771 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    273c:	8b 45 08             	mov    0x8(%ebp),%eax
    273f:	8b 00                	mov    (%eax),%eax
    2741:	89 04 24             	mov    %eax,(%esp)
    2744:	e8 81 f9 ff ff       	call   20ca <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    2749:	8b 45 08             	mov    0x8(%ebp),%eax
    274c:	8b 00                	mov    (%eax),%eax
    274e:	89 04 24             	mov    %eax,(%esp)
    2751:	e8 64 f9 ff ff       	call   20ba <kthread_mutex_dealloc>
    2756:	85 c0                	test   %eax,%eax
    2758:	79 07                	jns    2761 <mesa_cond_dealloc+0x38>
		return -1;
    275a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    275f:	eb 10                	jmp    2771 <mesa_cond_dealloc+0x48>

	free (mCond);
    2761:	8b 45 08             	mov    0x8(%ebp),%eax
    2764:	89 04 24             	mov    %eax,(%esp)
    2767:	e8 01 fc ff ff       	call   236d <free>
	return 0;
    276c:	b8 00 00 00 00       	mov    $0x0,%eax

}
    2771:	c9                   	leave  
    2772:	c3                   	ret    

00002773 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    2773:	55                   	push   %ebp
    2774:	89 e5                	mov    %esp,%ebp
    2776:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    2779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    277d:	75 07                	jne    2786 <mesa_cond_wait+0x13>
		return -1;
    277f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2784:	eb 55                	jmp    27db <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    2786:	8b 45 08             	mov    0x8(%ebp),%eax
    2789:	8b 40 04             	mov    0x4(%eax),%eax
    278c:	8d 50 01             	lea    0x1(%eax),%edx
    278f:	8b 45 08             	mov    0x8(%ebp),%eax
    2792:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    2795:	8b 45 0c             	mov    0xc(%ebp),%eax
    2798:	89 04 24             	mov    %eax,(%esp)
    279b:	e8 2a f9 ff ff       	call   20ca <kthread_mutex_unlock>
    27a0:	85 c0                	test   %eax,%eax
    27a2:	79 27                	jns    27cb <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
    27a4:	8b 45 08             	mov    0x8(%ebp),%eax
    27a7:	8b 00                	mov    (%eax),%eax
    27a9:	89 04 24             	mov    %eax,(%esp)
    27ac:	e8 11 f9 ff ff       	call   20c2 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    27b1:	85 c0                	test   %eax,%eax
    27b3:	74 16                	je     27cb <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
	{
		mCond->waitinCount--;
    27b5:	8b 45 08             	mov    0x8(%ebp),%eax
    27b8:	8b 40 04             	mov    0x4(%eax),%eax
    27bb:	8d 50 ff             	lea    -0x1(%eax),%edx
    27be:	8b 45 08             	mov    0x8(%ebp),%eax
    27c1:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    27c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    27c9:	eb 10                	jmp    27db <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    27cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    27ce:	89 04 24             	mov    %eax,(%esp)
    27d1:	e8 ec f8 ff ff       	call   20c2 <kthread_mutex_lock>
	return 0;
    27d6:	b8 00 00 00 00       	mov    $0x0,%eax


}
    27db:	c9                   	leave  
    27dc:	c3                   	ret    

000027dd <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    27dd:	55                   	push   %ebp
    27de:	89 e5                	mov    %esp,%ebp
    27e0:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    27e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    27e7:	75 07                	jne    27f0 <mesa_cond_signal+0x13>
		return -1;
    27e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    27ee:	eb 5d                	jmp    284d <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    27f0:	8b 45 08             	mov    0x8(%ebp),%eax
    27f3:	8b 40 04             	mov    0x4(%eax),%eax
    27f6:	85 c0                	test   %eax,%eax
    27f8:	7e 36                	jle    2830 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    27fa:	8b 45 08             	mov    0x8(%ebp),%eax
    27fd:	8b 40 04             	mov    0x4(%eax),%eax
    2800:	8d 50 ff             	lea    -0x1(%eax),%edx
    2803:	8b 45 08             	mov    0x8(%ebp),%eax
    2806:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    2809:	8b 45 08             	mov    0x8(%ebp),%eax
    280c:	8b 00                	mov    (%eax),%eax
    280e:	89 04 24             	mov    %eax,(%esp)
    2811:	e8 b4 f8 ff ff       	call   20ca <kthread_mutex_unlock>
    2816:	85 c0                	test   %eax,%eax
    2818:	78 16                	js     2830 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    281a:	8b 45 08             	mov    0x8(%ebp),%eax
    281d:	8b 40 04             	mov    0x4(%eax),%eax
    2820:	8d 50 01             	lea    0x1(%eax),%edx
    2823:	8b 45 08             	mov    0x8(%ebp),%eax
    2826:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    2829:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    282e:	eb 1d                	jmp    284d <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    2830:	8b 45 08             	mov    0x8(%ebp),%eax
    2833:	8b 00                	mov    (%eax),%eax
    2835:	89 04 24             	mov    %eax,(%esp)
    2838:	e8 8d f8 ff ff       	call   20ca <kthread_mutex_unlock>
    283d:	85 c0                	test   %eax,%eax
    283f:	79 07                	jns    2848 <mesa_cond_signal+0x6b>

		return -1;
    2841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2846:	eb 05                	jmp    284d <mesa_cond_signal+0x70>
	}
	return 0;
    2848:	b8 00 00 00 00       	mov    $0x0,%eax

}
    284d:	c9                   	leave  
    284e:	c3                   	ret    
