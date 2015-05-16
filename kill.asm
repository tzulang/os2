
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
       9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
       f:	c7 44 24 04 31 10 00 	movl   $0x1031,0x4(%esp)
      16:	00 
      17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      1e:	e8 74 04 00 00       	call   497 <printf>
    exit();
      23:	e8 a7 02 00 00       	call   2cf <exit>
  }
  for(i=1; i<argc; i++)
      28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
      2f:	00 
      30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
      32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
      3d:	8b 45 0c             	mov    0xc(%ebp),%eax
      40:	01 d0                	add    %edx,%eax
      42:	8b 00                	mov    (%eax),%eax
      44:	89 04 24             	mov    %eax,(%esp)
      47:	e8 f1 01 00 00       	call   23d <atoi>
      4c:	89 04 24             	mov    %eax,(%esp)
      4f:	e8 ab 02 00 00       	call   2ff <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
      54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
      59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      5d:	3b 45 08             	cmp    0x8(%ebp),%eax
      60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
      62:	e8 68 02 00 00       	call   2cf <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
      67:	55                   	push   %ebp
      68:	89 e5                	mov    %esp,%ebp
      6a:	57                   	push   %edi
      6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
      6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
      6f:	8b 55 10             	mov    0x10(%ebp),%edx
      72:	8b 45 0c             	mov    0xc(%ebp),%eax
      75:	89 cb                	mov    %ecx,%ebx
      77:	89 df                	mov    %ebx,%edi
      79:	89 d1                	mov    %edx,%ecx
      7b:	fc                   	cld    
      7c:	f3 aa                	rep stos %al,%es:(%edi)
      7e:	89 ca                	mov    %ecx,%edx
      80:	89 fb                	mov    %edi,%ebx
      82:	89 5d 08             	mov    %ebx,0x8(%ebp)
      85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
      88:	5b                   	pop    %ebx
      89:	5f                   	pop    %edi
      8a:	5d                   	pop    %ebp
      8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
      8c:	55                   	push   %ebp
      8d:	89 e5                	mov    %esp,%ebp
      8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
      92:	8b 45 08             	mov    0x8(%ebp),%eax
      95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
      98:	90                   	nop
      99:	8b 45 08             	mov    0x8(%ebp),%eax
      9c:	8d 50 01             	lea    0x1(%eax),%edx
      9f:	89 55 08             	mov    %edx,0x8(%ebp)
      a2:	8b 55 0c             	mov    0xc(%ebp),%edx
      a5:	8d 4a 01             	lea    0x1(%edx),%ecx
      a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
      ab:	0f b6 12             	movzbl (%edx),%edx
      ae:	88 10                	mov    %dl,(%eax)
      b0:	0f b6 00             	movzbl (%eax),%eax
      b3:	84 c0                	test   %al,%al
      b5:	75 e2                	jne    99 <strcpy+0xd>
    ;
  return os;
      b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
      ba:	c9                   	leave  
      bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
      bc:	55                   	push   %ebp
      bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
      bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
      c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
      c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
      c9:	8b 45 08             	mov    0x8(%ebp),%eax
      cc:	0f b6 00             	movzbl (%eax),%eax
      cf:	84 c0                	test   %al,%al
      d1:	74 10                	je     e3 <strcmp+0x27>
      d3:	8b 45 08             	mov    0x8(%ebp),%eax
      d6:	0f b6 10             	movzbl (%eax),%edx
      d9:	8b 45 0c             	mov    0xc(%ebp),%eax
      dc:	0f b6 00             	movzbl (%eax),%eax
      df:	38 c2                	cmp    %al,%dl
      e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
      e3:	8b 45 08             	mov    0x8(%ebp),%eax
      e6:	0f b6 00             	movzbl (%eax),%eax
      e9:	0f b6 d0             	movzbl %al,%edx
      ec:	8b 45 0c             	mov    0xc(%ebp),%eax
      ef:	0f b6 00             	movzbl (%eax),%eax
      f2:	0f b6 c0             	movzbl %al,%eax
      f5:	29 c2                	sub    %eax,%edx
      f7:	89 d0                	mov    %edx,%eax
}
      f9:	5d                   	pop    %ebp
      fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
      fb:	55                   	push   %ebp
      fc:	89 e5                	mov    %esp,%ebp
      fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     108:	eb 04                	jmp    10e <strlen+0x13>
     10a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     111:	8b 45 08             	mov    0x8(%ebp),%eax
     114:	01 d0                	add    %edx,%eax
     116:	0f b6 00             	movzbl (%eax),%eax
     119:	84 c0                	test   %al,%al
     11b:	75 ed                	jne    10a <strlen+0xf>
    ;
  return n;
     11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     120:	c9                   	leave  
     121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
     122:	55                   	push   %ebp
     123:	89 e5                	mov    %esp,%ebp
     125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     128:	8b 45 10             	mov    0x10(%ebp),%eax
     12b:	89 44 24 08          	mov    %eax,0x8(%esp)
     12f:	8b 45 0c             	mov    0xc(%ebp),%eax
     132:	89 44 24 04          	mov    %eax,0x4(%esp)
     136:	8b 45 08             	mov    0x8(%ebp),%eax
     139:	89 04 24             	mov    %eax,(%esp)
     13c:	e8 26 ff ff ff       	call   67 <stosb>
  return dst;
     141:	8b 45 08             	mov    0x8(%ebp),%eax
}
     144:	c9                   	leave  
     145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
     146:	55                   	push   %ebp
     147:	89 e5                	mov    %esp,%ebp
     149:	83 ec 04             	sub    $0x4,%esp
     14c:	8b 45 0c             	mov    0xc(%ebp),%eax
     14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
     154:	8b 45 08             	mov    0x8(%ebp),%eax
     157:	0f b6 00             	movzbl (%eax),%eax
     15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
     15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
     15f:	8b 45 08             	mov    0x8(%ebp),%eax
     162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     168:	8b 45 08             	mov    0x8(%ebp),%eax
     16b:	0f b6 00             	movzbl (%eax),%eax
     16e:	84 c0                	test   %al,%al
     170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     172:	b8 00 00 00 00       	mov    $0x0,%eax
}
     177:	c9                   	leave  
     178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
     179:	55                   	push   %ebp
     17a:	89 e5                	mov    %esp,%ebp
     17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     186:	eb 4c                	jmp    1d4 <gets+0x5b>
    cc = read(0, &c, 1);
     188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     18f:	00 
     190:	8d 45 ef             	lea    -0x11(%ebp),%eax
     193:	89 44 24 04          	mov    %eax,0x4(%esp)
     197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     19e:	e8 44 01 00 00       	call   2e7 <read>
     1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1aa:	7f 02                	jg     1ae <gets+0x35>
      break;
     1ac:	eb 31                	jmp    1df <gets+0x66>
    buf[i++] = c;
     1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1b1:	8d 50 01             	lea    0x1(%eax),%edx
     1b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
     1b7:	89 c2                	mov    %eax,%edx
     1b9:	8b 45 08             	mov    0x8(%ebp),%eax
     1bc:	01 c2                	add    %eax,%edx
     1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1c8:	3c 0a                	cmp    $0xa,%al
     1ca:	74 13                	je     1df <gets+0x66>
     1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1d0:	3c 0d                	cmp    $0xd,%al
     1d2:	74 0b                	je     1df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1d7:	83 c0 01             	add    $0x1,%eax
     1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
     1dd:	7c a9                	jl     188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     1df:	8b 55 f4             	mov    -0xc(%ebp),%edx
     1e2:	8b 45 08             	mov    0x8(%ebp),%eax
     1e5:	01 d0                	add    %edx,%eax
     1e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1ed:	c9                   	leave  
     1ee:	c3                   	ret    

000001ef <stat>:

int
stat(char *n, struct stat *st)
{
     1ef:	55                   	push   %ebp
     1f0:	89 e5                	mov    %esp,%ebp
     1f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     1f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1fc:	00 
     1fd:	8b 45 08             	mov    0x8(%ebp),%eax
     200:	89 04 24             	mov    %eax,(%esp)
     203:	e8 07 01 00 00       	call   30f <open>
     208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     20f:	79 07                	jns    218 <stat+0x29>
    return -1;
     211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     216:	eb 23                	jmp    23b <stat+0x4c>
  r = fstat(fd, st);
     218:	8b 45 0c             	mov    0xc(%ebp),%eax
     21b:	89 44 24 04          	mov    %eax,0x4(%esp)
     21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     222:	89 04 24             	mov    %eax,(%esp)
     225:	e8 fd 00 00 00       	call   327 <fstat>
     22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     230:	89 04 24             	mov    %eax,(%esp)
     233:	e8 bf 00 00 00       	call   2f7 <close>
  return r;
     238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     23b:	c9                   	leave  
     23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
     23d:	55                   	push   %ebp
     23e:	89 e5                	mov    %esp,%ebp
     240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
     24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
     24f:	89 d0                	mov    %edx,%eax
     251:	c1 e0 02             	shl    $0x2,%eax
     254:	01 d0                	add    %edx,%eax
     256:	01 c0                	add    %eax,%eax
     258:	89 c1                	mov    %eax,%ecx
     25a:	8b 45 08             	mov    0x8(%ebp),%eax
     25d:	8d 50 01             	lea    0x1(%eax),%edx
     260:	89 55 08             	mov    %edx,0x8(%ebp)
     263:	0f b6 00             	movzbl (%eax),%eax
     266:	0f be c0             	movsbl %al,%eax
     269:	01 c8                	add    %ecx,%eax
     26b:	83 e8 30             	sub    $0x30,%eax
     26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     271:	8b 45 08             	mov    0x8(%ebp),%eax
     274:	0f b6 00             	movzbl (%eax),%eax
     277:	3c 2f                	cmp    $0x2f,%al
     279:	7e 0a                	jle    285 <atoi+0x48>
     27b:	8b 45 08             	mov    0x8(%ebp),%eax
     27e:	0f b6 00             	movzbl (%eax),%eax
     281:	3c 39                	cmp    $0x39,%al
     283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     288:	c9                   	leave  
     289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     28a:	55                   	push   %ebp
     28b:	89 e5                	mov    %esp,%ebp
     28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     290:	8b 45 08             	mov    0x8(%ebp),%eax
     293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     296:	8b 45 0c             	mov    0xc(%ebp),%eax
     299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
     29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     2a1:	8d 50 01             	lea    0x1(%eax),%edx
     2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
     2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
     2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
     2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     2b0:	0f b6 12             	movzbl (%edx),%edx
     2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     2b5:	8b 45 10             	mov    0x10(%ebp),%eax
     2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
     2bb:	89 55 10             	mov    %edx,0x10(%ebp)
     2be:	85 c0                	test   %eax,%eax
     2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     2c7:	b8 01 00 00 00       	mov    $0x1,%eax
     2cc:	cd 40                	int    $0x40
     2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
     2cf:	b8 02 00 00 00       	mov    $0x2,%eax
     2d4:	cd 40                	int    $0x40
     2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
     2d7:	b8 03 00 00 00       	mov    $0x3,%eax
     2dc:	cd 40                	int    $0x40
     2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
     2df:	b8 04 00 00 00       	mov    $0x4,%eax
     2e4:	cd 40                	int    $0x40
     2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
     2e7:	b8 05 00 00 00       	mov    $0x5,%eax
     2ec:	cd 40                	int    $0x40
     2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
     2ef:	b8 10 00 00 00       	mov    $0x10,%eax
     2f4:	cd 40                	int    $0x40
     2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
     2f7:	b8 15 00 00 00       	mov    $0x15,%eax
     2fc:	cd 40                	int    $0x40
     2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
     2ff:	b8 06 00 00 00       	mov    $0x6,%eax
     304:	cd 40                	int    $0x40
     306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
     307:	b8 07 00 00 00       	mov    $0x7,%eax
     30c:	cd 40                	int    $0x40
     30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
     30f:	b8 0f 00 00 00       	mov    $0xf,%eax
     314:	cd 40                	int    $0x40
     316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
     317:	b8 11 00 00 00       	mov    $0x11,%eax
     31c:	cd 40                	int    $0x40
     31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
     31f:	b8 12 00 00 00       	mov    $0x12,%eax
     324:	cd 40                	int    $0x40
     326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
     327:	b8 08 00 00 00       	mov    $0x8,%eax
     32c:	cd 40                	int    $0x40
     32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
     32f:	b8 13 00 00 00       	mov    $0x13,%eax
     334:	cd 40                	int    $0x40
     336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
     337:	b8 14 00 00 00       	mov    $0x14,%eax
     33c:	cd 40                	int    $0x40
     33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
     33f:	b8 09 00 00 00       	mov    $0x9,%eax
     344:	cd 40                	int    $0x40
     346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
     347:	b8 0a 00 00 00       	mov    $0xa,%eax
     34c:	cd 40                	int    $0x40
     34e:	c3                   	ret    

0000034f <getpid>:
SYSCALL(getpid)
     34f:	b8 0b 00 00 00       	mov    $0xb,%eax
     354:	cd 40                	int    $0x40
     356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
     357:	b8 0c 00 00 00       	mov    $0xc,%eax
     35c:	cd 40                	int    $0x40
     35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
     35f:	b8 0d 00 00 00       	mov    $0xd,%eax
     364:	cd 40                	int    $0x40
     366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
     367:	b8 0e 00 00 00       	mov    $0xe,%eax
     36c:	cd 40                	int    $0x40
     36e:	c3                   	ret    

0000036f <kthread_create>:




SYSCALL(kthread_create)
     36f:	b8 16 00 00 00       	mov    $0x16,%eax
     374:	cd 40                	int    $0x40
     376:	c3                   	ret    

00000377 <kthread_id>:
SYSCALL(kthread_id)
     377:	b8 17 00 00 00       	mov    $0x17,%eax
     37c:	cd 40                	int    $0x40
     37e:	c3                   	ret    

0000037f <kthread_exit>:
SYSCALL(kthread_exit)
     37f:	b8 18 00 00 00       	mov    $0x18,%eax
     384:	cd 40                	int    $0x40
     386:	c3                   	ret    

00000387 <kthread_join>:
SYSCALL(kthread_join)
     387:	b8 19 00 00 00       	mov    $0x19,%eax
     38c:	cd 40                	int    $0x40
     38e:	c3                   	ret    

0000038f <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     38f:	b8 1a 00 00 00       	mov    $0x1a,%eax
     394:	cd 40                	int    $0x40
     396:	c3                   	ret    

00000397 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     397:	b8 1b 00 00 00       	mov    $0x1b,%eax
     39c:	cd 40                	int    $0x40
     39e:	c3                   	ret    

0000039f <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     39f:	b8 1c 00 00 00       	mov    $0x1c,%eax
     3a4:	cd 40                	int    $0x40
     3a6:	c3                   	ret    

000003a7 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     3a7:	b8 1d 00 00 00       	mov    $0x1d,%eax
     3ac:	cd 40                	int    $0x40
     3ae:	c3                   	ret    

000003af <kthread_mutex_yieldlock>:
     3af:	b8 1e 00 00 00       	mov    $0x1e,%eax
     3b4:	cd 40                	int    $0x40
     3b6:	c3                   	ret    

000003b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     3b7:	55                   	push   %ebp
     3b8:	89 e5                	mov    %esp,%ebp
     3ba:	83 ec 18             	sub    $0x18,%esp
     3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     3c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     3c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3ca:	00 
     3cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
     3ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     3d2:	8b 45 08             	mov    0x8(%ebp),%eax
     3d5:	89 04 24             	mov    %eax,(%esp)
     3d8:	e8 12 ff ff ff       	call   2ef <write>
}
     3dd:	c9                   	leave  
     3de:	c3                   	ret    

000003df <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     3df:	55                   	push   %ebp
     3e0:	89 e5                	mov    %esp,%ebp
     3e2:	56                   	push   %esi
     3e3:	53                   	push   %ebx
     3e4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     3e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     3ee:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     3f2:	74 17                	je     40b <printint+0x2c>
     3f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     3f8:	79 11                	jns    40b <printint+0x2c>
    neg = 1;
     3fa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     401:	8b 45 0c             	mov    0xc(%ebp),%eax
     404:	f7 d8                	neg    %eax
     406:	89 45 ec             	mov    %eax,-0x14(%ebp)
     409:	eb 06                	jmp    411 <printint+0x32>
  } else {
    x = xx;
     40b:	8b 45 0c             	mov    0xc(%ebp),%eax
     40e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     411:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     418:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     41b:	8d 41 01             	lea    0x1(%ecx),%eax
     41e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     421:	8b 5d 10             	mov    0x10(%ebp),%ebx
     424:	8b 45 ec             	mov    -0x14(%ebp),%eax
     427:	ba 00 00 00 00       	mov    $0x0,%edx
     42c:	f7 f3                	div    %ebx
     42e:	89 d0                	mov    %edx,%eax
     430:	0f b6 80 d0 14 00 00 	movzbl 0x14d0(%eax),%eax
     437:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     43b:	8b 75 10             	mov    0x10(%ebp),%esi
     43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     441:	ba 00 00 00 00       	mov    $0x0,%edx
     446:	f7 f6                	div    %esi
     448:	89 45 ec             	mov    %eax,-0x14(%ebp)
     44b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     44f:	75 c7                	jne    418 <printint+0x39>
  if(neg)
     451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     455:	74 10                	je     467 <printint+0x88>
    buf[i++] = '-';
     457:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45a:	8d 50 01             	lea    0x1(%eax),%edx
     45d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     460:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     465:	eb 1f                	jmp    486 <printint+0xa7>
     467:	eb 1d                	jmp    486 <printint+0xa7>
    putc(fd, buf[i]);
     469:	8d 55 dc             	lea    -0x24(%ebp),%edx
     46c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46f:	01 d0                	add    %edx,%eax
     471:	0f b6 00             	movzbl (%eax),%eax
     474:	0f be c0             	movsbl %al,%eax
     477:	89 44 24 04          	mov    %eax,0x4(%esp)
     47b:	8b 45 08             	mov    0x8(%ebp),%eax
     47e:	89 04 24             	mov    %eax,(%esp)
     481:	e8 31 ff ff ff       	call   3b7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     486:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     48a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     48e:	79 d9                	jns    469 <printint+0x8a>
    putc(fd, buf[i]);
}
     490:	83 c4 30             	add    $0x30,%esp
     493:	5b                   	pop    %ebx
     494:	5e                   	pop    %esi
     495:	5d                   	pop    %ebp
     496:	c3                   	ret    

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     497:	55                   	push   %ebp
     498:	89 e5                	mov    %esp,%ebp
     49a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     49d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     4a4:	8d 45 0c             	lea    0xc(%ebp),%eax
     4a7:	83 c0 04             	add    $0x4,%eax
     4aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     4b4:	e9 7c 01 00 00       	jmp    635 <printf+0x19e>
    c = fmt[i] & 0xff;
     4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
     4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4bf:	01 d0                	add    %edx,%eax
     4c1:	0f b6 00             	movzbl (%eax),%eax
     4c4:	0f be c0             	movsbl %al,%eax
     4c7:	25 ff 00 00 00       	and    $0xff,%eax
     4cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4d3:	75 2c                	jne    501 <printf+0x6a>
      if(c == '%'){
     4d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     4d9:	75 0c                	jne    4e7 <printf+0x50>
        state = '%';
     4db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     4e2:	e9 4a 01 00 00       	jmp    631 <printf+0x19a>
      } else {
        putc(fd, c);
     4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4ea:	0f be c0             	movsbl %al,%eax
     4ed:	89 44 24 04          	mov    %eax,0x4(%esp)
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
     4f4:	89 04 24             	mov    %eax,(%esp)
     4f7:	e8 bb fe ff ff       	call   3b7 <putc>
     4fc:	e9 30 01 00 00       	jmp    631 <printf+0x19a>
      }
    } else if(state == '%'){
     501:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     505:	0f 85 26 01 00 00    	jne    631 <printf+0x19a>
      if(c == 'd'){
     50b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     50f:	75 2d                	jne    53e <printf+0xa7>
        printint(fd, *ap, 10, 1);
     511:	8b 45 e8             	mov    -0x18(%ebp),%eax
     514:	8b 00                	mov    (%eax),%eax
     516:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     51d:	00 
     51e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     525:	00 
     526:	89 44 24 04          	mov    %eax,0x4(%esp)
     52a:	8b 45 08             	mov    0x8(%ebp),%eax
     52d:	89 04 24             	mov    %eax,(%esp)
     530:	e8 aa fe ff ff       	call   3df <printint>
        ap++;
     535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     539:	e9 ec 00 00 00       	jmp    62a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     53e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     542:	74 06                	je     54a <printf+0xb3>
     544:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     548:	75 2d                	jne    577 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     54d:	8b 00                	mov    (%eax),%eax
     54f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     556:	00 
     557:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     55e:	00 
     55f:	89 44 24 04          	mov    %eax,0x4(%esp)
     563:	8b 45 08             	mov    0x8(%ebp),%eax
     566:	89 04 24             	mov    %eax,(%esp)
     569:	e8 71 fe ff ff       	call   3df <printint>
        ap++;
     56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     572:	e9 b3 00 00 00       	jmp    62a <printf+0x193>
      } else if(c == 's'){
     577:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     57b:	75 45                	jne    5c2 <printf+0x12b>
        s = (char*)*ap;
     57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     580:	8b 00                	mov    (%eax),%eax
     582:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     58d:	75 09                	jne    598 <printf+0x101>
          s = "(null)";
     58f:	c7 45 f4 45 10 00 00 	movl   $0x1045,-0xc(%ebp)
        while(*s != 0){
     596:	eb 1e                	jmp    5b6 <printf+0x11f>
     598:	eb 1c                	jmp    5b6 <printf+0x11f>
          putc(fd, *s);
     59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59d:	0f b6 00             	movzbl (%eax),%eax
     5a0:	0f be c0             	movsbl %al,%eax
     5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
     5a7:	8b 45 08             	mov    0x8(%ebp),%eax
     5aa:	89 04 24             	mov    %eax,(%esp)
     5ad:	e8 05 fe ff ff       	call   3b7 <putc>
          s++;
     5b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b9:	0f b6 00             	movzbl (%eax),%eax
     5bc:	84 c0                	test   %al,%al
     5be:	75 da                	jne    59a <printf+0x103>
     5c0:	eb 68                	jmp    62a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     5c2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     5c6:	75 1d                	jne    5e5 <printf+0x14e>
        putc(fd, *ap);
     5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5cb:	8b 00                	mov    (%eax),%eax
     5cd:	0f be c0             	movsbl %al,%eax
     5d0:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d4:	8b 45 08             	mov    0x8(%ebp),%eax
     5d7:	89 04 24             	mov    %eax,(%esp)
     5da:	e8 d8 fd ff ff       	call   3b7 <putc>
        ap++;
     5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5e3:	eb 45                	jmp    62a <printf+0x193>
      } else if(c == '%'){
     5e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     5e9:	75 17                	jne    602 <printf+0x16b>
        putc(fd, c);
     5eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5ee:	0f be c0             	movsbl %al,%eax
     5f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     5f5:	8b 45 08             	mov    0x8(%ebp),%eax
     5f8:	89 04 24             	mov    %eax,(%esp)
     5fb:	e8 b7 fd ff ff       	call   3b7 <putc>
     600:	eb 28                	jmp    62a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     602:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     609:	00 
     60a:	8b 45 08             	mov    0x8(%ebp),%eax
     60d:	89 04 24             	mov    %eax,(%esp)
     610:	e8 a2 fd ff ff       	call   3b7 <putc>
        putc(fd, c);
     615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     618:	0f be c0             	movsbl %al,%eax
     61b:	89 44 24 04          	mov    %eax,0x4(%esp)
     61f:	8b 45 08             	mov    0x8(%ebp),%eax
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 8d fd ff ff       	call   3b7 <putc>
      }
      state = 0;
     62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     631:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     635:	8b 55 0c             	mov    0xc(%ebp),%edx
     638:	8b 45 f0             	mov    -0x10(%ebp),%eax
     63b:	01 d0                	add    %edx,%eax
     63d:	0f b6 00             	movzbl (%eax),%eax
     640:	84 c0                	test   %al,%al
     642:	0f 85 71 fe ff ff    	jne    4b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     648:	c9                   	leave  
     649:	c3                   	ret    

0000064a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     64a:	55                   	push   %ebp
     64b:	89 e5                	mov    %esp,%ebp
     64d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     650:	8b 45 08             	mov    0x8(%ebp),%eax
     653:	83 e8 08             	sub    $0x8,%eax
     656:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     659:	a1 ec 14 00 00       	mov    0x14ec,%eax
     65e:	89 45 fc             	mov    %eax,-0x4(%ebp)
     661:	eb 24                	jmp    687 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     663:	8b 45 fc             	mov    -0x4(%ebp),%eax
     666:	8b 00                	mov    (%eax),%eax
     668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     66b:	77 12                	ja     67f <free+0x35>
     66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     670:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     673:	77 24                	ja     699 <free+0x4f>
     675:	8b 45 fc             	mov    -0x4(%ebp),%eax
     678:	8b 00                	mov    (%eax),%eax
     67a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     67d:	77 1a                	ja     699 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     682:	8b 00                	mov    (%eax),%eax
     684:	89 45 fc             	mov    %eax,-0x4(%ebp)
     687:	8b 45 f8             	mov    -0x8(%ebp),%eax
     68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     68d:	76 d4                	jbe    663 <free+0x19>
     68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     692:	8b 00                	mov    (%eax),%eax
     694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     697:	76 ca                	jbe    663 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     699:	8b 45 f8             	mov    -0x8(%ebp),%eax
     69c:	8b 40 04             	mov    0x4(%eax),%eax
     69f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6a9:	01 c2                	add    %eax,%edx
     6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ae:	8b 00                	mov    (%eax),%eax
     6b0:	39 c2                	cmp    %eax,%edx
     6b2:	75 24                	jne    6d8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6b7:	8b 50 04             	mov    0x4(%eax),%edx
     6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6bd:	8b 00                	mov    (%eax),%eax
     6bf:	8b 40 04             	mov    0x4(%eax),%eax
     6c2:	01 c2                	add    %eax,%edx
     6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6c7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6cd:	8b 00                	mov    (%eax),%eax
     6cf:	8b 10                	mov    (%eax),%edx
     6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d4:	89 10                	mov    %edx,(%eax)
     6d6:	eb 0a                	jmp    6e2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6db:	8b 10                	mov    (%eax),%edx
     6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6e0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6e5:	8b 40 04             	mov    0x4(%eax),%eax
     6e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6f2:	01 d0                	add    %edx,%eax
     6f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6f7:	75 20                	jne    719 <free+0xcf>
    p->s.size += bp->s.size;
     6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6fc:	8b 50 04             	mov    0x4(%eax),%edx
     6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
     702:	8b 40 04             	mov    0x4(%eax),%eax
     705:	01 c2                	add    %eax,%edx
     707:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     710:	8b 10                	mov    (%eax),%edx
     712:	8b 45 fc             	mov    -0x4(%ebp),%eax
     715:	89 10                	mov    %edx,(%eax)
     717:	eb 08                	jmp    721 <free+0xd7>
  } else
    p->s.ptr = bp;
     719:	8b 45 fc             	mov    -0x4(%ebp),%eax
     71c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     71f:	89 10                	mov    %edx,(%eax)
  freep = p;
     721:	8b 45 fc             	mov    -0x4(%ebp),%eax
     724:	a3 ec 14 00 00       	mov    %eax,0x14ec
}
     729:	c9                   	leave  
     72a:	c3                   	ret    

0000072b <morecore>:

static Header*
morecore(uint nu)
{
     72b:	55                   	push   %ebp
     72c:	89 e5                	mov    %esp,%ebp
     72e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     731:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     738:	77 07                	ja     741 <morecore+0x16>
    nu = 4096;
     73a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     741:	8b 45 08             	mov    0x8(%ebp),%eax
     744:	c1 e0 03             	shl    $0x3,%eax
     747:	89 04 24             	mov    %eax,(%esp)
     74a:	e8 08 fc ff ff       	call   357 <sbrk>
     74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     752:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     756:	75 07                	jne    75f <morecore+0x34>
    return 0;
     758:	b8 00 00 00 00       	mov    $0x0,%eax
     75d:	eb 22                	jmp    781 <morecore+0x56>
  hp = (Header*)p;
     75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     762:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     765:	8b 45 f0             	mov    -0x10(%ebp),%eax
     768:	8b 55 08             	mov    0x8(%ebp),%edx
     76b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     771:	83 c0 08             	add    $0x8,%eax
     774:	89 04 24             	mov    %eax,(%esp)
     777:	e8 ce fe ff ff       	call   64a <free>
  return freep;
     77c:	a1 ec 14 00 00       	mov    0x14ec,%eax
}
     781:	c9                   	leave  
     782:	c3                   	ret    

00000783 <malloc>:

void*
malloc(uint nbytes)
{
     783:	55                   	push   %ebp
     784:	89 e5                	mov    %esp,%ebp
     786:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     789:	8b 45 08             	mov    0x8(%ebp),%eax
     78c:	83 c0 07             	add    $0x7,%eax
     78f:	c1 e8 03             	shr    $0x3,%eax
     792:	83 c0 01             	add    $0x1,%eax
     795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     798:	a1 ec 14 00 00       	mov    0x14ec,%eax
     79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7a4:	75 23                	jne    7c9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7a6:	c7 45 f0 e4 14 00 00 	movl   $0x14e4,-0x10(%ebp)
     7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7b0:	a3 ec 14 00 00       	mov    %eax,0x14ec
     7b5:	a1 ec 14 00 00       	mov    0x14ec,%eax
     7ba:	a3 e4 14 00 00       	mov    %eax,0x14e4
    base.s.size = 0;
     7bf:	c7 05 e8 14 00 00 00 	movl   $0x0,0x14e8
     7c6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7cc:	8b 00                	mov    (%eax),%eax
     7ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d4:	8b 40 04             	mov    0x4(%eax),%eax
     7d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7da:	72 4d                	jb     829 <malloc+0xa6>
      if(p->s.size == nunits)
     7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7df:	8b 40 04             	mov    0x4(%eax),%eax
     7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7e5:	75 0c                	jne    7f3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ea:	8b 10                	mov    (%eax),%edx
     7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7ef:	89 10                	mov    %edx,(%eax)
     7f1:	eb 26                	jmp    819 <malloc+0x96>
      else {
        p->s.size -= nunits;
     7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f6:	8b 40 04             	mov    0x4(%eax),%eax
     7f9:	2b 45 ec             	sub    -0x14(%ebp),%eax
     7fc:	89 c2                	mov    %eax,%edx
     7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     801:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     804:	8b 45 f4             	mov    -0xc(%ebp),%eax
     807:	8b 40 04             	mov    0x4(%eax),%eax
     80a:	c1 e0 03             	shl    $0x3,%eax
     80d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     810:	8b 45 f4             	mov    -0xc(%ebp),%eax
     813:	8b 55 ec             	mov    -0x14(%ebp),%edx
     816:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     819:	8b 45 f0             	mov    -0x10(%ebp),%eax
     81c:	a3 ec 14 00 00       	mov    %eax,0x14ec
      return (void*)(p + 1);
     821:	8b 45 f4             	mov    -0xc(%ebp),%eax
     824:	83 c0 08             	add    $0x8,%eax
     827:	eb 38                	jmp    861 <malloc+0xde>
    }
    if(p == freep)
     829:	a1 ec 14 00 00       	mov    0x14ec,%eax
     82e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     831:	75 1b                	jne    84e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     833:	8b 45 ec             	mov    -0x14(%ebp),%eax
     836:	89 04 24             	mov    %eax,(%esp)
     839:	e8 ed fe ff ff       	call   72b <morecore>
     83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     845:	75 07                	jne    84e <malloc+0xcb>
        return 0;
     847:	b8 00 00 00 00       	mov    $0x0,%eax
     84c:	eb 13                	jmp    861 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     851:	89 45 f0             	mov    %eax,-0x10(%ebp)
     854:	8b 45 f4             	mov    -0xc(%ebp),%eax
     857:	8b 00                	mov    (%eax),%eax
     859:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     85c:	e9 70 ff ff ff       	jmp    7d1 <malloc+0x4e>
}
     861:	c9                   	leave  
     862:	c3                   	ret    

00000863 <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     863:	55                   	push   %ebp
     864:	89 e5                	mov    %esp,%ebp
     866:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     869:	e8 21 fb ff ff       	call   38f <kthread_mutex_alloc>
     86e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     875:	79 0a                	jns    881 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     877:	b8 00 00 00 00       	mov    $0x0,%eax
     87c:	e9 8b 00 00 00       	jmp    90c <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     881:	e8 44 06 00 00       	call   eca <mesa_cond_alloc>
     886:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     88d:	75 12                	jne    8a1 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     892:	89 04 24             	mov    %eax,(%esp)
     895:	e8 fd fa ff ff       	call   397 <kthread_mutex_dealloc>
		return 0;
     89a:	b8 00 00 00 00       	mov    $0x0,%eax
     89f:	eb 6b                	jmp    90c <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     8a1:	e8 24 06 00 00       	call   eca <mesa_cond_alloc>
     8a6:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     8a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8ad:	75 1d                	jne    8cc <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b2:	89 04 24             	mov    %eax,(%esp)
     8b5:	e8 dd fa ff ff       	call   397 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8bd:	89 04 24             	mov    %eax,(%esp)
     8c0:	e8 46 06 00 00       	call   f0b <mesa_cond_dealloc>
		return 0;
     8c5:	b8 00 00 00 00       	mov    $0x0,%eax
     8ca:	eb 40                	jmp    90c <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     8cc:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     8d3:	e8 ab fe ff ff       	call   783 <malloc>
     8d8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     8db:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8de:	8b 55 f0             	mov    -0x10(%ebp),%edx
     8e1:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     8e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     8ea:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     8ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8f3:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     8f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     8ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     902:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     909:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     90c:	c9                   	leave  
     90d:	c3                   	ret    

0000090e <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     90e:	55                   	push   %ebp
     90f:	89 e5                	mov    %esp,%ebp
     911:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     914:	8b 45 08             	mov    0x8(%ebp),%eax
     917:	8b 00                	mov    (%eax),%eax
     919:	89 04 24             	mov    %eax,(%esp)
     91c:	e8 76 fa ff ff       	call   397 <kthread_mutex_dealloc>
     921:	85 c0                	test   %eax,%eax
     923:	78 2e                	js     953 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     925:	8b 45 08             	mov    0x8(%ebp),%eax
     928:	8b 40 04             	mov    0x4(%eax),%eax
     92b:	89 04 24             	mov    %eax,(%esp)
     92e:	e8 97 05 00 00       	call   eca <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     933:	8b 45 08             	mov    0x8(%ebp),%eax
     936:	8b 40 08             	mov    0x8(%eax),%eax
     939:	89 04 24             	mov    %eax,(%esp)
     93c:	e8 89 05 00 00       	call   eca <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     941:	8b 45 08             	mov    0x8(%ebp),%eax
     944:	89 04 24             	mov    %eax,(%esp)
     947:	e8 fe fc ff ff       	call   64a <free>
	return 0;
     94c:	b8 00 00 00 00       	mov    $0x0,%eax
     951:	eb 05                	jmp    958 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     958:	c9                   	leave  
     959:	c3                   	ret    

0000095a <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     95a:	55                   	push   %ebp
     95b:	89 e5                	mov    %esp,%ebp
     95d:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     960:	8b 45 08             	mov    0x8(%ebp),%eax
     963:	8b 40 10             	mov    0x10(%eax),%eax
     966:	85 c0                	test   %eax,%eax
     968:	75 0a                	jne    974 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     96a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     96f:	e9 81 00 00 00       	jmp    9f5 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     974:	8b 45 08             	mov    0x8(%ebp),%eax
     977:	8b 00                	mov    (%eax),%eax
     979:	89 04 24             	mov    %eax,(%esp)
     97c:	e8 1e fa ff ff       	call   39f <kthread_mutex_lock>
     981:	83 f8 ff             	cmp    $0xffffffff,%eax
     984:	7d 07                	jge    98d <mesa_slots_monitor_addslots+0x33>
		return -1;
     986:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     98b:	eb 68                	jmp    9f5 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     98d:	eb 17                	jmp    9a6 <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     98f:	8b 45 08             	mov    0x8(%ebp),%eax
     992:	8b 10                	mov    (%eax),%edx
     994:	8b 45 08             	mov    0x8(%ebp),%eax
     997:	8b 40 08             	mov    0x8(%eax),%eax
     99a:	89 54 24 04          	mov    %edx,0x4(%esp)
     99e:	89 04 24             	mov    %eax,(%esp)
     9a1:	e8 af 05 00 00       	call   f55 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     9a6:	8b 45 08             	mov    0x8(%ebp),%eax
     9a9:	8b 40 10             	mov    0x10(%eax),%eax
     9ac:	85 c0                	test   %eax,%eax
     9ae:	74 0a                	je     9ba <mesa_slots_monitor_addslots+0x60>
     9b0:	8b 45 08             	mov    0x8(%ebp),%eax
     9b3:	8b 40 0c             	mov    0xc(%eax),%eax
     9b6:	85 c0                	test   %eax,%eax
     9b8:	7f d5                	jg     98f <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     9ba:	8b 45 08             	mov    0x8(%ebp),%eax
     9bd:	8b 40 10             	mov    0x10(%eax),%eax
     9c0:	85 c0                	test   %eax,%eax
     9c2:	74 11                	je     9d5 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     9c4:	8b 45 08             	mov    0x8(%ebp),%eax
     9c7:	8b 50 0c             	mov    0xc(%eax),%edx
     9ca:	8b 45 0c             	mov    0xc(%ebp),%eax
     9cd:	01 c2                	add    %eax,%edx
     9cf:	8b 45 08             	mov    0x8(%ebp),%eax
     9d2:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     9d5:	8b 45 08             	mov    0x8(%ebp),%eax
     9d8:	8b 40 04             	mov    0x4(%eax),%eax
     9db:	89 04 24             	mov    %eax,(%esp)
     9de:	e8 dc 05 00 00       	call   fbf <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     9e3:	8b 45 08             	mov    0x8(%ebp),%eax
     9e6:	8b 00                	mov    (%eax),%eax
     9e8:	89 04 24             	mov    %eax,(%esp)
     9eb:	e8 b7 f9 ff ff       	call   3a7 <kthread_mutex_unlock>

	return 1;
     9f0:	b8 01 00 00 00       	mov    $0x1,%eax


}
     9f5:	c9                   	leave  
     9f6:	c3                   	ret    

000009f7 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     9f7:	55                   	push   %ebp
     9f8:	89 e5                	mov    %esp,%ebp
     9fa:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     9fd:	8b 45 08             	mov    0x8(%ebp),%eax
     a00:	8b 40 10             	mov    0x10(%eax),%eax
     a03:	85 c0                	test   %eax,%eax
     a05:	75 07                	jne    a0e <mesa_slots_monitor_takeslot+0x17>
		return -1;
     a07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a0c:	eb 7f                	jmp    a8d <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     a0e:	8b 45 08             	mov    0x8(%ebp),%eax
     a11:	8b 00                	mov    (%eax),%eax
     a13:	89 04 24             	mov    %eax,(%esp)
     a16:	e8 84 f9 ff ff       	call   39f <kthread_mutex_lock>
     a1b:	83 f8 ff             	cmp    $0xffffffff,%eax
     a1e:	7d 07                	jge    a27 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a25:	eb 66                	jmp    a8d <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     a27:	eb 17                	jmp    a40 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     a29:	8b 45 08             	mov    0x8(%ebp),%eax
     a2c:	8b 10                	mov    (%eax),%edx
     a2e:	8b 45 08             	mov    0x8(%ebp),%eax
     a31:	8b 40 04             	mov    0x4(%eax),%eax
     a34:	89 54 24 04          	mov    %edx,0x4(%esp)
     a38:	89 04 24             	mov    %eax,(%esp)
     a3b:	e8 15 05 00 00       	call   f55 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     a40:	8b 45 08             	mov    0x8(%ebp),%eax
     a43:	8b 40 10             	mov    0x10(%eax),%eax
     a46:	85 c0                	test   %eax,%eax
     a48:	74 0a                	je     a54 <mesa_slots_monitor_takeslot+0x5d>
     a4a:	8b 45 08             	mov    0x8(%ebp),%eax
     a4d:	8b 40 0c             	mov    0xc(%eax),%eax
     a50:	85 c0                	test   %eax,%eax
     a52:	74 d5                	je     a29 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     a54:	8b 45 08             	mov    0x8(%ebp),%eax
     a57:	8b 40 10             	mov    0x10(%eax),%eax
     a5a:	85 c0                	test   %eax,%eax
     a5c:	74 0f                	je     a6d <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     a5e:	8b 45 08             	mov    0x8(%ebp),%eax
     a61:	8b 40 0c             	mov    0xc(%eax),%eax
     a64:	8d 50 ff             	lea    -0x1(%eax),%edx
     a67:	8b 45 08             	mov    0x8(%ebp),%eax
     a6a:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     a6d:	8b 45 08             	mov    0x8(%ebp),%eax
     a70:	8b 40 08             	mov    0x8(%eax),%eax
     a73:	89 04 24             	mov    %eax,(%esp)
     a76:	e8 44 05 00 00       	call   fbf <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     a7b:	8b 45 08             	mov    0x8(%ebp),%eax
     a7e:	8b 00                	mov    (%eax),%eax
     a80:	89 04 24             	mov    %eax,(%esp)
     a83:	e8 1f f9 ff ff       	call   3a7 <kthread_mutex_unlock>

	return 1;
     a88:	b8 01 00 00 00       	mov    $0x1,%eax

}
     a8d:	c9                   	leave  
     a8e:	c3                   	ret    

00000a8f <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     a8f:	55                   	push   %ebp
     a90:	89 e5                	mov    %esp,%ebp
     a92:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     a95:	8b 45 08             	mov    0x8(%ebp),%eax
     a98:	8b 40 10             	mov    0x10(%eax),%eax
     a9b:	85 c0                	test   %eax,%eax
     a9d:	75 07                	jne    aa6 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     aa4:	eb 35                	jmp    adb <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	8b 00                	mov    (%eax),%eax
     aab:	89 04 24             	mov    %eax,(%esp)
     aae:	e8 ec f8 ff ff       	call   39f <kthread_mutex_lock>
     ab3:	83 f8 ff             	cmp    $0xffffffff,%eax
     ab6:	7d 07                	jge    abf <mesa_slots_monitor_stopadding+0x30>
			return -1;
     ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     abd:	eb 1c                	jmp    adb <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     abf:	8b 45 08             	mov    0x8(%ebp),%eax
     ac2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     ac9:	8b 45 08             	mov    0x8(%ebp),%eax
     acc:	8b 00                	mov    (%eax),%eax
     ace:	89 04 24             	mov    %eax,(%esp)
     ad1:	e8 d1 f8 ff ff       	call   3a7 <kthread_mutex_unlock>

		return 0;
     ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
     adb:	c9                   	leave  
     adc:	c3                   	ret    

00000add <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     add:	55                   	push   %ebp
     ade:	89 e5                	mov    %esp,%ebp
     ae0:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     ae3:	e8 a7 f8 ff ff       	call   38f <kthread_mutex_alloc>
     ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aef:	79 0a                	jns    afb <hoare_slots_monitor_alloc+0x1e>
		return 0;
     af1:	b8 00 00 00 00       	mov    $0x0,%eax
     af6:	e9 8b 00 00 00       	jmp    b86 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     afb:	e8 68 02 00 00       	call   d68 <hoare_cond_alloc>
     b00:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b07:	75 12                	jne    b1b <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b0c:	89 04 24             	mov    %eax,(%esp)
     b0f:	e8 83 f8 ff ff       	call   397 <kthread_mutex_dealloc>
		return 0;
     b14:	b8 00 00 00 00       	mov    $0x0,%eax
     b19:	eb 6b                	jmp    b86 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     b1b:	e8 48 02 00 00       	call   d68 <hoare_cond_alloc>
     b20:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     b23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b27:	75 1d                	jne    b46 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 63 f8 ff ff       	call   397 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b37:	89 04 24             	mov    %eax,(%esp)
     b3a:	e8 6a 02 00 00       	call   da9 <hoare_cond_dealloc>
		return 0;
     b3f:	b8 00 00 00 00       	mov    $0x0,%eax
     b44:	eb 40                	jmp    b86 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     b46:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b4d:	e8 31 fc ff ff       	call   783 <malloc>
     b52:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b58:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b5b:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b61:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b64:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b6d:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b7c:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     b83:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     b86:	c9                   	leave  
     b87:	c3                   	ret    

00000b88 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     b88:	55                   	push   %ebp
     b89:	89 e5                	mov    %esp,%ebp
     b8b:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     b8e:	8b 45 08             	mov    0x8(%ebp),%eax
     b91:	8b 00                	mov    (%eax),%eax
     b93:	89 04 24             	mov    %eax,(%esp)
     b96:	e8 fc f7 ff ff       	call   397 <kthread_mutex_dealloc>
     b9b:	85 c0                	test   %eax,%eax
     b9d:	78 2e                	js     bcd <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     b9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ba2:	8b 40 04             	mov    0x4(%eax),%eax
     ba5:	89 04 24             	mov    %eax,(%esp)
     ba8:	e8 bb 01 00 00       	call   d68 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     bad:	8b 45 08             	mov    0x8(%ebp),%eax
     bb0:	8b 40 08             	mov    0x8(%eax),%eax
     bb3:	89 04 24             	mov    %eax,(%esp)
     bb6:	e8 ad 01 00 00       	call   d68 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     bbb:	8b 45 08             	mov    0x8(%ebp),%eax
     bbe:	89 04 24             	mov    %eax,(%esp)
     bc1:	e8 84 fa ff ff       	call   64a <free>
	return 0;
     bc6:	b8 00 00 00 00       	mov    $0x0,%eax
     bcb:	eb 05                	jmp    bd2 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bd2:	c9                   	leave  
     bd3:	c3                   	ret    

00000bd4 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     bd4:	55                   	push   %ebp
     bd5:	89 e5                	mov    %esp,%ebp
     bd7:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     bda:	8b 45 08             	mov    0x8(%ebp),%eax
     bdd:	8b 40 10             	mov    0x10(%eax),%eax
     be0:	85 c0                	test   %eax,%eax
     be2:	75 0a                	jne    bee <hoare_slots_monitor_addslots+0x1a>
		return -1;
     be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     be9:	e9 88 00 00 00       	jmp    c76 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     bee:	8b 45 08             	mov    0x8(%ebp),%eax
     bf1:	8b 00                	mov    (%eax),%eax
     bf3:	89 04 24             	mov    %eax,(%esp)
     bf6:	e8 a4 f7 ff ff       	call   39f <kthread_mutex_lock>
     bfb:	83 f8 ff             	cmp    $0xffffffff,%eax
     bfe:	7d 07                	jge    c07 <hoare_slots_monitor_addslots+0x33>
		return -1;
     c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c05:	eb 6f                	jmp    c76 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     c07:	8b 45 08             	mov    0x8(%ebp),%eax
     c0a:	8b 40 10             	mov    0x10(%eax),%eax
     c0d:	85 c0                	test   %eax,%eax
     c0f:	74 21                	je     c32 <hoare_slots_monitor_addslots+0x5e>
     c11:	8b 45 08             	mov    0x8(%ebp),%eax
     c14:	8b 40 0c             	mov    0xc(%eax),%eax
     c17:	85 c0                	test   %eax,%eax
     c19:	7e 17                	jle    c32 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     c1b:	8b 45 08             	mov    0x8(%ebp),%eax
     c1e:	8b 10                	mov    (%eax),%edx
     c20:	8b 45 08             	mov    0x8(%ebp),%eax
     c23:	8b 40 08             	mov    0x8(%eax),%eax
     c26:	89 54 24 04          	mov    %edx,0x4(%esp)
     c2a:	89 04 24             	mov    %eax,(%esp)
     c2d:	e8 c1 01 00 00       	call   df3 <hoare_cond_wait>


	if  ( monitor->active)
     c32:	8b 45 08             	mov    0x8(%ebp),%eax
     c35:	8b 40 10             	mov    0x10(%eax),%eax
     c38:	85 c0                	test   %eax,%eax
     c3a:	74 11                	je     c4d <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     c3c:	8b 45 08             	mov    0x8(%ebp),%eax
     c3f:	8b 50 0c             	mov    0xc(%eax),%edx
     c42:	8b 45 0c             	mov    0xc(%ebp),%eax
     c45:	01 c2                	add    %eax,%edx
     c47:	8b 45 08             	mov    0x8(%ebp),%eax
     c4a:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     c4d:	8b 45 08             	mov    0x8(%ebp),%eax
     c50:	8b 10                	mov    (%eax),%edx
     c52:	8b 45 08             	mov    0x8(%ebp),%eax
     c55:	8b 40 04             	mov    0x4(%eax),%eax
     c58:	89 54 24 04          	mov    %edx,0x4(%esp)
     c5c:	89 04 24             	mov    %eax,(%esp)
     c5f:	e8 e6 01 00 00       	call   e4a <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	8b 00                	mov    (%eax),%eax
     c69:	89 04 24             	mov    %eax,(%esp)
     c6c:	e8 36 f7 ff ff       	call   3a7 <kthread_mutex_unlock>

	return 1;
     c71:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c76:	c9                   	leave  
     c77:	c3                   	ret    

00000c78 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     c78:	55                   	push   %ebp
     c79:	89 e5                	mov    %esp,%ebp
     c7b:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     c7e:	8b 45 08             	mov    0x8(%ebp),%eax
     c81:	8b 40 10             	mov    0x10(%eax),%eax
     c84:	85 c0                	test   %eax,%eax
     c86:	75 0a                	jne    c92 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c8d:	e9 86 00 00 00       	jmp    d18 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c92:	8b 45 08             	mov    0x8(%ebp),%eax
     c95:	8b 00                	mov    (%eax),%eax
     c97:	89 04 24             	mov    %eax,(%esp)
     c9a:	e8 00 f7 ff ff       	call   39f <kthread_mutex_lock>
     c9f:	83 f8 ff             	cmp    $0xffffffff,%eax
     ca2:	7d 07                	jge    cab <hoare_slots_monitor_takeslot+0x33>
		return -1;
     ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ca9:	eb 6d                	jmp    d18 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     cab:	8b 45 08             	mov    0x8(%ebp),%eax
     cae:	8b 40 10             	mov    0x10(%eax),%eax
     cb1:	85 c0                	test   %eax,%eax
     cb3:	74 21                	je     cd6 <hoare_slots_monitor_takeslot+0x5e>
     cb5:	8b 45 08             	mov    0x8(%ebp),%eax
     cb8:	8b 40 0c             	mov    0xc(%eax),%eax
     cbb:	85 c0                	test   %eax,%eax
     cbd:	75 17                	jne    cd6 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     cbf:	8b 45 08             	mov    0x8(%ebp),%eax
     cc2:	8b 10                	mov    (%eax),%edx
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	8b 40 04             	mov    0x4(%eax),%eax
     cca:	89 54 24 04          	mov    %edx,0x4(%esp)
     cce:	89 04 24             	mov    %eax,(%esp)
     cd1:	e8 1d 01 00 00       	call   df3 <hoare_cond_wait>


	if  ( monitor->active)
     cd6:	8b 45 08             	mov    0x8(%ebp),%eax
     cd9:	8b 40 10             	mov    0x10(%eax),%eax
     cdc:	85 c0                	test   %eax,%eax
     cde:	74 0f                	je     cef <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     ce0:	8b 45 08             	mov    0x8(%ebp),%eax
     ce3:	8b 40 0c             	mov    0xc(%eax),%eax
     ce6:	8d 50 ff             	lea    -0x1(%eax),%edx
     ce9:	8b 45 08             	mov    0x8(%ebp),%eax
     cec:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     cef:	8b 45 08             	mov    0x8(%ebp),%eax
     cf2:	8b 10                	mov    (%eax),%edx
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
     cf7:	8b 40 08             	mov    0x8(%eax),%eax
     cfa:	89 54 24 04          	mov    %edx,0x4(%esp)
     cfe:	89 04 24             	mov    %eax,(%esp)
     d01:	e8 44 01 00 00       	call   e4a <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d06:	8b 45 08             	mov    0x8(%ebp),%eax
     d09:	8b 00                	mov    (%eax),%eax
     d0b:	89 04 24             	mov    %eax,(%esp)
     d0e:	e8 94 f6 ff ff       	call   3a7 <kthread_mutex_unlock>

	return 1;
     d13:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d18:	c9                   	leave  
     d19:	c3                   	ret    

00000d1a <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     d1a:	55                   	push   %ebp
     d1b:	89 e5                	mov    %esp,%ebp
     d1d:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d20:	8b 45 08             	mov    0x8(%ebp),%eax
     d23:	8b 40 10             	mov    0x10(%eax),%eax
     d26:	85 c0                	test   %eax,%eax
     d28:	75 07                	jne    d31 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d2f:	eb 35                	jmp    d66 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d31:	8b 45 08             	mov    0x8(%ebp),%eax
     d34:	8b 00                	mov    (%eax),%eax
     d36:	89 04 24             	mov    %eax,(%esp)
     d39:	e8 61 f6 ff ff       	call   39f <kthread_mutex_lock>
     d3e:	83 f8 ff             	cmp    $0xffffffff,%eax
     d41:	7d 07                	jge    d4a <hoare_slots_monitor_stopadding+0x30>
			return -1;
     d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d48:	eb 1c                	jmp    d66 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d4a:	8b 45 08             	mov    0x8(%ebp),%eax
     d4d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d54:	8b 45 08             	mov    0x8(%ebp),%eax
     d57:	8b 00                	mov    (%eax),%eax
     d59:	89 04 24             	mov    %eax,(%esp)
     d5c:	e8 46 f6 ff ff       	call   3a7 <kthread_mutex_unlock>

		return 0;
     d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d66:	c9                   	leave  
     d67:	c3                   	ret    

00000d68 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     d68:	55                   	push   %ebp
     d69:	89 e5                	mov    %esp,%ebp
     d6b:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     d6e:	e8 1c f6 ff ff       	call   38f <kthread_mutex_alloc>
     d73:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d7a:	79 07                	jns    d83 <hoare_cond_alloc+0x1b>
		return 0;
     d7c:	b8 00 00 00 00       	mov    $0x0,%eax
     d81:	eb 24                	jmp    da7 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     d83:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d8a:	e8 f4 f9 ff ff       	call   783 <malloc>
     d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d98:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     da7:	c9                   	leave  
     da8:	c3                   	ret    

00000da9 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     da9:	55                   	push   %ebp
     daa:	89 e5                	mov    %esp,%ebp
     dac:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     daf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     db3:	75 07                	jne    dbc <hoare_cond_dealloc+0x13>
			return -1;
     db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dba:	eb 35                	jmp    df1 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     dbc:	8b 45 08             	mov    0x8(%ebp),%eax
     dbf:	8b 00                	mov    (%eax),%eax
     dc1:	89 04 24             	mov    %eax,(%esp)
     dc4:	e8 de f5 ff ff       	call   3a7 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     dc9:	8b 45 08             	mov    0x8(%ebp),%eax
     dcc:	8b 00                	mov    (%eax),%eax
     dce:	89 04 24             	mov    %eax,(%esp)
     dd1:	e8 c1 f5 ff ff       	call   397 <kthread_mutex_dealloc>
     dd6:	85 c0                	test   %eax,%eax
     dd8:	79 07                	jns    de1 <hoare_cond_dealloc+0x38>
			return -1;
     dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ddf:	eb 10                	jmp    df1 <hoare_cond_dealloc+0x48>

		free (hCond);
     de1:	8b 45 08             	mov    0x8(%ebp),%eax
     de4:	89 04 24             	mov    %eax,(%esp)
     de7:	e8 5e f8 ff ff       	call   64a <free>
		return 0;
     dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
     df1:	c9                   	leave  
     df2:	c3                   	ret    

00000df3 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     df3:	55                   	push   %ebp
     df4:	89 e5                	mov    %esp,%ebp
     df6:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     dfd:	75 07                	jne    e06 <hoare_cond_wait+0x13>
			return -1;
     dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e04:	eb 42                	jmp    e48 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     e06:	8b 45 08             	mov    0x8(%ebp),%eax
     e09:	8b 40 04             	mov    0x4(%eax),%eax
     e0c:	8d 50 01             	lea    0x1(%eax),%edx
     e0f:	8b 45 08             	mov    0x8(%ebp),%eax
     e12:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     e15:	8b 45 08             	mov    0x8(%ebp),%eax
     e18:	8b 00                	mov    (%eax),%eax
     e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e21:	89 04 24             	mov    %eax,(%esp)
     e24:	e8 86 f5 ff ff       	call   3af <kthread_mutex_yieldlock>
     e29:	85 c0                	test   %eax,%eax
     e2b:	79 16                	jns    e43 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     e2d:	8b 45 08             	mov    0x8(%ebp),%eax
     e30:	8b 40 04             	mov    0x4(%eax),%eax
     e33:	8d 50 ff             	lea    -0x1(%eax),%edx
     e36:	8b 45 08             	mov    0x8(%ebp),%eax
     e39:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e41:	eb 05                	jmp    e48 <hoare_cond_wait+0x55>
		}

	return 0;
     e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e48:	c9                   	leave  
     e49:	c3                   	ret    

00000e4a <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     e4a:	55                   	push   %ebp
     e4b:	89 e5                	mov    %esp,%ebp
     e4d:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e54:	75 07                	jne    e5d <hoare_cond_signal+0x13>
		return -1;
     e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e5b:	eb 6b                	jmp    ec8 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     e5d:	8b 45 08             	mov    0x8(%ebp),%eax
     e60:	8b 40 04             	mov    0x4(%eax),%eax
     e63:	85 c0                	test   %eax,%eax
     e65:	7e 3d                	jle    ea4 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     e67:	8b 45 08             	mov    0x8(%ebp),%eax
     e6a:	8b 40 04             	mov    0x4(%eax),%eax
     e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
     e70:	8b 45 08             	mov    0x8(%ebp),%eax
     e73:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     e76:	8b 45 08             	mov    0x8(%ebp),%eax
     e79:	8b 00                	mov    (%eax),%eax
     e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
     e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
     e82:	89 04 24             	mov    %eax,(%esp)
     e85:	e8 25 f5 ff ff       	call   3af <kthread_mutex_yieldlock>
     e8a:	85 c0                	test   %eax,%eax
     e8c:	79 16                	jns    ea4 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     e8e:	8b 45 08             	mov    0x8(%ebp),%eax
     e91:	8b 40 04             	mov    0x4(%eax),%eax
     e94:	8d 50 01             	lea    0x1(%eax),%edx
     e97:	8b 45 08             	mov    0x8(%ebp),%eax
     e9a:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea2:	eb 24                	jmp    ec8 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     ea4:	8b 45 08             	mov    0x8(%ebp),%eax
     ea7:	8b 00                	mov    (%eax),%eax
     ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
     ead:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb0:	89 04 24             	mov    %eax,(%esp)
     eb3:	e8 f7 f4 ff ff       	call   3af <kthread_mutex_yieldlock>
     eb8:	85 c0                	test   %eax,%eax
     eba:	79 07                	jns    ec3 <hoare_cond_signal+0x79>

    			return -1;
     ebc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ec1:	eb 05                	jmp    ec8 <hoare_cond_signal+0x7e>
    }

	return 0;
     ec3:	b8 00 00 00 00       	mov    $0x0,%eax

}
     ec8:	c9                   	leave  
     ec9:	c3                   	ret    

00000eca <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     eca:	55                   	push   %ebp
     ecb:	89 e5                	mov    %esp,%ebp
     ecd:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ed0:	e8 ba f4 ff ff       	call   38f <kthread_mutex_alloc>
     ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     edc:	79 07                	jns    ee5 <mesa_cond_alloc+0x1b>
		return 0;
     ede:	b8 00 00 00 00       	mov    $0x0,%eax
     ee3:	eb 24                	jmp    f09 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
     ee5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     eec:	e8 92 f8 ff ff       	call   783 <malloc>
     ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
     ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     efa:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
     efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
     f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f09:	c9                   	leave  
     f0a:	c3                   	ret    

00000f0b <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
     f0b:	55                   	push   %ebp
     f0c:	89 e5                	mov    %esp,%ebp
     f0e:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
     f11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f15:	75 07                	jne    f1e <mesa_cond_dealloc+0x13>
		return -1;
     f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f1c:	eb 35                	jmp    f53 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
     f1e:	8b 45 08             	mov    0x8(%ebp),%eax
     f21:	8b 00                	mov    (%eax),%eax
     f23:	89 04 24             	mov    %eax,(%esp)
     f26:	e8 7c f4 ff ff       	call   3a7 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
     f2b:	8b 45 08             	mov    0x8(%ebp),%eax
     f2e:	8b 00                	mov    (%eax),%eax
     f30:	89 04 24             	mov    %eax,(%esp)
     f33:	e8 5f f4 ff ff       	call   397 <kthread_mutex_dealloc>
     f38:	85 c0                	test   %eax,%eax
     f3a:	79 07                	jns    f43 <mesa_cond_dealloc+0x38>
		return -1;
     f3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f41:	eb 10                	jmp    f53 <mesa_cond_dealloc+0x48>

	free (mCond);
     f43:	8b 45 08             	mov    0x8(%ebp),%eax
     f46:	89 04 24             	mov    %eax,(%esp)
     f49:	e8 fc f6 ff ff       	call   64a <free>
	return 0;
     f4e:	b8 00 00 00 00       	mov    $0x0,%eax

}
     f53:	c9                   	leave  
     f54:	c3                   	ret    

00000f55 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
     f55:	55                   	push   %ebp
     f56:	89 e5                	mov    %esp,%ebp
     f58:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     f5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f5f:	75 07                	jne    f68 <mesa_cond_wait+0x13>
		return -1;
     f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f66:	eb 55                	jmp    fbd <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
     f68:	8b 45 08             	mov    0x8(%ebp),%eax
     f6b:	8b 40 04             	mov    0x4(%eax),%eax
     f6e:	8d 50 01             	lea    0x1(%eax),%edx
     f71:	8b 45 08             	mov    0x8(%ebp),%eax
     f74:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f77:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7a:	89 04 24             	mov    %eax,(%esp)
     f7d:	e8 25 f4 ff ff       	call   3a7 <kthread_mutex_unlock>
     f82:	85 c0                	test   %eax,%eax
     f84:	79 27                	jns    fad <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
     f86:	8b 45 08             	mov    0x8(%ebp),%eax
     f89:	8b 00                	mov    (%eax),%eax
     f8b:	89 04 24             	mov    %eax,(%esp)
     f8e:	e8 0c f4 ff ff       	call   39f <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f93:	85 c0                	test   %eax,%eax
     f95:	79 16                	jns    fad <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
     f97:	8b 45 08             	mov    0x8(%ebp),%eax
     f9a:	8b 40 04             	mov    0x4(%eax),%eax
     f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
     fa0:	8b 45 08             	mov    0x8(%ebp),%eax
     fa3:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
     fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fab:	eb 10                	jmp    fbd <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
     fad:	8b 45 0c             	mov    0xc(%ebp),%eax
     fb0:	89 04 24             	mov    %eax,(%esp)
     fb3:	e8 e7 f3 ff ff       	call   39f <kthread_mutex_lock>
	return 0;
     fb8:	b8 00 00 00 00       	mov    $0x0,%eax


}
     fbd:	c9                   	leave  
     fbe:	c3                   	ret    

00000fbf <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
     fbf:	55                   	push   %ebp
     fc0:	89 e5                	mov    %esp,%ebp
     fc2:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     fc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fc9:	75 07                	jne    fd2 <mesa_cond_signal+0x13>
		return -1;
     fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fd0:	eb 5d                	jmp    102f <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
     fd2:	8b 45 08             	mov    0x8(%ebp),%eax
     fd5:	8b 40 04             	mov    0x4(%eax),%eax
     fd8:	85 c0                	test   %eax,%eax
     fda:	7e 36                	jle    1012 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
     fdc:	8b 45 08             	mov    0x8(%ebp),%eax
     fdf:	8b 40 04             	mov    0x4(%eax),%eax
     fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
     fe5:	8b 45 08             	mov    0x8(%ebp),%eax
     fe8:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
     feb:	8b 45 08             	mov    0x8(%ebp),%eax
     fee:	8b 00                	mov    (%eax),%eax
     ff0:	89 04 24             	mov    %eax,(%esp)
     ff3:	e8 af f3 ff ff       	call   3a7 <kthread_mutex_unlock>
     ff8:	85 c0                	test   %eax,%eax
     ffa:	78 16                	js     1012 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
     ffc:	8b 45 08             	mov    0x8(%ebp),%eax
     fff:	8b 40 04             	mov    0x4(%eax),%eax
    1002:	8d 50 01             	lea    0x1(%eax),%edx
    1005:	8b 45 08             	mov    0x8(%ebp),%eax
    1008:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    100b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1010:	eb 1d                	jmp    102f <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1012:	8b 45 08             	mov    0x8(%ebp),%eax
    1015:	8b 00                	mov    (%eax),%eax
    1017:	89 04 24             	mov    %eax,(%esp)
    101a:	e8 88 f3 ff ff       	call   3a7 <kthread_mutex_unlock>
    101f:	85 c0                	test   %eax,%eax
    1021:	79 07                	jns    102a <mesa_cond_signal+0x6b>

		return -1;
    1023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1028:	eb 05                	jmp    102f <mesa_cond_signal+0x70>
	}
	return 0;
    102a:	b8 00 00 00 00       	mov    $0x0,%eax

}
    102f:	c9                   	leave  
    1030:	c3                   	ret    
