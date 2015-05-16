
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
       6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
       d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
      12:	8b 45 ec             	mov    -0x14(%ebp),%eax
      15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
      18:	c7 45 f0 a0 18 00 00 	movl   $0x18a0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
      1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
      21:	8b 45 e8             	mov    -0x18(%ebp),%eax
      24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
      27:	8b 45 f0             	mov    -0x10(%ebp),%eax
      2a:	89 44 24 04          	mov    %eax,0x4(%esp)
      2e:	8b 45 08             	mov    0x8(%ebp),%eax
      31:	89 04 24             	mov    %eax,(%esp)
      34:	e8 bc 01 00 00       	call   1f5 <match>
      39:	85 c0                	test   %eax,%eax
      3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
      3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
      43:	8b 45 e8             	mov    -0x18(%ebp),%eax
      46:	83 c0 01             	add    $0x1,%eax
      49:	89 c2                	mov    %eax,%edx
      4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      4e:	29 c2                	sub    %eax,%edx
      50:	89 d0                	mov    %edx,%eax
      52:	89 44 24 08          	mov    %eax,0x8(%esp)
      56:	8b 45 f0             	mov    -0x10(%ebp),%eax
      59:	89 44 24 04          	mov    %eax,0x4(%esp)
      5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      64:	e8 74 05 00 00       	call   5dd <write>
      }
      p = q+1;
      69:	8b 45 e8             	mov    -0x18(%ebp),%eax
      6c:	83 c0 01             	add    $0x1,%eax
      6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
      79:	00 
      7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      7d:	89 04 24             	mov    %eax,(%esp)
      80:	e8 af 03 00 00       	call   434 <strchr>
      85:	89 45 e8             	mov    %eax,-0x18(%ebp)
      88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      8e:	81 7d f0 a0 18 00 00 	cmpl   $0x18a0,-0x10(%ebp)
      95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
      97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
      9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
      a4:	ba a0 18 00 00       	mov    $0x18a0,%edx
      a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      ac:	29 c2                	sub    %eax,%edx
      ae:	89 d0                	mov    %edx,%eax
      b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
      b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
      bd:	89 44 24 04          	mov    %eax,0x4(%esp)
      c1:	c7 04 24 a0 18 00 00 	movl   $0x18a0,(%esp)
      c8:	e8 ab 04 00 00       	call   578 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
      cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d0:	ba 00 04 00 00       	mov    $0x400,%edx
      d5:	29 c2                	sub    %eax,%edx
      d7:	89 d0                	mov    %edx,%eax
      d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
      dc:	81 c2 a0 18 00 00    	add    $0x18a0,%edx
      e2:	89 44 24 08          	mov    %eax,0x8(%esp)
      e6:	89 54 24 04          	mov    %edx,0x4(%esp)
      ea:	8b 45 0c             	mov    0xc(%ebp),%eax
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 e0 04 00 00       	call   5d5 <read>
      f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
     102:	c9                   	leave  
     103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
     104:	55                   	push   %ebp
     105:	89 e5                	mov    %esp,%ebp
     107:	83 e4 f0             	and    $0xfffffff0,%esp
     10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
     10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     111:	7f 19                	jg     12c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
     113:	c7 44 24 04 20 13 00 	movl   $0x1320,0x4(%esp)
     11a:	00 
     11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     122:	e8 5e 06 00 00       	call   785 <printf>
    exit();
     127:	e8 91 04 00 00       	call   5bd <exit>
  }
  pattern = argv[1];
     12c:	8b 45 0c             	mov    0xc(%ebp),%eax
     12f:	8b 40 04             	mov    0x4(%eax),%eax
     132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
     136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     13a:	7f 19                	jg     155 <main+0x51>
    grep(pattern, 0);
     13c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     143:	00 
     144:	8b 44 24 18          	mov    0x18(%esp),%eax
     148:	89 04 24             	mov    %eax,(%esp)
     14b:	e8 b0 fe ff ff       	call   0 <grep>
    exit();
     150:	e8 68 04 00 00       	call   5bd <exit>
  }

  for(i = 2; i < argc; i++){
     155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
     15c:	00 
     15d:	e9 81 00 00 00       	jmp    1e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
     162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     16d:	8b 45 0c             	mov    0xc(%ebp),%eax
     170:	01 d0                	add    %edx,%eax
     172:	8b 00                	mov    (%eax),%eax
     174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     17b:	00 
     17c:	89 04 24             	mov    %eax,(%esp)
     17f:	e8 79 04 00 00       	call   5fd <open>
     184:	89 44 24 14          	mov    %eax,0x14(%esp)
     188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
     18d:	79 2f                	jns    1be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
     18f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     19a:	8b 45 0c             	mov    0xc(%ebp),%eax
     19d:	01 d0                	add    %edx,%eax
     19f:	8b 00                	mov    (%eax),%eax
     1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
     1a5:	c7 44 24 04 40 13 00 	movl   $0x1340,0x4(%esp)
     1ac:	00 
     1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1b4:	e8 cc 05 00 00       	call   785 <printf>
      exit();
     1b9:	e8 ff 03 00 00       	call   5bd <exit>
    }
    grep(pattern, fd);
     1be:	8b 44 24 14          	mov    0x14(%esp),%eax
     1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     1c6:	8b 44 24 18          	mov    0x18(%esp),%eax
     1ca:	89 04 24             	mov    %eax,(%esp)
     1cd:	e8 2e fe ff ff       	call   0 <grep>
    close(fd);
     1d2:	8b 44 24 14          	mov    0x14(%esp),%eax
     1d6:	89 04 24             	mov    %eax,(%esp)
     1d9:	e8 07 04 00 00       	call   5e5 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
     1de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     1e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     1e7:	3b 45 08             	cmp    0x8(%ebp),%eax
     1ea:	0f 8c 72 ff ff ff    	jl     162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
     1f0:	e8 c8 03 00 00       	call   5bd <exit>

000001f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
     1f5:	55                   	push   %ebp
     1f6:	89 e5                	mov    %esp,%ebp
     1f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
     1fb:	8b 45 08             	mov    0x8(%ebp),%eax
     1fe:	0f b6 00             	movzbl (%eax),%eax
     201:	3c 5e                	cmp    $0x5e,%al
     203:	75 17                	jne    21c <match+0x27>
    return matchhere(re+1, text);
     205:	8b 45 08             	mov    0x8(%ebp),%eax
     208:	8d 50 01             	lea    0x1(%eax),%edx
     20b:	8b 45 0c             	mov    0xc(%ebp),%eax
     20e:	89 44 24 04          	mov    %eax,0x4(%esp)
     212:	89 14 24             	mov    %edx,(%esp)
     215:	e8 36 00 00 00       	call   250 <matchhere>
     21a:	eb 32                	jmp    24e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
     21c:	8b 45 0c             	mov    0xc(%ebp),%eax
     21f:	89 44 24 04          	mov    %eax,0x4(%esp)
     223:	8b 45 08             	mov    0x8(%ebp),%eax
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 22 00 00 00       	call   250 <matchhere>
     22e:	85 c0                	test   %eax,%eax
     230:	74 07                	je     239 <match+0x44>
      return 1;
     232:	b8 01 00 00 00       	mov    $0x1,%eax
     237:	eb 15                	jmp    24e <match+0x59>
  }while(*text++ != '\0');
     239:	8b 45 0c             	mov    0xc(%ebp),%eax
     23c:	8d 50 01             	lea    0x1(%eax),%edx
     23f:	89 55 0c             	mov    %edx,0xc(%ebp)
     242:	0f b6 00             	movzbl (%eax),%eax
     245:	84 c0                	test   %al,%al
     247:	75 d3                	jne    21c <match+0x27>
  return 0;
     249:	b8 00 00 00 00       	mov    $0x0,%eax
}
     24e:	c9                   	leave  
     24f:	c3                   	ret    

00000250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
     256:	8b 45 08             	mov    0x8(%ebp),%eax
     259:	0f b6 00             	movzbl (%eax),%eax
     25c:	84 c0                	test   %al,%al
     25e:	75 0a                	jne    26a <matchhere+0x1a>
    return 1;
     260:	b8 01 00 00 00       	mov    $0x1,%eax
     265:	e9 9b 00 00 00       	jmp    305 <matchhere+0xb5>
  if(re[1] == '*')
     26a:	8b 45 08             	mov    0x8(%ebp),%eax
     26d:	83 c0 01             	add    $0x1,%eax
     270:	0f b6 00             	movzbl (%eax),%eax
     273:	3c 2a                	cmp    $0x2a,%al
     275:	75 24                	jne    29b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
     277:	8b 45 08             	mov    0x8(%ebp),%eax
     27a:	8d 48 02             	lea    0x2(%eax),%ecx
     27d:	8b 45 08             	mov    0x8(%ebp),%eax
     280:	0f b6 00             	movzbl (%eax),%eax
     283:	0f be c0             	movsbl %al,%eax
     286:	8b 55 0c             	mov    0xc(%ebp),%edx
     289:	89 54 24 08          	mov    %edx,0x8(%esp)
     28d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
     291:	89 04 24             	mov    %eax,(%esp)
     294:	e8 6e 00 00 00       	call   307 <matchstar>
     299:	eb 6a                	jmp    305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
     29b:	8b 45 08             	mov    0x8(%ebp),%eax
     29e:	0f b6 00             	movzbl (%eax),%eax
     2a1:	3c 24                	cmp    $0x24,%al
     2a3:	75 1d                	jne    2c2 <matchhere+0x72>
     2a5:	8b 45 08             	mov    0x8(%ebp),%eax
     2a8:	83 c0 01             	add    $0x1,%eax
     2ab:	0f b6 00             	movzbl (%eax),%eax
     2ae:	84 c0                	test   %al,%al
     2b0:	75 10                	jne    2c2 <matchhere+0x72>
    return *text == '\0';
     2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b5:	0f b6 00             	movzbl (%eax),%eax
     2b8:	84 c0                	test   %al,%al
     2ba:	0f 94 c0             	sete   %al
     2bd:	0f b6 c0             	movzbl %al,%eax
     2c0:	eb 43                	jmp    305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
     2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c5:	0f b6 00             	movzbl (%eax),%eax
     2c8:	84 c0                	test   %al,%al
     2ca:	74 34                	je     300 <matchhere+0xb0>
     2cc:	8b 45 08             	mov    0x8(%ebp),%eax
     2cf:	0f b6 00             	movzbl (%eax),%eax
     2d2:	3c 2e                	cmp    $0x2e,%al
     2d4:	74 10                	je     2e6 <matchhere+0x96>
     2d6:	8b 45 08             	mov    0x8(%ebp),%eax
     2d9:	0f b6 10             	movzbl (%eax),%edx
     2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     2df:	0f b6 00             	movzbl (%eax),%eax
     2e2:	38 c2                	cmp    %al,%dl
     2e4:	75 1a                	jne    300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
     2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     2e9:	8d 50 01             	lea    0x1(%eax),%edx
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	83 c0 01             	add    $0x1,%eax
     2f2:	89 54 24 04          	mov    %edx,0x4(%esp)
     2f6:	89 04 24             	mov    %eax,(%esp)
     2f9:	e8 52 ff ff ff       	call   250 <matchhere>
     2fe:	eb 05                	jmp    305 <matchhere+0xb5>
  return 0;
     300:	b8 00 00 00 00       	mov    $0x0,%eax
}
     305:	c9                   	leave  
     306:	c3                   	ret    

00000307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
     307:	55                   	push   %ebp
     308:	89 e5                	mov    %esp,%ebp
     30a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
     30d:	8b 45 10             	mov    0x10(%ebp),%eax
     310:	89 44 24 04          	mov    %eax,0x4(%esp)
     314:	8b 45 0c             	mov    0xc(%ebp),%eax
     317:	89 04 24             	mov    %eax,(%esp)
     31a:	e8 31 ff ff ff       	call   250 <matchhere>
     31f:	85 c0                	test   %eax,%eax
     321:	74 07                	je     32a <matchstar+0x23>
      return 1;
     323:	b8 01 00 00 00       	mov    $0x1,%eax
     328:	eb 29                	jmp    353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
     32a:	8b 45 10             	mov    0x10(%ebp),%eax
     32d:	0f b6 00             	movzbl (%eax),%eax
     330:	84 c0                	test   %al,%al
     332:	74 1a                	je     34e <matchstar+0x47>
     334:	8b 45 10             	mov    0x10(%ebp),%eax
     337:	8d 50 01             	lea    0x1(%eax),%edx
     33a:	89 55 10             	mov    %edx,0x10(%ebp)
     33d:	0f b6 00             	movzbl (%eax),%eax
     340:	0f be c0             	movsbl %al,%eax
     343:	3b 45 08             	cmp    0x8(%ebp),%eax
     346:	74 c5                	je     30d <matchstar+0x6>
     348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
     34c:	74 bf                	je     30d <matchstar+0x6>
  return 0;
     34e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     353:	c9                   	leave  
     354:	c3                   	ret    

00000355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     355:	55                   	push   %ebp
     356:	89 e5                	mov    %esp,%ebp
     358:	57                   	push   %edi
     359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     35d:	8b 55 10             	mov    0x10(%ebp),%edx
     360:	8b 45 0c             	mov    0xc(%ebp),%eax
     363:	89 cb                	mov    %ecx,%ebx
     365:	89 df                	mov    %ebx,%edi
     367:	89 d1                	mov    %edx,%ecx
     369:	fc                   	cld    
     36a:	f3 aa                	rep stos %al,%es:(%edi)
     36c:	89 ca                	mov    %ecx,%edx
     36e:	89 fb                	mov    %edi,%ebx
     370:	89 5d 08             	mov    %ebx,0x8(%ebp)
     373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     376:	5b                   	pop    %ebx
     377:	5f                   	pop    %edi
     378:	5d                   	pop    %ebp
     379:	c3                   	ret    

0000037a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     37a:	55                   	push   %ebp
     37b:	89 e5                	mov    %esp,%ebp
     37d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     380:	8b 45 08             	mov    0x8(%ebp),%eax
     383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     386:	90                   	nop
     387:	8b 45 08             	mov    0x8(%ebp),%eax
     38a:	8d 50 01             	lea    0x1(%eax),%edx
     38d:	89 55 08             	mov    %edx,0x8(%ebp)
     390:	8b 55 0c             	mov    0xc(%ebp),%edx
     393:	8d 4a 01             	lea    0x1(%edx),%ecx
     396:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     399:	0f b6 12             	movzbl (%edx),%edx
     39c:	88 10                	mov    %dl,(%eax)
     39e:	0f b6 00             	movzbl (%eax),%eax
     3a1:	84 c0                	test   %al,%al
     3a3:	75 e2                	jne    387 <strcpy+0xd>
    ;
  return os;
     3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    

000003aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     3ad:	eb 08                	jmp    3b7 <strcmp+0xd>
    p++, q++;
     3af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     3b7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ba:	0f b6 00             	movzbl (%eax),%eax
     3bd:	84 c0                	test   %al,%al
     3bf:	74 10                	je     3d1 <strcmp+0x27>
     3c1:	8b 45 08             	mov    0x8(%ebp),%eax
     3c4:	0f b6 10             	movzbl (%eax),%edx
     3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ca:	0f b6 00             	movzbl (%eax),%eax
     3cd:	38 c2                	cmp    %al,%dl
     3cf:	74 de                	je     3af <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3d1:	8b 45 08             	mov    0x8(%ebp),%eax
     3d4:	0f b6 00             	movzbl (%eax),%eax
     3d7:	0f b6 d0             	movzbl %al,%edx
     3da:	8b 45 0c             	mov    0xc(%ebp),%eax
     3dd:	0f b6 00             	movzbl (%eax),%eax
     3e0:	0f b6 c0             	movzbl %al,%eax
     3e3:	29 c2                	sub    %eax,%edx
     3e5:	89 d0                	mov    %edx,%eax
}
     3e7:	5d                   	pop    %ebp
     3e8:	c3                   	ret    

000003e9 <strlen>:

uint
strlen(char *s)
{
     3e9:	55                   	push   %ebp
     3ea:	89 e5                	mov    %esp,%ebp
     3ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3f6:	eb 04                	jmp    3fc <strlen+0x13>
     3f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     3fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3ff:	8b 45 08             	mov    0x8(%ebp),%eax
     402:	01 d0                	add    %edx,%eax
     404:	0f b6 00             	movzbl (%eax),%eax
     407:	84 c0                	test   %al,%al
     409:	75 ed                	jne    3f8 <strlen+0xf>
    ;
  return n;
     40b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     40e:	c9                   	leave  
     40f:	c3                   	ret    

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     416:	8b 45 10             	mov    0x10(%ebp),%eax
     419:	89 44 24 08          	mov    %eax,0x8(%esp)
     41d:	8b 45 0c             	mov    0xc(%ebp),%eax
     420:	89 44 24 04          	mov    %eax,0x4(%esp)
     424:	8b 45 08             	mov    0x8(%ebp),%eax
     427:	89 04 24             	mov    %eax,(%esp)
     42a:	e8 26 ff ff ff       	call   355 <stosb>
  return dst;
     42f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     432:	c9                   	leave  
     433:	c3                   	ret    

00000434 <strchr>:

char*
strchr(const char *s, char c)
{
     434:	55                   	push   %ebp
     435:	89 e5                	mov    %esp,%ebp
     437:	83 ec 04             	sub    $0x4,%esp
     43a:	8b 45 0c             	mov    0xc(%ebp),%eax
     43d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     440:	eb 14                	jmp    456 <strchr+0x22>
    if(*s == c)
     442:	8b 45 08             	mov    0x8(%ebp),%eax
     445:	0f b6 00             	movzbl (%eax),%eax
     448:	3a 45 fc             	cmp    -0x4(%ebp),%al
     44b:	75 05                	jne    452 <strchr+0x1e>
      return (char*)s;
     44d:	8b 45 08             	mov    0x8(%ebp),%eax
     450:	eb 13                	jmp    465 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     456:	8b 45 08             	mov    0x8(%ebp),%eax
     459:	0f b6 00             	movzbl (%eax),%eax
     45c:	84 c0                	test   %al,%al
     45e:	75 e2                	jne    442 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     460:	b8 00 00 00 00       	mov    $0x0,%eax
}
     465:	c9                   	leave  
     466:	c3                   	ret    

00000467 <gets>:

char*
gets(char *buf, int max)
{
     467:	55                   	push   %ebp
     468:	89 e5                	mov    %esp,%ebp
     46a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     46d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     474:	eb 4c                	jmp    4c2 <gets+0x5b>
    cc = read(0, &c, 1);
     476:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     47d:	00 
     47e:	8d 45 ef             	lea    -0x11(%ebp),%eax
     481:	89 44 24 04          	mov    %eax,0x4(%esp)
     485:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     48c:	e8 44 01 00 00       	call   5d5 <read>
     491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     498:	7f 02                	jg     49c <gets+0x35>
      break;
     49a:	eb 31                	jmp    4cd <gets+0x66>
    buf[i++] = c;
     49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49f:	8d 50 01             	lea    0x1(%eax),%edx
     4a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4a5:	89 c2                	mov    %eax,%edx
     4a7:	8b 45 08             	mov    0x8(%ebp),%eax
     4aa:	01 c2                	add    %eax,%edx
     4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b6:	3c 0a                	cmp    $0xa,%al
     4b8:	74 13                	je     4cd <gets+0x66>
     4ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4be:	3c 0d                	cmp    $0xd,%al
     4c0:	74 0b                	je     4cd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	83 c0 01             	add    $0x1,%eax
     4c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4cb:	7c a9                	jl     476 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     4cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d0:	8b 45 08             	mov    0x8(%ebp),%eax
     4d3:	01 d0                	add    %edx,%eax
     4d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     4d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4db:	c9                   	leave  
     4dc:	c3                   	ret    

000004dd <stat>:

int
stat(char *n, struct stat *st)
{
     4dd:	55                   	push   %ebp
     4de:	89 e5                	mov    %esp,%ebp
     4e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4ea:	00 
     4eb:	8b 45 08             	mov    0x8(%ebp),%eax
     4ee:	89 04 24             	mov    %eax,(%esp)
     4f1:	e8 07 01 00 00       	call   5fd <open>
     4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4fd:	79 07                	jns    506 <stat+0x29>
    return -1;
     4ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     504:	eb 23                	jmp    529 <stat+0x4c>
  r = fstat(fd, st);
     506:	8b 45 0c             	mov    0xc(%ebp),%eax
     509:	89 44 24 04          	mov    %eax,0x4(%esp)
     50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     510:	89 04 24             	mov    %eax,(%esp)
     513:	e8 fd 00 00 00       	call   615 <fstat>
     518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	89 04 24             	mov    %eax,(%esp)
     521:	e8 bf 00 00 00       	call   5e5 <close>
  return r;
     526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     529:	c9                   	leave  
     52a:	c3                   	ret    

0000052b <atoi>:

int
atoi(const char *s)
{
     52b:	55                   	push   %ebp
     52c:	89 e5                	mov    %esp,%ebp
     52e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     538:	eb 25                	jmp    55f <atoi+0x34>
    n = n*10 + *s++ - '0';
     53a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     53d:	89 d0                	mov    %edx,%eax
     53f:	c1 e0 02             	shl    $0x2,%eax
     542:	01 d0                	add    %edx,%eax
     544:	01 c0                	add    %eax,%eax
     546:	89 c1                	mov    %eax,%ecx
     548:	8b 45 08             	mov    0x8(%ebp),%eax
     54b:	8d 50 01             	lea    0x1(%eax),%edx
     54e:	89 55 08             	mov    %edx,0x8(%ebp)
     551:	0f b6 00             	movzbl (%eax),%eax
     554:	0f be c0             	movsbl %al,%eax
     557:	01 c8                	add    %ecx,%eax
     559:	83 e8 30             	sub    $0x30,%eax
     55c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     55f:	8b 45 08             	mov    0x8(%ebp),%eax
     562:	0f b6 00             	movzbl (%eax),%eax
     565:	3c 2f                	cmp    $0x2f,%al
     567:	7e 0a                	jle    573 <atoi+0x48>
     569:	8b 45 08             	mov    0x8(%ebp),%eax
     56c:	0f b6 00             	movzbl (%eax),%eax
     56f:	3c 39                	cmp    $0x39,%al
     571:	7e c7                	jle    53a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     576:	c9                   	leave  
     577:	c3                   	ret    

00000578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     578:	55                   	push   %ebp
     579:	89 e5                	mov    %esp,%ebp
     57b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     57e:	8b 45 08             	mov    0x8(%ebp),%eax
     581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     584:	8b 45 0c             	mov    0xc(%ebp),%eax
     587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     58a:	eb 17                	jmp    5a3 <memmove+0x2b>
    *dst++ = *src++;
     58c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     58f:	8d 50 01             	lea    0x1(%eax),%edx
     592:	89 55 fc             	mov    %edx,-0x4(%ebp)
     595:	8b 55 f8             	mov    -0x8(%ebp),%edx
     598:	8d 4a 01             	lea    0x1(%edx),%ecx
     59b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     59e:	0f b6 12             	movzbl (%edx),%edx
     5a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     5a3:	8b 45 10             	mov    0x10(%ebp),%eax
     5a6:	8d 50 ff             	lea    -0x1(%eax),%edx
     5a9:	89 55 10             	mov    %edx,0x10(%ebp)
     5ac:	85 c0                	test   %eax,%eax
     5ae:	7f dc                	jg     58c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     5b3:	c9                   	leave  
     5b4:	c3                   	ret    

000005b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     5b5:	b8 01 00 00 00       	mov    $0x1,%eax
     5ba:	cd 40                	int    $0x40
     5bc:	c3                   	ret    

000005bd <exit>:
SYSCALL(exit)
     5bd:	b8 02 00 00 00       	mov    $0x2,%eax
     5c2:	cd 40                	int    $0x40
     5c4:	c3                   	ret    

000005c5 <wait>:
SYSCALL(wait)
     5c5:	b8 03 00 00 00       	mov    $0x3,%eax
     5ca:	cd 40                	int    $0x40
     5cc:	c3                   	ret    

000005cd <pipe>:
SYSCALL(pipe)
     5cd:	b8 04 00 00 00       	mov    $0x4,%eax
     5d2:	cd 40                	int    $0x40
     5d4:	c3                   	ret    

000005d5 <read>:
SYSCALL(read)
     5d5:	b8 05 00 00 00       	mov    $0x5,%eax
     5da:	cd 40                	int    $0x40
     5dc:	c3                   	ret    

000005dd <write>:
SYSCALL(write)
     5dd:	b8 10 00 00 00       	mov    $0x10,%eax
     5e2:	cd 40                	int    $0x40
     5e4:	c3                   	ret    

000005e5 <close>:
SYSCALL(close)
     5e5:	b8 15 00 00 00       	mov    $0x15,%eax
     5ea:	cd 40                	int    $0x40
     5ec:	c3                   	ret    

000005ed <kill>:
SYSCALL(kill)
     5ed:	b8 06 00 00 00       	mov    $0x6,%eax
     5f2:	cd 40                	int    $0x40
     5f4:	c3                   	ret    

000005f5 <exec>:
SYSCALL(exec)
     5f5:	b8 07 00 00 00       	mov    $0x7,%eax
     5fa:	cd 40                	int    $0x40
     5fc:	c3                   	ret    

000005fd <open>:
SYSCALL(open)
     5fd:	b8 0f 00 00 00       	mov    $0xf,%eax
     602:	cd 40                	int    $0x40
     604:	c3                   	ret    

00000605 <mknod>:
SYSCALL(mknod)
     605:	b8 11 00 00 00       	mov    $0x11,%eax
     60a:	cd 40                	int    $0x40
     60c:	c3                   	ret    

0000060d <unlink>:
SYSCALL(unlink)
     60d:	b8 12 00 00 00       	mov    $0x12,%eax
     612:	cd 40                	int    $0x40
     614:	c3                   	ret    

00000615 <fstat>:
SYSCALL(fstat)
     615:	b8 08 00 00 00       	mov    $0x8,%eax
     61a:	cd 40                	int    $0x40
     61c:	c3                   	ret    

0000061d <link>:
SYSCALL(link)
     61d:	b8 13 00 00 00       	mov    $0x13,%eax
     622:	cd 40                	int    $0x40
     624:	c3                   	ret    

00000625 <mkdir>:
SYSCALL(mkdir)
     625:	b8 14 00 00 00       	mov    $0x14,%eax
     62a:	cd 40                	int    $0x40
     62c:	c3                   	ret    

0000062d <chdir>:
SYSCALL(chdir)
     62d:	b8 09 00 00 00       	mov    $0x9,%eax
     632:	cd 40                	int    $0x40
     634:	c3                   	ret    

00000635 <dup>:
SYSCALL(dup)
     635:	b8 0a 00 00 00       	mov    $0xa,%eax
     63a:	cd 40                	int    $0x40
     63c:	c3                   	ret    

0000063d <getpid>:
SYSCALL(getpid)
     63d:	b8 0b 00 00 00       	mov    $0xb,%eax
     642:	cd 40                	int    $0x40
     644:	c3                   	ret    

00000645 <sbrk>:
SYSCALL(sbrk)
     645:	b8 0c 00 00 00       	mov    $0xc,%eax
     64a:	cd 40                	int    $0x40
     64c:	c3                   	ret    

0000064d <sleep>:
SYSCALL(sleep)
     64d:	b8 0d 00 00 00       	mov    $0xd,%eax
     652:	cd 40                	int    $0x40
     654:	c3                   	ret    

00000655 <uptime>:
SYSCALL(uptime)
     655:	b8 0e 00 00 00       	mov    $0xe,%eax
     65a:	cd 40                	int    $0x40
     65c:	c3                   	ret    

0000065d <kthread_create>:




SYSCALL(kthread_create)
     65d:	b8 16 00 00 00       	mov    $0x16,%eax
     662:	cd 40                	int    $0x40
     664:	c3                   	ret    

00000665 <kthread_id>:
SYSCALL(kthread_id)
     665:	b8 17 00 00 00       	mov    $0x17,%eax
     66a:	cd 40                	int    $0x40
     66c:	c3                   	ret    

0000066d <kthread_exit>:
SYSCALL(kthread_exit)
     66d:	b8 18 00 00 00       	mov    $0x18,%eax
     672:	cd 40                	int    $0x40
     674:	c3                   	ret    

00000675 <kthread_join>:
SYSCALL(kthread_join)
     675:	b8 19 00 00 00       	mov    $0x19,%eax
     67a:	cd 40                	int    $0x40
     67c:	c3                   	ret    

0000067d <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     67d:	b8 1a 00 00 00       	mov    $0x1a,%eax
     682:	cd 40                	int    $0x40
     684:	c3                   	ret    

00000685 <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     685:	b8 1b 00 00 00       	mov    $0x1b,%eax
     68a:	cd 40                	int    $0x40
     68c:	c3                   	ret    

0000068d <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     68d:	b8 1c 00 00 00       	mov    $0x1c,%eax
     692:	cd 40                	int    $0x40
     694:	c3                   	ret    

00000695 <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     695:	b8 1d 00 00 00       	mov    $0x1d,%eax
     69a:	cd 40                	int    $0x40
     69c:	c3                   	ret    

0000069d <kthread_mutex_yieldlock>:
     69d:	b8 1e 00 00 00       	mov    $0x1e,%eax
     6a2:	cd 40                	int    $0x40
     6a4:	c3                   	ret    

000006a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     6a5:	55                   	push   %ebp
     6a6:	89 e5                	mov    %esp,%ebp
     6a8:	83 ec 18             	sub    $0x18,%esp
     6ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     6ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     6b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     6b8:	00 
     6b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
     6bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c0:	8b 45 08             	mov    0x8(%ebp),%eax
     6c3:	89 04 24             	mov    %eax,(%esp)
     6c6:	e8 12 ff ff ff       	call   5dd <write>
}
     6cb:	c9                   	leave  
     6cc:	c3                   	ret    

000006cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     6cd:	55                   	push   %ebp
     6ce:	89 e5                	mov    %esp,%ebp
     6d0:	56                   	push   %esi
     6d1:	53                   	push   %ebx
     6d2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     6d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     6dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6e0:	74 17                	je     6f9 <printint+0x2c>
     6e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     6e6:	79 11                	jns    6f9 <printint+0x2c>
    neg = 1;
     6e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     6ef:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f2:	f7 d8                	neg    %eax
     6f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6f7:	eb 06                	jmp    6ff <printint+0x32>
  } else {
    x = xx;
     6f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     6fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     6ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     706:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     709:	8d 41 01             	lea    0x1(%ecx),%eax
     70c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     70f:	8b 5d 10             	mov    0x10(%ebp),%ebx
     712:	8b 45 ec             	mov    -0x14(%ebp),%eax
     715:	ba 00 00 00 00       	mov    $0x0,%edx
     71a:	f7 f3                	div    %ebx
     71c:	89 d0                	mov    %edx,%eax
     71e:	0f b6 80 64 18 00 00 	movzbl 0x1864(%eax),%eax
     725:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     729:	8b 75 10             	mov    0x10(%ebp),%esi
     72c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     72f:	ba 00 00 00 00       	mov    $0x0,%edx
     734:	f7 f6                	div    %esi
     736:	89 45 ec             	mov    %eax,-0x14(%ebp)
     739:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     73d:	75 c7                	jne    706 <printint+0x39>
  if(neg)
     73f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     743:	74 10                	je     755 <printint+0x88>
    buf[i++] = '-';
     745:	8b 45 f4             	mov    -0xc(%ebp),%eax
     748:	8d 50 01             	lea    0x1(%eax),%edx
     74b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     74e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     753:	eb 1f                	jmp    774 <printint+0xa7>
     755:	eb 1d                	jmp    774 <printint+0xa7>
    putc(fd, buf[i]);
     757:	8d 55 dc             	lea    -0x24(%ebp),%edx
     75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75d:	01 d0                	add    %edx,%eax
     75f:	0f b6 00             	movzbl (%eax),%eax
     762:	0f be c0             	movsbl %al,%eax
     765:	89 44 24 04          	mov    %eax,0x4(%esp)
     769:	8b 45 08             	mov    0x8(%ebp),%eax
     76c:	89 04 24             	mov    %eax,(%esp)
     76f:	e8 31 ff ff ff       	call   6a5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     774:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     77c:	79 d9                	jns    757 <printint+0x8a>
    putc(fd, buf[i]);
}
     77e:	83 c4 30             	add    $0x30,%esp
     781:	5b                   	pop    %ebx
     782:	5e                   	pop    %esi
     783:	5d                   	pop    %ebp
     784:	c3                   	ret    

00000785 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     785:	55                   	push   %ebp
     786:	89 e5                	mov    %esp,%ebp
     788:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     78b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     792:	8d 45 0c             	lea    0xc(%ebp),%eax
     795:	83 c0 04             	add    $0x4,%eax
     798:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     79b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7a2:	e9 7c 01 00 00       	jmp    923 <printf+0x19e>
    c = fmt[i] & 0xff;
     7a7:	8b 55 0c             	mov    0xc(%ebp),%edx
     7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7ad:	01 d0                	add    %edx,%eax
     7af:	0f b6 00             	movzbl (%eax),%eax
     7b2:	0f be c0             	movsbl %al,%eax
     7b5:	25 ff 00 00 00       	and    $0xff,%eax
     7ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     7bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     7c1:	75 2c                	jne    7ef <printf+0x6a>
      if(c == '%'){
     7c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     7c7:	75 0c                	jne    7d5 <printf+0x50>
        state = '%';
     7c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     7d0:	e9 4a 01 00 00       	jmp    91f <printf+0x19a>
      } else {
        putc(fd, c);
     7d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7d8:	0f be c0             	movsbl %al,%eax
     7db:	89 44 24 04          	mov    %eax,0x4(%esp)
     7df:	8b 45 08             	mov    0x8(%ebp),%eax
     7e2:	89 04 24             	mov    %eax,(%esp)
     7e5:	e8 bb fe ff ff       	call   6a5 <putc>
     7ea:	e9 30 01 00 00       	jmp    91f <printf+0x19a>
      }
    } else if(state == '%'){
     7ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     7f3:	0f 85 26 01 00 00    	jne    91f <printf+0x19a>
      if(c == 'd'){
     7f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     7fd:	75 2d                	jne    82c <printf+0xa7>
        printint(fd, *ap, 10, 1);
     7ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     802:	8b 00                	mov    (%eax),%eax
     804:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     80b:	00 
     80c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     813:	00 
     814:	89 44 24 04          	mov    %eax,0x4(%esp)
     818:	8b 45 08             	mov    0x8(%ebp),%eax
     81b:	89 04 24             	mov    %eax,(%esp)
     81e:	e8 aa fe ff ff       	call   6cd <printint>
        ap++;
     823:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     827:	e9 ec 00 00 00       	jmp    918 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     82c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     830:	74 06                	je     838 <printf+0xb3>
     832:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     836:	75 2d                	jne    865 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     838:	8b 45 e8             	mov    -0x18(%ebp),%eax
     83b:	8b 00                	mov    (%eax),%eax
     83d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     844:	00 
     845:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     84c:	00 
     84d:	89 44 24 04          	mov    %eax,0x4(%esp)
     851:	8b 45 08             	mov    0x8(%ebp),%eax
     854:	89 04 24             	mov    %eax,(%esp)
     857:	e8 71 fe ff ff       	call   6cd <printint>
        ap++;
     85c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     860:	e9 b3 00 00 00       	jmp    918 <printf+0x193>
      } else if(c == 's'){
     865:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     869:	75 45                	jne    8b0 <printf+0x12b>
        s = (char*)*ap;
     86b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     86e:	8b 00                	mov    (%eax),%eax
     870:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     873:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     87b:	75 09                	jne    886 <printf+0x101>
          s = "(null)";
     87d:	c7 45 f4 56 13 00 00 	movl   $0x1356,-0xc(%ebp)
        while(*s != 0){
     884:	eb 1e                	jmp    8a4 <printf+0x11f>
     886:	eb 1c                	jmp    8a4 <printf+0x11f>
          putc(fd, *s);
     888:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88b:	0f b6 00             	movzbl (%eax),%eax
     88e:	0f be c0             	movsbl %al,%eax
     891:	89 44 24 04          	mov    %eax,0x4(%esp)
     895:	8b 45 08             	mov    0x8(%ebp),%eax
     898:	89 04 24             	mov    %eax,(%esp)
     89b:	e8 05 fe ff ff       	call   6a5 <putc>
          s++;
     8a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a7:	0f b6 00             	movzbl (%eax),%eax
     8aa:	84 c0                	test   %al,%al
     8ac:	75 da                	jne    888 <printf+0x103>
     8ae:	eb 68                	jmp    918 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     8b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     8b4:	75 1d                	jne    8d3 <printf+0x14e>
        putc(fd, *ap);
     8b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8b9:	8b 00                	mov    (%eax),%eax
     8bb:	0f be c0             	movsbl %al,%eax
     8be:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c2:	8b 45 08             	mov    0x8(%ebp),%eax
     8c5:	89 04 24             	mov    %eax,(%esp)
     8c8:	e8 d8 fd ff ff       	call   6a5 <putc>
        ap++;
     8cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     8d1:	eb 45                	jmp    918 <printf+0x193>
      } else if(c == '%'){
     8d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     8d7:	75 17                	jne    8f0 <printf+0x16b>
        putc(fd, c);
     8d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8dc:	0f be c0             	movsbl %al,%eax
     8df:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e3:	8b 45 08             	mov    0x8(%ebp),%eax
     8e6:	89 04 24             	mov    %eax,(%esp)
     8e9:	e8 b7 fd ff ff       	call   6a5 <putc>
     8ee:	eb 28                	jmp    918 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     8f0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     8f7:	00 
     8f8:	8b 45 08             	mov    0x8(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 a2 fd ff ff       	call   6a5 <putc>
        putc(fd, c);
     903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     906:	0f be c0             	movsbl %al,%eax
     909:	89 44 24 04          	mov    %eax,0x4(%esp)
     90d:	8b 45 08             	mov    0x8(%ebp),%eax
     910:	89 04 24             	mov    %eax,(%esp)
     913:	e8 8d fd ff ff       	call   6a5 <putc>
      }
      state = 0;
     918:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     91f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     923:	8b 55 0c             	mov    0xc(%ebp),%edx
     926:	8b 45 f0             	mov    -0x10(%ebp),%eax
     929:	01 d0                	add    %edx,%eax
     92b:	0f b6 00             	movzbl (%eax),%eax
     92e:	84 c0                	test   %al,%al
     930:	0f 85 71 fe ff ff    	jne    7a7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     936:	c9                   	leave  
     937:	c3                   	ret    

00000938 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     938:	55                   	push   %ebp
     939:	89 e5                	mov    %esp,%ebp
     93b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     93e:	8b 45 08             	mov    0x8(%ebp),%eax
     941:	83 e8 08             	sub    $0x8,%eax
     944:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     947:	a1 88 18 00 00       	mov    0x1888,%eax
     94c:	89 45 fc             	mov    %eax,-0x4(%ebp)
     94f:	eb 24                	jmp    975 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     951:	8b 45 fc             	mov    -0x4(%ebp),%eax
     954:	8b 00                	mov    (%eax),%eax
     956:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     959:	77 12                	ja     96d <free+0x35>
     95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     95e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     961:	77 24                	ja     987 <free+0x4f>
     963:	8b 45 fc             	mov    -0x4(%ebp),%eax
     966:	8b 00                	mov    (%eax),%eax
     968:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     96b:	77 1a                	ja     987 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     970:	8b 00                	mov    (%eax),%eax
     972:	89 45 fc             	mov    %eax,-0x4(%ebp)
     975:	8b 45 f8             	mov    -0x8(%ebp),%eax
     978:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     97b:	76 d4                	jbe    951 <free+0x19>
     97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     980:	8b 00                	mov    (%eax),%eax
     982:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     985:	76 ca                	jbe    951 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     987:	8b 45 f8             	mov    -0x8(%ebp),%eax
     98a:	8b 40 04             	mov    0x4(%eax),%eax
     98d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     994:	8b 45 f8             	mov    -0x8(%ebp),%eax
     997:	01 c2                	add    %eax,%edx
     999:	8b 45 fc             	mov    -0x4(%ebp),%eax
     99c:	8b 00                	mov    (%eax),%eax
     99e:	39 c2                	cmp    %eax,%edx
     9a0:	75 24                	jne    9c6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     9a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9a5:	8b 50 04             	mov    0x4(%eax),%edx
     9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ab:	8b 00                	mov    (%eax),%eax
     9ad:	8b 40 04             	mov    0x4(%eax),%eax
     9b0:	01 c2                	add    %eax,%edx
     9b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9b5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9bb:	8b 00                	mov    (%eax),%eax
     9bd:	8b 10                	mov    (%eax),%edx
     9bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9c2:	89 10                	mov    %edx,(%eax)
     9c4:	eb 0a                	jmp    9d0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     9c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c9:	8b 10                	mov    (%eax),%edx
     9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9ce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9d3:	8b 40 04             	mov    0x4(%eax),%eax
     9d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9e0:	01 d0                	add    %edx,%eax
     9e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9e5:	75 20                	jne    a07 <free+0xcf>
    p->s.size += bp->s.size;
     9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ea:	8b 50 04             	mov    0x4(%eax),%edx
     9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9f0:	8b 40 04             	mov    0x4(%eax),%eax
     9f3:	01 c2                	add    %eax,%edx
     9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9f8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     9fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9fe:	8b 10                	mov    (%eax),%edx
     a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a03:	89 10                	mov    %edx,(%eax)
     a05:	eb 08                	jmp    a0f <free+0xd7>
  } else
    p->s.ptr = bp;
     a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a0d:	89 10                	mov    %edx,(%eax)
  freep = p;
     a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a12:	a3 88 18 00 00       	mov    %eax,0x1888
}
     a17:	c9                   	leave  
     a18:	c3                   	ret    

00000a19 <morecore>:

static Header*
morecore(uint nu)
{
     a19:	55                   	push   %ebp
     a1a:	89 e5                	mov    %esp,%ebp
     a1c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     a1f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     a26:	77 07                	ja     a2f <morecore+0x16>
    nu = 4096;
     a28:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     a2f:	8b 45 08             	mov    0x8(%ebp),%eax
     a32:	c1 e0 03             	shl    $0x3,%eax
     a35:	89 04 24             	mov    %eax,(%esp)
     a38:	e8 08 fc ff ff       	call   645 <sbrk>
     a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     a40:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     a44:	75 07                	jne    a4d <morecore+0x34>
    return 0;
     a46:	b8 00 00 00 00       	mov    $0x0,%eax
     a4b:	eb 22                	jmp    a6f <morecore+0x56>
  hp = (Header*)p;
     a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a56:	8b 55 08             	mov    0x8(%ebp),%edx
     a59:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a5f:	83 c0 08             	add    $0x8,%eax
     a62:	89 04 24             	mov    %eax,(%esp)
     a65:	e8 ce fe ff ff       	call   938 <free>
  return freep;
     a6a:	a1 88 18 00 00       	mov    0x1888,%eax
}
     a6f:	c9                   	leave  
     a70:	c3                   	ret    

00000a71 <malloc>:

void*
malloc(uint nbytes)
{
     a71:	55                   	push   %ebp
     a72:	89 e5                	mov    %esp,%ebp
     a74:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a77:	8b 45 08             	mov    0x8(%ebp),%eax
     a7a:	83 c0 07             	add    $0x7,%eax
     a7d:	c1 e8 03             	shr    $0x3,%eax
     a80:	83 c0 01             	add    $0x1,%eax
     a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a86:	a1 88 18 00 00       	mov    0x1888,%eax
     a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a92:	75 23                	jne    ab7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a94:	c7 45 f0 80 18 00 00 	movl   $0x1880,-0x10(%ebp)
     a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a9e:	a3 88 18 00 00       	mov    %eax,0x1888
     aa3:	a1 88 18 00 00       	mov    0x1888,%eax
     aa8:	a3 80 18 00 00       	mov    %eax,0x1880
    base.s.size = 0;
     aad:	c7 05 84 18 00 00 00 	movl   $0x0,0x1884
     ab4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aba:	8b 00                	mov    (%eax),%eax
     abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	8b 40 04             	mov    0x4(%eax),%eax
     ac5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ac8:	72 4d                	jb     b17 <malloc+0xa6>
      if(p->s.size == nunits)
     aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     acd:	8b 40 04             	mov    0x4(%eax),%eax
     ad0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ad3:	75 0c                	jne    ae1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad8:	8b 10                	mov    (%eax),%edx
     ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
     add:	89 10                	mov    %edx,(%eax)
     adf:	eb 26                	jmp    b07 <malloc+0x96>
      else {
        p->s.size -= nunits;
     ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ae4:	8b 40 04             	mov    0x4(%eax),%eax
     ae7:	2b 45 ec             	sub    -0x14(%ebp),%eax
     aea:	89 c2                	mov    %eax,%edx
     aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af5:	8b 40 04             	mov    0x4(%eax),%eax
     af8:	c1 e0 03             	shl    $0x3,%eax
     afb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b01:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b04:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b0a:	a3 88 18 00 00       	mov    %eax,0x1888
      return (void*)(p + 1);
     b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b12:	83 c0 08             	add    $0x8,%eax
     b15:	eb 38                	jmp    b4f <malloc+0xde>
    }
    if(p == freep)
     b17:	a1 88 18 00 00       	mov    0x1888,%eax
     b1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b1f:	75 1b                	jne    b3c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b24:	89 04 24             	mov    %eax,(%esp)
     b27:	e8 ed fe ff ff       	call   a19 <morecore>
     b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b33:	75 07                	jne    b3c <malloc+0xcb>
        return 0;
     b35:	b8 00 00 00 00       	mov    $0x0,%eax
     b3a:	eb 13                	jmp    b4f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b45:	8b 00                	mov    (%eax),%eax
     b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     b4a:	e9 70 ff ff ff       	jmp    abf <malloc+0x4e>
}
     b4f:	c9                   	leave  
     b50:	c3                   	ret    

00000b51 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     b51:	55                   	push   %ebp
     b52:	89 e5                	mov    %esp,%ebp
     b54:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     b57:	e8 21 fb ff ff       	call   67d <kthread_mutex_alloc>
     b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     b5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b63:	79 0a                	jns    b6f <mesa_slots_monitor_alloc+0x1e>
		return 0;
     b65:	b8 00 00 00 00       	mov    $0x0,%eax
     b6a:	e9 8b 00 00 00       	jmp    bfa <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     b6f:	e8 44 06 00 00       	call   11b8 <mesa_cond_alloc>
     b74:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b7b:	75 12                	jne    b8f <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b80:	89 04 24             	mov    %eax,(%esp)
     b83:	e8 fd fa ff ff       	call   685 <kthread_mutex_dealloc>
		return 0;
     b88:	b8 00 00 00 00       	mov    $0x0,%eax
     b8d:	eb 6b                	jmp    bfa <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     b8f:	e8 24 06 00 00       	call   11b8 <mesa_cond_alloc>
     b94:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b9b:	75 1d                	jne    bba <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ba0:	89 04 24             	mov    %eax,(%esp)
     ba3:	e8 dd fa ff ff       	call   685 <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bab:	89 04 24             	mov    %eax,(%esp)
     bae:	e8 46 06 00 00       	call   11f9 <mesa_cond_dealloc>
		return 0;
     bb3:	b8 00 00 00 00       	mov    $0x0,%eax
     bb8:	eb 40                	jmp    bfa <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     bba:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     bc1:	e8 ab fe ff ff       	call   a71 <malloc>
     bc6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
     bcf:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bd8:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
     be1:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     be3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     be6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf0:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     bfa:	c9                   	leave  
     bfb:	c3                   	ret    

00000bfc <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     bfc:	55                   	push   %ebp
     bfd:	89 e5                	mov    %esp,%ebp
     bff:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
     c05:	8b 00                	mov    (%eax),%eax
     c07:	89 04 24             	mov    %eax,(%esp)
     c0a:	e8 76 fa ff ff       	call   685 <kthread_mutex_dealloc>
     c0f:	85 c0                	test   %eax,%eax
     c11:	78 2e                	js     c41 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     c13:	8b 45 08             	mov    0x8(%ebp),%eax
     c16:	8b 40 04             	mov    0x4(%eax),%eax
     c19:	89 04 24             	mov    %eax,(%esp)
     c1c:	e8 97 05 00 00       	call   11b8 <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     c21:	8b 45 08             	mov    0x8(%ebp),%eax
     c24:	8b 40 08             	mov    0x8(%eax),%eax
     c27:	89 04 24             	mov    %eax,(%esp)
     c2a:	e8 89 05 00 00       	call   11b8 <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     c2f:	8b 45 08             	mov    0x8(%ebp),%eax
     c32:	89 04 24             	mov    %eax,(%esp)
     c35:	e8 fe fc ff ff       	call   938 <free>
	return 0;
     c3a:	b8 00 00 00 00       	mov    $0x0,%eax
     c3f:	eb 05                	jmp    c46 <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     c46:	c9                   	leave  
     c47:	c3                   	ret    

00000c48 <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     c48:	55                   	push   %ebp
     c49:	89 e5                	mov    %esp,%ebp
     c4b:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     c4e:	8b 45 08             	mov    0x8(%ebp),%eax
     c51:	8b 40 10             	mov    0x10(%eax),%eax
     c54:	85 c0                	test   %eax,%eax
     c56:	75 0a                	jne    c62 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c5d:	e9 81 00 00 00       	jmp    ce3 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c62:	8b 45 08             	mov    0x8(%ebp),%eax
     c65:	8b 00                	mov    (%eax),%eax
     c67:	89 04 24             	mov    %eax,(%esp)
     c6a:	e8 1e fa ff ff       	call   68d <kthread_mutex_lock>
     c6f:	83 f8 ff             	cmp    $0xffffffff,%eax
     c72:	7d 07                	jge    c7b <mesa_slots_monitor_addslots+0x33>
		return -1;
     c74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c79:	eb 68                	jmp    ce3 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     c7b:	eb 17                	jmp    c94 <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     c7d:	8b 45 08             	mov    0x8(%ebp),%eax
     c80:	8b 10                	mov    (%eax),%edx
     c82:	8b 45 08             	mov    0x8(%ebp),%eax
     c85:	8b 40 08             	mov    0x8(%eax),%eax
     c88:	89 54 24 04          	mov    %edx,0x4(%esp)
     c8c:	89 04 24             	mov    %eax,(%esp)
     c8f:	e8 af 05 00 00       	call   1243 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c94:	8b 45 08             	mov    0x8(%ebp),%eax
     c97:	8b 40 10             	mov    0x10(%eax),%eax
     c9a:	85 c0                	test   %eax,%eax
     c9c:	74 0a                	je     ca8 <mesa_slots_monitor_addslots+0x60>
     c9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ca1:	8b 40 0c             	mov    0xc(%eax),%eax
     ca4:	85 c0                	test   %eax,%eax
     ca6:	7f d5                	jg     c7d <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     ca8:	8b 45 08             	mov    0x8(%ebp),%eax
     cab:	8b 40 10             	mov    0x10(%eax),%eax
     cae:	85 c0                	test   %eax,%eax
     cb0:	74 11                	je     cc3 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     cb2:	8b 45 08             	mov    0x8(%ebp),%eax
     cb5:	8b 50 0c             	mov    0xc(%eax),%edx
     cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
     cbb:	01 c2                	add    %eax,%edx
     cbd:	8b 45 08             	mov    0x8(%ebp),%eax
     cc0:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	8b 40 04             	mov    0x4(%eax),%eax
     cc9:	89 04 24             	mov    %eax,(%esp)
     ccc:	e8 dc 05 00 00       	call   12ad <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     cd1:	8b 45 08             	mov    0x8(%ebp),%eax
     cd4:	8b 00                	mov    (%eax),%eax
     cd6:	89 04 24             	mov    %eax,(%esp)
     cd9:	e8 b7 f9 ff ff       	call   695 <kthread_mutex_unlock>

	return 1;
     cde:	b8 01 00 00 00       	mov    $0x1,%eax


}
     ce3:	c9                   	leave  
     ce4:	c3                   	ret    

00000ce5 <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     ce5:	55                   	push   %ebp
     ce6:	89 e5                	mov    %esp,%ebp
     ce8:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     ceb:	8b 45 08             	mov    0x8(%ebp),%eax
     cee:	8b 40 10             	mov    0x10(%eax),%eax
     cf1:	85 c0                	test   %eax,%eax
     cf3:	75 07                	jne    cfc <mesa_slots_monitor_takeslot+0x17>
		return -1;
     cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cfa:	eb 7f                	jmp    d7b <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     cfc:	8b 45 08             	mov    0x8(%ebp),%eax
     cff:	8b 00                	mov    (%eax),%eax
     d01:	89 04 24             	mov    %eax,(%esp)
     d04:	e8 84 f9 ff ff       	call   68d <kthread_mutex_lock>
     d09:	83 f8 ff             	cmp    $0xffffffff,%eax
     d0c:	7d 07                	jge    d15 <mesa_slots_monitor_takeslot+0x30>
		return -1;
     d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d13:	eb 66                	jmp    d7b <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     d15:	eb 17                	jmp    d2e <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     d17:	8b 45 08             	mov    0x8(%ebp),%eax
     d1a:	8b 10                	mov    (%eax),%edx
     d1c:	8b 45 08             	mov    0x8(%ebp),%eax
     d1f:	8b 40 04             	mov    0x4(%eax),%eax
     d22:	89 54 24 04          	mov    %edx,0x4(%esp)
     d26:	89 04 24             	mov    %eax,(%esp)
     d29:	e8 15 05 00 00       	call   1243 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     d2e:	8b 45 08             	mov    0x8(%ebp),%eax
     d31:	8b 40 10             	mov    0x10(%eax),%eax
     d34:	85 c0                	test   %eax,%eax
     d36:	74 0a                	je     d42 <mesa_slots_monitor_takeslot+0x5d>
     d38:	8b 45 08             	mov    0x8(%ebp),%eax
     d3b:	8b 40 0c             	mov    0xc(%eax),%eax
     d3e:	85 c0                	test   %eax,%eax
     d40:	74 d5                	je     d17 <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     d42:	8b 45 08             	mov    0x8(%ebp),%eax
     d45:	8b 40 10             	mov    0x10(%eax),%eax
     d48:	85 c0                	test   %eax,%eax
     d4a:	74 0f                	je     d5b <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     d4c:	8b 45 08             	mov    0x8(%ebp),%eax
     d4f:	8b 40 0c             	mov    0xc(%eax),%eax
     d52:	8d 50 ff             	lea    -0x1(%eax),%edx
     d55:	8b 45 08             	mov    0x8(%ebp),%eax
     d58:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	8b 40 08             	mov    0x8(%eax),%eax
     d61:	89 04 24             	mov    %eax,(%esp)
     d64:	e8 44 05 00 00       	call   12ad <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d69:	8b 45 08             	mov    0x8(%ebp),%eax
     d6c:	8b 00                	mov    (%eax),%eax
     d6e:	89 04 24             	mov    %eax,(%esp)
     d71:	e8 1f f9 ff ff       	call   695 <kthread_mutex_unlock>

	return 1;
     d76:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d7b:	c9                   	leave  
     d7c:	c3                   	ret    

00000d7d <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     d7d:	55                   	push   %ebp
     d7e:	89 e5                	mov    %esp,%ebp
     d80:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d83:	8b 45 08             	mov    0x8(%ebp),%eax
     d86:	8b 40 10             	mov    0x10(%eax),%eax
     d89:	85 c0                	test   %eax,%eax
     d8b:	75 07                	jne    d94 <mesa_slots_monitor_stopadding+0x17>
			return -1;
     d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d92:	eb 35                	jmp    dc9 <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d94:	8b 45 08             	mov    0x8(%ebp),%eax
     d97:	8b 00                	mov    (%eax),%eax
     d99:	89 04 24             	mov    %eax,(%esp)
     d9c:	e8 ec f8 ff ff       	call   68d <kthread_mutex_lock>
     da1:	83 f8 ff             	cmp    $0xffffffff,%eax
     da4:	7d 07                	jge    dad <mesa_slots_monitor_stopadding+0x30>
			return -1;
     da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dab:	eb 1c                	jmp    dc9 <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     dad:	8b 45 08             	mov    0x8(%ebp),%eax
     db0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     db7:	8b 45 08             	mov    0x8(%ebp),%eax
     dba:	8b 00                	mov    (%eax),%eax
     dbc:	89 04 24             	mov    %eax,(%esp)
     dbf:	e8 d1 f8 ff ff       	call   695 <kthread_mutex_unlock>

		return 0;
     dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     dc9:	c9                   	leave  
     dca:	c3                   	ret    

00000dcb <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     dcb:	55                   	push   %ebp
     dcc:	89 e5                	mov    %esp,%ebp
     dce:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     dd1:	e8 a7 f8 ff ff       	call   67d <kthread_mutex_alloc>
     dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ddd:	79 0a                	jns    de9 <hoare_slots_monitor_alloc+0x1e>
		return 0;
     ddf:	b8 00 00 00 00       	mov    $0x0,%eax
     de4:	e9 8b 00 00 00       	jmp    e74 <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     de9:	e8 68 02 00 00       	call   1056 <hoare_cond_alloc>
     dee:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     df5:	75 12                	jne    e09 <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dfa:	89 04 24             	mov    %eax,(%esp)
     dfd:	e8 83 f8 ff ff       	call   685 <kthread_mutex_dealloc>
		return 0;
     e02:	b8 00 00 00 00       	mov    $0x0,%eax
     e07:	eb 6b                	jmp    e74 <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     e09:	e8 48 02 00 00       	call   1056 <hoare_cond_alloc>
     e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     e11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e15:	75 1d                	jne    e34 <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1a:	89 04 24             	mov    %eax,(%esp)
     e1d:	e8 63 f8 ff ff       	call   685 <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e25:	89 04 24             	mov    %eax,(%esp)
     e28:	e8 6a 02 00 00       	call   1097 <hoare_cond_dealloc>
		return 0;
     e2d:	b8 00 00 00 00       	mov    $0x0,%eax
     e32:	eb 40                	jmp    e74 <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     e34:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     e3b:	e8 31 fc ff ff       	call   a71 <malloc>
     e40:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e46:	8b 55 f0             	mov    -0x10(%ebp),%edx
     e49:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     e52:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     e55:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5b:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e6a:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     e71:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     e74:	c9                   	leave  
     e75:	c3                   	ret    

00000e76 <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     e76:	55                   	push   %ebp
     e77:	89 e5                	mov    %esp,%ebp
     e79:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     e7c:	8b 45 08             	mov    0x8(%ebp),%eax
     e7f:	8b 00                	mov    (%eax),%eax
     e81:	89 04 24             	mov    %eax,(%esp)
     e84:	e8 fc f7 ff ff       	call   685 <kthread_mutex_dealloc>
     e89:	85 c0                	test   %eax,%eax
     e8b:	78 2e                	js     ebb <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     e8d:	8b 45 08             	mov    0x8(%ebp),%eax
     e90:	8b 40 04             	mov    0x4(%eax),%eax
     e93:	89 04 24             	mov    %eax,(%esp)
     e96:	e8 bb 01 00 00       	call   1056 <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     e9b:	8b 45 08             	mov    0x8(%ebp),%eax
     e9e:	8b 40 08             	mov    0x8(%eax),%eax
     ea1:	89 04 24             	mov    %eax,(%esp)
     ea4:	e8 ad 01 00 00       	call   1056 <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     ea9:	8b 45 08             	mov    0x8(%ebp),%eax
     eac:	89 04 24             	mov    %eax,(%esp)
     eaf:	e8 84 fa ff ff       	call   938 <free>
	return 0;
     eb4:	b8 00 00 00 00       	mov    $0x0,%eax
     eb9:	eb 05                	jmp    ec0 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     ebb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     ec0:	c9                   	leave  
     ec1:	c3                   	ret    

00000ec2 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     ec2:	55                   	push   %ebp
     ec3:	89 e5                	mov    %esp,%ebp
     ec5:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     ec8:	8b 45 08             	mov    0x8(%ebp),%eax
     ecb:	8b 40 10             	mov    0x10(%eax),%eax
     ece:	85 c0                	test   %eax,%eax
     ed0:	75 0a                	jne    edc <hoare_slots_monitor_addslots+0x1a>
		return -1;
     ed2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ed7:	e9 88 00 00 00       	jmp    f64 <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     edc:	8b 45 08             	mov    0x8(%ebp),%eax
     edf:	8b 00                	mov    (%eax),%eax
     ee1:	89 04 24             	mov    %eax,(%esp)
     ee4:	e8 a4 f7 ff ff       	call   68d <kthread_mutex_lock>
     ee9:	83 f8 ff             	cmp    $0xffffffff,%eax
     eec:	7d 07                	jge    ef5 <hoare_slots_monitor_addslots+0x33>
		return -1;
     eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ef3:	eb 6f                	jmp    f64 <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     ef5:	8b 45 08             	mov    0x8(%ebp),%eax
     ef8:	8b 40 10             	mov    0x10(%eax),%eax
     efb:	85 c0                	test   %eax,%eax
     efd:	74 21                	je     f20 <hoare_slots_monitor_addslots+0x5e>
     eff:	8b 45 08             	mov    0x8(%ebp),%eax
     f02:	8b 40 0c             	mov    0xc(%eax),%eax
     f05:	85 c0                	test   %eax,%eax
     f07:	7e 17                	jle    f20 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     f09:	8b 45 08             	mov    0x8(%ebp),%eax
     f0c:	8b 10                	mov    (%eax),%edx
     f0e:	8b 45 08             	mov    0x8(%ebp),%eax
     f11:	8b 40 08             	mov    0x8(%eax),%eax
     f14:	89 54 24 04          	mov    %edx,0x4(%esp)
     f18:	89 04 24             	mov    %eax,(%esp)
     f1b:	e8 c1 01 00 00       	call   10e1 <hoare_cond_wait>


	if  ( monitor->active)
     f20:	8b 45 08             	mov    0x8(%ebp),%eax
     f23:	8b 40 10             	mov    0x10(%eax),%eax
     f26:	85 c0                	test   %eax,%eax
     f28:	74 11                	je     f3b <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     f2a:	8b 45 08             	mov    0x8(%ebp),%eax
     f2d:	8b 50 0c             	mov    0xc(%eax),%edx
     f30:	8b 45 0c             	mov    0xc(%ebp),%eax
     f33:	01 c2                	add    %eax,%edx
     f35:	8b 45 08             	mov    0x8(%ebp),%eax
     f38:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     f3b:	8b 45 08             	mov    0x8(%ebp),%eax
     f3e:	8b 10                	mov    (%eax),%edx
     f40:	8b 45 08             	mov    0x8(%ebp),%eax
     f43:	8b 40 04             	mov    0x4(%eax),%eax
     f46:	89 54 24 04          	mov    %edx,0x4(%esp)
     f4a:	89 04 24             	mov    %eax,(%esp)
     f4d:	e8 e6 01 00 00       	call   1138 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f52:	8b 45 08             	mov    0x8(%ebp),%eax
     f55:	8b 00                	mov    (%eax),%eax
     f57:	89 04 24             	mov    %eax,(%esp)
     f5a:	e8 36 f7 ff ff       	call   695 <kthread_mutex_unlock>

	return 1;
     f5f:	b8 01 00 00 00       	mov    $0x1,%eax


}
     f64:	c9                   	leave  
     f65:	c3                   	ret    

00000f66 <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     f66:	55                   	push   %ebp
     f67:	89 e5                	mov    %esp,%ebp
     f69:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     f6c:	8b 45 08             	mov    0x8(%ebp),%eax
     f6f:	8b 40 10             	mov    0x10(%eax),%eax
     f72:	85 c0                	test   %eax,%eax
     f74:	75 0a                	jne    f80 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     f76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f7b:	e9 86 00 00 00       	jmp    1006 <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f80:	8b 45 08             	mov    0x8(%ebp),%eax
     f83:	8b 00                	mov    (%eax),%eax
     f85:	89 04 24             	mov    %eax,(%esp)
     f88:	e8 00 f7 ff ff       	call   68d <kthread_mutex_lock>
     f8d:	83 f8 ff             	cmp    $0xffffffff,%eax
     f90:	7d 07                	jge    f99 <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f97:	eb 6d                	jmp    1006 <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f99:	8b 45 08             	mov    0x8(%ebp),%eax
     f9c:	8b 40 10             	mov    0x10(%eax),%eax
     f9f:	85 c0                	test   %eax,%eax
     fa1:	74 21                	je     fc4 <hoare_slots_monitor_takeslot+0x5e>
     fa3:	8b 45 08             	mov    0x8(%ebp),%eax
     fa6:	8b 40 0c             	mov    0xc(%eax),%eax
     fa9:	85 c0                	test   %eax,%eax
     fab:	75 17                	jne    fc4 <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     fad:	8b 45 08             	mov    0x8(%ebp),%eax
     fb0:	8b 10                	mov    (%eax),%edx
     fb2:	8b 45 08             	mov    0x8(%ebp),%eax
     fb5:	8b 40 04             	mov    0x4(%eax),%eax
     fb8:	89 54 24 04          	mov    %edx,0x4(%esp)
     fbc:	89 04 24             	mov    %eax,(%esp)
     fbf:	e8 1d 01 00 00       	call   10e1 <hoare_cond_wait>


	if  ( monitor->active)
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	8b 40 10             	mov    0x10(%eax),%eax
     fca:	85 c0                	test   %eax,%eax
     fcc:	74 0f                	je     fdd <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     fce:	8b 45 08             	mov    0x8(%ebp),%eax
     fd1:	8b 40 0c             	mov    0xc(%eax),%eax
     fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
     fd7:	8b 45 08             	mov    0x8(%ebp),%eax
     fda:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     fdd:	8b 45 08             	mov    0x8(%ebp),%eax
     fe0:	8b 10                	mov    (%eax),%edx
     fe2:	8b 45 08             	mov    0x8(%ebp),%eax
     fe5:	8b 40 08             	mov    0x8(%eax),%eax
     fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
     fec:	89 04 24             	mov    %eax,(%esp)
     fef:	e8 44 01 00 00       	call   1138 <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ff4:	8b 45 08             	mov    0x8(%ebp),%eax
     ff7:	8b 00                	mov    (%eax),%eax
     ff9:	89 04 24             	mov    %eax,(%esp)
     ffc:	e8 94 f6 ff ff       	call   695 <kthread_mutex_unlock>

	return 1;
    1001:	b8 01 00 00 00       	mov    $0x1,%eax

}
    1006:	c9                   	leave  
    1007:	c3                   	ret    

00001008 <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
    1008:	55                   	push   %ebp
    1009:	89 e5                	mov    %esp,%ebp
    100b:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
    100e:	8b 45 08             	mov    0x8(%ebp),%eax
    1011:	8b 40 10             	mov    0x10(%eax),%eax
    1014:	85 c0                	test   %eax,%eax
    1016:	75 07                	jne    101f <hoare_slots_monitor_stopadding+0x17>
			return -1;
    1018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    101d:	eb 35                	jmp    1054 <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    101f:	8b 45 08             	mov    0x8(%ebp),%eax
    1022:	8b 00                	mov    (%eax),%eax
    1024:	89 04 24             	mov    %eax,(%esp)
    1027:	e8 61 f6 ff ff       	call   68d <kthread_mutex_lock>
    102c:	83 f8 ff             	cmp    $0xffffffff,%eax
    102f:	7d 07                	jge    1038 <hoare_slots_monitor_stopadding+0x30>
			return -1;
    1031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1036:	eb 1c                	jmp    1054 <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
    1038:	8b 45 08             	mov    0x8(%ebp),%eax
    103b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
    1042:	8b 45 08             	mov    0x8(%ebp),%eax
    1045:	8b 00                	mov    (%eax),%eax
    1047:	89 04 24             	mov    %eax,(%esp)
    104a:	e8 46 f6 ff ff       	call   695 <kthread_mutex_unlock>

		return 0;
    104f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1054:	c9                   	leave  
    1055:	c3                   	ret    

00001056 <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
    1056:	55                   	push   %ebp
    1057:	89 e5                	mov    %esp,%ebp
    1059:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    105c:	e8 1c f6 ff ff       	call   67d <kthread_mutex_alloc>
    1061:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    1064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1068:	79 07                	jns    1071 <hoare_cond_alloc+0x1b>
		return 0;
    106a:	b8 00 00 00 00       	mov    $0x0,%eax
    106f:	eb 24                	jmp    1095 <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    1071:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1078:	e8 f4 f9 ff ff       	call   a71 <malloc>
    107d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    1080:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1083:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1086:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    1088:	8b 45 f0             	mov    -0x10(%ebp),%eax
    108b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1092:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1095:	c9                   	leave  
    1096:	c3                   	ret    

00001097 <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    1097:	55                   	push   %ebp
    1098:	89 e5                	mov    %esp,%ebp
    109a:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    109d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10a1:	75 07                	jne    10aa <hoare_cond_dealloc+0x13>
			return -1;
    10a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10a8:	eb 35                	jmp    10df <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    10aa:	8b 45 08             	mov    0x8(%ebp),%eax
    10ad:	8b 00                	mov    (%eax),%eax
    10af:	89 04 24             	mov    %eax,(%esp)
    10b2:	e8 de f5 ff ff       	call   695 <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    10b7:	8b 45 08             	mov    0x8(%ebp),%eax
    10ba:	8b 00                	mov    (%eax),%eax
    10bc:	89 04 24             	mov    %eax,(%esp)
    10bf:	e8 c1 f5 ff ff       	call   685 <kthread_mutex_dealloc>
    10c4:	85 c0                	test   %eax,%eax
    10c6:	79 07                	jns    10cf <hoare_cond_dealloc+0x38>
			return -1;
    10c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10cd:	eb 10                	jmp    10df <hoare_cond_dealloc+0x48>

		free (hCond);
    10cf:	8b 45 08             	mov    0x8(%ebp),%eax
    10d2:	89 04 24             	mov    %eax,(%esp)
    10d5:	e8 5e f8 ff ff       	call   938 <free>
		return 0;
    10da:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10df:	c9                   	leave  
    10e0:	c3                   	ret    

000010e1 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    10e1:	55                   	push   %ebp
    10e2:	89 e5                	mov    %esp,%ebp
    10e4:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10eb:	75 07                	jne    10f4 <hoare_cond_wait+0x13>
			return -1;
    10ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10f2:	eb 42                	jmp    1136 <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    10f4:	8b 45 08             	mov    0x8(%ebp),%eax
    10f7:	8b 40 04             	mov    0x4(%eax),%eax
    10fa:	8d 50 01             	lea    0x1(%eax),%edx
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1100:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	8b 00                	mov    (%eax),%eax
    1108:	89 44 24 04          	mov    %eax,0x4(%esp)
    110c:	8b 45 0c             	mov    0xc(%ebp),%eax
    110f:	89 04 24             	mov    %eax,(%esp)
    1112:	e8 86 f5 ff ff       	call   69d <kthread_mutex_yieldlock>
    1117:	85 c0                	test   %eax,%eax
    1119:	79 16                	jns    1131 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	8b 40 04             	mov    0x4(%eax),%eax
    1121:	8d 50 ff             	lea    -0x1(%eax),%edx
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    112a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    112f:	eb 05                	jmp    1136 <hoare_cond_wait+0x55>
		}

	return 0;
    1131:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1136:	c9                   	leave  
    1137:	c3                   	ret    

00001138 <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    1138:	55                   	push   %ebp
    1139:	89 e5                	mov    %esp,%ebp
    113b:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    113e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1142:	75 07                	jne    114b <hoare_cond_signal+0x13>
		return -1;
    1144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1149:	eb 6b                	jmp    11b6 <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    114b:	8b 45 08             	mov    0x8(%ebp),%eax
    114e:	8b 40 04             	mov    0x4(%eax),%eax
    1151:	85 c0                	test   %eax,%eax
    1153:	7e 3d                	jle    1192 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    1155:	8b 45 08             	mov    0x8(%ebp),%eax
    1158:	8b 40 04             	mov    0x4(%eax),%eax
    115b:	8d 50 ff             	lea    -0x1(%eax),%edx
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	8b 00                	mov    (%eax),%eax
    1169:	89 44 24 04          	mov    %eax,0x4(%esp)
    116d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1170:	89 04 24             	mov    %eax,(%esp)
    1173:	e8 25 f5 ff ff       	call   69d <kthread_mutex_yieldlock>
    1178:	85 c0                	test   %eax,%eax
    117a:	79 16                	jns    1192 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	8b 40 04             	mov    0x4(%eax),%eax
    1182:	8d 50 01             	lea    0x1(%eax),%edx
    1185:	8b 45 08             	mov    0x8(%ebp),%eax
    1188:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    118b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1190:	eb 24                	jmp    11b6 <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1192:	8b 45 08             	mov    0x8(%ebp),%eax
    1195:	8b 00                	mov    (%eax),%eax
    1197:	89 44 24 04          	mov    %eax,0x4(%esp)
    119b:	8b 45 0c             	mov    0xc(%ebp),%eax
    119e:	89 04 24             	mov    %eax,(%esp)
    11a1:	e8 f7 f4 ff ff       	call   69d <kthread_mutex_yieldlock>
    11a6:	85 c0                	test   %eax,%eax
    11a8:	79 07                	jns    11b1 <hoare_cond_signal+0x79>

    			return -1;
    11aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11af:	eb 05                	jmp    11b6 <hoare_cond_signal+0x7e>
    }

	return 0;
    11b1:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11b6:	c9                   	leave  
    11b7:	c3                   	ret    

000011b8 <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    11b8:	55                   	push   %ebp
    11b9:	89 e5                	mov    %esp,%ebp
    11bb:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    11be:	e8 ba f4 ff ff       	call   67d <kthread_mutex_alloc>
    11c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    11c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ca:	79 07                	jns    11d3 <mesa_cond_alloc+0x1b>
		return 0;
    11cc:	b8 00 00 00 00       	mov    $0x0,%eax
    11d1:	eb 24                	jmp    11f7 <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    11d3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    11da:	e8 92 f8 ff ff       	call   a71 <malloc>
    11df:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    11e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e8:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    11ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    11f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    

000011f9 <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    11ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1203:	75 07                	jne    120c <mesa_cond_dealloc+0x13>
		return -1;
    1205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    120a:	eb 35                	jmp    1241 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	8b 00                	mov    (%eax),%eax
    1211:	89 04 24             	mov    %eax,(%esp)
    1214:	e8 7c f4 ff ff       	call   695 <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    1219:	8b 45 08             	mov    0x8(%ebp),%eax
    121c:	8b 00                	mov    (%eax),%eax
    121e:	89 04 24             	mov    %eax,(%esp)
    1221:	e8 5f f4 ff ff       	call   685 <kthread_mutex_dealloc>
    1226:	85 c0                	test   %eax,%eax
    1228:	79 07                	jns    1231 <mesa_cond_dealloc+0x38>
		return -1;
    122a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    122f:	eb 10                	jmp    1241 <mesa_cond_dealloc+0x48>

	free (mCond);
    1231:	8b 45 08             	mov    0x8(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 fc f6 ff ff       	call   938 <free>
	return 0;
    123c:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1241:	c9                   	leave  
    1242:	c3                   	ret    

00001243 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    1243:	55                   	push   %ebp
    1244:	89 e5                	mov    %esp,%ebp
    1246:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    1249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    124d:	75 07                	jne    1256 <mesa_cond_wait+0x13>
		return -1;
    124f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1254:	eb 55                	jmp    12ab <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    1256:	8b 45 08             	mov    0x8(%ebp),%eax
    1259:	8b 40 04             	mov    0x4(%eax),%eax
    125c:	8d 50 01             	lea    0x1(%eax),%edx
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1265:	8b 45 0c             	mov    0xc(%ebp),%eax
    1268:	89 04 24             	mov    %eax,(%esp)
    126b:	e8 25 f4 ff ff       	call   695 <kthread_mutex_unlock>
    1270:	85 c0                	test   %eax,%eax
    1272:	79 27                	jns    129b <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    1274:	8b 45 08             	mov    0x8(%ebp),%eax
    1277:	8b 00                	mov    (%eax),%eax
    1279:	89 04 24             	mov    %eax,(%esp)
    127c:	e8 0c f4 ff ff       	call   68d <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1281:	85 c0                	test   %eax,%eax
    1283:	79 16                	jns    129b <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    1285:	8b 45 08             	mov    0x8(%ebp),%eax
    1288:	8b 40 04             	mov    0x4(%eax),%eax
    128b:	8d 50 ff             	lea    -0x1(%eax),%edx
    128e:	8b 45 08             	mov    0x8(%ebp),%eax
    1291:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    1294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1299:	eb 10                	jmp    12ab <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    129b:	8b 45 0c             	mov    0xc(%ebp),%eax
    129e:	89 04 24             	mov    %eax,(%esp)
    12a1:	e8 e7 f3 ff ff       	call   68d <kthread_mutex_lock>
	return 0;
    12a6:	b8 00 00 00 00       	mov    $0x0,%eax


}
    12ab:	c9                   	leave  
    12ac:	c3                   	ret    

000012ad <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    12ad:	55                   	push   %ebp
    12ae:	89 e5                	mov    %esp,%ebp
    12b0:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    12b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12b7:	75 07                	jne    12c0 <mesa_cond_signal+0x13>
		return -1;
    12b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12be:	eb 5d                	jmp    131d <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    12c0:	8b 45 08             	mov    0x8(%ebp),%eax
    12c3:	8b 40 04             	mov    0x4(%eax),%eax
    12c6:	85 c0                	test   %eax,%eax
    12c8:	7e 36                	jle    1300 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    12ca:	8b 45 08             	mov    0x8(%ebp),%eax
    12cd:	8b 40 04             	mov    0x4(%eax),%eax
    12d0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12d3:	8b 45 08             	mov    0x8(%ebp),%eax
    12d6:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    12d9:	8b 45 08             	mov    0x8(%ebp),%eax
    12dc:	8b 00                	mov    (%eax),%eax
    12de:	89 04 24             	mov    %eax,(%esp)
    12e1:	e8 af f3 ff ff       	call   695 <kthread_mutex_unlock>
    12e6:	85 c0                	test   %eax,%eax
    12e8:	78 16                	js     1300 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    12ea:	8b 45 08             	mov    0x8(%ebp),%eax
    12ed:	8b 40 04             	mov    0x4(%eax),%eax
    12f0:	8d 50 01             	lea    0x1(%eax),%edx
    12f3:	8b 45 08             	mov    0x8(%ebp),%eax
    12f6:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    12f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12fe:	eb 1d                	jmp    131d <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1300:	8b 45 08             	mov    0x8(%ebp),%eax
    1303:	8b 00                	mov    (%eax),%eax
    1305:	89 04 24             	mov    %eax,(%esp)
    1308:	e8 88 f3 ff ff       	call   695 <kthread_mutex_unlock>
    130d:	85 c0                	test   %eax,%eax
    130f:	79 07                	jns    1318 <mesa_cond_signal+0x6b>

		return -1;
    1311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1316:	eb 05                	jmp    131d <mesa_cond_signal+0x70>
	}
	return 0;
    1318:	b8 00 00 00 00       	mov    $0x0,%eax

}
    131d:	c9                   	leave  
    131e:	c3                   	ret    
