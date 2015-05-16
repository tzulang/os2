
_t:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int  main ()

{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	kthread_id();
   6:	e8 15 03 00 00       	call   320 <kthread_id>

	exit();
   b:	e8 68 02 00 00       	call   278 <exit>

00000010 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	8b 55 10             	mov    0x10(%ebp),%edx
  1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  1e:	89 cb                	mov    %ecx,%ebx
  20:	89 df                	mov    %ebx,%edi
  22:	89 d1                	mov    %edx,%ecx
  24:	fc                   	cld    
  25:	f3 aa                	rep stos %al,%es:(%edi)
  27:	89 ca                	mov    %ecx,%edx
  29:	89 fb                	mov    %edi,%ebx
  2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  31:	5b                   	pop    %ebx
  32:	5f                   	pop    %edi
  33:	5d                   	pop    %ebp
  34:	c3                   	ret    

00000035 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  35:	55                   	push   %ebp
  36:	89 e5                	mov    %esp,%ebp
  38:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  3b:	8b 45 08             	mov    0x8(%ebp),%eax
  3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  41:	90                   	nop
  42:	8b 45 08             	mov    0x8(%ebp),%eax
  45:	8d 50 01             	lea    0x1(%eax),%edx
  48:	89 55 08             	mov    %edx,0x8(%ebp)
  4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  54:	0f b6 12             	movzbl (%edx),%edx
  57:	88 10                	mov    %dl,(%eax)
  59:	0f b6 00             	movzbl (%eax),%eax
  5c:	84 c0                	test   %al,%al
  5e:	75 e2                	jne    42 <strcpy+0xd>
    ;
  return os;
  60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  63:	c9                   	leave  
  64:	c3                   	ret    

00000065 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  68:	eb 08                	jmp    72 <strcmp+0xd>
    p++, q++;
  6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  72:	8b 45 08             	mov    0x8(%ebp),%eax
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	74 10                	je     8c <strcmp+0x27>
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	0f b6 10             	movzbl (%eax),%edx
  82:	8b 45 0c             	mov    0xc(%ebp),%eax
  85:	0f b6 00             	movzbl (%eax),%eax
  88:	38 c2                	cmp    %al,%dl
  8a:	74 de                	je     6a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	0f b6 00             	movzbl (%eax),%eax
  92:	0f b6 d0             	movzbl %al,%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	0f b6 c0             	movzbl %al,%eax
  9e:	29 c2                	sub    %eax,%edx
  a0:	89 d0                	mov    %edx,%eax
}
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    

000000a4 <strlen>:

uint
strlen(char *s)
{
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  b1:	eb 04                	jmp    b7 <strlen+0x13>
  b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	01 d0                	add    %edx,%eax
  bf:	0f b6 00             	movzbl (%eax),%eax
  c2:	84 c0                	test   %al,%al
  c4:	75 ed                	jne    b3 <strlen+0xf>
    ;
  return n;
  c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c9:	c9                   	leave  
  ca:	c3                   	ret    

000000cb <memset>:

void*
memset(void *dst, int c, uint n)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  d1:	8b 45 10             	mov    0x10(%ebp),%eax
  d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	89 44 24 04          	mov    %eax,0x4(%esp)
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	89 04 24             	mov    %eax,(%esp)
  e5:	e8 26 ff ff ff       	call   10 <stosb>
  return dst;
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <strchr>:

char*
strchr(const char *s, char c)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	83 ec 04             	sub    $0x4,%esp
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fb:	eb 14                	jmp    111 <strchr+0x22>
    if(*s == c)
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	3a 45 fc             	cmp    -0x4(%ebp),%al
 106:	75 05                	jne    10d <strchr+0x1e>
      return (char*)s;
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	eb 13                	jmp    120 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	75 e2                	jne    fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <gets>:

char*
gets(char *buf, int max)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12f:	eb 4c                	jmp    17d <gets+0x5b>
    cc = read(0, &c, 1);
 131:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 138:	00 
 139:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13c:	89 44 24 04          	mov    %eax,0x4(%esp)
 140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 147:	e8 44 01 00 00       	call   290 <read>
 14c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 153:	7f 02                	jg     157 <gets+0x35>
      break;
 155:	eb 31                	jmp    188 <gets+0x66>
    buf[i++] = c;
 157:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15a:	8d 50 01             	lea    0x1(%eax),%edx
 15d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 160:	89 c2                	mov    %eax,%edx
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	01 c2                	add    %eax,%edx
 167:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	3c 0a                	cmp    $0xa,%al
 173:	74 13                	je     188 <gets+0x66>
 175:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 179:	3c 0d                	cmp    $0xd,%al
 17b:	74 0b                	je     188 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 180:	83 c0 01             	add    $0x1,%eax
 183:	3b 45 0c             	cmp    0xc(%ebp),%eax
 186:	7c a9                	jl     131 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 188:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 d0                	add    %edx,%eax
 190:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <stat>:

int
stat(char *n, struct stat *st)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a5:	00 
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	89 04 24             	mov    %eax,(%esp)
 1ac:	e8 07 01 00 00       	call   2b8 <open>
 1b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b8:	79 07                	jns    1c1 <stat+0x29>
    return -1;
 1ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bf:	eb 23                	jmp    1e4 <stat+0x4c>
  r = fstat(fd, st);
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cb:	89 04 24             	mov    %eax,(%esp)
 1ce:	e8 fd 00 00 00       	call   2d0 <fstat>
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	89 04 24             	mov    %eax,(%esp)
 1dc:	e8 bf 00 00 00       	call   2a0 <close>
  return r;
 1e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    

000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f3:	eb 25                	jmp    21a <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f8:	89 d0                	mov    %edx,%eax
 1fa:	c1 e0 02             	shl    $0x2,%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	01 c0                	add    %eax,%eax
 201:	89 c1                	mov    %eax,%ecx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	8d 50 01             	lea    0x1(%eax),%edx
 209:	89 55 08             	mov    %edx,0x8(%ebp)
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	0f be c0             	movsbl %al,%eax
 212:	01 c8                	add    %ecx,%eax
 214:	83 e8 30             	sub    $0x30,%eax
 217:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	3c 2f                	cmp    $0x2f,%al
 222:	7e 0a                	jle    22e <atoi+0x48>
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	3c 39                	cmp    $0x39,%al
 22c:	7e c7                	jle    1f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 245:	eb 17                	jmp    25e <memmove+0x2b>
    *dst++ = *src++;
 247:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 250:	8b 55 f8             	mov    -0x8(%ebp),%edx
 253:	8d 4a 01             	lea    0x1(%edx),%ecx
 256:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 259:	0f b6 12             	movzbl (%edx),%edx
 25c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	8b 45 10             	mov    0x10(%ebp),%eax
 261:	8d 50 ff             	lea    -0x1(%eax),%edx
 264:	89 55 10             	mov    %edx,0x10(%ebp)
 267:	85 c0                	test   %eax,%eax
 269:	7f dc                	jg     247 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <exit>:
SYSCALL(exit)
 278:	b8 02 00 00 00       	mov    $0x2,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <wait>:
SYSCALL(wait)
 280:	b8 03 00 00 00       	mov    $0x3,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <pipe>:
SYSCALL(pipe)
 288:	b8 04 00 00 00       	mov    $0x4,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <read>:
SYSCALL(read)
 290:	b8 05 00 00 00       	mov    $0x5,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <write>:
SYSCALL(write)
 298:	b8 10 00 00 00       	mov    $0x10,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <close>:
SYSCALL(close)
 2a0:	b8 15 00 00 00       	mov    $0x15,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <kill>:
SYSCALL(kill)
 2a8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exec>:
SYSCALL(exec)
 2b0:	b8 07 00 00 00       	mov    $0x7,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <open>:
SYSCALL(open)
 2b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mknod>:
SYSCALL(mknod)
 2c0:	b8 11 00 00 00       	mov    $0x11,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <unlink>:
SYSCALL(unlink)
 2c8:	b8 12 00 00 00       	mov    $0x12,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <fstat>:
SYSCALL(fstat)
 2d0:	b8 08 00 00 00       	mov    $0x8,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <link>:
SYSCALL(link)
 2d8:	b8 13 00 00 00       	mov    $0x13,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mkdir>:
SYSCALL(mkdir)
 2e0:	b8 14 00 00 00       	mov    $0x14,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <chdir>:
SYSCALL(chdir)
 2e8:	b8 09 00 00 00       	mov    $0x9,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <dup>:
SYSCALL(dup)
 2f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <getpid>:
SYSCALL(getpid)
 2f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sbrk>:
SYSCALL(sbrk)
 300:	b8 0c 00 00 00       	mov    $0xc,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <sleep>:
SYSCALL(sleep)
 308:	b8 0d 00 00 00       	mov    $0xd,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <uptime>:
SYSCALL(uptime)
 310:	b8 0e 00 00 00       	mov    $0xe,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <kthread_create>:




SYSCALL(kthread_create)
 318:	b8 16 00 00 00       	mov    $0x16,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <kthread_id>:
SYSCALL(kthread_id)
 320:	b8 17 00 00 00       	mov    $0x17,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kthread_exit>:
SYSCALL(kthread_exit)
 328:	b8 18 00 00 00       	mov    $0x18,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <kthread_join>:
SYSCALL(kthread_join)
 330:	b8 19 00 00 00       	mov    $0x19,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
 338:	b8 1a 00 00 00       	mov    $0x1a,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
 340:	b8 1b 00 00 00       	mov    $0x1b,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
 348:	b8 1c 00 00 00       	mov    $0x1c,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
 350:	b8 1d 00 00 00       	mov    $0x1d,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <kthread_mutex_yieldlock>:
 358:	b8 1e 00 00 00       	mov    $0x1e,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 18             	sub    $0x18,%esp
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 373:	00 
 374:	8d 45 f4             	lea    -0xc(%ebp),%eax
 377:	89 44 24 04          	mov    %eax,0x4(%esp)
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	89 04 24             	mov    %eax,(%esp)
 381:	e8 12 ff ff ff       	call   298 <write>
}
 386:	c9                   	leave  
 387:	c3                   	ret    

00000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	56                   	push   %esi
 38c:	53                   	push   %ebx
 38d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 390:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 397:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39b:	74 17                	je     3b4 <printint+0x2c>
 39d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a1:	79 11                	jns    3b4 <printint+0x2c>
    neg = 1;
 3a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	f7 d8                	neg    %eax
 3af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b2:	eb 06                	jmp    3ba <printint+0x32>
  } else {
    x = xx;
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c4:	8d 41 01             	lea    0x1(%ecx),%eax
 3c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d0:	ba 00 00 00 00       	mov    $0x0,%edx
 3d5:	f7 f3                	div    %ebx
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	0f b6 80 68 14 00 00 	movzbl 0x1468(%eax),%eax
 3e0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e4:	8b 75 10             	mov    0x10(%ebp),%esi
 3e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ea:	ba 00 00 00 00       	mov    $0x0,%edx
 3ef:	f7 f6                	div    %esi
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f8:	75 c7                	jne    3c1 <printint+0x39>
  if(neg)
 3fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fe:	74 10                	je     410 <printint+0x88>
    buf[i++] = '-';
 400:	8b 45 f4             	mov    -0xc(%ebp),%eax
 403:	8d 50 01             	lea    0x1(%eax),%edx
 406:	89 55 f4             	mov    %edx,-0xc(%ebp)
 409:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40e:	eb 1f                	jmp    42f <printint+0xa7>
 410:	eb 1d                	jmp    42f <printint+0xa7>
    putc(fd, buf[i]);
 412:	8d 55 dc             	lea    -0x24(%ebp),%edx
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	0f be c0             	movsbl %al,%eax
 420:	89 44 24 04          	mov    %eax,0x4(%esp)
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	89 04 24             	mov    %eax,(%esp)
 42a:	e8 31 ff ff ff       	call   360 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 437:	79 d9                	jns    412 <printint+0x8a>
    putc(fd, buf[i]);
}
 439:	83 c4 30             	add    $0x30,%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 446:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44d:	8d 45 0c             	lea    0xc(%ebp),%eax
 450:	83 c0 04             	add    $0x4,%eax
 453:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 456:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45d:	e9 7c 01 00 00       	jmp    5de <printf+0x19e>
    c = fmt[i] & 0xff;
 462:	8b 55 0c             	mov    0xc(%ebp),%edx
 465:	8b 45 f0             	mov    -0x10(%ebp),%eax
 468:	01 d0                	add    %edx,%eax
 46a:	0f b6 00             	movzbl (%eax),%eax
 46d:	0f be c0             	movsbl %al,%eax
 470:	25 ff 00 00 00       	and    $0xff,%eax
 475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47c:	75 2c                	jne    4aa <printf+0x6a>
      if(c == '%'){
 47e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 482:	75 0c                	jne    490 <printf+0x50>
        state = '%';
 484:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48b:	e9 4a 01 00 00       	jmp    5da <printf+0x19a>
      } else {
        putc(fd, c);
 490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	89 44 24 04          	mov    %eax,0x4(%esp)
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	89 04 24             	mov    %eax,(%esp)
 4a0:	e8 bb fe ff ff       	call   360 <putc>
 4a5:	e9 30 01 00 00       	jmp    5da <printf+0x19a>
      }
    } else if(state == '%'){
 4aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ae:	0f 85 26 01 00 00    	jne    5da <printf+0x19a>
      if(c == 'd'){
 4b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b8:	75 2d                	jne    4e7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bd:	8b 00                	mov    (%eax),%eax
 4bf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c6:	00 
 4c7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ce:	00 
 4cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	89 04 24             	mov    %eax,(%esp)
 4d9:	e8 aa fe ff ff       	call   388 <printint>
        ap++;
 4de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e2:	e9 ec 00 00 00       	jmp    5d3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4eb:	74 06                	je     4f3 <printf+0xb3>
 4ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f1:	75 2d                	jne    520 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ff:	00 
 500:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 507:	00 
 508:	89 44 24 04          	mov    %eax,0x4(%esp)
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	89 04 24             	mov    %eax,(%esp)
 512:	e8 71 fe ff ff       	call   388 <printint>
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 b3 00 00 00       	jmp    5d3 <printf+0x193>
      } else if(c == 's'){
 520:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 524:	75 45                	jne    56b <printf+0x12b>
        s = (char*)*ap;
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 536:	75 09                	jne    541 <printf+0x101>
          s = "(null)";
 538:	c7 45 f4 da 0f 00 00 	movl   $0xfda,-0xc(%ebp)
        while(*s != 0){
 53f:	eb 1e                	jmp    55f <printf+0x11f>
 541:	eb 1c                	jmp    55f <printf+0x11f>
          putc(fd, *s);
 543:	8b 45 f4             	mov    -0xc(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	89 04 24             	mov    %eax,(%esp)
 556:	e8 05 fe ff ff       	call   360 <putc>
          s++;
 55b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	84 c0                	test   %al,%al
 567:	75 da                	jne    543 <printf+0x103>
 569:	eb 68                	jmp    5d3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56f:	75 1d                	jne    58e <printf+0x14e>
        putc(fd, *ap);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 d8 fd ff ff       	call   360 <putc>
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58c:	eb 45                	jmp    5d3 <printf+0x193>
      } else if(c == '%'){
 58e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 592:	75 17                	jne    5ab <printf+0x16b>
        putc(fd, c);
 594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 b7 fd ff ff       	call   360 <putc>
 5a9:	eb 28                	jmp    5d3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b2:	00 
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	89 04 24             	mov    %eax,(%esp)
 5b9:	e8 a2 fd ff ff       	call   360 <putc>
        putc(fd, c);
 5be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c1:	0f be c0             	movsbl %al,%eax
 5c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 8d fd ff ff       	call   360 <putc>
      }
      state = 0;
 5d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5de:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e4:	01 d0                	add    %edx,%eax
 5e6:	0f b6 00             	movzbl (%eax),%eax
 5e9:	84 c0                	test   %al,%al
 5eb:	0f 85 71 fe ff ff    	jne    462 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f1:	c9                   	leave  
 5f2:	c3                   	ret    

000005f3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f3:	55                   	push   %ebp
 5f4:	89 e5                	mov    %esp,%ebp
 5f6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	83 e8 08             	sub    $0x8,%eax
 5ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 602:	a1 84 14 00 00       	mov    0x1484,%eax
 607:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60a:	eb 24                	jmp    630 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 614:	77 12                	ja     628 <free+0x35>
 616:	8b 45 f8             	mov    -0x8(%ebp),%eax
 619:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61c:	77 24                	ja     642 <free+0x4f>
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 626:	77 1a                	ja     642 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 636:	76 d4                	jbe    60c <free+0x19>
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 640:	76 ca                	jbe    60c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	8b 40 04             	mov    0x4(%eax),%eax
 648:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	01 c2                	add    %eax,%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	39 c2                	cmp    %eax,%edx
 65b:	75 24                	jne    681 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	8b 50 04             	mov    0x4(%eax),%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	8b 40 04             	mov    0x4(%eax),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 0a                	jmp    68b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 10                	mov    (%eax),%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a0:	75 20                	jne    6c2 <free+0xcf>
    p->s.size += bp->s.size;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	01 c2                	add    %eax,%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
 6c0:	eb 08                	jmp    6ca <free+0xd7>
  } else
    p->s.ptr = bp;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	a3 84 14 00 00       	mov    %eax,0x1484
}
 6d2:	c9                   	leave  
 6d3:	c3                   	ret    

000006d4 <morecore>:

static Header*
morecore(uint nu)
{
 6d4:	55                   	push   %ebp
 6d5:	89 e5                	mov    %esp,%ebp
 6d7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6da:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e1:	77 07                	ja     6ea <morecore+0x16>
    nu = 4096;
 6e3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ea:	8b 45 08             	mov    0x8(%ebp),%eax
 6ed:	c1 e0 03             	shl    $0x3,%eax
 6f0:	89 04 24             	mov    %eax,(%esp)
 6f3:	e8 08 fc ff ff       	call   300 <sbrk>
 6f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ff:	75 07                	jne    708 <morecore+0x34>
    return 0;
 701:	b8 00 00 00 00       	mov    $0x0,%eax
 706:	eb 22                	jmp    72a <morecore+0x56>
  hp = (Header*)p;
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 711:	8b 55 08             	mov    0x8(%ebp),%edx
 714:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	83 c0 08             	add    $0x8,%eax
 71d:	89 04 24             	mov    %eax,(%esp)
 720:	e8 ce fe ff ff       	call   5f3 <free>
  return freep;
 725:	a1 84 14 00 00       	mov    0x1484,%eax
}
 72a:	c9                   	leave  
 72b:	c3                   	ret    

0000072c <malloc>:

void*
malloc(uint nbytes)
{
 72c:	55                   	push   %ebp
 72d:	89 e5                	mov    %esp,%ebp
 72f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	8b 45 08             	mov    0x8(%ebp),%eax
 735:	83 c0 07             	add    $0x7,%eax
 738:	c1 e8 03             	shr    $0x3,%eax
 73b:	83 c0 01             	add    $0x1,%eax
 73e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 741:	a1 84 14 00 00       	mov    0x1484,%eax
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	75 23                	jne    772 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74f:	c7 45 f0 7c 14 00 00 	movl   $0x147c,-0x10(%ebp)
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	a3 84 14 00 00       	mov    %eax,0x1484
 75e:	a1 84 14 00 00       	mov    0x1484,%eax
 763:	a3 7c 14 00 00       	mov    %eax,0x147c
    base.s.size = 0;
 768:	c7 05 80 14 00 00 00 	movl   $0x0,0x1480
 76f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 783:	72 4d                	jb     7d2 <malloc+0xa6>
      if(p->s.size == nunits)
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78e:	75 0c                	jne    79c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 10                	mov    (%eax),%edx
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	89 10                	mov    %edx,(%eax)
 79a:	eb 26                	jmp    7c2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a5:	89 c2                	mov    %eax,%edx
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	c1 e0 03             	shl    $0x3,%eax
 7b6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	a3 84 14 00 00       	mov    %eax,0x1484
      return (void*)(p + 1);
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	83 c0 08             	add    $0x8,%eax
 7d0:	eb 38                	jmp    80a <malloc+0xde>
    }
    if(p == freep)
 7d2:	a1 84 14 00 00       	mov    0x1484,%eax
 7d7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7da:	75 1b                	jne    7f7 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 ed fe ff ff       	call   6d4 <morecore>
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <malloc+0xcb>
        return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 13                	jmp    80a <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 805:	e9 70 ff ff ff       	jmp    77a <malloc+0x4e>
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
 812:	e8 21 fb ff ff       	call   338 <kthread_mutex_alloc>
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
 81a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81e:	79 0a                	jns    82a <mesa_slots_monitor_alloc+0x1e>

		return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	e9 8b 00 00 00       	jmp    8b5 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
 82a:	e8 44 06 00 00       	call   e73 <mesa_cond_alloc>
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
 832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 836:	75 12                	jne    84a <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	89 04 24             	mov    %eax,(%esp)
 83e:	e8 fd fa ff ff       	call   340 <kthread_mutex_dealloc>
		return 0;
 843:	b8 00 00 00 00       	mov    $0x0,%eax
 848:	eb 6b                	jmp    8b5 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
 84a:	e8 24 06 00 00       	call   e73 <mesa_cond_alloc>
 84f:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
 852:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 856:	75 1d                	jne    875 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	89 04 24             	mov    %eax,(%esp)
 85e:	e8 dd fa ff ff       	call   340 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	89 04 24             	mov    %eax,(%esp)
 869:	e8 46 06 00 00       	call   eb4 <mesa_cond_dealloc>
		return 0;
 86e:	b8 00 00 00 00       	mov    $0x0,%eax
 873:	eb 40                	jmp    8b5 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
 875:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 87c:	e8 ab fe ff ff       	call   72c <malloc>
 881:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
 884:	8b 45 e8             	mov    -0x18(%ebp),%eax
 887:	8b 55 f0             	mov    -0x10(%ebp),%edx
 88a:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
 88d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 890:	8b 55 ec             	mov    -0x14(%ebp),%edx
 893:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
 896:	8b 45 e8             	mov    -0x18(%ebp),%eax
 899:	8b 55 f4             	mov    -0xc(%ebp),%edx
 89c:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
 89e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
 8a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ab:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
 8b2:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    

000008b7 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
 8b7:	55                   	push   %ebp
 8b8:	89 e5                	mov    %esp,%ebp
 8ba:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
 8bd:	8b 45 08             	mov    0x8(%ebp),%eax
 8c0:	8b 00                	mov    (%eax),%eax
 8c2:	89 04 24             	mov    %eax,(%esp)
 8c5:	e8 76 fa ff ff       	call   340 <kthread_mutex_dealloc>
 8ca:	85 c0                	test   %eax,%eax
 8cc:	78 2e                	js     8fc <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	8b 40 04             	mov    0x4(%eax),%eax
 8d4:	89 04 24             	mov    %eax,(%esp)
 8d7:	e8 97 05 00 00       	call   e73 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
 8df:	8b 40 08             	mov    0x8(%eax),%eax
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 89 05 00 00       	call   e73 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
 8ea:	8b 45 08             	mov    0x8(%ebp),%eax
 8ed:	89 04 24             	mov    %eax,(%esp)
 8f0:	e8 fe fc ff ff       	call   5f3 <free>
	return 0;
 8f5:	b8 00 00 00 00       	mov    $0x0,%eax
 8fa:	eb 05                	jmp    901 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
 8fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
 901:	c9                   	leave  
 902:	c3                   	ret    

00000903 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
 903:	55                   	push   %ebp
 904:	89 e5                	mov    %esp,%ebp
 906:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
 909:	8b 45 08             	mov    0x8(%ebp),%eax
 90c:	8b 40 10             	mov    0x10(%eax),%eax
 90f:	85 c0                	test   %eax,%eax
 911:	75 0a                	jne    91d <mesa_slots_monitor_addslots+0x1a>
		return -1;
 913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 918:	e9 81 00 00 00       	jmp    99e <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 91d:	8b 45 08             	mov    0x8(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	89 04 24             	mov    %eax,(%esp)
 925:	e8 1e fa ff ff       	call   348 <kthread_mutex_lock>
 92a:	83 f8 ff             	cmp    $0xffffffff,%eax
 92d:	7d 07                	jge    936 <mesa_slots_monitor_addslots+0x33>
		return -1;
 92f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 934:	eb 68                	jmp    99e <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
 936:	eb 17                	jmp    94f <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
 938:	8b 45 08             	mov    0x8(%ebp),%eax
 93b:	8b 10                	mov    (%eax),%edx
 93d:	8b 45 08             	mov    0x8(%ebp),%eax
 940:	8b 40 08             	mov    0x8(%eax),%eax
 943:	89 54 24 04          	mov    %edx,0x4(%esp)
 947:	89 04 24             	mov    %eax,(%esp)
 94a:	e8 af 05 00 00       	call   efe <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
 94f:	8b 45 08             	mov    0x8(%ebp),%eax
 952:	8b 40 10             	mov    0x10(%eax),%eax
 955:	85 c0                	test   %eax,%eax
 957:	74 0a                	je     963 <mesa_slots_monitor_addslots+0x60>
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	8b 40 0c             	mov    0xc(%eax),%eax
 95f:	85 c0                	test   %eax,%eax
 961:	7f d5                	jg     938 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
 963:	8b 45 08             	mov    0x8(%ebp),%eax
 966:	8b 40 10             	mov    0x10(%eax),%eax
 969:	85 c0                	test   %eax,%eax
 96b:	74 11                	je     97e <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
 96d:	8b 45 08             	mov    0x8(%ebp),%eax
 970:	8b 50 0c             	mov    0xc(%eax),%edx
 973:	8b 45 0c             	mov    0xc(%ebp),%eax
 976:	01 c2                	add    %eax,%edx
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
 97e:	8b 45 08             	mov    0x8(%ebp),%eax
 981:	8b 40 04             	mov    0x4(%eax),%eax
 984:	89 04 24             	mov    %eax,(%esp)
 987:	e8 dc 05 00 00       	call   f68 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 98c:	8b 45 08             	mov    0x8(%ebp),%eax
 98f:	8b 00                	mov    (%eax),%eax
 991:	89 04 24             	mov    %eax,(%esp)
 994:	e8 b7 f9 ff ff       	call   350 <kthread_mutex_unlock>

	return 1;
 999:	b8 01 00 00 00       	mov    $0x1,%eax


}
 99e:	c9                   	leave  
 99f:	c3                   	ret    

000009a0 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
 9a6:	8b 45 08             	mov    0x8(%ebp),%eax
 9a9:	8b 40 10             	mov    0x10(%eax),%eax
 9ac:	85 c0                	test   %eax,%eax
 9ae:	75 07                	jne    9b7 <mesa_slots_monitor_takeslot+0x17>
		return -1;
 9b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9b5:	eb 7f                	jmp    a36 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	8b 00                	mov    (%eax),%eax
 9bc:	89 04 24             	mov    %eax,(%esp)
 9bf:	e8 84 f9 ff ff       	call   348 <kthread_mutex_lock>
 9c4:	83 f8 ff             	cmp    $0xffffffff,%eax
 9c7:	7d 07                	jge    9d0 <mesa_slots_monitor_takeslot+0x30>
		return -1;
 9c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9ce:	eb 66                	jmp    a36 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
 9d0:	eb 17                	jmp    9e9 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	8b 10                	mov    (%eax),%edx
 9d7:	8b 45 08             	mov    0x8(%ebp),%eax
 9da:	8b 40 04             	mov    0x4(%eax),%eax
 9dd:	89 54 24 04          	mov    %edx,0x4(%esp)
 9e1:	89 04 24             	mov    %eax,(%esp)
 9e4:	e8 15 05 00 00       	call   efe <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ec:	8b 40 10             	mov    0x10(%eax),%eax
 9ef:	85 c0                	test   %eax,%eax
 9f1:	74 0a                	je     9fd <mesa_slots_monitor_takeslot+0x5d>
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	8b 40 0c             	mov    0xc(%eax),%eax
 9f9:	85 c0                	test   %eax,%eax
 9fb:	74 d5                	je     9d2 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	8b 40 10             	mov    0x10(%eax),%eax
 a03:	85 c0                	test   %eax,%eax
 a05:	74 0f                	je     a16 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	8b 40 0c             	mov    0xc(%eax),%eax
 a0d:	8d 50 ff             	lea    -0x1(%eax),%edx
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
 a16:	8b 45 08             	mov    0x8(%ebp),%eax
 a19:	8b 40 08             	mov    0x8(%eax),%eax
 a1c:	89 04 24             	mov    %eax,(%esp)
 a1f:	e8 44 05 00 00       	call   f68 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 a24:	8b 45 08             	mov    0x8(%ebp),%eax
 a27:	8b 00                	mov    (%eax),%eax
 a29:	89 04 24             	mov    %eax,(%esp)
 a2c:	e8 1f f9 ff ff       	call   350 <kthread_mutex_unlock>

	return 1;
 a31:	b8 01 00 00 00       	mov    $0x1,%eax

}
 a36:	c9                   	leave  
 a37:	c3                   	ret    

00000a38 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
 a38:	55                   	push   %ebp
 a39:	89 e5                	mov    %esp,%ebp
 a3b:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
 a3e:	8b 45 08             	mov    0x8(%ebp),%eax
 a41:	8b 40 10             	mov    0x10(%eax),%eax
 a44:	85 c0                	test   %eax,%eax
 a46:	75 07                	jne    a4f <mesa_slots_monitor_stopadding+0x17>
			return -1;
 a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a4d:	eb 35                	jmp    a84 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	8b 00                	mov    (%eax),%eax
 a54:	89 04 24             	mov    %eax,(%esp)
 a57:	e8 ec f8 ff ff       	call   348 <kthread_mutex_lock>
 a5c:	83 f8 ff             	cmp    $0xffffffff,%eax
 a5f:	7d 07                	jge    a68 <mesa_slots_monitor_stopadding+0x30>
			return -1;
 a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a66:	eb 1c                	jmp    a84 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
 a68:	8b 45 08             	mov    0x8(%ebp),%eax
 a6b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
 a72:	8b 45 08             	mov    0x8(%ebp),%eax
 a75:	8b 00                	mov    (%eax),%eax
 a77:	89 04 24             	mov    %eax,(%esp)
 a7a:	e8 d1 f8 ff ff       	call   350 <kthread_mutex_unlock>

		return 0;
 a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a84:	c9                   	leave  
 a85:	c3                   	ret    

00000a86 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
 a86:	55                   	push   %ebp
 a87:	89 e5                	mov    %esp,%ebp
 a89:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
 a8c:	e8 a7 f8 ff ff       	call   338 <kthread_mutex_alloc>
 a91:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
 a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a98:	79 0a                	jns    aa4 <hoare_slots_monitor_alloc+0x1e>
		return 0;
 a9a:	b8 00 00 00 00       	mov    $0x0,%eax
 a9f:	e9 8b 00 00 00       	jmp    b2f <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
 aa4:	e8 68 02 00 00       	call   d11 <hoare_cond_alloc>
 aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
 aac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ab0:	75 12                	jne    ac4 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	89 04 24             	mov    %eax,(%esp)
 ab8:	e8 83 f8 ff ff       	call   340 <kthread_mutex_dealloc>
		return 0;
 abd:	b8 00 00 00 00       	mov    $0x0,%eax
 ac2:	eb 6b                	jmp    b2f <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
 ac4:	e8 48 02 00 00       	call   d11 <hoare_cond_alloc>
 ac9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
 acc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad0:	75 1d                	jne    aef <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	89 04 24             	mov    %eax,(%esp)
 ad8:	e8 63 f8 ff ff       	call   340 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	89 04 24             	mov    %eax,(%esp)
 ae3:	e8 6a 02 00 00       	call   d52 <hoare_cond_dealloc>
		return 0;
 ae8:	b8 00 00 00 00       	mov    $0x0,%eax
 aed:	eb 40                	jmp    b2f <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
 aef:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 af6:	e8 31 fc ff ff       	call   72c <malloc>
 afb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
 afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b01:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b04:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
 b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b0d:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
 b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b16:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
 b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
 b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b25:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
 b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
 b2f:	c9                   	leave  
 b30:	c3                   	ret    

00000b31 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
 b31:	55                   	push   %ebp
 b32:	89 e5                	mov    %esp,%ebp
 b34:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
 b37:	8b 45 08             	mov    0x8(%ebp),%eax
 b3a:	8b 00                	mov    (%eax),%eax
 b3c:	89 04 24             	mov    %eax,(%esp)
 b3f:	e8 fc f7 ff ff       	call   340 <kthread_mutex_dealloc>
 b44:	85 c0                	test   %eax,%eax
 b46:	78 2e                	js     b76 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
 b48:	8b 45 08             	mov    0x8(%ebp),%eax
 b4b:	8b 40 04             	mov    0x4(%eax),%eax
 b4e:	89 04 24             	mov    %eax,(%esp)
 b51:	e8 bb 01 00 00       	call   d11 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
 b56:	8b 45 08             	mov    0x8(%ebp),%eax
 b59:	8b 40 08             	mov    0x8(%eax),%eax
 b5c:	89 04 24             	mov    %eax,(%esp)
 b5f:	e8 ad 01 00 00       	call   d11 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
 b64:	8b 45 08             	mov    0x8(%ebp),%eax
 b67:	89 04 24             	mov    %eax,(%esp)
 b6a:	e8 84 fa ff ff       	call   5f3 <free>
	return 0;
 b6f:	b8 00 00 00 00       	mov    $0x0,%eax
 b74:	eb 05                	jmp    b7b <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
 b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
 b7b:	c9                   	leave  
 b7c:	c3                   	ret    

00000b7d <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
 b7d:	55                   	push   %ebp
 b7e:	89 e5                	mov    %esp,%ebp
 b80:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
 b83:	8b 45 08             	mov    0x8(%ebp),%eax
 b86:	8b 40 10             	mov    0x10(%eax),%eax
 b89:	85 c0                	test   %eax,%eax
 b8b:	75 0a                	jne    b97 <hoare_slots_monitor_addslots+0x1a>
		return -1;
 b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b92:	e9 88 00 00 00       	jmp    c1f <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 b97:	8b 45 08             	mov    0x8(%ebp),%eax
 b9a:	8b 00                	mov    (%eax),%eax
 b9c:	89 04 24             	mov    %eax,(%esp)
 b9f:	e8 a4 f7 ff ff       	call   348 <kthread_mutex_lock>
 ba4:	83 f8 ff             	cmp    $0xffffffff,%eax
 ba7:	7d 07                	jge    bb0 <hoare_slots_monitor_addslots+0x33>
		return -1;
 ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bae:	eb 6f                	jmp    c1f <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
 bb0:	8b 45 08             	mov    0x8(%ebp),%eax
 bb3:	8b 40 10             	mov    0x10(%eax),%eax
 bb6:	85 c0                	test   %eax,%eax
 bb8:	74 21                	je     bdb <hoare_slots_monitor_addslots+0x5e>
 bba:	8b 45 08             	mov    0x8(%ebp),%eax
 bbd:	8b 40 0c             	mov    0xc(%eax),%eax
 bc0:	85 c0                	test   %eax,%eax
 bc2:	7e 17                	jle    bdb <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
 bc4:	8b 45 08             	mov    0x8(%ebp),%eax
 bc7:	8b 10                	mov    (%eax),%edx
 bc9:	8b 45 08             	mov    0x8(%ebp),%eax
 bcc:	8b 40 08             	mov    0x8(%eax),%eax
 bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
 bd3:	89 04 24             	mov    %eax,(%esp)
 bd6:	e8 c1 01 00 00       	call   d9c <hoare_cond_wait>


	if  ( monitor->active)
 bdb:	8b 45 08             	mov    0x8(%ebp),%eax
 bde:	8b 40 10             	mov    0x10(%eax),%eax
 be1:	85 c0                	test   %eax,%eax
 be3:	74 11                	je     bf6 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
 be5:	8b 45 08             	mov    0x8(%ebp),%eax
 be8:	8b 50 0c             	mov    0xc(%eax),%edx
 beb:	8b 45 0c             	mov    0xc(%ebp),%eax
 bee:	01 c2                	add    %eax,%edx
 bf0:	8b 45 08             	mov    0x8(%ebp),%eax
 bf3:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
 bf6:	8b 45 08             	mov    0x8(%ebp),%eax
 bf9:	8b 10                	mov    (%eax),%edx
 bfb:	8b 45 08             	mov    0x8(%ebp),%eax
 bfe:	8b 40 04             	mov    0x4(%eax),%eax
 c01:	89 54 24 04          	mov    %edx,0x4(%esp)
 c05:	89 04 24             	mov    %eax,(%esp)
 c08:	e8 e6 01 00 00       	call   df3 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 c0d:	8b 45 08             	mov    0x8(%ebp),%eax
 c10:	8b 00                	mov    (%eax),%eax
 c12:	89 04 24             	mov    %eax,(%esp)
 c15:	e8 36 f7 ff ff       	call   350 <kthread_mutex_unlock>

	return 1;
 c1a:	b8 01 00 00 00       	mov    $0x1,%eax


}
 c1f:	c9                   	leave  
 c20:	c3                   	ret    

00000c21 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
 c21:	55                   	push   %ebp
 c22:	89 e5                	mov    %esp,%ebp
 c24:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
 c27:	8b 45 08             	mov    0x8(%ebp),%eax
 c2a:	8b 40 10             	mov    0x10(%eax),%eax
 c2d:	85 c0                	test   %eax,%eax
 c2f:	75 0a                	jne    c3b <hoare_slots_monitor_takeslot+0x1a>
		return -1;
 c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c36:	e9 86 00 00 00       	jmp    cc1 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 c3b:	8b 45 08             	mov    0x8(%ebp),%eax
 c3e:	8b 00                	mov    (%eax),%eax
 c40:	89 04 24             	mov    %eax,(%esp)
 c43:	e8 00 f7 ff ff       	call   348 <kthread_mutex_lock>
 c48:	83 f8 ff             	cmp    $0xffffffff,%eax
 c4b:	7d 07                	jge    c54 <hoare_slots_monitor_takeslot+0x33>
		return -1;
 c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c52:	eb 6d                	jmp    cc1 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
 c54:	8b 45 08             	mov    0x8(%ebp),%eax
 c57:	8b 40 10             	mov    0x10(%eax),%eax
 c5a:	85 c0                	test   %eax,%eax
 c5c:	74 21                	je     c7f <hoare_slots_monitor_takeslot+0x5e>
 c5e:	8b 45 08             	mov    0x8(%ebp),%eax
 c61:	8b 40 0c             	mov    0xc(%eax),%eax
 c64:	85 c0                	test   %eax,%eax
 c66:	75 17                	jne    c7f <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
 c68:	8b 45 08             	mov    0x8(%ebp),%eax
 c6b:	8b 10                	mov    (%eax),%edx
 c6d:	8b 45 08             	mov    0x8(%ebp),%eax
 c70:	8b 40 04             	mov    0x4(%eax),%eax
 c73:	89 54 24 04          	mov    %edx,0x4(%esp)
 c77:	89 04 24             	mov    %eax,(%esp)
 c7a:	e8 1d 01 00 00       	call   d9c <hoare_cond_wait>


	if  ( monitor->active)
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	8b 40 10             	mov    0x10(%eax),%eax
 c85:	85 c0                	test   %eax,%eax
 c87:	74 0f                	je     c98 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
 c89:	8b 45 08             	mov    0x8(%ebp),%eax
 c8c:	8b 40 0c             	mov    0xc(%eax),%eax
 c8f:	8d 50 ff             	lea    -0x1(%eax),%edx
 c92:	8b 45 08             	mov    0x8(%ebp),%eax
 c95:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
 c98:	8b 45 08             	mov    0x8(%ebp),%eax
 c9b:	8b 10                	mov    (%eax),%edx
 c9d:	8b 45 08             	mov    0x8(%ebp),%eax
 ca0:	8b 40 08             	mov    0x8(%eax),%eax
 ca3:	89 54 24 04          	mov    %edx,0x4(%esp)
 ca7:	89 04 24             	mov    %eax,(%esp)
 caa:	e8 44 01 00 00       	call   df3 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 caf:	8b 45 08             	mov    0x8(%ebp),%eax
 cb2:	8b 00                	mov    (%eax),%eax
 cb4:	89 04 24             	mov    %eax,(%esp)
 cb7:	e8 94 f6 ff ff       	call   350 <kthread_mutex_unlock>

	return 1;
 cbc:	b8 01 00 00 00       	mov    $0x1,%eax

}
 cc1:	c9                   	leave  
 cc2:	c3                   	ret    

00000cc3 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
 cc3:	55                   	push   %ebp
 cc4:	89 e5                	mov    %esp,%ebp
 cc6:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
 cc9:	8b 45 08             	mov    0x8(%ebp),%eax
 ccc:	8b 40 10             	mov    0x10(%eax),%eax
 ccf:	85 c0                	test   %eax,%eax
 cd1:	75 07                	jne    cda <hoare_slots_monitor_stopadding+0x17>
			return -1;
 cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 cd8:	eb 35                	jmp    d0f <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 cda:	8b 45 08             	mov    0x8(%ebp),%eax
 cdd:	8b 00                	mov    (%eax),%eax
 cdf:	89 04 24             	mov    %eax,(%esp)
 ce2:	e8 61 f6 ff ff       	call   348 <kthread_mutex_lock>
 ce7:	83 f8 ff             	cmp    $0xffffffff,%eax
 cea:	7d 07                	jge    cf3 <hoare_slots_monitor_stopadding+0x30>
			return -1;
 cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 cf1:	eb 1c                	jmp    d0f <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
 cf3:	8b 45 08             	mov    0x8(%ebp),%eax
 cf6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
 cfd:	8b 45 08             	mov    0x8(%ebp),%eax
 d00:	8b 00                	mov    (%eax),%eax
 d02:	89 04 24             	mov    %eax,(%esp)
 d05:	e8 46 f6 ff ff       	call   350 <kthread_mutex_unlock>

		return 0;
 d0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d0f:	c9                   	leave  
 d10:	c3                   	ret    

00000d11 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
 d11:	55                   	push   %ebp
 d12:	89 e5                	mov    %esp,%ebp
 d14:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 d17:	e8 1c f6 ff ff       	call   338 <kthread_mutex_alloc>
 d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d23:	79 07                	jns    d2c <hoare_cond_alloc+0x1b>
		return 0;
 d25:	b8 00 00 00 00       	mov    $0x0,%eax
 d2a:	eb 24                	jmp    d50 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
 d2c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d33:	e8 f4 f9 ff ff       	call   72c <malloc>
 d38:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
 d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d41:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
 d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
 d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 d50:	c9                   	leave  
 d51:	c3                   	ret    

00000d52 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
 d52:	55                   	push   %ebp
 d53:	89 e5                	mov    %esp,%ebp
 d55:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
 d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d5c:	75 07                	jne    d65 <hoare_cond_dealloc+0x13>
			return -1;
 d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d63:	eb 35                	jmp    d9a <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
 d65:	8b 45 08             	mov    0x8(%ebp),%eax
 d68:	8b 00                	mov    (%eax),%eax
 d6a:	89 04 24             	mov    %eax,(%esp)
 d6d:	e8 de f5 ff ff       	call   350 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
 d72:	8b 45 08             	mov    0x8(%ebp),%eax
 d75:	8b 00                	mov    (%eax),%eax
 d77:	89 04 24             	mov    %eax,(%esp)
 d7a:	e8 c1 f5 ff ff       	call   340 <kthread_mutex_dealloc>
 d7f:	85 c0                	test   %eax,%eax
 d81:	79 07                	jns    d8a <hoare_cond_dealloc+0x38>
			return -1;
 d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d88:	eb 10                	jmp    d9a <hoare_cond_dealloc+0x48>

		free (hCond);
 d8a:	8b 45 08             	mov    0x8(%ebp),%eax
 d8d:	89 04 24             	mov    %eax,(%esp)
 d90:	e8 5e f8 ff ff       	call   5f3 <free>
		return 0;
 d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d9a:	c9                   	leave  
 d9b:	c3                   	ret    

00000d9c <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
 d9c:	55                   	push   %ebp
 d9d:	89 e5                	mov    %esp,%ebp
 d9f:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 da2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 da6:	75 07                	jne    daf <hoare_cond_wait+0x13>
			return -1;
 da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dad:	eb 42                	jmp    df1 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
 daf:	8b 45 08             	mov    0x8(%ebp),%eax
 db2:	8b 40 04             	mov    0x4(%eax),%eax
 db5:	8d 50 01             	lea    0x1(%eax),%edx
 db8:	8b 45 08             	mov    0x8(%ebp),%eax
 dbb:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
 dbe:	8b 45 08             	mov    0x8(%ebp),%eax
 dc1:	8b 00                	mov    (%eax),%eax
 dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
 dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
 dca:	89 04 24             	mov    %eax,(%esp)
 dcd:	e8 86 f5 ff ff       	call   358 <kthread_mutex_yieldlock>
 dd2:	85 c0                	test   %eax,%eax
 dd4:	79 16                	jns    dec <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
 dd6:	8b 45 08             	mov    0x8(%ebp),%eax
 dd9:	8b 40 04             	mov    0x4(%eax),%eax
 ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
 ddf:	8b 45 08             	mov    0x8(%ebp),%eax
 de2:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dea:	eb 05                	jmp    df1 <hoare_cond_wait+0x55>
		}

	return 0;
 dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
 df1:	c9                   	leave  
 df2:	c3                   	ret    

00000df3 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
 df3:	55                   	push   %ebp
 df4:	89 e5                	mov    %esp,%ebp
 df6:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 dfd:	75 07                	jne    e06 <hoare_cond_signal+0x13>
		return -1;
 dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e04:	eb 6b                	jmp    e71 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
 e06:	8b 45 08             	mov    0x8(%ebp),%eax
 e09:	8b 40 04             	mov    0x4(%eax),%eax
 e0c:	85 c0                	test   %eax,%eax
 e0e:	7e 3d                	jle    e4d <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
 e10:	8b 45 08             	mov    0x8(%ebp),%eax
 e13:	8b 40 04             	mov    0x4(%eax),%eax
 e16:	8d 50 ff             	lea    -0x1(%eax),%edx
 e19:	8b 45 08             	mov    0x8(%ebp),%eax
 e1c:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 e1f:	8b 45 08             	mov    0x8(%ebp),%eax
 e22:	8b 00                	mov    (%eax),%eax
 e24:	89 44 24 04          	mov    %eax,0x4(%esp)
 e28:	8b 45 0c             	mov    0xc(%ebp),%eax
 e2b:	89 04 24             	mov    %eax,(%esp)
 e2e:	e8 25 f5 ff ff       	call   358 <kthread_mutex_yieldlock>
 e33:	85 c0                	test   %eax,%eax
 e35:	79 16                	jns    e4d <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
 e37:	8b 45 08             	mov    0x8(%ebp),%eax
 e3a:	8b 40 04             	mov    0x4(%eax),%eax
 e3d:	8d 50 01             	lea    0x1(%eax),%edx
 e40:	8b 45 08             	mov    0x8(%ebp),%eax
 e43:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 e46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e4b:	eb 24                	jmp    e71 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 e4d:	8b 45 08             	mov    0x8(%ebp),%eax
 e50:	8b 00                	mov    (%eax),%eax
 e52:	89 44 24 04          	mov    %eax,0x4(%esp)
 e56:	8b 45 0c             	mov    0xc(%ebp),%eax
 e59:	89 04 24             	mov    %eax,(%esp)
 e5c:	e8 f7 f4 ff ff       	call   358 <kthread_mutex_yieldlock>
 e61:	85 c0                	test   %eax,%eax
 e63:	79 07                	jns    e6c <hoare_cond_signal+0x79>

    			return -1;
 e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e6a:	eb 05                	jmp    e71 <hoare_cond_signal+0x7e>
    }

	return 0;
 e6c:	b8 00 00 00 00       	mov    $0x0,%eax

}
 e71:	c9                   	leave  
 e72:	c3                   	ret    

00000e73 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
 e73:	55                   	push   %ebp
 e74:	89 e5                	mov    %esp,%ebp
 e76:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 e79:	e8 ba f4 ff ff       	call   338 <kthread_mutex_alloc>
 e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e85:	79 07                	jns    e8e <mesa_cond_alloc+0x1b>
		return 0;
 e87:	b8 00 00 00 00       	mov    $0x0,%eax
 e8c:	eb 24                	jmp    eb2 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
 e8e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e95:	e8 92 f8 ff ff       	call   72c <malloc>
 e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
 e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ea3:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
 ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
 eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 eb2:	c9                   	leave  
 eb3:	c3                   	ret    

00000eb4 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
 eb4:	55                   	push   %ebp
 eb5:	89 e5                	mov    %esp,%ebp
 eb7:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
 eba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ebe:	75 07                	jne    ec7 <mesa_cond_dealloc+0x13>
		return -1;
 ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ec5:	eb 35                	jmp    efc <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
 ec7:	8b 45 08             	mov    0x8(%ebp),%eax
 eca:	8b 00                	mov    (%eax),%eax
 ecc:	89 04 24             	mov    %eax,(%esp)
 ecf:	e8 7c f4 ff ff       	call   350 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
 ed4:	8b 45 08             	mov    0x8(%ebp),%eax
 ed7:	8b 00                	mov    (%eax),%eax
 ed9:	89 04 24             	mov    %eax,(%esp)
 edc:	e8 5f f4 ff ff       	call   340 <kthread_mutex_dealloc>
 ee1:	85 c0                	test   %eax,%eax
 ee3:	79 07                	jns    eec <mesa_cond_dealloc+0x38>
		return -1;
 ee5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 eea:	eb 10                	jmp    efc <mesa_cond_dealloc+0x48>

	free (mCond);
 eec:	8b 45 08             	mov    0x8(%ebp),%eax
 eef:	89 04 24             	mov    %eax,(%esp)
 ef2:	e8 fc f6 ff ff       	call   5f3 <free>
	return 0;
 ef7:	b8 00 00 00 00       	mov    $0x0,%eax

}
 efc:	c9                   	leave  
 efd:	c3                   	ret    

00000efe <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
 efe:	55                   	push   %ebp
 eff:	89 e5                	mov    %esp,%ebp
 f01:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 f04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 f08:	75 07                	jne    f11 <mesa_cond_wait+0x13>
		return -1;
 f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f0f:	eb 55                	jmp    f66 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
 f11:	8b 45 08             	mov    0x8(%ebp),%eax
 f14:	8b 40 04             	mov    0x4(%eax),%eax
 f17:	8d 50 01             	lea    0x1(%eax),%edx
 f1a:	8b 45 08             	mov    0x8(%ebp),%eax
 f1d:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
 f20:	8b 45 0c             	mov    0xc(%ebp),%eax
 f23:	89 04 24             	mov    %eax,(%esp)
 f26:	e8 25 f4 ff ff       	call   350 <kthread_mutex_unlock>
 f2b:	85 c0                	test   %eax,%eax
 f2d:	79 27                	jns    f56 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
 f2f:	8b 45 08             	mov    0x8(%ebp),%eax
 f32:	8b 00                	mov    (%eax),%eax
 f34:	89 04 24             	mov    %eax,(%esp)
 f37:	e8 0c f4 ff ff       	call   348 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
 f3c:	85 c0                	test   %eax,%eax
 f3e:	79 16                	jns    f56 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
 f40:	8b 45 08             	mov    0x8(%ebp),%eax
 f43:	8b 40 04             	mov    0x4(%eax),%eax
 f46:	8d 50 ff             	lea    -0x1(%eax),%edx
 f49:	8b 45 08             	mov    0x8(%ebp),%eax
 f4c:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
 f4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f54:	eb 10                	jmp    f66 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
 f56:	8b 45 0c             	mov    0xc(%ebp),%eax
 f59:	89 04 24             	mov    %eax,(%esp)
 f5c:	e8 e7 f3 ff ff       	call   348 <kthread_mutex_lock>
	return 0;
 f61:	b8 00 00 00 00       	mov    $0x0,%eax


}
 f66:	c9                   	leave  
 f67:	c3                   	ret    

00000f68 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
 f68:	55                   	push   %ebp
 f69:	89 e5                	mov    %esp,%ebp
 f6b:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 f6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 f72:	75 07                	jne    f7b <mesa_cond_signal+0x13>
		return -1;
 f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f79:	eb 5d                	jmp    fd8 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
 f7b:	8b 45 08             	mov    0x8(%ebp),%eax
 f7e:	8b 40 04             	mov    0x4(%eax),%eax
 f81:	85 c0                	test   %eax,%eax
 f83:	7e 36                	jle    fbb <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
 f85:	8b 45 08             	mov    0x8(%ebp),%eax
 f88:	8b 40 04             	mov    0x4(%eax),%eax
 f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
 f8e:	8b 45 08             	mov    0x8(%ebp),%eax
 f91:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
 f94:	8b 45 08             	mov    0x8(%ebp),%eax
 f97:	8b 00                	mov    (%eax),%eax
 f99:	89 04 24             	mov    %eax,(%esp)
 f9c:	e8 af f3 ff ff       	call   350 <kthread_mutex_unlock>
 fa1:	85 c0                	test   %eax,%eax
 fa3:	78 16                	js     fbb <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
 fa5:	8b 45 08             	mov    0x8(%ebp),%eax
 fa8:	8b 40 04             	mov    0x4(%eax),%eax
 fab:	8d 50 01             	lea    0x1(%eax),%edx
 fae:	8b 45 08             	mov    0x8(%ebp),%eax
 fb1:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
 fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 fb9:	eb 1d                	jmp    fd8 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
 fbb:	8b 45 08             	mov    0x8(%ebp),%eax
 fbe:	8b 00                	mov    (%eax),%eax
 fc0:	89 04 24             	mov    %eax,(%esp)
 fc3:	e8 88 f3 ff ff       	call   350 <kthread_mutex_unlock>
 fc8:	85 c0                	test   %eax,%eax
 fca:	79 07                	jns    fd3 <mesa_cond_signal+0x6b>

		return -1;
 fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 fd1:	eb 05                	jmp    fd8 <mesa_cond_signal+0x70>
	}
	return 0;
 fd3:	b8 00 00 00 00       	mov    $0x0,%eax

}
 fd8:	c9                   	leave  
 fd9:	c3                   	ret    
