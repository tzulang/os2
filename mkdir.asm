
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
   f:	c7 44 24 04 54 0b 00 	movl   $0xb54,0x4(%esp)
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
  66:	c7 44 24 04 6b 0b 00 	movl   $0xb6b,0x4(%esp)
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
 458:	0f b6 80 d4 0e 00 00 	movzbl 0xed4(%eax),%eax
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
 5b7:	c7 45 f4 87 0b 00 00 	movl   $0xb87,-0xc(%ebp)
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
 681:	a1 f0 0e 00 00       	mov    0xef0,%eax
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
 74c:	a3 f0 0e 00 00       	mov    %eax,0xef0
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
 7a4:	a1 f0 0e 00 00       	mov    0xef0,%eax
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
 7c0:	a1 f0 0e 00 00       	mov    0xef0,%eax
 7c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7cc:	75 23                	jne    7f1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ce:	c7 45 f0 e8 0e 00 00 	movl   $0xee8,-0x10(%ebp)
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	a3 f0 0e 00 00       	mov    %eax,0xef0
 7dd:	a1 f0 0e 00 00       	mov    0xef0,%eax
 7e2:	a3 e8 0e 00 00       	mov    %eax,0xee8
    base.s.size = 0;
 7e7:	c7 05 ec 0e 00 00 00 	movl   $0x0,0xeec
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
 844:	a3 f0 0e 00 00       	mov    %eax,0xef0
      return (void*)(p + 1);
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	83 c0 08             	add    $0x8,%eax
 84f:	eb 38                	jmp    889 <malloc+0xde>
    }
    if(p == freep)
 851:	a1 f0 0e 00 00       	mov    0xef0,%eax
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

0000088b <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
 88b:	55                   	push   %ebp
 88c:	89 e5                	mov    %esp,%ebp
 88e:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 891:	e8 21 fb ff ff       	call   3b7 <kthread_mutex_alloc>
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89d:	79 07                	jns    8a6 <hoare_cond_alloc+0x1b>
		return 0;
 89f:	b8 00 00 00 00       	mov    $0x0,%eax
 8a4:	eb 24                	jmp    8ca <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
 8a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8ad:	e8 f9 fe ff ff       	call   7ab <malloc>
 8b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8bb:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8ca:	c9                   	leave  
 8cb:	c3                   	ret    

000008cc <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
 8cc:	55                   	push   %ebp
 8cd:	89 e5                	mov    %esp,%ebp
 8cf:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
 8d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8d6:	75 07                	jne    8df <hoare_cond_dealloc+0x13>
			return -1;
 8d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8dd:	eb 35                	jmp    914 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
 8df:	8b 45 08             	mov    0x8(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	89 04 24             	mov    %eax,(%esp)
 8e7:	e8 e3 fa ff ff       	call   3cf <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 04 24             	mov    %eax,(%esp)
 8f4:	e8 c6 fa ff ff       	call   3bf <kthread_mutex_dealloc>
 8f9:	85 c0                	test   %eax,%eax
 8fb:	79 07                	jns    904 <hoare_cond_dealloc+0x38>
			return -1;
 8fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 902:	eb 10                	jmp    914 <hoare_cond_dealloc+0x48>

		free (hCond);
 904:	8b 45 08             	mov    0x8(%ebp),%eax
 907:	89 04 24             	mov    %eax,(%esp)
 90a:	e8 63 fd ff ff       	call   672 <free>
		return 0;
 90f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 914:	c9                   	leave  
 915:	c3                   	ret    

00000916 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
 916:	55                   	push   %ebp
 917:	89 e5                	mov    %esp,%ebp
 919:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 91c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 920:	75 07                	jne    929 <hoare_cond_wait+0x13>
			return -1;
 922:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 927:	eb 42                	jmp    96b <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	8d 50 01             	lea    0x1(%eax),%edx
 932:	8b 45 08             	mov    0x8(%ebp),%eax
 935:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
 938:	8b 45 08             	mov    0x8(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	89 44 24 04          	mov    %eax,0x4(%esp)
 941:	8b 45 0c             	mov    0xc(%ebp),%eax
 944:	89 04 24             	mov    %eax,(%esp)
 947:	e8 8b fa ff ff       	call   3d7 <kthread_mutex_yieldlock>
 94c:	85 c0                	test   %eax,%eax
 94e:	79 16                	jns    966 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
 950:	8b 45 08             	mov    0x8(%ebp),%eax
 953:	8b 40 04             	mov    0x4(%eax),%eax
 956:	8d 50 ff             	lea    -0x1(%eax),%edx
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 95f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 964:	eb 05                	jmp    96b <hoare_cond_wait+0x55>
		}

	return 0;
 966:	b8 00 00 00 00       	mov    $0x0,%eax
}
 96b:	c9                   	leave  
 96c:	c3                   	ret    

0000096d <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
 96d:	55                   	push   %ebp
 96e:	89 e5                	mov    %esp,%ebp
 970:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 973:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 977:	75 07                	jne    980 <hoare_cond_signal+0x13>
		return -1;
 979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 97e:	eb 6b                	jmp    9eb <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	85 c0                	test   %eax,%eax
 988:	7e 3d                	jle    9c7 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
 98a:	8b 45 08             	mov    0x8(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	8d 50 ff             	lea    -0x1(%eax),%edx
 993:	8b 45 08             	mov    0x8(%ebp),%eax
 996:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 999:	8b 45 08             	mov    0x8(%ebp),%eax
 99c:	8b 00                	mov    (%eax),%eax
 99e:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a5:	89 04 24             	mov    %eax,(%esp)
 9a8:	e8 2a fa ff ff       	call   3d7 <kthread_mutex_yieldlock>
 9ad:	85 c0                	test   %eax,%eax
 9af:	79 16                	jns    9c7 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	8d 50 01             	lea    0x1(%eax),%edx
 9ba:	8b 45 08             	mov    0x8(%ebp),%eax
 9bd:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 9c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9c5:	eb 24                	jmp    9eb <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	8b 00                	mov    (%eax),%eax
 9cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 9d3:	89 04 24             	mov    %eax,(%esp)
 9d6:	e8 fc f9 ff ff       	call   3d7 <kthread_mutex_yieldlock>
 9db:	85 c0                	test   %eax,%eax
 9dd:	79 07                	jns    9e6 <hoare_cond_signal+0x79>

    			return -1;
 9df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9e4:	eb 05                	jmp    9eb <hoare_cond_signal+0x7e>
    }

	return 0;
 9e6:	b8 00 00 00 00       	mov    $0x0,%eax

}
 9eb:	c9                   	leave  
 9ec:	c3                   	ret    

000009ed <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
 9ed:	55                   	push   %ebp
 9ee:	89 e5                	mov    %esp,%ebp
 9f0:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 9f3:	e8 bf f9 ff ff       	call   3b7 <kthread_mutex_alloc>
 9f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 9fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ff:	79 07                	jns    a08 <mesa_cond_alloc+0x1b>
		return 0;
 a01:	b8 00 00 00 00       	mov    $0x0,%eax
 a06:	eb 24                	jmp    a2c <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
 a08:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a0f:	e8 97 fd ff ff       	call   7ab <malloc>
 a14:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
 a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a1d:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
 a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 a2c:	c9                   	leave  
 a2d:	c3                   	ret    

00000a2e <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
 a2e:	55                   	push   %ebp
 a2f:	89 e5                	mov    %esp,%ebp
 a31:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
 a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 a38:	75 07                	jne    a41 <mesa_cond_dealloc+0x13>
		return -1;
 a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a3f:	eb 35                	jmp    a76 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
 a41:	8b 45 08             	mov    0x8(%ebp),%eax
 a44:	8b 00                	mov    (%eax),%eax
 a46:	89 04 24             	mov    %eax,(%esp)
 a49:	e8 81 f9 ff ff       	call   3cf <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
 a4e:	8b 45 08             	mov    0x8(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	89 04 24             	mov    %eax,(%esp)
 a56:	e8 64 f9 ff ff       	call   3bf <kthread_mutex_dealloc>
 a5b:	85 c0                	test   %eax,%eax
 a5d:	79 07                	jns    a66 <mesa_cond_dealloc+0x38>
		return -1;
 a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a64:	eb 10                	jmp    a76 <mesa_cond_dealloc+0x48>

	free (mCond);
 a66:	8b 45 08             	mov    0x8(%ebp),%eax
 a69:	89 04 24             	mov    %eax,(%esp)
 a6c:	e8 01 fc ff ff       	call   672 <free>
	return 0;
 a71:	b8 00 00 00 00       	mov    $0x0,%eax

}
 a76:	c9                   	leave  
 a77:	c3                   	ret    

00000a78 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
 a78:	55                   	push   %ebp
 a79:	89 e5                	mov    %esp,%ebp
 a7b:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 a7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 a82:	75 07                	jne    a8b <mesa_cond_wait+0x13>
		return -1;
 a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a89:	eb 55                	jmp    ae0 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
 a8b:	8b 45 08             	mov    0x8(%ebp),%eax
 a8e:	8b 40 04             	mov    0x4(%eax),%eax
 a91:	8d 50 01             	lea    0x1(%eax),%edx
 a94:	8b 45 08             	mov    0x8(%ebp),%eax
 a97:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
 a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
 a9d:	89 04 24             	mov    %eax,(%esp)
 aa0:	e8 2a f9 ff ff       	call   3cf <kthread_mutex_unlock>
 aa5:	85 c0                	test   %eax,%eax
 aa7:	79 27                	jns    ad0 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
 aa9:	8b 45 08             	mov    0x8(%ebp),%eax
 aac:	8b 00                	mov    (%eax),%eax
 aae:	89 04 24             	mov    %eax,(%esp)
 ab1:	e8 11 f9 ff ff       	call   3c7 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
 ab6:	85 c0                	test   %eax,%eax
 ab8:	74 16                	je     ad0 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
	{
		mCond->waitinCount--;
 aba:	8b 45 08             	mov    0x8(%ebp),%eax
 abd:	8b 40 04             	mov    0x4(%eax),%eax
 ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
 ac3:	8b 45 08             	mov    0x8(%ebp),%eax
 ac6:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
 ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ace:	eb 10                	jmp    ae0 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
 ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
 ad3:	89 04 24             	mov    %eax,(%esp)
 ad6:	e8 ec f8 ff ff       	call   3c7 <kthread_mutex_lock>
	return 0;
 adb:	b8 00 00 00 00       	mov    $0x0,%eax


}
 ae0:	c9                   	leave  
 ae1:	c3                   	ret    

00000ae2 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
 ae2:	55                   	push   %ebp
 ae3:	89 e5                	mov    %esp,%ebp
 ae5:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 aec:	75 07                	jne    af5 <mesa_cond_signal+0x13>
		return -1;
 aee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 af3:	eb 5d                	jmp    b52 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
 af5:	8b 45 08             	mov    0x8(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	85 c0                	test   %eax,%eax
 afd:	7e 36                	jle    b35 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
 aff:	8b 45 08             	mov    0x8(%ebp),%eax
 b02:	8b 40 04             	mov    0x4(%eax),%eax
 b05:	8d 50 ff             	lea    -0x1(%eax),%edx
 b08:	8b 45 08             	mov    0x8(%ebp),%eax
 b0b:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
 b0e:	8b 45 08             	mov    0x8(%ebp),%eax
 b11:	8b 00                	mov    (%eax),%eax
 b13:	89 04 24             	mov    %eax,(%esp)
 b16:	e8 b4 f8 ff ff       	call   3cf <kthread_mutex_unlock>
 b1b:	85 c0                	test   %eax,%eax
 b1d:	78 16                	js     b35 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	8b 40 04             	mov    0x4(%eax),%eax
 b25:	8d 50 01             	lea    0x1(%eax),%edx
 b28:	8b 45 08             	mov    0x8(%ebp),%eax
 b2b:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
 b2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b33:	eb 1d                	jmp    b52 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
 b35:	8b 45 08             	mov    0x8(%ebp),%eax
 b38:	8b 00                	mov    (%eax),%eax
 b3a:	89 04 24             	mov    %eax,(%esp)
 b3d:	e8 8d f8 ff ff       	call   3cf <kthread_mutex_unlock>
 b42:	85 c0                	test   %eax,%eax
 b44:	79 07                	jns    b4d <mesa_cond_signal+0x6b>

		return -1;
 b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b4b:	eb 05                	jmp    b52 <mesa_cond_signal+0x70>
	}
	return 0;
 b4d:	b8 00 00 00 00       	mov    $0x0,%eax

}
 b52:	c9                   	leave  
 b53:	c3                   	ret    
