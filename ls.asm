
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       7:	8b 45 08             	mov    0x8(%ebp),%eax
       a:	89 04 24             	mov    %eax,(%esp)
       d:	e8 dd 03 00 00       	call   3ef <strlen>
      12:	8b 55 08             	mov    0x8(%ebp),%edx
      15:	01 d0                	add    %edx,%eax
      17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      1a:	eb 04                	jmp    20 <fmtname+0x20>
      1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
      20:	8b 45 f4             	mov    -0xc(%ebp),%eax
      23:	3b 45 08             	cmp    0x8(%ebp),%eax
      26:	72 0a                	jb     32 <fmtname+0x32>
      28:	8b 45 f4             	mov    -0xc(%ebp),%eax
      2b:	0f b6 00             	movzbl (%eax),%eax
      2e:	3c 2f                	cmp    $0x2f,%al
      30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
      32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	89 04 24             	mov    %eax,(%esp)
      3c:	e8 ae 03 00 00       	call   3ef <strlen>
      41:	83 f8 0d             	cmp    $0xd,%eax
      44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
      46:	8b 45 f4             	mov    -0xc(%ebp),%eax
      49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	89 04 24             	mov    %eax,(%esp)
      51:	e8 99 03 00 00       	call   3ef <strlen>
      56:	89 44 24 08          	mov    %eax,0x8(%esp)
      5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5d:	89 44 24 04          	mov    %eax,0x4(%esp)
      61:	c7 04 24 64 18 00 00 	movl   $0x1864,(%esp)
      68:	e8 11 05 00 00       	call   57e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      70:	89 04 24             	mov    %eax,(%esp)
      73:	e8 77 03 00 00       	call   3ef <strlen>
      78:	ba 0e 00 00 00       	mov    $0xe,%edx
      7d:	89 d3                	mov    %edx,%ebx
      7f:	29 c3                	sub    %eax,%ebx
      81:	8b 45 f4             	mov    -0xc(%ebp),%eax
      84:	89 04 24             	mov    %eax,(%esp)
      87:	e8 63 03 00 00       	call   3ef <strlen>
      8c:	05 64 18 00 00       	add    $0x1864,%eax
      91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
      95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
      9c:	00 
      9d:	89 04 24             	mov    %eax,(%esp)
      a0:	e8 71 03 00 00       	call   416 <memset>
  return buf;
      a5:	b8 64 18 00 00       	mov    $0x1864,%eax
}
      aa:	83 c4 24             	add    $0x24,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	57                   	push   %edi
      b4:	56                   	push   %esi
      b5:	53                   	push   %ebx
      b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
      bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      c3:	00 
      c4:	8b 45 08             	mov    0x8(%ebp),%eax
      c7:	89 04 24             	mov    %eax,(%esp)
      ca:	e8 34 05 00 00       	call   603 <open>
      cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
      d8:	8b 45 08             	mov    0x8(%ebp),%eax
      db:	89 44 24 08          	mov    %eax,0x8(%esp)
      df:	c7 44 24 04 25 13 00 	movl   $0x1325,0x4(%esp)
      e6:	00 
      e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      ee:	e8 98 06 00 00       	call   78b <printf>
    return;
      f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
      f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
      fe:	89 44 24 04          	mov    %eax,0x4(%esp)
     102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     105:	89 04 24             	mov    %eax,(%esp)
     108:	e8 0e 05 00 00       	call   61b <fstat>
     10d:	85 c0                	test   %eax,%eax
     10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
     111:	8b 45 08             	mov    0x8(%ebp),%eax
     114:	89 44 24 08          	mov    %eax,0x8(%esp)
     118:	c7 44 24 04 39 13 00 	movl   $0x1339,0x4(%esp)
     11f:	00 
     120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     127:	e8 5f 06 00 00       	call   78b <printf>
    close(fd);
     12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     12f:	89 04 24             	mov    %eax,(%esp)
     132:	e8 b4 04 00 00       	call   5eb <close>
    return;
     137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }
  
  switch(st.type){
     13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     143:	98                   	cwtl   
     144:	83 f8 01             	cmp    $0x1,%eax
     147:	74 53                	je     19c <ls+0xec>
     149:	83 f8 02             	cmp    $0x2,%eax
     14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
     152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     165:	0f bf d8             	movswl %ax,%ebx
     168:	8b 45 08             	mov    0x8(%ebp),%eax
     16b:	89 04 24             	mov    %eax,(%esp)
     16e:	e8 8d fe ff ff       	call   0 <fmtname>
     173:	89 7c 24 14          	mov    %edi,0x14(%esp)
     177:	89 74 24 10          	mov    %esi,0x10(%esp)
     17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     17f:	89 44 24 08          	mov    %eax,0x8(%esp)
     183:	c7 44 24 04 4d 13 00 	movl   $0x134d,0x4(%esp)
     18a:	00 
     18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     192:	e8 f4 05 00 00       	call   78b <printf>
    break;
     197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     19c:	8b 45 08             	mov    0x8(%ebp),%eax
     19f:	89 04 24             	mov    %eax,(%esp)
     1a2:	e8 48 02 00 00       	call   3ef <strlen>
     1a7:	83 c0 10             	add    $0x10,%eax
     1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
     1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
     1b1:	c7 44 24 04 5a 13 00 	movl   $0x135a,0x4(%esp)
     1b8:	00 
     1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c0:	e8 c6 05 00 00       	call   78b <printf>
      break;
     1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
     1ca:	8b 45 08             	mov    0x8(%ebp),%eax
     1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
     1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1d7:	89 04 24             	mov    %eax,(%esp)
     1da:	e8 a1 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
     1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1e5:	89 04 24             	mov    %eax,(%esp)
     1e8:	e8 02 02 00 00       	call   3ef <strlen>
     1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
     1f3:	01 d0                	add    %edx,%eax
     1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
     1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1fb:	8d 50 01             	lea    0x1(%eax),%edx
     1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
     201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
     209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
     210:	66 85 c0             	test   %ax,%ax
     213:	75 05                	jne    21a <ls+0x16a>
        continue;
     215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
     21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
     221:	00 
     222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     228:	83 c0 02             	add    $0x2,%eax
     22b:	89 44 24 04          	mov    %eax,0x4(%esp)
     22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     232:	89 04 24             	mov    %eax,(%esp)
     235:	e8 44 03 00 00       	call   57e <memmove>
      p[DIRSIZ] = 0;
     23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     23d:	83 c0 0e             	add    $0xe,%eax
     240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
     243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
     249:	89 44 24 04          	mov    %eax,0x4(%esp)
     24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 88 02 00 00       	call   4e3 <stat>
     25b:	85 c0                	test   %eax,%eax
     25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
     25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     265:	89 44 24 08          	mov    %eax,0x8(%esp)
     269:	c7 44 24 04 39 13 00 	movl   $0x1339,0x4(%esp)
     270:	00 
     271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     278:	e8 0e 05 00 00       	call   78b <printf>
        continue;
     27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     292:	0f bf d8             	movswl %ax,%ebx
     295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     29b:	89 04 24             	mov    %eax,(%esp)
     29e:	e8 5d fd ff ff       	call   0 <fmtname>
     2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
     2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
     2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     2af:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b3:	c7 44 24 04 4d 13 00 	movl   $0x134d,0x4(%esp)
     2ba:	00 
     2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c2:	e8 c4 04 00 00       	call   78b <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     2ce:	00 
     2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
     2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2dc:	89 04 24             	mov    %eax,(%esp)
     2df:	e8 f7 02 00 00       	call   5db <read>
     2e4:	83 f8 10             	cmp    $0x10,%eax
     2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
     2ed:	90                   	nop
  }
  close(fd);
     2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2f1:	89 04 24             	mov    %eax,(%esp)
     2f4:	e8 f2 02 00 00       	call   5eb <close>
}
     2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
     2ff:	5b                   	pop    %ebx
     300:	5e                   	pop    %esi
     301:	5f                   	pop    %edi
     302:	5d                   	pop    %ebp
     303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
     304:	55                   	push   %ebp
     305:	89 e5                	mov    %esp,%ebp
     307:	83 e4 f0             	and    $0xfffffff0,%esp
     30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
     30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     311:	7f 11                	jg     324 <main+0x20>
    ls(".");
     313:	c7 04 24 6d 13 00 00 	movl   $0x136d,(%esp)
     31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
     31f:	e8 9f 02 00 00       	call   5c3 <exit>
  }
  for(i=1; i<argc; i++)
     324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     32b:	00 
     32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
     32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     339:	8b 45 0c             	mov    0xc(%ebp),%eax
     33c:	01 d0                	add    %edx,%eax
     33e:	8b 00                	mov    (%eax),%eax
     340:	89 04 24             	mov    %eax,(%esp)
     343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
     348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     351:	3b 45 08             	cmp    0x8(%ebp),%eax
     354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
     356:	e8 68 02 00 00       	call   5c3 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     35b:	55                   	push   %ebp
     35c:	89 e5                	mov    %esp,%ebp
     35e:	57                   	push   %edi
     35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     360:	8b 4d 08             	mov    0x8(%ebp),%ecx
     363:	8b 55 10             	mov    0x10(%ebp),%edx
     366:	8b 45 0c             	mov    0xc(%ebp),%eax
     369:	89 cb                	mov    %ecx,%ebx
     36b:	89 df                	mov    %ebx,%edi
     36d:	89 d1                	mov    %edx,%ecx
     36f:	fc                   	cld    
     370:	f3 aa                	rep stos %al,%es:(%edi)
     372:	89 ca                	mov    %ecx,%edx
     374:	89 fb                	mov    %edi,%ebx
     376:	89 5d 08             	mov    %ebx,0x8(%ebp)
     379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     37c:	5b                   	pop    %ebx
     37d:	5f                   	pop    %edi
     37e:	5d                   	pop    %ebp
     37f:	c3                   	ret    

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     386:	8b 45 08             	mov    0x8(%ebp),%eax
     389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     38c:	90                   	nop
     38d:	8b 45 08             	mov    0x8(%ebp),%eax
     390:	8d 50 01             	lea    0x1(%eax),%edx
     393:	89 55 08             	mov    %edx,0x8(%ebp)
     396:	8b 55 0c             	mov    0xc(%ebp),%edx
     399:	8d 4a 01             	lea    0x1(%edx),%ecx
     39c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     39f:	0f b6 12             	movzbl (%edx),%edx
     3a2:	88 10                	mov    %dl,(%eax)
     3a4:	0f b6 00             	movzbl (%eax),%eax
     3a7:	84 c0                	test   %al,%al
     3a9:	75 e2                	jne    38d <strcpy+0xd>
    ;
  return os;
     3ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3ae:	c9                   	leave  
     3af:	c3                   	ret    

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     3b3:	eb 08                	jmp    3bd <strcmp+0xd>
    p++, q++;
     3b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	0f b6 00             	movzbl (%eax),%eax
     3c3:	84 c0                	test   %al,%al
     3c5:	74 10                	je     3d7 <strcmp+0x27>
     3c7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ca:	0f b6 10             	movzbl (%eax),%edx
     3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
     3d0:	0f b6 00             	movzbl (%eax),%eax
     3d3:	38 c2                	cmp    %al,%dl
     3d5:	74 de                	je     3b5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3d7:	8b 45 08             	mov    0x8(%ebp),%eax
     3da:	0f b6 00             	movzbl (%eax),%eax
     3dd:	0f b6 d0             	movzbl %al,%edx
     3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e3:	0f b6 00             	movzbl (%eax),%eax
     3e6:	0f b6 c0             	movzbl %al,%eax
     3e9:	29 c2                	sub    %eax,%edx
     3eb:	89 d0                	mov    %edx,%eax
}
     3ed:	5d                   	pop    %ebp
     3ee:	c3                   	ret    

000003ef <strlen>:

uint
strlen(char *s)
{
     3ef:	55                   	push   %ebp
     3f0:	89 e5                	mov    %esp,%ebp
     3f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3fc:	eb 04                	jmp    402 <strlen+0x13>
     3fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     402:	8b 55 fc             	mov    -0x4(%ebp),%edx
     405:	8b 45 08             	mov    0x8(%ebp),%eax
     408:	01 d0                	add    %edx,%eax
     40a:	0f b6 00             	movzbl (%eax),%eax
     40d:	84 c0                	test   %al,%al
     40f:	75 ed                	jne    3fe <strlen+0xf>
    ;
  return n;
     411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     414:	c9                   	leave  
     415:	c3                   	ret    

00000416 <memset>:

void*
memset(void *dst, int c, uint n)
{
     416:	55                   	push   %ebp
     417:	89 e5                	mov    %esp,%ebp
     419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     41c:	8b 45 10             	mov    0x10(%ebp),%eax
     41f:	89 44 24 08          	mov    %eax,0x8(%esp)
     423:	8b 45 0c             	mov    0xc(%ebp),%eax
     426:	89 44 24 04          	mov    %eax,0x4(%esp)
     42a:	8b 45 08             	mov    0x8(%ebp),%eax
     42d:	89 04 24             	mov    %eax,(%esp)
     430:	e8 26 ff ff ff       	call   35b <stosb>
  return dst;
     435:	8b 45 08             	mov    0x8(%ebp),%eax
}
     438:	c9                   	leave  
     439:	c3                   	ret    

0000043a <strchr>:

char*
strchr(const char *s, char c)
{
     43a:	55                   	push   %ebp
     43b:	89 e5                	mov    %esp,%ebp
     43d:	83 ec 04             	sub    $0x4,%esp
     440:	8b 45 0c             	mov    0xc(%ebp),%eax
     443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     446:	eb 14                	jmp    45c <strchr+0x22>
    if(*s == c)
     448:	8b 45 08             	mov    0x8(%ebp),%eax
     44b:	0f b6 00             	movzbl (%eax),%eax
     44e:	3a 45 fc             	cmp    -0x4(%ebp),%al
     451:	75 05                	jne    458 <strchr+0x1e>
      return (char*)s;
     453:	8b 45 08             	mov    0x8(%ebp),%eax
     456:	eb 13                	jmp    46b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     45c:	8b 45 08             	mov    0x8(%ebp),%eax
     45f:	0f b6 00             	movzbl (%eax),%eax
     462:	84 c0                	test   %al,%al
     464:	75 e2                	jne    448 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     466:	b8 00 00 00 00       	mov    $0x0,%eax
}
     46b:	c9                   	leave  
     46c:	c3                   	ret    

0000046d <gets>:

char*
gets(char *buf, int max)
{
     46d:	55                   	push   %ebp
     46e:	89 e5                	mov    %esp,%ebp
     470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     47a:	eb 4c                	jmp    4c8 <gets+0x5b>
    cc = read(0, &c, 1);
     47c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     483:	00 
     484:	8d 45 ef             	lea    -0x11(%ebp),%eax
     487:	89 44 24 04          	mov    %eax,0x4(%esp)
     48b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     492:	e8 44 01 00 00       	call   5db <read>
     497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     49a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     49e:	7f 02                	jg     4a2 <gets+0x35>
      break;
     4a0:	eb 31                	jmp    4d3 <gets+0x66>
    buf[i++] = c;
     4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a5:	8d 50 01             	lea    0x1(%eax),%edx
     4a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4ab:	89 c2                	mov    %eax,%edx
     4ad:	8b 45 08             	mov    0x8(%ebp),%eax
     4b0:	01 c2                	add    %eax,%edx
     4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4bc:	3c 0a                	cmp    $0xa,%al
     4be:	74 13                	je     4d3 <gets+0x66>
     4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4c4:	3c 0d                	cmp    $0xd,%al
     4c6:	74 0b                	je     4d3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4cb:	83 c0 01             	add    $0x1,%eax
     4ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4d1:	7c a9                	jl     47c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     4d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d6:	8b 45 08             	mov    0x8(%ebp),%eax
     4d9:	01 d0                	add    %edx,%eax
     4db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     4de:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4e1:	c9                   	leave  
     4e2:	c3                   	ret    

000004e3 <stat>:

int
stat(char *n, struct stat *st)
{
     4e3:	55                   	push   %ebp
     4e4:	89 e5                	mov    %esp,%ebp
     4e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4f0:	00 
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
     4f4:	89 04 24             	mov    %eax,(%esp)
     4f7:	e8 07 01 00 00       	call   603 <open>
     4fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     503:	79 07                	jns    50c <stat+0x29>
    return -1;
     505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     50a:	eb 23                	jmp    52f <stat+0x4c>
  r = fstat(fd, st);
     50c:	8b 45 0c             	mov    0xc(%ebp),%eax
     50f:	89 44 24 04          	mov    %eax,0x4(%esp)
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	89 04 24             	mov    %eax,(%esp)
     519:	e8 fd 00 00 00       	call   61b <fstat>
     51e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     521:	8b 45 f4             	mov    -0xc(%ebp),%eax
     524:	89 04 24             	mov    %eax,(%esp)
     527:	e8 bf 00 00 00       	call   5eb <close>
  return r;
     52c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     52f:	c9                   	leave  
     530:	c3                   	ret    

00000531 <atoi>:

int
atoi(const char *s)
{
     531:	55                   	push   %ebp
     532:	89 e5                	mov    %esp,%ebp
     534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     53e:	eb 25                	jmp    565 <atoi+0x34>
    n = n*10 + *s++ - '0';
     540:	8b 55 fc             	mov    -0x4(%ebp),%edx
     543:	89 d0                	mov    %edx,%eax
     545:	c1 e0 02             	shl    $0x2,%eax
     548:	01 d0                	add    %edx,%eax
     54a:	01 c0                	add    %eax,%eax
     54c:	89 c1                	mov    %eax,%ecx
     54e:	8b 45 08             	mov    0x8(%ebp),%eax
     551:	8d 50 01             	lea    0x1(%eax),%edx
     554:	89 55 08             	mov    %edx,0x8(%ebp)
     557:	0f b6 00             	movzbl (%eax),%eax
     55a:	0f be c0             	movsbl %al,%eax
     55d:	01 c8                	add    %ecx,%eax
     55f:	83 e8 30             	sub    $0x30,%eax
     562:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     565:	8b 45 08             	mov    0x8(%ebp),%eax
     568:	0f b6 00             	movzbl (%eax),%eax
     56b:	3c 2f                	cmp    $0x2f,%al
     56d:	7e 0a                	jle    579 <atoi+0x48>
     56f:	8b 45 08             	mov    0x8(%ebp),%eax
     572:	0f b6 00             	movzbl (%eax),%eax
     575:	3c 39                	cmp    $0x39,%al
     577:	7e c7                	jle    540 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     57c:	c9                   	leave  
     57d:	c3                   	ret    

0000057e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     584:	8b 45 08             	mov    0x8(%ebp),%eax
     587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     58a:	8b 45 0c             	mov    0xc(%ebp),%eax
     58d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     590:	eb 17                	jmp    5a9 <memmove+0x2b>
    *dst++ = *src++;
     592:	8b 45 fc             	mov    -0x4(%ebp),%eax
     595:	8d 50 01             	lea    0x1(%eax),%edx
     598:	89 55 fc             	mov    %edx,-0x4(%ebp)
     59b:	8b 55 f8             	mov    -0x8(%ebp),%edx
     59e:	8d 4a 01             	lea    0x1(%edx),%ecx
     5a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     5a4:	0f b6 12             	movzbl (%edx),%edx
     5a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     5a9:	8b 45 10             	mov    0x10(%ebp),%eax
     5ac:	8d 50 ff             	lea    -0x1(%eax),%edx
     5af:	89 55 10             	mov    %edx,0x10(%ebp)
     5b2:	85 c0                	test   %eax,%eax
     5b4:	7f dc                	jg     592 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     5b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     5b9:	c9                   	leave  
     5ba:	c3                   	ret    

000005bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     5bb:	b8 01 00 00 00       	mov    $0x1,%eax
     5c0:	cd 40                	int    $0x40
     5c2:	c3                   	ret    

000005c3 <exit>:
SYSCALL(exit)
     5c3:	b8 02 00 00 00       	mov    $0x2,%eax
     5c8:	cd 40                	int    $0x40
     5ca:	c3                   	ret    

000005cb <wait>:
SYSCALL(wait)
     5cb:	b8 03 00 00 00       	mov    $0x3,%eax
     5d0:	cd 40                	int    $0x40
     5d2:	c3                   	ret    

000005d3 <pipe>:
SYSCALL(pipe)
     5d3:	b8 04 00 00 00       	mov    $0x4,%eax
     5d8:	cd 40                	int    $0x40
     5da:	c3                   	ret    

000005db <read>:
SYSCALL(read)
     5db:	b8 05 00 00 00       	mov    $0x5,%eax
     5e0:	cd 40                	int    $0x40
     5e2:	c3                   	ret    

000005e3 <write>:
SYSCALL(write)
     5e3:	b8 10 00 00 00       	mov    $0x10,%eax
     5e8:	cd 40                	int    $0x40
     5ea:	c3                   	ret    

000005eb <close>:
SYSCALL(close)
     5eb:	b8 15 00 00 00       	mov    $0x15,%eax
     5f0:	cd 40                	int    $0x40
     5f2:	c3                   	ret    

000005f3 <kill>:
SYSCALL(kill)
     5f3:	b8 06 00 00 00       	mov    $0x6,%eax
     5f8:	cd 40                	int    $0x40
     5fa:	c3                   	ret    

000005fb <exec>:
SYSCALL(exec)
     5fb:	b8 07 00 00 00       	mov    $0x7,%eax
     600:	cd 40                	int    $0x40
     602:	c3                   	ret    

00000603 <open>:
SYSCALL(open)
     603:	b8 0f 00 00 00       	mov    $0xf,%eax
     608:	cd 40                	int    $0x40
     60a:	c3                   	ret    

0000060b <mknod>:
SYSCALL(mknod)
     60b:	b8 11 00 00 00       	mov    $0x11,%eax
     610:	cd 40                	int    $0x40
     612:	c3                   	ret    

00000613 <unlink>:
SYSCALL(unlink)
     613:	b8 12 00 00 00       	mov    $0x12,%eax
     618:	cd 40                	int    $0x40
     61a:	c3                   	ret    

0000061b <fstat>:
SYSCALL(fstat)
     61b:	b8 08 00 00 00       	mov    $0x8,%eax
     620:	cd 40                	int    $0x40
     622:	c3                   	ret    

00000623 <link>:
SYSCALL(link)
     623:	b8 13 00 00 00       	mov    $0x13,%eax
     628:	cd 40                	int    $0x40
     62a:	c3                   	ret    

0000062b <mkdir>:
SYSCALL(mkdir)
     62b:	b8 14 00 00 00       	mov    $0x14,%eax
     630:	cd 40                	int    $0x40
     632:	c3                   	ret    

00000633 <chdir>:
SYSCALL(chdir)
     633:	b8 09 00 00 00       	mov    $0x9,%eax
     638:	cd 40                	int    $0x40
     63a:	c3                   	ret    

0000063b <dup>:
SYSCALL(dup)
     63b:	b8 0a 00 00 00       	mov    $0xa,%eax
     640:	cd 40                	int    $0x40
     642:	c3                   	ret    

00000643 <getpid>:
SYSCALL(getpid)
     643:	b8 0b 00 00 00       	mov    $0xb,%eax
     648:	cd 40                	int    $0x40
     64a:	c3                   	ret    

0000064b <sbrk>:
SYSCALL(sbrk)
     64b:	b8 0c 00 00 00       	mov    $0xc,%eax
     650:	cd 40                	int    $0x40
     652:	c3                   	ret    

00000653 <sleep>:
SYSCALL(sleep)
     653:	b8 0d 00 00 00       	mov    $0xd,%eax
     658:	cd 40                	int    $0x40
     65a:	c3                   	ret    

0000065b <uptime>:
SYSCALL(uptime)
     65b:	b8 0e 00 00 00       	mov    $0xe,%eax
     660:	cd 40                	int    $0x40
     662:	c3                   	ret    

00000663 <kthread_create>:




SYSCALL(kthread_create)
     663:	b8 16 00 00 00       	mov    $0x16,%eax
     668:	cd 40                	int    $0x40
     66a:	c3                   	ret    

0000066b <kthread_id>:
SYSCALL(kthread_id)
     66b:	b8 17 00 00 00       	mov    $0x17,%eax
     670:	cd 40                	int    $0x40
     672:	c3                   	ret    

00000673 <kthread_exit>:
SYSCALL(kthread_exit)
     673:	b8 18 00 00 00       	mov    $0x18,%eax
     678:	cd 40                	int    $0x40
     67a:	c3                   	ret    

0000067b <kthread_join>:
SYSCALL(kthread_join)
     67b:	b8 19 00 00 00       	mov    $0x19,%eax
     680:	cd 40                	int    $0x40
     682:	c3                   	ret    

00000683 <kthread_mutex_alloc>:

SYSCALL(kthread_mutex_alloc)
     683:	b8 1a 00 00 00       	mov    $0x1a,%eax
     688:	cd 40                	int    $0x40
     68a:	c3                   	ret    

0000068b <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
     68b:	b8 1b 00 00 00       	mov    $0x1b,%eax
     690:	cd 40                	int    $0x40
     692:	c3                   	ret    

00000693 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
     693:	b8 1c 00 00 00       	mov    $0x1c,%eax
     698:	cd 40                	int    $0x40
     69a:	c3                   	ret    

0000069b <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
     69b:	b8 1d 00 00 00       	mov    $0x1d,%eax
     6a0:	cd 40                	int    $0x40
     6a2:	c3                   	ret    

000006a3 <kthread_mutex_yieldlock>:
     6a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
     6a8:	cd 40                	int    $0x40
     6aa:	c3                   	ret    

000006ab <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     6ab:	55                   	push   %ebp
     6ac:	89 e5                	mov    %esp,%ebp
     6ae:	83 ec 18             	sub    $0x18,%esp
     6b1:	8b 45 0c             	mov    0xc(%ebp),%eax
     6b4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     6b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     6be:	00 
     6bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
     6c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c6:	8b 45 08             	mov    0x8(%ebp),%eax
     6c9:	89 04 24             	mov    %eax,(%esp)
     6cc:	e8 12 ff ff ff       	call   5e3 <write>
}
     6d1:	c9                   	leave  
     6d2:	c3                   	ret    

000006d3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     6d3:	55                   	push   %ebp
     6d4:	89 e5                	mov    %esp,%ebp
     6d6:	56                   	push   %esi
     6d7:	53                   	push   %ebx
     6d8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     6db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     6e2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6e6:	74 17                	je     6ff <printint+0x2c>
     6e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     6ec:	79 11                	jns    6ff <printint+0x2c>
    neg = 1;
     6ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     6f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f8:	f7 d8                	neg    %eax
     6fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6fd:	eb 06                	jmp    705 <printint+0x32>
  } else {
    x = xx;
     6ff:	8b 45 0c             	mov    0xc(%ebp),%eax
     702:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     705:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     70c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     70f:	8d 41 01             	lea    0x1(%ecx),%eax
     712:	89 45 f4             	mov    %eax,-0xc(%ebp)
     715:	8b 5d 10             	mov    0x10(%ebp),%ebx
     718:	8b 45 ec             	mov    -0x14(%ebp),%eax
     71b:	ba 00 00 00 00       	mov    $0x0,%edx
     720:	f7 f3                	div    %ebx
     722:	89 d0                	mov    %edx,%eax
     724:	0f b6 80 50 18 00 00 	movzbl 0x1850(%eax),%eax
     72b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     72f:	8b 75 10             	mov    0x10(%ebp),%esi
     732:	8b 45 ec             	mov    -0x14(%ebp),%eax
     735:	ba 00 00 00 00       	mov    $0x0,%edx
     73a:	f7 f6                	div    %esi
     73c:	89 45 ec             	mov    %eax,-0x14(%ebp)
     73f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     743:	75 c7                	jne    70c <printint+0x39>
  if(neg)
     745:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     749:	74 10                	je     75b <printint+0x88>
    buf[i++] = '-';
     74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74e:	8d 50 01             	lea    0x1(%eax),%edx
     751:	89 55 f4             	mov    %edx,-0xc(%ebp)
     754:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     759:	eb 1f                	jmp    77a <printint+0xa7>
     75b:	eb 1d                	jmp    77a <printint+0xa7>
    putc(fd, buf[i]);
     75d:	8d 55 dc             	lea    -0x24(%ebp),%edx
     760:	8b 45 f4             	mov    -0xc(%ebp),%eax
     763:	01 d0                	add    %edx,%eax
     765:	0f b6 00             	movzbl (%eax),%eax
     768:	0f be c0             	movsbl %al,%eax
     76b:	89 44 24 04          	mov    %eax,0x4(%esp)
     76f:	8b 45 08             	mov    0x8(%ebp),%eax
     772:	89 04 24             	mov    %eax,(%esp)
     775:	e8 31 ff ff ff       	call   6ab <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     77a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     77e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     782:	79 d9                	jns    75d <printint+0x8a>
    putc(fd, buf[i]);
}
     784:	83 c4 30             	add    $0x30,%esp
     787:	5b                   	pop    %ebx
     788:	5e                   	pop    %esi
     789:	5d                   	pop    %ebp
     78a:	c3                   	ret    

0000078b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     78b:	55                   	push   %ebp
     78c:	89 e5                	mov    %esp,%ebp
     78e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     791:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     798:	8d 45 0c             	lea    0xc(%ebp),%eax
     79b:	83 c0 04             	add    $0x4,%eax
     79e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     7a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7a8:	e9 7c 01 00 00       	jmp    929 <printf+0x19e>
    c = fmt[i] & 0xff;
     7ad:	8b 55 0c             	mov    0xc(%ebp),%edx
     7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7b3:	01 d0                	add    %edx,%eax
     7b5:	0f b6 00             	movzbl (%eax),%eax
     7b8:	0f be c0             	movsbl %al,%eax
     7bb:	25 ff 00 00 00       	and    $0xff,%eax
     7c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     7c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     7c7:	75 2c                	jne    7f5 <printf+0x6a>
      if(c == '%'){
     7c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     7cd:	75 0c                	jne    7db <printf+0x50>
        state = '%';
     7cf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     7d6:	e9 4a 01 00 00       	jmp    925 <printf+0x19a>
      } else {
        putc(fd, c);
     7db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7de:	0f be c0             	movsbl %al,%eax
     7e1:	89 44 24 04          	mov    %eax,0x4(%esp)
     7e5:	8b 45 08             	mov    0x8(%ebp),%eax
     7e8:	89 04 24             	mov    %eax,(%esp)
     7eb:	e8 bb fe ff ff       	call   6ab <putc>
     7f0:	e9 30 01 00 00       	jmp    925 <printf+0x19a>
      }
    } else if(state == '%'){
     7f5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     7f9:	0f 85 26 01 00 00    	jne    925 <printf+0x19a>
      if(c == 'd'){
     7ff:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     803:	75 2d                	jne    832 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     805:	8b 45 e8             	mov    -0x18(%ebp),%eax
     808:	8b 00                	mov    (%eax),%eax
     80a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     811:	00 
     812:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     819:	00 
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 aa fe ff ff       	call   6d3 <printint>
        ap++;
     829:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     82d:	e9 ec 00 00 00       	jmp    91e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     832:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     836:	74 06                	je     83e <printf+0xb3>
     838:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     83c:	75 2d                	jne    86b <printf+0xe0>
        printint(fd, *ap, 16, 0);
     83e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     841:	8b 00                	mov    (%eax),%eax
     843:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     84a:	00 
     84b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     852:	00 
     853:	89 44 24 04          	mov    %eax,0x4(%esp)
     857:	8b 45 08             	mov    0x8(%ebp),%eax
     85a:	89 04 24             	mov    %eax,(%esp)
     85d:	e8 71 fe ff ff       	call   6d3 <printint>
        ap++;
     862:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     866:	e9 b3 00 00 00       	jmp    91e <printf+0x193>
      } else if(c == 's'){
     86b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     86f:	75 45                	jne    8b6 <printf+0x12b>
        s = (char*)*ap;
     871:	8b 45 e8             	mov    -0x18(%ebp),%eax
     874:	8b 00                	mov    (%eax),%eax
     876:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     879:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     87d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     881:	75 09                	jne    88c <printf+0x101>
          s = "(null)";
     883:	c7 45 f4 6f 13 00 00 	movl   $0x136f,-0xc(%ebp)
        while(*s != 0){
     88a:	eb 1e                	jmp    8aa <printf+0x11f>
     88c:	eb 1c                	jmp    8aa <printf+0x11f>
          putc(fd, *s);
     88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     891:	0f b6 00             	movzbl (%eax),%eax
     894:	0f be c0             	movsbl %al,%eax
     897:	89 44 24 04          	mov    %eax,0x4(%esp)
     89b:	8b 45 08             	mov    0x8(%ebp),%eax
     89e:	89 04 24             	mov    %eax,(%esp)
     8a1:	e8 05 fe ff ff       	call   6ab <putc>
          s++;
     8a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ad:	0f b6 00             	movzbl (%eax),%eax
     8b0:	84 c0                	test   %al,%al
     8b2:	75 da                	jne    88e <printf+0x103>
     8b4:	eb 68                	jmp    91e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     8b6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     8ba:	75 1d                	jne    8d9 <printf+0x14e>
        putc(fd, *ap);
     8bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8bf:	8b 00                	mov    (%eax),%eax
     8c1:	0f be c0             	movsbl %al,%eax
     8c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c8:	8b 45 08             	mov    0x8(%ebp),%eax
     8cb:	89 04 24             	mov    %eax,(%esp)
     8ce:	e8 d8 fd ff ff       	call   6ab <putc>
        ap++;
     8d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     8d7:	eb 45                	jmp    91e <printf+0x193>
      } else if(c == '%'){
     8d9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     8dd:	75 17                	jne    8f6 <printf+0x16b>
        putc(fd, c);
     8df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8e2:	0f be c0             	movsbl %al,%eax
     8e5:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e9:	8b 45 08             	mov    0x8(%ebp),%eax
     8ec:	89 04 24             	mov    %eax,(%esp)
     8ef:	e8 b7 fd ff ff       	call   6ab <putc>
     8f4:	eb 28                	jmp    91e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     8f6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     8fd:	00 
     8fe:	8b 45 08             	mov    0x8(%ebp),%eax
     901:	89 04 24             	mov    %eax,(%esp)
     904:	e8 a2 fd ff ff       	call   6ab <putc>
        putc(fd, c);
     909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     90c:	0f be c0             	movsbl %al,%eax
     90f:	89 44 24 04          	mov    %eax,0x4(%esp)
     913:	8b 45 08             	mov    0x8(%ebp),%eax
     916:	89 04 24             	mov    %eax,(%esp)
     919:	e8 8d fd ff ff       	call   6ab <putc>
      }
      state = 0;
     91e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     925:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     929:	8b 55 0c             	mov    0xc(%ebp),%edx
     92c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     92f:	01 d0                	add    %edx,%eax
     931:	0f b6 00             	movzbl (%eax),%eax
     934:	84 c0                	test   %al,%al
     936:	0f 85 71 fe ff ff    	jne    7ad <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     93c:	c9                   	leave  
     93d:	c3                   	ret    

0000093e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     93e:	55                   	push   %ebp
     93f:	89 e5                	mov    %esp,%ebp
     941:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     944:	8b 45 08             	mov    0x8(%ebp),%eax
     947:	83 e8 08             	sub    $0x8,%eax
     94a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     94d:	a1 7c 18 00 00       	mov    0x187c,%eax
     952:	89 45 fc             	mov    %eax,-0x4(%ebp)
     955:	eb 24                	jmp    97b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     957:	8b 45 fc             	mov    -0x4(%ebp),%eax
     95a:	8b 00                	mov    (%eax),%eax
     95c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     95f:	77 12                	ja     973 <free+0x35>
     961:	8b 45 f8             	mov    -0x8(%ebp),%eax
     964:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     967:	77 24                	ja     98d <free+0x4f>
     969:	8b 45 fc             	mov    -0x4(%ebp),%eax
     96c:	8b 00                	mov    (%eax),%eax
     96e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     971:	77 1a                	ja     98d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     973:	8b 45 fc             	mov    -0x4(%ebp),%eax
     976:	8b 00                	mov    (%eax),%eax
     978:	89 45 fc             	mov    %eax,-0x4(%ebp)
     97b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     97e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     981:	76 d4                	jbe    957 <free+0x19>
     983:	8b 45 fc             	mov    -0x4(%ebp),%eax
     986:	8b 00                	mov    (%eax),%eax
     988:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     98b:	76 ca                	jbe    957 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     990:	8b 40 04             	mov    0x4(%eax),%eax
     993:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     99a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     99d:	01 c2                	add    %eax,%edx
     99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a2:	8b 00                	mov    (%eax),%eax
     9a4:	39 c2                	cmp    %eax,%edx
     9a6:	75 24                	jne    9cc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     9a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9ab:	8b 50 04             	mov    0x4(%eax),%edx
     9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9b1:	8b 00                	mov    (%eax),%eax
     9b3:	8b 40 04             	mov    0x4(%eax),%eax
     9b6:	01 c2                	add    %eax,%edx
     9b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9bb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     9be:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c1:	8b 00                	mov    (%eax),%eax
     9c3:	8b 10                	mov    (%eax),%edx
     9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9c8:	89 10                	mov    %edx,(%eax)
     9ca:	eb 0a                	jmp    9d6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9cf:	8b 10                	mov    (%eax),%edx
     9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9d4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9d9:	8b 40 04             	mov    0x4(%eax),%eax
     9dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9e6:	01 d0                	add    %edx,%eax
     9e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9eb:	75 20                	jne    a0d <free+0xcf>
    p->s.size += bp->s.size;
     9ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9f0:	8b 50 04             	mov    0x4(%eax),%edx
     9f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9f6:	8b 40 04             	mov    0x4(%eax),%eax
     9f9:	01 c2                	add    %eax,%edx
     9fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9fe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     a01:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a04:	8b 10                	mov    (%eax),%edx
     a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a09:	89 10                	mov    %edx,(%eax)
     a0b:	eb 08                	jmp    a15 <free+0xd7>
  } else
    p->s.ptr = bp;
     a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a10:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a13:	89 10                	mov    %edx,(%eax)
  freep = p;
     a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a18:	a3 7c 18 00 00       	mov    %eax,0x187c
}
     a1d:	c9                   	leave  
     a1e:	c3                   	ret    

00000a1f <morecore>:

static Header*
morecore(uint nu)
{
     a1f:	55                   	push   %ebp
     a20:	89 e5                	mov    %esp,%ebp
     a22:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     a25:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     a2c:	77 07                	ja     a35 <morecore+0x16>
    nu = 4096;
     a2e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     a35:	8b 45 08             	mov    0x8(%ebp),%eax
     a38:	c1 e0 03             	shl    $0x3,%eax
     a3b:	89 04 24             	mov    %eax,(%esp)
     a3e:	e8 08 fc ff ff       	call   64b <sbrk>
     a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     a46:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     a4a:	75 07                	jne    a53 <morecore+0x34>
    return 0;
     a4c:	b8 00 00 00 00       	mov    $0x0,%eax
     a51:	eb 22                	jmp    a75 <morecore+0x56>
  hp = (Header*)p;
     a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a5c:	8b 55 08             	mov    0x8(%ebp),%edx
     a5f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a65:	83 c0 08             	add    $0x8,%eax
     a68:	89 04 24             	mov    %eax,(%esp)
     a6b:	e8 ce fe ff ff       	call   93e <free>
  return freep;
     a70:	a1 7c 18 00 00       	mov    0x187c,%eax
}
     a75:	c9                   	leave  
     a76:	c3                   	ret    

00000a77 <malloc>:

void*
malloc(uint nbytes)
{
     a77:	55                   	push   %ebp
     a78:	89 e5                	mov    %esp,%ebp
     a7a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a7d:	8b 45 08             	mov    0x8(%ebp),%eax
     a80:	83 c0 07             	add    $0x7,%eax
     a83:	c1 e8 03             	shr    $0x3,%eax
     a86:	83 c0 01             	add    $0x1,%eax
     a89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a8c:	a1 7c 18 00 00       	mov    0x187c,%eax
     a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a98:	75 23                	jne    abd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a9a:	c7 45 f0 74 18 00 00 	movl   $0x1874,-0x10(%ebp)
     aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aa4:	a3 7c 18 00 00       	mov    %eax,0x187c
     aa9:	a1 7c 18 00 00       	mov    0x187c,%eax
     aae:	a3 74 18 00 00       	mov    %eax,0x1874
    base.s.size = 0;
     ab3:	c7 05 78 18 00 00 00 	movl   $0x0,0x1878
     aba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac0:	8b 00                	mov    (%eax),%eax
     ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac8:	8b 40 04             	mov    0x4(%eax),%eax
     acb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ace:	72 4d                	jb     b1d <malloc+0xa6>
      if(p->s.size == nunits)
     ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad3:	8b 40 04             	mov    0x4(%eax),%eax
     ad6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ad9:	75 0c                	jne    ae7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ade:	8b 10                	mov    (%eax),%edx
     ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ae3:	89 10                	mov    %edx,(%eax)
     ae5:	eb 26                	jmp    b0d <malloc+0x96>
      else {
        p->s.size -= nunits;
     ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aea:	8b 40 04             	mov    0x4(%eax),%eax
     aed:	2b 45 ec             	sub    -0x14(%ebp),%eax
     af0:	89 c2                	mov    %eax,%edx
     af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     afb:	8b 40 04             	mov    0x4(%eax),%eax
     afe:	c1 e0 03             	shl    $0x3,%eax
     b01:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b0a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b10:	a3 7c 18 00 00       	mov    %eax,0x187c
      return (void*)(p + 1);
     b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b18:	83 c0 08             	add    $0x8,%eax
     b1b:	eb 38                	jmp    b55 <malloc+0xde>
    }
    if(p == freep)
     b1d:	a1 7c 18 00 00       	mov    0x187c,%eax
     b22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b25:	75 1b                	jne    b42 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b2a:	89 04 24             	mov    %eax,(%esp)
     b2d:	e8 ed fe ff ff       	call   a1f <morecore>
     b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b39:	75 07                	jne    b42 <malloc+0xcb>
        return 0;
     b3b:	b8 00 00 00 00       	mov    $0x0,%eax
     b40:	eb 13                	jmp    b55 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b4b:	8b 00                	mov    (%eax),%eax
     b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     b50:	e9 70 ff ff ff       	jmp    ac5 <malloc+0x4e>
}
     b55:	c9                   	leave  
     b56:	c3                   	ret    

00000b57 <mesa_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



mesa_slots_monitor_t* mesa_slots_monitor_alloc(){
     b57:	55                   	push   %ebp
     b58:	89 e5                	mov    %esp,%ebp
     b5a:	83 ec 28             	sub    $0x28,%esp

	int mutex=  kthread_mutex_alloc() ;
     b5d:	e8 21 fb ff ff       	call   683 <kthread_mutex_alloc>
     b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if( mutex < 0)
     b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b69:	79 0a                	jns    b75 <mesa_slots_monitor_alloc+0x1e>
		return 0;
     b6b:	b8 00 00 00 00       	mov    $0x0,%eax
     b70:	e9 8b 00 00 00       	jmp    c00 <mesa_slots_monitor_alloc+0xa9>

	struct mesa_cond * empty = mesa_cond_alloc();
     b75:	e8 44 06 00 00       	call   11be <mesa_cond_alloc>
     b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b81:	75 12                	jne    b95 <mesa_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b86:	89 04 24             	mov    %eax,(%esp)
     b89:	e8 fd fa ff ff       	call   68b <kthread_mutex_dealloc>
		return 0;
     b8e:	b8 00 00 00 00       	mov    $0x0,%eax
     b93:	eb 6b                	jmp    c00 <mesa_slots_monitor_alloc+0xa9>
	}

	struct mesa_cond * full = mesa_cond_alloc();
     b95:	e8 24 06 00 00       	call   11be <mesa_cond_alloc>
     b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (full == 0){
     b9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ba1:	75 1d                	jne    bc0 <mesa_slots_monitor_alloc+0x69>
		kthread_mutex_dealloc(mutex);
     ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ba6:	89 04 24             	mov    %eax,(%esp)
     ba9:	e8 dd fa ff ff       	call   68b <kthread_mutex_dealloc>
		mesa_cond_dealloc(empty);
     bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bb1:	89 04 24             	mov    %eax,(%esp)
     bb4:	e8 46 06 00 00       	call   11ff <mesa_cond_dealloc>
		return 0;
     bb9:	b8 00 00 00 00       	mov    $0x0,%eax
     bbe:	eb 40                	jmp    c00 <mesa_slots_monitor_alloc+0xa9>
	}

    mesa_slots_monitor_t * monitor= malloc (sizeof (mesa_slots_monitor_t));
     bc0:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     bc7:	e8 ab fe ff ff       	call   a77 <malloc>
     bcc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
     bd5:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bde:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     be7:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf6:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     c00:	c9                   	leave  
     c01:	c3                   	ret    

00000c02 <mesa_slots_monitor_dealloc>:


int mesa_slots_monitor_dealloc(mesa_slots_monitor_t* monitor){
     c02:	55                   	push   %ebp
     c03:	89 e5                	mov    %esp,%ebp
     c05:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     c08:	8b 45 08             	mov    0x8(%ebp),%eax
     c0b:	8b 00                	mov    (%eax),%eax
     c0d:	89 04 24             	mov    %eax,(%esp)
     c10:	e8 76 fa ff ff       	call   68b <kthread_mutex_dealloc>
     c15:	85 c0                	test   %eax,%eax
     c17:	78 2e                	js     c47 <mesa_slots_monitor_dealloc+0x45>
	    mesa_cond_alloc(monitor->empty)<0 				 ||
     c19:	8b 45 08             	mov    0x8(%ebp),%eax
     c1c:	8b 40 04             	mov    0x4(%eax),%eax
     c1f:	89 04 24             	mov    %eax,(%esp)
     c22:	e8 97 05 00 00       	call   11be <mesa_cond_alloc>
		mesa_cond_alloc(monitor->full)<0
     c27:	8b 45 08             	mov    0x8(%ebp),%eax
     c2a:	8b 40 08             	mov    0x8(%eax),%eax
     c2d:	89 04 24             	mov    %eax,(%esp)
     c30:	e8 89 05 00 00       	call   11be <mesa_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     c35:	8b 45 08             	mov    0x8(%ebp),%eax
     c38:	89 04 24             	mov    %eax,(%esp)
     c3b:	e8 fe fc ff ff       	call   93e <free>
	return 0;
     c40:	b8 00 00 00 00       	mov    $0x0,%eax
     c45:	eb 05                	jmp    c4c <mesa_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    mesa_cond_alloc(monitor->empty)<0 				 ||
		mesa_cond_alloc(monitor->full)<0
		){
			return -1;
     c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     c4c:	c9                   	leave  
     c4d:	c3                   	ret    

00000c4e <mesa_slots_monitor_addslots>:

int mesa_slots_monitor_addslots(mesa_slots_monitor_t* monitor,int n){
     c4e:	55                   	push   %ebp
     c4f:	89 e5                	mov    %esp,%ebp
     c51:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     c54:	8b 45 08             	mov    0x8(%ebp),%eax
     c57:	8b 40 10             	mov    0x10(%eax),%eax
     c5a:	85 c0                	test   %eax,%eax
     c5c:	75 0a                	jne    c68 <mesa_slots_monitor_addslots+0x1a>
		return -1;
     c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c63:	e9 81 00 00 00       	jmp    ce9 <mesa_slots_monitor_addslots+0x9b>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     c68:	8b 45 08             	mov    0x8(%ebp),%eax
     c6b:	8b 00                	mov    (%eax),%eax
     c6d:	89 04 24             	mov    %eax,(%esp)
     c70:	e8 1e fa ff ff       	call   693 <kthread_mutex_lock>
     c75:	83 f8 ff             	cmp    $0xffffffff,%eax
     c78:	7d 07                	jge    c81 <mesa_slots_monitor_addslots+0x33>
		return -1;
     c7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c7f:	eb 68                	jmp    ce9 <mesa_slots_monitor_addslots+0x9b>

	while ( monitor->active && monitor->slots > 0 )
     c81:	eb 17                	jmp    c9a <mesa_slots_monitor_addslots+0x4c>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);
     c83:	8b 45 08             	mov    0x8(%ebp),%eax
     c86:	8b 10                	mov    (%eax),%edx
     c88:	8b 45 08             	mov    0x8(%ebp),%eax
     c8b:	8b 40 08             	mov    0x8(%eax),%eax
     c8e:	89 54 24 04          	mov    %edx,0x4(%esp)
     c92:	89 04 24             	mov    %eax,(%esp)
     c95:	e8 af 05 00 00       	call   1249 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots > 0 )
     c9a:	8b 45 08             	mov    0x8(%ebp),%eax
     c9d:	8b 40 10             	mov    0x10(%eax),%eax
     ca0:	85 c0                	test   %eax,%eax
     ca2:	74 0a                	je     cae <mesa_slots_monitor_addslots+0x60>
     ca4:	8b 45 08             	mov    0x8(%ebp),%eax
     ca7:	8b 40 0c             	mov    0xc(%eax),%eax
     caa:	85 c0                	test   %eax,%eax
     cac:	7f d5                	jg     c83 <mesa_slots_monitor_addslots+0x35>
				mesa_cond_wait( monitor->full, monitor->Monitormutex);


	if  ( monitor->active)
     cae:	8b 45 08             	mov    0x8(%ebp),%eax
     cb1:	8b 40 10             	mov    0x10(%eax),%eax
     cb4:	85 c0                	test   %eax,%eax
     cb6:	74 11                	je     cc9 <mesa_slots_monitor_addslots+0x7b>
			monitor->slots+= n;
     cb8:	8b 45 08             	mov    0x8(%ebp),%eax
     cbb:	8b 50 0c             	mov    0xc(%eax),%edx
     cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
     cc1:	01 c2                	add    %eax,%edx
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->empty);
     cc9:	8b 45 08             	mov    0x8(%ebp),%eax
     ccc:	8b 40 04             	mov    0x4(%eax),%eax
     ccf:	89 04 24             	mov    %eax,(%esp)
     cd2:	e8 dc 05 00 00       	call   12b3 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     cd7:	8b 45 08             	mov    0x8(%ebp),%eax
     cda:	8b 00                	mov    (%eax),%eax
     cdc:	89 04 24             	mov    %eax,(%esp)
     cdf:	e8 b7 f9 ff ff       	call   69b <kthread_mutex_unlock>

	return 1;
     ce4:	b8 01 00 00 00       	mov    $0x1,%eax


}
     ce9:	c9                   	leave  
     cea:	c3                   	ret    

00000ceb <mesa_slots_monitor_takeslot>:


int mesa_slots_monitor_takeslot(mesa_slots_monitor_t* monitor){
     ceb:	55                   	push   %ebp
     cec:	89 e5                	mov    %esp,%ebp
     cee:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     cf1:	8b 45 08             	mov    0x8(%ebp),%eax
     cf4:	8b 40 10             	mov    0x10(%eax),%eax
     cf7:	85 c0                	test   %eax,%eax
     cf9:	75 07                	jne    d02 <mesa_slots_monitor_takeslot+0x17>
		return -1;
     cfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d00:	eb 7f                	jmp    d81 <mesa_slots_monitor_takeslot+0x96>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d02:	8b 45 08             	mov    0x8(%ebp),%eax
     d05:	8b 00                	mov    (%eax),%eax
     d07:	89 04 24             	mov    %eax,(%esp)
     d0a:	e8 84 f9 ff ff       	call   693 <kthread_mutex_lock>
     d0f:	83 f8 ff             	cmp    $0xffffffff,%eax
     d12:	7d 07                	jge    d1b <mesa_slots_monitor_takeslot+0x30>
		return -1;
     d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d19:	eb 66                	jmp    d81 <mesa_slots_monitor_takeslot+0x96>

	while ( monitor->active && monitor->slots == 0 )
     d1b:	eb 17                	jmp    d34 <mesa_slots_monitor_takeslot+0x49>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);
     d1d:	8b 45 08             	mov    0x8(%ebp),%eax
     d20:	8b 10                	mov    (%eax),%edx
     d22:	8b 45 08             	mov    0x8(%ebp),%eax
     d25:	8b 40 04             	mov    0x4(%eax),%eax
     d28:	89 54 24 04          	mov    %edx,0x4(%esp)
     d2c:	89 04 24             	mov    %eax,(%esp)
     d2f:	e8 15 05 00 00       	call   1249 <mesa_cond_wait>
		return -1;

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
		return -1;

	while ( monitor->active && monitor->slots == 0 )
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
     d37:	8b 40 10             	mov    0x10(%eax),%eax
     d3a:	85 c0                	test   %eax,%eax
     d3c:	74 0a                	je     d48 <mesa_slots_monitor_takeslot+0x5d>
     d3e:	8b 45 08             	mov    0x8(%ebp),%eax
     d41:	8b 40 0c             	mov    0xc(%eax),%eax
     d44:	85 c0                	test   %eax,%eax
     d46:	74 d5                	je     d1d <mesa_slots_monitor_takeslot+0x32>
				mesa_cond_wait( monitor->empty, monitor->Monitormutex);


	if  ( monitor->active)
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	8b 40 10             	mov    0x10(%eax),%eax
     d4e:	85 c0                	test   %eax,%eax
     d50:	74 0f                	je     d61 <mesa_slots_monitor_takeslot+0x76>
			monitor->slots--;
     d52:	8b 45 08             	mov    0x8(%ebp),%eax
     d55:	8b 40 0c             	mov    0xc(%eax),%eax
     d58:	8d 50 ff             	lea    -0x1(%eax),%edx
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	89 50 0c             	mov    %edx,0xc(%eax)

	mesa_cond_signal(monitor->full);
     d61:	8b 45 08             	mov    0x8(%ebp),%eax
     d64:	8b 40 08             	mov    0x8(%eax),%eax
     d67:	89 04 24             	mov    %eax,(%esp)
     d6a:	e8 44 05 00 00       	call   12b3 <mesa_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     d6f:	8b 45 08             	mov    0x8(%ebp),%eax
     d72:	8b 00                	mov    (%eax),%eax
     d74:	89 04 24             	mov    %eax,(%esp)
     d77:	e8 1f f9 ff ff       	call   69b <kthread_mutex_unlock>

	return 1;
     d7c:	b8 01 00 00 00       	mov    $0x1,%eax

}
     d81:	c9                   	leave  
     d82:	c3                   	ret    

00000d83 <mesa_slots_monitor_stopadding>:
int mesa_slots_monitor_stopadding(mesa_slots_monitor_t* monitor){
     d83:	55                   	push   %ebp
     d84:	89 e5                	mov    %esp,%ebp
     d86:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
     d89:	8b 45 08             	mov    0x8(%ebp),%eax
     d8c:	8b 40 10             	mov    0x10(%eax),%eax
     d8f:	85 c0                	test   %eax,%eax
     d91:	75 07                	jne    d9a <mesa_slots_monitor_stopadding+0x17>
			return -1;
     d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d98:	eb 35                	jmp    dcf <mesa_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     d9a:	8b 45 08             	mov    0x8(%ebp),%eax
     d9d:	8b 00                	mov    (%eax),%eax
     d9f:	89 04 24             	mov    %eax,(%esp)
     da2:	e8 ec f8 ff ff       	call   693 <kthread_mutex_lock>
     da7:	83 f8 ff             	cmp    $0xffffffff,%eax
     daa:	7d 07                	jge    db3 <mesa_slots_monitor_stopadding+0x30>
			return -1;
     dac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     db1:	eb 1c                	jmp    dcf <mesa_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
     db3:	8b 45 08             	mov    0x8(%ebp),%eax
     db6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
     dbd:	8b 45 08             	mov    0x8(%ebp),%eax
     dc0:	8b 00                	mov    (%eax),%eax
     dc2:	89 04 24             	mov    %eax,(%esp)
     dc5:	e8 d1 f8 ff ff       	call   69b <kthread_mutex_unlock>

		return 0;
     dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
     dcf:	c9                   	leave  
     dd0:	c3                   	ret    

00000dd1 <hoare_slots_monitor_alloc>:
#include "stat.h"
#include "user.h"



hoare_slots_monitor_t* hoare_slots_monitor_alloc(){
     dd1:	55                   	push   %ebp
     dd2:	89 e5                	mov    %esp,%ebp
     dd4:	83 ec 28             	sub    $0x28,%esp


	int mutex=  kthread_mutex_alloc() ;
     dd7:	e8 a7 f8 ff ff       	call   683 <kthread_mutex_alloc>
     ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if( mutex < 0)
     ddf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     de3:	79 0a                	jns    def <hoare_slots_monitor_alloc+0x1e>
		return 0;
     de5:	b8 00 00 00 00       	mov    $0x0,%eax
     dea:	e9 8b 00 00 00       	jmp    e7a <hoare_slots_monitor_alloc+0xa9>

	struct hoare_cond * empty = hoare_cond_alloc();
     def:	e8 68 02 00 00       	call   105c <hoare_cond_alloc>
     df4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (empty == 0){
     df7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     dfb:	75 12                	jne    e0f <hoare_slots_monitor_alloc+0x3e>
		kthread_mutex_dealloc(mutex);
     dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e00:	89 04 24             	mov    %eax,(%esp)
     e03:	e8 83 f8 ff ff       	call   68b <kthread_mutex_dealloc>
		return 0;
     e08:	b8 00 00 00 00       	mov    $0x0,%eax
     e0d:	eb 6b                	jmp    e7a <hoare_slots_monitor_alloc+0xa9>
	}

	hoare_cond_t * full = hoare_cond_alloc();
     e0f:	e8 48 02 00 00       	call   105c <hoare_cond_alloc>
     e14:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (full == 0)
     e17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e1b:	75 1d                	jne    e3a <hoare_slots_monitor_alloc+0x69>
	{
		kthread_mutex_dealloc(mutex);
     e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e20:	89 04 24             	mov    %eax,(%esp)
     e23:	e8 63 f8 ff ff       	call   68b <kthread_mutex_dealloc>
		hoare_cond_dealloc(empty);
     e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e2b:	89 04 24             	mov    %eax,(%esp)
     e2e:	e8 6a 02 00 00       	call   109d <hoare_cond_dealloc>
		return 0;
     e33:	b8 00 00 00 00       	mov    $0x0,%eax
     e38:	eb 40                	jmp    e7a <hoare_slots_monitor_alloc+0xa9>
	}

    hoare_slots_monitor_t * monitor= malloc (sizeof (hoare_slots_monitor_t));
     e3a:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     e41:	e8 31 fc ff ff       	call   a77 <malloc>
     e46:	89 45 e8             	mov    %eax,-0x18(%ebp)

	monitor->empty= empty;
     e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     e4f:	89 50 04             	mov    %edx,0x4(%eax)
	monitor->full= full;
     e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e55:	8b 55 ec             	mov    -0x14(%ebp),%edx
     e58:	89 50 08             	mov    %edx,0x8(%eax)
	monitor->Monitormutex= mutex;
     e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e61:	89 10                	mov    %edx,(%eax)
	monitor->slots=0;
     e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	monitor->active=1;
     e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e70:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)

	return monitor;
     e77:	8b 45 e8             	mov    -0x18(%ebp),%eax

}
     e7a:	c9                   	leave  
     e7b:	c3                   	ret    

00000e7c <hoare_slots_monitor_dealloc>:


int hoare_slots_monitor_dealloc(hoare_slots_monitor_t* monitor){
     e7c:	55                   	push   %ebp
     e7d:	89 e5                	mov    %esp,%ebp
     e7f:	83 ec 18             	sub    $0x18,%esp

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
     e82:	8b 45 08             	mov    0x8(%ebp),%eax
     e85:	8b 00                	mov    (%eax),%eax
     e87:	89 04 24             	mov    %eax,(%esp)
     e8a:	e8 fc f7 ff ff       	call   68b <kthread_mutex_dealloc>
     e8f:	85 c0                	test   %eax,%eax
     e91:	78 2e                	js     ec1 <hoare_slots_monitor_dealloc+0x45>
	    hoare_cond_alloc(monitor->empty)<0 				 ||
     e93:	8b 45 08             	mov    0x8(%ebp),%eax
     e96:	8b 40 04             	mov    0x4(%eax),%eax
     e99:	89 04 24             	mov    %eax,(%esp)
     e9c:	e8 bb 01 00 00       	call   105c <hoare_cond_alloc>
		hoare_cond_alloc(monitor->full)<0
     ea1:	8b 45 08             	mov    0x8(%ebp),%eax
     ea4:	8b 40 08             	mov    0x8(%eax),%eax
     ea7:	89 04 24             	mov    %eax,(%esp)
     eaa:	e8 ad 01 00 00       	call   105c <hoare_cond_alloc>
		){
			return -1;
	}

	free(monitor);
     eaf:	8b 45 08             	mov    0x8(%ebp),%eax
     eb2:	89 04 24             	mov    %eax,(%esp)
     eb5:	e8 84 fa ff ff       	call   93e <free>
	return 0;
     eba:	b8 00 00 00 00       	mov    $0x0,%eax
     ebf:	eb 05                	jmp    ec6 <hoare_slots_monitor_dealloc+0x4a>

	if( kthread_mutex_dealloc(monitor->Monitormutex) < 0 ||
	    hoare_cond_alloc(monitor->empty)<0 				 ||
		hoare_cond_alloc(monitor->full)<0
		){
			return -1;
     ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

	free(monitor);
	return 0;
}
     ec6:	c9                   	leave  
     ec7:	c3                   	ret    

00000ec8 <hoare_slots_monitor_addslots>:

int hoare_slots_monitor_addslots(hoare_slots_monitor_t* monitor,int n){
     ec8:	55                   	push   %ebp
     ec9:	89 e5                	mov    %esp,%ebp
     ecb:	83 ec 18             	sub    $0x18,%esp

	if (!monitor->active)
     ece:	8b 45 08             	mov    0x8(%ebp),%eax
     ed1:	8b 40 10             	mov    0x10(%eax),%eax
     ed4:	85 c0                	test   %eax,%eax
     ed6:	75 0a                	jne    ee2 <hoare_slots_monitor_addslots+0x1a>
		return -1;
     ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     edd:	e9 88 00 00 00       	jmp    f6a <hoare_slots_monitor_addslots+0xa2>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     ee2:	8b 45 08             	mov    0x8(%ebp),%eax
     ee5:	8b 00                	mov    (%eax),%eax
     ee7:	89 04 24             	mov    %eax,(%esp)
     eea:	e8 a4 f7 ff ff       	call   693 <kthread_mutex_lock>
     eef:	83 f8 ff             	cmp    $0xffffffff,%eax
     ef2:	7d 07                	jge    efb <hoare_slots_monitor_addslots+0x33>
		return -1;
     ef4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ef9:	eb 6f                	jmp    f6a <hoare_slots_monitor_addslots+0xa2>

	if ( monitor->active && monitor->slots > 0 )
     efb:	8b 45 08             	mov    0x8(%ebp),%eax
     efe:	8b 40 10             	mov    0x10(%eax),%eax
     f01:	85 c0                	test   %eax,%eax
     f03:	74 21                	je     f26 <hoare_slots_monitor_addslots+0x5e>
     f05:	8b 45 08             	mov    0x8(%ebp),%eax
     f08:	8b 40 0c             	mov    0xc(%eax),%eax
     f0b:	85 c0                	test   %eax,%eax
     f0d:	7e 17                	jle    f26 <hoare_slots_monitor_addslots+0x5e>
				hoare_cond_wait( monitor->full, monitor->Monitormutex);
     f0f:	8b 45 08             	mov    0x8(%ebp),%eax
     f12:	8b 10                	mov    (%eax),%edx
     f14:	8b 45 08             	mov    0x8(%ebp),%eax
     f17:	8b 40 08             	mov    0x8(%eax),%eax
     f1a:	89 54 24 04          	mov    %edx,0x4(%esp)
     f1e:	89 04 24             	mov    %eax,(%esp)
     f21:	e8 c1 01 00 00       	call   10e7 <hoare_cond_wait>


	if  ( monitor->active)
     f26:	8b 45 08             	mov    0x8(%ebp),%eax
     f29:	8b 40 10             	mov    0x10(%eax),%eax
     f2c:	85 c0                	test   %eax,%eax
     f2e:	74 11                	je     f41 <hoare_slots_monitor_addslots+0x79>
			monitor->slots+= n;
     f30:	8b 45 08             	mov    0x8(%ebp),%eax
     f33:	8b 50 0c             	mov    0xc(%eax),%edx
     f36:	8b 45 0c             	mov    0xc(%ebp),%eax
     f39:	01 c2                	add    %eax,%edx
     f3b:	8b 45 08             	mov    0x8(%ebp),%eax
     f3e:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->empty, monitor->Monitormutex );
     f41:	8b 45 08             	mov    0x8(%ebp),%eax
     f44:	8b 10                	mov    (%eax),%edx
     f46:	8b 45 08             	mov    0x8(%ebp),%eax
     f49:	8b 40 04             	mov    0x4(%eax),%eax
     f4c:	89 54 24 04          	mov    %edx,0x4(%esp)
     f50:	89 04 24             	mov    %eax,(%esp)
     f53:	e8 e6 01 00 00       	call   113e <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     f58:	8b 45 08             	mov    0x8(%ebp),%eax
     f5b:	8b 00                	mov    (%eax),%eax
     f5d:	89 04 24             	mov    %eax,(%esp)
     f60:	e8 36 f7 ff ff       	call   69b <kthread_mutex_unlock>

	return 1;
     f65:	b8 01 00 00 00       	mov    $0x1,%eax


}
     f6a:	c9                   	leave  
     f6b:	c3                   	ret    

00000f6c <hoare_slots_monitor_takeslot>:


int hoare_slots_monitor_takeslot(hoare_slots_monitor_t* monitor){
     f6c:	55                   	push   %ebp
     f6d:	89 e5                	mov    %esp,%ebp
     f6f:	83 ec 18             	sub    $0x18,%esp


	if (!monitor->active)
     f72:	8b 45 08             	mov    0x8(%ebp),%eax
     f75:	8b 40 10             	mov    0x10(%eax),%eax
     f78:	85 c0                	test   %eax,%eax
     f7a:	75 0a                	jne    f86 <hoare_slots_monitor_takeslot+0x1a>
		return -1;
     f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f81:	e9 86 00 00 00       	jmp    100c <hoare_slots_monitor_takeslot+0xa0>

	if (kthread_mutex_lock( monitor->Monitormutex)< -1)
     f86:	8b 45 08             	mov    0x8(%ebp),%eax
     f89:	8b 00                	mov    (%eax),%eax
     f8b:	89 04 24             	mov    %eax,(%esp)
     f8e:	e8 00 f7 ff ff       	call   693 <kthread_mutex_lock>
     f93:	83 f8 ff             	cmp    $0xffffffff,%eax
     f96:	7d 07                	jge    f9f <hoare_slots_monitor_takeslot+0x33>
		return -1;
     f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f9d:	eb 6d                	jmp    100c <hoare_slots_monitor_takeslot+0xa0>

	if ( monitor->active && monitor->slots == 0 )
     f9f:	8b 45 08             	mov    0x8(%ebp),%eax
     fa2:	8b 40 10             	mov    0x10(%eax),%eax
     fa5:	85 c0                	test   %eax,%eax
     fa7:	74 21                	je     fca <hoare_slots_monitor_takeslot+0x5e>
     fa9:	8b 45 08             	mov    0x8(%ebp),%eax
     fac:	8b 40 0c             	mov    0xc(%eax),%eax
     faf:	85 c0                	test   %eax,%eax
     fb1:	75 17                	jne    fca <hoare_slots_monitor_takeslot+0x5e>
				hoare_cond_wait( monitor->empty, monitor->Monitormutex);
     fb3:	8b 45 08             	mov    0x8(%ebp),%eax
     fb6:	8b 10                	mov    (%eax),%edx
     fb8:	8b 45 08             	mov    0x8(%ebp),%eax
     fbb:	8b 40 04             	mov    0x4(%eax),%eax
     fbe:	89 54 24 04          	mov    %edx,0x4(%esp)
     fc2:	89 04 24             	mov    %eax,(%esp)
     fc5:	e8 1d 01 00 00       	call   10e7 <hoare_cond_wait>


	if  ( monitor->active)
     fca:	8b 45 08             	mov    0x8(%ebp),%eax
     fcd:	8b 40 10             	mov    0x10(%eax),%eax
     fd0:	85 c0                	test   %eax,%eax
     fd2:	74 0f                	je     fe3 <hoare_slots_monitor_takeslot+0x77>
			monitor->slots--;
     fd4:	8b 45 08             	mov    0x8(%ebp),%eax
     fd7:	8b 40 0c             	mov    0xc(%eax),%eax
     fda:	8d 50 ff             	lea    -0x1(%eax),%edx
     fdd:	8b 45 08             	mov    0x8(%ebp),%eax
     fe0:	89 50 0c             	mov    %edx,0xc(%eax)

	hoare_cond_signal(monitor->full, monitor->Monitormutex );
     fe3:	8b 45 08             	mov    0x8(%ebp),%eax
     fe6:	8b 10                	mov    (%eax),%edx
     fe8:	8b 45 08             	mov    0x8(%ebp),%eax
     feb:	8b 40 08             	mov    0x8(%eax),%eax
     fee:	89 54 24 04          	mov    %edx,0x4(%esp)
     ff2:	89 04 24             	mov    %eax,(%esp)
     ff5:	e8 44 01 00 00       	call   113e <hoare_cond_signal>
	kthread_mutex_unlock( monitor->Monitormutex );
     ffa:	8b 45 08             	mov    0x8(%ebp),%eax
     ffd:	8b 00                	mov    (%eax),%eax
     fff:	89 04 24             	mov    %eax,(%esp)
    1002:	e8 94 f6 ff ff       	call   69b <kthread_mutex_unlock>

	return 1;
    1007:	b8 01 00 00 00       	mov    $0x1,%eax

}
    100c:	c9                   	leave  
    100d:	c3                   	ret    

0000100e <hoare_slots_monitor_stopadding>:
int hoare_slots_monitor_stopadding(hoare_slots_monitor_t* monitor){
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	83 ec 18             	sub    $0x18,%esp


		if (!monitor->active)
    1014:	8b 45 08             	mov    0x8(%ebp),%eax
    1017:	8b 40 10             	mov    0x10(%eax),%eax
    101a:	85 c0                	test   %eax,%eax
    101c:	75 07                	jne    1025 <hoare_slots_monitor_stopadding+0x17>
			return -1;
    101e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1023:	eb 35                	jmp    105a <hoare_slots_monitor_stopadding+0x4c>

		if (kthread_mutex_lock( monitor->Monitormutex)< -1)
    1025:	8b 45 08             	mov    0x8(%ebp),%eax
    1028:	8b 00                	mov    (%eax),%eax
    102a:	89 04 24             	mov    %eax,(%esp)
    102d:	e8 61 f6 ff ff       	call   693 <kthread_mutex_lock>
    1032:	83 f8 ff             	cmp    $0xffffffff,%eax
    1035:	7d 07                	jge    103e <hoare_slots_monitor_stopadding+0x30>
			return -1;
    1037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    103c:	eb 1c                	jmp    105a <hoare_slots_monitor_stopadding+0x4c>

		monitor->active = 0;
    103e:	8b 45 08             	mov    0x8(%ebp),%eax
    1041:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

		kthread_mutex_unlock( monitor->Monitormutex );
    1048:	8b 45 08             	mov    0x8(%ebp),%eax
    104b:	8b 00                	mov    (%eax),%eax
    104d:	89 04 24             	mov    %eax,(%esp)
    1050:	e8 46 f6 ff ff       	call   69b <kthread_mutex_unlock>

		return 0;
    1055:	b8 00 00 00 00       	mov    $0x0,%eax
}
    105a:	c9                   	leave  
    105b:	c3                   	ret    

0000105c <hoare_cond_alloc>:
#include "types.h"
#include "stat.h"
#include "user.h"


hoare_cond_t* hoare_cond_alloc(){
    105c:	55                   	push   %ebp
    105d:	89 e5                	mov    %esp,%ebp
    105f:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    1062:	e8 1c f6 ff ff       	call   683 <kthread_mutex_alloc>
    1067:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    106a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106e:	79 07                	jns    1077 <hoare_cond_alloc+0x1b>
		return 0;
    1070:	b8 00 00 00 00       	mov    $0x0,%eax
    1075:	eb 24                	jmp    109b <hoare_cond_alloc+0x3f>

	hoare_cond_t *hcond = malloc( sizeof (hoare_cond_t)) ;
    1077:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    107e:	e8 f4 f9 ff ff       	call   a77 <malloc>
    1083:	89 45 f0             	mov    %eax,-0x10(%ebp)

	hcond->mutexCV=cvMutex;
    1086:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1089:	8b 55 f4             	mov    -0xc(%ebp),%edx
    108c:	89 10                	mov    %edx,(%eax)
	hcond->waitinCount=0;
    108e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return hcond;
    1098:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    109b:	c9                   	leave  
    109c:	c3                   	ret    

0000109d <hoare_cond_dealloc>:


int hoare_cond_dealloc(hoare_cond_t* hCond){
    109d:	55                   	push   %ebp
    109e:	89 e5                	mov    %esp,%ebp
    10a0:	83 ec 18             	sub    $0x18,%esp

	if (!hCond ){
    10a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10a7:	75 07                	jne    10b0 <hoare_cond_dealloc+0x13>
			return -1;
    10a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10ae:	eb 35                	jmp    10e5 <hoare_cond_dealloc+0x48>
		}

		kthread_mutex_unlock(hCond->mutexCV);
    10b0:	8b 45 08             	mov    0x8(%ebp),%eax
    10b3:	8b 00                	mov    (%eax),%eax
    10b5:	89 04 24             	mov    %eax,(%esp)
    10b8:	e8 de f5 ff ff       	call   69b <kthread_mutex_unlock>
		if(	kthread_mutex_dealloc(hCond->mutexCV) <0)
    10bd:	8b 45 08             	mov    0x8(%ebp),%eax
    10c0:	8b 00                	mov    (%eax),%eax
    10c2:	89 04 24             	mov    %eax,(%esp)
    10c5:	e8 c1 f5 ff ff       	call   68b <kthread_mutex_dealloc>
    10ca:	85 c0                	test   %eax,%eax
    10cc:	79 07                	jns    10d5 <hoare_cond_dealloc+0x38>
			return -1;
    10ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10d3:	eb 10                	jmp    10e5 <hoare_cond_dealloc+0x48>

		free (hCond);
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	89 04 24             	mov    %eax,(%esp)
    10db:	e8 5e f8 ff ff       	call   93e <free>
		return 0;
    10e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10e5:	c9                   	leave  
    10e6:	c3                   	ret    

000010e7 <hoare_cond_wait>:


int hoare_cond_wait(hoare_cond_t* hCond, int mutex_id){
    10e7:	55                   	push   %ebp
    10e8:	89 e5                	mov    %esp,%ebp
    10ea:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    10ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    10f1:	75 07                	jne    10fa <hoare_cond_wait+0x13>
			return -1;
    10f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    10f8:	eb 42                	jmp    113c <hoare_cond_wait+0x55>
		}

	hCond->waitinCount++;
    10fa:	8b 45 08             	mov    0x8(%ebp),%eax
    10fd:	8b 40 04             	mov    0x4(%eax),%eax
    1100:	8d 50 01             	lea    0x1(%eax),%edx
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	89 50 04             	mov    %edx,0x4(%eax)


	if ( kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0)
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
    110c:	8b 00                	mov    (%eax),%eax
    110e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1112:	8b 45 0c             	mov    0xc(%ebp),%eax
    1115:	89 04 24             	mov    %eax,(%esp)
    1118:	e8 86 f5 ff ff       	call   6a3 <kthread_mutex_yieldlock>
    111d:	85 c0                	test   %eax,%eax
    111f:	79 16                	jns    1137 <hoare_cond_wait+0x50>
		{
			hCond->waitinCount--;
    1121:	8b 45 08             	mov    0x8(%ebp),%eax
    1124:	8b 40 04             	mov    0x4(%eax),%eax
    1127:	8d 50 ff             	lea    -0x1(%eax),%edx
    112a:	8b 45 08             	mov    0x8(%ebp),%eax
    112d:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    1130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1135:	eb 05                	jmp    113c <hoare_cond_wait+0x55>
		}

	return 0;
    1137:	b8 00 00 00 00       	mov    $0x0,%eax
}
    113c:	c9                   	leave  
    113d:	c3                   	ret    

0000113e <hoare_cond_signal>:



int hoare_cond_signal(hoare_cond_t* hCond, int mutex_id)
{
    113e:	55                   	push   %ebp
    113f:	89 e5                	mov    %esp,%ebp
    1141:	83 ec 18             	sub    $0x18,%esp

	if (!hCond){
    1144:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1148:	75 07                	jne    1151 <hoare_cond_signal+0x13>
		return -1;
    114a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    114f:	eb 6b                	jmp    11bc <hoare_cond_signal+0x7e>
	}

    if ( hCond->waitinCount >0){
    1151:	8b 45 08             	mov    0x8(%ebp),%eax
    1154:	8b 40 04             	mov    0x4(%eax),%eax
    1157:	85 c0                	test   %eax,%eax
    1159:	7e 3d                	jle    1198 <hoare_cond_signal+0x5a>
    	hCond->waitinCount--;
    115b:	8b 45 08             	mov    0x8(%ebp),%eax
    115e:	8b 40 04             	mov    0x4(%eax),%eax
    1161:	8d 50 ff             	lea    -0x1(%eax),%edx
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	89 50 04             	mov    %edx,0x4(%eax)
		if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    116a:	8b 45 08             	mov    0x8(%ebp),%eax
    116d:	8b 00                	mov    (%eax),%eax
    116f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1173:	8b 45 0c             	mov    0xc(%ebp),%eax
    1176:	89 04 24             	mov    %eax,(%esp)
    1179:	e8 25 f5 ff ff       	call   6a3 <kthread_mutex_yieldlock>
    117e:	85 c0                	test   %eax,%eax
    1180:	79 16                	jns    1198 <hoare_cond_signal+0x5a>
			hCond->waitinCount++;
    1182:	8b 45 08             	mov    0x8(%ebp),%eax
    1185:	8b 40 04             	mov    0x4(%eax),%eax
    1188:	8d 50 01             	lea    0x1(%eax),%edx
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	89 50 04             	mov    %edx,0x4(%eax)
			return -1;
    1191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1196:	eb 24                	jmp    11bc <hoare_cond_signal+0x7e>
		}
    }

    if  (kthread_mutex_yieldlock(mutex_id, hCond->mutexCV)<0){
    1198:	8b 45 08             	mov    0x8(%ebp),%eax
    119b:	8b 00                	mov    (%eax),%eax
    119d:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a4:	89 04 24             	mov    %eax,(%esp)
    11a7:	e8 f7 f4 ff ff       	call   6a3 <kthread_mutex_yieldlock>
    11ac:	85 c0                	test   %eax,%eax
    11ae:	79 07                	jns    11b7 <hoare_cond_signal+0x79>

    			return -1;
    11b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11b5:	eb 05                	jmp    11bc <hoare_cond_signal+0x7e>
    }

	return 0;
    11b7:	b8 00 00 00 00       	mov    $0x0,%eax

}
    11bc:	c9                   	leave  
    11bd:	c3                   	ret    

000011be <mesa_cond_alloc>:
#include  "mesa_cond.h"
#include "types.h"
#include "stat.h"
#include "user.h"

mesa_cond_t* mesa_cond_alloc(){
    11be:	55                   	push   %ebp
    11bf:	89 e5                	mov    %esp,%ebp
    11c1:	83 ec 28             	sub    $0x28,%esp

	int cvMutex= kthread_mutex_alloc();
    11c4:	e8 ba f4 ff ff       	call   683 <kthread_mutex_alloc>
    11c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (cvMutex<0)
    11cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11d0:	79 07                	jns    11d9 <mesa_cond_alloc+0x1b>
		return 0;
    11d2:	b8 00 00 00 00       	mov    $0x0,%eax
    11d7:	eb 24                	jmp    11fd <mesa_cond_alloc+0x3f>

	mesa_cond_t *mcond = malloc( sizeof (mesa_cond_t)) ;
    11d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    11e0:	e8 92 f8 ff ff       	call   a77 <malloc>
    11e5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	mcond->mutexCV=cvMutex;
    11e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ee:	89 10                	mov    %edx,(%eax)
	mcond->waitinCount=0;
    11f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	return mcond;
    11fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11fd:	c9                   	leave  
    11fe:	c3                   	ret    

000011ff <mesa_cond_dealloc>:


int mesa_cond_dealloc(mesa_cond_t* mCond){
    11ff:	55                   	push   %ebp
    1200:	89 e5                	mov    %esp,%ebp
    1202:	83 ec 18             	sub    $0x18,%esp

	if (!mCond ){
    1205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1209:	75 07                	jne    1212 <mesa_cond_dealloc+0x13>
		return -1;
    120b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1210:	eb 35                	jmp    1247 <mesa_cond_dealloc+0x48>
	}

	kthread_mutex_unlock(mCond->mutexCV);
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
    1215:	8b 00                	mov    (%eax),%eax
    1217:	89 04 24             	mov    %eax,(%esp)
    121a:	e8 7c f4 ff ff       	call   69b <kthread_mutex_unlock>
	if(	kthread_mutex_dealloc(mCond->mutexCV) <0)
    121f:	8b 45 08             	mov    0x8(%ebp),%eax
    1222:	8b 00                	mov    (%eax),%eax
    1224:	89 04 24             	mov    %eax,(%esp)
    1227:	e8 5f f4 ff ff       	call   68b <kthread_mutex_dealloc>
    122c:	85 c0                	test   %eax,%eax
    122e:	79 07                	jns    1237 <mesa_cond_dealloc+0x38>
		return -1;
    1230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1235:	eb 10                	jmp    1247 <mesa_cond_dealloc+0x48>

	free (mCond);
    1237:	8b 45 08             	mov    0x8(%ebp),%eax
    123a:	89 04 24             	mov    %eax,(%esp)
    123d:	e8 fc f6 ff ff       	call   93e <free>
	return 0;
    1242:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1247:	c9                   	leave  
    1248:	c3                   	ret    

00001249 <mesa_cond_wait>:


int mesa_cond_wait(mesa_cond_t* mCond,int mutex_id){
    1249:	55                   	push   %ebp
    124a:	89 e5                	mov    %esp,%ebp
    124c:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    124f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1253:	75 07                	jne    125c <mesa_cond_wait+0x13>
		return -1;
    1255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    125a:	eb 55                	jmp    12b1 <mesa_cond_wait+0x68>
	}
	mCond->waitinCount++;
    125c:	8b 45 08             	mov    0x8(%ebp),%eax
    125f:	8b 40 04             	mov    0x4(%eax),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	8b 45 08             	mov    0x8(%ebp),%eax
    1268:	89 50 04             	mov    %edx,0x4(%eax)
	if (kthread_mutex_unlock(mutex_id)<0 &&
    126b:	8b 45 0c             	mov    0xc(%ebp),%eax
    126e:	89 04 24             	mov    %eax,(%esp)
    1271:	e8 25 f4 ff ff       	call   69b <kthread_mutex_unlock>
    1276:	85 c0                	test   %eax,%eax
    1278:	79 27                	jns    12a1 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
    127a:	8b 45 08             	mov    0x8(%ebp),%eax
    127d:	8b 00                	mov    (%eax),%eax
    127f:	89 04 24             	mov    %eax,(%esp)
    1282:	e8 0c f4 ff ff       	call   693 <kthread_mutex_lock>

	if (!mCond){
		return -1;
	}
	mCond->waitinCount++;
	if (kthread_mutex_unlock(mutex_id)<0 &&
    1287:	85 c0                	test   %eax,%eax
    1289:	79 16                	jns    12a1 <mesa_cond_wait+0x58>
		kthread_mutex_lock(mCond->mutexCV)<0)
	{
		mCond->waitinCount--;
    128b:	8b 45 08             	mov    0x8(%ebp),%eax
    128e:	8b 40 04             	mov    0x4(%eax),%eax
    1291:	8d 50 ff             	lea    -0x1(%eax),%edx
    1294:	8b 45 08             	mov    0x8(%ebp),%eax
    1297:	89 50 04             	mov    %edx,0x4(%eax)
		return -1;
    129a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    129f:	eb 10                	jmp    12b1 <mesa_cond_wait+0x68>
	}


	kthread_mutex_lock(mutex_id);
    12a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a4:	89 04 24             	mov    %eax,(%esp)
    12a7:	e8 e7 f3 ff ff       	call   693 <kthread_mutex_lock>
	return 0;
    12ac:	b8 00 00 00 00       	mov    $0x0,%eax


}
    12b1:	c9                   	leave  
    12b2:	c3                   	ret    

000012b3 <mesa_cond_signal>:

int mesa_cond_signal(mesa_cond_t* mCond){
    12b3:	55                   	push   %ebp
    12b4:	89 e5                	mov    %esp,%ebp
    12b6:	83 ec 18             	sub    $0x18,%esp

	if (!mCond){
    12b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12bd:	75 07                	jne    12c6 <mesa_cond_signal+0x13>
		return -1;
    12bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c4:	eb 5d                	jmp    1323 <mesa_cond_signal+0x70>
	}

	if (mCond->waitinCount>0){
    12c6:	8b 45 08             	mov    0x8(%ebp),%eax
    12c9:	8b 40 04             	mov    0x4(%eax),%eax
    12cc:	85 c0                	test   %eax,%eax
    12ce:	7e 36                	jle    1306 <mesa_cond_signal+0x53>
		 mCond->waitinCount --;
    12d0:	8b 45 08             	mov    0x8(%ebp),%eax
    12d3:	8b 40 04             	mov    0x4(%eax),%eax
    12d6:	8d 50 ff             	lea    -0x1(%eax),%edx
    12d9:	8b 45 08             	mov    0x8(%ebp),%eax
    12dc:	89 50 04             	mov    %edx,0x4(%eax)
		 if (kthread_mutex_unlock(mCond->mutexCV)>=0){
    12df:	8b 45 08             	mov    0x8(%ebp),%eax
    12e2:	8b 00                	mov    (%eax),%eax
    12e4:	89 04 24             	mov    %eax,(%esp)
    12e7:	e8 af f3 ff ff       	call   69b <kthread_mutex_unlock>
    12ec:	85 c0                	test   %eax,%eax
    12ee:	78 16                	js     1306 <mesa_cond_signal+0x53>
			 mCond->waitinCount ++;
    12f0:	8b 45 08             	mov    0x8(%ebp),%eax
    12f3:	8b 40 04             	mov    0x4(%eax),%eax
    12f6:	8d 50 01             	lea    0x1(%eax),%edx
    12f9:	8b 45 08             	mov    0x8(%ebp),%eax
    12fc:	89 50 04             	mov    %edx,0x4(%eax)
			 return -1;
    12ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1304:	eb 1d                	jmp    1323 <mesa_cond_signal+0x70>
		 }
	}

	if (kthread_mutex_unlock(mCond->mutexCV)<0){
    1306:	8b 45 08             	mov    0x8(%ebp),%eax
    1309:	8b 00                	mov    (%eax),%eax
    130b:	89 04 24             	mov    %eax,(%esp)
    130e:	e8 88 f3 ff ff       	call   69b <kthread_mutex_unlock>
    1313:	85 c0                	test   %eax,%eax
    1315:	79 07                	jns    131e <mesa_cond_signal+0x6b>

		return -1;
    1317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    131c:	eb 05                	jmp    1323 <mesa_cond_signal+0x70>
	}
	return 0;
    131e:	b8 00 00 00 00       	mov    $0x0,%eax

}
    1323:	c9                   	leave  
    1324:	c3                   	ret    
