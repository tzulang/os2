
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
       6:	a1 b4 18 00 00       	mov    0x18b4,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 c6 0e 00 00       	call   ed9 <hoare_slots_monitor_takeslot>
	printf (1, " student %d got a slot \n",kthread_id());
      13:	e8 c0 05 00 00       	call   5d8 <kthread_id>
      18:	89 44 24 08          	mov    %eax,0x8(%esp)
      1c:	c7 44 24 04 94 12 00 	movl   $0x1294,0x4(%esp)
      23:	00 
      24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      2b:	e8 c8 06 00 00       	call   6f8 <printf>
	kthread_exit();
      30:	e8 ab 05 00 00       	call   5e0 <kthread_exit>
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
      3f:	8b 15 ac 18 00 00    	mov    0x18ac,%edx
      45:	a1 b4 18 00 00       	mov    0x18b4,%eax
      4a:	89 54 24 04          	mov    %edx,0x4(%esp)
      4e:	89 04 24             	mov    %eax,(%esp)
      51:	e8 df 0d 00 00       	call   e35 <hoare_slots_monitor_addslots>
	kthread_exit();
}

void addSlot(void){

	while (monitor->active){
      56:	a1 b4 18 00 00       	mov    0x18b4,%eax
      5b:	8b 40 10             	mov    0x10(%eax),%eax
      5e:	85 c0                	test   %eax,%eax
      60:	75 dd                	jne    3f <addSlot+0x8>
		hoare_slots_monitor_addslots(monitor, n);
	}
	printf (1, " grader stopped producing slots \n",kthread_id());
      62:	e8 71 05 00 00       	call   5d8 <kthread_id>
      67:	89 44 24 08          	mov    %eax,0x8(%esp)
      6b:	c7 44 24 04 b0 12 00 	movl   $0x12b0,0x4(%esp)
      72:	00 
      73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      7a:	e8 79 06 00 00       	call   6f8 <printf>
	kthread_exit();
      7f:	e8 5c 05 00 00       	call   5e0 <kthread_exit>
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
      a1:	c7 44 24 04 d4 12 00 	movl   $0x12d4,0x4(%esp)
      a8:	00 
      a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b0:	e8 43 06 00 00       	call   6f8 <printf>
		 exit();
      b5:	e8 76 04 00 00       	call   530 <exit>
	}

	m= atoi(argv[1]);
      ba:	8b 43 04             	mov    0x4(%ebx),%eax
      bd:	83 c0 04             	add    $0x4,%eax
      c0:	8b 00                	mov    (%eax),%eax
      c2:	89 04 24             	mov    %eax,(%esp)
      c5:	e8 d4 03 00 00       	call   49e <atoi>
      ca:	a3 b0 18 00 00       	mov    %eax,0x18b0
	n= atoi(argv[2]);
      cf:	8b 43 04             	mov    0x4(%ebx),%eax
      d2:	83 c0 08             	add    $0x8,%eax
      d5:	8b 00                	mov    (%eax),%eax
      d7:	89 04 24             	mov    %eax,(%esp)
      da:	e8 bf 03 00 00       	call   49e <atoi>
      df:	a3 ac 18 00 00       	mov    %eax,0x18ac

	if (n==0 ||m==0){
      e4:	a1 ac 18 00 00       	mov    0x18ac,%eax
      e9:	85 c0                	test   %eax,%eax
      eb:	74 09                	je     f6 <main+0x70>
      ed:	a1 b0 18 00 00       	mov    0x18b0,%eax
      f2:	85 c0                	test   %eax,%eax
      f4:	75 19                	jne    10f <main+0x89>
		 printf (1, "Error reading arguments. Insert numbers greater then 0 to run simulation\n");
      f6:	c7 44 24 04 fc 12 00 	movl   $0x12fc,0x4(%esp)
      fd:	00 
      fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     105:	e8 ee 05 00 00       	call   6f8 <printf>
		 exit();
     10a:	e8 21 04 00 00       	call   530 <exit>
	}

	monitor = hoare_slots_monitor_alloc();
     10f:	e8 2a 0c 00 00       	call   d3e <hoare_slots_monitor_alloc>
     114:	a3 b4 18 00 00       	mov    %eax,0x18b4

	if (monitor==0){
     119:	a1 b4 18 00 00       	mov    0x18b4,%eax
     11e:	85 c0                	test   %eax,%eax
     120:	75 19                	jne    13b <main+0xb5>
		 printf (1, "Error creating monitor \n");
     122:	c7 44 24 04 46 13 00 	movl   $0x1346,0x4(%esp)
     129:	00 
     12a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     131:	e8 c2 05 00 00       	call   6f8 <printf>
		 exit();
     136:	e8 f5 03 00 00       	call   530 <exit>
	}

	int studentsThread[m];
     13b:	a1 b0 18 00 00       	mov    0x18b0,%eax
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
     177:	a1 b0 18 00 00       	mov    0x18b0,%eax
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
     1c3:	e8 1c 08 00 00       	call   9e4 <malloc>
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
     1ed:	e8 de 03 00 00       	call   5d0 <kthread_create>
     1f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
     1f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     1f8:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     1fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     201:	8b 04 90             	mov    (%eax,%edx,4),%eax
     204:	85 c0                	test   %eax,%eax
     206:	79 19                	jns    221 <main+0x19b>
			printf(1, "Error Allocating threads for students");
     208:	c7 44 24 04 60 13 00 	movl   $0x1360,0x4(%esp)
     20f:	00 
     210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     217:	e8 dc 04 00 00       	call   6f8 <printf>
			exit();
     21c:	e8 0f 03 00 00       	call   530 <exit>
		}
		index++;
     221:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	int graderThread;



	int index=0;
	while (index <m){
     225:	a1 b0 18 00 00       	mov    0x18b0,%eax
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
     24b:	e8 80 03 00 00       	call   5d0 <kthread_create>
     250:	89 45 d0             	mov    %eax,-0x30(%ebp)
     253:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     257:	79 19                	jns    272 <main+0x1ec>
				printf(1, "Error Allocating threads for grader");
     259:	c7 44 24 04 88 13 00 	movl   $0x1388,0x4(%esp)
     260:	00 
     261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     268:	e8 8b 04 00 00       	call   6f8 <printf>
				exit();
     26d:	e8 be 02 00 00       	call   530 <exit>
	}


	index=0;
     272:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	while (index <m){
     279:	eb 26                	jmp    2a1 <main+0x21b>

		kthread_join( studentsThread[index]);
     27b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     27e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     281:	8b 04 90             	mov    (%eax,%edx,4),%eax
     284:	89 04 24             	mov    %eax,(%esp)
     287:	e8 5c 03 00 00       	call   5e8 <kthread_join>
		free(stacks[index]);
     28c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     28f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     292:	8b 04 90             	mov    (%eax,%edx,4),%eax
     295:	89 04 24             	mov    %eax,(%esp)
     298:	e8 0e 06 00 00       	call   8ab <free>
		index++;
     29d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
				exit();
	}


	index=0;
	while (index <m){
     2a1:	a1 b0 18 00 00       	mov    0x18b0,%eax
     2a6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
     2a9:	7c d0                	jl     27b <main+0x1f5>
		kthread_join( studentsThread[index]);
		free(stacks[index]);
		index++;
	}

	hoare_slots_monitor_stopadding(monitor);
     2ab:	a1 b4 18 00 00       	mov    0x18b4,%eax
     2b0:	89 04 24             	mov    %eax,(%esp)
     2b3:	e8 c3 0c 00 00       	call   f7b <hoare_slots_monitor_stopadding>

	kthread_join( graderThread);
     2b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2bb:	89 04 24             	mov    %eax,(%esp)
     2be:	e8 25 03 00 00       	call   5e8 <kthread_join>

	exit();
     2c3:	e8 68 02 00 00       	call   530 <exit>

000002c8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     2c8:	55                   	push   %ebp
     2c9:	89 e5                	mov    %esp,%ebp
     2cb:	57                   	push   %edi
     2cc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     2cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
     2d0:	8b 55 10             	mov    0x10(%ebp),%edx
     2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     2d6:	89 cb                	mov    %ecx,%ebx
     2d8:	89 df                	mov    %ebx,%edi
     2da:	89 d1                	mov    %edx,%ecx
     2dc:	fc                   	cld    
     2dd:	f3 aa                	rep stos %al,%es:(%edi)
     2df:	89 ca                	mov    %ecx,%edx
     2e1:	89 fb                	mov    %edi,%ebx
     2e3:	89 5d 08             	mov    %ebx,0x8(%ebp)
     2e6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     2e9:	5b                   	pop    %ebx
     2ea:	5f                   	pop    %edi
     2eb:	5d                   	pop    %ebp
     2ec:	c3                   	ret    

000002ed <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     2ed:	55                   	push   %ebp
     2ee:	89 e5                	mov    %esp,%ebp
     2f0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     2f3:	8b 45 08             	mov    0x8(%ebp),%eax
     2f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     2f9:	90                   	nop
     2fa:	8b 45 08             	mov    0x8(%ebp),%eax
     2fd:	8d 50 01             	lea    0x1(%eax),%edx
     300:	89 55 08             	mov    %edx,0x8(%ebp)
     303:	8b 55 0c             	mov    0xc(%ebp),%edx
     306:	8d 4a 01             	lea    0x1(%edx),%ecx
     309:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     30c:	0f b6 12             	movzbl (%edx),%edx
     30f:	88 10                	mov    %dl,(%eax)
     311:	0f b6 00             	movzbl (%eax),%eax
     314:	84 c0                	test   %al,%al
     316:	75 e2                	jne    2fa <strcpy+0xd>
    ;
  return os;
     318:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     31b:	c9                   	leave  
     31c:	c3                   	ret    

0000031d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     31d:	55                   	push   %ebp
     31e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     320:	eb 08                	jmp    32a <strcmp+0xd>
    p++, q++;
     322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     326:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     32a:	8b 45 08             	mov    0x8(%ebp),%eax
     32d:	0f b6 00             	movzbl (%eax),%eax
     330:	84 c0                	test   %al,%al
     332:	74 10                	je     344 <strcmp+0x27>
     334:	8b 45 08             	mov    0x8(%ebp),%eax
     337:	0f b6 10             	movzbl (%eax),%edx
     33a:	8b 45 0c             	mov    0xc(%ebp),%eax
     33d:	0f b6 00             	movzbl (%eax),%eax
     340:	38 c2                	cmp    %al,%dl
     342:	74 de                	je     322 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     344:	8b 45 08             	mov    0x8(%ebp),%eax
     347:	0f b6 00             	movzbl (%eax),%eax
     34a:	0f b6 d0             	movzbl %al,%edx
     34d:	8b 45 0c             	mov    0xc(%ebp),%eax
     350:	0f b6 00             	movzbl (%eax),%eax
     353:	0f b6 c0             	movzbl %al,%eax
     356:	29 c2                	sub    %eax,%edx
     358:	89 d0                	mov    %edx,%eax
}
     35a:	5d                   	pop    %ebp
     35b:	c3                   	ret    

0000035c <strlen>:

uint
strlen(char *s)
{
     35c:	55                   	push   %ebp
     35d:	89 e5                	mov    %esp,%ebp
     35f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     362:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     369:	eb 04                	jmp    36f <strlen+0x13>
     36b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     36f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     372:	8b 45 08             	mov    0x8(%ebp),%eax
     375:	01 d0                	add    %edx,%eax
     377:	0f b6 00             	movzbl (%eax),%eax
     37a:	84 c0                	test   %al,%al
     37c:	75 ed                	jne    36b <strlen+0xf>
    ;
  return n;
     37e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     381:	c9                   	leave  
     382:	c3                   	ret    

00000383 <memset>:

void*
memset(void *dst, int c, uint n)
{
     383:	55                   	push   %ebp
     384:	89 e5                	mov    %esp,%ebp
     386:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     389:	8b 45 10             	mov    0x10(%ebp),%eax
     38c:	89 44 24 08          	mov    %eax,0x8(%esp)
     390:	8b 45 0c             	mov    0xc(%ebp),%eax
     393:	89 44 24 04          	mov    %eax,0x4(%esp)
     397:	8b 45 08             	mov    0x8(%ebp),%eax
     39a:	89 04 24             	mov    %eax,(%esp)
     39d:	e8 26 ff ff ff       	call   2c8 <stosb>
  return dst;
     3a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3a5:	c9                   	leave  
     3a6:	c3                   	ret    

000003a7 <strchr>:

char*
strchr(const char *s, char c)
{
     3a7:	55                   	push   %ebp
     3a8:	89 e5                	mov    %esp,%ebp
     3aa:	83 ec 04             	sub    $0x4,%esp
     3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     3b0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     3b3:	eb 14                	jmp    3c9 <strchr+0x22>
    if(*s == c)
     3b5:	8b 45 08             	mov    0x8(%ebp),%eax
     3b8:	0f b6 00             	movzbl (%eax),%eax
     3bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
     3be:	75 05                	jne    3c5 <strchr+0x1e>
      return (char*)s;
     3c0:	8b 45 08             	mov    0x8(%ebp),%eax
     3c3:	eb 13                	jmp    3d8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3c9:	8b 45 08             	mov    0x8(%ebp),%eax
     3cc:	0f b6 00             	movzbl (%eax),%eax
     3cf:	84 c0                	test   %al,%al
     3d1:	75 e2                	jne    3b5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     3d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3d8:	c9                   	leave  
     3d9:	c3                   	ret    

000003da <gets>:

char*
gets(char *buf, int max)
{
     3da:	55                   	push   %ebp
     3db:	89 e5                	mov    %esp,%ebp
     3dd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     3e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3e7:	eb 4c                	jmp    435 <gets+0x5b>
    cc = read(0, &c, 1);
     3e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3f0:	00 
     3f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
     3f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     3f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3ff:	e8 44 01 00 00       	call   548 <read>
     404:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     40b:	7f 02                	jg     40f <gets+0x35>
      break;
     40d:	eb 31                	jmp    440 <gets+0x66>
    buf[i++] = c;
     40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     412:	8d 50 01             	lea    0x1(%eax),%edx
     415:	89 55 f4             	mov    %edx,-0xc(%ebp)
     418:	89 c2                	mov    %eax,%edx
     41a:	8b 45 08             	mov    0x8(%ebp),%eax
     41d:	01 c2                	add    %eax,%edx
     41f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     423:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     425:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     429:	3c 0a                	cmp    $0xa,%al
     42b:	74 13                	je     440 <gets+0x66>
     42d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     431:	3c 0d                	cmp    $0xd,%al
     433:	74 0b                	je     440 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     435:	8b 45 f4             	mov    -0xc(%ebp),%eax
     438:	83 c0 01             	add    $0x1,%eax
     43b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     43e:	7c a9                	jl     3e9 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     440:	8b 55 f4             	mov    -0xc(%ebp),%edx
     443:	8b 45 08             	mov    0x8(%ebp),%eax
     446:	01 d0                	add    %edx,%eax
     448:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     44b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     44e:	c9                   	leave  
     44f:	c3                   	ret    

00000450 <stat>:

int
stat(char *n, struct stat *st)
{
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     456:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     45d:	00 
     45e:	8b 45 08             	mov    0x8(%ebp),%eax
     461:	89 04 24             	mov    %eax,(%esp)
     464:	e8 07 01 00 00       	call   570 <open>
     469:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     46c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     470:	79 07                	jns    479 <stat+0x29>
    return -1;
     472:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     477:	eb 23                	jmp    49c <stat+0x4c>
  r = fstat(fd, st);
     479:	8b 45 0c             	mov    0xc(%ebp),%eax
     47c:	89 44 24 04          	mov    %eax,0x4(%esp)
     480:	8b 45 f4             	mov    -0xc(%ebp),%eax
     483:	89 04 24             	mov    %eax,(%esp)
     486:	e8 fd 00 00 00       	call   588 <fstat>
     48b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     491:	89 04 24             	mov    %eax,(%esp)
     494:	e8 bf 00 00 00       	call   558 <close>
  return r;
     499:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     49c:	c9                   	leave  
     49d:	c3                   	ret    

0000049e <atoi>:

int
atoi(const char *s)
{
     49e:	55                   	push   %ebp
     49f:	89 e5                	mov    %esp,%ebp
     4a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     4a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     4ab:	eb 25                	jmp    4d2 <atoi+0x34>
    n = n*10 + *s++ - '0';
     4ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
     4b0:	89 d0                	mov    %edx,%eax
     4b2:	c1 e0 02             	shl    $0x2,%eax
     4b5:	01 d0                	add    %edx,%eax
     4b7:	01 c0                	add    %eax,%eax
     4b9:	89 c1                	mov    %eax,%ecx
     4bb:	8b 45 08             	mov    0x8(%ebp),%eax
     4be:	8d 50 01             	lea    0x1(%eax),%edx
     4c1:	89 55 08             	mov    %edx,0x8(%ebp)
     4c4:	0f b6 00             	movzbl (%eax),%eax
     4c7:	0f be c0             	movsbl %al,%eax
     4ca:	01 c8                	add    %ecx,%eax
     4cc:	83 e8 30             	sub    $0x30,%eax
     4cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     4d2:	8b 45 08             	mov    0x8(%ebp),%eax
     4d5:	0f b6 00             	movzbl (%eax),%eax
     4d8:	3c 2f                	cmp    $0x2f,%al
     4da:	7e 0a                	jle    4e6 <atoi+0x48>
     4dc:	8b 45 08             	mov    0x8(%ebp),%eax
     4df:	0f b6 00             	movzbl (%eax),%eax
     4e2:	3c 39                	cmp    $0x39,%al
     4e4:	7e c7                	jle    4ad <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     4e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     4e9:	c9                   	leave  
     4ea:	c3                   	ret    

000004eb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     4eb:	55                   	push   %ebp
     4ec:	89 e5                	mov    %esp,%ebp
     4ee:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
     4f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     4fd:	eb 17                	jmp    516 <memmove+0x2b>
    *dst++ = *src++;
     4ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
     502:	8d 50 01             	lea    0x1(%eax),%edx
     505:	89 55 fc             	mov    %edx,-0x4(%ebp)
     508:	8b 55 f8             	mov    -0x8(%ebp),%edx
     50b:	8d 4a 01             	lea    0x1(%edx),%ecx
     50e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     511:	0f b6 12             	movzbl (%edx),%edx
     514:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     516:	8b 45 10             	mov    0x10(%ebp),%eax
     519:	8d 50 ff             	lea    -0x1(%eax),%edx
     51c:	89 55 10             	mov    %edx,0x10(%ebp)
     51f:	85 c0                	test   %eax,%eax
     521:	7f dc                	jg     4ff <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     523:	8b 45 08             	mov    0x8(%ebp),%eax
}
     526:	c9                   	leave  
     527:	c3                   	ret    

00000528 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     528:	b8 01 00 00 00       	mov    $0x1,%eax
     52d:	cd 40                	int    $0x40
     52f:	c3                   	ret    

00000530 <exit>:
SYSCALL(exit)
     530:	b8 02 00 00 00       	mov    $0x2,%eax
     535:	cd 40                	int    $0x40
     537:	c3                   	ret    

00000538 <wait>:
SYSCALL(wait)
     538:	b8 03 00 00 00       	mov    $0x3,%eax
     53d:	cd 40                	int    $0x40
     53f:	c3                   	ret    

00000540 <pipe>:
SYSCALL(pipe)
     540:	b8 04 00 00 00       	mov    $0x4,%eax
     545:	cd 40                	int    $0x40
     547:	c3                   	ret    

00000548 <read>:
SYSCALL(read)
     548:	b8 05 00 00 00       	mov    $0x5,%eax
     54d:	cd 40                	int    $0x40
     54f:	c3                   	ret    

00000550 <write>:
SYSCALL(write)
     550:	b8 10 00 00 00       	mov    $0x10,%eax
     555:	cd 40                	int    $0x40
     557:	c3                   	ret    

00000558 <close>:
SYSCALL(close)
     558:	b8 15 00 00 00       	mov    $0x15,%eax
     55d:	cd 40                	int    $0x40
     55f:	c3                   	ret    

00000560 <kill>:
SYSCALL(kill)
     560:	b8 06 00 00 00       	mov    $0x6,%eax
     565:	cd 40                	int    $0x40
     567:	c3                   	ret    

00000568 <exec>:
SYSCALL(exec)
     568:	b8 07 00 00 00       	mov    $0x7,%eax
     56d:	cd 40                	int    $0x40
     56f:	c3                   	ret    

00000570 <open>:
SYSCALL(open)
     570:	b8 0f 00 00 00       	mov    $0xf,%eax
     575:	cd 40                	int    $0x40
     577:	c3                   	ret    

00000578 <mknod>:
SYSCALL(mknod)
     578:	b8 11 00 00 00       	mov    $0x11,%eax
     57d:	cd 40                	int    $0x40
     57f:	c3                   	ret    

00000580 <unlink>:
SYSCALL(unlink)
     580:	b8 12 00 00 00       	mov    $0x12,%eax
     585:	cd 40                	int    $0x40
     587:	c3                   	ret    

00000588 <fstat>:
SYSCALL(fstat)
     588:	b8 08 00 00 00       	mov    $0x8,%eax
     58d:	cd 40                	int    $0x40
     58f:	c3                   	ret    

00000590 <link>:
SYSCALL(link)
     590:	b8 13 00 00 00       	mov    $0x13,%eax
     595:	cd 40                	int    $0x40
     597:	c3                   	ret    

00000598 <mkdir>:
SYSCALL(mkdir)
     598:	b8 14 00 00 00       	mov    $0x14,%eax
     59d:	cd 40                	int    $0x40
     59f:	c3                   	ret    

000005a0 <chdir>:
SYSCALL(chdir)
     5a0:	b8 09 00 00 00       	mov    $0x9,%eax
     5a5:	cd 40                	int    $0x40
     5a7:	c3                   	ret    

000005a8 <dup>:
SYSCALL(dup)
     5a8:	b8 0a 00 00 00       	mov    $0xa,%eax
     5ad:	cd 40                	int    $0x40
     5af:	c3                   	ret    

000005b0 <getpid>:
SYSCALL(getpid)
     5b0:	b8 0b 00 00 00       	mov    $0xb,%eax
     5b5:	cd 40                	int    $0x40
     5b7:	c3                   	ret    

000005b8 <sbrk>:
SYSCALL(sbrk)
     5b8:	b8 0c 00 00 00       	mov    $0xc,%eax
     5bd:	cd 40                	int    $0x40
     5bf:	c3                   	ret    

000005c0 <sleep>:
SYSCALL(sleep)
     5c0:	b8 0d 00 00 00       	mov    $0xd,%eax
     5c5:	cd 40                	int    $0x40
     5c7:	c3                   	ret    

000005c8 <uptime>:
SYSCALL(uptime)
     5c8:	b8 0e 00 00 00       	mov    $0xe,%eax
     5cd:	cd 40                	int    $0x40
     5cf:	c3                   	ret    

000005d0 <kthread_create>:




SYSCALL(kthread_create)
     5d0:	b8 16 00 00 00       	mov    $0x16,%eax
     5d5:	cd 40                	int    $0x40
     5d7:	c3                   	ret    

000005d8 <kthread_id>:
SYSCALL(kthread_id)
     5d8:	b8 17 00 00 00       	mov    $0x17,%eax
     5dd:	cd 40                	int    $0x40
     5df:	c3                   	ret    

000005e0 <kthread_exit>:
SYSCALL(kthread_exit)
     5e0:	b8 18 00 00 00       	mov    $0x18,%eax
     5e5:	cd 40                	int    $0x40
     5e7:	c3                   	ret    

000005e8 <kthread_join>:
SYSCALL(kthread_join)
     5e8:	b8 19 00 00 00       	mov    $0x19,%eax
     5ed:	cd 40                	int    $0x40
     5ef:	c3                   	ret    

000005f0 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     5f0:	b8 1a 00 00 00       	mov    $0x1a,%eax
     5f5:	cd 40                	int    $0x40
     5f7:	c3                   	ret    

000005f8 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     5f8:	b8 1b 00 00 00       	mov    $0x1b,%eax
     5fd:	cd 40                	int    $0x40
     5ff:	c3                   	ret    

00000600 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     600:	b8 1c 00 00 00       	mov    $0x1c,%eax
     605:	cd 40                	int    $0x40
     607:	c3                   	ret    

00000608 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     608:	b8 1d 00 00 00       	mov    $0x1d,%eax
     60d:	cd 40                	int    $0x40
     60f:	c3                   	ret    

00000610 <kthread_mutex_yieldlock>:
     610:	b8 1e 00 00 00       	mov    $0x1e,%eax
     615:	cd 40                	int    $0x40
     617:	c3                   	ret    

00000618 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     618:	55                   	push   %ebp
     619:	89 e5                	mov    %esp,%ebp
     61b:	83 ec 18             	sub    $0x18,%esp
     61e:	8b 45 0c             	mov    0xc(%ebp),%eax
     621:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     624:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     62b:	00 
     62c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     62f:	89 44 24 04          	mov    %eax,0x4(%esp)
     633:	8b 45 08             	mov    0x8(%ebp),%eax
     636:	89 04 24             	mov    %eax,(%esp)
     639:	e8 12 ff ff ff       	call   550 <write>
}
     63e:	c9                   	leave  
     63f:	c3                   	ret    

00000640 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	56                   	push   %esi
     644:	53                   	push   %ebx
     645:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     648:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     64f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     653:	74 17                	je     66c <printint+0x2c>
     655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     659:	79 11                	jns    66c <printint+0x2c>
    neg = 1;
     65b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     662:	8b 45 0c             	mov    0xc(%ebp),%eax
     665:	f7 d8                	neg    %eax
     667:	89 45 ec             	mov    %eax,-0x14(%ebp)
     66a:	eb 06                	jmp    672 <printint+0x32>
  } else {
    x = xx;
     66c:	8b 45 0c             	mov    0xc(%ebp),%eax
     66f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     672:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     679:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     67c:	8d 41 01             	lea    0x1(%ecx),%eax
     67f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     682:	8b 5d 10             	mov    0x10(%ebp),%ebx
     685:	8b 45 ec             	mov    -0x14(%ebp),%eax
     688:	ba 00 00 00 00       	mov    $0x0,%edx
     68d:	f7 f3                	div    %ebx
     68f:	89 d0                	mov    %edx,%eax
     691:	0f b6 80 8c 18 00 00 	movzbl 0x188c(%eax),%eax
     698:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     69c:	8b 75 10             	mov    0x10(%ebp),%esi
     69f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6a2:	ba 00 00 00 00       	mov    $0x0,%edx
     6a7:	f7 f6                	div    %esi
     6a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6b0:	75 c7                	jne    679 <printint+0x39>
  if(neg)
     6b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     6b6:	74 10                	je     6c8 <printint+0x88>
    buf[i++] = '-';
     6b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6bb:	8d 50 01             	lea    0x1(%eax),%edx
     6be:	89 55 f4             	mov    %edx,-0xc(%ebp)
     6c1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     6c6:	eb 1f                	jmp    6e7 <printint+0xa7>
     6c8:	eb 1d                	jmp    6e7 <printint+0xa7>
    putc(fd, buf[i]);
     6ca:	8d 55 dc             	lea    -0x24(%ebp),%edx
     6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d0:	01 d0                	add    %edx,%eax
     6d2:	0f b6 00             	movzbl (%eax),%eax
     6d5:	0f be c0             	movsbl %al,%eax
     6d8:	89 44 24 04          	mov    %eax,0x4(%esp)
     6dc:	8b 45 08             	mov    0x8(%ebp),%eax
     6df:	89 04 24             	mov    %eax,(%esp)
     6e2:	e8 31 ff ff ff       	call   618 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     6e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     6eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6ef:	79 d9                	jns    6ca <printint+0x8a>
    putc(fd, buf[i]);
}
     6f1:	83 c4 30             	add    $0x30,%esp
     6f4:	5b                   	pop    %ebx
     6f5:	5e                   	pop    %esi
     6f6:	5d                   	pop    %ebp
     6f7:	c3                   	ret    

000006f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     6f8:	55                   	push   %ebp
     6f9:	89 e5                	mov    %esp,%ebp
     6fb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     6fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     705:	8d 45 0c             	lea    0xc(%ebp),%eax
     708:	83 c0 04             	add    $0x4,%eax
     70b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     70e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     715:	e9 7c 01 00 00       	jmp    896 <printf+0x19e>
    c = fmt[i] & 0xff;
     71a:	8b 55 0c             	mov    0xc(%ebp),%edx
     71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     720:	01 d0                	add    %edx,%eax
     722:	0f b6 00             	movzbl (%eax),%eax
     725:	0f be c0             	movsbl %al,%eax
     728:	25 ff 00 00 00       	and    $0xff,%eax
     72d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     730:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     734:	75 2c                	jne    762 <printf+0x6a>
      if(c == '%'){
     736:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     73a:	75 0c                	jne    748 <printf+0x50>
        state = '%';
     73c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     743:	e9 4a 01 00 00       	jmp    892 <printf+0x19a>
      } else {
        putc(fd, c);
     748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     74b:	0f be c0             	movsbl %al,%eax
     74e:	89 44 24 04          	mov    %eax,0x4(%esp)
     752:	8b 45 08             	mov    0x8(%ebp),%eax
     755:	89 04 24             	mov    %eax,(%esp)
     758:	e8 bb fe ff ff       	call   618 <putc>
     75d:	e9 30 01 00 00       	jmp    892 <printf+0x19a>
      }
    } else if(state == '%'){
     762:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     766:	0f 85 26 01 00 00    	jne    892 <printf+0x19a>
      if(c == 'd'){
     76c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     770:	75 2d                	jne    79f <printf+0xa7>
        printint(fd, *ap, 10, 1);
     772:	8b 45 e8             	mov    -0x18(%ebp),%eax
     775:	8b 00                	mov    (%eax),%eax
     777:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     77e:	00 
     77f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     786:	00 
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 aa fe ff ff       	call   640 <printint>
        ap++;
     796:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     79a:	e9 ec 00 00 00       	jmp    88b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     79f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     7a3:	74 06                	je     7ab <printf+0xb3>
     7a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     7a9:	75 2d                	jne    7d8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     7ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7ae:	8b 00                	mov    (%eax),%eax
     7b0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7b7:	00 
     7b8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     7bf:	00 
     7c0:	89 44 24 04          	mov    %eax,0x4(%esp)
     7c4:	8b 45 08             	mov    0x8(%ebp),%eax
     7c7:	89 04 24             	mov    %eax,(%esp)
     7ca:	e8 71 fe ff ff       	call   640 <printint>
        ap++;
     7cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7d3:	e9 b3 00 00 00       	jmp    88b <printf+0x193>
      } else if(c == 's'){
     7d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     7dc:	75 45                	jne    823 <printf+0x12b>
        s = (char*)*ap;
     7de:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7e1:	8b 00                	mov    (%eax),%eax
     7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     7e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     7ee:	75 09                	jne    7f9 <printf+0x101>
          s = "(null)";
     7f0:	c7 45 f4 ac 13 00 00 	movl   $0x13ac,-0xc(%ebp)
        while(*s != 0){
     7f7:	eb 1e                	jmp    817 <printf+0x11f>
     7f9:	eb 1c                	jmp    817 <printf+0x11f>
          putc(fd, *s);
     7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fe:	0f b6 00             	movzbl (%eax),%eax
     801:	0f be c0             	movsbl %al,%eax
     804:	89 44 24 04          	mov    %eax,0x4(%esp)
     808:	8b 45 08             	mov    0x8(%ebp),%eax
     80b:	89 04 24             	mov    %eax,(%esp)
     80e:	e8 05 fe ff ff       	call   618 <putc>
          s++;
     813:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     817:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81a:	0f b6 00             	movzbl (%eax),%eax
     81d:	84 c0                	test   %al,%al
     81f:	75 da                	jne    7fb <printf+0x103>
     821:	eb 68                	jmp    88b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     823:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     827:	75 1d                	jne    846 <printf+0x14e>
        putc(fd, *ap);
     829:	8b 45 e8             	mov    -0x18(%ebp),%eax
     82c:	8b 00                	mov    (%eax),%eax
     82e:	0f be c0             	movsbl %al,%eax
     831:	89 44 24 04          	mov    %eax,0x4(%esp)
     835:	8b 45 08             	mov    0x8(%ebp),%eax
     838:	89 04 24             	mov    %eax,(%esp)
     83b:	e8 d8 fd ff ff       	call   618 <putc>
        ap++;
     840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     844:	eb 45                	jmp    88b <printf+0x193>
      } else if(c == '%'){
     846:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     84a:	75 17                	jne    863 <printf+0x16b>
        putc(fd, c);
     84c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     84f:	0f be c0             	movsbl %al,%eax
     852:	89 44 24 04          	mov    %eax,0x4(%esp)
     856:	8b 45 08             	mov    0x8(%ebp),%eax
     859:	89 04 24             	mov    %eax,(%esp)
     85c:	e8 b7 fd ff ff       	call   618 <putc>
     861:	eb 28                	jmp    88b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     863:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     86a:	00 
     86b:	8b 45 08             	mov    0x8(%ebp),%eax
     86e:	89 04 24             	mov    %eax,(%esp)
     871:	e8 a2 fd ff ff       	call   618 <putc>
        putc(fd, c);
     876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     879:	0f be c0             	movsbl %al,%eax
     87c:	89 44 24 04          	mov    %eax,0x4(%esp)
     880:	8b 45 08             	mov    0x8(%ebp),%eax
     883:	89 04 24             	mov    %eax,(%esp)
     886:	e8 8d fd ff ff       	call   618 <putc>
      }
      state = 0;
     88b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     892:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     896:	8b 55 0c             	mov    0xc(%ebp),%edx
     899:	8b 45 f0             	mov    -0x10(%ebp),%eax
     89c:	01 d0                	add    %edx,%eax
     89e:	0f b6 00             	movzbl (%eax),%eax
     8a1:	84 c0                	test   %al,%al
     8a3:	0f 85 71 fe ff ff    	jne    71a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     8a9:	c9                   	leave  
     8aa:	c3                   	ret    

000008ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     8ab:	55                   	push   %ebp
     8ac:	89 e5                	mov    %esp,%ebp
     8ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     8b1:	8b 45 08             	mov    0x8(%ebp),%eax
     8b4:	83 e8 08             	sub    $0x8,%eax
     8b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8ba:	a1 a8 18 00 00       	mov    0x18a8,%eax
     8bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8c2:	eb 24                	jmp    8e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8c7:	8b 00                	mov    (%eax),%eax
     8c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8cc:	77 12                	ja     8e0 <free+0x35>
     8ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8d4:	77 24                	ja     8fa <free+0x4f>
     8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8d9:	8b 00                	mov    (%eax),%eax
     8db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8de:	77 1a                	ja     8fa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8e3:	8b 00                	mov    (%eax),%eax
     8e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
     8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     8ee:	76 d4                	jbe    8c4 <free+0x19>
     8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8f3:	8b 00                	mov    (%eax),%eax
     8f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     8f8:	76 ca                	jbe    8c4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8fd:	8b 40 04             	mov    0x4(%eax),%eax
     900:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     907:	8b 45 f8             	mov    -0x8(%ebp),%eax
     90a:	01 c2                	add    %eax,%edx
     90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     90f:	8b 00                	mov    (%eax),%eax
     911:	39 c2                	cmp    %eax,%edx
     913:	75 24                	jne    939 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     915:	8b 45 f8             	mov    -0x8(%ebp),%eax
     918:	8b 50 04             	mov    0x4(%eax),%edx
     91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     91e:	8b 00                	mov    (%eax),%eax
     920:	8b 40 04             	mov    0x4(%eax),%eax
     923:	01 c2                	add    %eax,%edx
     925:	8b 45 f8             	mov    -0x8(%ebp),%eax
     928:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     92b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     92e:	8b 00                	mov    (%eax),%eax
     930:	8b 10                	mov    (%eax),%edx
     932:	8b 45 f8             	mov    -0x8(%ebp),%eax
     935:	89 10                	mov    %edx,(%eax)
     937:	eb 0a                	jmp    943 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     939:	8b 45 fc             	mov    -0x4(%ebp),%eax
     93c:	8b 10                	mov    (%eax),%edx
     93e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     941:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     943:	8b 45 fc             	mov    -0x4(%ebp),%eax
     946:	8b 40 04             	mov    0x4(%eax),%eax
     949:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     950:	8b 45 fc             	mov    -0x4(%ebp),%eax
     953:	01 d0                	add    %edx,%eax
     955:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     958:	75 20                	jne    97a <free+0xcf>
    p->s.size += bp->s.size;
     95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     95d:	8b 50 04             	mov    0x4(%eax),%edx
     960:	8b 45 f8             	mov    -0x8(%ebp),%eax
     963:	8b 40 04             	mov    0x4(%eax),%eax
     966:	01 c2                	add    %eax,%edx
     968:	8b 45 fc             	mov    -0x4(%ebp),%eax
     96b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     971:	8b 10                	mov    (%eax),%edx
     973:	8b 45 fc             	mov    -0x4(%ebp),%eax
     976:	89 10                	mov    %edx,(%eax)
     978:	eb 08                	jmp    982 <free+0xd7>
  } else
    p->s.ptr = bp;
     97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97d:	8b 55 f8             	mov    -0x8(%ebp),%edx
     980:	89 10                	mov    %edx,(%eax)
  freep = p;
     982:	8b 45 fc             	mov    -0x4(%ebp),%eax
     985:	a3 a8 18 00 00       	mov    %eax,0x18a8
}
     98a:	c9                   	leave  
     98b:	c3                   	ret    

0000098c <morecore>:

static Header*
morecore(uint nu)
{
     98c:	55                   	push   %ebp
     98d:	89 e5                	mov    %esp,%ebp
     98f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     992:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     999:	77 07                	ja     9a2 <morecore+0x16>
    nu = 4096;
     99b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     9a2:	8b 45 08             	mov    0x8(%ebp),%eax
     9a5:	c1 e0 03             	shl    $0x3,%eax
     9a8:	89 04 24             	mov    %eax,(%esp)
     9ab:	e8 08 fc ff ff       	call   5b8 <sbrk>
     9b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     9b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     9b7:	75 07                	jne    9c0 <morecore+0x34>
    return 0;
     9b9:	b8 00 00 00 00       	mov    $0x0,%eax
     9be:	eb 22                	jmp    9e2 <morecore+0x56>
  hp = (Header*)p;
     9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     9c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9c9:	8b 55 08             	mov    0x8(%ebp),%edx
     9cc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     9cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9d2:	83 c0 08             	add    $0x8,%eax
     9d5:	89 04 24             	mov    %eax,(%esp)
     9d8:	e8 ce fe ff ff       	call   8ab <free>
  return freep;
     9dd:	a1 a8 18 00 00       	mov    0x18a8,%eax
}
     9e2:	c9                   	leave  
     9e3:	c3                   	ret    

000009e4 <malloc>:

void*
malloc(uint nbytes)
{
     9e4:	55                   	push   %ebp
     9e5:	89 e5                	mov    %esp,%ebp
     9e7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     9ea:	8b 45 08             	mov    0x8(%ebp),%eax
     9ed:	83 c0 07             	add    $0x7,%eax
     9f0:	c1 e8 03             	shr    $0x3,%eax
     9f3:	83 c0 01             	add    $0x1,%eax
     9f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     9f9:	a1 a8 18 00 00       	mov    0x18a8,%eax
     9fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a05:	75 23                	jne    a2a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a07:	c7 45 f0 a0 18 00 00 	movl   $0x18a0,-0x10(%ebp)
     a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a11:	a3 a8 18 00 00       	mov    %eax,0x18a8
     a16:	a1 a8 18 00 00       	mov    0x18a8,%eax
     a1b:	a3 a0 18 00 00       	mov    %eax,0x18a0
    base.s.size = 0;
     a20:	c7 05 a4 18 00 00 00 	movl   $0x0,0x18a4
     a27:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2d:	8b 00                	mov    (%eax),%eax
     a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a35:	8b 40 04             	mov    0x4(%eax),%eax
     a38:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a3b:	72 4d                	jb     a8a <malloc+0xa6>
      if(p->s.size == nunits)
     a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a40:	8b 40 04             	mov    0x4(%eax),%eax
     a43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a46:	75 0c                	jne    a54 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a4b:	8b 10                	mov    (%eax),%edx
     a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a50:	89 10                	mov    %edx,(%eax)
     a52:	eb 26                	jmp    a7a <malloc+0x96>
      else {
        p->s.size -= nunits;
     a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a57:	8b 40 04             	mov    0x4(%eax),%eax
     a5a:	2b 45 ec             	sub    -0x14(%ebp),%eax
     a5d:	89 c2                	mov    %eax,%edx
     a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a62:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a68:	8b 40 04             	mov    0x4(%eax),%eax
     a6b:	c1 e0 03             	shl    $0x3,%eax
     a6e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a74:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a77:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a7d:	a3 a8 18 00 00       	mov    %eax,0x18a8
      return (void*)(p + 1);
     a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a85:	83 c0 08             	add    $0x8,%eax
     a88:	eb 38                	jmp    ac2 <malloc+0xde>
    }
    if(p == freep)
     a8a:	a1 a8 18 00 00       	mov    0x18a8,%eax
     a8f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a92:	75 1b                	jne    aaf <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a97:	89 04 24             	mov    %eax,(%esp)
     a9a:	e8 ed fe ff ff       	call   98c <morecore>
     a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aa6:	75 07                	jne    aaf <malloc+0xcb>
        return 0;
     aa8:	b8 00 00 00 00       	mov    $0x0,%eax
     aad:	eb 13                	jmp    ac2 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab8:	8b 00                	mov    (%eax),%eax
     aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     abd:	e9 70 ff ff ff       	jmp    a32 <malloc+0x4e>
}
     ac2:	c9                   	leave  
     ac3:	c3                   	ret    

00000ac4 <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     ac4:	55                   	push   %ebp
     ac5:	89 e5                	mov    %esp,%ebp
     ac7:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     aca:	e8 21 fb ff ff       	call   5f0 <kthread_mutex_alloc>
     acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ad6:	79 0a                	jns    ae2 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     ad8:	b8 00 00 00 00       	mov    $0x0,%eax
     add:	e9 8b 00 00 00       	jmp    b6d <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     ae2:	e8 44 06 00 00       	call   112b <mesa_cond_alloc>
     ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     aee:	75 12                	jne    b02 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af3:	89 04 24             	mov    %eax,(%esp)
     af6:	e8 fd fa ff ff       	call   5f8 <kthread_mutex_dealloc>
		return 0;
     afb:	b8 00 00 00 00       	mov    $0x0,%eax
     b00:	eb 6b                	jmp    b6d <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     b02:	e8 24 06 00 00       	call   112b <mesa_cond_alloc>
     b07:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b0e:	75 1d                	jne    b2d <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b13:	89 04 24             	mov    %eax,(%esp)
     b16:	e8 dd fa ff ff       	call   5f8 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b1e:	89 04 24             	mov    %eax,(%esp)
     b21:	e8 46 06 00 00       	call   116c <mesa_cond_dealloc>
		return 0;
     b26:	b8 00 00 00 00       	mov    $0x0,%eax
     b2b:	eb 40                	jmp    b6d <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     b2d:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b34:	e8 ab fe ff ff       	call   9e4 <malloc>
     b39:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b42:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b48:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b4b:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b54:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b63:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b6d:	c9                   	leave  
     b6e:	c3                   	ret    

00000b6f <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     b6f:	55                   	push   %ebp
     b70:	89 e5                	mov    %esp,%ebp
     b72:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     b75:	8b 45 08             	mov    0x8(%ebp),%eax
     b78:	8b 00                	mov    (%eax),%eax
     b7a:	89 04 24             	mov    %eax,(%esp)
     b7d:	e8 76 fa ff ff       	call   5f8 <kthread_mutex_dealloc>
     b82:	85 c0                	test   %eax,%eax
     b84:	78 2e                	js     bb4 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     b86:	8b 45 08             	mov    0x8(%ebp),%eax
     b89:	8b 40 04             	mov    0x4(%eax),%eax
     b8c:	89 04 24             	mov    %eax,(%esp)
     b8f:	e8 97 05 00 00       	call   112b <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	8b 40 08             	mov    0x8(%eax),%eax
     b9a:	89 04 24             	mov    %eax,(%esp)
     b9d:	e8 89 05 00 00       	call   112b <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     ba2:	8b 45 08             	mov    0x8(%ebp),%eax
     ba5:	89 04 24             	mov    %eax,(%esp)
     ba8:	e8 fe fc ff ff       	call   8ab <free>
	return 0;
     bad:	b8 00 00 00 00       	mov    $0x0,%eax
     bb2:	eb 05                	jmp    bb9 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bb9:	c9                   	leave  
     bba:	c3                   	ret    

00000bbb <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     bbb:	55                   	push   %ebp
     bbc:	89 e5                	mov    %esp,%ebp
     bbe:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     bc1:	8b 45 08             	mov    0x8(%ebp),%eax
     bc4:	8b 40 10             	mov    0x10(%eax),%eax
     bc7:	85 c0                	test   %eax,%eax
     bc9:	75 0a                	jne    bd5 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bd0:	e9 81 00 00 00       	jmp    c56 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bd5:	8b 45 08             	mov    0x8(%ebp),%eax
     bd8:	8b 00                	mov    (%eax),%eax
     bda:	89 04 24             	mov    %eax,(%esp)
     bdd:	e8 1e fa ff ff       	call   600 <kthread_mutex_lock>
     be2:	83 f8 ff             	cmp    $0xffffffff,%eax
     be5:	7d 07                	jge    bee <mesa_slots_monitor_addslots+0x33>
		return -1;
     be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bec:	eb 68                	jmp    c56 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     bee:	eb 17                	jmp    c07 <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     bf0:	8b 45 08             	mov    0x8(%ebp),%eax
     bf3:	8b 10                	mov    (%eax),%edx
     bf5:	8b 45 08             	mov    0x8(%ebp),%eax
     bf8:	8b 40 08             	mov    0x8(%eax),%eax
     bfb:	89 54 24 04          	mov    %edx,0x4(%esp)
     bff:	89 04 24             	mov    %eax,(%esp)
     c02:	e8 af 05 00 00       	call   11b6 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c07:	8b 45 08             	mov    0x8(%ebp),%eax
     c0a:	8b 40 10             	mov    0x10(%eax),%eax
     c0d:	85 c0                	test   %eax,%eax
     c0f:	74 0a                	je     c1b <mesa_slots_monitor_addslots+0x60>
     c11:	8b 45 08             	mov    0x8(%ebp),%eax
     c14:	8b 40 0c             	mov    0xc(%eax),%eax
     c17:	85 c0                	test   %eax,%eax
     c19:	7f d5                	jg     bf0 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     c1b:	8b 45 08             	mov    0x8(%ebp),%eax
     c1e:	8b 40 10             	mov    0x10(%eax),%eax
     c21:	85 c0                	test   %eax,%eax
     c23:	74 11                	je     c36 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     c25:	8b 45 08             	mov    0x8(%ebp),%eax
     c28:	8b 50 0c             	mov    0xc(%eax),%edx
     c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
     c2e:	01 c2                	add    %eax,%edx
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     c36:	8b 45 08             	mov    0x8(%ebp),%eax
     c39:	8b 40 04             	mov    0x4(%eax),%eax
     c3c:	89 04 24             	mov    %eax,(%esp)
     c3f:	e8 dc 05 00 00       	call   1220 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c44:	8b 45 08             	mov    0x8(%ebp),%eax
     c47:	8b 00                	mov    (%eax),%eax
     c49:	89 04 24             	mov    %eax,(%esp)
     c4c:	e8 b7 f9 ff ff       	call   608 <kthread_mutex_unlock>

	return 1;
     c51:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c56:	c9                   	leave  
     c57:	c3                   	ret    

00000c58 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     c58:	55                   	push   %ebp
     c59:	89 e5                	mov    %esp,%ebp
     c5b:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c5e:	8b 45 08             	mov    0x8(%ebp),%eax
     c61:	8b 40 10             	mov    0x10(%eax),%eax
     c64:	85 c0                	test   %eax,%eax
     c66:	75 07                	jne    c6f <mesa_slots_monitor_takeslot+0x17>
		return -1;
     c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c6d:	eb 7f                	jmp    cee <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c6f:	8b 45 08             	mov    0x8(%ebp),%eax
     c72:	8b 00                	mov    (%eax),%eax
     c74:	89 04 24             	mov    %eax,(%esp)
     c77:	e8 84 f9 ff ff       	call   600 <kthread_mutex_lock>
     c7c:	83 f8 ff             	cmp    $0xffffffff,%eax
     c7f:	7d 07                	jge    c88 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c86:	eb 66                	jmp    cee <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     c88:	eb 17                	jmp    ca1 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     c8a:	8b 45 08             	mov    0x8(%ebp),%eax
     c8d:	8b 10                	mov    (%eax),%edx
     c8f:	8b 45 08             	mov    0x8(%ebp),%eax
     c92:	8b 40 04             	mov    0x4(%eax),%eax
     c95:	89 54 24 04          	mov    %edx,0x4(%esp)
     c99:	89 04 24             	mov    %eax,(%esp)
     c9c:	e8 15 05 00 00       	call   11b6 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     ca1:	8b 45 08             	mov    0x8(%ebp),%eax
     ca4:	8b 40 10             	mov    0x10(%eax),%eax
     ca7:	85 c0                	test   %eax,%eax
     ca9:	74 0a                	je     cb5 <mesa_slots_monitor_takeslot+0x5d>
     cab:	8b 45 08             	mov    0x8(%ebp),%eax
     cae:	8b 40 0c             	mov    0xc(%eax),%eax
     cb1:	85 c0                	test   %eax,%eax
     cb3:	74 d5                	je     c8a <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     cb5:	8b 45 08             	mov    0x8(%ebp),%eax
     cb8:	8b 40 10             	mov    0x10(%eax),%eax
     cbb:	85 c0                	test   %eax,%eax
     cbd:	74 0f                	je     cce <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     cbf:	8b 45 08             	mov    0x8(%ebp),%eax
     cc2:	8b 40 0c             	mov    0xc(%eax),%eax
     cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
     cc8:	8b 45 08             	mov    0x8(%ebp),%eax
     ccb:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     cce:	8b 45 08             	mov    0x8(%ebp),%eax
     cd1:	8b 40 08             	mov    0x8(%eax),%eax
     cd4:	89 04 24             	mov    %eax,(%esp)
     cd7:	e8 44 05 00 00       	call   1220 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     cdc:	8b 45 08             	mov    0x8(%ebp),%eax
     cdf:	8b 00                	mov    (%eax),%eax
     ce1:	89 04 24             	mov    %eax,(%esp)
     ce4:	e8 1f f9 ff ff       	call   608 <kthread_mutex_unlock>

	return 1;
     ce9:	b8 01 00 00 00       	mov    $0x1,%eax

}
     cee:	c9                   	leave  
     cef:	c3                   	ret    

00000cf0 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     cf6:	8b 45 08             	mov    0x8(%ebp),%eax
     cf9:	8b 40 10             	mov    0x10(%eax),%eax
     cfc:	85 c0                	test   %eax,%eax
     cfe:	75 07                	jne    d07 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d05:	eb 35                	jmp    d3c <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	8b 00                	mov    (%eax),%eax
     d0c:	89 04 24             	mov    %eax,(%esp)
     d0f:	e8 ec f8 ff ff       	call   600 <kthread_mutex_lock>
     d14:	83 f8 ff             	cmp    $0xffffffff,%eax
     d17:	7d 07                	jge    d20 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d1e:	eb 1c                	jmp    d3c <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d20:	8b 45 08             	mov    0x8(%ebp),%eax
     d23:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d2a:	8b 45 08             	mov    0x8(%ebp),%eax
     d2d:	8b 00                	mov    (%eax),%eax
     d2f:	89 04 24             	mov    %eax,(%esp)
     d32:	e8 d1 f8 ff ff       	call   608 <kthread_mutex_unlock>

		return 0;
     d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d3c:	c9                   	leave  
     d3d:	c3                   	ret    

00000d3e <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     d3e:	55                   	push   %ebp
     d3f:	89 e5                	mov    %esp,%ebp
     d41:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     d44:	e8 a7 f8 ff ff       	call   5f0 <kthread_mutex_alloc>
     d49:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d50:	79 0a                	jns    d5c <hoare_slots_monitor_alloc+0x1e>
		return 0;
     d52:	b8 00 00 00 00       	mov    $0x0,%eax
     d57:	e9 8b 00 00 00       	jmp    de7 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     d5c:	e8 68 02 00 00       	call   fc9 <hoare_cond_alloc>
     d61:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d68:	75 12                	jne    d7c <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d6d:	89 04 24             	mov    %eax,(%esp)
     d70:	e8 83 f8 ff ff       	call   5f8 <kthread_mutex_dealloc>
		return 0;
     d75:	b8 00 00 00 00       	mov    $0x0,%eax
     d7a:	eb 6b                	jmp    de7 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     d7c:	e8 48 02 00 00       	call   fc9 <hoare_cond_alloc>
     d81:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     d84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d88:	75 1d                	jne    da7 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8d:	89 04 24             	mov    %eax,(%esp)
     d90:	e8 63 f8 ff ff       	call   5f8 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d98:	89 04 24             	mov    %eax,(%esp)
     d9b:	e8 6a 02 00 00       	call   100a <hoare_cond_dealloc>
		return 0;
     da0:	b8 00 00 00 00       	mov    $0x0,%eax
     da5:	eb 40                	jmp    de7 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     da7:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     dae:	e8 31 fc ff ff       	call   9e4 <malloc>
     db3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     db9:	8b 55 f0             	mov    -0x10(%ebp),%edx
     dbc:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
     dc5:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dce:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ddd:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     de4:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     de7:	c9                   	leave  
     de8:	c3                   	ret    

00000de9 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     de9:	55                   	push   %ebp
     dea:	89 e5                	mov    %esp,%ebp
     dec:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     def:	8b 45 08             	mov    0x8(%ebp),%eax
     df2:	8b 00                	mov    (%eax),%eax
     df4:	89 04 24             	mov    %eax,(%esp)
     df7:	e8 fc f7 ff ff       	call   5f8 <kthread_mutex_dealloc>
     dfc:	85 c0                	test   %eax,%eax
     dfe:	78 2e                	js     e2e <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     e00:	8b 45 08             	mov    0x8(%ebp),%eax
     e03:	8b 40 04             	mov    0x4(%eax),%eax
     e06:	89 04 24             	mov    %eax,(%esp)
     e09:	e8 bb 01 00 00       	call   fc9 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     e0e:	8b 45 08             	mov    0x8(%ebp),%eax
     e11:	8b 40 08             	mov    0x8(%eax),%eax
     e14:	89 04 24             	mov    %eax,(%esp)
     e17:	e8 ad 01 00 00       	call   fc9 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     e1c:	8b 45 08             	mov    0x8(%ebp),%eax
     e1f:	89 04 24             	mov    %eax,(%esp)
     e22:	e8 84 fa ff ff       	call   8ab <free>
	return 0;
     e27:	b8 00 00 00 00       	mov    $0x0,%eax
     e2c:	eb 05                	jmp    e33 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     e33:	c9                   	leave  
     e34:	c3                   	ret    

00000e35 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     e35:	55                   	push   %ebp
     e36:	89 e5                	mov    %esp,%ebp
     e38:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     e3b:	8b 45 08             	mov    0x8(%ebp),%eax
     e3e:	8b 40 10             	mov    0x10(%eax),%eax
     e41:	85 c0                	test   %eax,%eax
     e43:	75 0a                	jne    e4f <hoare_slots_monitor_addslots+0x1a>
		return -1;
     e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e4a:	e9 88 00 00 00       	jmp    ed7 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e4f:	8b 45 08             	mov    0x8(%ebp),%eax
     e52:	8b 00                	mov    (%eax),%eax
     e54:	89 04 24             	mov    %eax,(%esp)
     e57:	e8 a4 f7 ff ff       	call   600 <kthread_mutex_lock>
     e5c:	83 f8 ff             	cmp    $0xffffffff,%eax
     e5f:	7d 07                	jge    e68 <hoare_slots_monitor_addslots+0x33>
		return -1;
     e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e66:	eb 6f                	jmp    ed7 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     e68:	8b 45 08             	mov    0x8(%ebp),%eax
     e6b:	8b 40 10             	mov    0x10(%eax),%eax
     e6e:	85 c0                	test   %eax,%eax
     e70:	74 21                	je     e93 <hoare_slots_monitor_addslots+0x5e>
     e72:	8b 45 08             	mov    0x8(%ebp),%eax
     e75:	8b 40 0c             	mov    0xc(%eax),%eax
     e78:	85 c0                	test   %eax,%eax
     e7a:	7e 17                	jle    e93 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     e7c:	8b 45 08             	mov    0x8(%ebp),%eax
     e7f:	8b 10                	mov    (%eax),%edx
     e81:	8b 45 08             	mov    0x8(%ebp),%eax
     e84:	8b 40 08             	mov    0x8(%eax),%eax
     e87:	89 54 24 04          	mov    %edx,0x4(%esp)
     e8b:	89 04 24             	mov    %eax,(%esp)
     e8e:	e8 c1 01 00 00       	call   1054 <hoare_cond_wait>


	if  ( monitor->active)
     e93:	8b 45 08             	mov    0x8(%ebp),%eax
     e96:	8b 40 10             	mov    0x10(%eax),%eax
     e99:	85 c0                	test   %eax,%eax
     e9b:	74 11                	je     eae <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     e9d:	8b 45 08             	mov    0x8(%ebp),%eax
     ea0:	8b 50 0c             	mov    0xc(%eax),%edx
     ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea6:	01 c2                	add    %eax,%edx
     ea8:	8b 45 08             	mov    0x8(%ebp),%eax
     eab:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     eae:	8b 45 08             	mov    0x8(%ebp),%eax
     eb1:	8b 10                	mov    (%eax),%edx
     eb3:	8b 45 08             	mov    0x8(%ebp),%eax
     eb6:	8b 40 04             	mov    0x4(%eax),%eax
     eb9:	89 54 24 04          	mov    %edx,0x4(%esp)
     ebd:	89 04 24             	mov    %eax,(%esp)
     ec0:	e8 e6 01 00 00       	call   10ab <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ec5:	8b 45 08             	mov    0x8(%ebp),%eax
     ec8:	8b 00                	mov    (%eax),%eax
     eca:	89 04 24             	mov    %eax,(%esp)
     ecd:	e8 36 f7 ff ff       	call   608 <kthread_mutex_unlock>

	return 1;
     ed2:	b8 01 00 00 00       	mov    $0x1,%eax


}
     ed7:	c9                   	leave  
     ed8:	c3                   	ret    

00000ed9 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     ed9:	55                   	push   %ebp
     eda:	89 e5                	mov    %esp,%ebp
     edc:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     edf:	8b 45 08             	mov    0x8(%ebp),%eax
     ee2:	8b 40 10             	mov    0x10(%eax),%eax
     ee5:	85 c0                	test   %eax,%eax
     ee7:	75 0a                	jne    ef3 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eee:	e9 86 00 00 00       	jmp    f79 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ef3:	8b 45 08             	mov    0x8(%ebp),%eax
     ef6:	8b 00                	mov    (%eax),%eax
     ef8:	89 04 24             	mov    %eax,(%esp)
     efb:	e8 00 f7 ff ff       	call   600 <kthread_mutex_lock>
     f00:	83 f8 ff             	cmp    $0xffffffff,%eax
     f03:	7d 07                	jge    f0c <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f0a:	eb 6d                	jmp    f79 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f0c:	8b 45 08             	mov    0x8(%ebp),%eax
     f0f:	8b 40 10             	mov    0x10(%eax),%eax
     f12:	85 c0                	test   %eax,%eax
     f14:	74 21                	je     f37 <hoare_slots_monitor_takeslot+0x5e>
     f16:	8b 45 08             	mov    0x8(%ebp),%eax
     f19:	8b 40 0c             	mov    0xc(%eax),%eax
     f1c:	85 c0                	test   %eax,%eax
     f1e:	75 17                	jne    f37 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     f20:	8b 45 08             	mov    0x8(%ebp),%eax
     f23:	8b 10                	mov    (%eax),%edx
     f25:	8b 45 08             	mov    0x8(%ebp),%eax
     f28:	8b 40 04             	mov    0x4(%eax),%eax
     f2b:	89 54 24 04          	mov    %edx,0x4(%esp)
     f2f:	89 04 24             	mov    %eax,(%esp)
     f32:	e8 1d 01 00 00       	call   1054 <hoare_cond_wait>


	if  ( monitor->active)
     f37:	8b 45 08             	mov    0x8(%ebp),%eax
     f3a:	8b 40 10             	mov    0x10(%eax),%eax
     f3d:	85 c0                	test   %eax,%eax
     f3f:	74 0f                	je     f50 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     f41:	8b 45 08             	mov    0x8(%ebp),%eax
     f44:	8b 40 0c             	mov    0xc(%eax),%eax
     f47:	8d 50 ff             	lea    -0x1(%eax),%edx
     f4a:	8b 45 08             	mov    0x8(%ebp),%eax
     f4d:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     f50:	8b 45 08             	mov    0x8(%ebp),%eax
     f53:	8b 10                	mov    (%eax),%edx
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
     f58:	8b 40 08             	mov    0x8(%eax),%eax
     f5b:	89 54 24 04          	mov    %edx,0x4(%esp)
     f5f:	89 04 24             	mov    %eax,(%esp)
     f62:	e8 44 01 00 00       	call   10ab <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f67:	8b 45 08             	mov    0x8(%ebp),%eax
     f6a:	8b 00                	mov    (%eax),%eax
     f6c:	89 04 24             	mov    %eax,(%esp)
     f6f:	e8 94 f6 ff ff       	call   608 <kthread_mutex_unlock>

	return 1;
     f74:	b8 01 00 00 00       	mov    $0x1,%eax

}
     f79:	c9                   	leave  
     f7a:	c3                   	ret    

00000f7b <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     f7b:	55                   	push   %ebp
     f7c:	89 e5                	mov    %esp,%ebp
     f7e:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     f81:	8b 45 08             	mov    0x8(%ebp),%eax
     f84:	8b 40 10             	mov    0x10(%eax),%eax
     f87:	85 c0                	test   %eax,%eax
     f89:	75 07                	jne    f92 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f90:	eb 35                	jmp    fc7 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f92:	8b 45 08             	mov    0x8(%ebp),%eax
     f95:	8b 00                	mov    (%eax),%eax
     f97:	89 04 24             	mov    %eax,(%esp)
     f9a:	e8 61 f6 ff ff       	call   600 <kthread_mutex_lock>
     f9f:	83 f8 ff             	cmp    $0xffffffff,%eax
     fa2:	7d 07                	jge    fab <hoare_slots_monitor_stopadding+0x30>
			return -1;
     fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fa9:	eb 1c                	jmp    fc7 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     fab:	8b 45 08             	mov    0x8(%ebp),%eax
     fae:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     fb5:	8b 45 08             	mov    0x8(%ebp),%eax
     fb8:	8b 00                	mov    (%eax),%eax
     fba:	89 04 24             	mov    %eax,(%esp)
     fbd:	e8 46 f6 ff ff       	call   608 <kthread_mutex_unlock>

		return 0;
     fc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
     fc7:	c9                   	leave  
     fc8:	c3                   	ret    

00000fc9 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     fc9:	55                   	push   %ebp
     fca:	89 e5                	mov    %esp,%ebp
     fcc:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     fcf:	e8 1c f6 ff ff       	call   5f0 <kthread_mutex_alloc>
     fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fdb:	79 07                	jns    fe4 <hoare_cond_alloc+0x1b>
		return 0;
     fdd:	b8 00 00 00 00       	mov    $0x0,%eax
     fe2:	eb 24                	jmp    1008 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     fe4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     feb:	e8 f4 f9 ff ff       	call   9e4 <malloc>
     ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ff9:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1005:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1008:	c9                   	leave  
    1009:	c3                   	ret    

0000100a <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    1010:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1014:	75 07                	jne    101d <hoare_cond_dealloc+0x13>
			return -1;
    1016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    101b:	eb 35                	jmp    1052 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    101d:	8b 45 08             	mov    0x8(%ebp),%eax
    1020:	8b 00                	mov    (%eax),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 de f5 ff ff       	call   608 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    102a:	8b 45 08             	mov    0x8(%ebp),%eax
    102d:	8b 00                	mov    (%eax),%eax
    102f:	89 04 24             	mov    %eax,(%esp)
    1032:	e8 c1 f5 ff ff       	call   5f8 <kthread_mutex_dealloc>
    1037:	85 c0                	test   %eax,%eax
    1039:	79 07                	jns    1042 <hoare_cond_dealloc+0x38>
			return -1;
    103b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1040:	eb 10                	jmp    1052 <hoare_cond_dealloc+0x48>

		free (hCond);
    1042:	8b 45 08             	mov    0x8(%ebp),%eax
    1045:	89 04 24             	mov    %eax,(%esp)
    1048:	e8 5e f8 ff ff       	call   8ab <free>
		return 0;
    104d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1052:	c9                   	leave  
    1053:	c3                   	ret    

00001054 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    1054:	55                   	push   %ebp
    1055:	89 e5                	mov    %esp,%ebp
    1057:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    105a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    105e:	75 07                	jne    1067 <hoare_cond_wait+0x13>
			return -1;
    1060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1065:	eb 42                	jmp    10a9 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    1067:	8b 45 08             	mov    0x8(%ebp),%eax
    106a:	8b 40 04             	mov    0x4(%eax),%eax
    106d:	8d 50 01             	lea    0x1(%eax),%edx
    1070:	8b 45 08             	mov    0x8(%ebp),%eax
    1073:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    1076:	8b 45 08             	mov    0x8(%ebp),%eax
    1079:	8b 00                	mov    (%eax),%eax
    107b:	89 44 24 04          	mov    %eax,0x4(%esp)
    107f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1082:	89 04 24             	mov    %eax,(%esp)
    1085:	e8 86 f5 ff ff       	call   610 <kthread_mutex_yieldlock>
    108a:	85 c0                	test   %eax,%eax
    108c:	79 16                	jns    10a4 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    108e:	8b 45 08             	mov    0x8(%ebp),%eax
    1091:	8b 40 04             	mov    0x4(%eax),%eax
    1094:	8d 50 ff             	lea    -0x1(%eax),%edx
    1097:	8b 45 08             	mov    0x8(%ebp),%eax
    109a:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    109d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10a2:	eb 05                	jmp    10a9 <hoare_cond_wait+0x55>
		}

	return 0;
    10a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10a9:	c9                   	leave  
    10aa:	c3                   	ret    

000010ab <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    10ab:	55                   	push   %ebp
    10ac:	89 e5                	mov    %esp,%ebp
    10ae:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10b5:	75 07                	jne    10be <hoare_cond_signal+0x13>
		return -1;
    10b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10bc:	eb 6b                	jmp    1129 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    10be:	8b 45 08             	mov    0x8(%ebp),%eax
    10c1:	8b 40 04             	mov    0x4(%eax),%eax
    10c4:	85 c0                	test   %eax,%eax
    10c6:	7e 3d                	jle    1105 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	8b 40 04             	mov    0x4(%eax),%eax
    10ce:	8d 50 ff             	lea    -0x1(%eax),%edx
    10d1:	8b 45 08             	mov    0x8(%ebp),%eax
    10d4:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    10d7:	8b 45 08             	mov    0x8(%ebp),%eax
    10da:	8b 00                	mov    (%eax),%eax
    10dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e3:	89 04 24             	mov    %eax,(%esp)
    10e6:	e8 25 f5 ff ff       	call   610 <kthread_mutex_yieldlock>
    10eb:	85 c0                	test   %eax,%eax
    10ed:	79 16                	jns    1105 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    10ef:	8b 45 08             	mov    0x8(%ebp),%eax
    10f2:	8b 40 04             	mov    0x4(%eax),%eax
    10f5:	8d 50 01             	lea    0x1(%eax),%edx
    10f8:	8b 45 08             	mov    0x8(%ebp),%eax
    10fb:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    10fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1103:	eb 24                	jmp    1129 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1105:	8b 45 08             	mov    0x8(%ebp),%eax
    1108:	8b 00                	mov    (%eax),%eax
    110a:	89 44 24 04          	mov    %eax,0x4(%esp)
    110e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	e8 f7 f4 ff ff       	call   610 <kthread_mutex_yieldlock>
    1119:	85 c0                	test   %eax,%eax
    111b:	79 07                	jns    1124 <hoare_cond_signal+0x79>

    			return -1;
    111d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1122:	eb 05                	jmp    1129 <hoare_cond_signal+0x7e>
    }

	return 0;
    1124:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1129:	c9                   	leave  
    112a:	c3                   	ret    

0000112b <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    112b:	55                   	push   %ebp
    112c:	89 e5                	mov    %esp,%ebp
    112e:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1131:	e8 ba f4 ff ff       	call   5f0 <kthread_mutex_alloc>
    1136:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    113d:	79 07                	jns    1146 <mesa_cond_alloc+0x1b>
		return 0;
    113f:	b8 00 00 00 00       	mov    $0x0,%eax
    1144:	eb 24                	jmp    116a <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1146:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    114d:	e8 92 f8 ff ff       	call   9e4 <malloc>
    1152:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1155:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1158:	8b 55 f4             	mov    -0xc(%ebp),%edx
    115b:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    115d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1167:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    116a:	c9                   	leave  
    116b:	c3                   	ret    

0000116c <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    116c:	55                   	push   %ebp
    116d:	89 e5                	mov    %esp,%ebp
    116f:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    1172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1176:	75 07                	jne    117f <mesa_cond_dealloc+0x13>
		return -1;
    1178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    117d:	eb 35                	jmp    11b4 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    117f:	8b 45 08             	mov    0x8(%ebp),%eax
    1182:	8b 00                	mov    (%eax),%eax
    1184:	89 04 24             	mov    %eax,(%esp)
    1187:	e8 7c f4 ff ff       	call   608 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    118c:	8b 45 08             	mov    0x8(%ebp),%eax
    118f:	8b 00                	mov    (%eax),%eax
    1191:	89 04 24             	mov    %eax,(%esp)
    1194:	e8 5f f4 ff ff       	call   5f8 <kthread_mutex_dealloc>
    1199:	85 c0                	test   %eax,%eax
    119b:	79 07                	jns    11a4 <mesa_cond_dealloc+0x38>
		return -1;
    119d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11a2:	eb 10                	jmp    11b4 <mesa_cond_dealloc+0x48>

	free (mCond);
    11a4:	8b 45 08             	mov    0x8(%ebp),%eax
    11a7:	89 04 24             	mov    %eax,(%esp)
    11aa:	e8 fc f6 ff ff       	call   8ab <free>
	return 0;
    11af:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11b4:	c9                   	leave  
    11b5:	c3                   	ret    

000011b6 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    11b6:	55                   	push   %ebp
    11b7:	89 e5                	mov    %esp,%ebp
    11b9:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    11bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    11c0:	75 07                	jne    11c9 <mesa_cond_wait+0x13>
		return -1;
    11c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c7:	eb 55                	jmp    121e <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    11c9:	8b 45 08             	mov    0x8(%ebp),%eax
    11cc:	8b 40 04             	mov    0x4(%eax),%eax
    11cf:	8d 50 01             	lea    0x1(%eax),%edx
    11d2:	8b 45 08             	mov    0x8(%ebp),%eax
    11d5:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    11d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11db:	89 04 24             	mov    %eax,(%esp)
    11de:	e8 25 f4 ff ff       	call   608 <kthread_mutex_unlock>
    11e3:	85 c0                	test   %eax,%eax
    11e5:	79 27                	jns    120e <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	8b 00                	mov    (%eax),%eax
    11ec:	89 04 24             	mov    %eax,(%esp)
    11ef:	e8 0c f4 ff ff       	call   600 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    11f4:	85 c0                	test   %eax,%eax
    11f6:	79 16                	jns    120e <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    11f8:	8b 45 08             	mov    0x8(%ebp),%eax
    11fb:	8b 40 04             	mov    0x4(%eax),%eax
    11fe:	8d 50 ff             	lea    -0x1(%eax),%edx
    1201:	8b 45 08             	mov    0x8(%ebp),%eax
    1204:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    1207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    120c:	eb 10                	jmp    121e <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    120e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1211:	89 04 24             	mov    %eax,(%esp)
    1214:	e8 e7 f3 ff ff       	call   600 <kthread_mutex_lock>
	return 0;
    1219:	b8 00 00 00 00       	mov    $0x0,%eax


}
    121e:	c9                   	leave  
    121f:	c3                   	ret    

00001220 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    122a:	75 07                	jne    1233 <mesa_cond_signal+0x13>
		return -1;
    122c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1231:	eb 5d                	jmp    1290 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	8b 40 04             	mov    0x4(%eax),%eax
    1239:	85 c0                	test   %eax,%eax
    123b:	7e 36                	jle    1273 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    123d:	8b 45 08             	mov    0x8(%ebp),%eax
    1240:	8b 40 04             	mov    0x4(%eax),%eax
    1243:	8d 50 ff             	lea    -0x1(%eax),%edx
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
    1249:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	8b 00                	mov    (%eax),%eax
    1251:	89 04 24             	mov    %eax,(%esp)
    1254:	e8 af f3 ff ff       	call   608 <kthread_mutex_unlock>
    1259:	85 c0                	test   %eax,%eax
    125b:	78 16                	js     1273 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    125d:	8b 45 08             	mov    0x8(%ebp),%eax
    1260:	8b 40 04             	mov    0x4(%eax),%eax
    1263:	8d 50 01             	lea    0x1(%eax),%edx
    1266:	8b 45 08             	mov    0x8(%ebp),%eax
    1269:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    126c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1271:	eb 1d                	jmp    1290 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1273:	8b 45 08             	mov    0x8(%ebp),%eax
    1276:	8b 00                	mov    (%eax),%eax
    1278:	89 04 24             	mov    %eax,(%esp)
    127b:	e8 88 f3 ff ff       	call   608 <kthread_mutex_unlock>
    1280:	85 c0                	test   %eax,%eax
    1282:	79 07                	jns    128b <mesa_cond_signal+0x6b>

		return -1;
    1284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1289:	eb 05                	jmp    1290 <mesa_cond_signal+0x70>
	}
	return 0;
    128b:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1290:	c9                   	leave  
    1291:	c3                   	ret    
