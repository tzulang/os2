
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
       9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
      10:	00 
      11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
      13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      17:	83 c0 01             	add    $0x1,%eax
      1a:	3b 45 08             	cmp    0x8(%ebp),%eax
      1d:	7d 07                	jge    26 <main+0x26>
      1f:	b8 36 10 00 00       	mov    $0x1036,%eax
      24:	eb 05                	jmp    2b <main+0x2b>
      26:	b8 38 10 00 00       	mov    $0x1038,%eax
      2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
      2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
      36:	8b 55 0c             	mov    0xc(%ebp),%edx
      39:	01 ca                	add    %ecx,%edx
      3b:	8b 12                	mov    (%edx),%edx
      3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
      41:	89 54 24 08          	mov    %edx,0x8(%esp)
      45:	c7 44 24 04 3a 10 00 	movl   $0x103a,0x4(%esp)
      4c:	00 
      4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      54:	e8 43 04 00 00       	call   49c <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
      59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
      5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      62:	3b 45 08             	cmp    0x8(%ebp),%eax
      65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
      67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
      6c:	55                   	push   %ebp
      6d:	89 e5                	mov    %esp,%ebp
      6f:	57                   	push   %edi
      70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
      71:	8b 4d 08             	mov    0x8(%ebp),%ecx
      74:	8b 55 10             	mov    0x10(%ebp),%edx
      77:	8b 45 0c             	mov    0xc(%ebp),%eax
      7a:	89 cb                	mov    %ecx,%ebx
      7c:	89 df                	mov    %ebx,%edi
      7e:	89 d1                	mov    %edx,%ecx
      80:	fc                   	cld    
      81:	f3 aa                	rep stos %al,%es:(%edi)
      83:	89 ca                	mov    %ecx,%edx
      85:	89 fb                	mov    %edi,%ebx
      87:	89 5d 08             	mov    %ebx,0x8(%ebp)
      8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
      8d:	5b                   	pop    %ebx
      8e:	5f                   	pop    %edi
      8f:	5d                   	pop    %ebp
      90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
      91:	55                   	push   %ebp
      92:	89 e5                	mov    %esp,%ebp
      94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
      97:	8b 45 08             	mov    0x8(%ebp),%eax
      9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
      9d:	90                   	nop
      9e:	8b 45 08             	mov    0x8(%ebp),%eax
      a1:	8d 50 01             	lea    0x1(%eax),%edx
      a4:	89 55 08             	mov    %edx,0x8(%ebp)
      a7:	8b 55 0c             	mov    0xc(%ebp),%edx
      aa:	8d 4a 01             	lea    0x1(%edx),%ecx
      ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
      b0:	0f b6 12             	movzbl (%edx),%edx
      b3:	88 10                	mov    %dl,(%eax)
      b5:	0f b6 00             	movzbl (%eax),%eax
      b8:	84 c0                	test   %al,%al
      ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
      bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
      bf:	c9                   	leave  
      c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
      c1:	55                   	push   %ebp
      c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
      c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
      c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
      ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
      ce:	8b 45 08             	mov    0x8(%ebp),%eax
      d1:	0f b6 00             	movzbl (%eax),%eax
      d4:	84 c0                	test   %al,%al
      d6:	74 10                	je     e8 <strcmp+0x27>
      d8:	8b 45 08             	mov    0x8(%ebp),%eax
      db:	0f b6 10             	movzbl (%eax),%edx
      de:	8b 45 0c             	mov    0xc(%ebp),%eax
      e1:	0f b6 00             	movzbl (%eax),%eax
      e4:	38 c2                	cmp    %al,%dl
      e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
      e8:	8b 45 08             	mov    0x8(%ebp),%eax
      eb:	0f b6 00             	movzbl (%eax),%eax
      ee:	0f b6 d0             	movzbl %al,%edx
      f1:	8b 45 0c             	mov    0xc(%ebp),%eax
      f4:	0f b6 00             	movzbl (%eax),%eax
      f7:	0f b6 c0             	movzbl %al,%eax
      fa:	29 c2                	sub    %eax,%edx
      fc:	89 d0                	mov    %edx,%eax
}
      fe:	5d                   	pop    %ebp
      ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
     100:	55                   	push   %ebp
     101:	89 e5                	mov    %esp,%ebp
     103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     10d:	eb 04                	jmp    113 <strlen+0x13>
     10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     113:	8b 55 fc             	mov    -0x4(%ebp),%edx
     116:	8b 45 08             	mov    0x8(%ebp),%eax
     119:	01 d0                	add    %edx,%eax
     11b:	0f b6 00             	movzbl (%eax),%eax
     11e:	84 c0                	test   %al,%al
     120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
     122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     125:	c9                   	leave  
     126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
     127:	55                   	push   %ebp
     128:	89 e5                	mov    %esp,%ebp
     12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     12d:	8b 45 10             	mov    0x10(%ebp),%eax
     130:	89 44 24 08          	mov    %eax,0x8(%esp)
     134:	8b 45 0c             	mov    0xc(%ebp),%eax
     137:	89 44 24 04          	mov    %eax,0x4(%esp)
     13b:	8b 45 08             	mov    0x8(%ebp),%eax
     13e:	89 04 24             	mov    %eax,(%esp)
     141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
     146:	8b 45 08             	mov    0x8(%ebp),%eax
}
     149:	c9                   	leave  
     14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
     14b:	55                   	push   %ebp
     14c:	89 e5                	mov    %esp,%ebp
     14e:	83 ec 04             	sub    $0x4,%esp
     151:	8b 45 0c             	mov    0xc(%ebp),%eax
     154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
     159:	8b 45 08             	mov    0x8(%ebp),%eax
     15c:	0f b6 00             	movzbl (%eax),%eax
     15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
     162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
     164:	8b 45 08             	mov    0x8(%ebp),%eax
     167:	eb 13                	jmp    17c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     16d:	8b 45 08             	mov    0x8(%ebp),%eax
     170:	0f b6 00             	movzbl (%eax),%eax
     173:	84 c0                	test   %al,%al
     175:	75 e2                	jne    159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     177:	b8 00 00 00 00       	mov    $0x0,%eax
}
     17c:	c9                   	leave  
     17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
     17e:	55                   	push   %ebp
     17f:	89 e5                	mov    %esp,%ebp
     181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
     18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     194:	00 
     195:	8d 45 ef             	lea    -0x11(%ebp),%eax
     198:	89 44 24 04          	mov    %eax,0x4(%esp)
     19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1a3:	e8 44 01 00 00       	call   2ec <read>
     1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
     1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
     1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1b6:	8d 50 01             	lea    0x1(%eax),%edx
     1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     1bc:	89 c2                	mov    %eax,%edx
     1be:	8b 45 08             	mov    0x8(%ebp),%eax
     1c1:	01 c2                	add    %eax,%edx
     1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1cd:	3c 0a                	cmp    $0xa,%al
     1cf:	74 13                	je     1e4 <gets+0x66>
     1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1d5:	3c 0d                	cmp    $0xd,%al
     1d7:	74 0b                	je     1e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1dc:	83 c0 01             	add    $0x1,%eax
     1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
     1e2:	7c a9                	jl     18d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     1e7:	8b 45 08             	mov    0x8(%ebp),%eax
     1ea:	01 d0                	add    %edx,%eax
     1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1f2:	c9                   	leave  
     1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
     1f4:	55                   	push   %ebp
     1f5:	89 e5                	mov    %esp,%ebp
     1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     201:	00 
     202:	8b 45 08             	mov    0x8(%ebp),%eax
     205:	89 04 24             	mov    %eax,(%esp)
     208:	e8 07 01 00 00       	call   314 <open>
     20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     214:	79 07                	jns    21d <stat+0x29>
    return -1;
     216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
     21d:	8b 45 0c             	mov    0xc(%ebp),%eax
     220:	89 44 24 04          	mov    %eax,0x4(%esp)
     224:	8b 45 f4             	mov    -0xc(%ebp),%eax
     227:	89 04 24             	mov    %eax,(%esp)
     22a:	e8 fd 00 00 00       	call   32c <fstat>
     22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	89 04 24             	mov    %eax,(%esp)
     238:	e8 bf 00 00 00       	call   2fc <close>
  return r;
     23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     240:	c9                   	leave  
     241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
     242:	55                   	push   %ebp
     243:	89 e5                	mov    %esp,%ebp
     245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
     251:	8b 55 fc             	mov    -0x4(%ebp),%edx
     254:	89 d0                	mov    %edx,%eax
     256:	c1 e0 02             	shl    $0x2,%eax
     259:	01 d0                	add    %edx,%eax
     25b:	01 c0                	add    %eax,%eax
     25d:	89 c1                	mov    %eax,%ecx
     25f:	8b 45 08             	mov    0x8(%ebp),%eax
     262:	8d 50 01             	lea    0x1(%eax),%edx
     265:	89 55 08             	mov    %edx,0x8(%ebp)
     268:	0f b6 00             	movzbl (%eax),%eax
     26b:	0f be c0             	movsbl %al,%eax
     26e:	01 c8                	add    %ecx,%eax
     270:	83 e8 30             	sub    $0x30,%eax
     273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     276:	8b 45 08             	mov    0x8(%ebp),%eax
     279:	0f b6 00             	movzbl (%eax),%eax
     27c:	3c 2f                	cmp    $0x2f,%al
     27e:	7e 0a                	jle    28a <atoi+0x48>
     280:	8b 45 08             	mov    0x8(%ebp),%eax
     283:	0f b6 00             	movzbl (%eax),%eax
     286:	3c 39                	cmp    $0x39,%al
     288:	7e c7                	jle    251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     28d:	c9                   	leave  
     28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     28f:	55                   	push   %ebp
     290:	89 e5                	mov    %esp,%ebp
     292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     295:	8b 45 08             	mov    0x8(%ebp),%eax
     298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     29b:	8b 45 0c             	mov    0xc(%ebp),%eax
     29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
     2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     2a6:	8d 50 01             	lea    0x1(%eax),%edx
     2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
     2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
     2af:	8d 4a 01             	lea    0x1(%edx),%ecx
     2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     2b5:	0f b6 12             	movzbl (%edx),%edx
     2b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     2ba:	8b 45 10             	mov    0x10(%ebp),%eax
     2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
     2c0:	89 55 10             	mov    %edx,0x10(%ebp)
     2c3:	85 c0                	test   %eax,%eax
     2c5:	7f dc                	jg     2a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2ca:	c9                   	leave  
     2cb:	c3                   	ret    

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     2cc:	b8 01 00 00 00       	mov    $0x1,%eax
     2d1:	cd 40                	int    $0x40
     2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
     2d4:	b8 02 00 00 00       	mov    $0x2,%eax
     2d9:	cd 40                	int    $0x40
     2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
     2dc:	b8 03 00 00 00       	mov    $0x3,%eax
     2e1:	cd 40                	int    $0x40
     2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
     2e4:	b8 04 00 00 00       	mov    $0x4,%eax
     2e9:	cd 40                	int    $0x40
     2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
     2ec:	b8 05 00 00 00       	mov    $0x5,%eax
     2f1:	cd 40                	int    $0x40
     2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
     2f4:	b8 10 00 00 00       	mov    $0x10,%eax
     2f9:	cd 40                	int    $0x40
     2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
     2fc:	b8 15 00 00 00       	mov    $0x15,%eax
     301:	cd 40                	int    $0x40
     303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
     304:	b8 06 00 00 00       	mov    $0x6,%eax
     309:	cd 40                	int    $0x40
     30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
     30c:	b8 07 00 00 00       	mov    $0x7,%eax
     311:	cd 40                	int    $0x40
     313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
     314:	b8 0f 00 00 00       	mov    $0xf,%eax
     319:	cd 40                	int    $0x40
     31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
     31c:	b8 11 00 00 00       	mov    $0x11,%eax
     321:	cd 40                	int    $0x40
     323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
     324:	b8 12 00 00 00       	mov    $0x12,%eax
     329:	cd 40                	int    $0x40
     32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
     32c:	b8 08 00 00 00       	mov    $0x8,%eax
     331:	cd 40                	int    $0x40
     333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
     334:	b8 13 00 00 00       	mov    $0x13,%eax
     339:	cd 40                	int    $0x40
     33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
     33c:	b8 14 00 00 00       	mov    $0x14,%eax
     341:	cd 40                	int    $0x40
     343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
     344:	b8 09 00 00 00       	mov    $0x9,%eax
     349:	cd 40                	int    $0x40
     34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
     34c:	b8 0a 00 00 00       	mov    $0xa,%eax
     351:	cd 40                	int    $0x40
     353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
     354:	b8 0b 00 00 00       	mov    $0xb,%eax
     359:	cd 40                	int    $0x40
     35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
     35c:	b8 0c 00 00 00       	mov    $0xc,%eax
     361:	cd 40                	int    $0x40
     363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
     364:	b8 0d 00 00 00       	mov    $0xd,%eax
     369:	cd 40                	int    $0x40
     36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
     36c:	b8 0e 00 00 00       	mov    $0xe,%eax
     371:	cd 40                	int    $0x40
     373:	c3                   	ret    

00000374 <kthread_create>:




SYSCALL(kthread_create)
     374:	b8 16 00 00 00       	mov    $0x16,%eax
     379:	cd 40                	int    $0x40
     37b:	c3                   	ret    

0000037c <kthread_id>:
SYSCALL(kthread_id)
     37c:	b8 17 00 00 00       	mov    $0x17,%eax
     381:	cd 40                	int    $0x40
     383:	c3                   	ret    

00000384 <kthread_exit>:
SYSCALL(kthread_exit)
     384:	b8 18 00 00 00       	mov    $0x18,%eax
     389:	cd 40                	int    $0x40
     38b:	c3                   	ret    

0000038c <kthread_join>:
SYSCALL(kthread_join)
     38c:	b8 19 00 00 00       	mov    $0x19,%eax
     391:	cd 40                	int    $0x40
     393:	c3                   	ret    

00000394 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     394:	b8 1a 00 00 00       	mov    $0x1a,%eax
     399:	cd 40                	int    $0x40
     39b:	c3                   	ret    

0000039c <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     39c:	b8 1b 00 00 00       	mov    $0x1b,%eax
     3a1:	cd 40                	int    $0x40
     3a3:	c3                   	ret    

000003a4 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     3a4:	b8 1c 00 00 00       	mov    $0x1c,%eax
     3a9:	cd 40                	int    $0x40
     3ab:	c3                   	ret    

000003ac <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     3ac:	b8 1d 00 00 00       	mov    $0x1d,%eax
     3b1:	cd 40                	int    $0x40
     3b3:	c3                   	ret    

000003b4 <kthread_mutex_yieldlock>:
     3b4:	b8 1e 00 00 00       	mov    $0x1e,%eax
     3b9:	cd 40                	int    $0x40
     3bb:	c3                   	ret    

000003bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     3bc:	55                   	push   %ebp
     3bd:	89 e5                	mov    %esp,%ebp
     3bf:	83 ec 18             	sub    $0x18,%esp
     3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
     3c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     3c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3cf:	00 
     3d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
     3d3:	89 44 24 04          	mov    %eax,0x4(%esp)
     3d7:	8b 45 08             	mov    0x8(%ebp),%eax
     3da:	89 04 24             	mov    %eax,(%esp)
     3dd:	e8 12 ff ff ff       	call   2f4 <write>
}
     3e2:	c9                   	leave  
     3e3:	c3                   	ret    

000003e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     3e4:	55                   	push   %ebp
     3e5:	89 e5                	mov    %esp,%ebp
     3e7:	56                   	push   %esi
     3e8:	53                   	push   %ebx
     3e9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     3ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     3f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     3f7:	74 17                	je     410 <printint+0x2c>
     3f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     3fd:	79 11                	jns    410 <printint+0x2c>
    neg = 1;
     3ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     406:	8b 45 0c             	mov    0xc(%ebp),%eax
     409:	f7 d8                	neg    %eax
     40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     40e:	eb 06                	jmp    416 <printint+0x32>
  } else {
    x = xx;
     410:	8b 45 0c             	mov    0xc(%ebp),%eax
     413:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     41d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     420:	8d 41 01             	lea    0x1(%ecx),%eax
     423:	89 45 f4             	mov    %eax,-0xc(%ebp)
     426:	8b 5d 10             	mov    0x10(%ebp),%ebx
     429:	8b 45 ec             	mov    -0x14(%ebp),%eax
     42c:	ba 00 00 00 00       	mov    $0x0,%edx
     431:	f7 f3                	div    %ebx
     433:	89 d0                	mov    %edx,%eax
     435:	0f b6 80 cc 14 00 00 	movzbl 0x14cc(%eax),%eax
     43c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     440:	8b 75 10             	mov    0x10(%ebp),%esi
     443:	8b 45 ec             	mov    -0x14(%ebp),%eax
     446:	ba 00 00 00 00       	mov    $0x0,%edx
     44b:	f7 f6                	div    %esi
     44d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     454:	75 c7                	jne    41d <printint+0x39>
  if(neg)
     456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     45a:	74 10                	je     46c <printint+0x88>
    buf[i++] = '-';
     45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45f:	8d 50 01             	lea    0x1(%eax),%edx
     462:	89 55 f4             	mov    %edx,-0xc(%ebp)
     465:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     46a:	eb 1f                	jmp    48b <printint+0xa7>
     46c:	eb 1d                	jmp    48b <printint+0xa7>
    putc(fd, buf[i]);
     46e:	8d 55 dc             	lea    -0x24(%ebp),%edx
     471:	8b 45 f4             	mov    -0xc(%ebp),%eax
     474:	01 d0                	add    %edx,%eax
     476:	0f b6 00             	movzbl (%eax),%eax
     479:	0f be c0             	movsbl %al,%eax
     47c:	89 44 24 04          	mov    %eax,0x4(%esp)
     480:	8b 45 08             	mov    0x8(%ebp),%eax
     483:	89 04 24             	mov    %eax,(%esp)
     486:	e8 31 ff ff ff       	call   3bc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     48b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     48f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     493:	79 d9                	jns    46e <printint+0x8a>
    putc(fd, buf[i]);
}
     495:	83 c4 30             	add    $0x30,%esp
     498:	5b                   	pop    %ebx
     499:	5e                   	pop    %esi
     49a:	5d                   	pop    %ebp
     49b:	c3                   	ret    

0000049c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     49c:	55                   	push   %ebp
     49d:	89 e5                	mov    %esp,%ebp
     49f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     4a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     4a9:	8d 45 0c             	lea    0xc(%ebp),%eax
     4ac:	83 c0 04             	add    $0x4,%eax
     4af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     4b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     4b9:	e9 7c 01 00 00       	jmp    63a <printf+0x19e>
    c = fmt[i] & 0xff;
     4be:	8b 55 0c             	mov    0xc(%ebp),%edx
     4c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4c4:	01 d0                	add    %edx,%eax
     4c6:	0f b6 00             	movzbl (%eax),%eax
     4c9:	0f be c0             	movsbl %al,%eax
     4cc:	25 ff 00 00 00       	and    $0xff,%eax
     4d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     4d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4d8:	75 2c                	jne    506 <printf+0x6a>
      if(c == '%'){
     4da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     4de:	75 0c                	jne    4ec <printf+0x50>
        state = '%';
     4e0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     4e7:	e9 4a 01 00 00       	jmp    636 <printf+0x19a>
      } else {
        putc(fd, c);
     4ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4ef:	0f be c0             	movsbl %al,%eax
     4f2:	89 44 24 04          	mov    %eax,0x4(%esp)
     4f6:	8b 45 08             	mov    0x8(%ebp),%eax
     4f9:	89 04 24             	mov    %eax,(%esp)
     4fc:	e8 bb fe ff ff       	call   3bc <putc>
     501:	e9 30 01 00 00       	jmp    636 <printf+0x19a>
      }
    } else if(state == '%'){
     506:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     50a:	0f 85 26 01 00 00    	jne    636 <printf+0x19a>
      if(c == 'd'){
     510:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     514:	75 2d                	jne    543 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     516:	8b 45 e8             	mov    -0x18(%ebp),%eax
     519:	8b 00                	mov    (%eax),%eax
     51b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     522:	00 
     523:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     52a:	00 
     52b:	89 44 24 04          	mov    %eax,0x4(%esp)
     52f:	8b 45 08             	mov    0x8(%ebp),%eax
     532:	89 04 24             	mov    %eax,(%esp)
     535:	e8 aa fe ff ff       	call   3e4 <printint>
        ap++;
     53a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     53e:	e9 ec 00 00 00       	jmp    62f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     543:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     547:	74 06                	je     54f <printf+0xb3>
     549:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     54d:	75 2d                	jne    57c <printf+0xe0>
        printint(fd, *ap, 16, 0);
     54f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     552:	8b 00                	mov    (%eax),%eax
     554:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     55b:	00 
     55c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     563:	00 
     564:	89 44 24 04          	mov    %eax,0x4(%esp)
     568:	8b 45 08             	mov    0x8(%ebp),%eax
     56b:	89 04 24             	mov    %eax,(%esp)
     56e:	e8 71 fe ff ff       	call   3e4 <printint>
        ap++;
     573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     577:	e9 b3 00 00 00       	jmp    62f <printf+0x193>
      } else if(c == 's'){
     57c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     580:	75 45                	jne    5c7 <printf+0x12b>
        s = (char*)*ap;
     582:	8b 45 e8             	mov    -0x18(%ebp),%eax
     585:	8b 00                	mov    (%eax),%eax
     587:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     58e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     592:	75 09                	jne    59d <printf+0x101>
          s = "(null)";
     594:	c7 45 f4 3f 10 00 00 	movl   $0x103f,-0xc(%ebp)
        while(*s != 0){
     59b:	eb 1e                	jmp    5bb <printf+0x11f>
     59d:	eb 1c                	jmp    5bb <printf+0x11f>
          putc(fd, *s);
     59f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a2:	0f b6 00             	movzbl (%eax),%eax
     5a5:	0f be c0             	movsbl %al,%eax
     5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     5ac:	8b 45 08             	mov    0x8(%ebp),%eax
     5af:	89 04 24             	mov    %eax,(%esp)
     5b2:	e8 05 fe ff ff       	call   3bc <putc>
          s++;
     5b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5be:	0f b6 00             	movzbl (%eax),%eax
     5c1:	84 c0                	test   %al,%al
     5c3:	75 da                	jne    59f <printf+0x103>
     5c5:	eb 68                	jmp    62f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     5c7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     5cb:	75 1d                	jne    5ea <printf+0x14e>
        putc(fd, *ap);
     5cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5d0:	8b 00                	mov    (%eax),%eax
     5d2:	0f be c0             	movsbl %al,%eax
     5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d9:	8b 45 08             	mov    0x8(%ebp),%eax
     5dc:	89 04 24             	mov    %eax,(%esp)
     5df:	e8 d8 fd ff ff       	call   3bc <putc>
        ap++;
     5e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5e8:	eb 45                	jmp    62f <printf+0x193>
      } else if(c == '%'){
     5ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     5ee:	75 17                	jne    607 <printf+0x16b>
        putc(fd, c);
     5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5f3:	0f be c0             	movsbl %al,%eax
     5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     5fa:	8b 45 08             	mov    0x8(%ebp),%eax
     5fd:	89 04 24             	mov    %eax,(%esp)
     600:	e8 b7 fd ff ff       	call   3bc <putc>
     605:	eb 28                	jmp    62f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     607:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     60e:	00 
     60f:	8b 45 08             	mov    0x8(%ebp),%eax
     612:	89 04 24             	mov    %eax,(%esp)
     615:	e8 a2 fd ff ff       	call   3bc <putc>
        putc(fd, c);
     61a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     61d:	0f be c0             	movsbl %al,%eax
     620:	89 44 24 04          	mov    %eax,0x4(%esp)
     624:	8b 45 08             	mov    0x8(%ebp),%eax
     627:	89 04 24             	mov    %eax,(%esp)
     62a:	e8 8d fd ff ff       	call   3bc <putc>
      }
      state = 0;
     62f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     636:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     63a:	8b 55 0c             	mov    0xc(%ebp),%edx
     63d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     640:	01 d0                	add    %edx,%eax
     642:	0f b6 00             	movzbl (%eax),%eax
     645:	84 c0                	test   %al,%al
     647:	0f 85 71 fe ff ff    	jne    4be <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     64d:	c9                   	leave  
     64e:	c3                   	ret    

0000064f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     64f:	55                   	push   %ebp
     650:	89 e5                	mov    %esp,%ebp
     652:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     655:	8b 45 08             	mov    0x8(%ebp),%eax
     658:	83 e8 08             	sub    $0x8,%eax
     65b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     65e:	a1 e8 14 00 00       	mov    0x14e8,%eax
     663:	89 45 fc             	mov    %eax,-0x4(%ebp)
     666:	eb 24                	jmp    68c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     668:	8b 45 fc             	mov    -0x4(%ebp),%eax
     66b:	8b 00                	mov    (%eax),%eax
     66d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     670:	77 12                	ja     684 <free+0x35>
     672:	8b 45 f8             	mov    -0x8(%ebp),%eax
     675:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     678:	77 24                	ja     69e <free+0x4f>
     67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     67d:	8b 00                	mov    (%eax),%eax
     67f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     682:	77 1a                	ja     69e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     684:	8b 45 fc             	mov    -0x4(%ebp),%eax
     687:	8b 00                	mov    (%eax),%eax
     689:	89 45 fc             	mov    %eax,-0x4(%ebp)
     68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     68f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     692:	76 d4                	jbe    668 <free+0x19>
     694:	8b 45 fc             	mov    -0x4(%ebp),%eax
     697:	8b 00                	mov    (%eax),%eax
     699:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     69c:	76 ca                	jbe    668 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6a1:	8b 40 04             	mov    0x4(%eax),%eax
     6a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6ae:	01 c2                	add    %eax,%edx
     6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6b3:	8b 00                	mov    (%eax),%eax
     6b5:	39 c2                	cmp    %eax,%edx
     6b7:	75 24                	jne    6dd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6bc:	8b 50 04             	mov    0x4(%eax),%edx
     6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6c2:	8b 00                	mov    (%eax),%eax
     6c4:	8b 40 04             	mov    0x4(%eax),%eax
     6c7:	01 c2                	add    %eax,%edx
     6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6cc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6d2:	8b 00                	mov    (%eax),%eax
     6d4:	8b 10                	mov    (%eax),%edx
     6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d9:	89 10                	mov    %edx,(%eax)
     6db:	eb 0a                	jmp    6e7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6e0:	8b 10                	mov    (%eax),%edx
     6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6e5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ea:	8b 40 04             	mov    0x4(%eax),%eax
     6ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6f7:	01 d0                	add    %edx,%eax
     6f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6fc:	75 20                	jne    71e <free+0xcf>
    p->s.size += bp->s.size;
     6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
     701:	8b 50 04             	mov    0x4(%eax),%edx
     704:	8b 45 f8             	mov    -0x8(%ebp),%eax
     707:	8b 40 04             	mov    0x4(%eax),%eax
     70a:	01 c2                	add    %eax,%edx
     70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     712:	8b 45 f8             	mov    -0x8(%ebp),%eax
     715:	8b 10                	mov    (%eax),%edx
     717:	8b 45 fc             	mov    -0x4(%ebp),%eax
     71a:	89 10                	mov    %edx,(%eax)
     71c:	eb 08                	jmp    726 <free+0xd7>
  } else
    p->s.ptr = bp;
     71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     721:	8b 55 f8             	mov    -0x8(%ebp),%edx
     724:	89 10                	mov    %edx,(%eax)
  freep = p;
     726:	8b 45 fc             	mov    -0x4(%ebp),%eax
     729:	a3 e8 14 00 00       	mov    %eax,0x14e8
}
     72e:	c9                   	leave  
     72f:	c3                   	ret    

00000730 <morecore>:

static Header*
morecore(uint nu)
{
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
     733:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     736:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     73d:	77 07                	ja     746 <morecore+0x16>
    nu = 4096;
     73f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     746:	8b 45 08             	mov    0x8(%ebp),%eax
     749:	c1 e0 03             	shl    $0x3,%eax
     74c:	89 04 24             	mov    %eax,(%esp)
     74f:	e8 08 fc ff ff       	call   35c <sbrk>
     754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     757:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     75b:	75 07                	jne    764 <morecore+0x34>
    return 0;
     75d:	b8 00 00 00 00       	mov    $0x0,%eax
     762:	eb 22                	jmp    786 <morecore+0x56>
  hp = (Header*)p;
     764:	8b 45 f4             	mov    -0xc(%ebp),%eax
     767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	8b 55 08             	mov    0x8(%ebp),%edx
     770:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     773:	8b 45 f0             	mov    -0x10(%ebp),%eax
     776:	83 c0 08             	add    $0x8,%eax
     779:	89 04 24             	mov    %eax,(%esp)
     77c:	e8 ce fe ff ff       	call   64f <free>
  return freep;
     781:	a1 e8 14 00 00       	mov    0x14e8,%eax
}
     786:	c9                   	leave  
     787:	c3                   	ret    

00000788 <malloc>:

void*
malloc(uint nbytes)
{
     788:	55                   	push   %ebp
     789:	89 e5                	mov    %esp,%ebp
     78b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     78e:	8b 45 08             	mov    0x8(%ebp),%eax
     791:	83 c0 07             	add    $0x7,%eax
     794:	c1 e8 03             	shr    $0x3,%eax
     797:	83 c0 01             	add    $0x1,%eax
     79a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     79d:	a1 e8 14 00 00       	mov    0x14e8,%eax
     7a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7a9:	75 23                	jne    7ce <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7ab:	c7 45 f0 e0 14 00 00 	movl   $0x14e0,-0x10(%ebp)
     7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7b5:	a3 e8 14 00 00       	mov    %eax,0x14e8
     7ba:	a1 e8 14 00 00       	mov    0x14e8,%eax
     7bf:	a3 e0 14 00 00       	mov    %eax,0x14e0
    base.s.size = 0;
     7c4:	c7 05 e4 14 00 00 00 	movl   $0x0,0x14e4
     7cb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7d1:	8b 00                	mov    (%eax),%eax
     7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d9:	8b 40 04             	mov    0x4(%eax),%eax
     7dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7df:	72 4d                	jb     82e <malloc+0xa6>
      if(p->s.size == nunits)
     7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7e4:	8b 40 04             	mov    0x4(%eax),%eax
     7e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7ea:	75 0c                	jne    7f8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ef:	8b 10                	mov    (%eax),%edx
     7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7f4:	89 10                	mov    %edx,(%eax)
     7f6:	eb 26                	jmp    81e <malloc+0x96>
      else {
        p->s.size -= nunits;
     7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fb:	8b 40 04             	mov    0x4(%eax),%eax
     7fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
     801:	89 c2                	mov    %eax,%edx
     803:	8b 45 f4             	mov    -0xc(%ebp),%eax
     806:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     809:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80c:	8b 40 04             	mov    0x4(%eax),%eax
     80f:	c1 e0 03             	shl    $0x3,%eax
     812:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     815:	8b 45 f4             	mov    -0xc(%ebp),%eax
     818:	8b 55 ec             	mov    -0x14(%ebp),%edx
     81b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     821:	a3 e8 14 00 00       	mov    %eax,0x14e8
      return (void*)(p + 1);
     826:	8b 45 f4             	mov    -0xc(%ebp),%eax
     829:	83 c0 08             	add    $0x8,%eax
     82c:	eb 38                	jmp    866 <malloc+0xde>
    }
    if(p == freep)
     82e:	a1 e8 14 00 00       	mov    0x14e8,%eax
     833:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     836:	75 1b                	jne    853 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     838:	8b 45 ec             	mov    -0x14(%ebp),%eax
     83b:	89 04 24             	mov    %eax,(%esp)
     83e:	e8 ed fe ff ff       	call   730 <morecore>
     843:	89 45 f4             	mov    %eax,-0xc(%ebp)
     846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     84a:	75 07                	jne    853 <malloc+0xcb>
        return 0;
     84c:	b8 00 00 00 00       	mov    $0x0,%eax
     851:	eb 13                	jmp    866 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     853:	8b 45 f4             	mov    -0xc(%ebp),%eax
     856:	89 45 f0             	mov    %eax,-0x10(%ebp)
     859:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85c:	8b 00                	mov    (%eax),%eax
     85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     861:	e9 70 ff ff ff       	jmp    7d6 <malloc+0x4e>
}
     866:	c9                   	leave  
     867:	c3                   	ret    

00000868 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     868:	55                   	push   %ebp
     869:	89 e5                	mov    %esp,%ebp
     86b:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     86e:	e8 21 fb ff ff       	call   394 <kthread_mutex_alloc>
     873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     87a:	79 0a                	jns    886 <mesa_slots_monitor_alloc+0x1e>
		return 0;
     87c:	b8 00 00 00 00       	mov    $0x0,%eax
     881:	e9 8b 00 00 00       	jmp    911 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     886:	e8 44 06 00 00       	call   ecf <mesa_cond_alloc>
     88b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     88e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     892:	75 12                	jne    8a6 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     894:	8b 45 f4             	mov    -0xc(%ebp),%eax
     897:	89 04 24             	mov    %eax,(%esp)
     89a:	e8 fd fa ff ff       	call   39c <kthread_mutex_dealloc>
		return 0;
     89f:	b8 00 00 00 00       	mov    $0x0,%eax
     8a4:	eb 6b                	jmp    911 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     8a6:	e8 24 06 00 00       	call   ecf <mesa_cond_alloc>
     8ab:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     8ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8b2:	75 1d                	jne    8d1 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 dd fa ff ff       	call   39c <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     8bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8c2:	89 04 24             	mov    %eax,(%esp)
     8c5:	e8 46 06 00 00       	call   f10 <mesa_cond_dealloc>
		return 0;
     8ca:	b8 00 00 00 00       	mov    $0x0,%eax
     8cf:	eb 40                	jmp    911 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     8d1:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     8d8:	e8 ab fe ff ff       	call   788 <malloc>
     8dd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     8e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
     8e6:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     8e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
     8ef:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     8f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8f8:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     8fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     904:	8b 45 e8             	mov    -0x18(%ebp),%eax
     907:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     90e:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     911:	c9                   	leave  
     912:	c3                   	ret    

00000913 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     913:	55                   	push   %ebp
     914:	89 e5                	mov    %esp,%ebp
     916:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     919:	8b 45 08             	mov    0x8(%ebp),%eax
     91c:	8b 00                	mov    (%eax),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 76 fa ff ff       	call   39c <kthread_mutex_dealloc>
     926:	85 c0                	test   %eax,%eax
     928:	78 2e                	js     958 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     92a:	8b 45 08             	mov    0x8(%ebp),%eax
     92d:	8b 40 04             	mov    0x4(%eax),%eax
     930:	89 04 24             	mov    %eax,(%esp)
     933:	e8 97 05 00 00       	call   ecf <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     938:	8b 45 08             	mov    0x8(%ebp),%eax
     93b:	8b 40 08             	mov    0x8(%eax),%eax
     93e:	89 04 24             	mov    %eax,(%esp)
     941:	e8 89 05 00 00       	call   ecf <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     946:	8b 45 08             	mov    0x8(%ebp),%eax
     949:	89 04 24             	mov    %eax,(%esp)
     94c:	e8 fe fc ff ff       	call   64f <free>
	return 0;
     951:	b8 00 00 00 00       	mov    $0x0,%eax
     956:	eb 05                	jmp    95d <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     95d:	c9                   	leave  
     95e:	c3                   	ret    

0000095f <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     95f:	55                   	push   %ebp
     960:	89 e5                	mov    %esp,%ebp
     962:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     965:	8b 45 08             	mov    0x8(%ebp),%eax
     968:	8b 40 10             	mov    0x10(%eax),%eax
     96b:	85 c0                	test   %eax,%eax
     96d:	75 0a                	jne    979 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     96f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     974:	e9 81 00 00 00       	jmp    9fa <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     979:	8b 45 08             	mov    0x8(%ebp),%eax
     97c:	8b 00                	mov    (%eax),%eax
     97e:	89 04 24             	mov    %eax,(%esp)
     981:	e8 1e fa ff ff       	call   3a4 <kthread_mutex_lock>
     986:	83 f8 ff             	cmp    $0xffffffff,%eax
     989:	7d 07                	jge    992 <mesa_slots_monitor_addslots+0x33>
		return -1;
     98b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     990:	eb 68                	jmp    9fa <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     992:	eb 17                	jmp    9ab <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     994:	8b 45 08             	mov    0x8(%ebp),%eax
     997:	8b 10                	mov    (%eax),%edx
     999:	8b 45 08             	mov    0x8(%ebp),%eax
     99c:	8b 40 08             	mov    0x8(%eax),%eax
     99f:	89 54 24 04          	mov    %edx,0x4(%esp)
     9a3:	89 04 24             	mov    %eax,(%esp)
     9a6:	e8 af 05 00 00       	call   f5a <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     9ab:	8b 45 08             	mov    0x8(%ebp),%eax
     9ae:	8b 40 10             	mov    0x10(%eax),%eax
     9b1:	85 c0                	test   %eax,%eax
     9b3:	74 0a                	je     9bf <mesa_slots_monitor_addslots+0x60>
     9b5:	8b 45 08             	mov    0x8(%ebp),%eax
     9b8:	8b 40 0c             	mov    0xc(%eax),%eax
     9bb:	85 c0                	test   %eax,%eax
     9bd:	7f d5                	jg     994 <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     9bf:	8b 45 08             	mov    0x8(%ebp),%eax
     9c2:	8b 40 10             	mov    0x10(%eax),%eax
     9c5:	85 c0                	test   %eax,%eax
     9c7:	74 11                	je     9da <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     9c9:	8b 45 08             	mov    0x8(%ebp),%eax
     9cc:	8b 50 0c             	mov    0xc(%eax),%edx
     9cf:	8b 45 0c             	mov    0xc(%ebp),%eax
     9d2:	01 c2                	add    %eax,%edx
     9d4:	8b 45 08             	mov    0x8(%ebp),%eax
     9d7:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     9da:	8b 45 08             	mov    0x8(%ebp),%eax
     9dd:	8b 40 04             	mov    0x4(%eax),%eax
     9e0:	89 04 24             	mov    %eax,(%esp)
     9e3:	e8 dc 05 00 00       	call   fc4 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     9e8:	8b 45 08             	mov    0x8(%ebp),%eax
     9eb:	8b 00                	mov    (%eax),%eax
     9ed:	89 04 24             	mov    %eax,(%esp)
     9f0:	e8 b7 f9 ff ff       	call   3ac <kthread_mutex_unlock>

	return 1;
     9f5:	b8 01 00 00 00       	mov    $0x1,%eax


}
     9fa:	c9                   	leave  
     9fb:	c3                   	ret    

000009fc <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     9fc:	55                   	push   %ebp
     9fd:	89 e5                	mov    %esp,%ebp
     9ff:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     a02:	8b 45 08             	mov    0x8(%ebp),%eax
     a05:	8b 40 10             	mov    0x10(%eax),%eax
     a08:	85 c0                	test   %eax,%eax
     a0a:	75 07                	jne    a13 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a11:	eb 7f                	jmp    a92 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	8b 00                	mov    (%eax),%eax
     a18:	89 04 24             	mov    %eax,(%esp)
     a1b:	e8 84 f9 ff ff       	call   3a4 <kthread_mutex_lock>
     a20:	83 f8 ff             	cmp    $0xffffffff,%eax
     a23:	7d 07                	jge    a2c <mesa_slots_monitor_takeslot+0x30>
		return -1;
     a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a2a:	eb 66                	jmp    a92 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     a2c:	eb 17                	jmp    a45 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     a2e:	8b 45 08             	mov    0x8(%ebp),%eax
     a31:	8b 10                	mov    (%eax),%edx
     a33:	8b 45 08             	mov    0x8(%ebp),%eax
     a36:	8b 40 04             	mov    0x4(%eax),%eax
     a39:	89 54 24 04          	mov    %edx,0x4(%esp)
     a3d:	89 04 24             	mov    %eax,(%esp)
     a40:	e8 15 05 00 00       	call   f5a <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	8b 40 10             	mov    0x10(%eax),%eax
     a4b:	85 c0                	test   %eax,%eax
     a4d:	74 0a                	je     a59 <mesa_slots_monitor_takeslot+0x5d>
     a4f:	8b 45 08             	mov    0x8(%ebp),%eax
     a52:	8b 40 0c             	mov    0xc(%eax),%eax
     a55:	85 c0                	test   %eax,%eax
     a57:	74 d5                	je     a2e <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     a59:	8b 45 08             	mov    0x8(%ebp),%eax
     a5c:	8b 40 10             	mov    0x10(%eax),%eax
     a5f:	85 c0                	test   %eax,%eax
     a61:	74 0f                	je     a72 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     a63:	8b 45 08             	mov    0x8(%ebp),%eax
     a66:	8b 40 0c             	mov    0xc(%eax),%eax
     a69:	8d 50 ff             	lea    -0x1(%eax),%edx
     a6c:	8b 45 08             	mov    0x8(%ebp),%eax
     a6f:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     a72:	8b 45 08             	mov    0x8(%ebp),%eax
     a75:	8b 40 08             	mov    0x8(%eax),%eax
     a78:	89 04 24             	mov    %eax,(%esp)
     a7b:	e8 44 05 00 00       	call   fc4 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     a80:	8b 45 08             	mov    0x8(%ebp),%eax
     a83:	8b 00                	mov    (%eax),%eax
     a85:	89 04 24             	mov    %eax,(%esp)
     a88:	e8 1f f9 ff ff       	call   3ac <kthread_mutex_unlock>

	return 1;
     a8d:	b8 01 00 00 00       	mov    $0x1,%eax

}
     a92:	c9                   	leave  
     a93:	c3                   	ret    

00000a94 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     a94:	55                   	push   %ebp
     a95:	89 e5                	mov    %esp,%ebp
     a97:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     a9a:	8b 45 08             	mov    0x8(%ebp),%eax
     a9d:	8b 40 10             	mov    0x10(%eax),%eax
     aa0:	85 c0                	test   %eax,%eax
     aa2:	75 07                	jne    aab <mesa_slots_monitor_stopadding+0x17>
			return -1;
     aa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     aa9:	eb 35                	jmp    ae0 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     aab:	8b 45 08             	mov    0x8(%ebp),%eax
     aae:	8b 00                	mov    (%eax),%eax
     ab0:	89 04 24             	mov    %eax,(%esp)
     ab3:	e8 ec f8 ff ff       	call   3a4 <kthread_mutex_lock>
     ab8:	83 f8 ff             	cmp    $0xffffffff,%eax
     abb:	7d 07                	jge    ac4 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ac2:	eb 1c                	jmp    ae0 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     ac4:	8b 45 08             	mov    0x8(%ebp),%eax
     ac7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     ace:	8b 45 08             	mov    0x8(%ebp),%eax
     ad1:	8b 00                	mov    (%eax),%eax
     ad3:	89 04 24             	mov    %eax,(%esp)
     ad6:	e8 d1 f8 ff ff       	call   3ac <kthread_mutex_unlock>

		return 0;
     adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ae0:	c9                   	leave  
     ae1:	c3                   	ret    

00000ae2 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     ae2:	55                   	push   %ebp
     ae3:	89 e5                	mov    %esp,%ebp
     ae5:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     ae8:	e8 a7 f8 ff ff       	call   394 <kthread_mutex_alloc>
     aed:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     af0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     af4:	79 0a                	jns    b00 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     af6:	b8 00 00 00 00       	mov    $0x0,%eax
     afb:	e9 8b 00 00 00       	jmp    b8b <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     b00:	e8 68 02 00 00       	call   d6d <hoare_cond_alloc>
     b05:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b0c:	75 12                	jne    b20 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b11:	89 04 24             	mov    %eax,(%esp)
     b14:	e8 83 f8 ff ff       	call   39c <kthread_mutex_dealloc>
		return 0;
     b19:	b8 00 00 00 00       	mov    $0x0,%eax
     b1e:	eb 6b                	jmp    b8b <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     b20:	e8 48 02 00 00       	call   d6d <hoare_cond_alloc>
     b25:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     b28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b2c:	75 1d                	jne    b4b <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b31:	89 04 24             	mov    %eax,(%esp)
     b34:	e8 63 f8 ff ff       	call   39c <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b3c:	89 04 24             	mov    %eax,(%esp)
     b3f:	e8 6a 02 00 00       	call   dae <hoare_cond_dealloc>
		return 0;
     b44:	b8 00 00 00 00       	mov    $0x0,%eax
     b49:	eb 40                	jmp    b8b <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     b4b:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b52:	e8 31 fc ff ff       	call   788 <malloc>
     b57:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b60:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b66:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b69:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b72:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b81:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b88:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b8b:	c9                   	leave  
     b8c:	c3                   	ret    

00000b8d <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     b8d:	55                   	push   %ebp
     b8e:	89 e5                	mov    %esp,%ebp
     b90:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     b93:	8b 45 08             	mov    0x8(%ebp),%eax
     b96:	8b 00                	mov    (%eax),%eax
     b98:	89 04 24             	mov    %eax,(%esp)
     b9b:	e8 fc f7 ff ff       	call   39c <kthread_mutex_dealloc>
     ba0:	85 c0                	test   %eax,%eax
     ba2:	78 2e                	js     bd2 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     ba4:	8b 45 08             	mov    0x8(%ebp),%eax
     ba7:	8b 40 04             	mov    0x4(%eax),%eax
     baa:	89 04 24             	mov    %eax,(%esp)
     bad:	e8 bb 01 00 00       	call   d6d <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     bb2:	8b 45 08             	mov    0x8(%ebp),%eax
     bb5:	8b 40 08             	mov    0x8(%eax),%eax
     bb8:	89 04 24             	mov    %eax,(%esp)
     bbb:	e8 ad 01 00 00       	call   d6d <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     bc0:	8b 45 08             	mov    0x8(%ebp),%eax
     bc3:	89 04 24             	mov    %eax,(%esp)
     bc6:	e8 84 fa ff ff       	call   64f <free>
	return 0;
     bcb:	b8 00 00 00 00       	mov    $0x0,%eax
     bd0:	eb 05                	jmp    bd7 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     bd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bd7:	c9                   	leave  
     bd8:	c3                   	ret    

00000bd9 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     bd9:	55                   	push   %ebp
     bda:	89 e5                	mov    %esp,%ebp
     bdc:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	8b 40 10             	mov    0x10(%eax),%eax
     be5:	85 c0                	test   %eax,%eax
     be7:	75 0a                	jne    bf3 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bee:	e9 88 00 00 00       	jmp    c7b <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bf3:	8b 45 08             	mov    0x8(%ebp),%eax
     bf6:	8b 00                	mov    (%eax),%eax
     bf8:	89 04 24             	mov    %eax,(%esp)
     bfb:	e8 a4 f7 ff ff       	call   3a4 <kthread_mutex_lock>
     c00:	83 f8 ff             	cmp    $0xffffffff,%eax
     c03:	7d 07                	jge    c0c <hoare_slots_monitor_addslots+0x33>
		return -1;
     c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c0a:	eb 6f                	jmp    c7b <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     c0c:	8b 45 08             	mov    0x8(%ebp),%eax
     c0f:	8b 40 10             	mov    0x10(%eax),%eax
     c12:	85 c0                	test   %eax,%eax
     c14:	74 21                	je     c37 <hoare_slots_monitor_addslots+0x5e>
     c16:	8b 45 08             	mov    0x8(%ebp),%eax
     c19:	8b 40 0c             	mov    0xc(%eax),%eax
     c1c:	85 c0                	test   %eax,%eax
     c1e:	7e 17                	jle    c37 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     c20:	8b 45 08             	mov    0x8(%ebp),%eax
     c23:	8b 10                	mov    (%eax),%edx
     c25:	8b 45 08             	mov    0x8(%ebp),%eax
     c28:	8b 40 08             	mov    0x8(%eax),%eax
     c2b:	89 54 24 04          	mov    %edx,0x4(%esp)
     c2f:	89 04 24             	mov    %eax,(%esp)
     c32:	e8 c1 01 00 00       	call   df8 <hoare_cond_wait>


	if  ( monitor->active)
     c37:	8b 45 08             	mov    0x8(%ebp),%eax
     c3a:	8b 40 10             	mov    0x10(%eax),%eax
     c3d:	85 c0                	test   %eax,%eax
     c3f:	74 11                	je     c52 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     c41:	8b 45 08             	mov    0x8(%ebp),%eax
     c44:	8b 50 0c             	mov    0xc(%eax),%edx
     c47:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4a:	01 c2                	add    %eax,%edx
     c4c:	8b 45 08             	mov    0x8(%ebp),%eax
     c4f:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     c52:	8b 45 08             	mov    0x8(%ebp),%eax
     c55:	8b 10                	mov    (%eax),%edx
     c57:	8b 45 08             	mov    0x8(%ebp),%eax
     c5a:	8b 40 04             	mov    0x4(%eax),%eax
     c5d:	89 54 24 04          	mov    %edx,0x4(%esp)
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 e6 01 00 00       	call   e4f <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c69:	8b 45 08             	mov    0x8(%ebp),%eax
     c6c:	8b 00                	mov    (%eax),%eax
     c6e:	89 04 24             	mov    %eax,(%esp)
     c71:	e8 36 f7 ff ff       	call   3ac <kthread_mutex_unlock>

	return 1;
     c76:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c7b:	c9                   	leave  
     c7c:	c3                   	ret    

00000c7d <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     c7d:	55                   	push   %ebp
     c7e:	89 e5                	mov    %esp,%ebp
     c80:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c83:	8b 45 08             	mov    0x8(%ebp),%eax
     c86:	8b 40 10             	mov    0x10(%eax),%eax
     c89:	85 c0                	test   %eax,%eax
     c8b:	75 0a                	jne    c97 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c92:	e9 86 00 00 00       	jmp    d1d <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c97:	8b 45 08             	mov    0x8(%ebp),%eax
     c9a:	8b 00                	mov    (%eax),%eax
     c9c:	89 04 24             	mov    %eax,(%esp)
     c9f:	e8 00 f7 ff ff       	call   3a4 <kthread_mutex_lock>
     ca4:	83 f8 ff             	cmp    $0xffffffff,%eax
     ca7:	7d 07                	jge    cb0 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cae:	eb 6d                	jmp    d1d <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     cb0:	8b 45 08             	mov    0x8(%ebp),%eax
     cb3:	8b 40 10             	mov    0x10(%eax),%eax
     cb6:	85 c0                	test   %eax,%eax
     cb8:	74 21                	je     cdb <hoare_slots_monitor_takeslot+0x5e>
     cba:	8b 45 08             	mov    0x8(%ebp),%eax
     cbd:	8b 40 0c             	mov    0xc(%eax),%eax
     cc0:	85 c0                	test   %eax,%eax
     cc2:	75 17                	jne    cdb <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	8b 10                	mov    (%eax),%edx
     cc9:	8b 45 08             	mov    0x8(%ebp),%eax
     ccc:	8b 40 04             	mov    0x4(%eax),%eax
     ccf:	89 54 24 04          	mov    %edx,0x4(%esp)
     cd3:	89 04 24             	mov    %eax,(%esp)
     cd6:	e8 1d 01 00 00       	call   df8 <hoare_cond_wait>


	if  ( monitor->active)
     cdb:	8b 45 08             	mov    0x8(%ebp),%eax
     cde:	8b 40 10             	mov    0x10(%eax),%eax
     ce1:	85 c0                	test   %eax,%eax
     ce3:	74 0f                	je     cf4 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     ce5:	8b 45 08             	mov    0x8(%ebp),%eax
     ce8:	8b 40 0c             	mov    0xc(%eax),%eax
     ceb:	8d 50 ff             	lea    -0x1(%eax),%edx
     cee:	8b 45 08             	mov    0x8(%ebp),%eax
     cf1:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
     cf7:	8b 10                	mov    (%eax),%edx
     cf9:	8b 45 08             	mov    0x8(%ebp),%eax
     cfc:	8b 40 08             	mov    0x8(%eax),%eax
     cff:	89 54 24 04          	mov    %edx,0x4(%esp)
     d03:	89 04 24             	mov    %eax,(%esp)
     d06:	e8 44 01 00 00       	call   e4f <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	8b 00                	mov    (%eax),%eax
     d10:	89 04 24             	mov    %eax,(%esp)
     d13:	e8 94 f6 ff ff       	call   3ac <kthread_mutex_unlock>

	return 1;
     d18:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d1d:	c9                   	leave  
     d1e:	c3                   	ret    

00000d1f <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     d1f:	55                   	push   %ebp
     d20:	89 e5                	mov    %esp,%ebp
     d22:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d25:	8b 45 08             	mov    0x8(%ebp),%eax
     d28:	8b 40 10             	mov    0x10(%eax),%eax
     d2b:	85 c0                	test   %eax,%eax
     d2d:	75 07                	jne    d36 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d34:	eb 35                	jmp    d6b <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d36:	8b 45 08             	mov    0x8(%ebp),%eax
     d39:	8b 00                	mov    (%eax),%eax
     d3b:	89 04 24             	mov    %eax,(%esp)
     d3e:	e8 61 f6 ff ff       	call   3a4 <kthread_mutex_lock>
     d43:	83 f8 ff             	cmp    $0xffffffff,%eax
     d46:	7d 07                	jge    d4f <hoare_slots_monitor_stopadding+0x30>
			return -1;
     d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d4d:	eb 1c                	jmp    d6b <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d4f:	8b 45 08             	mov    0x8(%ebp),%eax
     d52:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d59:	8b 45 08             	mov    0x8(%ebp),%eax
     d5c:	8b 00                	mov    (%eax),%eax
     d5e:	89 04 24             	mov    %eax,(%esp)
     d61:	e8 46 f6 ff ff       	call   3ac <kthread_mutex_unlock>

		return 0;
     d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d6b:	c9                   	leave  
     d6c:	c3                   	ret    

00000d6d <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     d6d:	55                   	push   %ebp
     d6e:	89 e5                	mov    %esp,%ebp
     d70:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     d73:	e8 1c f6 ff ff       	call   394 <kthread_mutex_alloc>
     d78:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d7f:	79 07                	jns    d88 <hoare_cond_alloc+0x1b>
		return 0;
     d81:	b8 00 00 00 00       	mov    $0x0,%eax
     d86:	eb 24                	jmp    dac <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     d88:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d8f:	e8 f4 f9 ff ff       	call   788 <malloc>
     d94:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d9d:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     dac:	c9                   	leave  
     dad:	c3                   	ret    

00000dae <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     dae:	55                   	push   %ebp
     daf:	89 e5                	mov    %esp,%ebp
     db1:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     db8:	75 07                	jne    dc1 <hoare_cond_dealloc+0x13>
			return -1;
     dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dbf:	eb 35                	jmp    df6 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     dc1:	8b 45 08             	mov    0x8(%ebp),%eax
     dc4:	8b 00                	mov    (%eax),%eax
     dc6:	89 04 24             	mov    %eax,(%esp)
     dc9:	e8 de f5 ff ff       	call   3ac <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	8b 00                	mov    (%eax),%eax
     dd3:	89 04 24             	mov    %eax,(%esp)
     dd6:	e8 c1 f5 ff ff       	call   39c <kthread_mutex_dealloc>
     ddb:	85 c0                	test   %eax,%eax
     ddd:	79 07                	jns    de6 <hoare_cond_dealloc+0x38>
			return -1;
     ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     de4:	eb 10                	jmp    df6 <hoare_cond_dealloc+0x48>

		free (hCond);
     de6:	8b 45 08             	mov    0x8(%ebp),%eax
     de9:	89 04 24             	mov    %eax,(%esp)
     dec:	e8 5e f8 ff ff       	call   64f <free>
		return 0;
     df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
     df6:	c9                   	leave  
     df7:	c3                   	ret    

00000df8 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     df8:	55                   	push   %ebp
     df9:	89 e5                	mov    %esp,%ebp
     dfb:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e02:	75 07                	jne    e0b <hoare_cond_wait+0x13>
			return -1;
     e04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e09:	eb 42                	jmp    e4d <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     e0b:	8b 45 08             	mov    0x8(%ebp),%eax
     e0e:	8b 40 04             	mov    0x4(%eax),%eax
     e11:	8d 50 01             	lea    0x1(%eax),%edx
     e14:	8b 45 08             	mov    0x8(%ebp),%eax
     e17:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     e1a:	8b 45 08             	mov    0x8(%ebp),%eax
     e1d:	8b 00                	mov    (%eax),%eax
     e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e23:	8b 45 0c             	mov    0xc(%ebp),%eax
     e26:	89 04 24             	mov    %eax,(%esp)
     e29:	e8 86 f5 ff ff       	call   3b4 <kthread_mutex_yieldlock>
     e2e:	85 c0                	test   %eax,%eax
     e30:	79 16                	jns    e48 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     e32:	8b 45 08             	mov    0x8(%ebp),%eax
     e35:	8b 40 04             	mov    0x4(%eax),%eax
     e38:	8d 50 ff             	lea    -0x1(%eax),%edx
     e3b:	8b 45 08             	mov    0x8(%ebp),%eax
     e3e:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e46:	eb 05                	jmp    e4d <hoare_cond_wait+0x55>
		}

	return 0;
     e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e4d:	c9                   	leave  
     e4e:	c3                   	ret    

00000e4f <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     e4f:	55                   	push   %ebp
     e50:	89 e5                	mov    %esp,%ebp
     e52:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e59:	75 07                	jne    e62 <hoare_cond_signal+0x13>
		return -1;
     e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e60:	eb 6b                	jmp    ecd <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     e62:	8b 45 08             	mov    0x8(%ebp),%eax
     e65:	8b 40 04             	mov    0x4(%eax),%eax
     e68:	85 c0                	test   %eax,%eax
     e6a:	7e 3d                	jle    ea9 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     e6c:	8b 45 08             	mov    0x8(%ebp),%eax
     e6f:	8b 40 04             	mov    0x4(%eax),%eax
     e72:	8d 50 ff             	lea    -0x1(%eax),%edx
     e75:	8b 45 08             	mov    0x8(%ebp),%eax
     e78:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     e7b:	8b 45 08             	mov    0x8(%ebp),%eax
     e7e:	8b 00                	mov    (%eax),%eax
     e80:	89 44 24 04          	mov    %eax,0x4(%esp)
     e84:	8b 45 0c             	mov    0xc(%ebp),%eax
     e87:	89 04 24             	mov    %eax,(%esp)
     e8a:	e8 25 f5 ff ff       	call   3b4 <kthread_mutex_yieldlock>
     e8f:	85 c0                	test   %eax,%eax
     e91:	79 16                	jns    ea9 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     e93:	8b 45 08             	mov    0x8(%ebp),%eax
     e96:	8b 40 04             	mov    0x4(%eax),%eax
     e99:	8d 50 01             	lea    0x1(%eax),%edx
     e9c:	8b 45 08             	mov    0x8(%ebp),%eax
     e9f:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea7:	eb 24                	jmp    ecd <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     ea9:	8b 45 08             	mov    0x8(%ebp),%eax
     eac:	8b 00                	mov    (%eax),%eax
     eae:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb5:	89 04 24             	mov    %eax,(%esp)
     eb8:	e8 f7 f4 ff ff       	call   3b4 <kthread_mutex_yieldlock>
     ebd:	85 c0                	test   %eax,%eax
     ebf:	79 07                	jns    ec8 <hoare_cond_signal+0x79>

    			return -1;
     ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ec6:	eb 05                	jmp    ecd <hoare_cond_signal+0x7e>
    }

	return 0;
     ec8:	b8 00 00 00 00       	mov    $0x0,%eax

}
     ecd:	c9                   	leave  
     ece:	c3                   	ret    

00000ecf <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     ecf:	55                   	push   %ebp
     ed0:	89 e5                	mov    %esp,%ebp
     ed2:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ed5:	e8 ba f4 ff ff       	call   394 <kthread_mutex_alloc>
     eda:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ee1:	79 07                	jns    eea <mesa_cond_alloc+0x1b>
		return 0;
     ee3:	b8 00 00 00 00       	mov    $0x0,%eax
     ee8:	eb 24                	jmp    f0e <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
     eea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     ef1:	e8 92 f8 ff ff       	call   788 <malloc>
     ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
     ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eff:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
     f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
     f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f0e:	c9                   	leave  
     f0f:	c3                   	ret    

00000f10 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
     f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f1a:	75 07                	jne    f23 <mesa_cond_dealloc+0x13>
		return -1;
     f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f21:	eb 35                	jmp    f58 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
     f23:	8b 45 08             	mov    0x8(%ebp),%eax
     f26:	8b 00                	mov    (%eax),%eax
     f28:	89 04 24             	mov    %eax,(%esp)
     f2b:	e8 7c f4 ff ff       	call   3ac <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
     f30:	8b 45 08             	mov    0x8(%ebp),%eax
     f33:	8b 00                	mov    (%eax),%eax
     f35:	89 04 24             	mov    %eax,(%esp)
     f38:	e8 5f f4 ff ff       	call   39c <kthread_mutex_dealloc>
     f3d:	85 c0                	test   %eax,%eax
     f3f:	79 07                	jns    f48 <mesa_cond_dealloc+0x38>
		return -1;
     f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f46:	eb 10                	jmp    f58 <mesa_cond_dealloc+0x48>

	free (mCond);
     f48:	8b 45 08             	mov    0x8(%ebp),%eax
     f4b:	89 04 24             	mov    %eax,(%esp)
     f4e:	e8 fc f6 ff ff       	call   64f <free>
	return 0;
     f53:	b8 00 00 00 00       	mov    $0x0,%eax

}
     f58:	c9                   	leave  
     f59:	c3                   	ret    

00000f5a <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
     f5a:	55                   	push   %ebp
     f5b:	89 e5                	mov    %esp,%ebp
     f5d:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     f60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f64:	75 07                	jne    f6d <mesa_cond_wait+0x13>
		return -1;
     f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f6b:	eb 55                	jmp    fc2 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
     f6d:	8b 45 08             	mov    0x8(%ebp),%eax
     f70:	8b 40 04             	mov    0x4(%eax),%eax
     f73:	8d 50 01             	lea    0x1(%eax),%edx
     f76:	8b 45 08             	mov    0x8(%ebp),%eax
     f79:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7f:	89 04 24             	mov    %eax,(%esp)
     f82:	e8 25 f4 ff ff       	call   3ac <kthread_mutex_unlock>
     f87:	85 c0                	test   %eax,%eax
     f89:	79 27                	jns    fb2 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
     f8b:	8b 45 08             	mov    0x8(%ebp),%eax
     f8e:	8b 00                	mov    (%eax),%eax
     f90:	89 04 24             	mov    %eax,(%esp)
     f93:	e8 0c f4 ff ff       	call   3a4 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f98:	85 c0                	test   %eax,%eax
     f9a:	79 16                	jns    fb2 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
     f9c:	8b 45 08             	mov    0x8(%ebp),%eax
     f9f:	8b 40 04             	mov    0x4(%eax),%eax
     fa2:	8d 50 ff             	lea    -0x1(%eax),%edx
     fa5:	8b 45 08             	mov    0x8(%ebp),%eax
     fa8:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
     fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fb0:	eb 10                	jmp    fc2 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
     fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
     fb5:	89 04 24             	mov    %eax,(%esp)
     fb8:	e8 e7 f3 ff ff       	call   3a4 <kthread_mutex_lock>
	return 0;
     fbd:	b8 00 00 00 00       	mov    $0x0,%eax


}
     fc2:	c9                   	leave  
     fc3:	c3                   	ret    

00000fc4 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
     fc4:	55                   	push   %ebp
     fc5:	89 e5                	mov    %esp,%ebp
     fc7:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     fca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fce:	75 07                	jne    fd7 <mesa_cond_signal+0x13>
		return -1;
     fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fd5:	eb 5d                	jmp    1034 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
     fd7:	8b 45 08             	mov    0x8(%ebp),%eax
     fda:	8b 40 04             	mov    0x4(%eax),%eax
     fdd:	85 c0                	test   %eax,%eax
     fdf:	7e 36                	jle    1017 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
     fe1:	8b 45 08             	mov    0x8(%ebp),%eax
     fe4:	8b 40 04             	mov    0x4(%eax),%eax
     fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
     fea:	8b 45 08             	mov    0x8(%ebp),%eax
     fed:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
     ff0:	8b 45 08             	mov    0x8(%ebp),%eax
     ff3:	8b 00                	mov    (%eax),%eax
     ff5:	89 04 24             	mov    %eax,(%esp)
     ff8:	e8 af f3 ff ff       	call   3ac <kthread_mutex_unlock>
     ffd:	85 c0                	test   %eax,%eax
     fff:	78 16                	js     1017 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    1001:	8b 45 08             	mov    0x8(%ebp),%eax
    1004:	8b 40 04             	mov    0x4(%eax),%eax
    1007:	8d 50 01             	lea    0x1(%eax),%edx
    100a:	8b 45 08             	mov    0x8(%ebp),%eax
    100d:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    1010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1015:	eb 1d                	jmp    1034 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	8b 00                	mov    (%eax),%eax
    101c:	89 04 24             	mov    %eax,(%esp)
    101f:	e8 88 f3 ff ff       	call   3ac <kthread_mutex_unlock>
    1024:	85 c0                	test   %eax,%eax
    1026:	79 07                	jns    102f <mesa_cond_signal+0x6b>

		return -1;
    1028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    102d:	eb 05                	jmp    1034 <mesa_cond_signal+0x70>
	}
	return 0;
    102f:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1034:	c9                   	leave  
    1035:	c3                   	ret    
