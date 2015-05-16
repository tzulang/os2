
_ln:     file format elf32-i386


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
       6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
       9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
       d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
       f:	c7 44 24 04 43 10 00 	movl   $0x1043,0x4(%esp)
      16:	00 
      17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      1e:	e8 86 04 00 00       	call   4a9 <printf>
    exit();
      23:	e8 b9 02 00 00       	call   2e1 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
      28:	8b 45 0c             	mov    0xc(%ebp),%eax
      2b:	83 c0 08             	add    $0x8,%eax
      2e:	8b 10                	mov    (%eax),%edx
      30:	8b 45 0c             	mov    0xc(%ebp),%eax
      33:	83 c0 04             	add    $0x4,%eax
      36:	8b 00                	mov    (%eax),%eax
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 fd 02 00 00       	call   341 <link>
      44:	85 c0                	test   %eax,%eax
      46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
      48:	8b 45 0c             	mov    0xc(%ebp),%eax
      4b:	83 c0 08             	add    $0x8,%eax
      4e:	8b 10                	mov    (%eax),%edx
      50:	8b 45 0c             	mov    0xc(%ebp),%eax
      53:	83 c0 04             	add    $0x4,%eax
      56:	8b 00                	mov    (%eax),%eax
      58:	89 54 24 0c          	mov    %edx,0xc(%esp)
      5c:	89 44 24 08          	mov    %eax,0x8(%esp)
      60:	c7 44 24 04 56 10 00 	movl   $0x1056,0x4(%esp)
      67:	00 
      68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      6f:	e8 35 04 00 00       	call   4a9 <printf>
  exit();
      74:	e8 68 02 00 00       	call   2e1 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
      79:	55                   	push   %ebp
      7a:	89 e5                	mov    %esp,%ebp
      7c:	57                   	push   %edi
      7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
      7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
      81:	8b 55 10             	mov    0x10(%ebp),%edx
      84:	8b 45 0c             	mov    0xc(%ebp),%eax
      87:	89 cb                	mov    %ecx,%ebx
      89:	89 df                	mov    %ebx,%edi
      8b:	89 d1                	mov    %edx,%ecx
      8d:	fc                   	cld    
      8e:	f3 aa                	rep stos %al,%es:(%edi)
      90:	89 ca                	mov    %ecx,%edx
      92:	89 fb                	mov    %edi,%ebx
      94:	89 5d 08             	mov    %ebx,0x8(%ebp)
      97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
      9a:	5b                   	pop    %ebx
      9b:	5f                   	pop    %edi
      9c:	5d                   	pop    %ebp
      9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
      9e:	55                   	push   %ebp
      9f:	89 e5                	mov    %esp,%ebp
      a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
      a4:	8b 45 08             	mov    0x8(%ebp),%eax
      a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
      aa:	90                   	nop
      ab:	8b 45 08             	mov    0x8(%ebp),%eax
      ae:	8d 50 01             	lea    0x1(%eax),%edx
      b1:	89 55 08             	mov    %edx,0x8(%ebp)
      b4:	8b 55 0c             	mov    0xc(%ebp),%edx
      b7:	8d 4a 01             	lea    0x1(%edx),%ecx
      ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
      bd:	0f b6 12             	movzbl (%edx),%edx
      c0:	88 10                	mov    %dl,(%eax)
      c2:	0f b6 00             	movzbl (%eax),%eax
      c5:	84 c0                	test   %al,%al
      c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
      c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
      cc:	c9                   	leave  
      cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
      ce:	55                   	push   %ebp
      cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
      d1:	eb 08                	jmp    db <strcmp+0xd>
    p++, q++;
      d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
      d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
      db:	8b 45 08             	mov    0x8(%ebp),%eax
      de:	0f b6 00             	movzbl (%eax),%eax
      e1:	84 c0                	test   %al,%al
      e3:	74 10                	je     f5 <strcmp+0x27>
      e5:	8b 45 08             	mov    0x8(%ebp),%eax
      e8:	0f b6 10             	movzbl (%eax),%edx
      eb:	8b 45 0c             	mov    0xc(%ebp),%eax
      ee:	0f b6 00             	movzbl (%eax),%eax
      f1:	38 c2                	cmp    %al,%dl
      f3:	74 de                	je     d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
      f5:	8b 45 08             	mov    0x8(%ebp),%eax
      f8:	0f b6 00             	movzbl (%eax),%eax
      fb:	0f b6 d0             	movzbl %al,%edx
      fe:	8b 45 0c             	mov    0xc(%ebp),%eax
     101:	0f b6 00             	movzbl (%eax),%eax
     104:	0f b6 c0             	movzbl %al,%eax
     107:	29 c2                	sub    %eax,%edx
     109:	89 d0                	mov    %edx,%eax
}
     10b:	5d                   	pop    %ebp
     10c:	c3                   	ret    

0000010d <strlen>:

uint
strlen(char *s)
{
     10d:	55                   	push   %ebp
     10e:	89 e5                	mov    %esp,%ebp
     110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     11a:	eb 04                	jmp    120 <strlen+0x13>
     11c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     120:	8b 55 fc             	mov    -0x4(%ebp),%edx
     123:	8b 45 08             	mov    0x8(%ebp),%eax
     126:	01 d0                	add    %edx,%eax
     128:	0f b6 00             	movzbl (%eax),%eax
     12b:	84 c0                	test   %al,%al
     12d:	75 ed                	jne    11c <strlen+0xf>
    ;
  return n;
     12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     132:	c9                   	leave  
     133:	c3                   	ret    

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
     134:	55                   	push   %ebp
     135:	89 e5                	mov    %esp,%ebp
     137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     13a:	8b 45 10             	mov    0x10(%ebp),%eax
     13d:	89 44 24 08          	mov    %eax,0x8(%esp)
     141:	8b 45 0c             	mov    0xc(%ebp),%eax
     144:	89 44 24 04          	mov    %eax,0x4(%esp)
     148:	8b 45 08             	mov    0x8(%ebp),%eax
     14b:	89 04 24             	mov    %eax,(%esp)
     14e:	e8 26 ff ff ff       	call   79 <stosb>
  return dst;
     153:	8b 45 08             	mov    0x8(%ebp),%eax
}
     156:	c9                   	leave  
     157:	c3                   	ret    

00000158 <strchr>:

char*
strchr(const char *s, char c)
{
     158:	55                   	push   %ebp
     159:	89 e5                	mov    %esp,%ebp
     15b:	83 ec 04             	sub    $0x4,%esp
     15e:	8b 45 0c             	mov    0xc(%ebp),%eax
     161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     164:	eb 14                	jmp    17a <strchr+0x22>
    if(*s == c)
     166:	8b 45 08             	mov    0x8(%ebp),%eax
     169:	0f b6 00             	movzbl (%eax),%eax
     16c:	3a 45 fc             	cmp    -0x4(%ebp),%al
     16f:	75 05                	jne    176 <strchr+0x1e>
      return (char*)s;
     171:	8b 45 08             	mov    0x8(%ebp),%eax
     174:	eb 13                	jmp    189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     17a:	8b 45 08             	mov    0x8(%ebp),%eax
     17d:	0f b6 00             	movzbl (%eax),%eax
     180:	84 c0                	test   %al,%al
     182:	75 e2                	jne    166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     184:	b8 00 00 00 00       	mov    $0x0,%eax
}
     189:	c9                   	leave  
     18a:	c3                   	ret    

0000018b <gets>:

char*
gets(char *buf, int max)
{
     18b:	55                   	push   %ebp
     18c:	89 e5                	mov    %esp,%ebp
     18e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     198:	eb 4c                	jmp    1e6 <gets+0x5b>
    cc = read(0, &c, 1);
     19a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     1a1:	00 
     1a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
     1a5:	89 44 24 04          	mov    %eax,0x4(%esp)
     1a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1b0:	e8 44 01 00 00       	call   2f9 <read>
     1b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     1b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1bc:	7f 02                	jg     1c0 <gets+0x35>
      break;
     1be:	eb 31                	jmp    1f1 <gets+0x66>
    buf[i++] = c;
     1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c3:	8d 50 01             	lea    0x1(%eax),%edx
     1c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
     1c9:	89 c2                	mov    %eax,%edx
     1cb:	8b 45 08             	mov    0x8(%ebp),%eax
     1ce:	01 c2                	add    %eax,%edx
     1d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1da:	3c 0a                	cmp    $0xa,%al
     1dc:	74 13                	je     1f1 <gets+0x66>
     1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1e2:	3c 0d                	cmp    $0xd,%al
     1e4:	74 0b                	je     1f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e9:	83 c0 01             	add    $0x1,%eax
     1ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
     1ef:	7c a9                	jl     19a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     1f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     1f4:	8b 45 08             	mov    0x8(%ebp),%eax
     1f7:	01 d0                	add    %edx,%eax
     1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1ff:	c9                   	leave  
     200:	c3                   	ret    

00000201 <stat>:

int
stat(char *n, struct stat *st)
{
     201:	55                   	push   %ebp
     202:	89 e5                	mov    %esp,%ebp
     204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     20e:	00 
     20f:	8b 45 08             	mov    0x8(%ebp),%eax
     212:	89 04 24             	mov    %eax,(%esp)
     215:	e8 07 01 00 00       	call   321 <open>
     21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     21d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     221:	79 07                	jns    22a <stat+0x29>
    return -1;
     223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     228:	eb 23                	jmp    24d <stat+0x4c>
  r = fstat(fd, st);
     22a:	8b 45 0c             	mov    0xc(%ebp),%eax
     22d:	89 44 24 04          	mov    %eax,0x4(%esp)
     231:	8b 45 f4             	mov    -0xc(%ebp),%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 fd 00 00 00       	call   339 <fstat>
     23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     242:	89 04 24             	mov    %eax,(%esp)
     245:	e8 bf 00 00 00       	call   309 <close>
  return r;
     24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     24d:	c9                   	leave  
     24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
     24f:	55                   	push   %ebp
     250:	89 e5                	mov    %esp,%ebp
     252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     25c:	eb 25                	jmp    283 <atoi+0x34>
    n = n*10 + *s++ - '0';
     25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     261:	89 d0                	mov    %edx,%eax
     263:	c1 e0 02             	shl    $0x2,%eax
     266:	01 d0                	add    %edx,%eax
     268:	01 c0                	add    %eax,%eax
     26a:	89 c1                	mov    %eax,%ecx
     26c:	8b 45 08             	mov    0x8(%ebp),%eax
     26f:	8d 50 01             	lea    0x1(%eax),%edx
     272:	89 55 08             	mov    %edx,0x8(%ebp)
     275:	0f b6 00             	movzbl (%eax),%eax
     278:	0f be c0             	movsbl %al,%eax
     27b:	01 c8                	add    %ecx,%eax
     27d:	83 e8 30             	sub    $0x30,%eax
     280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     283:	8b 45 08             	mov    0x8(%ebp),%eax
     286:	0f b6 00             	movzbl (%eax),%eax
     289:	3c 2f                	cmp    $0x2f,%al
     28b:	7e 0a                	jle    297 <atoi+0x48>
     28d:	8b 45 08             	mov    0x8(%ebp),%eax
     290:	0f b6 00             	movzbl (%eax),%eax
     293:	3c 39                	cmp    $0x39,%al
     295:	7e c7                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     29a:	c9                   	leave  
     29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     29c:	55                   	push   %ebp
     29d:	89 e5                	mov    %esp,%ebp
     29f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     2a2:	8b 45 08             	mov    0x8(%ebp),%eax
     2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     2ae:	eb 17                	jmp    2c7 <memmove+0x2b>
    *dst++ = *src++;
     2b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     2b3:	8d 50 01             	lea    0x1(%eax),%edx
     2b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
     2b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
     2bc:	8d 4a 01             	lea    0x1(%edx),%ecx
     2bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     2c2:	0f b6 12             	movzbl (%edx),%edx
     2c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     2c7:	8b 45 10             	mov    0x10(%ebp),%eax
     2ca:	8d 50 ff             	lea    -0x1(%eax),%edx
     2cd:	89 55 10             	mov    %edx,0x10(%ebp)
     2d0:	85 c0                	test   %eax,%eax
     2d2:	7f dc                	jg     2b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     2d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2d7:	c9                   	leave  
     2d8:	c3                   	ret    

000002d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     2d9:	b8 01 00 00 00       	mov    $0x1,%eax
     2de:	cd 40                	int    $0x40
     2e0:	c3                   	ret    

000002e1 <exit>:
SYSCALL(exit)
     2e1:	b8 02 00 00 00       	mov    $0x2,%eax
     2e6:	cd 40                	int    $0x40
     2e8:	c3                   	ret    

000002e9 <wait>:
SYSCALL(wait)
     2e9:	b8 03 00 00 00       	mov    $0x3,%eax
     2ee:	cd 40                	int    $0x40
     2f0:	c3                   	ret    

000002f1 <pipe>:
SYSCALL(pipe)
     2f1:	b8 04 00 00 00       	mov    $0x4,%eax
     2f6:	cd 40                	int    $0x40
     2f8:	c3                   	ret    

000002f9 <read>:
SYSCALL(read)
     2f9:	b8 05 00 00 00       	mov    $0x5,%eax
     2fe:	cd 40                	int    $0x40
     300:	c3                   	ret    

00000301 <write>:
SYSCALL(write)
     301:	b8 10 00 00 00       	mov    $0x10,%eax
     306:	cd 40                	int    $0x40
     308:	c3                   	ret    

00000309 <close>:
SYSCALL(close)
     309:	b8 15 00 00 00       	mov    $0x15,%eax
     30e:	cd 40                	int    $0x40
     310:	c3                   	ret    

00000311 <kill>:
SYSCALL(kill)
     311:	b8 06 00 00 00       	mov    $0x6,%eax
     316:	cd 40                	int    $0x40
     318:	c3                   	ret    

00000319 <exec>:
SYSCALL(exec)
     319:	b8 07 00 00 00       	mov    $0x7,%eax
     31e:	cd 40                	int    $0x40
     320:	c3                   	ret    

00000321 <open>:
SYSCALL(open)
     321:	b8 0f 00 00 00       	mov    $0xf,%eax
     326:	cd 40                	int    $0x40
     328:	c3                   	ret    

00000329 <mknod>:
SYSCALL(mknod)
     329:	b8 11 00 00 00       	mov    $0x11,%eax
     32e:	cd 40                	int    $0x40
     330:	c3                   	ret    

00000331 <unlink>:
SYSCALL(unlink)
     331:	b8 12 00 00 00       	mov    $0x12,%eax
     336:	cd 40                	int    $0x40
     338:	c3                   	ret    

00000339 <fstat>:
SYSCALL(fstat)
     339:	b8 08 00 00 00       	mov    $0x8,%eax
     33e:	cd 40                	int    $0x40
     340:	c3                   	ret    

00000341 <link>:
SYSCALL(link)
     341:	b8 13 00 00 00       	mov    $0x13,%eax
     346:	cd 40                	int    $0x40
     348:	c3                   	ret    

00000349 <mkdir>:
SYSCALL(mkdir)
     349:	b8 14 00 00 00       	mov    $0x14,%eax
     34e:	cd 40                	int    $0x40
     350:	c3                   	ret    

00000351 <chdir>:
SYSCALL(chdir)
     351:	b8 09 00 00 00       	mov    $0x9,%eax
     356:	cd 40                	int    $0x40
     358:	c3                   	ret    

00000359 <dup>:
SYSCALL(dup)
     359:	b8 0a 00 00 00       	mov    $0xa,%eax
     35e:	cd 40                	int    $0x40
     360:	c3                   	ret    

00000361 <getpid>:
SYSCALL(getpid)
     361:	b8 0b 00 00 00       	mov    $0xb,%eax
     366:	cd 40                	int    $0x40
     368:	c3                   	ret    

00000369 <sbrk>:
SYSCALL(sbrk)
     369:	b8 0c 00 00 00       	mov    $0xc,%eax
     36e:	cd 40                	int    $0x40
     370:	c3                   	ret    

00000371 <sleep>:
SYSCALL(sleep)
     371:	b8 0d 00 00 00       	mov    $0xd,%eax
     376:	cd 40                	int    $0x40
     378:	c3                   	ret    

00000379 <uptime>:
SYSCALL(uptime)
     379:	b8 0e 00 00 00       	mov    $0xe,%eax
     37e:	cd 40                	int    $0x40
     380:	c3                   	ret    

00000381 <kthread_create>:




SYSCALL(kthread_create)
     381:	b8 16 00 00 00       	mov    $0x16,%eax
     386:	cd 40                	int    $0x40
     388:	c3                   	ret    

00000389 <kthread_id>:
SYSCALL(kthread_id)
     389:	b8 17 00 00 00       	mov    $0x17,%eax
     38e:	cd 40                	int    $0x40
     390:	c3                   	ret    

00000391 <kthread_exit>:
SYSCALL(kthread_exit)
     391:	b8 18 00 00 00       	mov    $0x18,%eax
     396:	cd 40                	int    $0x40
     398:	c3                   	ret    

00000399 <kthread_join>:
SYSCALL(kthread_join)
     399:	b8 19 00 00 00       	mov    $0x19,%eax
     39e:	cd 40                	int    $0x40
     3a0:	c3                   	ret    

000003a1 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     3a1:	b8 1a 00 00 00       	mov    $0x1a,%eax
     3a6:	cd 40                	int    $0x40
     3a8:	c3                   	ret    

000003a9 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     3a9:	b8 1b 00 00 00       	mov    $0x1b,%eax
     3ae:	cd 40                	int    $0x40
     3b0:	c3                   	ret    

000003b1 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     3b1:	b8 1c 00 00 00       	mov    $0x1c,%eax
     3b6:	cd 40                	int    $0x40
     3b8:	c3                   	ret    

000003b9 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     3b9:	b8 1d 00 00 00       	mov    $0x1d,%eax
     3be:	cd 40                	int    $0x40
     3c0:	c3                   	ret    

000003c1 <kthread_mutex_yieldlock>:
     3c1:	b8 1e 00 00 00       	mov    $0x1e,%eax
     3c6:	cd 40                	int    $0x40
     3c8:	c3                   	ret    

000003c9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     3c9:	55                   	push   %ebp
     3ca:	89 e5                	mov    %esp,%ebp
     3cc:	83 ec 18             	sub    $0x18,%esp
     3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
     3d2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     3d5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3dc:	00 
     3dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
     3e0:	89 44 24 04          	mov    %eax,0x4(%esp)
     3e4:	8b 45 08             	mov    0x8(%ebp),%eax
     3e7:	89 04 24             	mov    %eax,(%esp)
     3ea:	e8 12 ff ff ff       	call   301 <write>
}
     3ef:	c9                   	leave  
     3f0:	c3                   	ret    

000003f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     3f1:	55                   	push   %ebp
     3f2:	89 e5                	mov    %esp,%ebp
     3f4:	56                   	push   %esi
     3f5:	53                   	push   %ebx
     3f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     3f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     400:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     404:	74 17                	je     41d <printint+0x2c>
     406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     40a:	79 11                	jns    41d <printint+0x2c>
    neg = 1;
     40c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     413:	8b 45 0c             	mov    0xc(%ebp),%eax
     416:	f7 d8                	neg    %eax
     418:	89 45 ec             	mov    %eax,-0x14(%ebp)
     41b:	eb 06                	jmp    423 <printint+0x32>
  } else {
    x = xx;
     41d:	8b 45 0c             	mov    0xc(%ebp),%eax
     420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     42a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     42d:	8d 41 01             	lea    0x1(%ecx),%eax
     430:	89 45 f4             	mov    %eax,-0xc(%ebp)
     433:	8b 5d 10             	mov    0x10(%ebp),%ebx
     436:	8b 45 ec             	mov    -0x14(%ebp),%eax
     439:	ba 00 00 00 00       	mov    $0x0,%edx
     43e:	f7 f3                	div    %ebx
     440:	89 d0                	mov    %edx,%eax
     442:	0f b6 80 f8 14 00 00 	movzbl 0x14f8(%eax),%eax
     449:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     44d:	8b 75 10             	mov    0x10(%ebp),%esi
     450:	8b 45 ec             	mov    -0x14(%ebp),%eax
     453:	ba 00 00 00 00       	mov    $0x0,%edx
     458:	f7 f6                	div    %esi
     45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     45d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     461:	75 c7                	jne    42a <printint+0x39>
  if(neg)
     463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     467:	74 10                	je     479 <printint+0x88>
    buf[i++] = '-';
     469:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46c:	8d 50 01             	lea    0x1(%eax),%edx
     46f:	89 55 f4             	mov    %edx,-0xc(%ebp)
     472:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     477:	eb 1f                	jmp    498 <printint+0xa7>
     479:	eb 1d                	jmp    498 <printint+0xa7>
    putc(fd, buf[i]);
     47b:	8d 55 dc             	lea    -0x24(%ebp),%edx
     47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     481:	01 d0                	add    %edx,%eax
     483:	0f b6 00             	movzbl (%eax),%eax
     486:	0f be c0             	movsbl %al,%eax
     489:	89 44 24 04          	mov    %eax,0x4(%esp)
     48d:	8b 45 08             	mov    0x8(%ebp),%eax
     490:	89 04 24             	mov    %eax,(%esp)
     493:	e8 31 ff ff ff       	call   3c9 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     498:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     49c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4a0:	79 d9                	jns    47b <printint+0x8a>
    putc(fd, buf[i]);
}
     4a2:	83 c4 30             	add    $0x30,%esp
     4a5:	5b                   	pop    %ebx
     4a6:	5e                   	pop    %esi
     4a7:	5d                   	pop    %ebp
     4a8:	c3                   	ret    

000004a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     4a9:	55                   	push   %ebp
     4aa:	89 e5                	mov    %esp,%ebp
     4ac:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     4af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     4b6:	8d 45 0c             	lea    0xc(%ebp),%eax
     4b9:	83 c0 04             	add    $0x4,%eax
     4bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     4bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     4c6:	e9 7c 01 00 00       	jmp    647 <printf+0x19e>
    c = fmt[i] & 0xff;
     4cb:	8b 55 0c             	mov    0xc(%ebp),%edx
     4ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4d1:	01 d0                	add    %edx,%eax
     4d3:	0f b6 00             	movzbl (%eax),%eax
     4d6:	0f be c0             	movsbl %al,%eax
     4d9:	25 ff 00 00 00       	and    $0xff,%eax
     4de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     4e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4e5:	75 2c                	jne    513 <printf+0x6a>
      if(c == '%'){
     4e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     4eb:	75 0c                	jne    4f9 <printf+0x50>
        state = '%';
     4ed:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     4f4:	e9 4a 01 00 00       	jmp    643 <printf+0x19a>
      } else {
        putc(fd, c);
     4f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4fc:	0f be c0             	movsbl %al,%eax
     4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
     503:	8b 45 08             	mov    0x8(%ebp),%eax
     506:	89 04 24             	mov    %eax,(%esp)
     509:	e8 bb fe ff ff       	call   3c9 <putc>
     50e:	e9 30 01 00 00       	jmp    643 <printf+0x19a>
      }
    } else if(state == '%'){
     513:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     517:	0f 85 26 01 00 00    	jne    643 <printf+0x19a>
      if(c == 'd'){
     51d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     521:	75 2d                	jne    550 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     523:	8b 45 e8             	mov    -0x18(%ebp),%eax
     526:	8b 00                	mov    (%eax),%eax
     528:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     52f:	00 
     530:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     537:	00 
     538:	89 44 24 04          	mov    %eax,0x4(%esp)
     53c:	8b 45 08             	mov    0x8(%ebp),%eax
     53f:	89 04 24             	mov    %eax,(%esp)
     542:	e8 aa fe ff ff       	call   3f1 <printint>
        ap++;
     547:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     54b:	e9 ec 00 00 00       	jmp    63c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     550:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     554:	74 06                	je     55c <printf+0xb3>
     556:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     55a:	75 2d                	jne    589 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     55c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     55f:	8b 00                	mov    (%eax),%eax
     561:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     568:	00 
     569:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     570:	00 
     571:	89 44 24 04          	mov    %eax,0x4(%esp)
     575:	8b 45 08             	mov    0x8(%ebp),%eax
     578:	89 04 24             	mov    %eax,(%esp)
     57b:	e8 71 fe ff ff       	call   3f1 <printint>
        ap++;
     580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     584:	e9 b3 00 00 00       	jmp    63c <printf+0x193>
      } else if(c == 's'){
     589:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     58d:	75 45                	jne    5d4 <printf+0x12b>
        s = (char*)*ap;
     58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     592:	8b 00                	mov    (%eax),%eax
     594:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     597:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     59b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     59f:	75 09                	jne    5aa <printf+0x101>
          s = "(null)";
     5a1:	c7 45 f4 6a 10 00 00 	movl   $0x106a,-0xc(%ebp)
        while(*s != 0){
     5a8:	eb 1e                	jmp    5c8 <printf+0x11f>
     5aa:	eb 1c                	jmp    5c8 <printf+0x11f>
          putc(fd, *s);
     5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5af:	0f b6 00             	movzbl (%eax),%eax
     5b2:	0f be c0             	movsbl %al,%eax
     5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
     5b9:	8b 45 08             	mov    0x8(%ebp),%eax
     5bc:	89 04 24             	mov    %eax,(%esp)
     5bf:	e8 05 fe ff ff       	call   3c9 <putc>
          s++;
     5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cb:	0f b6 00             	movzbl (%eax),%eax
     5ce:	84 c0                	test   %al,%al
     5d0:	75 da                	jne    5ac <printf+0x103>
     5d2:	eb 68                	jmp    63c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     5d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     5d8:	75 1d                	jne    5f7 <printf+0x14e>
        putc(fd, *ap);
     5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5dd:	8b 00                	mov    (%eax),%eax
     5df:	0f be c0             	movsbl %al,%eax
     5e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     5e6:	8b 45 08             	mov    0x8(%ebp),%eax
     5e9:	89 04 24             	mov    %eax,(%esp)
     5ec:	e8 d8 fd ff ff       	call   3c9 <putc>
        ap++;
     5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5f5:	eb 45                	jmp    63c <printf+0x193>
      } else if(c == '%'){
     5f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     5fb:	75 17                	jne    614 <printf+0x16b>
        putc(fd, c);
     5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     600:	0f be c0             	movsbl %al,%eax
     603:	89 44 24 04          	mov    %eax,0x4(%esp)
     607:	8b 45 08             	mov    0x8(%ebp),%eax
     60a:	89 04 24             	mov    %eax,(%esp)
     60d:	e8 b7 fd ff ff       	call   3c9 <putc>
     612:	eb 28                	jmp    63c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     614:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     61b:	00 
     61c:	8b 45 08             	mov    0x8(%ebp),%eax
     61f:	89 04 24             	mov    %eax,(%esp)
     622:	e8 a2 fd ff ff       	call   3c9 <putc>
        putc(fd, c);
     627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     62a:	0f be c0             	movsbl %al,%eax
     62d:	89 44 24 04          	mov    %eax,0x4(%esp)
     631:	8b 45 08             	mov    0x8(%ebp),%eax
     634:	89 04 24             	mov    %eax,(%esp)
     637:	e8 8d fd ff ff       	call   3c9 <putc>
      }
      state = 0;
     63c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     643:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     647:	8b 55 0c             	mov    0xc(%ebp),%edx
     64a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     64d:	01 d0                	add    %edx,%eax
     64f:	0f b6 00             	movzbl (%eax),%eax
     652:	84 c0                	test   %al,%al
     654:	0f 85 71 fe ff ff    	jne    4cb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     65a:	c9                   	leave  
     65b:	c3                   	ret    

0000065c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     65c:	55                   	push   %ebp
     65d:	89 e5                	mov    %esp,%ebp
     65f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     662:	8b 45 08             	mov    0x8(%ebp),%eax
     665:	83 e8 08             	sub    $0x8,%eax
     668:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     66b:	a1 14 15 00 00       	mov    0x1514,%eax
     670:	89 45 fc             	mov    %eax,-0x4(%ebp)
     673:	eb 24                	jmp    699 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     675:	8b 45 fc             	mov    -0x4(%ebp),%eax
     678:	8b 00                	mov    (%eax),%eax
     67a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     67d:	77 12                	ja     691 <free+0x35>
     67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     685:	77 24                	ja     6ab <free+0x4f>
     687:	8b 45 fc             	mov    -0x4(%ebp),%eax
     68a:	8b 00                	mov    (%eax),%eax
     68c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     68f:	77 1a                	ja     6ab <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     691:	8b 45 fc             	mov    -0x4(%ebp),%eax
     694:	8b 00                	mov    (%eax),%eax
     696:	89 45 fc             	mov    %eax,-0x4(%ebp)
     699:	8b 45 f8             	mov    -0x8(%ebp),%eax
     69c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     69f:	76 d4                	jbe    675 <free+0x19>
     6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6a4:	8b 00                	mov    (%eax),%eax
     6a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6a9:	76 ca                	jbe    675 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6ae:	8b 40 04             	mov    0x4(%eax),%eax
     6b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6bb:	01 c2                	add    %eax,%edx
     6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6c0:	8b 00                	mov    (%eax),%eax
     6c2:	39 c2                	cmp    %eax,%edx
     6c4:	75 24                	jne    6ea <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6c9:	8b 50 04             	mov    0x4(%eax),%edx
     6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6cf:	8b 00                	mov    (%eax),%eax
     6d1:	8b 40 04             	mov    0x4(%eax),%eax
     6d4:	01 c2                	add    %eax,%edx
     6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6df:	8b 00                	mov    (%eax),%eax
     6e1:	8b 10                	mov    (%eax),%edx
     6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6e6:	89 10                	mov    %edx,(%eax)
     6e8:	eb 0a                	jmp    6f4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ed:	8b 10                	mov    (%eax),%edx
     6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6f2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6f7:	8b 40 04             	mov    0x4(%eax),%eax
     6fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     701:	8b 45 fc             	mov    -0x4(%ebp),%eax
     704:	01 d0                	add    %edx,%eax
     706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     709:	75 20                	jne    72b <free+0xcf>
    p->s.size += bp->s.size;
     70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70e:	8b 50 04             	mov    0x4(%eax),%edx
     711:	8b 45 f8             	mov    -0x8(%ebp),%eax
     714:	8b 40 04             	mov    0x4(%eax),%eax
     717:	01 c2                	add    %eax,%edx
     719:	8b 45 fc             	mov    -0x4(%ebp),%eax
     71c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     722:	8b 10                	mov    (%eax),%edx
     724:	8b 45 fc             	mov    -0x4(%ebp),%eax
     727:	89 10                	mov    %edx,(%eax)
     729:	eb 08                	jmp    733 <free+0xd7>
  } else
    p->s.ptr = bp;
     72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     72e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     731:	89 10                	mov    %edx,(%eax)
  freep = p;
     733:	8b 45 fc             	mov    -0x4(%ebp),%eax
     736:	a3 14 15 00 00       	mov    %eax,0x1514
}
     73b:	c9                   	leave  
     73c:	c3                   	ret    

0000073d <morecore>:

static Header*
morecore(uint nu)
{
     73d:	55                   	push   %ebp
     73e:	89 e5                	mov    %esp,%ebp
     740:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     743:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     74a:	77 07                	ja     753 <morecore+0x16>
    nu = 4096;
     74c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     753:	8b 45 08             	mov    0x8(%ebp),%eax
     756:	c1 e0 03             	shl    $0x3,%eax
     759:	89 04 24             	mov    %eax,(%esp)
     75c:	e8 08 fc ff ff       	call   369 <sbrk>
     761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     764:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     768:	75 07                	jne    771 <morecore+0x34>
    return 0;
     76a:	b8 00 00 00 00       	mov    $0x0,%eax
     76f:	eb 22                	jmp    793 <morecore+0x56>
  hp = (Header*)p;
     771:	8b 45 f4             	mov    -0xc(%ebp),%eax
     774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     777:	8b 45 f0             	mov    -0x10(%ebp),%eax
     77a:	8b 55 08             	mov    0x8(%ebp),%edx
     77d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     780:	8b 45 f0             	mov    -0x10(%ebp),%eax
     783:	83 c0 08             	add    $0x8,%eax
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 ce fe ff ff       	call   65c <free>
  return freep;
     78e:	a1 14 15 00 00       	mov    0x1514,%eax
}
     793:	c9                   	leave  
     794:	c3                   	ret    

00000795 <malloc>:

void*
malloc(uint nbytes)
{
     795:	55                   	push   %ebp
     796:	89 e5                	mov    %esp,%ebp
     798:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     79b:	8b 45 08             	mov    0x8(%ebp),%eax
     79e:	83 c0 07             	add    $0x7,%eax
     7a1:	c1 e8 03             	shr    $0x3,%eax
     7a4:	83 c0 01             	add    $0x1,%eax
     7a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     7aa:	a1 14 15 00 00       	mov    0x1514,%eax
     7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7b6:	75 23                	jne    7db <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7b8:	c7 45 f0 0c 15 00 00 	movl   $0x150c,-0x10(%ebp)
     7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7c2:	a3 14 15 00 00       	mov    %eax,0x1514
     7c7:	a1 14 15 00 00       	mov    0x1514,%eax
     7cc:	a3 0c 15 00 00       	mov    %eax,0x150c
    base.s.size = 0;
     7d1:	c7 05 10 15 00 00 00 	movl   $0x0,0x1510
     7d8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7de:	8b 00                	mov    (%eax),%eax
     7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7e6:	8b 40 04             	mov    0x4(%eax),%eax
     7e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7ec:	72 4d                	jb     83b <malloc+0xa6>
      if(p->s.size == nunits)
     7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f1:	8b 40 04             	mov    0x4(%eax),%eax
     7f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7f7:	75 0c                	jne    805 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fc:	8b 10                	mov    (%eax),%edx
     7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
     801:	89 10                	mov    %edx,(%eax)
     803:	eb 26                	jmp    82b <malloc+0x96>
      else {
        p->s.size -= nunits;
     805:	8b 45 f4             	mov    -0xc(%ebp),%eax
     808:	8b 40 04             	mov    0x4(%eax),%eax
     80b:	2b 45 ec             	sub    -0x14(%ebp),%eax
     80e:	89 c2                	mov    %eax,%edx
     810:	8b 45 f4             	mov    -0xc(%ebp),%eax
     813:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     816:	8b 45 f4             	mov    -0xc(%ebp),%eax
     819:	8b 40 04             	mov    0x4(%eax),%eax
     81c:	c1 e0 03             	shl    $0x3,%eax
     81f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     822:	8b 45 f4             	mov    -0xc(%ebp),%eax
     825:	8b 55 ec             	mov    -0x14(%ebp),%edx
     828:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     82e:	a3 14 15 00 00       	mov    %eax,0x1514
      return (void*)(p + 1);
     833:	8b 45 f4             	mov    -0xc(%ebp),%eax
     836:	83 c0 08             	add    $0x8,%eax
     839:	eb 38                	jmp    873 <malloc+0xde>
    }
    if(p == freep)
     83b:	a1 14 15 00 00       	mov    0x1514,%eax
     840:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     843:	75 1b                	jne    860 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     845:	8b 45 ec             	mov    -0x14(%ebp),%eax
     848:	89 04 24             	mov    %eax,(%esp)
     84b:	e8 ed fe ff ff       	call   73d <morecore>
     850:	89 45 f4             	mov    %eax,-0xc(%ebp)
     853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     857:	75 07                	jne    860 <malloc+0xcb>
        return 0;
     859:	b8 00 00 00 00       	mov    $0x0,%eax
     85e:	eb 13                	jmp    873 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     860:	8b 45 f4             	mov    -0xc(%ebp),%eax
     863:	89 45 f0             	mov    %eax,-0x10(%ebp)
     866:	8b 45 f4             	mov    -0xc(%ebp),%eax
     869:	8b 00                	mov    (%eax),%eax
     86b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     86e:	e9 70 ff ff ff       	jmp    7e3 <malloc+0x4e>
}
     873:	c9                   	leave  
     874:	c3                   	ret    

00000875 <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     875:	55                   	push   %ebp
     876:	89 e5                	mov    %esp,%ebp
     878:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     87b:	e8 21 fb ff ff       	call   3a1 <kthread_mutex_alloc>
     880:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     887:	79 0a                	jns    893 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     889:	b8 00 00 00 00       	mov    $0x0,%eax
     88e:	e9 8b 00 00 00       	jmp    91e <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     893:	e8 44 06 00 00       	call   edc <mesa_cond_alloc>
     898:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     89b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     89f:	75 12                	jne    8b3 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a4:	89 04 24             	mov    %eax,(%esp)
     8a7:	e8 fd fa ff ff       	call   3a9 <kthread_mutex_dealloc>
		return 0;
     8ac:	b8 00 00 00 00       	mov    $0x0,%eax
     8b1:	eb 6b                	jmp    91e <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     8b3:	e8 24 06 00 00       	call   edc <mesa_cond_alloc>
     8b8:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     8bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8bf:	75 1d                	jne    8de <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c4:	89 04 24             	mov    %eax,(%esp)
     8c7:	e8 dd fa ff ff       	call   3a9 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8cf:	89 04 24             	mov    %eax,(%esp)
     8d2:	e8 46 06 00 00       	call   f1d <mesa_cond_dealloc>
		return 0;
     8d7:	b8 00 00 00 00       	mov    $0x0,%eax
     8dc:	eb 40                	jmp    91e <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     8de:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     8e5:	e8 ab fe ff ff       	call   795 <malloc>
     8ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     8ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
     8f3:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     8f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
     8fc:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     8ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     902:	8b 55 f4             	mov    -0xc(%ebp),%edx
     905:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     907:	8b 45 e8             	mov    -0x18(%ebp),%eax
     90a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     911:	8b 45 e8             	mov    -0x18(%ebp),%eax
     914:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     91b:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     91e:	c9                   	leave  
     91f:	c3                   	ret    

00000920 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     926:	8b 45 08             	mov    0x8(%ebp),%eax
     929:	8b 00                	mov    (%eax),%eax
     92b:	89 04 24             	mov    %eax,(%esp)
     92e:	e8 76 fa ff ff       	call   3a9 <kthread_mutex_dealloc>
     933:	85 c0                	test   %eax,%eax
     935:	78 2e                	js     965 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     937:	8b 45 08             	mov    0x8(%ebp),%eax
     93a:	8b 40 04             	mov    0x4(%eax),%eax
     93d:	89 04 24             	mov    %eax,(%esp)
     940:	e8 97 05 00 00       	call   edc <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     945:	8b 45 08             	mov    0x8(%ebp),%eax
     948:	8b 40 08             	mov    0x8(%eax),%eax
     94b:	89 04 24             	mov    %eax,(%esp)
     94e:	e8 89 05 00 00       	call   edc <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     953:	8b 45 08             	mov    0x8(%ebp),%eax
     956:	89 04 24             	mov    %eax,(%esp)
     959:	e8 fe fc ff ff       	call   65c <free>
	return 0;
     95e:	b8 00 00 00 00       	mov    $0x0,%eax
     963:	eb 05                	jmp    96a <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     96a:	c9                   	leave  
     96b:	c3                   	ret    

0000096c <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     96c:	55                   	push   %ebp
     96d:	89 e5                	mov    %esp,%ebp
     96f:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     972:	8b 45 08             	mov    0x8(%ebp),%eax
     975:	8b 40 10             	mov    0x10(%eax),%eax
     978:	85 c0                	test   %eax,%eax
     97a:	75 0a                	jne    986 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     97c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     981:	e9 81 00 00 00       	jmp    a07 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     986:	8b 45 08             	mov    0x8(%ebp),%eax
     989:	8b 00                	mov    (%eax),%eax
     98b:	89 04 24             	mov    %eax,(%esp)
     98e:	e8 1e fa ff ff       	call   3b1 <kthread_mutex_lock>
     993:	83 f8 ff             	cmp    $0xffffffff,%eax
     996:	7d 07                	jge    99f <mesa_slots_monitor_addslots+0x33>
		return -1;
     998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     99d:	eb 68                	jmp    a07 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     99f:	eb 17                	jmp    9b8 <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     9a1:	8b 45 08             	mov    0x8(%ebp),%eax
     9a4:	8b 10                	mov    (%eax),%edx
     9a6:	8b 45 08             	mov    0x8(%ebp),%eax
     9a9:	8b 40 08             	mov    0x8(%eax),%eax
     9ac:	89 54 24 04          	mov    %edx,0x4(%esp)
     9b0:	89 04 24             	mov    %eax,(%esp)
     9b3:	e8 af 05 00 00       	call   f67 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     9b8:	8b 45 08             	mov    0x8(%ebp),%eax
     9bb:	8b 40 10             	mov    0x10(%eax),%eax
     9be:	85 c0                	test   %eax,%eax
     9c0:	74 0a                	je     9cc <mesa_slots_monitor_addslots+0x60>
     9c2:	8b 45 08             	mov    0x8(%ebp),%eax
     9c5:	8b 40 0c             	mov    0xc(%eax),%eax
     9c8:	85 c0                	test   %eax,%eax
     9ca:	7f d5                	jg     9a1 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     9cc:	8b 45 08             	mov    0x8(%ebp),%eax
     9cf:	8b 40 10             	mov    0x10(%eax),%eax
     9d2:	85 c0                	test   %eax,%eax
     9d4:	74 11                	je     9e7 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     9d6:	8b 45 08             	mov    0x8(%ebp),%eax
     9d9:	8b 50 0c             	mov    0xc(%eax),%edx
     9dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     9df:	01 c2                	add    %eax,%edx
     9e1:	8b 45 08             	mov    0x8(%ebp),%eax
     9e4:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     9e7:	8b 45 08             	mov    0x8(%ebp),%eax
     9ea:	8b 40 04             	mov    0x4(%eax),%eax
     9ed:	89 04 24             	mov    %eax,(%esp)
     9f0:	e8 dc 05 00 00       	call   fd1 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     9f5:	8b 45 08             	mov    0x8(%ebp),%eax
     9f8:	8b 00                	mov    (%eax),%eax
     9fa:	89 04 24             	mov    %eax,(%esp)
     9fd:	e8 b7 f9 ff ff       	call   3b9 <kthread_mutex_unlock>

	return 1;
     a02:	b8 01 00 00 00       	mov    $0x1,%eax


}
     a07:	c9                   	leave  
     a08:	c3                   	ret    

00000a09 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     a09:	55                   	push   %ebp
     a0a:	89 e5                	mov    %esp,%ebp
     a0c:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     a0f:	8b 45 08             	mov    0x8(%ebp),%eax
     a12:	8b 40 10             	mov    0x10(%eax),%eax
     a15:	85 c0                	test   %eax,%eax
     a17:	75 07                	jne    a20 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a1e:	eb 7f                	jmp    a9f <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     a20:	8b 45 08             	mov    0x8(%ebp),%eax
     a23:	8b 00                	mov    (%eax),%eax
     a25:	89 04 24             	mov    %eax,(%esp)
     a28:	e8 84 f9 ff ff       	call   3b1 <kthread_mutex_lock>
     a2d:	83 f8 ff             	cmp    $0xffffffff,%eax
     a30:	7d 07                	jge    a39 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     a32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a37:	eb 66                	jmp    a9f <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     a39:	eb 17                	jmp    a52 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     a3b:	8b 45 08             	mov    0x8(%ebp),%eax
     a3e:	8b 10                	mov    (%eax),%edx
     a40:	8b 45 08             	mov    0x8(%ebp),%eax
     a43:	8b 40 04             	mov    0x4(%eax),%eax
     a46:	89 54 24 04          	mov    %edx,0x4(%esp)
     a4a:	89 04 24             	mov    %eax,(%esp)
     a4d:	e8 15 05 00 00       	call   f67 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     a52:	8b 45 08             	mov    0x8(%ebp),%eax
     a55:	8b 40 10             	mov    0x10(%eax),%eax
     a58:	85 c0                	test   %eax,%eax
     a5a:	74 0a                	je     a66 <mesa_slots_monitor_takeslot+0x5d>
     a5c:	8b 45 08             	mov    0x8(%ebp),%eax
     a5f:	8b 40 0c             	mov    0xc(%eax),%eax
     a62:	85 c0                	test   %eax,%eax
     a64:	74 d5                	je     a3b <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     a66:	8b 45 08             	mov    0x8(%ebp),%eax
     a69:	8b 40 10             	mov    0x10(%eax),%eax
     a6c:	85 c0                	test   %eax,%eax
     a6e:	74 0f                	je     a7f <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     a70:	8b 45 08             	mov    0x8(%ebp),%eax
     a73:	8b 40 0c             	mov    0xc(%eax),%eax
     a76:	8d 50 ff             	lea    -0x1(%eax),%edx
     a79:	8b 45 08             	mov    0x8(%ebp),%eax
     a7c:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     a7f:	8b 45 08             	mov    0x8(%ebp),%eax
     a82:	8b 40 08             	mov    0x8(%eax),%eax
     a85:	89 04 24             	mov    %eax,(%esp)
     a88:	e8 44 05 00 00       	call   fd1 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     a8d:	8b 45 08             	mov    0x8(%ebp),%eax
     a90:	8b 00                	mov    (%eax),%eax
     a92:	89 04 24             	mov    %eax,(%esp)
     a95:	e8 1f f9 ff ff       	call   3b9 <kthread_mutex_unlock>

	return 1;
     a9a:	b8 01 00 00 00       	mov    $0x1,%eax

}
     a9f:	c9                   	leave  
     aa0:	c3                   	ret    

00000aa1 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     aa1:	55                   	push   %ebp
     aa2:	89 e5                	mov    %esp,%ebp
     aa4:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     aa7:	8b 45 08             	mov    0x8(%ebp),%eax
     aaa:	8b 40 10             	mov    0x10(%eax),%eax
     aad:	85 c0                	test   %eax,%eax
     aaf:	75 07                	jne    ab8 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ab6:	eb 35                	jmp    aed <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	8b 00                	mov    (%eax),%eax
     abd:	89 04 24             	mov    %eax,(%esp)
     ac0:	e8 ec f8 ff ff       	call   3b1 <kthread_mutex_lock>
     ac5:	83 f8 ff             	cmp    $0xffffffff,%eax
     ac8:	7d 07                	jge    ad1 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     aca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     acf:	eb 1c                	jmp    aed <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     ad1:	8b 45 08             	mov    0x8(%ebp),%eax
     ad4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     adb:	8b 45 08             	mov    0x8(%ebp),%eax
     ade:	8b 00                	mov    (%eax),%eax
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 d1 f8 ff ff       	call   3b9 <kthread_mutex_unlock>

		return 0;
     ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
     aed:	c9                   	leave  
     aee:	c3                   	ret    

00000aef <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     aef:	55                   	push   %ebp
     af0:	89 e5                	mov    %esp,%ebp
     af2:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     af5:	e8 a7 f8 ff ff       	call   3a1 <kthread_mutex_alloc>
     afa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b01:	79 0a                	jns    b0d <hoare_slots_monitor_alloc+0x1e>
		return 0;
     b03:	b8 00 00 00 00       	mov    $0x0,%eax
     b08:	e9 8b 00 00 00       	jmp    b98 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     b0d:	e8 68 02 00 00       	call   d7a <hoare_cond_alloc>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b19:	75 12                	jne    b2d <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1e:	89 04 24             	mov    %eax,(%esp)
     b21:	e8 83 f8 ff ff       	call   3a9 <kthread_mutex_dealloc>
		return 0;
     b26:	b8 00 00 00 00       	mov    $0x0,%eax
     b2b:	eb 6b                	jmp    b98 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     b2d:	e8 48 02 00 00       	call   d7a <hoare_cond_alloc>
     b32:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b39:	75 1d                	jne    b58 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b3e:	89 04 24             	mov    %eax,(%esp)
     b41:	e8 63 f8 ff ff       	call   3a9 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b49:	89 04 24             	mov    %eax,(%esp)
     b4c:	e8 6a 02 00 00       	call   dbb <hoare_cond_dealloc>
		return 0;
     b51:	b8 00 00 00 00       	mov    $0x0,%eax
     b56:	eb 40                	jmp    b98 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     b58:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b5f:	e8 31 fc ff ff       	call   795 <malloc>
     b64:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b6d:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b73:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b76:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b7f:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b8e:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b95:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b98:	c9                   	leave  
     b99:	c3                   	ret    

00000b9a <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     b9a:	55                   	push   %ebp
     b9b:	89 e5                	mov    %esp,%ebp
     b9d:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     ba0:	8b 45 08             	mov    0x8(%ebp),%eax
     ba3:	8b 00                	mov    (%eax),%eax
     ba5:	89 04 24             	mov    %eax,(%esp)
     ba8:	e8 fc f7 ff ff       	call   3a9 <kthread_mutex_dealloc>
     bad:	85 c0                	test   %eax,%eax
     baf:	78 2e                	js     bdf <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     bb1:	8b 45 08             	mov    0x8(%ebp),%eax
     bb4:	8b 40 04             	mov    0x4(%eax),%eax
     bb7:	89 04 24             	mov    %eax,(%esp)
     bba:	e8 bb 01 00 00       	call   d7a <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     bbf:	8b 45 08             	mov    0x8(%ebp),%eax
     bc2:	8b 40 08             	mov    0x8(%eax),%eax
     bc5:	89 04 24             	mov    %eax,(%esp)
     bc8:	e8 ad 01 00 00       	call   d7a <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     bcd:	8b 45 08             	mov    0x8(%ebp),%eax
     bd0:	89 04 24             	mov    %eax,(%esp)
     bd3:	e8 84 fa ff ff       	call   65c <free>
	return 0;
     bd8:	b8 00 00 00 00       	mov    $0x0,%eax
     bdd:	eb 05                	jmp    be4 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     be4:	c9                   	leave  
     be5:	c3                   	ret    

00000be6 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     be6:	55                   	push   %ebp
     be7:	89 e5                	mov    %esp,%ebp
     be9:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     bec:	8b 45 08             	mov    0x8(%ebp),%eax
     bef:	8b 40 10             	mov    0x10(%eax),%eax
     bf2:	85 c0                	test   %eax,%eax
     bf4:	75 0a                	jne    c00 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     bfb:	e9 88 00 00 00       	jmp    c88 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c00:	8b 45 08             	mov    0x8(%ebp),%eax
     c03:	8b 00                	mov    (%eax),%eax
     c05:	89 04 24             	mov    %eax,(%esp)
     c08:	e8 a4 f7 ff ff       	call   3b1 <kthread_mutex_lock>
     c0d:	83 f8 ff             	cmp    $0xffffffff,%eax
     c10:	7d 07                	jge    c19 <hoare_slots_monitor_addslots+0x33>
		return -1;
     c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c17:	eb 6f                	jmp    c88 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     c19:	8b 45 08             	mov    0x8(%ebp),%eax
     c1c:	8b 40 10             	mov    0x10(%eax),%eax
     c1f:	85 c0                	test   %eax,%eax
     c21:	74 21                	je     c44 <hoare_slots_monitor_addslots+0x5e>
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	8b 40 0c             	mov    0xc(%eax),%eax
     c29:	85 c0                	test   %eax,%eax
     c2b:	7e 17                	jle    c44 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     c2d:	8b 45 08             	mov    0x8(%ebp),%eax
     c30:	8b 10                	mov    (%eax),%edx
     c32:	8b 45 08             	mov    0x8(%ebp),%eax
     c35:	8b 40 08             	mov    0x8(%eax),%eax
     c38:	89 54 24 04          	mov    %edx,0x4(%esp)
     c3c:	89 04 24             	mov    %eax,(%esp)
     c3f:	e8 c1 01 00 00       	call   e05 <hoare_cond_wait>


	if  ( monitor->active)
     c44:	8b 45 08             	mov    0x8(%ebp),%eax
     c47:	8b 40 10             	mov    0x10(%eax),%eax
     c4a:	85 c0                	test   %eax,%eax
     c4c:	74 11                	je     c5f <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     c4e:	8b 45 08             	mov    0x8(%ebp),%eax
     c51:	8b 50 0c             	mov    0xc(%eax),%edx
     c54:	8b 45 0c             	mov    0xc(%ebp),%eax
     c57:	01 c2                	add    %eax,%edx
     c59:	8b 45 08             	mov    0x8(%ebp),%eax
     c5c:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     c5f:	8b 45 08             	mov    0x8(%ebp),%eax
     c62:	8b 10                	mov    (%eax),%edx
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	8b 40 04             	mov    0x4(%eax),%eax
     c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
     c6e:	89 04 24             	mov    %eax,(%esp)
     c71:	e8 e6 01 00 00       	call   e5c <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c76:	8b 45 08             	mov    0x8(%ebp),%eax
     c79:	8b 00                	mov    (%eax),%eax
     c7b:	89 04 24             	mov    %eax,(%esp)
     c7e:	e8 36 f7 ff ff       	call   3b9 <kthread_mutex_unlock>

	return 1;
     c83:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c88:	c9                   	leave  
     c89:	c3                   	ret    

00000c8a <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     c8a:	55                   	push   %ebp
     c8b:	89 e5                	mov    %esp,%ebp
     c8d:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c90:	8b 45 08             	mov    0x8(%ebp),%eax
     c93:	8b 40 10             	mov    0x10(%eax),%eax
     c96:	85 c0                	test   %eax,%eax
     c98:	75 0a                	jne    ca4 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     c9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c9f:	e9 86 00 00 00       	jmp    d2a <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ca4:	8b 45 08             	mov    0x8(%ebp),%eax
     ca7:	8b 00                	mov    (%eax),%eax
     ca9:	89 04 24             	mov    %eax,(%esp)
     cac:	e8 00 f7 ff ff       	call   3b1 <kthread_mutex_lock>
     cb1:	83 f8 ff             	cmp    $0xffffffff,%eax
     cb4:	7d 07                	jge    cbd <hoare_slots_monitor_takeslot+0x33>
		return -1;
     cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cbb:	eb 6d                	jmp    d2a <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     cbd:	8b 45 08             	mov    0x8(%ebp),%eax
     cc0:	8b 40 10             	mov    0x10(%eax),%eax
     cc3:	85 c0                	test   %eax,%eax
     cc5:	74 21                	je     ce8 <hoare_slots_monitor_takeslot+0x5e>
     cc7:	8b 45 08             	mov    0x8(%ebp),%eax
     cca:	8b 40 0c             	mov    0xc(%eax),%eax
     ccd:	85 c0                	test   %eax,%eax
     ccf:	75 17                	jne    ce8 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     cd1:	8b 45 08             	mov    0x8(%ebp),%eax
     cd4:	8b 10                	mov    (%eax),%edx
     cd6:	8b 45 08             	mov    0x8(%ebp),%eax
     cd9:	8b 40 04             	mov    0x4(%eax),%eax
     cdc:	89 54 24 04          	mov    %edx,0x4(%esp)
     ce0:	89 04 24             	mov    %eax,(%esp)
     ce3:	e8 1d 01 00 00       	call   e05 <hoare_cond_wait>


	if  ( monitor->active)
     ce8:	8b 45 08             	mov    0x8(%ebp),%eax
     ceb:	8b 40 10             	mov    0x10(%eax),%eax
     cee:	85 c0                	test   %eax,%eax
     cf0:	74 0f                	je     d01 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     cf2:	8b 45 08             	mov    0x8(%ebp),%eax
     cf5:	8b 40 0c             	mov    0xc(%eax),%eax
     cf8:	8d 50 ff             	lea    -0x1(%eax),%edx
     cfb:	8b 45 08             	mov    0x8(%ebp),%eax
     cfe:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     d01:	8b 45 08             	mov    0x8(%ebp),%eax
     d04:	8b 10                	mov    (%eax),%edx
     d06:	8b 45 08             	mov    0x8(%ebp),%eax
     d09:	8b 40 08             	mov    0x8(%eax),%eax
     d0c:	89 54 24 04          	mov    %edx,0x4(%esp)
     d10:	89 04 24             	mov    %eax,(%esp)
     d13:	e8 44 01 00 00       	call   e5c <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d18:	8b 45 08             	mov    0x8(%ebp),%eax
     d1b:	8b 00                	mov    (%eax),%eax
     d1d:	89 04 24             	mov    %eax,(%esp)
     d20:	e8 94 f6 ff ff       	call   3b9 <kthread_mutex_unlock>

	return 1;
     d25:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d2a:	c9                   	leave  
     d2b:	c3                   	ret    

00000d2c <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     d2c:	55                   	push   %ebp
     d2d:	89 e5                	mov    %esp,%ebp
     d2f:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d32:	8b 45 08             	mov    0x8(%ebp),%eax
     d35:	8b 40 10             	mov    0x10(%eax),%eax
     d38:	85 c0                	test   %eax,%eax
     d3a:	75 07                	jne    d43 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d41:	eb 35                	jmp    d78 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
     d46:	8b 00                	mov    (%eax),%eax
     d48:	89 04 24             	mov    %eax,(%esp)
     d4b:	e8 61 f6 ff ff       	call   3b1 <kthread_mutex_lock>
     d50:	83 f8 ff             	cmp    $0xffffffff,%eax
     d53:	7d 07                	jge    d5c <hoare_slots_monitor_stopadding+0x30>
			return -1;
     d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d5a:	eb 1c                	jmp    d78 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d5c:	8b 45 08             	mov    0x8(%ebp),%eax
     d5f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d66:	8b 45 08             	mov    0x8(%ebp),%eax
     d69:	8b 00                	mov    (%eax),%eax
     d6b:	89 04 24             	mov    %eax,(%esp)
     d6e:	e8 46 f6 ff ff       	call   3b9 <kthread_mutex_unlock>

		return 0;
     d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d78:	c9                   	leave  
     d79:	c3                   	ret    

00000d7a <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     d7a:	55                   	push   %ebp
     d7b:	89 e5                	mov    %esp,%ebp
     d7d:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     d80:	e8 1c f6 ff ff       	call   3a1 <kthread_mutex_alloc>
     d85:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d8c:	79 07                	jns    d95 <hoare_cond_alloc+0x1b>
		return 0;
     d8e:	b8 00 00 00 00       	mov    $0x0,%eax
     d93:	eb 24                	jmp    db9 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     d95:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d9c:	e8 f4 f9 ff ff       	call   795 <malloc>
     da1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     daa:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     db9:	c9                   	leave  
     dba:	c3                   	ret    

00000dbb <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     dbb:	55                   	push   %ebp
     dbc:	89 e5                	mov    %esp,%ebp
     dbe:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     dc5:	75 07                	jne    dce <hoare_cond_dealloc+0x13>
			return -1;
     dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dcc:	eb 35                	jmp    e03 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	8b 00                	mov    (%eax),%eax
     dd3:	89 04 24             	mov    %eax,(%esp)
     dd6:	e8 de f5 ff ff       	call   3b9 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     ddb:	8b 45 08             	mov    0x8(%ebp),%eax
     dde:	8b 00                	mov    (%eax),%eax
     de0:	89 04 24             	mov    %eax,(%esp)
     de3:	e8 c1 f5 ff ff       	call   3a9 <kthread_mutex_dealloc>
     de8:	85 c0                	test   %eax,%eax
     dea:	79 07                	jns    df3 <hoare_cond_dealloc+0x38>
			return -1;
     dec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     df1:	eb 10                	jmp    e03 <hoare_cond_dealloc+0x48>

		free (hCond);
     df3:	8b 45 08             	mov    0x8(%ebp),%eax
     df6:	89 04 24             	mov    %eax,(%esp)
     df9:	e8 5e f8 ff ff       	call   65c <free>
		return 0;
     dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e03:	c9                   	leave  
     e04:	c3                   	ret    

00000e05 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     e05:	55                   	push   %ebp
     e06:	89 e5                	mov    %esp,%ebp
     e08:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e0f:	75 07                	jne    e18 <hoare_cond_wait+0x13>
			return -1;
     e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e16:	eb 42                	jmp    e5a <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     e18:	8b 45 08             	mov    0x8(%ebp),%eax
     e1b:	8b 40 04             	mov    0x4(%eax),%eax
     e1e:	8d 50 01             	lea    0x1(%eax),%edx
     e21:	8b 45 08             	mov    0x8(%ebp),%eax
     e24:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     e27:	8b 45 08             	mov    0x8(%ebp),%eax
     e2a:	8b 00                	mov    (%eax),%eax
     e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     e30:	8b 45 0c             	mov    0xc(%ebp),%eax
     e33:	89 04 24             	mov    %eax,(%esp)
     e36:	e8 86 f5 ff ff       	call   3c1 <kthread_mutex_yieldlock>
     e3b:	85 c0                	test   %eax,%eax
     e3d:	79 16                	jns    e55 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     e3f:	8b 45 08             	mov    0x8(%ebp),%eax
     e42:	8b 40 04             	mov    0x4(%eax),%eax
     e45:	8d 50 ff             	lea    -0x1(%eax),%edx
     e48:	8b 45 08             	mov    0x8(%ebp),%eax
     e4b:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e53:	eb 05                	jmp    e5a <hoare_cond_wait+0x55>
		}

	return 0;
     e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e5a:	c9                   	leave  
     e5b:	c3                   	ret    

00000e5c <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     e5c:	55                   	push   %ebp
     e5d:	89 e5                	mov    %esp,%ebp
     e5f:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e66:	75 07                	jne    e6f <hoare_cond_signal+0x13>
		return -1;
     e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e6d:	eb 6b                	jmp    eda <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     e6f:	8b 45 08             	mov    0x8(%ebp),%eax
     e72:	8b 40 04             	mov    0x4(%eax),%eax
     e75:	85 c0                	test   %eax,%eax
     e77:	7e 3d                	jle    eb6 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     e79:	8b 45 08             	mov    0x8(%ebp),%eax
     e7c:	8b 40 04             	mov    0x4(%eax),%eax
     e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
     e82:	8b 45 08             	mov    0x8(%ebp),%eax
     e85:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     e88:	8b 45 08             	mov    0x8(%ebp),%eax
     e8b:	8b 00                	mov    (%eax),%eax
     e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e91:	8b 45 0c             	mov    0xc(%ebp),%eax
     e94:	89 04 24             	mov    %eax,(%esp)
     e97:	e8 25 f5 ff ff       	call   3c1 <kthread_mutex_yieldlock>
     e9c:	85 c0                	test   %eax,%eax
     e9e:	79 16                	jns    eb6 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     ea0:	8b 45 08             	mov    0x8(%ebp),%eax
     ea3:	8b 40 04             	mov    0x4(%eax),%eax
     ea6:	8d 50 01             	lea    0x1(%eax),%edx
     ea9:	8b 45 08             	mov    0x8(%ebp),%eax
     eac:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eb4:	eb 24                	jmp    eda <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     eb6:	8b 45 08             	mov    0x8(%ebp),%eax
     eb9:	8b 00                	mov    (%eax),%eax
     ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
     ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec2:	89 04 24             	mov    %eax,(%esp)
     ec5:	e8 f7 f4 ff ff       	call   3c1 <kthread_mutex_yieldlock>
     eca:	85 c0                	test   %eax,%eax
     ecc:	79 07                	jns    ed5 <hoare_cond_signal+0x79>

    			return -1;
     ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ed3:	eb 05                	jmp    eda <hoare_cond_signal+0x7e>
    }

	return 0;
     ed5:	b8 00 00 00 00       	mov    $0x0,%eax

}
     eda:	c9                   	leave  
     edb:	c3                   	ret    

00000edc <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     edc:	55                   	push   %ebp
     edd:	89 e5                	mov    %esp,%ebp
     edf:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ee2:	e8 ba f4 ff ff       	call   3a1 <kthread_mutex_alloc>
     ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     eee:	79 07                	jns    ef7 <mesa_cond_alloc+0x1b>
		return 0;
     ef0:	b8 00 00 00 00       	mov    $0x0,%eax
     ef5:	eb 24                	jmp    f1b <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
     ef7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     efe:	e8 92 f8 ff ff       	call   795 <malloc>
     f03:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
     f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f0c:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
     f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
     f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f1b:	c9                   	leave  
     f1c:	c3                   	ret    

00000f1d <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
     f1d:	55                   	push   %ebp
     f1e:	89 e5                	mov    %esp,%ebp
     f20:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
     f23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f27:	75 07                	jne    f30 <mesa_cond_dealloc+0x13>
		return -1;
     f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f2e:	eb 35                	jmp    f65 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
     f30:	8b 45 08             	mov    0x8(%ebp),%eax
     f33:	8b 00                	mov    (%eax),%eax
     f35:	89 04 24             	mov    %eax,(%esp)
     f38:	e8 7c f4 ff ff       	call   3b9 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
     f3d:	8b 45 08             	mov    0x8(%ebp),%eax
     f40:	8b 00                	mov    (%eax),%eax
     f42:	89 04 24             	mov    %eax,(%esp)
     f45:	e8 5f f4 ff ff       	call   3a9 <kthread_mutex_dealloc>
     f4a:	85 c0                	test   %eax,%eax
     f4c:	79 07                	jns    f55 <mesa_cond_dealloc+0x38>
		return -1;
     f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f53:	eb 10                	jmp    f65 <mesa_cond_dealloc+0x48>

	free (mCond);
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
     f58:	89 04 24             	mov    %eax,(%esp)
     f5b:	e8 fc f6 ff ff       	call   65c <free>
	return 0;
     f60:	b8 00 00 00 00       	mov    $0x0,%eax

}
     f65:	c9                   	leave  
     f66:	c3                   	ret    

00000f67 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
     f67:	55                   	push   %ebp
     f68:	89 e5                	mov    %esp,%ebp
     f6a:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     f6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f71:	75 07                	jne    f7a <mesa_cond_wait+0x13>
		return -1;
     f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f78:	eb 55                	jmp    fcf <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
     f7a:	8b 45 08             	mov    0x8(%ebp),%eax
     f7d:	8b 40 04             	mov    0x4(%eax),%eax
     f80:	8d 50 01             	lea    0x1(%eax),%edx
     f83:	8b 45 08             	mov    0x8(%ebp),%eax
     f86:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f89:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8c:	89 04 24             	mov    %eax,(%esp)
     f8f:	e8 25 f4 ff ff       	call   3b9 <kthread_mutex_unlock>
     f94:	85 c0                	test   %eax,%eax
     f96:	79 27                	jns    fbf <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
     f98:	8b 45 08             	mov    0x8(%ebp),%eax
     f9b:	8b 00                	mov    (%eax),%eax
     f9d:	89 04 24             	mov    %eax,(%esp)
     fa0:	e8 0c f4 ff ff       	call   3b1 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
     fa5:	85 c0                	test   %eax,%eax
     fa7:	79 16                	jns    fbf <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
     fa9:	8b 45 08             	mov    0x8(%ebp),%eax
     fac:	8b 40 04             	mov    0x4(%eax),%eax
     faf:	8d 50 ff             	lea    -0x1(%eax),%edx
     fb2:	8b 45 08             	mov    0x8(%ebp),%eax
     fb5:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
     fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fbd:	eb 10                	jmp    fcf <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
     fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc2:	89 04 24             	mov    %eax,(%esp)
     fc5:	e8 e7 f3 ff ff       	call   3b1 <kthread_mutex_lock>
	return 0;
     fca:	b8 00 00 00 00       	mov    $0x0,%eax


}
     fcf:	c9                   	leave  
     fd0:	c3                   	ret    

00000fd1 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
     fd1:	55                   	push   %ebp
     fd2:	89 e5                	mov    %esp,%ebp
     fd4:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fdb:	75 07                	jne    fe4 <mesa_cond_signal+0x13>
		return -1;
     fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fe2:	eb 5d                	jmp    1041 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
     fe4:	8b 45 08             	mov    0x8(%ebp),%eax
     fe7:	8b 40 04             	mov    0x4(%eax),%eax
     fea:	85 c0                	test   %eax,%eax
     fec:	7e 36                	jle    1024 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
     fee:	8b 45 08             	mov    0x8(%ebp),%eax
     ff1:	8b 40 04             	mov    0x4(%eax),%eax
     ff4:	8d 50 ff             	lea    -0x1(%eax),%edx
     ff7:	8b 45 08             	mov    0x8(%ebp),%eax
     ffa:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
     ffd:	8b 45 08             	mov    0x8(%ebp),%eax
    1000:	8b 00                	mov    (%eax),%eax
    1002:	89 04 24             	mov    %eax,(%esp)
    1005:	e8 af f3 ff ff       	call   3b9 <kthread_mutex_unlock>
    100a:	85 c0                	test   %eax,%eax
    100c:	78 16                	js     1024 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    100e:	8b 45 08             	mov    0x8(%ebp),%eax
    1011:	8b 40 04             	mov    0x4(%eax),%eax
    1014:	8d 50 01             	lea    0x1(%eax),%edx
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    101d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1022:	eb 1d                	jmp    1041 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1024:	8b 45 08             	mov    0x8(%ebp),%eax
    1027:	8b 00                	mov    (%eax),%eax
    1029:	89 04 24             	mov    %eax,(%esp)
    102c:	e8 88 f3 ff ff       	call   3b9 <kthread_mutex_unlock>
    1031:	85 c0                	test   %eax,%eax
    1033:	79 07                	jns    103c <mesa_cond_signal+0x6b>

		return -1;
    1035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    103a:	eb 05                	jmp    1041 <mesa_cond_signal+0x70>
	}
	return 0;
    103c:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1041:	c9                   	leave  
    1042:	c3                   	ret    
