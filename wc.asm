
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
       6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
       d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      10:	89 45 ec             	mov    %eax,-0x14(%ebp)
      13:	8b 45 ec             	mov    -0x14(%ebp),%eax
      16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
      19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
      20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
      22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      29:	eb 57                	jmp    82 <wc+0x82>
      c++;
      2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
      2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      32:	05 c0 16 00 00       	add    $0x16c0,%eax
      37:	0f b6 00             	movzbl (%eax),%eax
      3a:	3c 0a                	cmp    $0xa,%al
      3c:	75 04                	jne    42 <wc+0x42>
        l++;
      3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
      42:	8b 45 f4             	mov    -0xc(%ebp),%eax
      45:	05 c0 16 00 00       	add    $0x16c0,%eax
      4a:	0f b6 00             	movzbl (%eax),%eax
      4d:	0f be c0             	movsbl %al,%eax
      50:	89 44 24 04          	mov    %eax,0x4(%esp)
      54:	c7 04 24 a3 11 00 00 	movl   $0x11a3,(%esp)
      5b:	e8 58 02 00 00       	call   2b8 <strchr>
      60:	85 c0                	test   %eax,%eax
      62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
      64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
      6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      71:	75 0b                	jne    7e <wc+0x7e>
        w++;
      73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
      77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      82:	8b 45 f4             	mov    -0xc(%ebp),%eax
      85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
      88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
      8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
      91:	00 
      92:	c7 44 24 04 c0 16 00 	movl   $0x16c0,0x4(%esp)
      99:	00 
      9a:	8b 45 08             	mov    0x8(%ebp),%eax
      9d:	89 04 24             	mov    %eax,(%esp)
      a0:	e8 b4 03 00 00       	call   459 <read>
      a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
      a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
      b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
      b8:	c7 44 24 04 a9 11 00 	movl   $0x11a9,0x4(%esp)
      bf:	00 
      c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      c7:	e8 3d 05 00 00       	call   609 <printf>
    exit();
      cc:	e8 70 03 00 00       	call   441 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
      d1:	8b 45 0c             	mov    0xc(%ebp),%eax
      d4:	89 44 24 14          	mov    %eax,0x14(%esp)
      d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
      db:	89 44 24 10          	mov    %eax,0x10(%esp)
      df:	8b 45 ec             	mov    -0x14(%ebp),%eax
      e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
      e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
      e9:	89 44 24 08          	mov    %eax,0x8(%esp)
      ed:	c7 44 24 04 b9 11 00 	movl   $0x11b9,0x4(%esp)
      f4:	00 
      f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      fc:	e8 08 05 00 00       	call   609 <printf>
}
     101:	c9                   	leave  
     102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
     103:	55                   	push   %ebp
     104:	89 e5                	mov    %esp,%ebp
     106:	83 e4 f0             	and    $0xfffffff0,%esp
     109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
     10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
     112:	c7 44 24 04 c6 11 00 	movl   $0x11c6,0x4(%esp)
     119:	00 
     11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     121:	e8 da fe ff ff       	call   0 <wc>
    exit();
     126:	e8 16 03 00 00       	call   441 <exit>
  }

  for(i = 1; i < argc; i++){
     12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     132:	00 
     133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
     138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     143:	8b 45 0c             	mov    0xc(%ebp),%eax
     146:	01 d0                	add    %edx,%eax
     148:	8b 00                	mov    (%eax),%eax
     14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     151:	00 
     152:	89 04 24             	mov    %eax,(%esp)
     155:	e8 27 03 00 00       	call   481 <open>
     15a:	89 44 24 18          	mov    %eax,0x18(%esp)
     15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
     163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
     165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     170:	8b 45 0c             	mov    0xc(%ebp),%eax
     173:	01 d0                	add    %edx,%eax
     175:	8b 00                	mov    (%eax),%eax
     177:	89 44 24 08          	mov    %eax,0x8(%esp)
     17b:	c7 44 24 04 c7 11 00 	movl   $0x11c7,0x4(%esp)
     182:	00 
     183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     18a:	e8 7a 04 00 00       	call   609 <printf>
      exit();
     18f:	e8 ad 02 00 00       	call   441 <exit>
    }
    wc(fd, argv[i]);
     194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     19f:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a2:	01 d0                	add    %edx,%eax
     1a4:	8b 00                	mov    (%eax),%eax
     1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
     1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
     1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
     1ba:	89 04 24             	mov    %eax,(%esp)
     1bd:	e8 a7 02 00 00       	call   469 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
     1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
     1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
     1d4:	e8 68 02 00 00       	call   441 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     1d9:	55                   	push   %ebp
     1da:	89 e5                	mov    %esp,%ebp
     1dc:	57                   	push   %edi
     1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
     1e1:	8b 55 10             	mov    0x10(%ebp),%edx
     1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
     1e7:	89 cb                	mov    %ecx,%ebx
     1e9:	89 df                	mov    %ebx,%edi
     1eb:	89 d1                	mov    %edx,%ecx
     1ed:	fc                   	cld    
     1ee:	f3 aa                	rep stos %al,%es:(%edi)
     1f0:	89 ca                	mov    %ecx,%edx
     1f2:	89 fb                	mov    %edi,%ebx
     1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     1fa:	5b                   	pop    %ebx
     1fb:	5f                   	pop    %edi
     1fc:	5d                   	pop    %ebp
     1fd:	c3                   	ret    

000001fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     1fe:	55                   	push   %ebp
     1ff:	89 e5                	mov    %esp,%ebp
     201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     204:	8b 45 08             	mov    0x8(%ebp),%eax
     207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     20a:	90                   	nop
     20b:	8b 45 08             	mov    0x8(%ebp),%eax
     20e:	8d 50 01             	lea    0x1(%eax),%edx
     211:	89 55 08             	mov    %edx,0x8(%ebp)
     214:	8b 55 0c             	mov    0xc(%ebp),%edx
     217:	8d 4a 01             	lea    0x1(%edx),%ecx
     21a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     21d:	0f b6 12             	movzbl (%edx),%edx
     220:	88 10                	mov    %dl,(%eax)
     222:	0f b6 00             	movzbl (%eax),%eax
     225:	84 c0                	test   %al,%al
     227:	75 e2                	jne    20b <strcpy+0xd>
    ;
  return os;
     229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     22c:	c9                   	leave  
     22d:	c3                   	ret    

0000022e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     22e:	55                   	push   %ebp
     22f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     231:	eb 08                	jmp    23b <strcmp+0xd>
    p++, q++;
     233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     23b:	8b 45 08             	mov    0x8(%ebp),%eax
     23e:	0f b6 00             	movzbl (%eax),%eax
     241:	84 c0                	test   %al,%al
     243:	74 10                	je     255 <strcmp+0x27>
     245:	8b 45 08             	mov    0x8(%ebp),%eax
     248:	0f b6 10             	movzbl (%eax),%edx
     24b:	8b 45 0c             	mov    0xc(%ebp),%eax
     24e:	0f b6 00             	movzbl (%eax),%eax
     251:	38 c2                	cmp    %al,%dl
     253:	74 de                	je     233 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     255:	8b 45 08             	mov    0x8(%ebp),%eax
     258:	0f b6 00             	movzbl (%eax),%eax
     25b:	0f b6 d0             	movzbl %al,%edx
     25e:	8b 45 0c             	mov    0xc(%ebp),%eax
     261:	0f b6 00             	movzbl (%eax),%eax
     264:	0f b6 c0             	movzbl %al,%eax
     267:	29 c2                	sub    %eax,%edx
     269:	89 d0                	mov    %edx,%eax
}
     26b:	5d                   	pop    %ebp
     26c:	c3                   	ret    

0000026d <strlen>:

uint
strlen(char *s)
{
     26d:	55                   	push   %ebp
     26e:	89 e5                	mov    %esp,%ebp
     270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     27a:	eb 04                	jmp    280 <strlen+0x13>
     27c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     280:	8b 55 fc             	mov    -0x4(%ebp),%edx
     283:	8b 45 08             	mov    0x8(%ebp),%eax
     286:	01 d0                	add    %edx,%eax
     288:	0f b6 00             	movzbl (%eax),%eax
     28b:	84 c0                	test   %al,%al
     28d:	75 ed                	jne    27c <strlen+0xf>
    ;
  return n;
     28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     292:	c9                   	leave  
     293:	c3                   	ret    

00000294 <memset>:

void*
memset(void *dst, int c, uint n)
{
     294:	55                   	push   %ebp
     295:	89 e5                	mov    %esp,%ebp
     297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     29a:	8b 45 10             	mov    0x10(%ebp),%eax
     29d:	89 44 24 08          	mov    %eax,0x8(%esp)
     2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
     2a4:	89 44 24 04          	mov    %eax,0x4(%esp)
     2a8:	8b 45 08             	mov    0x8(%ebp),%eax
     2ab:	89 04 24             	mov    %eax,(%esp)
     2ae:	e8 26 ff ff ff       	call   1d9 <stosb>
  return dst;
     2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
     2b6:	c9                   	leave  
     2b7:	c3                   	ret    

000002b8 <strchr>:

char*
strchr(const char *s, char c)
{
     2b8:	55                   	push   %ebp
     2b9:	89 e5                	mov    %esp,%ebp
     2bb:	83 ec 04             	sub    $0x4,%esp
     2be:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     2c4:	eb 14                	jmp    2da <strchr+0x22>
    if(*s == c)
     2c6:	8b 45 08             	mov    0x8(%ebp),%eax
     2c9:	0f b6 00             	movzbl (%eax),%eax
     2cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
     2cf:	75 05                	jne    2d6 <strchr+0x1e>
      return (char*)s;
     2d1:	8b 45 08             	mov    0x8(%ebp),%eax
     2d4:	eb 13                	jmp    2e9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     2d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2da:	8b 45 08             	mov    0x8(%ebp),%eax
     2dd:	0f b6 00             	movzbl (%eax),%eax
     2e0:	84 c0                	test   %al,%al
     2e2:	75 e2                	jne    2c6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     2e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2e9:	c9                   	leave  
     2ea:	c3                   	ret    

000002eb <gets>:

char*
gets(char *buf, int max)
{
     2eb:	55                   	push   %ebp
     2ec:	89 e5                	mov    %esp,%ebp
     2ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     2f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     2f8:	eb 4c                	jmp    346 <gets+0x5b>
    cc = read(0, &c, 1);
     2fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     301:	00 
     302:	8d 45 ef             	lea    -0x11(%ebp),%eax
     305:	89 44 24 04          	mov    %eax,0x4(%esp)
     309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     310:	e8 44 01 00 00       	call   459 <read>
     315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     31c:	7f 02                	jg     320 <gets+0x35>
      break;
     31e:	eb 31                	jmp    351 <gets+0x66>
    buf[i++] = c;
     320:	8b 45 f4             	mov    -0xc(%ebp),%eax
     323:	8d 50 01             	lea    0x1(%eax),%edx
     326:	89 55 f4             	mov    %edx,-0xc(%ebp)
     329:	89 c2                	mov    %eax,%edx
     32b:	8b 45 08             	mov    0x8(%ebp),%eax
     32e:	01 c2                	add    %eax,%edx
     330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     33a:	3c 0a                	cmp    $0xa,%al
     33c:	74 13                	je     351 <gets+0x66>
     33e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     342:	3c 0d                	cmp    $0xd,%al
     344:	74 0b                	je     351 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     346:	8b 45 f4             	mov    -0xc(%ebp),%eax
     349:	83 c0 01             	add    $0x1,%eax
     34c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     34f:	7c a9                	jl     2fa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     351:	8b 55 f4             	mov    -0xc(%ebp),%edx
     354:	8b 45 08             	mov    0x8(%ebp),%eax
     357:	01 d0                	add    %edx,%eax
     359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     35f:	c9                   	leave  
     360:	c3                   	ret    

00000361 <stat>:

int
stat(char *n, struct stat *st)
{
     361:	55                   	push   %ebp
     362:	89 e5                	mov    %esp,%ebp
     364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     36e:	00 
     36f:	8b 45 08             	mov    0x8(%ebp),%eax
     372:	89 04 24             	mov    %eax,(%esp)
     375:	e8 07 01 00 00       	call   481 <open>
     37a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     37d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     381:	79 07                	jns    38a <stat+0x29>
    return -1;
     383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     388:	eb 23                	jmp    3ad <stat+0x4c>
  r = fstat(fd, st);
     38a:	8b 45 0c             	mov    0xc(%ebp),%eax
     38d:	89 44 24 04          	mov    %eax,0x4(%esp)
     391:	8b 45 f4             	mov    -0xc(%ebp),%eax
     394:	89 04 24             	mov    %eax,(%esp)
     397:	e8 fd 00 00 00       	call   499 <fstat>
     39c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3a2:	89 04 24             	mov    %eax,(%esp)
     3a5:	e8 bf 00 00 00       	call   469 <close>
  return r;
     3aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     3ad:	c9                   	leave  
     3ae:	c3                   	ret    

000003af <atoi>:

int
atoi(const char *s)
{
     3af:	55                   	push   %ebp
     3b0:	89 e5                	mov    %esp,%ebp
     3b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     3b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     3bc:	eb 25                	jmp    3e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
     3be:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3c1:	89 d0                	mov    %edx,%eax
     3c3:	c1 e0 02             	shl    $0x2,%eax
     3c6:	01 d0                	add    %edx,%eax
     3c8:	01 c0                	add    %eax,%eax
     3ca:	89 c1                	mov    %eax,%ecx
     3cc:	8b 45 08             	mov    0x8(%ebp),%eax
     3cf:	8d 50 01             	lea    0x1(%eax),%edx
     3d2:	89 55 08             	mov    %edx,0x8(%ebp)
     3d5:	0f b6 00             	movzbl (%eax),%eax
     3d8:	0f be c0             	movsbl %al,%eax
     3db:	01 c8                	add    %ecx,%eax
     3dd:	83 e8 30             	sub    $0x30,%eax
     3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     3e3:	8b 45 08             	mov    0x8(%ebp),%eax
     3e6:	0f b6 00             	movzbl (%eax),%eax
     3e9:	3c 2f                	cmp    $0x2f,%al
     3eb:	7e 0a                	jle    3f7 <atoi+0x48>
     3ed:	8b 45 08             	mov    0x8(%ebp),%eax
     3f0:	0f b6 00             	movzbl (%eax),%eax
     3f3:	3c 39                	cmp    $0x39,%al
     3f5:	7e c7                	jle    3be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3fa:	c9                   	leave  
     3fb:	c3                   	ret    

000003fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     3fc:	55                   	push   %ebp
     3fd:	89 e5                	mov    %esp,%ebp
     3ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     402:	8b 45 08             	mov    0x8(%ebp),%eax
     405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     408:	8b 45 0c             	mov    0xc(%ebp),%eax
     40b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     40e:	eb 17                	jmp    427 <memmove+0x2b>
    *dst++ = *src++;
     410:	8b 45 fc             	mov    -0x4(%ebp),%eax
     413:	8d 50 01             	lea    0x1(%eax),%edx
     416:	89 55 fc             	mov    %edx,-0x4(%ebp)
     419:	8b 55 f8             	mov    -0x8(%ebp),%edx
     41c:	8d 4a 01             	lea    0x1(%edx),%ecx
     41f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     422:	0f b6 12             	movzbl (%edx),%edx
     425:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     427:	8b 45 10             	mov    0x10(%ebp),%eax
     42a:	8d 50 ff             	lea    -0x1(%eax),%edx
     42d:	89 55 10             	mov    %edx,0x10(%ebp)
     430:	85 c0                	test   %eax,%eax
     432:	7f dc                	jg     410 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     434:	8b 45 08             	mov    0x8(%ebp),%eax
}
     437:	c9                   	leave  
     438:	c3                   	ret    

00000439 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     439:	b8 01 00 00 00       	mov    $0x1,%eax
     43e:	cd 40                	int    $0x40
     440:	c3                   	ret    

00000441 <exit>:
SYSCALL(exit)
     441:	b8 02 00 00 00       	mov    $0x2,%eax
     446:	cd 40                	int    $0x40
     448:	c3                   	ret    

00000449 <wait>:
SYSCALL(wait)
     449:	b8 03 00 00 00       	mov    $0x3,%eax
     44e:	cd 40                	int    $0x40
     450:	c3                   	ret    

00000451 <pipe>:
SYSCALL(pipe)
     451:	b8 04 00 00 00       	mov    $0x4,%eax
     456:	cd 40                	int    $0x40
     458:	c3                   	ret    

00000459 <read>:
SYSCALL(read)
     459:	b8 05 00 00 00       	mov    $0x5,%eax
     45e:	cd 40                	int    $0x40
     460:	c3                   	ret    

00000461 <write>:
SYSCALL(write)
     461:	b8 10 00 00 00       	mov    $0x10,%eax
     466:	cd 40                	int    $0x40
     468:	c3                   	ret    

00000469 <close>:
SYSCALL(close)
     469:	b8 15 00 00 00       	mov    $0x15,%eax
     46e:	cd 40                	int    $0x40
     470:	c3                   	ret    

00000471 <kill>:
SYSCALL(kill)
     471:	b8 06 00 00 00       	mov    $0x6,%eax
     476:	cd 40                	int    $0x40
     478:	c3                   	ret    

00000479 <exec>:
SYSCALL(exec)
     479:	b8 07 00 00 00       	mov    $0x7,%eax
     47e:	cd 40                	int    $0x40
     480:	c3                   	ret    

00000481 <open>:
SYSCALL(open)
     481:	b8 0f 00 00 00       	mov    $0xf,%eax
     486:	cd 40                	int    $0x40
     488:	c3                   	ret    

00000489 <mknod>:
SYSCALL(mknod)
     489:	b8 11 00 00 00       	mov    $0x11,%eax
     48e:	cd 40                	int    $0x40
     490:	c3                   	ret    

00000491 <unlink>:
SYSCALL(unlink)
     491:	b8 12 00 00 00       	mov    $0x12,%eax
     496:	cd 40                	int    $0x40
     498:	c3                   	ret    

00000499 <fstat>:
SYSCALL(fstat)
     499:	b8 08 00 00 00       	mov    $0x8,%eax
     49e:	cd 40                	int    $0x40
     4a0:	c3                   	ret    

000004a1 <link>:
SYSCALL(link)
     4a1:	b8 13 00 00 00       	mov    $0x13,%eax
     4a6:	cd 40                	int    $0x40
     4a8:	c3                   	ret    

000004a9 <mkdir>:
SYSCALL(mkdir)
     4a9:	b8 14 00 00 00       	mov    $0x14,%eax
     4ae:	cd 40                	int    $0x40
     4b0:	c3                   	ret    

000004b1 <chdir>:
SYSCALL(chdir)
     4b1:	b8 09 00 00 00       	mov    $0x9,%eax
     4b6:	cd 40                	int    $0x40
     4b8:	c3                   	ret    

000004b9 <dup>:
SYSCALL(dup)
     4b9:	b8 0a 00 00 00       	mov    $0xa,%eax
     4be:	cd 40                	int    $0x40
     4c0:	c3                   	ret    

000004c1 <getpid>:
SYSCALL(getpid)
     4c1:	b8 0b 00 00 00       	mov    $0xb,%eax
     4c6:	cd 40                	int    $0x40
     4c8:	c3                   	ret    

000004c9 <sbrk>:
SYSCALL(sbrk)
     4c9:	b8 0c 00 00 00       	mov    $0xc,%eax
     4ce:	cd 40                	int    $0x40
     4d0:	c3                   	ret    

000004d1 <sleep>:
SYSCALL(sleep)
     4d1:	b8 0d 00 00 00       	mov    $0xd,%eax
     4d6:	cd 40                	int    $0x40
     4d8:	c3                   	ret    

000004d9 <uptime>:
SYSCALL(uptime)
     4d9:	b8 0e 00 00 00       	mov    $0xe,%eax
     4de:	cd 40                	int    $0x40
     4e0:	c3                   	ret    

000004e1 <kthread_create>:




SYSCALL(kthread_create)
     4e1:	b8 16 00 00 00       	mov    $0x16,%eax
     4e6:	cd 40                	int    $0x40
     4e8:	c3                   	ret    

000004e9 <kthread_id>:
SYSCALL(kthread_id)
     4e9:	b8 17 00 00 00       	mov    $0x17,%eax
     4ee:	cd 40                	int    $0x40
     4f0:	c3                   	ret    

000004f1 <kthread_exit>:
SYSCALL(kthread_exit)
     4f1:	b8 18 00 00 00       	mov    $0x18,%eax
     4f6:	cd 40                	int    $0x40
     4f8:	c3                   	ret    

000004f9 <kthread_join>:
SYSCALL(kthread_join)
     4f9:	b8 19 00 00 00       	mov    $0x19,%eax
     4fe:	cd 40                	int    $0x40
     500:	c3                   	ret    

00000501 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     501:	b8 1a 00 00 00       	mov    $0x1a,%eax
     506:	cd 40                	int    $0x40
     508:	c3                   	ret    

00000509 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     509:	b8 1b 00 00 00       	mov    $0x1b,%eax
     50e:	cd 40                	int    $0x40
     510:	c3                   	ret    

00000511 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     511:	b8 1c 00 00 00       	mov    $0x1c,%eax
     516:	cd 40                	int    $0x40
     518:	c3                   	ret    

00000519 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     519:	b8 1d 00 00 00       	mov    $0x1d,%eax
     51e:	cd 40                	int    $0x40
     520:	c3                   	ret    

00000521 <kthread_mutex_yieldlock>:
     521:	b8 1e 00 00 00       	mov    $0x1e,%eax
     526:	cd 40                	int    $0x40
     528:	c3                   	ret    

00000529 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     529:	55                   	push   %ebp
     52a:	89 e5                	mov    %esp,%ebp
     52c:	83 ec 18             	sub    $0x18,%esp
     52f:	8b 45 0c             	mov    0xc(%ebp),%eax
     532:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     535:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     53c:	00 
     53d:	8d 45 f4             	lea    -0xc(%ebp),%eax
     540:	89 44 24 04          	mov    %eax,0x4(%esp)
     544:	8b 45 08             	mov    0x8(%ebp),%eax
     547:	89 04 24             	mov    %eax,(%esp)
     54a:	e8 12 ff ff ff       	call   461 <write>
}
     54f:	c9                   	leave  
     550:	c3                   	ret    

00000551 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     551:	55                   	push   %ebp
     552:	89 e5                	mov    %esp,%ebp
     554:	56                   	push   %esi
     555:	53                   	push   %ebx
     556:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     559:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     560:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     564:	74 17                	je     57d <printint+0x2c>
     566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     56a:	79 11                	jns    57d <printint+0x2c>
    neg = 1;
     56c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     573:	8b 45 0c             	mov    0xc(%ebp),%eax
     576:	f7 d8                	neg    %eax
     578:	89 45 ec             	mov    %eax,-0x14(%ebp)
     57b:	eb 06                	jmp    583 <printint+0x32>
  } else {
    x = xx;
     57d:	8b 45 0c             	mov    0xc(%ebp),%eax
     580:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     58a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     58d:	8d 41 01             	lea    0x1(%ecx),%eax
     590:	89 45 f4             	mov    %eax,-0xc(%ebp)
     593:	8b 5d 10             	mov    0x10(%ebp),%ebx
     596:	8b 45 ec             	mov    -0x14(%ebp),%eax
     599:	ba 00 00 00 00       	mov    $0x0,%edx
     59e:	f7 f3                	div    %ebx
     5a0:	89 d0                	mov    %edx,%eax
     5a2:	0f b6 80 88 16 00 00 	movzbl 0x1688(%eax),%eax
     5a9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     5ad:	8b 75 10             	mov    0x10(%ebp),%esi
     5b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5b3:	ba 00 00 00 00       	mov    $0x0,%edx
     5b8:	f7 f6                	div    %esi
     5ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
     5bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5c1:	75 c7                	jne    58a <printint+0x39>
  if(neg)
     5c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     5c7:	74 10                	je     5d9 <printint+0x88>
    buf[i++] = '-';
     5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cc:	8d 50 01             	lea    0x1(%eax),%edx
     5cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
     5d2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     5d7:	eb 1f                	jmp    5f8 <printint+0xa7>
     5d9:	eb 1d                	jmp    5f8 <printint+0xa7>
    putc(fd, buf[i]);
     5db:	8d 55 dc             	lea    -0x24(%ebp),%edx
     5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e1:	01 d0                	add    %edx,%eax
     5e3:	0f b6 00             	movzbl (%eax),%eax
     5e6:	0f be c0             	movsbl %al,%eax
     5e9:	89 44 24 04          	mov    %eax,0x4(%esp)
     5ed:	8b 45 08             	mov    0x8(%ebp),%eax
     5f0:	89 04 24             	mov    %eax,(%esp)
     5f3:	e8 31 ff ff ff       	call   529 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     5f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     5fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     600:	79 d9                	jns    5db <printint+0x8a>
    putc(fd, buf[i]);
}
     602:	83 c4 30             	add    $0x30,%esp
     605:	5b                   	pop    %ebx
     606:	5e                   	pop    %esi
     607:	5d                   	pop    %ebp
     608:	c3                   	ret    

00000609 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     609:	55                   	push   %ebp
     60a:	89 e5                	mov    %esp,%ebp
     60c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     616:	8d 45 0c             	lea    0xc(%ebp),%eax
     619:	83 c0 04             	add    $0x4,%eax
     61c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     626:	e9 7c 01 00 00       	jmp    7a7 <printf+0x19e>
    c = fmt[i] & 0xff;
     62b:	8b 55 0c             	mov    0xc(%ebp),%edx
     62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     631:	01 d0                	add    %edx,%eax
     633:	0f b6 00             	movzbl (%eax),%eax
     636:	0f be c0             	movsbl %al,%eax
     639:	25 ff 00 00 00       	and    $0xff,%eax
     63e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     645:	75 2c                	jne    673 <printf+0x6a>
      if(c == '%'){
     647:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     64b:	75 0c                	jne    659 <printf+0x50>
        state = '%';
     64d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     654:	e9 4a 01 00 00       	jmp    7a3 <printf+0x19a>
      } else {
        putc(fd, c);
     659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     65c:	0f be c0             	movsbl %al,%eax
     65f:	89 44 24 04          	mov    %eax,0x4(%esp)
     663:	8b 45 08             	mov    0x8(%ebp),%eax
     666:	89 04 24             	mov    %eax,(%esp)
     669:	e8 bb fe ff ff       	call   529 <putc>
     66e:	e9 30 01 00 00       	jmp    7a3 <printf+0x19a>
      }
    } else if(state == '%'){
     673:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     677:	0f 85 26 01 00 00    	jne    7a3 <printf+0x19a>
      if(c == 'd'){
     67d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     681:	75 2d                	jne    6b0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     683:	8b 45 e8             	mov    -0x18(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     68f:	00 
     690:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     697:	00 
     698:	89 44 24 04          	mov    %eax,0x4(%esp)
     69c:	8b 45 08             	mov    0x8(%ebp),%eax
     69f:	89 04 24             	mov    %eax,(%esp)
     6a2:	e8 aa fe ff ff       	call   551 <printint>
        ap++;
     6a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     6ab:	e9 ec 00 00 00       	jmp    79c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     6b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     6b4:	74 06                	je     6bc <printf+0xb3>
     6b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     6ba:	75 2d                	jne    6e9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     6bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6bf:	8b 00                	mov    (%eax),%eax
     6c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6c8:	00 
     6c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     6d0:	00 
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 08             	mov    0x8(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 71 fe ff ff       	call   551 <printint>
        ap++;
     6e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     6e4:	e9 b3 00 00 00       	jmp    79c <printf+0x193>
      } else if(c == 's'){
     6e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     6ed:	75 45                	jne    734 <printf+0x12b>
        s = (char*)*ap;
     6ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6f2:	8b 00                	mov    (%eax),%eax
     6f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     6f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     6fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6ff:	75 09                	jne    70a <printf+0x101>
          s = "(null)";
     701:	c7 45 f4 db 11 00 00 	movl   $0x11db,-0xc(%ebp)
        while(*s != 0){
     708:	eb 1e                	jmp    728 <printf+0x11f>
     70a:	eb 1c                	jmp    728 <printf+0x11f>
          putc(fd, *s);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	0f b6 00             	movzbl (%eax),%eax
     712:	0f be c0             	movsbl %al,%eax
     715:	89 44 24 04          	mov    %eax,0x4(%esp)
     719:	8b 45 08             	mov    0x8(%ebp),%eax
     71c:	89 04 24             	mov    %eax,(%esp)
     71f:	e8 05 fe ff ff       	call   529 <putc>
          s++;
     724:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     728:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72b:	0f b6 00             	movzbl (%eax),%eax
     72e:	84 c0                	test   %al,%al
     730:	75 da                	jne    70c <printf+0x103>
     732:	eb 68                	jmp    79c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     734:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     738:	75 1d                	jne    757 <printf+0x14e>
        putc(fd, *ap);
     73a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     73d:	8b 00                	mov    (%eax),%eax
     73f:	0f be c0             	movsbl %al,%eax
     742:	89 44 24 04          	mov    %eax,0x4(%esp)
     746:	8b 45 08             	mov    0x8(%ebp),%eax
     749:	89 04 24             	mov    %eax,(%esp)
     74c:	e8 d8 fd ff ff       	call   529 <putc>
        ap++;
     751:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     755:	eb 45                	jmp    79c <printf+0x193>
      } else if(c == '%'){
     757:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     75b:	75 17                	jne    774 <printf+0x16b>
        putc(fd, c);
     75d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     760:	0f be c0             	movsbl %al,%eax
     763:	89 44 24 04          	mov    %eax,0x4(%esp)
     767:	8b 45 08             	mov    0x8(%ebp),%eax
     76a:	89 04 24             	mov    %eax,(%esp)
     76d:	e8 b7 fd ff ff       	call   529 <putc>
     772:	eb 28                	jmp    79c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     774:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     77b:	00 
     77c:	8b 45 08             	mov    0x8(%ebp),%eax
     77f:	89 04 24             	mov    %eax,(%esp)
     782:	e8 a2 fd ff ff       	call   529 <putc>
        putc(fd, c);
     787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     78a:	0f be c0             	movsbl %al,%eax
     78d:	89 44 24 04          	mov    %eax,0x4(%esp)
     791:	8b 45 08             	mov    0x8(%ebp),%eax
     794:	89 04 24             	mov    %eax,(%esp)
     797:	e8 8d fd ff ff       	call   529 <putc>
      }
      state = 0;
     79c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     7a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     7a7:	8b 55 0c             	mov    0xc(%ebp),%edx
     7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7ad:	01 d0                	add    %edx,%eax
     7af:	0f b6 00             	movzbl (%eax),%eax
     7b2:	84 c0                	test   %al,%al
     7b4:	0f 85 71 fe ff ff    	jne    62b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     7ba:	c9                   	leave  
     7bb:	c3                   	ret    

000007bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     7bc:	55                   	push   %ebp
     7bd:	89 e5                	mov    %esp,%ebp
     7bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     7c2:	8b 45 08             	mov    0x8(%ebp),%eax
     7c5:	83 e8 08             	sub    $0x8,%eax
     7c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7cb:	a1 a8 16 00 00       	mov    0x16a8,%eax
     7d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7d3:	eb 24                	jmp    7f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7d8:	8b 00                	mov    (%eax),%eax
     7da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7dd:	77 12                	ja     7f1 <free+0x35>
     7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7e5:	77 24                	ja     80b <free+0x4f>
     7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7ea:	8b 00                	mov    (%eax),%eax
     7ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     7ef:	77 1a                	ja     80b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     7f4:	8b 00                	mov    (%eax),%eax
     7f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     7fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     7ff:	76 d4                	jbe    7d5 <free+0x19>
     801:	8b 45 fc             	mov    -0x4(%ebp),%eax
     804:	8b 00                	mov    (%eax),%eax
     806:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     809:	76 ca                	jbe    7d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     80e:	8b 40 04             	mov    0x4(%eax),%eax
     811:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     818:	8b 45 f8             	mov    -0x8(%ebp),%eax
     81b:	01 c2                	add    %eax,%edx
     81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     820:	8b 00                	mov    (%eax),%eax
     822:	39 c2                	cmp    %eax,%edx
     824:	75 24                	jne    84a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     826:	8b 45 f8             	mov    -0x8(%ebp),%eax
     829:	8b 50 04             	mov    0x4(%eax),%edx
     82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     82f:	8b 00                	mov    (%eax),%eax
     831:	8b 40 04             	mov    0x4(%eax),%eax
     834:	01 c2                	add    %eax,%edx
     836:	8b 45 f8             	mov    -0x8(%ebp),%eax
     839:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     83f:	8b 00                	mov    (%eax),%eax
     841:	8b 10                	mov    (%eax),%edx
     843:	8b 45 f8             	mov    -0x8(%ebp),%eax
     846:	89 10                	mov    %edx,(%eax)
     848:	eb 0a                	jmp    854 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     84d:	8b 10                	mov    (%eax),%edx
     84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     852:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     854:	8b 45 fc             	mov    -0x4(%ebp),%eax
     857:	8b 40 04             	mov    0x4(%eax),%eax
     85a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     861:	8b 45 fc             	mov    -0x4(%ebp),%eax
     864:	01 d0                	add    %edx,%eax
     866:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     869:	75 20                	jne    88b <free+0xcf>
    p->s.size += bp->s.size;
     86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     86e:	8b 50 04             	mov    0x4(%eax),%edx
     871:	8b 45 f8             	mov    -0x8(%ebp),%eax
     874:	8b 40 04             	mov    0x4(%eax),%eax
     877:	01 c2                	add    %eax,%edx
     879:	8b 45 fc             	mov    -0x4(%ebp),%eax
     87c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     87f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     882:	8b 10                	mov    (%eax),%edx
     884:	8b 45 fc             	mov    -0x4(%ebp),%eax
     887:	89 10                	mov    %edx,(%eax)
     889:	eb 08                	jmp    893 <free+0xd7>
  } else
    p->s.ptr = bp;
     88b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     88e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     891:	89 10                	mov    %edx,(%eax)
  freep = p;
     893:	8b 45 fc             	mov    -0x4(%ebp),%eax
     896:	a3 a8 16 00 00       	mov    %eax,0x16a8
}
     89b:	c9                   	leave  
     89c:	c3                   	ret    

0000089d <morecore>:

static Header*
morecore(uint nu)
{
     89d:	55                   	push   %ebp
     89e:	89 e5                	mov    %esp,%ebp
     8a0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     8a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     8aa:	77 07                	ja     8b3 <morecore+0x16>
    nu = 4096;
     8ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     8b3:	8b 45 08             	mov    0x8(%ebp),%eax
     8b6:	c1 e0 03             	shl    $0x3,%eax
     8b9:	89 04 24             	mov    %eax,(%esp)
     8bc:	e8 08 fc ff ff       	call   4c9 <sbrk>
     8c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     8c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     8c8:	75 07                	jne    8d1 <morecore+0x34>
    return 0;
     8ca:	b8 00 00 00 00       	mov    $0x0,%eax
     8cf:	eb 22                	jmp    8f3 <morecore+0x56>
  hp = (Header*)p;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     8d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8da:	8b 55 08             	mov    0x8(%ebp),%edx
     8dd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8e3:	83 c0 08             	add    $0x8,%eax
     8e6:	89 04 24             	mov    %eax,(%esp)
     8e9:	e8 ce fe ff ff       	call   7bc <free>
  return freep;
     8ee:	a1 a8 16 00 00       	mov    0x16a8,%eax
}
     8f3:	c9                   	leave  
     8f4:	c3                   	ret    

000008f5 <malloc>:

void*
malloc(uint nbytes)
{
     8f5:	55                   	push   %ebp
     8f6:	89 e5                	mov    %esp,%ebp
     8f8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     8fb:	8b 45 08             	mov    0x8(%ebp),%eax
     8fe:	83 c0 07             	add    $0x7,%eax
     901:	c1 e8 03             	shr    $0x3,%eax
     904:	83 c0 01             	add    $0x1,%eax
     907:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     90a:	a1 a8 16 00 00       	mov    0x16a8,%eax
     90f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     912:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     916:	75 23                	jne    93b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     918:	c7 45 f0 a0 16 00 00 	movl   $0x16a0,-0x10(%ebp)
     91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     922:	a3 a8 16 00 00       	mov    %eax,0x16a8
     927:	a1 a8 16 00 00       	mov    0x16a8,%eax
     92c:	a3 a0 16 00 00       	mov    %eax,0x16a0
    base.s.size = 0;
     931:	c7 05 a4 16 00 00 00 	movl   $0x0,0x16a4
     938:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     93b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     93e:	8b 00                	mov    (%eax),%eax
     940:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     943:	8b 45 f4             	mov    -0xc(%ebp),%eax
     946:	8b 40 04             	mov    0x4(%eax),%eax
     949:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     94c:	72 4d                	jb     99b <malloc+0xa6>
      if(p->s.size == nunits)
     94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     951:	8b 40 04             	mov    0x4(%eax),%eax
     954:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     957:	75 0c                	jne    965 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     959:	8b 45 f4             	mov    -0xc(%ebp),%eax
     95c:	8b 10                	mov    (%eax),%edx
     95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     961:	89 10                	mov    %edx,(%eax)
     963:	eb 26                	jmp    98b <malloc+0x96>
      else {
        p->s.size -= nunits;
     965:	8b 45 f4             	mov    -0xc(%ebp),%eax
     968:	8b 40 04             	mov    0x4(%eax),%eax
     96b:	2b 45 ec             	sub    -0x14(%ebp),%eax
     96e:	89 c2                	mov    %eax,%edx
     970:	8b 45 f4             	mov    -0xc(%ebp),%eax
     973:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     976:	8b 45 f4             	mov    -0xc(%ebp),%eax
     979:	8b 40 04             	mov    0x4(%eax),%eax
     97c:	c1 e0 03             	shl    $0x3,%eax
     97f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     982:	8b 45 f4             	mov    -0xc(%ebp),%eax
     985:	8b 55 ec             	mov    -0x14(%ebp),%edx
     988:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     98e:	a3 a8 16 00 00       	mov    %eax,0x16a8
      return (void*)(p + 1);
     993:	8b 45 f4             	mov    -0xc(%ebp),%eax
     996:	83 c0 08             	add    $0x8,%eax
     999:	eb 38                	jmp    9d3 <malloc+0xde>
    }
    if(p == freep)
     99b:	a1 a8 16 00 00       	mov    0x16a8,%eax
     9a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9a3:	75 1b                	jne    9c0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     9a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9a8:	89 04 24             	mov    %eax,(%esp)
     9ab:	e8 ed fe ff ff       	call   89d <morecore>
     9b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     9b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     9b7:	75 07                	jne    9c0 <malloc+0xcb>
        return 0;
     9b9:	b8 00 00 00 00       	mov    $0x0,%eax
     9be:	eb 13                	jmp    9d3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c9:	8b 00                	mov    (%eax),%eax
     9cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     9ce:	e9 70 ff ff ff       	jmp    943 <malloc+0x4e>
}
     9d3:	c9                   	leave  
     9d4:	c3                   	ret    

000009d5 <mesa_slots_monitor_alloc>:
#include "user.h"




mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     9d5:	55                   	push   %ebp
     9d6:	89 e5                	mov    %esp,%ebp
     9d8:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     9db:	e8 21 fb ff ff       	call   501 <kthread_mutex_alloc>
     9e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0){
     9e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     9e7:	79 0a                	jns    9f3 <mesa_slots_monitor_alloc+0x1e>

		return 0;
     9e9:	b8 00 00 00 00       	mov    $0x0,%eax
     9ee:	e9 8b 00 00 00       	jmp    a7e <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * empty = mesa_cond_alloc();
     9f3:	e8 44 06 00 00       	call   103c <mesa_cond_alloc>
     9f8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     9fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9ff:	75 12                	jne    a13 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a04:	89 04 24             	mov    %eax,(%esp)
     a07:	e8 fd fa ff ff       	call   509 <kthread_mutex_dealloc>
		return 0;
     a0c:	b8 00 00 00 00       	mov    $0x0,%eax
     a11:	eb 6b                	jmp    a7e <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     a13:	e8 24 06 00 00       	call   103c <mesa_cond_alloc>
     a18:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     a1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     a1f:	75 1d                	jne    a3e <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a24:	89 04 24             	mov    %eax,(%esp)
     a27:	e8 dd fa ff ff       	call   509 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2f:	89 04 24             	mov    %eax,(%esp)
     a32:	e8 46 06 00 00       	call   107d <mesa_cond_dealloc>
		return 0;
     a37:	b8 00 00 00 00       	mov    $0x0,%eax
     a3c:	eb 40                	jmp    a7e <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     a3e:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     a45:	e8 ab fe ff ff       	call   8f5 <malloc>
     a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a53:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a59:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a5c:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a65:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a74:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     a7e:	c9                   	leave  
     a7f:	c3                   	ret    

00000a80 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     a80:	55                   	push   %ebp
     a81:	89 e5                	mov    %esp,%ebp
     a83:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     a86:	8b 45 08             	mov    0x8(%ebp),%eax
     a89:	8b 00                	mov    (%eax),%eax
     a8b:	89 04 24             	mov    %eax,(%esp)
     a8e:	e8 76 fa ff ff       	call   509 <kthread_mutex_dealloc>
     a93:	85 c0                	test   %eax,%eax
     a95:	78 2e                	js     ac5 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     a97:	8b 45 08             	mov    0x8(%ebp),%eax
     a9a:	8b 40 04             	mov    0x4(%eax),%eax
     a9d:	89 04 24             	mov    %eax,(%esp)
     aa0:	e8 97 05 00 00       	call   103c <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     aa5:	8b 45 08             	mov    0x8(%ebp),%eax
     aa8:	8b 40 08             	mov    0x8(%eax),%eax
     aab:	89 04 24             	mov    %eax,(%esp)
     aae:	e8 89 05 00 00       	call   103c <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     ab3:	8b 45 08             	mov    0x8(%ebp),%eax
     ab6:	89 04 24             	mov    %eax,(%esp)
     ab9:	e8 fe fc ff ff       	call   7bc <free>
	return 0;
     abe:	b8 00 00 00 00       	mov    $0x0,%eax
     ac3:	eb 05                	jmp    aca <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     aca:	c9                   	leave  
     acb:	c3                   	ret    

00000acc <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     acc:	55                   	push   %ebp
     acd:	89 e5                	mov    %esp,%ebp
     acf:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     ad2:	8b 45 08             	mov    0x8(%ebp),%eax
     ad5:	8b 40 10             	mov    0x10(%eax),%eax
     ad8:	85 c0                	test   %eax,%eax
     ada:	75 0a                	jne    ae6 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ae1:	e9 81 00 00 00       	jmp    b67 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ae6:	8b 45 08             	mov    0x8(%ebp),%eax
     ae9:	8b 00                	mov    (%eax),%eax
     aeb:	89 04 24             	mov    %eax,(%esp)
     aee:	e8 1e fa ff ff       	call   511 <kthread_mutex_lock>
     af3:	83 f8 ff             	cmp    $0xffffffff,%eax
     af6:	7d 07                	jge    aff <mesa_slots_monitor_addslots+0x33>
		return -1;
     af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     afd:	eb 68                	jmp    b67 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     aff:	eb 17                	jmp    b18 <mesa_slots_monitor_addslots+0x4c>
	{
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
     b01:	8b 45 08             	mov    0x8(%ebp),%eax
     b04:	8b 10                	mov    (%eax),%edx
     b06:	8b 45 08             	mov    0x8(%ebp),%eax
     b09:	8b 40 08             	mov    0x8(%eax),%eax
     b0c:	89 54 24 04          	mov    %edx,0x4(%esp)
     b10:	89 04 24             	mov    %eax,(%esp)
     b13:	e8 af 05 00 00       	call   10c7 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     b18:	8b 45 08             	mov    0x8(%ebp),%eax
     b1b:	8b 40 10             	mov    0x10(%eax),%eax
     b1e:	85 c0                	test   %eax,%eax
     b20:	74 0a                	je     b2c <mesa_slots_monitor_addslots+0x60>
     b22:	8b 45 08             	mov    0x8(%ebp),%eax
     b25:	8b 40 0c             	mov    0xc(%eax),%eax
     b28:	85 c0                	test   %eax,%eax
     b2a:	7f d5                	jg     b01 <mesa_slots_monitor_addslots+0x35>
		//printf(1,"grader is sleeping  %d\n ", monitor->active);
				mesa_cond_wait( monitor->full, monitor->Monitormutex) ;
	}


	if  ( monitor->active)
     b2c:	8b 45 08             	mov    0x8(%ebp),%eax
     b2f:	8b 40 10             	mov    0x10(%eax),%eax
     b32:	85 c0                	test   %eax,%eax
     b34:	74 11                	je     b47 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     b36:	8b 45 08             	mov    0x8(%ebp),%eax
     b39:	8b 50 0c             	mov    0xc(%eax),%edx
     b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3f:	01 c2                	add    %eax,%edx
     b41:	8b 45 08             	mov    0x8(%ebp),%eax
     b44:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     b47:	8b 45 08             	mov    0x8(%ebp),%eax
     b4a:	8b 40 04             	mov    0x4(%eax),%eax
     b4d:	89 04 24             	mov    %eax,(%esp)
     b50:	e8 dc 05 00 00       	call   1131 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     b55:	8b 45 08             	mov    0x8(%ebp),%eax
     b58:	8b 00                	mov    (%eax),%eax
     b5a:	89 04 24             	mov    %eax,(%esp)
     b5d:	e8 b7 f9 ff ff       	call   519 <kthread_mutex_unlock>

	return 1;
     b62:	b8 01 00 00 00       	mov    $0x1,%eax


}
     b67:	c9                   	leave  
     b68:	c3                   	ret    

00000b69 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     b69:	55                   	push   %ebp
     b6a:	89 e5                	mov    %esp,%ebp
     b6c:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     b6f:	8b 45 08             	mov    0x8(%ebp),%eax
     b72:	8b 40 10             	mov    0x10(%eax),%eax
     b75:	85 c0                	test   %eax,%eax
     b77:	75 07                	jne    b80 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b7e:	eb 7f                	jmp    bff <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     b80:	8b 45 08             	mov    0x8(%ebp),%eax
     b83:	8b 00                	mov    (%eax),%eax
     b85:	89 04 24             	mov    %eax,(%esp)
     b88:	e8 84 f9 ff ff       	call   511 <kthread_mutex_lock>
     b8d:	83 f8 ff             	cmp    $0xffffffff,%eax
     b90:	7d 07                	jge    b99 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     b92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b97:	eb 66                	jmp    bff <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     b99:	eb 17                	jmp    bb2 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     b9b:	8b 45 08             	mov    0x8(%ebp),%eax
     b9e:	8b 10                	mov    (%eax),%edx
     ba0:	8b 45 08             	mov    0x8(%ebp),%eax
     ba3:	8b 40 04             	mov    0x4(%eax),%eax
     ba6:	89 54 24 04          	mov    %edx,0x4(%esp)
     baa:	89 04 24             	mov    %eax,(%esp)
     bad:	e8 15 05 00 00       	call   10c7 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     bb2:	8b 45 08             	mov    0x8(%ebp),%eax
     bb5:	8b 40 10             	mov    0x10(%eax),%eax
     bb8:	85 c0                	test   %eax,%eax
     bba:	74 0a                	je     bc6 <mesa_slots_monitor_takeslot+0x5d>
     bbc:	8b 45 08             	mov    0x8(%ebp),%eax
     bbf:	8b 40 0c             	mov    0xc(%eax),%eax
     bc2:	85 c0                	test   %eax,%eax
     bc4:	74 d5                	je     b9b <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     bc6:	8b 45 08             	mov    0x8(%ebp),%eax
     bc9:	8b 40 10             	mov    0x10(%eax),%eax
     bcc:	85 c0                	test   %eax,%eax
     bce:	74 0f                	je     bdf <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     bd0:	8b 45 08             	mov    0x8(%ebp),%eax
     bd3:	8b 40 0c             	mov    0xc(%eax),%eax
     bd6:	8d 50 ff             	lea    -0x1(%eax),%edx
     bd9:	8b 45 08             	mov    0x8(%ebp),%eax
     bdc:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	8b 40 08             	mov    0x8(%eax),%eax
     be5:	89 04 24             	mov    %eax,(%esp)
     be8:	e8 44 05 00 00       	call   1131 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     bed:	8b 45 08             	mov    0x8(%ebp),%eax
     bf0:	8b 00                	mov    (%eax),%eax
     bf2:	89 04 24             	mov    %eax,(%esp)
     bf5:	e8 1f f9 ff ff       	call   519 <kthread_mutex_unlock>

	return 1;
     bfa:	b8 01 00 00 00       	mov    $0x1,%eax

}
     bff:	c9                   	leave  
     c00:	c3                   	ret    

00000c01 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     c01:	55                   	push   %ebp
     c02:	89 e5                	mov    %esp,%ebp
     c04:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     c07:	8b 45 08             	mov    0x8(%ebp),%eax
     c0a:	8b 40 10             	mov    0x10(%eax),%eax
     c0d:	85 c0                	test   %eax,%eax
     c0f:	75 07                	jne    c18 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c16:	eb 35                	jmp    c4d <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c18:	8b 45 08             	mov    0x8(%ebp),%eax
     c1b:	8b 00                	mov    (%eax),%eax
     c1d:	89 04 24             	mov    %eax,(%esp)
     c20:	e8 ec f8 ff ff       	call   511 <kthread_mutex_lock>
     c25:	83 f8 ff             	cmp    $0xffffffff,%eax
     c28:	7d 07                	jge    c31 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c2f:	eb 1c                	jmp    c4d <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     c31:	8b 45 08             	mov    0x8(%ebp),%eax
     c34:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     c3b:	8b 45 08             	mov    0x8(%ebp),%eax
     c3e:	8b 00                	mov    (%eax),%eax
     c40:	89 04 24             	mov    %eax,(%esp)
     c43:	e8 d1 f8 ff ff       	call   519 <kthread_mutex_unlock>

		return 0;
     c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c4d:	c9                   	leave  
     c4e:	c3                   	ret    

00000c4f <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     c4f:	55                   	push   %ebp
     c50:	89 e5                	mov    %esp,%ebp
     c52:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     c55:	e8 a7 f8 ff ff       	call   501 <kthread_mutex_alloc>
     c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c61:	79 0a                	jns    c6d <hoare_slots_monitor_alloc+0x1e>
		return 0;
     c63:	b8 00 00 00 00       	mov    $0x0,%eax
     c68:	e9 8b 00 00 00       	jmp    cf8 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     c6d:	e8 68 02 00 00       	call   eda <hoare_cond_alloc>
     c72:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c79:	75 12                	jne    c8d <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c7e:	89 04 24             	mov    %eax,(%esp)
     c81:	e8 83 f8 ff ff       	call   509 <kthread_mutex_dealloc>
		return 0;
     c86:	b8 00 00 00 00       	mov    $0x0,%eax
     c8b:	eb 6b                	jmp    cf8 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     c8d:	e8 48 02 00 00       	call   eda <hoare_cond_alloc>
     c92:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     c95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c99:	75 1d                	jne    cb8 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9e:	89 04 24             	mov    %eax,(%esp)
     ca1:	e8 63 f8 ff ff       	call   509 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ca9:	89 04 24             	mov    %eax,(%esp)
     cac:	e8 6a 02 00 00       	call   f1b <hoare_cond_dealloc>
		return 0;
     cb1:	b8 00 00 00 00       	mov    $0x0,%eax
     cb6:	eb 40                	jmp    cf8 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     cb8:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     cbf:	e8 31 fc ff ff       	call   8f5 <malloc>
     cc4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cca:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ccd:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cd3:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cd6:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cdf:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ce4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cee:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     cf8:	c9                   	leave  
     cf9:	c3                   	ret    

00000cfa <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     cfa:	55                   	push   %ebp
     cfb:	89 e5                	mov    %esp,%ebp
     cfd:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     d00:	8b 45 08             	mov    0x8(%ebp),%eax
     d03:	8b 00                	mov    (%eax),%eax
     d05:	89 04 24             	mov    %eax,(%esp)
     d08:	e8 fc f7 ff ff       	call   509 <kthread_mutex_dealloc>
     d0d:	85 c0                	test   %eax,%eax
     d0f:	78 2e                	js     d3f <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     d11:	8b 45 08             	mov    0x8(%ebp),%eax
     d14:	8b 40 04             	mov    0x4(%eax),%eax
     d17:	89 04 24             	mov    %eax,(%esp)
     d1a:	e8 bb 01 00 00       	call   eda <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     d1f:	8b 45 08             	mov    0x8(%ebp),%eax
     d22:	8b 40 08             	mov    0x8(%eax),%eax
     d25:	89 04 24             	mov    %eax,(%esp)
     d28:	e8 ad 01 00 00       	call   eda <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     d2d:	8b 45 08             	mov    0x8(%ebp),%eax
     d30:	89 04 24             	mov    %eax,(%esp)
     d33:	e8 84 fa ff ff       	call   7bc <free>
	return 0;
     d38:	b8 00 00 00 00       	mov    $0x0,%eax
     d3d:	eb 05                	jmp    d44 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     d44:	c9                   	leave  
     d45:	c3                   	ret    

00000d46 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     d46:	55                   	push   %ebp
     d47:	89 e5                	mov    %esp,%ebp
     d49:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     d4c:	8b 45 08             	mov    0x8(%ebp),%eax
     d4f:	8b 40 10             	mov    0x10(%eax),%eax
     d52:	85 c0                	test   %eax,%eax
     d54:	75 0a                	jne    d60 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d5b:	e9 88 00 00 00       	jmp    de8 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d60:	8b 45 08             	mov    0x8(%ebp),%eax
     d63:	8b 00                	mov    (%eax),%eax
     d65:	89 04 24             	mov    %eax,(%esp)
     d68:	e8 a4 f7 ff ff       	call   511 <kthread_mutex_lock>
     d6d:	83 f8 ff             	cmp    $0xffffffff,%eax
     d70:	7d 07                	jge    d79 <hoare_slots_monitor_addslots+0x33>
		return -1;
     d72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d77:	eb 6f                	jmp    de8 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     d79:	8b 45 08             	mov    0x8(%ebp),%eax
     d7c:	8b 40 10             	mov    0x10(%eax),%eax
     d7f:	85 c0                	test   %eax,%eax
     d81:	74 21                	je     da4 <hoare_slots_monitor_addslots+0x5e>
     d83:	8b 45 08             	mov    0x8(%ebp),%eax
     d86:	8b 40 0c             	mov    0xc(%eax),%eax
     d89:	85 c0                	test   %eax,%eax
     d8b:	7e 17                	jle    da4 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     d8d:	8b 45 08             	mov    0x8(%ebp),%eax
     d90:	8b 10                	mov    (%eax),%edx
     d92:	8b 45 08             	mov    0x8(%ebp),%eax
     d95:	8b 40 08             	mov    0x8(%eax),%eax
     d98:	89 54 24 04          	mov    %edx,0x4(%esp)
     d9c:	89 04 24             	mov    %eax,(%esp)
     d9f:	e8 c1 01 00 00       	call   f65 <hoare_cond_wait>


	if  ( monitor->active)
     da4:	8b 45 08             	mov    0x8(%ebp),%eax
     da7:	8b 40 10             	mov    0x10(%eax),%eax
     daa:	85 c0                	test   %eax,%eax
     dac:	74 11                	je     dbf <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     dae:	8b 45 08             	mov    0x8(%ebp),%eax
     db1:	8b 50 0c             	mov    0xc(%eax),%edx
     db4:	8b 45 0c             	mov    0xc(%ebp),%eax
     db7:	01 c2                	add    %eax,%edx
     db9:	8b 45 08             	mov    0x8(%ebp),%eax
     dbc:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     dbf:	8b 45 08             	mov    0x8(%ebp),%eax
     dc2:	8b 10                	mov    (%eax),%edx
     dc4:	8b 45 08             	mov    0x8(%ebp),%eax
     dc7:	8b 40 04             	mov    0x4(%eax),%eax
     dca:	89 54 24 04          	mov    %edx,0x4(%esp)
     dce:	89 04 24             	mov    %eax,(%esp)
     dd1:	e8 e6 01 00 00       	call   fbc <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     dd6:	8b 45 08             	mov    0x8(%ebp),%eax
     dd9:	8b 00                	mov    (%eax),%eax
     ddb:	89 04 24             	mov    %eax,(%esp)
     dde:	e8 36 f7 ff ff       	call   519 <kthread_mutex_unlock>

	return 1;
     de3:	b8 01 00 00 00       	mov    $0x1,%eax


}
     de8:	c9                   	leave  
     de9:	c3                   	ret    

00000dea <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     dea:	55                   	push   %ebp
     deb:	89 e5                	mov    %esp,%ebp
     ded:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     df0:	8b 45 08             	mov    0x8(%ebp),%eax
     df3:	8b 40 10             	mov    0x10(%eax),%eax
     df6:	85 c0                	test   %eax,%eax
     df8:	75 0a                	jne    e04 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     dfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dff:	e9 86 00 00 00       	jmp    e8a <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     e04:	8b 45 08             	mov    0x8(%ebp),%eax
     e07:	8b 00                	mov    (%eax),%eax
     e09:	89 04 24             	mov    %eax,(%esp)
     e0c:	e8 00 f7 ff ff       	call   511 <kthread_mutex_lock>
     e11:	83 f8 ff             	cmp    $0xffffffff,%eax
     e14:	7d 07                	jge    e1d <hoare_slots_monitor_takeslot+0x33>
		return -1;
     e16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e1b:	eb 6d                	jmp    e8a <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     e1d:	8b 45 08             	mov    0x8(%ebp),%eax
     e20:	8b 40 10             	mov    0x10(%eax),%eax
     e23:	85 c0                	test   %eax,%eax
     e25:	74 21                	je     e48 <hoare_slots_monitor_takeslot+0x5e>
     e27:	8b 45 08             	mov    0x8(%ebp),%eax
     e2a:	8b 40 0c             	mov    0xc(%eax),%eax
     e2d:	85 c0                	test   %eax,%eax
     e2f:	75 17                	jne    e48 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     e31:	8b 45 08             	mov    0x8(%ebp),%eax
     e34:	8b 10                	mov    (%eax),%edx
     e36:	8b 45 08             	mov    0x8(%ebp),%eax
     e39:	8b 40 04             	mov    0x4(%eax),%eax
     e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
     e40:	89 04 24             	mov    %eax,(%esp)
     e43:	e8 1d 01 00 00       	call   f65 <hoare_cond_wait>


	if  ( monitor->active)
     e48:	8b 45 08             	mov    0x8(%ebp),%eax
     e4b:	8b 40 10             	mov    0x10(%eax),%eax
     e4e:	85 c0                	test   %eax,%eax
     e50:	74 0f                	je     e61 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     e52:	8b 45 08             	mov    0x8(%ebp),%eax
     e55:	8b 40 0c             	mov    0xc(%eax),%eax
     e58:	8d 50 ff             	lea    -0x1(%eax),%edx
     e5b:	8b 45 08             	mov    0x8(%ebp),%eax
     e5e:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     e61:	8b 45 08             	mov    0x8(%ebp),%eax
     e64:	8b 10                	mov    (%eax),%edx
     e66:	8b 45 08             	mov    0x8(%ebp),%eax
     e69:	8b 40 08             	mov    0x8(%eax),%eax
     e6c:	89 54 24 04          	mov    %edx,0x4(%esp)
     e70:	89 04 24             	mov    %eax,(%esp)
     e73:	e8 44 01 00 00       	call   fbc <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     e78:	8b 45 08             	mov    0x8(%ebp),%eax
     e7b:	8b 00                	mov    (%eax),%eax
     e7d:	89 04 24             	mov    %eax,(%esp)
     e80:	e8 94 f6 ff ff       	call   519 <kthread_mutex_unlock>

	return 1;
     e85:	b8 01 00 00 00       	mov    $0x1,%eax

}
     e8a:	c9                   	leave  
     e8b:	c3                   	ret    

00000e8c <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
     e8c:	55                   	push   %ebp
     e8d:	89 e5                	mov    %esp,%ebp
     e8f:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     e92:	8b 45 08             	mov    0x8(%ebp),%eax
     e95:	8b 40 10             	mov    0x10(%eax),%eax
     e98:	85 c0                	test   %eax,%eax
     e9a:	75 07                	jne    ea3 <hoare_slots_monitor_stopadding+0x17>
			return -1;
     e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea1:	eb 35                	jmp    ed8 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ea3:	8b 45 08             	mov    0x8(%ebp),%eax
     ea6:	8b 00                	mov    (%eax),%eax
     ea8:	89 04 24             	mov    %eax,(%esp)
     eab:	e8 61 f6 ff ff       	call   511 <kthread_mutex_lock>
     eb0:	83 f8 ff             	cmp    $0xffffffff,%eax
     eb3:	7d 07                	jge    ebc <hoare_slots_monitor_stopadding+0x30>
			return -1;
     eb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eba:	eb 1c                	jmp    ed8 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     ebc:	8b 45 08             	mov    0x8(%ebp),%eax
     ebf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     ec6:	8b 45 08             	mov    0x8(%ebp),%eax
     ec9:	8b 00                	mov    (%eax),%eax
     ecb:	89 04 24             	mov    %eax,(%esp)
     ece:	e8 46 f6 ff ff       	call   519 <kthread_mutex_unlock>

		return 0;
     ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ed8:	c9                   	leave  
     ed9:	c3                   	ret    

00000eda <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
     eda:	55                   	push   %ebp
     edb:	89 e5                	mov    %esp,%ebp
     edd:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
     ee0:	e8 1c f6 ff ff       	call   501 <kthread_mutex_alloc>
     ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
     ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     eec:	79 07                	jns    ef5 <hoare_cond_alloc+0x1b>
		return 0;
     eee:	b8 00 00 00 00       	mov    $0x0,%eax
     ef3:	eb 24                	jmp    f19 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
     ef5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     efc:	e8 f4 f9 ff ff       	call   8f5 <malloc>
     f01:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
     f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f0a:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
     f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
     f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f19:	c9                   	leave  
     f1a:	c3                   	ret    

00000f1b <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
     f1b:	55                   	push   %ebp
     f1c:	89 e5                	mov    %esp,%ebp
     f1e:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
     f21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f25:	75 07                	jne    f2e <hoare_cond_dealloc+0x13>
			return -1;
     f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f2c:	eb 35                	jmp    f63 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
     f2e:	8b 45 08             	mov    0x8(%ebp),%eax
     f31:	8b 00                	mov    (%eax),%eax
     f33:	89 04 24             	mov    %eax,(%esp)
     f36:	e8 de f5 ff ff       	call   519 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
     f3b:	8b 45 08             	mov    0x8(%ebp),%eax
     f3e:	8b 00                	mov    (%eax),%eax
     f40:	89 04 24             	mov    %eax,(%esp)
     f43:	e8 c1 f5 ff ff       	call   509 <kthread_mutex_dealloc>
     f48:	85 c0                	test   %eax,%eax
     f4a:	79 07                	jns    f53 <hoare_cond_dealloc+0x38>
			return -1;
     f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f51:	eb 10                	jmp    f63 <hoare_cond_dealloc+0x48>

		free (hCond);
     f53:	8b 45 08             	mov    0x8(%ebp),%eax
     f56:	89 04 24             	mov    %eax,(%esp)
     f59:	e8 5e f8 ff ff       	call   7bc <free>
		return 0;
     f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f63:	c9                   	leave  
     f64:	c3                   	ret    

00000f65 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
     f65:	55                   	push   %ebp
     f66:	89 e5                	mov    %esp,%ebp
     f68:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f6f:	75 07                	jne    f78 <hoare_cond_wait+0x13>
			return -1;
     f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f76:	eb 42                	jmp    fba <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
     f78:	8b 45 08             	mov    0x8(%ebp),%eax
     f7b:	8b 40 04             	mov    0x4(%eax),%eax
     f7e:	8d 50 01             	lea    0x1(%eax),%edx
     f81:	8b 45 08             	mov    0x8(%ebp),%eax
     f84:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
     f87:	8b 45 08             	mov    0x8(%ebp),%eax
     f8a:	8b 00                	mov    (%eax),%eax
     f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
     f90:	8b 45 0c             	mov    0xc(%ebp),%eax
     f93:	89 04 24             	mov    %eax,(%esp)
     f96:	e8 86 f5 ff ff       	call   521 <kthread_mutex_yieldlock>
     f9b:	85 c0                	test   %eax,%eax
     f9d:	79 16                	jns    fb5 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
     f9f:	8b 45 08             	mov    0x8(%ebp),%eax
     fa2:	8b 40 04             	mov    0x4(%eax),%eax
     fa5:	8d 50 ff             	lea    -0x1(%eax),%edx
     fa8:	8b 45 08             	mov    0x8(%ebp),%eax
     fab:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
     fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fb3:	eb 05                	jmp    fba <hoare_cond_wait+0x55>
		}

	return 0;
     fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
     fba:	c9                   	leave  
     fbb:	c3                   	ret    

00000fbc <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
     fbc:	55                   	push   %ebp
     fbd:	89 e5                	mov    %esp,%ebp
     fbf:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
     fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     fc6:	75 07                	jne    fcf <hoare_cond_signal+0x13>
		return -1;
     fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fcd:	eb 6b                	jmp    103a <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
     fcf:	8b 45 08             	mov    0x8(%ebp),%eax
     fd2:	8b 40 04             	mov    0x4(%eax),%eax
     fd5:	85 c0                	test   %eax,%eax
     fd7:	7e 3d                	jle    1016 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
     fd9:	8b 45 08             	mov    0x8(%ebp),%eax
     fdc:	8b 40 04             	mov    0x4(%eax),%eax
     fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
     fe2:	8b 45 08             	mov    0x8(%ebp),%eax
     fe5:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
     fe8:	8b 45 08             	mov    0x8(%ebp),%eax
     feb:	8b 00                	mov    (%eax),%eax
     fed:	89 44 24 04          	mov    %eax,0x4(%esp)
     ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff4:	89 04 24             	mov    %eax,(%esp)
     ff7:	e8 25 f5 ff ff       	call   521 <kthread_mutex_yieldlock>
     ffc:	85 c0                	test   %eax,%eax
     ffe:	79 16                	jns    1016 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    1000:	8b 45 08             	mov    0x8(%ebp),%eax
    1003:	8b 40 04             	mov    0x4(%eax),%eax
    1006:	8d 50 01             	lea    0x1(%eax),%edx
    1009:	8b 45 08             	mov    0x8(%ebp),%eax
    100c:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    100f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1014:	eb 24                	jmp    103a <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1016:	8b 45 08             	mov    0x8(%ebp),%eax
    1019:	8b 00                	mov    (%eax),%eax
    101b:	89 44 24 04          	mov    %eax,0x4(%esp)
    101f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 f7 f4 ff ff       	call   521 <kthread_mutex_yieldlock>
    102a:	85 c0                	test   %eax,%eax
    102c:	79 07                	jns    1035 <hoare_cond_signal+0x79>

    			return -1;
    102e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1033:	eb 05                	jmp    103a <hoare_cond_signal+0x7e>
    }

	return 0;
    1035:	b8 00 00 00 00       	mov    $0x0,%eax

}
    103a:	c9                   	leave  
    103b:	c3                   	ret    

0000103c <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    103c:	55                   	push   %ebp
    103d:	89 e5                	mov    %esp,%ebp
    103f:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1042:	e8 ba f4 ff ff       	call   501 <kthread_mutex_alloc>
    1047:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    104a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    104e:	79 07                	jns    1057 <mesa_cond_alloc+0x1b>
		return 0;
    1050:	b8 00 00 00 00       	mov    $0x0,%eax
    1055:	eb 24                	jmp    107b <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    1057:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    105e:	e8 92 f8 ff ff       	call   8f5 <malloc>
    1063:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    1066:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1069:	8b 55 f4             	mov    -0xc(%ebp),%edx
    106c:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    106e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    1078:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    107b:	c9                   	leave  
    107c:	c3                   	ret    

0000107d <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    107d:	55                   	push   %ebp
    107e:	89 e5                	mov    %esp,%ebp
    1080:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    1083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1087:	75 07                	jne    1090 <mesa_cond_dealloc+0x13>
		return -1;
    1089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    108e:	eb 35                	jmp    10c5 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    1090:	8b 45 08             	mov    0x8(%ebp),%eax
    1093:	8b 00                	mov    (%eax),%eax
    1095:	89 04 24             	mov    %eax,(%esp)
    1098:	e8 7c f4 ff ff       	call   519 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    109d:	8b 45 08             	mov    0x8(%ebp),%eax
    10a0:	8b 00                	mov    (%eax),%eax
    10a2:	89 04 24             	mov    %eax,(%esp)
    10a5:	e8 5f f4 ff ff       	call   509 <kthread_mutex_dealloc>
    10aa:	85 c0                	test   %eax,%eax
    10ac:	79 07                	jns    10b5 <mesa_cond_dealloc+0x38>
		return -1;
    10ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10b3:	eb 10                	jmp    10c5 <mesa_cond_dealloc+0x48>

	free (mCond);
    10b5:	8b 45 08             	mov    0x8(%ebp),%eax
    10b8:	89 04 24             	mov    %eax,(%esp)
    10bb:	e8 fc f6 ff ff       	call   7bc <free>
	return 0;
    10c0:	b8 00 00 00 00       	mov    $0x0,%eax

}
    10c5:	c9                   	leave  
    10c6:	c3                   	ret    

000010c7 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    10c7:	55                   	push   %ebp
    10c8:	89 e5                	mov    %esp,%ebp
    10ca:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    10cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10d1:	75 07                	jne    10da <mesa_cond_wait+0x13>
		return -1;
    10d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10d8:	eb 55                	jmp    112f <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    10da:	8b 45 08             	mov    0x8(%ebp),%eax
    10dd:	8b 40 04             	mov    0x4(%eax),%eax
    10e0:	8d 50 01             	lea    0x1(%eax),%edx
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    10e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ec:	89 04 24             	mov    %eax,(%esp)
    10ef:	e8 25 f4 ff ff       	call   519 <kthread_mutex_unlock>
    10f4:	85 c0                	test   %eax,%eax
    10f6:	79 27                	jns    111f <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    10f8:	8b 45 08             	mov    0x8(%ebp),%eax
    10fb:	8b 00                	mov    (%eax),%eax
    10fd:	89 04 24             	mov    %eax,(%esp)
    1100:	e8 0c f4 ff ff       	call   511 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1105:	85 c0                	test   %eax,%eax
    1107:	79 16                	jns    111f <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
    110c:	8b 40 04             	mov    0x4(%eax),%eax
    110f:	8d 50 ff             	lea    -0x1(%eax),%edx
    1112:	8b 45 08             	mov    0x8(%ebp),%eax
    1115:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    1118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    111d:	eb 10                	jmp    112f <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    111f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1122:	89 04 24             	mov    %eax,(%esp)
    1125:	e8 e7 f3 ff ff       	call   511 <kthread_mutex_lock>
	return 0;
    112a:	b8 00 00 00 00       	mov    $0x0,%eax


}
    112f:	c9                   	leave  
    1130:	c3                   	ret    

00001131 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    1131:	55                   	push   %ebp
    1132:	89 e5                	mov    %esp,%ebp
    1134:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    113b:	75 07                	jne    1144 <mesa_cond_signal+0x13>
		return -1;
    113d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1142:	eb 5d                	jmp    11a1 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    1144:	8b 45 08             	mov    0x8(%ebp),%eax
    1147:	8b 40 04             	mov    0x4(%eax),%eax
    114a:	85 c0                	test   %eax,%eax
    114c:	7e 36                	jle    1184 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    114e:	8b 45 08             	mov    0x8(%ebp),%eax
    1151:	8b 40 04             	mov    0x4(%eax),%eax
    1154:	8d 50 ff             	lea    -0x1(%eax),%edx
    1157:	8b 45 08             	mov    0x8(%ebp),%eax
    115a:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    115d:	8b 45 08             	mov    0x8(%ebp),%eax
    1160:	8b 00                	mov    (%eax),%eax
    1162:	89 04 24             	mov    %eax,(%esp)
    1165:	e8 af f3 ff ff       	call   519 <kthread_mutex_unlock>
    116a:	85 c0                	test   %eax,%eax
    116c:	78 16                	js     1184 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    116e:	8b 45 08             	mov    0x8(%ebp),%eax
    1171:	8b 40 04             	mov    0x4(%eax),%eax
    1174:	8d 50 01             	lea    0x1(%eax),%edx
    1177:	8b 45 08             	mov    0x8(%ebp),%eax
    117a:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    117d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1182:	eb 1d                	jmp    11a1 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1184:	8b 45 08             	mov    0x8(%ebp),%eax
    1187:	8b 00                	mov    (%eax),%eax
    1189:	89 04 24             	mov    %eax,(%esp)
    118c:	e8 88 f3 ff ff       	call   519 <kthread_mutex_unlock>
    1191:	85 c0                	test   %eax,%eax
    1193:	79 07                	jns    119c <mesa_cond_signal+0x6b>

		return -1;
    1195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    119a:	eb 05                	jmp    11a1 <mesa_cond_signal+0x70>
	}
	return 0;
    119c:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11a1:	c9                   	leave  
    11a2:	c3                   	ret    
