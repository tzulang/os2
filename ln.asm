
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
   f:	c7 44 24 04 3e 0b 00 	movl   $0xb3e,0x4(%esp)
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
  60:	c7 44 24 04 51 0b 00 	movl   $0xb51,0x4(%esp)
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
 442:	0f b6 80 b0 0e 00 00 	movzbl 0xeb0(%eax),%eax
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
 5a1:	c7 45 f4 65 0b 00 00 	movl   $0xb65,-0xc(%ebp)
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
 66b:	a1 cc 0e 00 00       	mov    0xecc,%eax
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
 736:	a3 cc 0e 00 00       	mov    %eax,0xecc
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
 78e:	a1 cc 0e 00 00       	mov    0xecc,%eax
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
 7aa:	a1 cc 0e 00 00       	mov    0xecc,%eax
 7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b6:	75 23                	jne    7db <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b8:	c7 45 f0 c4 0e 00 00 	movl   $0xec4,-0x10(%ebp)
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	a3 cc 0e 00 00       	mov    %eax,0xecc
 7c7:	a1 cc 0e 00 00       	mov    0xecc,%eax
 7cc:	a3 c4 0e 00 00       	mov    %eax,0xec4
    base.s.size = 0;
 7d1:	c7 05 c8 0e 00 00 00 	movl   $0x0,0xec8
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
 82e:	a3 cc 0e 00 00       	mov    %eax,0xecc
      return (void*)(p + 1);
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	83 c0 08             	add    $0x8,%eax
 839:	eb 38                	jmp    873 <malloc+0xde>
    }
    if(p == freep)
 83b:	a1 cc 0e 00 00       	mov    0xecc,%eax
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

00000875 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 87b:	e8 21 fb ff ff       	call   3a1 <kthread_mutex_alloc>
 880:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 887:	79 07                	jns    890 <hoare_cond_alloc+0x1b>
		return 0;
 889:	b8 00 00 00 00       	mov    $0x0,%eax
 88e:	eb 24                	jmp    8b4 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
 890:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 897:	e8 f9 fe ff ff       	call   795 <malloc>
 89c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8a5:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    

000008b6 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
 8b6:	55                   	push   %ebp
 8b7:	89 e5                	mov    %esp,%ebp
 8b9:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
 8bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8c0:	75 07                	jne    8c9 <hoare_cond_dealloc+0x13>
			return -1;
 8c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c7:	eb 35                	jmp    8fe <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
 8c9:	8b 45 08             	mov    0x8(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	89 04 24             	mov    %eax,(%esp)
 8d1:	e8 e3 fa ff ff       	call   3b9 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
 8d6:	8b 45 08             	mov    0x8(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 04 24             	mov    %eax,(%esp)
 8de:	e8 c6 fa ff ff       	call   3a9 <kthread_mutex_dealloc>
 8e3:	85 c0                	test   %eax,%eax
 8e5:	79 07                	jns    8ee <hoare_cond_dealloc+0x38>
			return -1;
 8e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8ec:	eb 10                	jmp    8fe <hoare_cond_dealloc+0x48>

		free (hCond);
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	89 04 24             	mov    %eax,(%esp)
 8f4:	e8 63 fd ff ff       	call   65c <free>
		return 0;
 8f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8fe:	c9                   	leave  
 8ff:	c3                   	ret    

00000900 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 906:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 90a:	75 07                	jne    913 <hoare_cond_wait+0x13>
			return -1;
 90c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 911:	eb 42                	jmp    955 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
 913:	8b 45 08             	mov    0x8(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	8d 50 01             	lea    0x1(%eax),%edx
 91c:	8b 45 08             	mov    0x8(%ebp),%eax
 91f:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
 922:	8b 45 08             	mov    0x8(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	89 44 24 04          	mov    %eax,0x4(%esp)
 92b:	8b 45 0c             	mov    0xc(%ebp),%eax
 92e:	89 04 24             	mov    %eax,(%esp)
 931:	e8 8b fa ff ff       	call   3c1 <kthread_mutex_yieldlock>
 936:	85 c0                	test   %eax,%eax
 938:	79 16                	jns    950 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
 93a:	8b 45 08             	mov    0x8(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	8d 50 ff             	lea    -0x1(%eax),%edx
 943:	8b 45 08             	mov    0x8(%ebp),%eax
 946:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 94e:	eb 05                	jmp    955 <hoare_cond_wait+0x55>
		}

	return 0;
 950:	b8 00 00 00 00       	mov    $0x0,%eax
}
 955:	c9                   	leave  
 956:	c3                   	ret    

00000957 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
 957:	55                   	push   %ebp
 958:	89 e5                	mov    %esp,%ebp
 95a:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 95d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 961:	75 07                	jne    96a <hoare_cond_signal+0x13>
		return -1;
 963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 968:	eb 6b                	jmp    9d5 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
 96a:	8b 45 08             	mov    0x8(%ebp),%eax
 96d:	8b 40 04             	mov    0x4(%eax),%eax
 970:	85 c0                	test   %eax,%eax
 972:	7e 3d                	jle    9b1 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
 974:	8b 45 08             	mov    0x8(%ebp),%eax
 977:	8b 40 04             	mov    0x4(%eax),%eax
 97a:	8d 50 ff             	lea    -0x1(%eax),%edx
 97d:	8b 45 08             	mov    0x8(%ebp),%eax
 980:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 983:	8b 45 08             	mov    0x8(%ebp),%eax
 986:	8b 00                	mov    (%eax),%eax
 988:	89 44 24 04          	mov    %eax,0x4(%esp)
 98c:	8b 45 0c             	mov    0xc(%ebp),%eax
 98f:	89 04 24             	mov    %eax,(%esp)
 992:	e8 2a fa ff ff       	call   3c1 <kthread_mutex_yieldlock>
 997:	85 c0                	test   %eax,%eax
 999:	79 16                	jns    9b1 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
 99b:	8b 45 08             	mov    0x8(%ebp),%eax
 99e:	8b 40 04             	mov    0x4(%eax),%eax
 9a1:	8d 50 01             	lea    0x1(%eax),%edx
 9a4:	8b 45 08             	mov    0x8(%ebp),%eax
 9a7:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 9aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9af:	eb 24                	jmp    9d5 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	8b 00                	mov    (%eax),%eax
 9b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 9bd:	89 04 24             	mov    %eax,(%esp)
 9c0:	e8 fc f9 ff ff       	call   3c1 <kthread_mutex_yieldlock>
 9c5:	85 c0                	test   %eax,%eax
 9c7:	79 07                	jns    9d0 <hoare_cond_signal+0x79>

    			return -1;
 9c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9ce:	eb 05                	jmp    9d5 <hoare_cond_signal+0x7e>
    }

	return 0;
 9d0:	b8 00 00 00 00       	mov    $0x0,%eax

}
 9d5:	c9                   	leave  
 9d6:	c3                   	ret    

000009d7 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
 9d7:	55                   	push   %ebp
 9d8:	89 e5                	mov    %esp,%ebp
 9da:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 9dd:	e8 bf f9 ff ff       	call   3a1 <kthread_mutex_alloc>
 9e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 9e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e9:	79 07                	jns    9f2 <mesa_cond_alloc+0x1b>
		return 0;
 9eb:	b8 00 00 00 00       	mov    $0x0,%eax
 9f0:	eb 24                	jmp    a16 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
 9f2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 9f9:	e8 97 fd ff ff       	call   795 <malloc>
 9fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
 a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a07:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
 a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 a16:	c9                   	leave  
 a17:	c3                   	ret    

00000a18 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
 a18:	55                   	push   %ebp
 a19:	89 e5                	mov    %esp,%ebp
 a1b:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
 a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 a22:	75 07                	jne    a2b <mesa_cond_dealloc+0x13>
		return -1;
 a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a29:	eb 35                	jmp    a60 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
 a2b:	8b 45 08             	mov    0x8(%ebp),%eax
 a2e:	8b 00                	mov    (%eax),%eax
 a30:	89 04 24             	mov    %eax,(%esp)
 a33:	e8 81 f9 ff ff       	call   3b9 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
 a38:	8b 45 08             	mov    0x8(%ebp),%eax
 a3b:	8b 00                	mov    (%eax),%eax
 a3d:	89 04 24             	mov    %eax,(%esp)
 a40:	e8 64 f9 ff ff       	call   3a9 <kthread_mutex_dealloc>
 a45:	85 c0                	test   %eax,%eax
 a47:	79 07                	jns    a50 <mesa_cond_dealloc+0x38>
		return -1;
 a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a4e:	eb 10                	jmp    a60 <mesa_cond_dealloc+0x48>

	free (mCond);
 a50:	8b 45 08             	mov    0x8(%ebp),%eax
 a53:	89 04 24             	mov    %eax,(%esp)
 a56:	e8 01 fc ff ff       	call   65c <free>
	return 0;
 a5b:	b8 00 00 00 00       	mov    $0x0,%eax

}
 a60:	c9                   	leave  
 a61:	c3                   	ret    

00000a62 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
 a62:	55                   	push   %ebp
 a63:	89 e5                	mov    %esp,%ebp
 a65:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 a6c:	75 07                	jne    a75 <mesa_cond_wait+0x13>
		return -1;
 a6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a73:	eb 55                	jmp    aca <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
 a75:	8b 45 08             	mov    0x8(%ebp),%eax
 a78:	8b 40 04             	mov    0x4(%eax),%eax
 a7b:	8d 50 01             	lea    0x1(%eax),%edx
 a7e:	8b 45 08             	mov    0x8(%ebp),%eax
 a81:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
 a84:	8b 45 0c             	mov    0xc(%ebp),%eax
 a87:	89 04 24             	mov    %eax,(%esp)
 a8a:	e8 2a f9 ff ff       	call   3b9 <kthread_mutex_unlock>
 a8f:	85 c0                	test   %eax,%eax
 a91:	79 27                	jns    aba <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
 a96:	8b 00                	mov    (%eax),%eax
 a98:	89 04 24             	mov    %eax,(%esp)
 a9b:	e8 11 f9 ff ff       	call   3b1 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
 aa0:	85 c0                	test   %eax,%eax
 aa2:	74 16                	je     aba <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV))
	{
		mCond->waitinCount--;
 aa4:	8b 45 08             	mov    0x8(%ebp),%eax
 aa7:	8b 40 04             	mov    0x4(%eax),%eax
 aaa:	8d 50 ff             	lea    -0x1(%eax),%edx
 aad:	8b 45 08             	mov    0x8(%ebp),%eax
 ab0:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
 ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ab8:	eb 10                	jmp    aca <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
 aba:	8b 45 0c             	mov    0xc(%ebp),%eax
 abd:	89 04 24             	mov    %eax,(%esp)
 ac0:	e8 ec f8 ff ff       	call   3b1 <kthread_mutex_lock>
	return 0;
 ac5:	b8 00 00 00 00       	mov    $0x0,%eax


}
 aca:	c9                   	leave  
 acb:	c3                   	ret    

00000acc <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
 acc:	55                   	push   %ebp
 acd:	89 e5                	mov    %esp,%ebp
 acf:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 ad2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ad6:	75 07                	jne    adf <mesa_cond_signal+0x13>
		return -1;
 ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 add:	eb 5d                	jmp    b3c <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
 adf:	8b 45 08             	mov    0x8(%ebp),%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	85 c0                	test   %eax,%eax
 ae7:	7e 36                	jle    b1f <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
 ae9:	8b 45 08             	mov    0x8(%ebp),%eax
 aec:	8b 40 04             	mov    0x4(%eax),%eax
 aef:	8d 50 ff             	lea    -0x1(%eax),%edx
 af2:	8b 45 08             	mov    0x8(%ebp),%eax
 af5:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	8b 00                	mov    (%eax),%eax
 afd:	89 04 24             	mov    %eax,(%esp)
 b00:	e8 b4 f8 ff ff       	call   3b9 <kthread_mutex_unlock>
 b05:	85 c0                	test   %eax,%eax
 b07:	78 16                	js     b1f <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
 b09:	8b 45 08             	mov    0x8(%ebp),%eax
 b0c:	8b 40 04             	mov    0x4(%eax),%eax
 b0f:	8d 50 01             	lea    0x1(%eax),%edx
 b12:	8b 45 08             	mov    0x8(%ebp),%eax
 b15:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
 b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b1d:	eb 1d                	jmp    b3c <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	8b 00                	mov    (%eax),%eax
 b24:	89 04 24             	mov    %eax,(%esp)
 b27:	e8 8d f8 ff ff       	call   3b9 <kthread_mutex_unlock>
 b2c:	85 c0                	test   %eax,%eax
 b2e:	79 07                	jns    b37 <mesa_cond_signal+0x6b>

		return -1;
 b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b35:	eb 05                	jmp    b3c <mesa_cond_signal+0x70>
	}
	return 0;
 b37:	b8 00 00 00 00       	mov    $0x0,%eax

}
 b3c:	c9                   	leave  
 b3d:	c3                   	ret    
