
_mkdir:     file format elf32-i386


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

  if(argc < 2){
       9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
       d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
       f:	c7 44 24 04 59 10 00 	movl   $0x1059,0x4(%esp)
      16:	00 
      17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      1e:	e8 9c 04 00 00       	call   4bf <printf>
    exit();
      23:	e8 cf 02 00 00       	call   2f7 <exit>
  }

  for(i = 1; i < argc; i++){
      28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
      2f:	00 
      30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
      32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
      3d:	8b 45 0c             	mov    0xc(%ebp),%eax
      40:	01 d0                	add    %edx,%eax
      42:	8b 00                	mov    (%eax),%eax
      44:	89 04 24             	mov    %eax,(%esp)
      47:	e8 13 03 00 00       	call   35f <mkdir>
      4c:	85 c0                	test   %eax,%eax
      4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
      5b:	8b 45 0c             	mov    0xc(%ebp),%eax
      5e:	01 d0                	add    %edx,%eax
      60:	8b 00                	mov    (%eax),%eax
      62:	89 44 24 08          	mov    %eax,0x8(%esp)
      66:	c7 44 24 04 70 10 00 	movl   $0x1070,0x4(%esp)
      6d:	00 
      6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      75:	e8 45 04 00 00       	call   4bf <printf>
      break;
      7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
      7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
      81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      85:	3b 45 08             	cmp    0x8(%ebp),%eax
      88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
      8a:	e8 68 02 00 00       	call   2f7 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
      8f:	55                   	push   %ebp
      90:	89 e5                	mov    %esp,%ebp
      92:	57                   	push   %edi
      93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
      94:	8b 4d 08             	mov    0x8(%ebp),%ecx
      97:	8b 55 10             	mov    0x10(%ebp),%edx
      9a:	8b 45 0c             	mov    0xc(%ebp),%eax
      9d:	89 cb                	mov    %ecx,%ebx
      9f:	89 df                	mov    %ebx,%edi
      a1:	89 d1                	mov    %edx,%ecx
      a3:	fc                   	cld    
      a4:	f3 aa                	rep stos %al,%es:(%edi)
      a6:	89 ca                	mov    %ecx,%edx
      a8:	89 fb                	mov    %edi,%ebx
      aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
      ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
      b0:	5b                   	pop    %ebx
      b1:	5f                   	pop    %edi
      b2:	5d                   	pop    %ebp
      b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
      b4:	55                   	push   %ebp
      b5:	89 e5                	mov    %esp,%ebp
      b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
      ba:	8b 45 08             	mov    0x8(%ebp),%eax
      bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
      c0:	90                   	nop
      c1:	8b 45 08             	mov    0x8(%ebp),%eax
      c4:	8d 50 01             	lea    0x1(%eax),%edx
      c7:	89 55 08             	mov    %edx,0x8(%ebp)
      ca:	8b 55 0c             	mov    0xc(%ebp),%edx
      cd:	8d 4a 01             	lea    0x1(%edx),%ecx
      d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
      d3:	0f b6 12             	movzbl (%edx),%edx
      d6:	88 10                	mov    %dl,(%eax)
      d8:	0f b6 00             	movzbl (%eax),%eax
      db:	84 c0                	test   %al,%al
      dd:	75 e2                	jne    c1 <strcpy+0xd>
    ;
  return os;
      df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
      e2:	c9                   	leave  
      e3:	c3                   	ret    

000000e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
      e4:	55                   	push   %ebp
      e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
      e7:	eb 08                	jmp    f1 <strcmp+0xd>
    p++, q++;
      e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
      ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
      f1:	8b 45 08             	mov    0x8(%ebp),%eax
      f4:	0f b6 00             	movzbl (%eax),%eax
      f7:	84 c0                	test   %al,%al
      f9:	74 10                	je     10b <strcmp+0x27>
      fb:	8b 45 08             	mov    0x8(%ebp),%eax
      fe:	0f b6 10             	movzbl (%eax),%edx
     101:	8b 45 0c             	mov    0xc(%ebp),%eax
     104:	0f b6 00             	movzbl (%eax),%eax
     107:	38 c2                	cmp    %al,%dl
     109:	74 de                	je     e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     10b:	8b 45 08             	mov    0x8(%ebp),%eax
     10e:	0f b6 00             	movzbl (%eax),%eax
     111:	0f b6 d0             	movzbl %al,%edx
     114:	8b 45 0c             	mov    0xc(%ebp),%eax
     117:	0f b6 00             	movzbl (%eax),%eax
     11a:	0f b6 c0             	movzbl %al,%eax
     11d:	29 c2                	sub    %eax,%edx
     11f:	89 d0                	mov    %edx,%eax
}
     121:	5d                   	pop    %ebp
     122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(char *s)
{
     123:	55                   	push   %ebp
     124:	89 e5                	mov    %esp,%ebp
     126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     130:	eb 04                	jmp    136 <strlen+0x13>
     132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     136:	8b 55 fc             	mov    -0x4(%ebp),%edx
     139:	8b 45 08             	mov    0x8(%ebp),%eax
     13c:	01 d0                	add    %edx,%eax
     13e:	0f b6 00             	movzbl (%eax),%eax
     141:	84 c0                	test   %al,%al
     143:	75 ed                	jne    132 <strlen+0xf>
    ;
  return n;
     145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     148:	c9                   	leave  
     149:	c3                   	ret    

0000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
     14a:	55                   	push   %ebp
     14b:	89 e5                	mov    %esp,%ebp
     14d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     150:	8b 45 10             	mov    0x10(%ebp),%eax
     153:	89 44 24 08          	mov    %eax,0x8(%esp)
     157:	8b 45 0c             	mov    0xc(%ebp),%eax
     15a:	89 44 24 04          	mov    %eax,0x4(%esp)
     15e:	8b 45 08             	mov    0x8(%ebp),%eax
     161:	89 04 24             	mov    %eax,(%esp)
     164:	e8 26 ff ff ff       	call   8f <stosb>
  return dst;
     169:	8b 45 08             	mov    0x8(%ebp),%eax
}
     16c:	c9                   	leave  
     16d:	c3                   	ret    

0000016e <strchr>:

char*
strchr(const char *s, char c)
{
     16e:	55                   	push   %ebp
     16f:	89 e5                	mov    %esp,%ebp
     171:	83 ec 04             	sub    $0x4,%esp
     174:	8b 45 0c             	mov    0xc(%ebp),%eax
     177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     17a:	eb 14                	jmp    190 <strchr+0x22>
    if(*s == c)
     17c:	8b 45 08             	mov    0x8(%ebp),%eax
     17f:	0f b6 00             	movzbl (%eax),%eax
     182:	3a 45 fc             	cmp    -0x4(%ebp),%al
     185:	75 05                	jne    18c <strchr+0x1e>
      return (char*)s;
     187:	8b 45 08             	mov    0x8(%ebp),%eax
     18a:	eb 13                	jmp    19f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     190:	8b 45 08             	mov    0x8(%ebp),%eax
     193:	0f b6 00             	movzbl (%eax),%eax
     196:	84 c0                	test   %al,%al
     198:	75 e2                	jne    17c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     19a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     19f:	c9                   	leave  
     1a0:	c3                   	ret    

000001a1 <gets>:

char*
gets(char *buf, int max)
{
     1a1:	55                   	push   %ebp
     1a2:	89 e5                	mov    %esp,%ebp
     1a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     1ae:	eb 4c                	jmp    1fc <gets+0x5b>
    cc = read(0, &c, 1);
     1b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     1b7:	00 
     1b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
     1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
     1bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1c6:	e8 44 01 00 00       	call   30f <read>
     1cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     1ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1d2:	7f 02                	jg     1d6 <gets+0x35>
      break;
     1d4:	eb 31                	jmp    207 <gets+0x66>
    buf[i++] = c;
     1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1d9:	8d 50 01             	lea    0x1(%eax),%edx
     1dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
     1df:	89 c2                	mov    %eax,%edx
     1e1:	8b 45 08             	mov    0x8(%ebp),%eax
     1e4:	01 c2                	add    %eax,%edx
     1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1f0:	3c 0a                	cmp    $0xa,%al
     1f2:	74 13                	je     207 <gets+0x66>
     1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     1f8:	3c 0d                	cmp    $0xd,%al
     1fa:	74 0b                	je     207 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ff:	83 c0 01             	add    $0x1,%eax
     202:	3b 45 0c             	cmp    0xc(%ebp),%eax
     205:	7c a9                	jl     1b0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     207:	8b 55 f4             	mov    -0xc(%ebp),%edx
     20a:	8b 45 08             	mov    0x8(%ebp),%eax
     20d:	01 d0                	add    %edx,%eax
     20f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     212:	8b 45 08             	mov    0x8(%ebp),%eax
}
     215:	c9                   	leave  
     216:	c3                   	ret    

00000217 <stat>:

int
stat(char *n, struct stat *st)
{
     217:	55                   	push   %ebp
     218:	89 e5                	mov    %esp,%ebp
     21a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     21d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     224:	00 
     225:	8b 45 08             	mov    0x8(%ebp),%eax
     228:	89 04 24             	mov    %eax,(%esp)
     22b:	e8 07 01 00 00       	call   337 <open>
     230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	79 07                	jns    240 <stat+0x29>
    return -1;
     239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     23e:	eb 23                	jmp    263 <stat+0x4c>
  r = fstat(fd, st);
     240:	8b 45 0c             	mov    0xc(%ebp),%eax
     243:	89 44 24 04          	mov    %eax,0x4(%esp)
     247:	8b 45 f4             	mov    -0xc(%ebp),%eax
     24a:	89 04 24             	mov    %eax,(%esp)
     24d:	e8 fd 00 00 00       	call   34f <fstat>
     252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     255:	8b 45 f4             	mov    -0xc(%ebp),%eax
     258:	89 04 24             	mov    %eax,(%esp)
     25b:	e8 bf 00 00 00       	call   31f <close>
  return r;
     260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     263:	c9                   	leave  
     264:	c3                   	ret    

00000265 <atoi>:

int
atoi(const char *s)
{
     265:	55                   	push   %ebp
     266:	89 e5                	mov    %esp,%ebp
     268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     26b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     272:	eb 25                	jmp    299 <atoi+0x34>
    n = n*10 + *s++ - '0';
     274:	8b 55 fc             	mov    -0x4(%ebp),%edx
     277:	89 d0                	mov    %edx,%eax
     279:	c1 e0 02             	shl    $0x2,%eax
     27c:	01 d0                	add    %edx,%eax
     27e:	01 c0                	add    %eax,%eax
     280:	89 c1                	mov    %eax,%ecx
     282:	8b 45 08             	mov    0x8(%ebp),%eax
     285:	8d 50 01             	lea    0x1(%eax),%edx
     288:	89 55 08             	mov    %edx,0x8(%ebp)
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	0f be c0             	movsbl %al,%eax
     291:	01 c8                	add    %ecx,%eax
     293:	83 e8 30             	sub    $0x30,%eax
     296:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     299:	8b 45 08             	mov    0x8(%ebp),%eax
     29c:	0f b6 00             	movzbl (%eax),%eax
     29f:	3c 2f                	cmp    $0x2f,%al
     2a1:	7e 0a                	jle    2ad <atoi+0x48>
     2a3:	8b 45 08             	mov    0x8(%ebp),%eax
     2a6:	0f b6 00             	movzbl (%eax),%eax
     2a9:	3c 39                	cmp    $0x39,%al
     2ab:	7e c7                	jle    274 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     2ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     2b0:	c9                   	leave  
     2b1:	c3                   	ret    

000002b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     2b2:	55                   	push   %ebp
     2b3:	89 e5                	mov    %esp,%ebp
     2b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     2b8:	8b 45 08             	mov    0x8(%ebp),%eax
     2bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     2be:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     2c4:	eb 17                	jmp    2dd <memmove+0x2b>
    *dst++ = *src++;
     2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     2c9:	8d 50 01             	lea    0x1(%eax),%edx
     2cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
     2cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
     2d2:	8d 4a 01             	lea    0x1(%edx),%ecx
     2d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     2d8:	0f b6 12             	movzbl (%edx),%edx
     2db:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     2dd:	8b 45 10             	mov    0x10(%ebp),%eax
     2e0:	8d 50 ff             	lea    -0x1(%eax),%edx
     2e3:	89 55 10             	mov    %edx,0x10(%ebp)
     2e6:	85 c0                	test   %eax,%eax
     2e8:	7f dc                	jg     2c6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2ed:	c9                   	leave  
     2ee:	c3                   	ret    

000002ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     2ef:	b8 01 00 00 00       	mov    $0x1,%eax
     2f4:	cd 40                	int    $0x40
     2f6:	c3                   	ret    

000002f7 <exit>:
SYSCALL(exit)
     2f7:	b8 02 00 00 00       	mov    $0x2,%eax
     2fc:	cd 40                	int    $0x40
     2fe:	c3                   	ret    

000002ff <wait>:
SYSCALL(wait)
     2ff:	b8 03 00 00 00       	mov    $0x3,%eax
     304:	cd 40                	int    $0x40
     306:	c3                   	ret    

00000307 <pipe>:
SYSCALL(pipe)
     307:	b8 04 00 00 00       	mov    $0x4,%eax
     30c:	cd 40                	int    $0x40
     30e:	c3                   	ret    

0000030f <read>:
SYSCALL(read)
     30f:	b8 05 00 00 00       	mov    $0x5,%eax
     314:	cd 40                	int    $0x40
     316:	c3                   	ret    

00000317 <write>:
SYSCALL(write)
     317:	b8 10 00 00 00       	mov    $0x10,%eax
     31c:	cd 40                	int    $0x40
     31e:	c3                   	ret    

0000031f <close>:
SYSCALL(close)
     31f:	b8 15 00 00 00       	mov    $0x15,%eax
     324:	cd 40                	int    $0x40
     326:	c3                   	ret    

00000327 <kill>:
SYSCALL(kill)
     327:	b8 06 00 00 00       	mov    $0x6,%eax
     32c:	cd 40                	int    $0x40
     32e:	c3                   	ret    

0000032f <exec>:
SYSCALL(exec)
     32f:	b8 07 00 00 00       	mov    $0x7,%eax
     334:	cd 40                	int    $0x40
     336:	c3                   	ret    

00000337 <open>:
SYSCALL(open)
     337:	b8 0f 00 00 00       	mov    $0xf,%eax
     33c:	cd 40                	int    $0x40
     33e:	c3                   	ret    

0000033f <mknod>:
SYSCALL(mknod)
     33f:	b8 11 00 00 00       	mov    $0x11,%eax
     344:	cd 40                	int    $0x40
     346:	c3                   	ret    

00000347 <unlink>:
SYSCALL(unlink)
     347:	b8 12 00 00 00       	mov    $0x12,%eax
     34c:	cd 40                	int    $0x40
     34e:	c3                   	ret    

0000034f <fstat>:
SYSCALL(fstat)
     34f:	b8 08 00 00 00       	mov    $0x8,%eax
     354:	cd 40                	int    $0x40
     356:	c3                   	ret    

00000357 <link>:
SYSCALL(link)
     357:	b8 13 00 00 00       	mov    $0x13,%eax
     35c:	cd 40                	int    $0x40
     35e:	c3                   	ret    

0000035f <mkdir>:
SYSCALL(mkdir)
     35f:	b8 14 00 00 00       	mov    $0x14,%eax
     364:	cd 40                	int    $0x40
     366:	c3                   	ret    

00000367 <chdir>:
SYSCALL(chdir)
     367:	b8 09 00 00 00       	mov    $0x9,%eax
     36c:	cd 40                	int    $0x40
     36e:	c3                   	ret    

0000036f <dup>:
SYSCALL(dup)
     36f:	b8 0a 00 00 00       	mov    $0xa,%eax
     374:	cd 40                	int    $0x40
     376:	c3                   	ret    

00000377 <getpid>:
SYSCALL(getpid)
     377:	b8 0b 00 00 00       	mov    $0xb,%eax
     37c:	cd 40                	int    $0x40
     37e:	c3                   	ret    

0000037f <sbrk>:
SYSCALL(sbrk)
     37f:	b8 0c 00 00 00       	mov    $0xc,%eax
     384:	cd 40                	int    $0x40
     386:	c3                   	ret    

00000387 <sleep>:
SYSCALL(sleep)
     387:	b8 0d 00 00 00       	mov    $0xd,%eax
     38c:	cd 40                	int    $0x40
     38e:	c3                   	ret    

0000038f <uptime>:
SYSCALL(uptime)
     38f:	b8 0e 00 00 00       	mov    $0xe,%eax
     394:	cd 40                	int    $0x40
     396:	c3                   	ret    

00000397 <kthread_create>:




SYSCALL(kthread_create)
     397:	b8 16 00 00 00       	mov    $0x16,%eax
     39c:	cd 40                	int    $0x40
     39e:	c3                   	ret    

0000039f <kthread_id>:
SYSCALL(kthread_id)
     39f:	b8 17 00 00 00       	mov    $0x17,%eax
     3a4:	cd 40                	int    $0x40
     3a6:	c3                   	ret    

000003a7 <kthread_exit>:
SYSCALL(kthread_exit)
     3a7:	b8 18 00 00 00       	mov    $0x18,%eax
     3ac:	cd 40                	int    $0x40
     3ae:	c3                   	ret    

000003af <kthread_join>:
SYSCALL(kthread_join)
     3af:	b8 19 00 00 00       	mov    $0x19,%eax
     3b4:	cd 40                	int    $0x40
     3b6:	c3                   	ret    

000003b7 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     3b7:	b8 1a 00 00 00       	mov    $0x1a,%eax
     3bc:	cd 40                	int    $0x40
     3be:	c3                   	ret    

000003bf <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     3bf:	b8 1b 00 00 00       	mov    $0x1b,%eax
     3c4:	cd 40                	int    $0x40
     3c6:	c3                   	ret    

000003c7 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     3c7:	b8 1c 00 00 00       	mov    $0x1c,%eax
     3cc:	cd 40                	int    $0x40
     3ce:	c3                   	ret    

000003cf <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     3cf:	b8 1d 00 00 00       	mov    $0x1d,%eax
     3d4:	cd 40                	int    $0x40
     3d6:	c3                   	ret    

000003d7 <kthread_mutex_yieldlock>:
     3d7:	b8 1e 00 00 00       	mov    $0x1e,%eax
     3dc:	cd 40                	int    $0x40
     3de:	c3                   	ret    

000003df <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     3df:	55                   	push   %ebp
     3e0:	89 e5                	mov    %esp,%ebp
     3e2:	83 ec 18             	sub    $0x18,%esp
     3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     3eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     3f2:	00 
     3f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
     3f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     3fa:	8b 45 08             	mov    0x8(%ebp),%eax
     3fd:	89 04 24             	mov    %eax,(%esp)
     400:	e8 12 ff ff ff       	call   317 <write>
}
     405:	c9                   	leave  
     406:	c3                   	ret    

00000407 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     407:	55                   	push   %ebp
     408:	89 e5                	mov    %esp,%ebp
     40a:	56                   	push   %esi
     40b:	53                   	push   %ebx
     40c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     40f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     416:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     41a:	74 17                	je     433 <printint+0x2c>
     41c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     420:	79 11                	jns    433 <printint+0x2c>
    neg = 1;
     422:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     429:	8b 45 0c             	mov    0xc(%ebp),%eax
     42c:	f7 d8                	neg    %eax
     42e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     431:	eb 06                	jmp    439 <printint+0x32>
  } else {
    x = xx;
     433:	8b 45 0c             	mov    0xc(%ebp),%eax
     436:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     440:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     443:	8d 41 01             	lea    0x1(%ecx),%eax
     446:	89 45 f4             	mov    %eax,-0xc(%ebp)
     449:	8b 5d 10             	mov    0x10(%ebp),%ebx
     44c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     44f:	ba 00 00 00 00       	mov    $0x0,%edx
     454:	f7 f3                	div    %ebx
     456:	89 d0                	mov    %edx,%eax
     458:	0f b6 80 18 15 00 00 	movzbl 0x1518(%eax),%eax
     45f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     463:	8b 75 10             	mov    0x10(%ebp),%esi
     466:	8b 45 ec             	mov    -0x14(%ebp),%eax
     469:	ba 00 00 00 00       	mov    $0x0,%edx
     46e:	f7 f6                	div    %esi
     470:	89 45 ec             	mov    %eax,-0x14(%ebp)
     473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     477:	75 c7                	jne    440 <printint+0x39>
  if(neg)
     479:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     47d:	74 10                	je     48f <printint+0x88>
    buf[i++] = '-';
     47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     482:	8d 50 01             	lea    0x1(%eax),%edx
     485:	89 55 f4             	mov    %edx,-0xc(%ebp)
     488:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     48d:	eb 1f                	jmp    4ae <printint+0xa7>
     48f:	eb 1d                	jmp    4ae <printint+0xa7>
    putc(fd, buf[i]);
     491:	8d 55 dc             	lea    -0x24(%ebp),%edx
     494:	8b 45 f4             	mov    -0xc(%ebp),%eax
     497:	01 d0                	add    %edx,%eax
     499:	0f b6 00             	movzbl (%eax),%eax
     49c:	0f be c0             	movsbl %al,%eax
     49f:	89 44 24 04          	mov    %eax,0x4(%esp)
     4a3:	8b 45 08             	mov    0x8(%ebp),%eax
     4a6:	89 04 24             	mov    %eax,(%esp)
     4a9:	e8 31 ff ff ff       	call   3df <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     4ae:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     4b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4b6:	79 d9                	jns    491 <printint+0x8a>
    putc(fd, buf[i]);
}
     4b8:	83 c4 30             	add    $0x30,%esp
     4bb:	5b                   	pop    %ebx
     4bc:	5e                   	pop    %esi
     4bd:	5d                   	pop    %ebp
     4be:	c3                   	ret    

000004bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     4bf:	55                   	push   %ebp
     4c0:	89 e5                	mov    %esp,%ebp
     4c2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     4c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     4cc:	8d 45 0c             	lea    0xc(%ebp),%eax
     4cf:	83 c0 04             	add    $0x4,%eax
     4d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     4d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     4dc:	e9 7c 01 00 00       	jmp    65d <printf+0x19e>
    c = fmt[i] & 0xff;
     4e1:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4e7:	01 d0                	add    %edx,%eax
     4e9:	0f b6 00             	movzbl (%eax),%eax
     4ec:	0f be c0             	movsbl %al,%eax
     4ef:	25 ff 00 00 00       	and    $0xff,%eax
     4f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     4f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4fb:	75 2c                	jne    529 <printf+0x6a>
      if(c == '%'){
     4fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     501:	75 0c                	jne    50f <printf+0x50>
        state = '%';
     503:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     50a:	e9 4a 01 00 00       	jmp    659 <printf+0x19a>
      } else {
        putc(fd, c);
     50f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     512:	0f be c0             	movsbl %al,%eax
     515:	89 44 24 04          	mov    %eax,0x4(%esp)
     519:	8b 45 08             	mov    0x8(%ebp),%eax
     51c:	89 04 24             	mov    %eax,(%esp)
     51f:	e8 bb fe ff ff       	call   3df <putc>
     524:	e9 30 01 00 00       	jmp    659 <printf+0x19a>
      }
    } else if(state == '%'){
     529:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     52d:	0f 85 26 01 00 00    	jne    659 <printf+0x19a>
      if(c == 'd'){
     533:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     537:	75 2d                	jne    566 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     539:	8b 45 e8             	mov    -0x18(%ebp),%eax
     53c:	8b 00                	mov    (%eax),%eax
     53e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     545:	00 
     546:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     54d:	00 
     54e:	89 44 24 04          	mov    %eax,0x4(%esp)
     552:	8b 45 08             	mov    0x8(%ebp),%eax
     555:	89 04 24             	mov    %eax,(%esp)
     558:	e8 aa fe ff ff       	call   407 <printint>
        ap++;
     55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     561:	e9 ec 00 00 00       	jmp    652 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     566:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     56a:	74 06                	je     572 <printf+0xb3>
     56c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     570:	75 2d                	jne    59f <printf+0xe0>
        printint(fd, *ap, 16, 0);
     572:	8b 45 e8             	mov    -0x18(%ebp),%eax
     575:	8b 00                	mov    (%eax),%eax
     577:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     57e:	00 
     57f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     586:	00 
     587:	89 44 24 04          	mov    %eax,0x4(%esp)
     58b:	8b 45 08             	mov    0x8(%ebp),%eax
     58e:	89 04 24             	mov    %eax,(%esp)
     591:	e8 71 fe ff ff       	call   407 <printint>
        ap++;
     596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     59a:	e9 b3 00 00 00       	jmp    652 <printf+0x193>
      } else if(c == 's'){
     59f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     5a3:	75 45                	jne    5ea <printf+0x12b>
        s = (char*)*ap;
     5a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5a8:	8b 00                	mov    (%eax),%eax
     5aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     5ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     5b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5b5:	75 09                	jne    5c0 <printf+0x101>
          s = "(null)";
     5b7:	c7 45 f4 8c 10 00 00 	movl   $0x108c,-0xc(%ebp)
        while(*s != 0){
     5be:	eb 1e                	jmp    5de <printf+0x11f>
     5c0:	eb 1c                	jmp    5de <printf+0x11f>
          putc(fd, *s);
     5c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c5:	0f b6 00             	movzbl (%eax),%eax
     5c8:	0f be c0             	movsbl %al,%eax
     5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
     5cf:	8b 45 08             	mov    0x8(%ebp),%eax
     5d2:	89 04 24             	mov    %eax,(%esp)
     5d5:	e8 05 fe ff ff       	call   3df <putc>
          s++;
     5da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e1:	0f b6 00             	movzbl (%eax),%eax
     5e4:	84 c0                	test   %al,%al
     5e6:	75 da                	jne    5c2 <printf+0x103>
     5e8:	eb 68                	jmp    652 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     5ea:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     5ee:	75 1d                	jne    60d <printf+0x14e>
        putc(fd, *ap);
     5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5f3:	8b 00                	mov    (%eax),%eax
     5f5:	0f be c0             	movsbl %al,%eax
     5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
     5fc:	8b 45 08             	mov    0x8(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 d8 fd ff ff       	call   3df <putc>
        ap++;
     607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     60b:	eb 45                	jmp    652 <printf+0x193>
      } else if(c == '%'){
     60d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     611:	75 17                	jne    62a <printf+0x16b>
        putc(fd, c);
     613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     616:	0f be c0             	movsbl %al,%eax
     619:	89 44 24 04          	mov    %eax,0x4(%esp)
     61d:	8b 45 08             	mov    0x8(%ebp),%eax
     620:	89 04 24             	mov    %eax,(%esp)
     623:	e8 b7 fd ff ff       	call   3df <putc>
     628:	eb 28                	jmp    652 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     62a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     631:	00 
     632:	8b 45 08             	mov    0x8(%ebp),%eax
     635:	89 04 24             	mov    %eax,(%esp)
     638:	e8 a2 fd ff ff       	call   3df <putc>
        putc(fd, c);
     63d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     640:	0f be c0             	movsbl %al,%eax
     643:	89 44 24 04          	mov    %eax,0x4(%esp)
     647:	8b 45 08             	mov    0x8(%ebp),%eax
     64a:	89 04 24             	mov    %eax,(%esp)
     64d:	e8 8d fd ff ff       	call   3df <putc>
      }
      state = 0;
     652:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     659:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     65d:	8b 55 0c             	mov    0xc(%ebp),%edx
     660:	8b 45 f0             	mov    -0x10(%ebp),%eax
     663:	01 d0                	add    %edx,%eax
     665:	0f b6 00             	movzbl (%eax),%eax
     668:	84 c0                	test   %al,%al
     66a:	0f 85 71 fe ff ff    	jne    4e1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     670:	c9                   	leave  
     671:	c3                   	ret    

00000672 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     672:	55                   	push   %ebp
     673:	89 e5                	mov    %esp,%ebp
     675:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     678:	8b 45 08             	mov    0x8(%ebp),%eax
     67b:	83 e8 08             	sub    $0x8,%eax
     67e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     681:	a1 34 15 00 00       	mov    0x1534,%eax
     686:	89 45 fc             	mov    %eax,-0x4(%ebp)
     689:	eb 24                	jmp    6af <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     68e:	8b 00                	mov    (%eax),%eax
     690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     693:	77 12                	ja     6a7 <free+0x35>
     695:	8b 45 f8             	mov    -0x8(%ebp),%eax
     698:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     69b:	77 24                	ja     6c1 <free+0x4f>
     69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6a0:	8b 00                	mov    (%eax),%eax
     6a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6a5:	77 1a                	ja     6c1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6aa:	8b 00                	mov    (%eax),%eax
     6ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
     6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     6b5:	76 d4                	jbe    68b <free+0x19>
     6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6ba:	8b 00                	mov    (%eax),%eax
     6bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     6bf:	76 ca                	jbe    68b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6c4:	8b 40 04             	mov    0x4(%eax),%eax
     6c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6d1:	01 c2                	add    %eax,%edx
     6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6d6:	8b 00                	mov    (%eax),%eax
     6d8:	39 c2                	cmp    %eax,%edx
     6da:	75 24                	jne    700 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6df:	8b 50 04             	mov    0x4(%eax),%edx
     6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6e5:	8b 00                	mov    (%eax),%eax
     6e7:	8b 40 04             	mov    0x4(%eax),%eax
     6ea:	01 c2                	add    %eax,%edx
     6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6ef:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     6f5:	8b 00                	mov    (%eax),%eax
     6f7:	8b 10                	mov    (%eax),%edx
     6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     6fc:	89 10                	mov    %edx,(%eax)
     6fe:	eb 0a                	jmp    70a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     700:	8b 45 fc             	mov    -0x4(%ebp),%eax
     703:	8b 10                	mov    (%eax),%edx
     705:	8b 45 f8             	mov    -0x8(%ebp),%eax
     708:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70d:	8b 40 04             	mov    0x4(%eax),%eax
     710:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     717:	8b 45 fc             	mov    -0x4(%ebp),%eax
     71a:	01 d0                	add    %edx,%eax
     71c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     71f:	75 20                	jne    741 <free+0xcf>
    p->s.size += bp->s.size;
     721:	8b 45 fc             	mov    -0x4(%ebp),%eax
     724:	8b 50 04             	mov    0x4(%eax),%edx
     727:	8b 45 f8             	mov    -0x8(%ebp),%eax
     72a:	8b 40 04             	mov    0x4(%eax),%eax
     72d:	01 c2                	add    %eax,%edx
     72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     732:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     735:	8b 45 f8             	mov    -0x8(%ebp),%eax
     738:	8b 10                	mov    (%eax),%edx
     73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     73d:	89 10                	mov    %edx,(%eax)
     73f:	eb 08                	jmp    749 <free+0xd7>
  } else
    p->s.ptr = bp;
     741:	8b 45 fc             	mov    -0x4(%ebp),%eax
     744:	8b 55 f8             	mov    -0x8(%ebp),%edx
     747:	89 10                	mov    %edx,(%eax)
  freep = p;
     749:	8b 45 fc             	mov    -0x4(%ebp),%eax
     74c:	a3 34 15 00 00       	mov    %eax,0x1534
}
     751:	c9                   	leave  
     752:	c3                   	ret    

00000753 <morecore>:

static Header*
morecore(uint nu)
{
     753:	55                   	push   %ebp
     754:	89 e5                	mov    %esp,%ebp
     756:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     759:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     760:	77 07                	ja     769 <morecore+0x16>
    nu = 4096;
     762:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     769:	8b 45 08             	mov    0x8(%ebp),%eax
     76c:	c1 e0 03             	shl    $0x3,%eax
     76f:	89 04 24             	mov    %eax,(%esp)
     772:	e8 08 fc ff ff       	call   37f <sbrk>
     777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     77a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     77e:	75 07                	jne    787 <morecore+0x34>
    return 0;
     780:	b8 00 00 00 00       	mov    $0x0,%eax
     785:	eb 22                	jmp    7a9 <morecore+0x56>
  hp = (Header*)p;
     787:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     790:	8b 55 08             	mov    0x8(%ebp),%edx
     793:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     796:	8b 45 f0             	mov    -0x10(%ebp),%eax
     799:	83 c0 08             	add    $0x8,%eax
     79c:	89 04 24             	mov    %eax,(%esp)
     79f:	e8 ce fe ff ff       	call   672 <free>
  return freep;
     7a4:	a1 34 15 00 00       	mov    0x1534,%eax
}
     7a9:	c9                   	leave  
     7aa:	c3                   	ret    

000007ab <malloc>:

void*
malloc(uint nbytes)
{
     7ab:	55                   	push   %ebp
     7ac:	89 e5                	mov    %esp,%ebp
     7ae:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     7b1:	8b 45 08             	mov    0x8(%ebp),%eax
     7b4:	83 c0 07             	add    $0x7,%eax
     7b7:	c1 e8 03             	shr    $0x3,%eax
     7ba:	83 c0 01             	add    $0x1,%eax
     7bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     7c0:	a1 34 15 00 00       	mov    0x1534,%eax
     7c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7cc:	75 23                	jne    7f1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     7ce:	c7 45 f0 2c 15 00 00 	movl   $0x152c,-0x10(%ebp)
     7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7d8:	a3 34 15 00 00       	mov    %eax,0x1534
     7dd:	a1 34 15 00 00       	mov    0x1534,%eax
     7e2:	a3 2c 15 00 00       	mov    %eax,0x152c
    base.s.size = 0;
     7e7:	c7 05 30 15 00 00 00 	movl   $0x0,0x1530
     7ee:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7f4:	8b 00                	mov    (%eax),%eax
     7f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fc:	8b 40 04             	mov    0x4(%eax),%eax
     7ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     802:	72 4d                	jb     851 <malloc+0xa6>
      if(p->s.size == nunits)
     804:	8b 45 f4             	mov    -0xc(%ebp),%eax
     807:	8b 40 04             	mov    0x4(%eax),%eax
     80a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     80d:	75 0c                	jne    81b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     812:	8b 10                	mov    (%eax),%edx
     814:	8b 45 f0             	mov    -0x10(%ebp),%eax
     817:	89 10                	mov    %edx,(%eax)
     819:	eb 26                	jmp    841 <malloc+0x96>
      else {
        p->s.size -= nunits;
     81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81e:	8b 40 04             	mov    0x4(%eax),%eax
     821:	2b 45 ec             	sub    -0x14(%ebp),%eax
     824:	89 c2                	mov    %eax,%edx
     826:	8b 45 f4             	mov    -0xc(%ebp),%eax
     829:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     82f:	8b 40 04             	mov    0x4(%eax),%eax
     832:	c1 e0 03             	shl    $0x3,%eax
     835:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     838:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     83e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     841:	8b 45 f0             	mov    -0x10(%ebp),%eax
     844:	a3 34 15 00 00       	mov    %eax,0x1534
      return (void*)(p + 1);
     849:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84c:	83 c0 08             	add    $0x8,%eax
     84f:	eb 38                	jmp    889 <malloc+0xde>
    }
    if(p == freep)
     851:	a1 34 15 00 00       	mov    0x1534,%eax
     856:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     859:	75 1b                	jne    876 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     85b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     85e:	89 04 24             	mov    %eax,(%esp)
     861:	e8 ed fe ff ff       	call   753 <morecore>
     866:	89 45 f4             	mov    %eax,-0xc(%ebp)
     869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     86d:	75 07                	jne    876 <malloc+0xcb>
        return 0;
     86f:	b8 00 00 00 00       	mov    $0x0,%eax
     874:	eb 13                	jmp    889 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     876:	8b 45 f4             	mov    -0xc(%ebp),%eax
     879:	89 45 f0             	mov    %eax,-0x10(%ebp)
     87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87f:	8b 00                	mov    (%eax),%eax
     881:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     884:	e9 70 ff ff ff       	jmp    7f9 <malloc+0x4e>
}
     889:	c9                   	leave  
     88a:	c3                   	ret    

0000088b <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     88b:	55                   	push   %ebp
     88c:	89 e5                	mov    %esp,%ebp
     88e:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     891:	e8 21 fb ff ff       	call   3b7 <kthread_mutex_alloc>
     896:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     89d:	79 0a                	jns    8a9 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     89f:	b8 00 00 00 00       	mov    $0x0,%eax
     8a4:	e9 8b 00 00 00       	jmp    934 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     8a9:	e8 44 06 00 00       	call   ef2 <mesa_cond_alloc>
     8ae:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     8b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8b5:	75 12                	jne    8c9 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ba:	89 04 24             	mov    %eax,(%esp)
     8bd:	e8 fd fa ff ff       	call   3bf <kthread_mutex_dealloc>
		return 0;
     8c2:	b8 00 00 00 00       	mov    $0x0,%eax
     8c7:	eb 6b                	jmp    934 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     8c9:	e8 24 06 00 00       	call   ef2 <mesa_cond_alloc>
     8ce:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     8d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8d5:	75 1d                	jne    8f4 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8da:	89 04 24             	mov    %eax,(%esp)
     8dd:	e8 dd fa ff ff       	call   3bf <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8e5:	89 04 24             	mov    %eax,(%esp)
     8e8:	e8 46 06 00 00       	call   f33 <mesa_cond_dealloc>
		return 0;
     8ed:	b8 00 00 00 00       	mov    $0x0,%eax
     8f2:	eb 40                	jmp    934 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     8f4:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     8fb:	e8 ab fe ff ff       	call   7ab <malloc>
     900:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     903:	8b 45 e8             	mov    -0x18(%ebp),%eax
     906:	8b 55 f0             	mov    -0x10(%ebp),%edx
     909:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     90c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     90f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     912:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     915:	8b 45 e8             	mov    -0x18(%ebp),%eax
     918:	8b 55 f4             	mov    -0xc(%ebp),%edx
     91b:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     91d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     920:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     927:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92a:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     931:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     934:	c9                   	leave  
     935:	c3                   	ret    

00000936 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     936:	55                   	push   %ebp
     937:	89 e5                	mov    %esp,%ebp
     939:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     93c:	8b 45 08             	mov    0x8(%ebp),%eax
     93f:	8b 00                	mov    (%eax),%eax
     941:	89 04 24             	mov    %eax,(%esp)
     944:	e8 76 fa ff ff       	call   3bf <kthread_mutex_dealloc>
     949:	85 c0                	test   %eax,%eax
     94b:	78 2e                	js     97b <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     94d:	8b 45 08             	mov    0x8(%ebp),%eax
     950:	8b 40 04             	mov    0x4(%eax),%eax
     953:	89 04 24             	mov    %eax,(%esp)
     956:	e8 97 05 00 00       	call   ef2 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     95b:	8b 45 08             	mov    0x8(%ebp),%eax
     95e:	8b 40 08             	mov    0x8(%eax),%eax
     961:	89 04 24             	mov    %eax,(%esp)
     964:	e8 89 05 00 00       	call   ef2 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     969:	8b 45 08             	mov    0x8(%ebp),%eax
     96c:	89 04 24             	mov    %eax,(%esp)
     96f:	e8 fe fc ff ff       	call   672 <free>
	return 0;
     974:	b8 00 00 00 00       	mov    $0x0,%eax
     979:	eb 05                	jmp    980 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     97b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     980:	c9                   	leave  
     981:	c3                   	ret    

00000982 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     982:	55                   	push   %ebp
     983:	89 e5                	mov    %esp,%ebp
     985:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     988:	8b 45 08             	mov    0x8(%ebp),%eax
     98b:	8b 40 10             	mov    0x10(%eax),%eax
     98e:	85 c0                	test   %eax,%eax
     990:	75 0a                	jne    99c <mesa_slots_monitor_addslots+0x1a>
		return -1;
     992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     997:	e9 81 00 00 00       	jmp    a1d <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     99c:	8b 45 08             	mov    0x8(%ebp),%eax
     99f:	8b 00                	mov    (%eax),%eax
     9a1:	89 04 24             	mov    %eax,(%esp)
     9a4:	e8 1e fa ff ff       	call   3c7 <kthread_mutex_lock>
     9a9:	83 f8 ff             	cmp    $0xffffffff,%eax
     9ac:	7d 07                	jge    9b5 <mesa_slots_monitor_addslots+0x33>
		return -1;
     9ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     9b3:	eb 68                	jmp    a1d <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     9b5:	eb 17                	jmp    9ce <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     9b7:	8b 45 08             	mov    0x8(%ebp),%eax
     9ba:	8b 10                	mov    (%eax),%edx
     9bc:	8b 45 08             	mov    0x8(%ebp),%eax
     9bf:	8b 40 08             	mov    0x8(%eax),%eax
     9c2:	89 54 24 04          	mov    %edx,0x4(%esp)
     9c6:	89 04 24             	mov    %eax,(%esp)
     9c9:	e8 af 05 00 00       	call   f7d <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     9ce:	8b 45 08             	mov    0x8(%ebp),%eax
     9d1:	8b 40 10             	mov    0x10(%eax),%eax
     9d4:	85 c0                	test   %eax,%eax
     9d6:	74 0a                	je     9e2 <mesa_slots_monitor_addslots+0x60>
     9d8:	8b 45 08             	mov    0x8(%ebp),%eax
     9db:	8b 40 0c             	mov    0xc(%eax),%eax
     9de:	85 c0                	test   %eax,%eax
     9e0:	7f d5                	jg     9b7 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     9e2:	8b 45 08             	mov    0x8(%ebp),%eax
     9e5:	8b 40 10             	mov    0x10(%eax),%eax
     9e8:	85 c0                	test   %eax,%eax
     9ea:	74 11                	je     9fd <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     9ec:	8b 45 08             	mov    0x8(%ebp),%eax
     9ef:	8b 50 0c             	mov    0xc(%eax),%edx
     9f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9f5:	01 c2                	add    %eax,%edx
     9f7:	8b 45 08             	mov    0x8(%ebp),%eax
     9fa:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     9fd:	8b 45 08             	mov    0x8(%ebp),%eax
     a00:	8b 40 04             	mov    0x4(%eax),%eax
     a03:	89 04 24             	mov    %eax,(%esp)
     a06:	e8 dc 05 00 00       	call   fe7 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     a0b:	8b 45 08             	mov    0x8(%ebp),%eax
     a0e:	8b 00                	mov    (%eax),%eax
     a10:	89 04 24             	mov    %eax,(%esp)
     a13:	e8 b7 f9 ff ff       	call   3cf <kthread_mutex_unlock>

	return 1;
     a18:	b8 01 00 00 00       	mov    $0x1,%eax


}
     a1d:	c9                   	leave  
     a1e:	c3                   	ret    

00000a1f <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     a1f:	55                   	push   %ebp
     a20:	89 e5                	mov    %esp,%ebp
     a22:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     a25:	8b 45 08             	mov    0x8(%ebp),%eax
     a28:	8b 40 10             	mov    0x10(%eax),%eax
     a2b:	85 c0                	test   %eax,%eax
     a2d:	75 07                	jne    a36 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a34:	eb 7f                	jmp    ab5 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     a36:	8b 45 08             	mov    0x8(%ebp),%eax
     a39:	8b 00                	mov    (%eax),%eax
     a3b:	89 04 24             	mov    %eax,(%esp)
     a3e:	e8 84 f9 ff ff       	call   3c7 <kthread_mutex_lock>
     a43:	83 f8 ff             	cmp    $0xffffffff,%eax
     a46:	7d 07                	jge    a4f <mesa_slots_monitor_takeslot+0x30>
		return -1;
     a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a4d:	eb 66                	jmp    ab5 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     a4f:	eb 17                	jmp    a68 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     a51:	8b 45 08             	mov    0x8(%ebp),%eax
     a54:	8b 10                	mov    (%eax),%edx
     a56:	8b 45 08             	mov    0x8(%ebp),%eax
     a59:	8b 40 04             	mov    0x4(%eax),%eax
     a5c:	89 54 24 04          	mov    %edx,0x4(%esp)
     a60:	89 04 24             	mov    %eax,(%esp)
     a63:	e8 15 05 00 00       	call   f7d <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     a68:	8b 45 08             	mov    0x8(%ebp),%eax
     a6b:	8b 40 10             	mov    0x10(%eax),%eax
     a6e:	85 c0                	test   %eax,%eax
     a70:	74 0a                	je     a7c <mesa_slots_monitor_takeslot+0x5d>
     a72:	8b 45 08             	mov    0x8(%ebp),%eax
     a75:	8b 40 0c             	mov    0xc(%eax),%eax
     a78:	85 c0                	test   %eax,%eax
     a7a:	74 d5                	je     a51 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     a7c:	8b 45 08             	mov    0x8(%ebp),%eax
     a7f:	8b 40 10             	mov    0x10(%eax),%eax
     a82:	85 c0                	test   %eax,%eax
     a84:	74 0f                	je     a95 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     a86:	8b 45 08             	mov    0x8(%ebp),%eax
     a89:	8b 40 0c             	mov    0xc(%eax),%eax
     a8c:	8d 50 ff             	lea    -0x1(%eax),%edx
     a8f:	8b 45 08             	mov    0x8(%ebp),%eax
     a92:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     a95:	8b 45 08             	mov    0x8(%ebp),%eax
     a98:	8b 40 08             	mov    0x8(%eax),%eax
     a9b:	89 04 24             	mov    %eax,(%esp)
     a9e:	e8 44 05 00 00       	call   fe7 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     aa3:	8b 45 08             	mov    0x8(%ebp),%eax
     aa6:	8b 00                	mov    (%eax),%eax
     aa8:	89 04 24             	mov    %eax,(%esp)
     aab:	e8 1f f9 ff ff       	call   3cf <kthread_mutex_unlock>

	return 1;
     ab0:	b8 01 00 00 00       	mov    $0x1,%eax

}
     ab5:	c9                   	leave  
     ab6:	c3                   	ret    

00000ab7 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     ab7:	55                   	push   %ebp
     ab8:	89 e5                	mov    %esp,%ebp
     aba:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     abd:	8b 45 08             	mov    0x8(%ebp),%eax
     ac0:	8b 40 10             	mov    0x10(%eax),%eax
     ac3:	85 c0                	test   %eax,%eax
     ac5:	75 07                	jne    ace <mesa_slots_monitor_stopadding+0x17>
			return -1;
     ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     acc:	eb 35                	jmp    b03 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ace:	8b 45 08             	mov    0x8(%ebp),%eax
     ad1:	8b 00                	mov    (%eax),%eax
     ad3:	89 04 24             	mov    %eax,(%esp)
     ad6:	e8 ec f8 ff ff       	call   3c7 <kthread_mutex_lock>
     adb:	83 f8 ff             	cmp    $0xffffffff,%eax
     ade:	7d 07                	jge    ae7 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ae5:	eb 1c                	jmp    b03 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     af1:	8b 45 08             	mov    0x8(%ebp),%eax
     af4:	8b 00                	mov    (%eax),%eax
     af6:	89 04 24             	mov    %eax,(%esp)
     af9:	e8 d1 f8 ff ff       	call   3cf <kthread_mutex_unlock>

		return 0;
     afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b03:	c9                   	leave  
     b04:	c3                   	ret    

00000b05 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     b05:	55                   	push   %ebp
     b06:	89 e5                	mov    %esp,%ebp
     b08:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     b0b:	e8 a7 f8 ff ff       	call   3b7 <kthread_mutex_alloc>
     b10:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b17:	79 0a                	jns    b23 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     b19:	b8 00 00 00 00       	mov    $0x0,%eax
     b1e:	e9 8b 00 00 00       	jmp    bae <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     b23:	e8 68 02 00 00       	call   d90 <hoare_cond_alloc>
     b28:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b2f:	75 12                	jne    b43 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b34:	89 04 24             	mov    %eax,(%esp)
     b37:	e8 83 f8 ff ff       	call   3bf <kthread_mutex_dealloc>
		return 0;
     b3c:	b8 00 00 00 00       	mov    $0x0,%eax
     b41:	eb 6b                	jmp    bae <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     b43:	e8 48 02 00 00       	call   d90 <hoare_cond_alloc>
     b48:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b4f:	75 1d                	jne    b6e <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b54:	89 04 24             	mov    %eax,(%esp)
     b57:	e8 63 f8 ff ff       	call   3bf <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b5f:	89 04 24             	mov    %eax,(%esp)
     b62:	e8 6a 02 00 00       	call   dd1 <hoare_cond_dealloc>
		return 0;
     b67:	b8 00 00 00 00       	mov    $0x0,%eax
     b6c:	eb 40                	jmp    bae <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     b6e:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     b75:	e8 31 fc ff ff       	call   7ab <malloc>
     b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b83:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b8c:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b95:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ba4:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     bab:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     bae:	c9                   	leave  
     baf:	c3                   	ret    

00000bb0 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     bb6:	8b 45 08             	mov    0x8(%ebp),%eax
     bb9:	8b 00                	mov    (%eax),%eax
     bbb:	89 04 24             	mov    %eax,(%esp)
     bbe:	e8 fc f7 ff ff       	call   3bf <kthread_mutex_dealloc>
     bc3:	85 c0                	test   %eax,%eax
     bc5:	78 2e                	js     bf5 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     bc7:	8b 45 08             	mov    0x8(%ebp),%eax
     bca:	8b 40 04             	mov    0x4(%eax),%eax
     bcd:	89 04 24             	mov    %eax,(%esp)
     bd0:	e8 bb 01 00 00       	call   d90 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     bd5:	8b 45 08             	mov    0x8(%ebp),%eax
     bd8:	8b 40 08             	mov    0x8(%eax),%eax
     bdb:	89 04 24             	mov    %eax,(%esp)
     bde:	e8 ad 01 00 00       	call   d90 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     be3:	8b 45 08             	mov    0x8(%ebp),%eax
     be6:	89 04 24             	mov    %eax,(%esp)
     be9:	e8 84 fa ff ff       	call   672 <free>
	return 0;
     bee:	b8 00 00 00 00       	mov    $0x0,%eax
     bf3:	eb 05                	jmp    bfa <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     bfa:	c9                   	leave  
     bfb:	c3                   	ret    

00000bfc <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     bfc:	55                   	push   %ebp
     bfd:	89 e5                	mov    %esp,%ebp
     bff:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
     c05:	8b 40 10             	mov    0x10(%eax),%eax
     c08:	85 c0                	test   %eax,%eax
     c0a:	75 0a                	jne    c16 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c11:	e9 88 00 00 00       	jmp    c9e <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c16:	8b 45 08             	mov    0x8(%ebp),%eax
     c19:	8b 00                	mov    (%eax),%eax
     c1b:	89 04 24             	mov    %eax,(%esp)
     c1e:	e8 a4 f7 ff ff       	call   3c7 <kthread_mutex_lock>
     c23:	83 f8 ff             	cmp    $0xffffffff,%eax
     c26:	7d 07                	jge    c2f <hoare_slots_monitor_addslots+0x33>
		return -1;
     c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c2d:	eb 6f                	jmp    c9e <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     c2f:	8b 45 08             	mov    0x8(%ebp),%eax
     c32:	8b 40 10             	mov    0x10(%eax),%eax
     c35:	85 c0                	test   %eax,%eax
     c37:	74 21                	je     c5a <hoare_slots_monitor_addslots+0x5e>
     c39:	8b 45 08             	mov    0x8(%ebp),%eax
     c3c:	8b 40 0c             	mov    0xc(%eax),%eax
     c3f:	85 c0                	test   %eax,%eax
     c41:	7e 17                	jle    c5a <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     c43:	8b 45 08             	mov    0x8(%ebp),%eax
     c46:	8b 10                	mov    (%eax),%edx
     c48:	8b 45 08             	mov    0x8(%ebp),%eax
     c4b:	8b 40 08             	mov    0x8(%eax),%eax
     c4e:	89 54 24 04          	mov    %edx,0x4(%esp)
     c52:	89 04 24             	mov    %eax,(%esp)
     c55:	e8 c1 01 00 00       	call   e1b <hoare_cond_wait>


	if  ( monitor->active)
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
     c5d:	8b 40 10             	mov    0x10(%eax),%eax
     c60:	85 c0                	test   %eax,%eax
     c62:	74 11                	je     c75 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	8b 50 0c             	mov    0xc(%eax),%edx
     c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c6d:	01 c2                	add    %eax,%edx
     c6f:	8b 45 08             	mov    0x8(%ebp),%eax
     c72:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     c75:	8b 45 08             	mov    0x8(%ebp),%eax
     c78:	8b 10                	mov    (%eax),%edx
     c7a:	8b 45 08             	mov    0x8(%ebp),%eax
     c7d:	8b 40 04             	mov    0x4(%eax),%eax
     c80:	89 54 24 04          	mov    %edx,0x4(%esp)
     c84:	89 04 24             	mov    %eax,(%esp)
     c87:	e8 e6 01 00 00       	call   e72 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     c8c:	8b 45 08             	mov    0x8(%ebp),%eax
     c8f:	8b 00                	mov    (%eax),%eax
     c91:	89 04 24             	mov    %eax,(%esp)
     c94:	e8 36 f7 ff ff       	call   3cf <kthread_mutex_unlock>

	return 1;
     c99:	b8 01 00 00 00       	mov    $0x1,%eax


}
     c9e:	c9                   	leave  
     c9f:	c3                   	ret    

00000ca0 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     ca6:	8b 45 08             	mov    0x8(%ebp),%eax
     ca9:	8b 40 10             	mov    0x10(%eax),%eax
     cac:	85 c0                	test   %eax,%eax
     cae:	75 0a                	jne    cba <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cb5:	e9 86 00 00 00       	jmp    d40 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     cba:	8b 45 08             	mov    0x8(%ebp),%eax
     cbd:	8b 00                	mov    (%eax),%eax
     cbf:	89 04 24             	mov    %eax,(%esp)
     cc2:	e8 00 f7 ff ff       	call   3c7 <kthread_mutex_lock>
     cc7:	83 f8 ff             	cmp    $0xffffffff,%eax
     cca:	7d 07                	jge    cd3 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cd1:	eb 6d                	jmp    d40 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     cd3:	8b 45 08             	mov    0x8(%ebp),%eax
     cd6:	8b 40 10             	mov    0x10(%eax),%eax
     cd9:	85 c0                	test   %eax,%eax
     cdb:	74 21                	je     cfe <hoare_slots_monitor_takeslot+0x5e>
     cdd:	8b 45 08             	mov    0x8(%ebp),%eax
     ce0:	8b 40 0c             	mov    0xc(%eax),%eax
     ce3:	85 c0                	test   %eax,%eax
     ce5:	75 17                	jne    cfe <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     ce7:	8b 45 08             	mov    0x8(%ebp),%eax
     cea:	8b 10                	mov    (%eax),%edx
     cec:	8b 45 08             	mov    0x8(%ebp),%eax
     cef:	8b 40 04             	mov    0x4(%eax),%eax
     cf2:	89 54 24 04          	mov    %edx,0x4(%esp)
     cf6:	89 04 24             	mov    %eax,(%esp)
     cf9:	e8 1d 01 00 00       	call   e1b <hoare_cond_wait>


	if  ( monitor->active)
     cfe:	8b 45 08             	mov    0x8(%ebp),%eax
     d01:	8b 40 10             	mov    0x10(%eax),%eax
     d04:	85 c0                	test   %eax,%eax
     d06:	74 0f                	je     d17 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     d08:	8b 45 08             	mov    0x8(%ebp),%eax
     d0b:	8b 40 0c             	mov    0xc(%eax),%eax
     d0e:	8d 50 ff             	lea    -0x1(%eax),%edx
     d11:	8b 45 08             	mov    0x8(%ebp),%eax
     d14:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     d17:	8b 45 08             	mov    0x8(%ebp),%eax
     d1a:	8b 10                	mov    (%eax),%edx
     d1c:	8b 45 08             	mov    0x8(%ebp),%eax
     d1f:	8b 40 08             	mov    0x8(%eax),%eax
     d22:	89 54 24 04          	mov    %edx,0x4(%esp)
     d26:	89 04 24             	mov    %eax,(%esp)
     d29:	e8 44 01 00 00       	call   e72 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d2e:	8b 45 08             	mov    0x8(%ebp),%eax
     d31:	8b 00                	mov    (%eax),%eax
     d33:	89 04 24             	mov    %eax,(%esp)
     d36:	e8 94 f6 ff ff       	call   3cf <kthread_mutex_unlock>

	return 1;
     d3b:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d40:	c9                   	leave  
     d41:	c3                   	ret    

00000d42 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     d42:	55                   	push   %ebp
     d43:	89 e5                	mov    %esp,%ebp
     d45:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	8b 40 10             	mov    0x10(%eax),%eax
     d4e:	85 c0                	test   %eax,%eax
     d50:	75 07                	jne    d59 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d57:	eb 35                	jmp    d8e <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d59:	8b 45 08             	mov    0x8(%ebp),%eax
     d5c:	8b 00                	mov    (%eax),%eax
     d5e:	89 04 24             	mov    %eax,(%esp)
     d61:	e8 61 f6 ff ff       	call   3c7 <kthread_mutex_lock>
     d66:	83 f8 ff             	cmp    $0xffffffff,%eax
     d69:	7d 07                	jge    d72 <hoare_slots_monitor_stopadding+0x30>
			return -1;
     d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d70:	eb 1c                	jmp    d8e <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     d72:	8b 45 08             	mov    0x8(%ebp),%eax
     d75:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     d7c:	8b 45 08             	mov    0x8(%ebp),%eax
     d7f:	8b 00                	mov    (%eax),%eax
     d81:	89 04 24             	mov    %eax,(%esp)
     d84:	e8 46 f6 ff ff       	call   3cf <kthread_mutex_unlock>

		return 0;
     d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d8e:	c9                   	leave  
     d8f:	c3                   	ret    

00000d90 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     d96:	e8 1c f6 ff ff       	call   3b7 <kthread_mutex_alloc>
     d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     da2:	79 07                	jns    dab <hoare_cond_alloc+0x1b>
		return 0;
     da4:	b8 00 00 00 00       	mov    $0x0,%eax
     da9:	eb 24                	jmp    dcf <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     dab:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     db2:	e8 f4 f9 ff ff       	call   7ab <malloc>
     db7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     dbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dc0:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     dc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     dcf:	c9                   	leave  
     dd0:	c3                   	ret    

00000dd1 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     dd1:	55                   	push   %ebp
     dd2:	89 e5                	mov    %esp,%ebp
     dd4:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     dd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ddb:	75 07                	jne    de4 <hoare_cond_dealloc+0x13>
			return -1;
     ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     de2:	eb 35                	jmp    e19 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     de4:	8b 45 08             	mov    0x8(%ebp),%eax
     de7:	8b 00                	mov    (%eax),%eax
     de9:	89 04 24             	mov    %eax,(%esp)
     dec:	e8 de f5 ff ff       	call   3cf <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     df1:	8b 45 08             	mov    0x8(%ebp),%eax
     df4:	8b 00                	mov    (%eax),%eax
     df6:	89 04 24             	mov    %eax,(%esp)
     df9:	e8 c1 f5 ff ff       	call   3bf <kthread_mutex_dealloc>
     dfe:	85 c0                	test   %eax,%eax
     e00:	79 07                	jns    e09 <hoare_cond_dealloc+0x38>
			return -1;
     e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e07:	eb 10                	jmp    e19 <hoare_cond_dealloc+0x48>

		free (hCond);
     e09:	8b 45 08             	mov    0x8(%ebp),%eax
     e0c:	89 04 24             	mov    %eax,(%esp)
     e0f:	e8 5e f8 ff ff       	call   672 <free>
		return 0;
     e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e19:	c9                   	leave  
     e1a:	c3                   	ret    

00000e1b <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     e1b:	55                   	push   %ebp
     e1c:	89 e5                	mov    %esp,%ebp
     e1e:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e25:	75 07                	jne    e2e <hoare_cond_wait+0x13>
			return -1;
     e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e2c:	eb 42                	jmp    e70 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     e2e:	8b 45 08             	mov    0x8(%ebp),%eax
     e31:	8b 40 04             	mov    0x4(%eax),%eax
     e34:	8d 50 01             	lea    0x1(%eax),%edx
     e37:	8b 45 08             	mov    0x8(%ebp),%eax
     e3a:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     e3d:	8b 45 08             	mov    0x8(%ebp),%eax
     e40:	8b 00                	mov    (%eax),%eax
     e42:	89 44 24 04          	mov    %eax,0x4(%esp)
     e46:	8b 45 0c             	mov    0xc(%ebp),%eax
     e49:	89 04 24             	mov    %eax,(%esp)
     e4c:	e8 86 f5 ff ff       	call   3d7 <kthread_mutex_yieldlock>
     e51:	85 c0                	test   %eax,%eax
     e53:	79 16                	jns    e6b <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     e55:	8b 45 08             	mov    0x8(%ebp),%eax
     e58:	8b 40 04             	mov    0x4(%eax),%eax
     e5b:	8d 50 ff             	lea    -0x1(%eax),%edx
     e5e:	8b 45 08             	mov    0x8(%ebp),%eax
     e61:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e69:	eb 05                	jmp    e70 <hoare_cond_wait+0x55>
		}

	return 0;
     e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e70:	c9                   	leave  
     e71:	c3                   	ret    

00000e72 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     e72:	55                   	push   %ebp
     e73:	89 e5                	mov    %esp,%ebp
     e75:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     e78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e7c:	75 07                	jne    e85 <hoare_cond_signal+0x13>
		return -1;
     e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e83:	eb 6b                	jmp    ef0 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     e85:	8b 45 08             	mov    0x8(%ebp),%eax
     e88:	8b 40 04             	mov    0x4(%eax),%eax
     e8b:	85 c0                	test   %eax,%eax
     e8d:	7e 3d                	jle    ecc <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     e8f:	8b 45 08             	mov    0x8(%ebp),%eax
     e92:	8b 40 04             	mov    0x4(%eax),%eax
     e95:	8d 50 ff             	lea    -0x1(%eax),%edx
     e98:	8b 45 08             	mov    0x8(%ebp),%eax
     e9b:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     e9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ea1:	8b 00                	mov    (%eax),%eax
     ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
     eaa:	89 04 24             	mov    %eax,(%esp)
     ead:	e8 25 f5 ff ff       	call   3d7 <kthread_mutex_yieldlock>
     eb2:	85 c0                	test   %eax,%eax
     eb4:	79 16                	jns    ecc <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     eb6:	8b 45 08             	mov    0x8(%ebp),%eax
     eb9:	8b 40 04             	mov    0x4(%eax),%eax
     ebc:	8d 50 01             	lea    0x1(%eax),%edx
     ebf:	8b 45 08             	mov    0x8(%ebp),%eax
     ec2:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eca:	eb 24                	jmp    ef0 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     ecc:	8b 45 08             	mov    0x8(%ebp),%eax
     ecf:	8b 00                	mov    (%eax),%eax
     ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
     ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ed8:	89 04 24             	mov    %eax,(%esp)
     edb:	e8 f7 f4 ff ff       	call   3d7 <kthread_mutex_yieldlock>
     ee0:	85 c0                	test   %eax,%eax
     ee2:	79 07                	jns    eeb <hoare_cond_signal+0x79>

    			return -1;
     ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ee9:	eb 05                	jmp    ef0 <hoare_cond_signal+0x7e>
    }

	return 0;
     eeb:	b8 00 00 00 00       	mov    $0x0,%eax

}
     ef0:	c9                   	leave  
     ef1:	c3                   	ret    

00000ef2 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     ef2:	55                   	push   %ebp
     ef3:	89 e5                	mov    %esp,%ebp
     ef5:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ef8:	e8 ba f4 ff ff       	call   3b7 <kthread_mutex_alloc>
     efd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f04:	79 07                	jns    f0d <mesa_cond_alloc+0x1b>
		return 0;
     f06:	b8 00 00 00 00       	mov    $0x0,%eax
     f0b:	eb 24                	jmp    f31 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
     f0d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     f14:	e8 92 f8 ff ff       	call   7ab <malloc>
     f19:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
     f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f22:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
     f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
     f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f31:	c9                   	leave  
     f32:	c3                   	ret    

00000f33 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
     f33:	55                   	push   %ebp
     f34:	89 e5                	mov    %esp,%ebp
     f36:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
     f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f3d:	75 07                	jne    f46 <mesa_cond_dealloc+0x13>
		return -1;
     f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f44:	eb 35                	jmp    f7b <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
     f46:	8b 45 08             	mov    0x8(%ebp),%eax
     f49:	8b 00                	mov    (%eax),%eax
     f4b:	89 04 24             	mov    %eax,(%esp)
     f4e:	e8 7c f4 ff ff       	call   3cf <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
     f53:	8b 45 08             	mov    0x8(%ebp),%eax
     f56:	8b 00                	mov    (%eax),%eax
     f58:	89 04 24             	mov    %eax,(%esp)
     f5b:	e8 5f f4 ff ff       	call   3bf <kthread_mutex_dealloc>
     f60:	85 c0                	test   %eax,%eax
     f62:	79 07                	jns    f6b <mesa_cond_dealloc+0x38>
		return -1;
     f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f69:	eb 10                	jmp    f7b <mesa_cond_dealloc+0x48>

	free (mCond);
     f6b:	8b 45 08             	mov    0x8(%ebp),%eax
     f6e:	89 04 24             	mov    %eax,(%esp)
     f71:	e8 fc f6 ff ff       	call   672 <free>
	return 0;
     f76:	b8 00 00 00 00       	mov    $0x0,%eax

}
     f7b:	c9                   	leave  
     f7c:	c3                   	ret    

00000f7d <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
     f7d:	55                   	push   %ebp
     f7e:	89 e5                	mov    %esp,%ebp
     f80:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     f83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f87:	75 07                	jne    f90 <mesa_cond_wait+0x13>
		return -1;
     f89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f8e:	eb 55                	jmp    fe5 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
     f90:	8b 45 08             	mov    0x8(%ebp),%eax
     f93:	8b 40 04             	mov    0x4(%eax),%eax
     f96:	8d 50 01             	lea    0x1(%eax),%edx
     f99:	8b 45 08             	mov    0x8(%ebp),%eax
     f9c:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
     f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa2:	89 04 24             	mov    %eax,(%esp)
     fa5:	e8 25 f4 ff ff       	call   3cf <kthread_mutex_unlock>
     faa:	85 c0                	test   %eax,%eax
     fac:	79 27                	jns    fd5 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
     fae:	8b 45 08             	mov    0x8(%ebp),%eax
     fb1:	8b 00                	mov    (%eax),%eax
     fb3:	89 04 24             	mov    %eax,(%esp)
     fb6:	e8 0c f4 ff ff       	call   3c7 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
     fbb:	85 c0                	test   %eax,%eax
     fbd:	79 16                	jns    fd5 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
     fbf:	8b 45 08             	mov    0x8(%ebp),%eax
     fc2:	8b 40 04             	mov    0x4(%eax),%eax
     fc5:	8d 50 ff             	lea    -0x1(%eax),%edx
     fc8:	8b 45 08             	mov    0x8(%ebp),%eax
     fcb:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
     fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fd3:	eb 10                	jmp    fe5 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
     fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     fd8:	89 04 24             	mov    %eax,(%esp)
     fdb:	e8 e7 f3 ff ff       	call   3c7 <kthread_mutex_lock>
	return 0;
     fe0:	b8 00 00 00 00       	mov    $0x0,%eax


}
     fe5:	c9                   	leave  
     fe6:	c3                   	ret    

00000fe7 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
     fe7:	55                   	push   %ebp
     fe8:	89 e5                	mov    %esp,%ebp
     fea:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
     fed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ff1:	75 07                	jne    ffa <mesa_cond_signal+0x13>
		return -1;
     ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ff8:	eb 5d                	jmp    1057 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
     ffa:	8b 45 08             	mov    0x8(%ebp),%eax
     ffd:	8b 40 04             	mov    0x4(%eax),%eax
    1000:	85 c0                	test   %eax,%eax
    1002:	7e 36                	jle    103a <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1004:	8b 45 08             	mov    0x8(%ebp),%eax
    1007:	8b 40 04             	mov    0x4(%eax),%eax
    100a:	8d 50 ff             	lea    -0x1(%eax),%edx
    100d:	8b 45 08             	mov    0x8(%ebp),%eax
    1010:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    1013:	8b 45 08             	mov    0x8(%ebp),%eax
    1016:	8b 00                	mov    (%eax),%eax
    1018:	89 04 24             	mov    %eax,(%esp)
    101b:	e8 af f3 ff ff       	call   3cf <kthread_mutex_unlock>
    1020:	85 c0                	test   %eax,%eax
    1022:	78 16                	js     103a <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    1024:	8b 45 08             	mov    0x8(%ebp),%eax
    1027:	8b 40 04             	mov    0x4(%eax),%eax
    102a:	8d 50 01             	lea    0x1(%eax),%edx
    102d:	8b 45 08             	mov    0x8(%ebp),%eax
    1030:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    1033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1038:	eb 1d                	jmp    1057 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    103a:	8b 45 08             	mov    0x8(%ebp),%eax
    103d:	8b 00                	mov    (%eax),%eax
    103f:	89 04 24             	mov    %eax,(%esp)
    1042:	e8 88 f3 ff ff       	call   3cf <kthread_mutex_unlock>
    1047:	85 c0                	test   %eax,%eax
    1049:	79 07                	jns    1052 <mesa_cond_signal+0x6b>

		return -1;
    104b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1050:	eb 05                	jmp    1057 <mesa_cond_signal+0x70>
	}
	return 0;
    1052:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1057:	c9                   	leave  
    1058:	c3                   	ret    
