
_mesasim:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void getSlot(void);


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
      1b:	c7 44 24 04 b4 12 00 	movl   $0x12b4,0x4(%esp)
      22:	00 
      23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      2a:	e8 e8 06 00 00       	call   717 <printf>
		 exit();
      2f:	e8 1b 05 00 00       	call   54f <exit>
	}

	m= atoi(argv[1]);
      34:	8b 43 04             	mov    0x4(%ebx),%eax
      37:	83 c0 04             	add    $0x4,%eax
      3a:	8b 00                	mov    (%eax),%eax
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 79 04 00 00       	call   4bd <atoi>
      44:	a3 d4 18 00 00       	mov    %eax,0x18d4
	n= atoi(argv[2]);
      49:	8b 43 04             	mov    0x4(%ebx),%eax
      4c:	83 c0 08             	add    $0x8,%eax
      4f:	8b 00                	mov    (%eax),%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 64 04 00 00       	call   4bd <atoi>
      59:	a3 d0 18 00 00       	mov    %eax,0x18d0

	if (n==0 ||m==0){
      5e:	a1 d0 18 00 00       	mov    0x18d0,%eax
      63:	85 c0                	test   %eax,%eax
      65:	74 09                	je     70 <main+0x70>
      67:	a1 d4 18 00 00       	mov    0x18d4,%eax
      6c:	85 c0                	test   %eax,%eax
      6e:	75 19                	jne    89 <main+0x89>
		 printf (1, "Error reading arguments. Insert numbers greater then 0 to run simulation\n");
      70:	c7 44 24 04 dc 12 00 	movl   $0x12dc,0x4(%esp)
      77:	00 
      78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      7f:	e8 93 06 00 00       	call   717 <printf>
		 exit();
      84:	e8 c6 04 00 00       	call   54f <exit>
	}

	monitor = mesa_slots_monitor_alloc();
      89:	e8 55 0a 00 00       	call   ae3 <mesa_slots_monitor_alloc>
      8e:	a3 d8 18 00 00       	mov    %eax,0x18d8

	if (monitor==0){
      93:	a1 d8 18 00 00       	mov    0x18d8,%eax
      98:	85 c0                	test   %eax,%eax
      9a:	75 19                	jne    b5 <main+0xb5>
		 printf (1, "Error creating monitor \n");
      9c:	c7 44 24 04 26 13 00 	movl   $0x1326,0x4(%esp)
      a3:	00 
      a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      ab:	e8 67 06 00 00       	call   717 <printf>
		 exit();
      b0:	e8 9a 04 00 00       	call   54f <exit>
	}

	int studentsThread[m];
      b5:	a1 d4 18 00 00       	mov    0x18d4,%eax
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
      f1:	a1 d4 18 00 00       	mov    0x18d4,%eax
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
     140:	e8 be 08 00 00       	call   a03 <malloc>
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
     163:	c7 04 24 61 02 00 00 	movl   $0x261,(%esp)
     16a:	e8 80 04 00 00       	call   5ef <kthread_create>
     16f:	8b 55 dc             	mov    -0x24(%ebp),%edx
     172:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     175:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     178:	8b 45 dc             	mov    -0x24(%ebp),%eax
     17b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     17e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     181:	85 c0                	test   %eax,%eax
     183:	79 35                	jns    1ba <main+0x1ba>
			printf(1,"%p \n", getSlot);
     185:	c7 44 24 08 61 02 00 	movl   $0x261,0x8(%esp)
     18c:	00 
     18d:	c7 44 24 04 3f 13 00 	movl   $0x133f,0x4(%esp)
     194:	00 
     195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     19c:	e8 76 05 00 00       	call   717 <printf>
			printf(1, "Error Allocating threads for students\n ");
     1a1:	c7 44 24 04 44 13 00 	movl   $0x1344,0x4(%esp)
     1a8:	00 
     1a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1b0:	e8 62 05 00 00       	call   717 <printf>
			exit();
     1b5:	e8 95 03 00 00       	call   54f <exit>
		}
		index++;
     1ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	int graderThread;



	int index=0;
	while (index <m){
     1be:	a1 d4 18 00 00       	mov    0x18d4,%eax
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
     1e1:	c7 04 24 98 02 00 00 	movl   $0x298,(%esp)
     1e8:	e8 02 04 00 00       	call   5ef <kthread_create>
     1ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
     1f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     1f4:	79 19                	jns    20f <main+0x20f>
				printf(1, "Error Allocating threads for grader");
     1f6:	c7 44 24 04 6c 13 00 	movl   $0x136c,0x4(%esp)
     1fd:	00 
     1fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     205:	e8 0d 05 00 00       	call   717 <printf>
				exit();
     20a:	e8 40 03 00 00       	call   54f <exit>
	}


	index=0;
     20f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     216:	eb 22                	jmp    23a <main+0x23a>

		kthread_join( studentsThread[index]);
     218:	8b 45 dc             	mov    -0x24(%ebp),%eax
     21b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     21e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     221:	89 04 24             	mov    %eax,(%esp)
     224:	e8 de 03 00 00       	call   607 <kthread_join>
		free(stacks[index]);
     229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     22c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     22f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     232:	89 04 24             	mov    %eax,(%esp)
     235:	e8 90 06 00 00       	call   8ca <free>
				exit();
	}


	index=0;
	while (index <m){
     23a:	a1 d4 18 00 00       	mov    0x18d4,%eax
     23f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     242:	7c d4                	jl     218 <main+0x218>

		kthread_join( studentsThread[index]);
		free(stacks[index]);
	}

	mesa_slots_monitor_stopadding(monitor);
     244:	a1 d8 18 00 00       	mov    0x18d8,%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 be 0a 00 00       	call   d0f <mesa_slots_monitor_stopadding>

	kthread_join( graderThread);
     251:	8b 45 d0             	mov    -0x30(%ebp),%eax
     254:	89 04 24             	mov    %eax,(%esp)
     257:	e8 ab 03 00 00       	call   607 <kthread_join>

	exit();
     25c:	e8 ee 02 00 00       	call   54f <exit>

00000261 <getSlot>:
	return 0;
}


void getSlot(void){
     261:	55                   	push   %ebp
     262:	89 e5                	mov    %esp,%ebp
     264:	83 ec 18             	sub    $0x18,%esp

	mesa_slots_monitor_takeslot (monitor);
     267:	a1 d8 18 00 00       	mov    0x18d8,%eax
     26c:	89 04 24             	mov    %eax,(%esp)
     26f:	e8 03 0a 00 00       	call   c77 <mesa_slots_monitor_takeslot>
	printf (1, " student %d got a slot \n",kthread_id());
     274:	e8 7e 03 00 00       	call   5f7 <kthread_id>
     279:	89 44 24 08          	mov    %eax,0x8(%esp)
     27d:	c7 44 24 04 90 13 00 	movl   $0x1390,0x4(%esp)
     284:	00 
     285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     28c:	e8 86 04 00 00       	call   717 <printf>
	kthread_exit();
     291:	e8 69 03 00 00       	call   5ff <kthread_exit>
}
     296:	c9                   	leave  
     297:	c3                   	ret    

00000298 <addSlot>:

void addSlot(void){
     298:	55                   	push   %ebp
     299:	89 e5                	mov    %esp,%ebp
     29b:	83 ec 18             	sub    $0x18,%esp

	while (monitor->active){
     29e:	eb 17                	jmp    2b7 <addSlot+0x1f>
		mesa_slots_monitor_addslots(monitor, n);
     2a0:	8b 15 d0 18 00 00    	mov    0x18d0,%edx
     2a6:	a1 d8 18 00 00       	mov    0x18d8,%eax
     2ab:	89 54 24 04          	mov    %edx,0x4(%esp)
     2af:	89 04 24             	mov    %eax,(%esp)
     2b2:	e8 23 09 00 00       	call   bda <mesa_slots_monitor_addslots>
	kthread_exit();
}

void addSlot(void){

	while (monitor->active){
     2b7:	a1 d8 18 00 00       	mov    0x18d8,%eax
     2bc:	8b 40 10             	mov    0x10(%eax),%eax
     2bf:	85 c0                	test   %eax,%eax
     2c1:	75 dd                	jne    2a0 <addSlot+0x8>
		mesa_slots_monitor_addslots(monitor, n);
	}
	printf (1, " grader stopped producing slots \n",kthread_id());
     2c3:	e8 2f 03 00 00       	call   5f7 <kthread_id>
     2c8:	89 44 24 08          	mov    %eax,0x8(%esp)
     2cc:	c7 44 24 04 ac 13 00 	movl   $0x13ac,0x4(%esp)
     2d3:	00 
     2d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2db:	e8 37 04 00 00       	call   717 <printf>
	kthread_exit();
     2e0:	e8 1a 03 00 00       	call   5ff <kthread_exit>
}
     2e5:	c9                   	leave  
     2e6:	c3                   	ret    

000002e7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     2e7:	55                   	push   %ebp
     2e8:	89 e5                	mov    %esp,%ebp
     2ea:	57                   	push   %edi
     2eb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     2ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
     2ef:	8b 55 10             	mov    0x10(%ebp),%edx
     2f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2f5:	89 cb                	mov    %ecx,%ebx
     2f7:	89 df                	mov    %ebx,%edi
     2f9:	89 d1                	mov    %edx,%ecx
     2fb:	fc                   	cld    
     2fc:	f3 aa                	rep stos %al,%es:(%edi)
     2fe:	89 ca                	mov    %ecx,%edx
     300:	89 fb                	mov    %edi,%ebx
     302:	89 5d 08             	mov    %ebx,0x8(%ebp)
     305:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     308:	5b                   	pop    %ebx
     309:	5f                   	pop    %edi
     30a:	5d                   	pop    %ebp
     30b:	c3                   	ret    

0000030c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     30c:	55                   	push   %ebp
     30d:	89 e5                	mov    %esp,%ebp
     30f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     312:	8b 45 08             	mov    0x8(%ebp),%eax
     315:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     318:	90                   	nop
     319:	8b 45 08             	mov    0x8(%ebp),%eax
     31c:	8d 50 01             	lea    0x1(%eax),%edx
     31f:	89 55 08             	mov    %edx,0x8(%ebp)
     322:	8b 55 0c             	mov    0xc(%ebp),%edx
     325:	8d 4a 01             	lea    0x1(%edx),%ecx
     328:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     32b:	0f b6 12             	movzbl (%edx),%edx
     32e:	88 10                	mov    %dl,(%eax)
     330:	0f b6 00             	movzbl (%eax),%eax
     333:	84 c0                	test   %al,%al
     335:	75 e2                	jne    319 <strcpy+0xd>
    ;
  return os;
     337:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     33a:	c9                   	leave  
     33b:	c3                   	ret    

0000033c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     33c:	55                   	push   %ebp
     33d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     33f:	eb 08                	jmp    349 <strcmp+0xd>
    p++, q++;
     341:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     345:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     349:	8b 45 08             	mov    0x8(%ebp),%eax
     34c:	0f b6 00             	movzbl (%eax),%eax
     34f:	84 c0                	test   %al,%al
     351:	74 10                	je     363 <strcmp+0x27>
     353:	8b 45 08             	mov    0x8(%ebp),%eax
     356:	0f b6 10             	movzbl (%eax),%edx
     359:	8b 45 0c             	mov    0xc(%ebp),%eax
     35c:	0f b6 00             	movzbl (%eax),%eax
     35f:	38 c2                	cmp    %al,%dl
     361:	74 de                	je     341 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     363:	8b 45 08             	mov    0x8(%ebp),%eax
     366:	0f b6 00             	movzbl (%eax),%eax
     369:	0f b6 d0             	movzbl %al,%edx
     36c:	8b 45 0c             	mov    0xc(%ebp),%eax
     36f:	0f b6 00             	movzbl (%eax),%eax
     372:	0f b6 c0             	movzbl %al,%eax
     375:	29 c2                	sub    %eax,%edx
     377:	89 d0                	mov    %edx,%eax
}
     379:	5d                   	pop    %ebp
     37a:	c3                   	ret    

0000037b <strlen>:

uint
strlen(char *s)
{
     37b:	55                   	push   %ebp
     37c:	89 e5                	mov    %esp,%ebp
     37e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     381:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     388:	eb 04                	jmp    38e <strlen+0x13>
     38a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     391:	8b 45 08             	mov    0x8(%ebp),%eax
     394:	01 d0                	add    %edx,%eax
     396:	0f b6 00             	movzbl (%eax),%eax
     399:	84 c0                	test   %al,%al
     39b:	75 ed                	jne    38a <strlen+0xf>
    ;
  return n;
     39d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3a0:	c9                   	leave  
     3a1:	c3                   	ret    

000003a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     3a2:	55                   	push   %ebp
     3a3:	89 e5                	mov    %esp,%ebp
     3a5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     3a8:	8b 45 10             	mov    0x10(%ebp),%eax
     3ab:	89 44 24 08          	mov    %eax,0x8(%esp)
     3af:	8b 45 0c             	mov    0xc(%ebp),%eax
     3b2:	89 44 24 04          	mov    %eax,0x4(%esp)
     3b6:	8b 45 08             	mov    0x8(%ebp),%eax
     3b9:	89 04 24             	mov    %eax,(%esp)
     3bc:	e8 26 ff ff ff       	call   2e7 <stosb>
  return dst;
     3c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3c4:	c9                   	leave  
     3c5:	c3                   	ret    

000003c6 <strchr>:

char*
strchr(const char *s, char c)
{
     3c6:	55                   	push   %ebp
     3c7:	89 e5                	mov    %esp,%ebp
     3c9:	83 ec 04             	sub    $0x4,%esp
     3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
     3cf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     3d2:	eb 14                	jmp    3e8 <strchr+0x22>
    if(*s == c)
     3d4:	8b 45 08             	mov    0x8(%ebp),%eax
     3d7:	0f b6 00             	movzbl (%eax),%eax
     3da:	3a 45 fc             	cmp    -0x4(%ebp),%al
     3dd:	75 05                	jne    3e4 <strchr+0x1e>
      return (char*)s;
     3df:	8b 45 08             	mov    0x8(%ebp),%eax
     3e2:	eb 13                	jmp    3f7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     3e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3e8:	8b 45 08             	mov    0x8(%ebp),%eax
     3eb:	0f b6 00             	movzbl (%eax),%eax
     3ee:	84 c0                	test   %al,%al
     3f0:	75 e2                	jne    3d4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     3f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3f7:	c9                   	leave  
     3f8:	c3                   	ret    

000003f9 <gets>:

char*
gets(char *buf, int max)
{
     3f9:	55                   	push   %ebp
     3fa:	89 e5                	mov    %esp,%ebp
     3fc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     3ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     406:	eb 4c                	jmp    454 <gets+0x5b>
    cc = read(0, &c, 1);
     408:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     40f:	00 
     410:	8d 45 ef             	lea    -0x11(%ebp),%eax
     413:	89 44 24 04          	mov    %eax,0x4(%esp)
     417:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     41e:	e8 44 01 00 00       	call   567 <read>
     423:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     42a:	7f 02                	jg     42e <gets+0x35>
      break;
     42c:	eb 31                	jmp    45f <gets+0x66>
    buf[i++] = c;
     42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     431:	8d 50 01             	lea    0x1(%eax),%edx
     434:	89 55 f4             	mov    %edx,-0xc(%ebp)
     437:	89 c2                	mov    %eax,%edx
     439:	8b 45 08             	mov    0x8(%ebp),%eax
     43c:	01 c2                	add    %eax,%edx
     43e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     442:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     444:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     448:	3c 0a                	cmp    $0xa,%al
     44a:	74 13                	je     45f <gets+0x66>
     44c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     450:	3c 0d                	cmp    $0xd,%al
     452:	74 0b                	je     45f <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     454:	8b 45 f4             	mov    -0xc(%ebp),%eax
     457:	83 c0 01             	add    $0x1,%eax
     45a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     45d:	7c a9                	jl     408 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     45f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     462:	8b 45 08             	mov    0x8(%ebp),%eax
     465:	01 d0                	add    %edx,%eax
     467:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     46a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     46d:	c9                   	leave  
     46e:	c3                   	ret    

0000046f <stat>:

int
stat(char *n, struct stat *st)
{
     46f:	55                   	push   %ebp
     470:	89 e5                	mov    %esp,%ebp
     472:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     475:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     47c:	00 
     47d:	8b 45 08             	mov    0x8(%ebp),%eax
     480:	89 04 24             	mov    %eax,(%esp)
     483:	e8 07 01 00 00       	call   58f <open>
     488:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     48b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     48f:	79 07                	jns    498 <stat+0x29>
    return -1;
     491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     496:	eb 23                	jmp    4bb <stat+0x4c>
  r = fstat(fd, st);
     498:	8b 45 0c             	mov    0xc(%ebp),%eax
     49b:	89 44 24 04          	mov    %eax,0x4(%esp)
     49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a2:	89 04 24             	mov    %eax,(%esp)
     4a5:	e8 fd 00 00 00       	call   5a7 <fstat>
     4aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b0:	89 04 24             	mov    %eax,(%esp)
     4b3:	e8 bf 00 00 00       	call   577 <close>
  return r;
     4b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     4bb:	c9                   	leave  
     4bc:	c3                   	ret    

000004bd <atoi>:

int
atoi(const char *s)
{
     4bd:	55                   	push   %ebp
     4be:	89 e5                	mov    %esp,%ebp
     4c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     4c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     4ca:	eb 25                	jmp    4f1 <atoi+0x34>
    n = n*10 + *s++ - '0';
     4cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
     4cf:	89 d0                	mov    %edx,%eax
     4d1:	c1 e0 02             	shl    $0x2,%eax
     4d4:	01 d0                	add    %edx,%eax
     4d6:	01 c0                	add    %eax,%eax
     4d8:	89 c1                	mov    %eax,%ecx
     4da:	8b 45 08             	mov    0x8(%ebp),%eax
     4dd:	8d 50 01             	lea    0x1(%eax),%edx
     4e0:	89 55 08             	mov    %edx,0x8(%ebp)
     4e3:	0f b6 00             	movzbl (%eax),%eax
     4e6:	0f be c0             	movsbl %al,%eax
     4e9:	01 c8                	add    %ecx,%eax
     4eb:	83 e8 30             	sub    $0x30,%eax
     4ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
     4f4:	0f b6 00             	movzbl (%eax),%eax
     4f7:	3c 2f                	cmp    $0x2f,%al
     4f9:	7e 0a                	jle    505 <atoi+0x48>
     4fb:	8b 45 08             	mov    0x8(%ebp),%eax
     4fe:	0f b6 00             	movzbl (%eax),%eax
     501:	3c 39                	cmp    $0x39,%al
     503:	7e c7                	jle    4cc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     505:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     508:	c9                   	leave  
     509:	c3                   	ret    

0000050a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     50a:	55                   	push   %ebp
     50b:	89 e5                	mov    %esp,%ebp
     50d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     510:	8b 45 08             	mov    0x8(%ebp),%eax
     513:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     516:	8b 45 0c             	mov    0xc(%ebp),%eax
     519:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     51c:	eb 17                	jmp    535 <memmove+0x2b>
    *dst++ = *src++;
     51e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     521:	8d 50 01             	lea    0x1(%eax),%edx
     524:	89 55 fc             	mov    %edx,-0x4(%ebp)
     527:	8b 55 f8             	mov    -0x8(%ebp),%edx
     52a:	8d 4a 01             	lea    0x1(%edx),%ecx
     52d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     530:	0f b6 12             	movzbl (%edx),%edx
     533:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     535:	8b 45 10             	mov    0x10(%ebp),%eax
     538:	8d 50 ff             	lea    -0x1(%eax),%edx
     53b:	89 55 10             	mov    %edx,0x10(%ebp)
     53e:	85 c0                	test   %eax,%eax
     540:	7f dc                	jg     51e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     542:	8b 45 08             	mov    0x8(%ebp),%eax
}
     545:	c9                   	leave  
     546:	c3                   	ret    

00000547 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     547:	b8 01 00 00 00       	mov    $0x1,%eax
     54c:	cd 40                	int    $0x40
     54e:	c3                   	ret    

0000054f <exit>:
SYSCALL(exit)
     54f:	b8 02 00 00 00       	mov    $0x2,%eax
     554:	cd 40                	int    $0x40
     556:	c3                   	ret    

00000557 <wait>:
SYSCALL(wait)
     557:	b8 03 00 00 00       	mov    $0x3,%eax
     55c:	cd 40                	int    $0x40
     55e:	c3                   	ret    

0000055f <pipe>:
SYSCALL(pipe)
     55f:	b8 04 00 00 00       	mov    $0x4,%eax
     564:	cd 40                	int    $0x40
     566:	c3                   	ret    

00000567 <read>:
SYSCALL(read)
     567:	b8 05 00 00 00       	mov    $0x5,%eax
     56c:	cd 40                	int    $0x40
     56e:	c3                   	ret    

0000056f <write>:
SYSCALL(write)
     56f:	b8 10 00 00 00       	mov    $0x10,%eax
     574:	cd 40                	int    $0x40
     576:	c3                   	ret    

00000577 <close>:
SYSCALL(close)
     577:	b8 15 00 00 00       	mov    $0x15,%eax
     57c:	cd 40                	int    $0x40
     57e:	c3                   	ret    

0000057f <kill>:
SYSCALL(kill)
     57f:	b8 06 00 00 00       	mov    $0x6,%eax
     584:	cd 40                	int    $0x40
     586:	c3                   	ret    

00000587 <exec>:
SYSCALL(exec)
     587:	b8 07 00 00 00       	mov    $0x7,%eax
     58c:	cd 40                	int    $0x40
     58e:	c3                   	ret    

0000058f <open>:
SYSCALL(open)
     58f:	b8 0f 00 00 00       	mov    $0xf,%eax
     594:	cd 40                	int    $0x40
     596:	c3                   	ret    

00000597 <mknod>:
SYSCALL(mknod)
     597:	b8 11 00 00 00       	mov    $0x11,%eax
     59c:	cd 40                	int    $0x40
     59e:	c3                   	ret    

0000059f <unlink>:
SYSCALL(unlink)
     59f:	b8 12 00 00 00       	mov    $0x12,%eax
     5a4:	cd 40                	int    $0x40
     5a6:	c3                   	ret    

000005a7 <fstat>:
SYSCALL(fstat)
     5a7:	b8 08 00 00 00       	mov    $0x8,%eax
     5ac:	cd 40                	int    $0x40
     5ae:	c3                   	ret    

000005af <link>:
SYSCALL(link)
     5af:	b8 13 00 00 00       	mov    $0x13,%eax
     5b4:	cd 40                	int    $0x40
     5b6:	c3                   	ret    

000005b7 <mkdir>:
SYSCALL(mkdir)
     5b7:	b8 14 00 00 00       	mov    $0x14,%eax
     5bc:	cd 40                	int    $0x40
     5be:	c3                   	ret    

000005bf <chdir>:
SYSCALL(chdir)
     5bf:	b8 09 00 00 00       	mov    $0x9,%eax
     5c4:	cd 40                	int    $0x40
     5c6:	c3                   	ret    

000005c7 <dup>:
SYSCALL(dup)
     5c7:	b8 0a 00 00 00       	mov    $0xa,%eax
     5cc:	cd 40                	int    $0x40
     5ce:	c3                   	ret    

000005cf <getpid>:
SYSCALL(getpid)
     5cf:	b8 0b 00 00 00       	mov    $0xb,%eax
     5d4:	cd 40                	int    $0x40
     5d6:	c3                   	ret    

000005d7 <sbrk>:
SYSCALL(sbrk)
     5d7:	b8 0c 00 00 00       	mov    $0xc,%eax
     5dc:	cd 40                	int    $0x40
     5de:	c3                   	ret    

000005df <sleep>:
SYSCALL(sleep)
     5df:	b8 0d 00 00 00       	mov    $0xd,%eax
     5e4:	cd 40                	int    $0x40
     5e6:	c3                   	ret    

000005e7 <uptime>:
SYSCALL(uptime)
     5e7:	b8 0e 00 00 00       	mov    $0xe,%eax
     5ec:	cd 40                	int    $0x40
     5ee:	c3                   	ret    

000005ef <kthread_create>:




SYSCALL(kthread_create)
     5ef:	b8 16 00 00 00       	mov    $0x16,%eax
     5f4:	cd 40                	int    $0x40
     5f6:	c3                   	ret    

000005f7 <kthread_id>:
SYSCALL(kthread_id)
     5f7:	b8 17 00 00 00       	mov    $0x17,%eax
     5fc:	cd 40                	int    $0x40
     5fe:	c3                   	ret    

000005ff <kthread_exit>:
SYSCALL(kthread_exit)
     5ff:	b8 18 00 00 00       	mov    $0x18,%eax
     604:	cd 40                	int    $0x40
     606:	c3                   	ret    

00000607 <kthread_join>:
SYSCALL(kthread_join)
     607:	b8 19 00 00 00       	mov    $0x19,%eax
     60c:	cd 40                	int    $0x40
     60e:	c3                   	ret    

0000060f <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     60f:	b8 1a 00 00 00       	mov    $0x1a,%eax
     614:	cd 40                	int    $0x40
     616:	c3                   	ret    

00000617 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     617:	b8 1b 00 00 00       	mov    $0x1b,%eax
     61c:	cd 40                	int    $0x40
     61e:	c3                   	ret    

0000061f <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     61f:	b8 1c 00 00 00       	mov    $0x1c,%eax
     624:	cd 40                	int    $0x40
     626:	c3                   	ret    

00000627 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     627:	b8 1d 00 00 00       	mov    $0x1d,%eax
     62c:	cd 40                	int    $0x40
     62e:	c3                   	ret    

0000062f <kthread_mutex_yieldlock>:
     62f:	b8 1e 00 00 00       	mov    $0x1e,%eax
     634:	cd 40                	int    $0x40
     636:	c3                   	ret    

00000637 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     637:	55                   	push   %ebp
     638:	89 e5                	mov    %esp,%ebp
     63a:	83 ec 18             	sub    $0x18,%esp
     63d:	8b 45 0c             	mov    0xc(%ebp),%eax
     640:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     643:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     64a:	00 
     64b:	8d 45 f4             	lea    -0xc(%ebp),%eax
     64e:	89 44 24 04          	mov    %eax,0x4(%esp)
     652:	8b 45 08             	mov    0x8(%ebp),%eax
     655:	89 04 24             	mov    %eax,(%esp)
     658:	e8 12 ff ff ff       	call   56f <write>
}
     65d:	c9                   	leave  
     65e:	c3                   	ret    

0000065f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     65f:	55                   	push   %ebp
     660:	89 e5                	mov    %esp,%ebp
     662:	56                   	push   %esi
     663:	53                   	push   %ebx
     664:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     667:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     66e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     672:	74 17                	je     68b <printint+0x2c>
     674:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     678:	79 11                	jns    68b <printint+0x2c>
    neg = 1;
     67a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     681:	8b 45 0c             	mov    0xc(%ebp),%eax
     684:	f7 d8                	neg    %eax
     686:	89 45 ec             	mov    %eax,-0x14(%ebp)
     689:	eb 06                	jmp    691 <printint+0x32>
  } else {
    x = xx;
     68b:	8b 45 0c             	mov    0xc(%ebp),%eax
     68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     698:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     69b:	8d 41 01             	lea    0x1(%ecx),%eax
     69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6a7:	ba 00 00 00 00       	mov    $0x0,%edx
     6ac:	f7 f3                	div    %ebx
     6ae:	89 d0                	mov    %edx,%eax
     6b0:	0f b6 80 b0 18 00 00 	movzbl 0x18b0(%eax),%eax
     6b7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6bb:	8b 75 10             	mov    0x10(%ebp),%esi
     6be:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6c1:	ba 00 00 00 00       	mov    $0x0,%edx
     6c6:	f7 f6                	div    %esi
     6c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6cf:	75 c7                	jne    698 <printint+0x39>
  if(neg)
     6d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6d5:	74 10                	je     6e7 <printint+0x88>
    buf[i++] = '-';
     6d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6da:	8d 50 01             	lea    0x1(%eax),%edx
     6dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     6e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     6e5:	eb 1f                	jmp    706 <printint+0xa7>
     6e7:	eb 1d                	jmp    706 <printint+0xa7>
    putc(fd, buf[i]);
     6e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
     6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ef:	01 d0                	add    %edx,%eax
     6f1:	0f b6 00             	movzbl (%eax),%eax
     6f4:	0f be c0             	movsbl %al,%eax
     6f7:	89 44 24 04          	mov    %eax,0x4(%esp)
     6fb:	8b 45 08             	mov    0x8(%ebp),%eax
     6fe:	89 04 24             	mov    %eax,(%esp)
     701:	e8 31 ff ff ff       	call   637 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     706:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     70a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     70e:	79 d9                	jns    6e9 <printint+0x8a>
    putc(fd, buf[i]);
}
     710:	83 c4 30             	add    $0x30,%esp
     713:	5b                   	pop    %ebx
     714:	5e                   	pop    %esi
     715:	5d                   	pop    %ebp
     716:	c3                   	ret    

00000717 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     717:	55                   	push   %ebp
     718:	89 e5                	mov    %esp,%ebp
     71a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     71d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     724:	8d 45 0c             	lea    0xc(%ebp),%eax
     727:	83 c0 04             	add    $0x4,%eax
     72a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     72d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     734:	e9 7c 01 00 00       	jmp    8b5 <printf+0x19e>
    c = fmt[i] & 0xff;
     739:	8b 55 0c             	mov    0xc(%ebp),%edx
     73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     73f:	01 d0                	add    %edx,%eax
     741:	0f b6 00             	movzbl (%eax),%eax
     744:	0f be c0             	movsbl %al,%eax
     747:	25 ff 00 00 00       	and    $0xff,%eax
     74c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     74f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     753:	75 2c                	jne    781 <printf+0x6a>
      if(c == '%'){
     755:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     759:	75 0c                	jne    767 <printf+0x50>
        state = '%';
     75b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     762:	e9 4a 01 00 00       	jmp    8b1 <printf+0x19a>
      } else {
        putc(fd, c);
     767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     76a:	0f be c0             	movsbl %al,%eax
     76d:	89 44 24 04          	mov    %eax,0x4(%esp)
     771:	8b 45 08             	mov    0x8(%ebp),%eax
     774:	89 04 24             	mov    %eax,(%esp)
     777:	e8 bb fe ff ff       	call   637 <putc>
     77c:	e9 30 01 00 00       	jmp    8b1 <printf+0x19a>
      }
    } else if(state == '%'){
     781:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     785:	0f 85 26 01 00 00    	jne    8b1 <printf+0x19a>
      if(c == 'd'){
     78b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     78f:	75 2d                	jne    7be <printf+0xa7>
        printint(fd, *ap, 10, 1);
     791:	8b 45 e8             	mov    -0x18(%ebp),%eax
     794:	8b 00                	mov    (%eax),%eax
     796:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     79d:	00 
     79e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     7a5:	00 
     7a6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7aa:	8b 45 08             	mov    0x8(%ebp),%eax
     7ad:	89 04 24             	mov    %eax,(%esp)
     7b0:	e8 aa fe ff ff       	call   65f <printint>
        ap++;
     7b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7b9:	e9 ec 00 00 00       	jmp    8aa <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     7be:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     7c2:	74 06                	je     7ca <printf+0xb3>
     7c4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7c8:	75 2d                	jne    7f7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     7ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7cd:	8b 00                	mov    (%eax),%eax
     7cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7d6:	00 
     7d7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     7de:	00 
     7df:	89 44 24 04          	mov    %eax,0x4(%esp)
     7e3:	8b 45 08             	mov    0x8(%ebp),%eax
     7e6:	89 04 24             	mov    %eax,(%esp)
     7e9:	e8 71 fe ff ff       	call   65f <printint>
        ap++;
     7ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7f2:	e9 b3 00 00 00       	jmp    8aa <printf+0x193>
      } else if(c == 's'){
     7f7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     7fb:	75 45                	jne    842 <printf+0x12b>
        s = (char*)*ap;
     7fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     800:	8b 00                	mov    (%eax),%eax
     802:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     805:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     80d:	75 09                	jne    818 <printf+0x101>
          s = "(null)";
     80f:	c7 45 f4 ce 13 00 00 	movl   $0x13ce,-0xc(%ebp)
        while(*s != 0){
     816:	eb 1e                	jmp    836 <printf+0x11f>
     818:	eb 1c                	jmp    836 <printf+0x11f>
          putc(fd, *s);
     81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81d:	0f b6 00             	movzbl (%eax),%eax
     820:	0f be c0             	movsbl %al,%eax
     823:	89 44 24 04          	mov    %eax,0x4(%esp)
     827:	8b 45 08             	mov    0x8(%ebp),%eax
     82a:	89 04 24             	mov    %eax,(%esp)
     82d:	e8 05 fe ff ff       	call   637 <putc>
          s++;
     832:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     836:	8b 45 f4             	mov    -0xc(%ebp),%eax
     839:	0f b6 00             	movzbl (%eax),%eax
     83c:	84 c0                	test   %al,%al
     83e:	75 da                	jne    81a <printf+0x103>
     840:	eb 68                	jmp    8aa <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     842:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     846:	75 1d                	jne    865 <printf+0x14e>
        putc(fd, *ap);
     848:	8b 45 e8             	mov    -0x18(%ebp),%eax
     84b:	8b 00                	mov    (%eax),%eax
     84d:	0f be c0             	movsbl %al,%eax
     850:	89 44 24 04          	mov    %eax,0x4(%esp)
     854:	8b 45 08             	mov    0x8(%ebp),%eax
     857:	89 04 24             	mov    %eax,(%esp)
     85a:	e8 d8 fd ff ff       	call   637 <putc>
        ap++;
     85f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     863:	eb 45                	jmp    8aa <printf+0x193>
      } else if(c == '%'){
     865:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     869:	75 17                	jne    882 <printf+0x16b>
        putc(fd, c);
     86b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     86e:	0f be c0             	movsbl %al,%eax
     871:	89 44 24 04          	mov    %eax,0x4(%esp)
     875:	8b 45 08             	mov    0x8(%ebp),%eax
     878:	89 04 24             	mov    %eax,(%esp)
     87b:	e8 b7 fd ff ff       	call   637 <putc>
     880:	eb 28                	jmp    8aa <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     882:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     889:	00 
     88a:	8b 45 08             	mov    0x8(%ebp),%eax
     88d:	89 04 24             	mov    %eax,(%esp)
     890:	e8 a2 fd ff ff       	call   637 <putc>
        putc(fd, c);
     895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     898:	0f be c0             	movsbl %al,%eax
     89b:	89 44 24 04          	mov    %eax,0x4(%esp)
     89f:	8b 45 08             	mov    0x8(%ebp),%eax
     8a2:	89 04 24             	mov    %eax,(%esp)
     8a5:	e8 8d fd ff ff       	call   637 <putc>
      }
      state = 0;
     8aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     8b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     8b5:	8b 55 0c             	mov    0xc(%ebp),%edx
     8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8bb:	01 d0                	add    %edx,%eax
     8bd:	0f b6 00             	movzbl (%eax),%eax
     8c0:	84 c0                	test   %al,%al
     8c2:	0f 85 71 fe ff ff    	jne    739 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8c8:	c9                   	leave  
     8c9:	c3                   	ret    

000008ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8ca:	55                   	push   %ebp
     8cb:	89 e5                	mov    %esp,%ebp
     8cd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8d0:	8b 45 08             	mov    0x8(%ebp),%eax
     8d3:	83 e8 08             	sub    $0x8,%eax
     8d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8d9:	a1 cc 18 00 00       	mov    0x18cc,%eax
     8de:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8e1:	eb 24                	jmp    907 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8e6:	8b 00                	mov    (%eax),%eax
     8e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8eb:	77 12                	ja     8ff <free+0x35>
     8ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8f3:	77 24                	ja     919 <free+0x4f>
     8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8f8:	8b 00                	mov    (%eax),%eax
     8fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8fd:	77 1a                	ja     919 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
     902:	8b 00                	mov    (%eax),%eax
     904:	89 45 fc             	mov    %eax,-0x4(%ebp)
     907:	8b 45 f8             	mov    -0x8(%ebp),%eax
     90a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     90d:	76 d4                	jbe    8e3 <free+0x19>
     90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     912:	8b 00                	mov    (%eax),%eax
     914:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     917:	76 ca                	jbe    8e3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     919:	8b 45 f8             	mov    -0x8(%ebp),%eax
     91c:	8b 40 04             	mov    0x4(%eax),%eax
     91f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     926:	8b 45 f8             	mov    -0x8(%ebp),%eax
     929:	01 c2                	add    %eax,%edx
     92b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     92e:	8b 00                	mov    (%eax),%eax
     930:	39 c2                	cmp    %eax,%edx
     932:	75 24                	jne    958 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     934:	8b 45 f8             	mov    -0x8(%ebp),%eax
     937:	8b 50 04             	mov    0x4(%eax),%edx
     93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     93d:	8b 00                	mov    (%eax),%eax
     93f:	8b 40 04             	mov    0x4(%eax),%eax
     942:	01 c2                	add    %eax,%edx
     944:	8b 45 f8             	mov    -0x8(%ebp),%eax
     947:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     94d:	8b 00                	mov    (%eax),%eax
     94f:	8b 10                	mov    (%eax),%edx
     951:	8b 45 f8             	mov    -0x8(%ebp),%eax
     954:	89 10                	mov    %edx,(%eax)
     956:	eb 0a                	jmp    962 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     958:	8b 45 fc             	mov    -0x4(%ebp),%eax
     95b:	8b 10                	mov    (%eax),%edx
     95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     960:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     962:	8b 45 fc             	mov    -0x4(%ebp),%eax
     965:	8b 40 04             	mov    0x4(%eax),%eax
     968:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     972:	01 d0                	add    %edx,%eax
     974:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     977:	75 20                	jne    999 <free+0xcf>
    p->s.size += bp->s.size;
     979:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97c:	8b 50 04             	mov    0x4(%eax),%edx
     97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     982:	8b 40 04             	mov    0x4(%eax),%eax
     985:	01 c2                	add    %eax,%edx
     987:	8b 45 fc             	mov    -0x4(%ebp),%eax
     98a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     990:	8b 10                	mov    (%eax),%edx
     992:	8b 45 fc             	mov    -0x4(%ebp),%eax
     995:	89 10                	mov    %edx,(%eax)
     997:	eb 08                	jmp    9a1 <free+0xd7>
  } else
    p->s.ptr = bp;
     999:	8b 45 fc             	mov    -0x4(%ebp),%eax
     99c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     99f:	89 10                	mov    %edx,(%eax)
  freep = p;
     9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a4:	a3 cc 18 00 00       	mov    %eax,0x18cc
}
     9a9:	c9                   	leave  
     9aa:	c3                   	ret    

000009ab <morecore>:

static Header*
morecore(uint nu)
{
     9ab:	55                   	push   %ebp
     9ac:	89 e5                	mov    %esp,%ebp
     9ae:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     9b1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     9b8:	77 07                	ja     9c1 <morecore+0x16>
    nu = 4096;
     9ba:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     9c1:	8b 45 08             	mov    0x8(%ebp),%eax
     9c4:	c1 e0 03             	shl    $0x3,%eax
     9c7:	89 04 24             	mov    %eax,(%esp)
     9ca:	e8 08 fc ff ff       	call   5d7 <sbrk>
     9cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9d6:	75 07                	jne    9df <morecore+0x34>
    return 0;
     9d8:	b8 00 00 00 00       	mov    $0x0,%eax
     9dd:	eb 22                	jmp    a01 <morecore+0x56>
  hp = (Header*)p;
     9df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     9e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9e8:	8b 55 08             	mov    0x8(%ebp),%edx
     9eb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     9ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9f1:	83 c0 08             	add    $0x8,%eax
     9f4:	89 04 24             	mov    %eax,(%esp)
     9f7:	e8 ce fe ff ff       	call   8ca <free>
  return freep;
     9fc:	a1 cc 18 00 00       	mov    0x18cc,%eax
}
     a01:	c9                   	leave  
     a02:	c3                   	ret    

00000a03 <malloc>:

void*
malloc(uint nbytes)
{
     a03:	55                   	push   %ebp
     a04:	89 e5                	mov    %esp,%ebp
     a06:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a09:	8b 45 08             	mov    0x8(%ebp),%eax
     a0c:	83 c0 07             	add    $0x7,%eax
     a0f:	c1 e8 03             	shr    $0x3,%eax
     a12:	83 c0 01             	add    $0x1,%eax
     a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a18:	a1 cc 18 00 00       	mov    0x18cc,%eax
     a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a24:	75 23                	jne    a49 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a26:	c7 45 f0 c4 18 00 00 	movl   $0x18c4,-0x10(%ebp)
     a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a30:	a3 cc 18 00 00       	mov    %eax,0x18cc
     a35:	a1 cc 18 00 00       	mov    0x18cc,%eax
     a3a:	a3 c4 18 00 00       	mov    %eax,0x18c4
    base.s.size = 0;
     a3f:	c7 05 c8 18 00 00 00 	movl   $0x0,0x18c8
     a46:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a4c:	8b 00                	mov    (%eax),%eax
     a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a54:	8b 40 04             	mov    0x4(%eax),%eax
     a57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a5a:	72 4d                	jb     aa9 <malloc+0xa6>
      if(p->s.size == nunits)
     a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a5f:	8b 40 04             	mov    0x4(%eax),%eax
     a62:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a65:	75 0c                	jne    a73 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6a:	8b 10                	mov    (%eax),%edx
     a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a6f:	89 10                	mov    %edx,(%eax)
     a71:	eb 26                	jmp    a99 <malloc+0x96>
      else {
        p->s.size -= nunits;
     a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a76:	8b 40 04             	mov    0x4(%eax),%eax
     a79:	2b 45 ec             	sub    -0x14(%ebp),%eax
     a7c:	89 c2                	mov    %eax,%edx
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a87:	8b 40 04             	mov    0x4(%eax),%eax
     a8a:	c1 e0 03             	shl    $0x3,%eax
     a8d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a96:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a9c:	a3 cc 18 00 00       	mov    %eax,0x18cc
      return (void*)(p + 1);
     aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa4:	83 c0 08             	add    $0x8,%eax
     aa7:	eb 38                	jmp    ae1 <malloc+0xde>
    }
    if(p == freep)
     aa9:	a1 cc 18 00 00       	mov    0x18cc,%eax
     aae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ab1:	75 1b                	jne    ace <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab6:	89 04 24             	mov    %eax,(%esp)
     ab9:	e8 ed fe ff ff       	call   9ab <morecore>
     abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ac5:	75 07                	jne    ace <malloc+0xcb>
        return 0;
     ac7:	b8 00 00 00 00       	mov    $0x0,%eax
     acc:	eb 13                	jmp    ae1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad7:	8b 00                	mov    (%eax),%eax
     ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     adc:	e9 70 ff ff ff       	jmp    a51 <malloc+0x4e>
}
     ae1:	c9                   	leave  
     ae2:	c3                   	ret    

00000ae3 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     ae3:	55                   	push   %ebp
     ae4:	89 e5                	mov    %esp,%ebp
     ae6:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     ae9:	e8 21 fb ff ff       	call   60f <kthread_mutex_alloc>
     aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     af5:	79 0a                	jns    b01 <mesa_slots_monitor_alloc+0x1e>
		return 0;
     af7:	b8 00 00 00 00       	mov    $0x0,%eax
     afc:	e9 8b 00 00 00       	jmp    b8c <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     b01:	e8 44 06 00 00       	call   114a <mesa_cond_alloc>
     b06:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b0d:	75 12                	jne    b21 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b12:	89 04 24             	mov    %eax,(%esp)
     b15:	e8 fd fa ff ff       	call   617 <kthread_mutex_dealloc>
		return 0;
     b1a:	b8 00 00 00 00       	mov    $0x0,%eax
     b1f:	eb 6b                	jmp    b8c <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     b21:	e8 24 06 00 00       	call   114a <mesa_cond_alloc>
     b26:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b2d:	75 1d                	jne    b4c <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b32:	89 04 24             	mov    %eax,(%esp)
     b35:	e8 dd fa ff ff       	call   617 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b3d:	89 04 24             	mov    %eax,(%esp)
     b40:	e8 46 06 00 00       	call   118b <mesa_cond_dealloc>
		return 0;
     b45:	b8 00 00 00 00       	mov    $0x0,%eax
     b4a:	eb 40                	jmp    b8c <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     b4c:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b53:	e8 ab fe ff ff       	call   a03 <malloc>
     b58:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b61:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b67:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b6a:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b73:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b82:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b89:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b8c:	c9                   	leave  
     b8d:	c3                   	ret    

00000b8e <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     b8e:	55                   	push   %ebp
     b8f:	89 e5                	mov    %esp,%ebp
     b91:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	8b 00                	mov    (%eax),%eax
     b99:	89 04 24             	mov    %eax,(%esp)
     b9c:	e8 76 fa ff ff       	call   617 <kthread_mutex_dealloc>
     ba1:	85 c0                	test   %eax,%eax
     ba3:	78 2e                	js     bd3 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     ba5:	8b 45 08             	mov    0x8(%ebp),%eax
     ba8:	8b 40 04             	mov    0x4(%eax),%eax
     bab:	89 04 24             	mov    %eax,(%esp)
     bae:	e8 97 05 00 00       	call   114a <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     bb3:	8b 45 08             	mov    0x8(%ebp),%eax
     bb6:	8b 40 08             	mov    0x8(%eax),%eax
     bb9:	89 04 24             	mov    %eax,(%esp)
     bbc:	e8 89 05 00 00       	call   114a <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     bc1:	8b 45 08             	mov    0x8(%ebp),%eax
     bc4:	89 04 24             	mov    %eax,(%esp)
     bc7:	e8 fe fc ff ff       	call   8ca <free>
	return 0;
     bcc:	b8 00 00 00 00       	mov    $0x0,%eax
     bd1:	eb 05                	jmp    bd8 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bd8:	c9                   	leave  
     bd9:	c3                   	ret    

00000bda <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     bda:	55                   	push   %ebp
     bdb:	89 e5                	mov    %esp,%ebp
     bdd:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     be0:	8b 45 08             	mov    0x8(%ebp),%eax
     be3:	8b 40 10             	mov    0x10(%eax),%eax
     be6:	85 c0                	test   %eax,%eax
     be8:	75 0a                	jne    bf4 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bef:	e9 81 00 00 00       	jmp    c75 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bf4:	8b 45 08             	mov    0x8(%ebp),%eax
     bf7:	8b 00                	mov    (%eax),%eax
     bf9:	89 04 24             	mov    %eax,(%esp)
     bfc:	e8 1e fa ff ff       	call   61f <kthread_mutex_lock>
     c01:	83 f8 ff             	cmp    $0xffffffff,%eax
     c04:	7d 07                	jge    c0d <mesa_slots_monitor_addslots+0x33>
		return -1;
     c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c0b:	eb 68                	jmp    c75 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     c0d:	eb 17                	jmp    c26 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     c0f:	8b 45 08             	mov    0x8(%ebp),%eax
     c12:	8b 10                	mov    (%eax),%edx
     c14:	8b 45 08             	mov    0x8(%ebp),%eax
     c17:	8b 40 08             	mov    0x8(%eax),%eax
     c1a:	89 54 24 04          	mov    %edx,0x4(%esp)
     c1e:	89 04 24             	mov    %eax,(%esp)
     c21:	e8 af 05 00 00       	call   11d5 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c26:	8b 45 08             	mov    0x8(%ebp),%eax
     c29:	8b 40 10             	mov    0x10(%eax),%eax
     c2c:	85 c0                	test   %eax,%eax
     c2e:	74 0a                	je     c3a <mesa_slots_monitor_addslots+0x60>
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	8b 40 0c             	mov    0xc(%eax),%eax
     c36:	85 c0                	test   %eax,%eax
     c38:	7f d5                	jg     c0f <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     c3a:	8b 45 08             	mov    0x8(%ebp),%eax
     c3d:	8b 40 10             	mov    0x10(%eax),%eax
     c40:	85 c0                	test   %eax,%eax
     c42:	74 11                	je     c55 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     c44:	8b 45 08             	mov    0x8(%ebp),%eax
     c47:	8b 50 0c             	mov    0xc(%eax),%edx
     c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4d:	01 c2                	add    %eax,%edx
     c4f:	8b 45 08             	mov    0x8(%ebp),%eax
     c52:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     c55:	8b 45 08             	mov    0x8(%ebp),%eax
     c58:	8b 40 04             	mov    0x4(%eax),%eax
     c5b:	89 04 24             	mov    %eax,(%esp)
     c5e:	e8 dc 05 00 00       	call   123f <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c63:	8b 45 08             	mov    0x8(%ebp),%eax
     c66:	8b 00                	mov    (%eax),%eax
     c68:	89 04 24             	mov    %eax,(%esp)
     c6b:	e8 b7 f9 ff ff       	call   627 <kthread_mutex_unlock>

	return 1;
     c70:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c75:	c9                   	leave  
     c76:	c3                   	ret    

00000c77 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     c77:	55                   	push   %ebp
     c78:	89 e5                	mov    %esp,%ebp
     c7a:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c7d:	8b 45 08             	mov    0x8(%ebp),%eax
     c80:	8b 40 10             	mov    0x10(%eax),%eax
     c83:	85 c0                	test   %eax,%eax
     c85:	75 07                	jne    c8e <mesa_slots_monitor_takeslot+0x17>
		return -1;
     c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c8c:	eb 7f                	jmp    d0d <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c8e:	8b 45 08             	mov    0x8(%ebp),%eax
     c91:	8b 00                	mov    (%eax),%eax
     c93:	89 04 24             	mov    %eax,(%esp)
     c96:	e8 84 f9 ff ff       	call   61f <kthread_mutex_lock>
     c9b:	83 f8 ff             	cmp    $0xffffffff,%eax
     c9e:	7d 07                	jge    ca7 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ca5:	eb 66                	jmp    d0d <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     ca7:	eb 17                	jmp    cc0 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     ca9:	8b 45 08             	mov    0x8(%ebp),%eax
     cac:	8b 10                	mov    (%eax),%edx
     cae:	8b 45 08             	mov    0x8(%ebp),%eax
     cb1:	8b 40 04             	mov    0x4(%eax),%eax
     cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
     cb8:	89 04 24             	mov    %eax,(%esp)
     cbb:	e8 15 05 00 00       	call   11d5 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     cc0:	8b 45 08             	mov    0x8(%ebp),%eax
     cc3:	8b 40 10             	mov    0x10(%eax),%eax
     cc6:	85 c0                	test   %eax,%eax
     cc8:	74 0a                	je     cd4 <mesa_slots_monitor_takeslot+0x5d>
     cca:	8b 45 08             	mov    0x8(%ebp),%eax
     ccd:	8b 40 0c             	mov    0xc(%eax),%eax
     cd0:	85 c0                	test   %eax,%eax
     cd2:	74 d5                	je     ca9 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     cd4:	8b 45 08             	mov    0x8(%ebp),%eax
     cd7:	8b 40 10             	mov    0x10(%eax),%eax
     cda:	85 c0                	test   %eax,%eax
     cdc:	74 0f                	je     ced <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     cde:	8b 45 08             	mov    0x8(%ebp),%eax
     ce1:	8b 40 0c             	mov    0xc(%eax),%eax
     ce4:	8d 50 ff             	lea    -0x1(%eax),%edx
     ce7:	8b 45 08             	mov    0x8(%ebp),%eax
     cea:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     ced:	8b 45 08             	mov    0x8(%ebp),%eax
     cf0:	8b 40 08             	mov    0x8(%eax),%eax
     cf3:	89 04 24             	mov    %eax,(%esp)
     cf6:	e8 44 05 00 00       	call   123f <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     cfb:	8b 45 08             	mov    0x8(%ebp),%eax
     cfe:	8b 00                	mov    (%eax),%eax
     d00:	89 04 24             	mov    %eax,(%esp)
     d03:	e8 1f f9 ff ff       	call   627 <kthread_mutex_unlock>

	return 1;
     d08:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d0d:	c9                   	leave  
     d0e:	c3                   	ret    

00000d0f <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     d0f:	55                   	push   %ebp
     d10:	89 e5                	mov    %esp,%ebp
     d12:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d15:	8b 45 08             	mov    0x8(%ebp),%eax
     d18:	8b 40 10             	mov    0x10(%eax),%eax
     d1b:	85 c0                	test   %eax,%eax
     d1d:	75 07                	jne    d26 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d24:	eb 35                	jmp    d5b <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	8b 00                	mov    (%eax),%eax
     d2b:	89 04 24             	mov    %eax,(%esp)
     d2e:	e8 ec f8 ff ff       	call   61f <kthread_mutex_lock>
     d33:	83 f8 ff             	cmp    $0xffffffff,%eax
     d36:	7d 07                	jge    d3f <mesa_slots_monitor_stopadding+0x30>
			return -1;
     d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d3d:	eb 1c                	jmp    d5b <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d3f:	8b 45 08             	mov    0x8(%ebp),%eax
     d42:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d49:	8b 45 08             	mov    0x8(%ebp),%eax
     d4c:	8b 00                	mov    (%eax),%eax
     d4e:	89 04 24             	mov    %eax,(%esp)
     d51:	e8 d1 f8 ff ff       	call   627 <kthread_mutex_unlock>

		return 0;
     d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d5b:	c9                   	leave  
     d5c:	c3                   	ret    

00000d5d <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     d5d:	55                   	push   %ebp
     d5e:	89 e5                	mov    %esp,%ebp
     d60:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     d63:	e8 a7 f8 ff ff       	call   60f <kthread_mutex_alloc>
     d68:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d6f:	79 0a                	jns    d7b <hoare_slots_monitor_alloc+0x1e>
		return 0;
     d71:	b8 00 00 00 00       	mov    $0x0,%eax
     d76:	e9 8b 00 00 00       	jmp    e06 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     d7b:	e8 68 02 00 00       	call   fe8 <hoare_cond_alloc>
     d80:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     d83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d87:	75 12                	jne    d9b <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8c:	89 04 24             	mov    %eax,(%esp)
     d8f:	e8 83 f8 ff ff       	call   617 <kthread_mutex_dealloc>
		return 0;
     d94:	b8 00 00 00 00       	mov    $0x0,%eax
     d99:	eb 6b                	jmp    e06 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     d9b:	e8 48 02 00 00       	call   fe8 <hoare_cond_alloc>
     da0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     da7:	75 1d                	jne    dc6 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dac:	89 04 24             	mov    %eax,(%esp)
     daf:	e8 63 f8 ff ff       	call   617 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     db7:	89 04 24             	mov    %eax,(%esp)
     dba:	e8 6a 02 00 00       	call   1029 <hoare_cond_dealloc>
		return 0;
     dbf:	b8 00 00 00 00       	mov    $0x0,%eax
     dc4:	eb 40                	jmp    e06 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     dc6:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     dcd:	e8 31 fc ff ff       	call   a03 <malloc>
     dd2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ddb:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
     de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
     de4:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ded:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     def:	8b 45 e8             	mov    -0x18(%ebp),%eax
     df2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dfc:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     e03:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     e06:	c9                   	leave  
     e07:	c3                   	ret    

00000e08 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     e0e:	8b 45 08             	mov    0x8(%ebp),%eax
     e11:	8b 00                	mov    (%eax),%eax
     e13:	89 04 24             	mov    %eax,(%esp)
     e16:	e8 fc f7 ff ff       	call   617 <kthread_mutex_dealloc>
     e1b:	85 c0                	test   %eax,%eax
     e1d:	78 2e                	js     e4d <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     e1f:	8b 45 08             	mov    0x8(%ebp),%eax
     e22:	8b 40 04             	mov    0x4(%eax),%eax
     e25:	89 04 24             	mov    %eax,(%esp)
     e28:	e8 bb 01 00 00       	call   fe8 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     e2d:	8b 45 08             	mov    0x8(%ebp),%eax
     e30:	8b 40 08             	mov    0x8(%eax),%eax
     e33:	89 04 24             	mov    %eax,(%esp)
     e36:	e8 ad 01 00 00       	call   fe8 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     e3b:	8b 45 08             	mov    0x8(%ebp),%eax
     e3e:	89 04 24             	mov    %eax,(%esp)
     e41:	e8 84 fa ff ff       	call   8ca <free>
	return 0;
     e46:	b8 00 00 00 00       	mov    $0x0,%eax
     e4b:	eb 05                	jmp    e52 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     e52:	c9                   	leave  
     e53:	c3                   	ret    

00000e54 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     e54:	55                   	push   %ebp
     e55:	89 e5                	mov    %esp,%ebp
     e57:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     e5a:	8b 45 08             	mov    0x8(%ebp),%eax
     e5d:	8b 40 10             	mov    0x10(%eax),%eax
     e60:	85 c0                	test   %eax,%eax
     e62:	75 0a                	jne    e6e <hoare_slots_monitor_addslots+0x1a>
		return -1;
     e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e69:	e9 88 00 00 00       	jmp    ef6 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e6e:	8b 45 08             	mov    0x8(%ebp),%eax
     e71:	8b 00                	mov    (%eax),%eax
     e73:	89 04 24             	mov    %eax,(%esp)
     e76:	e8 a4 f7 ff ff       	call   61f <kthread_mutex_lock>
     e7b:	83 f8 ff             	cmp    $0xffffffff,%eax
     e7e:	7d 07                	jge    e87 <hoare_slots_monitor_addslots+0x33>
		return -1;
     e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e85:	eb 6f                	jmp    ef6 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     e87:	8b 45 08             	mov    0x8(%ebp),%eax
     e8a:	8b 40 10             	mov    0x10(%eax),%eax
     e8d:	85 c0                	test   %eax,%eax
     e8f:	74 21                	je     eb2 <hoare_slots_monitor_addslots+0x5e>
     e91:	8b 45 08             	mov    0x8(%ebp),%eax
     e94:	8b 40 0c             	mov    0xc(%eax),%eax
     e97:	85 c0                	test   %eax,%eax
     e99:	7e 17                	jle    eb2 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     e9b:	8b 45 08             	mov    0x8(%ebp),%eax
     e9e:	8b 10                	mov    (%eax),%edx
     ea0:	8b 45 08             	mov    0x8(%ebp),%eax
     ea3:	8b 40 08             	mov    0x8(%eax),%eax
     ea6:	89 54 24 04          	mov    %edx,0x4(%esp)
     eaa:	89 04 24             	mov    %eax,(%esp)
     ead:	e8 c1 01 00 00       	call   1073 <hoare_cond_wait>


	if  ( monitor->active)
     eb2:	8b 45 08             	mov    0x8(%ebp),%eax
     eb5:	8b 40 10             	mov    0x10(%eax),%eax
     eb8:	85 c0                	test   %eax,%eax
     eba:	74 11                	je     ecd <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     ebc:	8b 45 08             	mov    0x8(%ebp),%eax
     ebf:	8b 50 0c             	mov    0xc(%eax),%edx
     ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec5:	01 c2                	add    %eax,%edx
     ec7:	8b 45 08             	mov    0x8(%ebp),%eax
     eca:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     ecd:	8b 45 08             	mov    0x8(%ebp),%eax
     ed0:	8b 10                	mov    (%eax),%edx
     ed2:	8b 45 08             	mov    0x8(%ebp),%eax
     ed5:	8b 40 04             	mov    0x4(%eax),%eax
     ed8:	89 54 24 04          	mov    %edx,0x4(%esp)
     edc:	89 04 24             	mov    %eax,(%esp)
     edf:	e8 e6 01 00 00       	call   10ca <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ee4:	8b 45 08             	mov    0x8(%ebp),%eax
     ee7:	8b 00                	mov    (%eax),%eax
     ee9:	89 04 24             	mov    %eax,(%esp)
     eec:	e8 36 f7 ff ff       	call   627 <kthread_mutex_unlock>

	return 1;
     ef1:	b8 01 00 00 00       	mov    $0x1,%eax


}
     ef6:	c9                   	leave  
     ef7:	c3                   	ret    

00000ef8 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     ef8:	55                   	push   %ebp
     ef9:	89 e5                	mov    %esp,%ebp
     efb:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     efe:	8b 45 08             	mov    0x8(%ebp),%eax
     f01:	8b 40 10             	mov    0x10(%eax),%eax
     f04:	85 c0                	test   %eax,%eax
     f06:	75 0a                	jne    f12 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f0d:	e9 86 00 00 00       	jmp    f98 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f12:	8b 45 08             	mov    0x8(%ebp),%eax
     f15:	8b 00                	mov    (%eax),%eax
     f17:	89 04 24             	mov    %eax,(%esp)
     f1a:	e8 00 f7 ff ff       	call   61f <kthread_mutex_lock>
     f1f:	83 f8 ff             	cmp    $0xffffffff,%eax
     f22:	7d 07                	jge    f2b <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f29:	eb 6d                	jmp    f98 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f2b:	8b 45 08             	mov    0x8(%ebp),%eax
     f2e:	8b 40 10             	mov    0x10(%eax),%eax
     f31:	85 c0                	test   %eax,%eax
     f33:	74 21                	je     f56 <hoare_slots_monitor_takeslot+0x5e>
     f35:	8b 45 08             	mov    0x8(%ebp),%eax
     f38:	8b 40 0c             	mov    0xc(%eax),%eax
     f3b:	85 c0                	test   %eax,%eax
     f3d:	75 17                	jne    f56 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     f3f:	8b 45 08             	mov    0x8(%ebp),%eax
     f42:	8b 10                	mov    (%eax),%edx
     f44:	8b 45 08             	mov    0x8(%ebp),%eax
     f47:	8b 40 04             	mov    0x4(%eax),%eax
     f4a:	89 54 24 04          	mov    %edx,0x4(%esp)
     f4e:	89 04 24             	mov    %eax,(%esp)
     f51:	e8 1d 01 00 00       	call   1073 <hoare_cond_wait>


	if  ( monitor->active)
     f56:	8b 45 08             	mov    0x8(%ebp),%eax
     f59:	8b 40 10             	mov    0x10(%eax),%eax
     f5c:	85 c0                	test   %eax,%eax
     f5e:	74 0f                	je     f6f <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     f60:	8b 45 08             	mov    0x8(%ebp),%eax
     f63:	8b 40 0c             	mov    0xc(%eax),%eax
     f66:	8d 50 ff             	lea    -0x1(%eax),%edx
     f69:	8b 45 08             	mov    0x8(%ebp),%eax
     f6c:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     f6f:	8b 45 08             	mov    0x8(%ebp),%eax
     f72:	8b 10                	mov    (%eax),%edx
     f74:	8b 45 08             	mov    0x8(%ebp),%eax
     f77:	8b 40 08             	mov    0x8(%eax),%eax
     f7a:	89 54 24 04          	mov    %edx,0x4(%esp)
     f7e:	89 04 24             	mov    %eax,(%esp)
     f81:	e8 44 01 00 00       	call   10ca <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f86:	8b 45 08             	mov    0x8(%ebp),%eax
     f89:	8b 00                	mov    (%eax),%eax
     f8b:	89 04 24             	mov    %eax,(%esp)
     f8e:	e8 94 f6 ff ff       	call   627 <kthread_mutex_unlock>

	return 1;
     f93:	b8 01 00 00 00       	mov    $0x1,%eax

}
     f98:	c9                   	leave  
     f99:	c3                   	ret    

00000f9a <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     f9a:	55                   	push   %ebp
     f9b:	89 e5                	mov    %esp,%ebp
     f9d:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     fa0:	8b 45 08             	mov    0x8(%ebp),%eax
     fa3:	8b 40 10             	mov    0x10(%eax),%eax
     fa6:	85 c0                	test   %eax,%eax
     fa8:	75 07                	jne    fb1 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     faa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     faf:	eb 35                	jmp    fe6 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     fb1:	8b 45 08             	mov    0x8(%ebp),%eax
     fb4:	8b 00                	mov    (%eax),%eax
     fb6:	89 04 24             	mov    %eax,(%esp)
     fb9:	e8 61 f6 ff ff       	call   61f <kthread_mutex_lock>
     fbe:	83 f8 ff             	cmp    $0xffffffff,%eax
     fc1:	7d 07                	jge    fca <hoare_slots_monitor_stopadding+0x30>
			return -1;
     fc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fc8:	eb 1c                	jmp    fe6 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     fca:	8b 45 08             	mov    0x8(%ebp),%eax
     fcd:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     fd4:	8b 45 08             	mov    0x8(%ebp),%eax
     fd7:	8b 00                	mov    (%eax),%eax
     fd9:	89 04 24             	mov    %eax,(%esp)
     fdc:	e8 46 f6 ff ff       	call   627 <kthread_mutex_unlock>

		return 0;
     fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
     fe6:	c9                   	leave  
     fe7:	c3                   	ret    

00000fe8 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     fe8:	55                   	push   %ebp
     fe9:	89 e5                	mov    %esp,%ebp
     feb:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     fee:	e8 1c f6 ff ff       	call   60f <kthread_mutex_alloc>
     ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ffa:	79 07                	jns    1003 <hoare_cond_alloc+0x1b>
		return 0;
     ffc:	b8 00 00 00 00       	mov    $0x0,%eax
    1001:	eb 24                	jmp    1027 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    1003:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    100a:	e8 f4 f9 ff ff       	call   a03 <malloc>
    100f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    1012:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1015:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1018:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    101a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    101d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1024:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1027:	c9                   	leave  
    1028:	c3                   	ret    

00001029 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    1029:	55                   	push   %ebp
    102a:	89 e5                	mov    %esp,%ebp
    102c:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    102f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1033:	75 07                	jne    103c <hoare_cond_dealloc+0x13>
			return -1;
    1035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    103a:	eb 35                	jmp    1071 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    103c:	8b 45 08             	mov    0x8(%ebp),%eax
    103f:	8b 00                	mov    (%eax),%eax
    1041:	89 04 24             	mov    %eax,(%esp)
    1044:	e8 de f5 ff ff       	call   627 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    1049:	8b 45 08             	mov    0x8(%ebp),%eax
    104c:	8b 00                	mov    (%eax),%eax
    104e:	89 04 24             	mov    %eax,(%esp)
    1051:	e8 c1 f5 ff ff       	call   617 <kthread_mutex_dealloc>
    1056:	85 c0                	test   %eax,%eax
    1058:	79 07                	jns    1061 <hoare_cond_dealloc+0x38>
			return -1;
    105a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    105f:	eb 10                	jmp    1071 <hoare_cond_dealloc+0x48>

		free (hCond);
    1061:	8b 45 08             	mov    0x8(%ebp),%eax
    1064:	89 04 24             	mov    %eax,(%esp)
    1067:	e8 5e f8 ff ff       	call   8ca <free>
		return 0;
    106c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1071:	c9                   	leave  
    1072:	c3                   	ret    

00001073 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    1073:	55                   	push   %ebp
    1074:	89 e5                	mov    %esp,%ebp
    1076:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    1079:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    107d:	75 07                	jne    1086 <hoare_cond_wait+0x13>
			return -1;
    107f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1084:	eb 42                	jmp    10c8 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    1086:	8b 45 08             	mov    0x8(%ebp),%eax
    1089:	8b 40 04             	mov    0x4(%eax),%eax
    108c:	8d 50 01             	lea    0x1(%eax),%edx
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    1095:	8b 45 08             	mov    0x8(%ebp),%eax
    1098:	8b 00                	mov    (%eax),%eax
    109a:	89 44 24 04          	mov    %eax,0x4(%esp)
    109e:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a1:	89 04 24             	mov    %eax,(%esp)
    10a4:	e8 86 f5 ff ff       	call   62f <kthread_mutex_yieldlock>
    10a9:	85 c0                	test   %eax,%eax
    10ab:	79 16                	jns    10c3 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
    10b0:	8b 40 04             	mov    0x4(%eax),%eax
    10b3:	8d 50 ff             	lea    -0x1(%eax),%edx
    10b6:	8b 45 08             	mov    0x8(%ebp),%eax
    10b9:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    10bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10c1:	eb 05                	jmp    10c8 <hoare_cond_wait+0x55>
		}

	return 0;
    10c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10c8:	c9                   	leave  
    10c9:	c3                   	ret    

000010ca <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    10ca:	55                   	push   %ebp
    10cb:	89 e5                	mov    %esp,%ebp
    10cd:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10d4:	75 07                	jne    10dd <hoare_cond_signal+0x13>
		return -1;
    10d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10db:	eb 6b                	jmp    1148 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    10dd:	8b 45 08             	mov    0x8(%ebp),%eax
    10e0:	8b 40 04             	mov    0x4(%eax),%eax
    10e3:	85 c0                	test   %eax,%eax
    10e5:	7e 3d                	jle    1124 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    10e7:	8b 45 08             	mov    0x8(%ebp),%eax
    10ea:	8b 40 04             	mov    0x4(%eax),%eax
    10ed:	8d 50 ff             	lea    -0x1(%eax),%edx
    10f0:	8b 45 08             	mov    0x8(%ebp),%eax
    10f3:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    10f6:	8b 45 08             	mov    0x8(%ebp),%eax
    10f9:	8b 00                	mov    (%eax),%eax
    10fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ff:	8b 45 0c             	mov    0xc(%ebp),%eax
    1102:	89 04 24             	mov    %eax,(%esp)
    1105:	e8 25 f5 ff ff       	call   62f <kthread_mutex_yieldlock>
    110a:	85 c0                	test   %eax,%eax
    110c:	79 16                	jns    1124 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    110e:	8b 45 08             	mov    0x8(%ebp),%eax
    1111:	8b 40 04             	mov    0x4(%eax),%eax
    1114:	8d 50 01             	lea    0x1(%eax),%edx
    1117:	8b 45 08             	mov    0x8(%ebp),%eax
    111a:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    111d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1122:	eb 24                	jmp    1148 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	8b 00                	mov    (%eax),%eax
    1129:	89 44 24 04          	mov    %eax,0x4(%esp)
    112d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1130:	89 04 24             	mov    %eax,(%esp)
    1133:	e8 f7 f4 ff ff       	call   62f <kthread_mutex_yieldlock>
    1138:	85 c0                	test   %eax,%eax
    113a:	79 07                	jns    1143 <hoare_cond_signal+0x79>

    			return -1;
    113c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1141:	eb 05                	jmp    1148 <hoare_cond_signal+0x7e>
    }

	return 0;
    1143:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1148:	c9                   	leave  
    1149:	c3                   	ret    

0000114a <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1150:	e8 ba f4 ff ff       	call   60f <kthread_mutex_alloc>
    1155:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    115c:	79 07                	jns    1165 <mesa_cond_alloc+0x1b>
		return 0;
    115e:	b8 00 00 00 00       	mov    $0x0,%eax
    1163:	eb 24                	jmp    1189 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    116c:	e8 92 f8 ff ff       	call   a03 <malloc>
    1171:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1174:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1177:	8b 55 f4             	mov    -0xc(%ebp),%edx
    117a:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    117c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    117f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1186:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1189:	c9                   	leave  
    118a:	c3                   	ret    

0000118b <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    118b:	55                   	push   %ebp
    118c:	89 e5                	mov    %esp,%ebp
    118e:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    1191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1195:	75 07                	jne    119e <mesa_cond_dealloc+0x13>
		return -1;
    1197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    119c:	eb 35                	jmp    11d3 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    119e:	8b 45 08             	mov    0x8(%ebp),%eax
    11a1:	8b 00                	mov    (%eax),%eax
    11a3:	89 04 24             	mov    %eax,(%esp)
    11a6:	e8 7c f4 ff ff       	call   627 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    11ab:	8b 45 08             	mov    0x8(%ebp),%eax
    11ae:	8b 00                	mov    (%eax),%eax
    11b0:	89 04 24             	mov    %eax,(%esp)
    11b3:	e8 5f f4 ff ff       	call   617 <kthread_mutex_dealloc>
    11b8:	85 c0                	test   %eax,%eax
    11ba:	79 07                	jns    11c3 <mesa_cond_dealloc+0x38>
		return -1;
    11bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c1:	eb 10                	jmp    11d3 <mesa_cond_dealloc+0x48>

	free (mCond);
    11c3:	8b 45 08             	mov    0x8(%ebp),%eax
    11c6:	89 04 24             	mov    %eax,(%esp)
    11c9:	e8 fc f6 ff ff       	call   8ca <free>
	return 0;
    11ce:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11d3:	c9                   	leave  
    11d4:	c3                   	ret    

000011d5 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    11d5:	55                   	push   %ebp
    11d6:	89 e5                	mov    %esp,%ebp
    11d8:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    11db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    11df:	75 07                	jne    11e8 <mesa_cond_wait+0x13>
		return -1;
    11e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11e6:	eb 55                	jmp    123d <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    11e8:	8b 45 08             	mov    0x8(%ebp),%eax
    11eb:	8b 40 04             	mov    0x4(%eax),%eax
    11ee:	8d 50 01             	lea    0x1(%eax),%edx
    11f1:	8b 45 08             	mov    0x8(%ebp),%eax
    11f4:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    11f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fa:	89 04 24             	mov    %eax,(%esp)
    11fd:	e8 25 f4 ff ff       	call   627 <kthread_mutex_unlock>
    1202:	85 c0                	test   %eax,%eax
    1204:	79 27                	jns    122d <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    1206:	8b 45 08             	mov    0x8(%ebp),%eax
    1209:	8b 00                	mov    (%eax),%eax
    120b:	89 04 24             	mov    %eax,(%esp)
    120e:	e8 0c f4 ff ff       	call   61f <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1213:	85 c0                	test   %eax,%eax
    1215:	79 16                	jns    122d <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    1217:	8b 45 08             	mov    0x8(%ebp),%eax
    121a:	8b 40 04             	mov    0x4(%eax),%eax
    121d:	8d 50 ff             	lea    -0x1(%eax),%edx
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
    1223:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    1226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    122b:	eb 10                	jmp    123d <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    122d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1230:	89 04 24             	mov    %eax,(%esp)
    1233:	e8 e7 f3 ff ff       	call   61f <kthread_mutex_lock>
	return 0;
    1238:	b8 00 00 00 00       	mov    $0x0,%eax


}
    123d:	c9                   	leave  
    123e:	c3                   	ret    

0000123f <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    123f:	55                   	push   %ebp
    1240:	89 e5                	mov    %esp,%ebp
    1242:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1249:	75 07                	jne    1252 <mesa_cond_signal+0x13>
		return -1;
    124b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1250:	eb 5d                	jmp    12af <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    1252:	8b 45 08             	mov    0x8(%ebp),%eax
    1255:	8b 40 04             	mov    0x4(%eax),%eax
    1258:	85 c0                	test   %eax,%eax
    125a:	7e 36                	jle    1292 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    125c:	8b 45 08             	mov    0x8(%ebp),%eax
    125f:	8b 40 04             	mov    0x4(%eax),%eax
    1262:	8d 50 ff             	lea    -0x1(%eax),%edx
    1265:	8b 45 08             	mov    0x8(%ebp),%eax
    1268:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    126b:	8b 45 08             	mov    0x8(%ebp),%eax
    126e:	8b 00                	mov    (%eax),%eax
    1270:	89 04 24             	mov    %eax,(%esp)
    1273:	e8 af f3 ff ff       	call   627 <kthread_mutex_unlock>
    1278:	85 c0                	test   %eax,%eax
    127a:	78 16                	js     1292 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
    127f:	8b 40 04             	mov    0x4(%eax),%eax
    1282:	8d 50 01             	lea    0x1(%eax),%edx
    1285:	8b 45 08             	mov    0x8(%ebp),%eax
    1288:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    128b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1290:	eb 1d                	jmp    12af <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
    1295:	8b 00                	mov    (%eax),%eax
    1297:	89 04 24             	mov    %eax,(%esp)
    129a:	e8 88 f3 ff ff       	call   627 <kthread_mutex_unlock>
    129f:	85 c0                	test   %eax,%eax
    12a1:	79 07                	jns    12aa <mesa_cond_signal+0x6b>

		return -1;
    12a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12a8:	eb 05                	jmp    12af <mesa_cond_signal+0x70>
	}
	return 0;
    12aa:	b8 00 00 00 00       	mov    $0x0,%eax

}
    12af:	c9                   	leave  
    12b0:	c3                   	ret    
