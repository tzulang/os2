
_hoaresim:     file format elf32-i386


Disassembly of section .text:

00000000 <getSlot>:

hoare_slots_monitor_t * monitor ;
int m;
int n;

void getSlot(void){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp

	hoare_slots_monitor_takeslot (monitor);
       6:	a1 b0 18 00 00       	mov    0x18b0,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 c2 0e 00 00       	call   ed5 <hoare_slots_monitor_takeslot>
	printf (1, " student %d got a slot \n",kthread_id());
      13:	e8 bc 05 00 00       	call   5d4 <kthread_id>
      18:	89 44 24 08          	mov    %eax,0x8(%esp)
      1c:	c7 44 24 04 90 12 00 	movl   $0x1290,0x4(%esp)
      23:	00 
      24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      2b:	e8 c4 06 00 00       	call   6f4 <printf>
	kthread_exit();
      30:	e8 a7 05 00 00       	call   5dc <kthread_exit>
}
      35:	c9                   	leave  
      36:	c3                   	ret    

00000037 <addSlot>:

void addSlot(void){
      37:	55                   	push   %ebp
      38:	89 e5                	mov    %esp,%ebp
      3a:	83 ec 18             	sub    $0x18,%esp

	while (monitor->active){
      3d:	eb 17                	jmp    56 <addSlot+0x1f>
		hoare_slots_monitor_addslots(monitor, n);
      3f:	8b 15 a8 18 00 00    	mov    0x18a8,%edx
      45:	a1 b0 18 00 00       	mov    0x18b0,%eax
      4a:	89 54 24 04          	mov    %edx,0x4(%esp)
      4e:	89 04 24             	mov    %eax,(%esp)
      51:	e8 db 0d 00 00       	call   e31 <hoare_slots_monitor_addslots>
	kthread_exit();
}

void addSlot(void){

	while (monitor->active){
      56:	a1 b0 18 00 00       	mov    0x18b0,%eax
      5b:	8b 40 10             	mov    0x10(%eax),%eax
      5e:	85 c0                	test   %eax,%eax
      60:	75 dd                	jne    3f <addSlot+0x8>
		hoare_slots_monitor_addslots(monitor, n);
	}
	printf (1, " grader stopped producing slots \n",kthread_id());
      62:	e8 6d 05 00 00       	call   5d4 <kthread_id>
      67:	89 44 24 08          	mov    %eax,0x8(%esp)
      6b:	c7 44 24 04 ac 12 00 	movl   $0x12ac,0x4(%esp)
      72:	00 
      73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      7a:	e8 75 06 00 00       	call   6f4 <printf>
	kthread_exit();
      7f:	e8 58 05 00 00       	call   5dc <kthread_exit>
}
      84:	c9                   	leave  
      85:	c3                   	ret    

00000086 <main>:

int  main (int argc, char* argv[]){
      86:	8d 4c 24 04          	lea    0x4(%esp),%ecx
      8a:	83 e4 f0             	and    $0xfffffff0,%esp
      8d:	ff 71 fc             	pushl  -0x4(%ecx)
      90:	55                   	push   %ebp
      91:	89 e5                	mov    %esp,%ebp
      93:	57                   	push   %edi
      94:	56                   	push   %esi
      95:	53                   	push   %ebx
      96:	51                   	push   %ecx
      97:	83 ec 38             	sub    $0x38,%esp
      9a:	89 cb                	mov    %ecx,%ebx



	if (argc <3){
      9c:	83 3b 02             	cmpl   $0x2,(%ebx)
      9f:	7f 19                	jg     ba <main+0x34>
		 printf (1, "Not enough arguments to run simulation\n");
      a1:	c7 44 24 04 d0 12 00 	movl   $0x12d0,0x4(%esp)
      a8:	00 
      a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b0:	e8 3f 06 00 00       	call   6f4 <printf>
		 exit();
      b5:	e8 72 04 00 00       	call   52c <exit>
	}

	m= atoi(argv[1]);
      ba:	8b 43 04             	mov    0x4(%ebx),%eax
      bd:	83 c0 04             	add    $0x4,%eax
      c0:	8b 00                	mov    (%eax),%eax
      c2:	89 04 24             	mov    %eax,(%esp)
      c5:	e8 d0 03 00 00       	call   49a <atoi>
      ca:	a3 ac 18 00 00       	mov    %eax,0x18ac
	n= atoi(argv[2]);
      cf:	8b 43 04             	mov    0x4(%ebx),%eax
      d2:	83 c0 08             	add    $0x8,%eax
      d5:	8b 00                	mov    (%eax),%eax
      d7:	89 04 24             	mov    %eax,(%esp)
      da:	e8 bb 03 00 00       	call   49a <atoi>
      df:	a3 a8 18 00 00       	mov    %eax,0x18a8

	if (n==0 ||m==0){
      e4:	a1 a8 18 00 00       	mov    0x18a8,%eax
      e9:	85 c0                	test   %eax,%eax
      eb:	74 09                	je     f6 <main+0x70>
      ed:	a1 ac 18 00 00       	mov    0x18ac,%eax
      f2:	85 c0                	test   %eax,%eax
      f4:	75 19                	jne    10f <main+0x89>
		 printf (1, "Error reading arguments. Insert numbers greater then 0 to run simulation\n");
      f6:	c7 44 24 04 f8 12 00 	movl   $0x12f8,0x4(%esp)
      fd:	00 
      fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     105:	e8 ea 05 00 00       	call   6f4 <printf>
		 exit();
     10a:	e8 1d 04 00 00       	call   52c <exit>
	}

	monitor = hoare_slots_monitor_alloc();
     10f:	e8 26 0c 00 00       	call   d3a <hoare_slots_monitor_alloc>
     114:	a3 b0 18 00 00       	mov    %eax,0x18b0

	if (monitor==0){
     119:	a1 b0 18 00 00       	mov    0x18b0,%eax
     11e:	85 c0                	test   %eax,%eax
     120:	75 19                	jne    13b <main+0xb5>
		 printf (1, "Error creating monitor \n");
     122:	c7 44 24 04 42 13 00 	movl   $0x1342,0x4(%esp)
     129:	00 
     12a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     131:	e8 be 05 00 00       	call   6f4 <printf>
		 exit();
     136:	e8 f1 03 00 00       	call   52c <exit>
	}

	int studentsThread[m];
     13b:	a1 ac 18 00 00       	mov    0x18ac,%eax
     140:	8d 50 ff             	lea    -0x1(%eax),%edx
     143:	89 55 e0             	mov    %edx,-0x20(%ebp)
     146:	c1 e0 02             	shl    $0x2,%eax
     149:	8d 50 03             	lea    0x3(%eax),%edx
     14c:	b8 10 00 00 00       	mov    $0x10,%eax
     151:	83 e8 01             	sub    $0x1,%eax
     154:	01 d0                	add    %edx,%eax
     156:	be 10 00 00 00       	mov    $0x10,%esi
     15b:	ba 00 00 00 00       	mov    $0x0,%edx
     160:	f7 f6                	div    %esi
     162:	6b c0 10             	imul   $0x10,%eax,%eax
     165:	29 c4                	sub    %eax,%esp
     167:	8d 44 24 0c          	lea    0xc(%esp),%eax
     16b:	83 c0 03             	add    $0x3,%eax
     16e:	c1 e8 02             	shr    $0x2,%eax
     171:	c1 e0 02             	shl    $0x2,%eax
     174:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char* stacks[m];
     177:	a1 ac 18 00 00       	mov    0x18ac,%eax
     17c:	8d 50 ff             	lea    -0x1(%eax),%edx
     17f:	89 55 d8             	mov    %edx,-0x28(%ebp)
     182:	c1 e0 02             	shl    $0x2,%eax
     185:	8d 50 03             	lea    0x3(%eax),%edx
     188:	b8 10 00 00 00       	mov    $0x10,%eax
     18d:	83 e8 01             	sub    $0x1,%eax
     190:	01 d0                	add    %edx,%eax
     192:	bf 10 00 00 00       	mov    $0x10,%edi
     197:	ba 00 00 00 00       	mov    $0x0,%edx
     19c:	f7 f7                	div    %edi
     19e:	6b c0 10             	imul   $0x10,%eax,%eax
     1a1:	29 c4                	sub    %eax,%esp
     1a3:	8d 44 24 0c          	lea    0xc(%esp),%eax
     1a7:	83 c0 03             	add    $0x3,%eax
     1aa:	c1 e8 02             	shr    $0x2,%eax
     1ad:	c1 e0 02             	shl    $0x2,%eax
     1b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int graderThread;



	int index=0;
     1b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     1ba:	eb 69                	jmp    225 <main+0x19f>

		stacks[index]= malloc (MAXSTACKSIZE);
     1bc:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
     1c3:	e8 18 08 00 00       	call   9e0 <malloc>
     1c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     1cb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     1ce:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
		if ( (studentsThread[index] =kthread_create(getSlot, stacks[index], MAXSTACKSIZE) )< 0){
     1d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     1d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     1d7:	8b 04 90             	mov    (%eax,%edx,4),%eax
     1da:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     1e1:	00 
     1e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     1e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1ed:	e8 da 03 00 00       	call   5cc <kthread_create>
     1f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
     1f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     1f8:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     1fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     201:	8b 04 90             	mov    (%eax,%edx,4),%eax
     204:	85 c0                	test   %eax,%eax
     206:	79 19                	jns    221 <main+0x19b>
			printf(1, "Error Allocating threads for students");
     208:	c7 44 24 04 5c 13 00 	movl   $0x135c,0x4(%esp)
     20f:	00 
     210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     217:	e8 d8 04 00 00       	call   6f4 <printf>
			exit();
     21c:	e8 0b 03 00 00       	call   52c <exit>
		}
		index++;
     221:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	int graderThread;



	int index=0;
	while (index <m){
     225:	a1 ac 18 00 00       	mov    0x18ac,%eax
     22a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     22d:	7c 8d                	jl     1bc <main+0x136>
		}
		index++;

	}

	if ( (graderThread=kthread_create(addSlot, stacks[index], MAXSTACKSIZE))< 0){
     22f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     235:	8b 04 90             	mov    (%eax,%edx,4),%eax
     238:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     23f:	00 
     240:	89 44 24 04          	mov    %eax,0x4(%esp)
     244:	c7 04 24 37 00 00 00 	movl   $0x37,(%esp)
     24b:	e8 7c 03 00 00       	call   5cc <kthread_create>
     250:	89 45 d0             	mov    %eax,-0x30(%ebp)
     253:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     257:	79 19                	jns    272 <main+0x1ec>
				printf(1, "Error Allocating threads for grader");
     259:	c7 44 24 04 84 13 00 	movl   $0x1384,0x4(%esp)
     260:	00 
     261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     268:	e8 87 04 00 00       	call   6f4 <printf>
				exit();
     26d:	e8 ba 02 00 00       	call   52c <exit>
	}


	index=0;
     272:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     279:	eb 22                	jmp    29d <main+0x217>

		kthread_join( studentsThread[index]);
     27b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     27e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     281:	8b 04 90             	mov    (%eax,%edx,4),%eax
     284:	89 04 24             	mov    %eax,(%esp)
     287:	e8 58 03 00 00       	call   5e4 <kthread_join>
		free(stacks[index]);
     28c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     28f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     292:	8b 04 90             	mov    (%eax,%edx,4),%eax
     295:	89 04 24             	mov    %eax,(%esp)
     298:	e8 0a 06 00 00       	call   8a7 <free>
				exit();
	}


	index=0;
	while (index <m){
     29d:	a1 ac 18 00 00       	mov    0x18ac,%eax
     2a2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     2a5:	7c d4                	jl     27b <main+0x1f5>

		kthread_join( studentsThread[index]);
		free(stacks[index]);
	}

	hoare_slots_monitor_stopadding(monitor);
     2a7:	a1 b0 18 00 00       	mov    0x18b0,%eax
     2ac:	89 04 24             	mov    %eax,(%esp)
     2af:	e8 c3 0c 00 00       	call   f77 <hoare_slots_monitor_stopadding>

	kthread_join( graderThread);
     2b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2b7:	89 04 24             	mov    %eax,(%esp)
     2ba:	e8 25 03 00 00       	call   5e4 <kthread_join>

	exit();
     2bf:	e8 68 02 00 00       	call   52c <exit>

000002c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     2c4:	55                   	push   %ebp
     2c5:	89 e5                	mov    %esp,%ebp
     2c7:	57                   	push   %edi
     2c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     2c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     2cc:	8b 55 10             	mov    0x10(%ebp),%edx
     2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
     2d2:	89 cb                	mov    %ecx,%ebx
     2d4:	89 df                	mov    %ebx,%edi
     2d6:	89 d1                	mov    %edx,%ecx
     2d8:	fc                   	cld    
     2d9:	f3 aa                	rep stos %al,%es:(%edi)
     2db:	89 ca                	mov    %ecx,%edx
     2dd:	89 fb                	mov    %edi,%ebx
     2df:	89 5d 08             	mov    %ebx,0x8(%ebp)
     2e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     2e5:	5b                   	pop    %ebx
     2e6:	5f                   	pop    %edi
     2e7:	5d                   	pop    %ebp
     2e8:	c3                   	ret    

000002e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     2e9:	55                   	push   %ebp
     2ea:	89 e5                	mov    %esp,%ebp
     2ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     2ef:	8b 45 08             	mov    0x8(%ebp),%eax
     2f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     2f5:	90                   	nop
     2f6:	8b 45 08             	mov    0x8(%ebp),%eax
     2f9:	8d 50 01             	lea    0x1(%eax),%edx
     2fc:	89 55 08             	mov    %edx,0x8(%ebp)
     2ff:	8b 55 0c             	mov    0xc(%ebp),%edx
     302:	8d 4a 01             	lea    0x1(%edx),%ecx
     305:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     308:	0f b6 12             	movzbl (%edx),%edx
     30b:	88 10                	mov    %dl,(%eax)
     30d:	0f b6 00             	movzbl (%eax),%eax
     310:	84 c0                	test   %al,%al
     312:	75 e2                	jne    2f6 <strcpy+0xd>
    ;
  return os;
     314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     317:	c9                   	leave  
     318:	c3                   	ret    

00000319 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     319:	55                   	push   %ebp
     31a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     31c:	eb 08                	jmp    326 <strcmp+0xd>
    p++, q++;
     31e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     322:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     326:	8b 45 08             	mov    0x8(%ebp),%eax
     329:	0f b6 00             	movzbl (%eax),%eax
     32c:	84 c0                	test   %al,%al
     32e:	74 10                	je     340 <strcmp+0x27>
     330:	8b 45 08             	mov    0x8(%ebp),%eax
     333:	0f b6 10             	movzbl (%eax),%edx
     336:	8b 45 0c             	mov    0xc(%ebp),%eax
     339:	0f b6 00             	movzbl (%eax),%eax
     33c:	38 c2                	cmp    %al,%dl
     33e:	74 de                	je     31e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     340:	8b 45 08             	mov    0x8(%ebp),%eax
     343:	0f b6 00             	movzbl (%eax),%eax
     346:	0f b6 d0             	movzbl %al,%edx
     349:	8b 45 0c             	mov    0xc(%ebp),%eax
     34c:	0f b6 00             	movzbl (%eax),%eax
     34f:	0f b6 c0             	movzbl %al,%eax
     352:	29 c2                	sub    %eax,%edx
     354:	89 d0                	mov    %edx,%eax
}
     356:	5d                   	pop    %ebp
     357:	c3                   	ret    

00000358 <strlen>:

uint
strlen(char *s)
{
     358:	55                   	push   %ebp
     359:	89 e5                	mov    %esp,%ebp
     35b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     35e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     365:	eb 04                	jmp    36b <strlen+0x13>
     367:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     36b:	8b 55 fc             	mov    -0x4(%ebp),%edx
     36e:	8b 45 08             	mov    0x8(%ebp),%eax
     371:	01 d0                	add    %edx,%eax
     373:	0f b6 00             	movzbl (%eax),%eax
     376:	84 c0                	test   %al,%al
     378:	75 ed                	jne    367 <strlen+0xf>
    ;
  return n;
     37a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     37d:	c9                   	leave  
     37e:	c3                   	ret    

0000037f <memset>:

void*
memset(void *dst, int c, uint n)
{
     37f:	55                   	push   %ebp
     380:	89 e5                	mov    %esp,%ebp
     382:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     385:	8b 45 10             	mov    0x10(%ebp),%eax
     388:	89 44 24 08          	mov    %eax,0x8(%esp)
     38c:	8b 45 0c             	mov    0xc(%ebp),%eax
     38f:	89 44 24 04          	mov    %eax,0x4(%esp)
     393:	8b 45 08             	mov    0x8(%ebp),%eax
     396:	89 04 24             	mov    %eax,(%esp)
     399:	e8 26 ff ff ff       	call   2c4 <stosb>
  return dst;
     39e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3a1:	c9                   	leave  
     3a2:	c3                   	ret    

000003a3 <strchr>:

char*
strchr(const char *s, char c)
{
     3a3:	55                   	push   %ebp
     3a4:	89 e5                	mov    %esp,%ebp
     3a6:	83 ec 04             	sub    $0x4,%esp
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     3af:	eb 14                	jmp    3c5 <strchr+0x22>
    if(*s == c)
     3b1:	8b 45 08             	mov    0x8(%ebp),%eax
     3b4:	0f b6 00             	movzbl (%eax),%eax
     3b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
     3ba:	75 05                	jne    3c1 <strchr+0x1e>
      return (char*)s;
     3bc:	8b 45 08             	mov    0x8(%ebp),%eax
     3bf:	eb 13                	jmp    3d4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     3c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3c5:	8b 45 08             	mov    0x8(%ebp),%eax
     3c8:	0f b6 00             	movzbl (%eax),%eax
     3cb:	84 c0                	test   %al,%al
     3cd:	75 e2                	jne    3b1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     3cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3d4:	c9                   	leave  
     3d5:	c3                   	ret    

000003d6 <gets>:

char*
gets(char *buf, int max)
{
     3d6:	55                   	push   %ebp
     3d7:	89 e5                	mov    %esp,%ebp
     3d9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     3dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3e3:	eb 4c                	jmp    431 <gets+0x5b>
    cc = read(0, &c, 1);
     3e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3ec:	00 
     3ed:	8d 45 ef             	lea    -0x11(%ebp),%eax
     3f0:	89 44 24 04          	mov    %eax,0x4(%esp)
     3f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3fb:	e8 44 01 00 00       	call   544 <read>
     400:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     403:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     407:	7f 02                	jg     40b <gets+0x35>
      break;
     409:	eb 31                	jmp    43c <gets+0x66>
    buf[i++] = c;
     40b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40e:	8d 50 01             	lea    0x1(%eax),%edx
     411:	89 55 f4             	mov    %edx,-0xc(%ebp)
     414:	89 c2                	mov    %eax,%edx
     416:	8b 45 08             	mov    0x8(%ebp),%eax
     419:	01 c2                	add    %eax,%edx
     41b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     41f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     421:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     425:	3c 0a                	cmp    $0xa,%al
     427:	74 13                	je     43c <gets+0x66>
     429:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     42d:	3c 0d                	cmp    $0xd,%al
     42f:	74 0b                	je     43c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     431:	8b 45 f4             	mov    -0xc(%ebp),%eax
     434:	83 c0 01             	add    $0x1,%eax
     437:	3b 45 0c             	cmp    0xc(%ebp),%eax
     43a:	7c a9                	jl     3e5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     43c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     43f:	8b 45 08             	mov    0x8(%ebp),%eax
     442:	01 d0                	add    %edx,%eax
     444:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     447:	8b 45 08             	mov    0x8(%ebp),%eax
}
     44a:	c9                   	leave  
     44b:	c3                   	ret    

0000044c <stat>:

int
stat(char *n, struct stat *st)
{
     44c:	55                   	push   %ebp
     44d:	89 e5                	mov    %esp,%ebp
     44f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     452:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     459:	00 
     45a:	8b 45 08             	mov    0x8(%ebp),%eax
     45d:	89 04 24             	mov    %eax,(%esp)
     460:	e8 07 01 00 00       	call   56c <open>
     465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     46c:	79 07                	jns    475 <stat+0x29>
    return -1;
     46e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     473:	eb 23                	jmp    498 <stat+0x4c>
  r = fstat(fd, st);
     475:	8b 45 0c             	mov    0xc(%ebp),%eax
     478:	89 44 24 04          	mov    %eax,0x4(%esp)
     47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47f:	89 04 24             	mov    %eax,(%esp)
     482:	e8 fd 00 00 00       	call   584 <fstat>
     487:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     48a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 bf 00 00 00       	call   554 <close>
  return r;
     495:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     498:	c9                   	leave  
     499:	c3                   	ret    

0000049a <atoi>:

int
atoi(const char *s)
{
     49a:	55                   	push   %ebp
     49b:	89 e5                	mov    %esp,%ebp
     49d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     4a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     4a7:	eb 25                	jmp    4ce <atoi+0x34>
    n = n*10 + *s++ - '0';
     4a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     4ac:	89 d0                	mov    %edx,%eax
     4ae:	c1 e0 02             	shl    $0x2,%eax
     4b1:	01 d0                	add    %edx,%eax
     4b3:	01 c0                	add    %eax,%eax
     4b5:	89 c1                	mov    %eax,%ecx
     4b7:	8b 45 08             	mov    0x8(%ebp),%eax
     4ba:	8d 50 01             	lea    0x1(%eax),%edx
     4bd:	89 55 08             	mov    %edx,0x8(%ebp)
     4c0:	0f b6 00             	movzbl (%eax),%eax
     4c3:	0f be c0             	movsbl %al,%eax
     4c6:	01 c8                	add    %ecx,%eax
     4c8:	83 e8 30             	sub    $0x30,%eax
     4cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     4ce:	8b 45 08             	mov    0x8(%ebp),%eax
     4d1:	0f b6 00             	movzbl (%eax),%eax
     4d4:	3c 2f                	cmp    $0x2f,%al
     4d6:	7e 0a                	jle    4e2 <atoi+0x48>
     4d8:	8b 45 08             	mov    0x8(%ebp),%eax
     4db:	0f b6 00             	movzbl (%eax),%eax
     4de:	3c 39                	cmp    $0x39,%al
     4e0:	7e c7                	jle    4a9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     4e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     4e5:	c9                   	leave  
     4e6:	c3                   	ret    

000004e7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     4e7:	55                   	push   %ebp
     4e8:	89 e5                	mov    %esp,%ebp
     4ea:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     4ed:	8b 45 08             	mov    0x8(%ebp),%eax
     4f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     4f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     4f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     4f9:	eb 17                	jmp    512 <memmove+0x2b>
    *dst++ = *src++;
     4fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     4fe:	8d 50 01             	lea    0x1(%eax),%edx
     501:	89 55 fc             	mov    %edx,-0x4(%ebp)
     504:	8b 55 f8             	mov    -0x8(%ebp),%edx
     507:	8d 4a 01             	lea    0x1(%edx),%ecx
     50a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     50d:	0f b6 12             	movzbl (%edx),%edx
     510:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     512:	8b 45 10             	mov    0x10(%ebp),%eax
     515:	8d 50 ff             	lea    -0x1(%eax),%edx
     518:	89 55 10             	mov    %edx,0x10(%ebp)
     51b:	85 c0                	test   %eax,%eax
     51d:	7f dc                	jg     4fb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     51f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     522:	c9                   	leave  
     523:	c3                   	ret    

00000524 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     524:	b8 01 00 00 00       	mov    $0x1,%eax
     529:	cd 40                	int    $0x40
     52b:	c3                   	ret    

0000052c <exit>:
SYSCALL(exit)
     52c:	b8 02 00 00 00       	mov    $0x2,%eax
     531:	cd 40                	int    $0x40
     533:	c3                   	ret    

00000534 <wait>:
SYSCALL(wait)
     534:	b8 03 00 00 00       	mov    $0x3,%eax
     539:	cd 40                	int    $0x40
     53b:	c3                   	ret    

0000053c <pipe>:
SYSCALL(pipe)
     53c:	b8 04 00 00 00       	mov    $0x4,%eax
     541:	cd 40                	int    $0x40
     543:	c3                   	ret    

00000544 <read>:
SYSCALL(read)
     544:	b8 05 00 00 00       	mov    $0x5,%eax
     549:	cd 40                	int    $0x40
     54b:	c3                   	ret    

0000054c <write>:
SYSCALL(write)
     54c:	b8 10 00 00 00       	mov    $0x10,%eax
     551:	cd 40                	int    $0x40
     553:	c3                   	ret    

00000554 <close>:
SYSCALL(close)
     554:	b8 15 00 00 00       	mov    $0x15,%eax
     559:	cd 40                	int    $0x40
     55b:	c3                   	ret    

0000055c <kill>:
SYSCALL(kill)
     55c:	b8 06 00 00 00       	mov    $0x6,%eax
     561:	cd 40                	int    $0x40
     563:	c3                   	ret    

00000564 <exec>:
SYSCALL(exec)
     564:	b8 07 00 00 00       	mov    $0x7,%eax
     569:	cd 40                	int    $0x40
     56b:	c3                   	ret    

0000056c <open>:
SYSCALL(open)
     56c:	b8 0f 00 00 00       	mov    $0xf,%eax
     571:	cd 40                	int    $0x40
     573:	c3                   	ret    

00000574 <mknod>:
SYSCALL(mknod)
     574:	b8 11 00 00 00       	mov    $0x11,%eax
     579:	cd 40                	int    $0x40
     57b:	c3                   	ret    

0000057c <unlink>:
SYSCALL(unlink)
     57c:	b8 12 00 00 00       	mov    $0x12,%eax
     581:	cd 40                	int    $0x40
     583:	c3                   	ret    

00000584 <fstat>:
SYSCALL(fstat)
     584:	b8 08 00 00 00       	mov    $0x8,%eax
     589:	cd 40                	int    $0x40
     58b:	c3                   	ret    

0000058c <link>:
SYSCALL(link)
     58c:	b8 13 00 00 00       	mov    $0x13,%eax
     591:	cd 40                	int    $0x40
     593:	c3                   	ret    

00000594 <mkdir>:
SYSCALL(mkdir)
     594:	b8 14 00 00 00       	mov    $0x14,%eax
     599:	cd 40                	int    $0x40
     59b:	c3                   	ret    

0000059c <chdir>:
SYSCALL(chdir)
     59c:	b8 09 00 00 00       	mov    $0x9,%eax
     5a1:	cd 40                	int    $0x40
     5a3:	c3                   	ret    

000005a4 <dup>:
SYSCALL(dup)
     5a4:	b8 0a 00 00 00       	mov    $0xa,%eax
     5a9:	cd 40                	int    $0x40
     5ab:	c3                   	ret    

000005ac <getpid>:
SYSCALL(getpid)
     5ac:	b8 0b 00 00 00       	mov    $0xb,%eax
     5b1:	cd 40                	int    $0x40
     5b3:	c3                   	ret    

000005b4 <sbrk>:
SYSCALL(sbrk)
     5b4:	b8 0c 00 00 00       	mov    $0xc,%eax
     5b9:	cd 40                	int    $0x40
     5bb:	c3                   	ret    

000005bc <sleep>:
SYSCALL(sleep)
     5bc:	b8 0d 00 00 00       	mov    $0xd,%eax
     5c1:	cd 40                	int    $0x40
     5c3:	c3                   	ret    

000005c4 <uptime>:
SYSCALL(uptime)
     5c4:	b8 0e 00 00 00       	mov    $0xe,%eax
     5c9:	cd 40                	int    $0x40
     5cb:	c3                   	ret    

000005cc <kthread_create>:




SYSCALL(kthread_create)
     5cc:	b8 16 00 00 00       	mov    $0x16,%eax
     5d1:	cd 40                	int    $0x40
     5d3:	c3                   	ret    

000005d4 <kthread_id>:
SYSCALL(kthread_id)
     5d4:	b8 17 00 00 00       	mov    $0x17,%eax
     5d9:	cd 40                	int    $0x40
     5db:	c3                   	ret    

000005dc <kthread_exit>:
SYSCALL(kthread_exit)
     5dc:	b8 18 00 00 00       	mov    $0x18,%eax
     5e1:	cd 40                	int    $0x40
     5e3:	c3                   	ret    

000005e4 <kthread_join>:
SYSCALL(kthread_join)
     5e4:	b8 19 00 00 00       	mov    $0x19,%eax
     5e9:	cd 40                	int    $0x40
     5eb:	c3                   	ret    

000005ec <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     5ec:	b8 1a 00 00 00       	mov    $0x1a,%eax
     5f1:	cd 40                	int    $0x40
     5f3:	c3                   	ret    

000005f4 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     5f4:	b8 1b 00 00 00       	mov    $0x1b,%eax
     5f9:	cd 40                	int    $0x40
     5fb:	c3                   	ret    

000005fc <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     5fc:	b8 1c 00 00 00       	mov    $0x1c,%eax
     601:	cd 40                	int    $0x40
     603:	c3                   	ret    

00000604 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     604:	b8 1d 00 00 00       	mov    $0x1d,%eax
     609:	cd 40                	int    $0x40
     60b:	c3                   	ret    

0000060c <kthread_mutex_yieldlock>:
     60c:	b8 1e 00 00 00       	mov    $0x1e,%eax
     611:	cd 40                	int    $0x40
     613:	c3                   	ret    

00000614 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     614:	55                   	push   %ebp
     615:	89 e5                	mov    %esp,%ebp
     617:	83 ec 18             	sub    $0x18,%esp
     61a:	8b 45 0c             	mov    0xc(%ebp),%eax
     61d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     620:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     627:	00 
     628:	8d 45 f4             	lea    -0xc(%ebp),%eax
     62b:	89 44 24 04          	mov    %eax,0x4(%esp)
     62f:	8b 45 08             	mov    0x8(%ebp),%eax
     632:	89 04 24             	mov    %eax,(%esp)
     635:	e8 12 ff ff ff       	call   54c <write>
}
     63a:	c9                   	leave  
     63b:	c3                   	ret    

0000063c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     63c:	55                   	push   %ebp
     63d:	89 e5                	mov    %esp,%ebp
     63f:	56                   	push   %esi
     640:	53                   	push   %ebx
     641:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     644:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     64b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     64f:	74 17                	je     668 <printint+0x2c>
     651:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     655:	79 11                	jns    668 <printint+0x2c>
    neg = 1;
     657:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     65e:	8b 45 0c             	mov    0xc(%ebp),%eax
     661:	f7 d8                	neg    %eax
     663:	89 45 ec             	mov    %eax,-0x14(%ebp)
     666:	eb 06                	jmp    66e <printint+0x32>
  } else {
    x = xx;
     668:	8b 45 0c             	mov    0xc(%ebp),%eax
     66b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     66e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     675:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     678:	8d 41 01             	lea    0x1(%ecx),%eax
     67b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     67e:	8b 5d 10             	mov    0x10(%ebp),%ebx
     681:	8b 45 ec             	mov    -0x14(%ebp),%eax
     684:	ba 00 00 00 00       	mov    $0x0,%edx
     689:	f7 f3                	div    %ebx
     68b:	89 d0                	mov    %edx,%eax
     68d:	0f b6 80 88 18 00 00 	movzbl 0x1888(%eax),%eax
     694:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     698:	8b 75 10             	mov    0x10(%ebp),%esi
     69b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     69e:	ba 00 00 00 00       	mov    $0x0,%edx
     6a3:	f7 f6                	div    %esi
     6a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6ac:	75 c7                	jne    675 <printint+0x39>
  if(neg)
     6ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6b2:	74 10                	je     6c4 <printint+0x88>
    buf[i++] = '-';
     6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b7:	8d 50 01             	lea    0x1(%eax),%edx
     6ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
     6bd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     6c2:	eb 1f                	jmp    6e3 <printint+0xa7>
     6c4:	eb 1d                	jmp    6e3 <printint+0xa7>
    putc(fd, buf[i]);
     6c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
     6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cc:	01 d0                	add    %edx,%eax
     6ce:	0f b6 00             	movzbl (%eax),%eax
     6d1:	0f be c0             	movsbl %al,%eax
     6d4:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d8:	8b 45 08             	mov    0x8(%ebp),%eax
     6db:	89 04 24             	mov    %eax,(%esp)
     6de:	e8 31 ff ff ff       	call   614 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     6e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     6e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6eb:	79 d9                	jns    6c6 <printint+0x8a>
    putc(fd, buf[i]);
}
     6ed:	83 c4 30             	add    $0x30,%esp
     6f0:	5b                   	pop    %ebx
     6f1:	5e                   	pop    %esi
     6f2:	5d                   	pop    %ebp
     6f3:	c3                   	ret    

000006f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     6f4:	55                   	push   %ebp
     6f5:	89 e5                	mov    %esp,%ebp
     6f7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     6fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     701:	8d 45 0c             	lea    0xc(%ebp),%eax
     704:	83 c0 04             	add    $0x4,%eax
     707:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     70a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     711:	e9 7c 01 00 00       	jmp    892 <printf+0x19e>
    c = fmt[i] & 0xff;
     716:	8b 55 0c             	mov    0xc(%ebp),%edx
     719:	8b 45 f0             	mov    -0x10(%ebp),%eax
     71c:	01 d0                	add    %edx,%eax
     71e:	0f b6 00             	movzbl (%eax),%eax
     721:	0f be c0             	movsbl %al,%eax
     724:	25 ff 00 00 00       	and    $0xff,%eax
     729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     72c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     730:	75 2c                	jne    75e <printf+0x6a>
      if(c == '%'){
     732:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     736:	75 0c                	jne    744 <printf+0x50>
        state = '%';
     738:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     73f:	e9 4a 01 00 00       	jmp    88e <printf+0x19a>
      } else {
        putc(fd, c);
     744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     747:	0f be c0             	movsbl %al,%eax
     74a:	89 44 24 04          	mov    %eax,0x4(%esp)
     74e:	8b 45 08             	mov    0x8(%ebp),%eax
     751:	89 04 24             	mov    %eax,(%esp)
     754:	e8 bb fe ff ff       	call   614 <putc>
     759:	e9 30 01 00 00       	jmp    88e <printf+0x19a>
      }
    } else if(state == '%'){
     75e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     762:	0f 85 26 01 00 00    	jne    88e <printf+0x19a>
      if(c == 'd'){
     768:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     76c:	75 2d                	jne    79b <printf+0xa7>
        printint(fd, *ap, 10, 1);
     76e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     771:	8b 00                	mov    (%eax),%eax
     773:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     77a:	00 
     77b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     782:	00 
     783:	89 44 24 04          	mov    %eax,0x4(%esp)
     787:	8b 45 08             	mov    0x8(%ebp),%eax
     78a:	89 04 24             	mov    %eax,(%esp)
     78d:	e8 aa fe ff ff       	call   63c <printint>
        ap++;
     792:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     796:	e9 ec 00 00 00       	jmp    887 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     79b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     79f:	74 06                	je     7a7 <printf+0xb3>
     7a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7a5:	75 2d                	jne    7d4 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     7a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7aa:	8b 00                	mov    (%eax),%eax
     7ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7b3:	00 
     7b4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     7bb:	00 
     7bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     7c0:	8b 45 08             	mov    0x8(%ebp),%eax
     7c3:	89 04 24             	mov    %eax,(%esp)
     7c6:	e8 71 fe ff ff       	call   63c <printint>
        ap++;
     7cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7cf:	e9 b3 00 00 00       	jmp    887 <printf+0x193>
      } else if(c == 's'){
     7d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     7d8:	75 45                	jne    81f <printf+0x12b>
        s = (char*)*ap;
     7da:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7dd:	8b 00                	mov    (%eax),%eax
     7df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     7e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     7ea:	75 09                	jne    7f5 <printf+0x101>
          s = "(null)";
     7ec:	c7 45 f4 a8 13 00 00 	movl   $0x13a8,-0xc(%ebp)
        while(*s != 0){
     7f3:	eb 1e                	jmp    813 <printf+0x11f>
     7f5:	eb 1c                	jmp    813 <printf+0x11f>
          putc(fd, *s);
     7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fa:	0f b6 00             	movzbl (%eax),%eax
     7fd:	0f be c0             	movsbl %al,%eax
     800:	89 44 24 04          	mov    %eax,0x4(%esp)
     804:	8b 45 08             	mov    0x8(%ebp),%eax
     807:	89 04 24             	mov    %eax,(%esp)
     80a:	e8 05 fe ff ff       	call   614 <putc>
          s++;
     80f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     813:	8b 45 f4             	mov    -0xc(%ebp),%eax
     816:	0f b6 00             	movzbl (%eax),%eax
     819:	84 c0                	test   %al,%al
     81b:	75 da                	jne    7f7 <printf+0x103>
     81d:	eb 68                	jmp    887 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     81f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     823:	75 1d                	jne    842 <printf+0x14e>
        putc(fd, *ap);
     825:	8b 45 e8             	mov    -0x18(%ebp),%eax
     828:	8b 00                	mov    (%eax),%eax
     82a:	0f be c0             	movsbl %al,%eax
     82d:	89 44 24 04          	mov    %eax,0x4(%esp)
     831:	8b 45 08             	mov    0x8(%ebp),%eax
     834:	89 04 24             	mov    %eax,(%esp)
     837:	e8 d8 fd ff ff       	call   614 <putc>
        ap++;
     83c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     840:	eb 45                	jmp    887 <printf+0x193>
      } else if(c == '%'){
     842:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     846:	75 17                	jne    85f <printf+0x16b>
        putc(fd, c);
     848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     84b:	0f be c0             	movsbl %al,%eax
     84e:	89 44 24 04          	mov    %eax,0x4(%esp)
     852:	8b 45 08             	mov    0x8(%ebp),%eax
     855:	89 04 24             	mov    %eax,(%esp)
     858:	e8 b7 fd ff ff       	call   614 <putc>
     85d:	eb 28                	jmp    887 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     85f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     866:	00 
     867:	8b 45 08             	mov    0x8(%ebp),%eax
     86a:	89 04 24             	mov    %eax,(%esp)
     86d:	e8 a2 fd ff ff       	call   614 <putc>
        putc(fd, c);
     872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     875:	0f be c0             	movsbl %al,%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 8d fd ff ff       	call   614 <putc>
      }
      state = 0;
     887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     88e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     892:	8b 55 0c             	mov    0xc(%ebp),%edx
     895:	8b 45 f0             	mov    -0x10(%ebp),%eax
     898:	01 d0                	add    %edx,%eax
     89a:	0f b6 00             	movzbl (%eax),%eax
     89d:	84 c0                	test   %al,%al
     89f:	0f 85 71 fe ff ff    	jne    716 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8a5:	c9                   	leave  
     8a6:	c3                   	ret    

000008a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8a7:	55                   	push   %ebp
     8a8:	89 e5                	mov    %esp,%ebp
     8aa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8ad:	8b 45 08             	mov    0x8(%ebp),%eax
     8b0:	83 e8 08             	sub    $0x8,%eax
     8b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8b6:	a1 a4 18 00 00       	mov    0x18a4,%eax
     8bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8be:	eb 24                	jmp    8e4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8c3:	8b 00                	mov    (%eax),%eax
     8c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8c8:	77 12                	ja     8dc <free+0x35>
     8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8d0:	77 24                	ja     8f6 <free+0x4f>
     8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8d5:	8b 00                	mov    (%eax),%eax
     8d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8da:	77 1a                	ja     8f6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8df:	8b 00                	mov    (%eax),%eax
     8e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8ea:	76 d4                	jbe    8c0 <free+0x19>
     8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8ef:	8b 00                	mov    (%eax),%eax
     8f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8f4:	76 ca                	jbe    8c0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8f9:	8b 40 04             	mov    0x4(%eax),%eax
     8fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     903:	8b 45 f8             	mov    -0x8(%ebp),%eax
     906:	01 c2                	add    %eax,%edx
     908:	8b 45 fc             	mov    -0x4(%ebp),%eax
     90b:	8b 00                	mov    (%eax),%eax
     90d:	39 c2                	cmp    %eax,%edx
     90f:	75 24                	jne    935 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     911:	8b 45 f8             	mov    -0x8(%ebp),%eax
     914:	8b 50 04             	mov    0x4(%eax),%edx
     917:	8b 45 fc             	mov    -0x4(%ebp),%eax
     91a:	8b 00                	mov    (%eax),%eax
     91c:	8b 40 04             	mov    0x4(%eax),%eax
     91f:	01 c2                	add    %eax,%edx
     921:	8b 45 f8             	mov    -0x8(%ebp),%eax
     924:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     927:	8b 45 fc             	mov    -0x4(%ebp),%eax
     92a:	8b 00                	mov    (%eax),%eax
     92c:	8b 10                	mov    (%eax),%edx
     92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     931:	89 10                	mov    %edx,(%eax)
     933:	eb 0a                	jmp    93f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     935:	8b 45 fc             	mov    -0x4(%ebp),%eax
     938:	8b 10                	mov    (%eax),%edx
     93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     93d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     942:	8b 40 04             	mov    0x4(%eax),%eax
     945:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     94f:	01 d0                	add    %edx,%eax
     951:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     954:	75 20                	jne    976 <free+0xcf>
    p->s.size += bp->s.size;
     956:	8b 45 fc             	mov    -0x4(%ebp),%eax
     959:	8b 50 04             	mov    0x4(%eax),%edx
     95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     95f:	8b 40 04             	mov    0x4(%eax),%eax
     962:	01 c2                	add    %eax,%edx
     964:	8b 45 fc             	mov    -0x4(%ebp),%eax
     967:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     96d:	8b 10                	mov    (%eax),%edx
     96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     972:	89 10                	mov    %edx,(%eax)
     974:	eb 08                	jmp    97e <free+0xd7>
  } else
    p->s.ptr = bp;
     976:	8b 45 fc             	mov    -0x4(%ebp),%eax
     979:	8b 55 f8             	mov    -0x8(%ebp),%edx
     97c:	89 10                	mov    %edx,(%eax)
  freep = p;
     97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     981:	a3 a4 18 00 00       	mov    %eax,0x18a4
}
     986:	c9                   	leave  
     987:	c3                   	ret    

00000988 <morecore>:

static Header*
morecore(uint nu)
{
     988:	55                   	push   %ebp
     989:	89 e5                	mov    %esp,%ebp
     98b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     98e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     995:	77 07                	ja     99e <morecore+0x16>
    nu = 4096;
     997:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     99e:	8b 45 08             	mov    0x8(%ebp),%eax
     9a1:	c1 e0 03             	shl    $0x3,%eax
     9a4:	89 04 24             	mov    %eax,(%esp)
     9a7:	e8 08 fc ff ff       	call   5b4 <sbrk>
     9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9af:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9b3:	75 07                	jne    9bc <morecore+0x34>
    return 0;
     9b5:	b8 00 00 00 00       	mov    $0x0,%eax
     9ba:	eb 22                	jmp    9de <morecore+0x56>
  hp = (Header*)p;
     9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     9c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c5:	8b 55 08             	mov    0x8(%ebp),%edx
     9c8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     9cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ce:	83 c0 08             	add    $0x8,%eax
     9d1:	89 04 24             	mov    %eax,(%esp)
     9d4:	e8 ce fe ff ff       	call   8a7 <free>
  return freep;
     9d9:	a1 a4 18 00 00       	mov    0x18a4,%eax
}
     9de:	c9                   	leave  
     9df:	c3                   	ret    

000009e0 <malloc>:

void*
malloc(uint nbytes)
{
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     9e6:	8b 45 08             	mov    0x8(%ebp),%eax
     9e9:	83 c0 07             	add    $0x7,%eax
     9ec:	c1 e8 03             	shr    $0x3,%eax
     9ef:	83 c0 01             	add    $0x1,%eax
     9f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     9f5:	a1 a4 18 00 00       	mov    0x18a4,%eax
     9fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
     9fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a01:	75 23                	jne    a26 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a03:	c7 45 f0 9c 18 00 00 	movl   $0x189c,-0x10(%ebp)
     a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a0d:	a3 a4 18 00 00       	mov    %eax,0x18a4
     a12:	a1 a4 18 00 00       	mov    0x18a4,%eax
     a17:	a3 9c 18 00 00       	mov    %eax,0x189c
    base.s.size = 0;
     a1c:	c7 05 a0 18 00 00 00 	movl   $0x0,0x18a0
     a23:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a29:	8b 00                	mov    (%eax),%eax
     a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a31:	8b 40 04             	mov    0x4(%eax),%eax
     a34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a37:	72 4d                	jb     a86 <malloc+0xa6>
      if(p->s.size == nunits)
     a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a3c:	8b 40 04             	mov    0x4(%eax),%eax
     a3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a42:	75 0c                	jne    a50 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a47:	8b 10                	mov    (%eax),%edx
     a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a4c:	89 10                	mov    %edx,(%eax)
     a4e:	eb 26                	jmp    a76 <malloc+0x96>
      else {
        p->s.size -= nunits;
     a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a53:	8b 40 04             	mov    0x4(%eax),%eax
     a56:	2b 45 ec             	sub    -0x14(%ebp),%eax
     a59:	89 c2                	mov    %eax,%edx
     a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a5e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a64:	8b 40 04             	mov    0x4(%eax),%eax
     a67:	c1 e0 03             	shl    $0x3,%eax
     a6a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a70:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a73:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a79:	a3 a4 18 00 00       	mov    %eax,0x18a4
      return (void*)(p + 1);
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	83 c0 08             	add    $0x8,%eax
     a84:	eb 38                	jmp    abe <malloc+0xde>
    }
    if(p == freep)
     a86:	a1 a4 18 00 00       	mov    0x18a4,%eax
     a8b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a8e:	75 1b                	jne    aab <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a93:	89 04 24             	mov    %eax,(%esp)
     a96:	e8 ed fe ff ff       	call   988 <morecore>
     a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aa2:	75 07                	jne    aab <malloc+0xcb>
        return 0;
     aa4:	b8 00 00 00 00       	mov    $0x0,%eax
     aa9:	eb 13                	jmp    abe <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab4:	8b 00                	mov    (%eax),%eax
     ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     ab9:	e9 70 ff ff ff       	jmp    a2e <malloc+0x4e>
}
     abe:	c9                   	leave  
     abf:	c3                   	ret    

00000ac0 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     ac6:	e8 21 fb ff ff       	call   5ec <kthread_mutex_alloc>
     acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ad2:	79 0a                	jns    ade <mesa_slots_monitor_alloc+0x1e>
		return 0;
     ad4:	b8 00 00 00 00       	mov    $0x0,%eax
     ad9:	e9 8b 00 00 00       	jmp    b69 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     ade:	e8 44 06 00 00       	call   1127 <mesa_cond_alloc>
     ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     ae6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     aea:	75 12                	jne    afe <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aef:	89 04 24             	mov    %eax,(%esp)
     af2:	e8 fd fa ff ff       	call   5f4 <kthread_mutex_dealloc>
		return 0;
     af7:	b8 00 00 00 00       	mov    $0x0,%eax
     afc:	eb 6b                	jmp    b69 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     afe:	e8 24 06 00 00       	call   1127 <mesa_cond_alloc>
     b03:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b0a:	75 1d                	jne    b29 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b0f:	89 04 24             	mov    %eax,(%esp)
     b12:	e8 dd fa ff ff       	call   5f4 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b1a:	89 04 24             	mov    %eax,(%esp)
     b1d:	e8 46 06 00 00       	call   1168 <mesa_cond_dealloc>
		return 0;
     b22:	b8 00 00 00 00       	mov    $0x0,%eax
     b27:	eb 40                	jmp    b69 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     b29:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b30:	e8 ab fe ff ff       	call   9e0 <malloc>
     b35:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b3e:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b44:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b47:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b50:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b5f:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b66:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b69:	c9                   	leave  
     b6a:	c3                   	ret    

00000b6b <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     b6b:	55                   	push   %ebp
     b6c:	89 e5                	mov    %esp,%ebp
     b6e:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     b71:	8b 45 08             	mov    0x8(%ebp),%eax
     b74:	8b 00                	mov    (%eax),%eax
     b76:	89 04 24             	mov    %eax,(%esp)
     b79:	e8 76 fa ff ff       	call   5f4 <kthread_mutex_dealloc>
     b7e:	85 c0                	test   %eax,%eax
     b80:	78 2e                	js     bb0 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     b82:	8b 45 08             	mov    0x8(%ebp),%eax
     b85:	8b 40 04             	mov    0x4(%eax),%eax
     b88:	89 04 24             	mov    %eax,(%esp)
     b8b:	e8 97 05 00 00       	call   1127 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     b90:	8b 45 08             	mov    0x8(%ebp),%eax
     b93:	8b 40 08             	mov    0x8(%eax),%eax
     b96:	89 04 24             	mov    %eax,(%esp)
     b99:	e8 89 05 00 00       	call   1127 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     b9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ba1:	89 04 24             	mov    %eax,(%esp)
     ba4:	e8 fe fc ff ff       	call   8a7 <free>
	return 0;
     ba9:	b8 00 00 00 00       	mov    $0x0,%eax
     bae:	eb 05                	jmp    bb5 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bb5:	c9                   	leave  
     bb6:	c3                   	ret    

00000bb7 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     bb7:	55                   	push   %ebp
     bb8:	89 e5                	mov    %esp,%ebp
     bba:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     bbd:	8b 45 08             	mov    0x8(%ebp),%eax
     bc0:	8b 40 10             	mov    0x10(%eax),%eax
     bc3:	85 c0                	test   %eax,%eax
     bc5:	75 0a                	jne    bd1 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bcc:	e9 81 00 00 00       	jmp    c52 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bd1:	8b 45 08             	mov    0x8(%ebp),%eax
     bd4:	8b 00                	mov    (%eax),%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 1e fa ff ff       	call   5fc <kthread_mutex_lock>
     bde:	83 f8 ff             	cmp    $0xffffffff,%eax
     be1:	7d 07                	jge    bea <mesa_slots_monitor_addslots+0x33>
		return -1;
     be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     be8:	eb 68                	jmp    c52 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     bea:	eb 17                	jmp    c03 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     bec:	8b 45 08             	mov    0x8(%ebp),%eax
     bef:	8b 10                	mov    (%eax),%edx
     bf1:	8b 45 08             	mov    0x8(%ebp),%eax
     bf4:	8b 40 08             	mov    0x8(%eax),%eax
     bf7:	89 54 24 04          	mov    %edx,0x4(%esp)
     bfb:	89 04 24             	mov    %eax,(%esp)
     bfe:	e8 af 05 00 00       	call   11b2 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c03:	8b 45 08             	mov    0x8(%ebp),%eax
     c06:	8b 40 10             	mov    0x10(%eax),%eax
     c09:	85 c0                	test   %eax,%eax
     c0b:	74 0a                	je     c17 <mesa_slots_monitor_addslots+0x60>
     c0d:	8b 45 08             	mov    0x8(%ebp),%eax
     c10:	8b 40 0c             	mov    0xc(%eax),%eax
     c13:	85 c0                	test   %eax,%eax
     c15:	7f d5                	jg     bec <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     c17:	8b 45 08             	mov    0x8(%ebp),%eax
     c1a:	8b 40 10             	mov    0x10(%eax),%eax
     c1d:	85 c0                	test   %eax,%eax
     c1f:	74 11                	je     c32 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     c21:	8b 45 08             	mov    0x8(%ebp),%eax
     c24:	8b 50 0c             	mov    0xc(%eax),%edx
     c27:	8b 45 0c             	mov    0xc(%ebp),%eax
     c2a:	01 c2                	add    %eax,%edx
     c2c:	8b 45 08             	mov    0x8(%ebp),%eax
     c2f:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     c32:	8b 45 08             	mov    0x8(%ebp),%eax
     c35:	8b 40 04             	mov    0x4(%eax),%eax
     c38:	89 04 24             	mov    %eax,(%esp)
     c3b:	e8 dc 05 00 00       	call   121c <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c40:	8b 45 08             	mov    0x8(%ebp),%eax
     c43:	8b 00                	mov    (%eax),%eax
     c45:	89 04 24             	mov    %eax,(%esp)
     c48:	e8 b7 f9 ff ff       	call   604 <kthread_mutex_unlock>

	return 1;
     c4d:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c52:	c9                   	leave  
     c53:	c3                   	ret    

00000c54 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     c54:	55                   	push   %ebp
     c55:	89 e5                	mov    %esp,%ebp
     c57:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
     c5d:	8b 40 10             	mov    0x10(%eax),%eax
     c60:	85 c0                	test   %eax,%eax
     c62:	75 07                	jne    c6b <mesa_slots_monitor_takeslot+0x17>
		return -1;
     c64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c69:	eb 7f                	jmp    cea <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c6b:	8b 45 08             	mov    0x8(%ebp),%eax
     c6e:	8b 00                	mov    (%eax),%eax
     c70:	89 04 24             	mov    %eax,(%esp)
     c73:	e8 84 f9 ff ff       	call   5fc <kthread_mutex_lock>
     c78:	83 f8 ff             	cmp    $0xffffffff,%eax
     c7b:	7d 07                	jge    c84 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c82:	eb 66                	jmp    cea <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     c84:	eb 17                	jmp    c9d <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     c86:	8b 45 08             	mov    0x8(%ebp),%eax
     c89:	8b 10                	mov    (%eax),%edx
     c8b:	8b 45 08             	mov    0x8(%ebp),%eax
     c8e:	8b 40 04             	mov    0x4(%eax),%eax
     c91:	89 54 24 04          	mov    %edx,0x4(%esp)
     c95:	89 04 24             	mov    %eax,(%esp)
     c98:	e8 15 05 00 00       	call   11b2 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     c9d:	8b 45 08             	mov    0x8(%ebp),%eax
     ca0:	8b 40 10             	mov    0x10(%eax),%eax
     ca3:	85 c0                	test   %eax,%eax
     ca5:	74 0a                	je     cb1 <mesa_slots_monitor_takeslot+0x5d>
     ca7:	8b 45 08             	mov    0x8(%ebp),%eax
     caa:	8b 40 0c             	mov    0xc(%eax),%eax
     cad:	85 c0                	test   %eax,%eax
     caf:	74 d5                	je     c86 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     cb1:	8b 45 08             	mov    0x8(%ebp),%eax
     cb4:	8b 40 10             	mov    0x10(%eax),%eax
     cb7:	85 c0                	test   %eax,%eax
     cb9:	74 0f                	je     cca <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	8b 40 0c             	mov    0xc(%eax),%eax
     cc1:	8d 50 ff             	lea    -0x1(%eax),%edx
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     cca:	8b 45 08             	mov    0x8(%ebp),%eax
     ccd:	8b 40 08             	mov    0x8(%eax),%eax
     cd0:	89 04 24             	mov    %eax,(%esp)
     cd3:	e8 44 05 00 00       	call   121c <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     cd8:	8b 45 08             	mov    0x8(%ebp),%eax
     cdb:	8b 00                	mov    (%eax),%eax
     cdd:	89 04 24             	mov    %eax,(%esp)
     ce0:	e8 1f f9 ff ff       	call   604 <kthread_mutex_unlock>

	return 1;
     ce5:	b8 01 00 00 00       	mov    $0x1,%eax

}
     cea:	c9                   	leave  
     ceb:	c3                   	ret    

00000cec <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     cec:	55                   	push   %ebp
     ced:	89 e5                	mov    %esp,%ebp
     cef:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     cf2:	8b 45 08             	mov    0x8(%ebp),%eax
     cf5:	8b 40 10             	mov    0x10(%eax),%eax
     cf8:	85 c0                	test   %eax,%eax
     cfa:	75 07                	jne    d03 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d01:	eb 35                	jmp    d38 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d03:	8b 45 08             	mov    0x8(%ebp),%eax
     d06:	8b 00                	mov    (%eax),%eax
     d08:	89 04 24             	mov    %eax,(%esp)
     d0b:	e8 ec f8 ff ff       	call   5fc <kthread_mutex_lock>
     d10:	83 f8 ff             	cmp    $0xffffffff,%eax
     d13:	7d 07                	jge    d1c <mesa_slots_monitor_stopadding+0x30>
			return -1;
     d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d1a:	eb 1c                	jmp    d38 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d1c:	8b 45 08             	mov    0x8(%ebp),%eax
     d1f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	8b 00                	mov    (%eax),%eax
     d2b:	89 04 24             	mov    %eax,(%esp)
     d2e:	e8 d1 f8 ff ff       	call   604 <kthread_mutex_unlock>

		return 0;
     d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d38:	c9                   	leave  
     d39:	c3                   	ret    

00000d3a <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     d3a:	55                   	push   %ebp
     d3b:	89 e5                	mov    %esp,%ebp
     d3d:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     d40:	e8 a7 f8 ff ff       	call   5ec <kthread_mutex_alloc>
     d45:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d4c:	79 0a                	jns    d58 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     d4e:	b8 00 00 00 00       	mov    $0x0,%eax
     d53:	e9 8b 00 00 00       	jmp    de3 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     d58:	e8 68 02 00 00       	call   fc5 <hoare_cond_alloc>
     d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d64:	75 12                	jne    d78 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d69:	89 04 24             	mov    %eax,(%esp)
     d6c:	e8 83 f8 ff ff       	call   5f4 <kthread_mutex_dealloc>
		return 0;
     d71:	b8 00 00 00 00       	mov    $0x0,%eax
     d76:	eb 6b                	jmp    de3 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     d78:	e8 48 02 00 00       	call   fc5 <hoare_cond_alloc>
     d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     d80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d84:	75 1d                	jne    da3 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d89:	89 04 24             	mov    %eax,(%esp)
     d8c:	e8 63 f8 ff ff       	call   5f4 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d94:	89 04 24             	mov    %eax,(%esp)
     d97:	e8 6a 02 00 00       	call   1006 <hoare_cond_dealloc>
		return 0;
     d9c:	b8 00 00 00 00       	mov    $0x0,%eax
     da1:	eb 40                	jmp    de3 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     da3:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     daa:	e8 31 fc ff ff       	call   9e0 <malloc>
     daf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
     db8:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
     dc1:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dca:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dcf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd9:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     de0:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     de3:	c9                   	leave  
     de4:	c3                   	ret    

00000de5 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     de5:	55                   	push   %ebp
     de6:	89 e5                	mov    %esp,%ebp
     de8:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     deb:	8b 45 08             	mov    0x8(%ebp),%eax
     dee:	8b 00                	mov    (%eax),%eax
     df0:	89 04 24             	mov    %eax,(%esp)
     df3:	e8 fc f7 ff ff       	call   5f4 <kthread_mutex_dealloc>
     df8:	85 c0                	test   %eax,%eax
     dfa:	78 2e                	js     e2a <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     dfc:	8b 45 08             	mov    0x8(%ebp),%eax
     dff:	8b 40 04             	mov    0x4(%eax),%eax
     e02:	89 04 24             	mov    %eax,(%esp)
     e05:	e8 bb 01 00 00       	call   fc5 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     e0a:	8b 45 08             	mov    0x8(%ebp),%eax
     e0d:	8b 40 08             	mov    0x8(%eax),%eax
     e10:	89 04 24             	mov    %eax,(%esp)
     e13:	e8 ad 01 00 00       	call   fc5 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     e18:	8b 45 08             	mov    0x8(%ebp),%eax
     e1b:	89 04 24             	mov    %eax,(%esp)
     e1e:	e8 84 fa ff ff       	call   8a7 <free>
	return 0;
     e23:	b8 00 00 00 00       	mov    $0x0,%eax
     e28:	eb 05                	jmp    e2f <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     e2f:	c9                   	leave  
     e30:	c3                   	ret    

00000e31 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     e31:	55                   	push   %ebp
     e32:	89 e5                	mov    %esp,%ebp
     e34:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     e37:	8b 45 08             	mov    0x8(%ebp),%eax
     e3a:	8b 40 10             	mov    0x10(%eax),%eax
     e3d:	85 c0                	test   %eax,%eax
     e3f:	75 0a                	jne    e4b <hoare_slots_monitor_addslots+0x1a>
		return -1;
     e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e46:	e9 88 00 00 00       	jmp    ed3 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e4b:	8b 45 08             	mov    0x8(%ebp),%eax
     e4e:	8b 00                	mov    (%eax),%eax
     e50:	89 04 24             	mov    %eax,(%esp)
     e53:	e8 a4 f7 ff ff       	call   5fc <kthread_mutex_lock>
     e58:	83 f8 ff             	cmp    $0xffffffff,%eax
     e5b:	7d 07                	jge    e64 <hoare_slots_monitor_addslots+0x33>
		return -1;
     e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e62:	eb 6f                	jmp    ed3 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     e64:	8b 45 08             	mov    0x8(%ebp),%eax
     e67:	8b 40 10             	mov    0x10(%eax),%eax
     e6a:	85 c0                	test   %eax,%eax
     e6c:	74 21                	je     e8f <hoare_slots_monitor_addslots+0x5e>
     e6e:	8b 45 08             	mov    0x8(%ebp),%eax
     e71:	8b 40 0c             	mov    0xc(%eax),%eax
     e74:	85 c0                	test   %eax,%eax
     e76:	7e 17                	jle    e8f <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     e78:	8b 45 08             	mov    0x8(%ebp),%eax
     e7b:	8b 10                	mov    (%eax),%edx
     e7d:	8b 45 08             	mov    0x8(%ebp),%eax
     e80:	8b 40 08             	mov    0x8(%eax),%eax
     e83:	89 54 24 04          	mov    %edx,0x4(%esp)
     e87:	89 04 24             	mov    %eax,(%esp)
     e8a:	e8 c1 01 00 00       	call   1050 <hoare_cond_wait>


	if  ( monitor->active)
     e8f:	8b 45 08             	mov    0x8(%ebp),%eax
     e92:	8b 40 10             	mov    0x10(%eax),%eax
     e95:	85 c0                	test   %eax,%eax
     e97:	74 11                	je     eaa <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     e99:	8b 45 08             	mov    0x8(%ebp),%eax
     e9c:	8b 50 0c             	mov    0xc(%eax),%edx
     e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea2:	01 c2                	add    %eax,%edx
     ea4:	8b 45 08             	mov    0x8(%ebp),%eax
     ea7:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     eaa:	8b 45 08             	mov    0x8(%ebp),%eax
     ead:	8b 10                	mov    (%eax),%edx
     eaf:	8b 45 08             	mov    0x8(%ebp),%eax
     eb2:	8b 40 04             	mov    0x4(%eax),%eax
     eb5:	89 54 24 04          	mov    %edx,0x4(%esp)
     eb9:	89 04 24             	mov    %eax,(%esp)
     ebc:	e8 e6 01 00 00       	call   10a7 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ec1:	8b 45 08             	mov    0x8(%ebp),%eax
     ec4:	8b 00                	mov    (%eax),%eax
     ec6:	89 04 24             	mov    %eax,(%esp)
     ec9:	e8 36 f7 ff ff       	call   604 <kthread_mutex_unlock>

	return 1;
     ece:	b8 01 00 00 00       	mov    $0x1,%eax


}
     ed3:	c9                   	leave  
     ed4:	c3                   	ret    

00000ed5 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     ed5:	55                   	push   %ebp
     ed6:	89 e5                	mov    %esp,%ebp
     ed8:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     edb:	8b 45 08             	mov    0x8(%ebp),%eax
     ede:	8b 40 10             	mov    0x10(%eax),%eax
     ee1:	85 c0                	test   %eax,%eax
     ee3:	75 0a                	jne    eef <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     ee5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eea:	e9 86 00 00 00       	jmp    f75 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     eef:	8b 45 08             	mov    0x8(%ebp),%eax
     ef2:	8b 00                	mov    (%eax),%eax
     ef4:	89 04 24             	mov    %eax,(%esp)
     ef7:	e8 00 f7 ff ff       	call   5fc <kthread_mutex_lock>
     efc:	83 f8 ff             	cmp    $0xffffffff,%eax
     eff:	7d 07                	jge    f08 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f06:	eb 6d                	jmp    f75 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f08:	8b 45 08             	mov    0x8(%ebp),%eax
     f0b:	8b 40 10             	mov    0x10(%eax),%eax
     f0e:	85 c0                	test   %eax,%eax
     f10:	74 21                	je     f33 <hoare_slots_monitor_takeslot+0x5e>
     f12:	8b 45 08             	mov    0x8(%ebp),%eax
     f15:	8b 40 0c             	mov    0xc(%eax),%eax
     f18:	85 c0                	test   %eax,%eax
     f1a:	75 17                	jne    f33 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     f1c:	8b 45 08             	mov    0x8(%ebp),%eax
     f1f:	8b 10                	mov    (%eax),%edx
     f21:	8b 45 08             	mov    0x8(%ebp),%eax
     f24:	8b 40 04             	mov    0x4(%eax),%eax
     f27:	89 54 24 04          	mov    %edx,0x4(%esp)
     f2b:	89 04 24             	mov    %eax,(%esp)
     f2e:	e8 1d 01 00 00       	call   1050 <hoare_cond_wait>


	if  ( monitor->active)
     f33:	8b 45 08             	mov    0x8(%ebp),%eax
     f36:	8b 40 10             	mov    0x10(%eax),%eax
     f39:	85 c0                	test   %eax,%eax
     f3b:	74 0f                	je     f4c <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     f3d:	8b 45 08             	mov    0x8(%ebp),%eax
     f40:	8b 40 0c             	mov    0xc(%eax),%eax
     f43:	8d 50 ff             	lea    -0x1(%eax),%edx
     f46:	8b 45 08             	mov    0x8(%ebp),%eax
     f49:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	8b 10                	mov    (%eax),%edx
     f51:	8b 45 08             	mov    0x8(%ebp),%eax
     f54:	8b 40 08             	mov    0x8(%eax),%eax
     f57:	89 54 24 04          	mov    %edx,0x4(%esp)
     f5b:	89 04 24             	mov    %eax,(%esp)
     f5e:	e8 44 01 00 00       	call   10a7 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	8b 00                	mov    (%eax),%eax
     f68:	89 04 24             	mov    %eax,(%esp)
     f6b:	e8 94 f6 ff ff       	call   604 <kthread_mutex_unlock>

	return 1;
     f70:	b8 01 00 00 00       	mov    $0x1,%eax

}
     f75:	c9                   	leave  
     f76:	c3                   	ret    

00000f77 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     f77:	55                   	push   %ebp
     f78:	89 e5                	mov    %esp,%ebp
     f7a:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     f7d:	8b 45 08             	mov    0x8(%ebp),%eax
     f80:	8b 40 10             	mov    0x10(%eax),%eax
     f83:	85 c0                	test   %eax,%eax
     f85:	75 07                	jne    f8e <hoare_slots_monitor_stopadding+0x17>
			return -1;
     f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f8c:	eb 35                	jmp    fc3 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f8e:	8b 45 08             	mov    0x8(%ebp),%eax
     f91:	8b 00                	mov    (%eax),%eax
     f93:	89 04 24             	mov    %eax,(%esp)
     f96:	e8 61 f6 ff ff       	call   5fc <kthread_mutex_lock>
     f9b:	83 f8 ff             	cmp    $0xffffffff,%eax
     f9e:	7d 07                	jge    fa7 <hoare_slots_monitor_stopadding+0x30>
			return -1;
     fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fa5:	eb 1c                	jmp    fc3 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     fa7:	8b 45 08             	mov    0x8(%ebp),%eax
     faa:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     fb1:	8b 45 08             	mov    0x8(%ebp),%eax
     fb4:	8b 00                	mov    (%eax),%eax
     fb6:	89 04 24             	mov    %eax,(%esp)
     fb9:	e8 46 f6 ff ff       	call   604 <kthread_mutex_unlock>

		return 0;
     fbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
     fc3:	c9                   	leave  
     fc4:	c3                   	ret    

00000fc5 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     fc5:	55                   	push   %ebp
     fc6:	89 e5                	mov    %esp,%ebp
     fc8:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     fcb:	e8 1c f6 ff ff       	call   5ec <kthread_mutex_alloc>
     fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fd7:	79 07                	jns    fe0 <hoare_cond_alloc+0x1b>
		return 0;
     fd9:	b8 00 00 00 00       	mov    $0x0,%eax
     fde:	eb 24                	jmp    1004 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     fe0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     fe7:	e8 f4 f9 ff ff       	call   9e0 <malloc>
     fec:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ff5:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1001:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1004:	c9                   	leave  
    1005:	c3                   	ret    

00001006 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    1006:	55                   	push   %ebp
    1007:	89 e5                	mov    %esp,%ebp
    1009:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    100c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1010:	75 07                	jne    1019 <hoare_cond_dealloc+0x13>
			return -1;
    1012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1017:	eb 35                	jmp    104e <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    1019:	8b 45 08             	mov    0x8(%ebp),%eax
    101c:	8b 00                	mov    (%eax),%eax
    101e:	89 04 24             	mov    %eax,(%esp)
    1021:	e8 de f5 ff ff       	call   604 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    1026:	8b 45 08             	mov    0x8(%ebp),%eax
    1029:	8b 00                	mov    (%eax),%eax
    102b:	89 04 24             	mov    %eax,(%esp)
    102e:	e8 c1 f5 ff ff       	call   5f4 <kthread_mutex_dealloc>
    1033:	85 c0                	test   %eax,%eax
    1035:	79 07                	jns    103e <hoare_cond_dealloc+0x38>
			return -1;
    1037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    103c:	eb 10                	jmp    104e <hoare_cond_dealloc+0x48>

		free (hCond);
    103e:	8b 45 08             	mov    0x8(%ebp),%eax
    1041:	89 04 24             	mov    %eax,(%esp)
    1044:	e8 5e f8 ff ff       	call   8a7 <free>
		return 0;
    1049:	b8 00 00 00 00       	mov    $0x0,%eax
}
    104e:	c9                   	leave  
    104f:	c3                   	ret    

00001050 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    1050:	55                   	push   %ebp
    1051:	89 e5                	mov    %esp,%ebp
    1053:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    1056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    105a:	75 07                	jne    1063 <hoare_cond_wait+0x13>
			return -1;
    105c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1061:	eb 42                	jmp    10a5 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	8b 40 04             	mov    0x4(%eax),%eax
    1069:	8d 50 01             	lea    0x1(%eax),%edx
    106c:	8b 45 08             	mov    0x8(%ebp),%eax
    106f:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    1072:	8b 45 08             	mov    0x8(%ebp),%eax
    1075:	8b 00                	mov    (%eax),%eax
    1077:	89 44 24 04          	mov    %eax,0x4(%esp)
    107b:	8b 45 0c             	mov    0xc(%ebp),%eax
    107e:	89 04 24             	mov    %eax,(%esp)
    1081:	e8 86 f5 ff ff       	call   60c <kthread_mutex_yieldlock>
    1086:	85 c0                	test   %eax,%eax
    1088:	79 16                	jns    10a0 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    108a:	8b 45 08             	mov    0x8(%ebp),%eax
    108d:	8b 40 04             	mov    0x4(%eax),%eax
    1090:	8d 50 ff             	lea    -0x1(%eax),%edx
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    1099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    109e:	eb 05                	jmp    10a5 <hoare_cond_wait+0x55>
		}

	return 0;
    10a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10a5:	c9                   	leave  
    10a6:	c3                   	ret    

000010a7 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    10a7:	55                   	push   %ebp
    10a8:	89 e5                	mov    %esp,%ebp
    10aa:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10b1:	75 07                	jne    10ba <hoare_cond_signal+0x13>
		return -1;
    10b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10b8:	eb 6b                	jmp    1125 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	8b 40 04             	mov    0x4(%eax),%eax
    10c0:	85 c0                	test   %eax,%eax
    10c2:	7e 3d                	jle    1101 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    10c4:	8b 45 08             	mov    0x8(%ebp),%eax
    10c7:	8b 40 04             	mov    0x4(%eax),%eax
    10ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	8b 00                	mov    (%eax),%eax
    10d8:	89 44 24 04          	mov    %eax,0x4(%esp)
    10dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    10df:	89 04 24             	mov    %eax,(%esp)
    10e2:	e8 25 f5 ff ff       	call   60c <kthread_mutex_yieldlock>
    10e7:	85 c0                	test   %eax,%eax
    10e9:	79 16                	jns    1101 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    10eb:	8b 45 08             	mov    0x8(%ebp),%eax
    10ee:	8b 40 04             	mov    0x4(%eax),%eax
    10f1:	8d 50 01             	lea    0x1(%eax),%edx
    10f4:	8b 45 08             	mov    0x8(%ebp),%eax
    10f7:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    10fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10ff:	eb 24                	jmp    1125 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	8b 00                	mov    (%eax),%eax
    1106:	89 44 24 04          	mov    %eax,0x4(%esp)
    110a:	8b 45 0c             	mov    0xc(%ebp),%eax
    110d:	89 04 24             	mov    %eax,(%esp)
    1110:	e8 f7 f4 ff ff       	call   60c <kthread_mutex_yieldlock>
    1115:	85 c0                	test   %eax,%eax
    1117:	79 07                	jns    1120 <hoare_cond_signal+0x79>

    			return -1;
    1119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    111e:	eb 05                	jmp    1125 <hoare_cond_signal+0x7e>
    }

	return 0;
    1120:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1125:	c9                   	leave  
    1126:	c3                   	ret    

00001127 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    1127:	55                   	push   %ebp
    1128:	89 e5                	mov    %esp,%ebp
    112a:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    112d:	e8 ba f4 ff ff       	call   5ec <kthread_mutex_alloc>
    1132:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1139:	79 07                	jns    1142 <mesa_cond_alloc+0x1b>
		return 0;
    113b:	b8 00 00 00 00       	mov    $0x0,%eax
    1140:	eb 24                	jmp    1166 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1142:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1149:	e8 92 f8 ff ff       	call   9e0 <malloc>
    114e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1151:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1154:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1157:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    1159:	8b 45 f0             	mov    -0x10(%ebp),%eax
    115c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1163:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1166:	c9                   	leave  
    1167:	c3                   	ret    

00001168 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    1168:	55                   	push   %ebp
    1169:	89 e5                	mov    %esp,%ebp
    116b:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1172:	75 07                	jne    117b <mesa_cond_dealloc+0x13>
		return -1;
    1174:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1179:	eb 35                	jmp    11b0 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    117b:	8b 45 08             	mov    0x8(%ebp),%eax
    117e:	8b 00                	mov    (%eax),%eax
    1180:	89 04 24             	mov    %eax,(%esp)
    1183:	e8 7c f4 ff ff       	call   604 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	8b 00                	mov    (%eax),%eax
    118d:	89 04 24             	mov    %eax,(%esp)
    1190:	e8 5f f4 ff ff       	call   5f4 <kthread_mutex_dealloc>
    1195:	85 c0                	test   %eax,%eax
    1197:	79 07                	jns    11a0 <mesa_cond_dealloc+0x38>
		return -1;
    1199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    119e:	eb 10                	jmp    11b0 <mesa_cond_dealloc+0x48>

	free (mCond);
    11a0:	8b 45 08             	mov    0x8(%ebp),%eax
    11a3:	89 04 24             	mov    %eax,(%esp)
    11a6:	e8 fc f6 ff ff       	call   8a7 <free>
	return 0;
    11ab:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11b0:	c9                   	leave  
    11b1:	c3                   	ret    

000011b2 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    11b2:	55                   	push   %ebp
    11b3:	89 e5                	mov    %esp,%ebp
    11b5:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    11b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    11bc:	75 07                	jne    11c5 <mesa_cond_wait+0x13>
		return -1;
    11be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c3:	eb 55                	jmp    121a <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    11c5:	8b 45 08             	mov    0x8(%ebp),%eax
    11c8:	8b 40 04             	mov    0x4(%eax),%eax
    11cb:	8d 50 01             	lea    0x1(%eax),%edx
    11ce:	8b 45 08             	mov    0x8(%ebp),%eax
    11d1:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    11d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 25 f4 ff ff       	call   604 <kthread_mutex_unlock>
    11df:	85 c0                	test   %eax,%eax
    11e1:	79 27                	jns    120a <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    11e3:	8b 45 08             	mov    0x8(%ebp),%eax
    11e6:	8b 00                	mov    (%eax),%eax
    11e8:	89 04 24             	mov    %eax,(%esp)
    11eb:	e8 0c f4 ff ff       	call   5fc <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    11f0:	85 c0                	test   %eax,%eax
    11f2:	79 16                	jns    120a <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	8b 40 04             	mov    0x4(%eax),%eax
    11fa:	8d 50 ff             	lea    -0x1(%eax),%edx
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1200:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    1203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1208:	eb 10                	jmp    121a <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    120a:	8b 45 0c             	mov    0xc(%ebp),%eax
    120d:	89 04 24             	mov    %eax,(%esp)
    1210:	e8 e7 f3 ff ff       	call   5fc <kthread_mutex_lock>
	return 0;
    1215:	b8 00 00 00 00       	mov    $0x0,%eax


}
    121a:	c9                   	leave  
    121b:	c3                   	ret    

0000121c <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    121c:	55                   	push   %ebp
    121d:	89 e5                	mov    %esp,%ebp
    121f:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1226:	75 07                	jne    122f <mesa_cond_signal+0x13>
		return -1;
    1228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    122d:	eb 5d                	jmp    128c <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    122f:	8b 45 08             	mov    0x8(%ebp),%eax
    1232:	8b 40 04             	mov    0x4(%eax),%eax
    1235:	85 c0                	test   %eax,%eax
    1237:	7e 36                	jle    126f <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1239:	8b 45 08             	mov    0x8(%ebp),%eax
    123c:	8b 40 04             	mov    0x4(%eax),%eax
    123f:	8d 50 ff             	lea    -0x1(%eax),%edx
    1242:	8b 45 08             	mov    0x8(%ebp),%eax
    1245:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	8b 00                	mov    (%eax),%eax
    124d:	89 04 24             	mov    %eax,(%esp)
    1250:	e8 af f3 ff ff       	call   604 <kthread_mutex_unlock>
    1255:	85 c0                	test   %eax,%eax
    1257:	78 16                	js     126f <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    1259:	8b 45 08             	mov    0x8(%ebp),%eax
    125c:	8b 40 04             	mov    0x4(%eax),%eax
    125f:	8d 50 01             	lea    0x1(%eax),%edx
    1262:	8b 45 08             	mov    0x8(%ebp),%eax
    1265:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    1268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    126d:	eb 1d                	jmp    128c <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    126f:	8b 45 08             	mov    0x8(%ebp),%eax
    1272:	8b 00                	mov    (%eax),%eax
    1274:	89 04 24             	mov    %eax,(%esp)
    1277:	e8 88 f3 ff ff       	call   604 <kthread_mutex_unlock>
    127c:	85 c0                	test   %eax,%eax
    127e:	79 07                	jns    1287 <mesa_cond_signal+0x6b>

		return -1;
    1280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1285:	eb 05                	jmp    128c <mesa_cond_signal+0x70>
	}
	return 0;
    1287:	b8 00 00 00 00       	mov    $0x0,%eax

}
    128c:	c9                   	leave  
    128d:	c3                   	ret    
