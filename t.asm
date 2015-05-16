
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
       7:	a1 f0 37 00 00       	mov    0x37f0,%eax
       c:	89 04 24             	mov    %eax,(%esp)
       f:	e8 a2 20 00 00       	call   20b6 <kthread_mutex_lock>
      14:	83 f8 ff             	cmp    $0xffffffff,%eax
      17:	75 5a                	jne    73 <safeThread+0x73>
      19:	c7 44 24 0c 21 00 00 	movl   $0x21,0xc(%esp)
      20:	00 
      21:	c7 44 24 08 f1 30 00 	movl   $0x30f1,0x8(%esp)
      28:	00 
      29:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
      30:	00 
      31:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      38:	e8 71 21 00 00       	call   21ae <printf>
      3d:	a1 f0 37 00 00       	mov    0x37f0,%eax
      42:	89 44 24 08          	mov    %eax,0x8(%esp)
      46:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
      4d:	00 
      4e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      55:	e8 54 21 00 00       	call   21ae <printf>
      5a:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
      61:	00 
      62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      69:	e8 40 21 00 00       	call   21ae <printf>
      6e:	e8 73 1f 00 00       	call   1fe6 <exit>

  resource1[0] = kthread_id();
      73:	e8 16 20 00 00       	call   208e <kthread_id>
      78:	a3 a0 37 00 00       	mov    %eax,0x37a0
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
      97:	e8 da 1f 00 00       	call   2076 <sleep>
    resource1[i] = resource1[i-1];
      9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
      9f:	83 e8 01             	sub    $0x1,%eax
      a2:	8b 14 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%edx
      a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
      ac:	89 14 85 a0 37 00 00 	mov    %edx,0x37a0(,%eax,4)

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
      bd:	e8 cc 1f 00 00       	call   208e <kthread_id>
      c2:	99                   	cltd   
      c3:	c1 ea 1f             	shr    $0x1f,%edx
      c6:	01 d0                	add    %edx,%eax
      c8:	83 e0 01             	and    $0x1,%eax
      cb:	29 d0                	sub    %edx,%eax
      cd:	89 04 24             	mov    %eax,(%esp)
      d0:	e8 a1 1f 00 00       	call   2076 <sleep>
  ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id:%d) fail", i, kthread_id());
      d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d8:	83 e8 01             	sub    $0x1,%eax
      db:	8b 1c 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%ebx
      e2:	e8 a7 1f 00 00       	call   208e <kthread_id>
      e7:	39 c3                	cmp    %eax,%ebx
      e9:	74 61                	je     14c <safeThread+0x14c>
      eb:	c7 44 24 0c 29 00 00 	movl   $0x29,0xc(%esp)
      f2:	00 
      f3:	c7 44 24 08 f1 30 00 	movl   $0x30f1,0x8(%esp)
      fa:	00 
      fb:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     102:	00 
     103:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     10a:	e8 9f 20 00 00       	call   21ae <printf>
     10f:	e8 7a 1f 00 00       	call   208e <kthread_id>
     114:	89 44 24 0c          	mov    %eax,0xc(%esp)
     118:	8b 45 f4             	mov    -0xc(%ebp),%eax
     11b:	89 44 24 08          	mov    %eax,0x8(%esp)
     11f:	c7 44 24 04 78 2d 00 	movl   $0x2d78,0x4(%esp)
     126:	00 
     127:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     12e:	e8 7b 20 00 00       	call   21ae <printf>
     133:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     13a:	00 
     13b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     142:	e8 67 20 00 00       	call   21ae <printf>
     147:	e8 9a 1e 00 00       	call   1fe6 <exit>

  ASSERT((kthread_mutex_unlock(mutex1) == -1), "kthread_mutex_unlock(%d) fail", mutex1);
     14c:	a1 f0 37 00 00       	mov    0x37f0,%eax
     151:	89 04 24             	mov    %eax,(%esp)
     154:	e8 65 1f 00 00       	call   20be <kthread_mutex_unlock>
     159:	83 f8 ff             	cmp    $0xffffffff,%eax
     15c:	75 5a                	jne    1b8 <safeThread+0x1b8>
     15e:	c7 44 24 0c 2b 00 00 	movl   $0x2b,0xc(%esp)
     165:	00 
     166:	c7 44 24 08 f1 30 00 	movl   $0x30f1,0x8(%esp)
     16d:	00 
     16e:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     175:	00 
     176:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     17d:	e8 2c 20 00 00       	call   21ae <printf>
     182:	a1 f0 37 00 00       	mov    0x37f0,%eax
     187:	89 44 24 08          	mov    %eax,0x8(%esp)
     18b:	c7 44 24 04 9e 2d 00 	movl   $0x2d9e,0x4(%esp)
     192:	00 
     193:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     19a:	e8 0f 20 00 00       	call   21ae <printf>
     19f:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     1a6:	00 
     1a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1ae:	e8 fb 1f 00 00       	call   21ae <printf>
     1b3:	e8 2e 1e 00 00       	call   1fe6 <exit>

  /* part two - mutual calculation */
  ASSERT((kthread_mutex_lock(mutex2) == -1), "kthread_mutex_lock(%d) fail", mutex2);
     1b8:	a1 80 37 00 00       	mov    0x3780,%eax
     1bd:	89 04 24             	mov    %eax,(%esp)
     1c0:	e8 f1 1e 00 00       	call   20b6 <kthread_mutex_lock>
     1c5:	83 f8 ff             	cmp    $0xffffffff,%eax
     1c8:	75 5a                	jne    224 <safeThread+0x224>
     1ca:	c7 44 24 0c 2e 00 00 	movl   $0x2e,0xc(%esp)
     1d1:	00 
     1d2:	c7 44 24 08 f1 30 00 	movl   $0x30f1,0x8(%esp)
     1d9:	00 
     1da:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     1e1:	00 
     1e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1e9:	e8 c0 1f 00 00       	call   21ae <printf>
     1ee:	a1 80 37 00 00       	mov    0x3780,%eax
     1f3:	89 44 24 08          	mov    %eax,0x8(%esp)
     1f7:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
     1fe:	00 
     1ff:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     206:	e8 a3 1f 00 00       	call   21ae <printf>
     20b:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     212:	00 
     213:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21a:	e8 8f 1f 00 00       	call   21ae <printf>
     21f:	e8 c2 1d 00 00       	call   1fe6 <exit>
  sleep(kthread_id() % 2);   // make some more troubles
     224:	e8 65 1e 00 00       	call   208e <kthread_id>
     229:	99                   	cltd   
     22a:	c1 ea 1f             	shr    $0x1f,%edx
     22d:	01 d0                	add    %edx,%eax
     22f:	83 e0 01             	and    $0x1,%eax
     232:	29 d0                	sub    %edx,%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 3a 1e 00 00       	call   2076 <sleep>
  resource2 = resource2 + kthread_id();
     23c:	e8 4d 1e 00 00       	call   208e <kthread_id>
     241:	8b 15 84 37 00 00    	mov    0x3784,%edx
     247:	01 d0                	add    %edx,%eax
     249:	a3 84 37 00 00       	mov    %eax,0x3784
  ASSERT((kthread_mutex_unlock(mutex2) == -1), "kthread_mutex_unlock(%d) fail", mutex2);
     24e:	a1 80 37 00 00       	mov    0x3780,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 63 1e 00 00       	call   20be <kthread_mutex_unlock>
     25b:	83 f8 ff             	cmp    $0xffffffff,%eax
     25e:	75 5a                	jne    2ba <safeThread+0x2ba>
     260:	c7 44 24 0c 31 00 00 	movl   $0x31,0xc(%esp)
     267:	00 
     268:	c7 44 24 08 f1 30 00 	movl   $0x30f1,0x8(%esp)
     26f:	00 
     270:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     277:	00 
     278:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     27f:	e8 2a 1f 00 00       	call   21ae <printf>
     284:	a1 80 37 00 00       	mov    0x3780,%eax
     289:	89 44 24 08          	mov    %eax,0x8(%esp)
     28d:	c7 44 24 04 9e 2d 00 	movl   $0x2d9e,0x4(%esp)
     294:	00 
     295:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     29c:	e8 0d 1f 00 00       	call   21ae <printf>
     2a1:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     2a8:	00 
     2a9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     2b0:	e8 f9 1e 00 00       	call   21ae <printf>
     2b5:	e8 2c 1d 00 00       	call   1fe6 <exit>

  kthread_exit();
     2ba:	e8 d7 1d 00 00       	call   2096 <kthread_exit>
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
     2d0:	e8 b9 1d 00 00       	call   208e <kthread_id>
     2d5:	a3 a0 37 00 00       	mov    %eax,0x37a0
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
     2f4:	e8 7d 1d 00 00       	call   2076 <sleep>
    resource1[i] = resource1[i-1];
     2f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2fc:	83 e8 01             	sub    $0x1,%eax
     2ff:	8b 14 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%edx
     306:	8b 45 f4             	mov    -0xc(%ebp),%eax
     309:	89 14 85 a0 37 00 00 	mov    %edx,0x37a0(,%eax,4)

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
     31a:	e8 6f 1d 00 00       	call   208e <kthread_id>
     31f:	89 04 24             	mov    %eax,(%esp)
     322:	e8 4f 1d 00 00       	call   2076 <sleep>
  //ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id()) fail", i);

  resource2 = resource2 + resource1[i-1];
     327:	8b 45 f4             	mov    -0xc(%ebp),%eax
     32a:	83 e8 01             	sub    $0x1,%eax
     32d:	8b 14 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%edx
     334:	a1 84 37 00 00       	mov    0x3784,%eax
     339:	01 d0                	add    %edx,%eax
     33b:	a3 84 37 00 00       	mov    %eax,0x3784

  kthread_exit();
     340:	e8 51 1d 00 00       	call   2096 <kthread_exit>
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
     39e:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     3a5:	00 
     3a6:	c7 44 24 04 bc 2d 00 	movl   $0x2dbc,0x4(%esp)
     3ad:	00 
     3ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3b5:	e8 f4 1d 00 00       	call   21ae <printf>

  for (i = 0 ; i < 20; i++)
     3ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c1:	eb 12                	jmp    3d5 <stressTest1+0x84>
    resource1[i] = 0;
     3c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3c6:	c7 04 85 a0 37 00 00 	movl   $0x0,0x37a0(,%eax,4)
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
     3db:	c7 05 84 37 00 00 00 	movl   $0x0,0x3784
     3e2:	00 00 00 
  mutex1 = kthread_mutex_alloc();
     3e5:	e8 bc 1c 00 00       	call   20a6 <kthread_mutex_alloc>
     3ea:	a3 f0 37 00 00       	mov    %eax,0x37f0
  mutex2 = kthread_mutex_alloc();
     3ef:	e8 b2 1c 00 00       	call   20a6 <kthread_mutex_alloc>
     3f4:	a3 80 37 00 00       	mov    %eax,0x3780
  ASSERT((mutex1 == mutex2), "(mutex1 == mutex2)");
     3f9:	8b 15 f0 37 00 00    	mov    0x37f0,%edx
     3ff:	a1 80 37 00 00       	mov    0x3780,%eax
     404:	39 c2                	cmp    %eax,%edx
     406:	75 51                	jne    459 <stressTest1+0x108>
     408:	c7 44 24 0c 5a 00 00 	movl   $0x5a,0xc(%esp)
     40f:	00 
     410:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     417:	00 
     418:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     41f:	00 
     420:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     427:	e8 82 1d 00 00       	call   21ae <printf>
     42c:	c7 44 24 04 ce 2d 00 	movl   $0x2dce,0x4(%esp)
     433:	00 
     434:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     43b:	e8 6e 1d 00 00       	call   21ae <printf>
     440:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     447:	00 
     448:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     44f:	e8 5a 1d 00 00       	call   21ae <printf>
     454:	e8 8d 1b 00 00       	call   1fe6 <exit>

  for (i = 0 ; i < count; i++){
     459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     460:	e9 d0 00 00 00       	jmp    535 <stressTest1+0x1e4>
    stack = malloc(STACK_SIZE);
     465:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     46c:	e8 29 20 00 00       	call   249a <malloc>
     471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    tid[i] = kthread_create(&safeThread, stack+STACK_SIZE, STACK_SIZE);
     474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     477:	05 e8 03 00 00       	add    $0x3e8,%eax
     47c:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     483:	00 
     484:	89 44 24 04          	mov    %eax,0x4(%esp)
     488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     48f:	e8 f2 1b 00 00       	call   2086 <kthread_create>
     494:	8b 55 e8             	mov    -0x18(%ebp),%edx
     497:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     49a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     49d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     4a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4a3:	8b 04 90             	mov    (%eax,%edx,4),%eax
     4a6:	85 c0                	test   %eax,%eax
     4a8:	7f 65                	jg     50f <stressTest1+0x1be>
     4aa:	c7 44 24 0c 5f 00 00 	movl   $0x5f,0xc(%esp)
     4b1:	00 
     4b2:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     4b9:	00 
     4ba:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     4c1:	00 
     4c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4c9:	e8 e0 1c 00 00       	call   21ae <printf>
     4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
     4d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d4:	8b 04 90             	mov    (%eax,%edx,4),%eax
     4d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4da:	89 54 24 0c          	mov    %edx,0xc(%esp)
     4de:	89 44 24 08          	mov    %eax,0x8(%esp)
     4e2:	c7 44 24 04 e4 2d 00 	movl   $0x2de4,0x4(%esp)
     4e9:	00 
     4ea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4f1:	e8 b8 1c 00 00       	call   21ae <printf>
     4f6:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     4fd:	00 
     4fe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     505:	e8 a4 1c 00 00       	call   21ae <printf>
     50a:	e8 d7 1a 00 00       	call   1fe6 <exit>
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
     52c:	e8 45 1b 00 00       	call   2076 <sleep>
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
     559:	e8 40 1b 00 00       	call   209e <kthread_join>
     55e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
     561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     565:	74 65                	je     5cc <stressTest1+0x27b>
     567:	c7 44 24 0c 67 00 00 	movl   $0x67,0xc(%esp)
     56e:	00 
     56f:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     576:	00 
     577:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     57e:	00 
     57f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     586:	e8 23 1c 00 00       	call   21ae <printf>
     58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     58e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     591:	8b 04 90             	mov    (%eax,%edx,4),%eax
     594:	8b 55 e0             	mov    -0x20(%ebp),%edx
     597:	89 54 24 0c          	mov    %edx,0xc(%esp)
     59b:	89 44 24 08          	mov    %eax,0x8(%esp)
     59f:	c7 44 24 04 14 2e 00 	movl   $0x2e14,0x4(%esp)
     5a6:	00 
     5a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5ae:	e8 fb 1b 00 00       	call   21ae <printf>
     5b3:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     5ba:	00 
     5bb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5c2:	e8 e7 1b 00 00       	call   21ae <printf>
     5c7:	e8 1a 1a 00 00       	call   1fe6 <exit>
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
     5dc:	a1 f0 37 00 00       	mov    0x37f0,%eax
     5e1:	89 04 24             	mov    %eax,(%esp)
     5e4:	e8 c5 1a 00 00       	call   20ae <kthread_mutex_dealloc>
     5e9:	85 c0                	test   %eax,%eax
     5eb:	74 51                	je     63e <stressTest1+0x2ed>
     5ed:	c7 44 24 0c 6b 00 00 	movl   $0x6b,0xc(%esp)
     5f4:	00 
     5f5:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     5fc:	00 
     5fd:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     604:	00 
     605:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     60c:	e8 9d 1b 00 00       	call   21ae <printf>
     611:	c7 44 24 04 35 2e 00 	movl   $0x2e35,0x4(%esp)
     618:	00 
     619:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     620:	e8 89 1b 00 00       	call   21ae <printf>
     625:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     62c:	00 
     62d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     634:	e8 75 1b 00 00       	call   21ae <printf>
     639:	e8 a8 19 00 00       	call   1fe6 <exit>
  ASSERT( (kthread_mutex_dealloc(mutex2) != 0), "dealloc");
     63e:	a1 80 37 00 00       	mov    0x3780,%eax
     643:	89 04 24             	mov    %eax,(%esp)
     646:	e8 63 1a 00 00       	call   20ae <kthread_mutex_dealloc>
     64b:	85 c0                	test   %eax,%eax
     64d:	74 51                	je     6a0 <stressTest1+0x34f>
     64f:	c7 44 24 0c 6c 00 00 	movl   $0x6c,0xc(%esp)
     656:	00 
     657:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     65e:	00 
     65f:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     666:	00 
     667:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     66e:	e8 3b 1b 00 00       	call   21ae <printf>
     673:	c7 44 24 04 35 2e 00 	movl   $0x2e35,0x4(%esp)
     67a:	00 
     67b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     682:	e8 27 1b 00 00       	call   21ae <printf>
     687:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     68e:	00 
     68f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     696:	e8 13 1b 00 00       	call   21ae <printf>
     69b:	e8 46 19 00 00       	call   1fe6 <exit>

  ASSERT((c != resource2), "(c != resource2) : (%d != %d)" , c, resource2);
     6a0:	a1 84 37 00 00       	mov    0x3784,%eax
     6a5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     6a8:	74 61                	je     70b <stressTest1+0x3ba>
     6aa:	c7 44 24 0c 6e 00 00 	movl   $0x6e,0xc(%esp)
     6b1:	00 
     6b2:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     6b9:	00 
     6ba:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     6c1:	00 
     6c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6c9:	e8 e0 1a 00 00       	call   21ae <printf>
     6ce:	a1 84 37 00 00       	mov    0x3784,%eax
     6d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     6d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6da:	89 44 24 08          	mov    %eax,0x8(%esp)
     6de:	c7 44 24 04 3d 2e 00 	movl   $0x2e3d,0x4(%esp)
     6e5:	00 
     6e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6ed:	e8 bc 1a 00 00       	call   21ae <printf>
     6f2:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     6f9:	00 
     6fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     701:	e8 a8 1a 00 00       	call   21ae <printf>
     706:	e8 db 18 00 00       	call   1fe6 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
     70b:	c7 44 24 08 fc 30 00 	movl   $0x30fc,0x8(%esp)
     712:	00 
     713:	c7 44 24 04 5b 2e 00 	movl   $0x2e5b,0x4(%esp)
     71a:	00 
     71b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     722:	e8 87 1a 00 00       	call   21ae <printf>
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
     77d:	c7 44 24 08 08 31 00 	movl   $0x3108,0x8(%esp)
     784:	00 
     785:	c7 44 24 04 bc 2d 00 	movl   $0x2dbc,0x4(%esp)
     78c:	00 
     78d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     794:	e8 15 1a 00 00       	call   21ae <printf>

  for (i = 0 ; i < 20; i++)
     799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7a0:	eb 12                	jmp    7b4 <stressTest2Fail+0x84>
    resource1[i] = 0;
     7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a5:	c7 04 85 a0 37 00 00 	movl   $0x0,0x37a0(,%eax,4)
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
     7ba:	c7 05 84 37 00 00 00 	movl   $0x0,0x3784
     7c1:	00 00 00 

  for (i = 0 ; i < count; i++){
     7c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7cb:	e9 df 00 00 00       	jmp    8af <stressTest2Fail+0x17f>
    stack = malloc(STACK_SIZE);
     7d0:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     7d7:	e8 be 1c 00 00       	call   249a <malloc>
     7dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    tid[i] = kthread_create(&unsafeThread, stack+STACK_SIZE, STACK_SIZE);
     7df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7e2:	05 e8 03 00 00       	add    $0x3e8,%eax
     7e7:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     7ee:	00 
     7ef:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f3:	c7 04 24 ca 02 00 00 	movl   $0x2ca,(%esp)
     7fa:	e8 87 18 00 00       	call   2086 <kthread_create>
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
     828:	e8 49 18 00 00       	call   2076 <sleep>
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     830:	8b 55 f4             	mov    -0xc(%ebp),%edx
     833:	8b 04 90             	mov    (%eax,%edx,4),%eax
     836:	85 c0                	test   %eax,%eax
     838:	7f 65                	jg     89f <stressTest2Fail+0x16f>
     83a:	c7 44 24 0c 85 00 00 	movl   $0x85,0xc(%esp)
     841:	00 
     842:	c7 44 24 08 08 31 00 	movl   $0x3108,0x8(%esp)
     849:	00 
     84a:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     851:	00 
     852:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     859:	e8 50 19 00 00       	call   21ae <printf>
     85e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     861:	8b 55 f4             	mov    -0xc(%ebp),%edx
     864:	8b 04 90             	mov    (%eax,%edx,4),%eax
     867:	8b 55 f4             	mov    -0xc(%ebp),%edx
     86a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     86e:	89 44 24 08          	mov    %eax,0x8(%esp)
     872:	c7 44 24 04 e4 2d 00 	movl   $0x2de4,0x4(%esp)
     879:	00 
     87a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     881:	e8 28 19 00 00       	call   21ae <printf>
     886:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     88d:	00 
     88e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     895:	e8 14 19 00 00       	call   21ae <printf>
     89a:	e8 47 17 00 00       	call   1fe6 <exit>
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
     8d3:	e8 c6 17 00 00       	call   209e <kthread_join>
     8d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
     8db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     8df:	74 65                	je     946 <stressTest2Fail+0x216>
     8e1:	c7 44 24 0c 8c 00 00 	movl   $0x8c,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 08 31 00 	movl   $0x3108,0x8(%esp)
     8f0:	00 
     8f1:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     8f8:	00 
     8f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     900:	e8 a9 18 00 00       	call   21ae <printf>
     905:	8b 45 e8             	mov    -0x18(%ebp),%eax
     908:	8b 55 f4             	mov    -0xc(%ebp),%edx
     90b:	8b 04 90             	mov    (%eax,%edx,4),%eax
     90e:	8b 55 e0             	mov    -0x20(%ebp),%edx
     911:	89 54 24 0c          	mov    %edx,0xc(%esp)
     915:	89 44 24 08          	mov    %eax,0x8(%esp)
     919:	c7 44 24 04 14 2e 00 	movl   $0x2e14,0x4(%esp)
     920:	00 
     921:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     928:	e8 81 18 00 00       	call   21ae <printf>
     92d:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     934:	00 
     935:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     93c:	e8 6d 18 00 00       	call   21ae <printf>
     941:	e8 a0 16 00 00       	call   1fe6 <exit>
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
     956:	a1 84 37 00 00       	mov    0x3784,%eax
     95b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     95e:	75 61                	jne    9c1 <stressTest2Fail+0x291>
     960:	c7 44 24 0c 8f 00 00 	movl   $0x8f,0xc(%esp)
     967:	00 
     968:	c7 44 24 08 08 31 00 	movl   $0x3108,0x8(%esp)
     96f:	00 
     970:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     977:	00 
     978:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     97f:	e8 2a 18 00 00       	call   21ae <printf>
     984:	a1 84 37 00 00       	mov    0x3784,%eax
     989:	89 44 24 0c          	mov    %eax,0xc(%esp)
     98d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     990:	89 44 24 08          	mov    %eax,0x8(%esp)
     994:	c7 44 24 04 6c 2e 00 	movl   $0x2e6c,0x4(%esp)
     99b:	00 
     99c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9a3:	e8 06 18 00 00       	call   21ae <printf>
     9a8:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     9af:	00 
     9b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9b7:	e8 f2 17 00 00       	call   21ae <printf>
     9bc:	e8 25 16 00 00       	call   1fe6 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
     9c1:	c7 44 24 08 08 31 00 	movl   $0x3108,0x8(%esp)
     9c8:	00 
     9c9:	c7 44 24 04 5b 2e 00 	movl   $0x2e5b,0x4(%esp)
     9d0:	00 
     9d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9d8:	e8 d1 17 00 00       	call   21ae <printf>
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
     a29:	c7 44 24 08 18 31 00 	movl   $0x3118,0x8(%esp)
     a30:	00 
     a31:	c7 44 24 04 bc 2d 00 	movl   $0x2dbc,0x4(%esp)
     a38:	00 
     a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a40:	e8 69 17 00 00       	call   21ae <printf>

  for (i = 0 ; i < count; i++){
     a45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a4c:	e9 ae 00 00 00       	jmp    aff <stressTest3toMuchTreads+0x119>
    stack = malloc(STACK_SIZE);
     a51:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     a58:	e8 3d 1a 00 00       	call   249a <malloc>
     a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    tid[i] = kthread_create(&loopThread, stack+STACK_SIZE, STACK_SIZE);
     a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a63:	05 e8 03 00 00       	add    $0x3e8,%eax
     a68:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
     a6f:	00 
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	c7 04 24 4c 03 00 00 	movl   $0x34c,(%esp)
     a7b:	e8 06 16 00 00       	call   2086 <kthread_create>
     a80:	8b 55 e8             	mov    -0x18(%ebp),%edx
     a83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a86:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    ASSERT((tid[i] <= 0), "kthread_create return with: %d, for index:%d", tid[i], i);
     a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a8f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a92:	85 c0                	test   %eax,%eax
     a94:	7f 65                	jg     afb <stressTest3toMuchTreads+0x115>
     a96:	c7 44 24 0c a0 00 00 	movl   $0xa0,0xc(%esp)
     a9d:	00 
     a9e:	c7 44 24 08 18 31 00 	movl   $0x3118,0x8(%esp)
     aa5:	00 
     aa6:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     aad:	00 
     aae:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ab5:	e8 f4 16 00 00       	call   21ae <printf>
     aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
     abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac0:	8b 04 90             	mov    (%eax,%edx,4),%eax
     ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac6:	89 54 24 0c          	mov    %edx,0xc(%esp)
     aca:	89 44 24 08          	mov    %eax,0x8(%esp)
     ace:	c7 44 24 04 e4 2d 00 	movl   $0x2de4,0x4(%esp)
     ad5:	00 
     ad6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     add:	e8 cc 16 00 00       	call   21ae <printf>
     ae2:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     ae9:	00 
     aea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     af1:	e8 b8 16 00 00       	call   21ae <printf>
     af6:	e8 eb 14 00 00       	call   1fe6 <exit>
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
     b26:	e8 5b 15 00 00       	call   2086 <kthread_create>
     b2b:	85 c0                	test   %eax,%eax
     b2d:	78 1e                	js     b4d <stressTest3toMuchTreads+0x167>
    printf(1, "%s test FAIL!\n", __FUNCTION__);
     b2f:	c7 44 24 08 18 31 00 	movl   $0x3118,0x8(%esp)
     b36:	00 
     b37:	c7 44 24 04 a4 2e 00 	movl   $0x2ea4,0x4(%esp)
     b3e:	00 
     b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b46:	e8 63 16 00 00       	call   21ae <printf>
     b4b:	eb 1c                	jmp    b69 <stressTest3toMuchTreads+0x183>
  } else {
    printf(1, "%s test PASS!\n", __FUNCTION__);
     b4d:	c7 44 24 08 18 31 00 	movl   $0x3118,0x8(%esp)
     b54:	00 
     b55:	c7 44 24 04 5b 2e 00 	movl   $0x2e5b,0x4(%esp)
     b5c:	00 
     b5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b64:	e8 45 16 00 00       	call   21ae <printf>
  }

  // the threads do not kill themself
  exit();
     b69:	e8 78 14 00 00       	call   1fe6 <exit>

00000b6e <yieldThread>:

}

void* yieldThread(){
     b6e:	55                   	push   %ebp
     b6f:	89 e5                	mov    %esp,%ebp
     b71:	53                   	push   %ebx
     b72:	83 ec 24             	sub    $0x24,%esp
  int i;

  sleep(kthread_id() % 3);  // change the order of the waiters threads
     b75:	e8 14 15 00 00       	call   208e <kthread_id>
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
     b99:	e8 d8 14 00 00       	call   2076 <sleep>

  /* part one use mutual array of resources */
  ASSERT((kthread_mutex_lock(mutex2) == -1), "kthread_mutex_lock(%d) fail", mutex2);
     b9e:	a1 80 37 00 00       	mov    0x3780,%eax
     ba3:	89 04 24             	mov    %eax,(%esp)
     ba6:	e8 0b 15 00 00       	call   20b6 <kthread_mutex_lock>
     bab:	83 f8 ff             	cmp    $0xffffffff,%eax
     bae:	75 5a                	jne    c0a <yieldThread+0x9c>
     bb0:	c7 44 24 0c b4 00 00 	movl   $0xb4,0xc(%esp)
     bb7:	00 
     bb8:	c7 44 24 08 30 31 00 	movl   $0x3130,0x8(%esp)
     bbf:	00 
     bc0:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     bc7:	00 
     bc8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     bcf:	e8 da 15 00 00       	call   21ae <printf>
     bd4:	a1 80 37 00 00       	mov    0x3780,%eax
     bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bdd:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
     be4:	00 
     be5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     bec:	e8 bd 15 00 00       	call   21ae <printf>
     bf1:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     bf8:	00 
     bf9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c00:	e8 a9 15 00 00       	call   21ae <printf>
     c05:	e8 dc 13 00 00       	call   1fe6 <exit>

  resource1[0] = kthread_id();
     c0a:	e8 7f 14 00 00       	call   208e <kthread_id>
     c0f:	a3 a0 37 00 00       	mov    %eax,0x37a0
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
     c2e:	e8 43 14 00 00       	call   2076 <sleep>
    resource1[i] = resource1[i-1];
     c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c36:	83 e8 01             	sub    $0x1,%eax
     c39:	8b 14 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%edx
     c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c43:	89 14 85 a0 37 00 00 	mov    %edx,0x37a0(,%eax,4)

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
     c54:	e8 35 14 00 00       	call   208e <kthread_id>
     c59:	99                   	cltd   
     c5a:	c1 ea 1f             	shr    $0x1f,%edx
     c5d:	01 d0                	add    %edx,%eax
     c5f:	83 e0 01             	and    $0x1,%eax
     c62:	29 d0                	sub    %edx,%eax
     c64:	89 04 24             	mov    %eax,(%esp)
     c67:	e8 0a 14 00 00       	call   2076 <sleep>
  ASSERT((resource1[i-1] != kthread_id()), "(resource1[%d] != kthread_id:%d) fail", i, kthread_id());
     c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6f:	83 e8 01             	sub    $0x1,%eax
     c72:	8b 1c 85 a0 37 00 00 	mov    0x37a0(,%eax,4),%ebx
     c79:	e8 10 14 00 00       	call   208e <kthread_id>
     c7e:	39 c3                	cmp    %eax,%ebx
     c80:	74 61                	je     ce3 <yieldThread+0x175>
     c82:	c7 44 24 0c bc 00 00 	movl   $0xbc,0xc(%esp)
     c89:	00 
     c8a:	c7 44 24 08 30 31 00 	movl   $0x3130,0x8(%esp)
     c91:	00 
     c92:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     c99:	00 
     c9a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ca1:	e8 08 15 00 00       	call   21ae <printf>
     ca6:	e8 e3 13 00 00       	call   208e <kthread_id>
     cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
     caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
     cb6:	c7 44 24 04 78 2d 00 	movl   $0x2d78,0x4(%esp)
     cbd:	00 
     cbe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     cc5:	e8 e4 14 00 00       	call   21ae <printf>
     cca:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     cd1:	00 
     cd2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     cd9:	e8 d0 14 00 00       	call   21ae <printf>
     cde:	e8 03 13 00 00       	call   1fe6 <exit>

  /* part two - mutual calculation */
  sleep(kthread_id() % 2);   // make some more troubles
     ce3:	e8 a6 13 00 00       	call   208e <kthread_id>
     ce8:	99                   	cltd   
     ce9:	c1 ea 1f             	shr    $0x1f,%edx
     cec:	01 d0                	add    %edx,%eax
     cee:	83 e0 01             	and    $0x1,%eax
     cf1:	29 d0                	sub    %edx,%eax
     cf3:	89 04 24             	mov    %eax,(%esp)
     cf6:	e8 7b 13 00 00       	call   2076 <sleep>
  resource2 = resource2 + kthread_id();
     cfb:	e8 8e 13 00 00       	call   208e <kthread_id>
     d00:	8b 15 84 37 00 00    	mov    0x3784,%edx
     d06:	01 d0                	add    %edx,%eax
     d08:	a3 84 37 00 00       	mov    %eax,0x3784

  // pass the mutex to the next thread
  ASSERT((kthread_mutex_yieldlock(mutex1, mutex2) != 0), "mutex yield");
     d0d:	8b 15 80 37 00 00    	mov    0x3780,%edx
     d13:	a1 f0 37 00 00       	mov    0x37f0,%eax
     d18:	89 54 24 04          	mov    %edx,0x4(%esp)
     d1c:	89 04 24             	mov    %eax,(%esp)
     d1f:	e8 a2 13 00 00       	call   20c6 <kthread_mutex_yieldlock>
     d24:	85 c0                	test   %eax,%eax
     d26:	74 51                	je     d79 <yieldThread+0x20b>
     d28:	c7 44 24 0c c3 00 00 	movl   $0xc3,0xc(%esp)
     d2f:	00 
     d30:	c7 44 24 08 30 31 00 	movl   $0x3130,0x8(%esp)
     d37:	00 
     d38:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     d3f:	00 
     d40:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d47:	e8 62 14 00 00       	call   21ae <printf>
     d4c:	c7 44 24 04 b3 2e 00 	movl   $0x2eb3,0x4(%esp)
     d53:	00 
     d54:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d5b:	e8 4e 14 00 00       	call   21ae <printf>
     d60:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     d67:	00 
     d68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d6f:	e8 3a 14 00 00       	call   21ae <printf>
     d74:	e8 6d 12 00 00       	call   1fe6 <exit>


  kthread_exit();
     d79:	e8 18 13 00 00       	call   2096 <kthread_exit>
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
     d8f:	a1 f0 37 00 00       	mov    0x37f0,%eax
     d94:	89 04 24             	mov    %eax,(%esp)
     d97:	e8 1a 13 00 00       	call   20b6 <kthread_mutex_lock>
     d9c:	83 f8 ff             	cmp    $0xffffffff,%eax
     d9f:	75 5a                	jne    dfb <trubleThread+0x72>
     da1:	c7 44 24 0c cc 00 00 	movl   $0xcc,0xc(%esp)
     da8:	00 
     da9:	c7 44 24 08 3c 31 00 	movl   $0x313c,0x8(%esp)
     db0:	00 
     db1:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     db8:	00 
     db9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     dc0:	e8 e9 13 00 00       	call   21ae <printf>
     dc5:	a1 f0 37 00 00       	mov    0x37f0,%eax
     dca:	89 44 24 08          	mov    %eax,0x8(%esp)
     dce:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
     dd5:	00 
     dd6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ddd:	e8 cc 13 00 00       	call   21ae <printf>
     de2:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     de9:	00 
     dea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     df1:	e8 b8 13 00 00       	call   21ae <printf>
     df6:	e8 eb 11 00 00       	call   1fe6 <exit>
  resource2 = -10;
     dfb:	c7 05 84 37 00 00 f6 	movl   $0xfffffff6,0x3784
     e02:	ff ff ff 

  ASSERT((kthread_mutex_unlock(mutex1) == -1), "kthread_mutex_unlock(%d) fail", mutex1);
     e05:	a1 f0 37 00 00       	mov    0x37f0,%eax
     e0a:	89 04 24             	mov    %eax,(%esp)
     e0d:	e8 ac 12 00 00       	call   20be <kthread_mutex_unlock>
     e12:	83 f8 ff             	cmp    $0xffffffff,%eax
     e15:	75 5a                	jne    e71 <trubleThread+0xe8>
     e17:	c7 44 24 0c cf 00 00 	movl   $0xcf,0xc(%esp)
     e1e:	00 
     e1f:	c7 44 24 08 3c 31 00 	movl   $0x313c,0x8(%esp)
     e26:	00 
     e27:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     e2e:	00 
     e2f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e36:	e8 73 13 00 00       	call   21ae <printf>
     e3b:	a1 f0 37 00 00       	mov    0x37f0,%eax
     e40:	89 44 24 08          	mov    %eax,0x8(%esp)
     e44:	c7 44 24 04 9e 2d 00 	movl   $0x2d9e,0x4(%esp)
     e4b:	00 
     e4c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e53:	e8 56 13 00 00       	call   21ae <printf>
     e58:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     e5f:	00 
     e60:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e67:	e8 42 13 00 00       	call   21ae <printf>
     e6c:	e8 75 11 00 00       	call   1fe6 <exit>

  kthread_exit();
     e71:	e8 20 12 00 00       	call   2096 <kthread_exit>
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
     e91:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
     e98:	00 
     e99:	c7 44 24 04 bc 2d 00 	movl   $0x2dbc,0x4(%esp)
     ea0:	00 
     ea1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ea8:	e8 01 13 00 00       	call   21ae <printf>

  for (i = 0 ; i < 20; i++)
     ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb4:	eb 12                	jmp    ec8 <mutexYieldTest+0x4b>
    resource1[i] = 0;
     eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb9:	c7 04 85 a0 37 00 00 	movl   $0x0,0x37a0(,%eax,4)
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
     ece:	c7 05 84 37 00 00 00 	movl   $0x0,0x3784
     ed5:	00 00 00 
  mutex1 = kthread_mutex_alloc();
     ed8:	e8 c9 11 00 00       	call   20a6 <kthread_mutex_alloc>
     edd:	a3 f0 37 00 00       	mov    %eax,0x37f0
  mutex2 = kthread_mutex_alloc();
     ee2:	e8 bf 11 00 00       	call   20a6 <kthread_mutex_alloc>
     ee7:	a3 80 37 00 00       	mov    %eax,0x3780
  ASSERT((mutex1 < 0), "(mutex1 < 0)");
     eec:	a1 f0 37 00 00       	mov    0x37f0,%eax
     ef1:	85 c0                	test   %eax,%eax
     ef3:	79 51                	jns    f46 <mutexYieldTest+0xc9>
     ef5:	c7 44 24 0c e2 00 00 	movl   $0xe2,0xc(%esp)
     efc:	00 
     efd:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
     f04:	00 
     f05:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     f0c:	00 
     f0d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f14:	e8 95 12 00 00       	call   21ae <printf>
     f19:	c7 44 24 04 bf 2e 00 	movl   $0x2ebf,0x4(%esp)
     f20:	00 
     f21:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f28:	e8 81 12 00 00       	call   21ae <printf>
     f2d:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     f34:	00 
     f35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f3c:	e8 6d 12 00 00       	call   21ae <printf>
     f41:	e8 a0 10 00 00       	call   1fe6 <exit>
  ASSERT((mutex2 < 0), "(mutex2 < 0)");
     f46:	a1 80 37 00 00       	mov    0x3780,%eax
     f4b:	85 c0                	test   %eax,%eax
     f4d:	79 51                	jns    fa0 <mutexYieldTest+0x123>
     f4f:	c7 44 24 0c e3 00 00 	movl   $0xe3,0xc(%esp)
     f56:	00 
     f57:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
     f5e:	00 
     f5f:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     f66:	00 
     f67:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f6e:	e8 3b 12 00 00       	call   21ae <printf>
     f73:	c7 44 24 04 cc 2e 00 	movl   $0x2ecc,0x4(%esp)
     f7a:	00 
     f7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f82:	e8 27 12 00 00       	call   21ae <printf>
     f87:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     f8e:	00 
     f8f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f96:	e8 13 12 00 00       	call   21ae <printf>
     f9b:	e8 46 10 00 00       	call   1fe6 <exit>
  ASSERT((mutex1 == mutex2), "(mutex1 == mutex2)");
     fa0:	8b 15 f0 37 00 00    	mov    0x37f0,%edx
     fa6:	a1 80 37 00 00       	mov    0x3780,%eax
     fab:	39 c2                	cmp    %eax,%edx
     fad:	75 51                	jne    1000 <mutexYieldTest+0x183>
     faf:	c7 44 24 0c e4 00 00 	movl   $0xe4,0xc(%esp)
     fb6:	00 
     fb7:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
     fbe:	00 
     fbf:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
     fc6:	00 
     fc7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     fce:	e8 db 11 00 00       	call   21ae <printf>
     fd3:	c7 44 24 04 ce 2d 00 	movl   $0x2dce,0x4(%esp)
     fda:	00 
     fdb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     fe2:	e8 c7 11 00 00       	call   21ae <printf>
     fe7:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
     fee:	00 
     fef:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ff6:	e8 b3 11 00 00       	call   21ae <printf>
     ffb:	e8 e6 0f 00 00       	call   1fe6 <exit>

  ASSERT((kthread_mutex_lock(mutex1) != 0), "mutex lock");
    1000:	a1 f0 37 00 00       	mov    0x37f0,%eax
    1005:	89 04 24             	mov    %eax,(%esp)
    1008:	e8 a9 10 00 00       	call   20b6 <kthread_mutex_lock>
    100d:	85 c0                	test   %eax,%eax
    100f:	74 51                	je     1062 <mutexYieldTest+0x1e5>
    1011:	c7 44 24 0c e6 00 00 	movl   $0xe6,0xc(%esp)
    1018:	00 
    1019:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    1020:	00 
    1021:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1028:	00 
    1029:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1030:	e8 79 11 00 00       	call   21ae <printf>
    1035:	c7 44 24 04 d9 2e 00 	movl   $0x2ed9,0x4(%esp)
    103c:	00 
    103d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1044:	e8 65 11 00 00       	call   21ae <printf>
    1049:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1058:	e8 51 11 00 00       	call   21ae <printf>
    105d:	e8 84 0f 00 00       	call   1fe6 <exit>
  ASSERT((kthread_mutex_lock(mutex2) != 0), "mutex lock");
    1062:	a1 80 37 00 00       	mov    0x3780,%eax
    1067:	89 04 24             	mov    %eax,(%esp)
    106a:	e8 47 10 00 00       	call   20b6 <kthread_mutex_lock>
    106f:	85 c0                	test   %eax,%eax
    1071:	74 51                	je     10c4 <mutexYieldTest+0x247>
    1073:	c7 44 24 0c e7 00 00 	movl   $0xe7,0xc(%esp)
    107a:	00 
    107b:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    1082:	00 
    1083:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    108a:	00 
    108b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1092:	e8 17 11 00 00       	call   21ae <printf>
    1097:	c7 44 24 04 d9 2e 00 	movl   $0x2ed9,0x4(%esp)
    109e:	00 
    109f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10a6:	e8 03 11 00 00       	call   21ae <printf>
    10ab:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    10b2:	00 
    10b3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10ba:	e8 ef 10 00 00       	call   21ae <printf>
    10bf:	e8 22 0f 00 00       	call   1fe6 <exit>

  stack = malloc(STACK_SIZE);
    10c4:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    10cb:	e8 ca 13 00 00       	call   249a <malloc>
    10d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  ttid = kthread_create(&trubleThread, stack+STACK_SIZE, STACK_SIZE);
    10d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d6:	05 e8 03 00 00       	add    $0x3e8,%eax
    10db:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
    10e2:	00 
    10e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e7:	c7 04 24 89 0d 00 00 	movl   $0xd89,(%esp)
    10ee:	e8 93 0f 00 00       	call   2086 <kthread_create>
    10f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = 0 ; i < 10; i++){
    10f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10fd:	eb 69                	jmp    1168 <mutexYieldTest+0x2eb>
    stack = malloc(STACK_SIZE);
    10ff:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    1106:	e8 8f 13 00 00       	call   249a <malloc>
    110b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    tid[i] = kthread_create(&yieldThread, stack+STACK_SIZE, STACK_SIZE);
    110e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1111:	05 e8 03 00 00       	add    $0x3e8,%eax
    1116:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
    111d:	00 
    111e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1122:	c7 04 24 6e 0b 00 00 	movl   $0xb6e,(%esp)
    1129:	e8 58 0f 00 00       	call   2086 <kthread_create>
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
    1155:	e8 1c 0f 00 00       	call   2076 <sleep>
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
    1175:	e8 fc 0e 00 00       	call   2076 <sleep>
  ASSERT((kthread_mutex_yieldlock(mutex1, mutex2) != 0), "mutex yield");
    117a:	8b 15 80 37 00 00    	mov    0x3780,%edx
    1180:	a1 f0 37 00 00       	mov    0x37f0,%eax
    1185:	89 54 24 04          	mov    %edx,0x4(%esp)
    1189:	89 04 24             	mov    %eax,(%esp)
    118c:	e8 35 0f 00 00       	call   20c6 <kthread_mutex_yieldlock>
    1191:	85 c0                	test   %eax,%eax
    1193:	74 51                	je     11e6 <mutexYieldTest+0x369>
    1195:	c7 44 24 0c f4 00 00 	movl   $0xf4,0xc(%esp)
    119c:	00 
    119d:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    11a4:	00 
    11a5:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    11ac:	00 
    11ad:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11b4:	e8 f5 0f 00 00       	call   21ae <printf>
    11b9:	c7 44 24 04 b3 2e 00 	movl   $0x2eb3,0x4(%esp)
    11c0:	00 
    11c1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11c8:	e8 e1 0f 00 00       	call   21ae <printf>
    11cd:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    11d4:	00 
    11d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11dc:	e8 cd 0f 00 00       	call   21ae <printf>
    11e1:	e8 00 0e 00 00       	call   1fe6 <exit>


  for (i = 0 ; i < 10; i++){
    11e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ed:	e9 d9 00 00 00       	jmp    12cb <mutexYieldTest+0x44e>
    ASSERT((resource2 < 0), "(resource2 < 0)")
    11f2:	a1 84 37 00 00       	mov    0x3784,%eax
    11f7:	85 c0                	test   %eax,%eax
    11f9:	79 51                	jns    124c <mutexYieldTest+0x3cf>
    11fb:	c7 44 24 0c f8 00 00 	movl   $0xf8,0xc(%esp)
    1202:	00 
    1203:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    120a:	00 
    120b:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1212:	00 
    1213:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    121a:	e8 8f 0f 00 00       	call   21ae <printf>
    121f:	c7 44 24 04 e4 2e 00 	movl   $0x2ee4,0x4(%esp)
    1226:	00 
    1227:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    122e:	e8 7b 0f 00 00       	call   21ae <printf>
    1233:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    123a:	00 
    123b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1242:	e8 67 0f 00 00       	call   21ae <printf>
    1247:	e8 9a 0d 00 00       	call   1fe6 <exit>
    ans = kthread_join(tid[i]);
    124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124f:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 43 0e 00 00       	call   209e <kthread_join>
    125b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // if fail here it's not always error!
    ASSERT((ans != 0), "kthread_join(%d) return with: %d", tid[i], ans)
    125e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1262:	74 63                	je     12c7 <mutexYieldTest+0x44a>
    1264:	c7 44 24 0c fb 00 00 	movl   $0xfb,0xc(%esp)
    126b:	00 
    126c:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    1273:	00 
    1274:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    127b:	00 
    127c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1283:	e8 26 0f 00 00       	call   21ae <printf>
    1288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128b:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
    128f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1292:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1296:	89 44 24 08          	mov    %eax,0x8(%esp)
    129a:	c7 44 24 04 14 2e 00 	movl   $0x2e14,0x4(%esp)
    12a1:	00 
    12a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    12a9:	e8 00 0f 00 00       	call   21ae <printf>
    12ae:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    12b5:	00 
    12b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    12bd:	e8 ec 0e 00 00       	call   21ae <printf>
    12c2:	e8 1f 0d 00 00       	call   1fe6 <exit>

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
    12d5:	a1 f0 37 00 00       	mov    0x37f0,%eax
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 d4 0d 00 00       	call   20b6 <kthread_mutex_lock>
  ASSERT((resource2 != -10), "expect resource2=-10, but resource2=%d, c=%d" , resource2, c);
    12e2:	a1 84 37 00 00       	mov    0x3784,%eax
    12e7:	83 f8 f6             	cmp    $0xfffffff6,%eax
    12ea:	74 61                	je     134d <mutexYieldTest+0x4d0>
    12ec:	c7 44 24 0c ff 00 00 	movl   $0xff,0xc(%esp)
    12f3:	00 
    12f4:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    12fb:	00 
    12fc:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1303:	00 
    1304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    130b:	e8 9e 0e 00 00       	call   21ae <printf>
    1310:	a1 84 37 00 00       	mov    0x3784,%eax
    1315:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1318:	89 54 24 0c          	mov    %edx,0xc(%esp)
    131c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1320:	c7 44 24 04 f4 2e 00 	movl   $0x2ef4,0x4(%esp)
    1327:	00 
    1328:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    132f:	e8 7a 0e 00 00       	call   21ae <printf>
    1334:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    133b:	00 
    133c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1343:	e8 66 0e 00 00       	call   21ae <printf>
    1348:	e8 99 0c 00 00       	call   1fe6 <exit>
  kthread_mutex_unlock(mutex1);
    134d:	a1 f0 37 00 00       	mov    0x37f0,%eax
    1352:	89 04 24             	mov    %eax,(%esp)
    1355:	e8 64 0d 00 00       	call   20be <kthread_mutex_unlock>

  // wait for the truble thread
  kthread_join(ttid);
    135a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    135d:	89 04 24             	mov    %eax,(%esp)
    1360:	e8 39 0d 00 00       	call   209e <kthread_join>

  // check that the last yield release the mutexes
  ASSERT((kthread_mutex_lock(mutex1) != 0), "mutex lock");
    1365:	a1 f0 37 00 00       	mov    0x37f0,%eax
    136a:	89 04 24             	mov    %eax,(%esp)
    136d:	e8 44 0d 00 00       	call   20b6 <kthread_mutex_lock>
    1372:	85 c0                	test   %eax,%eax
    1374:	74 51                	je     13c7 <mutexYieldTest+0x54a>
    1376:	c7 44 24 0c 06 01 00 	movl   $0x106,0xc(%esp)
    137d:	00 
    137e:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    1385:	00 
    1386:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    138d:	00 
    138e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1395:	e8 14 0e 00 00       	call   21ae <printf>
    139a:	c7 44 24 04 d9 2e 00 	movl   $0x2ed9,0x4(%esp)
    13a1:	00 
    13a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13a9:	e8 00 0e 00 00       	call   21ae <printf>
    13ae:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    13b5:	00 
    13b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13bd:	e8 ec 0d 00 00       	call   21ae <printf>
    13c2:	e8 1f 0c 00 00       	call   1fe6 <exit>
  ASSERT((kthread_mutex_lock(mutex2) != 0), "mutex lock");
    13c7:	a1 80 37 00 00       	mov    0x3780,%eax
    13cc:	89 04 24             	mov    %eax,(%esp)
    13cf:	e8 e2 0c 00 00       	call   20b6 <kthread_mutex_lock>
    13d4:	85 c0                	test   %eax,%eax
    13d6:	74 51                	je     1429 <mutexYieldTest+0x5ac>
    13d8:	c7 44 24 0c 07 01 00 	movl   $0x107,0xc(%esp)
    13df:	00 
    13e0:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    13e7:	00 
    13e8:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    13ef:	00 
    13f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    13f7:	e8 b2 0d 00 00       	call   21ae <printf>
    13fc:	c7 44 24 04 d9 2e 00 	movl   $0x2ed9,0x4(%esp)
    1403:	00 
    1404:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    140b:	e8 9e 0d 00 00       	call   21ae <printf>
    1410:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1417:	00 
    1418:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    141f:	e8 8a 0d 00 00       	call   21ae <printf>
    1424:	e8 bd 0b 00 00       	call   1fe6 <exit>
  ASSERT((kthread_mutex_unlock(mutex1) != 0), "mutex unlock");
    1429:	a1 f0 37 00 00       	mov    0x37f0,%eax
    142e:	89 04 24             	mov    %eax,(%esp)
    1431:	e8 88 0c 00 00       	call   20be <kthread_mutex_unlock>
    1436:	85 c0                	test   %eax,%eax
    1438:	74 51                	je     148b <mutexYieldTest+0x60e>
    143a:	c7 44 24 0c 08 01 00 	movl   $0x108,0xc(%esp)
    1441:	00 
    1442:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    1449:	00 
    144a:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1451:	00 
    1452:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1459:	e8 50 0d 00 00       	call   21ae <printf>
    145e:	c7 44 24 04 21 2f 00 	movl   $0x2f21,0x4(%esp)
    1465:	00 
    1466:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    146d:	e8 3c 0d 00 00       	call   21ae <printf>
    1472:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1479:	00 
    147a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1481:	e8 28 0d 00 00       	call   21ae <printf>
    1486:	e8 5b 0b 00 00       	call   1fe6 <exit>
  ASSERT((kthread_mutex_unlock(mutex2) != 0), "mutex unlock");
    148b:	a1 80 37 00 00       	mov    0x3780,%eax
    1490:	89 04 24             	mov    %eax,(%esp)
    1493:	e8 26 0c 00 00       	call   20be <kthread_mutex_unlock>
    1498:	85 c0                	test   %eax,%eax
    149a:	74 51                	je     14ed <mutexYieldTest+0x670>
    149c:	c7 44 24 0c 09 01 00 	movl   $0x109,0xc(%esp)
    14a3:	00 
    14a4:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    14ab:	00 
    14ac:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    14b3:	00 
    14b4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14bb:	e8 ee 0c 00 00       	call   21ae <printf>
    14c0:	c7 44 24 04 21 2f 00 	movl   $0x2f21,0x4(%esp)
    14c7:	00 
    14c8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14cf:	e8 da 0c 00 00       	call   21ae <printf>
    14d4:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    14db:	00 
    14dc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    14e3:	e8 c6 0c 00 00       	call   21ae <printf>
    14e8:	e8 f9 0a 00 00       	call   1fe6 <exit>

  // free the mutexes
  ASSERT( (kthread_mutex_dealloc(mutex1) != 0), "dealloc");
    14ed:	a1 f0 37 00 00       	mov    0x37f0,%eax
    14f2:	89 04 24             	mov    %eax,(%esp)
    14f5:	e8 b4 0b 00 00       	call   20ae <kthread_mutex_dealloc>
    14fa:	85 c0                	test   %eax,%eax
    14fc:	74 51                	je     154f <mutexYieldTest+0x6d2>
    14fe:	c7 44 24 0c 0c 01 00 	movl   $0x10c,0xc(%esp)
    1505:	00 
    1506:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    150d:	00 
    150e:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1515:	00 
    1516:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    151d:	e8 8c 0c 00 00       	call   21ae <printf>
    1522:	c7 44 24 04 35 2e 00 	movl   $0x2e35,0x4(%esp)
    1529:	00 
    152a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1531:	e8 78 0c 00 00       	call   21ae <printf>
    1536:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    153d:	00 
    153e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1545:	e8 64 0c 00 00       	call   21ae <printf>
    154a:	e8 97 0a 00 00       	call   1fe6 <exit>
  ASSERT( (kthread_mutex_dealloc(mutex2) != 0), "dealloc");
    154f:	a1 80 37 00 00       	mov    0x3780,%eax
    1554:	89 04 24             	mov    %eax,(%esp)
    1557:	e8 52 0b 00 00       	call   20ae <kthread_mutex_dealloc>
    155c:	85 c0                	test   %eax,%eax
    155e:	74 51                	je     15b1 <mutexYieldTest+0x734>
    1560:	c7 44 24 0c 0d 01 00 	movl   $0x10d,0xc(%esp)
    1567:	00 
    1568:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    156f:	00 
    1570:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1577:	00 
    1578:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    157f:	e8 2a 0c 00 00       	call   21ae <printf>
    1584:	c7 44 24 04 35 2e 00 	movl   $0x2e35,0x4(%esp)
    158b:	00 
    158c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1593:	e8 16 0c 00 00       	call   21ae <printf>
    1598:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    159f:	00 
    15a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    15a7:	e8 02 0c 00 00       	call   21ae <printf>
    15ac:	e8 35 0a 00 00       	call   1fe6 <exit>

  printf(1, "%s test PASS!\n", __FUNCTION__);
    15b1:	c7 44 24 08 49 31 00 	movl   $0x3149,0x8(%esp)
    15b8:	00 
    15b9:	c7 44 24 04 5b 2e 00 	movl   $0x2e5b,0x4(%esp)
    15c0:	00 
    15c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c8:	e8 e1 0b 00 00       	call   21ae <printf>

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
    15d8:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    15df:	00 
    15e0:	c7 44 24 04 bc 2d 00 	movl   $0x2dbc,0x4(%esp)
    15e7:	00 
    15e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ef:	e8 ba 0b 00 00       	call   21ae <printf>
  for(j=0 ; j<2 ; j++){ // run the test twice to check that mutexes can be reused
    15f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15fb:	e9 83 05 00 00       	jmp    1b83 <senaty+0x5b4>
    for(i=0 ; i < count ; i++){
    1600:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1607:	e9 dc 01 00 00       	jmp    17e8 <senaty+0x219>
      mutex[i] = kthread_mutex_alloc();
    160c:	e8 95 0a 00 00       	call   20a6 <kthread_mutex_alloc>
    1611:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1614:	89 84 95 f0 fe ff ff 	mov    %eax,-0x110(%ebp,%edx,4)
      ASSERT((mutex[i] == -1), "kthread_mutex_alloc fail, i=%d", i);
    161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161e:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1625:	83 f8 ff             	cmp    $0xffffffff,%eax
    1628:	75 58                	jne    1682 <senaty+0xb3>
    162a:	c7 44 24 0c 1b 01 00 	movl   $0x11b,0xc(%esp)
    1631:	00 
    1632:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1639:	00 
    163a:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1641:	00 
    1642:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1649:	e8 60 0b 00 00       	call   21ae <printf>
    164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1651:	89 44 24 08          	mov    %eax,0x8(%esp)
    1655:	c7 44 24 04 30 2f 00 	movl   $0x2f30,0x4(%esp)
    165c:	00 
    165d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1664:	e8 45 0b 00 00       	call   21ae <printf>
    1669:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1670:	00 
    1671:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1678:	e8 31 0b 00 00       	call   21ae <printf>
    167d:	e8 64 09 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_lock(mutex[i]) == -1), "kthread_mutex_lock(%d) fail", mutex[i]);
    1682:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1685:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    168c:	89 04 24             	mov    %eax,(%esp)
    168f:	e8 22 0a 00 00       	call   20b6 <kthread_mutex_lock>
    1694:	83 f8 ff             	cmp    $0xffffffff,%eax
    1697:	75 5f                	jne    16f8 <senaty+0x129>
    1699:	c7 44 24 0c 1c 01 00 	movl   $0x11c,0xc(%esp)
    16a0:	00 
    16a1:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    16a8:	00 
    16a9:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    16b0:	00 
    16b1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16b8:	e8 f1 0a 00 00       	call   21ae <printf>
    16bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c0:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    16c7:	89 44 24 08          	mov    %eax,0x8(%esp)
    16cb:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
    16d2:	00 
    16d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16da:	e8 cf 0a 00 00       	call   21ae <printf>
    16df:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    16e6:	00 
    16e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    16ee:	e8 bb 0a 00 00       	call   21ae <printf>
    16f3:	e8 ee 08 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) == -1), "kthread_mutex_unlock(%d) fail", mutex[i]);
    16f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16fb:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1702:	89 04 24             	mov    %eax,(%esp)
    1705:	e8 b4 09 00 00       	call   20be <kthread_mutex_unlock>
    170a:	83 f8 ff             	cmp    $0xffffffff,%eax
    170d:	75 5f                	jne    176e <senaty+0x19f>
    170f:	c7 44 24 0c 1d 01 00 	movl   $0x11d,0xc(%esp)
    1716:	00 
    1717:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    171e:	00 
    171f:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1726:	00 
    1727:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    172e:	e8 7b 0a 00 00       	call   21ae <printf>
    1733:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1736:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    173d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1741:	c7 44 24 04 9e 2d 00 	movl   $0x2d9e,0x4(%esp)
    1748:	00 
    1749:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1750:	e8 59 0a 00 00       	call   21ae <printf>
    1755:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    175c:	00 
    175d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1764:	e8 45 0a 00 00       	call   21ae <printf>
    1769:	e8 78 08 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1771:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1778:	89 04 24             	mov    %eax,(%esp)
    177b:	e8 3e 09 00 00       	call   20be <kthread_mutex_unlock>
    1780:	83 f8 ff             	cmp    $0xffffffff,%eax
    1783:	74 5f                	je     17e4 <senaty+0x215>
    1785:	c7 44 24 0c 1e 01 00 	movl   $0x11e,0xc(%esp)
    178c:	00 
    178d:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1794:	00 
    1795:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    179c:	00 
    179d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17a4:	e8 05 0a 00 00       	call   21ae <printf>
    17a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ac:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    17b3:	89 44 24 08          	mov    %eax,0x8(%esp)
    17b7:	c7 44 24 04 50 2f 00 	movl   $0x2f50,0x4(%esp)
    17be:	00 
    17bf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17c6:	e8 e3 09 00 00       	call   21ae <printf>
    17cb:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    17d2:	00 
    17d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    17da:	e8 cf 09 00 00       	call   21ae <printf>
    17df:	e8 02 08 00 00       	call   1fe6 <exit>
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
    180a:	e8 a7 08 00 00       	call   20b6 <kthread_mutex_lock>
    180f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1812:	75 5f                	jne    1873 <senaty+0x2a4>
    1814:	c7 44 24 0c 22 01 00 	movl   $0x122,0xc(%esp)
    181b:	00 
    181c:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1823:	00 
    1824:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    182b:	00 
    182c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1833:	e8 76 09 00 00       	call   21ae <printf>
    1838:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183b:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1842:	89 44 24 08          	mov    %eax,0x8(%esp)
    1846:	c7 44 24 04 59 2d 00 	movl   $0x2d59,0x4(%esp)
    184d:	00 
    184e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1855:	e8 54 09 00 00       	call   21ae <printf>
    185a:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1861:	00 
    1862:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1869:	e8 40 09 00 00       	call   21ae <printf>
    186e:	e8 73 07 00 00       	call   1fe6 <exit>
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
    189c:	e8 1d 08 00 00       	call   20be <kthread_mutex_unlock>
    18a1:	83 f8 ff             	cmp    $0xffffffff,%eax
    18a4:	75 5f                	jne    1905 <senaty+0x336>
    18a6:	c7 44 24 0c 26 01 00 	movl   $0x126,0xc(%esp)
    18ad:	00 
    18ae:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    18b5:	00 
    18b6:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    18bd:	00 
    18be:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18c5:	e8 e4 08 00 00       	call   21ae <printf>
    18ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cd:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    18d4:	89 44 24 08          	mov    %eax,0x8(%esp)
    18d8:	c7 44 24 04 9e 2d 00 	movl   $0x2d9e,0x4(%esp)
    18df:	00 
    18e0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18e7:	e8 c2 08 00 00       	call   21ae <printf>
    18ec:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    18f3:	00 
    18f4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    18fb:	e8 ae 08 00 00       	call   21ae <printf>
    1900:	e8 e1 06 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "second kthread_mutex_unlock(%d) didn't fail as expected", mutex[i]);
    1905:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1908:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    190f:	89 04 24             	mov    %eax,(%esp)
    1912:	e8 a7 07 00 00       	call   20be <kthread_mutex_unlock>
    1917:	83 f8 ff             	cmp    $0xffffffff,%eax
    191a:	74 5f                	je     197b <senaty+0x3ac>
    191c:	c7 44 24 0c 27 01 00 	movl   $0x127,0xc(%esp)
    1923:	00 
    1924:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    192b:	00 
    192c:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1933:	00 
    1934:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    193b:	e8 6e 08 00 00       	call   21ae <printf>
    1940:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1943:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    194a:	89 44 24 08          	mov    %eax,0x8(%esp)
    194e:	c7 44 24 04 50 2f 00 	movl   $0x2f50,0x4(%esp)
    1955:	00 
    1956:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    195d:	e8 4c 08 00 00       	call   21ae <printf>
    1962:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1969:	00 
    196a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1971:	e8 38 08 00 00       	call   21ae <printf>
    1976:	e8 6b 06 00 00       	call   1fe6 <exit>

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
    19a4:	e8 05 07 00 00       	call   20ae <kthread_mutex_dealloc>
    19a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    19ac:	75 5f                	jne    1a0d <senaty+0x43e>
    19ae:	c7 44 24 0c 2b 01 00 	movl   $0x12b,0xc(%esp)
    19b5:	00 
    19b6:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    19bd:	00 
    19be:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    19c5:	00 
    19c6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    19cd:	e8 dc 07 00 00       	call   21ae <printf>
    19d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d5:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    19dc:	89 44 24 08          	mov    %eax,0x8(%esp)
    19e0:	c7 44 24 04 88 2f 00 	movl   $0x2f88,0x4(%esp)
    19e7:	00 
    19e8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    19ef:	e8 ba 07 00 00       	call   21ae <printf>
    19f4:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    19fb:	00 
    19fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a03:	e8 a6 07 00 00       	call   21ae <printf>
    1a08:	e8 d9 05 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_dealloc(mutex[i]) != -1), "second kthread_mutex_dealloc(%d) didn't fail as expected", mutex[i]);
    1a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a10:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a17:	89 04 24             	mov    %eax,(%esp)
    1a1a:	e8 8f 06 00 00       	call   20ae <kthread_mutex_dealloc>
    1a1f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1a22:	74 5f                	je     1a83 <senaty+0x4b4>
    1a24:	c7 44 24 0c 2c 01 00 	movl   $0x12c,0xc(%esp)
    1a2b:	00 
    1a2c:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1a33:	00 
    1a34:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1a3b:	00 
    1a3c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a43:	e8 66 07 00 00       	call   21ae <printf>
    1a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4b:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a52:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a56:	c7 44 24 04 a8 2f 00 	movl   $0x2fa8,0x4(%esp)
    1a5d:	00 
    1a5e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a65:	e8 44 07 00 00       	call   21ae <printf>
    1a6a:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1a71:	00 
    1a72:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1a79:	e8 30 07 00 00       	call   21ae <printf>
    1a7e:	e8 63 05 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_lock(mutex[i]) != -1), "kthread_mutex_lock(%d) didn't fail after dealloc", mutex[i]);
    1a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a86:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1a8d:	89 04 24             	mov    %eax,(%esp)
    1a90:	e8 21 06 00 00       	call   20b6 <kthread_mutex_lock>
    1a95:	83 f8 ff             	cmp    $0xffffffff,%eax
    1a98:	74 5f                	je     1af9 <senaty+0x52a>
    1a9a:	c7 44 24 0c 2d 01 00 	movl   $0x12d,0xc(%esp)
    1aa1:	00 
    1aa2:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1aa9:	00 
    1aaa:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1ab1:	00 
    1ab2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1ab9:	e8 f0 06 00 00       	call   21ae <printf>
    1abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac1:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
    1acc:	c7 44 24 04 e4 2f 00 	movl   $0x2fe4,0x4(%esp)
    1ad3:	00 
    1ad4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1adb:	e8 ce 06 00 00       	call   21ae <printf>
    1ae0:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1ae7:	00 
    1ae8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1aef:	e8 ba 06 00 00       	call   21ae <printf>
    1af4:	e8 ed 04 00 00       	call   1fe6 <exit>
      ASSERT((kthread_mutex_unlock(mutex[i]) != -1), "kthread_mutex_unlock(%d) didn't fail after dealloc", mutex[i]);
    1af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afc:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1b03:	89 04 24             	mov    %eax,(%esp)
    1b06:	e8 b3 05 00 00       	call   20be <kthread_mutex_unlock>
    1b0b:	83 f8 ff             	cmp    $0xffffffff,%eax
    1b0e:	74 5f                	je     1b6f <senaty+0x5a0>
    1b10:	c7 44 24 0c 2e 01 00 	movl   $0x12e,0xc(%esp)
    1b17:	00 
    1b18:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1b1f:	00 
    1b20:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1b27:	00 
    1b28:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b2f:	e8 7a 06 00 00       	call   21ae <printf>
    1b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b37:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b42:	c7 44 24 04 18 30 00 	movl   $0x3018,0x4(%esp)
    1b49:	00 
    1b4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b51:	e8 58 06 00 00       	call   21ae <printf>
    1b56:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1b5d:	00 
    1b5e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1b65:	e8 44 06 00 00       	call   21ae <printf>
    1b6a:	e8 77 04 00 00       	call   1fe6 <exit>
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
    1b99:	e8 08 05 00 00       	call   20a6 <kthread_mutex_alloc>
    1b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ba1:	89 84 95 f0 fe ff ff 	mov    %eax,-0x110(%ebp,%edx,4)
    ASSERT((mutex[i] == -1), "kthread_mutex_alloc (limit) fail, i=%d, expected fail at:%d", i, MAX_MUTEXES);
    1ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bab:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1bb2:	83 f8 ff             	cmp    $0xffffffff,%eax
    1bb5:	75 60                	jne    1c17 <senaty+0x648>
    1bb7:	c7 44 24 0c 35 01 00 	movl   $0x135,0xc(%esp)
    1bbe:	00 
    1bbf:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1bc6:	00 
    1bc7:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1bce:	00 
    1bcf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bd6:	e8 d3 05 00 00       	call   21ae <printf>
    1bdb:	c7 44 24 0c 40 00 00 	movl   $0x40,0xc(%esp)
    1be2:	00 
    1be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1bea:	c7 44 24 04 4c 30 00 	movl   $0x304c,0x4(%esp)
    1bf1:	00 
    1bf2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bf9:	e8 b0 05 00 00       	call   21ae <printf>
    1bfe:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1c05:	00 
    1c06:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c0d:	e8 9c 05 00 00       	call   21ae <printf>
    1c12:	e8 cf 03 00 00       	call   1fe6 <exit>
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
    1c25:	e8 7c 04 00 00       	call   20a6 <kthread_mutex_alloc>
    1c2a:	83 f8 ff             	cmp    $0xffffffff,%eax
    1c2d:	74 63                	je     1c92 <senaty+0x6c3>
    1c2f:	c7 44 24 0c 38 01 00 	movl   $0x138,0xc(%esp)
    1c36:	00 
    1c37:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1c3e:	00 
    1c3f:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1c46:	00 
    1c47:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c4e:	e8 5b 05 00 00       	call   21ae <printf>
    1c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c56:	83 c0 01             	add    $0x1,%eax
    1c59:	c7 44 24 0c 40 00 00 	movl   $0x40,0xc(%esp)
    1c60:	00 
    1c61:	89 44 24 08          	mov    %eax,0x8(%esp)
    1c65:	c7 44 24 04 88 30 00 	movl   $0x3088,0x4(%esp)
    1c6c:	00 
    1c6d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c74:	e8 35 05 00 00       	call   21ae <printf>
    1c79:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1c80:	00 
    1c81:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1c88:	e8 21 05 00 00       	call   21ae <printf>
    1c8d:	e8 54 03 00 00       	call   1fe6 <exit>

  // release all mutexes
  for (i=0 ; i<MAX_MUTEXES ; i++){
    1c92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c99:	e9 81 00 00 00       	jmp    1d1f <senaty+0x750>
    ASSERT((kthread_mutex_dealloc(mutex[i]) == -1), "kthread_mutex_dealloc(%d) fail, i=%d", mutex[i], i);
    1c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ca1:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ca8:	89 04 24             	mov    %eax,(%esp)
    1cab:	e8 fe 03 00 00       	call   20ae <kthread_mutex_dealloc>
    1cb0:	83 f8 ff             	cmp    $0xffffffff,%eax
    1cb3:	75 66                	jne    1d1b <senaty+0x74c>
    1cb5:	c7 44 24 0c 3c 01 00 	movl   $0x13c,0xc(%esp)
    1cbc:	00 
    1cbd:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1cc4:	00 
    1cc5:	c7 44 24 04 48 2d 00 	movl   $0x2d48,0x4(%esp)
    1ccc:	00 
    1ccd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1cd4:	e8 d5 04 00 00       	call   21ae <printf>
    1cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cdc:	8b 84 85 f0 fe ff ff 	mov    -0x110(%ebp,%eax,4),%eax
    1ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ce6:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1cea:	89 44 24 08          	mov    %eax,0x8(%esp)
    1cee:	c7 44 24 04 cc 30 00 	movl   $0x30cc,0x4(%esp)
    1cf5:	00 
    1cf6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1cfd:	e8 ac 04 00 00       	call   21ae <printf>
    1d02:	c7 44 24 04 75 2d 00 	movl   $0x2d75,0x4(%esp)
    1d09:	00 
    1d0a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1d11:	e8 98 04 00 00       	call   21ae <printf>
    1d16:	e8 cb 02 00 00       	call   1fe6 <exit>
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
    1d29:	c7 44 24 08 58 31 00 	movl   $0x3158,0x8(%esp)
    1d30:	00 
    1d31:	c7 44 24 04 5b 2e 00 	movl   $0x2e5b,0x4(%esp)
    1d38:	00 
    1d39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d40:	e8 69 04 00 00       	call   21ae <printf>
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
  //stressTest1(15);
  mutexYieldTest();
    1d5c:	e8 1c f1 ff ff       	call   e7d <mutexYieldTest>
  stressTest2Fail(15);
    1d61:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
    1d68:	e8 c3 e9 ff ff       	call   730 <stressTest2Fail>
  stressTest3toMuchTreads(15); //this test must be the last
    1d6d:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
    1d74:	e8 6d ec ff ff       	call   9e6 <stressTest3toMuchTreads>

  exit();
    1d79:	e8 68 02 00 00       	call   1fe6 <exit>

00001d7e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1d7e:	55                   	push   %ebp
    1d7f:	89 e5                	mov    %esp,%ebp
    1d81:	57                   	push   %edi
    1d82:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1d86:	8b 55 10             	mov    0x10(%ebp),%edx
    1d89:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d8c:	89 cb                	mov    %ecx,%ebx
    1d8e:	89 df                	mov    %ebx,%edi
    1d90:	89 d1                	mov    %edx,%ecx
    1d92:	fc                   	cld    
    1d93:	f3 aa                	rep stos %al,%es:(%edi)
    1d95:	89 ca                	mov    %ecx,%edx
    1d97:	89 fb                	mov    %edi,%ebx
    1d99:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1d9c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1d9f:	5b                   	pop    %ebx
    1da0:	5f                   	pop    %edi
    1da1:	5d                   	pop    %ebp
    1da2:	c3                   	ret    

00001da3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1da3:	55                   	push   %ebp
    1da4:	89 e5                	mov    %esp,%ebp
    1da6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1da9:	8b 45 08             	mov    0x8(%ebp),%eax
    1dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1daf:	90                   	nop
    1db0:	8b 45 08             	mov    0x8(%ebp),%eax
    1db3:	8d 50 01             	lea    0x1(%eax),%edx
    1db6:	89 55 08             	mov    %edx,0x8(%ebp)
    1db9:	8b 55 0c             	mov    0xc(%ebp),%edx
    1dbc:	8d 4a 01             	lea    0x1(%edx),%ecx
    1dbf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1dc2:	0f b6 12             	movzbl (%edx),%edx
    1dc5:	88 10                	mov    %dl,(%eax)
    1dc7:	0f b6 00             	movzbl (%eax),%eax
    1dca:	84 c0                	test   %al,%al
    1dcc:	75 e2                	jne    1db0 <strcpy+0xd>
    ;
  return os;
    1dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1dd1:	c9                   	leave  
    1dd2:	c3                   	ret    

00001dd3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1dd3:	55                   	push   %ebp
    1dd4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1dd6:	eb 08                	jmp    1de0 <strcmp+0xd>
    p++, q++;
    1dd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1ddc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1de0:	8b 45 08             	mov    0x8(%ebp),%eax
    1de3:	0f b6 00             	movzbl (%eax),%eax
    1de6:	84 c0                	test   %al,%al
    1de8:	74 10                	je     1dfa <strcmp+0x27>
    1dea:	8b 45 08             	mov    0x8(%ebp),%eax
    1ded:	0f b6 10             	movzbl (%eax),%edx
    1df0:	8b 45 0c             	mov    0xc(%ebp),%eax
    1df3:	0f b6 00             	movzbl (%eax),%eax
    1df6:	38 c2                	cmp    %al,%dl
    1df8:	74 de                	je     1dd8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1dfa:	8b 45 08             	mov    0x8(%ebp),%eax
    1dfd:	0f b6 00             	movzbl (%eax),%eax
    1e00:	0f b6 d0             	movzbl %al,%edx
    1e03:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e06:	0f b6 00             	movzbl (%eax),%eax
    1e09:	0f b6 c0             	movzbl %al,%eax
    1e0c:	29 c2                	sub    %eax,%edx
    1e0e:	89 d0                	mov    %edx,%eax
}
    1e10:	5d                   	pop    %ebp
    1e11:	c3                   	ret    

00001e12 <strlen>:

uint
strlen(char *s)
{
    1e12:	55                   	push   %ebp
    1e13:	89 e5                	mov    %esp,%ebp
    1e15:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1e1f:	eb 04                	jmp    1e25 <strlen+0x13>
    1e21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1e28:	8b 45 08             	mov    0x8(%ebp),%eax
    1e2b:	01 d0                	add    %edx,%eax
    1e2d:	0f b6 00             	movzbl (%eax),%eax
    1e30:	84 c0                	test   %al,%al
    1e32:	75 ed                	jne    1e21 <strlen+0xf>
    ;
  return n;
    1e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1e37:	c9                   	leave  
    1e38:	c3                   	ret    

00001e39 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1e39:	55                   	push   %ebp
    1e3a:	89 e5                	mov    %esp,%ebp
    1e3c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1e3f:	8b 45 10             	mov    0x10(%ebp),%eax
    1e42:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e46:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e49:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e4d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e50:	89 04 24             	mov    %eax,(%esp)
    1e53:	e8 26 ff ff ff       	call   1d7e <stosb>
  return dst;
    1e58:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1e5b:	c9                   	leave  
    1e5c:	c3                   	ret    

00001e5d <strchr>:

char*
strchr(const char *s, char c)
{
    1e5d:	55                   	push   %ebp
    1e5e:	89 e5                	mov    %esp,%ebp
    1e60:	83 ec 04             	sub    $0x4,%esp
    1e63:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e66:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1e69:	eb 14                	jmp    1e7f <strchr+0x22>
    if(*s == c)
    1e6b:	8b 45 08             	mov    0x8(%ebp),%eax
    1e6e:	0f b6 00             	movzbl (%eax),%eax
    1e71:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1e74:	75 05                	jne    1e7b <strchr+0x1e>
      return (char*)s;
    1e76:	8b 45 08             	mov    0x8(%ebp),%eax
    1e79:	eb 13                	jmp    1e8e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1e7b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1e7f:	8b 45 08             	mov    0x8(%ebp),%eax
    1e82:	0f b6 00             	movzbl (%eax),%eax
    1e85:	84 c0                	test   %al,%al
    1e87:	75 e2                	jne    1e6b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1e8e:	c9                   	leave  
    1e8f:	c3                   	ret    

00001e90 <gets>:

char*
gets(char *buf, int max)
{
    1e90:	55                   	push   %ebp
    1e91:	89 e5                	mov    %esp,%ebp
    1e93:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1e96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e9d:	eb 4c                	jmp    1eeb <gets+0x5b>
    cc = read(0, &c, 1);
    1e9f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1ea6:	00 
    1ea7:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
    1eae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1eb5:	e8 44 01 00 00       	call   1ffe <read>
    1eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1ebd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1ec1:	7f 02                	jg     1ec5 <gets+0x35>
      break;
    1ec3:	eb 31                	jmp    1ef6 <gets+0x66>
    buf[i++] = c;
    1ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ec8:	8d 50 01             	lea    0x1(%eax),%edx
    1ecb:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1ece:	89 c2                	mov    %eax,%edx
    1ed0:	8b 45 08             	mov    0x8(%ebp),%eax
    1ed3:	01 c2                	add    %eax,%edx
    1ed5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1ed9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1edb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1edf:	3c 0a                	cmp    $0xa,%al
    1ee1:	74 13                	je     1ef6 <gets+0x66>
    1ee3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1ee7:	3c 0d                	cmp    $0xd,%al
    1ee9:	74 0b                	je     1ef6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eee:	83 c0 01             	add    $0x1,%eax
    1ef1:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1ef4:	7c a9                	jl     1e9f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ef9:	8b 45 08             	mov    0x8(%ebp),%eax
    1efc:	01 d0                	add    %edx,%eax
    1efe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1f04:	c9                   	leave  
    1f05:	c3                   	ret    

00001f06 <stat>:

int
stat(char *n, struct stat *st)
{
    1f06:	55                   	push   %ebp
    1f07:	89 e5                	mov    %esp,%ebp
    1f09:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1f0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f13:	00 
    1f14:	8b 45 08             	mov    0x8(%ebp),%eax
    1f17:	89 04 24             	mov    %eax,(%esp)
    1f1a:	e8 07 01 00 00       	call   2026 <open>
    1f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1f26:	79 07                	jns    1f2f <stat+0x29>
    return -1;
    1f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1f2d:	eb 23                	jmp    1f52 <stat+0x4c>
  r = fstat(fd, st);
    1f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1f32:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f39:	89 04 24             	mov    %eax,(%esp)
    1f3c:	e8 fd 00 00 00       	call   203e <fstat>
    1f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f47:	89 04 24             	mov    %eax,(%esp)
    1f4a:	e8 bf 00 00 00       	call   200e <close>
  return r;
    1f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1f52:	c9                   	leave  
    1f53:	c3                   	ret    

00001f54 <atoi>:

int
atoi(const char *s)
{
    1f54:	55                   	push   %ebp
    1f55:	89 e5                	mov    %esp,%ebp
    1f57:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1f61:	eb 25                	jmp    1f88 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1f66:	89 d0                	mov    %edx,%eax
    1f68:	c1 e0 02             	shl    $0x2,%eax
    1f6b:	01 d0                	add    %edx,%eax
    1f6d:	01 c0                	add    %eax,%eax
    1f6f:	89 c1                	mov    %eax,%ecx
    1f71:	8b 45 08             	mov    0x8(%ebp),%eax
    1f74:	8d 50 01             	lea    0x1(%eax),%edx
    1f77:	89 55 08             	mov    %edx,0x8(%ebp)
    1f7a:	0f b6 00             	movzbl (%eax),%eax
    1f7d:	0f be c0             	movsbl %al,%eax
    1f80:	01 c8                	add    %ecx,%eax
    1f82:	83 e8 30             	sub    $0x30,%eax
    1f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1f88:	8b 45 08             	mov    0x8(%ebp),%eax
    1f8b:	0f b6 00             	movzbl (%eax),%eax
    1f8e:	3c 2f                	cmp    $0x2f,%al
    1f90:	7e 0a                	jle    1f9c <atoi+0x48>
    1f92:	8b 45 08             	mov    0x8(%ebp),%eax
    1f95:	0f b6 00             	movzbl (%eax),%eax
    1f98:	3c 39                	cmp    $0x39,%al
    1f9a:	7e c7                	jle    1f63 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1f9f:	c9                   	leave  
    1fa0:	c3                   	ret    

00001fa1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1fa1:	55                   	push   %ebp
    1fa2:	89 e5                	mov    %esp,%ebp
    1fa4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1fa7:	8b 45 08             	mov    0x8(%ebp),%eax
    1faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1fad:	8b 45 0c             	mov    0xc(%ebp),%eax
    1fb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1fb3:	eb 17                	jmp    1fcc <memmove+0x2b>
    *dst++ = *src++;
    1fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1fb8:	8d 50 01             	lea    0x1(%eax),%edx
    1fbb:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1fbe:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1fc1:	8d 4a 01             	lea    0x1(%edx),%ecx
    1fc4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1fc7:	0f b6 12             	movzbl (%edx),%edx
    1fca:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1fcc:	8b 45 10             	mov    0x10(%ebp),%eax
    1fcf:	8d 50 ff             	lea    -0x1(%eax),%edx
    1fd2:	89 55 10             	mov    %edx,0x10(%ebp)
    1fd5:	85 c0                	test   %eax,%eax
    1fd7:	7f dc                	jg     1fb5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1fd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1fdc:	c9                   	leave  
    1fdd:	c3                   	ret    

00001fde <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1fde:	b8 01 00 00 00       	mov    $0x1,%eax
    1fe3:	cd 40                	int    $0x40
    1fe5:	c3                   	ret    

00001fe6 <exit>:
SYSCALL(exit)
    1fe6:	b8 02 00 00 00       	mov    $0x2,%eax
    1feb:	cd 40                	int    $0x40
    1fed:	c3                   	ret    

00001fee <wait>:
SYSCALL(wait)
    1fee:	b8 03 00 00 00       	mov    $0x3,%eax
    1ff3:	cd 40                	int    $0x40
    1ff5:	c3                   	ret    

00001ff6 <pipe>:
SYSCALL(pipe)
    1ff6:	b8 04 00 00 00       	mov    $0x4,%eax
    1ffb:	cd 40                	int    $0x40
    1ffd:	c3                   	ret    

00001ffe <read>:
SYSCALL(read)
    1ffe:	b8 05 00 00 00       	mov    $0x5,%eax
    2003:	cd 40                	int    $0x40
    2005:	c3                   	ret    

00002006 <write>:
SYSCALL(write)
    2006:	b8 10 00 00 00       	mov    $0x10,%eax
    200b:	cd 40                	int    $0x40
    200d:	c3                   	ret    

0000200e <close>:
SYSCALL(close)
    200e:	b8 15 00 00 00       	mov    $0x15,%eax
    2013:	cd 40                	int    $0x40
    2015:	c3                   	ret    

00002016 <kill>:
SYSCALL(kill)
    2016:	b8 06 00 00 00       	mov    $0x6,%eax
    201b:	cd 40                	int    $0x40
    201d:	c3                   	ret    

0000201e <exec>:
SYSCALL(exec)
    201e:	b8 07 00 00 00       	mov    $0x7,%eax
    2023:	cd 40                	int    $0x40
    2025:	c3                   	ret    

00002026 <open>:
SYSCALL(open)
    2026:	b8 0f 00 00 00       	mov    $0xf,%eax
    202b:	cd 40                	int    $0x40
    202d:	c3                   	ret    

0000202e <mknod>:
SYSCALL(mknod)
    202e:	b8 11 00 00 00       	mov    $0x11,%eax
    2033:	cd 40                	int    $0x40
    2035:	c3                   	ret    

00002036 <unlink>:
SYSCALL(unlink)
    2036:	b8 12 00 00 00       	mov    $0x12,%eax
    203b:	cd 40                	int    $0x40
    203d:	c3                   	ret    

0000203e <fstat>:
SYSCALL(fstat)
    203e:	b8 08 00 00 00       	mov    $0x8,%eax
    2043:	cd 40                	int    $0x40
    2045:	c3                   	ret    

00002046 <link>:
SYSCALL(link)
    2046:	b8 13 00 00 00       	mov    $0x13,%eax
    204b:	cd 40                	int    $0x40
    204d:	c3                   	ret    

0000204e <mkdir>:
SYSCALL(mkdir)
    204e:	b8 14 00 00 00       	mov    $0x14,%eax
    2053:	cd 40                	int    $0x40
    2055:	c3                   	ret    

00002056 <chdir>:
SYSCALL(chdir)
    2056:	b8 09 00 00 00       	mov    $0x9,%eax
    205b:	cd 40                	int    $0x40
    205d:	c3                   	ret    

0000205e <dup>:
SYSCALL(dup)
    205e:	b8 0a 00 00 00       	mov    $0xa,%eax
    2063:	cd 40                	int    $0x40
    2065:	c3                   	ret    

00002066 <getpid>:
SYSCALL(getpid)
    2066:	b8 0b 00 00 00       	mov    $0xb,%eax
    206b:	cd 40                	int    $0x40
    206d:	c3                   	ret    

0000206e <sbrk>:
SYSCALL(sbrk)
    206e:	b8 0c 00 00 00       	mov    $0xc,%eax
    2073:	cd 40                	int    $0x40
    2075:	c3                   	ret    

00002076 <sleep>:
SYSCALL(sleep)
    2076:	b8 0d 00 00 00       	mov    $0xd,%eax
    207b:	cd 40                	int    $0x40
    207d:	c3                   	ret    

0000207e <uptime>:
SYSCALL(uptime)
    207e:	b8 0e 00 00 00       	mov    $0xe,%eax
    2083:	cd 40                	int    $0x40
    2085:	c3                   	ret    

00002086 <kthread_create>:




SYSCALL(kthread_create)
    2086:	b8 16 00 00 00       	mov    $0x16,%eax
    208b:	cd 40                	int    $0x40
    208d:	c3                   	ret    

0000208e <kthread_id>:
SYSCALL(kthread_id)
    208e:	b8 17 00 00 00       	mov    $0x17,%eax
    2093:	cd 40                	int    $0x40
    2095:	c3                   	ret    

00002096 <kthread_exit>:
SYSCALL(kthread_exit)
    2096:	b8 18 00 00 00       	mov    $0x18,%eax
    209b:	cd 40                	int    $0x40
    209d:	c3                   	ret    

0000209e <kthread_join>:
SYSCALL(kthread_join)
    209e:	b8 19 00 00 00       	mov    $0x19,%eax
    20a3:	cd 40                	int    $0x40
    20a5:	c3                   	ret    

000020a6 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
    20a6:	b8 1a 00 00 00       	mov    $0x1a,%eax
    20ab:	cd 40                	int    $0x40
    20ad:	c3                   	ret    

000020ae <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
    20ae:	b8 1b 00 00 00       	mov    $0x1b,%eax
    20b3:	cd 40                	int    $0x40
    20b5:	c3                   	ret    

000020b6 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
    20b6:	b8 1c 00 00 00       	mov    $0x1c,%eax
    20bb:	cd 40                	int    $0x40
    20bd:	c3                   	ret    

000020be <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
    20be:	b8 1d 00 00 00       	mov    $0x1d,%eax
    20c3:	cd 40                	int    $0x40
    20c5:	c3                   	ret    

000020c6 <kthread_mutex_yieldlock>:
    20c6:	b8 1e 00 00 00       	mov    $0x1e,%eax
    20cb:	cd 40                	int    $0x40
    20cd:	c3                   	ret    

000020ce <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    20ce:	55                   	push   %ebp
    20cf:	89 e5                	mov    %esp,%ebp
    20d1:	83 ec 18             	sub    $0x18,%esp
    20d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    20d7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    20da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20e1:	00 
    20e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
    20e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    20e9:	8b 45 08             	mov    0x8(%ebp),%eax
    20ec:	89 04 24             	mov    %eax,(%esp)
    20ef:	e8 12 ff ff ff       	call   2006 <write>
}
    20f4:	c9                   	leave  
    20f5:	c3                   	ret    

000020f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    20f6:	55                   	push   %ebp
    20f7:	89 e5                	mov    %esp,%ebp
    20f9:	56                   	push   %esi
    20fa:	53                   	push   %ebx
    20fb:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    20fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    2105:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    2109:	74 17                	je     2122 <printint+0x2c>
    210b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    210f:	79 11                	jns    2122 <printint+0x2c>
    neg = 1;
    2111:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    2118:	8b 45 0c             	mov    0xc(%ebp),%eax
    211b:	f7 d8                	neg    %eax
    211d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2120:	eb 06                	jmp    2128 <printint+0x32>
  } else {
    x = xx;
    2122:	8b 45 0c             	mov    0xc(%ebp),%eax
    2125:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    2128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    212f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2132:	8d 41 01             	lea    0x1(%ecx),%eax
    2135:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2138:	8b 5d 10             	mov    0x10(%ebp),%ebx
    213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    213e:	ba 00 00 00 00       	mov    $0x0,%edx
    2143:	f7 f3                	div    %ebx
    2145:	89 d0                	mov    %edx,%eax
    2147:	0f b6 80 4c 37 00 00 	movzbl 0x374c(%eax),%eax
    214e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    2152:	8b 75 10             	mov    0x10(%ebp),%esi
    2155:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2158:	ba 00 00 00 00       	mov    $0x0,%edx
    215d:	f7 f6                	div    %esi
    215f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2162:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2166:	75 c7                	jne    212f <printint+0x39>
  if(neg)
    2168:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    216c:	74 10                	je     217e <printint+0x88>
    buf[i++] = '-';
    216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2171:	8d 50 01             	lea    0x1(%eax),%edx
    2174:	89 55 f4             	mov    %edx,-0xc(%ebp)
    2177:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    217c:	eb 1f                	jmp    219d <printint+0xa7>
    217e:	eb 1d                	jmp    219d <printint+0xa7>
    putc(fd, buf[i]);
    2180:	8d 55 dc             	lea    -0x24(%ebp),%edx
    2183:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2186:	01 d0                	add    %edx,%eax
    2188:	0f b6 00             	movzbl (%eax),%eax
    218b:	0f be c0             	movsbl %al,%eax
    218e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2192:	8b 45 08             	mov    0x8(%ebp),%eax
    2195:	89 04 24             	mov    %eax,(%esp)
    2198:	e8 31 ff ff ff       	call   20ce <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    219d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    21a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21a5:	79 d9                	jns    2180 <printint+0x8a>
    putc(fd, buf[i]);
}
    21a7:	83 c4 30             	add    $0x30,%esp
    21aa:	5b                   	pop    %ebx
    21ab:	5e                   	pop    %esi
    21ac:	5d                   	pop    %ebp
    21ad:	c3                   	ret    

000021ae <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    21ae:	55                   	push   %ebp
    21af:	89 e5                	mov    %esp,%ebp
    21b1:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    21b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    21bb:	8d 45 0c             	lea    0xc(%ebp),%eax
    21be:	83 c0 04             	add    $0x4,%eax
    21c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    21c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    21cb:	e9 7c 01 00 00       	jmp    234c <printf+0x19e>
    c = fmt[i] & 0xff;
    21d0:	8b 55 0c             	mov    0xc(%ebp),%edx
    21d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    21d6:	01 d0                	add    %edx,%eax
    21d8:	0f b6 00             	movzbl (%eax),%eax
    21db:	0f be c0             	movsbl %al,%eax
    21de:	25 ff 00 00 00       	and    $0xff,%eax
    21e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    21e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    21ea:	75 2c                	jne    2218 <printf+0x6a>
      if(c == '%'){
    21ec:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    21f0:	75 0c                	jne    21fe <printf+0x50>
        state = '%';
    21f2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    21f9:	e9 4a 01 00 00       	jmp    2348 <printf+0x19a>
      } else {
        putc(fd, c);
    21fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2201:	0f be c0             	movsbl %al,%eax
    2204:	89 44 24 04          	mov    %eax,0x4(%esp)
    2208:	8b 45 08             	mov    0x8(%ebp),%eax
    220b:	89 04 24             	mov    %eax,(%esp)
    220e:	e8 bb fe ff ff       	call   20ce <putc>
    2213:	e9 30 01 00 00       	jmp    2348 <printf+0x19a>
      }
    } else if(state == '%'){
    2218:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    221c:	0f 85 26 01 00 00    	jne    2348 <printf+0x19a>
      if(c == 'd'){
    2222:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    2226:	75 2d                	jne    2255 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    2228:	8b 45 e8             	mov    -0x18(%ebp),%eax
    222b:	8b 00                	mov    (%eax),%eax
    222d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    2234:	00 
    2235:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    223c:	00 
    223d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2241:	8b 45 08             	mov    0x8(%ebp),%eax
    2244:	89 04 24             	mov    %eax,(%esp)
    2247:	e8 aa fe ff ff       	call   20f6 <printint>
        ap++;
    224c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2250:	e9 ec 00 00 00       	jmp    2341 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    2255:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    2259:	74 06                	je     2261 <printf+0xb3>
    225b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    225f:	75 2d                	jne    228e <printf+0xe0>
        printint(fd, *ap, 16, 0);
    2261:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2264:	8b 00                	mov    (%eax),%eax
    2266:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    226d:	00 
    226e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    2275:	00 
    2276:	89 44 24 04          	mov    %eax,0x4(%esp)
    227a:	8b 45 08             	mov    0x8(%ebp),%eax
    227d:	89 04 24             	mov    %eax,(%esp)
    2280:	e8 71 fe ff ff       	call   20f6 <printint>
        ap++;
    2285:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2289:	e9 b3 00 00 00       	jmp    2341 <printf+0x193>
      } else if(c == 's'){
    228e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    2292:	75 45                	jne    22d9 <printf+0x12b>
        s = (char*)*ap;
    2294:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2297:	8b 00                	mov    (%eax),%eax
    2299:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    229c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    22a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22a4:	75 09                	jne    22af <printf+0x101>
          s = "(null)";
    22a6:	c7 45 f4 5f 31 00 00 	movl   $0x315f,-0xc(%ebp)
        while(*s != 0){
    22ad:	eb 1e                	jmp    22cd <printf+0x11f>
    22af:	eb 1c                	jmp    22cd <printf+0x11f>
          putc(fd, *s);
    22b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22b4:	0f b6 00             	movzbl (%eax),%eax
    22b7:	0f be c0             	movsbl %al,%eax
    22ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    22be:	8b 45 08             	mov    0x8(%ebp),%eax
    22c1:	89 04 24             	mov    %eax,(%esp)
    22c4:	e8 05 fe ff ff       	call   20ce <putc>
          s++;
    22c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    22cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22d0:	0f b6 00             	movzbl (%eax),%eax
    22d3:	84 c0                	test   %al,%al
    22d5:	75 da                	jne    22b1 <printf+0x103>
    22d7:	eb 68                	jmp    2341 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    22d9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    22dd:	75 1d                	jne    22fc <printf+0x14e>
        putc(fd, *ap);
    22df:	8b 45 e8             	mov    -0x18(%ebp),%eax
    22e2:	8b 00                	mov    (%eax),%eax
    22e4:	0f be c0             	movsbl %al,%eax
    22e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    22eb:	8b 45 08             	mov    0x8(%ebp),%eax
    22ee:	89 04 24             	mov    %eax,(%esp)
    22f1:	e8 d8 fd ff ff       	call   20ce <putc>
        ap++;
    22f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    22fa:	eb 45                	jmp    2341 <printf+0x193>
      } else if(c == '%'){
    22fc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    2300:	75 17                	jne    2319 <printf+0x16b>
        putc(fd, c);
    2302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2305:	0f be c0             	movsbl %al,%eax
    2308:	89 44 24 04          	mov    %eax,0x4(%esp)
    230c:	8b 45 08             	mov    0x8(%ebp),%eax
    230f:	89 04 24             	mov    %eax,(%esp)
    2312:	e8 b7 fd ff ff       	call   20ce <putc>
    2317:	eb 28                	jmp    2341 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2319:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    2320:	00 
    2321:	8b 45 08             	mov    0x8(%ebp),%eax
    2324:	89 04 24             	mov    %eax,(%esp)
    2327:	e8 a2 fd ff ff       	call   20ce <putc>
        putc(fd, c);
    232c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    232f:	0f be c0             	movsbl %al,%eax
    2332:	89 44 24 04          	mov    %eax,0x4(%esp)
    2336:	8b 45 08             	mov    0x8(%ebp),%eax
    2339:	89 04 24             	mov    %eax,(%esp)
    233c:	e8 8d fd ff ff       	call   20ce <putc>
      }
      state = 0;
    2341:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2348:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    234c:	8b 55 0c             	mov    0xc(%ebp),%edx
    234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2352:	01 d0                	add    %edx,%eax
    2354:	0f b6 00             	movzbl (%eax),%eax
    2357:	84 c0                	test   %al,%al
    2359:	0f 85 71 fe ff ff    	jne    21d0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    235f:	c9                   	leave  
    2360:	c3                   	ret    

00002361 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2361:	55                   	push   %ebp
    2362:	89 e5                	mov    %esp,%ebp
    2364:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2367:	8b 45 08             	mov    0x8(%ebp),%eax
    236a:	83 e8 08             	sub    $0x8,%eax
    236d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2370:	a1 68 37 00 00       	mov    0x3768,%eax
    2375:	89 45 fc             	mov    %eax,-0x4(%ebp)
    2378:	eb 24                	jmp    239e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    237a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    237d:	8b 00                	mov    (%eax),%eax
    237f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    2382:	77 12                	ja     2396 <free+0x35>
    2384:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2387:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    238a:	77 24                	ja     23b0 <free+0x4f>
    238c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    238f:	8b 00                	mov    (%eax),%eax
    2391:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2394:	77 1a                	ja     23b0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2396:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2399:	8b 00                	mov    (%eax),%eax
    239b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    239e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    23a4:	76 d4                	jbe    237a <free+0x19>
    23a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23a9:	8b 00                	mov    (%eax),%eax
    23ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    23ae:	76 ca                	jbe    237a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    23b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23b3:	8b 40 04             	mov    0x4(%eax),%eax
    23b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    23bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23c0:	01 c2                	add    %eax,%edx
    23c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23c5:	8b 00                	mov    (%eax),%eax
    23c7:	39 c2                	cmp    %eax,%edx
    23c9:	75 24                	jne    23ef <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    23cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23ce:	8b 50 04             	mov    0x4(%eax),%edx
    23d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23d4:	8b 00                	mov    (%eax),%eax
    23d6:	8b 40 04             	mov    0x4(%eax),%eax
    23d9:	01 c2                	add    %eax,%edx
    23db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23de:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    23e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23e4:	8b 00                	mov    (%eax),%eax
    23e6:	8b 10                	mov    (%eax),%edx
    23e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23eb:	89 10                	mov    %edx,(%eax)
    23ed:	eb 0a                	jmp    23f9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    23ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23f2:	8b 10                	mov    (%eax),%edx
    23f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    23f7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    23f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    23fc:	8b 40 04             	mov    0x4(%eax),%eax
    23ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    2406:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2409:	01 d0                	add    %edx,%eax
    240b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    240e:	75 20                	jne    2430 <free+0xcf>
    p->s.size += bp->s.size;
    2410:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2413:	8b 50 04             	mov    0x4(%eax),%edx
    2416:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2419:	8b 40 04             	mov    0x4(%eax),%eax
    241c:	01 c2                	add    %eax,%edx
    241e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2421:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    2424:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2427:	8b 10                	mov    (%eax),%edx
    2429:	8b 45 fc             	mov    -0x4(%ebp),%eax
    242c:	89 10                	mov    %edx,(%eax)
    242e:	eb 08                	jmp    2438 <free+0xd7>
  } else
    p->s.ptr = bp;
    2430:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2433:	8b 55 f8             	mov    -0x8(%ebp),%edx
    2436:	89 10                	mov    %edx,(%eax)
  freep = p;
    2438:	8b 45 fc             	mov    -0x4(%ebp),%eax
    243b:	a3 68 37 00 00       	mov    %eax,0x3768
}
    2440:	c9                   	leave  
    2441:	c3                   	ret    

00002442 <morecore>:

static Header*
morecore(uint nu)
{
    2442:	55                   	push   %ebp
    2443:	89 e5                	mov    %esp,%ebp
    2445:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    2448:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    244f:	77 07                	ja     2458 <morecore+0x16>
    nu = 4096;
    2451:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    2458:	8b 45 08             	mov    0x8(%ebp),%eax
    245b:	c1 e0 03             	shl    $0x3,%eax
    245e:	89 04 24             	mov    %eax,(%esp)
    2461:	e8 08 fc ff ff       	call   206e <sbrk>
    2466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    2469:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    246d:	75 07                	jne    2476 <morecore+0x34>
    return 0;
    246f:	b8 00 00 00 00       	mov    $0x0,%eax
    2474:	eb 22                	jmp    2498 <morecore+0x56>
  hp = (Header*)p;
    2476:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    247f:	8b 55 08             	mov    0x8(%ebp),%edx
    2482:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    2485:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2488:	83 c0 08             	add    $0x8,%eax
    248b:	89 04 24             	mov    %eax,(%esp)
    248e:	e8 ce fe ff ff       	call   2361 <free>
  return freep;
    2493:	a1 68 37 00 00       	mov    0x3768,%eax
}
    2498:	c9                   	leave  
    2499:	c3                   	ret    

0000249a <malloc>:

void*
malloc(uint nbytes)
{
    249a:	55                   	push   %ebp
    249b:	89 e5                	mov    %esp,%ebp
    249d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    24a0:	8b 45 08             	mov    0x8(%ebp),%eax
    24a3:	83 c0 07             	add    $0x7,%eax
    24a6:	c1 e8 03             	shr    $0x3,%eax
    24a9:	83 c0 01             	add    $0x1,%eax
    24ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    24af:	a1 68 37 00 00       	mov    0x3768,%eax
    24b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    24b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    24bb:	75 23                	jne    24e0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    24bd:	c7 45 f0 60 37 00 00 	movl   $0x3760,-0x10(%ebp)
    24c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    24c7:	a3 68 37 00 00       	mov    %eax,0x3768
    24cc:	a1 68 37 00 00       	mov    0x3768,%eax
    24d1:	a3 60 37 00 00       	mov    %eax,0x3760
    base.s.size = 0;
    24d6:	c7 05 64 37 00 00 00 	movl   $0x0,0x3764
    24dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    24e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    24e3:	8b 00                	mov    (%eax),%eax
    24e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    24e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24eb:	8b 40 04             	mov    0x4(%eax),%eax
    24ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    24f1:	72 4d                	jb     2540 <malloc+0xa6>
      if(p->s.size == nunits)
    24f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24f6:	8b 40 04             	mov    0x4(%eax),%eax
    24f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    24fc:	75 0c                	jne    250a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    24fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2501:	8b 10                	mov    (%eax),%edx
    2503:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2506:	89 10                	mov    %edx,(%eax)
    2508:	eb 26                	jmp    2530 <malloc+0x96>
      else {
        p->s.size -= nunits;
    250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    250d:	8b 40 04             	mov    0x4(%eax),%eax
    2510:	2b 45 ec             	sub    -0x14(%ebp),%eax
    2513:	89 c2                	mov    %eax,%edx
    2515:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2518:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    251e:	8b 40 04             	mov    0x4(%eax),%eax
    2521:	c1 e0 03             	shl    $0x3,%eax
    2524:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    2527:	8b 45 f4             	mov    -0xc(%ebp),%eax
    252a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    252d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    2530:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2533:	a3 68 37 00 00       	mov    %eax,0x3768
      return (void*)(p + 1);
    2538:	8b 45 f4             	mov    -0xc(%ebp),%eax
    253b:	83 c0 08             	add    $0x8,%eax
    253e:	eb 38                	jmp    2578 <malloc+0xde>
    }
    if(p == freep)
    2540:	a1 68 37 00 00       	mov    0x3768,%eax
    2545:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    2548:	75 1b                	jne    2565 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    254a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    254d:	89 04 24             	mov    %eax,(%esp)
    2550:	e8 ed fe ff ff       	call   2442 <morecore>
    2555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    255c:	75 07                	jne    2565 <malloc+0xcb>
        return 0;
    255e:	b8 00 00 00 00       	mov    $0x0,%eax
    2563:	eb 13                	jmp    2578 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2568:	89 45 f0             	mov    %eax,-0x10(%ebp)
    256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    256e:	8b 00                	mov    (%eax),%eax
    2570:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    2573:	e9 70 ff ff ff       	jmp    24e8 <malloc+0x4e>
}
    2578:	c9                   	leave  
    2579:	c3                   	ret    

0000257a <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
    257a:	55                   	push   %ebp
    257b:	89 e5                	mov    %esp,%ebp
    257d:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
    2580:	e8 21 fb ff ff       	call   20a6 <kthread_mutex_alloc>
    2585:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
    2588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    258c:	79 0a                	jns    2598 <mesa_slots_monitor_alloc+0x1e>
		return 0;
    258e:	b8 00 00 00 00       	mov    $0x0,%eax
    2593:	e9 8b 00 00 00       	jmp    2623 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
    2598:	e8 44 06 00 00       	call   2be1 <mesa_cond_alloc>
    259d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
    25a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    25a4:	75 12                	jne    25b8 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
    25a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25a9:	89 04 24             	mov    %eax,(%esp)
    25ac:	e8 fd fa ff ff       	call   20ae <kthread_mutex_dealloc>
		return 0;
    25b1:	b8 00 00 00 00       	mov    $0x0,%eax
    25b6:	eb 6b                	jmp    2623 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
    25b8:	e8 24 06 00 00       	call   2be1 <mesa_cond_alloc>
    25bd:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
    25c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    25c4:	75 1d                	jne    25e3 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
    25c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25c9:	89 04 24             	mov    %eax,(%esp)
    25cc:	e8 dd fa ff ff       	call   20ae <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
    25d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    25d4:	89 04 24             	mov    %eax,(%esp)
    25d7:	e8 46 06 00 00       	call   2c22 <mesa_cond_dealloc>
		return 0;
    25dc:	b8 00 00 00 00       	mov    $0x0,%eax
    25e1:	eb 40                	jmp    2623 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
    25e3:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
    25ea:	e8 ab fe ff ff       	call   249a <malloc>
    25ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
    25f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    25f8:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
    25fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
    2601:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
    2604:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2607:	8b 55 f4             	mov    -0xc(%ebp),%edx
    260a:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
    260c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    260f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
    2616:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2619:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
    2620:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
    2623:	c9                   	leave  
    2624:	c3                   	ret    

00002625 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
    2625:	55                   	push   %ebp
    2626:	89 e5                	mov    %esp,%ebp
    2628:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
    262b:	8b 45 08             	mov    0x8(%ebp),%eax
    262e:	8b 00                	mov    (%eax),%eax
    2630:	89 04 24             	mov    %eax,(%esp)
    2633:	e8 76 fa ff ff       	call   20ae <kthread_mutex_dealloc>
    2638:	85 c0                	test   %eax,%eax
    263a:	78 2e                	js     266a <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
    263c:	8b 45 08             	mov    0x8(%ebp),%eax
    263f:	8b 40 04             	mov    0x4(%eax),%eax
    2642:	89 04 24             	mov    %eax,(%esp)
    2645:	e8 97 05 00 00       	call   2be1 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
    264a:	8b 45 08             	mov    0x8(%ebp),%eax
    264d:	8b 40 08             	mov    0x8(%eax),%eax
    2650:	89 04 24             	mov    %eax,(%esp)
    2653:	e8 89 05 00 00       	call   2be1 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
    2658:	8b 45 08             	mov    0x8(%ebp),%eax
    265b:	89 04 24             	mov    %eax,(%esp)
    265e:	e8 fe fc ff ff       	call   2361 <free>
	return 0;
    2663:	b8 00 00 00 00       	mov    $0x0,%eax
    2668:	eb 05                	jmp    266f <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
    266a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
    266f:	c9                   	leave  
    2670:	c3                   	ret    

00002671 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
    2671:	55                   	push   %ebp
    2672:	89 e5                	mov    %esp,%ebp
    2674:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
    2677:	8b 45 08             	mov    0x8(%ebp),%eax
    267a:	8b 40 10             	mov    0x10(%eax),%eax
    267d:	85 c0                	test   %eax,%eax
    267f:	75 0a                	jne    268b <mesa_slots_monitor_addslots+0x1a>
		return -1;
    2681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2686:	e9 81 00 00 00       	jmp    270c <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    268b:	8b 45 08             	mov    0x8(%ebp),%eax
    268e:	8b 00                	mov    (%eax),%eax
    2690:	89 04 24             	mov    %eax,(%esp)
    2693:	e8 1e fa ff ff       	call   20b6 <kthread_mutex_lock>
    2698:	83 f8 ff             	cmp    $0xffffffff,%eax
    269b:	7d 07                	jge    26a4 <mesa_slots_monitor_addslots+0x33>
		return -1;
    269d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    26a2:	eb 68                	jmp    270c <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
    26a4:	eb 17                	jmp    26bd <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
    26a6:	8b 45 08             	mov    0x8(%ebp),%eax
    26a9:	8b 10                	mov    (%eax),%edx
    26ab:	8b 45 08             	mov    0x8(%ebp),%eax
    26ae:	8b 40 08             	mov    0x8(%eax),%eax
    26b1:	89 54 24 04          	mov    %edx,0x4(%esp)
    26b5:	89 04 24             	mov    %eax,(%esp)
    26b8:	e8 af 05 00 00       	call   2c6c <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
    26bd:	8b 45 08             	mov    0x8(%ebp),%eax
    26c0:	8b 40 10             	mov    0x10(%eax),%eax
    26c3:	85 c0                	test   %eax,%eax
    26c5:	74 0a                	je     26d1 <mesa_slots_monitor_addslots+0x60>
    26c7:	8b 45 08             	mov    0x8(%ebp),%eax
    26ca:	8b 40 0c             	mov    0xc(%eax),%eax
    26cd:	85 c0                	test   %eax,%eax
    26cf:	7f d5                	jg     26a6 <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
    26d1:	8b 45 08             	mov    0x8(%ebp),%eax
    26d4:	8b 40 10             	mov    0x10(%eax),%eax
    26d7:	85 c0                	test   %eax,%eax
    26d9:	74 11                	je     26ec <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
    26db:	8b 45 08             	mov    0x8(%ebp),%eax
    26de:	8b 50 0c             	mov    0xc(%eax),%edx
    26e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    26e4:	01 c2                	add    %eax,%edx
    26e6:	8b 45 08             	mov    0x8(%ebp),%eax
    26e9:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
    26ec:	8b 45 08             	mov    0x8(%ebp),%eax
    26ef:	8b 40 04             	mov    0x4(%eax),%eax
    26f2:	89 04 24             	mov    %eax,(%esp)
    26f5:	e8 dc 05 00 00       	call   2cd6 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
    26fa:	8b 45 08             	mov    0x8(%ebp),%eax
    26fd:	8b 00                	mov    (%eax),%eax
    26ff:	89 04 24             	mov    %eax,(%esp)
    2702:	e8 b7 f9 ff ff       	call   20be <kthread_mutex_unlock>

	return 1;
    2707:	b8 01 00 00 00       	mov    $0x1,%eax


}
    270c:	c9                   	leave  
    270d:	c3                   	ret    

0000270e <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
    270e:	55                   	push   %ebp
    270f:	89 e5                	mov    %esp,%ebp
    2711:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
    2714:	8b 45 08             	mov    0x8(%ebp),%eax
    2717:	8b 40 10             	mov    0x10(%eax),%eax
    271a:	85 c0                	test   %eax,%eax
    271c:	75 07                	jne    2725 <mesa_slots_monitor_takeslot+0x17>
		return -1;
    271e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2723:	eb 7f                	jmp    27a4 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    2725:	8b 45 08             	mov    0x8(%ebp),%eax
    2728:	8b 00                	mov    (%eax),%eax
    272a:	89 04 24             	mov    %eax,(%esp)
    272d:	e8 84 f9 ff ff       	call   20b6 <kthread_mutex_lock>
    2732:	83 f8 ff             	cmp    $0xffffffff,%eax
    2735:	7d 07                	jge    273e <mesa_slots_monitor_takeslot+0x30>
		return -1;
    2737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    273c:	eb 66                	jmp    27a4 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
    273e:	eb 17                	jmp    2757 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
    2740:	8b 45 08             	mov    0x8(%ebp),%eax
    2743:	8b 10                	mov    (%eax),%edx
    2745:	8b 45 08             	mov    0x8(%ebp),%eax
    2748:	8b 40 04             	mov    0x4(%eax),%eax
    274b:	89 54 24 04          	mov    %edx,0x4(%esp)
    274f:	89 04 24             	mov    %eax,(%esp)
    2752:	e8 15 05 00 00       	call   2c6c <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
    2757:	8b 45 08             	mov    0x8(%ebp),%eax
    275a:	8b 40 10             	mov    0x10(%eax),%eax
    275d:	85 c0                	test   %eax,%eax
    275f:	74 0a                	je     276b <mesa_slots_monitor_takeslot+0x5d>
    2761:	8b 45 08             	mov    0x8(%ebp),%eax
    2764:	8b 40 0c             	mov    0xc(%eax),%eax
    2767:	85 c0                	test   %eax,%eax
    2769:	74 d5                	je     2740 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
    276b:	8b 45 08             	mov    0x8(%ebp),%eax
    276e:	8b 40 10             	mov    0x10(%eax),%eax
    2771:	85 c0                	test   %eax,%eax
    2773:	74 0f                	je     2784 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
    2775:	8b 45 08             	mov    0x8(%ebp),%eax
    2778:	8b 40 0c             	mov    0xc(%eax),%eax
    277b:	8d 50 ff             	lea    -0x1(%eax),%edx
    277e:	8b 45 08             	mov    0x8(%ebp),%eax
    2781:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
    2784:	8b 45 08             	mov    0x8(%ebp),%eax
    2787:	8b 40 08             	mov    0x8(%eax),%eax
    278a:	89 04 24             	mov    %eax,(%esp)
    278d:	e8 44 05 00 00       	call   2cd6 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
    2792:	8b 45 08             	mov    0x8(%ebp),%eax
    2795:	8b 00                	mov    (%eax),%eax
    2797:	89 04 24             	mov    %eax,(%esp)
    279a:	e8 1f f9 ff ff       	call   20be <kthread_mutex_unlock>

	return 1;
    279f:	b8 01 00 00 00       	mov    $0x1,%eax

}
    27a4:	c9                   	leave  
    27a5:	c3                   	ret    

000027a6 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
    27a6:	55                   	push   %ebp
    27a7:	89 e5                	mov    %esp,%ebp
    27a9:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
    27ac:	8b 45 08             	mov    0x8(%ebp),%eax
    27af:	8b 40 10             	mov    0x10(%eax),%eax
    27b2:	85 c0                	test   %eax,%eax
    27b4:	75 07                	jne    27bd <mesa_slots_monitor_stopadding+0x17>
			return -1;
    27b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    27bb:	eb 35                	jmp    27f2 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    27bd:	8b 45 08             	mov    0x8(%ebp),%eax
    27c0:	8b 00                	mov    (%eax),%eax
    27c2:	89 04 24             	mov    %eax,(%esp)
    27c5:	e8 ec f8 ff ff       	call   20b6 <kthread_mutex_lock>
    27ca:	83 f8 ff             	cmp    $0xffffffff,%eax
    27cd:	7d 07                	jge    27d6 <mesa_slots_monitor_stopadding+0x30>
			return -1;
    27cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    27d4:	eb 1c                	jmp    27f2 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
    27d6:	8b 45 08             	mov    0x8(%ebp),%eax
    27d9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
    27e0:	8b 45 08             	mov    0x8(%ebp),%eax
    27e3:	8b 00                	mov    (%eax),%eax
    27e5:	89 04 24             	mov    %eax,(%esp)
    27e8:	e8 d1 f8 ff ff       	call   20be <kthread_mutex_unlock>

		return 0;
    27ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
    27f2:	c9                   	leave  
    27f3:	c3                   	ret    

000027f4 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
    27f4:	55                   	push   %ebp
    27f5:	89 e5                	mov    %esp,%ebp
    27f7:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
    27fa:	e8 a7 f8 ff ff       	call   20a6 <kthread_mutex_alloc>
    27ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
    2802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2806:	79 0a                	jns    2812 <hoare_slots_monitor_alloc+0x1e>
		return 0;
    2808:	b8 00 00 00 00       	mov    $0x0,%eax
    280d:	e9 8b 00 00 00       	jmp    289d <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
    2812:	e8 68 02 00 00       	call   2a7f <hoare_cond_alloc>
    2817:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
    281a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    281e:	75 12                	jne    2832 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
    2820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2823:	89 04 24             	mov    %eax,(%esp)
    2826:	e8 83 f8 ff ff       	call   20ae <kthread_mutex_dealloc>
		return 0;
    282b:	b8 00 00 00 00       	mov    $0x0,%eax
    2830:	eb 6b                	jmp    289d <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
    2832:	e8 48 02 00 00       	call   2a7f <hoare_cond_alloc>
    2837:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
    283a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    283e:	75 1d                	jne    285d <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
    2840:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2843:	89 04 24             	mov    %eax,(%esp)
    2846:	e8 63 f8 ff ff       	call   20ae <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
    284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    284e:	89 04 24             	mov    %eax,(%esp)
    2851:	e8 6a 02 00 00       	call   2ac0 <hoare_cond_dealloc>
		return 0;
    2856:	b8 00 00 00 00       	mov    $0x0,%eax
    285b:	eb 40                	jmp    289d <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
    285d:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
    2864:	e8 31 fc ff ff       	call   249a <malloc>
    2869:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
    286c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    286f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    2872:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
    2875:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2878:	8b 55 ec             	mov    -0x14(%ebp),%edx
    287b:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
    287e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2881:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2884:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
    2886:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2889:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
    2890:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2893:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
    289a:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
    289d:	c9                   	leave  
    289e:	c3                   	ret    

0000289f <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
    289f:	55                   	push   %ebp
    28a0:	89 e5                	mov    %esp,%ebp
    28a2:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
    28a5:	8b 45 08             	mov    0x8(%ebp),%eax
    28a8:	8b 00                	mov    (%eax),%eax
    28aa:	89 04 24             	mov    %eax,(%esp)
    28ad:	e8 fc f7 ff ff       	call   20ae <kthread_mutex_dealloc>
    28b2:	85 c0                	test   %eax,%eax
    28b4:	78 2e                	js     28e4 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
    28b6:	8b 45 08             	mov    0x8(%ebp),%eax
    28b9:	8b 40 04             	mov    0x4(%eax),%eax
    28bc:	89 04 24             	mov    %eax,(%esp)
    28bf:	e8 bb 01 00 00       	call   2a7f <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
    28c4:	8b 45 08             	mov    0x8(%ebp),%eax
    28c7:	8b 40 08             	mov    0x8(%eax),%eax
    28ca:	89 04 24             	mov    %eax,(%esp)
    28cd:	e8 ad 01 00 00       	call   2a7f <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
    28d2:	8b 45 08             	mov    0x8(%ebp),%eax
    28d5:	89 04 24             	mov    %eax,(%esp)
    28d8:	e8 84 fa ff ff       	call   2361 <free>
	return 0;
    28dd:	b8 00 00 00 00       	mov    $0x0,%eax
    28e2:	eb 05                	jmp    28e9 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
    28e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
    28e9:	c9                   	leave  
    28ea:	c3                   	ret    

000028eb <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
    28eb:	55                   	push   %ebp
    28ec:	89 e5                	mov    %esp,%ebp
    28ee:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
    28f1:	8b 45 08             	mov    0x8(%ebp),%eax
    28f4:	8b 40 10             	mov    0x10(%eax),%eax
    28f7:	85 c0                	test   %eax,%eax
    28f9:	75 0a                	jne    2905 <hoare_slots_monitor_addslots+0x1a>
		return -1;
    28fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2900:	e9 88 00 00 00       	jmp    298d <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    2905:	8b 45 08             	mov    0x8(%ebp),%eax
    2908:	8b 00                	mov    (%eax),%eax
    290a:	89 04 24             	mov    %eax,(%esp)
    290d:	e8 a4 f7 ff ff       	call   20b6 <kthread_mutex_lock>
    2912:	83 f8 ff             	cmp    $0xffffffff,%eax
    2915:	7d 07                	jge    291e <hoare_slots_monitor_addslots+0x33>
		return -1;
    2917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    291c:	eb 6f                	jmp    298d <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
    291e:	8b 45 08             	mov    0x8(%ebp),%eax
    2921:	8b 40 10             	mov    0x10(%eax),%eax
    2924:	85 c0                	test   %eax,%eax
    2926:	74 21                	je     2949 <hoare_slots_monitor_addslots+0x5e>
    2928:	8b 45 08             	mov    0x8(%ebp),%eax
    292b:	8b 40 0c             	mov    0xc(%eax),%eax
    292e:	85 c0                	test   %eax,%eax
    2930:	7e 17                	jle    2949 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
    2932:	8b 45 08             	mov    0x8(%ebp),%eax
    2935:	8b 10                	mov    (%eax),%edx
    2937:	8b 45 08             	mov    0x8(%ebp),%eax
    293a:	8b 40 08             	mov    0x8(%eax),%eax
    293d:	89 54 24 04          	mov    %edx,0x4(%esp)
    2941:	89 04 24             	mov    %eax,(%esp)
    2944:	e8 c1 01 00 00       	call   2b0a <hoare_cond_wait>


	if  ( monitor->active)
    2949:	8b 45 08             	mov    0x8(%ebp),%eax
    294c:	8b 40 10             	mov    0x10(%eax),%eax
    294f:	85 c0                	test   %eax,%eax
    2951:	74 11                	je     2964 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
    2953:	8b 45 08             	mov    0x8(%ebp),%eax
    2956:	8b 50 0c             	mov    0xc(%eax),%edx
    2959:	8b 45 0c             	mov    0xc(%ebp),%eax
    295c:	01 c2                	add    %eax,%edx
    295e:	8b 45 08             	mov    0x8(%ebp),%eax
    2961:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
    2964:	8b 45 08             	mov    0x8(%ebp),%eax
    2967:	8b 10                	mov    (%eax),%edx
    2969:	8b 45 08             	mov    0x8(%ebp),%eax
    296c:	8b 40 04             	mov    0x4(%eax),%eax
    296f:	89 54 24 04          	mov    %edx,0x4(%esp)
    2973:	89 04 24             	mov    %eax,(%esp)
    2976:	e8 e6 01 00 00       	call   2b61 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
    297b:	8b 45 08             	mov    0x8(%ebp),%eax
    297e:	8b 00                	mov    (%eax),%eax
    2980:	89 04 24             	mov    %eax,(%esp)
    2983:	e8 36 f7 ff ff       	call   20be <kthread_mutex_unlock>

	return 1;
    2988:	b8 01 00 00 00       	mov    $0x1,%eax


}
    298d:	c9                   	leave  
    298e:	c3                   	ret    

0000298f <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
    298f:	55                   	push   %ebp
    2990:	89 e5                	mov    %esp,%ebp
    2992:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
    2995:	8b 45 08             	mov    0x8(%ebp),%eax
    2998:	8b 40 10             	mov    0x10(%eax),%eax
    299b:	85 c0                	test   %eax,%eax
    299d:	75 0a                	jne    29a9 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
    299f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    29a4:	e9 86 00 00 00       	jmp    2a2f <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    29a9:	8b 45 08             	mov    0x8(%ebp),%eax
    29ac:	8b 00                	mov    (%eax),%eax
    29ae:	89 04 24             	mov    %eax,(%esp)
    29b1:	e8 00 f7 ff ff       	call   20b6 <kthread_mutex_lock>
    29b6:	83 f8 ff             	cmp    $0xffffffff,%eax
    29b9:	7d 07                	jge    29c2 <hoare_slots_monitor_takeslot+0x33>
		return -1;
    29bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    29c0:	eb 6d                	jmp    2a2f <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
    29c2:	8b 45 08             	mov    0x8(%ebp),%eax
    29c5:	8b 40 10             	mov    0x10(%eax),%eax
    29c8:	85 c0                	test   %eax,%eax
    29ca:	74 21                	je     29ed <hoare_slots_monitor_takeslot+0x5e>
    29cc:	8b 45 08             	mov    0x8(%ebp),%eax
    29cf:	8b 40 0c             	mov    0xc(%eax),%eax
    29d2:	85 c0                	test   %eax,%eax
    29d4:	75 17                	jne    29ed <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
    29d6:	8b 45 08             	mov    0x8(%ebp),%eax
    29d9:	8b 10                	mov    (%eax),%edx
    29db:	8b 45 08             	mov    0x8(%ebp),%eax
    29de:	8b 40 04             	mov    0x4(%eax),%eax
    29e1:	89 54 24 04          	mov    %edx,0x4(%esp)
    29e5:	89 04 24             	mov    %eax,(%esp)
    29e8:	e8 1d 01 00 00       	call   2b0a <hoare_cond_wait>


	if  ( monitor->active)
    29ed:	8b 45 08             	mov    0x8(%ebp),%eax
    29f0:	8b 40 10             	mov    0x10(%eax),%eax
    29f3:	85 c0                	test   %eax,%eax
    29f5:	74 0f                	je     2a06 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
    29f7:	8b 45 08             	mov    0x8(%ebp),%eax
    29fa:	8b 40 0c             	mov    0xc(%eax),%eax
    29fd:	8d 50 ff             	lea    -0x1(%eax),%edx
    2a00:	8b 45 08             	mov    0x8(%ebp),%eax
    2a03:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
    2a06:	8b 45 08             	mov    0x8(%ebp),%eax
    2a09:	8b 10                	mov    (%eax),%edx
    2a0b:	8b 45 08             	mov    0x8(%ebp),%eax
    2a0e:	8b 40 08             	mov    0x8(%eax),%eax
    2a11:	89 54 24 04          	mov    %edx,0x4(%esp)
    2a15:	89 04 24             	mov    %eax,(%esp)
    2a18:	e8 44 01 00 00       	call   2b61 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
    2a1d:	8b 45 08             	mov    0x8(%ebp),%eax
    2a20:	8b 00                	mov    (%eax),%eax
    2a22:	89 04 24             	mov    %eax,(%esp)
    2a25:	e8 94 f6 ff ff       	call   20be <kthread_mutex_unlock>

	return 1;
    2a2a:	b8 01 00 00 00       	mov    $0x1,%eax

}
    2a2f:	c9                   	leave  
    2a30:	c3                   	ret    

00002a31 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
    2a31:	55                   	push   %ebp
    2a32:	89 e5                	mov    %esp,%ebp
    2a34:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
    2a37:	8b 45 08             	mov    0x8(%ebp),%eax
    2a3a:	8b 40 10             	mov    0x10(%eax),%eax
    2a3d:	85 c0                	test   %eax,%eax
    2a3f:	75 07                	jne    2a48 <hoare_slots_monitor_stopadding+0x17>
			return -1;
    2a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2a46:	eb 35                	jmp    2a7d <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    2a48:	8b 45 08             	mov    0x8(%ebp),%eax
    2a4b:	8b 00                	mov    (%eax),%eax
    2a4d:	89 04 24             	mov    %eax,(%esp)
    2a50:	e8 61 f6 ff ff       	call   20b6 <kthread_mutex_lock>
    2a55:	83 f8 ff             	cmp    $0xffffffff,%eax
    2a58:	7d 07                	jge    2a61 <hoare_slots_monitor_stopadding+0x30>
			return -1;
    2a5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2a5f:	eb 1c                	jmp    2a7d <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
    2a61:	8b 45 08             	mov    0x8(%ebp),%eax
    2a64:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
    2a6b:	8b 45 08             	mov    0x8(%ebp),%eax
    2a6e:	8b 00                	mov    (%eax),%eax
    2a70:	89 04 24             	mov    %eax,(%esp)
    2a73:	e8 46 f6 ff ff       	call   20be <kthread_mutex_unlock>

		return 0;
    2a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2a7d:	c9                   	leave  
    2a7e:	c3                   	ret    

00002a7f <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
    2a7f:	55                   	push   %ebp
    2a80:	89 e5                	mov    %esp,%ebp
    2a82:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    2a85:	e8 1c f6 ff ff       	call   20a6 <kthread_mutex_alloc>
    2a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    2a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a91:	79 07                	jns    2a9a <hoare_cond_alloc+0x1b>
		return 0;
    2a93:	b8 00 00 00 00       	mov    $0x0,%eax
    2a98:	eb 24                	jmp    2abe <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    2a9a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    2aa1:	e8 f4 f9 ff ff       	call   249a <malloc>
    2aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    2aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2aaf:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    2ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    2abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    2abe:	c9                   	leave  
    2abf:	c3                   	ret    

00002ac0 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    2ac0:	55                   	push   %ebp
    2ac1:	89 e5                	mov    %esp,%ebp
    2ac3:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    2ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2aca:	75 07                	jne    2ad3 <hoare_cond_dealloc+0x13>
			return -1;
    2acc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2ad1:	eb 35                	jmp    2b08 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    2ad3:	8b 45 08             	mov    0x8(%ebp),%eax
    2ad6:	8b 00                	mov    (%eax),%eax
    2ad8:	89 04 24             	mov    %eax,(%esp)
    2adb:	e8 de f5 ff ff       	call   20be <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    2ae0:	8b 45 08             	mov    0x8(%ebp),%eax
    2ae3:	8b 00                	mov    (%eax),%eax
    2ae5:	89 04 24             	mov    %eax,(%esp)
    2ae8:	e8 c1 f5 ff ff       	call   20ae <kthread_mutex_dealloc>
    2aed:	85 c0                	test   %eax,%eax
    2aef:	79 07                	jns    2af8 <hoare_cond_dealloc+0x38>
			return -1;
    2af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2af6:	eb 10                	jmp    2b08 <hoare_cond_dealloc+0x48>

		free (hCond);
    2af8:	8b 45 08             	mov    0x8(%ebp),%eax
    2afb:	89 04 24             	mov    %eax,(%esp)
    2afe:	e8 5e f8 ff ff       	call   2361 <free>
		return 0;
    2b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2b08:	c9                   	leave  
    2b09:	c3                   	ret    

00002b0a <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    2b0a:	55                   	push   %ebp
    2b0b:	89 e5                	mov    %esp,%ebp
    2b0d:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    2b10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2b14:	75 07                	jne    2b1d <hoare_cond_wait+0x13>
			return -1;
    2b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2b1b:	eb 42                	jmp    2b5f <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    2b1d:	8b 45 08             	mov    0x8(%ebp),%eax
    2b20:	8b 40 04             	mov    0x4(%eax),%eax
    2b23:	8d 50 01             	lea    0x1(%eax),%edx
    2b26:	8b 45 08             	mov    0x8(%ebp),%eax
    2b29:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    2b2c:	8b 45 08             	mov    0x8(%ebp),%eax
    2b2f:	8b 00                	mov    (%eax),%eax
    2b31:	89 44 24 04          	mov    %eax,0x4(%esp)
    2b35:	8b 45 0c             	mov    0xc(%ebp),%eax
    2b38:	89 04 24             	mov    %eax,(%esp)
    2b3b:	e8 86 f5 ff ff       	call   20c6 <kthread_mutex_yieldlock>
    2b40:	85 c0                	test   %eax,%eax
    2b42:	79 16                	jns    2b5a <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    2b44:	8b 45 08             	mov    0x8(%ebp),%eax
    2b47:	8b 40 04             	mov    0x4(%eax),%eax
    2b4a:	8d 50 ff             	lea    -0x1(%eax),%edx
    2b4d:	8b 45 08             	mov    0x8(%ebp),%eax
    2b50:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    2b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2b58:	eb 05                	jmp    2b5f <hoare_cond_wait+0x55>
		}

	return 0;
    2b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2b5f:	c9                   	leave  
    2b60:	c3                   	ret    

00002b61 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    2b61:	55                   	push   %ebp
    2b62:	89 e5                	mov    %esp,%ebp
    2b64:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    2b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2b6b:	75 07                	jne    2b74 <hoare_cond_signal+0x13>
		return -1;
    2b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2b72:	eb 6b                	jmp    2bdf <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    2b74:	8b 45 08             	mov    0x8(%ebp),%eax
    2b77:	8b 40 04             	mov    0x4(%eax),%eax
    2b7a:	85 c0                	test   %eax,%eax
    2b7c:	7e 3d                	jle    2bbb <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    2b7e:	8b 45 08             	mov    0x8(%ebp),%eax
    2b81:	8b 40 04             	mov    0x4(%eax),%eax
    2b84:	8d 50 ff             	lea    -0x1(%eax),%edx
    2b87:	8b 45 08             	mov    0x8(%ebp),%eax
    2b8a:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    2b8d:	8b 45 08             	mov    0x8(%ebp),%eax
    2b90:	8b 00                	mov    (%eax),%eax
    2b92:	89 44 24 04          	mov    %eax,0x4(%esp)
    2b96:	8b 45 0c             	mov    0xc(%ebp),%eax
    2b99:	89 04 24             	mov    %eax,(%esp)
    2b9c:	e8 25 f5 ff ff       	call   20c6 <kthread_mutex_yieldlock>
    2ba1:	85 c0                	test   %eax,%eax
    2ba3:	79 16                	jns    2bbb <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    2ba5:	8b 45 08             	mov    0x8(%ebp),%eax
    2ba8:	8b 40 04             	mov    0x4(%eax),%eax
    2bab:	8d 50 01             	lea    0x1(%eax),%edx
    2bae:	8b 45 08             	mov    0x8(%ebp),%eax
    2bb1:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    2bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2bb9:	eb 24                	jmp    2bdf <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    2bbb:	8b 45 08             	mov    0x8(%ebp),%eax
    2bbe:	8b 00                	mov    (%eax),%eax
    2bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
    2bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
    2bc7:	89 04 24             	mov    %eax,(%esp)
    2bca:	e8 f7 f4 ff ff       	call   20c6 <kthread_mutex_yieldlock>
    2bcf:	85 c0                	test   %eax,%eax
    2bd1:	79 07                	jns    2bda <hoare_cond_signal+0x79>

    			return -1;
    2bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2bd8:	eb 05                	jmp    2bdf <hoare_cond_signal+0x7e>
    }

	return 0;
    2bda:	b8 00 00 00 00       	mov    $0x0,%eax

}
    2bdf:	c9                   	leave  
    2be0:	c3                   	ret    

00002be1 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    2be1:	55                   	push   %ebp
    2be2:	89 e5                	mov    %esp,%ebp
    2be4:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    2be7:	e8 ba f4 ff ff       	call   20a6 <kthread_mutex_alloc>
    2bec:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    2bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2bf3:	79 07                	jns    2bfc <mesa_cond_alloc+0x1b>
		return 0;
    2bf5:	b8 00 00 00 00       	mov    $0x0,%eax
    2bfa:	eb 24                	jmp    2c20 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    2bfc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    2c03:	e8 92 f8 ff ff       	call   249a <malloc>
    2c08:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    2c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2c11:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    2c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2c16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    2c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    2c20:	c9                   	leave  
    2c21:	c3                   	ret    

00002c22 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    2c22:	55                   	push   %ebp
    2c23:	89 e5                	mov    %esp,%ebp
    2c25:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    2c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2c2c:	75 07                	jne    2c35 <mesa_cond_dealloc+0x13>
		return -1;
    2c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2c33:	eb 35                	jmp    2c6a <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    2c35:	8b 45 08             	mov    0x8(%ebp),%eax
    2c38:	8b 00                	mov    (%eax),%eax
    2c3a:	89 04 24             	mov    %eax,(%esp)
    2c3d:	e8 7c f4 ff ff       	call   20be <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    2c42:	8b 45 08             	mov    0x8(%ebp),%eax
    2c45:	8b 00                	mov    (%eax),%eax
    2c47:	89 04 24             	mov    %eax,(%esp)
    2c4a:	e8 5f f4 ff ff       	call   20ae <kthread_mutex_dealloc>
    2c4f:	85 c0                	test   %eax,%eax
    2c51:	79 07                	jns    2c5a <mesa_cond_dealloc+0x38>
		return -1;
    2c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2c58:	eb 10                	jmp    2c6a <mesa_cond_dealloc+0x48>

	free (mCond);
    2c5a:	8b 45 08             	mov    0x8(%ebp),%eax
    2c5d:	89 04 24             	mov    %eax,(%esp)
    2c60:	e8 fc f6 ff ff       	call   2361 <free>
	return 0;
    2c65:	b8 00 00 00 00       	mov    $0x0,%eax

}
    2c6a:	c9                   	leave  
    2c6b:	c3                   	ret    

00002c6c <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    2c6c:	55                   	push   %ebp
    2c6d:	89 e5                	mov    %esp,%ebp
    2c6f:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    2c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2c76:	75 07                	jne    2c7f <mesa_cond_wait+0x13>
		return -1;
    2c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2c7d:	eb 55                	jmp    2cd4 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    2c7f:	8b 45 08             	mov    0x8(%ebp),%eax
    2c82:	8b 40 04             	mov    0x4(%eax),%eax
    2c85:	8d 50 01             	lea    0x1(%eax),%edx
    2c88:	8b 45 08             	mov    0x8(%ebp),%eax
    2c8b:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    2c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
    2c91:	89 04 24             	mov    %eax,(%esp)
    2c94:	e8 25 f4 ff ff       	call   20be <kthread_mutex_unlock>
    2c99:	85 c0                	test   %eax,%eax
    2c9b:	79 27                	jns    2cc4 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    2c9d:	8b 45 08             	mov    0x8(%ebp),%eax
    2ca0:	8b 00                	mov    (%eax),%eax
    2ca2:	89 04 24             	mov    %eax,(%esp)
    2ca5:	e8 0c f4 ff ff       	call   20b6 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    2caa:	85 c0                	test   %eax,%eax
    2cac:	79 16                	jns    2cc4 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    2cae:	8b 45 08             	mov    0x8(%ebp),%eax
    2cb1:	8b 40 04             	mov    0x4(%eax),%eax
    2cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
    2cb7:	8b 45 08             	mov    0x8(%ebp),%eax
    2cba:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    2cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2cc2:	eb 10                	jmp    2cd4 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    2cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
    2cc7:	89 04 24             	mov    %eax,(%esp)
    2cca:	e8 e7 f3 ff ff       	call   20b6 <kthread_mutex_lock>
	return 0;
    2ccf:	b8 00 00 00 00       	mov    $0x0,%eax


}
    2cd4:	c9                   	leave  
    2cd5:	c3                   	ret    

00002cd6 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    2cd6:	55                   	push   %ebp
    2cd7:	89 e5                	mov    %esp,%ebp
    2cd9:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    2cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    2ce0:	75 07                	jne    2ce9 <mesa_cond_signal+0x13>
		return -1;
    2ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2ce7:	eb 5d                	jmp    2d46 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    2ce9:	8b 45 08             	mov    0x8(%ebp),%eax
    2cec:	8b 40 04             	mov    0x4(%eax),%eax
    2cef:	85 c0                	test   %eax,%eax
    2cf1:	7e 36                	jle    2d29 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    2cf3:	8b 45 08             	mov    0x8(%ebp),%eax
    2cf6:	8b 40 04             	mov    0x4(%eax),%eax
    2cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
    2cfc:	8b 45 08             	mov    0x8(%ebp),%eax
    2cff:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    2d02:	8b 45 08             	mov    0x8(%ebp),%eax
    2d05:	8b 00                	mov    (%eax),%eax
    2d07:	89 04 24             	mov    %eax,(%esp)
    2d0a:	e8 af f3 ff ff       	call   20be <kthread_mutex_unlock>
    2d0f:	85 c0                	test   %eax,%eax
    2d11:	78 16                	js     2d29 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    2d13:	8b 45 08             	mov    0x8(%ebp),%eax
    2d16:	8b 40 04             	mov    0x4(%eax),%eax
    2d19:	8d 50 01             	lea    0x1(%eax),%edx
    2d1c:	8b 45 08             	mov    0x8(%ebp),%eax
    2d1f:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    2d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2d27:	eb 1d                	jmp    2d46 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    2d29:	8b 45 08             	mov    0x8(%ebp),%eax
    2d2c:	8b 00                	mov    (%eax),%eax
    2d2e:	89 04 24             	mov    %eax,(%esp)
    2d31:	e8 88 f3 ff ff       	call   20be <kthread_mutex_unlock>
    2d36:	85 c0                	test   %eax,%eax
    2d38:	79 07                	jns    2d41 <mesa_cond_signal+0x6b>

		return -1;
    2d3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2d3f:	eb 05                	jmp    2d46 <mesa_cond_signal+0x70>
	}
	return 0;
    2d41:	b8 00 00 00 00       	mov    $0x0,%eax

}
    2d46:	c9                   	leave  
    2d47:	c3                   	ret    
