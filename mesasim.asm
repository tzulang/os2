
_mesasim:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

void addSlot(void);



int  main (int argc, char* argv[]){
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	57                   	push   %edi
       e:	56                   	push   %esi
       f:	53                   	push   %ebx
      10:	51                   	push   %ecx
      11:	83 ec 38             	sub    $0x38,%esp
      14:	89 cb                	mov    %ecx,%ebx



	if (argc <3){
      16:	83 3b 02             	cmpl   $0x2,(%ebx)
      19:	7f 19                	jg     34 <main+0x34>
		 printf (1, "Not enough arguments to run simulation\n");
      1b:	c7 44 24 04 d8 12 00 	movl   $0x12d8,0x4(%esp)
      22:	00 
      23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      2a:	e8 0c 07 00 00       	call   73b <printf>
		 exit();
      2f:	e8 3f 05 00 00       	call   573 <exit>
	}

	m= atoi(argv[1]);
      34:	8b 43 04             	mov    0x4(%ebx),%eax
      37:	83 c0 04             	add    $0x4,%eax
      3a:	8b 00                	mov    (%eax),%eax
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 9d 04 00 00       	call   4e1 <atoi>
      44:	a3 0c 19 00 00       	mov    %eax,0x190c
	n= atoi(argv[2]);
      49:	8b 43 04             	mov    0x4(%ebx),%eax
      4c:	83 c0 08             	add    $0x8,%eax
      4f:	8b 00                	mov    (%eax),%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 88 04 00 00       	call   4e1 <atoi>
      59:	a3 08 19 00 00       	mov    %eax,0x1908

	if (n==0 ||m==0){
      5e:	a1 08 19 00 00       	mov    0x1908,%eax
      63:	85 c0                	test   %eax,%eax
      65:	74 09                	je     70 <main+0x70>
      67:	a1 0c 19 00 00       	mov    0x190c,%eax
      6c:	85 c0                	test   %eax,%eax
      6e:	75 19                	jne    89 <main+0x89>
		 printf (1, "Error reading arguments. Insert numbers greater then 0 to run simulation\n");
      70:	c7 44 24 04 00 13 00 	movl   $0x1300,0x4(%esp)
      77:	00 
      78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      7f:	e8 b7 06 00 00       	call   73b <printf>
		 exit();
      84:	e8 ea 04 00 00       	call   573 <exit>
	}

	monitor = mesa_slots_monitor_alloc();
      89:	e8 79 0a 00 00       	call   b07 <mesa_slots_monitor_alloc>
      8e:	a3 10 19 00 00       	mov    %eax,0x1910

	if (monitor==0){
      93:	a1 10 19 00 00       	mov    0x1910,%eax
      98:	85 c0                	test   %eax,%eax
      9a:	75 19                	jne    b5 <main+0xb5>
		 printf (1, "Error creating monitor \n");
      9c:	c7 44 24 04 4a 13 00 	movl   $0x134a,0x4(%esp)
      a3:	00 
      a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      ab:	e8 8b 06 00 00       	call   73b <printf>
		 exit();
      b0:	e8 be 04 00 00       	call   573 <exit>
	}

	int studentsThread[m];
      b5:	a1 0c 19 00 00       	mov    0x190c,%eax
      ba:	8d 50 ff             	lea    -0x1(%eax),%edx
      bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
      c0:	c1 e0 02             	shl    $0x2,%eax
      c3:	8d 50 03             	lea    0x3(%eax),%edx
      c6:	b8 10 00 00 00       	mov    $0x10,%eax
      cb:	83 e8 01             	sub    $0x1,%eax
      ce:	01 d0                	add    %edx,%eax
      d0:	be 10 00 00 00       	mov    $0x10,%esi
      d5:	ba 00 00 00 00       	mov    $0x0,%edx
      da:	f7 f6                	div    %esi
      dc:	6b c0 10             	imul   $0x10,%eax,%eax
      df:	29 c4                	sub    %eax,%esp
      e1:	8d 44 24 0c          	lea    0xc(%esp),%eax
      e5:	83 c0 03             	add    $0x3,%eax
      e8:	c1 e8 02             	shr    $0x2,%eax
      eb:	c1 e0 02             	shl    $0x2,%eax
      ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char* stacks[m];
      f1:	a1 0c 19 00 00       	mov    0x190c,%eax
      f6:	8d 50 ff             	lea    -0x1(%eax),%edx
      f9:	89 55 d8             	mov    %edx,-0x28(%ebp)
      fc:	c1 e0 02             	shl    $0x2,%eax
      ff:	8d 50 03             	lea    0x3(%eax),%edx
     102:	b8 10 00 00 00       	mov    $0x10,%eax
     107:	83 e8 01             	sub    $0x1,%eax
     10a:	01 d0                	add    %edx,%eax
     10c:	bf 10 00 00 00       	mov    $0x10,%edi
     111:	ba 00 00 00 00       	mov    $0x0,%edx
     116:	f7 f7                	div    %edi
     118:	6b c0 10             	imul   $0x10,%eax,%eax
     11b:	29 c4                	sub    %eax,%esp
     11d:	8d 44 24 0c          	lea    0xc(%esp),%eax
     121:	83 c0 03             	add    $0x3,%eax
     124:	c1 e8 02             	shr    $0x2,%eax
     127:	c1 e0 02             	shl    $0x2,%eax
     12a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int graderThread;



	int index=0;
     12d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     134:	e9 85 00 00 00       	jmp    1be <main+0x1be>

		stacks[index]= malloc (MAXSTACKSIZE);
     139:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
     140:	e8 e2 08 00 00       	call   a27 <malloc>
     145:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     148:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     14b:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
		if ( (studentsThread[index] =kthread_create(getSlot, stacks[index], MAXSTACKSIZE) )< 0){
     14e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     151:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     154:	8b 04 90             	mov    (%eax,%edx,4),%eax
     157:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     15e:	00 
     15f:	89 44 24 04          	mov    %eax,0x4(%esp)
     163:	c7 04 24 85 02 00 00 	movl   $0x285,(%esp)
     16a:	e8 a4 04 00 00       	call   613 <kthread_create>
     16f:	8b 55 dc             	mov    -0x24(%ebp),%edx
     172:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     175:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     178:	8b 45 dc             	mov    -0x24(%ebp),%eax
     17b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     17e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     181:	85 c0                	test   %eax,%eax
     183:	79 35                	jns    1ba <main+0x1ba>
			printf(1,"%p \n", getSlot);
     185:	c7 44 24 08 85 02 00 	movl   $0x285,0x8(%esp)
     18c:	00 
     18d:	c7 44 24 04 63 13 00 	movl   $0x1363,0x4(%esp)
     194:	00 
     195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     19c:	e8 9a 05 00 00       	call   73b <printf>
			printf(1, "Error Allocating threads for students\n ");
     1a1:	c7 44 24 04 68 13 00 	movl   $0x1368,0x4(%esp)
     1a8:	00 
     1a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1b0:	e8 86 05 00 00       	call   73b <printf>
			exit();
     1b5:	e8 b9 03 00 00       	call   573 <exit>
		}
		index++;
     1ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	int graderThread;



	int index=0;
	while (index <m){
     1be:	a1 0c 19 00 00       	mov    0x190c,%eax
     1c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     1c6:	0f 8c 6d ff ff ff    	jl     139 <main+0x139>
		}
		index++;

	}

	if ( (graderThread=kthread_create(addSlot, stacks[index], MAXSTACKSIZE))< 0){
     1cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     1cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     1d2:	8b 04 90             	mov    (%eax,%edx,4),%eax
     1d5:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     1dc:	00 
     1dd:	89 44 24 04          	mov    %eax,0x4(%esp)
     1e1:	c7 04 24 bc 02 00 00 	movl   $0x2bc,(%esp)
     1e8:	e8 26 04 00 00       	call   613 <kthread_create>
     1ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
     1f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     1f4:	79 19                	jns    20f <main+0x20f>
				printf(1, "Error Allocating threads for grader");
     1f6:	c7 44 24 04 90 13 00 	movl   $0x1390,0x4(%esp)
     1fd:	00 
     1fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     205:	e8 31 05 00 00       	call   73b <printf>
				exit();
     20a:	e8 64 03 00 00       	call   573 <exit>
	}


	index=0;
     20f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     216:	eb 26                	jmp    23e <main+0x23e>

		kthread_join( studentsThread[index]);
     218:	8b 45 dc             	mov    -0x24(%ebp),%eax
     21b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     21e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     221:	89 04 24             	mov    %eax,(%esp)
     224:	e8 02 04 00 00       	call   62b <kthread_join>
		free(stacks[index]);
     229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     22c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     22f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     232:	89 04 24             	mov    %eax,(%esp)
     235:	e8 b4 06 00 00       	call   8ee <free>
		index++;
     23a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
				exit();
	}


	index=0;
	while (index <m){
     23e:	a1 0c 19 00 00       	mov    0x190c,%eax
     243:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     246:	7c d0                	jl     218 <main+0x218>
		free(stacks[index]);
		index++;

	}

	mesa_slots_monitor_stopadding(monitor);
     248:	a1 10 19 00 00       	mov    0x1910,%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 de 0a 00 00       	call   d33 <mesa_slots_monitor_stopadding>
	printf(1,"monitor stopped %d \n", monitor->active);
     255:	a1 10 19 00 00       	mov    0x1910,%eax
     25a:	8b 40 10             	mov    0x10(%eax),%eax
     25d:	89 44 24 08          	mov    %eax,0x8(%esp)
     261:	c7 44 24 04 b4 13 00 	movl   $0x13b4,0x4(%esp)
     268:	00 
     269:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     270:	e8 c6 04 00 00       	call   73b <printf>
	kthread_join( graderThread);
     275:	8b 45 d0             	mov    -0x30(%ebp),%eax
     278:	89 04 24             	mov    %eax,(%esp)
     27b:	e8 ab 03 00 00       	call   62b <kthread_join>

	exit();
     280:	e8 ee 02 00 00       	call   573 <exit>

00000285 <getSlot>:
	return 0;
}


void getSlot(void){
     285:	55                   	push   %ebp
     286:	89 e5                	mov    %esp,%ebp
     288:	83 ec 18             	sub    $0x18,%esp

	mesa_slots_monitor_takeslot (monitor);
     28b:	a1 10 19 00 00       	mov    0x1910,%eax
     290:	89 04 24             	mov    %eax,(%esp)
     293:	e8 03 0a 00 00       	call   c9b <mesa_slots_monitor_takeslot>
	printf (1, " student %d got a slot \n",kthread_id());
     298:	e8 7e 03 00 00       	call   61b <kthread_id>
     29d:	89 44 24 08          	mov    %eax,0x8(%esp)
     2a1:	c7 44 24 04 c9 13 00 	movl   $0x13c9,0x4(%esp)
     2a8:	00 
     2a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2b0:	e8 86 04 00 00       	call   73b <printf>
	kthread_exit();
     2b5:	e8 69 03 00 00       	call   623 <kthread_exit>
}
     2ba:	c9                   	leave  
     2bb:	c3                   	ret    

000002bc <addSlot>:

void addSlot(void){
     2bc:	55                   	push   %ebp
     2bd:	89 e5                	mov    %esp,%ebp
     2bf:	83 ec 18             	sub    $0x18,%esp

	while (monitor->active){
     2c2:	eb 17                	jmp    2db <addSlot+0x1f>
		mesa_slots_monitor_addslots(monitor, n);
     2c4:	8b 15 08 19 00 00    	mov    0x1908,%edx
     2ca:	a1 10 19 00 00       	mov    0x1910,%eax
     2cf:	89 54 24 04          	mov    %edx,0x4(%esp)
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 23 09 00 00       	call   bfe <mesa_slots_monitor_addslots>
	kthread_exit();
}

void addSlot(void){

	while (monitor->active){
     2db:	a1 10 19 00 00       	mov    0x1910,%eax
     2e0:	8b 40 10             	mov    0x10(%eax),%eax
     2e3:	85 c0                	test   %eax,%eax
     2e5:	75 dd                	jne    2c4 <addSlot+0x8>
		mesa_slots_monitor_addslots(monitor, n);
	}
	printf (1, " grader stopped producing slots \n",kthread_id());
     2e7:	e8 2f 03 00 00       	call   61b <kthread_id>
     2ec:	89 44 24 08          	mov    %eax,0x8(%esp)
     2f0:	c7 44 24 04 e4 13 00 	movl   $0x13e4,0x4(%esp)
     2f7:	00 
     2f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2ff:	e8 37 04 00 00       	call   73b <printf>
	kthread_exit();
     304:	e8 1a 03 00 00       	call   623 <kthread_exit>
}
     309:	c9                   	leave  
     30a:	c3                   	ret    

0000030b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     30b:	55                   	push   %ebp
     30c:	89 e5                	mov    %esp,%ebp
     30e:	57                   	push   %edi
     30f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     310:	8b 4d 08             	mov    0x8(%ebp),%ecx
     313:	8b 55 10             	mov    0x10(%ebp),%edx
     316:	8b 45 0c             	mov    0xc(%ebp),%eax
     319:	89 cb                	mov    %ecx,%ebx
     31b:	89 df                	mov    %ebx,%edi
     31d:	89 d1                	mov    %edx,%ecx
     31f:	fc                   	cld    
     320:	f3 aa                	rep stos %al,%es:(%edi)
     322:	89 ca                	mov    %ecx,%edx
     324:	89 fb                	mov    %edi,%ebx
     326:	89 5d 08             	mov    %ebx,0x8(%ebp)
     329:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     32c:	5b                   	pop    %ebx
     32d:	5f                   	pop    %edi
     32e:	5d                   	pop    %ebp
     32f:	c3                   	ret    

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     336:	8b 45 08             	mov    0x8(%ebp),%eax
     339:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     33c:	90                   	nop
     33d:	8b 45 08             	mov    0x8(%ebp),%eax
     340:	8d 50 01             	lea    0x1(%eax),%edx
     343:	89 55 08             	mov    %edx,0x8(%ebp)
     346:	8b 55 0c             	mov    0xc(%ebp),%edx
     349:	8d 4a 01             	lea    0x1(%edx),%ecx
     34c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     34f:	0f b6 12             	movzbl (%edx),%edx
     352:	88 10                	mov    %dl,(%eax)
     354:	0f b6 00             	movzbl (%eax),%eax
     357:	84 c0                	test   %al,%al
     359:	75 e2                	jne    33d <strcpy+0xd>
    ;
  return os;
     35b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     35e:	c9                   	leave  
     35f:	c3                   	ret    

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     363:	eb 08                	jmp    36d <strcmp+0xd>
    p++, q++;
     365:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     369:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     36d:	8b 45 08             	mov    0x8(%ebp),%eax
     370:	0f b6 00             	movzbl (%eax),%eax
     373:	84 c0                	test   %al,%al
     375:	74 10                	je     387 <strcmp+0x27>
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	0f b6 10             	movzbl (%eax),%edx
     37d:	8b 45 0c             	mov    0xc(%ebp),%eax
     380:	0f b6 00             	movzbl (%eax),%eax
     383:	38 c2                	cmp    %al,%dl
     385:	74 de                	je     365 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     387:	8b 45 08             	mov    0x8(%ebp),%eax
     38a:	0f b6 00             	movzbl (%eax),%eax
     38d:	0f b6 d0             	movzbl %al,%edx
     390:	8b 45 0c             	mov    0xc(%ebp),%eax
     393:	0f b6 00             	movzbl (%eax),%eax
     396:	0f b6 c0             	movzbl %al,%eax
     399:	29 c2                	sub    %eax,%edx
     39b:	89 d0                	mov    %edx,%eax
}
     39d:	5d                   	pop    %ebp
     39e:	c3                   	ret    

0000039f <strlen>:

uint
strlen(char *s)
{
     39f:	55                   	push   %ebp
     3a0:	89 e5                	mov    %esp,%ebp
     3a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3ac:	eb 04                	jmp    3b2 <strlen+0x13>
     3ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     3b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3b5:	8b 45 08             	mov    0x8(%ebp),%eax
     3b8:	01 d0                	add    %edx,%eax
     3ba:	0f b6 00             	movzbl (%eax),%eax
     3bd:	84 c0                	test   %al,%al
     3bf:	75 ed                	jne    3ae <strlen+0xf>
    ;
  return n;
     3c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3c4:	c9                   	leave  
     3c5:	c3                   	ret    

000003c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     3c6:	55                   	push   %ebp
     3c7:	89 e5                	mov    %esp,%ebp
     3c9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     3cc:	8b 45 10             	mov    0x10(%ebp),%eax
     3cf:	89 44 24 08          	mov    %eax,0x8(%esp)
     3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     3d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     3da:	8b 45 08             	mov    0x8(%ebp),%eax
     3dd:	89 04 24             	mov    %eax,(%esp)
     3e0:	e8 26 ff ff ff       	call   30b <stosb>
  return dst;
     3e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3e8:	c9                   	leave  
     3e9:	c3                   	ret    

000003ea <strchr>:

char*
strchr(const char *s, char c)
{
     3ea:	55                   	push   %ebp
     3eb:	89 e5                	mov    %esp,%ebp
     3ed:	83 ec 04             	sub    $0x4,%esp
     3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     3f6:	eb 14                	jmp    40c <strchr+0x22>
    if(*s == c)
     3f8:	8b 45 08             	mov    0x8(%ebp),%eax
     3fb:	0f b6 00             	movzbl (%eax),%eax
     3fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
     401:	75 05                	jne    408 <strchr+0x1e>
      return (char*)s;
     403:	8b 45 08             	mov    0x8(%ebp),%eax
     406:	eb 13                	jmp    41b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     408:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     40c:	8b 45 08             	mov    0x8(%ebp),%eax
     40f:	0f b6 00             	movzbl (%eax),%eax
     412:	84 c0                	test   %al,%al
     414:	75 e2                	jne    3f8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     416:	b8 00 00 00 00       	mov    $0x0,%eax
}
     41b:	c9                   	leave  
     41c:	c3                   	ret    

0000041d <gets>:

char*
gets(char *buf, int max)
{
     41d:	55                   	push   %ebp
     41e:	89 e5                	mov    %esp,%ebp
     420:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     42a:	eb 4c                	jmp    478 <gets+0x5b>
    cc = read(0, &c, 1);
     42c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     433:	00 
     434:	8d 45 ef             	lea    -0x11(%ebp),%eax
     437:	89 44 24 04          	mov    %eax,0x4(%esp)
     43b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     442:	e8 44 01 00 00       	call   58b <read>
     447:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     44a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     44e:	7f 02                	jg     452 <gets+0x35>
      break;
     450:	eb 31                	jmp    483 <gets+0x66>
    buf[i++] = c;
     452:	8b 45 f4             	mov    -0xc(%ebp),%eax
     455:	8d 50 01             	lea    0x1(%eax),%edx
     458:	89 55 f4             	mov    %edx,-0xc(%ebp)
     45b:	89 c2                	mov    %eax,%edx
     45d:	8b 45 08             	mov    0x8(%ebp),%eax
     460:	01 c2                	add    %eax,%edx
     462:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     466:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     468:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     46c:	3c 0a                	cmp    $0xa,%al
     46e:	74 13                	je     483 <gets+0x66>
     470:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     474:	3c 0d                	cmp    $0xd,%al
     476:	74 0b                	je     483 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     478:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47b:	83 c0 01             	add    $0x1,%eax
     47e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     481:	7c a9                	jl     42c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     483:	8b 55 f4             	mov    -0xc(%ebp),%edx
     486:	8b 45 08             	mov    0x8(%ebp),%eax
     489:	01 d0                	add    %edx,%eax
     48b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     48e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     491:	c9                   	leave  
     492:	c3                   	ret    

00000493 <stat>:

int
stat(char *n, struct stat *st)
{
     493:	55                   	push   %ebp
     494:	89 e5                	mov    %esp,%ebp
     496:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     499:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4a0:	00 
     4a1:	8b 45 08             	mov    0x8(%ebp),%eax
     4a4:	89 04 24             	mov    %eax,(%esp)
     4a7:	e8 07 01 00 00       	call   5b3 <open>
     4ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4b3:	79 07                	jns    4bc <stat+0x29>
    return -1;
     4b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     4ba:	eb 23                	jmp    4df <stat+0x4c>
  r = fstat(fd, st);
     4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
     4bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c6:	89 04 24             	mov    %eax,(%esp)
     4c9:	e8 fd 00 00 00       	call   5cb <fstat>
     4ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d4:	89 04 24             	mov    %eax,(%esp)
     4d7:	e8 bf 00 00 00       	call   59b <close>
  return r;
     4dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     4df:	c9                   	leave  
     4e0:	c3                   	ret    

000004e1 <atoi>:

int
atoi(const char *s)
{
     4e1:	55                   	push   %ebp
     4e2:	89 e5                	mov    %esp,%ebp
     4e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     4e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     4ee:	eb 25                	jmp    515 <atoi+0x34>
    n = n*10 + *s++ - '0';
     4f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
     4f3:	89 d0                	mov    %edx,%eax
     4f5:	c1 e0 02             	shl    $0x2,%eax
     4f8:	01 d0                	add    %edx,%eax
     4fa:	01 c0                	add    %eax,%eax
     4fc:	89 c1                	mov    %eax,%ecx
     4fe:	8b 45 08             	mov    0x8(%ebp),%eax
     501:	8d 50 01             	lea    0x1(%eax),%edx
     504:	89 55 08             	mov    %edx,0x8(%ebp)
     507:	0f b6 00             	movzbl (%eax),%eax
     50a:	0f be c0             	movsbl %al,%eax
     50d:	01 c8                	add    %ecx,%eax
     50f:	83 e8 30             	sub    $0x30,%eax
     512:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     515:	8b 45 08             	mov    0x8(%ebp),%eax
     518:	0f b6 00             	movzbl (%eax),%eax
     51b:	3c 2f                	cmp    $0x2f,%al
     51d:	7e 0a                	jle    529 <atoi+0x48>
     51f:	8b 45 08             	mov    0x8(%ebp),%eax
     522:	0f b6 00             	movzbl (%eax),%eax
     525:	3c 39                	cmp    $0x39,%al
     527:	7e c7                	jle    4f0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     529:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     52c:	c9                   	leave  
     52d:	c3                   	ret    

0000052e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     52e:	55                   	push   %ebp
     52f:	89 e5                	mov    %esp,%ebp
     531:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     534:	8b 45 08             	mov    0x8(%ebp),%eax
     537:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     53a:	8b 45 0c             	mov    0xc(%ebp),%eax
     53d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     540:	eb 17                	jmp    559 <memmove+0x2b>
    *dst++ = *src++;
     542:	8b 45 fc             	mov    -0x4(%ebp),%eax
     545:	8d 50 01             	lea    0x1(%eax),%edx
     548:	89 55 fc             	mov    %edx,-0x4(%ebp)
     54b:	8b 55 f8             	mov    -0x8(%ebp),%edx
     54e:	8d 4a 01             	lea    0x1(%edx),%ecx
     551:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     554:	0f b6 12             	movzbl (%edx),%edx
     557:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     559:	8b 45 10             	mov    0x10(%ebp),%eax
     55c:	8d 50 ff             	lea    -0x1(%eax),%edx
     55f:	89 55 10             	mov    %edx,0x10(%ebp)
     562:	85 c0                	test   %eax,%eax
     564:	7f dc                	jg     542 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     566:	8b 45 08             	mov    0x8(%ebp),%eax
}
     569:	c9                   	leave  
     56a:	c3                   	ret    

0000056b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     56b:	b8 01 00 00 00       	mov    $0x1,%eax
     570:	cd 40                	int    $0x40
     572:	c3                   	ret    

00000573 <exit>:
SYSCALL(exit)
     573:	b8 02 00 00 00       	mov    $0x2,%eax
     578:	cd 40                	int    $0x40
     57a:	c3                   	ret    

0000057b <wait>:
SYSCALL(wait)
     57b:	b8 03 00 00 00       	mov    $0x3,%eax
     580:	cd 40                	int    $0x40
     582:	c3                   	ret    

00000583 <pipe>:
SYSCALL(pipe)
     583:	b8 04 00 00 00       	mov    $0x4,%eax
     588:	cd 40                	int    $0x40
     58a:	c3                   	ret    

0000058b <read>:
SYSCALL(read)
     58b:	b8 05 00 00 00       	mov    $0x5,%eax
     590:	cd 40                	int    $0x40
     592:	c3                   	ret    

00000593 <write>:
SYSCALL(write)
     593:	b8 10 00 00 00       	mov    $0x10,%eax
     598:	cd 40                	int    $0x40
     59a:	c3                   	ret    

0000059b <close>:
SYSCALL(close)
     59b:	b8 15 00 00 00       	mov    $0x15,%eax
     5a0:	cd 40                	int    $0x40
     5a2:	c3                   	ret    

000005a3 <kill>:
SYSCALL(kill)
     5a3:	b8 06 00 00 00       	mov    $0x6,%eax
     5a8:	cd 40                	int    $0x40
     5aa:	c3                   	ret    

000005ab <exec>:
SYSCALL(exec)
     5ab:	b8 07 00 00 00       	mov    $0x7,%eax
     5b0:	cd 40                	int    $0x40
     5b2:	c3                   	ret    

000005b3 <open>:
SYSCALL(open)
     5b3:	b8 0f 00 00 00       	mov    $0xf,%eax
     5b8:	cd 40                	int    $0x40
     5ba:	c3                   	ret    

000005bb <mknod>:
SYSCALL(mknod)
     5bb:	b8 11 00 00 00       	mov    $0x11,%eax
     5c0:	cd 40                	int    $0x40
     5c2:	c3                   	ret    

000005c3 <unlink>:
SYSCALL(unlink)
     5c3:	b8 12 00 00 00       	mov    $0x12,%eax
     5c8:	cd 40                	int    $0x40
     5ca:	c3                   	ret    

000005cb <fstat>:
SYSCALL(fstat)
     5cb:	b8 08 00 00 00       	mov    $0x8,%eax
     5d0:	cd 40                	int    $0x40
     5d2:	c3                   	ret    

000005d3 <link>:
SYSCALL(link)
     5d3:	b8 13 00 00 00       	mov    $0x13,%eax
     5d8:	cd 40                	int    $0x40
     5da:	c3                   	ret    

000005db <mkdir>:
SYSCALL(mkdir)
     5db:	b8 14 00 00 00       	mov    $0x14,%eax
     5e0:	cd 40                	int    $0x40
     5e2:	c3                   	ret    

000005e3 <chdir>:
SYSCALL(chdir)
     5e3:	b8 09 00 00 00       	mov    $0x9,%eax
     5e8:	cd 40                	int    $0x40
     5ea:	c3                   	ret    

000005eb <dup>:
SYSCALL(dup)
     5eb:	b8 0a 00 00 00       	mov    $0xa,%eax
     5f0:	cd 40                	int    $0x40
     5f2:	c3                   	ret    

000005f3 <getpid>:
SYSCALL(getpid)
     5f3:	b8 0b 00 00 00       	mov    $0xb,%eax
     5f8:	cd 40                	int    $0x40
     5fa:	c3                   	ret    

000005fb <sbrk>:
SYSCALL(sbrk)
     5fb:	b8 0c 00 00 00       	mov    $0xc,%eax
     600:	cd 40                	int    $0x40
     602:	c3                   	ret    

00000603 <sleep>:
SYSCALL(sleep)
     603:	b8 0d 00 00 00       	mov    $0xd,%eax
     608:	cd 40                	int    $0x40
     60a:	c3                   	ret    

0000060b <uptime>:
SYSCALL(uptime)
     60b:	b8 0e 00 00 00       	mov    $0xe,%eax
     610:	cd 40                	int    $0x40
     612:	c3                   	ret    

00000613 <kthread_create>:




SYSCALL(kthread_create)
     613:	b8 16 00 00 00       	mov    $0x16,%eax
     618:	cd 40                	int    $0x40
     61a:	c3                   	ret    

0000061b <kthread_id>:
SYSCALL(kthread_id)
     61b:	b8 17 00 00 00       	mov    $0x17,%eax
     620:	cd 40                	int    $0x40
     622:	c3                   	ret    

00000623 <kthread_exit>:
SYSCALL(kthread_exit)
     623:	b8 18 00 00 00       	mov    $0x18,%eax
     628:	cd 40                	int    $0x40
     62a:	c3                   	ret    

0000062b <kthread_join>:
SYSCALL(kthread_join)
     62b:	b8 19 00 00 00       	mov    $0x19,%eax
     630:	cd 40                	int    $0x40
     632:	c3                   	ret    

00000633 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     633:	b8 1a 00 00 00       	mov    $0x1a,%eax
     638:	cd 40                	int    $0x40
     63a:	c3                   	ret    

0000063b <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     63b:	b8 1b 00 00 00       	mov    $0x1b,%eax
     640:	cd 40                	int    $0x40
     642:	c3                   	ret    

00000643 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     643:	b8 1c 00 00 00       	mov    $0x1c,%eax
     648:	cd 40                	int    $0x40
     64a:	c3                   	ret    

0000064b <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     64b:	b8 1d 00 00 00       	mov    $0x1d,%eax
     650:	cd 40                	int    $0x40
     652:	c3                   	ret    

00000653 <kthread_mutex_yieldlock>:
     653:	b8 1e 00 00 00       	mov    $0x1e,%eax
     658:	cd 40                	int    $0x40
     65a:	c3                   	ret    

0000065b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     65b:	55                   	push   %ebp
     65c:	89 e5                	mov    %esp,%ebp
     65e:	83 ec 18             	sub    $0x18,%esp
     661:	8b 45 0c             	mov    0xc(%ebp),%eax
     664:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     667:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     66e:	00 
     66f:	8d 45 f4             	lea    -0xc(%ebp),%eax
     672:	89 44 24 04          	mov    %eax,0x4(%esp)
     676:	8b 45 08             	mov    0x8(%ebp),%eax
     679:	89 04 24             	mov    %eax,(%esp)
     67c:	e8 12 ff ff ff       	call   593 <write>
}
     681:	c9                   	leave  
     682:	c3                   	ret    

00000683 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     683:	55                   	push   %ebp
     684:	89 e5                	mov    %esp,%ebp
     686:	56                   	push   %esi
     687:	53                   	push   %ebx
     688:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     68b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     692:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     696:	74 17                	je     6af <printint+0x2c>
     698:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     69c:	79 11                	jns    6af <printint+0x2c>
    neg = 1;
     69e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     6a5:	8b 45 0c             	mov    0xc(%ebp),%eax
     6a8:	f7 d8                	neg    %eax
     6aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6ad:	eb 06                	jmp    6b5 <printint+0x32>
  } else {
    x = xx;
     6af:	8b 45 0c             	mov    0xc(%ebp),%eax
     6b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     6b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     6bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     6bf:	8d 41 01             	lea    0x1(%ecx),%eax
     6c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6cb:	ba 00 00 00 00       	mov    $0x0,%edx
     6d0:	f7 f3                	div    %ebx
     6d2:	89 d0                	mov    %edx,%eax
     6d4:	0f b6 80 e8 18 00 00 	movzbl 0x18e8(%eax),%eax
     6db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6df:	8b 75 10             	mov    0x10(%ebp),%esi
     6e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6e5:	ba 00 00 00 00       	mov    $0x0,%edx
     6ea:	f7 f6                	div    %esi
     6ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6f3:	75 c7                	jne    6bc <printint+0x39>
  if(neg)
     6f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6f9:	74 10                	je     70b <printint+0x88>
    buf[i++] = '-';
     6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6fe:	8d 50 01             	lea    0x1(%eax),%edx
     701:	89 55 f4             	mov    %edx,-0xc(%ebp)
     704:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     709:	eb 1f                	jmp    72a <printint+0xa7>
     70b:	eb 1d                	jmp    72a <printint+0xa7>
    putc(fd, buf[i]);
     70d:	8d 55 dc             	lea    -0x24(%ebp),%edx
     710:	8b 45 f4             	mov    -0xc(%ebp),%eax
     713:	01 d0                	add    %edx,%eax
     715:	0f b6 00             	movzbl (%eax),%eax
     718:	0f be c0             	movsbl %al,%eax
     71b:	89 44 24 04          	mov    %eax,0x4(%esp)
     71f:	8b 45 08             	mov    0x8(%ebp),%eax
     722:	89 04 24             	mov    %eax,(%esp)
     725:	e8 31 ff ff ff       	call   65b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     72a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     72e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     732:	79 d9                	jns    70d <printint+0x8a>
    putc(fd, buf[i]);
}
     734:	83 c4 30             	add    $0x30,%esp
     737:	5b                   	pop    %ebx
     738:	5e                   	pop    %esi
     739:	5d                   	pop    %ebp
     73a:	c3                   	ret    

0000073b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     73b:	55                   	push   %ebp
     73c:	89 e5                	mov    %esp,%ebp
     73e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     748:	8d 45 0c             	lea    0xc(%ebp),%eax
     74b:	83 c0 04             	add    $0x4,%eax
     74e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     751:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     758:	e9 7c 01 00 00       	jmp    8d9 <printf+0x19e>
    c = fmt[i] & 0xff;
     75d:	8b 55 0c             	mov    0xc(%ebp),%edx
     760:	8b 45 f0             	mov    -0x10(%ebp),%eax
     763:	01 d0                	add    %edx,%eax
     765:	0f b6 00             	movzbl (%eax),%eax
     768:	0f be c0             	movsbl %al,%eax
     76b:	25 ff 00 00 00       	and    $0xff,%eax
     770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     773:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     777:	75 2c                	jne    7a5 <printf+0x6a>
      if(c == '%'){
     779:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     77d:	75 0c                	jne    78b <printf+0x50>
        state = '%';
     77f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     786:	e9 4a 01 00 00       	jmp    8d5 <printf+0x19a>
      } else {
        putc(fd, c);
     78b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     78e:	0f be c0             	movsbl %al,%eax
     791:	89 44 24 04          	mov    %eax,0x4(%esp)
     795:	8b 45 08             	mov    0x8(%ebp),%eax
     798:	89 04 24             	mov    %eax,(%esp)
     79b:	e8 bb fe ff ff       	call   65b <putc>
     7a0:	e9 30 01 00 00       	jmp    8d5 <printf+0x19a>
      }
    } else if(state == '%'){
     7a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     7a9:	0f 85 26 01 00 00    	jne    8d5 <printf+0x19a>
      if(c == 'd'){
     7af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     7b3:	75 2d                	jne    7e2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     7b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7b8:	8b 00                	mov    (%eax),%eax
     7ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     7c1:	00 
     7c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     7c9:	00 
     7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
     7ce:	8b 45 08             	mov    0x8(%ebp),%eax
     7d1:	89 04 24             	mov    %eax,(%esp)
     7d4:	e8 aa fe ff ff       	call   683 <printint>
        ap++;
     7d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7dd:	e9 ec 00 00 00       	jmp    8ce <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     7e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     7e6:	74 06                	je     7ee <printf+0xb3>
     7e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7ec:	75 2d                	jne    81b <printf+0xe0>
        printint(fd, *ap, 16, 0);
     7ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7f1:	8b 00                	mov    (%eax),%eax
     7f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7fa:	00 
     7fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     802:	00 
     803:	89 44 24 04          	mov    %eax,0x4(%esp)
     807:	8b 45 08             	mov    0x8(%ebp),%eax
     80a:	89 04 24             	mov    %eax,(%esp)
     80d:	e8 71 fe ff ff       	call   683 <printint>
        ap++;
     812:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     816:	e9 b3 00 00 00       	jmp    8ce <printf+0x193>
      } else if(c == 's'){
     81b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     81f:	75 45                	jne    866 <printf+0x12b>
        s = (char*)*ap;
     821:	8b 45 e8             	mov    -0x18(%ebp),%eax
     824:	8b 00                	mov    (%eax),%eax
     826:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     829:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     831:	75 09                	jne    83c <printf+0x101>
          s = "(null)";
     833:	c7 45 f4 06 14 00 00 	movl   $0x1406,-0xc(%ebp)
        while(*s != 0){
     83a:	eb 1e                	jmp    85a <printf+0x11f>
     83c:	eb 1c                	jmp    85a <printf+0x11f>
          putc(fd, *s);
     83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     841:	0f b6 00             	movzbl (%eax),%eax
     844:	0f be c0             	movsbl %al,%eax
     847:	89 44 24 04          	mov    %eax,0x4(%esp)
     84b:	8b 45 08             	mov    0x8(%ebp),%eax
     84e:	89 04 24             	mov    %eax,(%esp)
     851:	e8 05 fe ff ff       	call   65b <putc>
          s++;
     856:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85d:	0f b6 00             	movzbl (%eax),%eax
     860:	84 c0                	test   %al,%al
     862:	75 da                	jne    83e <printf+0x103>
     864:	eb 68                	jmp    8ce <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     866:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     86a:	75 1d                	jne    889 <printf+0x14e>
        putc(fd, *ap);
     86c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     86f:	8b 00                	mov    (%eax),%eax
     871:	0f be c0             	movsbl %al,%eax
     874:	89 44 24 04          	mov    %eax,0x4(%esp)
     878:	8b 45 08             	mov    0x8(%ebp),%eax
     87b:	89 04 24             	mov    %eax,(%esp)
     87e:	e8 d8 fd ff ff       	call   65b <putc>
        ap++;
     883:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     887:	eb 45                	jmp    8ce <printf+0x193>
      } else if(c == '%'){
     889:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     88d:	75 17                	jne    8a6 <printf+0x16b>
        putc(fd, c);
     88f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     892:	0f be c0             	movsbl %al,%eax
     895:	89 44 24 04          	mov    %eax,0x4(%esp)
     899:	8b 45 08             	mov    0x8(%ebp),%eax
     89c:	89 04 24             	mov    %eax,(%esp)
     89f:	e8 b7 fd ff ff       	call   65b <putc>
     8a4:	eb 28                	jmp    8ce <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     8a6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     8ad:	00 
     8ae:	8b 45 08             	mov    0x8(%ebp),%eax
     8b1:	89 04 24             	mov    %eax,(%esp)
     8b4:	e8 a2 fd ff ff       	call   65b <putc>
        putc(fd, c);
     8b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8bc:	0f be c0             	movsbl %al,%eax
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 08             	mov    0x8(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 8d fd ff ff       	call   65b <putc>
      }
      state = 0;
     8ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     8d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     8d9:	8b 55 0c             	mov    0xc(%ebp),%edx
     8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8df:	01 d0                	add    %edx,%eax
     8e1:	0f b6 00             	movzbl (%eax),%eax
     8e4:	84 c0                	test   %al,%al
     8e6:	0f 85 71 fe ff ff    	jne    75d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8ec:	c9                   	leave  
     8ed:	c3                   	ret    

000008ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8ee:	55                   	push   %ebp
     8ef:	89 e5                	mov    %esp,%ebp
     8f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8f4:	8b 45 08             	mov    0x8(%ebp),%eax
     8f7:	83 e8 08             	sub    $0x8,%eax
     8fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8fd:	a1 04 19 00 00       	mov    0x1904,%eax
     902:	89 45 fc             	mov    %eax,-0x4(%ebp)
     905:	eb 24                	jmp    92b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     907:	8b 45 fc             	mov    -0x4(%ebp),%eax
     90a:	8b 00                	mov    (%eax),%eax
     90c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     90f:	77 12                	ja     923 <free+0x35>
     911:	8b 45 f8             	mov    -0x8(%ebp),%eax
     914:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     917:	77 24                	ja     93d <free+0x4f>
     919:	8b 45 fc             	mov    -0x4(%ebp),%eax
     91c:	8b 00                	mov    (%eax),%eax
     91e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     921:	77 1a                	ja     93d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     923:	8b 45 fc             	mov    -0x4(%ebp),%eax
     926:	8b 00                	mov    (%eax),%eax
     928:	89 45 fc             	mov    %eax,-0x4(%ebp)
     92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     931:	76 d4                	jbe    907 <free+0x19>
     933:	8b 45 fc             	mov    -0x4(%ebp),%eax
     936:	8b 00                	mov    (%eax),%eax
     938:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     93b:	76 ca                	jbe    907 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     940:	8b 40 04             	mov    0x4(%eax),%eax
     943:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     94d:	01 c2                	add    %eax,%edx
     94f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     952:	8b 00                	mov    (%eax),%eax
     954:	39 c2                	cmp    %eax,%edx
     956:	75 24                	jne    97c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     958:	8b 45 f8             	mov    -0x8(%ebp),%eax
     95b:	8b 50 04             	mov    0x4(%eax),%edx
     95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     961:	8b 00                	mov    (%eax),%eax
     963:	8b 40 04             	mov    0x4(%eax),%eax
     966:	01 c2                	add    %eax,%edx
     968:	8b 45 f8             	mov    -0x8(%ebp),%eax
     96b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     971:	8b 00                	mov    (%eax),%eax
     973:	8b 10                	mov    (%eax),%edx
     975:	8b 45 f8             	mov    -0x8(%ebp),%eax
     978:	89 10                	mov    %edx,(%eax)
     97a:	eb 0a                	jmp    986 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97f:	8b 10                	mov    (%eax),%edx
     981:	8b 45 f8             	mov    -0x8(%ebp),%eax
     984:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     986:	8b 45 fc             	mov    -0x4(%ebp),%eax
     989:	8b 40 04             	mov    0x4(%eax),%eax
     98c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     993:	8b 45 fc             	mov    -0x4(%ebp),%eax
     996:	01 d0                	add    %edx,%eax
     998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     99b:	75 20                	jne    9bd <free+0xcf>
    p->s.size += bp->s.size;
     99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a0:	8b 50 04             	mov    0x4(%eax),%edx
     9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9a6:	8b 40 04             	mov    0x4(%eax),%eax
     9a9:	01 c2                	add    %eax,%edx
     9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     9b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9b4:	8b 10                	mov    (%eax),%edx
     9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9b9:	89 10                	mov    %edx,(%eax)
     9bb:	eb 08                	jmp    9c5 <free+0xd7>
  } else
    p->s.ptr = bp;
     9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
     9c3:	89 10                	mov    %edx,(%eax)
  freep = p;
     9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c8:	a3 04 19 00 00       	mov    %eax,0x1904
}
     9cd:	c9                   	leave  
     9ce:	c3                   	ret    

000009cf <morecore>:

static Header*
morecore(uint nu)
{
     9cf:	55                   	push   %ebp
     9d0:	89 e5                	mov    %esp,%ebp
     9d2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     9d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     9dc:	77 07                	ja     9e5 <morecore+0x16>
    nu = 4096;
     9de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     9e5:	8b 45 08             	mov    0x8(%ebp),%eax
     9e8:	c1 e0 03             	shl    $0x3,%eax
     9eb:	89 04 24             	mov    %eax,(%esp)
     9ee:	e8 08 fc ff ff       	call   5fb <sbrk>
     9f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9fa:	75 07                	jne    a03 <morecore+0x34>
    return 0;
     9fc:	b8 00 00 00 00       	mov    $0x0,%eax
     a01:	eb 22                	jmp    a25 <morecore+0x56>
  hp = (Header*)p;
     a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a0c:	8b 55 08             	mov    0x8(%ebp),%edx
     a0f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a15:	83 c0 08             	add    $0x8,%eax
     a18:	89 04 24             	mov    %eax,(%esp)
     a1b:	e8 ce fe ff ff       	call   8ee <free>
  return freep;
     a20:	a1 04 19 00 00       	mov    0x1904,%eax
}
     a25:	c9                   	leave  
     a26:	c3                   	ret    

00000a27 <malloc>:

void*
malloc(uint nbytes)
{
     a27:	55                   	push   %ebp
     a28:	89 e5                	mov    %esp,%ebp
     a2a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a2d:	8b 45 08             	mov    0x8(%ebp),%eax
     a30:	83 c0 07             	add    $0x7,%eax
     a33:	c1 e8 03             	shr    $0x3,%eax
     a36:	83 c0 01             	add    $0x1,%eax
     a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a3c:	a1 04 19 00 00       	mov    0x1904,%eax
     a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a48:	75 23                	jne    a6d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a4a:	c7 45 f0 fc 18 00 00 	movl   $0x18fc,-0x10(%ebp)
     a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a54:	a3 04 19 00 00       	mov    %eax,0x1904
     a59:	a1 04 19 00 00       	mov    0x1904,%eax
     a5e:	a3 fc 18 00 00       	mov    %eax,0x18fc
    base.s.size = 0;
     a63:	c7 05 00 19 00 00 00 	movl   $0x0,0x1900
     a6a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a70:	8b 00                	mov    (%eax),%eax
     a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a78:	8b 40 04             	mov    0x4(%eax),%eax
     a7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a7e:	72 4d                	jb     acd <malloc+0xa6>
      if(p->s.size == nunits)
     a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a83:	8b 40 04             	mov    0x4(%eax),%eax
     a86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a89:	75 0c                	jne    a97 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a8e:	8b 10                	mov    (%eax),%edx
     a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a93:	89 10                	mov    %edx,(%eax)
     a95:	eb 26                	jmp    abd <malloc+0x96>
      else {
        p->s.size -= nunits;
     a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a9a:	8b 40 04             	mov    0x4(%eax),%eax
     a9d:	2b 45 ec             	sub    -0x14(%ebp),%eax
     aa0:	89 c2                	mov    %eax,%edx
     aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aab:	8b 40 04             	mov    0x4(%eax),%eax
     aae:	c1 e0 03             	shl    $0x3,%eax
     ab1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     aba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac0:	a3 04 19 00 00       	mov    %eax,0x1904
      return (void*)(p + 1);
     ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac8:	83 c0 08             	add    $0x8,%eax
     acb:	eb 38                	jmp    b05 <malloc+0xde>
    }
    if(p == freep)
     acd:	a1 04 19 00 00       	mov    0x1904,%eax
     ad2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ad5:	75 1b                	jne    af2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ada:	89 04 24             	mov    %eax,(%esp)
     add:	e8 ed fe ff ff       	call   9cf <morecore>
     ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ae9:	75 07                	jne    af2 <malloc+0xcb>
        return 0;
     aeb:	b8 00 00 00 00       	mov    $0x0,%eax
     af0:	eb 13                	jmp    b05 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     afb:	8b 00                	mov    (%eax),%eax
     afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     b00:	e9 70 ff ff ff       	jmp    a75 <malloc+0x4e>
}
     b05:	c9                   	leave  
     b06:	c3                   	ret    

00000b07 <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     b07:	55                   	push   %ebp
     b08:	89 e5                	mov    %esp,%ebp
     b0a:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     b0d:	e8 21 fb ff ff       	call   633 <kthread_mutex_alloc>
     b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b19:	79 0a                	jns    b25 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     b1b:	b8 00 00 00 00       	mov    $0x0,%eax
     b20:	e9 8b 00 00 00       	jmp    bb0 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     b25:	e8 44 06 00 00       	call   116e <mesa_cond_alloc>
     b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b31:	75 12                	jne    b45 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b36:	89 04 24             	mov    %eax,(%esp)
     b39:	e8 fd fa ff ff       	call   63b <kthread_mutex_dealloc>
		return 0;
     b3e:	b8 00 00 00 00       	mov    $0x0,%eax
     b43:	eb 6b                	jmp    bb0 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     b45:	e8 24 06 00 00       	call   116e <mesa_cond_alloc>
     b4a:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b51:	75 1d                	jne    b70 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b56:	89 04 24             	mov    %eax,(%esp)
     b59:	e8 dd fa ff ff       	call   63b <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b61:	89 04 24             	mov    %eax,(%esp)
     b64:	e8 46 06 00 00       	call   11af <mesa_cond_dealloc>
		return 0;
     b69:	b8 00 00 00 00       	mov    $0x0,%eax
     b6e:	eb 40                	jmp    bb0 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     b70:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b77:	e8 ab fe ff ff       	call   a27 <malloc>
     b7c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b82:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b85:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b8e:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b91:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b97:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ba6:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     bad:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     bb0:	c9                   	leave  
     bb1:	c3                   	ret    

00000bb2 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     bb2:	55                   	push   %ebp
     bb3:	89 e5                	mov    %esp,%ebp
     bb5:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     bb8:	8b 45 08             	mov    0x8(%ebp),%eax
     bbb:	8b 00                	mov    (%eax),%eax
     bbd:	89 04 24             	mov    %eax,(%esp)
     bc0:	e8 76 fa ff ff       	call   63b <kthread_mutex_dealloc>
     bc5:	85 c0                	test   %eax,%eax
     bc7:	78 2e                	js     bf7 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     bc9:	8b 45 08             	mov    0x8(%ebp),%eax
     bcc:	8b 40 04             	mov    0x4(%eax),%eax
     bcf:	89 04 24             	mov    %eax,(%esp)
     bd2:	e8 97 05 00 00       	call   116e <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     bd7:	8b 45 08             	mov    0x8(%ebp),%eax
     bda:	8b 40 08             	mov    0x8(%eax),%eax
     bdd:	89 04 24             	mov    %eax,(%esp)
     be0:	e8 89 05 00 00       	call   116e <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     be5:	8b 45 08             	mov    0x8(%ebp),%eax
     be8:	89 04 24             	mov    %eax,(%esp)
     beb:	e8 fe fc ff ff       	call   8ee <free>
	return 0;
     bf0:	b8 00 00 00 00       	mov    $0x0,%eax
     bf5:	eb 05                	jmp    bfc <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bfc:	c9                   	leave  
     bfd:	c3                   	ret    

00000bfe <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     bfe:	55                   	push   %ebp
     bff:	89 e5                	mov    %esp,%ebp
     c01:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     c04:	8b 45 08             	mov    0x8(%ebp),%eax
     c07:	8b 40 10             	mov    0x10(%eax),%eax
     c0a:	85 c0                	test   %eax,%eax
     c0c:	75 0a                	jne    c18 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c13:	e9 81 00 00 00       	jmp    c99 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c18:	8b 45 08             	mov    0x8(%ebp),%eax
     c1b:	8b 00                	mov    (%eax),%eax
     c1d:	89 04 24             	mov    %eax,(%esp)
     c20:	e8 1e fa ff ff       	call   643 <kthread_mutex_lock>
     c25:	83 f8 ff             	cmp    $0xffffffff,%eax
     c28:	7d 07                	jge    c31 <mesa_slots_monitor_addslots+0x33>
		return -1;
     c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c2f:	eb 68                	jmp    c99 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     c31:	eb 17                	jmp    c4a <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     c33:	8b 45 08             	mov    0x8(%ebp),%eax
     c36:	8b 10                	mov    (%eax),%edx
     c38:	8b 45 08             	mov    0x8(%ebp),%eax
     c3b:	8b 40 08             	mov    0x8(%eax),%eax
     c3e:	89 54 24 04          	mov    %edx,0x4(%esp)
     c42:	89 04 24             	mov    %eax,(%esp)
     c45:	e8 af 05 00 00       	call   11f9 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c4a:	8b 45 08             	mov    0x8(%ebp),%eax
     c4d:	8b 40 10             	mov    0x10(%eax),%eax
     c50:	85 c0                	test   %eax,%eax
     c52:	74 0a                	je     c5e <mesa_slots_monitor_addslots+0x60>
     c54:	8b 45 08             	mov    0x8(%ebp),%eax
     c57:	8b 40 0c             	mov    0xc(%eax),%eax
     c5a:	85 c0                	test   %eax,%eax
     c5c:	7f d5                	jg     c33 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     c5e:	8b 45 08             	mov    0x8(%ebp),%eax
     c61:	8b 40 10             	mov    0x10(%eax),%eax
     c64:	85 c0                	test   %eax,%eax
     c66:	74 11                	je     c79 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     c68:	8b 45 08             	mov    0x8(%ebp),%eax
     c6b:	8b 50 0c             	mov    0xc(%eax),%edx
     c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c71:	01 c2                	add    %eax,%edx
     c73:	8b 45 08             	mov    0x8(%ebp),%eax
     c76:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     c79:	8b 45 08             	mov    0x8(%ebp),%eax
     c7c:	8b 40 04             	mov    0x4(%eax),%eax
     c7f:	89 04 24             	mov    %eax,(%esp)
     c82:	e8 dc 05 00 00       	call   1263 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c87:	8b 45 08             	mov    0x8(%ebp),%eax
     c8a:	8b 00                	mov    (%eax),%eax
     c8c:	89 04 24             	mov    %eax,(%esp)
     c8f:	e8 b7 f9 ff ff       	call   64b <kthread_mutex_unlock>

	return 1;
     c94:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c99:	c9                   	leave  
     c9a:	c3                   	ret    

00000c9b <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     c9b:	55                   	push   %ebp
     c9c:	89 e5                	mov    %esp,%ebp
     c9e:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     ca1:	8b 45 08             	mov    0x8(%ebp),%eax
     ca4:	8b 40 10             	mov    0x10(%eax),%eax
     ca7:	85 c0                	test   %eax,%eax
     ca9:	75 07                	jne    cb2 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cb0:	eb 7f                	jmp    d31 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     cb2:	8b 45 08             	mov    0x8(%ebp),%eax
     cb5:	8b 00                	mov    (%eax),%eax
     cb7:	89 04 24             	mov    %eax,(%esp)
     cba:	e8 84 f9 ff ff       	call   643 <kthread_mutex_lock>
     cbf:	83 f8 ff             	cmp    $0xffffffff,%eax
     cc2:	7d 07                	jge    ccb <mesa_slots_monitor_takeslot+0x30>
		return -1;
     cc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cc9:	eb 66                	jmp    d31 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     ccb:	eb 17                	jmp    ce4 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     ccd:	8b 45 08             	mov    0x8(%ebp),%eax
     cd0:	8b 10                	mov    (%eax),%edx
     cd2:	8b 45 08             	mov    0x8(%ebp),%eax
     cd5:	8b 40 04             	mov    0x4(%eax),%eax
     cd8:	89 54 24 04          	mov    %edx,0x4(%esp)
     cdc:	89 04 24             	mov    %eax,(%esp)
     cdf:	e8 15 05 00 00       	call   11f9 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     ce4:	8b 45 08             	mov    0x8(%ebp),%eax
     ce7:	8b 40 10             	mov    0x10(%eax),%eax
     cea:	85 c0                	test   %eax,%eax
     cec:	74 0a                	je     cf8 <mesa_slots_monitor_takeslot+0x5d>
     cee:	8b 45 08             	mov    0x8(%ebp),%eax
     cf1:	8b 40 0c             	mov    0xc(%eax),%eax
     cf4:	85 c0                	test   %eax,%eax
     cf6:	74 d5                	je     ccd <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     cf8:	8b 45 08             	mov    0x8(%ebp),%eax
     cfb:	8b 40 10             	mov    0x10(%eax),%eax
     cfe:	85 c0                	test   %eax,%eax
     d00:	74 0f                	je     d11 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     d02:	8b 45 08             	mov    0x8(%ebp),%eax
     d05:	8b 40 0c             	mov    0xc(%eax),%eax
     d08:	8d 50 ff             	lea    -0x1(%eax),%edx
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     d11:	8b 45 08             	mov    0x8(%ebp),%eax
     d14:	8b 40 08             	mov    0x8(%eax),%eax
     d17:	89 04 24             	mov    %eax,(%esp)
     d1a:	e8 44 05 00 00       	call   1263 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d1f:	8b 45 08             	mov    0x8(%ebp),%eax
     d22:	8b 00                	mov    (%eax),%eax
     d24:	89 04 24             	mov    %eax,(%esp)
     d27:	e8 1f f9 ff ff       	call   64b <kthread_mutex_unlock>

	return 1;
     d2c:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d31:	c9                   	leave  
     d32:	c3                   	ret    

00000d33 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
     d36:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d39:	8b 45 08             	mov    0x8(%ebp),%eax
     d3c:	8b 40 10             	mov    0x10(%eax),%eax
     d3f:	85 c0                	test   %eax,%eax
     d41:	75 07                	jne    d4a <mesa_slots_monitor_stopadding+0x17>
			return -1;
     d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d48:	eb 35                	jmp    d7f <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d4a:	8b 45 08             	mov    0x8(%ebp),%eax
     d4d:	8b 00                	mov    (%eax),%eax
     d4f:	89 04 24             	mov    %eax,(%esp)
     d52:	e8 ec f8 ff ff       	call   643 <kthread_mutex_lock>
     d57:	83 f8 ff             	cmp    $0xffffffff,%eax
     d5a:	7d 07                	jge    d63 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d61:	eb 1c                	jmp    d7f <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d63:	8b 45 08             	mov    0x8(%ebp),%eax
     d66:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d6d:	8b 45 08             	mov    0x8(%ebp),%eax
     d70:	8b 00                	mov    (%eax),%eax
     d72:	89 04 24             	mov    %eax,(%esp)
     d75:	e8 d1 f8 ff ff       	call   64b <kthread_mutex_unlock>

		return 0;
     d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d7f:	c9                   	leave  
     d80:	c3                   	ret    

00000d81 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     d81:	55                   	push   %ebp
     d82:	89 e5                	mov    %esp,%ebp
     d84:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     d87:	e8 a7 f8 ff ff       	call   633 <kthread_mutex_alloc>
     d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d93:	79 0a                	jns    d9f <hoare_slots_monitor_alloc+0x1e>
		return 0;
     d95:	b8 00 00 00 00       	mov    $0x0,%eax
     d9a:	e9 8b 00 00 00       	jmp    e2a <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     d9f:	e8 68 02 00 00       	call   100c <hoare_cond_alloc>
     da4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     dab:	75 12                	jne    dbf <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db0:	89 04 24             	mov    %eax,(%esp)
     db3:	e8 83 f8 ff ff       	call   63b <kthread_mutex_dealloc>
		return 0;
     db8:	b8 00 00 00 00       	mov    $0x0,%eax
     dbd:	eb 6b                	jmp    e2a <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     dbf:	e8 48 02 00 00       	call   100c <hoare_cond_alloc>
     dc4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     dc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     dcb:	75 1d                	jne    dea <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd0:	89 04 24             	mov    %eax,(%esp)
     dd3:	e8 63 f8 ff ff       	call   63b <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ddb:	89 04 24             	mov    %eax,(%esp)
     dde:	e8 6a 02 00 00       	call   104d <hoare_cond_dealloc>
		return 0;
     de3:	b8 00 00 00 00       	mov    $0x0,%eax
     de8:	eb 40                	jmp    e2a <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     dea:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     df1:	e8 31 fc ff ff       	call   a27 <malloc>
     df6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
     dff:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
     e08:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e11:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e20:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     e27:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     e2a:	c9                   	leave  
     e2b:	c3                   	ret    

00000e2c <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     e2c:	55                   	push   %ebp
     e2d:	89 e5                	mov    %esp,%ebp
     e2f:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     e32:	8b 45 08             	mov    0x8(%ebp),%eax
     e35:	8b 00                	mov    (%eax),%eax
     e37:	89 04 24             	mov    %eax,(%esp)
     e3a:	e8 fc f7 ff ff       	call   63b <kthread_mutex_dealloc>
     e3f:	85 c0                	test   %eax,%eax
     e41:	78 2e                	js     e71 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     e43:	8b 45 08             	mov    0x8(%ebp),%eax
     e46:	8b 40 04             	mov    0x4(%eax),%eax
     e49:	89 04 24             	mov    %eax,(%esp)
     e4c:	e8 bb 01 00 00       	call   100c <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     e51:	8b 45 08             	mov    0x8(%ebp),%eax
     e54:	8b 40 08             	mov    0x8(%eax),%eax
     e57:	89 04 24             	mov    %eax,(%esp)
     e5a:	e8 ad 01 00 00       	call   100c <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     e5f:	8b 45 08             	mov    0x8(%ebp),%eax
     e62:	89 04 24             	mov    %eax,(%esp)
     e65:	e8 84 fa ff ff       	call   8ee <free>
	return 0;
     e6a:	b8 00 00 00 00       	mov    $0x0,%eax
     e6f:	eb 05                	jmp    e76 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     e76:	c9                   	leave  
     e77:	c3                   	ret    

00000e78 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     e78:	55                   	push   %ebp
     e79:	89 e5                	mov    %esp,%ebp
     e7b:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     e7e:	8b 45 08             	mov    0x8(%ebp),%eax
     e81:	8b 40 10             	mov    0x10(%eax),%eax
     e84:	85 c0                	test   %eax,%eax
     e86:	75 0a                	jne    e92 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e8d:	e9 88 00 00 00       	jmp    f1a <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e92:	8b 45 08             	mov    0x8(%ebp),%eax
     e95:	8b 00                	mov    (%eax),%eax
     e97:	89 04 24             	mov    %eax,(%esp)
     e9a:	e8 a4 f7 ff ff       	call   643 <kthread_mutex_lock>
     e9f:	83 f8 ff             	cmp    $0xffffffff,%eax
     ea2:	7d 07                	jge    eab <hoare_slots_monitor_addslots+0x33>
		return -1;
     ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea9:	eb 6f                	jmp    f1a <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     eab:	8b 45 08             	mov    0x8(%ebp),%eax
     eae:	8b 40 10             	mov    0x10(%eax),%eax
     eb1:	85 c0                	test   %eax,%eax
     eb3:	74 21                	je     ed6 <hoare_slots_monitor_addslots+0x5e>
     eb5:	8b 45 08             	mov    0x8(%ebp),%eax
     eb8:	8b 40 0c             	mov    0xc(%eax),%eax
     ebb:	85 c0                	test   %eax,%eax
     ebd:	7e 17                	jle    ed6 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     ebf:	8b 45 08             	mov    0x8(%ebp),%eax
     ec2:	8b 10                	mov    (%eax),%edx
     ec4:	8b 45 08             	mov    0x8(%ebp),%eax
     ec7:	8b 40 08             	mov    0x8(%eax),%eax
     eca:	89 54 24 04          	mov    %edx,0x4(%esp)
     ece:	89 04 24             	mov    %eax,(%esp)
     ed1:	e8 c1 01 00 00       	call   1097 <hoare_cond_wait>


	if  ( monitor->active)
     ed6:	8b 45 08             	mov    0x8(%ebp),%eax
     ed9:	8b 40 10             	mov    0x10(%eax),%eax
     edc:	85 c0                	test   %eax,%eax
     ede:	74 11                	je     ef1 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     ee0:	8b 45 08             	mov    0x8(%ebp),%eax
     ee3:	8b 50 0c             	mov    0xc(%eax),%edx
     ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee9:	01 c2                	add    %eax,%edx
     eeb:	8b 45 08             	mov    0x8(%ebp),%eax
     eee:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     ef1:	8b 45 08             	mov    0x8(%ebp),%eax
     ef4:	8b 10                	mov    (%eax),%edx
     ef6:	8b 45 08             	mov    0x8(%ebp),%eax
     ef9:	8b 40 04             	mov    0x4(%eax),%eax
     efc:	89 54 24 04          	mov    %edx,0x4(%esp)
     f00:	89 04 24             	mov    %eax,(%esp)
     f03:	e8 e6 01 00 00       	call   10ee <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f08:	8b 45 08             	mov    0x8(%ebp),%eax
     f0b:	8b 00                	mov    (%eax),%eax
     f0d:	89 04 24             	mov    %eax,(%esp)
     f10:	e8 36 f7 ff ff       	call   64b <kthread_mutex_unlock>

	return 1;
     f15:	b8 01 00 00 00       	mov    $0x1,%eax


}
     f1a:	c9                   	leave  
     f1b:	c3                   	ret    

00000f1c <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     f1c:	55                   	push   %ebp
     f1d:	89 e5                	mov    %esp,%ebp
     f1f:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     f22:	8b 45 08             	mov    0x8(%ebp),%eax
     f25:	8b 40 10             	mov    0x10(%eax),%eax
     f28:	85 c0                	test   %eax,%eax
     f2a:	75 0a                	jne    f36 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f31:	e9 86 00 00 00       	jmp    fbc <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f36:	8b 45 08             	mov    0x8(%ebp),%eax
     f39:	8b 00                	mov    (%eax),%eax
     f3b:	89 04 24             	mov    %eax,(%esp)
     f3e:	e8 00 f7 ff ff       	call   643 <kthread_mutex_lock>
     f43:	83 f8 ff             	cmp    $0xffffffff,%eax
     f46:	7d 07                	jge    f4f <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f4d:	eb 6d                	jmp    fbc <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f4f:	8b 45 08             	mov    0x8(%ebp),%eax
     f52:	8b 40 10             	mov    0x10(%eax),%eax
     f55:	85 c0                	test   %eax,%eax
     f57:	74 21                	je     f7a <hoare_slots_monitor_takeslot+0x5e>
     f59:	8b 45 08             	mov    0x8(%ebp),%eax
     f5c:	8b 40 0c             	mov    0xc(%eax),%eax
     f5f:	85 c0                	test   %eax,%eax
     f61:	75 17                	jne    f7a <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	8b 10                	mov    (%eax),%edx
     f68:	8b 45 08             	mov    0x8(%ebp),%eax
     f6b:	8b 40 04             	mov    0x4(%eax),%eax
     f6e:	89 54 24 04          	mov    %edx,0x4(%esp)
     f72:	89 04 24             	mov    %eax,(%esp)
     f75:	e8 1d 01 00 00       	call   1097 <hoare_cond_wait>


	if  ( monitor->active)
     f7a:	8b 45 08             	mov    0x8(%ebp),%eax
     f7d:	8b 40 10             	mov    0x10(%eax),%eax
     f80:	85 c0                	test   %eax,%eax
     f82:	74 0f                	je     f93 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     f84:	8b 45 08             	mov    0x8(%ebp),%eax
     f87:	8b 40 0c             	mov    0xc(%eax),%eax
     f8a:	8d 50 ff             	lea    -0x1(%eax),%edx
     f8d:	8b 45 08             	mov    0x8(%ebp),%eax
     f90:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     f93:	8b 45 08             	mov    0x8(%ebp),%eax
     f96:	8b 10                	mov    (%eax),%edx
     f98:	8b 45 08             	mov    0x8(%ebp),%eax
     f9b:	8b 40 08             	mov    0x8(%eax),%eax
     f9e:	89 54 24 04          	mov    %edx,0x4(%esp)
     fa2:	89 04 24             	mov    %eax,(%esp)
     fa5:	e8 44 01 00 00       	call   10ee <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     faa:	8b 45 08             	mov    0x8(%ebp),%eax
     fad:	8b 00                	mov    (%eax),%eax
     faf:	89 04 24             	mov    %eax,(%esp)
     fb2:	e8 94 f6 ff ff       	call   64b <kthread_mutex_unlock>

	return 1;
     fb7:	b8 01 00 00 00       	mov    $0x1,%eax

}
     fbc:	c9                   	leave  
     fbd:	c3                   	ret    

00000fbe <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     fbe:	55                   	push   %ebp
     fbf:	89 e5                	mov    %esp,%ebp
     fc1:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	8b 40 10             	mov    0x10(%eax),%eax
     fca:	85 c0                	test   %eax,%eax
     fcc:	75 07                	jne    fd5 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fd3:	eb 35                	jmp    100a <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     fd5:	8b 45 08             	mov    0x8(%ebp),%eax
     fd8:	8b 00                	mov    (%eax),%eax
     fda:	89 04 24             	mov    %eax,(%esp)
     fdd:	e8 61 f6 ff ff       	call   643 <kthread_mutex_lock>
     fe2:	83 f8 ff             	cmp    $0xffffffff,%eax
     fe5:	7d 07                	jge    fee <hoare_slots_monitor_stopadding+0x30>
			return -1;
     fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fec:	eb 1c                	jmp    100a <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     fee:	8b 45 08             	mov    0x8(%ebp),%eax
     ff1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     ff8:	8b 45 08             	mov    0x8(%ebp),%eax
     ffb:	8b 00                	mov    (%eax),%eax
     ffd:	89 04 24             	mov    %eax,(%esp)
    1000:	e8 46 f6 ff ff       	call   64b <kthread_mutex_unlock>

		return 0;
    1005:	b8 00 00 00 00       	mov    $0x0,%eax
}
    100a:	c9                   	leave  
    100b:	c3                   	ret    

0000100c <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
    100c:	55                   	push   %ebp
    100d:	89 e5                	mov    %esp,%ebp
    100f:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1012:	e8 1c f6 ff ff       	call   633 <kthread_mutex_alloc>
    1017:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    101a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    101e:	79 07                	jns    1027 <hoare_cond_alloc+0x1b>
		return 0;
    1020:	b8 00 00 00 00       	mov    $0x0,%eax
    1025:	eb 24                	jmp    104b <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    1027:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    102e:	e8 f4 f9 ff ff       	call   a27 <malloc>
    1033:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    1036:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1039:	8b 55 f4             	mov    -0xc(%ebp),%edx
    103c:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    103e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1048:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    104b:	c9                   	leave  
    104c:	c3                   	ret    

0000104d <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    104d:	55                   	push   %ebp
    104e:	89 e5                	mov    %esp,%ebp
    1050:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    1053:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1057:	75 07                	jne    1060 <hoare_cond_dealloc+0x13>
			return -1;
    1059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    105e:	eb 35                	jmp    1095 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    1060:	8b 45 08             	mov    0x8(%ebp),%eax
    1063:	8b 00                	mov    (%eax),%eax
    1065:	89 04 24             	mov    %eax,(%esp)
    1068:	e8 de f5 ff ff       	call   64b <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    106d:	8b 45 08             	mov    0x8(%ebp),%eax
    1070:	8b 00                	mov    (%eax),%eax
    1072:	89 04 24             	mov    %eax,(%esp)
    1075:	e8 c1 f5 ff ff       	call   63b <kthread_mutex_dealloc>
    107a:	85 c0                	test   %eax,%eax
    107c:	79 07                	jns    1085 <hoare_cond_dealloc+0x38>
			return -1;
    107e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1083:	eb 10                	jmp    1095 <hoare_cond_dealloc+0x48>

		free (hCond);
    1085:	8b 45 08             	mov    0x8(%ebp),%eax
    1088:	89 04 24             	mov    %eax,(%esp)
    108b:	e8 5e f8 ff ff       	call   8ee <free>
		return 0;
    1090:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1095:	c9                   	leave  
    1096:	c3                   	ret    

00001097 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    1097:	55                   	push   %ebp
    1098:	89 e5                	mov    %esp,%ebp
    109a:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    109d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10a1:	75 07                	jne    10aa <hoare_cond_wait+0x13>
			return -1;
    10a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10a8:	eb 42                	jmp    10ec <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    10aa:	8b 45 08             	mov    0x8(%ebp),%eax
    10ad:	8b 40 04             	mov    0x4(%eax),%eax
    10b0:	8d 50 01             	lea    0x1(%eax),%edx
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    10b9:	8b 45 08             	mov    0x8(%ebp),%eax
    10bc:	8b 00                	mov    (%eax),%eax
    10be:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c5:	89 04 24             	mov    %eax,(%esp)
    10c8:	e8 86 f5 ff ff       	call   653 <kthread_mutex_yieldlock>
    10cd:	85 c0                	test   %eax,%eax
    10cf:	79 16                	jns    10e7 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    10d1:	8b 45 08             	mov    0x8(%ebp),%eax
    10d4:	8b 40 04             	mov    0x4(%eax),%eax
    10d7:	8d 50 ff             	lea    -0x1(%eax),%edx
    10da:	8b 45 08             	mov    0x8(%ebp),%eax
    10dd:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    10e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10e5:	eb 05                	jmp    10ec <hoare_cond_wait+0x55>
		}

	return 0;
    10e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10ec:	c9                   	leave  
    10ed:	c3                   	ret    

000010ee <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    10ee:	55                   	push   %ebp
    10ef:	89 e5                	mov    %esp,%ebp
    10f1:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10f8:	75 07                	jne    1101 <hoare_cond_signal+0x13>
		return -1;
    10fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10ff:	eb 6b                	jmp    116c <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	8b 40 04             	mov    0x4(%eax),%eax
    1107:	85 c0                	test   %eax,%eax
    1109:	7e 3d                	jle    1148 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	8b 40 04             	mov    0x4(%eax),%eax
    1111:	8d 50 ff             	lea    -0x1(%eax),%edx
    1114:	8b 45 08             	mov    0x8(%ebp),%eax
    1117:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    111a:	8b 45 08             	mov    0x8(%ebp),%eax
    111d:	8b 00                	mov    (%eax),%eax
    111f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1123:	8b 45 0c             	mov    0xc(%ebp),%eax
    1126:	89 04 24             	mov    %eax,(%esp)
    1129:	e8 25 f5 ff ff       	call   653 <kthread_mutex_yieldlock>
    112e:	85 c0                	test   %eax,%eax
    1130:	79 16                	jns    1148 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	8b 40 04             	mov    0x4(%eax),%eax
    1138:	8d 50 01             	lea    0x1(%eax),%edx
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    1141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1146:	eb 24                	jmp    116c <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	8b 00                	mov    (%eax),%eax
    114d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	89 04 24             	mov    %eax,(%esp)
    1157:	e8 f7 f4 ff ff       	call   653 <kthread_mutex_yieldlock>
    115c:	85 c0                	test   %eax,%eax
    115e:	79 07                	jns    1167 <hoare_cond_signal+0x79>

    			return -1;
    1160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1165:	eb 05                	jmp    116c <hoare_cond_signal+0x7e>
    }

	return 0;
    1167:	b8 00 00 00 00       	mov    $0x0,%eax

}
    116c:	c9                   	leave  
    116d:	c3                   	ret    

0000116e <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1174:	e8 ba f4 ff ff       	call   633 <kthread_mutex_alloc>
    1179:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    117c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1180:	79 07                	jns    1189 <mesa_cond_alloc+0x1b>
		return 0;
    1182:	b8 00 00 00 00       	mov    $0x0,%eax
    1187:	eb 24                	jmp    11ad <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1189:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1190:	e8 92 f8 ff ff       	call   a27 <malloc>
    1195:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1198:	8b 45 f0             	mov    -0x10(%ebp),%eax
    119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    119e:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    11a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    11aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11ad:	c9                   	leave  
    11ae:	c3                   	ret    

000011af <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    11af:	55                   	push   %ebp
    11b0:	89 e5                	mov    %esp,%ebp
    11b2:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    11b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    11b9:	75 07                	jne    11c2 <mesa_cond_dealloc+0x13>
		return -1;
    11bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c0:	eb 35                	jmp    11f7 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    11c2:	8b 45 08             	mov    0x8(%ebp),%eax
    11c5:	8b 00                	mov    (%eax),%eax
    11c7:	89 04 24             	mov    %eax,(%esp)
    11ca:	e8 7c f4 ff ff       	call   64b <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    11cf:	8b 45 08             	mov    0x8(%ebp),%eax
    11d2:	8b 00                	mov    (%eax),%eax
    11d4:	89 04 24             	mov    %eax,(%esp)
    11d7:	e8 5f f4 ff ff       	call   63b <kthread_mutex_dealloc>
    11dc:	85 c0                	test   %eax,%eax
    11de:	79 07                	jns    11e7 <mesa_cond_dealloc+0x38>
		return -1;
    11e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11e5:	eb 10                	jmp    11f7 <mesa_cond_dealloc+0x48>

	free (mCond);
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	89 04 24             	mov    %eax,(%esp)
    11ed:	e8 fc f6 ff ff       	call   8ee <free>
	return 0;
    11f2:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    

000011f9 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    11ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1203:	75 07                	jne    120c <mesa_cond_wait+0x13>
		return -1;
    1205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    120a:	eb 55                	jmp    1261 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	8b 40 04             	mov    0x4(%eax),%eax
    1212:	8d 50 01             	lea    0x1(%eax),%edx
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    121b:	8b 45 0c             	mov    0xc(%ebp),%eax
    121e:	89 04 24             	mov    %eax,(%esp)
    1221:	e8 25 f4 ff ff       	call   64b <kthread_mutex_unlock>
    1226:	85 c0                	test   %eax,%eax
    1228:	79 27                	jns    1251 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    122a:	8b 45 08             	mov    0x8(%ebp),%eax
    122d:	8b 00                	mov    (%eax),%eax
    122f:	89 04 24             	mov    %eax,(%esp)
    1232:	e8 0c f4 ff ff       	call   643 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1237:	85 c0                	test   %eax,%eax
    1239:	79 16                	jns    1251 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	8b 40 04             	mov    0x4(%eax),%eax
    1241:	8d 50 ff             	lea    -0x1(%eax),%edx
    1244:	8b 45 08             	mov    0x8(%ebp),%eax
    1247:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    124a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    124f:	eb 10                	jmp    1261 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    1251:	8b 45 0c             	mov    0xc(%ebp),%eax
    1254:	89 04 24             	mov    %eax,(%esp)
    1257:	e8 e7 f3 ff ff       	call   643 <kthread_mutex_lock>
	return 0;
    125c:	b8 00 00 00 00       	mov    $0x0,%eax


}
    1261:	c9                   	leave  
    1262:	c3                   	ret    

00001263 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    1263:	55                   	push   %ebp
    1264:	89 e5                	mov    %esp,%ebp
    1266:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    126d:	75 07                	jne    1276 <mesa_cond_signal+0x13>
		return -1;
    126f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1274:	eb 5d                	jmp    12d3 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    1276:	8b 45 08             	mov    0x8(%ebp),%eax
    1279:	8b 40 04             	mov    0x4(%eax),%eax
    127c:	85 c0                	test   %eax,%eax
    127e:	7e 36                	jle    12b6 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	8b 40 04             	mov    0x4(%eax),%eax
    1286:	8d 50 ff             	lea    -0x1(%eax),%edx
    1289:	8b 45 08             	mov    0x8(%ebp),%eax
    128c:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    128f:	8b 45 08             	mov    0x8(%ebp),%eax
    1292:	8b 00                	mov    (%eax),%eax
    1294:	89 04 24             	mov    %eax,(%esp)
    1297:	e8 af f3 ff ff       	call   64b <kthread_mutex_unlock>
    129c:	85 c0                	test   %eax,%eax
    129e:	78 16                	js     12b6 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	8b 40 04             	mov    0x4(%eax),%eax
    12a6:	8d 50 01             	lea    0x1(%eax),%edx
    12a9:	8b 45 08             	mov    0x8(%ebp),%eax
    12ac:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    12af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12b4:	eb 1d                	jmp    12d3 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    12b6:	8b 45 08             	mov    0x8(%ebp),%eax
    12b9:	8b 00                	mov    (%eax),%eax
    12bb:	89 04 24             	mov    %eax,(%esp)
    12be:	e8 88 f3 ff ff       	call   64b <kthread_mutex_unlock>
    12c3:	85 c0                	test   %eax,%eax
    12c5:	79 07                	jns    12ce <mesa_cond_signal+0x6b>

		return -1;
    12c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12cc:	eb 05                	jmp    12d3 <mesa_cond_signal+0x70>
	}
	return 0;
    12ce:	b8 00 00 00 00       	mov    $0x0,%eax

}
    12d3:	c9                   	leave  
    12d4:	c3                   	ret    
