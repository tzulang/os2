
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 29 37 10 80       	mov    $0x80103729,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 dc 86 10 	movl   $0x801086dc,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 0f 50 00 00       	call   8010505d <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100055:	05 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
8010005f:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 74 05 11 80       	mov    0x80110574,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 bc 4f 00 00       	call   8010507e <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 74 05 11 80       	mov    0x80110574,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 d7 4f 00 00       	call   801050e0 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 4c 4c 00 00       	call   80104d70 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 70 05 11 80       	mov    0x80110570,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 5f 4f 00 00       	call   801050e0 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 e3 86 10 80 	movl   $0x801086e3,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 db 25 00 00       	call   801027b3 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 f4 86 10 80 	movl   $0x801086f4,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9e 25 00 00       	call   801027b3 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 fb 86 10 80 	movl   $0x801086fb,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 3d 4e 00 00       	call   8010507e <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 74 05 11 80       	mov    0x80110574,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 c6 4b 00 00       	call   80104e68 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 32 4e 00 00       	call   801050e0 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 be 4c 00 00       	call   8010507e <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 02 87 10 80 	movl   $0x80108702,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 0b 87 10 80 	movl   $0x8010870b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 a8 4b 00 00       	call   801050e0 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 12 87 10 80 	movl   $0x80108712,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 21 87 10 80 	movl   $0x80108721,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 9b 4b 00 00       	call   8010512f <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 23 87 10 80 	movl   $0x80108723,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 ea 4c 00 00       	call   801053a1 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 ec 4b 00 00       	call   801052d2 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 9d 65 00 00       	call   80106d18 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 91 65 00 00       	call   80106d18 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 85 65 00 00       	call   80106d18 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 78 65 00 00       	call   80106d18 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
801007ba:	e8 bf 48 00 00       	call   8010507e <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 3b 47 00 00       	call   80104f2a <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100816:	a1 38 08 11 80       	mov    0x80110838,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 3c 08 11 80       	mov    0x8011083c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100840:	a1 38 08 11 80       	mov    0x80110838,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 3c 08 11 80       	mov    0x8011083c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
8010087c:	a1 34 08 11 80       	mov    0x80110834,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 3c 08 11 80    	mov    %edx,0x8011083c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 b4 07 11 80    	mov    %al,-0x7feef84c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008d5:	8b 15 34 08 11 80    	mov    0x80110834,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008e7:	a3 38 08 11 80       	mov    %eax,0x80110838
          wakeup(&input.r);
801008ec:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
801008f3:	e8 70 45 00 00       	call   80104e68 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100914:	e8 c7 47 00 00       	call   801050e0 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 8c 10 00 00       	call   801019b8 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100939:	e8 40 47 00 00       	call   8010507e <acquire>
  while(n > 0){
8010093e:	e9 ad 00 00 00       	jmp    801009f0 <consoleread+0xd5>
    while(input.r == input.w){
80100943:	eb 45                	jmp    8010098a <consoleread+0x6f>
      if(thread->proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 0c             	mov    0xc(%eax),%eax
8010094e:	8b 40 18             	mov    0x18(%eax),%eax
80100951:	85 c0                	test   %eax,%eax
80100953:	74 21                	je     80100976 <consoleread+0x5b>
        release(&input.lock);
80100955:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
8010095c:	e8 7f 47 00 00       	call   801050e0 <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 fe 0e 00 00       	call   8010186a <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a5 00 00 00       	jmp    80100a1b <consoleread+0x100>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 80 07 11 	movl   $0x80110780,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
80100985:	e8 e6 43 00 00       	call   80104d70 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098a:	8b 15 34 08 11 80    	mov    0x80110834,%edx
80100990:	a1 38 08 11 80       	mov    0x80110838,%eax
80100995:	39 c2                	cmp    %eax,%edx
80100997:	74 ac                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100999:	a1 34 08 11 80       	mov    0x80110834,%eax
8010099e:	8d 50 01             	lea    0x1(%eax),%edx
801009a1:	89 15 34 08 11 80    	mov    %edx,0x80110834
801009a7:	83 e0 7f             	and    $0x7f,%eax
801009aa:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
801009b1:	0f be c0             	movsbl %al,%eax
801009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b7:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009bb:	75 19                	jne    801009d6 <consoleread+0xbb>
      if(n < target){
801009bd:	8b 45 10             	mov    0x10(%ebp),%eax
801009c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c3:	73 0f                	jae    801009d4 <consoleread+0xb9>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c5:	a1 34 08 11 80       	mov    0x80110834,%eax
801009ca:	83 e8 01             	sub    $0x1,%eax
801009cd:	a3 34 08 11 80       	mov    %eax,0x80110834
      }
      break;
801009d2:	eb 26                	jmp    801009fa <consoleread+0xdf>
801009d4:	eb 24                	jmp    801009fa <consoleread+0xdf>
    }
    *dst++ = c;
801009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d9:	8d 50 01             	lea    0x1(%eax),%edx
801009dc:	89 55 0c             	mov    %edx,0xc(%ebp)
801009df:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009e2:	88 10                	mov    %dl,(%eax)
    --n;
801009e4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009ec:	75 02                	jne    801009f0 <consoleread+0xd5>
      break;
801009ee:	eb 0a                	jmp    801009fa <consoleread+0xdf>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f4:	0f 8f 49 ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009fa:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100a01:	e8 da 46 00 00       	call   801050e0 <release>
  ilock(ip);
80100a06:	8b 45 08             	mov    0x8(%ebp),%eax
80100a09:	89 04 24             	mov    %eax,(%esp)
80100a0c:	e8 59 0e 00 00       	call   8010186a <ilock>

  return target - n;
80100a11:	8b 45 10             	mov    0x10(%ebp),%eax
80100a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a17:	29 c2                	sub    %eax,%edx
80100a19:	89 d0                	mov    %edx,%eax
}
80100a1b:	c9                   	leave  
80100a1c:	c3                   	ret    

80100a1d <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1d:	55                   	push   %ebp
80100a1e:	89 e5                	mov    %esp,%ebp
80100a20:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a23:	8b 45 08             	mov    0x8(%ebp),%eax
80100a26:	89 04 24             	mov    %eax,(%esp)
80100a29:	e8 8a 0f 00 00       	call   801019b8 <iunlock>
  acquire(&cons.lock);
80100a2e:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a35:	e8 44 46 00 00       	call   8010507e <acquire>
  for(i = 0; i < n; i++)
80100a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a41:	eb 1d                	jmp    80100a60 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a46:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a49:	01 d0                	add    %edx,%eax
80100a4b:	0f b6 00             	movzbl (%eax),%eax
80100a4e:	0f be c0             	movsbl %al,%eax
80100a51:	0f b6 c0             	movzbl %al,%eax
80100a54:	89 04 24             	mov    %eax,(%esp)
80100a57:	e8 f4 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a63:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a66:	7c db                	jl     80100a43 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a68:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6f:	e8 6c 46 00 00       	call   801050e0 <release>
  ilock(ip);
80100a74:	8b 45 08             	mov    0x8(%ebp),%eax
80100a77:	89 04 24             	mov    %eax,(%esp)
80100a7a:	e8 eb 0d 00 00       	call   8010186a <ilock>

  return n;
80100a7f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a82:	c9                   	leave  
80100a83:	c3                   	ret    

80100a84 <consoleinit>:

void
consoleinit(void)
{
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a8a:	c7 44 24 04 27 87 10 	movl   $0x80108727,0x4(%esp)
80100a91:	80 
80100a92:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a99:	e8 bf 45 00 00       	call   8010505d <initlock>
  initlock(&input.lock, "input");
80100a9e:	c7 44 24 04 2f 87 10 	movl   $0x8010872f,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100aad:	e8 ab 45 00 00       	call   8010505d <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab2:	c7 05 ec 11 11 80 1d 	movl   $0x80100a1d,0x801111ec
80100ab9:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100abc:	c7 05 e8 11 11 80 1b 	movl   $0x8010091b,0x801111e8
80100ac3:	09 10 80 
  cons.locking = 1;
80100ac6:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100acd:	00 00 00 

  picenable(IRQ_KBD);
80100ad0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad7:	e8 ea 32 00 00       	call   80103dc6 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100adc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae3:	00 
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 7f 1e 00 00       	call   8010296f <ioapicenable>
}
80100af0:	c9                   	leave  
80100af1:	c3                   	ret    

80100af2 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af2:	55                   	push   %ebp
80100af3:	89 e5                	mov    %esp,%ebp
80100af5:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100afb:	e8 22 29 00 00       	call   80103422 <begin_op>
  if((ip = namei(path)) == 0){
80100b00:	8b 45 08             	mov    0x8(%ebp),%eax
80100b03:	89 04 24             	mov    %eax,(%esp)
80100b06:	e8 0d 19 00 00       	call   80102418 <namei>
80100b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b12:	75 0f                	jne    80100b23 <exec+0x31>
    end_op();
80100b14:	e8 8d 29 00 00       	call   801034a6 <end_op>
    return -1;
80100b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1e:	e9 f4 03 00 00       	jmp    80100f17 <exec+0x425>
  }
  ilock(ip);
80100b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 3c 0d 00 00       	call   8010186a <ilock>
  pgdir = 0;
80100b2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b35:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3c:	00 
80100b3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b44:	00 
80100b45:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b52:	89 04 24             	mov    %eax,(%esp)
80100b55:	e8 1d 12 00 00       	call   80101d77 <readi>
80100b5a:	83 f8 33             	cmp    $0x33,%eax
80100b5d:	77 05                	ja     80100b64 <exec+0x72>
    goto bad;
80100b5f:	e9 87 03 00 00       	jmp    80100eeb <exec+0x3f9>
  if(elf.magic != ELF_MAGIC)
80100b64:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b6a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6f:	74 05                	je     80100b76 <exec+0x84>
    goto bad;
80100b71:	e9 75 03 00 00       	jmp    80100eeb <exec+0x3f9>

  if((pgdir = setupkvm()) == 0)
80100b76:	e8 ee 72 00 00       	call   80107e69 <setupkvm>
80100b7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b82:	75 05                	jne    80100b89 <exec+0x97>
    goto bad;
80100b84:	e9 62 03 00 00       	jmp    80100eeb <exec+0x3f9>

  // Load program into memory.
  sz = 0;
80100b89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b97:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba0:	e9 cb 00 00 00       	jmp    80100c70 <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100baf:	00 
80100bb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bba:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc1:	89 04 24             	mov    %eax,(%esp)
80100bc4:	e8 ae 11 00 00       	call   80101d77 <readi>
80100bc9:	83 f8 20             	cmp    $0x20,%eax
80100bcc:	74 05                	je     80100bd3 <exec+0xe1>
      goto bad;
80100bce:	e9 18 03 00 00       	jmp    80100eeb <exec+0x3f9>
    if(ph.type != ELF_PROG_LOAD)
80100bd3:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd9:	83 f8 01             	cmp    $0x1,%eax
80100bdc:	74 05                	je     80100be3 <exec+0xf1>
      continue;
80100bde:	e9 80 00 00 00       	jmp    80100c63 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be3:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be9:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bef:	39 c2                	cmp    %eax,%edx
80100bf1:	73 05                	jae    80100bf8 <exec+0x106>
      goto bad;
80100bf3:	e9 f3 02 00 00       	jmp    80100eeb <exec+0x3f9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf8:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfe:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c04:	01 d0                	add    %edx,%eax
80100c06:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c14:	89 04 24             	mov    %eax,(%esp)
80100c17:	e8 20 76 00 00       	call   8010823c <allocuvm>
80100c1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c23:	75 05                	jne    80100c2a <exec+0x138>
      goto bad;
80100c25:	e9 c1 02 00 00       	jmp    80100eeb <exec+0x3f9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c2a:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c30:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c36:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c40:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c44:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c47:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c52:	89 04 24             	mov    %eax,(%esp)
80100c55:	e8 f7 74 00 00       	call   80108151 <loaduvm>
80100c5a:	85 c0                	test   %eax,%eax
80100c5c:	79 05                	jns    80100c63 <exec+0x171>
      goto bad;
80100c5e:	e9 88 02 00 00       	jmp    80100eeb <exec+0x3f9>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c6a:	83 c0 20             	add    $0x20,%eax
80100c6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c70:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c77:	0f b7 c0             	movzwl %ax,%eax
80100c7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7d:	0f 8f 22 ff ff ff    	jg     80100ba5 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c83:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c86:	89 04 24             	mov    %eax,(%esp)
80100c89:	e8 60 0e 00 00       	call   80101aee <iunlockput>
  end_op();
80100c8e:	e8 13 28 00 00       	call   801034a6 <end_op>
  ip = 0;
80100c93:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cad:	05 00 20 00 00       	add    $0x2000,%eax
80100cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc0:	89 04 24             	mov    %eax,(%esp)
80100cc3:	e8 74 75 00 00       	call   8010823c <allocuvm>
80100cc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ccb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccf:	75 05                	jne    80100cd6 <exec+0x1e4>
    goto bad;
80100cd1:	e9 15 02 00 00       	jmp    80100eeb <exec+0x3f9>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd9:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce5:	89 04 24             	mov    %eax,(%esp)
80100ce8:	e8 7f 77 00 00       	call   8010846c <clearpteu>
  sp = sz;
80100ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf0:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cfa:	e9 9a 00 00 00       	jmp    80100d99 <exec+0x2a7>
    if(argc >= MAXARG)
80100cff:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d03:	76 05                	jbe    80100d0a <exec+0x218>
      goto bad;
80100d05:	e9 e1 01 00 00       	jmp    80100eeb <exec+0x3f9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d17:	01 d0                	add    %edx,%eax
80100d19:	8b 00                	mov    (%eax),%eax
80100d1b:	89 04 24             	mov    %eax,(%esp)
80100d1e:	e8 19 48 00 00       	call   8010553c <strlen>
80100d23:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d26:	29 c2                	sub    %eax,%edx
80100d28:	89 d0                	mov    %edx,%eax
80100d2a:	83 e8 01             	sub    $0x1,%eax
80100d2d:	83 e0 fc             	and    $0xfffffffc,%eax
80100d30:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d40:	01 d0                	add    %edx,%eax
80100d42:	8b 00                	mov    (%eax),%eax
80100d44:	89 04 24             	mov    %eax,(%esp)
80100d47:	e8 f0 47 00 00       	call   8010553c <strlen>
80100d4c:	83 c0 01             	add    $0x1,%eax
80100d4f:	89 c2                	mov    %eax,%edx
80100d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d54:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5e:	01 c8                	add    %ecx,%eax
80100d60:	8b 00                	mov    (%eax),%eax
80100d62:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d66:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d74:	89 04 24             	mov    %eax,(%esp)
80100d77:	e8 b5 78 00 00       	call   80108631 <copyout>
80100d7c:	85 c0                	test   %eax,%eax
80100d7e:	79 05                	jns    80100d85 <exec+0x293>
      goto bad;
80100d80:	e9 66 01 00 00       	jmp    80100eeb <exec+0x3f9>
    ustack[3+argc] = sp;
80100d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d88:	8d 50 03             	lea    0x3(%eax),%edx
80100d8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8e:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d95:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da6:	01 d0                	add    %edx,%eax
80100da8:	8b 00                	mov    (%eax),%eax
80100daa:	85 c0                	test   %eax,%eax
80100dac:	0f 85 4d ff ff ff    	jne    80100cff <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db5:	83 c0 03             	add    $0x3,%eax
80100db8:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbf:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc3:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dca:	ff ff ff 
  ustack[1] = argc;
80100dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd0:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	83 c0 01             	add    $0x1,%eax
80100ddc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de6:	29 d0                	sub    %edx,%eax
80100de8:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df1:	83 c0 04             	add    $0x4,%eax
80100df4:	c1 e0 02             	shl    $0x2,%eax
80100df7:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfd:	83 c0 04             	add    $0x4,%eax
80100e00:	c1 e0 02             	shl    $0x2,%eax
80100e03:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e07:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e14:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e1b:	89 04 24             	mov    %eax,(%esp)
80100e1e:	e8 0e 78 00 00       	call   80108631 <copyout>
80100e23:	85 c0                	test   %eax,%eax
80100e25:	79 05                	jns    80100e2c <exec+0x33a>
    goto bad;
80100e27:	e9 bf 00 00 00       	jmp    80100eeb <exec+0x3f9>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e38:	eb 17                	jmp    80100e51 <exec+0x35f>
    if(*s == '/')
80100e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3d:	0f b6 00             	movzbl (%eax),%eax
80100e40:	3c 2f                	cmp    $0x2f,%al
80100e42:	75 09                	jne    80100e4d <exec+0x35b>
      last = s+1;
80100e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e47:	83 c0 01             	add    $0x1,%eax
80100e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e54:	0f b6 00             	movzbl (%eax),%eax
80100e57:	84 c0                	test   %al,%al
80100e59:	75 df                	jne    80100e3a <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(thread->proc->name, last, sizeof(thread->proc->name));
80100e5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e61:	8b 40 0c             	mov    0xc(%eax),%eax
80100e64:	8d 50 60             	lea    0x60(%eax),%edx
80100e67:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e6e:	00 
80100e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e72:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e76:	89 14 24             	mov    %edx,(%esp)
80100e79:	e8 74 46 00 00       	call   801054f2 <safestrcpy>

  // Commit to the user image.
  oldpgdir = thread->proc->pgdir;
80100e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e84:	8b 40 0c             	mov    0xc(%eax),%eax
80100e87:	8b 40 04             	mov    0x4(%eax),%eax
80100e8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  thread->proc->pgdir = pgdir;
80100e8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e93:	8b 40 0c             	mov    0xc(%eax),%eax
80100e96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e99:	89 50 04             	mov    %edx,0x4(%eax)

  thread->proc->sz = sz;
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 0c             	mov    0xc(%eax),%eax
80100ea5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ea8:	89 10                	mov    %edx,(%eax)
  thread->tf->eip = elf.entry;  // main
80100eaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb0:	8b 40 10             	mov    0x10(%eax),%eax
80100eb3:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eb9:	89 50 38             	mov    %edx,0x38(%eax)
  thread->tf->esp = sp;
80100ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec2:	8b 40 10             	mov    0x10(%eax),%eax
80100ec5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ec8:	89 50 44             	mov    %edx,0x44(%eax)

  switchuvm(thread);
80100ecb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed1:	89 04 24             	mov    %eax,(%esp)
80100ed4:	e8 81 70 00 00       	call   80107f5a <switchuvm>

  freevm(oldpgdir);
80100ed9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100edc:	89 04 24             	mov    %eax,(%esp)
80100edf:	e8 ee 74 00 00       	call   801083d2 <freevm>
  return 0;
80100ee4:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee9:	eb 2c                	jmp    80100f17 <exec+0x425>

 bad:
  if(pgdir)
80100eeb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100eef:	74 0b                	je     80100efc <exec+0x40a>
    freevm(pgdir);
80100ef1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ef4:	89 04 24             	mov    %eax,(%esp)
80100ef7:	e8 d6 74 00 00       	call   801083d2 <freevm>
  if(ip){
80100efc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f00:	74 10                	je     80100f12 <exec+0x420>
    iunlockput(ip);
80100f02:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f05:	89 04 24             	mov    %eax,(%esp)
80100f08:	e8 e1 0b 00 00       	call   80101aee <iunlockput>
    end_op();
80100f0d:	e8 94 25 00 00       	call   801034a6 <end_op>
  }
  return -1;
80100f12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    

80100f19 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f19:	55                   	push   %ebp
80100f1a:	89 e5                	mov    %esp,%ebp
80100f1c:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f1f:	c7 44 24 04 35 87 10 	movl   $0x80108735,0x4(%esp)
80100f26:	80 
80100f27:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f2e:	e8 2a 41 00 00       	call   8010505d <initlock>
}
80100f33:	c9                   	leave  
80100f34:	c3                   	ret    

80100f35 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f35:	55                   	push   %ebp
80100f36:	89 e5                	mov    %esp,%ebp
80100f38:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f3b:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f42:	e8 37 41 00 00       	call   8010507e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f47:	c7 45 f4 74 08 11 80 	movl   $0x80110874,-0xc(%ebp)
80100f4e:	eb 29                	jmp    80100f79 <filealloc+0x44>
    if(f->ref == 0){
80100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f53:	8b 40 04             	mov    0x4(%eax),%eax
80100f56:	85 c0                	test   %eax,%eax
80100f58:	75 1b                	jne    80100f75 <filealloc+0x40>
      f->ref = 1;
80100f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f64:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f6b:	e8 70 41 00 00       	call   801050e0 <release>
      return f;
80100f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f73:	eb 1e                	jmp    80100f93 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f75:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f79:	81 7d f4 d4 11 11 80 	cmpl   $0x801111d4,-0xc(%ebp)
80100f80:	72 ce                	jb     80100f50 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f82:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f89:	e8 52 41 00 00       	call   801050e0 <release>
  return 0;
80100f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f93:	c9                   	leave  
80100f94:	c3                   	ret    

80100f95 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f95:	55                   	push   %ebp
80100f96:	89 e5                	mov    %esp,%ebp
80100f98:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f9b:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fa2:	e8 d7 40 00 00       	call   8010507e <acquire>
  if(f->ref < 1)
80100fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80100faa:	8b 40 04             	mov    0x4(%eax),%eax
80100fad:	85 c0                	test   %eax,%eax
80100faf:	7f 0c                	jg     80100fbd <filedup+0x28>
    panic("filedup");
80100fb1:	c7 04 24 3c 87 10 80 	movl   $0x8010873c,(%esp)
80100fb8:	e8 7d f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc0:	8b 40 04             	mov    0x4(%eax),%eax
80100fc3:	8d 50 01             	lea    0x1(%eax),%edx
80100fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc9:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fcc:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fd3:	e8 08 41 00 00       	call   801050e0 <release>
  return f;
80100fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fdb:	c9                   	leave  
80100fdc:	c3                   	ret    

80100fdd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fdd:	55                   	push   %ebp
80100fde:	89 e5                	mov    %esp,%ebp
80100fe0:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fe3:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fea:	e8 8f 40 00 00       	call   8010507e <acquire>
  if(f->ref < 1)
80100fef:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff2:	8b 40 04             	mov    0x4(%eax),%eax
80100ff5:	85 c0                	test   %eax,%eax
80100ff7:	7f 0c                	jg     80101005 <fileclose+0x28>
    panic("fileclose");
80100ff9:	c7 04 24 44 87 10 80 	movl   $0x80108744,(%esp)
80101000:	e8 35 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101005:	8b 45 08             	mov    0x8(%ebp),%eax
80101008:	8b 40 04             	mov    0x4(%eax),%eax
8010100b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010100e:	8b 45 08             	mov    0x8(%ebp),%eax
80101011:	89 50 04             	mov    %edx,0x4(%eax)
80101014:	8b 45 08             	mov    0x8(%ebp),%eax
80101017:	8b 40 04             	mov    0x4(%eax),%eax
8010101a:	85 c0                	test   %eax,%eax
8010101c:	7e 11                	jle    8010102f <fileclose+0x52>
    release(&ftable.lock);
8010101e:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80101025:	e8 b6 40 00 00       	call   801050e0 <release>
8010102a:	e9 82 00 00 00       	jmp    801010b1 <fileclose+0xd4>
    return;
  }
  ff = *f;
8010102f:	8b 45 08             	mov    0x8(%ebp),%eax
80101032:	8b 10                	mov    (%eax),%edx
80101034:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101037:	8b 50 04             	mov    0x4(%eax),%edx
8010103a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010103d:	8b 50 08             	mov    0x8(%eax),%edx
80101040:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101043:	8b 50 0c             	mov    0xc(%eax),%edx
80101046:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101049:	8b 50 10             	mov    0x10(%eax),%edx
8010104c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010104f:	8b 40 14             	mov    0x14(%eax),%eax
80101052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010105f:	8b 45 08             	mov    0x8(%ebp),%eax
80101062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101068:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
8010106f:	e8 6c 40 00 00       	call   801050e0 <release>
  
  if(ff.type == FD_PIPE)
80101074:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101077:	83 f8 01             	cmp    $0x1,%eax
8010107a:	75 18                	jne    80101094 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010107c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101080:	0f be d0             	movsbl %al,%edx
80101083:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101086:	89 54 24 04          	mov    %edx,0x4(%esp)
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 e4 2f 00 00       	call   80104076 <pipeclose>
80101092:	eb 1d                	jmp    801010b1 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101094:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101097:	83 f8 02             	cmp    $0x2,%eax
8010109a:	75 15                	jne    801010b1 <fileclose+0xd4>
    begin_op();
8010109c:	e8 81 23 00 00       	call   80103422 <begin_op>
    iput(ff.ip);
801010a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010a4:	89 04 24             	mov    %eax,(%esp)
801010a7:	e8 71 09 00 00       	call   80101a1d <iput>
    end_op();
801010ac:	e8 f5 23 00 00       	call   801034a6 <end_op>
  }
}
801010b1:	c9                   	leave  
801010b2:	c3                   	ret    

801010b3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010b3:	55                   	push   %ebp
801010b4:	89 e5                	mov    %esp,%ebp
801010b6:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010b9:	8b 45 08             	mov    0x8(%ebp),%eax
801010bc:	8b 00                	mov    (%eax),%eax
801010be:	83 f8 02             	cmp    $0x2,%eax
801010c1:	75 38                	jne    801010fb <filestat+0x48>
    ilock(f->ip);
801010c3:	8b 45 08             	mov    0x8(%ebp),%eax
801010c6:	8b 40 10             	mov    0x10(%eax),%eax
801010c9:	89 04 24             	mov    %eax,(%esp)
801010cc:	e8 99 07 00 00       	call   8010186a <ilock>
    stati(f->ip, st);
801010d1:	8b 45 08             	mov    0x8(%ebp),%eax
801010d4:	8b 40 10             	mov    0x10(%eax),%eax
801010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801010da:	89 54 24 04          	mov    %edx,0x4(%esp)
801010de:	89 04 24             	mov    %eax,(%esp)
801010e1:	e8 4c 0c 00 00       	call   80101d32 <stati>
    iunlock(f->ip);
801010e6:	8b 45 08             	mov    0x8(%ebp),%eax
801010e9:	8b 40 10             	mov    0x10(%eax),%eax
801010ec:	89 04 24             	mov    %eax,(%esp)
801010ef:	e8 c4 08 00 00       	call   801019b8 <iunlock>
    return 0;
801010f4:	b8 00 00 00 00       	mov    $0x0,%eax
801010f9:	eb 05                	jmp    80101100 <filestat+0x4d>
  }
  return -1;
801010fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101100:	c9                   	leave  
80101101:	c3                   	ret    

80101102 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101102:	55                   	push   %ebp
80101103:	89 e5                	mov    %esp,%ebp
80101105:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101108:	8b 45 08             	mov    0x8(%ebp),%eax
8010110b:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010110f:	84 c0                	test   %al,%al
80101111:	75 0a                	jne    8010111d <fileread+0x1b>
    return -1;
80101113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101118:	e9 9f 00 00 00       	jmp    801011bc <fileread+0xba>
  if(f->type == FD_PIPE)
8010111d:	8b 45 08             	mov    0x8(%ebp),%eax
80101120:	8b 00                	mov    (%eax),%eax
80101122:	83 f8 01             	cmp    $0x1,%eax
80101125:	75 1e                	jne    80101145 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101127:	8b 45 08             	mov    0x8(%ebp),%eax
8010112a:	8b 40 0c             	mov    0xc(%eax),%eax
8010112d:	8b 55 10             	mov    0x10(%ebp),%edx
80101130:	89 54 24 08          	mov    %edx,0x8(%esp)
80101134:	8b 55 0c             	mov    0xc(%ebp),%edx
80101137:	89 54 24 04          	mov    %edx,0x4(%esp)
8010113b:	89 04 24             	mov    %eax,(%esp)
8010113e:	e8 b7 30 00 00       	call   801041fa <piperead>
80101143:	eb 77                	jmp    801011bc <fileread+0xba>
  if(f->type == FD_INODE){
80101145:	8b 45 08             	mov    0x8(%ebp),%eax
80101148:	8b 00                	mov    (%eax),%eax
8010114a:	83 f8 02             	cmp    $0x2,%eax
8010114d:	75 61                	jne    801011b0 <fileread+0xae>
    ilock(f->ip);
8010114f:	8b 45 08             	mov    0x8(%ebp),%eax
80101152:	8b 40 10             	mov    0x10(%eax),%eax
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 0d 07 00 00       	call   8010186a <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101160:	8b 45 08             	mov    0x8(%ebp),%eax
80101163:	8b 50 14             	mov    0x14(%eax),%edx
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 40 10             	mov    0x10(%eax),%eax
8010116c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101170:	89 54 24 08          	mov    %edx,0x8(%esp)
80101174:	8b 55 0c             	mov    0xc(%ebp),%edx
80101177:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117b:	89 04 24             	mov    %eax,(%esp)
8010117e:	e8 f4 0b 00 00       	call   80101d77 <readi>
80101183:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010118a:	7e 11                	jle    8010119d <fileread+0x9b>
      f->off += r;
8010118c:	8b 45 08             	mov    0x8(%ebp),%eax
8010118f:	8b 50 14             	mov    0x14(%eax),%edx
80101192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101195:	01 c2                	add    %eax,%edx
80101197:	8b 45 08             	mov    0x8(%ebp),%eax
8010119a:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 40 10             	mov    0x10(%eax),%eax
801011a3:	89 04 24             	mov    %eax,(%esp)
801011a6:	e8 0d 08 00 00       	call   801019b8 <iunlock>
    return r;
801011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ae:	eb 0c                	jmp    801011bc <fileread+0xba>
  }
  panic("fileread");
801011b0:	c7 04 24 4e 87 10 80 	movl   $0x8010874e,(%esp)
801011b7:	e8 7e f3 ff ff       	call   8010053a <panic>
}
801011bc:	c9                   	leave  
801011bd:	c3                   	ret    

801011be <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011be:	55                   	push   %ebp
801011bf:	89 e5                	mov    %esp,%ebp
801011c1:	53                   	push   %ebx
801011c2:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011c5:	8b 45 08             	mov    0x8(%ebp),%eax
801011c8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011cc:	84 c0                	test   %al,%al
801011ce:	75 0a                	jne    801011da <filewrite+0x1c>
    return -1;
801011d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d5:	e9 20 01 00 00       	jmp    801012fa <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 00                	mov    (%eax),%eax
801011df:	83 f8 01             	cmp    $0x1,%eax
801011e2:	75 21                	jne    80101205 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011e4:	8b 45 08             	mov    0x8(%ebp),%eax
801011e7:	8b 40 0c             	mov    0xc(%eax),%eax
801011ea:	8b 55 10             	mov    0x10(%ebp),%edx
801011ed:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801011f4:	89 54 24 04          	mov    %edx,0x4(%esp)
801011f8:	89 04 24             	mov    %eax,(%esp)
801011fb:	e8 08 2f 00 00       	call   80104108 <pipewrite>
80101200:	e9 f5 00 00 00       	jmp    801012fa <filewrite+0x13c>
  if(f->type == FD_INODE){
80101205:	8b 45 08             	mov    0x8(%ebp),%eax
80101208:	8b 00                	mov    (%eax),%eax
8010120a:	83 f8 02             	cmp    $0x2,%eax
8010120d:	0f 85 db 00 00 00    	jne    801012ee <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101213:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010121a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101221:	e9 a8 00 00 00       	jmp    801012ce <filewrite+0x110>
      int n1 = n - i;
80101226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101229:	8b 55 10             	mov    0x10(%ebp),%edx
8010122c:	29 c2                	sub    %eax,%edx
8010122e:	89 d0                	mov    %edx,%eax
80101230:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101233:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101236:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101239:	7e 06                	jle    80101241 <filewrite+0x83>
        n1 = max;
8010123b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010123e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101241:	e8 dc 21 00 00       	call   80103422 <begin_op>
      ilock(f->ip);
80101246:	8b 45 08             	mov    0x8(%ebp),%eax
80101249:	8b 40 10             	mov    0x10(%eax),%eax
8010124c:	89 04 24             	mov    %eax,(%esp)
8010124f:	e8 16 06 00 00       	call   8010186a <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101254:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101257:	8b 45 08             	mov    0x8(%ebp),%eax
8010125a:	8b 50 14             	mov    0x14(%eax),%edx
8010125d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101260:	8b 45 0c             	mov    0xc(%ebp),%eax
80101263:	01 c3                	add    %eax,%ebx
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 40 10             	mov    0x10(%eax),%eax
8010126b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010126f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101273:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101277:	89 04 24             	mov    %eax,(%esp)
8010127a:	e8 5c 0c 00 00       	call   80101edb <writei>
8010127f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101282:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101286:	7e 11                	jle    80101299 <filewrite+0xdb>
        f->off += r;
80101288:	8b 45 08             	mov    0x8(%ebp),%eax
8010128b:	8b 50 14             	mov    0x14(%eax),%edx
8010128e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101291:	01 c2                	add    %eax,%edx
80101293:	8b 45 08             	mov    0x8(%ebp),%eax
80101296:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 40 10             	mov    0x10(%eax),%eax
8010129f:	89 04 24             	mov    %eax,(%esp)
801012a2:	e8 11 07 00 00       	call   801019b8 <iunlock>
      end_op();
801012a7:	e8 fa 21 00 00       	call   801034a6 <end_op>

      if(r < 0)
801012ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b0:	79 02                	jns    801012b4 <filewrite+0xf6>
        break;
801012b2:	eb 26                	jmp    801012da <filewrite+0x11c>
      if(r != n1)
801012b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012ba:	74 0c                	je     801012c8 <filewrite+0x10a>
        panic("short filewrite");
801012bc:	c7 04 24 57 87 10 80 	movl   $0x80108757,(%esp)
801012c3:	e8 72 f2 ff ff       	call   8010053a <panic>
      i += r;
801012c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cb:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d1:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d4:	0f 8c 4c ff ff ff    	jl     80101226 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e0:	75 05                	jne    801012e7 <filewrite+0x129>
801012e2:	8b 45 10             	mov    0x10(%ebp),%eax
801012e5:	eb 05                	jmp    801012ec <filewrite+0x12e>
801012e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ec:	eb 0c                	jmp    801012fa <filewrite+0x13c>
  }
  panic("filewrite");
801012ee:	c7 04 24 67 87 10 80 	movl   $0x80108767,(%esp)
801012f5:	e8 40 f2 ff ff       	call   8010053a <panic>
}
801012fa:	83 c4 24             	add    $0x24,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5d                   	pop    %ebp
801012ff:	c3                   	ret    

80101300 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101306:	8b 45 08             	mov    0x8(%ebp),%eax
80101309:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101310:	00 
80101311:	89 04 24             	mov    %eax,(%esp)
80101314:	e8 8d ee ff ff       	call   801001a6 <bread>
80101319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131f:	83 c0 18             	add    $0x18,%eax
80101322:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101329:	00 
8010132a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010132e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101331:	89 04 24             	mov    %eax,(%esp)
80101334:	e8 68 40 00 00       	call   801053a1 <memmove>
  brelse(bp);
80101339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133c:	89 04 24             	mov    %eax,(%esp)
8010133f:	e8 d3 ee ff ff       	call   80100217 <brelse>
}
80101344:	c9                   	leave  
80101345:	c3                   	ret    

80101346 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101346:	55                   	push   %ebp
80101347:	89 e5                	mov    %esp,%ebp
80101349:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010134c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010134f:	8b 45 08             	mov    0x8(%ebp),%eax
80101352:	89 54 24 04          	mov    %edx,0x4(%esp)
80101356:	89 04 24             	mov    %eax,(%esp)
80101359:	e8 48 ee ff ff       	call   801001a6 <bread>
8010135e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101364:	83 c0 18             	add    $0x18,%eax
80101367:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010136e:	00 
8010136f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101376:	00 
80101377:	89 04 24             	mov    %eax,(%esp)
8010137a:	e8 53 3f 00 00       	call   801052d2 <memset>
  log_write(bp);
8010137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101382:	89 04 24             	mov    %eax,(%esp)
80101385:	e8 a3 22 00 00       	call   8010362d <log_write>
  brelse(bp);
8010138a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138d:	89 04 24             	mov    %eax,(%esp)
80101390:	e8 82 ee ff ff       	call   80100217 <brelse>
}
80101395:	c9                   	leave  
80101396:	c3                   	ret    

80101397 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101397:	55                   	push   %ebp
80101398:	89 e5                	mov    %esp,%ebp
8010139a:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010139d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013a4:	8b 45 08             	mov    0x8(%ebp),%eax
801013a7:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801013ae:	89 04 24             	mov    %eax,(%esp)
801013b1:	e8 4a ff ff ff       	call   80101300 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013bd:	e9 07 01 00 00       	jmp    801014c9 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013cb:	85 c0                	test   %eax,%eax
801013cd:	0f 48 c2             	cmovs  %edx,%eax
801013d0:	c1 f8 0c             	sar    $0xc,%eax
801013d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013d6:	c1 ea 03             	shr    $0x3,%edx
801013d9:	01 d0                	add    %edx,%eax
801013db:	83 c0 03             	add    $0x3,%eax
801013de:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e2:	8b 45 08             	mov    0x8(%ebp),%eax
801013e5:	89 04 24             	mov    %eax,(%esp)
801013e8:	e8 b9 ed ff ff       	call   801001a6 <bread>
801013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013f7:	e9 9d 00 00 00       	jmp    80101499 <balloc+0x102>
      m = 1 << (bi % 8);
801013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013ff:	99                   	cltd   
80101400:	c1 ea 1d             	shr    $0x1d,%edx
80101403:	01 d0                	add    %edx,%eax
80101405:	83 e0 07             	and    $0x7,%eax
80101408:	29 d0                	sub    %edx,%eax
8010140a:	ba 01 00 00 00       	mov    $0x1,%edx
8010140f:	89 c1                	mov    %eax,%ecx
80101411:	d3 e2                	shl    %cl,%edx
80101413:	89 d0                	mov    %edx,%eax
80101415:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101418:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141b:	8d 50 07             	lea    0x7(%eax),%edx
8010141e:	85 c0                	test   %eax,%eax
80101420:	0f 48 c2             	cmovs  %edx,%eax
80101423:	c1 f8 03             	sar    $0x3,%eax
80101426:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101429:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010142e:	0f b6 c0             	movzbl %al,%eax
80101431:	23 45 e8             	and    -0x18(%ebp),%eax
80101434:	85 c0                	test   %eax,%eax
80101436:	75 5d                	jne    80101495 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143b:	8d 50 07             	lea    0x7(%eax),%edx
8010143e:	85 c0                	test   %eax,%eax
80101440:	0f 48 c2             	cmovs  %edx,%eax
80101443:	c1 f8 03             	sar    $0x3,%eax
80101446:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101449:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010144e:	89 d1                	mov    %edx,%ecx
80101450:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101453:	09 ca                	or     %ecx,%edx
80101455:	89 d1                	mov    %edx,%ecx
80101457:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145a:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101461:	89 04 24             	mov    %eax,(%esp)
80101464:	e8 c4 21 00 00       	call   8010362d <log_write>
        brelse(bp);
80101469:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146c:	89 04 24             	mov    %eax,(%esp)
8010146f:	e8 a3 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147a:	01 c2                	add    %eax,%edx
8010147c:	8b 45 08             	mov    0x8(%ebp),%eax
8010147f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101483:	89 04 24             	mov    %eax,(%esp)
80101486:	e8 bb fe ff ff       	call   80101346 <bzero>
        return b + bi;
8010148b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101491:	01 d0                	add    %edx,%eax
80101493:	eb 4e                	jmp    801014e3 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101495:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101499:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014a0:	7f 15                	jg     801014b7 <balloc+0x120>
801014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a8:	01 d0                	add    %edx,%eax
801014aa:	89 c2                	mov    %eax,%edx
801014ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014af:	39 c2                	cmp    %eax,%edx
801014b1:	0f 82 45 ff ff ff    	jb     801013fc <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ba:	89 04 24             	mov    %eax,(%esp)
801014bd:	e8 55 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014c2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014cf:	39 c2                	cmp    %eax,%edx
801014d1:	0f 82 eb fe ff ff    	jb     801013c2 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014d7:	c7 04 24 71 87 10 80 	movl   $0x80108771,(%esp)
801014de:	e8 57 f0 ff ff       	call   8010053a <panic>
}
801014e3:	c9                   	leave  
801014e4:	c3                   	ret    

801014e5 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014e5:	55                   	push   %ebp
801014e6:	89 e5                	mov    %esp,%ebp
801014e8:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f2:	8b 45 08             	mov    0x8(%ebp),%eax
801014f5:	89 04 24             	mov    %eax,(%esp)
801014f8:	e8 03 fe ff ff       	call   80101300 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101500:	c1 e8 0c             	shr    $0xc,%eax
80101503:	89 c2                	mov    %eax,%edx
80101505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101508:	c1 e8 03             	shr    $0x3,%eax
8010150b:	01 d0                	add    %edx,%eax
8010150d:	8d 50 03             	lea    0x3(%eax),%edx
80101510:	8b 45 08             	mov    0x8(%ebp),%eax
80101513:	89 54 24 04          	mov    %edx,0x4(%esp)
80101517:	89 04 24             	mov    %eax,(%esp)
8010151a:	e8 87 ec ff ff       	call   801001a6 <bread>
8010151f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101522:	8b 45 0c             	mov    0xc(%ebp),%eax
80101525:	25 ff 0f 00 00       	and    $0xfff,%eax
8010152a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	99                   	cltd   
80101531:	c1 ea 1d             	shr    $0x1d,%edx
80101534:	01 d0                	add    %edx,%eax
80101536:	83 e0 07             	and    $0x7,%eax
80101539:	29 d0                	sub    %edx,%eax
8010153b:	ba 01 00 00 00       	mov    $0x1,%edx
80101540:	89 c1                	mov    %eax,%ecx
80101542:	d3 e2                	shl    %cl,%edx
80101544:	89 d0                	mov    %edx,%eax
80101546:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154c:	8d 50 07             	lea    0x7(%eax),%edx
8010154f:	85 c0                	test   %eax,%eax
80101551:	0f 48 c2             	cmovs  %edx,%eax
80101554:	c1 f8 03             	sar    $0x3,%eax
80101557:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155a:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010155f:	0f b6 c0             	movzbl %al,%eax
80101562:	23 45 ec             	and    -0x14(%ebp),%eax
80101565:	85 c0                	test   %eax,%eax
80101567:	75 0c                	jne    80101575 <bfree+0x90>
    panic("freeing free block");
80101569:	c7 04 24 87 87 10 80 	movl   $0x80108787,(%esp)
80101570:	e8 c5 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101575:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101578:	8d 50 07             	lea    0x7(%eax),%edx
8010157b:	85 c0                	test   %eax,%eax
8010157d:	0f 48 c2             	cmovs  %edx,%eax
80101580:	c1 f8 03             	sar    $0x3,%eax
80101583:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101586:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010158b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010158e:	f7 d1                	not    %ecx
80101590:	21 ca                	and    %ecx,%edx
80101592:	89 d1                	mov    %edx,%ecx
80101594:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101597:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159e:	89 04 24             	mov    %eax,(%esp)
801015a1:	e8 87 20 00 00       	call   8010362d <log_write>
  brelse(bp);
801015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a9:	89 04 24             	mov    %eax,(%esp)
801015ac:	e8 66 ec ff ff       	call   80100217 <brelse>
}
801015b1:	c9                   	leave  
801015b2:	c3                   	ret    

801015b3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b3:	55                   	push   %ebp
801015b4:	89 e5                	mov    %esp,%ebp
801015b6:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015b9:	c7 44 24 04 9a 87 10 	movl   $0x8010879a,0x4(%esp)
801015c0:	80 
801015c1:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801015c8:	e8 90 3a 00 00       	call   8010505d <initlock>
}
801015cd:	c9                   	leave  
801015ce:	c3                   	ret    

801015cf <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015cf:	55                   	push   %ebp
801015d0:	89 e5                	mov    %esp,%ebp
801015d2:	83 ec 38             	sub    $0x38,%esp
801015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d8:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 12 fd ff ff       	call   80101300 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f5:	e9 98 00 00 00       	jmp    80101692 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fd:	c1 e8 03             	shr    $0x3,%eax
80101600:	83 c0 02             	add    $0x2,%eax
80101603:	89 44 24 04          	mov    %eax,0x4(%esp)
80101607:	8b 45 08             	mov    0x8(%ebp),%eax
8010160a:	89 04 24             	mov    %eax,(%esp)
8010160d:	e8 94 eb ff ff       	call   801001a6 <bread>
80101612:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101615:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101618:	8d 50 18             	lea    0x18(%eax),%edx
8010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161e:	83 e0 07             	and    $0x7,%eax
80101621:	c1 e0 06             	shl    $0x6,%eax
80101624:	01 d0                	add    %edx,%eax
80101626:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101629:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162c:	0f b7 00             	movzwl (%eax),%eax
8010162f:	66 85 c0             	test   %ax,%ax
80101632:	75 4f                	jne    80101683 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101634:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163b:	00 
8010163c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101643:	00 
80101644:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101647:	89 04 24             	mov    %eax,(%esp)
8010164a:	e8 83 3c 00 00       	call   801052d2 <memset>
      dip->type = type;
8010164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101652:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101656:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165c:	89 04 24             	mov    %eax,(%esp)
8010165f:	e8 c9 1f 00 00       	call   8010362d <log_write>
      brelse(bp);
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	89 04 24             	mov    %eax,(%esp)
8010166a:	e8 a8 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101672:	89 44 24 04          	mov    %eax,0x4(%esp)
80101676:	8b 45 08             	mov    0x8(%ebp),%eax
80101679:	89 04 24             	mov    %eax,(%esp)
8010167c:	e8 e5 00 00 00       	call   80101766 <iget>
80101681:	eb 29                	jmp    801016ac <ialloc+0xdd>
    }
    brelse(bp);
80101683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101686:	89 04 24             	mov    %eax,(%esp)
80101689:	e8 89 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010168e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101698:	39 c2                	cmp    %eax,%edx
8010169a:	0f 82 5a ff ff ff    	jb     801015fa <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a0:	c7 04 24 a1 87 10 80 	movl   $0x801087a1,(%esp)
801016a7:	e8 8e ee ff ff       	call   8010053a <panic>
}
801016ac:	c9                   	leave  
801016ad:	c3                   	ret    

801016ae <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016ae:	55                   	push   %ebp
801016af:	89 e5                	mov    %esp,%ebp
801016b1:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b4:	8b 45 08             	mov    0x8(%ebp),%eax
801016b7:	8b 40 04             	mov    0x4(%eax),%eax
801016ba:	c1 e8 03             	shr    $0x3,%eax
801016bd:	8d 50 02             	lea    0x2(%eax),%edx
801016c0:	8b 45 08             	mov    0x8(%ebp),%eax
801016c3:	8b 00                	mov    (%eax),%eax
801016c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801016c9:	89 04 24             	mov    %eax,(%esp)
801016cc:	e8 d5 ea ff ff       	call   801001a6 <bread>
801016d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d7:	8d 50 18             	lea    0x18(%eax),%edx
801016da:	8b 45 08             	mov    0x8(%ebp),%eax
801016dd:	8b 40 04             	mov    0x4(%eax),%eax
801016e0:	83 e0 07             	and    $0x7,%eax
801016e3:	c1 e0 06             	shl    $0x6,%eax
801016e6:	01 d0                	add    %edx,%eax
801016e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016eb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ee:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f8:	8b 45 08             	mov    0x8(%ebp),%eax
801016fb:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101702:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101706:	8b 45 08             	mov    0x8(%ebp),%eax
80101709:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101710:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101714:	8b 45 08             	mov    0x8(%ebp),%eax
80101717:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101722:	8b 45 08             	mov    0x8(%ebp),%eax
80101725:	8b 50 18             	mov    0x18(%eax),%edx
80101728:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172e:	8b 45 08             	mov    0x8(%ebp),%eax
80101731:	8d 50 1c             	lea    0x1c(%eax),%edx
80101734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101737:	83 c0 0c             	add    $0xc,%eax
8010173a:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101741:	00 
80101742:	89 54 24 04          	mov    %edx,0x4(%esp)
80101746:	89 04 24             	mov    %eax,(%esp)
80101749:	e8 53 3c 00 00       	call   801053a1 <memmove>
  log_write(bp);
8010174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101751:	89 04 24             	mov    %eax,(%esp)
80101754:	e8 d4 1e 00 00       	call   8010362d <log_write>
  brelse(bp);
80101759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175c:	89 04 24             	mov    %eax,(%esp)
8010175f:	e8 b3 ea ff ff       	call   80100217 <brelse>
}
80101764:	c9                   	leave  
80101765:	c3                   	ret    

80101766 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101766:	55                   	push   %ebp
80101767:	89 e5                	mov    %esp,%ebp
80101769:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176c:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101773:	e8 06 39 00 00       	call   8010507e <acquire>

  // Is the inode already cached?
  empty = 0;
80101778:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010177f:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
80101786:	eb 59                	jmp    801017e1 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178b:	8b 40 08             	mov    0x8(%eax),%eax
8010178e:	85 c0                	test   %eax,%eax
80101790:	7e 35                	jle    801017c7 <iget+0x61>
80101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101795:	8b 00                	mov    (%eax),%eax
80101797:	3b 45 08             	cmp    0x8(%ebp),%eax
8010179a:	75 2b                	jne    801017c7 <iget+0x61>
8010179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179f:	8b 40 04             	mov    0x4(%eax),%eax
801017a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a5:	75 20                	jne    801017c7 <iget+0x61>
      ip->ref++;
801017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017aa:	8b 40 08             	mov    0x8(%eax),%eax
801017ad:	8d 50 01             	lea    0x1(%eax),%edx
801017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b3:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b6:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801017bd:	e8 1e 39 00 00       	call   801050e0 <release>
      return ip;
801017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c5:	eb 6f                	jmp    80101836 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017cb:	75 10                	jne    801017dd <iget+0x77>
801017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d0:	8b 40 08             	mov    0x8(%eax),%eax
801017d3:	85 c0                	test   %eax,%eax
801017d5:	75 06                	jne    801017dd <iget+0x77>
      empty = ip;
801017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017da:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017dd:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017e1:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
801017e8:	72 9e                	jb     80101788 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ee:	75 0c                	jne    801017fc <iget+0x96>
    panic("iget: no inodes");
801017f0:	c7 04 24 b3 87 10 80 	movl   $0x801087b3,(%esp)
801017f7:	e8 3e ed ff ff       	call   8010053a <panic>

  ip = empty;
801017fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101805:	8b 55 08             	mov    0x8(%ebp),%edx
80101808:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101810:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101816:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101820:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101827:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
8010182e:	e8 ad 38 00 00       	call   801050e0 <release>

  return ip;
80101833:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101836:	c9                   	leave  
80101837:	c3                   	ret    

80101838 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101838:	55                   	push   %ebp
80101839:	89 e5                	mov    %esp,%ebp
8010183b:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010183e:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101845:	e8 34 38 00 00       	call   8010507e <acquire>
  ip->ref++;
8010184a:	8b 45 08             	mov    0x8(%ebp),%eax
8010184d:	8b 40 08             	mov    0x8(%eax),%eax
80101850:	8d 50 01             	lea    0x1(%eax),%edx
80101853:	8b 45 08             	mov    0x8(%ebp),%eax
80101856:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101859:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101860:	e8 7b 38 00 00       	call   801050e0 <release>
  return ip;
80101865:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101868:	c9                   	leave  
80101869:	c3                   	ret    

8010186a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010186a:	55                   	push   %ebp
8010186b:	89 e5                	mov    %esp,%ebp
8010186d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101870:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101874:	74 0a                	je     80101880 <ilock+0x16>
80101876:	8b 45 08             	mov    0x8(%ebp),%eax
80101879:	8b 40 08             	mov    0x8(%eax),%eax
8010187c:	85 c0                	test   %eax,%eax
8010187e:	7f 0c                	jg     8010188c <ilock+0x22>
    panic("ilock");
80101880:	c7 04 24 c3 87 10 80 	movl   $0x801087c3,(%esp)
80101887:	e8 ae ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010188c:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101893:	e8 e6 37 00 00       	call   8010507e <acquire>
  while(ip->flags & I_BUSY)
80101898:	eb 13                	jmp    801018ad <ilock+0x43>
    sleep(ip, &icache.lock);
8010189a:	c7 44 24 04 40 12 11 	movl   $0x80111240,0x4(%esp)
801018a1:	80 
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	89 04 24             	mov    %eax,(%esp)
801018a8:	e8 c3 34 00 00       	call   80104d70 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ad:	8b 45 08             	mov    0x8(%ebp),%eax
801018b0:	8b 40 0c             	mov    0xc(%eax),%eax
801018b3:	83 e0 01             	and    $0x1,%eax
801018b6:	85 c0                	test   %eax,%eax
801018b8:	75 e0                	jne    8010189a <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018ba:	8b 45 08             	mov    0x8(%ebp),%eax
801018bd:	8b 40 0c             	mov    0xc(%eax),%eax
801018c0:	83 c8 01             	or     $0x1,%eax
801018c3:	89 c2                	mov    %eax,%edx
801018c5:	8b 45 08             	mov    0x8(%ebp),%eax
801018c8:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018cb:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801018d2:	e8 09 38 00 00       	call   801050e0 <release>

  if(!(ip->flags & I_VALID)){
801018d7:	8b 45 08             	mov    0x8(%ebp),%eax
801018da:	8b 40 0c             	mov    0xc(%eax),%eax
801018dd:	83 e0 02             	and    $0x2,%eax
801018e0:	85 c0                	test   %eax,%eax
801018e2:	0f 85 ce 00 00 00    	jne    801019b6 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018e8:	8b 45 08             	mov    0x8(%ebp),%eax
801018eb:	8b 40 04             	mov    0x4(%eax),%eax
801018ee:	c1 e8 03             	shr    $0x3,%eax
801018f1:	8d 50 02             	lea    0x2(%eax),%edx
801018f4:	8b 45 08             	mov    0x8(%ebp),%eax
801018f7:	8b 00                	mov    (%eax),%eax
801018f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801018fd:	89 04 24             	mov    %eax,(%esp)
80101900:	e8 a1 e8 ff ff       	call   801001a6 <bread>
80101905:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190b:	8d 50 18             	lea    0x18(%eax),%edx
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	8b 40 04             	mov    0x4(%eax),%eax
80101914:	83 e0 07             	and    $0x7,%eax
80101917:	c1 e0 06             	shl    $0x6,%eax
8010191a:	01 d0                	add    %edx,%eax
8010191c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010191f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101922:	0f b7 10             	movzwl (%eax),%edx
80101925:	8b 45 08             	mov    0x8(%ebp),%eax
80101928:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101933:	8b 45 08             	mov    0x8(%ebp),%eax
80101936:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101941:	8b 45 08             	mov    0x8(%ebp),%eax
80101944:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010194f:	8b 45 08             	mov    0x8(%ebp),%eax
80101952:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101959:	8b 50 08             	mov    0x8(%eax),%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101962:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101965:	8d 50 0c             	lea    0xc(%eax),%edx
80101968:	8b 45 08             	mov    0x8(%ebp),%eax
8010196b:	83 c0 1c             	add    $0x1c,%eax
8010196e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101975:	00 
80101976:	89 54 24 04          	mov    %edx,0x4(%esp)
8010197a:	89 04 24             	mov    %eax,(%esp)
8010197d:	e8 1f 3a 00 00       	call   801053a1 <memmove>
    brelse(bp);
80101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101985:	89 04 24             	mov    %eax,(%esp)
80101988:	e8 8a e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	8b 40 0c             	mov    0xc(%eax),%eax
80101993:	83 c8 02             	or     $0x2,%eax
80101996:	89 c2                	mov    %eax,%edx
80101998:	8b 45 08             	mov    0x8(%ebp),%eax
8010199b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a5:	66 85 c0             	test   %ax,%ax
801019a8:	75 0c                	jne    801019b6 <ilock+0x14c>
      panic("ilock: no type");
801019aa:	c7 04 24 c9 87 10 80 	movl   $0x801087c9,(%esp)
801019b1:	e8 84 eb ff ff       	call   8010053a <panic>
  }
}
801019b6:	c9                   	leave  
801019b7:	c3                   	ret    

801019b8 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019b8:	55                   	push   %ebp
801019b9:	89 e5                	mov    %esp,%ebp
801019bb:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c2:	74 17                	je     801019db <iunlock+0x23>
801019c4:	8b 45 08             	mov    0x8(%ebp),%eax
801019c7:	8b 40 0c             	mov    0xc(%eax),%eax
801019ca:	83 e0 01             	and    $0x1,%eax
801019cd:	85 c0                	test   %eax,%eax
801019cf:	74 0a                	je     801019db <iunlock+0x23>
801019d1:	8b 45 08             	mov    0x8(%ebp),%eax
801019d4:	8b 40 08             	mov    0x8(%eax),%eax
801019d7:	85 c0                	test   %eax,%eax
801019d9:	7f 0c                	jg     801019e7 <iunlock+0x2f>
    panic("iunlock");
801019db:	c7 04 24 d8 87 10 80 	movl   $0x801087d8,(%esp)
801019e2:	e8 53 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019e7:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801019ee:	e8 8b 36 00 00       	call   8010507e <acquire>
  ip->flags &= ~I_BUSY;
801019f3:	8b 45 08             	mov    0x8(%ebp),%eax
801019f6:	8b 40 0c             	mov    0xc(%eax),%eax
801019f9:	83 e0 fe             	and    $0xfffffffe,%eax
801019fc:	89 c2                	mov    %eax,%edx
801019fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101a01:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	89 04 24             	mov    %eax,(%esp)
80101a0a:	e8 59 34 00 00       	call   80104e68 <wakeup>
  release(&icache.lock);
80101a0f:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a16:	e8 c5 36 00 00       	call   801050e0 <release>
}
80101a1b:	c9                   	leave  
80101a1c:	c3                   	ret    

80101a1d <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a1d:	55                   	push   %ebp
80101a1e:	89 e5                	mov    %esp,%ebp
80101a20:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a23:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a2a:	e8 4f 36 00 00       	call   8010507e <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a32:	8b 40 08             	mov    0x8(%eax),%eax
80101a35:	83 f8 01             	cmp    $0x1,%eax
80101a38:	0f 85 93 00 00 00    	jne    80101ad1 <iput+0xb4>
80101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a41:	8b 40 0c             	mov    0xc(%eax),%eax
80101a44:	83 e0 02             	and    $0x2,%eax
80101a47:	85 c0                	test   %eax,%eax
80101a49:	0f 84 82 00 00 00    	je     80101ad1 <iput+0xb4>
80101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a52:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a56:	66 85 c0             	test   %ax,%ax
80101a59:	75 76                	jne    80101ad1 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5e:	8b 40 0c             	mov    0xc(%eax),%eax
80101a61:	83 e0 01             	and    $0x1,%eax
80101a64:	85 c0                	test   %eax,%eax
80101a66:	74 0c                	je     80101a74 <iput+0x57>
      panic("iput busy");
80101a68:	c7 04 24 e0 87 10 80 	movl   $0x801087e0,(%esp)
80101a6f:	e8 c6 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a74:	8b 45 08             	mov    0x8(%ebp),%eax
80101a77:	8b 40 0c             	mov    0xc(%eax),%eax
80101a7a:	83 c8 01             	or     $0x1,%eax
80101a7d:	89 c2                	mov    %eax,%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a85:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a8c:	e8 4f 36 00 00       	call   801050e0 <release>
    itrunc(ip);
80101a91:	8b 45 08             	mov    0x8(%ebp),%eax
80101a94:	89 04 24             	mov    %eax,(%esp)
80101a97:	e8 7d 01 00 00       	call   80101c19 <itrunc>
    ip->type = 0;
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	89 04 24             	mov    %eax,(%esp)
80101aab:	e8 fe fb ff ff       	call   801016ae <iupdate>
    acquire(&icache.lock);
80101ab0:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101ab7:	e8 c2 35 00 00       	call   8010507e <acquire>
    ip->flags = 0;
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	89 04 24             	mov    %eax,(%esp)
80101acc:	e8 97 33 00 00       	call   80104e68 <wakeup>
  }
  ip->ref--;
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	8b 40 08             	mov    0x8(%eax),%eax
80101ad7:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae0:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101ae7:	e8 f4 35 00 00       	call   801050e0 <release>
}
80101aec:	c9                   	leave  
80101aed:	c3                   	ret    

80101aee <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aee:	55                   	push   %ebp
80101aef:	89 e5                	mov    %esp,%ebp
80101af1:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af4:	8b 45 08             	mov    0x8(%ebp),%eax
80101af7:	89 04 24             	mov    %eax,(%esp)
80101afa:	e8 b9 fe ff ff       	call   801019b8 <iunlock>
  iput(ip);
80101aff:	8b 45 08             	mov    0x8(%ebp),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 13 ff ff ff       	call   80101a1d <iput>
}
80101b0a:	c9                   	leave  
80101b0b:	c3                   	ret    

80101b0c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0c:	55                   	push   %ebp
80101b0d:	89 e5                	mov    %esp,%ebp
80101b0f:	53                   	push   %ebx
80101b10:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b13:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b17:	77 3e                	ja     80101b57 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b1f:	83 c2 04             	add    $0x4,%edx
80101b22:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b2d:	75 20                	jne    80101b4f <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	8b 00                	mov    (%eax),%eax
80101b34:	89 04 24             	mov    %eax,(%esp)
80101b37:	e8 5b f8 ff ff       	call   80101397 <balloc>
80101b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b42:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b45:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b4b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b52:	e9 bc 00 00 00       	jmp    80101c13 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b57:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b5b:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b5f:	0f 87 a2 00 00 00    	ja     80101c07 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b72:	75 19                	jne    80101b8d <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b74:	8b 45 08             	mov    0x8(%ebp),%eax
80101b77:	8b 00                	mov    (%eax),%eax
80101b79:	89 04 24             	mov    %eax,(%esp)
80101b7c:	e8 16 f8 ff ff       	call   80101397 <balloc>
80101b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b84:	8b 45 08             	mov    0x8(%ebp),%eax
80101b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b8a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	8b 00                	mov    (%eax),%eax
80101b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b95:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b99:	89 04 24             	mov    %eax,(%esp)
80101b9c:	e8 05 e6 ff ff       	call   801001a6 <bread>
80101ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba7:	83 c0 18             	add    $0x18,%eax
80101baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bba:	01 d0                	add    %edx,%eax
80101bbc:	8b 00                	mov    (%eax),%eax
80101bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc5:	75 30                	jne    80101bf7 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bd4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bda:	8b 00                	mov    (%eax),%eax
80101bdc:	89 04 24             	mov    %eax,(%esp)
80101bdf:	e8 b3 f7 ff ff       	call   80101397 <balloc>
80101be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bea:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bef:	89 04 24             	mov    %eax,(%esp)
80101bf2:	e8 36 1a 00 00       	call   8010362d <log_write>
    }
    brelse(bp);
80101bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfa:	89 04 24             	mov    %eax,(%esp)
80101bfd:	e8 15 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c05:	eb 0c                	jmp    80101c13 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c07:	c7 04 24 ea 87 10 80 	movl   $0x801087ea,(%esp)
80101c0e:	e8 27 e9 ff ff       	call   8010053a <panic>
}
80101c13:	83 c4 24             	add    $0x24,%esp
80101c16:	5b                   	pop    %ebx
80101c17:	5d                   	pop    %ebp
80101c18:	c3                   	ret    

80101c19 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c19:	55                   	push   %ebp
80101c1a:	89 e5                	mov    %esp,%ebp
80101c1c:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c26:	eb 44                	jmp    80101c6c <itrunc+0x53>
    if(ip->addrs[i]){
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2e:	83 c2 04             	add    $0x4,%edx
80101c31:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 2f                	je     80101c68 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3f:	83 c2 04             	add    $0x4,%edx
80101c42:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c46:	8b 45 08             	mov    0x8(%ebp),%eax
80101c49:	8b 00                	mov    (%eax),%eax
80101c4b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c4f:	89 04 24             	mov    %eax,(%esp)
80101c52:	e8 8e f8 ff ff       	call   801014e5 <bfree>
      ip->addrs[i] = 0;
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c5d:	83 c2 04             	add    $0x4,%edx
80101c60:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c67:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c6c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c70:	7e b6                	jle    80101c28 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c72:	8b 45 08             	mov    0x8(%ebp),%eax
80101c75:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c78:	85 c0                	test   %eax,%eax
80101c7a:	0f 84 9b 00 00 00    	je     80101d1b <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c80:	8b 45 08             	mov    0x8(%ebp),%eax
80101c83:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c86:	8b 45 08             	mov    0x8(%ebp),%eax
80101c89:	8b 00                	mov    (%eax),%eax
80101c8b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c8f:	89 04 24             	mov    %eax,(%esp)
80101c92:	e8 0f e5 ff ff       	call   801001a6 <bread>
80101c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9d:	83 c0 18             	add    $0x18,%eax
80101ca0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ca3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101caa:	eb 3b                	jmp    80101ce7 <itrunc+0xce>
      if(a[j])
80101cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101caf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cb9:	01 d0                	add    %edx,%eax
80101cbb:	8b 00                	mov    (%eax),%eax
80101cbd:	85 c0                	test   %eax,%eax
80101cbf:	74 22                	je     80101ce3 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cce:	01 d0                	add    %edx,%eax
80101cd0:	8b 10                	mov    (%eax),%edx
80101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd5:	8b 00                	mov    (%eax),%eax
80101cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cdb:	89 04 24             	mov    %eax,(%esp)
80101cde:	e8 02 f8 ff ff       	call   801014e5 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ce3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cea:	83 f8 7f             	cmp    $0x7f,%eax
80101ced:	76 bd                	jbe    80101cac <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf2:	89 04 24             	mov    %eax,(%esp)
80101cf5:	e8 1d e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 00                	mov    (%eax),%eax
80101d05:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d09:	89 04 24             	mov    %eax,(%esp)
80101d0c:	e8 d4 f7 ff ff       	call   801014e5 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d11:	8b 45 08             	mov    0x8(%ebp),%eax
80101d14:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	89 04 24             	mov    %eax,(%esp)
80101d2b:	e8 7e f9 ff ff       	call   801016ae <iupdate>
}
80101d30:	c9                   	leave  
80101d31:	c3                   	ret    

80101d32 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d32:	55                   	push   %ebp
80101d33:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	8b 00                	mov    (%eax),%eax
80101d3a:	89 c2                	mov    %eax,%edx
80101d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3f:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	8b 50 04             	mov    0x4(%eax),%edx
80101d48:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4b:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d58:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d62:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d65:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d69:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6c:	8b 50 18             	mov    0x18(%eax),%edx
80101d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d72:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d75:	5d                   	pop    %ebp
80101d76:	c3                   	ret    

80101d77 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d77:	55                   	push   %ebp
80101d78:	89 e5                	mov    %esp,%ebp
80101d7a:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d84:	66 83 f8 03          	cmp    $0x3,%ax
80101d88:	75 60                	jne    80101dea <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d91:	66 85 c0             	test   %ax,%ax
80101d94:	78 20                	js     80101db6 <readi+0x3f>
80101d96:	8b 45 08             	mov    0x8(%ebp),%eax
80101d99:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9d:	66 83 f8 09          	cmp    $0x9,%ax
80101da1:	7f 13                	jg     80101db6 <readi+0x3f>
80101da3:	8b 45 08             	mov    0x8(%ebp),%eax
80101da6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101daa:	98                   	cwtl   
80101dab:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 0a                	jne    80101dc0 <readi+0x49>
      return -1;
80101db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dbb:	e9 19 01 00 00       	jmp    80101ed9 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc7:	98                   	cwtl   
80101dc8:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101dcf:	8b 55 14             	mov    0x14(%ebp),%edx
80101dd2:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dd9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ddd:	8b 55 08             	mov    0x8(%ebp),%edx
80101de0:	89 14 24             	mov    %edx,(%esp)
80101de3:	ff d0                	call   *%eax
80101de5:	e9 ef 00 00 00       	jmp    80101ed9 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ded:	8b 40 18             	mov    0x18(%eax),%eax
80101df0:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df3:	72 0d                	jb     80101e02 <readi+0x8b>
80101df5:	8b 45 14             	mov    0x14(%ebp),%eax
80101df8:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfb:	01 d0                	add    %edx,%eax
80101dfd:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e00:	73 0a                	jae    80101e0c <readi+0x95>
    return -1;
80101e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e07:	e9 cd 00 00 00       	jmp    80101ed9 <readi+0x162>
  if(off + n > ip->size)
80101e0c:	8b 45 14             	mov    0x14(%ebp),%eax
80101e0f:	8b 55 10             	mov    0x10(%ebp),%edx
80101e12:	01 c2                	add    %eax,%edx
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	8b 40 18             	mov    0x18(%eax),%eax
80101e1a:	39 c2                	cmp    %eax,%edx
80101e1c:	76 0c                	jbe    80101e2a <readi+0xb3>
    n = ip->size - off;
80101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e21:	8b 40 18             	mov    0x18(%eax),%eax
80101e24:	2b 45 10             	sub    0x10(%ebp),%eax
80101e27:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e31:	e9 94 00 00 00       	jmp    80101eca <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e36:	8b 45 10             	mov    0x10(%ebp),%eax
80101e39:	c1 e8 09             	shr    $0x9,%eax
80101e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e40:	8b 45 08             	mov    0x8(%ebp),%eax
80101e43:	89 04 24             	mov    %eax,(%esp)
80101e46:	e8 c1 fc ff ff       	call   80101b0c <bmap>
80101e4b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4e:	8b 12                	mov    (%edx),%edx
80101e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e54:	89 14 24             	mov    %edx,(%esp)
80101e57:	e8 4a e3 ff ff       	call   801001a6 <bread>
80101e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e5f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e62:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e67:	89 c2                	mov    %eax,%edx
80101e69:	b8 00 02 00 00       	mov    $0x200,%eax
80101e6e:	29 d0                	sub    %edx,%eax
80101e70:	89 c2                	mov    %eax,%edx
80101e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e75:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e78:	29 c1                	sub    %eax,%ecx
80101e7a:	89 c8                	mov    %ecx,%eax
80101e7c:	39 c2                	cmp    %eax,%edx
80101e7e:	0f 46 c2             	cmovbe %edx,%eax
80101e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e84:	8b 45 10             	mov    0x10(%ebp),%eax
80101e87:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e8c:	8d 50 10             	lea    0x10(%eax),%edx
80101e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e92:	01 d0                	add    %edx,%eax
80101e94:	8d 50 08             	lea    0x8(%eax),%edx
80101e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e9e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea5:	89 04 24             	mov    %eax,(%esp)
80101ea8:	e8 f4 34 00 00       	call   801053a1 <memmove>
    brelse(bp);
80101ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 5f e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ebb:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec1:	01 45 10             	add    %eax,0x10(%ebp)
80101ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec7:	01 45 0c             	add    %eax,0xc(%ebp)
80101eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ecd:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ed0:	0f 82 60 ff ff ff    	jb     80101e36 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ed6:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ed9:	c9                   	leave  
80101eda:	c3                   	ret    

80101edb <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101edb:	55                   	push   %ebp
80101edc:	89 e5                	mov    %esp,%ebp
80101ede:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ee8:	66 83 f8 03          	cmp    $0x3,%ax
80101eec:	75 60                	jne    80101f4e <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101eee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef5:	66 85 c0             	test   %ax,%ax
80101ef8:	78 20                	js     80101f1a <writei+0x3f>
80101efa:	8b 45 08             	mov    0x8(%ebp),%eax
80101efd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f01:	66 83 f8 09          	cmp    $0x9,%ax
80101f05:	7f 13                	jg     80101f1a <writei+0x3f>
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0e:	98                   	cwtl   
80101f0f:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f16:	85 c0                	test   %eax,%eax
80101f18:	75 0a                	jne    80101f24 <writei+0x49>
      return -1;
80101f1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1f:	e9 44 01 00 00       	jmp    80102068 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f24:	8b 45 08             	mov    0x8(%ebp),%eax
80101f27:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2b:	98                   	cwtl   
80101f2c:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f33:	8b 55 14             	mov    0x14(%ebp),%edx
80101f36:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f41:	8b 55 08             	mov    0x8(%ebp),%edx
80101f44:	89 14 24             	mov    %edx,(%esp)
80101f47:	ff d0                	call   *%eax
80101f49:	e9 1a 01 00 00       	jmp    80102068 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f51:	8b 40 18             	mov    0x18(%eax),%eax
80101f54:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f57:	72 0d                	jb     80101f66 <writei+0x8b>
80101f59:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5c:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5f:	01 d0                	add    %edx,%eax
80101f61:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f64:	73 0a                	jae    80101f70 <writei+0x95>
    return -1;
80101f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6b:	e9 f8 00 00 00       	jmp    80102068 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f70:	8b 45 14             	mov    0x14(%ebp),%eax
80101f73:	8b 55 10             	mov    0x10(%ebp),%edx
80101f76:	01 d0                	add    %edx,%eax
80101f78:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f7d:	76 0a                	jbe    80101f89 <writei+0xae>
    return -1;
80101f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f84:	e9 df 00 00 00       	jmp    80102068 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f90:	e9 9f 00 00 00       	jmp    80102034 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f95:	8b 45 10             	mov    0x10(%ebp),%eax
80101f98:	c1 e8 09             	shr    $0x9,%eax
80101f9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa2:	89 04 24             	mov    %eax,(%esp)
80101fa5:	e8 62 fb ff ff       	call   80101b0c <bmap>
80101faa:	8b 55 08             	mov    0x8(%ebp),%edx
80101fad:	8b 12                	mov    (%edx),%edx
80101faf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb3:	89 14 24             	mov    %edx,(%esp)
80101fb6:	e8 eb e1 ff ff       	call   801001a6 <bread>
80101fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fbe:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc6:	89 c2                	mov    %eax,%edx
80101fc8:	b8 00 02 00 00       	mov    $0x200,%eax
80101fcd:	29 d0                	sub    %edx,%eax
80101fcf:	89 c2                	mov    %eax,%edx
80101fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fd7:	29 c1                	sub    %eax,%ecx
80101fd9:	89 c8                	mov    %ecx,%eax
80101fdb:	39 c2                	cmp    %eax,%edx
80101fdd:	0f 46 c2             	cmovbe %edx,%eax
80101fe0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101feb:	8d 50 10             	lea    0x10(%eax),%edx
80101fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff1:	01 d0                	add    %edx,%eax
80101ff3:	8d 50 08             	lea    0x8(%eax),%edx
80101ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff9:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102000:	89 44 24 04          	mov    %eax,0x4(%esp)
80102004:	89 14 24             	mov    %edx,(%esp)
80102007:	e8 95 33 00 00       	call   801053a1 <memmove>
    log_write(bp);
8010200c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200f:	89 04 24             	mov    %eax,(%esp)
80102012:	e8 16 16 00 00       	call   8010362d <log_write>
    brelse(bp);
80102017:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010201a:	89 04 24             	mov    %eax,(%esp)
8010201d:	e8 f5 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102022:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102025:	01 45 f4             	add    %eax,-0xc(%ebp)
80102028:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202b:	01 45 10             	add    %eax,0x10(%ebp)
8010202e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102031:	01 45 0c             	add    %eax,0xc(%ebp)
80102034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102037:	3b 45 14             	cmp    0x14(%ebp),%eax
8010203a:	0f 82 55 ff ff ff    	jb     80101f95 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102040:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102044:	74 1f                	je     80102065 <writei+0x18a>
80102046:	8b 45 08             	mov    0x8(%ebp),%eax
80102049:	8b 40 18             	mov    0x18(%eax),%eax
8010204c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204f:	73 14                	jae    80102065 <writei+0x18a>
    ip->size = off;
80102051:	8b 45 08             	mov    0x8(%ebp),%eax
80102054:	8b 55 10             	mov    0x10(%ebp),%edx
80102057:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010205a:	8b 45 08             	mov    0x8(%ebp),%eax
8010205d:	89 04 24             	mov    %eax,(%esp)
80102060:	e8 49 f6 ff ff       	call   801016ae <iupdate>
  }
  return n;
80102065:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102068:	c9                   	leave  
80102069:	c3                   	ret    

8010206a <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010206a:	55                   	push   %ebp
8010206b:	89 e5                	mov    %esp,%ebp
8010206d:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102070:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102077:	00 
80102078:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
80102082:	89 04 24             	mov    %eax,(%esp)
80102085:	e8 ba 33 00 00       	call   80105444 <strncmp>
}
8010208a:	c9                   	leave  
8010208b:	c3                   	ret    

8010208c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010208c:	55                   	push   %ebp
8010208d:	89 e5                	mov    %esp,%ebp
8010208f:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102099:	66 83 f8 01          	cmp    $0x1,%ax
8010209d:	74 0c                	je     801020ab <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010209f:	c7 04 24 fd 87 10 80 	movl   $0x801087fd,(%esp)
801020a6:	e8 8f e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020b2:	e9 88 00 00 00       	jmp    8010213f <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b7:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020be:	00 
801020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801020c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020cd:	8b 45 08             	mov    0x8(%ebp),%eax
801020d0:	89 04 24             	mov    %eax,(%esp)
801020d3:	e8 9f fc ff ff       	call   80101d77 <readi>
801020d8:	83 f8 10             	cmp    $0x10,%eax
801020db:	74 0c                	je     801020e9 <dirlookup+0x5d>
      panic("dirlink read");
801020dd:	c7 04 24 0f 88 10 80 	movl   $0x8010880f,(%esp)
801020e4:	e8 51 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020e9:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020ed:	66 85 c0             	test   %ax,%ax
801020f0:	75 02                	jne    801020f4 <dirlookup+0x68>
      continue;
801020f2:	eb 47                	jmp    8010213b <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f7:	83 c0 02             	add    $0x2,%eax
801020fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102101:	89 04 24             	mov    %eax,(%esp)
80102104:	e8 61 ff ff ff       	call   8010206a <namecmp>
80102109:	85 c0                	test   %eax,%eax
8010210b:	75 2e                	jne    8010213b <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010210d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102111:	74 08                	je     8010211b <dirlookup+0x8f>
        *poff = off;
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102119:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010211b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010211f:	0f b7 c0             	movzwl %ax,%eax
80102122:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102125:	8b 45 08             	mov    0x8(%ebp),%eax
80102128:	8b 00                	mov    (%eax),%eax
8010212a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010212d:	89 54 24 04          	mov    %edx,0x4(%esp)
80102131:	89 04 24             	mov    %eax,(%esp)
80102134:	e8 2d f6 ff ff       	call   80101766 <iget>
80102139:	eb 18                	jmp    80102153 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010213f:	8b 45 08             	mov    0x8(%ebp),%eax
80102142:	8b 40 18             	mov    0x18(%eax),%eax
80102145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102148:	0f 87 69 ff ff ff    	ja     801020b7 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010214e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102153:	c9                   	leave  
80102154:	c3                   	ret    

80102155 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102155:	55                   	push   %ebp
80102156:	89 e5                	mov    %esp,%ebp
80102158:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102162:	00 
80102163:	8b 45 0c             	mov    0xc(%ebp),%eax
80102166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010216a:	8b 45 08             	mov    0x8(%ebp),%eax
8010216d:	89 04 24             	mov    %eax,(%esp)
80102170:	e8 17 ff ff ff       	call   8010208c <dirlookup>
80102175:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010217c:	74 15                	je     80102193 <dirlink+0x3e>
    iput(ip);
8010217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102181:	89 04 24             	mov    %eax,(%esp)
80102184:	e8 94 f8 ff ff       	call   80101a1d <iput>
    return -1;
80102189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218e:	e9 b7 00 00 00       	jmp    8010224a <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010219a:	eb 46                	jmp    801021e2 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010219f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021a6:	00 
801021a7:	89 44 24 08          	mov    %eax,0x8(%esp)
801021ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b2:	8b 45 08             	mov    0x8(%ebp),%eax
801021b5:	89 04 24             	mov    %eax,(%esp)
801021b8:	e8 ba fb ff ff       	call   80101d77 <readi>
801021bd:	83 f8 10             	cmp    $0x10,%eax
801021c0:	74 0c                	je     801021ce <dirlink+0x79>
      panic("dirlink read");
801021c2:	c7 04 24 0f 88 10 80 	movl   $0x8010880f,(%esp)
801021c9:	e8 6c e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021ce:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d2:	66 85 c0             	test   %ax,%ax
801021d5:	75 02                	jne    801021d9 <dirlink+0x84>
      break;
801021d7:	eb 16                	jmp    801021ef <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021dc:	83 c0 10             	add    $0x10,%eax
801021df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021e5:	8b 45 08             	mov    0x8(%ebp),%eax
801021e8:	8b 40 18             	mov    0x18(%eax),%eax
801021eb:	39 c2                	cmp    %eax,%edx
801021ed:	72 ad                	jb     8010219c <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021ef:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021f6:	00 
801021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801021fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102201:	83 c0 02             	add    $0x2,%eax
80102204:	89 04 24             	mov    %eax,(%esp)
80102207:	e8 8e 32 00 00       	call   8010549a <strncpy>
  de.inum = inum;
8010220c:	8b 45 10             	mov    0x10(%ebp),%eax
8010220f:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102216:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010221d:	00 
8010221e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102222:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102225:	89 44 24 04          	mov    %eax,0x4(%esp)
80102229:	8b 45 08             	mov    0x8(%ebp),%eax
8010222c:	89 04 24             	mov    %eax,(%esp)
8010222f:	e8 a7 fc ff ff       	call   80101edb <writei>
80102234:	83 f8 10             	cmp    $0x10,%eax
80102237:	74 0c                	je     80102245 <dirlink+0xf0>
    panic("dirlink");
80102239:	c7 04 24 1c 88 10 80 	movl   $0x8010881c,(%esp)
80102240:	e8 f5 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102245:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224a:	c9                   	leave  
8010224b:	c3                   	ret    

8010224c <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010224c:	55                   	push   %ebp
8010224d:	89 e5                	mov    %esp,%ebp
8010224f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102252:	eb 04                	jmp    80102258 <skipelem+0xc>
    path++;
80102254:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	0f b6 00             	movzbl (%eax),%eax
8010225e:	3c 2f                	cmp    $0x2f,%al
80102260:	74 f2                	je     80102254 <skipelem+0x8>
    path++;
  if(*path == 0)
80102262:	8b 45 08             	mov    0x8(%ebp),%eax
80102265:	0f b6 00             	movzbl (%eax),%eax
80102268:	84 c0                	test   %al,%al
8010226a:	75 0a                	jne    80102276 <skipelem+0x2a>
    return 0;
8010226c:	b8 00 00 00 00       	mov    $0x0,%eax
80102271:	e9 86 00 00 00       	jmp    801022fc <skipelem+0xb0>
  s = path;
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010227c:	eb 04                	jmp    80102282 <skipelem+0x36>
    path++;
8010227e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102282:	8b 45 08             	mov    0x8(%ebp),%eax
80102285:	0f b6 00             	movzbl (%eax),%eax
80102288:	3c 2f                	cmp    $0x2f,%al
8010228a:	74 0a                	je     80102296 <skipelem+0x4a>
8010228c:	8b 45 08             	mov    0x8(%ebp),%eax
8010228f:	0f b6 00             	movzbl (%eax),%eax
80102292:	84 c0                	test   %al,%al
80102294:	75 e8                	jne    8010227e <skipelem+0x32>
    path++;
  len = path - s;
80102296:	8b 55 08             	mov    0x8(%ebp),%edx
80102299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229c:	29 c2                	sub    %eax,%edx
8010229e:	89 d0                	mov    %edx,%eax
801022a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022a3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022a7:	7e 1c                	jle    801022c5 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022a9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022b0:	00 
801022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801022bb:	89 04 24             	mov    %eax,(%esp)
801022be:	e8 de 30 00 00       	call   801053a1 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c3:	eb 2a                	jmp    801022ef <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022c8:	89 44 24 08          	mov    %eax,0x8(%esp)
801022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d6:	89 04 24             	mov    %eax,(%esp)
801022d9:	e8 c3 30 00 00       	call   801053a1 <memmove>
    name[len] = 0;
801022de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e4:	01 d0                	add    %edx,%eax
801022e6:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022e9:	eb 04                	jmp    801022ef <skipelem+0xa3>
    path++;
801022eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ef:	8b 45 08             	mov    0x8(%ebp),%eax
801022f2:	0f b6 00             	movzbl (%eax),%eax
801022f5:	3c 2f                	cmp    $0x2f,%al
801022f7:	74 f2                	je     801022eb <skipelem+0x9f>
    path++;
  return path;
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022fc:	c9                   	leave  
801022fd:	c3                   	ret    

801022fe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022fe:	55                   	push   %ebp
801022ff:	89 e5                	mov    %esp,%ebp
80102301:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102304:	8b 45 08             	mov    0x8(%ebp),%eax
80102307:	0f b6 00             	movzbl (%eax),%eax
8010230a:	3c 2f                	cmp    $0x2f,%al
8010230c:	75 1c                	jne    8010232a <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010230e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102315:	00 
80102316:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010231d:	e8 44 f4 ff ff       	call   80101766 <iget>
80102322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(thread->proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102325:	e9 b2 00 00 00       	jmp    801023dc <namex+0xde>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(thread->proc->cwd);
8010232a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102330:	8b 40 0c             	mov    0xc(%eax),%eax
80102333:	8b 40 5c             	mov    0x5c(%eax),%eax
80102336:	89 04 24             	mov    %eax,(%esp)
80102339:	e8 fa f4 ff ff       	call   80101838 <idup>
8010233e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102341:	e9 96 00 00 00       	jmp    801023dc <namex+0xde>
    ilock(ip);
80102346:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102349:	89 04 24             	mov    %eax,(%esp)
8010234c:	e8 19 f5 ff ff       	call   8010186a <ilock>
    if(ip->type != T_DIR){
80102351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102354:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102358:	66 83 f8 01          	cmp    $0x1,%ax
8010235c:	74 15                	je     80102373 <namex+0x75>
      iunlockput(ip);
8010235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102361:	89 04 24             	mov    %eax,(%esp)
80102364:	e8 85 f7 ff ff       	call   80101aee <iunlockput>
      return 0;
80102369:	b8 00 00 00 00       	mov    $0x0,%eax
8010236e:	e9 a3 00 00 00       	jmp    80102416 <namex+0x118>
    }
    if(nameiparent && *path == '\0'){
80102373:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102377:	74 1d                	je     80102396 <namex+0x98>
80102379:	8b 45 08             	mov    0x8(%ebp),%eax
8010237c:	0f b6 00             	movzbl (%eax),%eax
8010237f:	84 c0                	test   %al,%al
80102381:	75 13                	jne    80102396 <namex+0x98>
      // Stop one level early.
      iunlock(ip);
80102383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102386:	89 04 24             	mov    %eax,(%esp)
80102389:	e8 2a f6 ff ff       	call   801019b8 <iunlock>
      return ip;
8010238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102391:	e9 80 00 00 00       	jmp    80102416 <namex+0x118>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102396:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010239d:	00 
8010239e:	8b 45 10             	mov    0x10(%ebp),%eax
801023a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a8:	89 04 24             	mov    %eax,(%esp)
801023ab:	e8 dc fc ff ff       	call   8010208c <dirlookup>
801023b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023b7:	75 12                	jne    801023cb <namex+0xcd>
      iunlockput(ip);
801023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bc:	89 04 24             	mov    %eax,(%esp)
801023bf:	e8 2a f7 ff ff       	call   80101aee <iunlockput>
      return 0;
801023c4:	b8 00 00 00 00       	mov    $0x0,%eax
801023c9:	eb 4b                	jmp    80102416 <namex+0x118>
    }
    iunlockput(ip);
801023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ce:	89 04 24             	mov    %eax,(%esp)
801023d1:	e8 18 f7 ff ff       	call   80101aee <iunlockput>
    ip = next;
801023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(thread->proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023dc:	8b 45 10             	mov    0x10(%ebp),%eax
801023df:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e3:	8b 45 08             	mov    0x8(%ebp),%eax
801023e6:	89 04 24             	mov    %eax,(%esp)
801023e9:	e8 5e fe ff ff       	call   8010224c <skipelem>
801023ee:	89 45 08             	mov    %eax,0x8(%ebp)
801023f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023f5:	0f 85 4b ff ff ff    	jne    80102346 <namex+0x48>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023ff:	74 12                	je     80102413 <namex+0x115>
    iput(ip);
80102401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102404:	89 04 24             	mov    %eax,(%esp)
80102407:	e8 11 f6 ff ff       	call   80101a1d <iput>
    return 0;
8010240c:	b8 00 00 00 00       	mov    $0x0,%eax
80102411:	eb 03                	jmp    80102416 <namex+0x118>
  }
  return ip;
80102413:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102416:	c9                   	leave  
80102417:	c3                   	ret    

80102418 <namei>:

struct inode*
namei(char *path)
{
80102418:	55                   	push   %ebp
80102419:	89 e5                	mov    %esp,%ebp
8010241b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010241e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102421:	89 44 24 08          	mov    %eax,0x8(%esp)
80102425:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010242c:	00 
8010242d:	8b 45 08             	mov    0x8(%ebp),%eax
80102430:	89 04 24             	mov    %eax,(%esp)
80102433:	e8 c6 fe ff ff       	call   801022fe <namex>
}
80102438:	c9                   	leave  
80102439:	c3                   	ret    

8010243a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010243a:	55                   	push   %ebp
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102440:	8b 45 0c             	mov    0xc(%ebp),%eax
80102443:	89 44 24 08          	mov    %eax,0x8(%esp)
80102447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244e:	00 
8010244f:	8b 45 08             	mov    0x8(%ebp),%eax
80102452:	89 04 24             	mov    %eax,(%esp)
80102455:	e8 a4 fe ff ff       	call   801022fe <namex>
}
8010245a:	c9                   	leave  
8010245b:	c3                   	ret    

8010245c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010245c:	55                   	push   %ebp
8010245d:	89 e5                	mov    %esp,%ebp
8010245f:	83 ec 14             	sub    $0x14,%esp
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102469:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010246d:	89 c2                	mov    %eax,%edx
8010246f:	ec                   	in     (%dx),%al
80102470:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102473:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102477:	c9                   	leave  
80102478:	c3                   	ret    

80102479 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102479:	55                   	push   %ebp
8010247a:	89 e5                	mov    %esp,%ebp
8010247c:	57                   	push   %edi
8010247d:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247e:	8b 55 08             	mov    0x8(%ebp),%edx
80102481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102484:	8b 45 10             	mov    0x10(%ebp),%eax
80102487:	89 cb                	mov    %ecx,%ebx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	89 c1                	mov    %eax,%ecx
8010248d:	fc                   	cld    
8010248e:	f3 6d                	rep insl (%dx),%es:(%edi)
80102490:	89 c8                	mov    %ecx,%eax
80102492:	89 fb                	mov    %edi,%ebx
80102494:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102497:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249a:	5b                   	pop    %ebx
8010249b:	5f                   	pop    %edi
8010249c:	5d                   	pop    %ebp
8010249d:	c3                   	ret    

8010249e <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249e:	55                   	push   %ebp
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	83 ec 08             	sub    $0x8,%esp
801024a4:	8b 55 08             	mov    0x8(%ebp),%edx
801024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024aa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024ae:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024b9:	ee                   	out    %al,(%dx)
}
801024ba:	c9                   	leave  
801024bb:	c3                   	ret    

801024bc <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bc:	55                   	push   %ebp
801024bd:	89 e5                	mov    %esp,%ebp
801024bf:	56                   	push   %esi
801024c0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c1:	8b 55 08             	mov    0x8(%ebp),%edx
801024c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c7:	8b 45 10             	mov    0x10(%ebp),%eax
801024ca:	89 cb                	mov    %ecx,%ebx
801024cc:	89 de                	mov    %ebx,%esi
801024ce:	89 c1                	mov    %eax,%ecx
801024d0:	fc                   	cld    
801024d1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d3:	89 c8                	mov    %ecx,%eax
801024d5:	89 f3                	mov    %esi,%ebx
801024d7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024da:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024dd:	5b                   	pop    %ebx
801024de:	5e                   	pop    %esi
801024df:	5d                   	pop    %ebp
801024e0:	c3                   	ret    

801024e1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e1:	55                   	push   %ebp
801024e2:	89 e5                	mov    %esp,%ebp
801024e4:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e7:	90                   	nop
801024e8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024ef:	e8 68 ff ff ff       	call   8010245c <inb>
801024f4:	0f b6 c0             	movzbl %al,%eax
801024f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fd:	25 c0 00 00 00       	and    $0xc0,%eax
80102502:	83 f8 40             	cmp    $0x40,%eax
80102505:	75 e1                	jne    801024e8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250b:	74 11                	je     8010251e <idewait+0x3d>
8010250d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102510:	83 e0 21             	and    $0x21,%eax
80102513:	85 c0                	test   %eax,%eax
80102515:	74 07                	je     8010251e <idewait+0x3d>
    return -1;
80102517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251c:	eb 05                	jmp    80102523 <idewait+0x42>
  return 0;
8010251e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102523:	c9                   	leave  
80102524:	c3                   	ret    

80102525 <ideinit>:

void
ideinit(void)
{
80102525:	55                   	push   %ebp
80102526:	89 e5                	mov    %esp,%ebp
80102528:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252b:	c7 44 24 04 24 88 10 	movl   $0x80108824,0x4(%esp)
80102532:	80 
80102533:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010253a:	e8 1e 2b 00 00       	call   8010505d <initlock>
  picenable(IRQ_IDE);
8010253f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102546:	e8 7b 18 00 00       	call   80103dc6 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254b:	a1 40 29 11 80       	mov    0x80112940,%eax
80102550:	83 e8 01             	sub    $0x1,%eax
80102553:	89 44 24 04          	mov    %eax,0x4(%esp)
80102557:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255e:	e8 0c 04 00 00       	call   8010296f <ioapicenable>
  idewait(0);
80102563:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010256a:	e8 72 ff ff ff       	call   801024e1 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010256f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102576:	00 
80102577:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257e:	e8 1b ff ff ff       	call   8010249e <outb>
  for(i=0; i<1000; i++){
80102583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010258a:	eb 20                	jmp    801025ac <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102593:	e8 c4 fe ff ff       	call   8010245c <inb>
80102598:	84 c0                	test   %al,%al
8010259a:	74 0c                	je     801025a8 <ideinit+0x83>
      havedisk1 = 1;
8010259c:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025a3:	00 00 00 
      break;
801025a6:	eb 0d                	jmp    801025b5 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ac:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b3:	7e d7                	jle    8010258c <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b5:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bc:	00 
801025bd:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c4:	e8 d5 fe ff ff       	call   8010249e <outb>
}
801025c9:	c9                   	leave  
801025ca:	c3                   	ret    

801025cb <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025cb:	55                   	push   %ebp
801025cc:	89 e5                	mov    %esp,%ebp
801025ce:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d5:	75 0c                	jne    801025e3 <idestart+0x18>
    panic("idestart");
801025d7:	c7 04 24 28 88 10 80 	movl   $0x80108828,(%esp)
801025de:	e8 57 df ff ff       	call   8010053a <panic>

  idewait(0);
801025e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025ea:	e8 f2 fe ff ff       	call   801024e1 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f6:	00 
801025f7:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025fe:	e8 9b fe ff ff       	call   8010249e <outb>
  outb(0x1f2, 1);  // number of sectors
80102603:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260a:	00 
8010260b:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102612:	e8 87 fe ff ff       	call   8010249e <outb>
  outb(0x1f3, b->sector & 0xff);
80102617:	8b 45 08             	mov    0x8(%ebp),%eax
8010261a:	8b 40 08             	mov    0x8(%eax),%eax
8010261d:	0f b6 c0             	movzbl %al,%eax
80102620:	89 44 24 04          	mov    %eax,0x4(%esp)
80102624:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262b:	e8 6e fe ff ff       	call   8010249e <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102630:	8b 45 08             	mov    0x8(%ebp),%eax
80102633:	8b 40 08             	mov    0x8(%eax),%eax
80102636:	c1 e8 08             	shr    $0x8,%eax
80102639:	0f b6 c0             	movzbl %al,%eax
8010263c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102640:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102647:	e8 52 fe ff ff       	call   8010249e <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264c:	8b 45 08             	mov    0x8(%ebp),%eax
8010264f:	8b 40 08             	mov    0x8(%eax),%eax
80102652:	c1 e8 10             	shr    $0x10,%eax
80102655:	0f b6 c0             	movzbl %al,%eax
80102658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265c:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102663:	e8 36 fe ff ff       	call   8010249e <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102668:	8b 45 08             	mov    0x8(%ebp),%eax
8010266b:	8b 40 04             	mov    0x4(%eax),%eax
8010266e:	83 e0 01             	and    $0x1,%eax
80102671:	c1 e0 04             	shl    $0x4,%eax
80102674:	89 c2                	mov    %eax,%edx
80102676:	8b 45 08             	mov    0x8(%ebp),%eax
80102679:	8b 40 08             	mov    0x8(%eax),%eax
8010267c:	c1 e8 18             	shr    $0x18,%eax
8010267f:	83 e0 0f             	and    $0xf,%eax
80102682:	09 d0                	or     %edx,%eax
80102684:	83 c8 e0             	or     $0xffffffe0,%eax
80102687:	0f b6 c0             	movzbl %al,%eax
8010268a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102695:	e8 04 fe ff ff       	call   8010249e <outb>
  if(b->flags & B_DIRTY){
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	8b 00                	mov    (%eax),%eax
8010269f:	83 e0 04             	and    $0x4,%eax
801026a2:	85 c0                	test   %eax,%eax
801026a4:	74 34                	je     801026da <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a6:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ad:	00 
801026ae:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b5:	e8 e4 fd ff ff       	call   8010249e <outb>
    outsl(0x1f0, b->data, 512/4);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	83 c0 18             	add    $0x18,%eax
801026c0:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c7:	00 
801026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cc:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d3:	e8 e4 fd ff ff       	call   801024bc <outsl>
801026d8:	eb 14                	jmp    801026ee <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026da:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e1:	00 
801026e2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e9:	e8 b0 fd ff ff       	call   8010249e <outb>
  }
}
801026ee:	c9                   	leave  
801026ef:	c3                   	ret    

801026f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f6:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026fd:	e8 7c 29 00 00       	call   8010507e <acquire>
  if((b = idequeue) == 0){
80102702:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102707:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270e:	75 11                	jne    80102721 <ideintr+0x31>
    release(&idelock);
80102710:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102717:	e8 c4 29 00 00       	call   801050e0 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271c:	e9 90 00 00 00       	jmp    801027b1 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102724:	8b 40 14             	mov    0x14(%eax),%eax
80102727:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272f:	8b 00                	mov    (%eax),%eax
80102731:	83 e0 04             	and    $0x4,%eax
80102734:	85 c0                	test   %eax,%eax
80102736:	75 2e                	jne    80102766 <ideintr+0x76>
80102738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010273f:	e8 9d fd ff ff       	call   801024e1 <idewait>
80102744:	85 c0                	test   %eax,%eax
80102746:	78 1e                	js     80102766 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274b:	83 c0 18             	add    $0x18,%eax
8010274e:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102755:	00 
80102756:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275a:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102761:	e8 13 fd ff ff       	call   80102479 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102769:	8b 00                	mov    (%eax),%eax
8010276b:	83 c8 02             	or     $0x2,%eax
8010276e:	89 c2                	mov    %eax,%edx
80102770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102773:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102778:	8b 00                	mov    (%eax),%eax
8010277a:	83 e0 fb             	and    $0xfffffffb,%eax
8010277d:	89 c2                	mov    %eax,%edx
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102787:	89 04 24             	mov    %eax,(%esp)
8010278a:	e8 d9 26 00 00       	call   80104e68 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010278f:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102794:	85 c0                	test   %eax,%eax
80102796:	74 0d                	je     801027a5 <ideintr+0xb5>
    idestart(idequeue);
80102798:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010279d:	89 04 24             	mov    %eax,(%esp)
801027a0:	e8 26 fe ff ff       	call   801025cb <idestart>

  release(&idelock);
801027a5:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027ac:	e8 2f 29 00 00       	call   801050e0 <release>
}
801027b1:	c9                   	leave  
801027b2:	c3                   	ret    

801027b3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b3:	55                   	push   %ebp
801027b4:	89 e5                	mov    %esp,%ebp
801027b6:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027b9:	8b 45 08             	mov    0x8(%ebp),%eax
801027bc:	8b 00                	mov    (%eax),%eax
801027be:	83 e0 01             	and    $0x1,%eax
801027c1:	85 c0                	test   %eax,%eax
801027c3:	75 0c                	jne    801027d1 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c5:	c7 04 24 31 88 10 80 	movl   $0x80108831,(%esp)
801027cc:	e8 69 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d1:	8b 45 08             	mov    0x8(%ebp),%eax
801027d4:	8b 00                	mov    (%eax),%eax
801027d6:	83 e0 06             	and    $0x6,%eax
801027d9:	83 f8 02             	cmp    $0x2,%eax
801027dc:	75 0c                	jne    801027ea <iderw+0x37>
    panic("iderw: nothing to do");
801027de:	c7 04 24 45 88 10 80 	movl   $0x80108845,(%esp)
801027e5:	e8 50 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027ea:	8b 45 08             	mov    0x8(%ebp),%eax
801027ed:	8b 40 04             	mov    0x4(%eax),%eax
801027f0:	85 c0                	test   %eax,%eax
801027f2:	74 15                	je     80102809 <iderw+0x56>
801027f4:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	75 0c                	jne    80102809 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fd:	c7 04 24 5a 88 10 80 	movl   $0x8010885a,(%esp)
80102804:	e8 31 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102809:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102810:	e8 69 28 00 00       	call   8010507e <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102815:	8b 45 08             	mov    0x8(%ebp),%eax
80102818:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010281f:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102826:	eb 0b                	jmp    80102833 <iderw+0x80>
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	8b 00                	mov    (%eax),%eax
8010282d:	83 c0 14             	add    $0x14,%eax
80102830:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	8b 00                	mov    (%eax),%eax
80102838:	85 c0                	test   %eax,%eax
8010283a:	75 ec                	jne    80102828 <iderw+0x75>
    ;
  *pp = b;
8010283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283f:	8b 55 08             	mov    0x8(%ebp),%edx
80102842:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102844:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102849:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284c:	75 0d                	jne    8010285b <iderw+0xa8>
    idestart(b);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	89 04 24             	mov    %eax,(%esp)
80102854:	e8 72 fd ff ff       	call   801025cb <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102859:	eb 15                	jmp    80102870 <iderw+0xbd>
8010285b:	eb 13                	jmp    80102870 <iderw+0xbd>
    sleep(b, &idelock);
8010285d:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102864:	80 
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
80102868:	89 04 24             	mov    %eax,(%esp)
8010286b:	e8 00 25 00 00       	call   80104d70 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102870:	8b 45 08             	mov    0x8(%ebp),%eax
80102873:	8b 00                	mov    (%eax),%eax
80102875:	83 e0 06             	and    $0x6,%eax
80102878:	83 f8 02             	cmp    $0x2,%eax
8010287b:	75 e0                	jne    8010285d <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102884:	e8 57 28 00 00       	call   801050e0 <release>
}
80102889:	c9                   	leave  
8010288a:	c3                   	ret    

8010288b <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010288b:	55                   	push   %ebp
8010288c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288e:	a1 14 22 11 80       	mov    0x80112214,%eax
80102893:	8b 55 08             	mov    0x8(%ebp),%edx
80102896:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102898:	a1 14 22 11 80       	mov    0x80112214,%eax
8010289d:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a0:	5d                   	pop    %ebp
801028a1:	c3                   	ret    

801028a2 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a2:	55                   	push   %ebp
801028a3:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a5:	a1 14 22 11 80       	mov    0x80112214,%eax
801028aa:	8b 55 08             	mov    0x8(%ebp),%edx
801028ad:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028af:	a1 14 22 11 80       	mov    0x80112214,%eax
801028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801028b7:	89 50 10             	mov    %edx,0x10(%eax)
}
801028ba:	5d                   	pop    %ebp
801028bb:	c3                   	ret    

801028bc <ioapicinit>:

void
ioapicinit(void)
{
801028bc:	55                   	push   %ebp
801028bd:	89 e5                	mov    %esp,%ebp
801028bf:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c2:	a1 44 23 11 80       	mov    0x80112344,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 05                	jne    801028d0 <ioapicinit+0x14>
    return;
801028cb:	e9 9d 00 00 00       	jmp    8010296d <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d0:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
801028d7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e1:	e8 a5 ff ff ff       	call   8010288b <ioapicread>
801028e6:	c1 e8 10             	shr    $0x10,%eax
801028e9:	25 ff 00 00 00       	and    $0xff,%eax
801028ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028f8:	e8 8e ff ff ff       	call   8010288b <ioapicread>
801028fd:	c1 e8 18             	shr    $0x18,%eax
80102900:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102903:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
8010290a:	0f b6 c0             	movzbl %al,%eax
8010290d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102910:	74 0c                	je     8010291e <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102912:	c7 04 24 78 88 10 80 	movl   $0x80108878,(%esp)
80102919:	e8 82 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010291e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102925:	eb 3e                	jmp    80102965 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292a:	83 c0 20             	add    $0x20,%eax
8010292d:	0d 00 00 01 00       	or     $0x10000,%eax
80102932:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102935:	83 c2 08             	add    $0x8,%edx
80102938:	01 d2                	add    %edx,%edx
8010293a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293e:	89 14 24             	mov    %edx,(%esp)
80102941:	e8 5c ff ff ff       	call   801028a2 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102949:	83 c0 08             	add    $0x8,%eax
8010294c:	01 c0                	add    %eax,%eax
8010294e:	83 c0 01             	add    $0x1,%eax
80102951:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102958:	00 
80102959:	89 04 24             	mov    %eax,(%esp)
8010295c:	e8 41 ff ff ff       	call   801028a2 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102961:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102968:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010296b:	7e ba                	jle    80102927 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010296d:	c9                   	leave  
8010296e:	c3                   	ret    

8010296f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010296f:	55                   	push   %ebp
80102970:	89 e5                	mov    %esp,%ebp
80102972:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102975:	a1 44 23 11 80       	mov    0x80112344,%eax
8010297a:	85 c0                	test   %eax,%eax
8010297c:	75 02                	jne    80102980 <ioapicenable+0x11>
    return;
8010297e:	eb 37                	jmp    801029b7 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102980:	8b 45 08             	mov    0x8(%ebp),%eax
80102983:	83 c0 20             	add    $0x20,%eax
80102986:	8b 55 08             	mov    0x8(%ebp),%edx
80102989:	83 c2 08             	add    $0x8,%edx
8010298c:	01 d2                	add    %edx,%edx
8010298e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102992:	89 14 24             	mov    %edx,(%esp)
80102995:	e8 08 ff ff ff       	call   801028a2 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010299d:	c1 e0 18             	shl    $0x18,%eax
801029a0:	8b 55 08             	mov    0x8(%ebp),%edx
801029a3:	83 c2 08             	add    $0x8,%edx
801029a6:	01 d2                	add    %edx,%edx
801029a8:	83 c2 01             	add    $0x1,%edx
801029ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801029af:	89 14 24             	mov    %edx,(%esp)
801029b2:	e8 eb fe ff ff       	call   801028a2 <ioapicwrite>
}
801029b7:	c9                   	leave  
801029b8:	c3                   	ret    

801029b9 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029b9:	55                   	push   %ebp
801029ba:	89 e5                	mov    %esp,%ebp
801029bc:	8b 45 08             	mov    0x8(%ebp),%eax
801029bf:	05 00 00 00 80       	add    $0x80000000,%eax
801029c4:	5d                   	pop    %ebp
801029c5:	c3                   	ret    

801029c6 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029c6:	55                   	push   %ebp
801029c7:	89 e5                	mov    %esp,%ebp
801029c9:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029cc:	c7 44 24 04 aa 88 10 	movl   $0x801088aa,0x4(%esp)
801029d3:	80 
801029d4:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801029db:	e8 7d 26 00 00       	call   8010505d <initlock>
  kmem.use_lock = 0;
801029e0:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
801029e7:	00 00 00 
  freerange(vstart, vend);
801029ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8b 45 08             	mov    0x8(%ebp),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 26 00 00 00       	call   80102a22 <freerange>
}
801029fc:	c9                   	leave  
801029fd:	c3                   	ret    

801029fe <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029fe:	55                   	push   %ebp
801029ff:	89 e5                	mov    %esp,%ebp
80102a01:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0e:	89 04 24             	mov    %eax,(%esp)
80102a11:	e8 0c 00 00 00       	call   80102a22 <freerange>
  kmem.use_lock = 1;
80102a16:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102a1d:	00 00 00 
}
80102a20:	c9                   	leave  
80102a21:	c3                   	ret    

80102a22 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a22:	55                   	push   %ebp
80102a23:	89 e5                	mov    %esp,%ebp
80102a25:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a28:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a38:	eb 12                	jmp    80102a4c <freerange+0x2a>
    kfree(p);
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	89 04 24             	mov    %eax,(%esp)
80102a40:	e8 16 00 00 00       	call   80102a5b <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a45:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4f:	05 00 10 00 00       	add    $0x1000,%eax
80102a54:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a57:	76 e1                	jbe    80102a3a <freerange+0x18>
    kfree(p);
}
80102a59:	c9                   	leave  
80102a5a:	c3                   	ret    

80102a5b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a5b:	55                   	push   %ebp
80102a5c:	89 e5                	mov    %esp,%ebp
80102a5e:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a61:	8b 45 08             	mov    0x8(%ebp),%eax
80102a64:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a69:	85 c0                	test   %eax,%eax
80102a6b:	75 1b                	jne    80102a88 <kfree+0x2d>
80102a6d:	81 7d 08 3c bf 11 80 	cmpl   $0x8011bf3c,0x8(%ebp)
80102a74:	72 12                	jb     80102a88 <kfree+0x2d>
80102a76:	8b 45 08             	mov    0x8(%ebp),%eax
80102a79:	89 04 24             	mov    %eax,(%esp)
80102a7c:	e8 38 ff ff ff       	call   801029b9 <v2p>
80102a81:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a86:	76 0c                	jbe    80102a94 <kfree+0x39>
    panic("kfree");
80102a88:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
80102a8f:	e8 a6 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a9b:	00 
80102a9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aa3:	00 
80102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa7:	89 04 24             	mov    %eax,(%esp)
80102aaa:	e8 23 28 00 00       	call   801052d2 <memset>

  if(kmem.use_lock)
80102aaf:	a1 54 22 11 80       	mov    0x80112254,%eax
80102ab4:	85 c0                	test   %eax,%eax
80102ab6:	74 0c                	je     80102ac4 <kfree+0x69>
    acquire(&kmem.lock);
80102ab8:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102abf:	e8 ba 25 00 00       	call   8010507e <acquire>
  r = (struct run*)v;
80102ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aca:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad3:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102add:	a1 54 22 11 80       	mov    0x80112254,%eax
80102ae2:	85 c0                	test   %eax,%eax
80102ae4:	74 0c                	je     80102af2 <kfree+0x97>
    release(&kmem.lock);
80102ae6:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102aed:	e8 ee 25 00 00       	call   801050e0 <release>
}
80102af2:	c9                   	leave  
80102af3:	c3                   	ret    

80102af4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102af4:	55                   	push   %ebp
80102af5:	89 e5                	mov    %esp,%ebp
80102af7:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102afa:	a1 54 22 11 80       	mov    0x80112254,%eax
80102aff:	85 c0                	test   %eax,%eax
80102b01:	74 0c                	je     80102b0f <kalloc+0x1b>
    acquire(&kmem.lock);
80102b03:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102b0a:	e8 6f 25 00 00       	call   8010507e <acquire>
  r = kmem.freelist;
80102b0f:	a1 58 22 11 80       	mov    0x80112258,%eax
80102b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b1b:	74 0a                	je     80102b27 <kalloc+0x33>
    kmem.freelist = r->next;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	8b 00                	mov    (%eax),%eax
80102b22:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102b27:	a1 54 22 11 80       	mov    0x80112254,%eax
80102b2c:	85 c0                	test   %eax,%eax
80102b2e:	74 0c                	je     80102b3c <kalloc+0x48>
    release(&kmem.lock);
80102b30:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102b37:	e8 a4 25 00 00       	call   801050e0 <release>
  return (char*)r;
80102b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b3f:	c9                   	leave  
80102b40:	c3                   	ret    

80102b41 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b41:	55                   	push   %ebp
80102b42:	89 e5                	mov    %esp,%ebp
80102b44:	83 ec 14             	sub    $0x14,%esp
80102b47:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b52:	89 c2                	mov    %eax,%edx
80102b54:	ec                   	in     (%dx),%al
80102b55:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b58:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b5c:	c9                   	leave  
80102b5d:	c3                   	ret    

80102b5e <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b5e:	55                   	push   %ebp
80102b5f:	89 e5                	mov    %esp,%ebp
80102b61:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b64:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b6b:	e8 d1 ff ff ff       	call   80102b41 <inb>
80102b70:	0f b6 c0             	movzbl %al,%eax
80102b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b79:	83 e0 01             	and    $0x1,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	75 0a                	jne    80102b8a <kbdgetc+0x2c>
    return -1;
80102b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b85:	e9 25 01 00 00       	jmp    80102caf <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b8a:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b91:	e8 ab ff ff ff       	call   80102b41 <inb>
80102b96:	0f b6 c0             	movzbl %al,%eax
80102b99:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b9c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ba3:	75 17                	jne    80102bbc <kbdgetc+0x5e>
    shift |= E0ESC;
80102ba5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102baa:	83 c8 40             	or     $0x40,%eax
80102bad:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bb2:	b8 00 00 00 00       	mov    $0x0,%eax
80102bb7:	e9 f3 00 00 00       	jmp    80102caf <kbdgetc+0x151>
  } else if(data & 0x80){
80102bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbf:	25 80 00 00 00       	and    $0x80,%eax
80102bc4:	85 c0                	test   %eax,%eax
80102bc6:	74 45                	je     80102c0d <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bc8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bcd:	83 e0 40             	and    $0x40,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	75 08                	jne    80102bdc <kbdgetc+0x7e>
80102bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd7:	83 e0 7f             	and    $0x7f,%eax
80102bda:	eb 03                	jmp    80102bdf <kbdgetc+0x81>
80102bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be5:	05 20 90 10 80       	add    $0x80109020,%eax
80102bea:	0f b6 00             	movzbl (%eax),%eax
80102bed:	83 c8 40             	or     $0x40,%eax
80102bf0:	0f b6 c0             	movzbl %al,%eax
80102bf3:	f7 d0                	not    %eax
80102bf5:	89 c2                	mov    %eax,%edx
80102bf7:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bfc:	21 d0                	and    %edx,%eax
80102bfe:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c03:	b8 00 00 00 00       	mov    $0x0,%eax
80102c08:	e9 a2 00 00 00       	jmp    80102caf <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c0d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c12:	83 e0 40             	and    $0x40,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	74 14                	je     80102c2d <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c19:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c20:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c25:	83 e0 bf             	and    $0xffffffbf,%eax
80102c28:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c30:	05 20 90 10 80       	add    $0x80109020,%eax
80102c35:	0f b6 00             	movzbl (%eax),%eax
80102c38:	0f b6 d0             	movzbl %al,%edx
80102c3b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c40:	09 d0                	or     %edx,%eax
80102c42:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4a:	05 20 91 10 80       	add    $0x80109120,%eax
80102c4f:	0f b6 00             	movzbl (%eax),%eax
80102c52:	0f b6 d0             	movzbl %al,%edx
80102c55:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c5a:	31 d0                	xor    %edx,%eax
80102c5c:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c61:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c66:	83 e0 03             	and    $0x3,%eax
80102c69:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c73:	01 d0                	add    %edx,%eax
80102c75:	0f b6 00             	movzbl (%eax),%eax
80102c78:	0f b6 c0             	movzbl %al,%eax
80102c7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c7e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c83:	83 e0 08             	and    $0x8,%eax
80102c86:	85 c0                	test   %eax,%eax
80102c88:	74 22                	je     80102cac <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c8a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c8e:	76 0c                	jbe    80102c9c <kbdgetc+0x13e>
80102c90:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c94:	77 06                	ja     80102c9c <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c96:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c9a:	eb 10                	jmp    80102cac <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c9c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ca0:	76 0a                	jbe    80102cac <kbdgetc+0x14e>
80102ca2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ca6:	77 04                	ja     80102cac <kbdgetc+0x14e>
      c += 'a' - 'A';
80102ca8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102caf:	c9                   	leave  
80102cb0:	c3                   	ret    

80102cb1 <kbdintr>:

void
kbdintr(void)
{
80102cb1:	55                   	push   %ebp
80102cb2:	89 e5                	mov    %esp,%ebp
80102cb4:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cb7:	c7 04 24 5e 2b 10 80 	movl   $0x80102b5e,(%esp)
80102cbe:	e8 ea da ff ff       	call   801007ad <consoleintr>
}
80102cc3:	c9                   	leave  
80102cc4:	c3                   	ret    

80102cc5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cc5:	55                   	push   %ebp
80102cc6:	89 e5                	mov    %esp,%ebp
80102cc8:	83 ec 14             	sub    $0x14,%esp
80102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80102cce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cd6:	89 c2                	mov    %eax,%edx
80102cd8:	ec                   	in     (%dx),%al
80102cd9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cdc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ce0:	c9                   	leave  
80102ce1:	c3                   	ret    

80102ce2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ce2:	55                   	push   %ebp
80102ce3:	89 e5                	mov    %esp,%ebp
80102ce5:	83 ec 08             	sub    $0x8,%esp
80102ce8:	8b 55 08             	mov    0x8(%ebp),%edx
80102ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cee:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cf2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cf9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cfd:	ee                   	out    %al,(%dx)
}
80102cfe:	c9                   	leave  
80102cff:	c3                   	ret    

80102d00 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d06:	9c                   	pushf  
80102d07:	58                   	pop    %eax
80102d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d0e:	c9                   	leave  
80102d0f:	c3                   	ret    

80102d10 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d13:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d18:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1b:	c1 e2 02             	shl    $0x2,%edx
80102d1e:	01 c2                	add    %eax,%edx
80102d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d23:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d25:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d2a:	83 c0 20             	add    $0x20,%eax
80102d2d:	8b 00                	mov    (%eax),%eax
}
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    

80102d31 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d31:	55                   	push   %ebp
80102d32:	89 e5                	mov    %esp,%ebp
80102d34:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d37:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d3c:	85 c0                	test   %eax,%eax
80102d3e:	75 05                	jne    80102d45 <lapicinit+0x14>
    return;
80102d40:	e9 43 01 00 00       	jmp    80102e88 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d45:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d4c:	00 
80102d4d:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d54:	e8 b7 ff ff ff       	call   80102d10 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d59:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d60:	00 
80102d61:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d68:	e8 a3 ff ff ff       	call   80102d10 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d6d:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d74:	00 
80102d75:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d7c:	e8 8f ff ff ff       	call   80102d10 <lapicw>
  lapicw(TICR, 10000000); 
80102d81:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d88:	00 
80102d89:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d90:	e8 7b ff ff ff       	call   80102d10 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d95:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9c:	00 
80102d9d:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102da4:	e8 67 ff ff ff       	call   80102d10 <lapicw>
  lapicw(LINT1, MASKED);
80102da9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102db0:	00 
80102db1:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102db8:	e8 53 ff ff ff       	call   80102d10 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dbd:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102dc2:	83 c0 30             	add    $0x30,%eax
80102dc5:	8b 00                	mov    (%eax),%eax
80102dc7:	c1 e8 10             	shr    $0x10,%eax
80102dca:	0f b6 c0             	movzbl %al,%eax
80102dcd:	83 f8 03             	cmp    $0x3,%eax
80102dd0:	76 14                	jbe    80102de6 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102dd2:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102de1:	e8 2a ff ff ff       	call   80102d10 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102de6:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102df5:	e8 16 ff ff ff       	call   80102d10 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e09:	e8 02 ff ff ff       	call   80102d10 <lapicw>
  lapicw(ESR, 0);
80102e0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1d:	e8 ee fe ff ff       	call   80102d10 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e31:	e8 da fe ff ff       	call   80102d10 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e45:	e8 c6 fe ff ff       	call   80102d10 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e4a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e59:	e8 b2 fe ff ff       	call   80102d10 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e5e:	90                   	nop
80102e5f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e64:	05 00 03 00 00       	add    $0x300,%eax
80102e69:	8b 00                	mov    (%eax),%eax
80102e6b:	25 00 10 00 00       	and    $0x1000,%eax
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 eb                	jne    80102e5f <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e83:	e8 88 fe ff ff       	call   80102d10 <lapicw>
}
80102e88:	c9                   	leave  
80102e89:	c3                   	ret    

80102e8a <cpunum>:

int
cpunum(void)
{
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e90:	e8 6b fe ff ff       	call   80102d00 <readeflags>
80102e95:	25 00 02 00 00       	and    $0x200,%eax
80102e9a:	85 c0                	test   %eax,%eax
80102e9c:	74 25                	je     80102ec3 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e9e:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102ea3:	8d 50 01             	lea    0x1(%eax),%edx
80102ea6:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102eac:	85 c0                	test   %eax,%eax
80102eae:	75 13                	jne    80102ec3 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb0:	8b 45 04             	mov    0x4(%ebp),%eax
80102eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb7:	c7 04 24 b8 88 10 80 	movl   $0x801088b8,(%esp)
80102ebe:	e8 dd d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ec3:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ec8:	85 c0                	test   %eax,%eax
80102eca:	74 0f                	je     80102edb <cpunum+0x51>
    return lapic[ID]>>24;
80102ecc:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ed1:	83 c0 20             	add    $0x20,%eax
80102ed4:	8b 00                	mov    (%eax),%eax
80102ed6:	c1 e8 18             	shr    $0x18,%eax
80102ed9:	eb 05                	jmp    80102ee0 <cpunum+0x56>
  return 0;
80102edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ee0:	c9                   	leave  
80102ee1:	c3                   	ret    

80102ee2 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee2:	55                   	push   %ebp
80102ee3:	89 e5                	mov    %esp,%ebp
80102ee5:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ee8:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102eed:	85 c0                	test   %eax,%eax
80102eef:	74 14                	je     80102f05 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ef1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef8:	00 
80102ef9:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f00:	e8 0b fe ff ff       	call   80102d10 <lapicw>
}
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    

80102f07 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f07:	55                   	push   %ebp
80102f08:	89 e5                	mov    %esp,%ebp
}
80102f0a:	5d                   	pop    %ebp
80102f0b:	c3                   	ret    

80102f0c <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f0c:	55                   	push   %ebp
80102f0d:	89 e5                	mov    %esp,%ebp
80102f0f:	83 ec 1c             	sub    $0x1c,%esp
80102f12:	8b 45 08             	mov    0x8(%ebp),%eax
80102f15:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f18:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f1f:	00 
80102f20:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f27:	e8 b6 fd ff ff       	call   80102ce2 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f2c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f33:	00 
80102f34:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f3b:	e8 a2 fd ff ff       	call   80102ce2 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f40:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f4a:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f52:	8d 50 02             	lea    0x2(%eax),%edx
80102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f58:	c1 e8 04             	shr    $0x4,%eax
80102f5b:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f5e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f62:	c1 e0 18             	shl    $0x18,%eax
80102f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f69:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f70:	e8 9b fd ff ff       	call   80102d10 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f75:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f7c:	00 
80102f7d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f84:	e8 87 fd ff ff       	call   80102d10 <lapicw>
  microdelay(200);
80102f89:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f90:	e8 72 ff ff ff       	call   80102f07 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f95:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f9c:	00 
80102f9d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa4:	e8 67 fd ff ff       	call   80102d10 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fa9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fb0:	e8 52 ff ff ff       	call   80102f07 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fbc:	eb 40                	jmp    80102ffe <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fbe:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc2:	c1 e0 18             	shl    $0x18,%eax
80102fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fc9:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fd0:	e8 3b fd ff ff       	call   80102d10 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd8:	c1 e8 0c             	shr    $0xc,%eax
80102fdb:	80 cc 06             	or     $0x6,%ah
80102fde:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe2:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fe9:	e8 22 fd ff ff       	call   80102d10 <lapicw>
    microdelay(200);
80102fee:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ff5:	e8 0d ff ff ff       	call   80102f07 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102ffe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103002:	7e ba                	jle    80102fbe <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103004:	c9                   	leave  
80103005:	c3                   	ret    

80103006 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103006:	55                   	push   %ebp
80103007:	89 e5                	mov    %esp,%ebp
80103009:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010300c:	8b 45 08             	mov    0x8(%ebp),%eax
8010300f:	0f b6 c0             	movzbl %al,%eax
80103012:	89 44 24 04          	mov    %eax,0x4(%esp)
80103016:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010301d:	e8 c0 fc ff ff       	call   80102ce2 <outb>
  microdelay(200);
80103022:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103029:	e8 d9 fe ff ff       	call   80102f07 <microdelay>

  return inb(CMOS_RETURN);
8010302e:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103035:	e8 8b fc ff ff       	call   80102cc5 <inb>
8010303a:	0f b6 c0             	movzbl %al,%eax
}
8010303d:	c9                   	leave  
8010303e:	c3                   	ret    

8010303f <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010303f:	55                   	push   %ebp
80103040:	89 e5                	mov    %esp,%ebp
80103042:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010304c:	e8 b5 ff ff ff       	call   80103006 <cmos_read>
80103051:	8b 55 08             	mov    0x8(%ebp),%edx
80103054:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103056:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010305d:	e8 a4 ff ff ff       	call   80103006 <cmos_read>
80103062:	8b 55 08             	mov    0x8(%ebp),%edx
80103065:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103068:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010306f:	e8 92 ff ff ff       	call   80103006 <cmos_read>
80103074:	8b 55 08             	mov    0x8(%ebp),%edx
80103077:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010307a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103081:	e8 80 ff ff ff       	call   80103006 <cmos_read>
80103086:	8b 55 08             	mov    0x8(%ebp),%edx
80103089:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010308c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103093:	e8 6e ff ff ff       	call   80103006 <cmos_read>
80103098:	8b 55 08             	mov    0x8(%ebp),%edx
8010309b:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010309e:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030a5:	e8 5c ff ff ff       	call   80103006 <cmos_read>
801030aa:	8b 55 08             	mov    0x8(%ebp),%edx
801030ad:	89 42 14             	mov    %eax,0x14(%edx)
}
801030b0:	c9                   	leave  
801030b1:	c3                   	ret    

801030b2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030b2:	55                   	push   %ebp
801030b3:	89 e5                	mov    %esp,%ebp
801030b5:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030b8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030bf:	e8 42 ff ff ff       	call   80103006 <cmos_read>
801030c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030ca:	83 e0 04             	and    $0x4,%eax
801030cd:	85 c0                	test   %eax,%eax
801030cf:	0f 94 c0             	sete   %al
801030d2:	0f b6 c0             	movzbl %al,%eax
801030d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030d8:	8d 45 d8             	lea    -0x28(%ebp),%eax
801030db:	89 04 24             	mov    %eax,(%esp)
801030de:	e8 5c ff ff ff       	call   8010303f <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801030e3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801030ea:	e8 17 ff ff ff       	call   80103006 <cmos_read>
801030ef:	25 80 00 00 00       	and    $0x80,%eax
801030f4:	85 c0                	test   %eax,%eax
801030f6:	74 02                	je     801030fa <cmostime+0x48>
        continue;
801030f8:	eb 36                	jmp    80103130 <cmostime+0x7e>
    fill_rtcdate(&t2);
801030fa:	8d 45 c0             	lea    -0x40(%ebp),%eax
801030fd:	89 04 24             	mov    %eax,(%esp)
80103100:	e8 3a ff ff ff       	call   8010303f <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103105:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010310c:	00 
8010310d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103110:	89 44 24 04          	mov    %eax,0x4(%esp)
80103114:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103117:	89 04 24             	mov    %eax,(%esp)
8010311a:	e8 2a 22 00 00       	call   80105349 <memcmp>
8010311f:	85 c0                	test   %eax,%eax
80103121:	75 0d                	jne    80103130 <cmostime+0x7e>
      break;
80103123:	90                   	nop
  }

  // convert
  if (bcd) {
80103124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103128:	0f 84 ac 00 00 00    	je     801031da <cmostime+0x128>
8010312e:	eb 02                	jmp    80103132 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103130:	eb a6                	jmp    801030d8 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103135:	c1 e8 04             	shr    $0x4,%eax
80103138:	89 c2                	mov    %eax,%edx
8010313a:	89 d0                	mov    %edx,%eax
8010313c:	c1 e0 02             	shl    $0x2,%eax
8010313f:	01 d0                	add    %edx,%eax
80103141:	01 c0                	add    %eax,%eax
80103143:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103146:	83 e2 0f             	and    $0xf,%edx
80103149:	01 d0                	add    %edx,%eax
8010314b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103151:	c1 e8 04             	shr    $0x4,%eax
80103154:	89 c2                	mov    %eax,%edx
80103156:	89 d0                	mov    %edx,%eax
80103158:	c1 e0 02             	shl    $0x2,%eax
8010315b:	01 d0                	add    %edx,%eax
8010315d:	01 c0                	add    %eax,%eax
8010315f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103162:	83 e2 0f             	and    $0xf,%edx
80103165:	01 d0                	add    %edx,%eax
80103167:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010316a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010316d:	c1 e8 04             	shr    $0x4,%eax
80103170:	89 c2                	mov    %eax,%edx
80103172:	89 d0                	mov    %edx,%eax
80103174:	c1 e0 02             	shl    $0x2,%eax
80103177:	01 d0                	add    %edx,%eax
80103179:	01 c0                	add    %eax,%eax
8010317b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010317e:	83 e2 0f             	and    $0xf,%edx
80103181:	01 d0                	add    %edx,%eax
80103183:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103189:	c1 e8 04             	shr    $0x4,%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	89 d0                	mov    %edx,%eax
80103190:	c1 e0 02             	shl    $0x2,%eax
80103193:	01 d0                	add    %edx,%eax
80103195:	01 c0                	add    %eax,%eax
80103197:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010319a:	83 e2 0f             	and    $0xf,%edx
8010319d:	01 d0                	add    %edx,%eax
8010319f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031a5:	c1 e8 04             	shr    $0x4,%eax
801031a8:	89 c2                	mov    %eax,%edx
801031aa:	89 d0                	mov    %edx,%eax
801031ac:	c1 e0 02             	shl    $0x2,%eax
801031af:	01 d0                	add    %edx,%eax
801031b1:	01 c0                	add    %eax,%eax
801031b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031b6:	83 e2 0f             	and    $0xf,%edx
801031b9:	01 d0                	add    %edx,%eax
801031bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c1:	c1 e8 04             	shr    $0x4,%eax
801031c4:	89 c2                	mov    %eax,%edx
801031c6:	89 d0                	mov    %edx,%eax
801031c8:	c1 e0 02             	shl    $0x2,%eax
801031cb:	01 d0                	add    %edx,%eax
801031cd:	01 c0                	add    %eax,%eax
801031cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031d2:	83 e2 0f             	and    $0xf,%edx
801031d5:	01 d0                	add    %edx,%eax
801031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801031da:	8b 45 08             	mov    0x8(%ebp),%eax
801031dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031e0:	89 10                	mov    %edx,(%eax)
801031e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031e5:	89 50 04             	mov    %edx,0x4(%eax)
801031e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031eb:	89 50 08             	mov    %edx,0x8(%eax)
801031ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031f1:	89 50 0c             	mov    %edx,0xc(%eax)
801031f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031f7:	89 50 10             	mov    %edx,0x10(%eax)
801031fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031fd:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103200:	8b 45 08             	mov    0x8(%ebp),%eax
80103203:	8b 40 14             	mov    0x14(%eax),%eax
80103206:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010320c:	8b 45 08             	mov    0x8(%ebp),%eax
8010320f:	89 50 14             	mov    %edx,0x14(%eax)
}
80103212:	c9                   	leave  
80103213:	c3                   	ret    

80103214 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010321a:	c7 44 24 04 e4 88 10 	movl   $0x801088e4,0x4(%esp)
80103221:	80 
80103222:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103229:	e8 2f 1e 00 00       	call   8010505d <initlock>
  readsb(ROOTDEV, &sb);
8010322e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103231:	89 44 24 04          	mov    %eax,0x4(%esp)
80103235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010323c:	e8 bf e0 ff ff       	call   80101300 <readsb>
  log.start = sb.size - sb.nlog;
80103241:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103247:	29 c2                	sub    %eax,%edx
80103249:	89 d0                	mov    %edx,%eax
8010324b:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
80103250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103253:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = ROOTDEV;
80103258:	c7 05 a4 22 11 80 01 	movl   $0x1,0x801122a4
8010325f:	00 00 00 
  recover_from_log();
80103262:	e8 9a 01 00 00       	call   80103401 <recover_from_log>
}
80103267:	c9                   	leave  
80103268:	c3                   	ret    

80103269 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103269:	55                   	push   %ebp
8010326a:	89 e5                	mov    %esp,%ebp
8010326c:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010326f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103276:	e9 8c 00 00 00       	jmp    80103307 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010327b:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103284:	01 d0                	add    %edx,%eax
80103286:	83 c0 01             	add    $0x1,%eax
80103289:	89 c2                	mov    %eax,%edx
8010328b:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103290:	89 54 24 04          	mov    %edx,0x4(%esp)
80103294:	89 04 24             	mov    %eax,(%esp)
80103297:	e8 0a cf ff ff       	call   801001a6 <bread>
8010329c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032a2:	83 c0 10             	add    $0x10,%eax
801032a5:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801032ac:	89 c2                	mov    %eax,%edx
801032ae:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801032b3:	89 54 24 04          	mov    %edx,0x4(%esp)
801032b7:	89 04 24             	mov    %eax,(%esp)
801032ba:	e8 e7 ce ff ff       	call   801001a6 <bread>
801032bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032c5:	8d 50 18             	lea    0x18(%eax),%edx
801032c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032cb:	83 c0 18             	add    $0x18,%eax
801032ce:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032d5:	00 
801032d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801032da:	89 04 24             	mov    %eax,(%esp)
801032dd:	e8 bf 20 00 00       	call   801053a1 <memmove>
    bwrite(dbuf);  // write dst to disk
801032e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032e5:	89 04 24             	mov    %eax,(%esp)
801032e8:	e8 f0 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f0:	89 04 24             	mov    %eax,(%esp)
801032f3:	e8 1f cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032fb:	89 04 24             	mov    %eax,(%esp)
801032fe:	e8 14 cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103303:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103307:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010330c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010330f:	0f 8f 66 ff ff ff    	jg     8010327b <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103315:	c9                   	leave  
80103316:	c3                   	ret    

80103317 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103317:	55                   	push   %ebp
80103318:	89 e5                	mov    %esp,%ebp
8010331a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010331d:	a1 94 22 11 80       	mov    0x80112294,%eax
80103322:	89 c2                	mov    %eax,%edx
80103324:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010332d:	89 04 24             	mov    %eax,(%esp)
80103330:	e8 71 ce ff ff       	call   801001a6 <bread>
80103335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333b:	83 c0 18             	add    $0x18,%eax
8010333e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103341:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103344:	8b 00                	mov    (%eax),%eax
80103346:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
8010334b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103352:	eb 1b                	jmp    8010336f <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103357:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010335a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103361:	83 c2 10             	add    $0x10,%edx
80103364:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010336b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336f:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103374:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103377:	7f db                	jg     80103354 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010337c:	89 04 24             	mov    %eax,(%esp)
8010337f:	e8 93 ce ff ff       	call   80100217 <brelse>
}
80103384:	c9                   	leave  
80103385:	c3                   	ret    

80103386 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103386:	55                   	push   %ebp
80103387:	89 e5                	mov    %esp,%ebp
80103389:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010338c:	a1 94 22 11 80       	mov    0x80112294,%eax
80103391:	89 c2                	mov    %eax,%edx
80103393:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103398:	89 54 24 04          	mov    %edx,0x4(%esp)
8010339c:	89 04 24             	mov    %eax,(%esp)
8010339f:	e8 02 ce ff ff       	call   801001a6 <bread>
801033a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033aa:	83 c0 18             	add    $0x18,%eax
801033ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033b0:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
801033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b9:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033c2:	eb 1b                	jmp    801033df <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033c7:	83 c0 10             	add    $0x10,%eax
801033ca:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801033d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033d7:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033df:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801033e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033e7:	7f db                	jg     801033c4 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ec:	89 04 24             	mov    %eax,(%esp)
801033ef:	e8 e9 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
801033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f7:	89 04 24             	mov    %eax,(%esp)
801033fa:	e8 18 ce ff ff       	call   80100217 <brelse>
}
801033ff:	c9                   	leave  
80103400:	c3                   	ret    

80103401 <recover_from_log>:

static void
recover_from_log(void)
{
80103401:	55                   	push   %ebp
80103402:	89 e5                	mov    %esp,%ebp
80103404:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103407:	e8 0b ff ff ff       	call   80103317 <read_head>
  install_trans(); // if committed, copy from log to disk
8010340c:	e8 58 fe ff ff       	call   80103269 <install_trans>
  log.lh.n = 0;
80103411:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103418:	00 00 00 
  write_head(); // clear the log
8010341b:	e8 66 ff ff ff       	call   80103386 <write_head>
}
80103420:	c9                   	leave  
80103421:	c3                   	ret    

80103422 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103422:	55                   	push   %ebp
80103423:	89 e5                	mov    %esp,%ebp
80103425:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103428:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010342f:	e8 4a 1c 00 00       	call   8010507e <acquire>
  while(1){
    if(log.committing){
80103434:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103439:	85 c0                	test   %eax,%eax
8010343b:	74 16                	je     80103453 <begin_op+0x31>
      sleep(&log, &log.lock);
8010343d:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80103444:	80 
80103445:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010344c:	e8 1f 19 00 00       	call   80104d70 <sleep>
80103451:	eb 4f                	jmp    801034a2 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103453:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
80103459:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010345e:	8d 50 01             	lea    0x1(%eax),%edx
80103461:	89 d0                	mov    %edx,%eax
80103463:	c1 e0 02             	shl    $0x2,%eax
80103466:	01 d0                	add    %edx,%eax
80103468:	01 c0                	add    %eax,%eax
8010346a:	01 c8                	add    %ecx,%eax
8010346c:	83 f8 1e             	cmp    $0x1e,%eax
8010346f:	7e 16                	jle    80103487 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103471:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80103478:	80 
80103479:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103480:	e8 eb 18 00 00       	call   80104d70 <sleep>
80103485:	eb 1b                	jmp    801034a2 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103487:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010348c:	83 c0 01             	add    $0x1,%eax
8010348f:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
80103494:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010349b:	e8 40 1c 00 00       	call   801050e0 <release>
      break;
801034a0:	eb 02                	jmp    801034a4 <begin_op+0x82>
    }
  }
801034a2:	eb 90                	jmp    80103434 <begin_op+0x12>
}
801034a4:	c9                   	leave  
801034a5:	c3                   	ret    

801034a6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034a6:	55                   	push   %ebp
801034a7:	89 e5                	mov    %esp,%ebp
801034a9:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034b3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801034ba:	e8 bf 1b 00 00       	call   8010507e <acquire>
  log.outstanding -= 1;
801034bf:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801034c4:	83 e8 01             	sub    $0x1,%eax
801034c7:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
801034cc:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801034d1:	85 c0                	test   %eax,%eax
801034d3:	74 0c                	je     801034e1 <end_op+0x3b>
    panic("log.committing");
801034d5:	c7 04 24 e8 88 10 80 	movl   $0x801088e8,(%esp)
801034dc:	e8 59 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034e1:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801034e6:	85 c0                	test   %eax,%eax
801034e8:	75 13                	jne    801034fd <end_op+0x57>
    do_commit = 1;
801034ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801034f1:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
801034f8:	00 00 00 
801034fb:	eb 0c                	jmp    80103509 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801034fd:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103504:	e8 5f 19 00 00       	call   80104e68 <wakeup>
  }
  release(&log.lock);
80103509:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103510:	e8 cb 1b 00 00       	call   801050e0 <release>

  if(do_commit){
80103515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103519:	74 33                	je     8010354e <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010351b:	e8 de 00 00 00       	call   801035fe <commit>
    acquire(&log.lock);
80103520:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103527:	e8 52 1b 00 00       	call   8010507e <acquire>
    log.committing = 0;
8010352c:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
80103533:	00 00 00 
    wakeup(&log);
80103536:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010353d:	e8 26 19 00 00       	call   80104e68 <wakeup>
    release(&log.lock);
80103542:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103549:	e8 92 1b 00 00       	call   801050e0 <release>
  }
}
8010354e:	c9                   	leave  
8010354f:	c3                   	ret    

80103550 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010355d:	e9 8c 00 00 00       	jmp    801035ee <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103562:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	83 c0 01             	add    $0x1,%eax
80103570:	89 c2                	mov    %eax,%edx
80103572:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103577:	89 54 24 04          	mov    %edx,0x4(%esp)
8010357b:	89 04 24             	mov    %eax,(%esp)
8010357e:	e8 23 cc ff ff       	call   801001a6 <bread>
80103583:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103589:	83 c0 10             	add    $0x10,%eax
8010358c:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103593:	89 c2                	mov    %eax,%edx
80103595:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010359a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010359e:	89 04 24             	mov    %eax,(%esp)
801035a1:	e8 00 cc ff ff       	call   801001a6 <bread>
801035a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ac:	8d 50 18             	lea    0x18(%eax),%edx
801035af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b2:	83 c0 18             	add    $0x18,%eax
801035b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035bc:	00 
801035bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c1:	89 04 24             	mov    %eax,(%esp)
801035c4:	e8 d8 1d 00 00       	call   801053a1 <memmove>
    bwrite(to);  // write the log
801035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035cc:	89 04 24             	mov    %eax,(%esp)
801035cf:	e8 09 cc ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d7:	89 04 24             	mov    %eax,(%esp)
801035da:	e8 38 cc ff ff       	call   80100217 <brelse>
    brelse(to);
801035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e2:	89 04 24             	mov    %eax,(%esp)
801035e5:	e8 2d cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035ee:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801035f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035f6:	0f 8f 66 ff ff ff    	jg     80103562 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801035fc:	c9                   	leave  
801035fd:	c3                   	ret    

801035fe <commit>:

static void
commit()
{
801035fe:	55                   	push   %ebp
801035ff:	89 e5                	mov    %esp,%ebp
80103601:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103604:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103609:	85 c0                	test   %eax,%eax
8010360b:	7e 1e                	jle    8010362b <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010360d:	e8 3e ff ff ff       	call   80103550 <write_log>
    write_head();    // Write header to disk -- the real commit
80103612:	e8 6f fd ff ff       	call   80103386 <write_head>
    install_trans(); // Now install writes to home locations
80103617:	e8 4d fc ff ff       	call   80103269 <install_trans>
    log.lh.n = 0; 
8010361c:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103623:	00 00 00 
    write_head();    // Erase the transaction from the log
80103626:	e8 5b fd ff ff       	call   80103386 <write_head>
  }
}
8010362b:	c9                   	leave  
8010362c:	c3                   	ret    

8010362d <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010362d:	55                   	push   %ebp
8010362e:	89 e5                	mov    %esp,%ebp
80103630:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103633:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103638:	83 f8 1d             	cmp    $0x1d,%eax
8010363b:	7f 12                	jg     8010364f <log_write+0x22>
8010363d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103642:	8b 15 98 22 11 80    	mov    0x80112298,%edx
80103648:	83 ea 01             	sub    $0x1,%edx
8010364b:	39 d0                	cmp    %edx,%eax
8010364d:	7c 0c                	jl     8010365b <log_write+0x2e>
    panic("too big a transaction");
8010364f:	c7 04 24 f7 88 10 80 	movl   $0x801088f7,(%esp)
80103656:	e8 df ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010365b:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103660:	85 c0                	test   %eax,%eax
80103662:	7f 0c                	jg     80103670 <log_write+0x43>
    panic("log_write outside of trans");
80103664:	c7 04 24 0d 89 10 80 	movl   $0x8010890d,(%esp)
8010366b:	e8 ca ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103670:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103677:	e8 02 1a 00 00       	call   8010507e <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010367c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103683:	eb 1f                	jmp    801036a4 <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103688:	83 c0 10             	add    $0x10,%eax
8010368b:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103692:	89 c2                	mov    %eax,%edx
80103694:	8b 45 08             	mov    0x8(%ebp),%eax
80103697:	8b 40 08             	mov    0x8(%eax),%eax
8010369a:	39 c2                	cmp    %eax,%edx
8010369c:	75 02                	jne    801036a0 <log_write+0x73>
      break;
8010369e:	eb 0e                	jmp    801036ae <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036a4:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ac:	7f d7                	jg     80103685 <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036ae:	8b 45 08             	mov    0x8(%ebp),%eax
801036b1:	8b 40 08             	mov    0x8(%eax),%eax
801036b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036b7:	83 c2 10             	add    $0x10,%edx
801036ba:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  if (i == log.lh.n)
801036c1:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c9:	75 0d                	jne    801036d8 <log_write+0xab>
    log.lh.n++;
801036cb:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036d0:	83 c0 01             	add    $0x1,%eax
801036d3:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
801036d8:	8b 45 08             	mov    0x8(%ebp),%eax
801036db:	8b 00                	mov    (%eax),%eax
801036dd:	83 c8 04             	or     $0x4,%eax
801036e0:	89 c2                	mov    %eax,%edx
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801036e7:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801036ee:	e8 ed 19 00 00       	call   801050e0 <release>
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <v2p>:
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	8b 45 08             	mov    0x8(%ebp),%eax
801036fb:	05 00 00 00 80       	add    $0x80000000,%eax
80103700:	5d                   	pop    %ebp
80103701:	c3                   	ret    

80103702 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103702:	55                   	push   %ebp
80103703:	89 e5                	mov    %esp,%ebp
80103705:	8b 45 08             	mov    0x8(%ebp),%eax
80103708:	05 00 00 00 80       	add    $0x80000000,%eax
8010370d:	5d                   	pop    %ebp
8010370e:	c3                   	ret    

8010370f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010370f:	55                   	push   %ebp
80103710:	89 e5                	mov    %esp,%ebp
80103712:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103715:	8b 55 08             	mov    0x8(%ebp),%edx
80103718:	8b 45 0c             	mov    0xc(%ebp),%eax
8010371b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010371e:	f0 87 02             	lock xchg %eax,(%edx)
80103721:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103724:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103727:	c9                   	leave  
80103728:	c3                   	ret    

80103729 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103729:	55                   	push   %ebp
8010372a:	89 e5                	mov    %esp,%ebp
8010372c:	83 e4 f0             	and    $0xfffffff0,%esp
8010372f:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103732:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103739:	80 
8010373a:	c7 04 24 3c bf 11 80 	movl   $0x8011bf3c,(%esp)
80103741:	e8 80 f2 ff ff       	call   801029c6 <kinit1>
  kvmalloc();      // kernel page table
80103746:	e8 db 47 00 00       	call   80107f26 <kvmalloc>
  mpinit();        // collect info about this machine
8010374b:	e8 46 04 00 00       	call   80103b96 <mpinit>
  lapicinit();
80103750:	e8 dc f5 ff ff       	call   80102d31 <lapicinit>
  seginit();       // set up segments
80103755:	e8 5f 41 00 00       	call   801078b9 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010375a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103760:	0f b6 00             	movzbl (%eax),%eax
80103763:	0f b6 c0             	movzbl %al,%eax
80103766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010376a:	c7 04 24 28 89 10 80 	movl   $0x80108928,(%esp)
80103771:	e8 2a cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103776:	e8 79 06 00 00       	call   80103df4 <picinit>
  ioapicinit();    // another interrupt controller
8010377b:	e8 3c f1 ff ff       	call   801028bc <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103780:	e8 ff d2 ff ff       	call   80100a84 <consoleinit>
  uartinit();      // serial port
80103785:	e8 7e 34 00 00       	call   80106c08 <uartinit>
  pinit();         // process table
8010378a:	e8 75 0b 00 00       	call   80104304 <pinit>
  tvinit();        // trap vectors
8010378f:	e8 d0 2f 00 00       	call   80106764 <tvinit>
  binit();         // buffer cache
80103794:	e8 9b c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103799:	e8 7b d7 ff ff       	call   80100f19 <fileinit>
  iinit();         // inode cache
8010379e:	e8 10 de ff ff       	call   801015b3 <iinit>
  ideinit();       // disk
801037a3:	e8 7d ed ff ff       	call   80102525 <ideinit>
  if(!ismp)
801037a8:	a1 44 23 11 80       	mov    0x80112344,%eax
801037ad:	85 c0                	test   %eax,%eax
801037af:	75 05                	jne    801037b6 <main+0x8d>
    timerinit();   // uniprocessor timer
801037b1:	e8 f9 2e 00 00       	call   801066af <timerinit>
  startothers();   // start other processors
801037b6:	e8 7f 00 00 00       	call   8010383a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037bb:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037c2:	8e 
801037c3:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037ca:	e8 2f f2 ff ff       	call   801029fe <kinit2>
  userinit();      // first user process
801037cf:	e8 99 0c 00 00       	call   8010446d <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037d4:	e8 1a 00 00 00       	call   801037f3 <mpmain>

801037d9 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037d9:	55                   	push   %ebp
801037da:	89 e5                	mov    %esp,%ebp
801037dc:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801037df:	e8 59 47 00 00       	call   80107f3d <switchkvm>
  seginit();
801037e4:	e8 d0 40 00 00       	call   801078b9 <seginit>
  lapicinit();
801037e9:	e8 43 f5 ff ff       	call   80102d31 <lapicinit>
  mpmain();
801037ee:	e8 00 00 00 00       	call   801037f3 <mpmain>

801037f3 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037f3:	55                   	push   %ebp
801037f4:	89 e5                	mov    %esp,%ebp
801037f6:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801037f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037ff:	0f b6 00             	movzbl (%eax),%eax
80103802:	0f b6 c0             	movzbl %al,%eax
80103805:	89 44 24 04          	mov    %eax,0x4(%esp)
80103809:	c7 04 24 3f 89 10 80 	movl   $0x8010893f,(%esp)
80103810:	e8 8b cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103815:	e8 be 30 00 00       	call   801068d8 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010381a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103820:	05 a8 00 00 00       	add    $0xa8,%eax
80103825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010382c:	00 
8010382d:	89 04 24             	mov    %eax,(%esp)
80103830:	e8 da fe ff ff       	call   8010370f <xchg>
  scheduler();     // start running processes
80103835:	e8 4b 13 00 00       	call   80104b85 <scheduler>

8010383a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010383a:	55                   	push   %ebp
8010383b:	89 e5                	mov    %esp,%ebp
8010383d:	53                   	push   %ebx
8010383e:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103841:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103848:	e8 b5 fe ff ff       	call   80103702 <p2v>
8010384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103850:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103855:	89 44 24 08          	mov    %eax,0x8(%esp)
80103859:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
80103860:	80 
80103861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103864:	89 04 24             	mov    %eax,(%esp)
80103867:	e8 35 1b 00 00       	call   801053a1 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010386c:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
80103873:	e9 85 00 00 00       	jmp    801038fd <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103878:	e8 0d f6 ff ff       	call   80102e8a <cpunum>
8010387d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103883:	05 60 23 11 80       	add    $0x80112360,%eax
80103888:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010388b:	75 02                	jne    8010388f <startothers+0x55>
      continue;
8010388d:	eb 67                	jmp    801038f6 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010388f:	e8 60 f2 ff ff       	call   80102af4 <kalloc>
80103894:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389a:	83 e8 04             	sub    $0x4,%eax
8010389d:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038a0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038a6:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ab:	83 e8 08             	sub    $0x8,%eax
801038ae:	c7 00 d9 37 10 80    	movl   $0x801037d9,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b7:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038ba:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801038c1:	e8 2f fe ff ff       	call   801036f5 <v2p>
801038c6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038cb:	89 04 24             	mov    %eax,(%esp)
801038ce:	e8 22 fe ff ff       	call   801036f5 <v2p>
801038d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038d6:	0f b6 12             	movzbl (%edx),%edx
801038d9:	0f b6 d2             	movzbl %dl,%edx
801038dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801038e0:	89 14 24             	mov    %edx,(%esp)
801038e3:	e8 24 f6 ff ff       	call   80102f0c <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038e8:	90                   	nop
801038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ec:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 f3                	je     801038e9 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801038f6:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801038fd:	a1 40 29 11 80       	mov    0x80112940,%eax
80103902:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103908:	05 60 23 11 80       	add    $0x80112360,%eax
8010390d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103910:	0f 87 62 ff ff ff    	ja     80103878 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103916:	83 c4 24             	add    $0x24,%esp
80103919:	5b                   	pop    %ebx
8010391a:	5d                   	pop    %ebp
8010391b:	c3                   	ret    

8010391c <p2v>:
8010391c:	55                   	push   %ebp
8010391d:	89 e5                	mov    %esp,%ebp
8010391f:	8b 45 08             	mov    0x8(%ebp),%eax
80103922:	05 00 00 00 80       	add    $0x80000000,%eax
80103927:	5d                   	pop    %ebp
80103928:	c3                   	ret    

80103929 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103929:	55                   	push   %ebp
8010392a:	89 e5                	mov    %esp,%ebp
8010392c:	83 ec 14             	sub    $0x14,%esp
8010392f:	8b 45 08             	mov    0x8(%ebp),%eax
80103932:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103936:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010393a:	89 c2                	mov    %eax,%edx
8010393c:	ec                   	in     (%dx),%al
8010393d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103940:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103944:	c9                   	leave  
80103945:	c3                   	ret    

80103946 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103946:	55                   	push   %ebp
80103947:	89 e5                	mov    %esp,%ebp
80103949:	83 ec 08             	sub    $0x8,%esp
8010394c:	8b 55 08             	mov    0x8(%ebp),%edx
8010394f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103952:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103956:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103959:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010395d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103961:	ee                   	out    %al,(%dx)
}
80103962:	c9                   	leave  
80103963:	c3                   	ret    

80103964 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103967:	a1 44 b6 10 80       	mov    0x8010b644,%eax
8010396c:	89 c2                	mov    %eax,%edx
8010396e:	b8 60 23 11 80       	mov    $0x80112360,%eax
80103973:	29 c2                	sub    %eax,%edx
80103975:	89 d0                	mov    %edx,%eax
80103977:	c1 f8 02             	sar    $0x2,%eax
8010397a:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103980:	5d                   	pop    %ebp
80103981:	c3                   	ret    

80103982 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103982:	55                   	push   %ebp
80103983:	89 e5                	mov    %esp,%ebp
80103985:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103988:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010398f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103996:	eb 15                	jmp    801039ad <sum+0x2b>
    sum += addr[i];
80103998:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010399b:	8b 45 08             	mov    0x8(%ebp),%eax
8010399e:	01 d0                	add    %edx,%eax
801039a0:	0f b6 00             	movzbl (%eax),%eax
801039a3:	0f b6 c0             	movzbl %al,%eax
801039a6:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039b3:	7c e3                	jl     80103998 <sum+0x16>
    sum += addr[i];
  return sum;
801039b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039b8:	c9                   	leave  
801039b9:	c3                   	ret    

801039ba <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039ba:	55                   	push   %ebp
801039bb:	89 e5                	mov    %esp,%ebp
801039bd:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039c0:	8b 45 08             	mov    0x8(%ebp),%eax
801039c3:	89 04 24             	mov    %eax,(%esp)
801039c6:	e8 51 ff ff ff       	call   8010391c <p2v>
801039cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801039d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d4:	01 d0                	add    %edx,%eax
801039d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039df:	eb 3f                	jmp    80103a20 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039e1:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039e8:	00 
801039e9:	c7 44 24 04 50 89 10 	movl   $0x80108950,0x4(%esp)
801039f0:	80 
801039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f4:	89 04 24             	mov    %eax,(%esp)
801039f7:	e8 4d 19 00 00       	call   80105349 <memcmp>
801039fc:	85 c0                	test   %eax,%eax
801039fe:	75 1c                	jne    80103a1c <mpsearch1+0x62>
80103a00:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a07:	00 
80103a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a0b:	89 04 24             	mov    %eax,(%esp)
80103a0e:	e8 6f ff ff ff       	call   80103982 <sum>
80103a13:	84 c0                	test   %al,%al
80103a15:	75 05                	jne    80103a1c <mpsearch1+0x62>
      return (struct mp*)p;
80103a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1a:	eb 11                	jmp    80103a2d <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a1c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a26:	72 b9                	jb     801039e1 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a2d:	c9                   	leave  
80103a2e:	c3                   	ret    

80103a2f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a2f:	55                   	push   %ebp
80103a30:	89 e5                	mov    %esp,%ebp
80103a32:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a35:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3f:	83 c0 0f             	add    $0xf,%eax
80103a42:	0f b6 00             	movzbl (%eax),%eax
80103a45:	0f b6 c0             	movzbl %al,%eax
80103a48:	c1 e0 08             	shl    $0x8,%eax
80103a4b:	89 c2                	mov    %eax,%edx
80103a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a50:	83 c0 0e             	add    $0xe,%eax
80103a53:	0f b6 00             	movzbl (%eax),%eax
80103a56:	0f b6 c0             	movzbl %al,%eax
80103a59:	09 d0                	or     %edx,%eax
80103a5b:	c1 e0 04             	shl    $0x4,%eax
80103a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a65:	74 21                	je     80103a88 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a67:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a6e:	00 
80103a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a72:	89 04 24             	mov    %eax,(%esp)
80103a75:	e8 40 ff ff ff       	call   801039ba <mpsearch1>
80103a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a81:	74 50                	je     80103ad3 <mpsearch+0xa4>
      return mp;
80103a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a86:	eb 5f                	jmp    80103ae7 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8b:	83 c0 14             	add    $0x14,%eax
80103a8e:	0f b6 00             	movzbl (%eax),%eax
80103a91:	0f b6 c0             	movzbl %al,%eax
80103a94:	c1 e0 08             	shl    $0x8,%eax
80103a97:	89 c2                	mov    %eax,%edx
80103a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9c:	83 c0 13             	add    $0x13,%eax
80103a9f:	0f b6 00             	movzbl (%eax),%eax
80103aa2:	0f b6 c0             	movzbl %al,%eax
80103aa5:	09 d0                	or     %edx,%eax
80103aa7:	c1 e0 0a             	shl    $0xa,%eax
80103aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab0:	2d 00 04 00 00       	sub    $0x400,%eax
80103ab5:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103abc:	00 
80103abd:	89 04 24             	mov    %eax,(%esp)
80103ac0:	e8 f5 fe ff ff       	call   801039ba <mpsearch1>
80103ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103acc:	74 05                	je     80103ad3 <mpsearch+0xa4>
      return mp;
80103ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ad1:	eb 14                	jmp    80103ae7 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ad3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ada:	00 
80103adb:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ae2:	e8 d3 fe ff ff       	call   801039ba <mpsearch1>
}
80103ae7:	c9                   	leave  
80103ae8:	c3                   	ret    

80103ae9 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ae9:	55                   	push   %ebp
80103aea:	89 e5                	mov    %esp,%ebp
80103aec:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aef:	e8 3b ff ff ff       	call   80103a2f <mpsearch>
80103af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103afb:	74 0a                	je     80103b07 <mpconfig+0x1e>
80103afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b00:	8b 40 04             	mov    0x4(%eax),%eax
80103b03:	85 c0                	test   %eax,%eax
80103b05:	75 0a                	jne    80103b11 <mpconfig+0x28>
    return 0;
80103b07:	b8 00 00 00 00       	mov    $0x0,%eax
80103b0c:	e9 83 00 00 00       	jmp    80103b94 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b14:	8b 40 04             	mov    0x4(%eax),%eax
80103b17:	89 04 24             	mov    %eax,(%esp)
80103b1a:	e8 fd fd ff ff       	call   8010391c <p2v>
80103b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b22:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b29:	00 
80103b2a:	c7 44 24 04 55 89 10 	movl   $0x80108955,0x4(%esp)
80103b31:	80 
80103b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b35:	89 04 24             	mov    %eax,(%esp)
80103b38:	e8 0c 18 00 00       	call   80105349 <memcmp>
80103b3d:	85 c0                	test   %eax,%eax
80103b3f:	74 07                	je     80103b48 <mpconfig+0x5f>
    return 0;
80103b41:	b8 00 00 00 00       	mov    $0x0,%eax
80103b46:	eb 4c                	jmp    80103b94 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b4b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b4f:	3c 01                	cmp    $0x1,%al
80103b51:	74 12                	je     80103b65 <mpconfig+0x7c>
80103b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b56:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b5a:	3c 04                	cmp    $0x4,%al
80103b5c:	74 07                	je     80103b65 <mpconfig+0x7c>
    return 0;
80103b5e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b63:	eb 2f                	jmp    80103b94 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b68:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b6c:	0f b7 c0             	movzwl %ax,%eax
80103b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b76:	89 04 24             	mov    %eax,(%esp)
80103b79:	e8 04 fe ff ff       	call   80103982 <sum>
80103b7e:	84 c0                	test   %al,%al
80103b80:	74 07                	je     80103b89 <mpconfig+0xa0>
    return 0;
80103b82:	b8 00 00 00 00       	mov    $0x0,%eax
80103b87:	eb 0b                	jmp    80103b94 <mpconfig+0xab>
  *pmp = mp;
80103b89:	8b 45 08             	mov    0x8(%ebp),%eax
80103b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b8f:	89 10                	mov    %edx,(%eax)
  return conf;
80103b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b94:	c9                   	leave  
80103b95:	c3                   	ret    

80103b96 <mpinit>:

void
mpinit(void)
{
80103b96:	55                   	push   %ebp
80103b97:	89 e5                	mov    %esp,%ebp
80103b99:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103b9c:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103ba3:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ba6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ba9:	89 04 24             	mov    %eax,(%esp)
80103bac:	e8 38 ff ff ff       	call   80103ae9 <mpconfig>
80103bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bb8:	75 05                	jne    80103bbf <mpinit+0x29>
    return;
80103bba:	e9 9c 01 00 00       	jmp    80103d5b <mpinit+0x1c5>
  ismp = 1;
80103bbf:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103bc6:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcc:	8b 40 24             	mov    0x24(%eax),%eax
80103bcf:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd7:	83 c0 2c             	add    $0x2c,%eax
80103bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103be4:	0f b7 d0             	movzwl %ax,%edx
80103be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bea:	01 d0                	add    %edx,%eax
80103bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bef:	e9 f4 00 00 00       	jmp    80103ce8 <mpinit+0x152>
    switch(*p){
80103bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf7:	0f b6 00             	movzbl (%eax),%eax
80103bfa:	0f b6 c0             	movzbl %al,%eax
80103bfd:	83 f8 04             	cmp    $0x4,%eax
80103c00:	0f 87 bf 00 00 00    	ja     80103cc5 <mpinit+0x12f>
80103c06:	8b 04 85 98 89 10 80 	mov    -0x7fef7668(,%eax,4),%eax
80103c0d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c12:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c18:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c1c:	0f b6 d0             	movzbl %al,%edx
80103c1f:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c24:	39 c2                	cmp    %eax,%edx
80103c26:	74 2d                	je     80103c55 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c2f:	0f b6 d0             	movzbl %al,%edx
80103c32:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c37:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c3f:	c7 04 24 5a 89 10 80 	movl   $0x8010895a,(%esp)
80103c46:	e8 55 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c4b:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103c52:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c58:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c5c:	0f b6 c0             	movzbl %al,%eax
80103c5f:	83 e0 02             	and    $0x2,%eax
80103c62:	85 c0                	test   %eax,%eax
80103c64:	74 15                	je     80103c7b <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c66:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c6b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c71:	05 60 23 11 80       	add    $0x80112360,%eax
80103c76:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103c7b:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103c81:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c86:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c8c:	81 c2 60 23 11 80    	add    $0x80112360,%edx
80103c92:	88 02                	mov    %al,(%edx)
      ncpu++;
80103c94:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c99:	83 c0 01             	add    $0x1,%eax
80103c9c:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103ca1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ca5:	eb 41                	jmp    80103ce8 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cb0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cb4:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103cb9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cbd:	eb 29                	jmp    80103ce8 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cbf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cc3:	eb 23                	jmp    80103ce8 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc8:	0f b6 00             	movzbl (%eax),%eax
80103ccb:	0f b6 c0             	movzbl %al,%eax
80103cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cd2:	c7 04 24 78 89 10 80 	movl   $0x80108978,(%esp)
80103cd9:	e8 c2 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cde:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103ce5:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cee:	0f 82 00 ff ff ff    	jb     80103bf4 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103cf4:	a1 44 23 11 80       	mov    0x80112344,%eax
80103cf9:	85 c0                	test   %eax,%eax
80103cfb:	75 1d                	jne    80103d1a <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103cfd:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103d04:	00 00 00 
    lapic = 0;
80103d07:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103d0e:	00 00 00 
    ioapicid = 0;
80103d11:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103d18:	eb 41                	jmp    80103d5b <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d1d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d21:	84 c0                	test   %al,%al
80103d23:	74 36                	je     80103d5b <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d25:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d2c:	00 
80103d2d:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d34:	e8 0d fc ff ff       	call   80103946 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d39:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d40:	e8 e4 fb ff ff       	call   80103929 <inb>
80103d45:	83 c8 01             	or     $0x1,%eax
80103d48:	0f b6 c0             	movzbl %al,%eax
80103d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d4f:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d56:	e8 eb fb ff ff       	call   80103946 <outb>
  }
}
80103d5b:	c9                   	leave  
80103d5c:	c3                   	ret    

80103d5d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d5d:	55                   	push   %ebp
80103d5e:	89 e5                	mov    %esp,%ebp
80103d60:	83 ec 08             	sub    $0x8,%esp
80103d63:	8b 55 08             	mov    0x8(%ebp),%edx
80103d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d69:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d6d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d70:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d74:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d78:	ee                   	out    %al,(%dx)
}
80103d79:	c9                   	leave  
80103d7a:	c3                   	ret    

80103d7b <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	8b 45 08             	mov    0x8(%ebp),%eax
80103d84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103d88:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d8c:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103d92:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d96:	0f b6 c0             	movzbl %al,%eax
80103d99:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d9d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103da4:	e8 b4 ff ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, mask >> 8);
80103da9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dad:	66 c1 e8 08          	shr    $0x8,%ax
80103db1:	0f b6 c0             	movzbl %al,%eax
80103db4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103db8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103dbf:	e8 99 ff ff ff       	call   80103d5d <outb>
}
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    

80103dc6 <picenable>:

void
picenable(int irq)
{
80103dc6:	55                   	push   %ebp
80103dc7:	89 e5                	mov    %esp,%ebp
80103dc9:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcf:	ba 01 00 00 00       	mov    $0x1,%edx
80103dd4:	89 c1                	mov    %eax,%ecx
80103dd6:	d3 e2                	shl    %cl,%edx
80103dd8:	89 d0                	mov    %edx,%eax
80103dda:	f7 d0                	not    %eax
80103ddc:	89 c2                	mov    %eax,%edx
80103dde:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103de5:	21 d0                	and    %edx,%eax
80103de7:	0f b7 c0             	movzwl %ax,%eax
80103dea:	89 04 24             	mov    %eax,(%esp)
80103ded:	e8 89 ff ff ff       	call   80103d7b <picsetmask>
}
80103df2:	c9                   	leave  
80103df3:	c3                   	ret    

80103df4 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103dfa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e01:	00 
80103e02:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e09:	e8 4f ff ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, 0xFF);
80103e0e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e15:	00 
80103e16:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e1d:	e8 3b ff ff ff       	call   80103d5d <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e22:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e29:	00 
80103e2a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e31:	e8 27 ff ff ff       	call   80103d5d <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e36:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e3d:	00 
80103e3e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e45:	e8 13 ff ff ff       	call   80103d5d <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e4a:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e51:	00 
80103e52:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e59:	e8 ff fe ff ff       	call   80103d5d <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e5e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e65:	00 
80103e66:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e6d:	e8 eb fe ff ff       	call   80103d5d <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e72:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e79:	00 
80103e7a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103e81:	e8 d7 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103e86:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103e8d:	00 
80103e8e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e95:	e8 c3 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103e9a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ea1:	00 
80103ea2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea9:	e8 af fe ff ff       	call   80103d5d <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103eae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103eb5:	00 
80103eb6:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebd:	e8 9b fe ff ff       	call   80103d5d <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ec2:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ec9:	00 
80103eca:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ed1:	e8 87 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ed6:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103edd:	00 
80103ede:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ee5:	e8 73 fe ff ff       	call   80103d5d <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103eea:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ef1:	00 
80103ef2:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ef9:	e8 5f fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103efe:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f05:	00 
80103f06:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f0d:	e8 4b fe ff ff       	call   80103d5d <outb>

  if(irqmask != 0xFFFF)
80103f12:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f19:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f1d:	74 12                	je     80103f31 <picinit+0x13d>
    picsetmask(irqmask);
80103f1f:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f26:	0f b7 c0             	movzwl %ax,%eax
80103f29:	89 04 24             	mov    %eax,(%esp)
80103f2c:	e8 4a fe ff ff       	call   80103d7b <picsetmask>
}
80103f31:	c9                   	leave  
80103f32:	c3                   	ret    

80103f33 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f33:	55                   	push   %ebp
80103f34:	89 e5                	mov    %esp,%ebp
80103f36:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f49:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4c:	8b 10                	mov    (%eax),%edx
80103f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f51:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f53:	e8 dd cf ff ff       	call   80100f35 <filealloc>
80103f58:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5b:	89 02                	mov    %eax,(%edx)
80103f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f60:	8b 00                	mov    (%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	0f 84 c8 00 00 00    	je     80104032 <pipealloc+0xff>
80103f6a:	e8 c6 cf ff ff       	call   80100f35 <filealloc>
80103f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f72:	89 02                	mov    %eax,(%edx)
80103f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f77:	8b 00                	mov    (%eax),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	0f 84 b1 00 00 00    	je     80104032 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f81:	e8 6e eb ff ff       	call   80102af4 <kalloc>
80103f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f8d:	75 05                	jne    80103f94 <pipealloc+0x61>
    goto bad;
80103f8f:	e9 9e 00 00 00       	jmp    80104032 <pipealloc+0xff>
  p->readopen = 1;
80103f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f97:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f9e:	00 00 00 
  p->writeopen = 1;
80103fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fab:	00 00 00 
  p->nwrite = 0;
80103fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fb8:	00 00 00 
  p->nread = 0;
80103fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbe:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fc5:	00 00 00 
  initlock(&p->lock, "pipe");
80103fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcb:	c7 44 24 04 ac 89 10 	movl   $0x801089ac,0x4(%esp)
80103fd2:	80 
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 82 10 00 00       	call   8010505d <initlock>
  (*f0)->type = FD_PIPE;
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	8b 00                	mov    (%eax),%eax
80103fe0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe9:	8b 00                	mov    (%eax),%eax
80103feb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103fef:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff2:	8b 00                	mov    (%eax),%eax
80103ff4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffb:	8b 00                	mov    (%eax),%eax
80103ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104000:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104003:	8b 45 0c             	mov    0xc(%ebp),%eax
80104006:	8b 00                	mov    (%eax),%eax
80104008:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010400e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104011:	8b 00                	mov    (%eax),%eax
80104013:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104017:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401a:	8b 00                	mov    (%eax),%eax
8010401c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104020:	8b 45 0c             	mov    0xc(%ebp),%eax
80104023:	8b 00                	mov    (%eax),%eax
80104025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104028:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010402b:	b8 00 00 00 00       	mov    $0x0,%eax
80104030:	eb 42                	jmp    80104074 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104036:	74 0b                	je     80104043 <pipealloc+0x110>
    kfree((char*)p);
80104038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403b:	89 04 24             	mov    %eax,(%esp)
8010403e:	e8 18 ea ff ff       	call   80102a5b <kfree>
  if(*f0)
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	8b 00                	mov    (%eax),%eax
80104048:	85 c0                	test   %eax,%eax
8010404a:	74 0d                	je     80104059 <pipealloc+0x126>
    fileclose(*f0);
8010404c:	8b 45 08             	mov    0x8(%ebp),%eax
8010404f:	8b 00                	mov    (%eax),%eax
80104051:	89 04 24             	mov    %eax,(%esp)
80104054:	e8 84 cf ff ff       	call   80100fdd <fileclose>
  if(*f1)
80104059:	8b 45 0c             	mov    0xc(%ebp),%eax
8010405c:	8b 00                	mov    (%eax),%eax
8010405e:	85 c0                	test   %eax,%eax
80104060:	74 0d                	je     8010406f <pipealloc+0x13c>
    fileclose(*f1);
80104062:	8b 45 0c             	mov    0xc(%ebp),%eax
80104065:	8b 00                	mov    (%eax),%eax
80104067:	89 04 24             	mov    %eax,(%esp)
8010406a:	e8 6e cf ff ff       	call   80100fdd <fileclose>
  return -1;
8010406f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104074:	c9                   	leave  
80104075:	c3                   	ret    

80104076 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104076:	55                   	push   %ebp
80104077:	89 e5                	mov    %esp,%ebp
80104079:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010407c:	8b 45 08             	mov    0x8(%ebp),%eax
8010407f:	89 04 24             	mov    %eax,(%esp)
80104082:	e8 f7 0f 00 00       	call   8010507e <acquire>
  if(writable){
80104087:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010408b:	74 1f                	je     801040ac <pipeclose+0x36>
    p->writeopen = 0;
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104097:	00 00 00 
    wakeup(&p->nread);
8010409a:	8b 45 08             	mov    0x8(%ebp),%eax
8010409d:	05 34 02 00 00       	add    $0x234,%eax
801040a2:	89 04 24             	mov    %eax,(%esp)
801040a5:	e8 be 0d 00 00       	call   80104e68 <wakeup>
801040aa:	eb 1d                	jmp    801040c9 <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040ac:	8b 45 08             	mov    0x8(%ebp),%eax
801040af:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040b6:	00 00 00 
    wakeup(&p->nwrite);
801040b9:	8b 45 08             	mov    0x8(%ebp),%eax
801040bc:	05 38 02 00 00       	add    $0x238,%eax
801040c1:	89 04 24             	mov    %eax,(%esp)
801040c4:	e8 9f 0d 00 00       	call   80104e68 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040c9:	8b 45 08             	mov    0x8(%ebp),%eax
801040cc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040d2:	85 c0                	test   %eax,%eax
801040d4:	75 25                	jne    801040fb <pipeclose+0x85>
801040d6:	8b 45 08             	mov    0x8(%ebp),%eax
801040d9:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040df:	85 c0                	test   %eax,%eax
801040e1:	75 18                	jne    801040fb <pipeclose+0x85>
    release(&p->lock);
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
801040e6:	89 04 24             	mov    %eax,(%esp)
801040e9:	e8 f2 0f 00 00       	call   801050e0 <release>
    kfree((char*)p);
801040ee:	8b 45 08             	mov    0x8(%ebp),%eax
801040f1:	89 04 24             	mov    %eax,(%esp)
801040f4:	e8 62 e9 ff ff       	call   80102a5b <kfree>
801040f9:	eb 0b                	jmp    80104106 <pipeclose+0x90>
  } else
    release(&p->lock);
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	89 04 24             	mov    %eax,(%esp)
80104101:	e8 da 0f 00 00       	call   801050e0 <release>
}
80104106:	c9                   	leave  
80104107:	c3                   	ret    

80104108 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104108:	55                   	push   %ebp
80104109:	89 e5                	mov    %esp,%ebp
8010410b:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 04 24             	mov    %eax,(%esp)
80104114:	e8 65 0f 00 00       	call   8010507e <acquire>
  for(i = 0; i < n; i++){
80104119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104120:	e9 a9 00 00 00       	jmp    801041ce <pipewrite+0xc6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104125:	eb 5a                	jmp    80104181 <pipewrite+0x79>
      if(p->readopen == 0 || thread->proc->killed){
80104127:	8b 45 08             	mov    0x8(%ebp),%eax
8010412a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104130:	85 c0                	test   %eax,%eax
80104132:	74 10                	je     80104144 <pipewrite+0x3c>
80104134:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010413a:	8b 40 0c             	mov    0xc(%eax),%eax
8010413d:	8b 40 18             	mov    0x18(%eax),%eax
80104140:	85 c0                	test   %eax,%eax
80104142:	74 15                	je     80104159 <pipewrite+0x51>
        release(&p->lock);
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	89 04 24             	mov    %eax,(%esp)
8010414a:	e8 91 0f 00 00       	call   801050e0 <release>
        return -1;
8010414f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104154:	e9 9f 00 00 00       	jmp    801041f8 <pipewrite+0xf0>
      }
      wakeup(&p->nread);
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	05 34 02 00 00       	add    $0x234,%eax
80104161:	89 04 24             	mov    %eax,(%esp)
80104164:	e8 ff 0c 00 00       	call   80104e68 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	8b 55 08             	mov    0x8(%ebp),%edx
8010416f:	81 c2 38 02 00 00    	add    $0x238,%edx
80104175:	89 44 24 04          	mov    %eax,0x4(%esp)
80104179:	89 14 24             	mov    %edx,(%esp)
8010417c:	e8 ef 0b 00 00       	call   80104d70 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010418a:	8b 45 08             	mov    0x8(%ebp),%eax
8010418d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104193:	05 00 02 00 00       	add    $0x200,%eax
80104198:	39 c2                	cmp    %eax,%edx
8010419a:	74 8b                	je     80104127 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010419c:	8b 45 08             	mov    0x8(%ebp),%eax
8010419f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041a5:	8d 48 01             	lea    0x1(%eax),%ecx
801041a8:	8b 55 08             	mov    0x8(%ebp),%edx
801041ab:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041b1:	25 ff 01 00 00       	and    $0x1ff,%eax
801041b6:	89 c1                	mov    %eax,%ecx
801041b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801041be:	01 d0                	add    %edx,%eax
801041c0:	0f b6 10             	movzbl (%eax),%edx
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
801041c6:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d1:	3b 45 10             	cmp    0x10(%ebp),%eax
801041d4:	0f 8c 4b ff ff ff    	jl     80104125 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041da:	8b 45 08             	mov    0x8(%ebp),%eax
801041dd:	05 34 02 00 00       	add    $0x234,%eax
801041e2:	89 04 24             	mov    %eax,(%esp)
801041e5:	e8 7e 0c 00 00       	call   80104e68 <wakeup>
  release(&p->lock);
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	89 04 24             	mov    %eax,(%esp)
801041f0:	e8 eb 0e 00 00       	call   801050e0 <release>
  return n;
801041f5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    

801041fa <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801041fa:	55                   	push   %ebp
801041fb:	89 e5                	mov    %esp,%ebp
801041fd:	53                   	push   %ebx
801041fe:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	89 04 24             	mov    %eax,(%esp)
80104207:	e8 72 0e 00 00       	call   8010507e <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010420c:	eb 3d                	jmp    8010424b <piperead+0x51>
    if(thread->proc->killed){
8010420e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104214:	8b 40 0c             	mov    0xc(%eax),%eax
80104217:	8b 40 18             	mov    0x18(%eax),%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 15                	je     80104233 <piperead+0x39>
      release(&p->lock);
8010421e:	8b 45 08             	mov    0x8(%ebp),%eax
80104221:	89 04 24             	mov    %eax,(%esp)
80104224:	e8 b7 0e 00 00       	call   801050e0 <release>
      return -1;
80104229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010422e:	e9 b5 00 00 00       	jmp    801042e8 <piperead+0xee>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104233:	8b 45 08             	mov    0x8(%ebp),%eax
80104236:	8b 55 08             	mov    0x8(%ebp),%edx
80104239:	81 c2 34 02 00 00    	add    $0x234,%edx
8010423f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104243:	89 14 24             	mov    %edx,(%esp)
80104246:	e8 25 0b 00 00       	call   80104d70 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010424b:	8b 45 08             	mov    0x8(%ebp),%eax
8010424e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104254:	8b 45 08             	mov    0x8(%ebp),%eax
80104257:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010425d:	39 c2                	cmp    %eax,%edx
8010425f:	75 0d                	jne    8010426e <piperead+0x74>
80104261:	8b 45 08             	mov    0x8(%ebp),%eax
80104264:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010426a:	85 c0                	test   %eax,%eax
8010426c:	75 a0                	jne    8010420e <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010426e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104275:	eb 4b                	jmp    801042c2 <piperead+0xc8>
    if(p->nread == p->nwrite)
80104277:	8b 45 08             	mov    0x8(%ebp),%eax
8010427a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104280:	8b 45 08             	mov    0x8(%ebp),%eax
80104283:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104289:	39 c2                	cmp    %eax,%edx
8010428b:	75 02                	jne    8010428f <piperead+0x95>
      break;
8010428d:	eb 3b                	jmp    801042ca <piperead+0xd0>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010428f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104292:	8b 45 0c             	mov    0xc(%ebp),%eax
80104295:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104298:	8b 45 08             	mov    0x8(%ebp),%eax
8010429b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042a1:	8d 48 01             	lea    0x1(%eax),%ecx
801042a4:	8b 55 08             	mov    0x8(%ebp),%edx
801042a7:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042ad:	25 ff 01 00 00       	and    $0x1ff,%eax
801042b2:	89 c2                	mov    %eax,%edx
801042b4:	8b 45 08             	mov    0x8(%ebp),%eax
801042b7:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042bc:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801042c8:	7c ad                	jl     80104277 <piperead+0x7d>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042ca:	8b 45 08             	mov    0x8(%ebp),%eax
801042cd:	05 38 02 00 00       	add    $0x238,%eax
801042d2:	89 04 24             	mov    %eax,(%esp)
801042d5:	e8 8e 0b 00 00       	call   80104e68 <wakeup>
  release(&p->lock);
801042da:	8b 45 08             	mov    0x8(%ebp),%eax
801042dd:	89 04 24             	mov    %eax,(%esp)
801042e0:	e8 fb 0d 00 00       	call   801050e0 <release>
  return i;
801042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e8:	83 c4 24             	add    $0x24,%esp
801042eb:	5b                   	pop    %ebx
801042ec:	5d                   	pop    %ebp
801042ed:	c3                   	ret    

801042ee <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801042ee:	55                   	push   %ebp
801042ef:	89 e5                	mov    %esp,%ebp
801042f1:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042f4:	9c                   	pushf  
801042f5:	58                   	pop    %eax
801042f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801042f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801042fc:	c9                   	leave  
801042fd:	c3                   	ret    

801042fe <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801042fe:	55                   	push   %ebp
801042ff:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104301:	fb                   	sti    
}
80104302:	5d                   	pop    %ebp
80104303:	c3                   	ret    

80104304 <pinit>:



void
pinit(void)
{
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010430a:	c7 44 24 04 b1 89 10 	movl   $0x801089b1,0x4(%esp)
80104311:	80 
80104312:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104319:	e8 3f 0d 00 00       	call   8010505d <initlock>
}
8010431e:	c9                   	leave  
8010431f:	c3                   	ret    

80104320 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 28             	sub    $0x28,%esp
  struct thread *threads;
  char *sp;



  acquire(&ptable.lock);
80104326:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010432d:	e8 4c 0d 00 00       	call   8010507e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104332:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104339:	e9 8e 00 00 00       	jmp    801043cc <allocproc+0xac>
    if(p->state == UNUSED)
8010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104341:	8b 40 08             	mov    0x8(%eax),%eax
80104344:	85 c0                	test   %eax,%eax
80104346:	75 7d                	jne    801043c5 <allocproc+0xa5>
      goto found;
80104348:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  threads = p->threads;
80104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104356:	83 c0 70             	add    $0x70,%eax
80104359:	89 45 f0             	mov    %eax,-0x10(%ebp)
  p->numOfThreads = 0;
8010435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435f:	c7 80 30 02 00 00 00 	movl   $0x0,0x230(%eax)
80104366:	00 00 00 

  threads->state=EMBRYO;
80104369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010436c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  threads->proc=p;
80104373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104376:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104379:	89 50 0c             	mov    %edx,0xc(%eax)

  p->pid = nextpid++;
8010437c:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104381:	8d 50 01             	lea    0x1(%eax),%edx
80104384:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010438a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438d:	89 42 0c             	mov    %eax,0xc(%edx)
  threads->pid =nextpid++;
80104390:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104395:	8d 50 01             	lea    0x1(%eax),%edx
80104398:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010439e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043a1:	89 42 08             	mov    %eax,0x8(%edx)

  release(&ptable.lock);
801043a4:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801043ab:	e8 30 0d 00 00       	call   801050e0 <release>

  // Allocate kernel stack.
  if((threads->kstack = kalloc()) == 0){
801043b0:	e8 3f e7 ff ff       	call   80102af4 <kalloc>
801043b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043b8:	89 02                	mov    %eax,(%edx)
801043ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043bd:	8b 00                	mov    (%eax),%eax
801043bf:	85 c0                	test   %eax,%eax
801043c1:	75 44                	jne    80104407 <allocproc+0xe7>
801043c3:	eb 27                	jmp    801043ec <allocproc+0xcc>
  char *sp;



  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c5:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
801043cc:	81 7d f4 94 b6 11 80 	cmpl   $0x8011b694,-0xc(%ebp)
801043d3:	0f 82 65 ff ff ff    	jb     8010433e <allocproc+0x1e>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801043d9:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801043e0:	e8 fb 0c 00 00       	call   801050e0 <release>
  return 0;
801043e5:	b8 00 00 00 00       	mov    $0x0,%eax
801043ea:	eb 7f                	jmp    8010446b <allocproc+0x14b>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((threads->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    threads->state = UNUSED;
801043f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    return 0;
80104400:	b8 00 00 00 00       	mov    $0x0,%eax
80104405:	eb 64                	jmp    8010446b <allocproc+0x14b>
  }

  sp = threads->kstack + KSTACKSIZE;
80104407:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010440a:	8b 00                	mov    (%eax),%eax
8010440c:	05 00 10 00 00       	add    $0x1000,%eax
80104411:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *threads->tf;
80104414:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  threads->tf = (struct trapframe*)sp;
80104418:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010441b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010441e:	89 50 10             	mov    %edx,0x10(%eax)


  // which returns to trapret.
  // Set up new context to start executing at forkret,

  sp -= 4;
80104421:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80104425:	ba 1f 67 10 80       	mov    $0x8010671f,%edx
8010442a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010442d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *threads->context;
8010442f:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  threads->context = (struct context*)sp;
80104433:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104436:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104439:	89 50 14             	mov    %edx,0x14(%eax)
  memset(threads->context, 0, sizeof *threads->context);
8010443c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010443f:	8b 40 14             	mov    0x14(%eax),%eax
80104442:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104449:	00 
8010444a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104451:	00 
80104452:	89 04 24             	mov    %eax,(%esp)
80104455:	e8 78 0e 00 00       	call   801052d2 <memset>
  threads->context->eip = (uint)forkret;
8010445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010445d:	8b 40 14             	mov    0x14(%eax),%eax
80104460:	ba 44 4d 10 80       	mov    $0x80104d44,%edx
80104465:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104468:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010446b:	c9                   	leave  
8010446c:	c3                   	ret    

8010446d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010446d:	55                   	push   %ebp
8010446e:	89 e5                	mov    %esp,%ebp
80104470:	83 ec 28             	sub    $0x28,%esp

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104473:	e8 a8 fe ff ff       	call   80104320 <allocproc>
80104478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447e:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104483:	e8 e1 39 00 00       	call   80107e69 <setupkvm>
80104488:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010448b:	89 42 04             	mov    %eax,0x4(%edx)
8010448e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104491:	8b 40 04             	mov    0x4(%eax),%eax
80104494:	85 c0                	test   %eax,%eax
80104496:	75 0c                	jne    801044a4 <userinit+0x37>
    panic("userinit: out of memory?");
80104498:	c7 04 24 b8 89 10 80 	movl   $0x801089b8,(%esp)
8010449f:	e8 96 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044a4:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ac:	8b 40 04             	mov    0x4(%eax),%eax
801044af:	89 54 24 08          	mov    %edx,0x8(%esp)
801044b3:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801044ba:	80 
801044bb:	89 04 24             	mov    %eax,(%esp)
801044be:	e8 03 3c 00 00       	call   801080c6 <inituvm>
  p->sz = PGSIZE;
801044c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c6:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->threads->tf, 0, sizeof(*p->threads->tf));
801044cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cf:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801044d5:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801044dc:	00 
801044dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044e4:	00 
801044e5:	89 04 24             	mov    %eax,(%esp)
801044e8:	e8 e5 0d 00 00       	call   801052d2 <memset>
  p->threads->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801044f6:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->threads->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ff:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104505:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->threads->tf->es = p->threads->tf->ds;
8010450b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104514:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104517:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
8010451d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104521:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->threads->tf->ss = p->threads->tf->ds;
80104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104528:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010452e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104531:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
80104537:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010453b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->threads->tf->eflags = FL_IF;
8010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104542:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104548:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->threads->tf->esp = PGSIZE;
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104558:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->threads->tf->eip = 0;  // beginning of initcode.S
8010455f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104562:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104568:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010456f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104572:	83 c0 60             	add    $0x60,%eax
80104575:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010457c:	00 
8010457d:	c7 44 24 04 d1 89 10 	movl   $0x801089d1,0x4(%esp)
80104584:	80 
80104585:	89 04 24             	mov    %eax,(%esp)
80104588:	e8 65 0f 00 00       	call   801054f2 <safestrcpy>
  p->cwd = namei("/");
8010458d:	c7 04 24 da 89 10 80 	movl   $0x801089da,(%esp)
80104594:	e8 7f de ff ff       	call   80102418 <namei>
80104599:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459c:	89 42 5c             	mov    %eax,0x5c(%edx)

  p->numOfThreads = 0;
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	c7 80 30 02 00 00 00 	movl   $0x0,0x230(%eax)
801045a9:	00 00 00 

  p->state = RUNNABLE;
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
  p->threads->state = RUNNABLE;
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
}
801045c0:	c9                   	leave  
801045c1:	c3                   	ret    

801045c2 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045c2:	55                   	push   %ebp
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *proc= thread->proc;
801045c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ce:	8b 40 0c             	mov    0xc(%eax),%eax
801045d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sz = proc->sz;
801045d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045d7:	8b 00                	mov    (%eax),%eax
801045d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045e0:	7e 31                	jle    80104613 <growproc+0x51>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801045e2:	8b 55 08             	mov    0x8(%ebp),%edx
801045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e8:	01 c2                	add    %eax,%edx
801045ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045ed:	8b 40 04             	mov    0x4(%eax),%eax
801045f0:	89 54 24 08          	mov    %edx,0x8(%esp)
801045f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801045fb:	89 04 24             	mov    %eax,(%esp)
801045fe:	e8 39 3c 00 00       	call   8010823c <allocuvm>
80104603:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010460a:	75 3e                	jne    8010464a <growproc+0x88>
      return -1;
8010460c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104611:	eb 52                	jmp    80104665 <growproc+0xa3>
  } else if(n < 0){
80104613:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104617:	79 31                	jns    8010464a <growproc+0x88>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104619:	8b 55 08             	mov    0x8(%ebp),%edx
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	01 c2                	add    %eax,%edx
80104621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104624:	8b 40 04             	mov    0x4(%eax),%eax
80104627:	89 54 24 08          	mov    %edx,0x8(%esp)
8010462b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010462e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104632:	89 04 24             	mov    %eax,(%esp)
80104635:	e8 dc 3c 00 00       	call   80108316 <deallocuvm>
8010463a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010463d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104641:	75 07                	jne    8010464a <growproc+0x88>
      return -1;
80104643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104648:	eb 1b                	jmp    80104665 <growproc+0xa3>
  }
  proc->sz = sz;
8010464a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010464d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104650:	89 10                	mov    %edx,(%eax)
  switchuvm(thread);
80104652:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104658:	89 04 24             	mov    %eax,(%esp)
8010465b:	e8 fa 38 00 00       	call   80107f5a <switchuvm>
  return 0;
80104660:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104665:	c9                   	leave  
80104666:	c3                   	ret    

80104667 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104667:	55                   	push   %ebp
80104668:	89 e5                	mov    %esp,%ebp
8010466a:	57                   	push   %edi
8010466b:	56                   	push   %esi
8010466c:	53                   	push   %ebx
8010466d:	83 ec 3c             	sub    $0x3c,%esp
  int i, pid;
  struct proc *np;
  struct proc *proc=thread->proc;
80104670:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104676:	8b 40 0c             	mov    0xc(%eax),%eax
80104679:	89 45 e0             	mov    %eax,-0x20(%ebp)




  // Allocate process.
  if((np = allocproc()) == 0)
8010467c:	e8 9f fc ff ff       	call   80104320 <allocproc>
80104681:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104684:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104688:	75 0a                	jne    80104694 <fork+0x2d>
    return -1;
8010468a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468f:	e9 7e 01 00 00       	jmp    80104812 <fork+0x1ab>

  nt= np->threads;
80104694:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104697:	83 c0 70             	add    $0x70,%eax
8010469a:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Copy process state from p.



  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010469d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a0:	8b 10                	mov    (%eax),%edx
801046a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a5:	8b 40 04             	mov    0x4(%eax),%eax
801046a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801046ac:	89 04 24             	mov    %eax,(%esp)
801046af:	e8 fe 3d 00 00       	call   801084b2 <copyuvm>
801046b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046b7:	89 42 04             	mov    %eax,0x4(%edx)
801046ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046bd:	8b 40 04             	mov    0x4(%eax),%eax
801046c0:	85 c0                	test   %eax,%eax
801046c2:	75 34                	jne    801046f8 <fork+0x91>
    kfree(nt->kstack);
801046c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046c7:	8b 00                	mov    (%eax),%eax
801046c9:	89 04 24             	mov    %eax,(%esp)
801046cc:	e8 8a e3 ff ff       	call   80102a5b <kfree>

    nt->kstack = 0;
801046d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->state = UNUSED;
801046da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    nt->state = UNUSED;
801046e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    return -1;
801046ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f3:	e9 1a 01 00 00       	jmp    80104812 <fork+0x1ab>
  }

  np->sz = proc->sz;
801046f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fb:	8b 10                	mov    (%eax),%edx
801046fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104700:	89 10                	mov    %edx,(%eax)
  nt->proc= np;
80104702:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104705:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104708:	89 50 0c             	mov    %edx,0xc(%eax)
  np->parent = proc;
8010470b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010470e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104711:	89 50 10             	mov    %edx,0x10(%eax)
  *nt->tf = *thread->tf;
80104714:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104717:	8b 50 10             	mov    0x10(%eax),%edx
8010471a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104720:	8b 40 10             	mov    0x10(%eax),%eax
80104723:	89 c3                	mov    %eax,%ebx
80104725:	b8 13 00 00 00       	mov    $0x13,%eax
8010472a:	89 d7                	mov    %edx,%edi
8010472c:	89 de                	mov    %ebx,%esi
8010472e:	89 c1                	mov    %eax,%ecx
80104730:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  nt->tf->eax = 0;
80104732:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104735:	8b 40 10             	mov    0x10(%eax),%eax
80104738:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010473f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104746:	eb 37                	jmp    8010477f <fork+0x118>
    if(proc->ofile[i])
80104748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010474e:	83 c2 04             	add    $0x4,%edx
80104751:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	74 22                	je     8010477b <fork+0x114>
      np->ofile[i] = filedup(proc->ofile[i]);
80104759:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010475c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010475f:	83 c2 04             	add    $0x4,%edx
80104762:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104766:	89 04 24             	mov    %eax,(%esp)
80104769:	e8 27 c8 ff ff       	call   80100f95 <filedup>
8010476e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104771:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104774:	83 c1 04             	add    $0x4,%ecx
80104777:	89 44 8a 0c          	mov    %eax,0xc(%edx,%ecx,4)
  *nt->tf = *thread->tf;

  // Clear %eax so that fork returns 0 in the child.
  nt->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010477b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010477f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104783:	7e c3                	jle    80104748 <fork+0xe1>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104785:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104788:	8b 40 5c             	mov    0x5c(%eax),%eax
8010478b:	89 04 24             	mov    %eax,(%esp)
8010478e:	e8 a5 d0 ff ff       	call   80101838 <idup>
80104793:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104796:	89 42 5c             	mov    %eax,0x5c(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104799:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479c:	8d 50 60             	lea    0x60(%eax),%edx
8010479f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047a2:	83 c0 60             	add    $0x60,%eax
801047a5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801047ac:	00 
801047ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801047b1:	89 04 24             	mov    %eax,(%esp)
801047b4:	e8 39 0d 00 00       	call   801054f2 <safestrcpy>
 
  pid = np->pid;
801047b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047bc:	8b 40 0c             	mov    0xc(%eax),%eax
801047bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  nt->pid= nextpid++;
801047c2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801047c7:	8d 50 01             	lea    0x1(%eax),%edx
801047ca:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
801047d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801047d3:	89 42 08             	mov    %eax,0x8(%edx)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801047d6:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801047dd:	e8 9c 08 00 00       	call   8010507e <acquire>
  np->numOfThreads = 1;
801047e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047e5:	c7 80 30 02 00 00 01 	movl   $0x1,0x230(%eax)
801047ec:	00 00 00 
  np->state = RUNNABLE;
801047ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047f2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
  nt->state = RUNNABLE;
801047f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801047fc:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
  release(&ptable.lock);
80104803:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010480a:	e8 d1 08 00 00       	call   801050e0 <release>
  
  return pid;
8010480f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104812:	83 c4 3c             	add    $0x3c,%esp
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5f                   	pop    %edi
80104818:	5d                   	pop    %ebp
80104819:	c3                   	ret    

8010481a <increaseNumOfThreadsAlive>:


void
increaseNumOfThreadsAlive(void){
8010481a:	55                   	push   %ebp
8010481b:	89 e5                	mov    %esp,%ebp
8010481d:	83 ec 28             	sub    $0x28,%esp
	int i = thread->proc->numOfThreads++;
80104820:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104826:	8b 50 0c             	mov    0xc(%eax),%edx
80104829:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
8010482f:	8d 48 01             	lea    0x1(%eax),%ecx
80104832:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
80104838:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(i > NTHREAD)
8010483b:	83 7d f4 10          	cmpl   $0x10,-0xc(%ebp)
8010483f:	7e 0c                	jle    8010484d <increaseNumOfThreadsAlive+0x33>
		panic("Too many threads");
80104841:	c7 04 24 dc 89 10 80 	movl   $0x801089dc,(%esp)
80104848:	e8 ed bc ff ff       	call   8010053a <panic>
}
8010484d:	c9                   	leave  
8010484e:	c3                   	ret    

8010484f <decreaseNumOfThreadsAlive>:


void
decreaseNumOfThreadsAlive(void){
8010484f:	55                   	push   %ebp
80104850:	89 e5                	mov    %esp,%ebp
80104852:	83 ec 28             	sub    $0x28,%esp
	int i = thread->proc->numOfThreads--;
80104855:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485b:	8b 50 0c             	mov    0xc(%eax),%edx
8010485e:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
80104864:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104867:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
8010486d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(i < 0)
80104870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104874:	79 0c                	jns    80104882 <decreaseNumOfThreadsAlive+0x33>
		panic("Not enough threads");
80104876:	c7 04 24 ed 89 10 80 	movl   $0x801089ed,(%esp)
8010487d:	e8 b8 bc ff ff       	call   8010053a <panic>
}
80104882:	c9                   	leave  
80104883:	c3                   	ret    

80104884 <procIsAlive>:

int
procIsAlive(){
80104884:	55                   	push   %ebp
80104885:	89 e5                	mov    %esp,%ebp
	return thread->proc->numOfThreads > 0;
80104887:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488d:	8b 40 0c             	mov    0xc(%eax),%eax
80104890:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104896:	85 c0                	test   %eax,%eax
80104898:	0f 9f c0             	setg   %al
8010489b:	0f b6 c0             	movzbl %al,%eax
}
8010489e:	5d                   	pop    %ebp
8010489f:	c3                   	ret    

801048a0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct proc *proc =thread->proc;
801048a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ac:	8b 40 0c             	mov    0xc(%eax),%eax
801048af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct thread *t;
  int fd;

  if(proc == initproc)
801048b2:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801048b7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
801048ba:	75 0c                	jne    801048c8 <exit+0x28>
    panic("init exiting");
801048bc:	c7 04 24 00 8a 10 80 	movl   $0x80108a00,(%esp)
801048c3:	e8 72 bc ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801048cf:	eb 3b                	jmp    8010490c <exit+0x6c>
    if(proc->ofile[fd]){
801048d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801048d7:	83 c2 04             	add    $0x4,%edx
801048da:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048de:	85 c0                	test   %eax,%eax
801048e0:	74 26                	je     80104908 <exit+0x68>
      fileclose(proc->ofile[fd]);
801048e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801048e8:	83 c2 04             	add    $0x4,%edx
801048eb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048ef:	89 04 24             	mov    %eax,(%esp)
801048f2:	e8 e6 c6 ff ff       	call   80100fdd <fileclose>
      proc->ofile[fd] = 0;
801048f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
801048fd:	83 c2 04             	add    $0x4,%edx
80104900:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80104907:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104908:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010490c:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
80104910:	7e bf                	jle    801048d1 <exit+0x31>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104912:	e8 0b eb ff ff       	call   80103422 <begin_op>
  iput(proc->cwd);
80104917:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010491a:	8b 40 5c             	mov    0x5c(%eax),%eax
8010491d:	89 04 24             	mov    %eax,(%esp)
80104920:	e8 f8 d0 ff ff       	call   80101a1d <iput>
  end_op();
80104925:	e8 7c eb ff ff       	call   801034a6 <end_op>
  proc->cwd = 0;
8010492a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010492d:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)

  acquire(&ptable.lock);
80104934:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010493b:	e8 3e 07 00 00       	call   8010507e <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104940:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104943:	8b 40 10             	mov    0x10(%eax),%eax
80104946:	89 04 24             	mov    %eax,(%esp)
80104949:	e8 bd 04 00 00       	call   80104e0b <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494e:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104955:	eb 36                	jmp    8010498d <exit+0xed>
    if(p->parent == proc){
80104957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495a:	8b 40 10             	mov    0x10(%eax),%eax
8010495d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104960:	75 24                	jne    80104986 <exit+0xe6>
      p->parent = initproc;
80104962:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496b:	89 50 10             	mov    %edx,0x10(%eax)
      if(p->state == ZOMBIE)
8010496e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104971:	8b 40 08             	mov    0x8(%eax),%eax
80104974:	83 f8 05             	cmp    $0x5,%eax
80104977:	75 0d                	jne    80104986 <exit+0xe6>
        wakeup1(initproc);
80104979:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010497e:	89 04 24             	mov    %eax,(%esp)
80104981:	e8 85 04 00 00       	call   80104e0b <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104986:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
8010498d:	81 7d f4 94 b6 11 80 	cmpl   $0x8011b694,-0xc(%ebp)
80104994:	72 c1                	jb     80104957 <exit+0xb7>
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
  decreaseNumOfThreadsAlive();
80104996:	e8 b4 fe ff ff       	call   8010484f <decreaseNumOfThreadsAlive>
  proc->killed = 1;
8010499b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010499e:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
  for (t = proc->threads; t < &proc->threads[NTHREAD]; t++){
801049a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049a8:	83 c0 70             	add    $0x70,%eax
801049ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801049ae:	eb 28                	jmp    801049d8 <exit+0x138>
  		if (t->state != RUNNING && t->state != UNUSED){
801049b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049b3:	8b 40 04             	mov    0x4(%eax),%eax
801049b6:	83 f8 04             	cmp    $0x4,%eax
801049b9:	74 19                	je     801049d4 <exit+0x134>
801049bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049be:	8b 40 04             	mov    0x4(%eax),%eax
801049c1:	85 c0                	test   %eax,%eax
801049c3:	74 0f                	je     801049d4 <exit+0x134>
  			t->state = ZOMBIE;
801049c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c8:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)
  			decreaseNumOfThreadsAlive();
801049cf:	e8 7b fe ff ff       	call   8010484f <decreaseNumOfThreadsAlive>
        wakeup1(initproc);
    }
  }
  decreaseNumOfThreadsAlive();
  proc->killed = 1;
  for (t = proc->threads; t < &proc->threads[NTHREAD]; t++){
801049d4:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
801049d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049db:	05 30 02 00 00       	add    $0x230,%eax
801049e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801049e3:	77 cb                	ja     801049b0 <exit+0x110>

  		}
  	}

  // Jump into the scheduler, never to return.
 if(!procIsAlive())
801049e5:	e8 9a fe ff ff       	call   80104884 <procIsAlive>
801049ea:	85 c0                	test   %eax,%eax
801049ec:	75 0a                	jne    801049f8 <exit+0x158>
	  proc->state = ZOMBIE;
801049ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049f1:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
 thread->state = ZOMBIE;
801049f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fe:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)

  sched();
80104a05:	e8 56 02 00 00       	call   80104c60 <sched>
  panic("zombie exit");
80104a0a:	c7 04 24 0d 8a 10 80 	movl   $0x80108a0d,(%esp)
80104a11:	e8 24 bb ff ff       	call   8010053a <panic>

80104a16 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a16:	55                   	push   %ebp
80104a17:	89 e5                	mov    %esp,%ebp
80104a19:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *proc=thread->proc;
80104a1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a22:	8b 40 0c             	mov    0xc(%eax),%eax
80104a25:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct thread *t;

  acquire(&ptable.lock);
80104a28:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a2f:	e8 4a 06 00 00       	call   8010507e <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3b:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104a42:	e9 f4 00 00 00       	jmp    80104b3b <wait+0x125>
      if(p->parent != proc)
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	8b 40 10             	mov    0x10(%eax),%eax
80104a4d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104a50:	74 05                	je     80104a57 <wait+0x41>
        continue;
80104a52:	e9 dd 00 00 00       	jmp    80104b34 <wait+0x11e>
      havekids = 1;
80104a57:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	8b 40 08             	mov    0x8(%eax),%eax
80104a64:	83 f8 05             	cmp    $0x5,%eax
80104a67:	0f 85 c7 00 00 00    	jne    80104b34 <wait+0x11e>
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a70:	83 c0 70             	add    $0x70,%eax
80104a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a76:	eb 58                	jmp    80104ad0 <wait+0xba>

    		  if (t->state == ZOMBIE){
80104a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a7b:	8b 40 04             	mov    0x4(%eax),%eax
80104a7e:	83 f8 05             	cmp    $0x5,%eax
80104a81:	75 49                	jne    80104acc <wait+0xb6>
				  t->chan= 0;
80104a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a86:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
				  t->context = 0;
80104a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a90:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				  t->pid = 0;
80104a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				  t->proc = 0;
80104aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				  t->state = 0;
80104aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				 // t->tf = 0;
				  t->state= UNUSED;
80104ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				  kfree(t->kstack);
80104abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ac2:	8b 00                	mov    (%eax),%eax
80104ac4:	89 04 24             	mov    %eax,(%esp)
80104ac7:	e8 8f df ff ff       	call   80102a5b <kfree>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104acc:	83 45 ec 1c          	addl   $0x1c,-0x14(%ebp)
80104ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ad3:	05 30 02 00 00       	add    $0x230,%eax
80104ad8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104adb:	77 9b                	ja     80104a78 <wait+0x62>
				  t->state= UNUSED;
				  kfree(t->kstack);
    		  }
    	  }

        pid = p->pid;
80104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae0:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

        freevm(p->pgdir);
80104ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae9:	8b 40 04             	mov    0x4(%eax),%eax
80104aec:	89 04 24             	mov    %eax,(%esp)
80104aef:	e8 de 38 00 00       	call   801083d2 <freevm>
        p->state = UNUSED;
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        p->pid = 0;
80104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->parent = 0;
80104b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->name[0] = 0;
80104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b15:	c6 40 60 00          	movb   $0x0,0x60(%eax)
        p->killed = 0;
80104b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        release(&ptable.lock);
80104b23:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b2a:	e8 b1 05 00 00       	call   801050e0 <release>
        return pid;
80104b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b32:	eb 4f                	jmp    80104b83 <wait+0x16d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b34:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104b3b:	81 7d f4 94 b6 11 80 	cmpl   $0x8011b694,-0xc(%ebp)
80104b42:	0f 82 ff fe ff ff    	jb     80104a47 <wait+0x31>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b4c:	74 0a                	je     80104b58 <wait+0x142>
80104b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b51:	8b 40 18             	mov    0x18(%eax),%eax
80104b54:	85 c0                	test   %eax,%eax
80104b56:	74 13                	je     80104b6b <wait+0x155>
      release(&ptable.lock);
80104b58:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b5f:	e8 7c 05 00 00       	call   801050e0 <release>
      return -1;
80104b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b69:	eb 18                	jmp    80104b83 <wait+0x16d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b6b:	c7 44 24 04 60 29 11 	movl   $0x80112960,0x4(%esp)
80104b72:	80 
80104b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b76:	89 04 24             	mov    %eax,(%esp)
80104b79:	e8 f2 01 00 00       	call   80104d70 <sleep>
  }
80104b7e:	e9 b1 fe ff ff       	jmp    80104a34 <wait+0x1e>
  return -1;
}
80104b83:	c9                   	leave  
80104b84:	c3                   	ret    

80104b85 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b85:	55                   	push   %ebp
80104b86:	89 e5                	mov    %esp,%ebp
80104b88:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b8b:	e8 6e f7 ff ff       	call   801042fe <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b90:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b97:	e8 e2 04 00 00       	call   8010507e <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b9c:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104ba3:	e9 9a 00 00 00       	jmp    80104c42 <scheduler+0xbd>

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
80104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bab:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	7e 0d                	jle    80104bc2 <scheduler+0x3d>
80104bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb8:	8b 40 08             	mov    0x8(%eax),%eax
80104bbb:	83 f8 03             	cmp    $0x3,%eax
80104bbe:	74 02                	je     80104bc2 <scheduler+0x3d>
					continue;
80104bc0:	eb 79                	jmp    80104c3b <scheduler+0xb6>
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc5:	83 c0 70             	add    $0x70,%eax
80104bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104bcb:	eb 61                	jmp    80104c2e <scheduler+0xa9>

				  if(t->state != RUNNABLE)
80104bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bd0:	8b 40 04             	mov    0x4(%eax),%eax
80104bd3:	83 f8 03             	cmp    $0x3,%eax
80104bd6:	74 02                	je     80104bda <scheduler+0x55>
					continue;
80104bd8:	eb 50                	jmp    80104c2a <scheduler+0xa5>
				  // Switch to chosen process.  It is the process's job
				  // to release ptable.lock and then reacquire it
				  // before jumping back to us.
				  thread = t;
80104bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdd:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
				  switchuvm(thread);
80104be3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be9:	89 04 24             	mov    %eax,(%esp)
80104bec:	e8 69 33 00 00       	call   80107f5a <switchuvm>
				  t->state = RUNNING;
80104bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf4:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
				  swtch(&cpu->scheduler, thread->context);
80104bfb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c01:	8b 40 14             	mov    0x14(%eax),%eax
80104c04:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c0b:	83 c2 04             	add    $0x4,%edx
80104c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c12:	89 14 24             	mov    %edx,(%esp)
80104c15:	e8 49 09 00 00       	call   80105563 <swtch>
				  switchkvm();
80104c1a:	e8 1e 33 00 00       	call   80107f3d <switchkvm>

				  // Process is done running for now.
				  // It should have changed its p->state before coming back.
				  thread = 0;
80104c1f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c26:	00 00 00 00 

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
					continue;
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104c2a:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	05 30 02 00 00       	add    $0x230,%eax
80104c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104c39:	77 92                	ja     80104bcd <scheduler+0x48>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c3b:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104c42:	81 7d f4 94 b6 11 80 	cmpl   $0x8011b694,-0xc(%ebp)
80104c49:	0f 82 59 ff ff ff    	jb     80104ba8 <scheduler+0x23>
				  thread = 0;
			  }

    }

    release(&ptable.lock);
80104c4f:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c56:	e8 85 04 00 00       	call   801050e0 <release>

  }
80104c5b:	e9 2b ff ff ff       	jmp    80104b8b <scheduler+0x6>

80104c60 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c66:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c6d:	e8 36 05 00 00       	call   801051a8 <holding>
80104c72:	85 c0                	test   %eax,%eax
80104c74:	75 0c                	jne    80104c82 <sched+0x22>
    panic("sched ptable.lock");
80104c76:	c7 04 24 19 8a 10 80 	movl   $0x80108a19,(%esp)
80104c7d:	e8 b8 b8 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104c82:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c88:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c8e:	83 f8 01             	cmp    $0x1,%eax
80104c91:	74 0c                	je     80104c9f <sched+0x3f>
    panic("sched locks");
80104c93:	c7 04 24 2b 8a 10 80 	movl   $0x80108a2b,(%esp)
80104c9a:	e8 9b b8 ff ff       	call   8010053a <panic>
  if(thread->state == RUNNING)
80104c9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca5:	8b 40 04             	mov    0x4(%eax),%eax
80104ca8:	83 f8 04             	cmp    $0x4,%eax
80104cab:	75 0c                	jne    80104cb9 <sched+0x59>
    panic("sched running");
80104cad:	c7 04 24 37 8a 10 80 	movl   $0x80108a37,(%esp)
80104cb4:	e8 81 b8 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104cb9:	e8 30 f6 ff ff       	call   801042ee <readeflags>
80104cbe:	25 00 02 00 00       	and    $0x200,%eax
80104cc3:	85 c0                	test   %eax,%eax
80104cc5:	74 0c                	je     80104cd3 <sched+0x73>
    panic("sched interruptible");
80104cc7:	c7 04 24 45 8a 10 80 	movl   $0x80108a45,(%esp)
80104cce:	e8 67 b8 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104cd3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cd9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)

  swtch(&thread->context, cpu->scheduler);
80104ce2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ce8:	8b 40 04             	mov    0x4(%eax),%eax
80104ceb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104cf2:	83 c2 14             	add    $0x14,%edx
80104cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf9:	89 14 24             	mov    %edx,(%esp)
80104cfc:	e8 62 08 00 00       	call   80105563 <swtch>
  cpu->intena = intena;
80104d01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d0a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d10:	c9                   	leave  
80104d11:	c3                   	ret    

80104d12 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d12:	55                   	push   %ebp
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp

  acquire(&ptable.lock);  //DOC: yieldlock
80104d18:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d1f:	e8 5a 03 00 00       	call   8010507e <acquire>
  thread->state = RUNNABLE;
80104d24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d2a:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

  sched();
80104d31:	e8 2a ff ff ff       	call   80104c60 <sched>

  release(&ptable.lock);
80104d36:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d3d:	e8 9e 03 00 00       	call   801050e0 <release>
}
80104d42:	c9                   	leave  
80104d43:	c3                   	ret    

80104d44 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d4a:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d51:	e8 8a 03 00 00       	call   801050e0 <release>

  if (first) {
80104d56:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	74 0f                	je     80104d6e <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104d5f:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104d66:	00 00 00 
    initlog();
80104d69:	e8 a6 e4 ff ff       	call   80103214 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    

80104d70 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	83 ec 18             	sub    $0x18,%esp
  if(thread == 0)
80104d76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d7c:	85 c0                	test   %eax,%eax
80104d7e:	75 0c                	jne    80104d8c <sleep+0x1c>
    panic("sleep");
80104d80:	c7 04 24 59 8a 10 80 	movl   $0x80108a59,(%esp)
80104d87:	e8 ae b7 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d90:	75 0c                	jne    80104d9e <sleep+0x2e>
    panic("sleep without lk");
80104d92:	c7 04 24 5f 8a 10 80 	movl   $0x80108a5f,(%esp)
80104d99:	e8 9c b7 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104d9e:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104da5:	74 17                	je     80104dbe <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104da7:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104dae:	e8 cb 02 00 00       	call   8010507e <acquire>
    release(lk);
80104db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db6:	89 04 24             	mov    %eax,(%esp)
80104db9:	e8 22 03 00 00       	call   801050e0 <release>
  }

  // Go to sleep.
  thread->chan = chan;
80104dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104dc7:	89 50 18             	mov    %edx,0x18(%eax)
  thread->state = SLEEPING;
80104dca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd0:	c7 40 04 02 00 00 00 	movl   $0x2,0x4(%eax)
  sched();
80104dd7:	e8 84 fe ff ff       	call   80104c60 <sched>

  // Tidy up.
  thread->chan = 0;
80104ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de2:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104de9:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104df0:	74 17                	je     80104e09 <sleep+0x99>
    release(&ptable.lock);
80104df2:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104df9:	e8 e2 02 00 00       	call   801050e0 <release>
    acquire(lk);
80104dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e01:	89 04 24             	mov    %eax,(%esp)
80104e04:	e8 75 02 00 00       	call   8010507e <acquire>
  }
}
80104e09:	c9                   	leave  
80104e0a:	c3                   	ret    

80104e0b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e0b:	55                   	push   %ebp
80104e0c:	89 e5                	mov    %esp,%ebp
80104e0e:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e11:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104e18:	eb 43                	jmp    80104e5d <wakeup1+0x52>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1d:	83 c0 70             	add    $0x70,%eax
80104e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104e23:	eb 24                	jmp    80104e49 <wakeup1+0x3e>
		if(t->state == SLEEPING && t->chan == chan)
80104e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e28:	8b 40 04             	mov    0x4(%eax),%eax
80104e2b:	83 f8 02             	cmp    $0x2,%eax
80104e2e:	75 15                	jne    80104e45 <wakeup1+0x3a>
80104e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e33:	8b 40 18             	mov    0x18(%eax),%eax
80104e36:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e39:	75 0a                	jne    80104e45 <wakeup1+0x3a>
		  t->state = RUNNABLE;
80104e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e3e:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104e45:	83 45 f8 1c          	addl   $0x1c,-0x8(%ebp)
80104e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4c:	05 30 02 00 00       	add    $0x230,%eax
80104e51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e54:	77 cf                	ja     80104e25 <wakeup1+0x1a>
wakeup1(void *chan)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e56:	81 45 fc 34 02 00 00 	addl   $0x234,-0x4(%ebp)
80104e5d:	81 7d fc 94 b6 11 80 	cmpl   $0x8011b694,-0x4(%ebp)
80104e64:	72 b4                	jb     80104e1a <wakeup1+0xf>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
		if(t->state == SLEEPING && t->chan == chan)
		  t->state = RUNNABLE;
	 }
}
80104e66:	c9                   	leave  
80104e67:	c3                   	ret    

80104e68 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104e6e:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104e75:	e8 04 02 00 00       	call   8010507e <acquire>
  wakeup1(chan);
80104e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7d:	89 04 24             	mov    %eax,(%esp)
80104e80:	e8 86 ff ff ff       	call   80104e0b <wakeup1>
  release(&ptable.lock);
80104e85:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104e8c:	e8 4f 02 00 00       	call   801050e0 <release>
}
80104e91:	c9                   	leave  
80104e92:	c3                   	ret    

80104e93 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e93:	55                   	push   %ebp
80104e94:	89 e5                	mov    %esp,%ebp
80104e96:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
80104e99:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104ea0:	e8 d9 01 00 00       	call   8010507e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea5:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104eac:	eb 60                	jmp    80104f0e <kill+0x7b>
    if(p->pid == pid){
80104eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb1:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb4:	3b 45 08             	cmp    0x8(%ebp),%eax
80104eb7:	75 4e                	jne    80104f07 <kill+0x74>
      p->killed = 1;
80104eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ebc:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec6:	83 c0 70             	add    $0x70,%eax
80104ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104ecc:	eb 19                	jmp    80104ee7 <kill+0x54>
			 if(t->state == SLEEPING)
80104ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed1:	8b 40 04             	mov    0x4(%eax),%eax
80104ed4:	83 f8 02             	cmp    $0x2,%eax
80104ed7:	75 0a                	jne    80104ee3 <kill+0x50>
					t->state = RUNNABLE;
80104ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104edc:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104ee3:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eea:	05 30 02 00 00       	add    $0x230,%eax
80104eef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104ef2:	77 da                	ja     80104ece <kill+0x3b>
			 if(t->state == SLEEPING)
					t->state = RUNNABLE;
      }
      // Wake process from sleep if necessary.

      release(&ptable.lock);
80104ef4:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104efb:	e8 e0 01 00 00       	call   801050e0 <release>
      return 0;
80104f00:	b8 00 00 00 00       	mov    $0x0,%eax
80104f05:	eb 21                	jmp    80104f28 <kill+0x95>
kill(int pid)
{
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f07:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104f0e:	81 7d f4 94 b6 11 80 	cmpl   $0x8011b694,-0xc(%ebp)
80104f15:	72 97                	jb     80104eae <kill+0x1b>

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f17:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104f1e:	e8 bd 01 00 00       	call   801050e0 <release>
  return -1;
80104f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f28:	c9                   	leave  
80104f29:	c3                   	ret    

80104f2a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f2a:	55                   	push   %ebp
80104f2b:	89 e5                	mov    %esp,%ebp
80104f2d:	83 ec 58             	sub    $0x58,%esp
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f30:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104f37:	e9 dc 00 00 00       	jmp    80105018 <procdump+0xee>
    if(p->state == UNUSED)
80104f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f3f:	8b 40 08             	mov    0x8(%eax),%eax
80104f42:	85 c0                	test   %eax,%eax
80104f44:	75 05                	jne    80104f4b <procdump+0x21>
      continue;
80104f46:	e9 c6 00 00 00       	jmp    80105011 <procdump+0xe7>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4e:	8b 40 08             	mov    0x8(%eax),%eax
80104f51:	83 f8 05             	cmp    $0x5,%eax
80104f54:	77 23                	ja     80104f79 <procdump+0x4f>
80104f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f59:	8b 40 08             	mov    0x8(%eax),%eax
80104f5c:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104f63:	85 c0                	test   %eax,%eax
80104f65:	74 12                	je     80104f79 <procdump+0x4f>
      state = states[p->state];
80104f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6a:	8b 40 08             	mov    0x8(%eax),%eax
80104f6d:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f77:	eb 07                	jmp    80104f80 <procdump+0x56>
    else
      state = "???";
80104f79:	c7 45 ec 70 8a 10 80 	movl   $0x80108a70,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f83:	8d 50 60             	lea    0x60(%eax),%edx
80104f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f89:	8b 40 0c             	mov    0xc(%eax),%eax
80104f8c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104f90:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f93:	89 54 24 08          	mov    %edx,0x8(%esp)
80104f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9b:	c7 04 24 74 8a 10 80 	movl   $0x80108a74,(%esp)
80104fa2:	e8 f9 b3 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104faa:	8b 40 08             	mov    0x8(%eax),%eax
80104fad:	83 f8 02             	cmp    $0x2,%eax
80104fb0:	75 53                	jne    80105005 <procdump+0xdb>
      getcallerpcs((uint*)thread->context->ebp+2, pc);
80104fb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb8:	8b 40 14             	mov    0x14(%eax),%eax
80104fbb:	8b 40 0c             	mov    0xc(%eax),%eax
80104fbe:	83 c0 08             	add    $0x8,%eax
80104fc1:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104fc4:	89 54 24 04          	mov    %edx,0x4(%esp)
80104fc8:	89 04 24             	mov    %eax,(%esp)
80104fcb:	e8 5f 01 00 00       	call   8010512f <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fd7:	eb 1b                	jmp    80104ff4 <procdump+0xca>
        cprintf(" %p", pc[i]);
80104fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdc:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fe4:	c7 04 24 7d 8a 10 80 	movl   $0x80108a7d,(%esp)
80104feb:	e8 b0 b3 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)thread->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ff0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ff4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ff8:	7f 0b                	jg     80105005 <procdump+0xdb>
80104ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffd:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105001:	85 c0                	test   %eax,%eax
80105003:	75 d4                	jne    80104fd9 <procdump+0xaf>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105005:	c7 04 24 81 8a 10 80 	movl   $0x80108a81,(%esp)
8010500c:	e8 8f b3 ff ff       	call   801003a0 <cprintf>
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105011:	81 45 f0 34 02 00 00 	addl   $0x234,-0x10(%ebp)
80105018:	81 7d f0 94 b6 11 80 	cmpl   $0x8011b694,-0x10(%ebp)
8010501f:	0f 82 17 ff ff ff    	jb     80104f3c <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    

80105027 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105027:	55                   	push   %ebp
80105028:	89 e5                	mov    %esp,%ebp
8010502a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010502d:	9c                   	pushf  
8010502e:	58                   	pop    %eax
8010502f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105032:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    

80105037 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105037:	55                   	push   %ebp
80105038:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010503a:	fa                   	cli    
}
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    

8010503d <sti>:

static inline void
sti(void)
{
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105040:	fb                   	sti    
}
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret    

80105043 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105043:	55                   	push   %ebp
80105044:	89 e5                	mov    %esp,%ebp
80105046:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105049:	8b 55 08             	mov    0x8(%ebp),%edx
8010504c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105052:	f0 87 02             	lock xchg %eax,(%edx)
80105055:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105058:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010505b:	c9                   	leave  
8010505c:	c3                   	ret    

8010505d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010505d:	55                   	push   %ebp
8010505e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	8b 55 0c             	mov    0xc(%ebp),%edx
80105066:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105069:	8b 45 08             	mov    0x8(%ebp),%eax
8010506c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105072:	8b 45 08             	mov    0x8(%ebp),%eax
80105075:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010507c:	5d                   	pop    %ebp
8010507d:	c3                   	ret    

8010507e <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010507e:	55                   	push   %ebp
8010507f:	89 e5                	mov    %esp,%ebp
80105081:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105084:	e8 49 01 00 00       	call   801051d2 <pushcli>
  if(holding(lk))
80105089:	8b 45 08             	mov    0x8(%ebp),%eax
8010508c:	89 04 24             	mov    %eax,(%esp)
8010508f:	e8 14 01 00 00       	call   801051a8 <holding>
80105094:	85 c0                	test   %eax,%eax
80105096:	74 0c                	je     801050a4 <acquire+0x26>
    panic("acquire");
80105098:	c7 04 24 ad 8a 10 80 	movl   $0x80108aad,(%esp)
8010509f:	e8 96 b4 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801050a4:	90                   	nop
801050a5:	8b 45 08             	mov    0x8(%ebp),%eax
801050a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801050af:	00 
801050b0:	89 04 24             	mov    %eax,(%esp)
801050b3:	e8 8b ff ff ff       	call   80105043 <xchg>
801050b8:	85 c0                	test   %eax,%eax
801050ba:	75 e9                	jne    801050a5 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801050bc:	8b 45 08             	mov    0x8(%ebp),%eax
801050bf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050c6:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801050c9:	8b 45 08             	mov    0x8(%ebp),%eax
801050cc:	83 c0 0c             	add    $0xc,%eax
801050cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d3:	8d 45 08             	lea    0x8(%ebp),%eax
801050d6:	89 04 24             	mov    %eax,(%esp)
801050d9:	e8 51 00 00 00       	call   8010512f <getcallerpcs>
}
801050de:	c9                   	leave  
801050df:	c3                   	ret    

801050e0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801050e6:	8b 45 08             	mov    0x8(%ebp),%eax
801050e9:	89 04 24             	mov    %eax,(%esp)
801050ec:	e8 b7 00 00 00       	call   801051a8 <holding>
801050f1:	85 c0                	test   %eax,%eax
801050f3:	75 0c                	jne    80105101 <release+0x21>
    panic("release");
801050f5:	c7 04 24 b5 8a 10 80 	movl   $0x80108ab5,(%esp)
801050fc:	e8 39 b4 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105101:	8b 45 08             	mov    0x8(%ebp),%eax
80105104:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010510b:	8b 45 08             	mov    0x8(%ebp),%eax
8010510e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105115:	8b 45 08             	mov    0x8(%ebp),%eax
80105118:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010511f:	00 
80105120:	89 04 24             	mov    %eax,(%esp)
80105123:	e8 1b ff ff ff       	call   80105043 <xchg>

  popcli();
80105128:	e8 e9 00 00 00       	call   80105216 <popcli>
}
8010512d:	c9                   	leave  
8010512e:	c3                   	ret    

8010512f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010512f:	55                   	push   %ebp
80105130:	89 e5                	mov    %esp,%ebp
80105132:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105135:	8b 45 08             	mov    0x8(%ebp),%eax
80105138:	83 e8 08             	sub    $0x8,%eax
8010513b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010513e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105145:	eb 38                	jmp    8010517f <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105147:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010514b:	74 38                	je     80105185 <getcallerpcs+0x56>
8010514d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105154:	76 2f                	jbe    80105185 <getcallerpcs+0x56>
80105156:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010515a:	74 29                	je     80105185 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010515c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010515f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105166:	8b 45 0c             	mov    0xc(%ebp),%eax
80105169:	01 c2                	add    %eax,%edx
8010516b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010516e:	8b 40 04             	mov    0x4(%eax),%eax
80105171:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105173:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105176:	8b 00                	mov    (%eax),%eax
80105178:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010517b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010517f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105183:	7e c2                	jle    80105147 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105185:	eb 19                	jmp    801051a0 <getcallerpcs+0x71>
    pcs[i] = 0;
80105187:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010518a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105191:	8b 45 0c             	mov    0xc(%ebp),%eax
80105194:	01 d0                	add    %edx,%eax
80105196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010519c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051a0:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051a4:	7e e1                	jle    80105187 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801051a6:	c9                   	leave  
801051a7:	c3                   	ret    

801051a8 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801051a8:	55                   	push   %ebp
801051a9:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801051ab:	8b 45 08             	mov    0x8(%ebp),%eax
801051ae:	8b 00                	mov    (%eax),%eax
801051b0:	85 c0                	test   %eax,%eax
801051b2:	74 17                	je     801051cb <holding+0x23>
801051b4:	8b 45 08             	mov    0x8(%ebp),%eax
801051b7:	8b 50 08             	mov    0x8(%eax),%edx
801051ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051c0:	39 c2                	cmp    %eax,%edx
801051c2:	75 07                	jne    801051cb <holding+0x23>
801051c4:	b8 01 00 00 00       	mov    $0x1,%eax
801051c9:	eb 05                	jmp    801051d0 <holding+0x28>
801051cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    

801051d2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801051d2:	55                   	push   %ebp
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801051d8:	e8 4a fe ff ff       	call   80105027 <readeflags>
801051dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801051e0:	e8 52 fe ff ff       	call   80105037 <cli>
  if(cpu->ncli++ == 0)
801051e5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051ec:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801051f2:	8d 48 01             	lea    0x1(%eax),%ecx
801051f5:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801051fb:	85 c0                	test   %eax,%eax
801051fd:	75 15                	jne    80105214 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801051ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105205:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105208:	81 e2 00 02 00 00    	and    $0x200,%edx
8010520e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105214:	c9                   	leave  
80105215:	c3                   	ret    

80105216 <popcli>:

void
popcli(void)
{
80105216:	55                   	push   %ebp
80105217:	89 e5                	mov    %esp,%ebp
80105219:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010521c:	e8 06 fe ff ff       	call   80105027 <readeflags>
80105221:	25 00 02 00 00       	and    $0x200,%eax
80105226:	85 c0                	test   %eax,%eax
80105228:	74 0c                	je     80105236 <popcli+0x20>
    panic("popcli - interruptible");
8010522a:	c7 04 24 bd 8a 10 80 	movl   $0x80108abd,(%esp)
80105231:	e8 04 b3 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105236:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010523c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105242:	83 ea 01             	sub    $0x1,%edx
80105245:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010524b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105251:	85 c0                	test   %eax,%eax
80105253:	79 0c                	jns    80105261 <popcli+0x4b>
    panic("popcli");
80105255:	c7 04 24 d4 8a 10 80 	movl   $0x80108ad4,(%esp)
8010525c:	e8 d9 b2 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105261:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105267:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010526d:	85 c0                	test   %eax,%eax
8010526f:	75 15                	jne    80105286 <popcli+0x70>
80105271:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105277:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010527d:	85 c0                	test   %eax,%eax
8010527f:	74 05                	je     80105286 <popcli+0x70>
    sti();
80105281:	e8 b7 fd ff ff       	call   8010503d <sti>
}
80105286:	c9                   	leave  
80105287:	c3                   	ret    

80105288 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105288:	55                   	push   %ebp
80105289:	89 e5                	mov    %esp,%ebp
8010528b:	57                   	push   %edi
8010528c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010528d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105290:	8b 55 10             	mov    0x10(%ebp),%edx
80105293:	8b 45 0c             	mov    0xc(%ebp),%eax
80105296:	89 cb                	mov    %ecx,%ebx
80105298:	89 df                	mov    %ebx,%edi
8010529a:	89 d1                	mov    %edx,%ecx
8010529c:	fc                   	cld    
8010529d:	f3 aa                	rep stos %al,%es:(%edi)
8010529f:	89 ca                	mov    %ecx,%edx
801052a1:	89 fb                	mov    %edi,%ebx
801052a3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052a6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801052a9:	5b                   	pop    %ebx
801052aa:	5f                   	pop    %edi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    

801052ad <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801052ad:	55                   	push   %ebp
801052ae:	89 e5                	mov    %esp,%ebp
801052b0:	57                   	push   %edi
801052b1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801052b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052b5:	8b 55 10             	mov    0x10(%ebp),%edx
801052b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052bb:	89 cb                	mov    %ecx,%ebx
801052bd:	89 df                	mov    %ebx,%edi
801052bf:	89 d1                	mov    %edx,%ecx
801052c1:	fc                   	cld    
801052c2:	f3 ab                	rep stos %eax,%es:(%edi)
801052c4:	89 ca                	mov    %ecx,%edx
801052c6:	89 fb                	mov    %edi,%ebx
801052c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801052ce:	5b                   	pop    %ebx
801052cf:	5f                   	pop    %edi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret    

801052d2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052d2:	55                   	push   %ebp
801052d3:	89 e5                	mov    %esp,%ebp
801052d5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801052d8:	8b 45 08             	mov    0x8(%ebp),%eax
801052db:	83 e0 03             	and    $0x3,%eax
801052de:	85 c0                	test   %eax,%eax
801052e0:	75 49                	jne    8010532b <memset+0x59>
801052e2:	8b 45 10             	mov    0x10(%ebp),%eax
801052e5:	83 e0 03             	and    $0x3,%eax
801052e8:	85 c0                	test   %eax,%eax
801052ea:	75 3f                	jne    8010532b <memset+0x59>
    c &= 0xFF;
801052ec:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801052f3:	8b 45 10             	mov    0x10(%ebp),%eax
801052f6:	c1 e8 02             	shr    $0x2,%eax
801052f9:	89 c2                	mov    %eax,%edx
801052fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801052fe:	c1 e0 18             	shl    $0x18,%eax
80105301:	89 c1                	mov    %eax,%ecx
80105303:	8b 45 0c             	mov    0xc(%ebp),%eax
80105306:	c1 e0 10             	shl    $0x10,%eax
80105309:	09 c1                	or     %eax,%ecx
8010530b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010530e:	c1 e0 08             	shl    $0x8,%eax
80105311:	09 c8                	or     %ecx,%eax
80105313:	0b 45 0c             	or     0xc(%ebp),%eax
80105316:	89 54 24 08          	mov    %edx,0x8(%esp)
8010531a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531e:	8b 45 08             	mov    0x8(%ebp),%eax
80105321:	89 04 24             	mov    %eax,(%esp)
80105324:	e8 84 ff ff ff       	call   801052ad <stosl>
80105329:	eb 19                	jmp    80105344 <memset+0x72>
  } else
    stosb(dst, c, n);
8010532b:	8b 45 10             	mov    0x10(%ebp),%eax
8010532e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105332:	8b 45 0c             	mov    0xc(%ebp),%eax
80105335:	89 44 24 04          	mov    %eax,0x4(%esp)
80105339:	8b 45 08             	mov    0x8(%ebp),%eax
8010533c:	89 04 24             	mov    %eax,(%esp)
8010533f:	e8 44 ff ff ff       	call   80105288 <stosb>
  return dst;
80105344:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105347:	c9                   	leave  
80105348:	c3                   	ret    

80105349 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105349:	55                   	push   %ebp
8010534a:	89 e5                	mov    %esp,%ebp
8010534c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010534f:	8b 45 08             	mov    0x8(%ebp),%eax
80105352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105355:	8b 45 0c             	mov    0xc(%ebp),%eax
80105358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010535b:	eb 30                	jmp    8010538d <memcmp+0x44>
    if(*s1 != *s2)
8010535d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105360:	0f b6 10             	movzbl (%eax),%edx
80105363:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105366:	0f b6 00             	movzbl (%eax),%eax
80105369:	38 c2                	cmp    %al,%dl
8010536b:	74 18                	je     80105385 <memcmp+0x3c>
      return *s1 - *s2;
8010536d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105370:	0f b6 00             	movzbl (%eax),%eax
80105373:	0f b6 d0             	movzbl %al,%edx
80105376:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105379:	0f b6 00             	movzbl (%eax),%eax
8010537c:	0f b6 c0             	movzbl %al,%eax
8010537f:	29 c2                	sub    %eax,%edx
80105381:	89 d0                	mov    %edx,%eax
80105383:	eb 1a                	jmp    8010539f <memcmp+0x56>
    s1++, s2++;
80105385:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105389:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010538d:	8b 45 10             	mov    0x10(%ebp),%eax
80105390:	8d 50 ff             	lea    -0x1(%eax),%edx
80105393:	89 55 10             	mov    %edx,0x10(%ebp)
80105396:	85 c0                	test   %eax,%eax
80105398:	75 c3                	jne    8010535d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010539a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010539f:	c9                   	leave  
801053a0:	c3                   	ret    

801053a1 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053a1:	55                   	push   %ebp
801053a2:	89 e5                	mov    %esp,%ebp
801053a4:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801053a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801053aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801053ad:	8b 45 08             	mov    0x8(%ebp),%eax
801053b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801053b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053b9:	73 3d                	jae    801053f8 <memmove+0x57>
801053bb:	8b 45 10             	mov    0x10(%ebp),%eax
801053be:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053c1:	01 d0                	add    %edx,%eax
801053c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053c6:	76 30                	jbe    801053f8 <memmove+0x57>
    s += n;
801053c8:	8b 45 10             	mov    0x10(%ebp),%eax
801053cb:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801053ce:	8b 45 10             	mov    0x10(%ebp),%eax
801053d1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801053d4:	eb 13                	jmp    801053e9 <memmove+0x48>
      *--d = *--s;
801053d6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801053da:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801053de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e1:	0f b6 10             	movzbl (%eax),%edx
801053e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053e7:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801053e9:	8b 45 10             	mov    0x10(%ebp),%eax
801053ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801053ef:	89 55 10             	mov    %edx,0x10(%ebp)
801053f2:	85 c0                	test   %eax,%eax
801053f4:	75 e0                	jne    801053d6 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053f6:	eb 26                	jmp    8010541e <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801053f8:	eb 17                	jmp    80105411 <memmove+0x70>
      *d++ = *s++;
801053fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053fd:	8d 50 01             	lea    0x1(%eax),%edx
80105400:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105403:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105406:	8d 4a 01             	lea    0x1(%edx),%ecx
80105409:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010540c:	0f b6 12             	movzbl (%edx),%edx
8010540f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105411:	8b 45 10             	mov    0x10(%ebp),%eax
80105414:	8d 50 ff             	lea    -0x1(%eax),%edx
80105417:	89 55 10             	mov    %edx,0x10(%ebp)
8010541a:	85 c0                	test   %eax,%eax
8010541c:	75 dc                	jne    801053fa <memmove+0x59>
      *d++ = *s++;

  return dst;
8010541e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105421:	c9                   	leave  
80105422:	c3                   	ret    

80105423 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105423:	55                   	push   %ebp
80105424:	89 e5                	mov    %esp,%ebp
80105426:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105429:	8b 45 10             	mov    0x10(%ebp),%eax
8010542c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105430:	8b 45 0c             	mov    0xc(%ebp),%eax
80105433:	89 44 24 04          	mov    %eax,0x4(%esp)
80105437:	8b 45 08             	mov    0x8(%ebp),%eax
8010543a:	89 04 24             	mov    %eax,(%esp)
8010543d:	e8 5f ff ff ff       	call   801053a1 <memmove>
}
80105442:	c9                   	leave  
80105443:	c3                   	ret    

80105444 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105447:	eb 0c                	jmp    80105455 <strncmp+0x11>
    n--, p++, q++;
80105449:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010544d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105451:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105455:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105459:	74 1a                	je     80105475 <strncmp+0x31>
8010545b:	8b 45 08             	mov    0x8(%ebp),%eax
8010545e:	0f b6 00             	movzbl (%eax),%eax
80105461:	84 c0                	test   %al,%al
80105463:	74 10                	je     80105475 <strncmp+0x31>
80105465:	8b 45 08             	mov    0x8(%ebp),%eax
80105468:	0f b6 10             	movzbl (%eax),%edx
8010546b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546e:	0f b6 00             	movzbl (%eax),%eax
80105471:	38 c2                	cmp    %al,%dl
80105473:	74 d4                	je     80105449 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105475:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105479:	75 07                	jne    80105482 <strncmp+0x3e>
    return 0;
8010547b:	b8 00 00 00 00       	mov    $0x0,%eax
80105480:	eb 16                	jmp    80105498 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105482:	8b 45 08             	mov    0x8(%ebp),%eax
80105485:	0f b6 00             	movzbl (%eax),%eax
80105488:	0f b6 d0             	movzbl %al,%edx
8010548b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548e:	0f b6 00             	movzbl (%eax),%eax
80105491:	0f b6 c0             	movzbl %al,%eax
80105494:	29 c2                	sub    %eax,%edx
80105496:	89 d0                	mov    %edx,%eax
}
80105498:	5d                   	pop    %ebp
80105499:	c3                   	ret    

8010549a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010549a:	55                   	push   %ebp
8010549b:	89 e5                	mov    %esp,%ebp
8010549d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054a0:	8b 45 08             	mov    0x8(%ebp),%eax
801054a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054a6:	90                   	nop
801054a7:	8b 45 10             	mov    0x10(%ebp),%eax
801054aa:	8d 50 ff             	lea    -0x1(%eax),%edx
801054ad:	89 55 10             	mov    %edx,0x10(%ebp)
801054b0:	85 c0                	test   %eax,%eax
801054b2:	7e 1e                	jle    801054d2 <strncpy+0x38>
801054b4:	8b 45 08             	mov    0x8(%ebp),%eax
801054b7:	8d 50 01             	lea    0x1(%eax),%edx
801054ba:	89 55 08             	mov    %edx,0x8(%ebp)
801054bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801054c0:	8d 4a 01             	lea    0x1(%edx),%ecx
801054c3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801054c6:	0f b6 12             	movzbl (%edx),%edx
801054c9:	88 10                	mov    %dl,(%eax)
801054cb:	0f b6 00             	movzbl (%eax),%eax
801054ce:	84 c0                	test   %al,%al
801054d0:	75 d5                	jne    801054a7 <strncpy+0xd>
    ;
  while(n-- > 0)
801054d2:	eb 0c                	jmp    801054e0 <strncpy+0x46>
    *s++ = 0;
801054d4:	8b 45 08             	mov    0x8(%ebp),%eax
801054d7:	8d 50 01             	lea    0x1(%eax),%edx
801054da:	89 55 08             	mov    %edx,0x8(%ebp)
801054dd:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801054e0:	8b 45 10             	mov    0x10(%ebp),%eax
801054e3:	8d 50 ff             	lea    -0x1(%eax),%edx
801054e6:	89 55 10             	mov    %edx,0x10(%ebp)
801054e9:	85 c0                	test   %eax,%eax
801054eb:	7f e7                	jg     801054d4 <strncpy+0x3a>
    *s++ = 0;
  return os;
801054ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054f0:	c9                   	leave  
801054f1:	c3                   	ret    

801054f2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054f2:	55                   	push   %ebp
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054f8:	8b 45 08             	mov    0x8(%ebp),%eax
801054fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801054fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105502:	7f 05                	jg     80105509 <safestrcpy+0x17>
    return os;
80105504:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105507:	eb 31                	jmp    8010553a <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105509:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010550d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105511:	7e 1e                	jle    80105531 <safestrcpy+0x3f>
80105513:	8b 45 08             	mov    0x8(%ebp),%eax
80105516:	8d 50 01             	lea    0x1(%eax),%edx
80105519:	89 55 08             	mov    %edx,0x8(%ebp)
8010551c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010551f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105522:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105525:	0f b6 12             	movzbl (%edx),%edx
80105528:	88 10                	mov    %dl,(%eax)
8010552a:	0f b6 00             	movzbl (%eax),%eax
8010552d:	84 c0                	test   %al,%al
8010552f:	75 d8                	jne    80105509 <safestrcpy+0x17>
    ;
  *s = 0;
80105531:	8b 45 08             	mov    0x8(%ebp),%eax
80105534:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105537:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010553a:	c9                   	leave  
8010553b:	c3                   	ret    

8010553c <strlen>:

int
strlen(const char *s)
{
8010553c:	55                   	push   %ebp
8010553d:	89 e5                	mov    %esp,%ebp
8010553f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105542:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105549:	eb 04                	jmp    8010554f <strlen+0x13>
8010554b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010554f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105552:	8b 45 08             	mov    0x8(%ebp),%eax
80105555:	01 d0                	add    %edx,%eax
80105557:	0f b6 00             	movzbl (%eax),%eax
8010555a:	84 c0                	test   %al,%al
8010555c:	75 ed                	jne    8010554b <strlen+0xf>
    ;
  return n;
8010555e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105561:	c9                   	leave  
80105562:	c3                   	ret    

80105563 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105563:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105567:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010556b:	55                   	push   %ebp
  pushl %ebx
8010556c:	53                   	push   %ebx
  pushl %esi
8010556d:	56                   	push   %esi
  pushl %edi
8010556e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010556f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105571:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105573:	5f                   	pop    %edi
  popl %esi
80105574:	5e                   	pop    %esi
  popl %ebx
80105575:	5b                   	pop    %ebx
  popl %ebp
80105576:	5d                   	pop    %ebp
  ret
80105577:	c3                   	ret    

80105578 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105578:	55                   	push   %ebp
80105579:	89 e5                	mov    %esp,%ebp
  if(addr >= thread->proc->sz || addr+4 > thread->proc->sz)
8010557b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105581:	8b 40 0c             	mov    0xc(%eax),%eax
80105584:	8b 00                	mov    (%eax),%eax
80105586:	3b 45 08             	cmp    0x8(%ebp),%eax
80105589:	76 15                	jbe    801055a0 <fetchint+0x28>
8010558b:	8b 45 08             	mov    0x8(%ebp),%eax
8010558e:	8d 50 04             	lea    0x4(%eax),%edx
80105591:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105597:	8b 40 0c             	mov    0xc(%eax),%eax
8010559a:	8b 00                	mov    (%eax),%eax
8010559c:	39 c2                	cmp    %eax,%edx
8010559e:	76 07                	jbe    801055a7 <fetchint+0x2f>
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a5:	eb 0f                	jmp    801055b6 <fetchint+0x3e>
  *ip = *(int*)(addr);
801055a7:	8b 45 08             	mov    0x8(%ebp),%eax
801055aa:	8b 10                	mov    (%eax),%edx
801055ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801055af:	89 10                	mov    %edx,(%eax)
  return 0;
801055b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055b6:	5d                   	pop    %ebp
801055b7:	c3                   	ret    

801055b8 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055b8:	55                   	push   %ebp
801055b9:	89 e5                	mov    %esp,%ebp
801055bb:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= thread->proc->sz)
801055be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c4:	8b 40 0c             	mov    0xc(%eax),%eax
801055c7:	8b 00                	mov    (%eax),%eax
801055c9:	3b 45 08             	cmp    0x8(%ebp),%eax
801055cc:	77 07                	ja     801055d5 <fetchstr+0x1d>
    return -1;
801055ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d3:	eb 49                	jmp    8010561e <fetchstr+0x66>
  *pp = (char*)addr;
801055d5:	8b 55 08             	mov    0x8(%ebp),%edx
801055d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801055db:	89 10                	mov    %edx,(%eax)
  ep = (char*)thread->proc->sz;
801055dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e3:	8b 40 0c             	mov    0xc(%eax),%eax
801055e6:	8b 00                	mov    (%eax),%eax
801055e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801055eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ee:	8b 00                	mov    (%eax),%eax
801055f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055f3:	eb 1c                	jmp    80105611 <fetchstr+0x59>
    if(*s == 0)
801055f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055f8:	0f b6 00             	movzbl (%eax),%eax
801055fb:	84 c0                	test   %al,%al
801055fd:	75 0e                	jne    8010560d <fetchstr+0x55>
      return s - *pp;
801055ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105602:	8b 45 0c             	mov    0xc(%ebp),%eax
80105605:	8b 00                	mov    (%eax),%eax
80105607:	29 c2                	sub    %eax,%edx
80105609:	89 d0                	mov    %edx,%eax
8010560b:	eb 11                	jmp    8010561e <fetchstr+0x66>

  if(addr >= thread->proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)thread->proc->sz;
  for(s = *pp; s < ep; s++)
8010560d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105611:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105617:	72 dc                	jb     801055f5 <fetchstr+0x3d>
    if(*s == 0)
      return s - *pp;
  return -1;
80105619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    

80105620 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 08             	sub    $0x8,%esp
  return fetchint(thread->tf->esp + 4 + 4*n, ip);
80105626:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562c:	8b 40 10             	mov    0x10(%eax),%eax
8010562f:	8b 50 44             	mov    0x44(%eax),%edx
80105632:	8b 45 08             	mov    0x8(%ebp),%eax
80105635:	c1 e0 02             	shl    $0x2,%eax
80105638:	01 d0                	add    %edx,%eax
8010563a:	8d 50 04             	lea    0x4(%eax),%edx
8010563d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105640:	89 44 24 04          	mov    %eax,0x4(%esp)
80105644:	89 14 24             	mov    %edx,(%esp)
80105647:	e8 2c ff ff ff       	call   80105578 <fetchint>
}
8010564c:	c9                   	leave  
8010564d:	c3                   	ret    

8010564e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010564e:	55                   	push   %ebp
8010564f:	89 e5                	mov    %esp,%ebp
80105651:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105654:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105657:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565b:	8b 45 08             	mov    0x8(%ebp),%eax
8010565e:	89 04 24             	mov    %eax,(%esp)
80105661:	e8 ba ff ff ff       	call   80105620 <argint>
80105666:	85 c0                	test   %eax,%eax
80105668:	79 07                	jns    80105671 <argptr+0x23>
    return -1;
8010566a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566f:	eb 43                	jmp    801056b4 <argptr+0x66>
  if((uint)i >= thread->proc->sz || (uint)i+size > thread->proc->sz)
80105671:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105674:	89 c2                	mov    %eax,%edx
80105676:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010567c:	8b 40 0c             	mov    0xc(%eax),%eax
8010567f:	8b 00                	mov    (%eax),%eax
80105681:	39 c2                	cmp    %eax,%edx
80105683:	73 19                	jae    8010569e <argptr+0x50>
80105685:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105688:	89 c2                	mov    %eax,%edx
8010568a:	8b 45 10             	mov    0x10(%ebp),%eax
8010568d:	01 c2                	add    %eax,%edx
8010568f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105695:	8b 40 0c             	mov    0xc(%eax),%eax
80105698:	8b 00                	mov    (%eax),%eax
8010569a:	39 c2                	cmp    %eax,%edx
8010569c:	76 07                	jbe    801056a5 <argptr+0x57>
    return -1;
8010569e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a3:	eb 0f                	jmp    801056b4 <argptr+0x66>
  *pp = (char*)i;
801056a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056a8:	89 c2                	mov    %eax,%edx
801056aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ad:	89 10                	mov    %edx,(%eax)
  return 0;
801056af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056b4:	c9                   	leave  
801056b5:	c3                   	ret    

801056b6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056b6:	55                   	push   %ebp
801056b7:	89 e5                	mov    %esp,%ebp
801056b9:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056bc:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c3:	8b 45 08             	mov    0x8(%ebp),%eax
801056c6:	89 04 24             	mov    %eax,(%esp)
801056c9:	e8 52 ff ff ff       	call   80105620 <argint>
801056ce:	85 c0                	test   %eax,%eax
801056d0:	79 07                	jns    801056d9 <argstr+0x23>
    return -1;
801056d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d7:	eb 12                	jmp    801056eb <argstr+0x35>
  return fetchstr(addr, pp);
801056d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801056df:	89 54 24 04          	mov    %edx,0x4(%esp)
801056e3:	89 04 24             	mov    %eax,(%esp)
801056e6:	e8 cd fe ff ff       	call   801055b8 <fetchstr>
}
801056eb:	c9                   	leave  
801056ec:	c3                   	ret    

801056ed <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801056ed:	55                   	push   %ebp
801056ee:	89 e5                	mov    %esp,%ebp
801056f0:	53                   	push   %ebx
801056f1:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = thread->tf->eax;
801056f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056fa:	8b 40 10             	mov    0x10(%eax),%eax
801056fd:	8b 40 1c             	mov    0x1c(%eax),%eax
80105700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105707:	7e 30                	jle    80105739 <syscall+0x4c>
80105709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570c:	83 f8 15             	cmp    $0x15,%eax
8010570f:	77 28                	ja     80105739 <syscall+0x4c>
80105711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105714:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010571b:	85 c0                	test   %eax,%eax
8010571d:	74 1a                	je     80105739 <syscall+0x4c>
    thread->tf->eax = syscalls[num]();
8010571f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105725:	8b 58 10             	mov    0x10(%eax),%ebx
80105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572b:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105732:	ff d0                	call   *%eax
80105734:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105737:	eb 43                	jmp    8010577c <syscall+0x8f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            thread->proc->pid, thread->proc->name, num);
80105739:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573f:	8b 40 0c             	mov    0xc(%eax),%eax
80105742:	8d 48 60             	lea    0x60(%eax),%ecx
80105745:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010574b:	8b 40 0c             	mov    0xc(%eax),%eax

  num = thread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    thread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010574e:	8b 40 0c             	mov    0xc(%eax),%eax
80105751:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105754:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105758:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010575c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105760:	c7 04 24 db 8a 10 80 	movl   $0x80108adb,(%esp)
80105767:	e8 34 ac ff ff       	call   801003a0 <cprintf>
            thread->proc->pid, thread->proc->name, num);
    thread->tf->eax = -1;
8010576c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105772:	8b 40 10             	mov    0x10(%eax),%eax
80105775:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010577c:	83 c4 24             	add    $0x24,%esp
8010577f:	5b                   	pop    %ebx
80105780:	5d                   	pop    %ebp
80105781:	c3                   	ret    

80105782 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105782:	55                   	push   %ebp
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105788:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010578b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578f:	8b 45 08             	mov    0x8(%ebp),%eax
80105792:	89 04 24             	mov    %eax,(%esp)
80105795:	e8 86 fe ff ff       	call   80105620 <argint>
8010579a:	85 c0                	test   %eax,%eax
8010579c:	79 07                	jns    801057a5 <argfd+0x23>
    return -1;
8010579e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a3:	eb 53                	jmp    801057f8 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=thread->proc->ofile[fd]) == 0)
801057a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a8:	85 c0                	test   %eax,%eax
801057aa:	78 24                	js     801057d0 <argfd+0x4e>
801057ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057af:	83 f8 0f             	cmp    $0xf,%eax
801057b2:	7f 1c                	jg     801057d0 <argfd+0x4e>
801057b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ba:	8b 40 0c             	mov    0xc(%eax),%eax
801057bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057c0:	83 c2 04             	add    $0x4,%edx
801057c3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801057c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057ce:	75 07                	jne    801057d7 <argfd+0x55>
    return -1;
801057d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d5:	eb 21                	jmp    801057f8 <argfd+0x76>
  if(pfd)
801057d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057db:	74 08                	je     801057e5 <argfd+0x63>
    *pfd = fd;
801057dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e3:	89 10                	mov    %edx,(%eax)
  if(pf)
801057e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057e9:	74 08                	je     801057f3 <argfd+0x71>
    *pf = f;
801057eb:	8b 45 10             	mov    0x10(%ebp),%eax
801057ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f1:	89 10                	mov    %edx,(%eax)
  return 0;
801057f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057f8:	c9                   	leave  
801057f9:	c3                   	ret    

801057fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801057fa:	55                   	push   %ebp
801057fb:	89 e5                	mov    %esp,%ebp
801057fd:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105800:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105807:	eb 36                	jmp    8010583f <fdalloc+0x45>
    if(thread->proc->ofile[fd] == 0){
80105809:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580f:	8b 40 0c             	mov    0xc(%eax),%eax
80105812:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105815:	83 c2 04             	add    $0x4,%edx
80105818:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	75 1b                	jne    8010583b <fdalloc+0x41>
      thread->proc->ofile[fd] = f;
80105820:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105826:	8b 40 0c             	mov    0xc(%eax),%eax
80105829:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010582c:	8d 4a 04             	lea    0x4(%edx),%ecx
8010582f:	8b 55 08             	mov    0x8(%ebp),%edx
80105832:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
      return fd;
80105836:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105839:	eb 0f                	jmp    8010584a <fdalloc+0x50>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010583b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010583f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105843:	7e c4                	jle    80105809 <fdalloc+0xf>
    if(thread->proc->ofile[fd] == 0){
      thread->proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584a:	c9                   	leave  
8010584b:	c3                   	ret    

8010584c <sys_dup>:

int
sys_dup(void)
{
8010584c:	55                   	push   %ebp
8010584d:	89 e5                	mov    %esp,%ebp
8010584f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105852:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105855:	89 44 24 08          	mov    %eax,0x8(%esp)
80105859:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105860:	00 
80105861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105868:	e8 15 ff ff ff       	call   80105782 <argfd>
8010586d:	85 c0                	test   %eax,%eax
8010586f:	79 07                	jns    80105878 <sys_dup+0x2c>
    return -1;
80105871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105876:	eb 29                	jmp    801058a1 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010587b:	89 04 24             	mov    %eax,(%esp)
8010587e:	e8 77 ff ff ff       	call   801057fa <fdalloc>
80105883:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010588a:	79 07                	jns    80105893 <sys_dup+0x47>
    return -1;
8010588c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105891:	eb 0e                	jmp    801058a1 <sys_dup+0x55>
  filedup(f);
80105893:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105896:	89 04 24             	mov    %eax,(%esp)
80105899:	e8 f7 b6 ff ff       	call   80100f95 <filedup>
  return fd;
8010589e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801058a1:	c9                   	leave  
801058a2:	c3                   	ret    

801058a3 <sys_read>:

int
sys_read(void)
{
801058a3:	55                   	push   %ebp
801058a4:	89 e5                	mov    %esp,%ebp
801058a6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801058b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b7:	00 
801058b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058bf:	e8 be fe ff ff       	call   80105782 <argfd>
801058c4:	85 c0                	test   %eax,%eax
801058c6:	78 35                	js     801058fd <sys_read+0x5a>
801058c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801058cf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058d6:	e8 45 fd ff ff       	call   80105620 <argint>
801058db:	85 c0                	test   %eax,%eax
801058dd:	78 1e                	js     801058fd <sys_read+0x5a>
801058df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e2:	89 44 24 08          	mov    %eax,0x8(%esp)
801058e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058f4:	e8 55 fd ff ff       	call   8010564e <argptr>
801058f9:	85 c0                	test   %eax,%eax
801058fb:	79 07                	jns    80105904 <sys_read+0x61>
    return -1;
801058fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105902:	eb 19                	jmp    8010591d <sys_read+0x7a>
  return fileread(f, p, n);
80105904:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105907:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010590a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105911:	89 54 24 04          	mov    %edx,0x4(%esp)
80105915:	89 04 24             	mov    %eax,(%esp)
80105918:	e8 e5 b7 ff ff       	call   80101102 <fileread>
}
8010591d:	c9                   	leave  
8010591e:	c3                   	ret    

8010591f <sys_write>:

int
sys_write(void)
{
8010591f:	55                   	push   %ebp
80105920:	89 e5                	mov    %esp,%ebp
80105922:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105925:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105928:	89 44 24 08          	mov    %eax,0x8(%esp)
8010592c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105933:	00 
80105934:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010593b:	e8 42 fe ff ff       	call   80105782 <argfd>
80105940:	85 c0                	test   %eax,%eax
80105942:	78 35                	js     80105979 <sys_write+0x5a>
80105944:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105947:	89 44 24 04          	mov    %eax,0x4(%esp)
8010594b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105952:	e8 c9 fc ff ff       	call   80105620 <argint>
80105957:	85 c0                	test   %eax,%eax
80105959:	78 1e                	js     80105979 <sys_write+0x5a>
8010595b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105962:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105965:	89 44 24 04          	mov    %eax,0x4(%esp)
80105969:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105970:	e8 d9 fc ff ff       	call   8010564e <argptr>
80105975:	85 c0                	test   %eax,%eax
80105977:	79 07                	jns    80105980 <sys_write+0x61>
    return -1;
80105979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597e:	eb 19                	jmp    80105999 <sys_write+0x7a>
  return filewrite(f, p, n);
80105980:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105983:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105989:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010598d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105991:	89 04 24             	mov    %eax,(%esp)
80105994:	e8 25 b8 ff ff       	call   801011be <filewrite>
}
80105999:	c9                   	leave  
8010599a:	c3                   	ret    

8010599b <sys_close>:

int
sys_close(void)
{
8010599b:	55                   	push   %ebp
8010599c:	89 e5                	mov    %esp,%ebp
8010599e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801059a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801059a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801059af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059b6:	e8 c7 fd ff ff       	call   80105782 <argfd>
801059bb:	85 c0                	test   %eax,%eax
801059bd:	79 07                	jns    801059c6 <sys_close+0x2b>
    return -1;
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c4:	eb 27                	jmp    801059ed <sys_close+0x52>
  thread->proc->ofile[fd] = 0;
801059c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059cc:	8b 40 0c             	mov    0xc(%eax),%eax
801059cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d2:	83 c2 04             	add    $0x4,%edx
801059d5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801059dc:	00 
  fileclose(f);
801059dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e0:	89 04 24             	mov    %eax,(%esp)
801059e3:	e8 f5 b5 ff ff       	call   80100fdd <fileclose>
  return 0;
801059e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059ed:	c9                   	leave  
801059ee:	c3                   	ret    

801059ef <sys_fstat>:

int
sys_fstat(void)
{
801059ef:	55                   	push   %ebp
801059f0:	89 e5                	mov    %esp,%ebp
801059f2:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801059fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a03:	00 
80105a04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a0b:	e8 72 fd ff ff       	call   80105782 <argfd>
80105a10:	85 c0                	test   %eax,%eax
80105a12:	78 1f                	js     80105a33 <sys_fstat+0x44>
80105a14:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105a1b:	00 
80105a1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a2a:	e8 1f fc ff ff       	call   8010564e <argptr>
80105a2f:	85 c0                	test   %eax,%eax
80105a31:	79 07                	jns    80105a3a <sys_fstat+0x4b>
    return -1;
80105a33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a38:	eb 12                	jmp    80105a4c <sys_fstat+0x5d>
  return filestat(f, st);
80105a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a40:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a44:	89 04 24             	mov    %eax,(%esp)
80105a47:	e8 67 b6 ff ff       	call   801010b3 <filestat>
}
80105a4c:	c9                   	leave  
80105a4d:	c3                   	ret    

80105a4e <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a4e:	55                   	push   %ebp
80105a4f:	89 e5                	mov    %esp,%ebp
80105a51:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a54:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a62:	e8 4f fc ff ff       	call   801056b6 <argstr>
80105a67:	85 c0                	test   %eax,%eax
80105a69:	78 17                	js     80105a82 <sys_link+0x34>
80105a6b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a79:	e8 38 fc ff ff       	call   801056b6 <argstr>
80105a7e:	85 c0                	test   %eax,%eax
80105a80:	79 0a                	jns    80105a8c <sys_link+0x3e>
    return -1;
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a87:	e9 42 01 00 00       	jmp    80105bce <sys_link+0x180>

  begin_op();
80105a8c:	e8 91 d9 ff ff       	call   80103422 <begin_op>
  if((ip = namei(old)) == 0){
80105a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a94:	89 04 24             	mov    %eax,(%esp)
80105a97:	e8 7c c9 ff ff       	call   80102418 <namei>
80105a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aa3:	75 0f                	jne    80105ab4 <sys_link+0x66>
    end_op();
80105aa5:	e8 fc d9 ff ff       	call   801034a6 <end_op>
    return -1;
80105aaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aaf:	e9 1a 01 00 00       	jmp    80105bce <sys_link+0x180>
  }

  ilock(ip);
80105ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab7:	89 04 24             	mov    %eax,(%esp)
80105aba:	e8 ab bd ff ff       	call   8010186a <ilock>
  if(ip->type == T_DIR){
80105abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ac6:	66 83 f8 01          	cmp    $0x1,%ax
80105aca:	75 1a                	jne    80105ae6 <sys_link+0x98>
    iunlockput(ip);
80105acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105acf:	89 04 24             	mov    %eax,(%esp)
80105ad2:	e8 17 c0 ff ff       	call   80101aee <iunlockput>
    end_op();
80105ad7:	e8 ca d9 ff ff       	call   801034a6 <end_op>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae1:	e9 e8 00 00 00       	jmp    80105bce <sys_link+0x180>
  }

  ip->nlink++;
80105ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105aed:	8d 50 01             	lea    0x1(%eax),%edx
80105af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af3:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afa:	89 04 24             	mov    %eax,(%esp)
80105afd:	e8 ac bb ff ff       	call   801016ae <iupdate>
  iunlock(ip);
80105b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b05:	89 04 24             	mov    %eax,(%esp)
80105b08:	e8 ab be ff ff       	call   801019b8 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105b0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b10:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b13:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b17:	89 04 24             	mov    %eax,(%esp)
80105b1a:	e8 1b c9 ff ff       	call   8010243a <nameiparent>
80105b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b26:	75 02                	jne    80105b2a <sys_link+0xdc>
    goto bad;
80105b28:	eb 68                	jmp    80105b92 <sys_link+0x144>
  ilock(dp);
80105b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2d:	89 04 24             	mov    %eax,(%esp)
80105b30:	e8 35 bd ff ff       	call   8010186a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b38:	8b 10                	mov    (%eax),%edx
80105b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3d:	8b 00                	mov    (%eax),%eax
80105b3f:	39 c2                	cmp    %eax,%edx
80105b41:	75 20                	jne    80105b63 <sys_link+0x115>
80105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b46:	8b 40 04             	mov    0x4(%eax),%eax
80105b49:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b4d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b50:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b57:	89 04 24             	mov    %eax,(%esp)
80105b5a:	e8 f6 c5 ff ff       	call   80102155 <dirlink>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	79 0d                	jns    80105b70 <sys_link+0x122>
    iunlockput(dp);
80105b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b66:	89 04 24             	mov    %eax,(%esp)
80105b69:	e8 80 bf ff ff       	call   80101aee <iunlockput>
    goto bad;
80105b6e:	eb 22                	jmp    80105b92 <sys_link+0x144>
  }
  iunlockput(dp);
80105b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b73:	89 04 24             	mov    %eax,(%esp)
80105b76:	e8 73 bf ff ff       	call   80101aee <iunlockput>
  iput(ip);
80105b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7e:	89 04 24             	mov    %eax,(%esp)
80105b81:	e8 97 be ff ff       	call   80101a1d <iput>

  end_op();
80105b86:	e8 1b d9 ff ff       	call   801034a6 <end_op>

  return 0;
80105b8b:	b8 00 00 00 00       	mov    $0x0,%eax
80105b90:	eb 3c                	jmp    80105bce <sys_link+0x180>

bad:
  ilock(ip);
80105b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b95:	89 04 24             	mov    %eax,(%esp)
80105b98:	e8 cd bc ff ff       	call   8010186a <ilock>
  ip->nlink--;
80105b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ba4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb1:	89 04 24             	mov    %eax,(%esp)
80105bb4:	e8 f5 ba ff ff       	call   801016ae <iupdate>
  iunlockput(ip);
80105bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbc:	89 04 24             	mov    %eax,(%esp)
80105bbf:	e8 2a bf ff ff       	call   80101aee <iunlockput>
  end_op();
80105bc4:	e8 dd d8 ff ff       	call   801034a6 <end_op>
  return -1;
80105bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bce:	c9                   	leave  
80105bcf:	c3                   	ret    

80105bd0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bd6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bdd:	eb 4b                	jmp    80105c2a <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105be9:	00 
80105bea:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf8:	89 04 24             	mov    %eax,(%esp)
80105bfb:	e8 77 c1 ff ff       	call   80101d77 <readi>
80105c00:	83 f8 10             	cmp    $0x10,%eax
80105c03:	74 0c                	je     80105c11 <isdirempty+0x41>
      panic("isdirempty: readi");
80105c05:	c7 04 24 f7 8a 10 80 	movl   $0x80108af7,(%esp)
80105c0c:	e8 29 a9 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105c11:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c15:	66 85 c0             	test   %ax,%ax
80105c18:	74 07                	je     80105c21 <isdirempty+0x51>
      return 0;
80105c1a:	b8 00 00 00 00       	mov    $0x0,%eax
80105c1f:	eb 1b                	jmp    80105c3c <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c24:	83 c0 10             	add    $0x10,%eax
80105c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80105c30:	8b 40 18             	mov    0x18(%eax),%eax
80105c33:	39 c2                	cmp    %eax,%edx
80105c35:	72 a8                	jb     80105bdf <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105c37:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c3c:	c9                   	leave  
80105c3d:	c3                   	ret    

80105c3e <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c3e:	55                   	push   %ebp
80105c3f:	89 e5                	mov    %esp,%ebp
80105c41:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c44:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c52:	e8 5f fa ff ff       	call   801056b6 <argstr>
80105c57:	85 c0                	test   %eax,%eax
80105c59:	79 0a                	jns    80105c65 <sys_unlink+0x27>
    return -1;
80105c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c60:	e9 af 01 00 00       	jmp    80105e14 <sys_unlink+0x1d6>

  begin_op();
80105c65:	e8 b8 d7 ff ff       	call   80103422 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c6d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c70:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c74:	89 04 24             	mov    %eax,(%esp)
80105c77:	e8 be c7 ff ff       	call   8010243a <nameiparent>
80105c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c83:	75 0f                	jne    80105c94 <sys_unlink+0x56>
    end_op();
80105c85:	e8 1c d8 ff ff       	call   801034a6 <end_op>
    return -1;
80105c8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8f:	e9 80 01 00 00       	jmp    80105e14 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c97:	89 04 24             	mov    %eax,(%esp)
80105c9a:	e8 cb bb ff ff       	call   8010186a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c9f:	c7 44 24 04 09 8b 10 	movl   $0x80108b09,0x4(%esp)
80105ca6:	80 
80105ca7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105caa:	89 04 24             	mov    %eax,(%esp)
80105cad:	e8 b8 c3 ff ff       	call   8010206a <namecmp>
80105cb2:	85 c0                	test   %eax,%eax
80105cb4:	0f 84 45 01 00 00    	je     80105dff <sys_unlink+0x1c1>
80105cba:	c7 44 24 04 0b 8b 10 	movl   $0x80108b0b,0x4(%esp)
80105cc1:	80 
80105cc2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cc5:	89 04 24             	mov    %eax,(%esp)
80105cc8:	e8 9d c3 ff ff       	call   8010206a <namecmp>
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	0f 84 2a 01 00 00    	je     80105dff <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105cd5:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cdc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce6:	89 04 24             	mov    %eax,(%esp)
80105ce9:	e8 9e c3 ff ff       	call   8010208c <dirlookup>
80105cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cf5:	75 05                	jne    80105cfc <sys_unlink+0xbe>
    goto bad;
80105cf7:	e9 03 01 00 00       	jmp    80105dff <sys_unlink+0x1c1>
  ilock(ip);
80105cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cff:	89 04 24             	mov    %eax,(%esp)
80105d02:	e8 63 bb ff ff       	call   8010186a <ilock>

  if(ip->nlink < 1)
80105d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d0e:	66 85 c0             	test   %ax,%ax
80105d11:	7f 0c                	jg     80105d1f <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105d13:	c7 04 24 0e 8b 10 80 	movl   $0x80108b0e,(%esp)
80105d1a:	e8 1b a8 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d22:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d26:	66 83 f8 01          	cmp    $0x1,%ax
80105d2a:	75 1f                	jne    80105d4b <sys_unlink+0x10d>
80105d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2f:	89 04 24             	mov    %eax,(%esp)
80105d32:	e8 99 fe ff ff       	call   80105bd0 <isdirempty>
80105d37:	85 c0                	test   %eax,%eax
80105d39:	75 10                	jne    80105d4b <sys_unlink+0x10d>
    iunlockput(ip);
80105d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3e:	89 04 24             	mov    %eax,(%esp)
80105d41:	e8 a8 bd ff ff       	call   80101aee <iunlockput>
    goto bad;
80105d46:	e9 b4 00 00 00       	jmp    80105dff <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105d4b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105d52:	00 
80105d53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d5a:	00 
80105d5b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d5e:	89 04 24             	mov    %eax,(%esp)
80105d61:	e8 6c f5 ff ff       	call   801052d2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d66:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d69:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105d70:	00 
80105d71:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d75:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d78:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d7f:	89 04 24             	mov    %eax,(%esp)
80105d82:	e8 54 c1 ff ff       	call   80101edb <writei>
80105d87:	83 f8 10             	cmp    $0x10,%eax
80105d8a:	74 0c                	je     80105d98 <sys_unlink+0x15a>
    panic("unlink: writei");
80105d8c:	c7 04 24 20 8b 10 80 	movl   $0x80108b20,(%esp)
80105d93:	e8 a2 a7 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d9f:	66 83 f8 01          	cmp    $0x1,%ax
80105da3:	75 1c                	jne    80105dc1 <sys_unlink+0x183>
    dp->nlink--;
80105da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dac:	8d 50 ff             	lea    -0x1(%eax),%edx
80105daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db2:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db9:	89 04 24             	mov    %eax,(%esp)
80105dbc:	e8 ed b8 ff ff       	call   801016ae <iupdate>
  }
  iunlockput(dp);
80105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc4:	89 04 24             	mov    %eax,(%esp)
80105dc7:	e8 22 bd ff ff       	call   80101aee <iunlockput>

  ip->nlink--;
80105dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcf:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dd3:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de0:	89 04 24             	mov    %eax,(%esp)
80105de3:	e8 c6 b8 ff ff       	call   801016ae <iupdate>
  iunlockput(ip);
80105de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105deb:	89 04 24             	mov    %eax,(%esp)
80105dee:	e8 fb bc ff ff       	call   80101aee <iunlockput>

  end_op();
80105df3:	e8 ae d6 ff ff       	call   801034a6 <end_op>

  return 0;
80105df8:	b8 00 00 00 00       	mov    $0x0,%eax
80105dfd:	eb 15                	jmp    80105e14 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e02:	89 04 24             	mov    %eax,(%esp)
80105e05:	e8 e4 bc ff ff       	call   80101aee <iunlockput>
  end_op();
80105e0a:	e8 97 d6 ff ff       	call   801034a6 <end_op>
  return -1;
80105e0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e14:	c9                   	leave  
80105e15:	c3                   	ret    

80105e16 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e16:	55                   	push   %ebp
80105e17:	89 e5                	mov    %esp,%ebp
80105e19:	83 ec 48             	sub    $0x48,%esp
80105e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e1f:	8b 55 10             	mov    0x10(%ebp),%edx
80105e22:	8b 45 14             	mov    0x14(%ebp),%eax
80105e25:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e29:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e2d:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e31:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e34:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e38:	8b 45 08             	mov    0x8(%ebp),%eax
80105e3b:	89 04 24             	mov    %eax,(%esp)
80105e3e:	e8 f7 c5 ff ff       	call   8010243a <nameiparent>
80105e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e4a:	75 0a                	jne    80105e56 <create+0x40>
    return 0;
80105e4c:	b8 00 00 00 00       	mov    $0x0,%eax
80105e51:	e9 7e 01 00 00       	jmp    80105fd4 <create+0x1be>
  ilock(dp);
80105e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e59:	89 04 24             	mov    %eax,(%esp)
80105e5c:	e8 09 ba ff ff       	call   8010186a <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e61:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e64:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e68:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e72:	89 04 24             	mov    %eax,(%esp)
80105e75:	e8 12 c2 ff ff       	call   8010208c <dirlookup>
80105e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e81:	74 47                	je     80105eca <create+0xb4>
    iunlockput(dp);
80105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e86:	89 04 24             	mov    %eax,(%esp)
80105e89:	e8 60 bc ff ff       	call   80101aee <iunlockput>
    ilock(ip);
80105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e91:	89 04 24             	mov    %eax,(%esp)
80105e94:	e8 d1 b9 ff ff       	call   8010186a <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e99:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e9e:	75 15                	jne    80105eb5 <create+0x9f>
80105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ea7:	66 83 f8 02          	cmp    $0x2,%ax
80105eab:	75 08                	jne    80105eb5 <create+0x9f>
      return ip;
80105ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb0:	e9 1f 01 00 00       	jmp    80105fd4 <create+0x1be>
    iunlockput(ip);
80105eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb8:	89 04 24             	mov    %eax,(%esp)
80105ebb:	e8 2e bc ff ff       	call   80101aee <iunlockput>
    return 0;
80105ec0:	b8 00 00 00 00       	mov    $0x0,%eax
80105ec5:	e9 0a 01 00 00       	jmp    80105fd4 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105eca:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed1:	8b 00                	mov    (%eax),%eax
80105ed3:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ed7:	89 04 24             	mov    %eax,(%esp)
80105eda:	e8 f0 b6 ff ff       	call   801015cf <ialloc>
80105edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ee6:	75 0c                	jne    80105ef4 <create+0xde>
    panic("create: ialloc");
80105ee8:	c7 04 24 2f 8b 10 80 	movl   $0x80108b2f,(%esp)
80105eef:	e8 46 a6 ff ff       	call   8010053a <panic>

  ilock(ip);
80105ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef7:	89 04 24             	mov    %eax,(%esp)
80105efa:	e8 6b b9 ff ff       	call   8010186a <ilock>
  ip->major = major;
80105eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f02:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f06:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0d:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f11:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f18:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f21:	89 04 24             	mov    %eax,(%esp)
80105f24:	e8 85 b7 ff ff       	call   801016ae <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105f29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f2e:	75 6a                	jne    80105f9a <create+0x184>
    dp->nlink++;  // for ".."
80105f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f33:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f37:	8d 50 01             	lea    0x1(%eax),%edx
80105f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3d:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f44:	89 04 24             	mov    %eax,(%esp)
80105f47:	e8 62 b7 ff ff       	call   801016ae <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4f:	8b 40 04             	mov    0x4(%eax),%eax
80105f52:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f56:	c7 44 24 04 09 8b 10 	movl   $0x80108b09,0x4(%esp)
80105f5d:	80 
80105f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f61:	89 04 24             	mov    %eax,(%esp)
80105f64:	e8 ec c1 ff ff       	call   80102155 <dirlink>
80105f69:	85 c0                	test   %eax,%eax
80105f6b:	78 21                	js     80105f8e <create+0x178>
80105f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f70:	8b 40 04             	mov    0x4(%eax),%eax
80105f73:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f77:	c7 44 24 04 0b 8b 10 	movl   $0x80108b0b,0x4(%esp)
80105f7e:	80 
80105f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f82:	89 04 24             	mov    %eax,(%esp)
80105f85:	e8 cb c1 ff ff       	call   80102155 <dirlink>
80105f8a:	85 c0                	test   %eax,%eax
80105f8c:	79 0c                	jns    80105f9a <create+0x184>
      panic("create dots");
80105f8e:	c7 04 24 3e 8b 10 80 	movl   $0x80108b3e,(%esp)
80105f95:	e8 a0 a5 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9d:	8b 40 04             	mov    0x4(%eax),%eax
80105fa0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fa4:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fae:	89 04 24             	mov    %eax,(%esp)
80105fb1:	e8 9f c1 ff ff       	call   80102155 <dirlink>
80105fb6:	85 c0                	test   %eax,%eax
80105fb8:	79 0c                	jns    80105fc6 <create+0x1b0>
    panic("create: dirlink");
80105fba:	c7 04 24 4a 8b 10 80 	movl   $0x80108b4a,(%esp)
80105fc1:	e8 74 a5 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc9:	89 04 24             	mov    %eax,(%esp)
80105fcc:	e8 1d bb ff ff       	call   80101aee <iunlockput>

  return ip;
80105fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fd4:	c9                   	leave  
80105fd5:	c3                   	ret    

80105fd6 <sys_open>:

int
sys_open(void)
{
80105fd6:	55                   	push   %ebp
80105fd7:	89 e5                	mov    %esp,%ebp
80105fd9:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fdc:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fea:	e8 c7 f6 ff ff       	call   801056b6 <argstr>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	78 17                	js     8010600a <sys_open+0x34>
80105ff3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ffa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106001:	e8 1a f6 ff ff       	call   80105620 <argint>
80106006:	85 c0                	test   %eax,%eax
80106008:	79 0a                	jns    80106014 <sys_open+0x3e>
    return -1;
8010600a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600f:	e9 5c 01 00 00       	jmp    80106170 <sys_open+0x19a>

  begin_op();
80106014:	e8 09 d4 ff ff       	call   80103422 <begin_op>

  if(omode & O_CREATE){
80106019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010601c:	25 00 02 00 00       	and    $0x200,%eax
80106021:	85 c0                	test   %eax,%eax
80106023:	74 3b                	je     80106060 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106025:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106028:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010602f:	00 
80106030:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106037:	00 
80106038:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010603f:	00 
80106040:	89 04 24             	mov    %eax,(%esp)
80106043:	e8 ce fd ff ff       	call   80105e16 <create>
80106048:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010604b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010604f:	75 6b                	jne    801060bc <sys_open+0xe6>
      end_op();
80106051:	e8 50 d4 ff ff       	call   801034a6 <end_op>
      return -1;
80106056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605b:	e9 10 01 00 00       	jmp    80106170 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106060:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106063:	89 04 24             	mov    %eax,(%esp)
80106066:	e8 ad c3 ff ff       	call   80102418 <namei>
8010606b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106072:	75 0f                	jne    80106083 <sys_open+0xad>
      end_op();
80106074:	e8 2d d4 ff ff       	call   801034a6 <end_op>
      return -1;
80106079:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607e:	e9 ed 00 00 00       	jmp    80106170 <sys_open+0x19a>
    }
    ilock(ip);
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	89 04 24             	mov    %eax,(%esp)
80106089:	e8 dc b7 ff ff       	call   8010186a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010608e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106091:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106095:	66 83 f8 01          	cmp    $0x1,%ax
80106099:	75 21                	jne    801060bc <sys_open+0xe6>
8010609b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010609e:	85 c0                	test   %eax,%eax
801060a0:	74 1a                	je     801060bc <sys_open+0xe6>
      iunlockput(ip);
801060a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a5:	89 04 24             	mov    %eax,(%esp)
801060a8:	e8 41 ba ff ff       	call   80101aee <iunlockput>
      end_op();
801060ad:	e8 f4 d3 ff ff       	call   801034a6 <end_op>
      return -1;
801060b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b7:	e9 b4 00 00 00       	jmp    80106170 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060bc:	e8 74 ae ff ff       	call   80100f35 <filealloc>
801060c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c8:	74 14                	je     801060de <sys_open+0x108>
801060ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cd:	89 04 24             	mov    %eax,(%esp)
801060d0:	e8 25 f7 ff ff       	call   801057fa <fdalloc>
801060d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060dc:	79 28                	jns    80106106 <sys_open+0x130>
    if(f)
801060de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060e2:	74 0b                	je     801060ef <sys_open+0x119>
      fileclose(f);
801060e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e7:	89 04 24             	mov    %eax,(%esp)
801060ea:	e8 ee ae ff ff       	call   80100fdd <fileclose>
    iunlockput(ip);
801060ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f2:	89 04 24             	mov    %eax,(%esp)
801060f5:	e8 f4 b9 ff ff       	call   80101aee <iunlockput>
    end_op();
801060fa:	e8 a7 d3 ff ff       	call   801034a6 <end_op>
    return -1;
801060ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106104:	eb 6a                	jmp    80106170 <sys_open+0x19a>
  }
  iunlock(ip);
80106106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106109:	89 04 24             	mov    %eax,(%esp)
8010610c:	e8 a7 b8 ff ff       	call   801019b8 <iunlock>
  end_op();
80106111:	e8 90 d3 ff ff       	call   801034a6 <end_op>

  f->type = FD_INODE;
80106116:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106119:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010611f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106122:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106125:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106135:	83 e0 01             	and    $0x1,%eax
80106138:	85 c0                	test   %eax,%eax
8010613a:	0f 94 c0             	sete   %al
8010613d:	89 c2                	mov    %eax,%edx
8010613f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106142:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106148:	83 e0 01             	and    $0x1,%eax
8010614b:	85 c0                	test   %eax,%eax
8010614d:	75 0a                	jne    80106159 <sys_open+0x183>
8010614f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106152:	83 e0 02             	and    $0x2,%eax
80106155:	85 c0                	test   %eax,%eax
80106157:	74 07                	je     80106160 <sys_open+0x18a>
80106159:	b8 01 00 00 00       	mov    $0x1,%eax
8010615e:	eb 05                	jmp    80106165 <sys_open+0x18f>
80106160:	b8 00 00 00 00       	mov    $0x0,%eax
80106165:	89 c2                	mov    %eax,%edx
80106167:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010616d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106170:	c9                   	leave  
80106171:	c3                   	ret    

80106172 <sys_mkdir>:

int
sys_mkdir(void)
{
80106172:	55                   	push   %ebp
80106173:	89 e5                	mov    %esp,%ebp
80106175:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106178:	e8 a5 d2 ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010617d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106180:	89 44 24 04          	mov    %eax,0x4(%esp)
80106184:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010618b:	e8 26 f5 ff ff       	call   801056b6 <argstr>
80106190:	85 c0                	test   %eax,%eax
80106192:	78 2c                	js     801061c0 <sys_mkdir+0x4e>
80106194:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106197:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010619e:	00 
8010619f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801061a6:	00 
801061a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801061ae:	00 
801061af:	89 04 24             	mov    %eax,(%esp)
801061b2:	e8 5f fc ff ff       	call   80105e16 <create>
801061b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061be:	75 0c                	jne    801061cc <sys_mkdir+0x5a>
    end_op();
801061c0:	e8 e1 d2 ff ff       	call   801034a6 <end_op>
    return -1;
801061c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ca:	eb 15                	jmp    801061e1 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801061cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cf:	89 04 24             	mov    %eax,(%esp)
801061d2:	e8 17 b9 ff ff       	call   80101aee <iunlockput>
  end_op();
801061d7:	e8 ca d2 ff ff       	call   801034a6 <end_op>
  return 0;
801061dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061e1:	c9                   	leave  
801061e2:	c3                   	ret    

801061e3 <sys_mknod>:

int
sys_mknod(void)
{
801061e3:	55                   	push   %ebp
801061e4:	89 e5                	mov    %esp,%ebp
801061e6:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801061e9:	e8 34 d2 ff ff       	call   80103422 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801061ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061fc:	e8 b5 f4 ff ff       	call   801056b6 <argstr>
80106201:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106208:	78 5e                	js     80106268 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010620a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010620d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106211:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106218:	e8 03 f4 ff ff       	call   80105620 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010621d:	85 c0                	test   %eax,%eax
8010621f:	78 47                	js     80106268 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106221:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106224:	89 44 24 04          	mov    %eax,0x4(%esp)
80106228:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010622f:	e8 ec f3 ff ff       	call   80105620 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106234:	85 c0                	test   %eax,%eax
80106236:	78 30                	js     80106268 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010623b:	0f bf c8             	movswl %ax,%ecx
8010623e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106241:	0f bf d0             	movswl %ax,%edx
80106244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106247:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010624b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010624f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106256:	00 
80106257:	89 04 24             	mov    %eax,(%esp)
8010625a:	e8 b7 fb ff ff       	call   80105e16 <create>
8010625f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106266:	75 0c                	jne    80106274 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106268:	e8 39 d2 ff ff       	call   801034a6 <end_op>
    return -1;
8010626d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106272:	eb 15                	jmp    80106289 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106277:	89 04 24             	mov    %eax,(%esp)
8010627a:	e8 6f b8 ff ff       	call   80101aee <iunlockput>
  end_op();
8010627f:	e8 22 d2 ff ff       	call   801034a6 <end_op>
  return 0;
80106284:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106289:	c9                   	leave  
8010628a:	c3                   	ret    

8010628b <sys_chdir>:

int
sys_chdir(void)
{
8010628b:	55                   	push   %ebp
8010628c:	89 e5                	mov    %esp,%ebp
8010628e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106291:	e8 8c d1 ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106296:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a4:	e8 0d f4 ff ff       	call   801056b6 <argstr>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	78 14                	js     801062c1 <sys_chdir+0x36>
801062ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b0:	89 04 24             	mov    %eax,(%esp)
801062b3:	e8 60 c1 ff ff       	call   80102418 <namei>
801062b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062bf:	75 0c                	jne    801062cd <sys_chdir+0x42>
    end_op();
801062c1:	e8 e0 d1 ff ff       	call   801034a6 <end_op>
    return -1;
801062c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cb:	eb 67                	jmp    80106334 <sys_chdir+0xa9>
  }
  ilock(ip);
801062cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d0:	89 04 24             	mov    %eax,(%esp)
801062d3:	e8 92 b5 ff ff       	call   8010186a <ilock>
  if(ip->type != T_DIR){
801062d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062db:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062df:	66 83 f8 01          	cmp    $0x1,%ax
801062e3:	74 17                	je     801062fc <sys_chdir+0x71>
    iunlockput(ip);
801062e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e8:	89 04 24             	mov    %eax,(%esp)
801062eb:	e8 fe b7 ff ff       	call   80101aee <iunlockput>
    end_op();
801062f0:	e8 b1 d1 ff ff       	call   801034a6 <end_op>
    return -1;
801062f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fa:	eb 38                	jmp    80106334 <sys_chdir+0xa9>
  }
  iunlock(ip);
801062fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ff:	89 04 24             	mov    %eax,(%esp)
80106302:	e8 b1 b6 ff ff       	call   801019b8 <iunlock>
  iput(thread->proc->cwd);
80106307:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010630d:	8b 40 0c             	mov    0xc(%eax),%eax
80106310:	8b 40 5c             	mov    0x5c(%eax),%eax
80106313:	89 04 24             	mov    %eax,(%esp)
80106316:	e8 02 b7 ff ff       	call   80101a1d <iput>
  end_op();
8010631b:	e8 86 d1 ff ff       	call   801034a6 <end_op>
  thread->proc->cwd = ip;
80106320:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106326:	8b 40 0c             	mov    0xc(%eax),%eax
80106329:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010632c:	89 50 5c             	mov    %edx,0x5c(%eax)
  return 0;
8010632f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106334:	c9                   	leave  
80106335:	c3                   	ret    

80106336 <sys_exec>:

int
sys_exec(void)
{
80106336:	55                   	push   %ebp
80106337:	89 e5                	mov    %esp,%ebp
80106339:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010633f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106342:	89 44 24 04          	mov    %eax,0x4(%esp)
80106346:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010634d:	e8 64 f3 ff ff       	call   801056b6 <argstr>
80106352:	85 c0                	test   %eax,%eax
80106354:	78 1a                	js     80106370 <sys_exec+0x3a>
80106356:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010635c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106360:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106367:	e8 b4 f2 ff ff       	call   80105620 <argint>
8010636c:	85 c0                	test   %eax,%eax
8010636e:	79 0a                	jns    8010637a <sys_exec+0x44>
    return -1;
80106370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106375:	e9 c8 00 00 00       	jmp    80106442 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
8010637a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106381:	00 
80106382:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106389:	00 
8010638a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106390:	89 04 24             	mov    %eax,(%esp)
80106393:	e8 3a ef ff ff       	call   801052d2 <memset>
  for(i=0;; i++){
80106398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010639f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a2:	83 f8 1f             	cmp    $0x1f,%eax
801063a5:	76 0a                	jbe    801063b1 <sys_exec+0x7b>
      return -1;
801063a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ac:	e9 91 00 00 00       	jmp    80106442 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b4:	c1 e0 02             	shl    $0x2,%eax
801063b7:	89 c2                	mov    %eax,%edx
801063b9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063bf:	01 c2                	add    %eax,%edx
801063c1:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801063cb:	89 14 24             	mov    %edx,(%esp)
801063ce:	e8 a5 f1 ff ff       	call   80105578 <fetchint>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	79 07                	jns    801063de <sys_exec+0xa8>
      return -1;
801063d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063dc:	eb 64                	jmp    80106442 <sys_exec+0x10c>
    if(uarg == 0){
801063de:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063e4:	85 c0                	test   %eax,%eax
801063e6:	75 26                	jne    8010640e <sys_exec+0xd8>
      argv[i] = 0;
801063e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063eb:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063f2:	00 00 00 00 
      break;
801063f6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fa:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106400:	89 54 24 04          	mov    %edx,0x4(%esp)
80106404:	89 04 24             	mov    %eax,(%esp)
80106407:	e8 e6 a6 ff ff       	call   80100af2 <exec>
8010640c:	eb 34                	jmp    80106442 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010640e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106414:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106417:	c1 e2 02             	shl    $0x2,%edx
8010641a:	01 c2                	add    %eax,%edx
8010641c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106422:	89 54 24 04          	mov    %edx,0x4(%esp)
80106426:	89 04 24             	mov    %eax,(%esp)
80106429:	e8 8a f1 ff ff       	call   801055b8 <fetchstr>
8010642e:	85 c0                	test   %eax,%eax
80106430:	79 07                	jns    80106439 <sys_exec+0x103>
      return -1;
80106432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106437:	eb 09                	jmp    80106442 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106439:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010643d:	e9 5d ff ff ff       	jmp    8010639f <sys_exec+0x69>
  return exec(path, argv);
}
80106442:	c9                   	leave  
80106443:	c3                   	ret    

80106444 <sys_pipe>:

int
sys_pipe(void)
{
80106444:	55                   	push   %ebp
80106445:	89 e5                	mov    %esp,%ebp
80106447:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010644a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106451:	00 
80106452:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106455:	89 44 24 04          	mov    %eax,0x4(%esp)
80106459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106460:	e8 e9 f1 ff ff       	call   8010564e <argptr>
80106465:	85 c0                	test   %eax,%eax
80106467:	79 0a                	jns    80106473 <sys_pipe+0x2f>
    return -1;
80106469:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646e:	e9 a1 00 00 00       	jmp    80106514 <sys_pipe+0xd0>
  if(pipealloc(&rf, &wf) < 0)
80106473:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106476:	89 44 24 04          	mov    %eax,0x4(%esp)
8010647a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010647d:	89 04 24             	mov    %eax,(%esp)
80106480:	e8 ae da ff ff       	call   80103f33 <pipealloc>
80106485:	85 c0                	test   %eax,%eax
80106487:	79 0a                	jns    80106493 <sys_pipe+0x4f>
    return -1;
80106489:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648e:	e9 81 00 00 00       	jmp    80106514 <sys_pipe+0xd0>
  fd0 = -1;
80106493:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010649a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010649d:	89 04 24             	mov    %eax,(%esp)
801064a0:	e8 55 f3 ff ff       	call   801057fa <fdalloc>
801064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ac:	78 14                	js     801064c2 <sys_pipe+0x7e>
801064ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064b1:	89 04 24             	mov    %eax,(%esp)
801064b4:	e8 41 f3 ff ff       	call   801057fa <fdalloc>
801064b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064c0:	79 3a                	jns    801064fc <sys_pipe+0xb8>
    if(fd0 >= 0)
801064c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064c6:	78 17                	js     801064df <sys_pipe+0x9b>
      thread->proc->ofile[fd0] = 0;
801064c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ce:	8b 40 0c             	mov    0xc(%eax),%eax
801064d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064d4:	83 c2 04             	add    $0x4,%edx
801064d7:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801064de:	00 
    fileclose(rf);
801064df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064e2:	89 04 24             	mov    %eax,(%esp)
801064e5:	e8 f3 aa ff ff       	call   80100fdd <fileclose>
    fileclose(wf);
801064ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ed:	89 04 24             	mov    %eax,(%esp)
801064f0:	e8 e8 aa ff ff       	call   80100fdd <fileclose>
    return -1;
801064f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fa:	eb 18                	jmp    80106514 <sys_pipe+0xd0>
  }
  fd[0] = fd0;
801064fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106502:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106507:	8d 50 04             	lea    0x4(%eax),%edx
8010650a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650d:	89 02                	mov    %eax,(%edx)
  return 0;
8010650f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106514:	c9                   	leave  
80106515:	c3                   	ret    

80106516 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106516:	55                   	push   %ebp
80106517:	89 e5                	mov    %esp,%ebp
80106519:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010651c:	e8 46 e1 ff ff       	call   80104667 <fork>
}
80106521:	c9                   	leave  
80106522:	c3                   	ret    

80106523 <sys_exit>:

int
sys_exit(void)
{
80106523:	55                   	push   %ebp
80106524:	89 e5                	mov    %esp,%ebp
80106526:	83 ec 08             	sub    $0x8,%esp
  exit();
80106529:	e8 72 e3 ff ff       	call   801048a0 <exit>
  return 0;  // not reached
8010652e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106533:	c9                   	leave  
80106534:	c3                   	ret    

80106535 <sys_wait>:

int
sys_wait(void)
{
80106535:	55                   	push   %ebp
80106536:	89 e5                	mov    %esp,%ebp
80106538:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010653b:	e8 d6 e4 ff ff       	call   80104a16 <wait>
}
80106540:	c9                   	leave  
80106541:	c3                   	ret    

80106542 <sys_kill>:

int
sys_kill(void)
{
80106542:	55                   	push   %ebp
80106543:	89 e5                	mov    %esp,%ebp
80106545:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106548:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010654b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010654f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106556:	e8 c5 f0 ff ff       	call   80105620 <argint>
8010655b:	85 c0                	test   %eax,%eax
8010655d:	79 07                	jns    80106566 <sys_kill+0x24>
    return -1;
8010655f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106564:	eb 0b                	jmp    80106571 <sys_kill+0x2f>
  return kill(pid);
80106566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106569:	89 04 24             	mov    %eax,(%esp)
8010656c:	e8 22 e9 ff ff       	call   80104e93 <kill>
}
80106571:	c9                   	leave  
80106572:	c3                   	ret    

80106573 <sys_getpid>:

int
sys_getpid(void)
{
80106573:	55                   	push   %ebp
80106574:	89 e5                	mov    %esp,%ebp
  return thread->proc->pid;
80106576:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010657c:	8b 40 0c             	mov    0xc(%eax),%eax
8010657f:	8b 40 0c             	mov    0xc(%eax),%eax
}
80106582:	5d                   	pop    %ebp
80106583:	c3                   	ret    

80106584 <sys_sbrk>:

int
sys_sbrk(void)
{
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010658a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010658d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106591:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106598:	e8 83 f0 ff ff       	call   80105620 <argint>
8010659d:	85 c0                	test   %eax,%eax
8010659f:	79 07                	jns    801065a8 <sys_sbrk+0x24>
    return -1;
801065a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a6:	eb 27                	jmp    801065cf <sys_sbrk+0x4b>
  addr = thread->proc->sz;
801065a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065ae:	8b 40 0c             	mov    0xc(%eax),%eax
801065b1:	8b 00                	mov    (%eax),%eax
801065b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801065b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b9:	89 04 24             	mov    %eax,(%esp)
801065bc:	e8 01 e0 ff ff       	call   801045c2 <growproc>
801065c1:	85 c0                	test   %eax,%eax
801065c3:	79 07                	jns    801065cc <sys_sbrk+0x48>
    return -1;
801065c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ca:	eb 03                	jmp    801065cf <sys_sbrk+0x4b>
  return addr;
801065cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065cf:	c9                   	leave  
801065d0:	c3                   	ret    

801065d1 <sys_sleep>:

int
sys_sleep(void)
{
801065d1:	55                   	push   %ebp
801065d2:	89 e5                	mov    %esp,%ebp
801065d4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801065d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065da:	89 44 24 04          	mov    %eax,0x4(%esp)
801065de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065e5:	e8 36 f0 ff ff       	call   80105620 <argint>
801065ea:	85 c0                	test   %eax,%eax
801065ec:	79 07                	jns    801065f5 <sys_sleep+0x24>
    return -1;
801065ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f3:	eb 6f                	jmp    80106664 <sys_sleep+0x93>
  acquire(&tickslock);
801065f5:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
801065fc:	e8 7d ea ff ff       	call   8010507e <acquire>
  ticks0 = ticks;
80106601:	a1 e0 be 11 80       	mov    0x8011bee0,%eax
80106606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106609:	eb 37                	jmp    80106642 <sys_sleep+0x71>
    if(thread->proc->killed){
8010660b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106611:	8b 40 0c             	mov    0xc(%eax),%eax
80106614:	8b 40 18             	mov    0x18(%eax),%eax
80106617:	85 c0                	test   %eax,%eax
80106619:	74 13                	je     8010662e <sys_sleep+0x5d>
      release(&tickslock);
8010661b:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
80106622:	e8 b9 ea ff ff       	call   801050e0 <release>
      return -1;
80106627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010662c:	eb 36                	jmp    80106664 <sys_sleep+0x93>
    }
    sleep(&ticks, &tickslock);
8010662e:	c7 44 24 04 a0 b6 11 	movl   $0x8011b6a0,0x4(%esp)
80106635:	80 
80106636:	c7 04 24 e0 be 11 80 	movl   $0x8011bee0,(%esp)
8010663d:	e8 2e e7 ff ff       	call   80104d70 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106642:	a1 e0 be 11 80       	mov    0x8011bee0,%eax
80106647:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010664a:	89 c2                	mov    %eax,%edx
8010664c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010664f:	39 c2                	cmp    %eax,%edx
80106651:	72 b8                	jb     8010660b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106653:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
8010665a:	e8 81 ea ff ff       	call   801050e0 <release>
  return 0;
8010665f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106664:	c9                   	leave  
80106665:	c3                   	ret    

80106666 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106666:	55                   	push   %ebp
80106667:	89 e5                	mov    %esp,%ebp
80106669:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010666c:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
80106673:	e8 06 ea ff ff       	call   8010507e <acquire>
  xticks = ticks;
80106678:	a1 e0 be 11 80       	mov    0x8011bee0,%eax
8010667d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106680:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
80106687:	e8 54 ea ff ff       	call   801050e0 <release>
  return xticks;
8010668c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010668f:	c9                   	leave  
80106690:	c3                   	ret    

80106691 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106691:	55                   	push   %ebp
80106692:	89 e5                	mov    %esp,%ebp
80106694:	83 ec 08             	sub    $0x8,%esp
80106697:	8b 55 08             	mov    0x8(%ebp),%edx
8010669a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010669d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801066a1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066a4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801066a8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801066ac:	ee                   	out    %al,(%dx)
}
801066ad:	c9                   	leave  
801066ae:	c3                   	ret    

801066af <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801066af:	55                   	push   %ebp
801066b0:	89 e5                	mov    %esp,%ebp
801066b2:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801066b5:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801066bc:	00 
801066bd:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801066c4:	e8 c8 ff ff ff       	call   80106691 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801066c9:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801066d0:	00 
801066d1:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801066d8:	e8 b4 ff ff ff       	call   80106691 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801066dd:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801066e4:	00 
801066e5:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801066ec:	e8 a0 ff ff ff       	call   80106691 <outb>
  picenable(IRQ_TIMER);
801066f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066f8:	e8 c9 d6 ff ff       	call   80103dc6 <picenable>
}
801066fd:	c9                   	leave  
801066fe:	c3                   	ret    

801066ff <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066ff:	1e                   	push   %ds
  pushl %es
80106700:	06                   	push   %es
  pushl %fs
80106701:	0f a0                	push   %fs
  pushl %gs
80106703:	0f a8                	push   %gs
  pushal
80106705:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106706:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010670a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010670c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010670e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106712:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106714:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106716:	54                   	push   %esp
  call trap
80106717:	e8 d8 01 00 00       	call   801068f4 <trap>
  addl $4, %esp
8010671c:	83 c4 04             	add    $0x4,%esp

8010671f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010671f:	61                   	popa   
  popl %gs
80106720:	0f a9                	pop    %gs
  popl %fs
80106722:	0f a1                	pop    %fs
  popl %es
80106724:	07                   	pop    %es
  popl %ds
80106725:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106726:	83 c4 08             	add    $0x8,%esp
  iret
80106729:	cf                   	iret   

8010672a <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010672a:	55                   	push   %ebp
8010672b:	89 e5                	mov    %esp,%ebp
8010672d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106730:	8b 45 0c             	mov    0xc(%ebp),%eax
80106733:	83 e8 01             	sub    $0x1,%eax
80106736:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010673a:	8b 45 08             	mov    0x8(%ebp),%eax
8010673d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106741:	8b 45 08             	mov    0x8(%ebp),%eax
80106744:	c1 e8 10             	shr    $0x10,%eax
80106747:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010674b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010674e:	0f 01 18             	lidtl  (%eax)
}
80106751:	c9                   	leave  
80106752:	c3                   	ret    

80106753 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106753:	55                   	push   %ebp
80106754:	89 e5                	mov    %esp,%ebp
80106756:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106759:	0f 20 d0             	mov    %cr2,%eax
8010675c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010675f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106762:	c9                   	leave  
80106763:	c3                   	ret    

80106764 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010676a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106771:	e9 c3 00 00 00       	jmp    80106839 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106779:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106780:	89 c2                	mov    %eax,%edx
80106782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106785:	66 89 14 c5 e0 b6 11 	mov    %dx,-0x7fee4920(,%eax,8)
8010678c:	80 
8010678d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106790:	66 c7 04 c5 e2 b6 11 	movw   $0x8,-0x7fee491e(,%eax,8)
80106797:	80 08 00 
8010679a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679d:	0f b6 14 c5 e4 b6 11 	movzbl -0x7fee491c(,%eax,8),%edx
801067a4:	80 
801067a5:	83 e2 e0             	and    $0xffffffe0,%edx
801067a8:	88 14 c5 e4 b6 11 80 	mov    %dl,-0x7fee491c(,%eax,8)
801067af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b2:	0f b6 14 c5 e4 b6 11 	movzbl -0x7fee491c(,%eax,8),%edx
801067b9:	80 
801067ba:	83 e2 1f             	and    $0x1f,%edx
801067bd:	88 14 c5 e4 b6 11 80 	mov    %dl,-0x7fee491c(,%eax,8)
801067c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c7:	0f b6 14 c5 e5 b6 11 	movzbl -0x7fee491b(,%eax,8),%edx
801067ce:	80 
801067cf:	83 e2 f0             	and    $0xfffffff0,%edx
801067d2:	83 ca 0e             	or     $0xe,%edx
801067d5:	88 14 c5 e5 b6 11 80 	mov    %dl,-0x7fee491b(,%eax,8)
801067dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067df:	0f b6 14 c5 e5 b6 11 	movzbl -0x7fee491b(,%eax,8),%edx
801067e6:	80 
801067e7:	83 e2 ef             	and    $0xffffffef,%edx
801067ea:	88 14 c5 e5 b6 11 80 	mov    %dl,-0x7fee491b(,%eax,8)
801067f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f4:	0f b6 14 c5 e5 b6 11 	movzbl -0x7fee491b(,%eax,8),%edx
801067fb:	80 
801067fc:	83 e2 9f             	and    $0xffffff9f,%edx
801067ff:	88 14 c5 e5 b6 11 80 	mov    %dl,-0x7fee491b(,%eax,8)
80106806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106809:	0f b6 14 c5 e5 b6 11 	movzbl -0x7fee491b(,%eax,8),%edx
80106810:	80 
80106811:	83 ca 80             	or     $0xffffff80,%edx
80106814:	88 14 c5 e5 b6 11 80 	mov    %dl,-0x7fee491b(,%eax,8)
8010681b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681e:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106825:	c1 e8 10             	shr    $0x10,%eax
80106828:	89 c2                	mov    %eax,%edx
8010682a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010682d:	66 89 14 c5 e6 b6 11 	mov    %dx,-0x7fee491a(,%eax,8)
80106834:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106839:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106840:	0f 8e 30 ff ff ff    	jle    80106776 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106846:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010684b:	66 a3 e0 b8 11 80    	mov    %ax,0x8011b8e0
80106851:	66 c7 05 e2 b8 11 80 	movw   $0x8,0x8011b8e2
80106858:	08 00 
8010685a:	0f b6 05 e4 b8 11 80 	movzbl 0x8011b8e4,%eax
80106861:	83 e0 e0             	and    $0xffffffe0,%eax
80106864:	a2 e4 b8 11 80       	mov    %al,0x8011b8e4
80106869:	0f b6 05 e4 b8 11 80 	movzbl 0x8011b8e4,%eax
80106870:	83 e0 1f             	and    $0x1f,%eax
80106873:	a2 e4 b8 11 80       	mov    %al,0x8011b8e4
80106878:	0f b6 05 e5 b8 11 80 	movzbl 0x8011b8e5,%eax
8010687f:	83 c8 0f             	or     $0xf,%eax
80106882:	a2 e5 b8 11 80       	mov    %al,0x8011b8e5
80106887:	0f b6 05 e5 b8 11 80 	movzbl 0x8011b8e5,%eax
8010688e:	83 e0 ef             	and    $0xffffffef,%eax
80106891:	a2 e5 b8 11 80       	mov    %al,0x8011b8e5
80106896:	0f b6 05 e5 b8 11 80 	movzbl 0x8011b8e5,%eax
8010689d:	83 c8 60             	or     $0x60,%eax
801068a0:	a2 e5 b8 11 80       	mov    %al,0x8011b8e5
801068a5:	0f b6 05 e5 b8 11 80 	movzbl 0x8011b8e5,%eax
801068ac:	83 c8 80             	or     $0xffffff80,%eax
801068af:	a2 e5 b8 11 80       	mov    %al,0x8011b8e5
801068b4:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801068b9:	c1 e8 10             	shr    $0x10,%eax
801068bc:	66 a3 e6 b8 11 80    	mov    %ax,0x8011b8e6
  
  initlock(&tickslock, "time");
801068c2:	c7 44 24 04 5c 8b 10 	movl   $0x80108b5c,0x4(%esp)
801068c9:	80 
801068ca:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
801068d1:	e8 87 e7 ff ff       	call   8010505d <initlock>
}
801068d6:	c9                   	leave  
801068d7:	c3                   	ret    

801068d8 <idtinit>:

void
idtinit(void)
{
801068d8:	55                   	push   %ebp
801068d9:	89 e5                	mov    %esp,%ebp
801068db:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801068de:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801068e5:	00 
801068e6:	c7 04 24 e0 b6 11 80 	movl   $0x8011b6e0,(%esp)
801068ed:	e8 38 fe ff ff       	call   8010672a <lidt>
}
801068f2:	c9                   	leave  
801068f3:	c3                   	ret    

801068f4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068f4:	55                   	push   %ebp
801068f5:	89 e5                	mov    %esp,%ebp
801068f7:	57                   	push   %edi
801068f8:	56                   	push   %esi
801068f9:	53                   	push   %ebx
801068fa:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801068fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106900:	8b 40 30             	mov    0x30(%eax),%eax
80106903:	83 f8 40             	cmp    $0x40,%eax
80106906:	75 45                	jne    8010694d <trap+0x59>
    if(thread->proc->killed)
80106908:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010690e:	8b 40 0c             	mov    0xc(%eax),%eax
80106911:	8b 40 18             	mov    0x18(%eax),%eax
80106914:	85 c0                	test   %eax,%eax
80106916:	74 05                	je     8010691d <trap+0x29>
      exit();
80106918:	e8 83 df ff ff       	call   801048a0 <exit>
    thread->tf = tf;
8010691d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106923:	8b 55 08             	mov    0x8(%ebp),%edx
80106926:	89 50 10             	mov    %edx,0x10(%eax)
    syscall();
80106929:	e8 bf ed ff ff       	call   801056ed <syscall>
    if(thread->proc->killed)
8010692e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106934:	8b 40 0c             	mov    0xc(%eax),%eax
80106937:	8b 40 18             	mov    0x18(%eax),%eax
8010693a:	85 c0                	test   %eax,%eax
8010693c:	74 0a                	je     80106948 <trap+0x54>
      exit();
8010693e:	e8 5d df ff ff       	call   801048a0 <exit>
    return;
80106943:	e9 7d 02 00 00       	jmp    80106bc5 <trap+0x2d1>
80106948:	e9 78 02 00 00       	jmp    80106bc5 <trap+0x2d1>
  }

  switch(tf->trapno){
8010694d:	8b 45 08             	mov    0x8(%ebp),%eax
80106950:	8b 40 30             	mov    0x30(%eax),%eax
80106953:	83 e8 20             	sub    $0x20,%eax
80106956:	83 f8 1f             	cmp    $0x1f,%eax
80106959:	0f 87 bc 00 00 00    	ja     80106a1b <trap+0x127>
8010695f:	8b 04 85 14 8c 10 80 	mov    -0x7fef73ec(,%eax,4),%eax
80106966:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106968:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010696e:	0f b6 00             	movzbl (%eax),%eax
80106971:	84 c0                	test   %al,%al
80106973:	75 31                	jne    801069a6 <trap+0xb2>
      acquire(&tickslock);
80106975:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
8010697c:	e8 fd e6 ff ff       	call   8010507e <acquire>
      ticks++;
80106981:	a1 e0 be 11 80       	mov    0x8011bee0,%eax
80106986:	83 c0 01             	add    $0x1,%eax
80106989:	a3 e0 be 11 80       	mov    %eax,0x8011bee0
      wakeup(&ticks);
8010698e:	c7 04 24 e0 be 11 80 	movl   $0x8011bee0,(%esp)
80106995:	e8 ce e4 ff ff       	call   80104e68 <wakeup>
      release(&tickslock);
8010699a:	c7 04 24 a0 b6 11 80 	movl   $0x8011b6a0,(%esp)
801069a1:	e8 3a e7 ff ff       	call   801050e0 <release>
    }
    lapiceoi();
801069a6:	e8 37 c5 ff ff       	call   80102ee2 <lapiceoi>
    break;
801069ab:	e9 64 01 00 00       	jmp    80106b14 <trap+0x220>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801069b0:	e8 3b bd ff ff       	call   801026f0 <ideintr>
    lapiceoi();
801069b5:	e8 28 c5 ff ff       	call   80102ee2 <lapiceoi>
    break;
801069ba:	e9 55 01 00 00       	jmp    80106b14 <trap+0x220>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801069bf:	e8 ed c2 ff ff       	call   80102cb1 <kbdintr>
    lapiceoi();
801069c4:	e8 19 c5 ff ff       	call   80102ee2 <lapiceoi>
    break;
801069c9:	e9 46 01 00 00       	jmp    80106b14 <trap+0x220>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801069ce:	e8 e7 03 00 00       	call   80106dba <uartintr>
    lapiceoi();
801069d3:	e8 0a c5 ff ff       	call   80102ee2 <lapiceoi>
    break;
801069d8:	e9 37 01 00 00       	jmp    80106b14 <trap+0x220>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069dd:	8b 45 08             	mov    0x8(%ebp),%eax
801069e0:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801069e3:	8b 45 08             	mov    0x8(%ebp),%eax
801069e6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069ea:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801069ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069f3:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069f6:	0f b6 c0             	movzbl %al,%eax
801069f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801069fd:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a01:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a05:	c7 04 24 64 8b 10 80 	movl   $0x80108b64,(%esp)
80106a0c:	e8 8f 99 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106a11:	e8 cc c4 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106a16:	e9 f9 00 00 00       	jmp    80106b14 <trap+0x220>
   
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
80106a1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a21:	85 c0                	test   %eax,%eax
80106a23:	74 11                	je     80106a36 <trap+0x142>
80106a25:	8b 45 08             	mov    0x8(%ebp),%eax
80106a28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a2c:	0f b7 c0             	movzwl %ax,%eax
80106a2f:	83 e0 03             	and    $0x3,%eax
80106a32:	85 c0                	test   %eax,%eax
80106a34:	75 60                	jne    80106a96 <trap+0x1a2>
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
80106a36:	8b 45 08             	mov    0x8(%ebp),%eax
80106a39:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a3d:	0f b7 c0             	movzwl %ax,%eax
80106a40:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a44:	c7 04 24 88 8b 10 80 	movl   $0x80108b88,(%esp)
80106a4b:	e8 50 99 ff ff       	call   801003a0 <cprintf>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a50:	e8 fe fc ff ff       	call   80106753 <rcr2>
80106a55:	8b 55 08             	mov    0x8(%ebp),%edx
80106a58:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106a5b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a62:	0f b6 12             	movzbl (%edx),%edx
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a65:	0f b6 ca             	movzbl %dl,%ecx
80106a68:	8b 55 08             	mov    0x8(%ebp),%edx
80106a6b:	8b 52 30             	mov    0x30(%edx),%edx
80106a6e:	89 44 24 10          	mov    %eax,0x10(%esp)
80106a72:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106a76:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a7a:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a7e:	c7 04 24 98 8b 10 80 	movl   $0x80108b98,(%esp)
80106a85:	e8 16 99 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106a8a:	c7 04 24 ca 8b 10 80 	movl   $0x80108bca,(%esp)
80106a91:	e8 a4 9a ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a96:	e8 b8 fc ff ff       	call   80106753 <rcr2>
80106a9b:	89 c2                	mov    %eax,%edx
80106a9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa0:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106aa3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106aa9:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106aac:	0f b6 f0             	movzbl %al,%esi
80106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab2:	8b 58 34             	mov    0x34(%eax),%ebx
80106ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab8:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106abb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac1:	8b 40 0c             	mov    0xc(%eax),%eax
80106ac4:	83 c0 60             	add    $0x60,%eax
80106ac7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ad0:	8b 40 0c             	mov    0xc(%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ad3:	8b 40 0c             	mov    0xc(%eax),%eax
80106ad6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106ada:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106ade:	89 74 24 14          	mov    %esi,0x14(%esp)
80106ae2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106ae6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106aea:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106aed:	89 74 24 08          	mov    %esi,0x8(%esp)
80106af1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106af5:	c7 04 24 d0 8b 10 80 	movl   $0x80108bd0,(%esp)
80106afc:	e8 9f 98 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    thread->proc->killed = 1;
80106b01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b07:	8b 40 0c             	mov    0xc(%eax),%eax
80106b0a:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
80106b11:	eb 01                	jmp    80106b14 <trap+0x220>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106b13:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(thread && thread->proc  && thread->proc->killed && (tf->cs&3) == DPL_USER)
80106b14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b1a:	85 c0                	test   %eax,%eax
80106b1c:	74 34                	je     80106b52 <trap+0x25e>
80106b1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b24:	8b 40 0c             	mov    0xc(%eax),%eax
80106b27:	85 c0                	test   %eax,%eax
80106b29:	74 27                	je     80106b52 <trap+0x25e>
80106b2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b31:	8b 40 0c             	mov    0xc(%eax),%eax
80106b34:	8b 40 18             	mov    0x18(%eax),%eax
80106b37:	85 c0                	test   %eax,%eax
80106b39:	74 17                	je     80106b52 <trap+0x25e>
80106b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b42:	0f b7 c0             	movzwl %ax,%eax
80106b45:	83 e0 03             	and    $0x3,%eax
80106b48:	83 f8 03             	cmp    $0x3,%eax
80106b4b:	75 05                	jne    80106b52 <trap+0x25e>
    exit();
80106b4d:	e8 4e dd ff ff       	call   801048a0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if(thread && thread->proc && thread->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106b52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b58:	85 c0                	test   %eax,%eax
80106b5a:	74 2b                	je     80106b87 <trap+0x293>
80106b5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b62:	8b 40 0c             	mov    0xc(%eax),%eax
80106b65:	85 c0                	test   %eax,%eax
80106b67:	74 1e                	je     80106b87 <trap+0x293>
80106b69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b6f:	8b 40 04             	mov    0x4(%eax),%eax
80106b72:	83 f8 04             	cmp    $0x4,%eax
80106b75:	75 10                	jne    80106b87 <trap+0x293>
80106b77:	8b 45 08             	mov    0x8(%ebp),%eax
80106b7a:	8b 40 30             	mov    0x30(%eax),%eax
80106b7d:	83 f8 20             	cmp    $0x20,%eax
80106b80:	75 05                	jne    80106b87 <trap+0x293>

    yield();
80106b82:	e8 8b e1 ff ff       	call   80104d12 <yield>

  }

  // Check if the process has been killed since we yielded
  if(thread && thread->proc && thread->proc->killed && (tf->cs&3) == DPL_USER)
80106b87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b8d:	85 c0                	test   %eax,%eax
80106b8f:	74 34                	je     80106bc5 <trap+0x2d1>
80106b91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b97:	8b 40 0c             	mov    0xc(%eax),%eax
80106b9a:	85 c0                	test   %eax,%eax
80106b9c:	74 27                	je     80106bc5 <trap+0x2d1>
80106b9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba4:	8b 40 0c             	mov    0xc(%eax),%eax
80106ba7:	8b 40 18             	mov    0x18(%eax),%eax
80106baa:	85 c0                	test   %eax,%eax
80106bac:	74 17                	je     80106bc5 <trap+0x2d1>
80106bae:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106bb5:	0f b7 c0             	movzwl %ax,%eax
80106bb8:	83 e0 03             	and    $0x3,%eax
80106bbb:	83 f8 03             	cmp    $0x3,%eax
80106bbe:	75 05                	jne    80106bc5 <trap+0x2d1>
    exit();
80106bc0:	e8 db dc ff ff       	call   801048a0 <exit>
}
80106bc5:	83 c4 3c             	add    $0x3c,%esp
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret    

80106bcd <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106bcd:	55                   	push   %ebp
80106bce:	89 e5                	mov    %esp,%ebp
80106bd0:	83 ec 14             	sub    $0x14,%esp
80106bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bda:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106bde:	89 c2                	mov    %eax,%edx
80106be0:	ec                   	in     (%dx),%al
80106be1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106be4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106be8:	c9                   	leave  
80106be9:	c3                   	ret    

80106bea <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106bea:	55                   	push   %ebp
80106beb:	89 e5                	mov    %esp,%ebp
80106bed:	83 ec 08             	sub    $0x8,%esp
80106bf0:	8b 55 08             	mov    0x8(%ebp),%edx
80106bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106bfa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106bfd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c01:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c05:	ee                   	out    %al,(%dx)
}
80106c06:	c9                   	leave  
80106c07:	c3                   	ret    

80106c08 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c08:	55                   	push   %ebp
80106c09:	89 e5                	mov    %esp,%ebp
80106c0b:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106c0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c15:	00 
80106c16:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106c1d:	e8 c8 ff ff ff       	call   80106bea <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106c22:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106c29:	00 
80106c2a:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106c31:	e8 b4 ff ff ff       	call   80106bea <outb>
  outb(COM1+0, 115200/9600);
80106c36:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106c3d:	00 
80106c3e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c45:	e8 a0 ff ff ff       	call   80106bea <outb>
  outb(COM1+1, 0);
80106c4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c51:	00 
80106c52:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106c59:	e8 8c ff ff ff       	call   80106bea <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106c5e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106c65:	00 
80106c66:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106c6d:	e8 78 ff ff ff       	call   80106bea <outb>
  outb(COM1+4, 0);
80106c72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c79:	00 
80106c7a:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106c81:	e8 64 ff ff ff       	call   80106bea <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106c86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106c8d:	00 
80106c8e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106c95:	e8 50 ff ff ff       	call   80106bea <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106c9a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ca1:	e8 27 ff ff ff       	call   80106bcd <inb>
80106ca6:	3c ff                	cmp    $0xff,%al
80106ca8:	75 02                	jne    80106cac <uartinit+0xa4>
    return;
80106caa:	eb 6a                	jmp    80106d16 <uartinit+0x10e>
  uart = 1;
80106cac:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106cb3:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106cb6:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106cbd:	e8 0b ff ff ff       	call   80106bcd <inb>
  inb(COM1+0);
80106cc2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cc9:	e8 ff fe ff ff       	call   80106bcd <inb>
  picenable(IRQ_COM1);
80106cce:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106cd5:	e8 ec d0 ff ff       	call   80103dc6 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106cda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ce1:	00 
80106ce2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ce9:	e8 81 bc ff ff       	call   8010296f <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106cee:	c7 45 f4 94 8c 10 80 	movl   $0x80108c94,-0xc(%ebp)
80106cf5:	eb 15                	jmp    80106d0c <uartinit+0x104>
    uartputc(*p);
80106cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfa:	0f b6 00             	movzbl (%eax),%eax
80106cfd:	0f be c0             	movsbl %al,%eax
80106d00:	89 04 24             	mov    %eax,(%esp)
80106d03:	e8 10 00 00 00       	call   80106d18 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d0f:	0f b6 00             	movzbl (%eax),%eax
80106d12:	84 c0                	test   %al,%al
80106d14:	75 e1                	jne    80106cf7 <uartinit+0xef>
    uartputc(*p);
}
80106d16:	c9                   	leave  
80106d17:	c3                   	ret    

80106d18 <uartputc>:

void
uartputc(int c)
{
80106d18:	55                   	push   %ebp
80106d19:	89 e5                	mov    %esp,%ebp
80106d1b:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106d1e:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106d23:	85 c0                	test   %eax,%eax
80106d25:	75 02                	jne    80106d29 <uartputc+0x11>
    return;
80106d27:	eb 4b                	jmp    80106d74 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d30:	eb 10                	jmp    80106d42 <uartputc+0x2a>
    microdelay(10);
80106d32:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106d39:	e8 c9 c1 ff ff       	call   80102f07 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d42:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106d46:	7f 16                	jg     80106d5e <uartputc+0x46>
80106d48:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106d4f:	e8 79 fe ff ff       	call   80106bcd <inb>
80106d54:	0f b6 c0             	movzbl %al,%eax
80106d57:	83 e0 20             	and    $0x20,%eax
80106d5a:	85 c0                	test   %eax,%eax
80106d5c:	74 d4                	je     80106d32 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d61:	0f b6 c0             	movzbl %al,%eax
80106d64:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d68:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106d6f:	e8 76 fe ff ff       	call   80106bea <outb>
}
80106d74:	c9                   	leave  
80106d75:	c3                   	ret    

80106d76 <uartgetc>:

static int
uartgetc(void)
{
80106d76:	55                   	push   %ebp
80106d77:	89 e5                	mov    %esp,%ebp
80106d79:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106d7c:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106d81:	85 c0                	test   %eax,%eax
80106d83:	75 07                	jne    80106d8c <uartgetc+0x16>
    return -1;
80106d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d8a:	eb 2c                	jmp    80106db8 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106d8c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106d93:	e8 35 fe ff ff       	call   80106bcd <inb>
80106d98:	0f b6 c0             	movzbl %al,%eax
80106d9b:	83 e0 01             	and    $0x1,%eax
80106d9e:	85 c0                	test   %eax,%eax
80106da0:	75 07                	jne    80106da9 <uartgetc+0x33>
    return -1;
80106da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106da7:	eb 0f                	jmp    80106db8 <uartgetc+0x42>
  return inb(COM1+0);
80106da9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106db0:	e8 18 fe ff ff       	call   80106bcd <inb>
80106db5:	0f b6 c0             	movzbl %al,%eax
}
80106db8:	c9                   	leave  
80106db9:	c3                   	ret    

80106dba <uartintr>:

void
uartintr(void)
{
80106dba:	55                   	push   %ebp
80106dbb:	89 e5                	mov    %esp,%ebp
80106dbd:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106dc0:	c7 04 24 76 6d 10 80 	movl   $0x80106d76,(%esp)
80106dc7:	e8 e1 99 ff ff       	call   801007ad <consoleintr>
}
80106dcc:	c9                   	leave  
80106dcd:	c3                   	ret    

80106dce <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $0
80106dd0:	6a 00                	push   $0x0
  jmp alltraps
80106dd2:	e9 28 f9 ff ff       	jmp    801066ff <alltraps>

80106dd7 <vector1>:
.globl vector1
vector1:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $1
80106dd9:	6a 01                	push   $0x1
  jmp alltraps
80106ddb:	e9 1f f9 ff ff       	jmp    801066ff <alltraps>

80106de0 <vector2>:
.globl vector2
vector2:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $2
80106de2:	6a 02                	push   $0x2
  jmp alltraps
80106de4:	e9 16 f9 ff ff       	jmp    801066ff <alltraps>

80106de9 <vector3>:
.globl vector3
vector3:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $3
80106deb:	6a 03                	push   $0x3
  jmp alltraps
80106ded:	e9 0d f9 ff ff       	jmp    801066ff <alltraps>

80106df2 <vector4>:
.globl vector4
vector4:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $4
80106df4:	6a 04                	push   $0x4
  jmp alltraps
80106df6:	e9 04 f9 ff ff       	jmp    801066ff <alltraps>

80106dfb <vector5>:
.globl vector5
vector5:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $5
80106dfd:	6a 05                	push   $0x5
  jmp alltraps
80106dff:	e9 fb f8 ff ff       	jmp    801066ff <alltraps>

80106e04 <vector6>:
.globl vector6
vector6:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $6
80106e06:	6a 06                	push   $0x6
  jmp alltraps
80106e08:	e9 f2 f8 ff ff       	jmp    801066ff <alltraps>

80106e0d <vector7>:
.globl vector7
vector7:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $7
80106e0f:	6a 07                	push   $0x7
  jmp alltraps
80106e11:	e9 e9 f8 ff ff       	jmp    801066ff <alltraps>

80106e16 <vector8>:
.globl vector8
vector8:
  pushl $8
80106e16:	6a 08                	push   $0x8
  jmp alltraps
80106e18:	e9 e2 f8 ff ff       	jmp    801066ff <alltraps>

80106e1d <vector9>:
.globl vector9
vector9:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $9
80106e1f:	6a 09                	push   $0x9
  jmp alltraps
80106e21:	e9 d9 f8 ff ff       	jmp    801066ff <alltraps>

80106e26 <vector10>:
.globl vector10
vector10:
  pushl $10
80106e26:	6a 0a                	push   $0xa
  jmp alltraps
80106e28:	e9 d2 f8 ff ff       	jmp    801066ff <alltraps>

80106e2d <vector11>:
.globl vector11
vector11:
  pushl $11
80106e2d:	6a 0b                	push   $0xb
  jmp alltraps
80106e2f:	e9 cb f8 ff ff       	jmp    801066ff <alltraps>

80106e34 <vector12>:
.globl vector12
vector12:
  pushl $12
80106e34:	6a 0c                	push   $0xc
  jmp alltraps
80106e36:	e9 c4 f8 ff ff       	jmp    801066ff <alltraps>

80106e3b <vector13>:
.globl vector13
vector13:
  pushl $13
80106e3b:	6a 0d                	push   $0xd
  jmp alltraps
80106e3d:	e9 bd f8 ff ff       	jmp    801066ff <alltraps>

80106e42 <vector14>:
.globl vector14
vector14:
  pushl $14
80106e42:	6a 0e                	push   $0xe
  jmp alltraps
80106e44:	e9 b6 f8 ff ff       	jmp    801066ff <alltraps>

80106e49 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $15
80106e4b:	6a 0f                	push   $0xf
  jmp alltraps
80106e4d:	e9 ad f8 ff ff       	jmp    801066ff <alltraps>

80106e52 <vector16>:
.globl vector16
vector16:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $16
80106e54:	6a 10                	push   $0x10
  jmp alltraps
80106e56:	e9 a4 f8 ff ff       	jmp    801066ff <alltraps>

80106e5b <vector17>:
.globl vector17
vector17:
  pushl $17
80106e5b:	6a 11                	push   $0x11
  jmp alltraps
80106e5d:	e9 9d f8 ff ff       	jmp    801066ff <alltraps>

80106e62 <vector18>:
.globl vector18
vector18:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $18
80106e64:	6a 12                	push   $0x12
  jmp alltraps
80106e66:	e9 94 f8 ff ff       	jmp    801066ff <alltraps>

80106e6b <vector19>:
.globl vector19
vector19:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $19
80106e6d:	6a 13                	push   $0x13
  jmp alltraps
80106e6f:	e9 8b f8 ff ff       	jmp    801066ff <alltraps>

80106e74 <vector20>:
.globl vector20
vector20:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $20
80106e76:	6a 14                	push   $0x14
  jmp alltraps
80106e78:	e9 82 f8 ff ff       	jmp    801066ff <alltraps>

80106e7d <vector21>:
.globl vector21
vector21:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $21
80106e7f:	6a 15                	push   $0x15
  jmp alltraps
80106e81:	e9 79 f8 ff ff       	jmp    801066ff <alltraps>

80106e86 <vector22>:
.globl vector22
vector22:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $22
80106e88:	6a 16                	push   $0x16
  jmp alltraps
80106e8a:	e9 70 f8 ff ff       	jmp    801066ff <alltraps>

80106e8f <vector23>:
.globl vector23
vector23:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $23
80106e91:	6a 17                	push   $0x17
  jmp alltraps
80106e93:	e9 67 f8 ff ff       	jmp    801066ff <alltraps>

80106e98 <vector24>:
.globl vector24
vector24:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $24
80106e9a:	6a 18                	push   $0x18
  jmp alltraps
80106e9c:	e9 5e f8 ff ff       	jmp    801066ff <alltraps>

80106ea1 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $25
80106ea3:	6a 19                	push   $0x19
  jmp alltraps
80106ea5:	e9 55 f8 ff ff       	jmp    801066ff <alltraps>

80106eaa <vector26>:
.globl vector26
vector26:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $26
80106eac:	6a 1a                	push   $0x1a
  jmp alltraps
80106eae:	e9 4c f8 ff ff       	jmp    801066ff <alltraps>

80106eb3 <vector27>:
.globl vector27
vector27:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $27
80106eb5:	6a 1b                	push   $0x1b
  jmp alltraps
80106eb7:	e9 43 f8 ff ff       	jmp    801066ff <alltraps>

80106ebc <vector28>:
.globl vector28
vector28:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $28
80106ebe:	6a 1c                	push   $0x1c
  jmp alltraps
80106ec0:	e9 3a f8 ff ff       	jmp    801066ff <alltraps>

80106ec5 <vector29>:
.globl vector29
vector29:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $29
80106ec7:	6a 1d                	push   $0x1d
  jmp alltraps
80106ec9:	e9 31 f8 ff ff       	jmp    801066ff <alltraps>

80106ece <vector30>:
.globl vector30
vector30:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $30
80106ed0:	6a 1e                	push   $0x1e
  jmp alltraps
80106ed2:	e9 28 f8 ff ff       	jmp    801066ff <alltraps>

80106ed7 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $31
80106ed9:	6a 1f                	push   $0x1f
  jmp alltraps
80106edb:	e9 1f f8 ff ff       	jmp    801066ff <alltraps>

80106ee0 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $32
80106ee2:	6a 20                	push   $0x20
  jmp alltraps
80106ee4:	e9 16 f8 ff ff       	jmp    801066ff <alltraps>

80106ee9 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $33
80106eeb:	6a 21                	push   $0x21
  jmp alltraps
80106eed:	e9 0d f8 ff ff       	jmp    801066ff <alltraps>

80106ef2 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $34
80106ef4:	6a 22                	push   $0x22
  jmp alltraps
80106ef6:	e9 04 f8 ff ff       	jmp    801066ff <alltraps>

80106efb <vector35>:
.globl vector35
vector35:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $35
80106efd:	6a 23                	push   $0x23
  jmp alltraps
80106eff:	e9 fb f7 ff ff       	jmp    801066ff <alltraps>

80106f04 <vector36>:
.globl vector36
vector36:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $36
80106f06:	6a 24                	push   $0x24
  jmp alltraps
80106f08:	e9 f2 f7 ff ff       	jmp    801066ff <alltraps>

80106f0d <vector37>:
.globl vector37
vector37:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $37
80106f0f:	6a 25                	push   $0x25
  jmp alltraps
80106f11:	e9 e9 f7 ff ff       	jmp    801066ff <alltraps>

80106f16 <vector38>:
.globl vector38
vector38:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $38
80106f18:	6a 26                	push   $0x26
  jmp alltraps
80106f1a:	e9 e0 f7 ff ff       	jmp    801066ff <alltraps>

80106f1f <vector39>:
.globl vector39
vector39:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $39
80106f21:	6a 27                	push   $0x27
  jmp alltraps
80106f23:	e9 d7 f7 ff ff       	jmp    801066ff <alltraps>

80106f28 <vector40>:
.globl vector40
vector40:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $40
80106f2a:	6a 28                	push   $0x28
  jmp alltraps
80106f2c:	e9 ce f7 ff ff       	jmp    801066ff <alltraps>

80106f31 <vector41>:
.globl vector41
vector41:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $41
80106f33:	6a 29                	push   $0x29
  jmp alltraps
80106f35:	e9 c5 f7 ff ff       	jmp    801066ff <alltraps>

80106f3a <vector42>:
.globl vector42
vector42:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $42
80106f3c:	6a 2a                	push   $0x2a
  jmp alltraps
80106f3e:	e9 bc f7 ff ff       	jmp    801066ff <alltraps>

80106f43 <vector43>:
.globl vector43
vector43:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $43
80106f45:	6a 2b                	push   $0x2b
  jmp alltraps
80106f47:	e9 b3 f7 ff ff       	jmp    801066ff <alltraps>

80106f4c <vector44>:
.globl vector44
vector44:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $44
80106f4e:	6a 2c                	push   $0x2c
  jmp alltraps
80106f50:	e9 aa f7 ff ff       	jmp    801066ff <alltraps>

80106f55 <vector45>:
.globl vector45
vector45:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $45
80106f57:	6a 2d                	push   $0x2d
  jmp alltraps
80106f59:	e9 a1 f7 ff ff       	jmp    801066ff <alltraps>

80106f5e <vector46>:
.globl vector46
vector46:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $46
80106f60:	6a 2e                	push   $0x2e
  jmp alltraps
80106f62:	e9 98 f7 ff ff       	jmp    801066ff <alltraps>

80106f67 <vector47>:
.globl vector47
vector47:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $47
80106f69:	6a 2f                	push   $0x2f
  jmp alltraps
80106f6b:	e9 8f f7 ff ff       	jmp    801066ff <alltraps>

80106f70 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $48
80106f72:	6a 30                	push   $0x30
  jmp alltraps
80106f74:	e9 86 f7 ff ff       	jmp    801066ff <alltraps>

80106f79 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $49
80106f7b:	6a 31                	push   $0x31
  jmp alltraps
80106f7d:	e9 7d f7 ff ff       	jmp    801066ff <alltraps>

80106f82 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $50
80106f84:	6a 32                	push   $0x32
  jmp alltraps
80106f86:	e9 74 f7 ff ff       	jmp    801066ff <alltraps>

80106f8b <vector51>:
.globl vector51
vector51:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $51
80106f8d:	6a 33                	push   $0x33
  jmp alltraps
80106f8f:	e9 6b f7 ff ff       	jmp    801066ff <alltraps>

80106f94 <vector52>:
.globl vector52
vector52:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $52
80106f96:	6a 34                	push   $0x34
  jmp alltraps
80106f98:	e9 62 f7 ff ff       	jmp    801066ff <alltraps>

80106f9d <vector53>:
.globl vector53
vector53:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $53
80106f9f:	6a 35                	push   $0x35
  jmp alltraps
80106fa1:	e9 59 f7 ff ff       	jmp    801066ff <alltraps>

80106fa6 <vector54>:
.globl vector54
vector54:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $54
80106fa8:	6a 36                	push   $0x36
  jmp alltraps
80106faa:	e9 50 f7 ff ff       	jmp    801066ff <alltraps>

80106faf <vector55>:
.globl vector55
vector55:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $55
80106fb1:	6a 37                	push   $0x37
  jmp alltraps
80106fb3:	e9 47 f7 ff ff       	jmp    801066ff <alltraps>

80106fb8 <vector56>:
.globl vector56
vector56:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $56
80106fba:	6a 38                	push   $0x38
  jmp alltraps
80106fbc:	e9 3e f7 ff ff       	jmp    801066ff <alltraps>

80106fc1 <vector57>:
.globl vector57
vector57:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $57
80106fc3:	6a 39                	push   $0x39
  jmp alltraps
80106fc5:	e9 35 f7 ff ff       	jmp    801066ff <alltraps>

80106fca <vector58>:
.globl vector58
vector58:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $58
80106fcc:	6a 3a                	push   $0x3a
  jmp alltraps
80106fce:	e9 2c f7 ff ff       	jmp    801066ff <alltraps>

80106fd3 <vector59>:
.globl vector59
vector59:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $59
80106fd5:	6a 3b                	push   $0x3b
  jmp alltraps
80106fd7:	e9 23 f7 ff ff       	jmp    801066ff <alltraps>

80106fdc <vector60>:
.globl vector60
vector60:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $60
80106fde:	6a 3c                	push   $0x3c
  jmp alltraps
80106fe0:	e9 1a f7 ff ff       	jmp    801066ff <alltraps>

80106fe5 <vector61>:
.globl vector61
vector61:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $61
80106fe7:	6a 3d                	push   $0x3d
  jmp alltraps
80106fe9:	e9 11 f7 ff ff       	jmp    801066ff <alltraps>

80106fee <vector62>:
.globl vector62
vector62:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $62
80106ff0:	6a 3e                	push   $0x3e
  jmp alltraps
80106ff2:	e9 08 f7 ff ff       	jmp    801066ff <alltraps>

80106ff7 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $63
80106ff9:	6a 3f                	push   $0x3f
  jmp alltraps
80106ffb:	e9 ff f6 ff ff       	jmp    801066ff <alltraps>

80107000 <vector64>:
.globl vector64
vector64:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $64
80107002:	6a 40                	push   $0x40
  jmp alltraps
80107004:	e9 f6 f6 ff ff       	jmp    801066ff <alltraps>

80107009 <vector65>:
.globl vector65
vector65:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $65
8010700b:	6a 41                	push   $0x41
  jmp alltraps
8010700d:	e9 ed f6 ff ff       	jmp    801066ff <alltraps>

80107012 <vector66>:
.globl vector66
vector66:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $66
80107014:	6a 42                	push   $0x42
  jmp alltraps
80107016:	e9 e4 f6 ff ff       	jmp    801066ff <alltraps>

8010701b <vector67>:
.globl vector67
vector67:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $67
8010701d:	6a 43                	push   $0x43
  jmp alltraps
8010701f:	e9 db f6 ff ff       	jmp    801066ff <alltraps>

80107024 <vector68>:
.globl vector68
vector68:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $68
80107026:	6a 44                	push   $0x44
  jmp alltraps
80107028:	e9 d2 f6 ff ff       	jmp    801066ff <alltraps>

8010702d <vector69>:
.globl vector69
vector69:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $69
8010702f:	6a 45                	push   $0x45
  jmp alltraps
80107031:	e9 c9 f6 ff ff       	jmp    801066ff <alltraps>

80107036 <vector70>:
.globl vector70
vector70:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $70
80107038:	6a 46                	push   $0x46
  jmp alltraps
8010703a:	e9 c0 f6 ff ff       	jmp    801066ff <alltraps>

8010703f <vector71>:
.globl vector71
vector71:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $71
80107041:	6a 47                	push   $0x47
  jmp alltraps
80107043:	e9 b7 f6 ff ff       	jmp    801066ff <alltraps>

80107048 <vector72>:
.globl vector72
vector72:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $72
8010704a:	6a 48                	push   $0x48
  jmp alltraps
8010704c:	e9 ae f6 ff ff       	jmp    801066ff <alltraps>

80107051 <vector73>:
.globl vector73
vector73:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $73
80107053:	6a 49                	push   $0x49
  jmp alltraps
80107055:	e9 a5 f6 ff ff       	jmp    801066ff <alltraps>

8010705a <vector74>:
.globl vector74
vector74:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $74
8010705c:	6a 4a                	push   $0x4a
  jmp alltraps
8010705e:	e9 9c f6 ff ff       	jmp    801066ff <alltraps>

80107063 <vector75>:
.globl vector75
vector75:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $75
80107065:	6a 4b                	push   $0x4b
  jmp alltraps
80107067:	e9 93 f6 ff ff       	jmp    801066ff <alltraps>

8010706c <vector76>:
.globl vector76
vector76:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $76
8010706e:	6a 4c                	push   $0x4c
  jmp alltraps
80107070:	e9 8a f6 ff ff       	jmp    801066ff <alltraps>

80107075 <vector77>:
.globl vector77
vector77:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $77
80107077:	6a 4d                	push   $0x4d
  jmp alltraps
80107079:	e9 81 f6 ff ff       	jmp    801066ff <alltraps>

8010707e <vector78>:
.globl vector78
vector78:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $78
80107080:	6a 4e                	push   $0x4e
  jmp alltraps
80107082:	e9 78 f6 ff ff       	jmp    801066ff <alltraps>

80107087 <vector79>:
.globl vector79
vector79:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $79
80107089:	6a 4f                	push   $0x4f
  jmp alltraps
8010708b:	e9 6f f6 ff ff       	jmp    801066ff <alltraps>

80107090 <vector80>:
.globl vector80
vector80:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $80
80107092:	6a 50                	push   $0x50
  jmp alltraps
80107094:	e9 66 f6 ff ff       	jmp    801066ff <alltraps>

80107099 <vector81>:
.globl vector81
vector81:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $81
8010709b:	6a 51                	push   $0x51
  jmp alltraps
8010709d:	e9 5d f6 ff ff       	jmp    801066ff <alltraps>

801070a2 <vector82>:
.globl vector82
vector82:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $82
801070a4:	6a 52                	push   $0x52
  jmp alltraps
801070a6:	e9 54 f6 ff ff       	jmp    801066ff <alltraps>

801070ab <vector83>:
.globl vector83
vector83:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $83
801070ad:	6a 53                	push   $0x53
  jmp alltraps
801070af:	e9 4b f6 ff ff       	jmp    801066ff <alltraps>

801070b4 <vector84>:
.globl vector84
vector84:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $84
801070b6:	6a 54                	push   $0x54
  jmp alltraps
801070b8:	e9 42 f6 ff ff       	jmp    801066ff <alltraps>

801070bd <vector85>:
.globl vector85
vector85:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $85
801070bf:	6a 55                	push   $0x55
  jmp alltraps
801070c1:	e9 39 f6 ff ff       	jmp    801066ff <alltraps>

801070c6 <vector86>:
.globl vector86
vector86:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $86
801070c8:	6a 56                	push   $0x56
  jmp alltraps
801070ca:	e9 30 f6 ff ff       	jmp    801066ff <alltraps>

801070cf <vector87>:
.globl vector87
vector87:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $87
801070d1:	6a 57                	push   $0x57
  jmp alltraps
801070d3:	e9 27 f6 ff ff       	jmp    801066ff <alltraps>

801070d8 <vector88>:
.globl vector88
vector88:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $88
801070da:	6a 58                	push   $0x58
  jmp alltraps
801070dc:	e9 1e f6 ff ff       	jmp    801066ff <alltraps>

801070e1 <vector89>:
.globl vector89
vector89:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $89
801070e3:	6a 59                	push   $0x59
  jmp alltraps
801070e5:	e9 15 f6 ff ff       	jmp    801066ff <alltraps>

801070ea <vector90>:
.globl vector90
vector90:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $90
801070ec:	6a 5a                	push   $0x5a
  jmp alltraps
801070ee:	e9 0c f6 ff ff       	jmp    801066ff <alltraps>

801070f3 <vector91>:
.globl vector91
vector91:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $91
801070f5:	6a 5b                	push   $0x5b
  jmp alltraps
801070f7:	e9 03 f6 ff ff       	jmp    801066ff <alltraps>

801070fc <vector92>:
.globl vector92
vector92:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $92
801070fe:	6a 5c                	push   $0x5c
  jmp alltraps
80107100:	e9 fa f5 ff ff       	jmp    801066ff <alltraps>

80107105 <vector93>:
.globl vector93
vector93:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $93
80107107:	6a 5d                	push   $0x5d
  jmp alltraps
80107109:	e9 f1 f5 ff ff       	jmp    801066ff <alltraps>

8010710e <vector94>:
.globl vector94
vector94:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $94
80107110:	6a 5e                	push   $0x5e
  jmp alltraps
80107112:	e9 e8 f5 ff ff       	jmp    801066ff <alltraps>

80107117 <vector95>:
.globl vector95
vector95:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $95
80107119:	6a 5f                	push   $0x5f
  jmp alltraps
8010711b:	e9 df f5 ff ff       	jmp    801066ff <alltraps>

80107120 <vector96>:
.globl vector96
vector96:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $96
80107122:	6a 60                	push   $0x60
  jmp alltraps
80107124:	e9 d6 f5 ff ff       	jmp    801066ff <alltraps>

80107129 <vector97>:
.globl vector97
vector97:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $97
8010712b:	6a 61                	push   $0x61
  jmp alltraps
8010712d:	e9 cd f5 ff ff       	jmp    801066ff <alltraps>

80107132 <vector98>:
.globl vector98
vector98:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $98
80107134:	6a 62                	push   $0x62
  jmp alltraps
80107136:	e9 c4 f5 ff ff       	jmp    801066ff <alltraps>

8010713b <vector99>:
.globl vector99
vector99:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $99
8010713d:	6a 63                	push   $0x63
  jmp alltraps
8010713f:	e9 bb f5 ff ff       	jmp    801066ff <alltraps>

80107144 <vector100>:
.globl vector100
vector100:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $100
80107146:	6a 64                	push   $0x64
  jmp alltraps
80107148:	e9 b2 f5 ff ff       	jmp    801066ff <alltraps>

8010714d <vector101>:
.globl vector101
vector101:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $101
8010714f:	6a 65                	push   $0x65
  jmp alltraps
80107151:	e9 a9 f5 ff ff       	jmp    801066ff <alltraps>

80107156 <vector102>:
.globl vector102
vector102:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $102
80107158:	6a 66                	push   $0x66
  jmp alltraps
8010715a:	e9 a0 f5 ff ff       	jmp    801066ff <alltraps>

8010715f <vector103>:
.globl vector103
vector103:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $103
80107161:	6a 67                	push   $0x67
  jmp alltraps
80107163:	e9 97 f5 ff ff       	jmp    801066ff <alltraps>

80107168 <vector104>:
.globl vector104
vector104:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $104
8010716a:	6a 68                	push   $0x68
  jmp alltraps
8010716c:	e9 8e f5 ff ff       	jmp    801066ff <alltraps>

80107171 <vector105>:
.globl vector105
vector105:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $105
80107173:	6a 69                	push   $0x69
  jmp alltraps
80107175:	e9 85 f5 ff ff       	jmp    801066ff <alltraps>

8010717a <vector106>:
.globl vector106
vector106:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $106
8010717c:	6a 6a                	push   $0x6a
  jmp alltraps
8010717e:	e9 7c f5 ff ff       	jmp    801066ff <alltraps>

80107183 <vector107>:
.globl vector107
vector107:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $107
80107185:	6a 6b                	push   $0x6b
  jmp alltraps
80107187:	e9 73 f5 ff ff       	jmp    801066ff <alltraps>

8010718c <vector108>:
.globl vector108
vector108:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $108
8010718e:	6a 6c                	push   $0x6c
  jmp alltraps
80107190:	e9 6a f5 ff ff       	jmp    801066ff <alltraps>

80107195 <vector109>:
.globl vector109
vector109:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $109
80107197:	6a 6d                	push   $0x6d
  jmp alltraps
80107199:	e9 61 f5 ff ff       	jmp    801066ff <alltraps>

8010719e <vector110>:
.globl vector110
vector110:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $110
801071a0:	6a 6e                	push   $0x6e
  jmp alltraps
801071a2:	e9 58 f5 ff ff       	jmp    801066ff <alltraps>

801071a7 <vector111>:
.globl vector111
vector111:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $111
801071a9:	6a 6f                	push   $0x6f
  jmp alltraps
801071ab:	e9 4f f5 ff ff       	jmp    801066ff <alltraps>

801071b0 <vector112>:
.globl vector112
vector112:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $112
801071b2:	6a 70                	push   $0x70
  jmp alltraps
801071b4:	e9 46 f5 ff ff       	jmp    801066ff <alltraps>

801071b9 <vector113>:
.globl vector113
vector113:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $113
801071bb:	6a 71                	push   $0x71
  jmp alltraps
801071bd:	e9 3d f5 ff ff       	jmp    801066ff <alltraps>

801071c2 <vector114>:
.globl vector114
vector114:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $114
801071c4:	6a 72                	push   $0x72
  jmp alltraps
801071c6:	e9 34 f5 ff ff       	jmp    801066ff <alltraps>

801071cb <vector115>:
.globl vector115
vector115:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $115
801071cd:	6a 73                	push   $0x73
  jmp alltraps
801071cf:	e9 2b f5 ff ff       	jmp    801066ff <alltraps>

801071d4 <vector116>:
.globl vector116
vector116:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $116
801071d6:	6a 74                	push   $0x74
  jmp alltraps
801071d8:	e9 22 f5 ff ff       	jmp    801066ff <alltraps>

801071dd <vector117>:
.globl vector117
vector117:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $117
801071df:	6a 75                	push   $0x75
  jmp alltraps
801071e1:	e9 19 f5 ff ff       	jmp    801066ff <alltraps>

801071e6 <vector118>:
.globl vector118
vector118:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $118
801071e8:	6a 76                	push   $0x76
  jmp alltraps
801071ea:	e9 10 f5 ff ff       	jmp    801066ff <alltraps>

801071ef <vector119>:
.globl vector119
vector119:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $119
801071f1:	6a 77                	push   $0x77
  jmp alltraps
801071f3:	e9 07 f5 ff ff       	jmp    801066ff <alltraps>

801071f8 <vector120>:
.globl vector120
vector120:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $120
801071fa:	6a 78                	push   $0x78
  jmp alltraps
801071fc:	e9 fe f4 ff ff       	jmp    801066ff <alltraps>

80107201 <vector121>:
.globl vector121
vector121:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $121
80107203:	6a 79                	push   $0x79
  jmp alltraps
80107205:	e9 f5 f4 ff ff       	jmp    801066ff <alltraps>

8010720a <vector122>:
.globl vector122
vector122:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $122
8010720c:	6a 7a                	push   $0x7a
  jmp alltraps
8010720e:	e9 ec f4 ff ff       	jmp    801066ff <alltraps>

80107213 <vector123>:
.globl vector123
vector123:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $123
80107215:	6a 7b                	push   $0x7b
  jmp alltraps
80107217:	e9 e3 f4 ff ff       	jmp    801066ff <alltraps>

8010721c <vector124>:
.globl vector124
vector124:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $124
8010721e:	6a 7c                	push   $0x7c
  jmp alltraps
80107220:	e9 da f4 ff ff       	jmp    801066ff <alltraps>

80107225 <vector125>:
.globl vector125
vector125:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $125
80107227:	6a 7d                	push   $0x7d
  jmp alltraps
80107229:	e9 d1 f4 ff ff       	jmp    801066ff <alltraps>

8010722e <vector126>:
.globl vector126
vector126:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $126
80107230:	6a 7e                	push   $0x7e
  jmp alltraps
80107232:	e9 c8 f4 ff ff       	jmp    801066ff <alltraps>

80107237 <vector127>:
.globl vector127
vector127:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $127
80107239:	6a 7f                	push   $0x7f
  jmp alltraps
8010723b:	e9 bf f4 ff ff       	jmp    801066ff <alltraps>

80107240 <vector128>:
.globl vector128
vector128:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $128
80107242:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107247:	e9 b3 f4 ff ff       	jmp    801066ff <alltraps>

8010724c <vector129>:
.globl vector129
vector129:
  pushl $0
8010724c:	6a 00                	push   $0x0
  pushl $129
8010724e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107253:	e9 a7 f4 ff ff       	jmp    801066ff <alltraps>

80107258 <vector130>:
.globl vector130
vector130:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $130
8010725a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010725f:	e9 9b f4 ff ff       	jmp    801066ff <alltraps>

80107264 <vector131>:
.globl vector131
vector131:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $131
80107266:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010726b:	e9 8f f4 ff ff       	jmp    801066ff <alltraps>

80107270 <vector132>:
.globl vector132
vector132:
  pushl $0
80107270:	6a 00                	push   $0x0
  pushl $132
80107272:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107277:	e9 83 f4 ff ff       	jmp    801066ff <alltraps>

8010727c <vector133>:
.globl vector133
vector133:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $133
8010727e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107283:	e9 77 f4 ff ff       	jmp    801066ff <alltraps>

80107288 <vector134>:
.globl vector134
vector134:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $134
8010728a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010728f:	e9 6b f4 ff ff       	jmp    801066ff <alltraps>

80107294 <vector135>:
.globl vector135
vector135:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $135
80107296:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010729b:	e9 5f f4 ff ff       	jmp    801066ff <alltraps>

801072a0 <vector136>:
.globl vector136
vector136:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $136
801072a2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072a7:	e9 53 f4 ff ff       	jmp    801066ff <alltraps>

801072ac <vector137>:
.globl vector137
vector137:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $137
801072ae:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072b3:	e9 47 f4 ff ff       	jmp    801066ff <alltraps>

801072b8 <vector138>:
.globl vector138
vector138:
  pushl $0
801072b8:	6a 00                	push   $0x0
  pushl $138
801072ba:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072bf:	e9 3b f4 ff ff       	jmp    801066ff <alltraps>

801072c4 <vector139>:
.globl vector139
vector139:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $139
801072c6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801072cb:	e9 2f f4 ff ff       	jmp    801066ff <alltraps>

801072d0 <vector140>:
.globl vector140
vector140:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $140
801072d2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801072d7:	e9 23 f4 ff ff       	jmp    801066ff <alltraps>

801072dc <vector141>:
.globl vector141
vector141:
  pushl $0
801072dc:	6a 00                	push   $0x0
  pushl $141
801072de:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801072e3:	e9 17 f4 ff ff       	jmp    801066ff <alltraps>

801072e8 <vector142>:
.globl vector142
vector142:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $142
801072ea:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072ef:	e9 0b f4 ff ff       	jmp    801066ff <alltraps>

801072f4 <vector143>:
.globl vector143
vector143:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $143
801072f6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801072fb:	e9 ff f3 ff ff       	jmp    801066ff <alltraps>

80107300 <vector144>:
.globl vector144
vector144:
  pushl $0
80107300:	6a 00                	push   $0x0
  pushl $144
80107302:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107307:	e9 f3 f3 ff ff       	jmp    801066ff <alltraps>

8010730c <vector145>:
.globl vector145
vector145:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $145
8010730e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107313:	e9 e7 f3 ff ff       	jmp    801066ff <alltraps>

80107318 <vector146>:
.globl vector146
vector146:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $146
8010731a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010731f:	e9 db f3 ff ff       	jmp    801066ff <alltraps>

80107324 <vector147>:
.globl vector147
vector147:
  pushl $0
80107324:	6a 00                	push   $0x0
  pushl $147
80107326:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010732b:	e9 cf f3 ff ff       	jmp    801066ff <alltraps>

80107330 <vector148>:
.globl vector148
vector148:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $148
80107332:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107337:	e9 c3 f3 ff ff       	jmp    801066ff <alltraps>

8010733c <vector149>:
.globl vector149
vector149:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $149
8010733e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107343:	e9 b7 f3 ff ff       	jmp    801066ff <alltraps>

80107348 <vector150>:
.globl vector150
vector150:
  pushl $0
80107348:	6a 00                	push   $0x0
  pushl $150
8010734a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010734f:	e9 ab f3 ff ff       	jmp    801066ff <alltraps>

80107354 <vector151>:
.globl vector151
vector151:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $151
80107356:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010735b:	e9 9f f3 ff ff       	jmp    801066ff <alltraps>

80107360 <vector152>:
.globl vector152
vector152:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $152
80107362:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107367:	e9 93 f3 ff ff       	jmp    801066ff <alltraps>

8010736c <vector153>:
.globl vector153
vector153:
  pushl $0
8010736c:	6a 00                	push   $0x0
  pushl $153
8010736e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107373:	e9 87 f3 ff ff       	jmp    801066ff <alltraps>

80107378 <vector154>:
.globl vector154
vector154:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $154
8010737a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010737f:	e9 7b f3 ff ff       	jmp    801066ff <alltraps>

80107384 <vector155>:
.globl vector155
vector155:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $155
80107386:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010738b:	e9 6f f3 ff ff       	jmp    801066ff <alltraps>

80107390 <vector156>:
.globl vector156
vector156:
  pushl $0
80107390:	6a 00                	push   $0x0
  pushl $156
80107392:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107397:	e9 63 f3 ff ff       	jmp    801066ff <alltraps>

8010739c <vector157>:
.globl vector157
vector157:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $157
8010739e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073a3:	e9 57 f3 ff ff       	jmp    801066ff <alltraps>

801073a8 <vector158>:
.globl vector158
vector158:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $158
801073aa:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073af:	e9 4b f3 ff ff       	jmp    801066ff <alltraps>

801073b4 <vector159>:
.globl vector159
vector159:
  pushl $0
801073b4:	6a 00                	push   $0x0
  pushl $159
801073b6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073bb:	e9 3f f3 ff ff       	jmp    801066ff <alltraps>

801073c0 <vector160>:
.globl vector160
vector160:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $160
801073c2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801073c7:	e9 33 f3 ff ff       	jmp    801066ff <alltraps>

801073cc <vector161>:
.globl vector161
vector161:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $161
801073ce:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801073d3:	e9 27 f3 ff ff       	jmp    801066ff <alltraps>

801073d8 <vector162>:
.globl vector162
vector162:
  pushl $0
801073d8:	6a 00                	push   $0x0
  pushl $162
801073da:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801073df:	e9 1b f3 ff ff       	jmp    801066ff <alltraps>

801073e4 <vector163>:
.globl vector163
vector163:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $163
801073e6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073eb:	e9 0f f3 ff ff       	jmp    801066ff <alltraps>

801073f0 <vector164>:
.globl vector164
vector164:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $164
801073f2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073f7:	e9 03 f3 ff ff       	jmp    801066ff <alltraps>

801073fc <vector165>:
.globl vector165
vector165:
  pushl $0
801073fc:	6a 00                	push   $0x0
  pushl $165
801073fe:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107403:	e9 f7 f2 ff ff       	jmp    801066ff <alltraps>

80107408 <vector166>:
.globl vector166
vector166:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $166
8010740a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010740f:	e9 eb f2 ff ff       	jmp    801066ff <alltraps>

80107414 <vector167>:
.globl vector167
vector167:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $167
80107416:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010741b:	e9 df f2 ff ff       	jmp    801066ff <alltraps>

80107420 <vector168>:
.globl vector168
vector168:
  pushl $0
80107420:	6a 00                	push   $0x0
  pushl $168
80107422:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107427:	e9 d3 f2 ff ff       	jmp    801066ff <alltraps>

8010742c <vector169>:
.globl vector169
vector169:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $169
8010742e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107433:	e9 c7 f2 ff ff       	jmp    801066ff <alltraps>

80107438 <vector170>:
.globl vector170
vector170:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $170
8010743a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010743f:	e9 bb f2 ff ff       	jmp    801066ff <alltraps>

80107444 <vector171>:
.globl vector171
vector171:
  pushl $0
80107444:	6a 00                	push   $0x0
  pushl $171
80107446:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010744b:	e9 af f2 ff ff       	jmp    801066ff <alltraps>

80107450 <vector172>:
.globl vector172
vector172:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $172
80107452:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107457:	e9 a3 f2 ff ff       	jmp    801066ff <alltraps>

8010745c <vector173>:
.globl vector173
vector173:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $173
8010745e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107463:	e9 97 f2 ff ff       	jmp    801066ff <alltraps>

80107468 <vector174>:
.globl vector174
vector174:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $174
8010746a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010746f:	e9 8b f2 ff ff       	jmp    801066ff <alltraps>

80107474 <vector175>:
.globl vector175
vector175:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $175
80107476:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010747b:	e9 7f f2 ff ff       	jmp    801066ff <alltraps>

80107480 <vector176>:
.globl vector176
vector176:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $176
80107482:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107487:	e9 73 f2 ff ff       	jmp    801066ff <alltraps>

8010748c <vector177>:
.globl vector177
vector177:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $177
8010748e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107493:	e9 67 f2 ff ff       	jmp    801066ff <alltraps>

80107498 <vector178>:
.globl vector178
vector178:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $178
8010749a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010749f:	e9 5b f2 ff ff       	jmp    801066ff <alltraps>

801074a4 <vector179>:
.globl vector179
vector179:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $179
801074a6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074ab:	e9 4f f2 ff ff       	jmp    801066ff <alltraps>

801074b0 <vector180>:
.globl vector180
vector180:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $180
801074b2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074b7:	e9 43 f2 ff ff       	jmp    801066ff <alltraps>

801074bc <vector181>:
.globl vector181
vector181:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $181
801074be:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074c3:	e9 37 f2 ff ff       	jmp    801066ff <alltraps>

801074c8 <vector182>:
.globl vector182
vector182:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $182
801074ca:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801074cf:	e9 2b f2 ff ff       	jmp    801066ff <alltraps>

801074d4 <vector183>:
.globl vector183
vector183:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $183
801074d6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801074db:	e9 1f f2 ff ff       	jmp    801066ff <alltraps>

801074e0 <vector184>:
.globl vector184
vector184:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $184
801074e2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801074e7:	e9 13 f2 ff ff       	jmp    801066ff <alltraps>

801074ec <vector185>:
.globl vector185
vector185:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $185
801074ee:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074f3:	e9 07 f2 ff ff       	jmp    801066ff <alltraps>

801074f8 <vector186>:
.globl vector186
vector186:
  pushl $0
801074f8:	6a 00                	push   $0x0
  pushl $186
801074fa:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801074ff:	e9 fb f1 ff ff       	jmp    801066ff <alltraps>

80107504 <vector187>:
.globl vector187
vector187:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $187
80107506:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010750b:	e9 ef f1 ff ff       	jmp    801066ff <alltraps>

80107510 <vector188>:
.globl vector188
vector188:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $188
80107512:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107517:	e9 e3 f1 ff ff       	jmp    801066ff <alltraps>

8010751c <vector189>:
.globl vector189
vector189:
  pushl $0
8010751c:	6a 00                	push   $0x0
  pushl $189
8010751e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107523:	e9 d7 f1 ff ff       	jmp    801066ff <alltraps>

80107528 <vector190>:
.globl vector190
vector190:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $190
8010752a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010752f:	e9 cb f1 ff ff       	jmp    801066ff <alltraps>

80107534 <vector191>:
.globl vector191
vector191:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $191
80107536:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010753b:	e9 bf f1 ff ff       	jmp    801066ff <alltraps>

80107540 <vector192>:
.globl vector192
vector192:
  pushl $0
80107540:	6a 00                	push   $0x0
  pushl $192
80107542:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107547:	e9 b3 f1 ff ff       	jmp    801066ff <alltraps>

8010754c <vector193>:
.globl vector193
vector193:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $193
8010754e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107553:	e9 a7 f1 ff ff       	jmp    801066ff <alltraps>

80107558 <vector194>:
.globl vector194
vector194:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $194
8010755a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010755f:	e9 9b f1 ff ff       	jmp    801066ff <alltraps>

80107564 <vector195>:
.globl vector195
vector195:
  pushl $0
80107564:	6a 00                	push   $0x0
  pushl $195
80107566:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010756b:	e9 8f f1 ff ff       	jmp    801066ff <alltraps>

80107570 <vector196>:
.globl vector196
vector196:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $196
80107572:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107577:	e9 83 f1 ff ff       	jmp    801066ff <alltraps>

8010757c <vector197>:
.globl vector197
vector197:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $197
8010757e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107583:	e9 77 f1 ff ff       	jmp    801066ff <alltraps>

80107588 <vector198>:
.globl vector198
vector198:
  pushl $0
80107588:	6a 00                	push   $0x0
  pushl $198
8010758a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010758f:	e9 6b f1 ff ff       	jmp    801066ff <alltraps>

80107594 <vector199>:
.globl vector199
vector199:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $199
80107596:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010759b:	e9 5f f1 ff ff       	jmp    801066ff <alltraps>

801075a0 <vector200>:
.globl vector200
vector200:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $200
801075a2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075a7:	e9 53 f1 ff ff       	jmp    801066ff <alltraps>

801075ac <vector201>:
.globl vector201
vector201:
  pushl $0
801075ac:	6a 00                	push   $0x0
  pushl $201
801075ae:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075b3:	e9 47 f1 ff ff       	jmp    801066ff <alltraps>

801075b8 <vector202>:
.globl vector202
vector202:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $202
801075ba:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075bf:	e9 3b f1 ff ff       	jmp    801066ff <alltraps>

801075c4 <vector203>:
.globl vector203
vector203:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $203
801075c6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801075cb:	e9 2f f1 ff ff       	jmp    801066ff <alltraps>

801075d0 <vector204>:
.globl vector204
vector204:
  pushl $0
801075d0:	6a 00                	push   $0x0
  pushl $204
801075d2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801075d7:	e9 23 f1 ff ff       	jmp    801066ff <alltraps>

801075dc <vector205>:
.globl vector205
vector205:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $205
801075de:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801075e3:	e9 17 f1 ff ff       	jmp    801066ff <alltraps>

801075e8 <vector206>:
.globl vector206
vector206:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $206
801075ea:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075ef:	e9 0b f1 ff ff       	jmp    801066ff <alltraps>

801075f4 <vector207>:
.globl vector207
vector207:
  pushl $0
801075f4:	6a 00                	push   $0x0
  pushl $207
801075f6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801075fb:	e9 ff f0 ff ff       	jmp    801066ff <alltraps>

80107600 <vector208>:
.globl vector208
vector208:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $208
80107602:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107607:	e9 f3 f0 ff ff       	jmp    801066ff <alltraps>

8010760c <vector209>:
.globl vector209
vector209:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $209
8010760e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107613:	e9 e7 f0 ff ff       	jmp    801066ff <alltraps>

80107618 <vector210>:
.globl vector210
vector210:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $210
8010761a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010761f:	e9 db f0 ff ff       	jmp    801066ff <alltraps>

80107624 <vector211>:
.globl vector211
vector211:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $211
80107626:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010762b:	e9 cf f0 ff ff       	jmp    801066ff <alltraps>

80107630 <vector212>:
.globl vector212
vector212:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $212
80107632:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107637:	e9 c3 f0 ff ff       	jmp    801066ff <alltraps>

8010763c <vector213>:
.globl vector213
vector213:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $213
8010763e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107643:	e9 b7 f0 ff ff       	jmp    801066ff <alltraps>

80107648 <vector214>:
.globl vector214
vector214:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $214
8010764a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010764f:	e9 ab f0 ff ff       	jmp    801066ff <alltraps>

80107654 <vector215>:
.globl vector215
vector215:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $215
80107656:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010765b:	e9 9f f0 ff ff       	jmp    801066ff <alltraps>

80107660 <vector216>:
.globl vector216
vector216:
  pushl $0
80107660:	6a 00                	push   $0x0
  pushl $216
80107662:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107667:	e9 93 f0 ff ff       	jmp    801066ff <alltraps>

8010766c <vector217>:
.globl vector217
vector217:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $217
8010766e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107673:	e9 87 f0 ff ff       	jmp    801066ff <alltraps>

80107678 <vector218>:
.globl vector218
vector218:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $218
8010767a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010767f:	e9 7b f0 ff ff       	jmp    801066ff <alltraps>

80107684 <vector219>:
.globl vector219
vector219:
  pushl $0
80107684:	6a 00                	push   $0x0
  pushl $219
80107686:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010768b:	e9 6f f0 ff ff       	jmp    801066ff <alltraps>

80107690 <vector220>:
.globl vector220
vector220:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $220
80107692:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107697:	e9 63 f0 ff ff       	jmp    801066ff <alltraps>

8010769c <vector221>:
.globl vector221
vector221:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $221
8010769e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076a3:	e9 57 f0 ff ff       	jmp    801066ff <alltraps>

801076a8 <vector222>:
.globl vector222
vector222:
  pushl $0
801076a8:	6a 00                	push   $0x0
  pushl $222
801076aa:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076af:	e9 4b f0 ff ff       	jmp    801066ff <alltraps>

801076b4 <vector223>:
.globl vector223
vector223:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $223
801076b6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076bb:	e9 3f f0 ff ff       	jmp    801066ff <alltraps>

801076c0 <vector224>:
.globl vector224
vector224:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $224
801076c2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801076c7:	e9 33 f0 ff ff       	jmp    801066ff <alltraps>

801076cc <vector225>:
.globl vector225
vector225:
  pushl $0
801076cc:	6a 00                	push   $0x0
  pushl $225
801076ce:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801076d3:	e9 27 f0 ff ff       	jmp    801066ff <alltraps>

801076d8 <vector226>:
.globl vector226
vector226:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $226
801076da:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801076df:	e9 1b f0 ff ff       	jmp    801066ff <alltraps>

801076e4 <vector227>:
.globl vector227
vector227:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $227
801076e6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076eb:	e9 0f f0 ff ff       	jmp    801066ff <alltraps>

801076f0 <vector228>:
.globl vector228
vector228:
  pushl $0
801076f0:	6a 00                	push   $0x0
  pushl $228
801076f2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076f7:	e9 03 f0 ff ff       	jmp    801066ff <alltraps>

801076fc <vector229>:
.globl vector229
vector229:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $229
801076fe:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107703:	e9 f7 ef ff ff       	jmp    801066ff <alltraps>

80107708 <vector230>:
.globl vector230
vector230:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $230
8010770a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010770f:	e9 eb ef ff ff       	jmp    801066ff <alltraps>

80107714 <vector231>:
.globl vector231
vector231:
  pushl $0
80107714:	6a 00                	push   $0x0
  pushl $231
80107716:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010771b:	e9 df ef ff ff       	jmp    801066ff <alltraps>

80107720 <vector232>:
.globl vector232
vector232:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $232
80107722:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107727:	e9 d3 ef ff ff       	jmp    801066ff <alltraps>

8010772c <vector233>:
.globl vector233
vector233:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $233
8010772e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107733:	e9 c7 ef ff ff       	jmp    801066ff <alltraps>

80107738 <vector234>:
.globl vector234
vector234:
  pushl $0
80107738:	6a 00                	push   $0x0
  pushl $234
8010773a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010773f:	e9 bb ef ff ff       	jmp    801066ff <alltraps>

80107744 <vector235>:
.globl vector235
vector235:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $235
80107746:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010774b:	e9 af ef ff ff       	jmp    801066ff <alltraps>

80107750 <vector236>:
.globl vector236
vector236:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $236
80107752:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107757:	e9 a3 ef ff ff       	jmp    801066ff <alltraps>

8010775c <vector237>:
.globl vector237
vector237:
  pushl $0
8010775c:	6a 00                	push   $0x0
  pushl $237
8010775e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107763:	e9 97 ef ff ff       	jmp    801066ff <alltraps>

80107768 <vector238>:
.globl vector238
vector238:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $238
8010776a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010776f:	e9 8b ef ff ff       	jmp    801066ff <alltraps>

80107774 <vector239>:
.globl vector239
vector239:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $239
80107776:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010777b:	e9 7f ef ff ff       	jmp    801066ff <alltraps>

80107780 <vector240>:
.globl vector240
vector240:
  pushl $0
80107780:	6a 00                	push   $0x0
  pushl $240
80107782:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107787:	e9 73 ef ff ff       	jmp    801066ff <alltraps>

8010778c <vector241>:
.globl vector241
vector241:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $241
8010778e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107793:	e9 67 ef ff ff       	jmp    801066ff <alltraps>

80107798 <vector242>:
.globl vector242
vector242:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $242
8010779a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010779f:	e9 5b ef ff ff       	jmp    801066ff <alltraps>

801077a4 <vector243>:
.globl vector243
vector243:
  pushl $0
801077a4:	6a 00                	push   $0x0
  pushl $243
801077a6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077ab:	e9 4f ef ff ff       	jmp    801066ff <alltraps>

801077b0 <vector244>:
.globl vector244
vector244:
  pushl $0
801077b0:	6a 00                	push   $0x0
  pushl $244
801077b2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077b7:	e9 43 ef ff ff       	jmp    801066ff <alltraps>

801077bc <vector245>:
.globl vector245
vector245:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $245
801077be:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077c3:	e9 37 ef ff ff       	jmp    801066ff <alltraps>

801077c8 <vector246>:
.globl vector246
vector246:
  pushl $0
801077c8:	6a 00                	push   $0x0
  pushl $246
801077ca:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801077cf:	e9 2b ef ff ff       	jmp    801066ff <alltraps>

801077d4 <vector247>:
.globl vector247
vector247:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $247
801077d6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801077db:	e9 1f ef ff ff       	jmp    801066ff <alltraps>

801077e0 <vector248>:
.globl vector248
vector248:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $248
801077e2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801077e7:	e9 13 ef ff ff       	jmp    801066ff <alltraps>

801077ec <vector249>:
.globl vector249
vector249:
  pushl $0
801077ec:	6a 00                	push   $0x0
  pushl $249
801077ee:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077f3:	e9 07 ef ff ff       	jmp    801066ff <alltraps>

801077f8 <vector250>:
.globl vector250
vector250:
  pushl $0
801077f8:	6a 00                	push   $0x0
  pushl $250
801077fa:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801077ff:	e9 fb ee ff ff       	jmp    801066ff <alltraps>

80107804 <vector251>:
.globl vector251
vector251:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $251
80107806:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010780b:	e9 ef ee ff ff       	jmp    801066ff <alltraps>

80107810 <vector252>:
.globl vector252
vector252:
  pushl $0
80107810:	6a 00                	push   $0x0
  pushl $252
80107812:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107817:	e9 e3 ee ff ff       	jmp    801066ff <alltraps>

8010781c <vector253>:
.globl vector253
vector253:
  pushl $0
8010781c:	6a 00                	push   $0x0
  pushl $253
8010781e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107823:	e9 d7 ee ff ff       	jmp    801066ff <alltraps>

80107828 <vector254>:
.globl vector254
vector254:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $254
8010782a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010782f:	e9 cb ee ff ff       	jmp    801066ff <alltraps>

80107834 <vector255>:
.globl vector255
vector255:
  pushl $0
80107834:	6a 00                	push   $0x0
  pushl $255
80107836:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010783b:	e9 bf ee ff ff       	jmp    801066ff <alltraps>

80107840 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107846:	8b 45 0c             	mov    0xc(%ebp),%eax
80107849:	83 e8 01             	sub    $0x1,%eax
8010784c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107850:	8b 45 08             	mov    0x8(%ebp),%eax
80107853:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107857:	8b 45 08             	mov    0x8(%ebp),%eax
8010785a:	c1 e8 10             	shr    $0x10,%eax
8010785d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107861:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107864:	0f 01 10             	lgdtl  (%eax)
}
80107867:	c9                   	leave  
80107868:	c3                   	ret    

80107869 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107869:	55                   	push   %ebp
8010786a:	89 e5                	mov    %esp,%ebp
8010786c:	83 ec 04             	sub    $0x4,%esp
8010786f:	8b 45 08             	mov    0x8(%ebp),%eax
80107872:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107876:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010787a:	0f 00 d8             	ltr    %ax
}
8010787d:	c9                   	leave  
8010787e:	c3                   	ret    

8010787f <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010787f:	55                   	push   %ebp
80107880:	89 e5                	mov    %esp,%ebp
80107882:	83 ec 04             	sub    $0x4,%esp
80107885:	8b 45 08             	mov    0x8(%ebp),%eax
80107888:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010788c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107890:	8e e8                	mov    %eax,%gs
}
80107892:	c9                   	leave  
80107893:	c3                   	ret    

80107894 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107894:	55                   	push   %ebp
80107895:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107897:	8b 45 08             	mov    0x8(%ebp),%eax
8010789a:	0f 22 d8             	mov    %eax,%cr3
}
8010789d:	5d                   	pop    %ebp
8010789e:	c3                   	ret    

8010789f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010789f:	55                   	push   %ebp
801078a0:	89 e5                	mov    %esp,%ebp
801078a2:	8b 45 08             	mov    0x8(%ebp),%eax
801078a5:	05 00 00 00 80       	add    $0x80000000,%eax
801078aa:	5d                   	pop    %ebp
801078ab:	c3                   	ret    

801078ac <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801078ac:	55                   	push   %ebp
801078ad:	89 e5                	mov    %esp,%ebp
801078af:	8b 45 08             	mov    0x8(%ebp),%eax
801078b2:	05 00 00 00 80       	add    $0x80000000,%eax
801078b7:	5d                   	pop    %ebp
801078b8:	c3                   	ret    

801078b9 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801078b9:	55                   	push   %ebp
801078ba:	89 e5                	mov    %esp,%ebp
801078bc:	53                   	push   %ebx
801078bd:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801078c0:	e8 c5 b5 ff ff       	call   80102e8a <cpunum>
801078c5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801078cb:	05 60 23 11 80       	add    $0x80112360,%eax
801078d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d6:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078df:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801078e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801078ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ef:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078f3:	83 e2 f0             	and    $0xfffffff0,%edx
801078f6:	83 ca 0a             	or     $0xa,%edx
801078f9:	88 50 7d             	mov    %dl,0x7d(%eax)
801078fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ff:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107903:	83 ca 10             	or     $0x10,%edx
80107906:	88 50 7d             	mov    %dl,0x7d(%eax)
80107909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107910:	83 e2 9f             	and    $0xffffff9f,%edx
80107913:	88 50 7d             	mov    %dl,0x7d(%eax)
80107916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107919:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010791d:	83 ca 80             	or     $0xffffff80,%edx
80107920:	88 50 7d             	mov    %dl,0x7d(%eax)
80107923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107926:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010792a:	83 ca 0f             	or     $0xf,%edx
8010792d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107933:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107937:	83 e2 ef             	and    $0xffffffef,%edx
8010793a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010793d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107940:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107944:	83 e2 df             	and    $0xffffffdf,%edx
80107947:	88 50 7e             	mov    %dl,0x7e(%eax)
8010794a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107951:	83 ca 40             	or     $0x40,%edx
80107954:	88 50 7e             	mov    %dl,0x7e(%eax)
80107957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010795e:	83 ca 80             	or     $0xffffff80,%edx
80107961:	88 50 7e             	mov    %dl,0x7e(%eax)
80107964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107967:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010796b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107975:	ff ff 
80107977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107981:	00 00 
80107983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107986:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010798d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107990:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107997:	83 e2 f0             	and    $0xfffffff0,%edx
8010799a:	83 ca 02             	or     $0x2,%edx
8010799d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079ad:	83 ca 10             	or     $0x10,%edx
801079b0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079c0:	83 e2 9f             	and    $0xffffff9f,%edx
801079c3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079d3:	83 ca 80             	or     $0xffffff80,%edx
801079d6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079df:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079e6:	83 ca 0f             	or     $0xf,%edx
801079e9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079f9:	83 e2 ef             	and    $0xffffffef,%edx
801079fc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a05:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a0c:	83 e2 df             	and    $0xffffffdf,%edx
80107a0f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a18:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a1f:	83 ca 40             	or     $0x40,%edx
80107a22:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a32:	83 ca 80             	or     $0xffffff80,%edx
80107a35:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a48:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a4f:	ff ff 
80107a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a54:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a5b:	00 00 
80107a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a60:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a71:	83 e2 f0             	and    $0xfffffff0,%edx
80107a74:	83 ca 0a             	or     $0xa,%edx
80107a77:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a87:	83 ca 10             	or     $0x10,%edx
80107a8a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a93:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a9a:	83 ca 60             	or     $0x60,%edx
80107a9d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107aad:	83 ca 80             	or     $0xffffff80,%edx
80107ab0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ac0:	83 ca 0f             	or     $0xf,%edx
80107ac3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ad3:	83 e2 ef             	and    $0xffffffef,%edx
80107ad6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ae6:	83 e2 df             	and    $0xffffffdf,%edx
80107ae9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107af9:	83 ca 40             	or     $0x40,%edx
80107afc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b05:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b0c:	83 ca 80             	or     $0xffffff80,%edx
80107b0f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b18:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b22:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107b29:	ff ff 
80107b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2e:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107b35:	00 00 
80107b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3a:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b44:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b4b:	83 e2 f0             	and    $0xfffffff0,%edx
80107b4e:	83 ca 02             	or     $0x2,%edx
80107b51:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b5a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b61:	83 ca 10             	or     $0x10,%edx
80107b64:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b74:	83 ca 60             	or     $0x60,%edx
80107b77:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b80:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b87:	83 ca 80             	or     $0xffffff80,%edx
80107b8a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b93:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b9a:	83 ca 0f             	or     $0xf,%edx
80107b9d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bad:	83 e2 ef             	and    $0xffffffef,%edx
80107bb0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bc0:	83 e2 df             	and    $0xffffffdf,%edx
80107bc3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcc:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bd3:	83 ca 40             	or     $0x40,%edx
80107bd6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107be6:	83 ca 80             	or     $0xffffff80,%edx
80107be9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf2:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfc:	05 b4 00 00 00       	add    $0xb4,%eax
80107c01:	89 c3                	mov    %eax,%ebx
80107c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c06:	05 b4 00 00 00       	add    $0xb4,%eax
80107c0b:	c1 e8 10             	shr    $0x10,%eax
80107c0e:	89 c1                	mov    %eax,%ecx
80107c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c13:	05 b4 00 00 00       	add    $0xb4,%eax
80107c18:	c1 e8 18             	shr    $0x18,%eax
80107c1b:	89 c2                	mov    %eax,%edx
80107c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c20:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107c27:	00 00 
80107c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2c:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c36:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107c46:	83 e1 f0             	and    $0xfffffff0,%ecx
80107c49:	83 c9 02             	or     $0x2,%ecx
80107c4c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c55:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107c5c:	83 c9 10             	or     $0x10,%ecx
80107c5f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c68:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107c6f:	83 e1 9f             	and    $0xffffff9f,%ecx
80107c72:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107c82:	83 c9 80             	or     $0xffffff80,%ecx
80107c85:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107c95:	83 e1 f0             	and    $0xfffffff0,%ecx
80107c98:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ca8:	83 e1 ef             	and    $0xffffffef,%ecx
80107cab:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb4:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107cbb:	83 e1 df             	and    $0xffffffdf,%ecx
80107cbe:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc7:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107cce:	83 c9 40             	or     $0x40,%ecx
80107cd1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cda:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ce1:	83 c9 80             	or     $0xffffff80,%ecx
80107ce4:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf6:	83 c0 70             	add    $0x70,%eax
80107cf9:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107d00:	00 
80107d01:	89 04 24             	mov    %eax,(%esp)
80107d04:	e8 37 fb ff ff       	call   80107840 <lgdt>
  loadgs(SEG_KCPU << 3);
80107d09:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107d10:	e8 6a fb ff ff       	call   8010787f <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d18:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  thread = 0;
80107d1e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107d25:	00 00 00 00 
}
80107d29:	83 c4 24             	add    $0x24,%esp
80107d2c:	5b                   	pop    %ebx
80107d2d:	5d                   	pop    %ebp
80107d2e:	c3                   	ret    

80107d2f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107d2f:	55                   	push   %ebp
80107d30:	89 e5                	mov    %esp,%ebp
80107d32:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107d35:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d38:	c1 e8 16             	shr    $0x16,%eax
80107d3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d42:	8b 45 08             	mov    0x8(%ebp),%eax
80107d45:	01 d0                	add    %edx,%eax
80107d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d4d:	8b 00                	mov    (%eax),%eax
80107d4f:	83 e0 01             	and    $0x1,%eax
80107d52:	85 c0                	test   %eax,%eax
80107d54:	74 17                	je     80107d6d <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d59:	8b 00                	mov    (%eax),%eax
80107d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d60:	89 04 24             	mov    %eax,(%esp)
80107d63:	e8 44 fb ff ff       	call   801078ac <p2v>
80107d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d6b:	eb 4b                	jmp    80107db8 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107d71:	74 0e                	je     80107d81 <walkpgdir+0x52>
80107d73:	e8 7c ad ff ff       	call   80102af4 <kalloc>
80107d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d7f:	75 07                	jne    80107d88 <walkpgdir+0x59>
      return 0;
80107d81:	b8 00 00 00 00       	mov    $0x0,%eax
80107d86:	eb 47                	jmp    80107dcf <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107d88:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d8f:	00 
80107d90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d97:	00 
80107d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9b:	89 04 24             	mov    %eax,(%esp)
80107d9e:	e8 2f d5 ff ff       	call   801052d2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da6:	89 04 24             	mov    %eax,(%esp)
80107da9:	e8 f1 fa ff ff       	call   8010789f <v2p>
80107dae:	83 c8 07             	or     $0x7,%eax
80107db1:	89 c2                	mov    %eax,%edx
80107db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db6:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dbb:	c1 e8 0c             	shr    $0xc,%eax
80107dbe:	25 ff 03 00 00       	and    $0x3ff,%eax
80107dc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcd:	01 d0                	add    %edx,%eax
}
80107dcf:	c9                   	leave  
80107dd0:	c3                   	ret    

80107dd1 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107dd1:	55                   	push   %ebp
80107dd2:	89 e5                	mov    %esp,%ebp
80107dd4:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107de2:	8b 55 0c             	mov    0xc(%ebp),%edx
80107de5:	8b 45 10             	mov    0x10(%ebp),%eax
80107de8:	01 d0                	add    %edx,%eax
80107dea:	83 e8 01             	sub    $0x1,%eax
80107ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107df5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107dfc:	00 
80107dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e00:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e04:	8b 45 08             	mov    0x8(%ebp),%eax
80107e07:	89 04 24             	mov    %eax,(%esp)
80107e0a:	e8 20 ff ff ff       	call   80107d2f <walkpgdir>
80107e0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e16:	75 07                	jne    80107e1f <mappages+0x4e>
      return -1;
80107e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e1d:	eb 48                	jmp    80107e67 <mappages+0x96>
    if(*pte & PTE_P)
80107e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e22:	8b 00                	mov    (%eax),%eax
80107e24:	83 e0 01             	and    $0x1,%eax
80107e27:	85 c0                	test   %eax,%eax
80107e29:	74 0c                	je     80107e37 <mappages+0x66>
      panic("remap");
80107e2b:	c7 04 24 9c 8c 10 80 	movl   $0x80108c9c,(%esp)
80107e32:	e8 03 87 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107e37:	8b 45 18             	mov    0x18(%ebp),%eax
80107e3a:	0b 45 14             	or     0x14(%ebp),%eax
80107e3d:	83 c8 01             	or     $0x1,%eax
80107e40:	89 c2                	mov    %eax,%edx
80107e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e45:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107e4d:	75 08                	jne    80107e57 <mappages+0x86>
      break;
80107e4f:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107e50:	b8 00 00 00 00       	mov    $0x0,%eax
80107e55:	eb 10                	jmp    80107e67 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107e57:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107e5e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107e65:	eb 8e                	jmp    80107df5 <mappages+0x24>
  return 0;
}
80107e67:	c9                   	leave  
80107e68:	c3                   	ret    

80107e69 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107e69:	55                   	push   %ebp
80107e6a:	89 e5                	mov    %esp,%ebp
80107e6c:	53                   	push   %ebx
80107e6d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107e70:	e8 7f ac ff ff       	call   80102af4 <kalloc>
80107e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e7c:	75 0a                	jne    80107e88 <setupkvm+0x1f>
    return 0;
80107e7e:	b8 00 00 00 00       	mov    $0x0,%eax
80107e83:	e9 98 00 00 00       	jmp    80107f20 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107e88:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e8f:	00 
80107e90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e97:	00 
80107e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e9b:	89 04 24             	mov    %eax,(%esp)
80107e9e:	e8 2f d4 ff ff       	call   801052d2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107ea3:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107eaa:	e8 fd f9 ff ff       	call   801078ac <p2v>
80107eaf:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107eb4:	76 0c                	jbe    80107ec2 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107eb6:	c7 04 24 a2 8c 10 80 	movl   $0x80108ca2,(%esp)
80107ebd:	e8 78 86 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ec2:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107ec9:	eb 49                	jmp    80107f14 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ece:	8b 48 0c             	mov    0xc(%eax),%ecx
80107ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed4:	8b 50 04             	mov    0x4(%eax),%edx
80107ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eda:	8b 58 08             	mov    0x8(%eax),%ebx
80107edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee0:	8b 40 04             	mov    0x4(%eax),%eax
80107ee3:	29 c3                	sub    %eax,%ebx
80107ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee8:	8b 00                	mov    (%eax),%eax
80107eea:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107eee:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ef2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107efd:	89 04 24             	mov    %eax,(%esp)
80107f00:	e8 cc fe ff ff       	call   80107dd1 <mappages>
80107f05:	85 c0                	test   %eax,%eax
80107f07:	79 07                	jns    80107f10 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107f09:	b8 00 00 00 00       	mov    $0x0,%eax
80107f0e:	eb 10                	jmp    80107f20 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f10:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107f14:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107f1b:	72 ae                	jb     80107ecb <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107f20:	83 c4 34             	add    $0x34,%esp
80107f23:	5b                   	pop    %ebx
80107f24:	5d                   	pop    %ebp
80107f25:	c3                   	ret    

80107f26 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107f26:	55                   	push   %ebp
80107f27:	89 e5                	mov    %esp,%ebp
80107f29:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f2c:	e8 38 ff ff ff       	call   80107e69 <setupkvm>
80107f31:	a3 38 bf 11 80       	mov    %eax,0x8011bf38
  switchkvm();
80107f36:	e8 02 00 00 00       	call   80107f3d <switchkvm>
}
80107f3b:	c9                   	leave  
80107f3c:	c3                   	ret    

80107f3d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107f3d:	55                   	push   %ebp
80107f3e:	89 e5                	mov    %esp,%ebp
80107f40:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107f43:	a1 38 bf 11 80       	mov    0x8011bf38,%eax
80107f48:	89 04 24             	mov    %eax,(%esp)
80107f4b:	e8 4f f9 ff ff       	call   8010789f <v2p>
80107f50:	89 04 24             	mov    %eax,(%esp)
80107f53:	e8 3c f9 ff ff       	call   80107894 <lcr3>
}
80107f58:	c9                   	leave  
80107f59:	c3                   	ret    

80107f5a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct thread *t)
{
80107f5a:	55                   	push   %ebp
80107f5b:	89 e5                	mov    %esp,%ebp
80107f5d:	53                   	push   %ebx
80107f5e:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107f61:	e8 6c d2 ff ff       	call   801051d2 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107f66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f6c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f73:	83 c2 08             	add    $0x8,%edx
80107f76:	89 d3                	mov    %edx,%ebx
80107f78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f7f:	83 c2 08             	add    $0x8,%edx
80107f82:	c1 ea 10             	shr    $0x10,%edx
80107f85:	89 d1                	mov    %edx,%ecx
80107f87:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f8e:	83 c2 08             	add    $0x8,%edx
80107f91:	c1 ea 18             	shr    $0x18,%edx
80107f94:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107f9b:	67 00 
80107f9d:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107fa4:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107faa:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107fb1:	83 e1 f0             	and    $0xfffffff0,%ecx
80107fb4:	83 c9 09             	or     $0x9,%ecx
80107fb7:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107fbd:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107fc4:	83 c9 10             	or     $0x10,%ecx
80107fc7:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107fcd:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107fd4:	83 e1 9f             	and    $0xffffff9f,%ecx
80107fd7:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107fdd:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107fe4:	83 c9 80             	or     $0xffffff80,%ecx
80107fe7:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107fed:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ff4:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ff7:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ffd:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108004:	83 e1 ef             	and    $0xffffffef,%ecx
80108007:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010800d:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108014:	83 e1 df             	and    $0xffffffdf,%ecx
80108017:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010801d:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108024:	83 c9 40             	or     $0x40,%ecx
80108027:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010802d:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108034:	83 e1 7f             	and    $0x7f,%ecx
80108037:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010803d:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108043:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108049:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108050:	83 e2 ef             	and    $0xffffffef,%edx
80108053:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108059:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010805f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)thread->kstack + KSTACKSIZE;
80108065:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010806b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108072:	8b 12                	mov    (%edx),%edx
80108074:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010807a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010807d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108084:	e8 e0 f7 ff ff       	call   80107869 <ltr>
  if(t->proc->pgdir == 0)
80108089:	8b 45 08             	mov    0x8(%ebp),%eax
8010808c:	8b 40 0c             	mov    0xc(%eax),%eax
8010808f:	8b 40 04             	mov    0x4(%eax),%eax
80108092:	85 c0                	test   %eax,%eax
80108094:	75 0c                	jne    801080a2 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108096:	c7 04 24 b3 8c 10 80 	movl   $0x80108cb3,(%esp)
8010809d:	e8 98 84 ff ff       	call   8010053a <panic>
  lcr3(v2p(t->proc->pgdir ));  // switch to new address space
801080a2:	8b 45 08             	mov    0x8(%ebp),%eax
801080a5:	8b 40 0c             	mov    0xc(%eax),%eax
801080a8:	8b 40 04             	mov    0x4(%eax),%eax
801080ab:	89 04 24             	mov    %eax,(%esp)
801080ae:	e8 ec f7 ff ff       	call   8010789f <v2p>
801080b3:	89 04 24             	mov    %eax,(%esp)
801080b6:	e8 d9 f7 ff ff       	call   80107894 <lcr3>

  popcli();
801080bb:	e8 56 d1 ff ff       	call   80105216 <popcli>
}
801080c0:	83 c4 14             	add    $0x14,%esp
801080c3:	5b                   	pop    %ebx
801080c4:	5d                   	pop    %ebp
801080c5:	c3                   	ret    

801080c6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801080c6:	55                   	push   %ebp
801080c7:	89 e5                	mov    %esp,%ebp
801080c9:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801080cc:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801080d3:	76 0c                	jbe    801080e1 <inituvm+0x1b>
    panic("inituvm: more than a page");
801080d5:	c7 04 24 c7 8c 10 80 	movl   $0x80108cc7,(%esp)
801080dc:	e8 59 84 ff ff       	call   8010053a <panic>
  mem = kalloc();
801080e1:	e8 0e aa ff ff       	call   80102af4 <kalloc>
801080e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801080e9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080f0:	00 
801080f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080f8:	00 
801080f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fc:	89 04 24             	mov    %eax,(%esp)
801080ff:	e8 ce d1 ff ff       	call   801052d2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108107:	89 04 24             	mov    %eax,(%esp)
8010810a:	e8 90 f7 ff ff       	call   8010789f <v2p>
8010810f:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108116:	00 
80108117:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010811b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108122:	00 
80108123:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010812a:	00 
8010812b:	8b 45 08             	mov    0x8(%ebp),%eax
8010812e:	89 04 24             	mov    %eax,(%esp)
80108131:	e8 9b fc ff ff       	call   80107dd1 <mappages>
  memmove(mem, init, sz);
80108136:	8b 45 10             	mov    0x10(%ebp),%eax
80108139:	89 44 24 08          	mov    %eax,0x8(%esp)
8010813d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108140:	89 44 24 04          	mov    %eax,0x4(%esp)
80108144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108147:	89 04 24             	mov    %eax,(%esp)
8010814a:	e8 52 d2 ff ff       	call   801053a1 <memmove>
}
8010814f:	c9                   	leave  
80108150:	c3                   	ret    

80108151 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108151:	55                   	push   %ebp
80108152:	89 e5                	mov    %esp,%ebp
80108154:	53                   	push   %ebx
80108155:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010815b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108160:	85 c0                	test   %eax,%eax
80108162:	74 0c                	je     80108170 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108164:	c7 04 24 e4 8c 10 80 	movl   $0x80108ce4,(%esp)
8010816b:	e8 ca 83 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108177:	e9 a9 00 00 00       	jmp    80108225 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010817c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108182:	01 d0                	add    %edx,%eax
80108184:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010818b:	00 
8010818c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108190:	8b 45 08             	mov    0x8(%ebp),%eax
80108193:	89 04 24             	mov    %eax,(%esp)
80108196:	e8 94 fb ff ff       	call   80107d2f <walkpgdir>
8010819b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010819e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081a2:	75 0c                	jne    801081b0 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801081a4:	c7 04 24 07 8d 10 80 	movl   $0x80108d07,(%esp)
801081ab:	e8 8a 83 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801081b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081b3:	8b 00                	mov    (%eax),%eax
801081b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801081bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c0:	8b 55 18             	mov    0x18(%ebp),%edx
801081c3:	29 c2                	sub    %eax,%edx
801081c5:	89 d0                	mov    %edx,%eax
801081c7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801081cc:	77 0f                	ja     801081dd <loaduvm+0x8c>
      n = sz - i;
801081ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d1:	8b 55 18             	mov    0x18(%ebp),%edx
801081d4:	29 c2                	sub    %eax,%edx
801081d6:	89 d0                	mov    %edx,%eax
801081d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081db:	eb 07                	jmp    801081e4 <loaduvm+0x93>
    else
      n = PGSIZE;
801081dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801081e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e7:	8b 55 14             	mov    0x14(%ebp),%edx
801081ea:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801081ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081f0:	89 04 24             	mov    %eax,(%esp)
801081f3:	e8 b4 f6 ff ff       	call   801078ac <p2v>
801081f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801081fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
801081ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108203:	89 44 24 04          	mov    %eax,0x4(%esp)
80108207:	8b 45 10             	mov    0x10(%ebp),%eax
8010820a:	89 04 24             	mov    %eax,(%esp)
8010820d:	e8 65 9b ff ff       	call   80101d77 <readi>
80108212:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108215:	74 07                	je     8010821e <loaduvm+0xcd>
      return -1;
80108217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010821c:	eb 18                	jmp    80108236 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010821e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108228:	3b 45 18             	cmp    0x18(%ebp),%eax
8010822b:	0f 82 4b ff ff ff    	jb     8010817c <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108231:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108236:	83 c4 24             	add    $0x24,%esp
80108239:	5b                   	pop    %ebx
8010823a:	5d                   	pop    %ebp
8010823b:	c3                   	ret    

8010823c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010823c:	55                   	push   %ebp
8010823d:	89 e5                	mov    %esp,%ebp
8010823f:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108242:	8b 45 10             	mov    0x10(%ebp),%eax
80108245:	85 c0                	test   %eax,%eax
80108247:	79 0a                	jns    80108253 <allocuvm+0x17>
    return 0;
80108249:	b8 00 00 00 00       	mov    $0x0,%eax
8010824e:	e9 c1 00 00 00       	jmp    80108314 <allocuvm+0xd8>
  if(newsz < oldsz)
80108253:	8b 45 10             	mov    0x10(%ebp),%eax
80108256:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108259:	73 08                	jae    80108263 <allocuvm+0x27>
    return oldsz;
8010825b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010825e:	e9 b1 00 00 00       	jmp    80108314 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108263:	8b 45 0c             	mov    0xc(%ebp),%eax
80108266:	05 ff 0f 00 00       	add    $0xfff,%eax
8010826b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108273:	e9 8d 00 00 00       	jmp    80108305 <allocuvm+0xc9>
    mem = kalloc();
80108278:	e8 77 a8 ff ff       	call   80102af4 <kalloc>
8010827d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108284:	75 2c                	jne    801082b2 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108286:	c7 04 24 25 8d 10 80 	movl   $0x80108d25,(%esp)
8010828d:	e8 0e 81 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108292:	8b 45 0c             	mov    0xc(%ebp),%eax
80108295:	89 44 24 08          	mov    %eax,0x8(%esp)
80108299:	8b 45 10             	mov    0x10(%ebp),%eax
8010829c:	89 44 24 04          	mov    %eax,0x4(%esp)
801082a0:	8b 45 08             	mov    0x8(%ebp),%eax
801082a3:	89 04 24             	mov    %eax,(%esp)
801082a6:	e8 6b 00 00 00       	call   80108316 <deallocuvm>
      return 0;
801082ab:	b8 00 00 00 00       	mov    $0x0,%eax
801082b0:	eb 62                	jmp    80108314 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801082b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082b9:	00 
801082ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082c1:	00 
801082c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c5:	89 04 24             	mov    %eax,(%esp)
801082c8:	e8 05 d0 ff ff       	call   801052d2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801082cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082d0:	89 04 24             	mov    %eax,(%esp)
801082d3:	e8 c7 f5 ff ff       	call   8010789f <v2p>
801082d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082db:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801082e2:	00 
801082e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
801082e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082ee:	00 
801082ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801082f3:	8b 45 08             	mov    0x8(%ebp),%eax
801082f6:	89 04 24             	mov    %eax,(%esp)
801082f9:	e8 d3 fa ff ff       	call   80107dd1 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801082fe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108308:	3b 45 10             	cmp    0x10(%ebp),%eax
8010830b:	0f 82 67 ff ff ff    	jb     80108278 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108311:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108314:	c9                   	leave  
80108315:	c3                   	ret    

80108316 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108316:	55                   	push   %ebp
80108317:	89 e5                	mov    %esp,%ebp
80108319:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010831c:	8b 45 10             	mov    0x10(%ebp),%eax
8010831f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108322:	72 08                	jb     8010832c <deallocuvm+0x16>
    return oldsz;
80108324:	8b 45 0c             	mov    0xc(%ebp),%eax
80108327:	e9 a4 00 00 00       	jmp    801083d0 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010832c:	8b 45 10             	mov    0x10(%ebp),%eax
8010832f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108334:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010833c:	e9 80 00 00 00       	jmp    801083c1 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108344:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010834b:	00 
8010834c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108350:	8b 45 08             	mov    0x8(%ebp),%eax
80108353:	89 04 24             	mov    %eax,(%esp)
80108356:	e8 d4 f9 ff ff       	call   80107d2f <walkpgdir>
8010835b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010835e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108362:	75 09                	jne    8010836d <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108364:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010836b:	eb 4d                	jmp    801083ba <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010836d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108370:	8b 00                	mov    (%eax),%eax
80108372:	83 e0 01             	and    $0x1,%eax
80108375:	85 c0                	test   %eax,%eax
80108377:	74 41                	je     801083ba <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010837c:	8b 00                	mov    (%eax),%eax
8010837e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108383:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108386:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010838a:	75 0c                	jne    80108398 <deallocuvm+0x82>
        panic("kfree");
8010838c:	c7 04 24 3d 8d 10 80 	movl   $0x80108d3d,(%esp)
80108393:	e8 a2 81 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108398:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010839b:	89 04 24             	mov    %eax,(%esp)
8010839e:	e8 09 f5 ff ff       	call   801078ac <p2v>
801083a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801083a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083a9:	89 04 24             	mov    %eax,(%esp)
801083ac:	e8 aa a6 ff ff       	call   80102a5b <kfree>
      *pte = 0;
801083b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801083ba:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083c7:	0f 82 74 ff ff ff    	jb     80108341 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801083cd:	8b 45 10             	mov    0x10(%ebp),%eax
}
801083d0:	c9                   	leave  
801083d1:	c3                   	ret    

801083d2 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801083d2:	55                   	push   %ebp
801083d3:	89 e5                	mov    %esp,%ebp
801083d5:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801083d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801083dc:	75 0c                	jne    801083ea <freevm+0x18>
    panic("freevm: no pgdir");
801083de:	c7 04 24 43 8d 10 80 	movl   $0x80108d43,(%esp)
801083e5:	e8 50 81 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801083ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083f1:	00 
801083f2:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801083f9:	80 
801083fa:	8b 45 08             	mov    0x8(%ebp),%eax
801083fd:	89 04 24             	mov    %eax,(%esp)
80108400:	e8 11 ff ff ff       	call   80108316 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010840c:	eb 48                	jmp    80108456 <freevm+0x84>
    if(pgdir[i] & PTE_P){
8010840e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108411:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108418:	8b 45 08             	mov    0x8(%ebp),%eax
8010841b:	01 d0                	add    %edx,%eax
8010841d:	8b 00                	mov    (%eax),%eax
8010841f:	83 e0 01             	and    $0x1,%eax
80108422:	85 c0                	test   %eax,%eax
80108424:	74 2c                	je     80108452 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108429:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108430:	8b 45 08             	mov    0x8(%ebp),%eax
80108433:	01 d0                	add    %edx,%eax
80108435:	8b 00                	mov    (%eax),%eax
80108437:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010843c:	89 04 24             	mov    %eax,(%esp)
8010843f:	e8 68 f4 ff ff       	call   801078ac <p2v>
80108444:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010844a:	89 04 24             	mov    %eax,(%esp)
8010844d:	e8 09 a6 ff ff       	call   80102a5b <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108452:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108456:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010845d:	76 af                	jbe    8010840e <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010845f:	8b 45 08             	mov    0x8(%ebp),%eax
80108462:	89 04 24             	mov    %eax,(%esp)
80108465:	e8 f1 a5 ff ff       	call   80102a5b <kfree>
}
8010846a:	c9                   	leave  
8010846b:	c3                   	ret    

8010846c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010846c:	55                   	push   %ebp
8010846d:	89 e5                	mov    %esp,%ebp
8010846f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108472:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108479:	00 
8010847a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108481:	8b 45 08             	mov    0x8(%ebp),%eax
80108484:	89 04 24             	mov    %eax,(%esp)
80108487:	e8 a3 f8 ff ff       	call   80107d2f <walkpgdir>
8010848c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010848f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108493:	75 0c                	jne    801084a1 <clearpteu+0x35>
    panic("clearpteu");
80108495:	c7 04 24 54 8d 10 80 	movl   $0x80108d54,(%esp)
8010849c:	e8 99 80 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801084a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a4:	8b 00                	mov    (%eax),%eax
801084a6:	83 e0 fb             	and    $0xfffffffb,%eax
801084a9:	89 c2                	mov    %eax,%edx
801084ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ae:	89 10                	mov    %edx,(%eax)
}
801084b0:	c9                   	leave  
801084b1:	c3                   	ret    

801084b2 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801084b2:	55                   	push   %ebp
801084b3:	89 e5                	mov    %esp,%ebp
801084b5:	53                   	push   %ebx
801084b6:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801084b9:	e8 ab f9 ff ff       	call   80107e69 <setupkvm>
801084be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084c5:	75 0a                	jne    801084d1 <copyuvm+0x1f>
    return 0;
801084c7:	b8 00 00 00 00       	mov    $0x0,%eax
801084cc:	e9 fd 00 00 00       	jmp    801085ce <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
801084d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084d8:	e9 d0 00 00 00       	jmp    801085ad <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801084dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084e7:	00 
801084e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801084ec:	8b 45 08             	mov    0x8(%ebp),%eax
801084ef:	89 04 24             	mov    %eax,(%esp)
801084f2:	e8 38 f8 ff ff       	call   80107d2f <walkpgdir>
801084f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084fe:	75 0c                	jne    8010850c <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108500:	c7 04 24 5e 8d 10 80 	movl   $0x80108d5e,(%esp)
80108507:	e8 2e 80 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
8010850c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850f:	8b 00                	mov    (%eax),%eax
80108511:	83 e0 01             	and    $0x1,%eax
80108514:	85 c0                	test   %eax,%eax
80108516:	75 0c                	jne    80108524 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108518:	c7 04 24 78 8d 10 80 	movl   $0x80108d78,(%esp)
8010851f:	e8 16 80 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108524:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108527:	8b 00                	mov    (%eax),%eax
80108529:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010852e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108531:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108534:	8b 00                	mov    (%eax),%eax
80108536:	25 ff 0f 00 00       	and    $0xfff,%eax
8010853b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010853e:	e8 b1 a5 ff ff       	call   80102af4 <kalloc>
80108543:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108546:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010854a:	75 02                	jne    8010854e <copyuvm+0x9c>
      goto bad;
8010854c:	eb 70                	jmp    801085be <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010854e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108551:	89 04 24             	mov    %eax,(%esp)
80108554:	e8 53 f3 ff ff       	call   801078ac <p2v>
80108559:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108560:	00 
80108561:	89 44 24 04          	mov    %eax,0x4(%esp)
80108565:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108568:	89 04 24             	mov    %eax,(%esp)
8010856b:	e8 31 ce ff ff       	call   801053a1 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108570:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108573:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108576:	89 04 24             	mov    %eax,(%esp)
80108579:	e8 21 f3 ff ff       	call   8010789f <v2p>
8010857e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108581:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108585:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108589:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108590:	00 
80108591:	89 54 24 04          	mov    %edx,0x4(%esp)
80108595:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108598:	89 04 24             	mov    %eax,(%esp)
8010859b:	e8 31 f8 ff ff       	call   80107dd1 <mappages>
801085a0:	85 c0                	test   %eax,%eax
801085a2:	79 02                	jns    801085a6 <copyuvm+0xf4>
      goto bad;
801085a4:	eb 18                	jmp    801085be <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801085a6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085b3:	0f 82 24 ff ff ff    	jb     801084dd <copyuvm+0x2b>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }

  return d;
801085b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085bc:	eb 10                	jmp    801085ce <copyuvm+0x11c>

bad:

  freevm(d);
801085be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085c1:	89 04 24             	mov    %eax,(%esp)
801085c4:	e8 09 fe ff ff       	call   801083d2 <freevm>
  return 0;
801085c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085ce:	83 c4 44             	add    $0x44,%esp
801085d1:	5b                   	pop    %ebx
801085d2:	5d                   	pop    %ebp
801085d3:	c3                   	ret    

801085d4 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801085d4:	55                   	push   %ebp
801085d5:	89 e5                	mov    %esp,%ebp
801085d7:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085e1:	00 
801085e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801085e9:	8b 45 08             	mov    0x8(%ebp),%eax
801085ec:	89 04 24             	mov    %eax,(%esp)
801085ef:	e8 3b f7 ff ff       	call   80107d2f <walkpgdir>
801085f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801085f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fa:	8b 00                	mov    (%eax),%eax
801085fc:	83 e0 01             	and    $0x1,%eax
801085ff:	85 c0                	test   %eax,%eax
80108601:	75 07                	jne    8010860a <uva2ka+0x36>
    return 0;
80108603:	b8 00 00 00 00       	mov    $0x0,%eax
80108608:	eb 25                	jmp    8010862f <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010860a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860d:	8b 00                	mov    (%eax),%eax
8010860f:	83 e0 04             	and    $0x4,%eax
80108612:	85 c0                	test   %eax,%eax
80108614:	75 07                	jne    8010861d <uva2ka+0x49>
    return 0;
80108616:	b8 00 00 00 00       	mov    $0x0,%eax
8010861b:	eb 12                	jmp    8010862f <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010861d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108620:	8b 00                	mov    (%eax),%eax
80108622:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108627:	89 04 24             	mov    %eax,(%esp)
8010862a:	e8 7d f2 ff ff       	call   801078ac <p2v>
}
8010862f:	c9                   	leave  
80108630:	c3                   	ret    

80108631 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108631:	55                   	push   %ebp
80108632:	89 e5                	mov    %esp,%ebp
80108634:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108637:	8b 45 10             	mov    0x10(%ebp),%eax
8010863a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010863d:	e9 87 00 00 00       	jmp    801086c9 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108642:	8b 45 0c             	mov    0xc(%ebp),%eax
80108645:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010864a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010864d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108650:	89 44 24 04          	mov    %eax,0x4(%esp)
80108654:	8b 45 08             	mov    0x8(%ebp),%eax
80108657:	89 04 24             	mov    %eax,(%esp)
8010865a:	e8 75 ff ff ff       	call   801085d4 <uva2ka>
8010865f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108662:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108666:	75 07                	jne    8010866f <copyout+0x3e>
      return -1;
80108668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010866d:	eb 69                	jmp    801086d8 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010866f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108672:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108675:	29 c2                	sub    %eax,%edx
80108677:	89 d0                	mov    %edx,%eax
80108679:	05 00 10 00 00       	add    $0x1000,%eax
8010867e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108684:	3b 45 14             	cmp    0x14(%ebp),%eax
80108687:	76 06                	jbe    8010868f <copyout+0x5e>
      n = len;
80108689:	8b 45 14             	mov    0x14(%ebp),%eax
8010868c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010868f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108692:	8b 55 0c             	mov    0xc(%ebp),%edx
80108695:	29 c2                	sub    %eax,%edx
80108697:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010869a:	01 c2                	add    %eax,%edx
8010869c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010869f:	89 44 24 08          	mov    %eax,0x8(%esp)
801086a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801086aa:	89 14 24             	mov    %edx,(%esp)
801086ad:	e8 ef cc ff ff       	call   801053a1 <memmove>
    len -= n;
801086b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b5:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801086b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086bb:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801086be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c1:	05 00 10 00 00       	add    $0x1000,%eax
801086c6:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801086c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801086cd:	0f 85 6f ff ff ff    	jne    80108642 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801086d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086d8:	c9                   	leave  
801086d9:	c3                   	ret    
