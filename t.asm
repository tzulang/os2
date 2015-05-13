
_t:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:

    static char *echoargv[0];

    void
    foo()
    {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
      while (other_tid == 0){
   6:	90                   	nop
   7:	a1 c0 0c 00 00       	mov    0xcc0,%eax
   c:	85 c0                	test   %eax,%eax
   e:	74 f7                	je     7 <foo+0x7>

      };
      kthread_join(other_tid);
  10:	a1 c0 0c 00 00       	mov    0xcc0,%eax
  15:	89 04 24             	mov    %eax,(%esp)
  18:	e8 97 04 00 00       	call   4b4 <kthread_join>
      printf(1, "Foo exiting because goo finished running\n");
  1d:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
  24:	00 
  25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2c:	e8 6b 05 00 00       	call   59c <printf>
      kthread_exit();
  31:	e8 76 04 00 00       	call   4ac <kthread_exit>
    }
  36:	c9                   	leave  
  37:	c3                   	ret    

00000038 <goo>:

    void
    goo()
    {
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	83 ec 28             	sub    $0x28,%esp
      int i,z=0 ;
  3e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      other_tid = kthread_id();
  45:	e8 5a 04 00 00       	call   4a4 <kthread_id>
  4a:	a3 c0 0c 00 00       	mov    %eax,0xcc0
      printf(1, "Starting goo! my tid : %d \n ", other_tid);
  4f:	a1 c0 0c 00 00       	mov    0xcc0,%eax
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	c7 44 24 04 92 09 00 	movl   $0x992,0x4(%esp)
  5f:	00 
  60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  67:	e8 30 05 00 00       	call   59c <printf>
      for (i = 0 ; i < 999999 ; i++){
  6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  73:	eb 0f                	jmp    84 <goo+0x4c>
        z = 9999999 ^ 3231;
  75:	c7 45 f0 e0 9a 98 00 	movl   $0x989ae0,-0x10(%ebp)
        z++;
  7c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    goo()
    {
      int i,z=0 ;
      other_tid = kthread_id();
      printf(1, "Starting goo! my tid : %d \n ", other_tid);
      for (i = 0 ; i < 999999 ; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	81 7d f4 3e 42 0f 00 	cmpl   $0xf423e,-0xc(%ebp)
  8b:	7e e8                	jle    75 <goo+0x3d>
        z = 9999999 ^ 3231;
        z++;
      }
      printf(1, "goo finished calculating, exiting!\n");
  8d:	c7 44 24 04 b0 09 00 	movl   $0x9b0,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 fb 04 00 00       	call   59c <printf>
      exec("ls", echoargv);
  a1:	c7 44 24 04 c4 0c 00 	movl   $0xcc4,0x4(%esp)
  a8:	00 
  a9:	c7 04 24 d4 09 00 00 	movl   $0x9d4,(%esp)
  b0:	e8 7f 03 00 00       	call   434 <exec>
      kthread_exit();
  b5:	e8 f2 03 00 00       	call   4ac <kthread_exit>
    }
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <main>:

    int
    main(int argc, char *argv[])
    {
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	53                   	push   %ebx
  c0:	83 e4 f0             	and    $0xfffffff0,%esp
  c3:	83 ec 20             	sub    $0x20,%esp
      int i;
      int b=0;
  c6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  cd:	00 
      printf(1, "This is main pid :  %d , this is main tid: %d \n", getpid(), kthread_id());
  ce:	e8 d1 03 00 00       	call   4a4 <kthread_id>
  d3:	89 c3                	mov    %eax,%ebx
  d5:	e8 a2 03 00 00       	call   47c <getpid>
  da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  de:	89 44 24 08          	mov    %eax,0x8(%esp)
  e2:	c7 44 24 04 d8 09 00 	movl   $0x9d8,0x4(%esp)
  e9:	00 
  ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f1:	e8 a6 04 00 00       	call   59c <printf>

      b++;
  f6:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
      kthread_create(goo, malloc(4000), 4000);
  fb:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
 102:	e8 81 07 00 00       	call   888 <malloc>
 107:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
 10e:	00 
 10f:	89 44 24 04          	mov    %eax,0x4(%esp)
 113:	c7 04 24 38 00 00 00 	movl   $0x38,(%esp)
 11a:	e8 7d 03 00 00       	call   49c <kthread_create>
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
 11f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 126:	00 
 127:	eb 0d                	jmp    136 <main+0x7a>
 129:	c7 44 24 18 1b a1 07 	movl   $0x7a11b,0x18(%esp)
 130:	00 
 131:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 136:	81 7c 24 1c 9e 86 01 	cmpl   $0x1869e,0x1c(%esp)
 13d:	00 
 13e:	7e e9                	jle    129 <main+0x6d>
      kthread_create(foo, malloc(4000), 4000);
 140:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
 147:	e8 3c 07 00 00       	call   888 <malloc>
 14c:	c7 44 24 08 a0 0f 00 	movl   $0xfa0,0x8(%esp)
 153:	00 
 154:	89 44 24 04          	mov    %eax,0x4(%esp)
 158:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15f:	e8 38 03 00 00       	call   49c <kthread_create>
      for (i=0 ; i < 99999 ; i++) { b = 5 *99999;}
 164:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 16b:	00 
 16c:	eb 0d                	jmp    17b <main+0xbf>
 16e:	c7 44 24 18 1b a1 07 	movl   $0x7a11b,0x18(%esp)
 175:	00 
 176:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 17b:	81 7c 24 1c 9e 86 01 	cmpl   $0x1869e,0x1c(%esp)
 182:	00 
 183:	7e e9                	jle    16e <main+0xb2>
      kthread_exit();
 185:	e8 22 03 00 00       	call   4ac <kthread_exit>
      return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
    }
 18f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 199:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19c:	8b 55 10             	mov    0x10(%ebp),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	89 cb                	mov    %ecx,%ebx
 1a4:	89 df                	mov    %ebx,%edi
 1a6:	89 d1                	mov    %edx,%ecx
 1a8:	fc                   	cld    
 1a9:	f3 aa                	rep stos %al,%es:(%edi)
 1ab:	89 ca                	mov    %ecx,%edx
 1ad:	89 fb                	mov    %edi,%ebx
 1af:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1b5:	5b                   	pop    %ebx
 1b6:	5f                   	pop    %edi
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    

000001b9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1c5:	90                   	nop
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	8d 50 01             	lea    0x1(%eax),%edx
 1cc:	89 55 08             	mov    %edx,0x8(%ebp)
 1cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 1d2:	8d 4a 01             	lea    0x1(%edx),%ecx
 1d5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1d8:	0f b6 12             	movzbl (%edx),%edx
 1db:	88 10                	mov    %dl,(%eax)
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	84 c0                	test   %al,%al
 1e2:	75 e2                	jne    1c6 <strcpy+0xd>
    ;
  return os;
 1e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ec:	eb 08                	jmp    1f6 <strcmp+0xd>
    p++, q++;
 1ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	74 10                	je     210 <strcmp+0x27>
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 10             	movzbl (%eax),%edx
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	38 c2                	cmp    %al,%dl
 20e:	74 de                	je     1ee <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	0f b6 d0             	movzbl %al,%edx
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	0f b6 c0             	movzbl %al,%eax
 222:	29 c2                	sub    %eax,%edx
 224:	89 d0                	mov    %edx,%eax
}
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    

00000228 <strlen>:

uint
strlen(char *s)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 22e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 235:	eb 04                	jmp    23b <strlen+0x13>
 237:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 23b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 d0                	add    %edx,%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	84 c0                	test   %al,%al
 248:	75 ed                	jne    237 <strlen+0xf>
    ;
  return n;
 24a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <memset>:

void*
memset(void *dst, int c, uint n)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 255:	8b 45 10             	mov    0x10(%ebp),%eax
 258:	89 44 24 08          	mov    %eax,0x8(%esp)
 25c:	8b 45 0c             	mov    0xc(%ebp),%eax
 25f:	89 44 24 04          	mov    %eax,0x4(%esp)
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	89 04 24             	mov    %eax,(%esp)
 269:	e8 26 ff ff ff       	call   194 <stosb>
  return dst;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <strchr>:

char*
strchr(const char *s, char c)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 04             	sub    $0x4,%esp
 279:	8b 45 0c             	mov    0xc(%ebp),%eax
 27c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 27f:	eb 14                	jmp    295 <strchr+0x22>
    if(*s == c)
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3a 45 fc             	cmp    -0x4(%ebp),%al
 28a:	75 05                	jne    291 <strchr+0x1e>
      return (char*)s;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	eb 13                	jmp    2a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	84 c0                	test   %al,%al
 29d:	75 e2                	jne    281 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <gets>:

char*
gets(char *buf, int max)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b3:	eb 4c                	jmp    301 <gets+0x5b>
    cc = read(0, &c, 1);
 2b5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2bc:	00 
 2bd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2cb:	e8 44 01 00 00       	call   414 <read>
 2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2d7:	7f 02                	jg     2db <gets+0x35>
      break;
 2d9:	eb 31                	jmp    30c <gets+0x66>
    buf[i++] = c;
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	8d 50 01             	lea    0x1(%eax),%edx
 2e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2e4:	89 c2                	mov    %eax,%edx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	01 c2                	add    %eax,%edx
 2eb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ef:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f5:	3c 0a                	cmp    $0xa,%al
 2f7:	74 13                	je     30c <gets+0x66>
 2f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2fd:	3c 0d                	cmp    $0xd,%al
 2ff:	74 0b                	je     30c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 301:	8b 45 f4             	mov    -0xc(%ebp),%eax
 304:	83 c0 01             	add    $0x1,%eax
 307:	3b 45 0c             	cmp    0xc(%ebp),%eax
 30a:	7c a9                	jl     2b5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 30c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	01 d0                	add    %edx,%eax
 314:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 317:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <stat>:

int
stat(char *n, struct stat *st)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 329:	00 
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	89 04 24             	mov    %eax,(%esp)
 330:	e8 07 01 00 00       	call   43c <open>
 335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 33c:	79 07                	jns    345 <stat+0x29>
    return -1;
 33e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 343:	eb 23                	jmp    368 <stat+0x4c>
  r = fstat(fd, st);
 345:	8b 45 0c             	mov    0xc(%ebp),%eax
 348:	89 44 24 04          	mov    %eax,0x4(%esp)
 34c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34f:	89 04 24             	mov    %eax,(%esp)
 352:	e8 fd 00 00 00       	call   454 <fstat>
 357:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35d:	89 04 24             	mov    %eax,(%esp)
 360:	e8 bf 00 00 00       	call   424 <close>
  return r;
 365:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <atoi>:

int
atoi(const char *s)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 377:	eb 25                	jmp    39e <atoi+0x34>
    n = n*10 + *s++ - '0';
 379:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37c:	89 d0                	mov    %edx,%eax
 37e:	c1 e0 02             	shl    $0x2,%eax
 381:	01 d0                	add    %edx,%eax
 383:	01 c0                	add    %eax,%eax
 385:	89 c1                	mov    %eax,%ecx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8d 50 01             	lea    0x1(%eax),%edx
 38d:	89 55 08             	mov    %edx,0x8(%ebp)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	0f be c0             	movsbl %al,%eax
 396:	01 c8                	add    %ecx,%eax
 398:	83 e8 30             	sub    $0x30,%eax
 39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	3c 2f                	cmp    $0x2f,%al
 3a6:	7e 0a                	jle    3b2 <atoi+0x48>
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	3c 39                	cmp    $0x39,%al
 3b0:	7e c7                	jle    379 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c9:	eb 17                	jmp    3e2 <memmove+0x2b>
    *dst++ = *src++;
 3cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ce:	8d 50 01             	lea    0x1(%eax),%edx
 3d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d7:	8d 4a 01             	lea    0x1(%edx),%ecx
 3da:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3dd:	0f b6 12             	movzbl (%edx),%edx
 3e0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e2:	8b 45 10             	mov    0x10(%ebp),%eax
 3e5:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e8:	89 55 10             	mov    %edx,0x10(%ebp)
 3eb:	85 c0                	test   %eax,%eax
 3ed:	7f dc                	jg     3cb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f4:	b8 01 00 00 00       	mov    $0x1,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <exit>:
SYSCALL(exit)
 3fc:	b8 02 00 00 00       	mov    $0x2,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <wait>:
SYSCALL(wait)
 404:	b8 03 00 00 00       	mov    $0x3,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <pipe>:
SYSCALL(pipe)
 40c:	b8 04 00 00 00       	mov    $0x4,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <read>:
SYSCALL(read)
 414:	b8 05 00 00 00       	mov    $0x5,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <write>:
SYSCALL(write)
 41c:	b8 10 00 00 00       	mov    $0x10,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <close>:
SYSCALL(close)
 424:	b8 15 00 00 00       	mov    $0x15,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <kill>:
SYSCALL(kill)
 42c:	b8 06 00 00 00       	mov    $0x6,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <exec>:
SYSCALL(exec)
 434:	b8 07 00 00 00       	mov    $0x7,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <open>:
SYSCALL(open)
 43c:	b8 0f 00 00 00       	mov    $0xf,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <mknod>:
SYSCALL(mknod)
 444:	b8 11 00 00 00       	mov    $0x11,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <unlink>:
SYSCALL(unlink)
 44c:	b8 12 00 00 00       	mov    $0x12,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <fstat>:
SYSCALL(fstat)
 454:	b8 08 00 00 00       	mov    $0x8,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <link>:
SYSCALL(link)
 45c:	b8 13 00 00 00       	mov    $0x13,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mkdir>:
SYSCALL(mkdir)
 464:	b8 14 00 00 00       	mov    $0x14,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <chdir>:
SYSCALL(chdir)
 46c:	b8 09 00 00 00       	mov    $0x9,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <dup>:
SYSCALL(dup)
 474:	b8 0a 00 00 00       	mov    $0xa,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getpid>:
SYSCALL(getpid)
 47c:	b8 0b 00 00 00       	mov    $0xb,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <sbrk>:
SYSCALL(sbrk)
 484:	b8 0c 00 00 00       	mov    $0xc,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <sleep>:
SYSCALL(sleep)
 48c:	b8 0d 00 00 00       	mov    $0xd,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <uptime>:
SYSCALL(uptime)
 494:	b8 0e 00 00 00       	mov    $0xe,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <kthread_create>:




SYSCALL(kthread_create)
 49c:	b8 16 00 00 00       	mov    $0x16,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <kthread_id>:
SYSCALL(kthread_id)
 4a4:	b8 17 00 00 00       	mov    $0x17,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <kthread_exit>:
SYSCALL(kthread_exit)
 4ac:	b8 18 00 00 00       	mov    $0x18,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <kthread_join>:
SYSCALL(kthread_join)
 4b4:	b8 19 00 00 00       	mov    $0x19,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 3a ff ff ff       	call   41c <write>
}
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	56                   	push   %esi
 4e8:	53                   	push   %ebx
 4e9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f7:	74 17                	je     510 <printint+0x2c>
 4f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fd:	79 11                	jns    510 <printint+0x2c>
    neg = 1;
 4ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	f7 d8                	neg    %eax
 50b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50e:	eb 06                	jmp    516 <printint+0x32>
  } else {
    x = xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 520:	8d 41 01             	lea    0x1(%ecx),%eax
 523:	89 45 f4             	mov    %eax,-0xc(%ebp)
 526:	8b 5d 10             	mov    0x10(%ebp),%ebx
 529:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52c:	ba 00 00 00 00       	mov    $0x0,%edx
 531:	f7 f3                	div    %ebx
 533:	89 d0                	mov    %edx,%eax
 535:	0f b6 80 9c 0c 00 00 	movzbl 0xc9c(%eax),%eax
 53c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 540:	8b 75 10             	mov    0x10(%ebp),%esi
 543:	8b 45 ec             	mov    -0x14(%ebp),%eax
 546:	ba 00 00 00 00       	mov    $0x0,%edx
 54b:	f7 f6                	div    %esi
 54d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 554:	75 c7                	jne    51d <printint+0x39>
  if(neg)
 556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55a:	74 10                	je     56c <printint+0x88>
    buf[i++] = '-';
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 f4             	mov    %edx,-0xc(%ebp)
 565:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56a:	eb 1f                	jmp    58b <printint+0xa7>
 56c:	eb 1d                	jmp    58b <printint+0xa7>
    putc(fd, buf[i]);
 56e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	01 d0                	add    %edx,%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 31 ff ff ff       	call   4bc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 593:	79 d9                	jns    56e <printint+0x8a>
    putc(fd, buf[i]);
}
 595:	83 c4 30             	add    $0x30,%esp
 598:	5b                   	pop    %ebx
 599:	5e                   	pop    %esi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    

0000059c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a9:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ac:	83 c0 04             	add    $0x4,%eax
 5af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b9:	e9 7c 01 00 00       	jmp    73a <printf+0x19e>
    c = fmt[i] & 0xff;
 5be:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c4:	01 d0                	add    %edx,%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	25 ff 00 00 00       	and    $0xff,%eax
 5d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d8:	75 2c                	jne    606 <printf+0x6a>
      if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 0c                	jne    5ec <printf+0x50>
        state = '%';
 5e0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e7:	e9 4a 01 00 00       	jmp    736 <printf+0x19a>
      } else {
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 bb fe ff ff       	call   4bc <putc>
 601:	e9 30 01 00 00       	jmp    736 <printf+0x19a>
      }
    } else if(state == '%'){
 606:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60a:	0f 85 26 01 00 00    	jne    736 <printf+0x19a>
      if(c == 'd'){
 610:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 614:	75 2d                	jne    643 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 622:	00 
 623:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62a:	00 
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 aa fe ff ff       	call   4e4 <printint>
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	e9 ec 00 00 00       	jmp    72f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 643:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 647:	74 06                	je     64f <printf+0xb3>
 649:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 64d:	75 2d                	jne    67c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 64f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 65b:	00 
 65c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 663:	00 
 664:	89 44 24 04          	mov    %eax,0x4(%esp)
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 71 fe ff ff       	call   4e4 <printint>
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 677:	e9 b3 00 00 00       	jmp    72f <printf+0x193>
      } else if(c == 's'){
 67c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 680:	75 45                	jne    6c7 <printf+0x12b>
        s = (char*)*ap;
 682:	8b 45 e8             	mov    -0x18(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 692:	75 09                	jne    69d <printf+0x101>
          s = "(null)";
 694:	c7 45 f4 08 0a 00 00 	movl   $0xa08,-0xc(%ebp)
        while(*s != 0){
 69b:	eb 1e                	jmp    6bb <printf+0x11f>
 69d:	eb 1c                	jmp    6bb <printf+0x11f>
          putc(fd, *s);
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 05 fe ff ff       	call   4bc <putc>
          s++;
 6b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	75 da                	jne    69f <printf+0x103>
 6c5:	eb 68                	jmp    72f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cb:	75 1d                	jne    6ea <printf+0x14e>
        putc(fd, *ap);
 6cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	0f be c0             	movsbl %al,%eax
 6d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 d8 fd ff ff       	call   4bc <putc>
        ap++;
 6e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e8:	eb 45                	jmp    72f <printf+0x193>
      } else if(c == '%'){
 6ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ee:	75 17                	jne    707 <printf+0x16b>
        putc(fd, c);
 6f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f3:	0f be c0             	movsbl %al,%eax
 6f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	89 04 24             	mov    %eax,(%esp)
 700:	e8 b7 fd ff ff       	call   4bc <putc>
 705:	eb 28                	jmp    72f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 707:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 70e:	00 
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 a2 fd ff ff       	call   4bc <putc>
        putc(fd, c);
 71a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 8d fd ff ff       	call   4bc <putc>
      }
      state = 0;
 72f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 736:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 73a:	8b 55 0c             	mov    0xc(%ebp),%edx
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	0f b6 00             	movzbl (%eax),%eax
 745:	84 c0                	test   %al,%al
 747:	0f 85 71 fe ff ff    	jne    5be <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74d:	c9                   	leave  
 74e:	c3                   	ret    

0000074f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74f:	55                   	push   %ebp
 750:	89 e5                	mov    %esp,%ebp
 752:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	83 e8 08             	sub    $0x8,%eax
 75b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	a1 cc 0c 00 00       	mov    0xccc,%eax
 763:	89 45 fc             	mov    %eax,-0x4(%ebp)
 766:	eb 24                	jmp    78c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 770:	77 12                	ja     784 <free+0x35>
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 778:	77 24                	ja     79e <free+0x4f>
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 782:	77 1a                	ja     79e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 792:	76 d4                	jbe    768 <free+0x19>
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79c:	76 ca                	jbe    768 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 40 04             	mov    0x4(%eax),%eax
 7a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	01 c2                	add    %eax,%edx
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	39 c2                	cmp    %eax,%edx
 7b7:	75 24                	jne    7dd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bc:	8b 50 04             	mov    0x4(%eax),%edx
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	01 c2                	add    %eax,%edx
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
 7db:	eb 0a                	jmp    7e7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e0:	8b 10                	mov    (%eax),%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	01 d0                	add    %edx,%eax
 7f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fc:	75 20                	jne    81e <free+0xcf>
    p->s.size += bp->s.size;
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 50 04             	mov    0x4(%eax),%edx
 804:	8b 45 f8             	mov    -0x8(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	01 c2                	add    %eax,%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	8b 10                	mov    (%eax),%edx
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	89 10                	mov    %edx,(%eax)
 81c:	eb 08                	jmp    826 <free+0xd7>
  } else
    p->s.ptr = bp;
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 55 f8             	mov    -0x8(%ebp),%edx
 824:	89 10                	mov    %edx,(%eax)
  freep = p;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	a3 cc 0c 00 00       	mov    %eax,0xccc
}
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <morecore>:

static Header*
morecore(uint nu)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 836:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83d:	77 07                	ja     846 <morecore+0x16>
    nu = 4096;
 83f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	c1 e0 03             	shl    $0x3,%eax
 84c:	89 04 24             	mov    %eax,(%esp)
 84f:	e8 30 fc ff ff       	call   484 <sbrk>
 854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 857:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85b:	75 07                	jne    864 <morecore+0x34>
    return 0;
 85d:	b8 00 00 00 00       	mov    $0x0,%eax
 862:	eb 22                	jmp    886 <morecore+0x56>
  hp = (Header*)p;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86d:	8b 55 08             	mov    0x8(%ebp),%edx
 870:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	83 c0 08             	add    $0x8,%eax
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 ce fe ff ff       	call   74f <free>
  return freep;
 881:	a1 cc 0c 00 00       	mov    0xccc,%eax
}
 886:	c9                   	leave  
 887:	c3                   	ret    

00000888 <malloc>:

void*
malloc(uint nbytes)
{
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	83 c0 07             	add    $0x7,%eax
 894:	c1 e8 03             	shr    $0x3,%eax
 897:	83 c0 01             	add    $0x1,%eax
 89a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89d:	a1 cc 0c 00 00       	mov    0xccc,%eax
 8a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a9:	75 23                	jne    8ce <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ab:	c7 45 f0 c4 0c 00 00 	movl   $0xcc4,-0x10(%ebp)
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	a3 cc 0c 00 00       	mov    %eax,0xccc
 8ba:	a1 cc 0c 00 00       	mov    0xccc,%eax
 8bf:	a3 c4 0c 00 00       	mov    %eax,0xcc4
    base.s.size = 0;
 8c4:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
 8cb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	8b 00                	mov    (%eax),%eax
 8d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8df:	72 4d                	jb     92e <malloc+0xa6>
      if(p->s.size == nunits)
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ea:	75 0c                	jne    8f8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 10                	mov    (%eax),%edx
 8f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f4:	89 10                	mov    %edx,(%eax)
 8f6:	eb 26                	jmp    91e <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	8b 40 04             	mov    0x4(%eax),%eax
 8fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
 901:	89 c2                	mov    %eax,%edx
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	c1 e0 03             	shl    $0x3,%eax
 912:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 921:	a3 cc 0c 00 00       	mov    %eax,0xccc
      return (void*)(p + 1);
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	83 c0 08             	add    $0x8,%eax
 92c:	eb 38                	jmp    966 <malloc+0xde>
    }
    if(p == freep)
 92e:	a1 cc 0c 00 00       	mov    0xccc,%eax
 933:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 936:	75 1b                	jne    953 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 938:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93b:	89 04 24             	mov    %eax,(%esp)
 93e:	e8 ed fe ff ff       	call   830 <morecore>
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
 946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94a:	75 07                	jne    953 <malloc+0xcb>
        return 0;
 94c:	b8 00 00 00 00       	mov    $0x0,%eax
 951:	eb 13                	jmp    966 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	89 45 f0             	mov    %eax,-0x10(%ebp)
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	8b 00                	mov    (%eax),%eax
 95e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 961:	e9 70 ff ff ff       	jmp    8d6 <malloc+0x4e>
}
 966:	c9                   	leave  
 967:	c3                   	ret    
