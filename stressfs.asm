
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
       c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
      13:	73 74 72 65 
      17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
      1e:	73 73 66 73 
      22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
      29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
      2c:	c7 44 24 04 7d 11 00 	movl   $0x117d,0x4(%esp)
      33:	00 
      34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      3b:	e8 a3 05 00 00       	call   5e3 <printf>
  memset(data, 'a', sizeof(data));
      40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
      47:	00 
      48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
      4f:	00 
      50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
      54:	89 04 24             	mov    %eax,(%esp)
      57:	e8 12 02 00 00       	call   26e <memset>

  for(i = 0; i < 4; i++)
      5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
      63:	00 00 00 00 
      67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
      69:	e8 a5 03 00 00       	call   413 <fork>
      6e:	85 c0                	test   %eax,%eax
      70:	7e 02                	jle    74 <main+0x74>
      break;
      72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
      74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
      7b:	01 
      7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
      83:	03 
      84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
      86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
      8d:	89 44 24 08          	mov    %eax,0x8(%esp)
      91:	c7 44 24 04 90 11 00 	movl   $0x1190,0x4(%esp)
      98:	00 
      99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      a0:	e8 3e 05 00 00       	call   5e3 <printf>

  path[8] += i;
      a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
      ac:	00 
      ad:	89 c2                	mov    %eax,%edx
      af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
      b6:	01 d0                	add    %edx,%eax
      b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
      bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
      c6:	00 
      c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
      ce:	89 04 24             	mov    %eax,(%esp)
      d1:	e8 85 03 00 00       	call   45b <open>
      d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
      dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
      e4:	00 00 00 00 
      e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
      ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
      f1:	00 
      f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
      f6:	89 44 24 04          	mov    %eax,0x4(%esp)
      fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
     101:	89 04 24             	mov    %eax,(%esp)
     104:	e8 32 03 00 00       	call   43b <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
     109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
     110:	01 
     111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
     118:	13 
     119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
     11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
     122:	89 04 24             	mov    %eax,(%esp)
     125:	e8 19 03 00 00       	call   443 <close>

  printf(1, "read\n");
     12a:	c7 44 24 04 9a 11 00 	movl   $0x119a,0x4(%esp)
     131:	00 
     132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     139:	e8 a5 04 00 00       	call   5e3 <printf>

  fd = open(path, O_RDONLY);
     13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     145:	00 
     146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
     14d:	89 04 24             	mov    %eax,(%esp)
     150:	e8 06 03 00 00       	call   45b <open>
     155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
     15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
     163:	00 00 00 00 
     167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
     169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     170:	00 
     171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
     175:	89 44 24 04          	mov    %eax,0x4(%esp)
     179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
     180:	89 04 24             	mov    %eax,(%esp)
     183:	e8 ab 02 00 00       	call   433 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
     188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
     18f:	01 
     190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
     197:	13 
     198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
     19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
     1a1:	89 04 24             	mov    %eax,(%esp)
     1a4:	e8 9a 02 00 00       	call   443 <close>

  wait();
     1a9:	e8 75 02 00 00       	call   423 <wait>
  
  exit();
     1ae:	e8 68 02 00 00       	call   41b <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     1b3:	55                   	push   %ebp
     1b4:	89 e5                	mov    %esp,%ebp
     1b6:	57                   	push   %edi
     1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
     1bb:	8b 55 10             	mov    0x10(%ebp),%edx
     1be:	8b 45 0c             	mov    0xc(%ebp),%eax
     1c1:	89 cb                	mov    %ecx,%ebx
     1c3:	89 df                	mov    %ebx,%edi
     1c5:	89 d1                	mov    %edx,%ecx
     1c7:	fc                   	cld    
     1c8:	f3 aa                	rep stos %al,%es:(%edi)
     1ca:	89 ca                	mov    %ecx,%edx
     1cc:	89 fb                	mov    %edi,%ebx
     1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
     1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     1d4:	5b                   	pop    %ebx
     1d5:	5f                   	pop    %edi
     1d6:	5d                   	pop    %ebp
     1d7:	c3                   	ret    

000001d8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     1d8:	55                   	push   %ebp
     1d9:	89 e5                	mov    %esp,%ebp
     1db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     1de:	8b 45 08             	mov    0x8(%ebp),%eax
     1e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     1e4:	90                   	nop
     1e5:	8b 45 08             	mov    0x8(%ebp),%eax
     1e8:	8d 50 01             	lea    0x1(%eax),%edx
     1eb:	89 55 08             	mov    %edx,0x8(%ebp)
     1ee:	8b 55 0c             	mov    0xc(%ebp),%edx
     1f1:	8d 4a 01             	lea    0x1(%edx),%ecx
     1f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     1f7:	0f b6 12             	movzbl (%edx),%edx
     1fa:	88 10                	mov    %dl,(%eax)
     1fc:	0f b6 00             	movzbl (%eax),%eax
     1ff:	84 c0                	test   %al,%al
     201:	75 e2                	jne    1e5 <strcpy+0xd>
    ;
  return os;
     203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     206:	c9                   	leave  
     207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     208:	55                   	push   %ebp
     209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     20b:	eb 08                	jmp    215 <strcmp+0xd>
    p++, q++;
     20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     215:	8b 45 08             	mov    0x8(%ebp),%eax
     218:	0f b6 00             	movzbl (%eax),%eax
     21b:	84 c0                	test   %al,%al
     21d:	74 10                	je     22f <strcmp+0x27>
     21f:	8b 45 08             	mov    0x8(%ebp),%eax
     222:	0f b6 10             	movzbl (%eax),%edx
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	0f b6 00             	movzbl (%eax),%eax
     22b:	38 c2                	cmp    %al,%dl
     22d:	74 de                	je     20d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     22f:	8b 45 08             	mov    0x8(%ebp),%eax
     232:	0f b6 00             	movzbl (%eax),%eax
     235:	0f b6 d0             	movzbl %al,%edx
     238:	8b 45 0c             	mov    0xc(%ebp),%eax
     23b:	0f b6 00             	movzbl (%eax),%eax
     23e:	0f b6 c0             	movzbl %al,%eax
     241:	29 c2                	sub    %eax,%edx
     243:	89 d0                	mov    %edx,%eax
}
     245:	5d                   	pop    %ebp
     246:	c3                   	ret    

00000247 <strlen>:

uint
strlen(char *s)
{
     247:	55                   	push   %ebp
     248:	89 e5                	mov    %esp,%ebp
     24a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     24d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     254:	eb 04                	jmp    25a <strlen+0x13>
     256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     25d:	8b 45 08             	mov    0x8(%ebp),%eax
     260:	01 d0                	add    %edx,%eax
     262:	0f b6 00             	movzbl (%eax),%eax
     265:	84 c0                	test   %al,%al
     267:	75 ed                	jne    256 <strlen+0xf>
    ;
  return n;
     269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     26c:	c9                   	leave  
     26d:	c3                   	ret    

0000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
     26e:	55                   	push   %ebp
     26f:	89 e5                	mov    %esp,%ebp
     271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     274:	8b 45 10             	mov    0x10(%ebp),%eax
     277:	89 44 24 08          	mov    %eax,0x8(%esp)
     27b:	8b 45 0c             	mov    0xc(%ebp),%eax
     27e:	89 44 24 04          	mov    %eax,0x4(%esp)
     282:	8b 45 08             	mov    0x8(%ebp),%eax
     285:	89 04 24             	mov    %eax,(%esp)
     288:	e8 26 ff ff ff       	call   1b3 <stosb>
  return dst;
     28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     290:	c9                   	leave  
     291:	c3                   	ret    

00000292 <strchr>:

char*
strchr(const char *s, char c)
{
     292:	55                   	push   %ebp
     293:	89 e5                	mov    %esp,%ebp
     295:	83 ec 04             	sub    $0x4,%esp
     298:	8b 45 0c             	mov    0xc(%ebp),%eax
     29b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     29e:	eb 14                	jmp    2b4 <strchr+0x22>
    if(*s == c)
     2a0:	8b 45 08             	mov    0x8(%ebp),%eax
     2a3:	0f b6 00             	movzbl (%eax),%eax
     2a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
     2a9:	75 05                	jne    2b0 <strchr+0x1e>
      return (char*)s;
     2ab:	8b 45 08             	mov    0x8(%ebp),%eax
     2ae:	eb 13                	jmp    2c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2b4:	8b 45 08             	mov    0x8(%ebp),%eax
     2b7:	0f b6 00             	movzbl (%eax),%eax
     2ba:	84 c0                	test   %al,%al
     2bc:	75 e2                	jne    2a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     2be:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2c3:	c9                   	leave  
     2c4:	c3                   	ret    

000002c5 <gets>:

char*
gets(char *buf, int max)
{
     2c5:	55                   	push   %ebp
     2c6:	89 e5                	mov    %esp,%ebp
     2c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     2cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     2d2:	eb 4c                	jmp    320 <gets+0x5b>
    cc = read(0, &c, 1);
     2d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     2db:	00 
     2dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
     2df:	89 44 24 04          	mov    %eax,0x4(%esp)
     2e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2ea:	e8 44 01 00 00       	call   433 <read>
     2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2f6:	7f 02                	jg     2fa <gets+0x35>
      break;
     2f8:	eb 31                	jmp    32b <gets+0x66>
    buf[i++] = c;
     2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2fd:	8d 50 01             	lea    0x1(%eax),%edx
     300:	89 55 f4             	mov    %edx,-0xc(%ebp)
     303:	89 c2                	mov    %eax,%edx
     305:	8b 45 08             	mov    0x8(%ebp),%eax
     308:	01 c2                	add    %eax,%edx
     30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     314:	3c 0a                	cmp    $0xa,%al
     316:	74 13                	je     32b <gets+0x66>
     318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     31c:	3c 0d                	cmp    $0xd,%al
     31e:	74 0b                	je     32b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     320:	8b 45 f4             	mov    -0xc(%ebp),%eax
     323:	83 c0 01             	add    $0x1,%eax
     326:	3b 45 0c             	cmp    0xc(%ebp),%eax
     329:	7c a9                	jl     2d4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     32b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     32e:	8b 45 08             	mov    0x8(%ebp),%eax
     331:	01 d0                	add    %edx,%eax
     333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     336:	8b 45 08             	mov    0x8(%ebp),%eax
}
     339:	c9                   	leave  
     33a:	c3                   	ret    

0000033b <stat>:

int
stat(char *n, struct stat *st)
{
     33b:	55                   	push   %ebp
     33c:	89 e5                	mov    %esp,%ebp
     33e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     348:	00 
     349:	8b 45 08             	mov    0x8(%ebp),%eax
     34c:	89 04 24             	mov    %eax,(%esp)
     34f:	e8 07 01 00 00       	call   45b <open>
     354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     35b:	79 07                	jns    364 <stat+0x29>
    return -1;
     35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     362:	eb 23                	jmp    387 <stat+0x4c>
  r = fstat(fd, st);
     364:	8b 45 0c             	mov    0xc(%ebp),%eax
     367:	89 44 24 04          	mov    %eax,0x4(%esp)
     36b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36e:	89 04 24             	mov    %eax,(%esp)
     371:	e8 fd 00 00 00       	call   473 <fstat>
     376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     379:	8b 45 f4             	mov    -0xc(%ebp),%eax
     37c:	89 04 24             	mov    %eax,(%esp)
     37f:	e8 bf 00 00 00       	call   443 <close>
  return r;
     384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     387:	c9                   	leave  
     388:	c3                   	ret    

00000389 <atoi>:

int
atoi(const char *s)
{
     389:	55                   	push   %ebp
     38a:	89 e5                	mov    %esp,%ebp
     38c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     38f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     396:	eb 25                	jmp    3bd <atoi+0x34>
    n = n*10 + *s++ - '0';
     398:	8b 55 fc             	mov    -0x4(%ebp),%edx
     39b:	89 d0                	mov    %edx,%eax
     39d:	c1 e0 02             	shl    $0x2,%eax
     3a0:	01 d0                	add    %edx,%eax
     3a2:	01 c0                	add    %eax,%eax
     3a4:	89 c1                	mov    %eax,%ecx
     3a6:	8b 45 08             	mov    0x8(%ebp),%eax
     3a9:	8d 50 01             	lea    0x1(%eax),%edx
     3ac:	89 55 08             	mov    %edx,0x8(%ebp)
     3af:	0f b6 00             	movzbl (%eax),%eax
     3b2:	0f be c0             	movsbl %al,%eax
     3b5:	01 c8                	add    %ecx,%eax
     3b7:	83 e8 30             	sub    $0x30,%eax
     3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	0f b6 00             	movzbl (%eax),%eax
     3c3:	3c 2f                	cmp    $0x2f,%al
     3c5:	7e 0a                	jle    3d1 <atoi+0x48>
     3c7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ca:	0f b6 00             	movzbl (%eax),%eax
     3cd:	3c 39                	cmp    $0x39,%al
     3cf:	7e c7                	jle    398 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3d4:	c9                   	leave  
     3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     3d6:	55                   	push   %ebp
     3d7:	89 e5                	mov    %esp,%ebp
     3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     3dc:	8b 45 08             	mov    0x8(%ebp),%eax
     3df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     3e8:	eb 17                	jmp    401 <memmove+0x2b>
    *dst++ = *src++;
     3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
     3ed:	8d 50 01             	lea    0x1(%eax),%edx
     3f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
     3f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
     3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
     3f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     3fc:	0f b6 12             	movzbl (%edx),%edx
     3ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     401:	8b 45 10             	mov    0x10(%ebp),%eax
     404:	8d 50 ff             	lea    -0x1(%eax),%edx
     407:	89 55 10             	mov    %edx,0x10(%ebp)
     40a:	85 c0                	test   %eax,%eax
     40c:	7f dc                	jg     3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     411:	c9                   	leave  
     412:	c3                   	ret    

00000413 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     413:	b8 01 00 00 00       	mov    $0x1,%eax
     418:	cd 40                	int    $0x40
     41a:	c3                   	ret    

0000041b <exit>:
SYSCALL(exit)
     41b:	b8 02 00 00 00       	mov    $0x2,%eax
     420:	cd 40                	int    $0x40
     422:	c3                   	ret    

00000423 <wait>:
SYSCALL(wait)
     423:	b8 03 00 00 00       	mov    $0x3,%eax
     428:	cd 40                	int    $0x40
     42a:	c3                   	ret    

0000042b <pipe>:
SYSCALL(pipe)
     42b:	b8 04 00 00 00       	mov    $0x4,%eax
     430:	cd 40                	int    $0x40
     432:	c3                   	ret    

00000433 <read>:
SYSCALL(read)
     433:	b8 05 00 00 00       	mov    $0x5,%eax
     438:	cd 40                	int    $0x40
     43a:	c3                   	ret    

0000043b <write>:
SYSCALL(write)
     43b:	b8 10 00 00 00       	mov    $0x10,%eax
     440:	cd 40                	int    $0x40
     442:	c3                   	ret    

00000443 <close>:
SYSCALL(close)
     443:	b8 15 00 00 00       	mov    $0x15,%eax
     448:	cd 40                	int    $0x40
     44a:	c3                   	ret    

0000044b <kill>:
SYSCALL(kill)
     44b:	b8 06 00 00 00       	mov    $0x6,%eax
     450:	cd 40                	int    $0x40
     452:	c3                   	ret    

00000453 <exec>:
SYSCALL(exec)
     453:	b8 07 00 00 00       	mov    $0x7,%eax
     458:	cd 40                	int    $0x40
     45a:	c3                   	ret    

0000045b <open>:
SYSCALL(open)
     45b:	b8 0f 00 00 00       	mov    $0xf,%eax
     460:	cd 40                	int    $0x40
     462:	c3                   	ret    

00000463 <mknod>:
SYSCALL(mknod)
     463:	b8 11 00 00 00       	mov    $0x11,%eax
     468:	cd 40                	int    $0x40
     46a:	c3                   	ret    

0000046b <unlink>:
SYSCALL(unlink)
     46b:	b8 12 00 00 00       	mov    $0x12,%eax
     470:	cd 40                	int    $0x40
     472:	c3                   	ret    

00000473 <fstat>:
SYSCALL(fstat)
     473:	b8 08 00 00 00       	mov    $0x8,%eax
     478:	cd 40                	int    $0x40
     47a:	c3                   	ret    

0000047b <link>:
SYSCALL(link)
     47b:	b8 13 00 00 00       	mov    $0x13,%eax
     480:	cd 40                	int    $0x40
     482:	c3                   	ret    

00000483 <mkdir>:
SYSCALL(mkdir)
     483:	b8 14 00 00 00       	mov    $0x14,%eax
     488:	cd 40                	int    $0x40
     48a:	c3                   	ret    

0000048b <chdir>:
SYSCALL(chdir)
     48b:	b8 09 00 00 00       	mov    $0x9,%eax
     490:	cd 40                	int    $0x40
     492:	c3                   	ret    

00000493 <dup>:
SYSCALL(dup)
     493:	b8 0a 00 00 00       	mov    $0xa,%eax
     498:	cd 40                	int    $0x40
     49a:	c3                   	ret    

0000049b <getpid>:
SYSCALL(getpid)
     49b:	b8 0b 00 00 00       	mov    $0xb,%eax
     4a0:	cd 40                	int    $0x40
     4a2:	c3                   	ret    

000004a3 <sbrk>:
SYSCALL(sbrk)
     4a3:	b8 0c 00 00 00       	mov    $0xc,%eax
     4a8:	cd 40                	int    $0x40
     4aa:	c3                   	ret    

000004ab <sleep>:
SYSCALL(sleep)
     4ab:	b8 0d 00 00 00       	mov    $0xd,%eax
     4b0:	cd 40                	int    $0x40
     4b2:	c3                   	ret    

000004b3 <uptime>:
SYSCALL(uptime)
     4b3:	b8 0e 00 00 00       	mov    $0xe,%eax
     4b8:	cd 40                	int    $0x40
     4ba:	c3                   	ret    

000004bb <kthread_create>:




SYSCALL(kthread_create)
     4bb:	b8 16 00 00 00       	mov    $0x16,%eax
     4c0:	cd 40                	int    $0x40
     4c2:	c3                   	ret    

000004c3 <kthread_id>:
SYSCALL(kthread_id)
     4c3:	b8 17 00 00 00       	mov    $0x17,%eax
     4c8:	cd 40                	int    $0x40
     4ca:	c3                   	ret    

000004cb <kthread_exit>:
SYSCALL(kthread_exit)
     4cb:	b8 18 00 00 00       	mov    $0x18,%eax
     4d0:	cd 40                	int    $0x40
     4d2:	c3                   	ret    

000004d3 <kthread_join>:
SYSCALL(kthread_join)
     4d3:	b8 19 00 00 00       	mov    $0x19,%eax
     4d8:	cd 40                	int    $0x40
     4da:	c3                   	ret    

000004db <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     4db:	b8 1a 00 00 00       	mov    $0x1a,%eax
     4e0:	cd 40                	int    $0x40
     4e2:	c3                   	ret    

000004e3 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     4e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
     4e8:	cd 40                	int    $0x40
     4ea:	c3                   	ret    

000004eb <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     4eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
     4f0:	cd 40                	int    $0x40
     4f2:	c3                   	ret    

000004f3 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     4f3:	b8 1d 00 00 00       	mov    $0x1d,%eax
     4f8:	cd 40                	int    $0x40
     4fa:	c3                   	ret    

000004fb <kthread_mutex_yieldlock>:
     4fb:	b8 1e 00 00 00       	mov    $0x1e,%eax
     500:	cd 40                	int    $0x40
     502:	c3                   	ret    

00000503 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     503:	55                   	push   %ebp
     504:	89 e5                	mov    %esp,%ebp
     506:	83 ec 18             	sub    $0x18,%esp
     509:	8b 45 0c             	mov    0xc(%ebp),%eax
     50c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     50f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     516:	00 
     517:	8d 45 f4             	lea    -0xc(%ebp),%eax
     51a:	89 44 24 04          	mov    %eax,0x4(%esp)
     51e:	8b 45 08             	mov    0x8(%ebp),%eax
     521:	89 04 24             	mov    %eax,(%esp)
     524:	e8 12 ff ff ff       	call   43b <write>
}
     529:	c9                   	leave  
     52a:	c3                   	ret    

0000052b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     52b:	55                   	push   %ebp
     52c:	89 e5                	mov    %esp,%ebp
     52e:	56                   	push   %esi
     52f:	53                   	push   %ebx
     530:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     533:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     53a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     53e:	74 17                	je     557 <printint+0x2c>
     540:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     544:	79 11                	jns    557 <printint+0x2c>
    neg = 1;
     546:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     54d:	8b 45 0c             	mov    0xc(%ebp),%eax
     550:	f7 d8                	neg    %eax
     552:	89 45 ec             	mov    %eax,-0x14(%ebp)
     555:	eb 06                	jmp    55d <printint+0x32>
  } else {
    x = xx;
     557:	8b 45 0c             	mov    0xc(%ebp),%eax
     55a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     55d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     564:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     567:	8d 41 01             	lea    0x1(%ecx),%eax
     56a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     56d:	8b 5d 10             	mov    0x10(%ebp),%ebx
     570:	8b 45 ec             	mov    -0x14(%ebp),%eax
     573:	ba 00 00 00 00       	mov    $0x0,%edx
     578:	f7 f3                	div    %ebx
     57a:	89 d0                	mov    %edx,%eax
     57c:	0f b6 80 2c 16 00 00 	movzbl 0x162c(%eax),%eax
     583:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     587:	8b 75 10             	mov    0x10(%ebp),%esi
     58a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     58d:	ba 00 00 00 00       	mov    $0x0,%edx
     592:	f7 f6                	div    %esi
     594:	89 45 ec             	mov    %eax,-0x14(%ebp)
     597:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     59b:	75 c7                	jne    564 <printint+0x39>
  if(neg)
     59d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     5a1:	74 10                	je     5b3 <printint+0x88>
    buf[i++] = '-';
     5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a6:	8d 50 01             	lea    0x1(%eax),%edx
     5a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     5ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     5b1:	eb 1f                	jmp    5d2 <printint+0xa7>
     5b3:	eb 1d                	jmp    5d2 <printint+0xa7>
    putc(fd, buf[i]);
     5b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
     5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5bb:	01 d0                	add    %edx,%eax
     5bd:	0f b6 00             	movzbl (%eax),%eax
     5c0:	0f be c0             	movsbl %al,%eax
     5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
     5c7:	8b 45 08             	mov    0x8(%ebp),%eax
     5ca:	89 04 24             	mov    %eax,(%esp)
     5cd:	e8 31 ff ff ff       	call   503 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     5d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     5d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5da:	79 d9                	jns    5b5 <printint+0x8a>
    putc(fd, buf[i]);
}
     5dc:	83 c4 30             	add    $0x30,%esp
     5df:	5b                   	pop    %ebx
     5e0:	5e                   	pop    %esi
     5e1:	5d                   	pop    %ebp
     5e2:	c3                   	ret    

000005e3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     5e3:	55                   	push   %ebp
     5e4:	89 e5                	mov    %esp,%ebp
     5e6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     5e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     5f0:	8d 45 0c             	lea    0xc(%ebp),%eax
     5f3:	83 c0 04             	add    $0x4,%eax
     5f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     5f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     600:	e9 7c 01 00 00       	jmp    781 <printf+0x19e>
    c = fmt[i] & 0xff;
     605:	8b 55 0c             	mov    0xc(%ebp),%edx
     608:	8b 45 f0             	mov    -0x10(%ebp),%eax
     60b:	01 d0                	add    %edx,%eax
     60d:	0f b6 00             	movzbl (%eax),%eax
     610:	0f be c0             	movsbl %al,%eax
     613:	25 ff 00 00 00       	and    $0xff,%eax
     618:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     61b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     61f:	75 2c                	jne    64d <printf+0x6a>
      if(c == '%'){
     621:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     625:	75 0c                	jne    633 <printf+0x50>
        state = '%';
     627:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     62e:	e9 4a 01 00 00       	jmp    77d <printf+0x19a>
      } else {
        putc(fd, c);
     633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     636:	0f be c0             	movsbl %al,%eax
     639:	89 44 24 04          	mov    %eax,0x4(%esp)
     63d:	8b 45 08             	mov    0x8(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 bb fe ff ff       	call   503 <putc>
     648:	e9 30 01 00 00       	jmp    77d <printf+0x19a>
      }
    } else if(state == '%'){
     64d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     651:	0f 85 26 01 00 00    	jne    77d <printf+0x19a>
      if(c == 'd'){
     657:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     65b:	75 2d                	jne    68a <printf+0xa7>
        printint(fd, *ap, 10, 1);
     65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     660:	8b 00                	mov    (%eax),%eax
     662:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     669:	00 
     66a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     671:	00 
     672:	89 44 24 04          	mov    %eax,0x4(%esp)
     676:	8b 45 08             	mov    0x8(%ebp),%eax
     679:	89 04 24             	mov    %eax,(%esp)
     67c:	e8 aa fe ff ff       	call   52b <printint>
        ap++;
     681:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     685:	e9 ec 00 00 00       	jmp    776 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     68a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     68e:	74 06                	je     696 <printf+0xb3>
     690:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     694:	75 2d                	jne    6c3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     696:	8b 45 e8             	mov    -0x18(%ebp),%eax
     699:	8b 00                	mov    (%eax),%eax
     69b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6a2:	00 
     6a3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     6aa:	00 
     6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
     6af:	8b 45 08             	mov    0x8(%ebp),%eax
     6b2:	89 04 24             	mov    %eax,(%esp)
     6b5:	e8 71 fe ff ff       	call   52b <printint>
        ap++;
     6ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     6be:	e9 b3 00 00 00       	jmp    776 <printf+0x193>
      } else if(c == 's'){
     6c3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     6c7:	75 45                	jne    70e <printf+0x12b>
        s = (char*)*ap;
     6c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6cc:	8b 00                	mov    (%eax),%eax
     6ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     6d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     6d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6d9:	75 09                	jne    6e4 <printf+0x101>
          s = "(null)";
     6db:	c7 45 f4 a0 11 00 00 	movl   $0x11a0,-0xc(%ebp)
        while(*s != 0){
     6e2:	eb 1e                	jmp    702 <printf+0x11f>
     6e4:	eb 1c                	jmp    702 <printf+0x11f>
          putc(fd, *s);
     6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e9:	0f b6 00             	movzbl (%eax),%eax
     6ec:	0f be c0             	movsbl %al,%eax
     6ef:	89 44 24 04          	mov    %eax,0x4(%esp)
     6f3:	8b 45 08             	mov    0x8(%ebp),%eax
     6f6:	89 04 24             	mov    %eax,(%esp)
     6f9:	e8 05 fe ff ff       	call   503 <putc>
          s++;
     6fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     702:	8b 45 f4             	mov    -0xc(%ebp),%eax
     705:	0f b6 00             	movzbl (%eax),%eax
     708:	84 c0                	test   %al,%al
     70a:	75 da                	jne    6e6 <printf+0x103>
     70c:	eb 68                	jmp    776 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     70e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     712:	75 1d                	jne    731 <printf+0x14e>
        putc(fd, *ap);
     714:	8b 45 e8             	mov    -0x18(%ebp),%eax
     717:	8b 00                	mov    (%eax),%eax
     719:	0f be c0             	movsbl %al,%eax
     71c:	89 44 24 04          	mov    %eax,0x4(%esp)
     720:	8b 45 08             	mov    0x8(%ebp),%eax
     723:	89 04 24             	mov    %eax,(%esp)
     726:	e8 d8 fd ff ff       	call   503 <putc>
        ap++;
     72b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     72f:	eb 45                	jmp    776 <printf+0x193>
      } else if(c == '%'){
     731:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     735:	75 17                	jne    74e <printf+0x16b>
        putc(fd, c);
     737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     73a:	0f be c0             	movsbl %al,%eax
     73d:	89 44 24 04          	mov    %eax,0x4(%esp)
     741:	8b 45 08             	mov    0x8(%ebp),%eax
     744:	89 04 24             	mov    %eax,(%esp)
     747:	e8 b7 fd ff ff       	call   503 <putc>
     74c:	eb 28                	jmp    776 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     74e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     755:	00 
     756:	8b 45 08             	mov    0x8(%ebp),%eax
     759:	89 04 24             	mov    %eax,(%esp)
     75c:	e8 a2 fd ff ff       	call   503 <putc>
        putc(fd, c);
     761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     764:	0f be c0             	movsbl %al,%eax
     767:	89 44 24 04          	mov    %eax,0x4(%esp)
     76b:	8b 45 08             	mov    0x8(%ebp),%eax
     76e:	89 04 24             	mov    %eax,(%esp)
     771:	e8 8d fd ff ff       	call   503 <putc>
      }
      state = 0;
     776:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     77d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     781:	8b 55 0c             	mov    0xc(%ebp),%edx
     784:	8b 45 f0             	mov    -0x10(%ebp),%eax
     787:	01 d0                	add    %edx,%eax
     789:	0f b6 00             	movzbl (%eax),%eax
     78c:	84 c0                	test   %al,%al
     78e:	0f 85 71 fe ff ff    	jne    605 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     794:	c9                   	leave  
     795:	c3                   	ret    

00000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     796:	55                   	push   %ebp
     797:	89 e5                	mov    %esp,%ebp
     799:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     79c:	8b 45 08             	mov    0x8(%ebp),%eax
     79f:	83 e8 08             	sub    $0x8,%eax
     7a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7a5:	a1 48 16 00 00       	mov    0x1648,%eax
     7aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7ad:	eb 24                	jmp    7d3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7b2:	8b 00                	mov    (%eax),%eax
     7b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7b7:	77 12                	ja     7cb <free+0x35>
     7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7bf:	77 24                	ja     7e5 <free+0x4f>
     7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7c4:	8b 00                	mov    (%eax),%eax
     7c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7c9:	77 1a                	ja     7e5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7ce:	8b 00                	mov    (%eax),%eax
     7d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7d9:	76 d4                	jbe    7af <free+0x19>
     7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7de:	8b 00                	mov    (%eax),%eax
     7e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7e3:	76 ca                	jbe    7af <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     7e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7e8:	8b 40 04             	mov    0x4(%eax),%eax
     7eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7f5:	01 c2                	add    %eax,%edx
     7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7fa:	8b 00                	mov    (%eax),%eax
     7fc:	39 c2                	cmp    %eax,%edx
     7fe:	75 24                	jne    824 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     800:	8b 45 f8             	mov    -0x8(%ebp),%eax
     803:	8b 50 04             	mov    0x4(%eax),%edx
     806:	8b 45 fc             	mov    -0x4(%ebp),%eax
     809:	8b 00                	mov    (%eax),%eax
     80b:	8b 40 04             	mov    0x4(%eax),%eax
     80e:	01 c2                	add    %eax,%edx
     810:	8b 45 f8             	mov    -0x8(%ebp),%eax
     813:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     816:	8b 45 fc             	mov    -0x4(%ebp),%eax
     819:	8b 00                	mov    (%eax),%eax
     81b:	8b 10                	mov    (%eax),%edx
     81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     820:	89 10                	mov    %edx,(%eax)
     822:	eb 0a                	jmp    82e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     824:	8b 45 fc             	mov    -0x4(%ebp),%eax
     827:	8b 10                	mov    (%eax),%edx
     829:	8b 45 f8             	mov    -0x8(%ebp),%eax
     82c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     831:	8b 40 04             	mov    0x4(%eax),%eax
     834:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     83e:	01 d0                	add    %edx,%eax
     840:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     843:	75 20                	jne    865 <free+0xcf>
    p->s.size += bp->s.size;
     845:	8b 45 fc             	mov    -0x4(%ebp),%eax
     848:	8b 50 04             	mov    0x4(%eax),%edx
     84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     84e:	8b 40 04             	mov    0x4(%eax),%eax
     851:	01 c2                	add    %eax,%edx
     853:	8b 45 fc             	mov    -0x4(%ebp),%eax
     856:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     859:	8b 45 f8             	mov    -0x8(%ebp),%eax
     85c:	8b 10                	mov    (%eax),%edx
     85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     861:	89 10                	mov    %edx,(%eax)
     863:	eb 08                	jmp    86d <free+0xd7>
  } else
    p->s.ptr = bp;
     865:	8b 45 fc             	mov    -0x4(%ebp),%eax
     868:	8b 55 f8             	mov    -0x8(%ebp),%edx
     86b:	89 10                	mov    %edx,(%eax)
  freep = p;
     86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     870:	a3 48 16 00 00       	mov    %eax,0x1648
}
     875:	c9                   	leave  
     876:	c3                   	ret    

00000877 <morecore>:

static Header*
morecore(uint nu)
{
     877:	55                   	push   %ebp
     878:	89 e5                	mov    %esp,%ebp
     87a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     87d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     884:	77 07                	ja     88d <morecore+0x16>
    nu = 4096;
     886:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     88d:	8b 45 08             	mov    0x8(%ebp),%eax
     890:	c1 e0 03             	shl    $0x3,%eax
     893:	89 04 24             	mov    %eax,(%esp)
     896:	e8 08 fc ff ff       	call   4a3 <sbrk>
     89b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     89e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     8a2:	75 07                	jne    8ab <morecore+0x34>
    return 0;
     8a4:	b8 00 00 00 00       	mov    $0x0,%eax
     8a9:	eb 22                	jmp    8cd <morecore+0x56>
  hp = (Header*)p;
     8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8b4:	8b 55 08             	mov    0x8(%ebp),%edx
     8b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8bd:	83 c0 08             	add    $0x8,%eax
     8c0:	89 04 24             	mov    %eax,(%esp)
     8c3:	e8 ce fe ff ff       	call   796 <free>
  return freep;
     8c8:	a1 48 16 00 00       	mov    0x1648,%eax
}
     8cd:	c9                   	leave  
     8ce:	c3                   	ret    

000008cf <malloc>:

void*
malloc(uint nbytes)
{
     8cf:	55                   	push   %ebp
     8d0:	89 e5                	mov    %esp,%ebp
     8d2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     8d5:	8b 45 08             	mov    0x8(%ebp),%eax
     8d8:	83 c0 07             	add    $0x7,%eax
     8db:	c1 e8 03             	shr    $0x3,%eax
     8de:	83 c0 01             	add    $0x1,%eax
     8e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     8e4:	a1 48 16 00 00       	mov    0x1648,%eax
     8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     8ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8f0:	75 23                	jne    915 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     8f2:	c7 45 f0 40 16 00 00 	movl   $0x1640,-0x10(%ebp)
     8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8fc:	a3 48 16 00 00       	mov    %eax,0x1648
     901:	a1 48 16 00 00       	mov    0x1648,%eax
     906:	a3 40 16 00 00       	mov    %eax,0x1640
    base.s.size = 0;
     90b:	c7 05 44 16 00 00 00 	movl   $0x0,0x1644
     912:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     915:	8b 45 f0             	mov    -0x10(%ebp),%eax
     918:	8b 00                	mov    (%eax),%eax
     91a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     920:	8b 40 04             	mov    0x4(%eax),%eax
     923:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     926:	72 4d                	jb     975 <malloc+0xa6>
      if(p->s.size == nunits)
     928:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92b:	8b 40 04             	mov    0x4(%eax),%eax
     92e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     931:	75 0c                	jne    93f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     933:	8b 45 f4             	mov    -0xc(%ebp),%eax
     936:	8b 10                	mov    (%eax),%edx
     938:	8b 45 f0             	mov    -0x10(%ebp),%eax
     93b:	89 10                	mov    %edx,(%eax)
     93d:	eb 26                	jmp    965 <malloc+0x96>
      else {
        p->s.size -= nunits;
     93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     942:	8b 40 04             	mov    0x4(%eax),%eax
     945:	2b 45 ec             	sub    -0x14(%ebp),%eax
     948:	89 c2                	mov    %eax,%edx
     94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     950:	8b 45 f4             	mov    -0xc(%ebp),%eax
     953:	8b 40 04             	mov    0x4(%eax),%eax
     956:	c1 e0 03             	shl    $0x3,%eax
     959:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     95f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     962:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     965:	8b 45 f0             	mov    -0x10(%ebp),%eax
     968:	a3 48 16 00 00       	mov    %eax,0x1648
      return (void*)(p + 1);
     96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     970:	83 c0 08             	add    $0x8,%eax
     973:	eb 38                	jmp    9ad <malloc+0xde>
    }
    if(p == freep)
     975:	a1 48 16 00 00       	mov    0x1648,%eax
     97a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     97d:	75 1b                	jne    99a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     97f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     982:	89 04 24             	mov    %eax,(%esp)
     985:	e8 ed fe ff ff       	call   877 <morecore>
     98a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     98d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     991:	75 07                	jne    99a <malloc+0xcb>
        return 0;
     993:	b8 00 00 00 00       	mov    $0x0,%eax
     998:	eb 13                	jmp    9ad <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     99d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9a3:	8b 00                	mov    (%eax),%eax
     9a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     9a8:	e9 70 ff ff ff       	jmp    91d <malloc+0x4e>
}
     9ad:	c9                   	leave  
     9ae:	c3                   	ret    

000009af <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     9af:	55                   	push   %ebp
     9b0:	89 e5                	mov    %esp,%ebp
     9b2:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     9b5:	e8 21 fb ff ff       	call   4db <kthread_mutex_alloc>
     9ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     9bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     9c1:	79 0a                	jns    9cd <mesa_slots_monitor_alloc+0x1e>
		return 0;
     9c3:	b8 00 00 00 00       	mov    $0x0,%eax
     9c8:	e9 8b 00 00 00       	jmp    a58 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     9cd:	e8 44 06 00 00       	call   1016 <mesa_cond_alloc>
     9d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     9d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9d9:	75 12                	jne    9ed <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     9db:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9de:	89 04 24             	mov    %eax,(%esp)
     9e1:	e8 fd fa ff ff       	call   4e3 <kthread_mutex_dealloc>
		return 0;
     9e6:	b8 00 00 00 00       	mov    $0x0,%eax
     9eb:	eb 6b                	jmp    a58 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     9ed:	e8 24 06 00 00       	call   1016 <mesa_cond_alloc>
     9f2:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     9f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     9f9:	75 1d                	jne    a18 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fe:	89 04 24             	mov    %eax,(%esp)
     a01:	e8 dd fa ff ff       	call   4e3 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a09:	89 04 24             	mov    %eax,(%esp)
     a0c:	e8 46 06 00 00       	call   1057 <mesa_cond_dealloc>
		return 0;
     a11:	b8 00 00 00 00       	mov    $0x0,%eax
     a16:	eb 40                	jmp    a58 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     a18:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     a1f:	e8 ab fe ff ff       	call   8cf <malloc>
     a24:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a2d:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a33:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a36:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a3f:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a4e:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     a55:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     a58:	c9                   	leave  
     a59:	c3                   	ret    

00000a5a <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     a5a:	55                   	push   %ebp
     a5b:	89 e5                	mov    %esp,%ebp
     a5d:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     a60:	8b 45 08             	mov    0x8(%ebp),%eax
     a63:	8b 00                	mov    (%eax),%eax
     a65:	89 04 24             	mov    %eax,(%esp)
     a68:	e8 76 fa ff ff       	call   4e3 <kthread_mutex_dealloc>
     a6d:	85 c0                	test   %eax,%eax
     a6f:	78 2e                	js     a9f <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     a71:	8b 45 08             	mov    0x8(%ebp),%eax
     a74:	8b 40 04             	mov    0x4(%eax),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 97 05 00 00       	call   1016 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     a7f:	8b 45 08             	mov    0x8(%ebp),%eax
     a82:	8b 40 08             	mov    0x8(%eax),%eax
     a85:	89 04 24             	mov    %eax,(%esp)
     a88:	e8 89 05 00 00       	call   1016 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     a8d:	8b 45 08             	mov    0x8(%ebp),%eax
     a90:	89 04 24             	mov    %eax,(%esp)
     a93:	e8 fe fc ff ff       	call   796 <free>
	return 0;
     a98:	b8 00 00 00 00       	mov    $0x0,%eax
     a9d:	eb 05                	jmp    aa4 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     aa4:	c9                   	leave  
     aa5:	c3                   	ret    

00000aa6 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     aa6:	55                   	push   %ebp
     aa7:	89 e5                	mov    %esp,%ebp
     aa9:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     aac:	8b 45 08             	mov    0x8(%ebp),%eax
     aaf:	8b 40 10             	mov    0x10(%eax),%eax
     ab2:	85 c0                	test   %eax,%eax
     ab4:	75 0a                	jne    ac0 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     abb:	e9 81 00 00 00       	jmp    b41 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ac0:	8b 45 08             	mov    0x8(%ebp),%eax
     ac3:	8b 00                	mov    (%eax),%eax
     ac5:	89 04 24             	mov    %eax,(%esp)
     ac8:	e8 1e fa ff ff       	call   4eb <kthread_mutex_lock>
     acd:	83 f8 ff             	cmp    $0xffffffff,%eax
     ad0:	7d 07                	jge    ad9 <mesa_slots_monitor_addslots+0x33>
		return -1;
     ad2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ad7:	eb 68                	jmp    b41 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     ad9:	eb 17                	jmp    af2 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     adb:	8b 45 08             	mov    0x8(%ebp),%eax
     ade:	8b 10                	mov    (%eax),%edx
     ae0:	8b 45 08             	mov    0x8(%ebp),%eax
     ae3:	8b 40 08             	mov    0x8(%eax),%eax
     ae6:	89 54 24 04          	mov    %edx,0x4(%esp)
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 af 05 00 00       	call   10a1 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     af2:	8b 45 08             	mov    0x8(%ebp),%eax
     af5:	8b 40 10             	mov    0x10(%eax),%eax
     af8:	85 c0                	test   %eax,%eax
     afa:	74 0a                	je     b06 <mesa_slots_monitor_addslots+0x60>
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
     aff:	8b 40 0c             	mov    0xc(%eax),%eax
     b02:	85 c0                	test   %eax,%eax
     b04:	7f d5                	jg     adb <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     b06:	8b 45 08             	mov    0x8(%ebp),%eax
     b09:	8b 40 10             	mov    0x10(%eax),%eax
     b0c:	85 c0                	test   %eax,%eax
     b0e:	74 11                	je     b21 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     b10:	8b 45 08             	mov    0x8(%ebp),%eax
     b13:	8b 50 0c             	mov    0xc(%eax),%edx
     b16:	8b 45 0c             	mov    0xc(%ebp),%eax
     b19:	01 c2                	add    %eax,%edx
     b1b:	8b 45 08             	mov    0x8(%ebp),%eax
     b1e:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     b21:	8b 45 08             	mov    0x8(%ebp),%eax
     b24:	8b 40 04             	mov    0x4(%eax),%eax
     b27:	89 04 24             	mov    %eax,(%esp)
     b2a:	e8 dc 05 00 00       	call   110b <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     b2f:	8b 45 08             	mov    0x8(%ebp),%eax
     b32:	8b 00                	mov    (%eax),%eax
     b34:	89 04 24             	mov    %eax,(%esp)
     b37:	e8 b7 f9 ff ff       	call   4f3 <kthread_mutex_unlock>

	return 1;
     b3c:	b8 01 00 00 00       	mov    $0x1,%eax


}
     b41:	c9                   	leave  
     b42:	c3                   	ret    

00000b43 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     b43:	55                   	push   %ebp
     b44:	89 e5                	mov    %esp,%ebp
     b46:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     b49:	8b 45 08             	mov    0x8(%ebp),%eax
     b4c:	8b 40 10             	mov    0x10(%eax),%eax
     b4f:	85 c0                	test   %eax,%eax
     b51:	75 07                	jne    b5a <mesa_slots_monitor_takeslot+0x17>
		return -1;
     b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b58:	eb 7f                	jmp    bd9 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     b5a:	8b 45 08             	mov    0x8(%ebp),%eax
     b5d:	8b 00                	mov    (%eax),%eax
     b5f:	89 04 24             	mov    %eax,(%esp)
     b62:	e8 84 f9 ff ff       	call   4eb <kthread_mutex_lock>
     b67:	83 f8 ff             	cmp    $0xffffffff,%eax
     b6a:	7d 07                	jge    b73 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     b6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b71:	eb 66                	jmp    bd9 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     b73:	eb 17                	jmp    b8c <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     b75:	8b 45 08             	mov    0x8(%ebp),%eax
     b78:	8b 10                	mov    (%eax),%edx
     b7a:	8b 45 08             	mov    0x8(%ebp),%eax
     b7d:	8b 40 04             	mov    0x4(%eax),%eax
     b80:	89 54 24 04          	mov    %edx,0x4(%esp)
     b84:	89 04 24             	mov    %eax,(%esp)
     b87:	e8 15 05 00 00       	call   10a1 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     b8c:	8b 45 08             	mov    0x8(%ebp),%eax
     b8f:	8b 40 10             	mov    0x10(%eax),%eax
     b92:	85 c0                	test   %eax,%eax
     b94:	74 0a                	je     ba0 <mesa_slots_monitor_takeslot+0x5d>
     b96:	8b 45 08             	mov    0x8(%ebp),%eax
     b99:	8b 40 0c             	mov    0xc(%eax),%eax
     b9c:	85 c0                	test   %eax,%eax
     b9e:	74 d5                	je     b75 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     ba0:	8b 45 08             	mov    0x8(%ebp),%eax
     ba3:	8b 40 10             	mov    0x10(%eax),%eax
     ba6:	85 c0                	test   %eax,%eax
     ba8:	74 0f                	je     bb9 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     baa:	8b 45 08             	mov    0x8(%ebp),%eax
     bad:	8b 40 0c             	mov    0xc(%eax),%eax
     bb0:	8d 50 ff             	lea    -0x1(%eax),%edx
     bb3:	8b 45 08             	mov    0x8(%ebp),%eax
     bb6:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     bb9:	8b 45 08             	mov    0x8(%ebp),%eax
     bbc:	8b 40 08             	mov    0x8(%eax),%eax
     bbf:	89 04 24             	mov    %eax,(%esp)
     bc2:	e8 44 05 00 00       	call   110b <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     bc7:	8b 45 08             	mov    0x8(%ebp),%eax
     bca:	8b 00                	mov    (%eax),%eax
     bcc:	89 04 24             	mov    %eax,(%esp)
     bcf:	e8 1f f9 ff ff       	call   4f3 <kthread_mutex_unlock>

	return 1;
     bd4:	b8 01 00 00 00       	mov    $0x1,%eax

}
     bd9:	c9                   	leave  
     bda:	c3                   	ret    

00000bdb <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     bdb:	55                   	push   %ebp
     bdc:	89 e5                	mov    %esp,%ebp
     bde:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     be1:	8b 45 08             	mov    0x8(%ebp),%eax
     be4:	8b 40 10             	mov    0x10(%eax),%eax
     be7:	85 c0                	test   %eax,%eax
     be9:	75 07                	jne    bf2 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bf0:	eb 35                	jmp    c27 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bf2:	8b 45 08             	mov    0x8(%ebp),%eax
     bf5:	8b 00                	mov    (%eax),%eax
     bf7:	89 04 24             	mov    %eax,(%esp)
     bfa:	e8 ec f8 ff ff       	call   4eb <kthread_mutex_lock>
     bff:	83 f8 ff             	cmp    $0xffffffff,%eax
     c02:	7d 07                	jge    c0b <mesa_slots_monitor_stopadding+0x30>
			return -1;
     c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c09:	eb 1c                	jmp    c27 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     c0b:	8b 45 08             	mov    0x8(%ebp),%eax
     c0e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     c15:	8b 45 08             	mov    0x8(%ebp),%eax
     c18:	8b 00                	mov    (%eax),%eax
     c1a:	89 04 24             	mov    %eax,(%esp)
     c1d:	e8 d1 f8 ff ff       	call   4f3 <kthread_mutex_unlock>

		return 0;
     c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c27:	c9                   	leave  
     c28:	c3                   	ret    

00000c29 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     c29:	55                   	push   %ebp
     c2a:	89 e5                	mov    %esp,%ebp
     c2c:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     c2f:	e8 a7 f8 ff ff       	call   4db <kthread_mutex_alloc>
     c34:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c3b:	79 0a                	jns    c47 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     c3d:	b8 00 00 00 00       	mov    $0x0,%eax
     c42:	e9 8b 00 00 00       	jmp    cd2 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     c47:	e8 68 02 00 00       	call   eb4 <hoare_cond_alloc>
     c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c53:	75 12                	jne    c67 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c58:	89 04 24             	mov    %eax,(%esp)
     c5b:	e8 83 f8 ff ff       	call   4e3 <kthread_mutex_dealloc>
		return 0;
     c60:	b8 00 00 00 00       	mov    $0x0,%eax
     c65:	eb 6b                	jmp    cd2 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     c67:	e8 48 02 00 00       	call   eb4 <hoare_cond_alloc>
     c6c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     c6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c73:	75 1d                	jne    c92 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c78:	89 04 24             	mov    %eax,(%esp)
     c7b:	e8 63 f8 ff ff       	call   4e3 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c83:	89 04 24             	mov    %eax,(%esp)
     c86:	e8 6a 02 00 00       	call   ef5 <hoare_cond_dealloc>
		return 0;
     c8b:	b8 00 00 00 00       	mov    $0x0,%eax
     c90:	eb 40                	jmp    cd2 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     c92:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     c99:	e8 31 fc ff ff       	call   8cf <malloc>
     c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     ca1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca4:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ca7:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cb0:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cb9:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     cc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cc8:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     cd2:	c9                   	leave  
     cd3:	c3                   	ret    

00000cd4 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     cd4:	55                   	push   %ebp
     cd5:	89 e5                	mov    %esp,%ebp
     cd7:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	8b 00                	mov    (%eax),%eax
     cdf:	89 04 24             	mov    %eax,(%esp)
     ce2:	e8 fc f7 ff ff       	call   4e3 <kthread_mutex_dealloc>
     ce7:	85 c0                	test   %eax,%eax
     ce9:	78 2e                	js     d19 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     ceb:	8b 45 08             	mov    0x8(%ebp),%eax
     cee:	8b 40 04             	mov    0x4(%eax),%eax
     cf1:	89 04 24             	mov    %eax,(%esp)
     cf4:	e8 bb 01 00 00       	call   eb4 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     cf9:	8b 45 08             	mov    0x8(%ebp),%eax
     cfc:	8b 40 08             	mov    0x8(%eax),%eax
     cff:	89 04 24             	mov    %eax,(%esp)
     d02:	e8 ad 01 00 00       	call   eb4 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	89 04 24             	mov    %eax,(%esp)
     d0d:	e8 84 fa ff ff       	call   796 <free>
	return 0;
     d12:	b8 00 00 00 00       	mov    $0x0,%eax
     d17:	eb 05                	jmp    d1e <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     d1e:	c9                   	leave  
     d1f:	c3                   	ret    

00000d20 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	8b 40 10             	mov    0x10(%eax),%eax
     d2c:	85 c0                	test   %eax,%eax
     d2e:	75 0a                	jne    d3a <hoare_slots_monitor_addslots+0x1a>
		return -1;
     d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d35:	e9 88 00 00 00       	jmp    dc2 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d3a:	8b 45 08             	mov    0x8(%ebp),%eax
     d3d:	8b 00                	mov    (%eax),%eax
     d3f:	89 04 24             	mov    %eax,(%esp)
     d42:	e8 a4 f7 ff ff       	call   4eb <kthread_mutex_lock>
     d47:	83 f8 ff             	cmp    $0xffffffff,%eax
     d4a:	7d 07                	jge    d53 <hoare_slots_monitor_addslots+0x33>
		return -1;
     d4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d51:	eb 6f                	jmp    dc2 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     d53:	8b 45 08             	mov    0x8(%ebp),%eax
     d56:	8b 40 10             	mov    0x10(%eax),%eax
     d59:	85 c0                	test   %eax,%eax
     d5b:	74 21                	je     d7e <hoare_slots_monitor_addslots+0x5e>
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	8b 40 0c             	mov    0xc(%eax),%eax
     d63:	85 c0                	test   %eax,%eax
     d65:	7e 17                	jle    d7e <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	8b 10                	mov    (%eax),%edx
     d6c:	8b 45 08             	mov    0x8(%ebp),%eax
     d6f:	8b 40 08             	mov    0x8(%eax),%eax
     d72:	89 54 24 04          	mov    %edx,0x4(%esp)
     d76:	89 04 24             	mov    %eax,(%esp)
     d79:	e8 c1 01 00 00       	call   f3f <hoare_cond_wait>


	if  ( monitor->active)
     d7e:	8b 45 08             	mov    0x8(%ebp),%eax
     d81:	8b 40 10             	mov    0x10(%eax),%eax
     d84:	85 c0                	test   %eax,%eax
     d86:	74 11                	je     d99 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     d88:	8b 45 08             	mov    0x8(%ebp),%eax
     d8b:	8b 50 0c             	mov    0xc(%eax),%edx
     d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d91:	01 c2                	add    %eax,%edx
     d93:	8b 45 08             	mov    0x8(%ebp),%eax
     d96:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     d99:	8b 45 08             	mov    0x8(%ebp),%eax
     d9c:	8b 10                	mov    (%eax),%edx
     d9e:	8b 45 08             	mov    0x8(%ebp),%eax
     da1:	8b 40 04             	mov    0x4(%eax),%eax
     da4:	89 54 24 04          	mov    %edx,0x4(%esp)
     da8:	89 04 24             	mov    %eax,(%esp)
     dab:	e8 e6 01 00 00       	call   f96 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     db0:	8b 45 08             	mov    0x8(%ebp),%eax
     db3:	8b 00                	mov    (%eax),%eax
     db5:	89 04 24             	mov    %eax,(%esp)
     db8:	e8 36 f7 ff ff       	call   4f3 <kthread_mutex_unlock>

	return 1;
     dbd:	b8 01 00 00 00       	mov    $0x1,%eax


}
     dc2:	c9                   	leave  
     dc3:	c3                   	ret    

00000dc4 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     dc4:	55                   	push   %ebp
     dc5:	89 e5                	mov    %esp,%ebp
     dc7:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     dca:	8b 45 08             	mov    0x8(%ebp),%eax
     dcd:	8b 40 10             	mov    0x10(%eax),%eax
     dd0:	85 c0                	test   %eax,%eax
     dd2:	75 0a                	jne    dde <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dd9:	e9 86 00 00 00       	jmp    e64 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     dde:	8b 45 08             	mov    0x8(%ebp),%eax
     de1:	8b 00                	mov    (%eax),%eax
     de3:	89 04 24             	mov    %eax,(%esp)
     de6:	e8 00 f7 ff ff       	call   4eb <kthread_mutex_lock>
     deb:	83 f8 ff             	cmp    $0xffffffff,%eax
     dee:	7d 07                	jge    df7 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     df5:	eb 6d                	jmp    e64 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     df7:	8b 45 08             	mov    0x8(%ebp),%eax
     dfa:	8b 40 10             	mov    0x10(%eax),%eax
     dfd:	85 c0                	test   %eax,%eax
     dff:	74 21                	je     e22 <hoare_slots_monitor_takeslot+0x5e>
     e01:	8b 45 08             	mov    0x8(%ebp),%eax
     e04:	8b 40 0c             	mov    0xc(%eax),%eax
     e07:	85 c0                	test   %eax,%eax
     e09:	75 17                	jne    e22 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     e0b:	8b 45 08             	mov    0x8(%ebp),%eax
     e0e:	8b 10                	mov    (%eax),%edx
     e10:	8b 45 08             	mov    0x8(%ebp),%eax
     e13:	8b 40 04             	mov    0x4(%eax),%eax
     e16:	89 54 24 04          	mov    %edx,0x4(%esp)
     e1a:	89 04 24             	mov    %eax,(%esp)
     e1d:	e8 1d 01 00 00       	call   f3f <hoare_cond_wait>


	if  ( monitor->active)
     e22:	8b 45 08             	mov    0x8(%ebp),%eax
     e25:	8b 40 10             	mov    0x10(%eax),%eax
     e28:	85 c0                	test   %eax,%eax
     e2a:	74 0f                	je     e3b <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     e2c:	8b 45 08             	mov    0x8(%ebp),%eax
     e2f:	8b 40 0c             	mov    0xc(%eax),%eax
     e32:	8d 50 ff             	lea    -0x1(%eax),%edx
     e35:	8b 45 08             	mov    0x8(%ebp),%eax
     e38:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     e3b:	8b 45 08             	mov    0x8(%ebp),%eax
     e3e:	8b 10                	mov    (%eax),%edx
     e40:	8b 45 08             	mov    0x8(%ebp),%eax
     e43:	8b 40 08             	mov    0x8(%eax),%eax
     e46:	89 54 24 04          	mov    %edx,0x4(%esp)
     e4a:	89 04 24             	mov    %eax,(%esp)
     e4d:	e8 44 01 00 00       	call   f96 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     e52:	8b 45 08             	mov    0x8(%ebp),%eax
     e55:	8b 00                	mov    (%eax),%eax
     e57:	89 04 24             	mov    %eax,(%esp)
     e5a:	e8 94 f6 ff ff       	call   4f3 <kthread_mutex_unlock>

	return 1;
     e5f:	b8 01 00 00 00       	mov    $0x1,%eax

}
     e64:	c9                   	leave  
     e65:	c3                   	ret    

00000e66 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     e66:	55                   	push   %ebp
     e67:	89 e5                	mov    %esp,%ebp
     e69:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     e6c:	8b 45 08             	mov    0x8(%ebp),%eax
     e6f:	8b 40 10             	mov    0x10(%eax),%eax
     e72:	85 c0                	test   %eax,%eax
     e74:	75 07                	jne    e7d <hoare_slots_monitor_stopadding+0x17>
			return -1;
     e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e7b:	eb 35                	jmp    eb2 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e7d:	8b 45 08             	mov    0x8(%ebp),%eax
     e80:	8b 00                	mov    (%eax),%eax
     e82:	89 04 24             	mov    %eax,(%esp)
     e85:	e8 61 f6 ff ff       	call   4eb <kthread_mutex_lock>
     e8a:	83 f8 ff             	cmp    $0xffffffff,%eax
     e8d:	7d 07                	jge    e96 <hoare_slots_monitor_stopadding+0x30>
			return -1;
     e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e94:	eb 1c                	jmp    eb2 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     e96:	8b 45 08             	mov    0x8(%ebp),%eax
     e99:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     ea0:	8b 45 08             	mov    0x8(%ebp),%eax
     ea3:	8b 00                	mov    (%eax),%eax
     ea5:	89 04 24             	mov    %eax,(%esp)
     ea8:	e8 46 f6 ff ff       	call   4f3 <kthread_mutex_unlock>

		return 0;
     ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
     eb2:	c9                   	leave  
     eb3:	c3                   	ret    

00000eb4 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     eb4:	55                   	push   %ebp
     eb5:	89 e5                	mov    %esp,%ebp
     eb7:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     eba:	e8 1c f6 ff ff       	call   4db <kthread_mutex_alloc>
     ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ec6:	79 07                	jns    ecf <hoare_cond_alloc+0x1b>
		return 0;
     ec8:	b8 00 00 00 00       	mov    $0x0,%eax
     ecd:	eb 24                	jmp    ef3 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     ecf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     ed6:	e8 f4 f9 ff ff       	call   8cf <malloc>
     edb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ee4:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ef3:	c9                   	leave  
     ef4:	c3                   	ret    

00000ef5 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     ef5:	55                   	push   %ebp
     ef6:	89 e5                	mov    %esp,%ebp
     ef8:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     efb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     eff:	75 07                	jne    f08 <hoare_cond_dealloc+0x13>
			return -1;
     f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f06:	eb 35                	jmp    f3d <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     f08:	8b 45 08             	mov    0x8(%ebp),%eax
     f0b:	8b 00                	mov    (%eax),%eax
     f0d:	89 04 24             	mov    %eax,(%esp)
     f10:	e8 de f5 ff ff       	call   4f3 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     f15:	8b 45 08             	mov    0x8(%ebp),%eax
     f18:	8b 00                	mov    (%eax),%eax
     f1a:	89 04 24             	mov    %eax,(%esp)
     f1d:	e8 c1 f5 ff ff       	call   4e3 <kthread_mutex_dealloc>
     f22:	85 c0                	test   %eax,%eax
     f24:	79 07                	jns    f2d <hoare_cond_dealloc+0x38>
			return -1;
     f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f2b:	eb 10                	jmp    f3d <hoare_cond_dealloc+0x48>

		free (hCond);
     f2d:	8b 45 08             	mov    0x8(%ebp),%eax
     f30:	89 04 24             	mov    %eax,(%esp)
     f33:	e8 5e f8 ff ff       	call   796 <free>
		return 0;
     f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f3d:	c9                   	leave  
     f3e:	c3                   	ret    

00000f3f <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     f3f:	55                   	push   %ebp
     f40:	89 e5                	mov    %esp,%ebp
     f42:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f49:	75 07                	jne    f52 <hoare_cond_wait+0x13>
			return -1;
     f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f50:	eb 42                	jmp    f94 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     f52:	8b 45 08             	mov    0x8(%ebp),%eax
     f55:	8b 40 04             	mov    0x4(%eax),%eax
     f58:	8d 50 01             	lea    0x1(%eax),%edx
     f5b:	8b 45 08             	mov    0x8(%ebp),%eax
     f5e:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     f61:	8b 45 08             	mov    0x8(%ebp),%eax
     f64:	8b 00                	mov    (%eax),%eax
     f66:	89 44 24 04          	mov    %eax,0x4(%esp)
     f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f6d:	89 04 24             	mov    %eax,(%esp)
     f70:	e8 86 f5 ff ff       	call   4fb <kthread_mutex_yieldlock>
     f75:	85 c0                	test   %eax,%eax
     f77:	79 16                	jns    f8f <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     f79:	8b 45 08             	mov    0x8(%ebp),%eax
     f7c:	8b 40 04             	mov    0x4(%eax),%eax
     f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
     f82:	8b 45 08             	mov    0x8(%ebp),%eax
     f85:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f8d:	eb 05                	jmp    f94 <hoare_cond_wait+0x55>
		}

	return 0;
     f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f94:	c9                   	leave  
     f95:	c3                   	ret    

00000f96 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     f96:	55                   	push   %ebp
     f97:	89 e5                	mov    %esp,%ebp
     f99:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     f9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fa0:	75 07                	jne    fa9 <hoare_cond_signal+0x13>
		return -1;
     fa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fa7:	eb 6b                	jmp    1014 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     fa9:	8b 45 08             	mov    0x8(%ebp),%eax
     fac:	8b 40 04             	mov    0x4(%eax),%eax
     faf:	85 c0                	test   %eax,%eax
     fb1:	7e 3d                	jle    ff0 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     fb3:	8b 45 08             	mov    0x8(%ebp),%eax
     fb6:	8b 40 04             	mov    0x4(%eax),%eax
     fb9:	8d 50 ff             	lea    -0x1(%eax),%edx
     fbc:	8b 45 08             	mov    0x8(%ebp),%eax
     fbf:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     fc2:	8b 45 08             	mov    0x8(%ebp),%eax
     fc5:	8b 00                	mov    (%eax),%eax
     fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
     fce:	89 04 24             	mov    %eax,(%esp)
     fd1:	e8 25 f5 ff ff       	call   4fb <kthread_mutex_yieldlock>
     fd6:	85 c0                	test   %eax,%eax
     fd8:	79 16                	jns    ff0 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     fda:	8b 45 08             	mov    0x8(%ebp),%eax
     fdd:	8b 40 04             	mov    0x4(%eax),%eax
     fe0:	8d 50 01             	lea    0x1(%eax),%edx
     fe3:	8b 45 08             	mov    0x8(%ebp),%eax
     fe6:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fee:	eb 24                	jmp    1014 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     ff0:	8b 45 08             	mov    0x8(%ebp),%eax
     ff3:	8b 00                	mov    (%eax),%eax
     ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
     ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
     ffc:	89 04 24             	mov    %eax,(%esp)
     fff:	e8 f7 f4 ff ff       	call   4fb <kthread_mutex_yieldlock>
    1004:	85 c0                	test   %eax,%eax
    1006:	79 07                	jns    100f <hoare_cond_signal+0x79>

    			return -1;
    1008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    100d:	eb 05                	jmp    1014 <hoare_cond_signal+0x7e>
    }

	return 0;
    100f:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1014:	c9                   	leave  
    1015:	c3                   	ret    

00001016 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    1016:	55                   	push   %ebp
    1017:	89 e5                	mov    %esp,%ebp
    1019:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    101c:	e8 ba f4 ff ff       	call   4db <kthread_mutex_alloc>
    1021:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1028:	79 07                	jns    1031 <mesa_cond_alloc+0x1b>
		return 0;
    102a:	b8 00 00 00 00       	mov    $0x0,%eax
    102f:	eb 24                	jmp    1055 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1031:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1038:	e8 92 f8 ff ff       	call   8cf <malloc>
    103d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1040:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1043:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1046:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    1048:	8b 45 f0             	mov    -0x10(%ebp),%eax
    104b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1052:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1055:	c9                   	leave  
    1056:	c3                   	ret    

00001057 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    1057:	55                   	push   %ebp
    1058:	89 e5                	mov    %esp,%ebp
    105a:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    105d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1061:	75 07                	jne    106a <mesa_cond_dealloc+0x13>
		return -1;
    1063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1068:	eb 35                	jmp    109f <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    106a:	8b 45 08             	mov    0x8(%ebp),%eax
    106d:	8b 00                	mov    (%eax),%eax
    106f:	89 04 24             	mov    %eax,(%esp)
    1072:	e8 7c f4 ff ff       	call   4f3 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    1077:	8b 45 08             	mov    0x8(%ebp),%eax
    107a:	8b 00                	mov    (%eax),%eax
    107c:	89 04 24             	mov    %eax,(%esp)
    107f:	e8 5f f4 ff ff       	call   4e3 <kthread_mutex_dealloc>
    1084:	85 c0                	test   %eax,%eax
    1086:	79 07                	jns    108f <mesa_cond_dealloc+0x38>
		return -1;
    1088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    108d:	eb 10                	jmp    109f <mesa_cond_dealloc+0x48>

	free (mCond);
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	89 04 24             	mov    %eax,(%esp)
    1095:	e8 fc f6 ff ff       	call   796 <free>
	return 0;
    109a:	b8 00 00 00 00       	mov    $0x0,%eax

}
    109f:	c9                   	leave  
    10a0:	c3                   	ret    

000010a1 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    10a1:	55                   	push   %ebp
    10a2:	89 e5                	mov    %esp,%ebp
    10a4:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    10a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10ab:	75 07                	jne    10b4 <mesa_cond_wait+0x13>
		return -1;
    10ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10b2:	eb 55                	jmp    1109 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    10b4:	8b 45 08             	mov    0x8(%ebp),%eax
    10b7:	8b 40 04             	mov    0x4(%eax),%eax
    10ba:	8d 50 01             	lea    0x1(%eax),%edx
    10bd:	8b 45 08             	mov    0x8(%ebp),%eax
    10c0:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    10c3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c6:	89 04 24             	mov    %eax,(%esp)
    10c9:	e8 25 f4 ff ff       	call   4f3 <kthread_mutex_unlock>
    10ce:	85 c0                	test   %eax,%eax
    10d0:	79 27                	jns    10f9 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    10d2:	8b 45 08             	mov    0x8(%ebp),%eax
    10d5:	8b 00                	mov    (%eax),%eax
    10d7:	89 04 24             	mov    %eax,(%esp)
    10da:	e8 0c f4 ff ff       	call   4eb <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    10df:	85 c0                	test   %eax,%eax
    10e1:	79 16                	jns    10f9 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	8b 40 04             	mov    0x4(%eax),%eax
    10e9:	8d 50 ff             	lea    -0x1(%eax),%edx
    10ec:	8b 45 08             	mov    0x8(%ebp),%eax
    10ef:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    10f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10f7:	eb 10                	jmp    1109 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    10f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fc:	89 04 24             	mov    %eax,(%esp)
    10ff:	e8 e7 f3 ff ff       	call   4eb <kthread_mutex_lock>
	return 0;
    1104:	b8 00 00 00 00       	mov    $0x0,%eax


}
    1109:	c9                   	leave  
    110a:	c3                   	ret    

0000110b <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    110b:	55                   	push   %ebp
    110c:	89 e5                	mov    %esp,%ebp
    110e:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1111:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1115:	75 07                	jne    111e <mesa_cond_signal+0x13>
		return -1;
    1117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    111c:	eb 5d                	jmp    117b <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    111e:	8b 45 08             	mov    0x8(%ebp),%eax
    1121:	8b 40 04             	mov    0x4(%eax),%eax
    1124:	85 c0                	test   %eax,%eax
    1126:	7e 36                	jle    115e <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1128:	8b 45 08             	mov    0x8(%ebp),%eax
    112b:	8b 40 04             	mov    0x4(%eax),%eax
    112e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1131:	8b 45 08             	mov    0x8(%ebp),%eax
    1134:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    1137:	8b 45 08             	mov    0x8(%ebp),%eax
    113a:	8b 00                	mov    (%eax),%eax
    113c:	89 04 24             	mov    %eax,(%esp)
    113f:	e8 af f3 ff ff       	call   4f3 <kthread_mutex_unlock>
    1144:	85 c0                	test   %eax,%eax
    1146:	78 16                	js     115e <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	8b 40 04             	mov    0x4(%eax),%eax
    114e:	8d 50 01             	lea    0x1(%eax),%edx
    1151:	8b 45 08             	mov    0x8(%ebp),%eax
    1154:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    1157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    115c:	eb 1d                	jmp    117b <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	8b 00                	mov    (%eax),%eax
    1163:	89 04 24             	mov    %eax,(%esp)
    1166:	e8 88 f3 ff ff       	call   4f3 <kthread_mutex_unlock>
    116b:	85 c0                	test   %eax,%eax
    116d:	79 07                	jns    1176 <mesa_cond_signal+0x6b>

		return -1;
    116f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1174:	eb 05                	jmp    117b <mesa_cond_signal+0x70>
	}
	return 0;
    1176:	b8 00 00 00 00       	mov    $0x0,%eax

}
    117b:	c9                   	leave  
    117c:	c3                   	ret    
