
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 75 02 00 00       	call   283 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fd 02 00 00       	call   31b <sleep>
  exit();
  1e:	e8 68 02 00 00       	call   28b <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 44 01 00 00       	call   2a3 <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 07 01 00 00       	call   2cb <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 fd 00 00 00       	call   2e3 <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 bf 00 00 00       	call   2b3 <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exit>:
SYSCALL(exit)
 28b:	b8 02 00 00 00       	mov    $0x2,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <wait>:
SYSCALL(wait)
 293:	b8 03 00 00 00       	mov    $0x3,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <pipe>:
SYSCALL(pipe)
 29b:	b8 04 00 00 00       	mov    $0x4,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <read>:
SYSCALL(read)
 2a3:	b8 05 00 00 00       	mov    $0x5,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <write>:
SYSCALL(write)
 2ab:	b8 10 00 00 00       	mov    $0x10,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <close>:
SYSCALL(close)
 2b3:	b8 15 00 00 00       	mov    $0x15,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <kill>:
SYSCALL(kill)
 2bb:	b8 06 00 00 00       	mov    $0x6,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exec>:
SYSCALL(exec)
 2c3:	b8 07 00 00 00       	mov    $0x7,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <open>:
SYSCALL(open)
 2cb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <mknod>:
SYSCALL(mknod)
 2d3:	b8 11 00 00 00       	mov    $0x11,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <unlink>:
SYSCALL(unlink)
 2db:	b8 12 00 00 00       	mov    $0x12,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <fstat>:
SYSCALL(fstat)
 2e3:	b8 08 00 00 00       	mov    $0x8,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <link>:
SYSCALL(link)
 2eb:	b8 13 00 00 00       	mov    $0x13,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mkdir>:
SYSCALL(mkdir)
 2f3:	b8 14 00 00 00       	mov    $0x14,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <chdir>:
SYSCALL(chdir)
 2fb:	b8 09 00 00 00       	mov    $0x9,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <dup>:
SYSCALL(dup)
 303:	b8 0a 00 00 00       	mov    $0xa,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <getpid>:
SYSCALL(getpid)
 30b:	b8 0b 00 00 00       	mov    $0xb,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sbrk>:
SYSCALL(sbrk)
 313:	b8 0c 00 00 00       	mov    $0xc,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sleep>:
SYSCALL(sleep)
 31b:	b8 0d 00 00 00       	mov    $0xd,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <uptime>:
SYSCALL(uptime)
 323:	b8 0e 00 00 00       	mov    $0xe,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <kthread_create>:




SYSCALL(kthread_create)
 32b:	b8 16 00 00 00       	mov    $0x16,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <kthread_id>:
SYSCALL(kthread_id)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <kthread_exit>:
SYSCALL(kthread_exit)
 33b:	b8 18 00 00 00       	mov    $0x18,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <kthread_join>:
SYSCALL(kthread_join)
 343:	b8 19 00 00 00       	mov    $0x19,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
 34b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
 353:	b8 1b 00 00 00       	mov    $0x1b,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
 35b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
 363:	b8 1d 00 00 00       	mov    $0x1d,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <kthread_mutex_yieldlock>:
 36b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	83 ec 18             	sub    $0x18,%esp
 379:	8b 45 0c             	mov    0xc(%ebp),%eax
 37c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 386:	00 
 387:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38a:	89 44 24 04          	mov    %eax,0x4(%esp)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	89 04 24             	mov    %eax,(%esp)
 394:	e8 12 ff ff ff       	call   2ab <write>
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	56                   	push   %esi
 39f:	53                   	push   %ebx
 3a0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ae:	74 17                	je     3c7 <printint+0x2c>
 3b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b4:	79 11                	jns    3c7 <printint+0x2c>
    neg = 1;
 3b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	f7 d8                	neg    %eax
 3c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c5:	eb 06                	jmp    3cd <printint+0x32>
  } else {
    x = xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d7:	8d 41 01             	lea    0x1(%ecx),%eax
 3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e3:	ba 00 00 00 00       	mov    $0x0,%edx
 3e8:	f7 f3                	div    %ebx
 3ea:	89 d0                	mov    %edx,%eax
 3ec:	0f b6 80 78 14 00 00 	movzbl 0x1478(%eax),%eax
 3f3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f7:	8b 75 10             	mov    0x10(%ebp),%esi
 3fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fd:	ba 00 00 00 00       	mov    $0x0,%edx
 402:	f7 f6                	div    %esi
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 c7                	jne    3d4 <printint+0x39>
  if(neg)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	74 10                	je     423 <printint+0x88>
    buf[i++] = '-';
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 421:	eb 1f                	jmp    442 <printint+0xa7>
 423:	eb 1d                	jmp    442 <printint+0xa7>
    putc(fd, buf[i]);
 425:	8d 55 dc             	lea    -0x24(%ebp),%edx
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	0f be c0             	movsbl %al,%eax
 433:	89 44 24 04          	mov    %eax,0x4(%esp)
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	89 04 24             	mov    %eax,(%esp)
 43d:	e8 31 ff ff ff       	call   373 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 442:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44a:	79 d9                	jns    425 <printint+0x8a>
    putc(fd, buf[i]);
}
 44c:	83 c4 30             	add    $0x30,%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    

00000453 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 459:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 460:	8d 45 0c             	lea    0xc(%ebp),%eax
 463:	83 c0 04             	add    $0x4,%eax
 466:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 470:	e9 7c 01 00 00       	jmp    5f1 <printf+0x19e>
    c = fmt[i] & 0xff;
 475:	8b 55 0c             	mov    0xc(%ebp),%edx
 478:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	0f be c0             	movsbl %al,%eax
 483:	25 ff 00 00 00       	and    $0xff,%eax
 488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 2c                	jne    4bd <printf+0x6a>
      if(c == '%'){
 491:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 495:	75 0c                	jne    4a3 <printf+0x50>
        state = '%';
 497:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49e:	e9 4a 01 00 00       	jmp    5ed <printf+0x19a>
      } else {
        putc(fd, c);
 4a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	89 04 24             	mov    %eax,(%esp)
 4b3:	e8 bb fe ff ff       	call   373 <putc>
 4b8:	e9 30 01 00 00       	jmp    5ed <printf+0x19a>
      }
    } else if(state == '%'){
 4bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c1:	0f 85 26 01 00 00    	jne    5ed <printf+0x19a>
      if(c == 'd'){
 4c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cb:	75 2d                	jne    4fa <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d9:	00 
 4da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e1:	00 
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 aa fe ff ff       	call   39b <printint>
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f5:	e9 ec 00 00 00       	jmp    5e6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4fa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fe:	74 06                	je     506 <printf+0xb3>
 500:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 504:	75 2d                	jne    533 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 512:	00 
 513:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51a:	00 
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 71 fe ff ff       	call   39b <printint>
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52e:	e9 b3 00 00 00       	jmp    5e6 <printf+0x193>
      } else if(c == 's'){
 533:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 537:	75 45                	jne    57e <printf+0x12b>
        s = (char*)*ap;
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 549:	75 09                	jne    554 <printf+0x101>
          s = "(null)";
 54b:	c7 45 f4 ed 0f 00 00 	movl   $0xfed,-0xc(%ebp)
        while(*s != 0){
 552:	eb 1e                	jmp    572 <printf+0x11f>
 554:	eb 1c                	jmp    572 <printf+0x11f>
          putc(fd, *s);
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 05 fe ff ff       	call   373 <putc>
          s++;
 56e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	84 c0                	test   %al,%al
 57a:	75 da                	jne    556 <printf+0x103>
 57c:	eb 68                	jmp    5e6 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 582:	75 1d                	jne    5a1 <printf+0x14e>
        putc(fd, *ap);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	89 44 24 04          	mov    %eax,0x4(%esp)
 590:	8b 45 08             	mov    0x8(%ebp),%eax
 593:	89 04 24             	mov    %eax,(%esp)
 596:	e8 d8 fd ff ff       	call   373 <putc>
        ap++;
 59b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59f:	eb 45                	jmp    5e6 <printf+0x193>
      } else if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 17                	jne    5be <printf+0x16b>
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	89 04 24             	mov    %eax,(%esp)
 5b7:	e8 b7 fd ff ff       	call   373 <putc>
 5bc:	eb 28                	jmp    5e6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5be:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c5:	00 
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	89 04 24             	mov    %eax,(%esp)
 5cc:	e8 a2 fd ff ff       	call   373 <putc>
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 8d fd ff ff       	call   373 <putc>
      }
      state = 0;
 5e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ed:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f7:	01 d0                	add    %edx,%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	84 c0                	test   %al,%al
 5fe:	0f 85 71 fe ff ff    	jne    475 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 604:	c9                   	leave  
 605:	c3                   	ret    

00000606 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	83 e8 08             	sub    $0x8,%eax
 612:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 615:	a1 94 14 00 00       	mov    0x1494,%eax
 61a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61d:	eb 24                	jmp    643 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 627:	77 12                	ja     63b <free+0x35>
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62f:	77 24                	ja     655 <free+0x4f>
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 639:	77 1a                	ja     655 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	89 45 fc             	mov    %eax,-0x4(%ebp)
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 649:	76 d4                	jbe    61f <free+0x19>
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 653:	76 ca                	jbe    61f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	8b 40 04             	mov    0x4(%eax),%eax
 65b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	01 c2                	add    %eax,%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	39 c2                	cmp    %eax,%edx
 66e:	75 24                	jne    694 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 50 04             	mov    0x4(%eax),%edx
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	01 c2                	add    %eax,%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	8b 10                	mov    (%eax),%edx
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	89 10                	mov    %edx,(%eax)
 692:	eb 0a                	jmp    69e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 10                	mov    (%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	01 d0                	add    %edx,%eax
 6b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b3:	75 20                	jne    6d5 <free+0xcf>
    p->s.size += bp->s.size;
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 50 04             	mov    0x4(%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	01 c2                	add    %eax,%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 10                	mov    (%eax),%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	89 10                	mov    %edx,(%eax)
 6d3:	eb 08                	jmp    6dd <free+0xd7>
  } else
    p->s.ptr = bp;
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6db:	89 10                	mov    %edx,(%eax)
  freep = p;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	a3 94 14 00 00       	mov    %eax,0x1494
}
 6e5:	c9                   	leave  
 6e6:	c3                   	ret    

000006e7 <morecore>:

static Header*
morecore(uint nu)
{
 6e7:	55                   	push   %ebp
 6e8:	89 e5                	mov    %esp,%ebp
 6ea:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ed:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f4:	77 07                	ja     6fd <morecore+0x16>
    nu = 4096;
 6f6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	c1 e0 03             	shl    $0x3,%eax
 703:	89 04 24             	mov    %eax,(%esp)
 706:	e8 08 fc ff ff       	call   313 <sbrk>
 70b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 712:	75 07                	jne    71b <morecore+0x34>
    return 0;
 714:	b8 00 00 00 00       	mov    $0x0,%eax
 719:	eb 22                	jmp    73d <morecore+0x56>
  hp = (Header*)p;
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	8b 55 08             	mov    0x8(%ebp),%edx
 727:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	83 c0 08             	add    $0x8,%eax
 730:	89 04 24             	mov    %eax,(%esp)
 733:	e8 ce fe ff ff       	call   606 <free>
  return freep;
 738:	a1 94 14 00 00       	mov    0x1494,%eax
}
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <malloc>:

void*
malloc(uint nbytes)
{
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	83 c0 07             	add    $0x7,%eax
 74b:	c1 e8 03             	shr    $0x3,%eax
 74e:	83 c0 01             	add    $0x1,%eax
 751:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 754:	a1 94 14 00 00       	mov    0x1494,%eax
 759:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 760:	75 23                	jne    785 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 762:	c7 45 f0 8c 14 00 00 	movl   $0x148c,-0x10(%ebp)
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	a3 94 14 00 00       	mov    %eax,0x1494
 771:	a1 94 14 00 00       	mov    0x1494,%eax
 776:	a3 8c 14 00 00       	mov    %eax,0x148c
    base.s.size = 0;
 77b:	c7 05 90 14 00 00 00 	movl   $0x0,0x1490
 782:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 796:	72 4d                	jb     7e5 <malloc+0xa6>
      if(p->s.size == nunits)
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a1:	75 0c                	jne    7af <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	89 10                	mov    %edx,(%eax)
 7ad:	eb 26                	jmp    7d5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b8:	89 c2                	mov    %eax,%edx
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	a3 94 14 00 00       	mov    %eax,0x1494
      return (void*)(p + 1);
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	83 c0 08             	add    $0x8,%eax
 7e3:	eb 38                	jmp    81d <malloc+0xde>
    }
    if(p == freep)
 7e5:	a1 94 14 00 00       	mov    0x1494,%eax
 7ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ed:	75 1b                	jne    80a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f2:	89 04 24             	mov    %eax,(%esp)
 7f5:	e8 ed fe ff ff       	call   6e7 <morecore>
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 801:	75 07                	jne    80a <malloc+0xcb>
        return 0;
 803:	b8 00 00 00 00       	mov    $0x0,%eax
 808:	eb 13                	jmp    81d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 818:	e9 70 ff ff ff       	jmp    78d <malloc+0x4e>
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
 825:	e8 21 fb ff ff       	call   34b <kthread_mutex_alloc>
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	79 0a                	jns    83d <mesa_slots_monitor_alloc+0x1e>
		return 0;
 833:	b8 00 00 00 00       	mov    $0x0,%eax
 838:	e9 8b 00 00 00       	jmp    8c8 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
 83d:	e8 44 06 00 00       	call   e86 <mesa_cond_alloc>
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
 845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 849:	75 12                	jne    85d <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	89 04 24             	mov    %eax,(%esp)
 851:	e8 fd fa ff ff       	call   353 <kthread_mutex_dealloc>
		return 0;
 856:	b8 00 00 00 00       	mov    $0x0,%eax
 85b:	eb 6b                	jmp    8c8 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
 85d:	e8 24 06 00 00       	call   e86 <mesa_cond_alloc>
 862:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
 865:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 869:	75 1d                	jne    888 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	89 04 24             	mov    %eax,(%esp)
 871:	e8 dd fa ff ff       	call   353 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 46 06 00 00       	call   ec7 <mesa_cond_dealloc>
		return 0;
 881:	b8 00 00 00 00       	mov    $0x0,%eax
 886:	eb 40                	jmp    8c8 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
 888:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 88f:	e8 ab fe ff ff       	call   73f <malloc>
 894:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
 897:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89a:	8b 55 f0             	mov    -0x10(%ebp),%edx
 89d:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
 8a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a6:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
 8a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8af:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
 8b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
 8bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8be:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
 8c5:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
 8c8:	c9                   	leave  
 8c9:	c3                   	ret    

000008ca <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
 8ca:	55                   	push   %ebp
 8cb:	89 e5                	mov    %esp,%ebp
 8cd:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	89 04 24             	mov    %eax,(%esp)
 8d8:	e8 76 fa ff ff       	call   353 <kthread_mutex_dealloc>
 8dd:	85 c0                	test   %eax,%eax
 8df:	78 2e                	js     90f <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
 8e1:	8b 45 08             	mov    0x8(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	89 04 24             	mov    %eax,(%esp)
 8ea:	e8 97 05 00 00       	call   e86 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
 8ef:	8b 45 08             	mov    0x8(%ebp),%eax
 8f2:	8b 40 08             	mov    0x8(%eax),%eax
 8f5:	89 04 24             	mov    %eax,(%esp)
 8f8:	e8 89 05 00 00       	call   e86 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
 900:	89 04 24             	mov    %eax,(%esp)
 903:	e8 fe fc ff ff       	call   606 <free>
	return 0;
 908:	b8 00 00 00 00       	mov    $0x0,%eax
 90d:	eb 05                	jmp    914 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
 90f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
 914:	c9                   	leave  
 915:	c3                   	ret    

00000916 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
 916:	55                   	push   %ebp
 917:	89 e5                	mov    %esp,%ebp
 919:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
 91c:	8b 45 08             	mov    0x8(%ebp),%eax
 91f:	8b 40 10             	mov    0x10(%eax),%eax
 922:	85 c0                	test   %eax,%eax
 924:	75 0a                	jne    930 <mesa_slots_monitor_addslots+0x1a>
		return -1;
 926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 92b:	e9 81 00 00 00       	jmp    9b1 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 930:	8b 45 08             	mov    0x8(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	89 04 24             	mov    %eax,(%esp)
 938:	e8 1e fa ff ff       	call   35b <kthread_mutex_lock>
 93d:	83 f8 ff             	cmp    $0xffffffff,%eax
 940:	7d 07                	jge    949 <mesa_slots_monitor_addslots+0x33>
		return -1;
 942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 947:	eb 68                	jmp    9b1 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
 949:	eb 17                	jmp    962 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
 94b:	8b 45 08             	mov    0x8(%ebp),%eax
 94e:	8b 10                	mov    (%eax),%edx
 950:	8b 45 08             	mov    0x8(%ebp),%eax
 953:	8b 40 08             	mov    0x8(%eax),%eax
 956:	89 54 24 04          	mov    %edx,0x4(%esp)
 95a:	89 04 24             	mov    %eax,(%esp)
 95d:	e8 af 05 00 00       	call   f11 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
 962:	8b 45 08             	mov    0x8(%ebp),%eax
 965:	8b 40 10             	mov    0x10(%eax),%eax
 968:	85 c0                	test   %eax,%eax
 96a:	74 0a                	je     976 <mesa_slots_monitor_addslots+0x60>
 96c:	8b 45 08             	mov    0x8(%ebp),%eax
 96f:	8b 40 0c             	mov    0xc(%eax),%eax
 972:	85 c0                	test   %eax,%eax
 974:	7f d5                	jg     94b <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
 976:	8b 45 08             	mov    0x8(%ebp),%eax
 979:	8b 40 10             	mov    0x10(%eax),%eax
 97c:	85 c0                	test   %eax,%eax
 97e:	74 11                	je     991 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	8b 50 0c             	mov    0xc(%eax),%edx
 986:	8b 45 0c             	mov    0xc(%ebp),%eax
 989:	01 c2                	add    %eax,%edx
 98b:	8b 45 08             	mov    0x8(%ebp),%eax
 98e:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
 991:	8b 45 08             	mov    0x8(%ebp),%eax
 994:	8b 40 04             	mov    0x4(%eax),%eax
 997:	89 04 24             	mov    %eax,(%esp)
 99a:	e8 dc 05 00 00       	call   f7b <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	8b 00                	mov    (%eax),%eax
 9a4:	89 04 24             	mov    %eax,(%esp)
 9a7:	e8 b7 f9 ff ff       	call   363 <kthread_mutex_unlock>

	return 1;
 9ac:	b8 01 00 00 00       	mov    $0x1,%eax


}
 9b1:	c9                   	leave  
 9b2:	c3                   	ret    

000009b3 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
 9b3:	55                   	push   %ebp
 9b4:	89 e5                	mov    %esp,%ebp
 9b6:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
 9b9:	8b 45 08             	mov    0x8(%ebp),%eax
 9bc:	8b 40 10             	mov    0x10(%eax),%eax
 9bf:	85 c0                	test   %eax,%eax
 9c1:	75 07                	jne    9ca <mesa_slots_monitor_takeslot+0x17>
		return -1;
 9c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9c8:	eb 7f                	jmp    a49 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 9ca:	8b 45 08             	mov    0x8(%ebp),%eax
 9cd:	8b 00                	mov    (%eax),%eax
 9cf:	89 04 24             	mov    %eax,(%esp)
 9d2:	e8 84 f9 ff ff       	call   35b <kthread_mutex_lock>
 9d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9da:	7d 07                	jge    9e3 <mesa_slots_monitor_takeslot+0x30>
		return -1;
 9dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9e1:	eb 66                	jmp    a49 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
 9e3:	eb 17                	jmp    9fc <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	8b 10                	mov    (%eax),%edx
 9ea:	8b 45 08             	mov    0x8(%ebp),%eax
 9ed:	8b 40 04             	mov    0x4(%eax),%eax
 9f0:	89 54 24 04          	mov    %edx,0x4(%esp)
 9f4:	89 04 24             	mov    %eax,(%esp)
 9f7:	e8 15 05 00 00       	call   f11 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
 9fc:	8b 45 08             	mov    0x8(%ebp),%eax
 9ff:	8b 40 10             	mov    0x10(%eax),%eax
 a02:	85 c0                	test   %eax,%eax
 a04:	74 0a                	je     a10 <mesa_slots_monitor_takeslot+0x5d>
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	8b 40 0c             	mov    0xc(%eax),%eax
 a0c:	85 c0                	test   %eax,%eax
 a0e:	74 d5                	je     9e5 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	8b 40 10             	mov    0x10(%eax),%eax
 a16:	85 c0                	test   %eax,%eax
 a18:	74 0f                	je     a29 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
 a1a:	8b 45 08             	mov    0x8(%ebp),%eax
 a1d:	8b 40 0c             	mov    0xc(%eax),%eax
 a20:	8d 50 ff             	lea    -0x1(%eax),%edx
 a23:	8b 45 08             	mov    0x8(%ebp),%eax
 a26:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	8b 40 08             	mov    0x8(%eax),%eax
 a2f:	89 04 24             	mov    %eax,(%esp)
 a32:	e8 44 05 00 00       	call   f7b <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 a37:	8b 45 08             	mov    0x8(%ebp),%eax
 a3a:	8b 00                	mov    (%eax),%eax
 a3c:	89 04 24             	mov    %eax,(%esp)
 a3f:	e8 1f f9 ff ff       	call   363 <kthread_mutex_unlock>

	return 1;
 a44:	b8 01 00 00 00       	mov    $0x1,%eax

}
 a49:	c9                   	leave  
 a4a:	c3                   	ret    

00000a4b <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
 a4b:	55                   	push   %ebp
 a4c:	89 e5                	mov    %esp,%ebp
 a4e:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
 a51:	8b 45 08             	mov    0x8(%ebp),%eax
 a54:	8b 40 10             	mov    0x10(%eax),%eax
 a57:	85 c0                	test   %eax,%eax
 a59:	75 07                	jne    a62 <mesa_slots_monitor_stopadding+0x17>
			return -1;
 a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a60:	eb 35                	jmp    a97 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	89 04 24             	mov    %eax,(%esp)
 a6a:	e8 ec f8 ff ff       	call   35b <kthread_mutex_lock>
 a6f:	83 f8 ff             	cmp    $0xffffffff,%eax
 a72:	7d 07                	jge    a7b <mesa_slots_monitor_stopadding+0x30>
			return -1;
 a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a79:	eb 1c                	jmp    a97 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
 a7b:	8b 45 08             	mov    0x8(%ebp),%eax
 a7e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
 a85:	8b 45 08             	mov    0x8(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	89 04 24             	mov    %eax,(%esp)
 a8d:	e8 d1 f8 ff ff       	call   363 <kthread_mutex_unlock>

		return 0;
 a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a97:	c9                   	leave  
 a98:	c3                   	ret    

00000a99 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
 a99:	55                   	push   %ebp
 a9a:	89 e5                	mov    %esp,%ebp
 a9c:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
 a9f:	e8 a7 f8 ff ff       	call   34b <kthread_mutex_alloc>
 aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
 aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aab:	79 0a                	jns    ab7 <hoare_slots_monitor_alloc+0x1e>
		return 0;
 aad:	b8 00 00 00 00       	mov    $0x0,%eax
 ab2:	e9 8b 00 00 00       	jmp    b42 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
 ab7:	e8 68 02 00 00       	call   d24 <hoare_cond_alloc>
 abc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
 abf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ac3:	75 12                	jne    ad7 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	89 04 24             	mov    %eax,(%esp)
 acb:	e8 83 f8 ff ff       	call   353 <kthread_mutex_dealloc>
		return 0;
 ad0:	b8 00 00 00 00       	mov    $0x0,%eax
 ad5:	eb 6b                	jmp    b42 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
 ad7:	e8 48 02 00 00       	call   d24 <hoare_cond_alloc>
 adc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
 adf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ae3:	75 1d                	jne    b02 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	89 04 24             	mov    %eax,(%esp)
 aeb:	e8 63 f8 ff ff       	call   353 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
 af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af3:	89 04 24             	mov    %eax,(%esp)
 af6:	e8 6a 02 00 00       	call   d65 <hoare_cond_dealloc>
		return 0;
 afb:	b8 00 00 00 00       	mov    $0x0,%eax
 b00:	eb 40                	jmp    b42 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
 b02:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 b09:	e8 31 fc ff ff       	call   73f <malloc>
 b0e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
 b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b17:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
 b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b20:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
 b23:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b29:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
 b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
 b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b38:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
 b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
 b42:	c9                   	leave  
 b43:	c3                   	ret    

00000b44 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
 b44:	55                   	push   %ebp
 b45:	89 e5                	mov    %esp,%ebp
 b47:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
 b4a:	8b 45 08             	mov    0x8(%ebp),%eax
 b4d:	8b 00                	mov    (%eax),%eax
 b4f:	89 04 24             	mov    %eax,(%esp)
 b52:	e8 fc f7 ff ff       	call   353 <kthread_mutex_dealloc>
 b57:	85 c0                	test   %eax,%eax
 b59:	78 2e                	js     b89 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
 b5b:	8b 45 08             	mov    0x8(%ebp),%eax
 b5e:	8b 40 04             	mov    0x4(%eax),%eax
 b61:	89 04 24             	mov    %eax,(%esp)
 b64:	e8 bb 01 00 00       	call   d24 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
 b69:	8b 45 08             	mov    0x8(%ebp),%eax
 b6c:	8b 40 08             	mov    0x8(%eax),%eax
 b6f:	89 04 24             	mov    %eax,(%esp)
 b72:	e8 ad 01 00 00       	call   d24 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
 b77:	8b 45 08             	mov    0x8(%ebp),%eax
 b7a:	89 04 24             	mov    %eax,(%esp)
 b7d:	e8 84 fa ff ff       	call   606 <free>
	return 0;
 b82:	b8 00 00 00 00       	mov    $0x0,%eax
 b87:	eb 05                	jmp    b8e <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
 b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
 b8e:	c9                   	leave  
 b8f:	c3                   	ret    

00000b90 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
 b90:	55                   	push   %ebp
 b91:	89 e5                	mov    %esp,%ebp
 b93:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
 b96:	8b 45 08             	mov    0x8(%ebp),%eax
 b99:	8b 40 10             	mov    0x10(%eax),%eax
 b9c:	85 c0                	test   %eax,%eax
 b9e:	75 0a                	jne    baa <hoare_slots_monitor_addslots+0x1a>
		return -1;
 ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ba5:	e9 88 00 00 00       	jmp    c32 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 baa:	8b 45 08             	mov    0x8(%ebp),%eax
 bad:	8b 00                	mov    (%eax),%eax
 baf:	89 04 24             	mov    %eax,(%esp)
 bb2:	e8 a4 f7 ff ff       	call   35b <kthread_mutex_lock>
 bb7:	83 f8 ff             	cmp    $0xffffffff,%eax
 bba:	7d 07                	jge    bc3 <hoare_slots_monitor_addslots+0x33>
		return -1;
 bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bc1:	eb 6f                	jmp    c32 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
 bc3:	8b 45 08             	mov    0x8(%ebp),%eax
 bc6:	8b 40 10             	mov    0x10(%eax),%eax
 bc9:	85 c0                	test   %eax,%eax
 bcb:	74 21                	je     bee <hoare_slots_monitor_addslots+0x5e>
 bcd:	8b 45 08             	mov    0x8(%ebp),%eax
 bd0:	8b 40 0c             	mov    0xc(%eax),%eax
 bd3:	85 c0                	test   %eax,%eax
 bd5:	7e 17                	jle    bee <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	8b 10                	mov    (%eax),%edx
 bdc:	8b 45 08             	mov    0x8(%ebp),%eax
 bdf:	8b 40 08             	mov    0x8(%eax),%eax
 be2:	89 54 24 04          	mov    %edx,0x4(%esp)
 be6:	89 04 24             	mov    %eax,(%esp)
 be9:	e8 c1 01 00 00       	call   daf <hoare_cond_wait>


	if  ( monitor->active)
 bee:	8b 45 08             	mov    0x8(%ebp),%eax
 bf1:	8b 40 10             	mov    0x10(%eax),%eax
 bf4:	85 c0                	test   %eax,%eax
 bf6:	74 11                	je     c09 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
 bf8:	8b 45 08             	mov    0x8(%ebp),%eax
 bfb:	8b 50 0c             	mov    0xc(%eax),%edx
 bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
 c01:	01 c2                	add    %eax,%edx
 c03:	8b 45 08             	mov    0x8(%ebp),%eax
 c06:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
 c09:	8b 45 08             	mov    0x8(%ebp),%eax
 c0c:	8b 10                	mov    (%eax),%edx
 c0e:	8b 45 08             	mov    0x8(%ebp),%eax
 c11:	8b 40 04             	mov    0x4(%eax),%eax
 c14:	89 54 24 04          	mov    %edx,0x4(%esp)
 c18:	89 04 24             	mov    %eax,(%esp)
 c1b:	e8 e6 01 00 00       	call   e06 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 c20:	8b 45 08             	mov    0x8(%ebp),%eax
 c23:	8b 00                	mov    (%eax),%eax
 c25:	89 04 24             	mov    %eax,(%esp)
 c28:	e8 36 f7 ff ff       	call   363 <kthread_mutex_unlock>

	return 1;
 c2d:	b8 01 00 00 00       	mov    $0x1,%eax


}
 c32:	c9                   	leave  
 c33:	c3                   	ret    

00000c34 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
 c34:	55                   	push   %ebp
 c35:	89 e5                	mov    %esp,%ebp
 c37:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
 c3a:	8b 45 08             	mov    0x8(%ebp),%eax
 c3d:	8b 40 10             	mov    0x10(%eax),%eax
 c40:	85 c0                	test   %eax,%eax
 c42:	75 0a                	jne    c4e <hoare_slots_monitor_takeslot+0x1a>
		return -1;
 c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c49:	e9 86 00 00 00       	jmp    cd4 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 c4e:	8b 45 08             	mov    0x8(%ebp),%eax
 c51:	8b 00                	mov    (%eax),%eax
 c53:	89 04 24             	mov    %eax,(%esp)
 c56:	e8 00 f7 ff ff       	call   35b <kthread_mutex_lock>
 c5b:	83 f8 ff             	cmp    $0xffffffff,%eax
 c5e:	7d 07                	jge    c67 <hoare_slots_monitor_takeslot+0x33>
		return -1;
 c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c65:	eb 6d                	jmp    cd4 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
 c67:	8b 45 08             	mov    0x8(%ebp),%eax
 c6a:	8b 40 10             	mov    0x10(%eax),%eax
 c6d:	85 c0                	test   %eax,%eax
 c6f:	74 21                	je     c92 <hoare_slots_monitor_takeslot+0x5e>
 c71:	8b 45 08             	mov    0x8(%ebp),%eax
 c74:	8b 40 0c             	mov    0xc(%eax),%eax
 c77:	85 c0                	test   %eax,%eax
 c79:	75 17                	jne    c92 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
 c7b:	8b 45 08             	mov    0x8(%ebp),%eax
 c7e:	8b 10                	mov    (%eax),%edx
 c80:	8b 45 08             	mov    0x8(%ebp),%eax
 c83:	8b 40 04             	mov    0x4(%eax),%eax
 c86:	89 54 24 04          	mov    %edx,0x4(%esp)
 c8a:	89 04 24             	mov    %eax,(%esp)
 c8d:	e8 1d 01 00 00       	call   daf <hoare_cond_wait>


	if  ( monitor->active)
 c92:	8b 45 08             	mov    0x8(%ebp),%eax
 c95:	8b 40 10             	mov    0x10(%eax),%eax
 c98:	85 c0                	test   %eax,%eax
 c9a:	74 0f                	je     cab <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
 c9c:	8b 45 08             	mov    0x8(%ebp),%eax
 c9f:	8b 40 0c             	mov    0xc(%eax),%eax
 ca2:	8d 50 ff             	lea    -0x1(%eax),%edx
 ca5:	8b 45 08             	mov    0x8(%ebp),%eax
 ca8:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
 cab:	8b 45 08             	mov    0x8(%ebp),%eax
 cae:	8b 10                	mov    (%eax),%edx
 cb0:	8b 45 08             	mov    0x8(%ebp),%eax
 cb3:	8b 40 08             	mov    0x8(%eax),%eax
 cb6:	89 54 24 04          	mov    %edx,0x4(%esp)
 cba:	89 04 24             	mov    %eax,(%esp)
 cbd:	e8 44 01 00 00       	call   e06 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
 cc2:	8b 45 08             	mov    0x8(%ebp),%eax
 cc5:	8b 00                	mov    (%eax),%eax
 cc7:	89 04 24             	mov    %eax,(%esp)
 cca:	e8 94 f6 ff ff       	call   363 <kthread_mutex_unlock>

	return 1;
 ccf:	b8 01 00 00 00       	mov    $0x1,%eax

}
 cd4:	c9                   	leave  
 cd5:	c3                   	ret    

00000cd6 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
 cd6:	55                   	push   %ebp
 cd7:	89 e5                	mov    %esp,%ebp
 cd9:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
 cdc:	8b 45 08             	mov    0x8(%ebp),%eax
 cdf:	8b 40 10             	mov    0x10(%eax),%eax
 ce2:	85 c0                	test   %eax,%eax
 ce4:	75 07                	jne    ced <hoare_slots_monitor_stopadding+0x17>
			return -1;
 ce6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ceb:	eb 35                	jmp    d22 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
 ced:	8b 45 08             	mov    0x8(%ebp),%eax
 cf0:	8b 00                	mov    (%eax),%eax
 cf2:	89 04 24             	mov    %eax,(%esp)
 cf5:	e8 61 f6 ff ff       	call   35b <kthread_mutex_lock>
 cfa:	83 f8 ff             	cmp    $0xffffffff,%eax
 cfd:	7d 07                	jge    d06 <hoare_slots_monitor_stopadding+0x30>
			return -1;
 cff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d04:	eb 1c                	jmp    d22 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
 d06:	8b 45 08             	mov    0x8(%ebp),%eax
 d09:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
 d10:	8b 45 08             	mov    0x8(%ebp),%eax
 d13:	8b 00                	mov    (%eax),%eax
 d15:	89 04 24             	mov    %eax,(%esp)
 d18:	e8 46 f6 ff ff       	call   363 <kthread_mutex_unlock>

		return 0;
 d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d22:	c9                   	leave  
 d23:	c3                   	ret    

00000d24 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
 d24:	55                   	push   %ebp
 d25:	89 e5                	mov    %esp,%ebp
 d27:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 d2a:	e8 1c f6 ff ff       	call   34b <kthread_mutex_alloc>
 d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d36:	79 07                	jns    d3f <hoare_cond_alloc+0x1b>
		return 0;
 d38:	b8 00 00 00 00       	mov    $0x0,%eax
 d3d:	eb 24                	jmp    d63 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
 d3f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d46:	e8 f4 f9 ff ff       	call   73f <malloc>
 d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
 d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d54:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
 d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
 d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 d63:	c9                   	leave  
 d64:	c3                   	ret    

00000d65 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
 d65:	55                   	push   %ebp
 d66:	89 e5                	mov    %esp,%ebp
 d68:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
 d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 d6f:	75 07                	jne    d78 <hoare_cond_dealloc+0x13>
			return -1;
 d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d76:	eb 35                	jmp    dad <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
 d78:	8b 45 08             	mov    0x8(%ebp),%eax
 d7b:	8b 00                	mov    (%eax),%eax
 d7d:	89 04 24             	mov    %eax,(%esp)
 d80:	e8 de f5 ff ff       	call   363 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
 d85:	8b 45 08             	mov    0x8(%ebp),%eax
 d88:	8b 00                	mov    (%eax),%eax
 d8a:	89 04 24             	mov    %eax,(%esp)
 d8d:	e8 c1 f5 ff ff       	call   353 <kthread_mutex_dealloc>
 d92:	85 c0                	test   %eax,%eax
 d94:	79 07                	jns    d9d <hoare_cond_dealloc+0x38>
			return -1;
 d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d9b:	eb 10                	jmp    dad <hoare_cond_dealloc+0x48>

		free (hCond);
 d9d:	8b 45 08             	mov    0x8(%ebp),%eax
 da0:	89 04 24             	mov    %eax,(%esp)
 da3:	e8 5e f8 ff ff       	call   606 <free>
		return 0;
 da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 dad:	c9                   	leave  
 dae:	c3                   	ret    

00000daf <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
 daf:	55                   	push   %ebp
 db0:	89 e5                	mov    %esp,%ebp
 db2:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 db9:	75 07                	jne    dc2 <hoare_cond_wait+0x13>
			return -1;
 dbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dc0:	eb 42                	jmp    e04 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	8b 40 04             	mov    0x4(%eax),%eax
 dc8:	8d 50 01             	lea    0x1(%eax),%edx
 dcb:	8b 45 08             	mov    0x8(%ebp),%eax
 dce:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
 dd1:	8b 45 08             	mov    0x8(%ebp),%eax
 dd4:	8b 00                	mov    (%eax),%eax
 dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
 dda:	8b 45 0c             	mov    0xc(%ebp),%eax
 ddd:	89 04 24             	mov    %eax,(%esp)
 de0:	e8 86 f5 ff ff       	call   36b <kthread_mutex_yieldlock>
 de5:	85 c0                	test   %eax,%eax
 de7:	79 16                	jns    dff <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
 de9:	8b 45 08             	mov    0x8(%ebp),%eax
 dec:	8b 40 04             	mov    0x4(%eax),%eax
 def:	8d 50 ff             	lea    -0x1(%eax),%edx
 df2:	8b 45 08             	mov    0x8(%ebp),%eax
 df5:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dfd:	eb 05                	jmp    e04 <hoare_cond_wait+0x55>
		}

	return 0;
 dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
 e04:	c9                   	leave  
 e05:	c3                   	ret    

00000e06 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
 e06:	55                   	push   %ebp
 e07:	89 e5                	mov    %esp,%ebp
 e09:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
 e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 e10:	75 07                	jne    e19 <hoare_cond_signal+0x13>
		return -1;
 e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e17:	eb 6b                	jmp    e84 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
 e19:	8b 45 08             	mov    0x8(%ebp),%eax
 e1c:	8b 40 04             	mov    0x4(%eax),%eax
 e1f:	85 c0                	test   %eax,%eax
 e21:	7e 3d                	jle    e60 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
 e23:	8b 45 08             	mov    0x8(%ebp),%eax
 e26:	8b 40 04             	mov    0x4(%eax),%eax
 e29:	8d 50 ff             	lea    -0x1(%eax),%edx
 e2c:	8b 45 08             	mov    0x8(%ebp),%eax
 e2f:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 e32:	8b 45 08             	mov    0x8(%ebp),%eax
 e35:	8b 00                	mov    (%eax),%eax
 e37:	89 44 24 04          	mov    %eax,0x4(%esp)
 e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
 e3e:	89 04 24             	mov    %eax,(%esp)
 e41:	e8 25 f5 ff ff       	call   36b <kthread_mutex_yieldlock>
 e46:	85 c0                	test   %eax,%eax
 e48:	79 16                	jns    e60 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
 e4a:	8b 45 08             	mov    0x8(%ebp),%eax
 e4d:	8b 40 04             	mov    0x4(%eax),%eax
 e50:	8d 50 01             	lea    0x1(%eax),%edx
 e53:	8b 45 08             	mov    0x8(%ebp),%eax
 e56:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
 e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e5e:	eb 24                	jmp    e84 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
 e60:	8b 45 08             	mov    0x8(%ebp),%eax
 e63:	8b 00                	mov    (%eax),%eax
 e65:	89 44 24 04          	mov    %eax,0x4(%esp)
 e69:	8b 45 0c             	mov    0xc(%ebp),%eax
 e6c:	89 04 24             	mov    %eax,(%esp)
 e6f:	e8 f7 f4 ff ff       	call   36b <kthread_mutex_yieldlock>
 e74:	85 c0                	test   %eax,%eax
 e76:	79 07                	jns    e7f <hoare_cond_signal+0x79>

    			return -1;
 e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e7d:	eb 05                	jmp    e84 <hoare_cond_signal+0x7e>
    }

	return 0;
 e7f:	b8 00 00 00 00       	mov    $0x0,%eax

}
 e84:	c9                   	leave  
 e85:	c3                   	ret    

00000e86 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
 e86:	55                   	push   %ebp
 e87:	89 e5                	mov    %esp,%ebp
 e89:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
 e8c:	e8 ba f4 ff ff       	call   34b <kthread_mutex_alloc>
 e91:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
 e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e98:	79 07                	jns    ea1 <mesa_cond_alloc+0x1b>
		return 0;
 e9a:	b8 00 00 00 00       	mov    $0x0,%eax
 e9f:	eb 24                	jmp    ec5 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
 ea1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ea8:	e8 92 f8 ff ff       	call   73f <malloc>
 ead:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
 eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 eb6:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
 eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
 ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 ec5:	c9                   	leave  
 ec6:	c3                   	ret    

00000ec7 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
 ec7:	55                   	push   %ebp
 ec8:	89 e5                	mov    %esp,%ebp
 eca:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
 ecd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 ed1:	75 07                	jne    eda <mesa_cond_dealloc+0x13>
		return -1;
 ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ed8:	eb 35                	jmp    f0f <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
 eda:	8b 45 08             	mov    0x8(%ebp),%eax
 edd:	8b 00                	mov    (%eax),%eax
 edf:	89 04 24             	mov    %eax,(%esp)
 ee2:	e8 7c f4 ff ff       	call   363 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
 ee7:	8b 45 08             	mov    0x8(%ebp),%eax
 eea:	8b 00                	mov    (%eax),%eax
 eec:	89 04 24             	mov    %eax,(%esp)
 eef:	e8 5f f4 ff ff       	call   353 <kthread_mutex_dealloc>
 ef4:	85 c0                	test   %eax,%eax
 ef6:	79 07                	jns    eff <mesa_cond_dealloc+0x38>
		return -1;
 ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 efd:	eb 10                	jmp    f0f <mesa_cond_dealloc+0x48>

	free (mCond);
 eff:	8b 45 08             	mov    0x8(%ebp),%eax
 f02:	89 04 24             	mov    %eax,(%esp)
 f05:	e8 fc f6 ff ff       	call   606 <free>
	return 0;
 f0a:	b8 00 00 00 00       	mov    $0x0,%eax

}
 f0f:	c9                   	leave  
 f10:	c3                   	ret    

00000f11 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
 f11:	55                   	push   %ebp
 f12:	89 e5                	mov    %esp,%ebp
 f14:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 f17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 f1b:	75 07                	jne    f24 <mesa_cond_wait+0x13>
		return -1;
 f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f22:	eb 55                	jmp    f79 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
 f24:	8b 45 08             	mov    0x8(%ebp),%eax
 f27:	8b 40 04             	mov    0x4(%eax),%eax
 f2a:	8d 50 01             	lea    0x1(%eax),%edx
 f2d:	8b 45 08             	mov    0x8(%ebp),%eax
 f30:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
 f33:	8b 45 0c             	mov    0xc(%ebp),%eax
 f36:	89 04 24             	mov    %eax,(%esp)
 f39:	e8 25 f4 ff ff       	call   363 <kthread_mutex_unlock>
 f3e:	85 c0                	test   %eax,%eax
 f40:	79 27                	jns    f69 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
 f42:	8b 45 08             	mov    0x8(%ebp),%eax
 f45:	8b 00                	mov    (%eax),%eax
 f47:	89 04 24             	mov    %eax,(%esp)
 f4a:	e8 0c f4 ff ff       	call   35b <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
 f4f:	85 c0                	test   %eax,%eax
 f51:	79 16                	jns    f69 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
 f53:	8b 45 08             	mov    0x8(%ebp),%eax
 f56:	8b 40 04             	mov    0x4(%eax),%eax
 f59:	8d 50 ff             	lea    -0x1(%eax),%edx
 f5c:	8b 45 08             	mov    0x8(%ebp),%eax
 f5f:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
 f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f67:	eb 10                	jmp    f79 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
 f69:	8b 45 0c             	mov    0xc(%ebp),%eax
 f6c:	89 04 24             	mov    %eax,(%esp)
 f6f:	e8 e7 f3 ff ff       	call   35b <kthread_mutex_lock>
	return 0;
 f74:	b8 00 00 00 00       	mov    $0x0,%eax


}
 f79:	c9                   	leave  
 f7a:	c3                   	ret    

00000f7b <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
 f7b:	55                   	push   %ebp
 f7c:	89 e5                	mov    %esp,%ebp
 f7e:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
 f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 f85:	75 07                	jne    f8e <mesa_cond_signal+0x13>
		return -1;
 f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 f8c:	eb 5d                	jmp    feb <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
 f8e:	8b 45 08             	mov    0x8(%ebp),%eax
 f91:	8b 40 04             	mov    0x4(%eax),%eax
 f94:	85 c0                	test   %eax,%eax
 f96:	7e 36                	jle    fce <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
 f98:	8b 45 08             	mov    0x8(%ebp),%eax
 f9b:	8b 40 04             	mov    0x4(%eax),%eax
 f9e:	8d 50 ff             	lea    -0x1(%eax),%edx
 fa1:	8b 45 08             	mov    0x8(%ebp),%eax
 fa4:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
 fa7:	8b 45 08             	mov    0x8(%ebp),%eax
 faa:	8b 00                	mov    (%eax),%eax
 fac:	89 04 24             	mov    %eax,(%esp)
 faf:	e8 af f3 ff ff       	call   363 <kthread_mutex_unlock>
 fb4:	85 c0                	test   %eax,%eax
 fb6:	78 16                	js     fce <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
 fb8:	8b 45 08             	mov    0x8(%ebp),%eax
 fbb:	8b 40 04             	mov    0x4(%eax),%eax
 fbe:	8d 50 01             	lea    0x1(%eax),%edx
 fc1:	8b 45 08             	mov    0x8(%ebp),%eax
 fc4:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
 fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 fcc:	eb 1d                	jmp    feb <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
 fce:	8b 45 08             	mov    0x8(%ebp),%eax
 fd1:	8b 00                	mov    (%eax),%eax
 fd3:	89 04 24             	mov    %eax,(%esp)
 fd6:	e8 88 f3 ff ff       	call   363 <kthread_mutex_unlock>
 fdb:	85 c0                	test   %eax,%eax
 fdd:	79 07                	jns    fe6 <mesa_cond_signal+0x6b>

		return -1;
 fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 fe4:	eb 05                	jmp    feb <mesa_cond_signal+0x70>
	}
	return 0;
 fe6:	b8 00 00 00 00       	mov    $0x0,%eax

}
 feb:	c9                   	leave  
 fec:	c3                   	ret    
