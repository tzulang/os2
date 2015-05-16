
_t:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:

    static char *echoargv[0];

    void
    foo()
    {
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
      while (other_tid == 0){
       6:	90                   	nop
       7:	a1 00 17 00 00       	mov    0x1700,%eax
       c:	85 c0                	test   %eax,%eax
       e:	74 f7                	je     7 <foo+0x7>

      };
      kthread_join(other_tid);
      10:	a1 00 17 00 00       	mov    0x1700,%eax
      15:	89 04 24             	mov    %eax,(%esp)
      18:	e8 97 04 00 00       	call   4b4 <kthread_join>
      printf(1, "Foo exiting because goo finished running\n");
      1d:	c7 44 24 04 60 11 00 	movl   $0x1160,0x4(%esp)
      24:	00 
      25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      2c:	e8 93 05 00 00       	call   5c4 <printf>
      kthread_exit();
      31:	e8 76 04 00 00       	call   4ac <kthread_exit>
    }
      36:	c9                   	leave  
      37:	c3                   	ret    

00000038 <goo>:

    void
    goo()
    {
      38:	55                   	push   %ebp
      39:	89 e5                	mov    %esp,%ebp
      3b:	83 ec 28             	sub    $0x28,%esp
      int i,z=0 ;
      3e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      z++;
      45:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      other_tid = kthread_id();
      49:	e8 56 04 00 00       	call   4a4 <kthread_id>
      4e:	a3 00 17 00 00       	mov    %eax,0x1700
      printf(1, "Starting goo! my tid : %d \n ", other_tid);
      53:	a1 00 17 00 00       	mov    0x1700,%eax
      58:	89 44 24 08          	mov    %eax,0x8(%esp)
      5c:	c7 44 24 04 8a 11 00 	movl   $0x118a,0x4(%esp)
      63:	00 
      64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      6b:	e8 54 05 00 00       	call   5c4 <printf>
      for (i = 0 ; i < 999999 ; i++){
      70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      77:	eb 0b                	jmp    84 <goo+0x4c>
        z = 9999999 ^ 3231;
      79:	c7 45 f0 e0 9a 98 00 	movl   $0x989ae0,-0x10(%ebp)
    {
      int i,z=0 ;
      z++;
      other_tid = kthread_id();
      printf(1, "Starting goo! my tid : %d \n ", other_tid);
      for (i = 0 ; i < 999999 ; i++){
      80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      84:	81 7d f4 3e 42 0f 00 	cmpl   $0xf423e,-0xc(%ebp)
      8b:	7e ec                	jle    79 <goo+0x41>
        z = 9999999 ^ 3231;
      }
      printf(1, "goo finished calculating, exiting!\n");
      8d:	c7 44 24 04 a8 11 00 	movl   $0x11a8,0x4(%esp)
      94:	00 
      95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      9c:	e8 23 05 00 00       	call   5c4 <printf>
      exec("ls", echoargv);
      a1:	c7 44 24 04 04 17 00 	movl   $0x1704,0x4(%esp)
      a8:	00 
      a9:	c7 04 24 cc 11 00 00 	movl   $0x11cc,(%esp)
      b0:	e8 7f 03 00 00       	call   434 <exec>
      kthread_exit();
      b5:	e8 f2 03 00 00       	call   4ac <kthread_exit>
    }
      ba:	c9                   	leave  
      bb:	c3                   	ret    

000000bc <main>:

    int
    main(int argc, char *argv[])
    {
      bc:	55                   	push   %ebp
      bd:	89 e5                	mov    %esp,%ebp
      bf:	53                   	push   %ebx
      c0:	83 e4 f0             	and    $0xfffffff0,%esp
      c3:	83 ec 20             	sub    $0x20,%esp
      int i;
      int b=0;
      c6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
      cd:	00 
      b++;
      ce:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
      printf(1, "This is main pid :  %d , this is main tid: %d \n", getpid(), kthread_id());
      d3:	e8 cc 03 00 00       	call   4a4 <kthread_id>
      d8:	89 c3                	mov    %eax,%ebx
      da:	e8 9d 03 00 00       	call   47c <getpid>
      df:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
      e3:	89 44 24 08          	mov    %eax,0x8(%esp)
      e7:	c7 44 24 04 d0 11 00 	movl   $0x11d0,0x4(%esp)
      ee:	00 
      ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      f6:	e8 c9 04 00 00       	call   5c4 <printf>


      kthread_create(goo, malloc(4000), 4000);
      fb:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
     102:	e8 a9 07 00 00       	call   8b0 <malloc>
     107:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     10e:	00 
     10f:	89 44 24 04          	mov    %eax,0x4(%esp)
     113:	c7 04 24 38 00 00 00 	movl   $0x38,(%esp)
     11a:	e8 7d 03 00 00       	call   49c <kthread_create>
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
     11f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     126:	00 
     127:	eb 0d                	jmp    136 <main+0x7a>
     129:	c7 44 24 18 1b a1 07 	movl   $0x7a11b,0x18(%esp)
     130:	00 
     131:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     136:	81 7c 24 1c 9e 86 01 	cmpl   $0x1869e,0x1c(%esp)
     13d:	00 
     13e:	7e e9                	jle    129 <main+0x6d>
      kthread_create(foo, malloc(4000), 4000);
     140:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
     147:	e8 64 07 00 00       	call   8b0 <malloc>
     14c:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
     153:	00 
     154:	89 44 24 04          	mov    %eax,0x4(%esp)
     158:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     15f:	e8 38 03 00 00       	call   49c <kthread_create>
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
     164:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     16b:	00 
     16c:	eb 0d                	jmp    17b <main+0xbf>
     16e:	c7 44 24 18 1b a1 07 	movl   $0x7a11b,0x18(%esp)
     175:	00 
     176:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     17b:	81 7c 24 1c 9e 86 01 	cmpl   $0x1869e,0x1c(%esp)
     182:	00 
     183:	7e e9                	jle    16e <main+0xb2>
      kthread_exit();
     185:	e8 22 03 00 00       	call   4ac <kthread_exit>
      return 0;
     18a:	b8 00 00 00 00       	mov    $0x0,%eax
    }
     18f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     192:	c9                   	leave  
     193:	c3                   	ret    

00000194 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     194:	55                   	push   %ebp
     195:	89 e5                	mov    %esp,%ebp
     197:	57                   	push   %edi
     198:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     199:	8b 4d 08             	mov    0x8(%ebp),%ecx
     19c:	8b 55 10             	mov    0x10(%ebp),%edx
     19f:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a2:	89 cb                	mov    %ecx,%ebx
     1a4:	89 df                	mov    %ebx,%edi
     1a6:	89 d1                	mov    %edx,%ecx
     1a8:	fc                   	cld    
     1a9:	f3 aa                	rep stos %al,%es:(%edi)
     1ab:	89 ca                	mov    %ecx,%edx
     1ad:	89 fb                	mov    %edi,%ebx
     1af:	89 5d 08             	mov    %ebx,0x8(%ebp)
     1b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     1b5:	5b                   	pop    %ebx
     1b6:	5f                   	pop    %edi
     1b7:	5d                   	pop    %ebp
     1b8:	c3                   	ret    

000001b9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     1b9:	55                   	push   %ebp
     1ba:	89 e5                	mov    %esp,%ebp
     1bc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     1bf:	8b 45 08             	mov    0x8(%ebp),%eax
     1c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     1c5:	90                   	nop
     1c6:	8b 45 08             	mov    0x8(%ebp),%eax
     1c9:	8d 50 01             	lea    0x1(%eax),%edx
     1cc:	89 55 08             	mov    %edx,0x8(%ebp)
     1cf:	8b 55 0c             	mov    0xc(%ebp),%edx
     1d2:	8d 4a 01             	lea    0x1(%edx),%ecx
     1d5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     1d8:	0f b6 12             	movzbl (%edx),%edx
     1db:	88 10                	mov    %dl,(%eax)
     1dd:	0f b6 00             	movzbl (%eax),%eax
     1e0:	84 c0                	test   %al,%al
     1e2:	75 e2                	jne    1c6 <strcpy+0xd>
    ;
  return os;
     1e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     1e7:	c9                   	leave  
     1e8:	c3                   	ret    

000001e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     1e9:	55                   	push   %ebp
     1ea:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     1ec:	eb 08                	jmp    1f6 <strcmp+0xd>
    p++, q++;
     1ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     1f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	0f b6 00             	movzbl (%eax),%eax
     1fc:	84 c0                	test   %al,%al
     1fe:	74 10                	je     210 <strcmp+0x27>
     200:	8b 45 08             	mov    0x8(%ebp),%eax
     203:	0f b6 10             	movzbl (%eax),%edx
     206:	8b 45 0c             	mov    0xc(%ebp),%eax
     209:	0f b6 00             	movzbl (%eax),%eax
     20c:	38 c2                	cmp    %al,%dl
     20e:	74 de                	je     1ee <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     210:	8b 45 08             	mov    0x8(%ebp),%eax
     213:	0f b6 00             	movzbl (%eax),%eax
     216:	0f b6 d0             	movzbl %al,%edx
     219:	8b 45 0c             	mov    0xc(%ebp),%eax
     21c:	0f b6 00             	movzbl (%eax),%eax
     21f:	0f b6 c0             	movzbl %al,%eax
     222:	29 c2                	sub    %eax,%edx
     224:	89 d0                	mov    %edx,%eax
}
     226:	5d                   	pop    %ebp
     227:	c3                   	ret    

00000228 <strlen>:

uint
strlen(char *s)
{
     228:	55                   	push   %ebp
     229:	89 e5                	mov    %esp,%ebp
     22b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     22e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     235:	eb 04                	jmp    23b <strlen+0x13>
     237:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     23b:	8b 55 fc             	mov    -0x4(%ebp),%edx
     23e:	8b 45 08             	mov    0x8(%ebp),%eax
     241:	01 d0                	add    %edx,%eax
     243:	0f b6 00             	movzbl (%eax),%eax
     246:	84 c0                	test   %al,%al
     248:	75 ed                	jne    237 <strlen+0xf>
    ;
  return n;
     24a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     24d:	c9                   	leave  
     24e:	c3                   	ret    

0000024f <memset>:

void*
memset(void *dst, int c, uint n)
{
     24f:	55                   	push   %ebp
     250:	89 e5                	mov    %esp,%ebp
     252:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     255:	8b 45 10             	mov    0x10(%ebp),%eax
     258:	89 44 24 08          	mov    %eax,0x8(%esp)
     25c:	8b 45 0c             	mov    0xc(%ebp),%eax
     25f:	89 44 24 04          	mov    %eax,0x4(%esp)
     263:	8b 45 08             	mov    0x8(%ebp),%eax
     266:	89 04 24             	mov    %eax,(%esp)
     269:	e8 26 ff ff ff       	call   194 <stosb>
  return dst;
     26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     271:	c9                   	leave  
     272:	c3                   	ret    

00000273 <strchr>:

char*
strchr(const char *s, char c)
{
     273:	55                   	push   %ebp
     274:	89 e5                	mov    %esp,%ebp
     276:	83 ec 04             	sub    $0x4,%esp
     279:	8b 45 0c             	mov    0xc(%ebp),%eax
     27c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     27f:	eb 14                	jmp    295 <strchr+0x22>
    if(*s == c)
     281:	8b 45 08             	mov    0x8(%ebp),%eax
     284:	0f b6 00             	movzbl (%eax),%eax
     287:	3a 45 fc             	cmp    -0x4(%ebp),%al
     28a:	75 05                	jne    291 <strchr+0x1e>
      return (char*)s;
     28c:	8b 45 08             	mov    0x8(%ebp),%eax
     28f:	eb 13                	jmp    2a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     295:	8b 45 08             	mov    0x8(%ebp),%eax
     298:	0f b6 00             	movzbl (%eax),%eax
     29b:	84 c0                	test   %al,%al
     29d:	75 e2                	jne    281 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     29f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2a4:	c9                   	leave  
     2a5:	c3                   	ret    

000002a6 <gets>:

char*
gets(char *buf, int max)
{
     2a6:	55                   	push   %ebp
     2a7:	89 e5                	mov    %esp,%ebp
     2a9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     2ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     2b3:	eb 4c                	jmp    301 <gets+0x5b>
    cc = read(0, &c, 1);
     2b5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     2bc:	00 
     2bd:	8d 45 ef             	lea    -0x11(%ebp),%eax
     2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
     2c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2cb:	e8 44 01 00 00       	call   414 <read>
     2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     2d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2d7:	7f 02                	jg     2db <gets+0x35>
      break;
     2d9:	eb 31                	jmp    30c <gets+0x66>
    buf[i++] = c;
     2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2de:	8d 50 01             	lea    0x1(%eax),%edx
     2e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
     2e4:	89 c2                	mov    %eax,%edx
     2e6:	8b 45 08             	mov    0x8(%ebp),%eax
     2e9:	01 c2                	add    %eax,%edx
     2eb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     2ef:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     2f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     2f5:	3c 0a                	cmp    $0xa,%al
     2f7:	74 13                	je     30c <gets+0x66>
     2f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     2fd:	3c 0d                	cmp    $0xd,%al
     2ff:	74 0b                	je     30c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     301:	8b 45 f4             	mov    -0xc(%ebp),%eax
     304:	83 c0 01             	add    $0x1,%eax
     307:	3b 45 0c             	cmp    0xc(%ebp),%eax
     30a:	7c a9                	jl     2b5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     30c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     30f:	8b 45 08             	mov    0x8(%ebp),%eax
     312:	01 d0                	add    %edx,%eax
     314:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     317:	8b 45 08             	mov    0x8(%ebp),%eax
}
     31a:	c9                   	leave  
     31b:	c3                   	ret    

0000031c <stat>:

int
stat(char *n, struct stat *st)
{
     31c:	55                   	push   %ebp
     31d:	89 e5                	mov    %esp,%ebp
     31f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     329:	00 
     32a:	8b 45 08             	mov    0x8(%ebp),%eax
     32d:	89 04 24             	mov    %eax,(%esp)
     330:	e8 07 01 00 00       	call   43c <open>
     335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33c:	79 07                	jns    345 <stat+0x29>
    return -1;
     33e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     343:	eb 23                	jmp    368 <stat+0x4c>
  r = fstat(fd, st);
     345:	8b 45 0c             	mov    0xc(%ebp),%eax
     348:	89 44 24 04          	mov    %eax,0x4(%esp)
     34c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     34f:	89 04 24             	mov    %eax,(%esp)
     352:	e8 fd 00 00 00       	call   454 <fstat>
     357:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     35a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     35d:	89 04 24             	mov    %eax,(%esp)
     360:	e8 bf 00 00 00       	call   424 <close>
  return r;
     365:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     368:	c9                   	leave  
     369:	c3                   	ret    

0000036a <atoi>:

int
atoi(const char *s)
{
     36a:	55                   	push   %ebp
     36b:	89 e5                	mov    %esp,%ebp
     36d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     377:	eb 25                	jmp    39e <atoi+0x34>
    n = n*10 + *s++ - '0';
     379:	8b 55 fc             	mov    -0x4(%ebp),%edx
     37c:	89 d0                	mov    %edx,%eax
     37e:	c1 e0 02             	shl    $0x2,%eax
     381:	01 d0                	add    %edx,%eax
     383:	01 c0                	add    %eax,%eax
     385:	89 c1                	mov    %eax,%ecx
     387:	8b 45 08             	mov    0x8(%ebp),%eax
     38a:	8d 50 01             	lea    0x1(%eax),%edx
     38d:	89 55 08             	mov    %edx,0x8(%ebp)
     390:	0f b6 00             	movzbl (%eax),%eax
     393:	0f be c0             	movsbl %al,%eax
     396:	01 c8                	add    %ecx,%eax
     398:	83 e8 30             	sub    $0x30,%eax
     39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     39e:	8b 45 08             	mov    0x8(%ebp),%eax
     3a1:	0f b6 00             	movzbl (%eax),%eax
     3a4:	3c 2f                	cmp    $0x2f,%al
     3a6:	7e 0a                	jle    3b2 <atoi+0x48>
     3a8:	8b 45 08             	mov    0x8(%ebp),%eax
     3ab:	0f b6 00             	movzbl (%eax),%eax
     3ae:	3c 39                	cmp    $0x39,%al
     3b0:	7e c7                	jle    379 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     3b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3b5:	c9                   	leave  
     3b6:	c3                   	ret    

000003b7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     3b7:	55                   	push   %ebp
     3b8:	89 e5                	mov    %esp,%ebp
     3ba:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
     3c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     3c9:	eb 17                	jmp    3e2 <memmove+0x2b>
    *dst++ = *src++;
     3cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     3ce:	8d 50 01             	lea    0x1(%eax),%edx
     3d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
     3d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
     3d7:	8d 4a 01             	lea    0x1(%edx),%ecx
     3da:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     3dd:	0f b6 12             	movzbl (%edx),%edx
     3e0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     3e2:	8b 45 10             	mov    0x10(%ebp),%eax
     3e5:	8d 50 ff             	lea    -0x1(%eax),%edx
     3e8:	89 55 10             	mov    %edx,0x10(%ebp)
     3eb:	85 c0                	test   %eax,%eax
     3ed:	7f dc                	jg     3cb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     3ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
     3f2:	c9                   	leave  
     3f3:	c3                   	ret    

000003f4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     3f4:	b8 01 00 00 00       	mov    $0x1,%eax
     3f9:	cd 40                	int    $0x40
     3fb:	c3                   	ret    

000003fc <exit>:
SYSCALL(exit)
     3fc:	b8 02 00 00 00       	mov    $0x2,%eax
     401:	cd 40                	int    $0x40
     403:	c3                   	ret    

00000404 <wait>:
SYSCALL(wait)
     404:	b8 03 00 00 00       	mov    $0x3,%eax
     409:	cd 40                	int    $0x40
     40b:	c3                   	ret    

0000040c <pipe>:
SYSCALL(pipe)
     40c:	b8 04 00 00 00       	mov    $0x4,%eax
     411:	cd 40                	int    $0x40
     413:	c3                   	ret    

00000414 <read>:
SYSCALL(read)
     414:	b8 05 00 00 00       	mov    $0x5,%eax
     419:	cd 40                	int    $0x40
     41b:	c3                   	ret    

0000041c <write>:
SYSCALL(write)
     41c:	b8 10 00 00 00       	mov    $0x10,%eax
     421:	cd 40                	int    $0x40
     423:	c3                   	ret    

00000424 <close>:
SYSCALL(close)
     424:	b8 15 00 00 00       	mov    $0x15,%eax
     429:	cd 40                	int    $0x40
     42b:	c3                   	ret    

0000042c <kill>:
SYSCALL(kill)
     42c:	b8 06 00 00 00       	mov    $0x6,%eax
     431:	cd 40                	int    $0x40
     433:	c3                   	ret    

00000434 <exec>:
SYSCALL(exec)
     434:	b8 07 00 00 00       	mov    $0x7,%eax
     439:	cd 40                	int    $0x40
     43b:	c3                   	ret    

0000043c <open>:
SYSCALL(open)
     43c:	b8 0f 00 00 00       	mov    $0xf,%eax
     441:	cd 40                	int    $0x40
     443:	c3                   	ret    

00000444 <mknod>:
SYSCALL(mknod)
     444:	b8 11 00 00 00       	mov    $0x11,%eax
     449:	cd 40                	int    $0x40
     44b:	c3                   	ret    

0000044c <unlink>:
SYSCALL(unlink)
     44c:	b8 12 00 00 00       	mov    $0x12,%eax
     451:	cd 40                	int    $0x40
     453:	c3                   	ret    

00000454 <fstat>:
SYSCALL(fstat)
     454:	b8 08 00 00 00       	mov    $0x8,%eax
     459:	cd 40                	int    $0x40
     45b:	c3                   	ret    

0000045c <link>:
SYSCALL(link)
     45c:	b8 13 00 00 00       	mov    $0x13,%eax
     461:	cd 40                	int    $0x40
     463:	c3                   	ret    

00000464 <mkdir>:
SYSCALL(mkdir)
     464:	b8 14 00 00 00       	mov    $0x14,%eax
     469:	cd 40                	int    $0x40
     46b:	c3                   	ret    

0000046c <chdir>:
SYSCALL(chdir)
     46c:	b8 09 00 00 00       	mov    $0x9,%eax
     471:	cd 40                	int    $0x40
     473:	c3                   	ret    

00000474 <dup>:
SYSCALL(dup)
     474:	b8 0a 00 00 00       	mov    $0xa,%eax
     479:	cd 40                	int    $0x40
     47b:	c3                   	ret    

0000047c <getpid>:
SYSCALL(getpid)
     47c:	b8 0b 00 00 00       	mov    $0xb,%eax
     481:	cd 40                	int    $0x40
     483:	c3                   	ret    

00000484 <sbrk>:
SYSCALL(sbrk)
     484:	b8 0c 00 00 00       	mov    $0xc,%eax
     489:	cd 40                	int    $0x40
     48b:	c3                   	ret    

0000048c <sleep>:
SYSCALL(sleep)
     48c:	b8 0d 00 00 00       	mov    $0xd,%eax
     491:	cd 40                	int    $0x40
     493:	c3                   	ret    

00000494 <uptime>:
SYSCALL(uptime)
     494:	b8 0e 00 00 00       	mov    $0xe,%eax
     499:	cd 40                	int    $0x40
     49b:	c3                   	ret    

0000049c <kthread_create>:




SYSCALL(kthread_create)
     49c:	b8 16 00 00 00       	mov    $0x16,%eax
     4a1:	cd 40                	int    $0x40
     4a3:	c3                   	ret    

000004a4 <kthread_id>:
SYSCALL(kthread_id)
     4a4:	b8 17 00 00 00       	mov    $0x17,%eax
     4a9:	cd 40                	int    $0x40
     4ab:	c3                   	ret    

000004ac <kthread_exit>:
SYSCALL(kthread_exit)
     4ac:	b8 18 00 00 00       	mov    $0x18,%eax
     4b1:	cd 40                	int    $0x40
     4b3:	c3                   	ret    

000004b4 <kthread_join>:
SYSCALL(kthread_join)
     4b4:	b8 19 00 00 00       	mov    $0x19,%eax
     4b9:	cd 40                	int    $0x40
     4bb:	c3                   	ret    

000004bc <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     4bc:	b8 1a 00 00 00       	mov    $0x1a,%eax
     4c1:	cd 40                	int    $0x40
     4c3:	c3                   	ret    

000004c4 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     4c4:	b8 1b 00 00 00       	mov    $0x1b,%eax
     4c9:	cd 40                	int    $0x40
     4cb:	c3                   	ret    

000004cc <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     4cc:	b8 1c 00 00 00       	mov    $0x1c,%eax
     4d1:	cd 40                	int    $0x40
     4d3:	c3                   	ret    

000004d4 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     4d4:	b8 1d 00 00 00       	mov    $0x1d,%eax
     4d9:	cd 40                	int    $0x40
     4db:	c3                   	ret    

000004dc <kthread_mutex_yieldlock>:
     4dc:	b8 1e 00 00 00       	mov    $0x1e,%eax
     4e1:	cd 40                	int    $0x40
     4e3:	c3                   	ret    

000004e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     4e4:	55                   	push   %ebp
     4e5:	89 e5                	mov    %esp,%ebp
     4e7:	83 ec 18             	sub    $0x18,%esp
     4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
     4ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     4f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     4f7:	00 
     4f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
     4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
     4ff:	8b 45 08             	mov    0x8(%ebp),%eax
     502:	89 04 24             	mov    %eax,(%esp)
     505:	e8 12 ff ff ff       	call   41c <write>
}
     50a:	c9                   	leave  
     50b:	c3                   	ret    

0000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     50c:	55                   	push   %ebp
     50d:	89 e5                	mov    %esp,%ebp
     50f:	56                   	push   %esi
     510:	53                   	push   %ebx
     511:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     51b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     51f:	74 17                	je     538 <printint+0x2c>
     521:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     525:	79 11                	jns    538 <printint+0x2c>
    neg = 1;
     527:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     52e:	8b 45 0c             	mov    0xc(%ebp),%eax
     531:	f7 d8                	neg    %eax
     533:	89 45 ec             	mov    %eax,-0x14(%ebp)
     536:	eb 06                	jmp    53e <printint+0x32>
  } else {
    x = xx;
     538:	8b 45 0c             	mov    0xc(%ebp),%eax
     53b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     53e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     545:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     548:	8d 41 01             	lea    0x1(%ecx),%eax
     54b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     54e:	8b 5d 10             	mov    0x10(%ebp),%ebx
     551:	8b 45 ec             	mov    -0x14(%ebp),%eax
     554:	ba 00 00 00 00       	mov    $0x0,%edx
     559:	f7 f3                	div    %ebx
     55b:	89 d0                	mov    %edx,%eax
     55d:	0f b6 80 d4 16 00 00 	movzbl 0x16d4(%eax),%eax
     564:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     568:	8b 75 10             	mov    0x10(%ebp),%esi
     56b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     56e:	ba 00 00 00 00       	mov    $0x0,%edx
     573:	f7 f6                	div    %esi
     575:	89 45 ec             	mov    %eax,-0x14(%ebp)
     578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     57c:	75 c7                	jne    545 <printint+0x39>
  if(neg)
     57e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     582:	74 10                	je     594 <printint+0x88>
    buf[i++] = '-';
     584:	8b 45 f4             	mov    -0xc(%ebp),%eax
     587:	8d 50 01             	lea    0x1(%eax),%edx
     58a:	89 55 f4             	mov    %edx,-0xc(%ebp)
     58d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     592:	eb 1f                	jmp    5b3 <printint+0xa7>
     594:	eb 1d                	jmp    5b3 <printint+0xa7>
    putc(fd, buf[i]);
     596:	8d 55 dc             	lea    -0x24(%ebp),%edx
     599:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59c:	01 d0                	add    %edx,%eax
     59e:	0f b6 00             	movzbl (%eax),%eax
     5a1:	0f be c0             	movsbl %al,%eax
     5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
     5a8:	8b 45 08             	mov    0x8(%ebp),%eax
     5ab:	89 04 24             	mov    %eax,(%esp)
     5ae:	e8 31 ff ff ff       	call   4e4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     5b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     5b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5bb:	79 d9                	jns    596 <printint+0x8a>
    putc(fd, buf[i]);
}
     5bd:	83 c4 30             	add    $0x30,%esp
     5c0:	5b                   	pop    %ebx
     5c1:	5e                   	pop    %esi
     5c2:	5d                   	pop    %ebp
     5c3:	c3                   	ret    

000005c4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     5c4:	55                   	push   %ebp
     5c5:	89 e5                	mov    %esp,%ebp
     5c7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     5ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     5d1:	8d 45 0c             	lea    0xc(%ebp),%eax
     5d4:	83 c0 04             	add    $0x4,%eax
     5d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     5da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     5e1:	e9 7c 01 00 00       	jmp    762 <printf+0x19e>
    c = fmt[i] & 0xff;
     5e6:	8b 55 0c             	mov    0xc(%ebp),%edx
     5e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ec:	01 d0                	add    %edx,%eax
     5ee:	0f b6 00             	movzbl (%eax),%eax
     5f1:	0f be c0             	movsbl %al,%eax
     5f4:	25 ff 00 00 00       	and    $0xff,%eax
     5f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     5fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     600:	75 2c                	jne    62e <printf+0x6a>
      if(c == '%'){
     602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     606:	75 0c                	jne    614 <printf+0x50>
        state = '%';
     608:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     60f:	e9 4a 01 00 00       	jmp    75e <printf+0x19a>
      } else {
        putc(fd, c);
     614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     617:	0f be c0             	movsbl %al,%eax
     61a:	89 44 24 04          	mov    %eax,0x4(%esp)
     61e:	8b 45 08             	mov    0x8(%ebp),%eax
     621:	89 04 24             	mov    %eax,(%esp)
     624:	e8 bb fe ff ff       	call   4e4 <putc>
     629:	e9 30 01 00 00       	jmp    75e <printf+0x19a>
      }
    } else if(state == '%'){
     62e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     632:	0f 85 26 01 00 00    	jne    75e <printf+0x19a>
      if(c == 'd'){
     638:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     63c:	75 2d                	jne    66b <printf+0xa7>
        printint(fd, *ap, 10, 1);
     63e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     641:	8b 00                	mov    (%eax),%eax
     643:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     64a:	00 
     64b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     652:	00 
     653:	89 44 24 04          	mov    %eax,0x4(%esp)
     657:	8b 45 08             	mov    0x8(%ebp),%eax
     65a:	89 04 24             	mov    %eax,(%esp)
     65d:	e8 aa fe ff ff       	call   50c <printint>
        ap++;
     662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     666:	e9 ec 00 00 00       	jmp    757 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     66b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     66f:	74 06                	je     677 <printf+0xb3>
     671:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     675:	75 2d                	jne    6a4 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     677:	8b 45 e8             	mov    -0x18(%ebp),%eax
     67a:	8b 00                	mov    (%eax),%eax
     67c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     683:	00 
     684:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     68b:	00 
     68c:	89 44 24 04          	mov    %eax,0x4(%esp)
     690:	8b 45 08             	mov    0x8(%ebp),%eax
     693:	89 04 24             	mov    %eax,(%esp)
     696:	e8 71 fe ff ff       	call   50c <printint>
        ap++;
     69b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     69f:	e9 b3 00 00 00       	jmp    757 <printf+0x193>
      } else if(c == 's'){
     6a4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     6a8:	75 45                	jne    6ef <printf+0x12b>
        s = (char*)*ap;
     6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6ad:	8b 00                	mov    (%eax),%eax
     6af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     6b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     6b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6ba:	75 09                	jne    6c5 <printf+0x101>
          s = "(null)";
     6bc:	c7 45 f4 00 12 00 00 	movl   $0x1200,-0xc(%ebp)
        while(*s != 0){
     6c3:	eb 1e                	jmp    6e3 <printf+0x11f>
     6c5:	eb 1c                	jmp    6e3 <printf+0x11f>
          putc(fd, *s);
     6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ca:	0f b6 00             	movzbl (%eax),%eax
     6cd:	0f be c0             	movsbl %al,%eax
     6d0:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d4:	8b 45 08             	mov    0x8(%ebp),%eax
     6d7:	89 04 24             	mov    %eax,(%esp)
     6da:	e8 05 fe ff ff       	call   4e4 <putc>
          s++;
     6df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     6e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e6:	0f b6 00             	movzbl (%eax),%eax
     6e9:	84 c0                	test   %al,%al
     6eb:	75 da                	jne    6c7 <printf+0x103>
     6ed:	eb 68                	jmp    757 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     6ef:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     6f3:	75 1d                	jne    712 <printf+0x14e>
        putc(fd, *ap);
     6f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6f8:	8b 00                	mov    (%eax),%eax
     6fa:	0f be c0             	movsbl %al,%eax
     6fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     701:	8b 45 08             	mov    0x8(%ebp),%eax
     704:	89 04 24             	mov    %eax,(%esp)
     707:	e8 d8 fd ff ff       	call   4e4 <putc>
        ap++;
     70c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     710:	eb 45                	jmp    757 <printf+0x193>
      } else if(c == '%'){
     712:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     716:	75 17                	jne    72f <printf+0x16b>
        putc(fd, c);
     718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     71b:	0f be c0             	movsbl %al,%eax
     71e:	89 44 24 04          	mov    %eax,0x4(%esp)
     722:	8b 45 08             	mov    0x8(%ebp),%eax
     725:	89 04 24             	mov    %eax,(%esp)
     728:	e8 b7 fd ff ff       	call   4e4 <putc>
     72d:	eb 28                	jmp    757 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     72f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     736:	00 
     737:	8b 45 08             	mov    0x8(%ebp),%eax
     73a:	89 04 24             	mov    %eax,(%esp)
     73d:	e8 a2 fd ff ff       	call   4e4 <putc>
        putc(fd, c);
     742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     745:	0f be c0             	movsbl %al,%eax
     748:	89 44 24 04          	mov    %eax,0x4(%esp)
     74c:	8b 45 08             	mov    0x8(%ebp),%eax
     74f:	89 04 24             	mov    %eax,(%esp)
     752:	e8 8d fd ff ff       	call   4e4 <putc>
      }
      state = 0;
     757:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     75e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     762:	8b 55 0c             	mov    0xc(%ebp),%edx
     765:	8b 45 f0             	mov    -0x10(%ebp),%eax
     768:	01 d0                	add    %edx,%eax
     76a:	0f b6 00             	movzbl (%eax),%eax
     76d:	84 c0                	test   %al,%al
     76f:	0f 85 71 fe ff ff    	jne    5e6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     775:	c9                   	leave  
     776:	c3                   	ret    

00000777 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     777:	55                   	push   %ebp
     778:	89 e5                	mov    %esp,%ebp
     77a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     77d:	8b 45 08             	mov    0x8(%ebp),%eax
     780:	83 e8 08             	sub    $0x8,%eax
     783:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     786:	a1 0c 17 00 00       	mov    0x170c,%eax
     78b:	89 45 fc             	mov    %eax,-0x4(%ebp)
     78e:	eb 24                	jmp    7b4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     790:	8b 45 fc             	mov    -0x4(%ebp),%eax
     793:	8b 00                	mov    (%eax),%eax
     795:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     798:	77 12                	ja     7ac <free+0x35>
     79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     79d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7a0:	77 24                	ja     7c6 <free+0x4f>
     7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7a5:	8b 00                	mov    (%eax),%eax
     7a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7aa:	77 1a                	ja     7c6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7af:	8b 00                	mov    (%eax),%eax
     7b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7ba:	76 d4                	jbe    790 <free+0x19>
     7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7bf:	8b 00                	mov    (%eax),%eax
     7c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7c4:	76 ca                	jbe    790 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7c9:	8b 40 04             	mov    0x4(%eax),%eax
     7cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7d6:	01 c2                	add    %eax,%edx
     7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7db:	8b 00                	mov    (%eax),%eax
     7dd:	39 c2                	cmp    %eax,%edx
     7df:	75 24                	jne    805 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7e4:	8b 50 04             	mov    0x4(%eax),%edx
     7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7ea:	8b 00                	mov    (%eax),%eax
     7ec:	8b 40 04             	mov    0x4(%eax),%eax
     7ef:	01 c2                	add    %eax,%edx
     7f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7f4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7fa:	8b 00                	mov    (%eax),%eax
     7fc:	8b 10                	mov    (%eax),%edx
     7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
     801:	89 10                	mov    %edx,(%eax)
     803:	eb 0a                	jmp    80f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     805:	8b 45 fc             	mov    -0x4(%ebp),%eax
     808:	8b 10                	mov    (%eax),%edx
     80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     80d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     812:	8b 40 04             	mov    0x4(%eax),%eax
     815:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     81f:	01 d0                	add    %edx,%eax
     821:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     824:	75 20                	jne    846 <free+0xcf>
    p->s.size += bp->s.size;
     826:	8b 45 fc             	mov    -0x4(%ebp),%eax
     829:	8b 50 04             	mov    0x4(%eax),%edx
     82c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     82f:	8b 40 04             	mov    0x4(%eax),%eax
     832:	01 c2                	add    %eax,%edx
     834:	8b 45 fc             	mov    -0x4(%ebp),%eax
     837:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     83a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     83d:	8b 10                	mov    (%eax),%edx
     83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     842:	89 10                	mov    %edx,(%eax)
     844:	eb 08                	jmp    84e <free+0xd7>
  } else
    p->s.ptr = bp;
     846:	8b 45 fc             	mov    -0x4(%ebp),%eax
     849:	8b 55 f8             	mov    -0x8(%ebp),%edx
     84c:	89 10                	mov    %edx,(%eax)
  freep = p;
     84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     851:	a3 0c 17 00 00       	mov    %eax,0x170c
}
     856:	c9                   	leave  
     857:	c3                   	ret    

00000858 <morecore>:

static Header*
morecore(uint nu)
{
     858:	55                   	push   %ebp
     859:	89 e5                	mov    %esp,%ebp
     85b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     85e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     865:	77 07                	ja     86e <morecore+0x16>
    nu = 4096;
     867:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     86e:	8b 45 08             	mov    0x8(%ebp),%eax
     871:	c1 e0 03             	shl    $0x3,%eax
     874:	89 04 24             	mov    %eax,(%esp)
     877:	e8 08 fc ff ff       	call   484 <sbrk>
     87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     87f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     883:	75 07                	jne    88c <morecore+0x34>
    return 0;
     885:	b8 00 00 00 00       	mov    $0x0,%eax
     88a:	eb 22                	jmp    8ae <morecore+0x56>
  hp = (Header*)p;
     88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     892:	8b 45 f0             	mov    -0x10(%ebp),%eax
     895:	8b 55 08             	mov    0x8(%ebp),%edx
     898:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     89e:	83 c0 08             	add    $0x8,%eax
     8a1:	89 04 24             	mov    %eax,(%esp)
     8a4:	e8 ce fe ff ff       	call   777 <free>
  return freep;
     8a9:	a1 0c 17 00 00       	mov    0x170c,%eax
}
     8ae:	c9                   	leave  
     8af:	c3                   	ret    

000008b0 <malloc>:

void*
malloc(uint nbytes)
{
     8b0:	55                   	push   %ebp
     8b1:	89 e5                	mov    %esp,%ebp
     8b3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     8b6:	8b 45 08             	mov    0x8(%ebp),%eax
     8b9:	83 c0 07             	add    $0x7,%eax
     8bc:	c1 e8 03             	shr    $0x3,%eax
     8bf:	83 c0 01             	add    $0x1,%eax
     8c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     8c5:	a1 0c 17 00 00       	mov    0x170c,%eax
     8ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
     8cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8d1:	75 23                	jne    8f6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     8d3:	c7 45 f0 04 17 00 00 	movl   $0x1704,-0x10(%ebp)
     8da:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8dd:	a3 0c 17 00 00       	mov    %eax,0x170c
     8e2:	a1 0c 17 00 00       	mov    0x170c,%eax
     8e7:	a3 04 17 00 00       	mov    %eax,0x1704
    base.s.size = 0;
     8ec:	c7 05 08 17 00 00 00 	movl   $0x0,0x1708
     8f3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8f9:	8b 00                	mov    (%eax),%eax
     8fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     901:	8b 40 04             	mov    0x4(%eax),%eax
     904:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     907:	72 4d                	jb     956 <malloc+0xa6>
      if(p->s.size == nunits)
     909:	8b 45 f4             	mov    -0xc(%ebp),%eax
     90c:	8b 40 04             	mov    0x4(%eax),%eax
     90f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     912:	75 0c                	jne    920 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     914:	8b 45 f4             	mov    -0xc(%ebp),%eax
     917:	8b 10                	mov    (%eax),%edx
     919:	8b 45 f0             	mov    -0x10(%ebp),%eax
     91c:	89 10                	mov    %edx,(%eax)
     91e:	eb 26                	jmp    946 <malloc+0x96>
      else {
        p->s.size -= nunits;
     920:	8b 45 f4             	mov    -0xc(%ebp),%eax
     923:	8b 40 04             	mov    0x4(%eax),%eax
     926:	2b 45 ec             	sub    -0x14(%ebp),%eax
     929:	89 c2                	mov    %eax,%edx
     92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     931:	8b 45 f4             	mov    -0xc(%ebp),%eax
     934:	8b 40 04             	mov    0x4(%eax),%eax
     937:	c1 e0 03             	shl    $0x3,%eax
     93a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     940:	8b 55 ec             	mov    -0x14(%ebp),%edx
     943:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     946:	8b 45 f0             	mov    -0x10(%ebp),%eax
     949:	a3 0c 17 00 00       	mov    %eax,0x170c
      return (void*)(p + 1);
     94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     951:	83 c0 08             	add    $0x8,%eax
     954:	eb 38                	jmp    98e <malloc+0xde>
    }
    if(p == freep)
     956:	a1 0c 17 00 00       	mov    0x170c,%eax
     95b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     95e:	75 1b                	jne    97b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     960:	8b 45 ec             	mov    -0x14(%ebp),%eax
     963:	89 04 24             	mov    %eax,(%esp)
     966:	e8 ed fe ff ff       	call   858 <morecore>
     96b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     96e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     972:	75 07                	jne    97b <malloc+0xcb>
        return 0;
     974:	b8 00 00 00 00       	mov    $0x0,%eax
     979:	eb 13                	jmp    98e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     97e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     981:	8b 45 f4             	mov    -0xc(%ebp),%eax
     984:	8b 00                	mov    (%eax),%eax
     986:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     989:	e9 70 ff ff ff       	jmp    8fe <malloc+0x4e>
}
     98e:	c9                   	leave  
     98f:	c3                   	ret    

00000990 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     990:	55                   	push   %ebp
     991:	89 e5                	mov    %esp,%ebp
     993:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     996:	e8 21 fb ff ff       	call   4bc <kthread_mutex_alloc>
     99b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     99e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     9a2:	79 0a                	jns    9ae <mesa_slots_monitor_alloc+0x1e>
		return 0;
     9a4:	b8 00 00 00 00       	mov    $0x0,%eax
     9a9:	e9 8b 00 00 00       	jmp    a39 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     9ae:	e8 44 06 00 00       	call   ff7 <mesa_cond_alloc>
     9b3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     9b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9ba:	75 12                	jne    9ce <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9bf:	89 04 24             	mov    %eax,(%esp)
     9c2:	e8 fd fa ff ff       	call   4c4 <kthread_mutex_dealloc>
		return 0;
     9c7:	b8 00 00 00 00       	mov    $0x0,%eax
     9cc:	eb 6b                	jmp    a39 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     9ce:	e8 24 06 00 00       	call   ff7 <mesa_cond_alloc>
     9d3:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     9d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     9da:	75 1d                	jne    9f9 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9df:	89 04 24             	mov    %eax,(%esp)
     9e2:	e8 dd fa ff ff       	call   4c4 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     9e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ea:	89 04 24             	mov    %eax,(%esp)
     9ed:	e8 46 06 00 00       	call   1038 <mesa_cond_dealloc>
		return 0;
     9f2:	b8 00 00 00 00       	mov    $0x0,%eax
     9f7:	eb 40                	jmp    a39 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     9f9:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     a00:	e8 ab fe ff ff       	call   8b0 <malloc>
     a05:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a0e:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a14:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a17:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a20:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a2f:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     a36:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     a39:	c9                   	leave  
     a3a:	c3                   	ret    

00000a3b <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     a3b:	55                   	push   %ebp
     a3c:	89 e5                	mov    %esp,%ebp
     a3e:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     a41:	8b 45 08             	mov    0x8(%ebp),%eax
     a44:	8b 00                	mov    (%eax),%eax
     a46:	89 04 24             	mov    %eax,(%esp)
     a49:	e8 76 fa ff ff       	call   4c4 <kthread_mutex_dealloc>
     a4e:	85 c0                	test   %eax,%eax
     a50:	78 2e                	js     a80 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     a52:	8b 45 08             	mov    0x8(%ebp),%eax
     a55:	8b 40 04             	mov    0x4(%eax),%eax
     a58:	89 04 24             	mov    %eax,(%esp)
     a5b:	e8 97 05 00 00       	call   ff7 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     a60:	8b 45 08             	mov    0x8(%ebp),%eax
     a63:	8b 40 08             	mov    0x8(%eax),%eax
     a66:	89 04 24             	mov    %eax,(%esp)
     a69:	e8 89 05 00 00       	call   ff7 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     a6e:	8b 45 08             	mov    0x8(%ebp),%eax
     a71:	89 04 24             	mov    %eax,(%esp)
     a74:	e8 fe fc ff ff       	call   777 <free>
	return 0;
     a79:	b8 00 00 00 00       	mov    $0x0,%eax
     a7e:	eb 05                	jmp    a85 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     a85:	c9                   	leave  
     a86:	c3                   	ret    

00000a87 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     a87:	55                   	push   %ebp
     a88:	89 e5                	mov    %esp,%ebp
     a8a:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     a8d:	8b 45 08             	mov    0x8(%ebp),%eax
     a90:	8b 40 10             	mov    0x10(%eax),%eax
     a93:	85 c0                	test   %eax,%eax
     a95:	75 0a                	jne    aa1 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a9c:	e9 81 00 00 00       	jmp    b22 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     aa1:	8b 45 08             	mov    0x8(%ebp),%eax
     aa4:	8b 00                	mov    (%eax),%eax
     aa6:	89 04 24             	mov    %eax,(%esp)
     aa9:	e8 1e fa ff ff       	call   4cc <kthread_mutex_lock>
     aae:	83 f8 ff             	cmp    $0xffffffff,%eax
     ab1:	7d 07                	jge    aba <mesa_slots_monitor_addslots+0x33>
		return -1;
     ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ab8:	eb 68                	jmp    b22 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     aba:	eb 17                	jmp    ad3 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     abc:	8b 45 08             	mov    0x8(%ebp),%eax
     abf:	8b 10                	mov    (%eax),%edx
     ac1:	8b 45 08             	mov    0x8(%ebp),%eax
     ac4:	8b 40 08             	mov    0x8(%eax),%eax
     ac7:	89 54 24 04          	mov    %edx,0x4(%esp)
     acb:	89 04 24             	mov    %eax,(%esp)
     ace:	e8 af 05 00 00       	call   1082 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     ad3:	8b 45 08             	mov    0x8(%ebp),%eax
     ad6:	8b 40 10             	mov    0x10(%eax),%eax
     ad9:	85 c0                	test   %eax,%eax
     adb:	74 0a                	je     ae7 <mesa_slots_monitor_addslots+0x60>
     add:	8b 45 08             	mov    0x8(%ebp),%eax
     ae0:	8b 40 0c             	mov    0xc(%eax),%eax
     ae3:	85 c0                	test   %eax,%eax
     ae5:	7f d5                	jg     abc <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	8b 40 10             	mov    0x10(%eax),%eax
     aed:	85 c0                	test   %eax,%eax
     aef:	74 11                	je     b02 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     af1:	8b 45 08             	mov    0x8(%ebp),%eax
     af4:	8b 50 0c             	mov    0xc(%eax),%edx
     af7:	8b 45 0c             	mov    0xc(%ebp),%eax
     afa:	01 c2                	add    %eax,%edx
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
     aff:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     b02:	8b 45 08             	mov    0x8(%ebp),%eax
     b05:	8b 40 04             	mov    0x4(%eax),%eax
     b08:	89 04 24             	mov    %eax,(%esp)
     b0b:	e8 dc 05 00 00       	call   10ec <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     b10:	8b 45 08             	mov    0x8(%ebp),%eax
     b13:	8b 00                	mov    (%eax),%eax
     b15:	89 04 24             	mov    %eax,(%esp)
     b18:	e8 b7 f9 ff ff       	call   4d4 <kthread_mutex_unlock>

	return 1;
     b1d:	b8 01 00 00 00       	mov    $0x1,%eax


}
     b22:	c9                   	leave  
     b23:	c3                   	ret    

00000b24 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     b24:	55                   	push   %ebp
     b25:	89 e5                	mov    %esp,%ebp
     b27:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     b2a:	8b 45 08             	mov    0x8(%ebp),%eax
     b2d:	8b 40 10             	mov    0x10(%eax),%eax
     b30:	85 c0                	test   %eax,%eax
     b32:	75 07                	jne    b3b <mesa_slots_monitor_takeslot+0x17>
		return -1;
     b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b39:	eb 7f                	jmp    bba <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     b3b:	8b 45 08             	mov    0x8(%ebp),%eax
     b3e:	8b 00                	mov    (%eax),%eax
     b40:	89 04 24             	mov    %eax,(%esp)
     b43:	e8 84 f9 ff ff       	call   4cc <kthread_mutex_lock>
     b48:	83 f8 ff             	cmp    $0xffffffff,%eax
     b4b:	7d 07                	jge    b54 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b52:	eb 66                	jmp    bba <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     b54:	eb 17                	jmp    b6d <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     b56:	8b 45 08             	mov    0x8(%ebp),%eax
     b59:	8b 10                	mov    (%eax),%edx
     b5b:	8b 45 08             	mov    0x8(%ebp),%eax
     b5e:	8b 40 04             	mov    0x4(%eax),%eax
     b61:	89 54 24 04          	mov    %edx,0x4(%esp)
     b65:	89 04 24             	mov    %eax,(%esp)
     b68:	e8 15 05 00 00       	call   1082 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     b6d:	8b 45 08             	mov    0x8(%ebp),%eax
     b70:	8b 40 10             	mov    0x10(%eax),%eax
     b73:	85 c0                	test   %eax,%eax
     b75:	74 0a                	je     b81 <mesa_slots_monitor_takeslot+0x5d>
     b77:	8b 45 08             	mov    0x8(%ebp),%eax
     b7a:	8b 40 0c             	mov    0xc(%eax),%eax
     b7d:	85 c0                	test   %eax,%eax
     b7f:	74 d5                	je     b56 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     b81:	8b 45 08             	mov    0x8(%ebp),%eax
     b84:	8b 40 10             	mov    0x10(%eax),%eax
     b87:	85 c0                	test   %eax,%eax
     b89:	74 0f                	je     b9a <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     b8b:	8b 45 08             	mov    0x8(%ebp),%eax
     b8e:	8b 40 0c             	mov    0xc(%eax),%eax
     b91:	8d 50 ff             	lea    -0x1(%eax),%edx
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     b9a:	8b 45 08             	mov    0x8(%ebp),%eax
     b9d:	8b 40 08             	mov    0x8(%eax),%eax
     ba0:	89 04 24             	mov    %eax,(%esp)
     ba3:	e8 44 05 00 00       	call   10ec <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ba8:	8b 45 08             	mov    0x8(%ebp),%eax
     bab:	8b 00                	mov    (%eax),%eax
     bad:	89 04 24             	mov    %eax,(%esp)
     bb0:	e8 1f f9 ff ff       	call   4d4 <kthread_mutex_unlock>

	return 1;
     bb5:	b8 01 00 00 00       	mov    $0x1,%eax

}
     bba:	c9                   	leave  
     bbb:	c3                   	ret    

00000bbc <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     bbc:	55                   	push   %ebp
     bbd:	89 e5                	mov    %esp,%ebp
     bbf:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     bc2:	8b 45 08             	mov    0x8(%ebp),%eax
     bc5:	8b 40 10             	mov    0x10(%eax),%eax
     bc8:	85 c0                	test   %eax,%eax
     bca:	75 07                	jne    bd3 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bd1:	eb 35                	jmp    c08 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bd3:	8b 45 08             	mov    0x8(%ebp),%eax
     bd6:	8b 00                	mov    (%eax),%eax
     bd8:	89 04 24             	mov    %eax,(%esp)
     bdb:	e8 ec f8 ff ff       	call   4cc <kthread_mutex_lock>
     be0:	83 f8 ff             	cmp    $0xffffffff,%eax
     be3:	7d 07                	jge    bec <mesa_slots_monitor_stopadding+0x30>
			return -1;
     be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bea:	eb 1c                	jmp    c08 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     bec:	8b 45 08             	mov    0x8(%ebp),%eax
     bef:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     bf6:	8b 45 08             	mov    0x8(%ebp),%eax
     bf9:	8b 00                	mov    (%eax),%eax
     bfb:	89 04 24             	mov    %eax,(%esp)
     bfe:	e8 d1 f8 ff ff       	call   4d4 <kthread_mutex_unlock>

		return 0;
     c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c08:	c9                   	leave  
     c09:	c3                   	ret    

00000c0a <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     c0a:	55                   	push   %ebp
     c0b:	89 e5                	mov    %esp,%ebp
     c0d:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     c10:	e8 a7 f8 ff ff       	call   4bc <kthread_mutex_alloc>
     c15:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c1c:	79 0a                	jns    c28 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     c1e:	b8 00 00 00 00       	mov    $0x0,%eax
     c23:	e9 8b 00 00 00       	jmp    cb3 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     c28:	e8 68 02 00 00       	call   e95 <hoare_cond_alloc>
     c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     c30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c34:	75 12                	jne    c48 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c39:	89 04 24             	mov    %eax,(%esp)
     c3c:	e8 83 f8 ff ff       	call   4c4 <kthread_mutex_dealloc>
		return 0;
     c41:	b8 00 00 00 00       	mov    $0x0,%eax
     c46:	eb 6b                	jmp    cb3 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     c48:	e8 48 02 00 00       	call   e95 <hoare_cond_alloc>
     c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c54:	75 1d                	jne    c73 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c59:	89 04 24             	mov    %eax,(%esp)
     c5c:	e8 63 f8 ff ff       	call   4c4 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c64:	89 04 24             	mov    %eax,(%esp)
     c67:	e8 6a 02 00 00       	call   ed6 <hoare_cond_dealloc>
		return 0;
     c6c:	b8 00 00 00 00       	mov    $0x0,%eax
     c71:	eb 40                	jmp    cb3 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     c73:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     c7a:	e8 31 fc ff ff       	call   8b0 <malloc>
     c7f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c88:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c91:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c9a:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca9:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     cb0:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     cb3:	c9                   	leave  
     cb4:	c3                   	ret    

00000cb5 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     cb5:	55                   	push   %ebp
     cb6:	89 e5                	mov    %esp,%ebp
     cb8:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	8b 00                	mov    (%eax),%eax
     cc0:	89 04 24             	mov    %eax,(%esp)
     cc3:	e8 fc f7 ff ff       	call   4c4 <kthread_mutex_dealloc>
     cc8:	85 c0                	test   %eax,%eax
     cca:	78 2e                	js     cfa <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     ccc:	8b 45 08             	mov    0x8(%ebp),%eax
     ccf:	8b 40 04             	mov    0x4(%eax),%eax
     cd2:	89 04 24             	mov    %eax,(%esp)
     cd5:	e8 bb 01 00 00       	call   e95 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	8b 40 08             	mov    0x8(%eax),%eax
     ce0:	89 04 24             	mov    %eax,(%esp)
     ce3:	e8 ad 01 00 00       	call   e95 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     ce8:	8b 45 08             	mov    0x8(%ebp),%eax
     ceb:	89 04 24             	mov    %eax,(%esp)
     cee:	e8 84 fa ff ff       	call   777 <free>
	return 0;
     cf3:	b8 00 00 00 00       	mov    $0x0,%eax
     cf8:	eb 05                	jmp    cff <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     cfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     cff:	c9                   	leave  
     d00:	c3                   	ret    

00000d01 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     d01:	55                   	push   %ebp
     d02:	89 e5                	mov    %esp,%ebp
     d04:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	8b 40 10             	mov    0x10(%eax),%eax
     d0d:	85 c0                	test   %eax,%eax
     d0f:	75 0a                	jne    d1b <hoare_slots_monitor_addslots+0x1a>
		return -1;
     d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d16:	e9 88 00 00 00       	jmp    da3 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d1b:	8b 45 08             	mov    0x8(%ebp),%eax
     d1e:	8b 00                	mov    (%eax),%eax
     d20:	89 04 24             	mov    %eax,(%esp)
     d23:	e8 a4 f7 ff ff       	call   4cc <kthread_mutex_lock>
     d28:	83 f8 ff             	cmp    $0xffffffff,%eax
     d2b:	7d 07                	jge    d34 <hoare_slots_monitor_addslots+0x33>
		return -1;
     d2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d32:	eb 6f                	jmp    da3 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
     d37:	8b 40 10             	mov    0x10(%eax),%eax
     d3a:	85 c0                	test   %eax,%eax
     d3c:	74 21                	je     d5f <hoare_slots_monitor_addslots+0x5e>
     d3e:	8b 45 08             	mov    0x8(%ebp),%eax
     d41:	8b 40 0c             	mov    0xc(%eax),%eax
     d44:	85 c0                	test   %eax,%eax
     d46:	7e 17                	jle    d5f <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	8b 10                	mov    (%eax),%edx
     d4d:	8b 45 08             	mov    0x8(%ebp),%eax
     d50:	8b 40 08             	mov    0x8(%eax),%eax
     d53:	89 54 24 04          	mov    %edx,0x4(%esp)
     d57:	89 04 24             	mov    %eax,(%esp)
     d5a:	e8 c1 01 00 00       	call   f20 <hoare_cond_wait>


	if  ( monitor->active)
     d5f:	8b 45 08             	mov    0x8(%ebp),%eax
     d62:	8b 40 10             	mov    0x10(%eax),%eax
     d65:	85 c0                	test   %eax,%eax
     d67:	74 11                	je     d7a <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     d69:	8b 45 08             	mov    0x8(%ebp),%eax
     d6c:	8b 50 0c             	mov    0xc(%eax),%edx
     d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     d72:	01 c2                	add    %eax,%edx
     d74:	8b 45 08             	mov    0x8(%ebp),%eax
     d77:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     d7a:	8b 45 08             	mov    0x8(%ebp),%eax
     d7d:	8b 10                	mov    (%eax),%edx
     d7f:	8b 45 08             	mov    0x8(%ebp),%eax
     d82:	8b 40 04             	mov    0x4(%eax),%eax
     d85:	89 54 24 04          	mov    %edx,0x4(%esp)
     d89:	89 04 24             	mov    %eax,(%esp)
     d8c:	e8 e6 01 00 00       	call   f77 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d91:	8b 45 08             	mov    0x8(%ebp),%eax
     d94:	8b 00                	mov    (%eax),%eax
     d96:	89 04 24             	mov    %eax,(%esp)
     d99:	e8 36 f7 ff ff       	call   4d4 <kthread_mutex_unlock>

	return 1;
     d9e:	b8 01 00 00 00       	mov    $0x1,%eax


}
     da3:	c9                   	leave  
     da4:	c3                   	ret    

00000da5 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     da5:	55                   	push   %ebp
     da6:	89 e5                	mov    %esp,%ebp
     da8:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     dab:	8b 45 08             	mov    0x8(%ebp),%eax
     dae:	8b 40 10             	mov    0x10(%eax),%eax
     db1:	85 c0                	test   %eax,%eax
     db3:	75 0a                	jne    dbf <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dba:	e9 86 00 00 00       	jmp    e45 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     dbf:	8b 45 08             	mov    0x8(%ebp),%eax
     dc2:	8b 00                	mov    (%eax),%eax
     dc4:	89 04 24             	mov    %eax,(%esp)
     dc7:	e8 00 f7 ff ff       	call   4cc <kthread_mutex_lock>
     dcc:	83 f8 ff             	cmp    $0xffffffff,%eax
     dcf:	7d 07                	jge    dd8 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dd6:	eb 6d                	jmp    e45 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     dd8:	8b 45 08             	mov    0x8(%ebp),%eax
     ddb:	8b 40 10             	mov    0x10(%eax),%eax
     dde:	85 c0                	test   %eax,%eax
     de0:	74 21                	je     e03 <hoare_slots_monitor_takeslot+0x5e>
     de2:	8b 45 08             	mov    0x8(%ebp),%eax
     de5:	8b 40 0c             	mov    0xc(%eax),%eax
     de8:	85 c0                	test   %eax,%eax
     dea:	75 17                	jne    e03 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     dec:	8b 45 08             	mov    0x8(%ebp),%eax
     def:	8b 10                	mov    (%eax),%edx
     df1:	8b 45 08             	mov    0x8(%ebp),%eax
     df4:	8b 40 04             	mov    0x4(%eax),%eax
     df7:	89 54 24 04          	mov    %edx,0x4(%esp)
     dfb:	89 04 24             	mov    %eax,(%esp)
     dfe:	e8 1d 01 00 00       	call   f20 <hoare_cond_wait>


	if  ( monitor->active)
     e03:	8b 45 08             	mov    0x8(%ebp),%eax
     e06:	8b 40 10             	mov    0x10(%eax),%eax
     e09:	85 c0                	test   %eax,%eax
     e0b:	74 0f                	je     e1c <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     e0d:	8b 45 08             	mov    0x8(%ebp),%eax
     e10:	8b 40 0c             	mov    0xc(%eax),%eax
     e13:	8d 50 ff             	lea    -0x1(%eax),%edx
     e16:	8b 45 08             	mov    0x8(%ebp),%eax
     e19:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     e1c:	8b 45 08             	mov    0x8(%ebp),%eax
     e1f:	8b 10                	mov    (%eax),%edx
     e21:	8b 45 08             	mov    0x8(%ebp),%eax
     e24:	8b 40 08             	mov    0x8(%eax),%eax
     e27:	89 54 24 04          	mov    %edx,0x4(%esp)
     e2b:	89 04 24             	mov    %eax,(%esp)
     e2e:	e8 44 01 00 00       	call   f77 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     e33:	8b 45 08             	mov    0x8(%ebp),%eax
     e36:	8b 00                	mov    (%eax),%eax
     e38:	89 04 24             	mov    %eax,(%esp)
     e3b:	e8 94 f6 ff ff       	call   4d4 <kthread_mutex_unlock>

	return 1;
     e40:	b8 01 00 00 00       	mov    $0x1,%eax

}
     e45:	c9                   	leave  
     e46:	c3                   	ret    

00000e47 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     e47:	55                   	push   %ebp
     e48:	89 e5                	mov    %esp,%ebp
     e4a:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     e4d:	8b 45 08             	mov    0x8(%ebp),%eax
     e50:	8b 40 10             	mov    0x10(%eax),%eax
     e53:	85 c0                	test   %eax,%eax
     e55:	75 07                	jne    e5e <hoare_slots_monitor_stopadding+0x17>
			return -1;
     e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e5c:	eb 35                	jmp    e93 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e5e:	8b 45 08             	mov    0x8(%ebp),%eax
     e61:	8b 00                	mov    (%eax),%eax
     e63:	89 04 24             	mov    %eax,(%esp)
     e66:	e8 61 f6 ff ff       	call   4cc <kthread_mutex_lock>
     e6b:	83 f8 ff             	cmp    $0xffffffff,%eax
     e6e:	7d 07                	jge    e77 <hoare_slots_monitor_stopadding+0x30>
			return -1;
     e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e75:	eb 1c                	jmp    e93 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     e81:	8b 45 08             	mov    0x8(%ebp),%eax
     e84:	8b 00                	mov    (%eax),%eax
     e86:	89 04 24             	mov    %eax,(%esp)
     e89:	e8 46 f6 ff ff       	call   4d4 <kthread_mutex_unlock>

		return 0;
     e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e93:	c9                   	leave  
     e94:	c3                   	ret    

00000e95 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     e95:	55                   	push   %ebp
     e96:	89 e5                	mov    %esp,%ebp
     e98:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     e9b:	e8 1c f6 ff ff       	call   4bc <kthread_mutex_alloc>
     ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea7:	79 07                	jns    eb0 <hoare_cond_alloc+0x1b>
		return 0;
     ea9:	b8 00 00 00 00       	mov    $0x0,%eax
     eae:	eb 24                	jmp    ed4 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     eb0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     eb7:	e8 f4 f9 ff ff       	call   8b0 <malloc>
     ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ec5:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ed4:	c9                   	leave  
     ed5:	c3                   	ret    

00000ed6 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     ed6:	55                   	push   %ebp
     ed7:	89 e5                	mov    %esp,%ebp
     ed9:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ee0:	75 07                	jne    ee9 <hoare_cond_dealloc+0x13>
			return -1;
     ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ee7:	eb 35                	jmp    f1e <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     ee9:	8b 45 08             	mov    0x8(%ebp),%eax
     eec:	8b 00                	mov    (%eax),%eax
     eee:	89 04 24             	mov    %eax,(%esp)
     ef1:	e8 de f5 ff ff       	call   4d4 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     ef6:	8b 45 08             	mov    0x8(%ebp),%eax
     ef9:	8b 00                	mov    (%eax),%eax
     efb:	89 04 24             	mov    %eax,(%esp)
     efe:	e8 c1 f5 ff ff       	call   4c4 <kthread_mutex_dealloc>
     f03:	85 c0                	test   %eax,%eax
     f05:	79 07                	jns    f0e <hoare_cond_dealloc+0x38>
			return -1;
     f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f0c:	eb 10                	jmp    f1e <hoare_cond_dealloc+0x48>

		free (hCond);
     f0e:	8b 45 08             	mov    0x8(%ebp),%eax
     f11:	89 04 24             	mov    %eax,(%esp)
     f14:	e8 5e f8 ff ff       	call   777 <free>
		return 0;
     f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f1e:	c9                   	leave  
     f1f:	c3                   	ret    

00000f20 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     f20:	55                   	push   %ebp
     f21:	89 e5                	mov    %esp,%ebp
     f23:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     f26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f2a:	75 07                	jne    f33 <hoare_cond_wait+0x13>
			return -1;
     f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f31:	eb 42                	jmp    f75 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     f33:	8b 45 08             	mov    0x8(%ebp),%eax
     f36:	8b 40 04             	mov    0x4(%eax),%eax
     f39:	8d 50 01             	lea    0x1(%eax),%edx
     f3c:	8b 45 08             	mov    0x8(%ebp),%eax
     f3f:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     f42:	8b 45 08             	mov    0x8(%ebp),%eax
     f45:	8b 00                	mov    (%eax),%eax
     f47:	89 44 24 04          	mov    %eax,0x4(%esp)
     f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f4e:	89 04 24             	mov    %eax,(%esp)
     f51:	e8 86 f5 ff ff       	call   4dc <kthread_mutex_yieldlock>
     f56:	85 c0                	test   %eax,%eax
     f58:	79 16                	jns    f70 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     f5a:	8b 45 08             	mov    0x8(%ebp),%eax
     f5d:	8b 40 04             	mov    0x4(%eax),%eax
     f60:	8d 50 ff             	lea    -0x1(%eax),%edx
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f6e:	eb 05                	jmp    f75 <hoare_cond_wait+0x55>
		}

	return 0;
     f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f75:	c9                   	leave  
     f76:	c3                   	ret    

00000f77 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     f77:	55                   	push   %ebp
     f78:	89 e5                	mov    %esp,%ebp
     f7a:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f81:	75 07                	jne    f8a <hoare_cond_signal+0x13>
		return -1;
     f83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f88:	eb 6b                	jmp    ff5 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     f8a:	8b 45 08             	mov    0x8(%ebp),%eax
     f8d:	8b 40 04             	mov    0x4(%eax),%eax
     f90:	85 c0                	test   %eax,%eax
     f92:	7e 3d                	jle    fd1 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     f94:	8b 45 08             	mov    0x8(%ebp),%eax
     f97:	8b 40 04             	mov    0x4(%eax),%eax
     f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
     f9d:	8b 45 08             	mov    0x8(%ebp),%eax
     fa0:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     fa3:	8b 45 08             	mov    0x8(%ebp),%eax
     fa6:	8b 00                	mov    (%eax),%eax
     fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
     fac:	8b 45 0c             	mov    0xc(%ebp),%eax
     faf:	89 04 24             	mov    %eax,(%esp)
     fb2:	e8 25 f5 ff ff       	call   4dc <kthread_mutex_yieldlock>
     fb7:	85 c0                	test   %eax,%eax
     fb9:	79 16                	jns    fd1 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     fbb:	8b 45 08             	mov    0x8(%ebp),%eax
     fbe:	8b 40 04             	mov    0x4(%eax),%eax
     fc1:	8d 50 01             	lea    0x1(%eax),%edx
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fcf:	eb 24                	jmp    ff5 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     fd1:	8b 45 08             	mov    0x8(%ebp),%eax
     fd4:	8b 00                	mov    (%eax),%eax
     fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
     fda:	8b 45 0c             	mov    0xc(%ebp),%eax
     fdd:	89 04 24             	mov    %eax,(%esp)
     fe0:	e8 f7 f4 ff ff       	call   4dc <kthread_mutex_yieldlock>
     fe5:	85 c0                	test   %eax,%eax
     fe7:	79 07                	jns    ff0 <hoare_cond_signal+0x79>

    			return -1;
     fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fee:	eb 05                	jmp    ff5 <hoare_cond_signal+0x7e>
    }

	return 0;
     ff0:	b8 00 00 00 00       	mov    $0x0,%eax

}
     ff5:	c9                   	leave  
     ff6:	c3                   	ret    

00000ff7 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     ff7:	55                   	push   %ebp
     ff8:	89 e5                	mov    %esp,%ebp
     ffa:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ffd:	e8 ba f4 ff ff       	call   4bc <kthread_mutex_alloc>
    1002:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1009:	79 07                	jns    1012 <mesa_cond_alloc+0x1b>
		return 0;
    100b:	b8 00 00 00 00       	mov    $0x0,%eax
    1010:	eb 24                	jmp    1036 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1012:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1019:	e8 92 f8 ff ff       	call   8b0 <malloc>
    101e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1021:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1024:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1027:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    1029:	8b 45 f0             	mov    -0x10(%ebp),%eax
    102c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1033:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1036:	c9                   	leave  
    1037:	c3                   	ret    

00001038 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    1038:	55                   	push   %ebp
    1039:	89 e5                	mov    %esp,%ebp
    103b:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    103e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1042:	75 07                	jne    104b <mesa_cond_dealloc+0x13>
		return -1;
    1044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1049:	eb 35                	jmp    1080 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    104b:	8b 45 08             	mov    0x8(%ebp),%eax
    104e:	8b 00                	mov    (%eax),%eax
    1050:	89 04 24             	mov    %eax,(%esp)
    1053:	e8 7c f4 ff ff       	call   4d4 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    1058:	8b 45 08             	mov    0x8(%ebp),%eax
    105b:	8b 00                	mov    (%eax),%eax
    105d:	89 04 24             	mov    %eax,(%esp)
    1060:	e8 5f f4 ff ff       	call   4c4 <kthread_mutex_dealloc>
    1065:	85 c0                	test   %eax,%eax
    1067:	79 07                	jns    1070 <mesa_cond_dealloc+0x38>
		return -1;
    1069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    106e:	eb 10                	jmp    1080 <mesa_cond_dealloc+0x48>

	free (mCond);
    1070:	8b 45 08             	mov    0x8(%ebp),%eax
    1073:	89 04 24             	mov    %eax,(%esp)
    1076:	e8 fc f6 ff ff       	call   777 <free>
	return 0;
    107b:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1080:	c9                   	leave  
    1081:	c3                   	ret    

00001082 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    1082:	55                   	push   %ebp
    1083:	89 e5                	mov    %esp,%ebp
    1085:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    108c:	75 07                	jne    1095 <mesa_cond_wait+0x13>
		return -1;
    108e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1093:	eb 55                	jmp    10ea <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    1095:	8b 45 08             	mov    0x8(%ebp),%eax
    1098:	8b 40 04             	mov    0x4(%eax),%eax
    109b:	8d 50 01             	lea    0x1(%eax),%edx
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    10a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a7:	89 04 24             	mov    %eax,(%esp)
    10aa:	e8 25 f4 ff ff       	call   4d4 <kthread_mutex_unlock>
    10af:	85 c0                	test   %eax,%eax
    10b1:	79 27                	jns    10da <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	8b 00                	mov    (%eax),%eax
    10b8:	89 04 24             	mov    %eax,(%esp)
    10bb:	e8 0c f4 ff ff       	call   4cc <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    10c0:	85 c0                	test   %eax,%eax
    10c2:	79 16                	jns    10da <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    10c4:	8b 45 08             	mov    0x8(%ebp),%eax
    10c7:	8b 40 04             	mov    0x4(%eax),%eax
    10ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    10d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10d8:	eb 10                	jmp    10ea <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    10da:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dd:	89 04 24             	mov    %eax,(%esp)
    10e0:	e8 e7 f3 ff ff       	call   4cc <kthread_mutex_lock>
	return 0;
    10e5:	b8 00 00 00 00       	mov    $0x0,%eax


}
    10ea:	c9                   	leave  
    10eb:	c3                   	ret    

000010ec <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    10ec:	55                   	push   %ebp
    10ed:	89 e5                	mov    %esp,%ebp
    10ef:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    10f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10f6:	75 07                	jne    10ff <mesa_cond_signal+0x13>
		return -1;
    10f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10fd:	eb 5d                	jmp    115c <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    10ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1102:	8b 40 04             	mov    0x4(%eax),%eax
    1105:	85 c0                	test   %eax,%eax
    1107:	7e 36                	jle    113f <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
    110c:	8b 40 04             	mov    0x4(%eax),%eax
    110f:	8d 50 ff             	lea    -0x1(%eax),%edx
    1112:	8b 45 08             	mov    0x8(%ebp),%eax
    1115:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    1118:	8b 45 08             	mov    0x8(%ebp),%eax
    111b:	8b 00                	mov    (%eax),%eax
    111d:	89 04 24             	mov    %eax,(%esp)
    1120:	e8 af f3 ff ff       	call   4d4 <kthread_mutex_unlock>
    1125:	85 c0                	test   %eax,%eax
    1127:	78 16                	js     113f <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    1129:	8b 45 08             	mov    0x8(%ebp),%eax
    112c:	8b 40 04             	mov    0x4(%eax),%eax
    112f:	8d 50 01             	lea    0x1(%eax),%edx
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    1138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    113d:	eb 1d                	jmp    115c <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
    1142:	8b 00                	mov    (%eax),%eax
    1144:	89 04 24             	mov    %eax,(%esp)
    1147:	e8 88 f3 ff ff       	call   4d4 <kthread_mutex_unlock>
    114c:	85 c0                	test   %eax,%eax
    114e:	79 07                	jns    1157 <mesa_cond_signal+0x6b>

		return -1;
    1150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1155:	eb 05                	jmp    115c <mesa_cond_signal+0x70>
	}
	return 0;
    1157:	b8 00 00 00 00       	mov    $0x0,%eax

}
    115c:	c9                   	leave  
    115d:	c3                   	ret    
