
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
       9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
      10:	00 
      11:	c7 04 24 dc 10 00 00 	movl   $0x10dc,(%esp)
      18:	e8 9a 03 00 00       	call   3b7 <open>
      1d:	85 c0                	test   %eax,%eax
      1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
      21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
      28:	00 
      29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
      30:	00 
      31:	c7 04 24 dc 10 00 00 	movl   $0x10dc,(%esp)
      38:	e8 82 03 00 00       	call   3bf <mknod>
    open("console", O_RDWR);
      3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
      44:	00 
      45:	c7 04 24 dc 10 00 00 	movl   $0x10dc,(%esp)
      4c:	e8 66 03 00 00       	call   3b7 <open>
  }
  dup(0);  // stdout
      51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      58:	e8 92 03 00 00       	call   3ef <dup>
  dup(0);  // stderr
      5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      64:	e8 86 03 00 00       	call   3ef <dup>

  for(;;){
    printf(1, "init: starting sh\n");
      69:	c7 44 24 04 e4 10 00 	movl   $0x10e4,0x4(%esp)
      70:	00 
      71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      78:	e8 c2 04 00 00       	call   53f <printf>
    pid = fork();
      7d:	e8 ed 02 00 00       	call   36f <fork>
      82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
      86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
      8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
      8d:	c7 44 24 04 f7 10 00 	movl   $0x10f7,0x4(%esp)
      94:	00 
      95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      9c:	e8 9e 04 00 00       	call   53f <printf>
      exit();
      a1:	e8 d1 02 00 00       	call   377 <exit>
    }

    if(pid == 0){
      a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
      ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
      ad:	c7 44 24 04 b4 15 00 	movl   $0x15b4,0x4(%esp)
      b4:	00 
      b5:	c7 04 24 d9 10 00 00 	movl   $0x10d9,(%esp)
      bc:	e8 ee 02 00 00       	call   3af <exec>
      printf(1, "init: exec sh failed\n");
      c1:	c7 44 24 04 0a 11 00 	movl   $0x110a,0x4(%esp)
      c8:	00 
      c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      d0:	e8 6a 04 00 00       	call   53f <printf>
      exit();
      d5:	e8 9d 02 00 00       	call   377 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
      dc:	c7 44 24 04 20 11 00 	movl   $0x1120,0x4(%esp)
      e3:	00 
      e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      eb:	e8 4f 04 00 00       	call   53f <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      f0:	e8 8a 02 00 00       	call   37f <wait>
      f5:	89 44 24 18          	mov    %eax,0x18(%esp)
      f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
      fe:	78 0a                	js     10a <main+0x10a>
     100:	8b 44 24 18          	mov    0x18(%esp),%eax
     104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
     108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
     10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     10f:	55                   	push   %ebp
     110:	89 e5                	mov    %esp,%ebp
     112:	57                   	push   %edi
     113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     114:	8b 4d 08             	mov    0x8(%ebp),%ecx
     117:	8b 55 10             	mov    0x10(%ebp),%edx
     11a:	8b 45 0c             	mov    0xc(%ebp),%eax
     11d:	89 cb                	mov    %ecx,%ebx
     11f:	89 df                	mov    %ebx,%edi
     121:	89 d1                	mov    %edx,%ecx
     123:	fc                   	cld    
     124:	f3 aa                	rep stos %al,%es:(%edi)
     126:	89 ca                	mov    %ecx,%edx
     128:	89 fb                	mov    %edi,%ebx
     12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
     12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     130:	5b                   	pop    %ebx
     131:	5f                   	pop    %edi
     132:	5d                   	pop    %ebp
     133:	c3                   	ret    

00000134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     134:	55                   	push   %ebp
     135:	89 e5                	mov    %esp,%ebp
     137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     13a:	8b 45 08             	mov    0x8(%ebp),%eax
     13d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     140:	90                   	nop
     141:	8b 45 08             	mov    0x8(%ebp),%eax
     144:	8d 50 01             	lea    0x1(%eax),%edx
     147:	89 55 08             	mov    %edx,0x8(%ebp)
     14a:	8b 55 0c             	mov    0xc(%ebp),%edx
     14d:	8d 4a 01             	lea    0x1(%edx),%ecx
     150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     153:	0f b6 12             	movzbl (%edx),%edx
     156:	88 10                	mov    %dl,(%eax)
     158:	0f b6 00             	movzbl (%eax),%eax
     15b:	84 c0                	test   %al,%al
     15d:	75 e2                	jne    141 <strcpy+0xd>
    ;
  return os;
     15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     162:	c9                   	leave  
     163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     164:	55                   	push   %ebp
     165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     167:	eb 08                	jmp    171 <strcmp+0xd>
    p++, q++;
     169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     16d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     171:	8b 45 08             	mov    0x8(%ebp),%eax
     174:	0f b6 00             	movzbl (%eax),%eax
     177:	84 c0                	test   %al,%al
     179:	74 10                	je     18b <strcmp+0x27>
     17b:	8b 45 08             	mov    0x8(%ebp),%eax
     17e:	0f b6 10             	movzbl (%eax),%edx
     181:	8b 45 0c             	mov    0xc(%ebp),%eax
     184:	0f b6 00             	movzbl (%eax),%eax
     187:	38 c2                	cmp    %al,%dl
     189:	74 de                	je     169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     18b:	8b 45 08             	mov    0x8(%ebp),%eax
     18e:	0f b6 00             	movzbl (%eax),%eax
     191:	0f b6 d0             	movzbl %al,%edx
     194:	8b 45 0c             	mov    0xc(%ebp),%eax
     197:	0f b6 00             	movzbl (%eax),%eax
     19a:	0f b6 c0             	movzbl %al,%eax
     19d:	29 c2                	sub    %eax,%edx
     19f:	89 d0                	mov    %edx,%eax
}
     1a1:	5d                   	pop    %ebp
     1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
     1a3:	55                   	push   %ebp
     1a4:	89 e5                	mov    %esp,%ebp
     1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     1b0:	eb 04                	jmp    1b6 <strlen+0x13>
     1b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     1b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     1b9:	8b 45 08             	mov    0x8(%ebp),%eax
     1bc:	01 d0                	add    %edx,%eax
     1be:	0f b6 00             	movzbl (%eax),%eax
     1c1:	84 c0                	test   %al,%al
     1c3:	75 ed                	jne    1b2 <strlen+0xf>
    ;
  return n;
     1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     1c8:	c9                   	leave  
     1c9:	c3                   	ret    

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
     1ca:	55                   	push   %ebp
     1cb:	89 e5                	mov    %esp,%ebp
     1cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     1d0:	8b 45 10             	mov    0x10(%ebp),%eax
     1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
     1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     1da:	89 44 24 04          	mov    %eax,0x4(%esp)
     1de:	8b 45 08             	mov    0x8(%ebp),%eax
     1e1:	89 04 24             	mov    %eax,(%esp)
     1e4:	e8 26 ff ff ff       	call   10f <stosb>
  return dst;
     1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     1ec:	c9                   	leave  
     1ed:	c3                   	ret    

000001ee <strchr>:

char*
strchr(const char *s, char c)
{
     1ee:	55                   	push   %ebp
     1ef:	89 e5                	mov    %esp,%ebp
     1f1:	83 ec 04             	sub    $0x4,%esp
     1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
     1f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     1fa:	eb 14                	jmp    210 <strchr+0x22>
    if(*s == c)
     1fc:	8b 45 08             	mov    0x8(%ebp),%eax
     1ff:	0f b6 00             	movzbl (%eax),%eax
     202:	3a 45 fc             	cmp    -0x4(%ebp),%al
     205:	75 05                	jne    20c <strchr+0x1e>
      return (char*)s;
     207:	8b 45 08             	mov    0x8(%ebp),%eax
     20a:	eb 13                	jmp    21f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     210:	8b 45 08             	mov    0x8(%ebp),%eax
     213:	0f b6 00             	movzbl (%eax),%eax
     216:	84 c0                	test   %al,%al
     218:	75 e2                	jne    1fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     21f:	c9                   	leave  
     220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
     221:	55                   	push   %ebp
     222:	89 e5                	mov    %esp,%ebp
     224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     22e:	eb 4c                	jmp    27c <gets+0x5b>
    cc = read(0, &c, 1);
     230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     237:	00 
     238:	8d 45 ef             	lea    -0x11(%ebp),%eax
     23b:	89 44 24 04          	mov    %eax,0x4(%esp)
     23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     246:	e8 44 01 00 00       	call   38f <read>
     24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     24e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     252:	7f 02                	jg     256 <gets+0x35>
      break;
     254:	eb 31                	jmp    287 <gets+0x66>
    buf[i++] = c;
     256:	8b 45 f4             	mov    -0xc(%ebp),%eax
     259:	8d 50 01             	lea    0x1(%eax),%edx
     25c:	89 55 f4             	mov    %edx,-0xc(%ebp)
     25f:	89 c2                	mov    %eax,%edx
     261:	8b 45 08             	mov    0x8(%ebp),%eax
     264:	01 c2                	add    %eax,%edx
     266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     26a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     270:	3c 0a                	cmp    $0xa,%al
     272:	74 13                	je     287 <gets+0x66>
     274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     278:	3c 0d                	cmp    $0xd,%al
     27a:	74 0b                	je     287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27f:	83 c0 01             	add    $0x1,%eax
     282:	3b 45 0c             	cmp    0xc(%ebp),%eax
     285:	7c a9                	jl     230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     287:	8b 55 f4             	mov    -0xc(%ebp),%edx
     28a:	8b 45 08             	mov    0x8(%ebp),%eax
     28d:	01 d0                	add    %edx,%eax
     28f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     292:	8b 45 08             	mov    0x8(%ebp),%eax
}
     295:	c9                   	leave  
     296:	c3                   	ret    

00000297 <stat>:

int
stat(char *n, struct stat *st)
{
     297:	55                   	push   %ebp
     298:	89 e5                	mov    %esp,%ebp
     29a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2a4:	00 
     2a5:	8b 45 08             	mov    0x8(%ebp),%eax
     2a8:	89 04 24             	mov    %eax,(%esp)
     2ab:	e8 07 01 00 00       	call   3b7 <open>
     2b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     2b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2b7:	79 07                	jns    2c0 <stat+0x29>
    return -1;
     2b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2be:	eb 23                	jmp    2e3 <stat+0x4c>
  r = fstat(fd, st);
     2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c3:	89 44 24 04          	mov    %eax,0x4(%esp)
     2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2ca:	89 04 24             	mov    %eax,(%esp)
     2cd:	e8 fd 00 00 00       	call   3cf <fstat>
     2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2d8:	89 04 24             	mov    %eax,(%esp)
     2db:	e8 bf 00 00 00       	call   39f <close>
  return r;
     2e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     2e3:	c9                   	leave  
     2e4:	c3                   	ret    

000002e5 <atoi>:

int
atoi(const char *s)
{
     2e5:	55                   	push   %ebp
     2e6:	89 e5                	mov    %esp,%ebp
     2e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     2eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     2f2:	eb 25                	jmp    319 <atoi+0x34>
    n = n*10 + *s++ - '0';
     2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
     2f7:	89 d0                	mov    %edx,%eax
     2f9:	c1 e0 02             	shl    $0x2,%eax
     2fc:	01 d0                	add    %edx,%eax
     2fe:	01 c0                	add    %eax,%eax
     300:	89 c1                	mov    %eax,%ecx
     302:	8b 45 08             	mov    0x8(%ebp),%eax
     305:	8d 50 01             	lea    0x1(%eax),%edx
     308:	89 55 08             	mov    %edx,0x8(%ebp)
     30b:	0f b6 00             	movzbl (%eax),%eax
     30e:	0f be c0             	movsbl %al,%eax
     311:	01 c8                	add    %ecx,%eax
     313:	83 e8 30             	sub    $0x30,%eax
     316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     319:	8b 45 08             	mov    0x8(%ebp),%eax
     31c:	0f b6 00             	movzbl (%eax),%eax
     31f:	3c 2f                	cmp    $0x2f,%al
     321:	7e 0a                	jle    32d <atoi+0x48>
     323:	8b 45 08             	mov    0x8(%ebp),%eax
     326:	0f b6 00             	movzbl (%eax),%eax
     329:	3c 39                	cmp    $0x39,%al
     32b:	7e c7                	jle    2f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     330:	c9                   	leave  
     331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     332:	55                   	push   %ebp
     333:	89 e5                	mov    %esp,%ebp
     335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     338:	8b 45 08             	mov    0x8(%ebp),%eax
     33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     33e:	8b 45 0c             	mov    0xc(%ebp),%eax
     341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     344:	eb 17                	jmp    35d <memmove+0x2b>
    *dst++ = *src++;
     346:	8b 45 fc             	mov    -0x4(%ebp),%eax
     349:	8d 50 01             	lea    0x1(%eax),%edx
     34c:	89 55 fc             	mov    %edx,-0x4(%ebp)
     34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
     352:	8d 4a 01             	lea    0x1(%edx),%ecx
     355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     358:	0f b6 12             	movzbl (%edx),%edx
     35b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     35d:	8b 45 10             	mov    0x10(%ebp),%eax
     360:	8d 50 ff             	lea    -0x1(%eax),%edx
     363:	89 55 10             	mov    %edx,0x10(%ebp)
     366:	85 c0                	test   %eax,%eax
     368:	7f dc                	jg     346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     36d:	c9                   	leave  
     36e:	c3                   	ret    

0000036f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     36f:	b8 01 00 00 00       	mov    $0x1,%eax
     374:	cd 40                	int    $0x40
     376:	c3                   	ret    

00000377 <exit>:
SYSCALL(exit)
     377:	b8 02 00 00 00       	mov    $0x2,%eax
     37c:	cd 40                	int    $0x40
     37e:	c3                   	ret    

0000037f <wait>:
SYSCALL(wait)
     37f:	b8 03 00 00 00       	mov    $0x3,%eax
     384:	cd 40                	int    $0x40
     386:	c3                   	ret    

00000387 <pipe>:
SYSCALL(pipe)
     387:	b8 04 00 00 00       	mov    $0x4,%eax
     38c:	cd 40                	int    $0x40
     38e:	c3                   	ret    

0000038f <read>:
SYSCALL(read)
     38f:	b8 05 00 00 00       	mov    $0x5,%eax
     394:	cd 40                	int    $0x40
     396:	c3                   	ret    

00000397 <write>:
SYSCALL(write)
     397:	b8 10 00 00 00       	mov    $0x10,%eax
     39c:	cd 40                	int    $0x40
     39e:	c3                   	ret    

0000039f <close>:
SYSCALL(close)
     39f:	b8 15 00 00 00       	mov    $0x15,%eax
     3a4:	cd 40                	int    $0x40
     3a6:	c3                   	ret    

000003a7 <kill>:
SYSCALL(kill)
     3a7:	b8 06 00 00 00       	mov    $0x6,%eax
     3ac:	cd 40                	int    $0x40
     3ae:	c3                   	ret    

000003af <exec>:
SYSCALL(exec)
     3af:	b8 07 00 00 00       	mov    $0x7,%eax
     3b4:	cd 40                	int    $0x40
     3b6:	c3                   	ret    

000003b7 <open>:
SYSCALL(open)
     3b7:	b8 0f 00 00 00       	mov    $0xf,%eax
     3bc:	cd 40                	int    $0x40
     3be:	c3                   	ret    

000003bf <mknod>:
SYSCALL(mknod)
     3bf:	b8 11 00 00 00       	mov    $0x11,%eax
     3c4:	cd 40                	int    $0x40
     3c6:	c3                   	ret    

000003c7 <unlink>:
SYSCALL(unlink)
     3c7:	b8 12 00 00 00       	mov    $0x12,%eax
     3cc:	cd 40                	int    $0x40
     3ce:	c3                   	ret    

000003cf <fstat>:
SYSCALL(fstat)
     3cf:	b8 08 00 00 00       	mov    $0x8,%eax
     3d4:	cd 40                	int    $0x40
     3d6:	c3                   	ret    

000003d7 <link>:
SYSCALL(link)
     3d7:	b8 13 00 00 00       	mov    $0x13,%eax
     3dc:	cd 40                	int    $0x40
     3de:	c3                   	ret    

000003df <mkdir>:
SYSCALL(mkdir)
     3df:	b8 14 00 00 00       	mov    $0x14,%eax
     3e4:	cd 40                	int    $0x40
     3e6:	c3                   	ret    

000003e7 <chdir>:
SYSCALL(chdir)
     3e7:	b8 09 00 00 00       	mov    $0x9,%eax
     3ec:	cd 40                	int    $0x40
     3ee:	c3                   	ret    

000003ef <dup>:
SYSCALL(dup)
     3ef:	b8 0a 00 00 00       	mov    $0xa,%eax
     3f4:	cd 40                	int    $0x40
     3f6:	c3                   	ret    

000003f7 <getpid>:
SYSCALL(getpid)
     3f7:	b8 0b 00 00 00       	mov    $0xb,%eax
     3fc:	cd 40                	int    $0x40
     3fe:	c3                   	ret    

000003ff <sbrk>:
SYSCALL(sbrk)
     3ff:	b8 0c 00 00 00       	mov    $0xc,%eax
     404:	cd 40                	int    $0x40
     406:	c3                   	ret    

00000407 <sleep>:
SYSCALL(sleep)
     407:	b8 0d 00 00 00       	mov    $0xd,%eax
     40c:	cd 40                	int    $0x40
     40e:	c3                   	ret    

0000040f <uptime>:
SYSCALL(uptime)
     40f:	b8 0e 00 00 00       	mov    $0xe,%eax
     414:	cd 40                	int    $0x40
     416:	c3                   	ret    

00000417 <kthread_create>:




SYSCALL(kthread_create)
     417:	b8 16 00 00 00       	mov    $0x16,%eax
     41c:	cd 40                	int    $0x40
     41e:	c3                   	ret    

0000041f <kthread_id>:
SYSCALL(kthread_id)
     41f:	b8 17 00 00 00       	mov    $0x17,%eax
     424:	cd 40                	int    $0x40
     426:	c3                   	ret    

00000427 <kthread_exit>:
SYSCALL(kthread_exit)
     427:	b8 18 00 00 00       	mov    $0x18,%eax
     42c:	cd 40                	int    $0x40
     42e:	c3                   	ret    

0000042f <kthread_join>:
SYSCALL(kthread_join)
     42f:	b8 19 00 00 00       	mov    $0x19,%eax
     434:	cd 40                	int    $0x40
     436:	c3                   	ret    

00000437 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     437:	b8 1a 00 00 00       	mov    $0x1a,%eax
     43c:	cd 40                	int    $0x40
     43e:	c3                   	ret    

0000043f <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     43f:	b8 1b 00 00 00       	mov    $0x1b,%eax
     444:	cd 40                	int    $0x40
     446:	c3                   	ret    

00000447 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     447:	b8 1c 00 00 00       	mov    $0x1c,%eax
     44c:	cd 40                	int    $0x40
     44e:	c3                   	ret    

0000044f <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     44f:	b8 1d 00 00 00       	mov    $0x1d,%eax
     454:	cd 40                	int    $0x40
     456:	c3                   	ret    

00000457 <kthread_mutex_yieldlock>:
     457:	b8 1e 00 00 00       	mov    $0x1e,%eax
     45c:	cd 40                	int    $0x40
     45e:	c3                   	ret    

0000045f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     45f:	55                   	push   %ebp
     460:	89 e5                	mov    %esp,%ebp
     462:	83 ec 18             	sub    $0x18,%esp
     465:	8b 45 0c             	mov    0xc(%ebp),%eax
     468:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     46b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     472:	00 
     473:	8d 45 f4             	lea    -0xc(%ebp),%eax
     476:	89 44 24 04          	mov    %eax,0x4(%esp)
     47a:	8b 45 08             	mov    0x8(%ebp),%eax
     47d:	89 04 24             	mov    %eax,(%esp)
     480:	e8 12 ff ff ff       	call   397 <write>
}
     485:	c9                   	leave  
     486:	c3                   	ret    

00000487 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     487:	55                   	push   %ebp
     488:	89 e5                	mov    %esp,%ebp
     48a:	56                   	push   %esi
     48b:	53                   	push   %ebx
     48c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     496:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     49a:	74 17                	je     4b3 <printint+0x2c>
     49c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     4a0:	79 11                	jns    4b3 <printint+0x2c>
    neg = 1;
     4a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     4ac:	f7 d8                	neg    %eax
     4ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4b1:	eb 06                	jmp    4b9 <printint+0x32>
  } else {
    x = xx;
     4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     4b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     4c0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     4c3:	8d 41 01             	lea    0x1(%ecx),%eax
     4c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     4c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
     4cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4cf:	ba 00 00 00 00       	mov    $0x0,%edx
     4d4:	f7 f3                	div    %ebx
     4d6:	89 d0                	mov    %edx,%eax
     4d8:	0f b6 80 bc 15 00 00 	movzbl 0x15bc(%eax),%eax
     4df:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     4e3:	8b 75 10             	mov    0x10(%ebp),%esi
     4e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4e9:	ba 00 00 00 00       	mov    $0x0,%edx
     4ee:	f7 f6                	div    %esi
     4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     4f7:	75 c7                	jne    4c0 <printint+0x39>
  if(neg)
     4f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4fd:	74 10                	je     50f <printint+0x88>
    buf[i++] = '-';
     4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     502:	8d 50 01             	lea    0x1(%eax),%edx
     505:	89 55 f4             	mov    %edx,-0xc(%ebp)
     508:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     50d:	eb 1f                	jmp    52e <printint+0xa7>
     50f:	eb 1d                	jmp    52e <printint+0xa7>
    putc(fd, buf[i]);
     511:	8d 55 dc             	lea    -0x24(%ebp),%edx
     514:	8b 45 f4             	mov    -0xc(%ebp),%eax
     517:	01 d0                	add    %edx,%eax
     519:	0f b6 00             	movzbl (%eax),%eax
     51c:	0f be c0             	movsbl %al,%eax
     51f:	89 44 24 04          	mov    %eax,0x4(%esp)
     523:	8b 45 08             	mov    0x8(%ebp),%eax
     526:	89 04 24             	mov    %eax,(%esp)
     529:	e8 31 ff ff ff       	call   45f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     52e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     536:	79 d9                	jns    511 <printint+0x8a>
    putc(fd, buf[i]);
}
     538:	83 c4 30             	add    $0x30,%esp
     53b:	5b                   	pop    %ebx
     53c:	5e                   	pop    %esi
     53d:	5d                   	pop    %ebp
     53e:	c3                   	ret    

0000053f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     53f:	55                   	push   %ebp
     540:	89 e5                	mov    %esp,%ebp
     542:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     54c:	8d 45 0c             	lea    0xc(%ebp),%eax
     54f:	83 c0 04             	add    $0x4,%eax
     552:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     55c:	e9 7c 01 00 00       	jmp    6dd <printf+0x19e>
    c = fmt[i] & 0xff;
     561:	8b 55 0c             	mov    0xc(%ebp),%edx
     564:	8b 45 f0             	mov    -0x10(%ebp),%eax
     567:	01 d0                	add    %edx,%eax
     569:	0f b6 00             	movzbl (%eax),%eax
     56c:	0f be c0             	movsbl %al,%eax
     56f:	25 ff 00 00 00       	and    $0xff,%eax
     574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     57b:	75 2c                	jne    5a9 <printf+0x6a>
      if(c == '%'){
     57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     581:	75 0c                	jne    58f <printf+0x50>
        state = '%';
     583:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     58a:	e9 4a 01 00 00       	jmp    6d9 <printf+0x19a>
      } else {
        putc(fd, c);
     58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     592:	0f be c0             	movsbl %al,%eax
     595:	89 44 24 04          	mov    %eax,0x4(%esp)
     599:	8b 45 08             	mov    0x8(%ebp),%eax
     59c:	89 04 24             	mov    %eax,(%esp)
     59f:	e8 bb fe ff ff       	call   45f <putc>
     5a4:	e9 30 01 00 00       	jmp    6d9 <printf+0x19a>
      }
    } else if(state == '%'){
     5a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     5ad:	0f 85 26 01 00 00    	jne    6d9 <printf+0x19a>
      if(c == 'd'){
     5b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     5b7:	75 2d                	jne    5e6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5bc:	8b 00                	mov    (%eax),%eax
     5be:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     5c5:	00 
     5c6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     5cd:	00 
     5ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d2:	8b 45 08             	mov    0x8(%ebp),%eax
     5d5:	89 04 24             	mov    %eax,(%esp)
     5d8:	e8 aa fe ff ff       	call   487 <printint>
        ap++;
     5dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     5e1:	e9 ec 00 00 00       	jmp    6d2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     5e6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     5ea:	74 06                	je     5f2 <printf+0xb3>
     5ec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     5f0:	75 2d                	jne    61f <printf+0xe0>
        printint(fd, *ap, 16, 0);
     5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5f5:	8b 00                	mov    (%eax),%eax
     5f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     5fe:	00 
     5ff:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     606:	00 
     607:	89 44 24 04          	mov    %eax,0x4(%esp)
     60b:	8b 45 08             	mov    0x8(%ebp),%eax
     60e:	89 04 24             	mov    %eax,(%esp)
     611:	e8 71 fe ff ff       	call   487 <printint>
        ap++;
     616:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     61a:	e9 b3 00 00 00       	jmp    6d2 <printf+0x193>
      } else if(c == 's'){
     61f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     623:	75 45                	jne    66a <printf+0x12b>
        s = (char*)*ap;
     625:	8b 45 e8             	mov    -0x18(%ebp),%eax
     628:	8b 00                	mov    (%eax),%eax
     62a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     635:	75 09                	jne    640 <printf+0x101>
          s = "(null)";
     637:	c7 45 f4 29 11 00 00 	movl   $0x1129,-0xc(%ebp)
        while(*s != 0){
     63e:	eb 1e                	jmp    65e <printf+0x11f>
     640:	eb 1c                	jmp    65e <printf+0x11f>
          putc(fd, *s);
     642:	8b 45 f4             	mov    -0xc(%ebp),%eax
     645:	0f b6 00             	movzbl (%eax),%eax
     648:	0f be c0             	movsbl %al,%eax
     64b:	89 44 24 04          	mov    %eax,0x4(%esp)
     64f:	8b 45 08             	mov    0x8(%ebp),%eax
     652:	89 04 24             	mov    %eax,(%esp)
     655:	e8 05 fe ff ff       	call   45f <putc>
          s++;
     65a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     65e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     661:	0f b6 00             	movzbl (%eax),%eax
     664:	84 c0                	test   %al,%al
     666:	75 da                	jne    642 <printf+0x103>
     668:	eb 68                	jmp    6d2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     66a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     66e:	75 1d                	jne    68d <printf+0x14e>
        putc(fd, *ap);
     670:	8b 45 e8             	mov    -0x18(%ebp),%eax
     673:	8b 00                	mov    (%eax),%eax
     675:	0f be c0             	movsbl %al,%eax
     678:	89 44 24 04          	mov    %eax,0x4(%esp)
     67c:	8b 45 08             	mov    0x8(%ebp),%eax
     67f:	89 04 24             	mov    %eax,(%esp)
     682:	e8 d8 fd ff ff       	call   45f <putc>
        ap++;
     687:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     68b:	eb 45                	jmp    6d2 <printf+0x193>
      } else if(c == '%'){
     68d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     691:	75 17                	jne    6aa <printf+0x16b>
        putc(fd, c);
     693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     696:	0f be c0             	movsbl %al,%eax
     699:	89 44 24 04          	mov    %eax,0x4(%esp)
     69d:	8b 45 08             	mov    0x8(%ebp),%eax
     6a0:	89 04 24             	mov    %eax,(%esp)
     6a3:	e8 b7 fd ff ff       	call   45f <putc>
     6a8:	eb 28                	jmp    6d2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     6aa:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     6b1:	00 
     6b2:	8b 45 08             	mov    0x8(%ebp),%eax
     6b5:	89 04 24             	mov    %eax,(%esp)
     6b8:	e8 a2 fd ff ff       	call   45f <putc>
        putc(fd, c);
     6bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6c0:	0f be c0             	movsbl %al,%eax
     6c3:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c7:	8b 45 08             	mov    0x8(%ebp),%eax
     6ca:	89 04 24             	mov    %eax,(%esp)
     6cd:	e8 8d fd ff ff       	call   45f <putc>
      }
      state = 0;
     6d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     6d9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     6dd:	8b 55 0c             	mov    0xc(%ebp),%edx
     6e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6e3:	01 d0                	add    %edx,%eax
     6e5:	0f b6 00             	movzbl (%eax),%eax
     6e8:	84 c0                	test   %al,%al
     6ea:	0f 85 71 fe ff ff    	jne    561 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     6f8:	8b 45 08             	mov    0x8(%ebp),%eax
     6fb:	83 e8 08             	sub    $0x8,%eax
     6fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     701:	a1 d8 15 00 00       	mov    0x15d8,%eax
     706:	89 45 fc             	mov    %eax,-0x4(%ebp)
     709:	eb 24                	jmp    72f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     70e:	8b 00                	mov    (%eax),%eax
     710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     713:	77 12                	ja     727 <free+0x35>
     715:	8b 45 f8             	mov    -0x8(%ebp),%eax
     718:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     71b:	77 24                	ja     741 <free+0x4f>
     71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     720:	8b 00                	mov    (%eax),%eax
     722:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     725:	77 1a                	ja     741 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     727:	8b 45 fc             	mov    -0x4(%ebp),%eax
     72a:	8b 00                	mov    (%eax),%eax
     72c:	89 45 fc             	mov    %eax,-0x4(%ebp)
     72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     735:	76 d4                	jbe    70b <free+0x19>
     737:	8b 45 fc             	mov    -0x4(%ebp),%eax
     73a:	8b 00                	mov    (%eax),%eax
     73c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     73f:	76 ca                	jbe    70b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     741:	8b 45 f8             	mov    -0x8(%ebp),%eax
     744:	8b 40 04             	mov    0x4(%eax),%eax
     747:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     751:	01 c2                	add    %eax,%edx
     753:	8b 45 fc             	mov    -0x4(%ebp),%eax
     756:	8b 00                	mov    (%eax),%eax
     758:	39 c2                	cmp    %eax,%edx
     75a:	75 24                	jne    780 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     75f:	8b 50 04             	mov    0x4(%eax),%edx
     762:	8b 45 fc             	mov    -0x4(%ebp),%eax
     765:	8b 00                	mov    (%eax),%eax
     767:	8b 40 04             	mov    0x4(%eax),%eax
     76a:	01 c2                	add    %eax,%edx
     76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     76f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     772:	8b 45 fc             	mov    -0x4(%ebp),%eax
     775:	8b 00                	mov    (%eax),%eax
     777:	8b 10                	mov    (%eax),%edx
     779:	8b 45 f8             	mov    -0x8(%ebp),%eax
     77c:	89 10                	mov    %edx,(%eax)
     77e:	eb 0a                	jmp    78a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     780:	8b 45 fc             	mov    -0x4(%ebp),%eax
     783:	8b 10                	mov    (%eax),%edx
     785:	8b 45 f8             	mov    -0x8(%ebp),%eax
     788:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     78d:	8b 40 04             	mov    0x4(%eax),%eax
     790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     797:	8b 45 fc             	mov    -0x4(%ebp),%eax
     79a:	01 d0                	add    %edx,%eax
     79c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     79f:	75 20                	jne    7c1 <free+0xcf>
    p->s.size += bp->s.size;
     7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7a4:	8b 50 04             	mov    0x4(%eax),%edx
     7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7aa:	8b 40 04             	mov    0x4(%eax),%eax
     7ad:	01 c2                	add    %eax,%edx
     7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7b8:	8b 10                	mov    (%eax),%edx
     7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7bd:	89 10                	mov    %edx,(%eax)
     7bf:	eb 08                	jmp    7c9 <free+0xd7>
  } else
    p->s.ptr = bp;
     7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
     7c7:	89 10                	mov    %edx,(%eax)
  freep = p;
     7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7cc:	a3 d8 15 00 00       	mov    %eax,0x15d8
}
     7d1:	c9                   	leave  
     7d2:	c3                   	ret    

000007d3 <morecore>:

static Header*
morecore(uint nu)
{
     7d3:	55                   	push   %ebp
     7d4:	89 e5                	mov    %esp,%ebp
     7d6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     7d9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     7e0:	77 07                	ja     7e9 <morecore+0x16>
    nu = 4096;
     7e2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     7e9:	8b 45 08             	mov    0x8(%ebp),%eax
     7ec:	c1 e0 03             	shl    $0x3,%eax
     7ef:	89 04 24             	mov    %eax,(%esp)
     7f2:	e8 08 fc ff ff       	call   3ff <sbrk>
     7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     7fa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     7fe:	75 07                	jne    807 <morecore+0x34>
    return 0;
     800:	b8 00 00 00 00       	mov    $0x0,%eax
     805:	eb 22                	jmp    829 <morecore+0x56>
  hp = (Header*)p;
     807:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     810:	8b 55 08             	mov    0x8(%ebp),%edx
     813:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     816:	8b 45 f0             	mov    -0x10(%ebp),%eax
     819:	83 c0 08             	add    $0x8,%eax
     81c:	89 04 24             	mov    %eax,(%esp)
     81f:	e8 ce fe ff ff       	call   6f2 <free>
  return freep;
     824:	a1 d8 15 00 00       	mov    0x15d8,%eax
}
     829:	c9                   	leave  
     82a:	c3                   	ret    

0000082b <malloc>:

void*
malloc(uint nbytes)
{
     82b:	55                   	push   %ebp
     82c:	89 e5                	mov    %esp,%ebp
     82e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     831:	8b 45 08             	mov    0x8(%ebp),%eax
     834:	83 c0 07             	add    $0x7,%eax
     837:	c1 e8 03             	shr    $0x3,%eax
     83a:	83 c0 01             	add    $0x1,%eax
     83d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     840:	a1 d8 15 00 00       	mov    0x15d8,%eax
     845:	89 45 f0             	mov    %eax,-0x10(%ebp)
     848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     84c:	75 23                	jne    871 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     84e:	c7 45 f0 d0 15 00 00 	movl   $0x15d0,-0x10(%ebp)
     855:	8b 45 f0             	mov    -0x10(%ebp),%eax
     858:	a3 d8 15 00 00       	mov    %eax,0x15d8
     85d:	a1 d8 15 00 00       	mov    0x15d8,%eax
     862:	a3 d0 15 00 00       	mov    %eax,0x15d0
    base.s.size = 0;
     867:	c7 05 d4 15 00 00 00 	movl   $0x0,0x15d4
     86e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     871:	8b 45 f0             	mov    -0x10(%ebp),%eax
     874:	8b 00                	mov    (%eax),%eax
     876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     879:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87c:	8b 40 04             	mov    0x4(%eax),%eax
     87f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     882:	72 4d                	jb     8d1 <malloc+0xa6>
      if(p->s.size == nunits)
     884:	8b 45 f4             	mov    -0xc(%ebp),%eax
     887:	8b 40 04             	mov    0x4(%eax),%eax
     88a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     88d:	75 0c                	jne    89b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     892:	8b 10                	mov    (%eax),%edx
     894:	8b 45 f0             	mov    -0x10(%ebp),%eax
     897:	89 10                	mov    %edx,(%eax)
     899:	eb 26                	jmp    8c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
     89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     89e:	8b 40 04             	mov    0x4(%eax),%eax
     8a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
     8a4:	89 c2                	mov    %eax,%edx
     8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8af:	8b 40 04             	mov    0x4(%eax),%eax
     8b2:	c1 e0 03             	shl    $0x3,%eax
     8b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
     8be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8c4:	a3 d8 15 00 00       	mov    %eax,0x15d8
      return (void*)(p + 1);
     8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8cc:	83 c0 08             	add    $0x8,%eax
     8cf:	eb 38                	jmp    909 <malloc+0xde>
    }
    if(p == freep)
     8d1:	a1 d8 15 00 00       	mov    0x15d8,%eax
     8d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     8d9:	75 1b                	jne    8f6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     8db:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8de:	89 04 24             	mov    %eax,(%esp)
     8e1:	e8 ed fe ff ff       	call   7d3 <morecore>
     8e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8ed:	75 07                	jne    8f6 <malloc+0xcb>
        return 0;
     8ef:	b8 00 00 00 00       	mov    $0x0,%eax
     8f4:	eb 13                	jmp    909 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ff:	8b 00                	mov    (%eax),%eax
     901:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     904:	e9 70 ff ff ff       	jmp    879 <malloc+0x4e>
}
     909:	c9                   	leave  
     90a:	c3                   	ret    

0000090b <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     90b:	55                   	push   %ebp
     90c:	89 e5                	mov    %esp,%ebp
     90e:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     911:	e8 21 fb ff ff       	call   437 <kthread_mutex_alloc>
     916:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     919:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     91d:	79 0a                	jns    929 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     91f:	b8 00 00 00 00       	mov    $0x0,%eax
     924:	e9 8b 00 00 00       	jmp    9b4 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     929:	e8 44 06 00 00       	call   f72 <mesa_cond_alloc>
     92e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     931:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     935:	75 12                	jne    949 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	89 04 24             	mov    %eax,(%esp)
     93d:	e8 fd fa ff ff       	call   43f <kthread_mutex_dealloc>
		return 0;
     942:	b8 00 00 00 00       	mov    $0x0,%eax
     947:	eb 6b                	jmp    9b4 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     949:	e8 24 06 00 00       	call   f72 <mesa_cond_alloc>
     94e:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     951:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     955:	75 1d                	jne    974 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     957:	8b 45 f4             	mov    -0xc(%ebp),%eax
     95a:	89 04 24             	mov    %eax,(%esp)
     95d:	e8 dd fa ff ff       	call   43f <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     962:	8b 45 f0             	mov    -0x10(%ebp),%eax
     965:	89 04 24             	mov    %eax,(%esp)
     968:	e8 46 06 00 00       	call   fb3 <mesa_cond_dealloc>
		return 0;
     96d:	b8 00 00 00 00       	mov    $0x0,%eax
     972:	eb 40                	jmp    9b4 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     974:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     97b:	e8 ab fe ff ff       	call   82b <malloc>
     980:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     983:	8b 45 e8             	mov    -0x18(%ebp),%eax
     986:	8b 55 f0             	mov    -0x10(%ebp),%edx
     989:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     98c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     98f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     992:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     995:	8b 45 e8             	mov    -0x18(%ebp),%eax
     998:	8b 55 f4             	mov    -0xc(%ebp),%edx
     99b:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     99d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     9a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     9a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     9aa:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     9b1:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     9b4:	c9                   	leave  
     9b5:	c3                   	ret    

000009b6 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     9b6:	55                   	push   %ebp
     9b7:	89 e5                	mov    %esp,%ebp
     9b9:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     9bc:	8b 45 08             	mov    0x8(%ebp),%eax
     9bf:	8b 00                	mov    (%eax),%eax
     9c1:	89 04 24             	mov    %eax,(%esp)
     9c4:	e8 76 fa ff ff       	call   43f <kthread_mutex_dealloc>
     9c9:	85 c0                	test   %eax,%eax
     9cb:	78 2e                	js     9fb <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     9cd:	8b 45 08             	mov    0x8(%ebp),%eax
     9d0:	8b 40 04             	mov    0x4(%eax),%eax
     9d3:	89 04 24             	mov    %eax,(%esp)
     9d6:	e8 97 05 00 00       	call   f72 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     9db:	8b 45 08             	mov    0x8(%ebp),%eax
     9de:	8b 40 08             	mov    0x8(%eax),%eax
     9e1:	89 04 24             	mov    %eax,(%esp)
     9e4:	e8 89 05 00 00       	call   f72 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     9e9:	8b 45 08             	mov    0x8(%ebp),%eax
     9ec:	89 04 24             	mov    %eax,(%esp)
     9ef:	e8 fe fc ff ff       	call   6f2 <free>
	return 0;
     9f4:	b8 00 00 00 00       	mov    $0x0,%eax
     9f9:	eb 05                	jmp    a00 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     9fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     a00:	c9                   	leave  
     a01:	c3                   	ret    

00000a02 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     a02:	55                   	push   %ebp
     a03:	89 e5                	mov    %esp,%ebp
     a05:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     a08:	8b 45 08             	mov    0x8(%ebp),%eax
     a0b:	8b 40 10             	mov    0x10(%eax),%eax
     a0e:	85 c0                	test   %eax,%eax
     a10:	75 0a                	jne    a1c <mesa_slots_monitor_addslots+0x1a>
		return -1;
     a12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a17:	e9 81 00 00 00       	jmp    a9d <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     a1c:	8b 45 08             	mov    0x8(%ebp),%eax
     a1f:	8b 00                	mov    (%eax),%eax
     a21:	89 04 24             	mov    %eax,(%esp)
     a24:	e8 1e fa ff ff       	call   447 <kthread_mutex_lock>
     a29:	83 f8 ff             	cmp    $0xffffffff,%eax
     a2c:	7d 07                	jge    a35 <mesa_slots_monitor_addslots+0x33>
		return -1;
     a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a33:	eb 68                	jmp    a9d <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     a35:	eb 17                	jmp    a4e <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     a37:	8b 45 08             	mov    0x8(%ebp),%eax
     a3a:	8b 10                	mov    (%eax),%edx
     a3c:	8b 45 08             	mov    0x8(%ebp),%eax
     a3f:	8b 40 08             	mov    0x8(%eax),%eax
     a42:	89 54 24 04          	mov    %edx,0x4(%esp)
     a46:	89 04 24             	mov    %eax,(%esp)
     a49:	e8 af 05 00 00       	call   ffd <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     a4e:	8b 45 08             	mov    0x8(%ebp),%eax
     a51:	8b 40 10             	mov    0x10(%eax),%eax
     a54:	85 c0                	test   %eax,%eax
     a56:	74 0a                	je     a62 <mesa_slots_monitor_addslots+0x60>
     a58:	8b 45 08             	mov    0x8(%ebp),%eax
     a5b:	8b 40 0c             	mov    0xc(%eax),%eax
     a5e:	85 c0                	test   %eax,%eax
     a60:	7f d5                	jg     a37 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     a62:	8b 45 08             	mov    0x8(%ebp),%eax
     a65:	8b 40 10             	mov    0x10(%eax),%eax
     a68:	85 c0                	test   %eax,%eax
     a6a:	74 11                	je     a7d <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     a6c:	8b 45 08             	mov    0x8(%ebp),%eax
     a6f:	8b 50 0c             	mov    0xc(%eax),%edx
     a72:	8b 45 0c             	mov    0xc(%ebp),%eax
     a75:	01 c2                	add    %eax,%edx
     a77:	8b 45 08             	mov    0x8(%ebp),%eax
     a7a:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     a7d:	8b 45 08             	mov    0x8(%ebp),%eax
     a80:	8b 40 04             	mov    0x4(%eax),%eax
     a83:	89 04 24             	mov    %eax,(%esp)
     a86:	e8 dc 05 00 00       	call   1067 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     a8b:	8b 45 08             	mov    0x8(%ebp),%eax
     a8e:	8b 00                	mov    (%eax),%eax
     a90:	89 04 24             	mov    %eax,(%esp)
     a93:	e8 b7 f9 ff ff       	call   44f <kthread_mutex_unlock>

	return 1;
     a98:	b8 01 00 00 00       	mov    $0x1,%eax


}
     a9d:	c9                   	leave  
     a9e:	c3                   	ret    

00000a9f <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     a9f:	55                   	push   %ebp
     aa0:	89 e5                	mov    %esp,%ebp
     aa2:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     aa5:	8b 45 08             	mov    0x8(%ebp),%eax
     aa8:	8b 40 10             	mov    0x10(%eax),%eax
     aab:	85 c0                	test   %eax,%eax
     aad:	75 07                	jne    ab6 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     aaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ab4:	eb 7f                	jmp    b35 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ab6:	8b 45 08             	mov    0x8(%ebp),%eax
     ab9:	8b 00                	mov    (%eax),%eax
     abb:	89 04 24             	mov    %eax,(%esp)
     abe:	e8 84 f9 ff ff       	call   447 <kthread_mutex_lock>
     ac3:	83 f8 ff             	cmp    $0xffffffff,%eax
     ac6:	7d 07                	jge    acf <mesa_slots_monitor_takeslot+0x30>
		return -1;
     ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     acd:	eb 66                	jmp    b35 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     acf:	eb 17                	jmp    ae8 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     ad1:	8b 45 08             	mov    0x8(%ebp),%eax
     ad4:	8b 10                	mov    (%eax),%edx
     ad6:	8b 45 08             	mov    0x8(%ebp),%eax
     ad9:	8b 40 04             	mov    0x4(%eax),%eax
     adc:	89 54 24 04          	mov    %edx,0x4(%esp)
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 15 05 00 00       	call   ffd <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     ae8:	8b 45 08             	mov    0x8(%ebp),%eax
     aeb:	8b 40 10             	mov    0x10(%eax),%eax
     aee:	85 c0                	test   %eax,%eax
     af0:	74 0a                	je     afc <mesa_slots_monitor_takeslot+0x5d>
     af2:	8b 45 08             	mov    0x8(%ebp),%eax
     af5:	8b 40 0c             	mov    0xc(%eax),%eax
     af8:	85 c0                	test   %eax,%eax
     afa:	74 d5                	je     ad1 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
     aff:	8b 40 10             	mov    0x10(%eax),%eax
     b02:	85 c0                	test   %eax,%eax
     b04:	74 0f                	je     b15 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     b06:	8b 45 08             	mov    0x8(%ebp),%eax
     b09:	8b 40 0c             	mov    0xc(%eax),%eax
     b0c:	8d 50 ff             	lea    -0x1(%eax),%edx
     b0f:	8b 45 08             	mov    0x8(%ebp),%eax
     b12:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     b15:	8b 45 08             	mov    0x8(%ebp),%eax
     b18:	8b 40 08             	mov    0x8(%eax),%eax
     b1b:	89 04 24             	mov    %eax,(%esp)
     b1e:	e8 44 05 00 00       	call   1067 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     b23:	8b 45 08             	mov    0x8(%ebp),%eax
     b26:	8b 00                	mov    (%eax),%eax
     b28:	89 04 24             	mov    %eax,(%esp)
     b2b:	e8 1f f9 ff ff       	call   44f <kthread_mutex_unlock>

	return 1;
     b30:	b8 01 00 00 00       	mov    $0x1,%eax

}
     b35:	c9                   	leave  
     b36:	c3                   	ret    

00000b37 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     b37:	55                   	push   %ebp
     b38:	89 e5                	mov    %esp,%ebp
     b3a:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     b3d:	8b 45 08             	mov    0x8(%ebp),%eax
     b40:	8b 40 10             	mov    0x10(%eax),%eax
     b43:	85 c0                	test   %eax,%eax
     b45:	75 07                	jne    b4e <mesa_slots_monitor_stopadding+0x17>
			return -1;
     b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b4c:	eb 35                	jmp    b83 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     b4e:	8b 45 08             	mov    0x8(%ebp),%eax
     b51:	8b 00                	mov    (%eax),%eax
     b53:	89 04 24             	mov    %eax,(%esp)
     b56:	e8 ec f8 ff ff       	call   447 <kthread_mutex_lock>
     b5b:	83 f8 ff             	cmp    $0xffffffff,%eax
     b5e:	7d 07                	jge    b67 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b65:	eb 1c                	jmp    b83 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     b67:	8b 45 08             	mov    0x8(%ebp),%eax
     b6a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     b71:	8b 45 08             	mov    0x8(%ebp),%eax
     b74:	8b 00                	mov    (%eax),%eax
     b76:	89 04 24             	mov    %eax,(%esp)
     b79:	e8 d1 f8 ff ff       	call   44f <kthread_mutex_unlock>

		return 0;
     b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b83:	c9                   	leave  
     b84:	c3                   	ret    

00000b85 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     b85:	55                   	push   %ebp
     b86:	89 e5                	mov    %esp,%ebp
     b88:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     b8b:	e8 a7 f8 ff ff       	call   437 <kthread_mutex_alloc>
     b90:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     b93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b97:	79 0a                	jns    ba3 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     b99:	b8 00 00 00 00       	mov    $0x0,%eax
     b9e:	e9 8b 00 00 00       	jmp    c2e <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     ba3:	e8 68 02 00 00       	call   e10 <hoare_cond_alloc>
     ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     bab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     baf:	75 12                	jne    bc3 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bb4:	89 04 24             	mov    %eax,(%esp)
     bb7:	e8 83 f8 ff ff       	call   43f <kthread_mutex_dealloc>
		return 0;
     bbc:	b8 00 00 00 00       	mov    $0x0,%eax
     bc1:	eb 6b                	jmp    c2e <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     bc3:	e8 48 02 00 00       	call   e10 <hoare_cond_alloc>
     bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     bcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bcf:	75 1d                	jne    bee <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bd4:	89 04 24             	mov    %eax,(%esp)
     bd7:	e8 63 f8 ff ff       	call   43f <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bdf:	89 04 24             	mov    %eax,(%esp)
     be2:	e8 6a 02 00 00       	call   e51 <hoare_cond_dealloc>
		return 0;
     be7:	b8 00 00 00 00       	mov    $0x0,%eax
     bec:	eb 40                	jmp    c2e <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     bee:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     bf5:	e8 31 fc ff ff       	call   82b <malloc>
     bfa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c00:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c03:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c0c:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     c0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c15:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c24:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     c2b:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     c2e:	c9                   	leave  
     c2f:	c3                   	ret    

00000c30 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     c36:	8b 45 08             	mov    0x8(%ebp),%eax
     c39:	8b 00                	mov    (%eax),%eax
     c3b:	89 04 24             	mov    %eax,(%esp)
     c3e:	e8 fc f7 ff ff       	call   43f <kthread_mutex_dealloc>
     c43:	85 c0                	test   %eax,%eax
     c45:	78 2e                	js     c75 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     c47:	8b 45 08             	mov    0x8(%ebp),%eax
     c4a:	8b 40 04             	mov    0x4(%eax),%eax
     c4d:	89 04 24             	mov    %eax,(%esp)
     c50:	e8 bb 01 00 00       	call   e10 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     c55:	8b 45 08             	mov    0x8(%ebp),%eax
     c58:	8b 40 08             	mov    0x8(%eax),%eax
     c5b:	89 04 24             	mov    %eax,(%esp)
     c5e:	e8 ad 01 00 00       	call   e10 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     c63:	8b 45 08             	mov    0x8(%ebp),%eax
     c66:	89 04 24             	mov    %eax,(%esp)
     c69:	e8 84 fa ff ff       	call   6f2 <free>
	return 0;
     c6e:	b8 00 00 00 00       	mov    $0x0,%eax
     c73:	eb 05                	jmp    c7a <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     c7a:	c9                   	leave  
     c7b:	c3                   	ret    

00000c7c <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     c7c:	55                   	push   %ebp
     c7d:	89 e5                	mov    %esp,%ebp
     c7f:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     c82:	8b 45 08             	mov    0x8(%ebp),%eax
     c85:	8b 40 10             	mov    0x10(%eax),%eax
     c88:	85 c0                	test   %eax,%eax
     c8a:	75 0a                	jne    c96 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c91:	e9 88 00 00 00       	jmp    d1e <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c96:	8b 45 08             	mov    0x8(%ebp),%eax
     c99:	8b 00                	mov    (%eax),%eax
     c9b:	89 04 24             	mov    %eax,(%esp)
     c9e:	e8 a4 f7 ff ff       	call   447 <kthread_mutex_lock>
     ca3:	83 f8 ff             	cmp    $0xffffffff,%eax
     ca6:	7d 07                	jge    caf <hoare_slots_monitor_addslots+0x33>
		return -1;
     ca8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cad:	eb 6f                	jmp    d1e <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     caf:	8b 45 08             	mov    0x8(%ebp),%eax
     cb2:	8b 40 10             	mov    0x10(%eax),%eax
     cb5:	85 c0                	test   %eax,%eax
     cb7:	74 21                	je     cda <hoare_slots_monitor_addslots+0x5e>
     cb9:	8b 45 08             	mov    0x8(%ebp),%eax
     cbc:	8b 40 0c             	mov    0xc(%eax),%eax
     cbf:	85 c0                	test   %eax,%eax
     cc1:	7e 17                	jle    cda <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	8b 10                	mov    (%eax),%edx
     cc8:	8b 45 08             	mov    0x8(%ebp),%eax
     ccb:	8b 40 08             	mov    0x8(%eax),%eax
     cce:	89 54 24 04          	mov    %edx,0x4(%esp)
     cd2:	89 04 24             	mov    %eax,(%esp)
     cd5:	e8 c1 01 00 00       	call   e9b <hoare_cond_wait>


	if  ( monitor->active)
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	8b 40 10             	mov    0x10(%eax),%eax
     ce0:	85 c0                	test   %eax,%eax
     ce2:	74 11                	je     cf5 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     ce4:	8b 45 08             	mov    0x8(%ebp),%eax
     ce7:	8b 50 0c             	mov    0xc(%eax),%edx
     cea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ced:	01 c2                	add    %eax,%edx
     cef:	8b 45 08             	mov    0x8(%ebp),%eax
     cf2:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     cf5:	8b 45 08             	mov    0x8(%ebp),%eax
     cf8:	8b 10                	mov    (%eax),%edx
     cfa:	8b 45 08             	mov    0x8(%ebp),%eax
     cfd:	8b 40 04             	mov    0x4(%eax),%eax
     d00:	89 54 24 04          	mov    %edx,0x4(%esp)
     d04:	89 04 24             	mov    %eax,(%esp)
     d07:	e8 e6 01 00 00       	call   ef2 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d0c:	8b 45 08             	mov    0x8(%ebp),%eax
     d0f:	8b 00                	mov    (%eax),%eax
     d11:	89 04 24             	mov    %eax,(%esp)
     d14:	e8 36 f7 ff ff       	call   44f <kthread_mutex_unlock>

	return 1;
     d19:	b8 01 00 00 00       	mov    $0x1,%eax


}
     d1e:	c9                   	leave  
     d1f:	c3                   	ret    

00000d20 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	8b 40 10             	mov    0x10(%eax),%eax
     d2c:	85 c0                	test   %eax,%eax
     d2e:	75 0a                	jne    d3a <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d35:	e9 86 00 00 00       	jmp    dc0 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d3a:	8b 45 08             	mov    0x8(%ebp),%eax
     d3d:	8b 00                	mov    (%eax),%eax
     d3f:	89 04 24             	mov    %eax,(%esp)
     d42:	e8 00 f7 ff ff       	call   447 <kthread_mutex_lock>
     d47:	83 f8 ff             	cmp    $0xffffffff,%eax
     d4a:	7d 07                	jge    d53 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     d4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d51:	eb 6d                	jmp    dc0 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     d53:	8b 45 08             	mov    0x8(%ebp),%eax
     d56:	8b 40 10             	mov    0x10(%eax),%eax
     d59:	85 c0                	test   %eax,%eax
     d5b:	74 21                	je     d7e <hoare_slots_monitor_takeslot+0x5e>
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	8b 40 0c             	mov    0xc(%eax),%eax
     d63:	85 c0                	test   %eax,%eax
     d65:	75 17                	jne    d7e <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	8b 10                	mov    (%eax),%edx
     d6c:	8b 45 08             	mov    0x8(%ebp),%eax
     d6f:	8b 40 04             	mov    0x4(%eax),%eax
     d72:	89 54 24 04          	mov    %edx,0x4(%esp)
     d76:	89 04 24             	mov    %eax,(%esp)
     d79:	e8 1d 01 00 00       	call   e9b <hoare_cond_wait>


	if  ( monitor->active)
     d7e:	8b 45 08             	mov    0x8(%ebp),%eax
     d81:	8b 40 10             	mov    0x10(%eax),%eax
     d84:	85 c0                	test   %eax,%eax
     d86:	74 0f                	je     d97 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     d88:	8b 45 08             	mov    0x8(%ebp),%eax
     d8b:	8b 40 0c             	mov    0xc(%eax),%eax
     d8e:	8d 50 ff             	lea    -0x1(%eax),%edx
     d91:	8b 45 08             	mov    0x8(%ebp),%eax
     d94:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     d97:	8b 45 08             	mov    0x8(%ebp),%eax
     d9a:	8b 10                	mov    (%eax),%edx
     d9c:	8b 45 08             	mov    0x8(%ebp),%eax
     d9f:	8b 40 08             	mov    0x8(%eax),%eax
     da2:	89 54 24 04          	mov    %edx,0x4(%esp)
     da6:	89 04 24             	mov    %eax,(%esp)
     da9:	e8 44 01 00 00       	call   ef2 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     dae:	8b 45 08             	mov    0x8(%ebp),%eax
     db1:	8b 00                	mov    (%eax),%eax
     db3:	89 04 24             	mov    %eax,(%esp)
     db6:	e8 94 f6 ff ff       	call   44f <kthread_mutex_unlock>

	return 1;
     dbb:	b8 01 00 00 00       	mov    $0x1,%eax

}
     dc0:	c9                   	leave  
     dc1:	c3                   	ret    

00000dc2 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     dc2:	55                   	push   %ebp
     dc3:	89 e5                	mov    %esp,%ebp
     dc5:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     dc8:	8b 45 08             	mov    0x8(%ebp),%eax
     dcb:	8b 40 10             	mov    0x10(%eax),%eax
     dce:	85 c0                	test   %eax,%eax
     dd0:	75 07                	jne    dd9 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dd7:	eb 35                	jmp    e0e <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     dd9:	8b 45 08             	mov    0x8(%ebp),%eax
     ddc:	8b 00                	mov    (%eax),%eax
     dde:	89 04 24             	mov    %eax,(%esp)
     de1:	e8 61 f6 ff ff       	call   447 <kthread_mutex_lock>
     de6:	83 f8 ff             	cmp    $0xffffffff,%eax
     de9:	7d 07                	jge    df2 <hoare_slots_monitor_stopadding+0x30>
			return -1;
     deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     df0:	eb 1c                	jmp    e0e <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     df2:	8b 45 08             	mov    0x8(%ebp),%eax
     df5:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     dfc:	8b 45 08             	mov    0x8(%ebp),%eax
     dff:	8b 00                	mov    (%eax),%eax
     e01:	89 04 24             	mov    %eax,(%esp)
     e04:	e8 46 f6 ff ff       	call   44f <kthread_mutex_unlock>

		return 0;
     e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e0e:	c9                   	leave  
     e0f:	c3                   	ret    

00000e10 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     e16:	e8 1c f6 ff ff       	call   437 <kthread_mutex_alloc>
     e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e22:	79 07                	jns    e2b <hoare_cond_alloc+0x1b>
		return 0;
     e24:	b8 00 00 00 00       	mov    $0x0,%eax
     e29:	eb 24                	jmp    e4f <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     e2b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     e32:	e8 f4 f9 ff ff       	call   82b <malloc>
     e37:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e40:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e4f:	c9                   	leave  
     e50:	c3                   	ret    

00000e51 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     e51:	55                   	push   %ebp
     e52:	89 e5                	mov    %esp,%ebp
     e54:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e5b:	75 07                	jne    e64 <hoare_cond_dealloc+0x13>
			return -1;
     e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e62:	eb 35                	jmp    e99 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     e64:	8b 45 08             	mov    0x8(%ebp),%eax
     e67:	8b 00                	mov    (%eax),%eax
     e69:	89 04 24             	mov    %eax,(%esp)
     e6c:	e8 de f5 ff ff       	call   44f <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     e71:	8b 45 08             	mov    0x8(%ebp),%eax
     e74:	8b 00                	mov    (%eax),%eax
     e76:	89 04 24             	mov    %eax,(%esp)
     e79:	e8 c1 f5 ff ff       	call   43f <kthread_mutex_dealloc>
     e7e:	85 c0                	test   %eax,%eax
     e80:	79 07                	jns    e89 <hoare_cond_dealloc+0x38>
			return -1;
     e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e87:	eb 10                	jmp    e99 <hoare_cond_dealloc+0x48>

		free (hCond);
     e89:	8b 45 08             	mov    0x8(%ebp),%eax
     e8c:	89 04 24             	mov    %eax,(%esp)
     e8f:	e8 5e f8 ff ff       	call   6f2 <free>
		return 0;
     e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e99:	c9                   	leave  
     e9a:	c3                   	ret    

00000e9b <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     e9b:	55                   	push   %ebp
     e9c:	89 e5                	mov    %esp,%ebp
     e9e:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     ea1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ea5:	75 07                	jne    eae <hoare_cond_wait+0x13>
			return -1;
     ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eac:	eb 42                	jmp    ef0 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     eae:	8b 45 08             	mov    0x8(%ebp),%eax
     eb1:	8b 40 04             	mov    0x4(%eax),%eax
     eb4:	8d 50 01             	lea    0x1(%eax),%edx
     eb7:	8b 45 08             	mov    0x8(%ebp),%eax
     eba:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     ebd:	8b 45 08             	mov    0x8(%ebp),%eax
     ec0:	8b 00                	mov    (%eax),%eax
     ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec9:	89 04 24             	mov    %eax,(%esp)
     ecc:	e8 86 f5 ff ff       	call   457 <kthread_mutex_yieldlock>
     ed1:	85 c0                	test   %eax,%eax
     ed3:	79 16                	jns    eeb <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     ed5:	8b 45 08             	mov    0x8(%ebp),%eax
     ed8:	8b 40 04             	mov    0x4(%eax),%eax
     edb:	8d 50 ff             	lea    -0x1(%eax),%edx
     ede:	8b 45 08             	mov    0x8(%ebp),%eax
     ee1:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ee9:	eb 05                	jmp    ef0 <hoare_cond_wait+0x55>
		}

	return 0;
     eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ef0:	c9                   	leave  
     ef1:	c3                   	ret    

00000ef2 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     ef2:	55                   	push   %ebp
     ef3:	89 e5                	mov    %esp,%ebp
     ef5:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     efc:	75 07                	jne    f05 <hoare_cond_signal+0x13>
		return -1;
     efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f03:	eb 6b                	jmp    f70 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     f05:	8b 45 08             	mov    0x8(%ebp),%eax
     f08:	8b 40 04             	mov    0x4(%eax),%eax
     f0b:	85 c0                	test   %eax,%eax
     f0d:	7e 3d                	jle    f4c <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     f0f:	8b 45 08             	mov    0x8(%ebp),%eax
     f12:	8b 40 04             	mov    0x4(%eax),%eax
     f15:	8d 50 ff             	lea    -0x1(%eax),%edx
     f18:	8b 45 08             	mov    0x8(%ebp),%eax
     f1b:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     f1e:	8b 45 08             	mov    0x8(%ebp),%eax
     f21:	8b 00                	mov    (%eax),%eax
     f23:	89 44 24 04          	mov    %eax,0x4(%esp)
     f27:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2a:	89 04 24             	mov    %eax,(%esp)
     f2d:	e8 25 f5 ff ff       	call   457 <kthread_mutex_yieldlock>
     f32:	85 c0                	test   %eax,%eax
     f34:	79 16                	jns    f4c <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
     f36:	8b 45 08             	mov    0x8(%ebp),%eax
     f39:	8b 40 04             	mov    0x4(%eax),%eax
     f3c:	8d 50 01             	lea    0x1(%eax),%edx
     f3f:	8b 45 08             	mov    0x8(%ebp),%eax
     f42:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f4a:	eb 24                	jmp    f70 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	8b 00                	mov    (%eax),%eax
     f51:	89 44 24 04          	mov    %eax,0x4(%esp)
     f55:	8b 45 0c             	mov    0xc(%ebp),%eax
     f58:	89 04 24             	mov    %eax,(%esp)
     f5b:	e8 f7 f4 ff ff       	call   457 <kthread_mutex_yieldlock>
     f60:	85 c0                	test   %eax,%eax
     f62:	79 07                	jns    f6b <hoare_cond_signal+0x79>

    			return -1;
     f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f69:	eb 05                	jmp    f70 <hoare_cond_signal+0x7e>
    }

	return 0;
     f6b:	b8 00 00 00 00       	mov    $0x0,%eax

}
     f70:	c9                   	leave  
     f71:	c3                   	ret    

00000f72 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
     f72:	55                   	push   %ebp
     f73:	89 e5                	mov    %esp,%ebp
     f75:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     f78:	e8 ba f4 ff ff       	call   437 <kthread_mutex_alloc>
     f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f84:	79 07                	jns    f8d <mesa_cond_alloc+0x1b>
		return 0;
     f86:	b8 00 00 00 00       	mov    $0x0,%eax
     f8b:	eb 24                	jmp    fb1 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
     f8d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     f94:	e8 92 f8 ff ff       	call   82b <malloc>
     f99:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
     f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fa2:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
     fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
     fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     fb1:	c9                   	leave  
     fb2:	c3                   	ret    

00000fb3 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
     fb3:	55                   	push   %ebp
     fb4:	89 e5                	mov    %esp,%ebp
     fb6:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
     fb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fbd:	75 07                	jne    fc6 <mesa_cond_dealloc+0x13>
		return -1;
     fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fc4:	eb 35                	jmp    ffb <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
     fc6:	8b 45 08             	mov    0x8(%ebp),%eax
     fc9:	8b 00                	mov    (%eax),%eax
     fcb:	89 04 24             	mov    %eax,(%esp)
     fce:	e8 7c f4 ff ff       	call   44f <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
     fd3:	8b 45 08             	mov    0x8(%ebp),%eax
     fd6:	8b 00                	mov    (%eax),%eax
     fd8:	89 04 24             	mov    %eax,(%esp)
     fdb:	e8 5f f4 ff ff       	call   43f <kthread_mutex_dealloc>
     fe0:	85 c0                	test   %eax,%eax
     fe2:	79 07                	jns    feb <mesa_cond_dealloc+0x38>
		return -1;
     fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fe9:	eb 10                	jmp    ffb <mesa_cond_dealloc+0x48>

	free (mCond);
     feb:	8b 45 08             	mov    0x8(%ebp),%eax
     fee:	89 04 24             	mov    %eax,(%esp)
     ff1:	e8 fc f6 ff ff       	call   6f2 <free>
	return 0;
     ff6:	b8 00 00 00 00       	mov    $0x0,%eax

}
     ffb:	c9                   	leave  
     ffc:	c3                   	ret    

00000ffd <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
     ffd:	55                   	push   %ebp
     ffe:	89 e5                	mov    %esp,%ebp
    1000:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1003:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1007:	75 07                	jne    1010 <mesa_cond_wait+0x13>
		return -1;
    1009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    100e:	eb 55                	jmp    1065 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    1010:	8b 45 08             	mov    0x8(%ebp),%eax
    1013:	8b 40 04             	mov    0x4(%eax),%eax
    1016:	8d 50 01             	lea    0x1(%eax),%edx
    1019:	8b 45 08             	mov    0x8(%ebp),%eax
    101c:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    101f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 25 f4 ff ff       	call   44f <kthread_mutex_unlock>
    102a:	85 c0                	test   %eax,%eax
    102c:	79 27                	jns    1055 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    102e:	8b 45 08             	mov    0x8(%ebp),%eax
    1031:	8b 00                	mov    (%eax),%eax
    1033:	89 04 24             	mov    %eax,(%esp)
    1036:	e8 0c f4 ff ff       	call   447 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    103b:	85 c0                	test   %eax,%eax
    103d:	79 16                	jns    1055 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    103f:	8b 45 08             	mov    0x8(%ebp),%eax
    1042:	8b 40 04             	mov    0x4(%eax),%eax
    1045:	8d 50 ff             	lea    -0x1(%eax),%edx
    1048:	8b 45 08             	mov    0x8(%ebp),%eax
    104b:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    104e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1053:	eb 10                	jmp    1065 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    1055:	8b 45 0c             	mov    0xc(%ebp),%eax
    1058:	89 04 24             	mov    %eax,(%esp)
    105b:	e8 e7 f3 ff ff       	call   447 <kthread_mutex_lock>
	return 0;
    1060:	b8 00 00 00 00       	mov    $0x0,%eax


}
    1065:	c9                   	leave  
    1066:	c3                   	ret    

00001067 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    1067:	55                   	push   %ebp
    1068:	89 e5                	mov    %esp,%ebp
    106a:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    106d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1071:	75 07                	jne    107a <mesa_cond_signal+0x13>
		return -1;
    1073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1078:	eb 5d                	jmp    10d7 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    107a:	8b 45 08             	mov    0x8(%ebp),%eax
    107d:	8b 40 04             	mov    0x4(%eax),%eax
    1080:	85 c0                	test   %eax,%eax
    1082:	7e 36                	jle    10ba <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    1084:	8b 45 08             	mov    0x8(%ebp),%eax
    1087:	8b 40 04             	mov    0x4(%eax),%eax
    108a:	8d 50 ff             	lea    -0x1(%eax),%edx
    108d:	8b 45 08             	mov    0x8(%ebp),%eax
    1090:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	8b 00                	mov    (%eax),%eax
    1098:	89 04 24             	mov    %eax,(%esp)
    109b:	e8 af f3 ff ff       	call   44f <kthread_mutex_unlock>
    10a0:	85 c0                	test   %eax,%eax
    10a2:	78 16                	js     10ba <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	8b 40 04             	mov    0x4(%eax),%eax
    10aa:	8d 50 01             	lea    0x1(%eax),%edx
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
    10b0:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    10b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10b8:	eb 1d                	jmp    10d7 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	8b 00                	mov    (%eax),%eax
    10bf:	89 04 24             	mov    %eax,(%esp)
    10c2:	e8 88 f3 ff ff       	call   44f <kthread_mutex_unlock>
    10c7:	85 c0                	test   %eax,%eax
    10c9:	79 07                	jns    10d2 <mesa_cond_signal+0x6b>

		return -1;
    10cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10d0:	eb 05                	jmp    10d7 <mesa_cond_signal+0x70>
	}
	return 0;
    10d2:	b8 00 00 00 00       	mov    $0x0,%eax

}
    10d7:	c9                   	leave  
    10d8:	c3                   	ret    
