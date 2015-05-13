
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

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
8010003a:	c7 44 24 04 0c 8b 10 	movl   $0x80108b0c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 7f 53 00 00       	call   801053cd <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 15 11 80       	mov    0x80111594,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
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
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 2c 53 00 00       	call   801053ee <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 15 11 80       	mov    0x80111594,%eax
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
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 47 53 00 00       	call   80105450 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 55 4c 00 00       	call   80104d79 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 15 11 80       	mov    0x80111590,%eax
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
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 cf 52 00 00       	call   80105450 <release>
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
8010018f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 13 8b 10 80 	movl   $0x80108b13,(%esp)
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
801001ef:	c7 04 24 24 8b 10 80 	movl   $0x80108b24,(%esp)
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
80100229:	c7 04 24 2b 8b 10 80 	movl   $0x80108b2b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 ad 51 00 00       	call   801053ee <acquire>

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
8010025f:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 15 11 80       	mov    0x80111594,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 15 11 80       	mov    %eax,0x80111594

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
8010029d:	e8 cf 4b 00 00       	call   80104e71 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 a2 51 00 00       	call   80105450 <release>
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
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
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
801003a6:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bb:	e8 2e 50 00 00       	call   801053ee <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 32 8b 10 80 	movl   $0x80108b32,(%esp)
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
801004b0:	c7 45 ec 3b 8b 10 80 	movl   $0x80108b3b,-0x14(%ebp)
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
8010052c:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100533:	e8 18 4f 00 00       	call   80105450 <release>
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
80100545:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 42 8b 10 80 	movl   $0x80108b42,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 51 8b 10 80 	movl   $0x80108b51,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 0b 4f 00 00       	call   8010549f <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 53 8b 10 80 	movl   $0x80108b53,(%esp)
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
801005be:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
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
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
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
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 5a 50 00 00       	call   80105711 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 5c 4f 00 00       	call   80105642 <memset>
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
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
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
80100776:	e8 ce 69 00 00       	call   80107149 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 c2 69 00 00       	call   80107149 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 b6 69 00 00       	call   80107149 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 a9 69 00 00       	call   80107149 <uartputc>
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
801007b3:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
801007ba:	e8 2f 4c 00 00       	call   801053ee <acquire>
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
801007ea:	e8 44 47 00 00       	call   80104f33 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c 18 11 80       	mov    %eax,0x8011185c
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
80100810:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100816:	a1 58 18 11 80       	mov    0x80111858,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
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
8010083a:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100840:	a1 58 18 11 80       	mov    0x80111858,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c 18 11 80       	mov    %eax,0x8011185c
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
80100876:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010087c:	a1 54 18 11 80       	mov    0x80111854,%eax
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
8010089d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 17 11 80    	mov    %al,-0x7feee82c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008d5:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008e7:	a3 58 18 11 80       	mov    %eax,0x80111858
          wakeup(&input.r);
801008ec:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
801008f3:	e8 79 45 00 00       	call   80104e71 <wakeup>
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
8010090d:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100914:	e8 37 4b 00 00       	call   80105450 <release>
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
80100932:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100939:	e8 b0 4a 00 00       	call   801053ee <acquire>
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
80100955:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
8010095c:	e8 ef 4a 00 00       	call   80105450 <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 fe 0e 00 00       	call   8010186a <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a5 00 00 00       	jmp    80100a1b <consoleread+0x100>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 a0 17 11 	movl   $0x801117a0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
80100985:	e8 ef 43 00 00       	call   80104d79 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098a:	8b 15 54 18 11 80    	mov    0x80111854,%edx
80100990:	a1 58 18 11 80       	mov    0x80111858,%eax
80100995:	39 c2                	cmp    %eax,%edx
80100997:	74 ac                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100999:	a1 54 18 11 80       	mov    0x80111854,%eax
8010099e:	8d 50 01             	lea    0x1(%eax),%edx
801009a1:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009a7:	83 e0 7f             	and    $0x7f,%eax
801009aa:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
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
801009c5:	a1 54 18 11 80       	mov    0x80111854,%eax
801009ca:	83 e8 01             	sub    $0x1,%eax
801009cd:	a3 54 18 11 80       	mov    %eax,0x80111854
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
801009fa:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100a01:	e8 4a 4a 00 00       	call   80105450 <release>
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
80100a2e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a35:	e8 b4 49 00 00       	call   801053ee <acquire>
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
80100a68:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6f:	e8 dc 49 00 00       	call   80105450 <release>
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
80100a8a:	c7 44 24 04 57 8b 10 	movl   $0x80108b57,0x4(%esp)
80100a91:	80 
80100a92:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a99:	e8 2f 49 00 00       	call   801053cd <initlock>
  initlock(&input.lock, "input");
80100a9e:	c7 44 24 04 5f 8b 10 	movl   $0x80108b5f,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100aad:	e8 1b 49 00 00       	call   801053cd <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab2:	c7 05 0c 22 11 80 1d 	movl   $0x80100a1d,0x8011220c
80100ab9:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100abc:	c7 05 08 22 11 80 1b 	movl   $0x8010091b,0x80112208
80100ac3:	09 10 80 
  cons.locking = 1;
80100ac6:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
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
80100b76:	e8 1f 77 00 00       	call   8010829a <setupkvm>
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
80100c17:	e8 51 7a 00 00       	call   8010866d <allocuvm>
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
80100c55:	e8 28 79 00 00       	call   80108582 <loaduvm>
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
80100cc3:	e8 a5 79 00 00       	call   8010866d <allocuvm>
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
80100ce8:	e8 b0 7b 00 00       	call   8010889d <clearpteu>
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
80100d1e:	e8 89 4b 00 00       	call   801058ac <strlen>
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
80100d47:	e8 60 4b 00 00       	call   801058ac <strlen>
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
80100d77:	e8 e6 7c 00 00       	call   80108a62 <copyout>
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
80100e1e:	e8 3f 7c 00 00       	call   80108a62 <copyout>
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
80100e79:	e8 e4 49 00 00       	call   80105862 <safestrcpy>

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
80100ed4:	e8 b2 74 00 00       	call   8010838b <switchuvm>

  freevm(oldpgdir);
80100ed9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100edc:	89 04 24             	mov    %eax,(%esp)
80100edf:	e8 1f 79 00 00       	call   80108803 <freevm>
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
80100ef7:	e8 07 79 00 00       	call   80108803 <freevm>
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
80100f1f:	c7 44 24 04 65 8b 10 	movl   $0x80108b65,0x4(%esp)
80100f26:	80 
80100f27:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f2e:	e8 9a 44 00 00       	call   801053cd <initlock>
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
80100f3b:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f42:	e8 a7 44 00 00       	call   801053ee <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f47:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
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
80100f64:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f6b:	e8 e0 44 00 00       	call   80105450 <release>
      return f;
80100f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f73:	eb 1e                	jmp    80100f93 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f75:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f79:	81 7d f4 f4 21 11 80 	cmpl   $0x801121f4,-0xc(%ebp)
80100f80:	72 ce                	jb     80100f50 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f82:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f89:	e8 c2 44 00 00       	call   80105450 <release>
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
80100f9b:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fa2:	e8 47 44 00 00       	call   801053ee <acquire>
  if(f->ref < 1)
80100fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80100faa:	8b 40 04             	mov    0x4(%eax),%eax
80100fad:	85 c0                	test   %eax,%eax
80100faf:	7f 0c                	jg     80100fbd <filedup+0x28>
    panic("filedup");
80100fb1:	c7 04 24 6c 8b 10 80 	movl   $0x80108b6c,(%esp)
80100fb8:	e8 7d f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc0:	8b 40 04             	mov    0x4(%eax),%eax
80100fc3:	8d 50 01             	lea    0x1(%eax),%edx
80100fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc9:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fcc:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fd3:	e8 78 44 00 00       	call   80105450 <release>
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
80100fe3:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fea:	e8 ff 43 00 00       	call   801053ee <acquire>
  if(f->ref < 1)
80100fef:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff2:	8b 40 04             	mov    0x4(%eax),%eax
80100ff5:	85 c0                	test   %eax,%eax
80100ff7:	7f 0c                	jg     80101005 <fileclose+0x28>
    panic("fileclose");
80100ff9:	c7 04 24 74 8b 10 80 	movl   $0x80108b74,(%esp)
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
8010101e:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101025:	e8 26 44 00 00       	call   80105450 <release>
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
80101068:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
8010106f:	e8 dc 43 00 00       	call   80105450 <release>
  
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
801011b0:	c7 04 24 7e 8b 10 80 	movl   $0x80108b7e,(%esp)
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
801012bc:	c7 04 24 87 8b 10 80 	movl   $0x80108b87,(%esp)
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
801012ee:	c7 04 24 97 8b 10 80 	movl   $0x80108b97,(%esp)
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
80101334:	e8 d8 43 00 00       	call   80105711 <memmove>
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
8010137a:	e8 c3 42 00 00       	call   80105642 <memset>
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
801014d7:	c7 04 24 a1 8b 10 80 	movl   $0x80108ba1,(%esp)
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
80101569:	c7 04 24 b7 8b 10 80 	movl   $0x80108bb7,(%esp)
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
801015b9:	c7 44 24 04 ca 8b 10 	movl   $0x80108bca,0x4(%esp)
801015c0:	80 
801015c1:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015c8:	e8 00 3e 00 00       	call   801053cd <initlock>
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
8010164a:	e8 f3 3f 00 00       	call   80105642 <memset>
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
801016a0:	c7 04 24 d1 8b 10 80 	movl   $0x80108bd1,(%esp)
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
80101749:	e8 c3 3f 00 00       	call   80105711 <memmove>
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
8010176c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101773:	e8 76 3c 00 00       	call   801053ee <acquire>

  // Is the inode already cached?
  empty = 0;
80101778:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010177f:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
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
801017b6:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017bd:	e8 8e 3c 00 00       	call   80105450 <release>
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
801017e1:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
801017e8:	72 9e                	jb     80101788 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ee:	75 0c                	jne    801017fc <iget+0x96>
    panic("iget: no inodes");
801017f0:	c7 04 24 e3 8b 10 80 	movl   $0x80108be3,(%esp)
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
80101827:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010182e:	e8 1d 3c 00 00       	call   80105450 <release>

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
8010183e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101845:	e8 a4 3b 00 00       	call   801053ee <acquire>
  ip->ref++;
8010184a:	8b 45 08             	mov    0x8(%ebp),%eax
8010184d:	8b 40 08             	mov    0x8(%eax),%eax
80101850:	8d 50 01             	lea    0x1(%eax),%edx
80101853:	8b 45 08             	mov    0x8(%ebp),%eax
80101856:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101859:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101860:	e8 eb 3b 00 00       	call   80105450 <release>
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
80101880:	c7 04 24 f3 8b 10 80 	movl   $0x80108bf3,(%esp)
80101887:	e8 ae ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010188c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101893:	e8 56 3b 00 00       	call   801053ee <acquire>
  while(ip->flags & I_BUSY)
80101898:	eb 13                	jmp    801018ad <ilock+0x43>
    sleep(ip, &icache.lock);
8010189a:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018a1:	80 
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	89 04 24             	mov    %eax,(%esp)
801018a8:	e8 cc 34 00 00       	call   80104d79 <sleep>

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
801018cb:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018d2:	e8 79 3b 00 00       	call   80105450 <release>

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
8010197d:	e8 8f 3d 00 00       	call   80105711 <memmove>
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
801019aa:	c7 04 24 f9 8b 10 80 	movl   $0x80108bf9,(%esp)
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
801019db:	c7 04 24 08 8c 10 80 	movl   $0x80108c08,(%esp)
801019e2:	e8 53 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019e7:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801019ee:	e8 fb 39 00 00       	call   801053ee <acquire>
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
80101a0a:	e8 62 34 00 00       	call   80104e71 <wakeup>
  release(&icache.lock);
80101a0f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a16:	e8 35 3a 00 00       	call   80105450 <release>
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
80101a23:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a2a:	e8 bf 39 00 00       	call   801053ee <acquire>
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
80101a68:	c7 04 24 10 8c 10 80 	movl   $0x80108c10,(%esp)
80101a6f:	e8 c6 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a74:	8b 45 08             	mov    0x8(%ebp),%eax
80101a77:	8b 40 0c             	mov    0xc(%eax),%eax
80101a7a:	83 c8 01             	or     $0x1,%eax
80101a7d:	89 c2                	mov    %eax,%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a85:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a8c:	e8 bf 39 00 00       	call   80105450 <release>
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
80101ab0:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ab7:	e8 32 39 00 00       	call   801053ee <acquire>
    ip->flags = 0;
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	89 04 24             	mov    %eax,(%esp)
80101acc:	e8 a0 33 00 00       	call   80104e71 <wakeup>
  }
  ip->ref--;
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	8b 40 08             	mov    0x8(%eax),%eax
80101ad7:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae0:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ae7:	e8 64 39 00 00       	call   80105450 <release>
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
80101c07:	c7 04 24 1a 8c 10 80 	movl   $0x80108c1a,(%esp)
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
80101dab:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 0a                	jne    80101dc0 <readi+0x49>
      return -1;
80101db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dbb:	e9 19 01 00 00       	jmp    80101ed9 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc7:	98                   	cwtl   
80101dc8:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
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
80101ea8:	e8 64 38 00 00       	call   80105711 <memmove>
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
80101f0f:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f16:	85 c0                	test   %eax,%eax
80101f18:	75 0a                	jne    80101f24 <writei+0x49>
      return -1;
80101f1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1f:	e9 44 01 00 00       	jmp    80102068 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f24:	8b 45 08             	mov    0x8(%ebp),%eax
80101f27:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2b:	98                   	cwtl   
80101f2c:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
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
80102007:	e8 05 37 00 00       	call   80105711 <memmove>
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
80102085:	e8 2a 37 00 00       	call   801057b4 <strncmp>
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
8010209f:	c7 04 24 2d 8c 10 80 	movl   $0x80108c2d,(%esp)
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
801020dd:	c7 04 24 3f 8c 10 80 	movl   $0x80108c3f,(%esp)
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
801021c2:	c7 04 24 3f 8c 10 80 	movl   $0x80108c3f,(%esp)
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
80102207:	e8 fe 35 00 00       	call   8010580a <strncpy>
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
80102239:	c7 04 24 4c 8c 10 80 	movl   $0x80108c4c,(%esp)
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
801022be:	e8 4e 34 00 00       	call   80105711 <memmove>
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
801022d9:	e8 33 34 00 00       	call   80105711 <memmove>
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
8010252b:	c7 44 24 04 54 8c 10 	movl   $0x80108c54,0x4(%esp)
80102532:	80 
80102533:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010253a:	e8 8e 2e 00 00       	call   801053cd <initlock>
  picenable(IRQ_IDE);
8010253f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102546:	e8 7b 18 00 00       	call   80103dc6 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254b:	a1 60 39 11 80       	mov    0x80113960,%eax
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
8010259c:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
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
801025d7:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
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
801026f6:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026fd:	e8 ec 2c 00 00       	call   801053ee <acquire>
  if((b = idequeue) == 0){
80102702:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102707:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270e:	75 11                	jne    80102721 <ideintr+0x31>
    release(&idelock);
80102710:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102717:	e8 34 2d 00 00       	call   80105450 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271c:	e9 90 00 00 00       	jmp    801027b1 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102724:	8b 40 14             	mov    0x14(%eax),%eax
80102727:	a3 54 c6 10 80       	mov    %eax,0x8010c654

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
8010278a:	e8 e2 26 00 00       	call   80104e71 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010278f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102794:	85 c0                	test   %eax,%eax
80102796:	74 0d                	je     801027a5 <ideintr+0xb5>
    idestart(idequeue);
80102798:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010279d:	89 04 24             	mov    %eax,(%esp)
801027a0:	e8 26 fe ff ff       	call   801025cb <idestart>

  release(&idelock);
801027a5:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027ac:	e8 9f 2c 00 00       	call   80105450 <release>
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
801027c5:	c7 04 24 61 8c 10 80 	movl   $0x80108c61,(%esp)
801027cc:	e8 69 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d1:	8b 45 08             	mov    0x8(%ebp),%eax
801027d4:	8b 00                	mov    (%eax),%eax
801027d6:	83 e0 06             	and    $0x6,%eax
801027d9:	83 f8 02             	cmp    $0x2,%eax
801027dc:	75 0c                	jne    801027ea <iderw+0x37>
    panic("iderw: nothing to do");
801027de:	c7 04 24 75 8c 10 80 	movl   $0x80108c75,(%esp)
801027e5:	e8 50 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027ea:	8b 45 08             	mov    0x8(%ebp),%eax
801027ed:	8b 40 04             	mov    0x4(%eax),%eax
801027f0:	85 c0                	test   %eax,%eax
801027f2:	74 15                	je     80102809 <iderw+0x56>
801027f4:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	75 0c                	jne    80102809 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fd:	c7 04 24 8a 8c 10 80 	movl   $0x80108c8a,(%esp)
80102804:	e8 31 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102809:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102810:	e8 d9 2b 00 00       	call   801053ee <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102815:	8b 45 08             	mov    0x8(%ebp),%eax
80102818:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010281f:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
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
80102844:	a1 54 c6 10 80       	mov    0x8010c654,%eax
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
8010285d:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102864:	80 
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
80102868:	89 04 24             	mov    %eax,(%esp)
8010286b:	e8 09 25 00 00       	call   80104d79 <sleep>
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
8010287d:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102884:	e8 c7 2b 00 00       	call   80105450 <release>
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
8010288e:	a1 34 32 11 80       	mov    0x80113234,%eax
80102893:	8b 55 08             	mov    0x8(%ebp),%edx
80102896:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102898:	a1 34 32 11 80       	mov    0x80113234,%eax
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
801028a5:	a1 34 32 11 80       	mov    0x80113234,%eax
801028aa:	8b 55 08             	mov    0x8(%ebp),%edx
801028ad:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028af:	a1 34 32 11 80       	mov    0x80113234,%eax
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
801028c2:	a1 64 33 11 80       	mov    0x80113364,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 05                	jne    801028d0 <ioapicinit+0x14>
    return;
801028cb:	e9 9d 00 00 00       	jmp    8010296d <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d0:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
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
80102903:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
8010290a:	0f b6 c0             	movzbl %al,%eax
8010290d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102910:	74 0c                	je     8010291e <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102912:	c7 04 24 a8 8c 10 80 	movl   $0x80108ca8,(%esp)
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
80102975:	a1 64 33 11 80       	mov    0x80113364,%eax
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
801029cc:	c7 44 24 04 da 8c 10 	movl   $0x80108cda,0x4(%esp)
801029d3:	80 
801029d4:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801029db:	e8 ed 29 00 00       	call   801053cd <initlock>
  kmem.use_lock = 0;
801029e0:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
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
80102a16:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
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
80102a6d:	81 7d 08 5c cf 11 80 	cmpl   $0x8011cf5c,0x8(%ebp)
80102a74:	72 12                	jb     80102a88 <kfree+0x2d>
80102a76:	8b 45 08             	mov    0x8(%ebp),%eax
80102a79:	89 04 24             	mov    %eax,(%esp)
80102a7c:	e8 38 ff ff ff       	call   801029b9 <v2p>
80102a81:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a86:	76 0c                	jbe    80102a94 <kfree+0x39>
    panic("kfree");
80102a88:	c7 04 24 df 8c 10 80 	movl   $0x80108cdf,(%esp)
80102a8f:	e8 a6 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a9b:	00 
80102a9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aa3:	00 
80102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa7:	89 04 24             	mov    %eax,(%esp)
80102aaa:	e8 93 2b 00 00       	call   80105642 <memset>

  if(kmem.use_lock)
80102aaf:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ab4:	85 c0                	test   %eax,%eax
80102ab6:	74 0c                	je     80102ac4 <kfree+0x69>
    acquire(&kmem.lock);
80102ab8:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102abf:	e8 2a 29 00 00       	call   801053ee <acquire>
  r = (struct run*)v;
80102ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aca:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad3:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102add:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ae2:	85 c0                	test   %eax,%eax
80102ae4:	74 0c                	je     80102af2 <kfree+0x97>
    release(&kmem.lock);
80102ae6:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102aed:	e8 5e 29 00 00       	call   80105450 <release>
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
80102afa:	a1 74 32 11 80       	mov    0x80113274,%eax
80102aff:	85 c0                	test   %eax,%eax
80102b01:	74 0c                	je     80102b0f <kalloc+0x1b>
    acquire(&kmem.lock);
80102b03:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b0a:	e8 df 28 00 00       	call   801053ee <acquire>
  r = kmem.freelist;
80102b0f:	a1 78 32 11 80       	mov    0x80113278,%eax
80102b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b1b:	74 0a                	je     80102b27 <kalloc+0x33>
    kmem.freelist = r->next;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	8b 00                	mov    (%eax),%eax
80102b22:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b27:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b2c:	85 c0                	test   %eax,%eax
80102b2e:	74 0c                	je     80102b3c <kalloc+0x48>
    release(&kmem.lock);
80102b30:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b37:	e8 14 29 00 00       	call   80105450 <release>
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
80102ba5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102baa:	83 c8 40             	or     $0x40,%eax
80102bad:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
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
80102bc8:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102be5:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bea:	0f b6 00             	movzbl (%eax),%eax
80102bed:	83 c8 40             	or     $0x40,%eax
80102bf0:	0f b6 c0             	movzbl %al,%eax
80102bf3:	f7 d0                	not    %eax
80102bf5:	89 c2                	mov    %eax,%edx
80102bf7:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bfc:	21 d0                	and    %edx,%eax
80102bfe:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c03:	b8 00 00 00 00       	mov    $0x0,%eax
80102c08:	e9 a2 00 00 00       	jmp    80102caf <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c0d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c12:	83 e0 40             	and    $0x40,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	74 14                	je     80102c2d <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c19:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c20:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c25:	83 e0 bf             	and    $0xffffffbf,%eax
80102c28:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c30:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c35:	0f b6 00             	movzbl (%eax),%eax
80102c38:	0f b6 d0             	movzbl %al,%edx
80102c3b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c40:	09 d0                	or     %edx,%eax
80102c42:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4a:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c4f:	0f b6 00             	movzbl (%eax),%eax
80102c52:	0f b6 d0             	movzbl %al,%edx
80102c55:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c5a:	31 d0                	xor    %edx,%eax
80102c5c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c61:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c66:	83 e0 03             	and    $0x3,%eax
80102c69:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c73:	01 d0                	add    %edx,%eax
80102c75:	0f b6 00             	movzbl (%eax),%eax
80102c78:	0f b6 c0             	movzbl %al,%eax
80102c7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c7e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102d13:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d18:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1b:	c1 e2 02             	shl    $0x2,%edx
80102d1e:	01 c2                	add    %eax,%edx
80102d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d23:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d25:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102d37:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102dbd:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102e5f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102e9e:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102ea3:	8d 50 01             	lea    0x1(%eax),%edx
80102ea6:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102eac:	85 c0                	test   %eax,%eax
80102eae:	75 13                	jne    80102ec3 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb0:	8b 45 04             	mov    0x4(%ebp),%eax
80102eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb7:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
80102ebe:	e8 dd d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ec3:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ec8:	85 c0                	test   %eax,%eax
80102eca:	74 0f                	je     80102edb <cpunum+0x51>
    return lapic[ID]>>24;
80102ecc:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102ee8:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
8010311a:	e8 9a 25 00 00       	call   801056b9 <memcmp>
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
8010321a:	c7 44 24 04 14 8d 10 	movl   $0x80108d14,0x4(%esp)
80103221:	80 
80103222:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103229:	e8 9f 21 00 00       	call   801053cd <initlock>
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
8010324b:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103253:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
80103258:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
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
8010327b:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103284:	01 d0                	add    %edx,%eax
80103286:	83 c0 01             	add    $0x1,%eax
80103289:	89 c2                	mov    %eax,%edx
8010328b:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103290:	89 54 24 04          	mov    %edx,0x4(%esp)
80103294:	89 04 24             	mov    %eax,(%esp)
80103297:	e8 0a cf ff ff       	call   801001a6 <bread>
8010329c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032a2:	83 c0 10             	add    $0x10,%eax
801032a5:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801032ac:	89 c2                	mov    %eax,%edx
801032ae:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801032dd:	e8 2f 24 00 00       	call   80105711 <memmove>
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
80103307:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
8010331d:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103322:	89 c2                	mov    %eax,%edx
80103324:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103346:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010334b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103352:	eb 1b                	jmp    8010336f <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103357:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010335a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103361:	83 c2 10             	add    $0x10,%edx
80103364:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010336b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336f:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
8010338c:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103391:	89 c2                	mov    %eax,%edx
80103393:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801033b0:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b9:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033c2:	eb 1b                	jmp    801033df <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033c7:	83 c0 10             	add    $0x10,%eax
801033ca:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
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
801033df:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103411:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
80103428:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010342f:	e8 ba 1f 00 00       	call   801053ee <acquire>
  while(1){
    if(log.committing){
80103434:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103439:	85 c0                	test   %eax,%eax
8010343b:	74 16                	je     80103453 <begin_op+0x31>
      sleep(&log, &log.lock);
8010343d:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103444:	80 
80103445:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010344c:	e8 28 19 00 00       	call   80104d79 <sleep>
80103451:	eb 4f                	jmp    801034a2 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103453:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
80103459:	a1 bc 32 11 80       	mov    0x801132bc,%eax
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
80103471:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103478:	80 
80103479:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103480:	e8 f4 18 00 00       	call   80104d79 <sleep>
80103485:	eb 1b                	jmp    801034a2 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103487:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010348c:	83 c0 01             	add    $0x1,%eax
8010348f:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103494:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010349b:	e8 b0 1f 00 00       	call   80105450 <release>
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
801034b3:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034ba:	e8 2f 1f 00 00       	call   801053ee <acquire>
  log.outstanding -= 1;
801034bf:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034c4:	83 e8 01             	sub    $0x1,%eax
801034c7:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801034cc:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034d1:	85 c0                	test   %eax,%eax
801034d3:	74 0c                	je     801034e1 <end_op+0x3b>
    panic("log.committing");
801034d5:	c7 04 24 18 8d 10 80 	movl   $0x80108d18,(%esp)
801034dc:	e8 59 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034e1:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034e6:	85 c0                	test   %eax,%eax
801034e8:	75 13                	jne    801034fd <end_op+0x57>
    do_commit = 1;
801034ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801034f1:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801034f8:	00 00 00 
801034fb:	eb 0c                	jmp    80103509 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801034fd:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103504:	e8 68 19 00 00       	call   80104e71 <wakeup>
  }
  release(&log.lock);
80103509:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103510:	e8 3b 1f 00 00       	call   80105450 <release>

  if(do_commit){
80103515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103519:	74 33                	je     8010354e <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010351b:	e8 de 00 00 00       	call   801035fe <commit>
    acquire(&log.lock);
80103520:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103527:	e8 c2 1e 00 00       	call   801053ee <acquire>
    log.committing = 0;
8010352c:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103533:	00 00 00 
    wakeup(&log);
80103536:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010353d:	e8 2f 19 00 00       	call   80104e71 <wakeup>
    release(&log.lock);
80103542:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103549:	e8 02 1f 00 00       	call   80105450 <release>
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
80103562:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	83 c0 01             	add    $0x1,%eax
80103570:	89 c2                	mov    %eax,%edx
80103572:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103577:	89 54 24 04          	mov    %edx,0x4(%esp)
8010357b:	89 04 24             	mov    %eax,(%esp)
8010357e:	e8 23 cc ff ff       	call   801001a6 <bread>
80103583:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103589:	83 c0 10             	add    $0x10,%eax
8010358c:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103593:	89 c2                	mov    %eax,%edx
80103595:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801035c4:	e8 48 21 00 00       	call   80105711 <memmove>
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
801035ee:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103604:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103609:	85 c0                	test   %eax,%eax
8010360b:	7e 1e                	jle    8010362b <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010360d:	e8 3e ff ff ff       	call   80103550 <write_log>
    write_head();    // Write header to disk -- the real commit
80103612:	e8 6f fd ff ff       	call   80103386 <write_head>
    install_trans(); // Now install writes to home locations
80103617:	e8 4d fc ff ff       	call   80103269 <install_trans>
    log.lh.n = 0; 
8010361c:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
80103633:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103638:	83 f8 1d             	cmp    $0x1d,%eax
8010363b:	7f 12                	jg     8010364f <log_write+0x22>
8010363d:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103642:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103648:	83 ea 01             	sub    $0x1,%edx
8010364b:	39 d0                	cmp    %edx,%eax
8010364d:	7c 0c                	jl     8010365b <log_write+0x2e>
    panic("too big a transaction");
8010364f:	c7 04 24 27 8d 10 80 	movl   $0x80108d27,(%esp)
80103656:	e8 df ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010365b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103660:	85 c0                	test   %eax,%eax
80103662:	7f 0c                	jg     80103670 <log_write+0x43>
    panic("log_write outside of trans");
80103664:	c7 04 24 3d 8d 10 80 	movl   $0x80108d3d,(%esp)
8010366b:	e8 ca ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103670:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103677:	e8 72 1d 00 00       	call   801053ee <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010367c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103683:	eb 1f                	jmp    801036a4 <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103688:	83 c0 10             	add    $0x10,%eax
8010368b:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
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
801036a4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801036ba:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
801036c1:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c9:	75 0d                	jne    801036d8 <log_write+0xab>
    log.lh.n++;
801036cb:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036d0:	83 c0 01             	add    $0x1,%eax
801036d3:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801036d8:	8b 45 08             	mov    0x8(%ebp),%eax
801036db:	8b 00                	mov    (%eax),%eax
801036dd:	83 c8 04             	or     $0x4,%eax
801036e0:	89 c2                	mov    %eax,%edx
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801036e7:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801036ee:	e8 5d 1d 00 00       	call   80105450 <release>
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
8010373a:	c7 04 24 5c cf 11 80 	movl   $0x8011cf5c,(%esp)
80103741:	e8 80 f2 ff ff       	call   801029c6 <kinit1>
  kvmalloc();      // kernel page table
80103746:	e8 0c 4c 00 00       	call   80108357 <kvmalloc>
  mpinit();        // collect info about this machine
8010374b:	e8 46 04 00 00       	call   80103b96 <mpinit>
  lapicinit();
80103750:	e8 dc f5 ff ff       	call   80102d31 <lapicinit>
  seginit();       // set up segments
80103755:	e8 90 45 00 00       	call   80107cea <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010375a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103760:	0f b6 00             	movzbl (%eax),%eax
80103763:	0f b6 c0             	movzbl %al,%eax
80103766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010376a:	c7 04 24 58 8d 10 80 	movl   $0x80108d58,(%esp)
80103771:	e8 2a cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103776:	e8 79 06 00 00       	call   80103df4 <picinit>
  ioapicinit();    // another interrupt controller
8010377b:	e8 3c f1 ff ff       	call   801028bc <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103780:	e8 ff d2 ff ff       	call   80100a84 <consoleinit>
  uartinit();      // serial port
80103785:	e8 af 38 00 00       	call   80107039 <uartinit>
  pinit();         // process table
8010378a:	e8 75 0b 00 00       	call   80104304 <pinit>
  tvinit();        // trap vectors
8010378f:	e8 01 34 00 00       	call   80106b95 <tvinit>
  binit();         // buffer cache
80103794:	e8 9b c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103799:	e8 7b d7 ff ff       	call   80100f19 <fileinit>
  iinit();         // inode cache
8010379e:	e8 10 de ff ff       	call   801015b3 <iinit>
  ideinit();       // disk
801037a3:	e8 7d ed ff ff       	call   80102525 <ideinit>
  if(!ismp)
801037a8:	a1 64 33 11 80       	mov    0x80113364,%eax
801037ad:	85 c0                	test   %eax,%eax
801037af:	75 05                	jne    801037b6 <main+0x8d>
    timerinit();   // uniprocessor timer
801037b1:	e8 2a 33 00 00       	call   80106ae0 <timerinit>
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
801037df:	e8 8a 4b 00 00       	call   8010836e <switchkvm>
  seginit();
801037e4:	e8 01 45 00 00       	call   80107cea <seginit>
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
80103809:	c7 04 24 6f 8d 10 80 	movl   $0x80108d6f,(%esp)
80103810:	e8 8b cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103815:	e8 ef 34 00 00       	call   80106d09 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010381a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103820:	05 a8 00 00 00       	add    $0xa8,%eax
80103825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010382c:	00 
8010382d:	89 04 24             	mov    %eax,(%esp)
80103830:	e8 da fe ff ff       	call   8010370f <xchg>
  scheduler();     // start running processes
80103835:	e8 54 13 00 00       	call   80104b8e <scheduler>

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
80103859:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103860:	80 
80103861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103864:	89 04 24             	mov    %eax,(%esp)
80103867:	e8 a5 1e 00 00       	call   80105711 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010386c:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103873:	e9 85 00 00 00       	jmp    801038fd <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103878:	e8 0d f6 ff ff       	call   80102e8a <cpunum>
8010387d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103883:	05 80 33 11 80       	add    $0x80113380,%eax
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
801038ba:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
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
801038fd:	a1 60 39 11 80       	mov    0x80113960,%eax
80103902:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103908:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103967:	a1 64 c6 10 80       	mov    0x8010c664,%eax
8010396c:	89 c2                	mov    %eax,%edx
8010396e:	b8 80 33 11 80       	mov    $0x80113380,%eax
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
801039e9:	c7 44 24 04 80 8d 10 	movl   $0x80108d80,0x4(%esp)
801039f0:	80 
801039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f4:	89 04 24             	mov    %eax,(%esp)
801039f7:	e8 bd 1c 00 00       	call   801056b9 <memcmp>
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
80103b2a:	c7 44 24 04 85 8d 10 	movl   $0x80108d85,0x4(%esp)
80103b31:	80 
80103b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b35:	89 04 24             	mov    %eax,(%esp)
80103b38:	e8 7c 1b 00 00       	call   801056b9 <memcmp>
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
80103b9c:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103ba3:	33 11 80 
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
80103bbf:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103bc6:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcc:	8b 40 24             	mov    0x24(%eax),%eax
80103bcf:	a3 7c 32 11 80       	mov    %eax,0x8011327c
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
80103c06:	8b 04 85 c8 8d 10 80 	mov    -0x7fef7238(,%eax,4),%eax
80103c0d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c12:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c18:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c1c:	0f b6 d0             	movzbl %al,%edx
80103c1f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c24:	39 c2                	cmp    %eax,%edx
80103c26:	74 2d                	je     80103c55 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c2f:	0f b6 d0             	movzbl %al,%edx
80103c32:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c37:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c3f:	c7 04 24 8a 8d 10 80 	movl   $0x80108d8a,(%esp)
80103c46:	e8 55 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c4b:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103c66:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c6b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c71:	05 80 33 11 80       	add    $0x80113380,%eax
80103c76:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103c7b:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103c81:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c86:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c8c:	81 c2 80 33 11 80    	add    $0x80113380,%edx
80103c92:	88 02                	mov    %al,(%edx)
      ncpu++;
80103c94:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c99:	83 c0 01             	add    $0x1,%eax
80103c9c:	a3 60 39 11 80       	mov    %eax,0x80113960
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
80103cb4:	a2 60 33 11 80       	mov    %al,0x80113360
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
80103cd2:	c7 04 24 a8 8d 10 80 	movl   $0x80108da8,(%esp)
80103cd9:	e8 c2 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cde:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103cf4:	a1 64 33 11 80       	mov    0x80113364,%eax
80103cf9:	85 c0                	test   %eax,%eax
80103cfb:	75 1d                	jne    80103d1a <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103cfd:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103d04:	00 00 00 
    lapic = 0;
80103d07:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103d0e:	00 00 00 
    ioapicid = 0;
80103d11:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
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
80103d8c:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
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
80103dde:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
80103f12:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f19:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f1d:	74 12                	je     80103f31 <picinit+0x13d>
    picsetmask(irqmask);
80103f1f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
80103fcb:	c7 44 24 04 dc 8d 10 	movl   $0x80108ddc,0x4(%esp)
80103fd2:	80 
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 f2 13 00 00       	call   801053cd <initlock>
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
80104082:	e8 67 13 00 00       	call   801053ee <acquire>
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
801040a5:	e8 c7 0d 00 00       	call   80104e71 <wakeup>
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
801040c4:	e8 a8 0d 00 00       	call   80104e71 <wakeup>
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
801040e9:	e8 62 13 00 00       	call   80105450 <release>
    kfree((char*)p);
801040ee:	8b 45 08             	mov    0x8(%ebp),%eax
801040f1:	89 04 24             	mov    %eax,(%esp)
801040f4:	e8 62 e9 ff ff       	call   80102a5b <kfree>
801040f9:	eb 0b                	jmp    80104106 <pipeclose+0x90>
  } else
    release(&p->lock);
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	89 04 24             	mov    %eax,(%esp)
80104101:	e8 4a 13 00 00       	call   80105450 <release>
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
80104114:	e8 d5 12 00 00       	call   801053ee <acquire>
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
8010414a:	e8 01 13 00 00       	call   80105450 <release>
        return -1;
8010414f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104154:	e9 9f 00 00 00       	jmp    801041f8 <pipewrite+0xf0>
      }
      wakeup(&p->nread);
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	05 34 02 00 00       	add    $0x234,%eax
80104161:	89 04 24             	mov    %eax,(%esp)
80104164:	e8 08 0d 00 00       	call   80104e71 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	8b 55 08             	mov    0x8(%ebp),%edx
8010416f:	81 c2 38 02 00 00    	add    $0x238,%edx
80104175:	89 44 24 04          	mov    %eax,0x4(%esp)
80104179:	89 14 24             	mov    %edx,(%esp)
8010417c:	e8 f8 0b 00 00       	call   80104d79 <sleep>
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
801041e5:	e8 87 0c 00 00       	call   80104e71 <wakeup>
  release(&p->lock);
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	89 04 24             	mov    %eax,(%esp)
801041f0:	e8 5b 12 00 00       	call   80105450 <release>
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
80104207:	e8 e2 11 00 00       	call   801053ee <acquire>
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
80104224:	e8 27 12 00 00       	call   80105450 <release>
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
80104246:	e8 2e 0b 00 00       	call   80104d79 <sleep>
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
801042d5:	e8 97 0b 00 00       	call   80104e71 <wakeup>
  release(&p->lock);
801042da:	8b 45 08             	mov    0x8(%ebp),%eax
801042dd:	89 04 24             	mov    %eax,(%esp)
801042e0:	e8 6b 11 00 00       	call   80105450 <release>
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
8010430a:	c7 44 24 04 e1 8d 10 	movl   $0x80108de1,0x4(%esp)
80104311:	80 
80104312:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104319:	e8 af 10 00 00       	call   801053cd <initlock>
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
80104326:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010432d:	e8 bc 10 00 00       	call   801053ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104332:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
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
8010437c:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104381:	8d 50 01             	lea    0x1(%eax),%edx
80104384:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010438a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438d:	89 42 0c             	mov    %eax,0xc(%edx)
  threads->pid =nextpid++;
80104390:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104395:	8d 50 01             	lea    0x1(%eax),%edx
80104398:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010439e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043a1:	89 42 08             	mov    %eax,0x8(%edx)

  release(&ptable.lock);
801043a4:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043ab:	e8 a0 10 00 00       	call   80105450 <release>

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
801043cc:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
801043d3:	0f 82 65 ff ff ff    	jb     8010433e <allocproc+0x1e>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801043d9:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043e0:	e8 6b 10 00 00       	call   80105450 <release>
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
80104425:	ba 50 6b 10 80       	mov    $0x80106b50,%edx
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
80104455:	e8 e8 11 00 00       	call   80105642 <memset>
  threads->context->eip = (uint)forkret;
8010445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010445d:	8b 40 14             	mov    0x14(%eax),%eax
80104460:	ba 4d 4d 10 80       	mov    $0x80104d4d,%edx
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
8010447e:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104483:	e8 12 3e 00 00       	call   8010829a <setupkvm>
80104488:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010448b:	89 42 04             	mov    %eax,0x4(%edx)
8010448e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104491:	8b 40 04             	mov    0x4(%eax),%eax
80104494:	85 c0                	test   %eax,%eax
80104496:	75 0c                	jne    801044a4 <userinit+0x37>
    panic("userinit: out of memory?");
80104498:	c7 04 24 e8 8d 10 80 	movl   $0x80108de8,(%esp)
8010449f:	e8 96 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044a4:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ac:	8b 40 04             	mov    0x4(%eax),%eax
801044af:	89 54 24 08          	mov    %edx,0x8(%esp)
801044b3:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801044ba:	80 
801044bb:	89 04 24             	mov    %eax,(%esp)
801044be:	e8 34 40 00 00       	call   801084f7 <inituvm>
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
801044e8:	e8 55 11 00 00       	call   80105642 <memset>
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
8010457d:	c7 44 24 04 01 8e 10 	movl   $0x80108e01,0x4(%esp)
80104584:	80 
80104585:	89 04 24             	mov    %eax,(%esp)
80104588:	e8 d5 12 00 00       	call   80105862 <safestrcpy>
  p->cwd = namei("/");
8010458d:	c7 04 24 0a 8e 10 80 	movl   $0x80108e0a,(%esp)
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
801045fe:	e8 6a 40 00 00       	call   8010866d <allocuvm>
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
80104635:	e8 0d 41 00 00       	call   80108747 <deallocuvm>
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
8010465b:	e8 2b 3d 00 00       	call   8010838b <switchuvm>
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
801046af:	e8 2f 42 00 00       	call   801088e3 <copyuvm>
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
801047b4:	e8 a9 10 00 00       	call   80105862 <safestrcpy>
 
  pid = np->pid;
801047b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047bc:	8b 40 0c             	mov    0xc(%eax),%eax
801047bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  nt->pid= nextpid++;
801047c2:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801047c7:	8d 50 01             	lea    0x1(%eax),%edx
801047ca:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801047d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801047d3:	89 42 08             	mov    %eax,0x8(%edx)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801047d6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801047dd:	e8 0c 0c 00 00       	call   801053ee <acquire>
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
80104803:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010480a:	e8 41 0c 00 00       	call   80105450 <release>
  
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
80104841:	c7 04 24 0c 8e 10 80 	movl   $0x80108e0c,(%esp)
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
80104876:	c7 04 24 1d 8e 10 80 	movl   $0x80108e1d,(%esp)
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
801048b2:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801048b7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
801048ba:	75 0c                	jne    801048c8 <exit+0x28>
    panic("init exiting");
801048bc:	c7 04 24 30 8e 10 80 	movl   $0x80108e30,(%esp)
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
80104934:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010493b:	e8 ae 0a 00 00       	call   801053ee <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104940:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104943:	8b 40 10             	mov    0x10(%eax),%eax
80104946:	89 04 24             	mov    %eax,(%esp)
80104949:	e8 c6 04 00 00       	call   80104e14 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104955:	eb 36                	jmp    8010498d <exit+0xed>
    if(p->parent == proc){
80104957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495a:	8b 40 10             	mov    0x10(%eax),%eax
8010495d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104960:	75 24                	jne    80104986 <exit+0xe6>
      p->parent = initproc;
80104962:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496b:	89 50 10             	mov    %edx,0x10(%eax)
      if(p->state == ZOMBIE)
8010496e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104971:	8b 40 08             	mov    0x8(%eax),%eax
80104974:	83 f8 05             	cmp    $0x5,%eax
80104977:	75 0d                	jne    80104986 <exit+0xe6>
        wakeup1(initproc);
80104979:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010497e:	89 04 24             	mov    %eax,(%esp)
80104981:	e8 8e 04 00 00       	call   80104e14 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104986:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
8010498d:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
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
80104a05:	e8 5f 02 00 00       	call   80104c69 <sched>
  panic("zombie exit");
80104a0a:	c7 04 24 3d 8e 10 80 	movl   $0x80108e3d,(%esp)
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
80104a28:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a2f:	e8 ba 09 00 00       	call   801053ee <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3b:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104a42:	e9 fd 00 00 00       	jmp    80104b44 <wait+0x12e>
      if(p->parent != proc)
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	8b 40 10             	mov    0x10(%eax),%eax
80104a4d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104a50:	74 05                	je     80104a57 <wait+0x41>
        continue;
80104a52:	e9 e6 00 00 00       	jmp    80104b3d <wait+0x127>
      havekids = 1;
80104a57:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	8b 40 08             	mov    0x8(%eax),%eax
80104a64:	83 f8 05             	cmp    $0x5,%eax
80104a67:	0f 85 d0 00 00 00    	jne    80104b3d <wait+0x127>
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a70:	83 c0 70             	add    $0x70,%eax
80104a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a76:	eb 61                	jmp    80104ad9 <wait+0xc3>

    		  if (t->state == ZOMBIE){
80104a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a7b:	8b 40 04             	mov    0x4(%eax),%eax
80104a7e:	83 f8 05             	cmp    $0x5,%eax
80104a81:	75 52                	jne    80104ad5 <wait+0xbf>
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
				  if (t->kstack)
80104abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ac2:	8b 00                	mov    (%eax),%eax
80104ac4:	85 c0                	test   %eax,%eax
80104ac6:	74 0d                	je     80104ad5 <wait+0xbf>
					  kfree(t->kstack);
80104ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104acb:	8b 00                	mov    (%eax),%eax
80104acd:	89 04 24             	mov    %eax,(%esp)
80104ad0:	e8 86 df ff ff       	call   80102a5b <kfree>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104ad5:	83 45 ec 1c          	addl   $0x1c,-0x14(%ebp)
80104ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104adc:	05 30 02 00 00       	add    $0x230,%eax
80104ae1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104ae4:	77 92                	ja     80104a78 <wait+0x62>
				  if (t->kstack)
					  kfree(t->kstack);
    		  }
    	  }

        pid = p->pid;
80104ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae9:	8b 40 0c             	mov    0xc(%eax),%eax
80104aec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

        freevm(p->pgdir);
80104aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af2:	8b 40 04             	mov    0x4(%eax),%eax
80104af5:	89 04 24             	mov    %eax,(%esp)
80104af8:	e8 06 3d 00 00       	call   80108803 <freevm>
        p->state = UNUSED;
80104afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        p->pid = 0;
80104b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->parent = 0;
80104b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b14:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->name[0] = 0;
80104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1e:	c6 40 60 00          	movb   $0x0,0x60(%eax)
        p->killed = 0;
80104b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b25:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        release(&ptable.lock);
80104b2c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b33:	e8 18 09 00 00       	call   80105450 <release>
        return pid;
80104b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b3b:	eb 4f                	jmp    80104b8c <wait+0x176>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3d:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104b44:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104b4b:	0f 82 f6 fe ff ff    	jb     80104a47 <wait+0x31>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b55:	74 0a                	je     80104b61 <wait+0x14b>
80104b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b5a:	8b 40 18             	mov    0x18(%eax),%eax
80104b5d:	85 c0                	test   %eax,%eax
80104b5f:	74 13                	je     80104b74 <wait+0x15e>
      release(&ptable.lock);
80104b61:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b68:	e8 e3 08 00 00       	call   80105450 <release>
      return -1;
80104b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b72:	eb 18                	jmp    80104b8c <wait+0x176>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b74:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104b7b:	80 
80104b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b7f:	89 04 24             	mov    %eax,(%esp)
80104b82:	e8 f2 01 00 00       	call   80104d79 <sleep>
  }
80104b87:	e9 a8 fe ff ff       	jmp    80104a34 <wait+0x1e>
  return -1;
}
80104b8c:	c9                   	leave  
80104b8d:	c3                   	ret    

80104b8e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b8e:	55                   	push   %ebp
80104b8f:	89 e5                	mov    %esp,%ebp
80104b91:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b94:	e8 65 f7 ff ff       	call   801042fe <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b99:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ba0:	e8 49 08 00 00       	call   801053ee <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ba5:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104bac:	e9 9a 00 00 00       	jmp    80104c4b <scheduler+0xbd>

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
80104bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb4:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	7e 0d                	jle    80104bcb <scheduler+0x3d>
80104bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc1:	8b 40 08             	mov    0x8(%eax),%eax
80104bc4:	83 f8 03             	cmp    $0x3,%eax
80104bc7:	74 02                	je     80104bcb <scheduler+0x3d>
					continue;
80104bc9:	eb 79                	jmp    80104c44 <scheduler+0xb6>
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bce:	83 c0 70             	add    $0x70,%eax
80104bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104bd4:	eb 61                	jmp    80104c37 <scheduler+0xa9>

				  if(t->state != RUNNABLE)
80104bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bd9:	8b 40 04             	mov    0x4(%eax),%eax
80104bdc:	83 f8 03             	cmp    $0x3,%eax
80104bdf:	74 02                	je     80104be3 <scheduler+0x55>
					continue;
80104be1:	eb 50                	jmp    80104c33 <scheduler+0xa5>
				  // Switch to chosen process.  It is the process's job
				  // to release ptable.lock and then reacquire it
				  // before jumping back to us.
				  thread = t;
80104be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be6:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
				  switchuvm(thread);
80104bec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf2:	89 04 24             	mov    %eax,(%esp)
80104bf5:	e8 91 37 00 00       	call   8010838b <switchuvm>
				  t->state = RUNNING;
80104bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfd:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
				  swtch(&cpu->scheduler, thread->context);
80104c04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c0a:	8b 40 14             	mov    0x14(%eax),%eax
80104c0d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c14:	83 c2 04             	add    $0x4,%edx
80104c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c1b:	89 14 24             	mov    %edx,(%esp)
80104c1e:	e8 b0 0c 00 00       	call   801058d3 <swtch>
				  switchkvm();
80104c23:	e8 46 37 00 00       	call   8010836e <switchkvm>

				  // Process is done running for now.
				  // It should have changed its p->state before coming back.
				  thread = 0;
80104c28:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c2f:	00 00 00 00 

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
					continue;
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104c33:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3a:	05 30 02 00 00       	add    $0x230,%eax
80104c3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104c42:	77 92                	ja     80104bd6 <scheduler+0x48>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c44:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104c4b:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104c52:	0f 82 59 ff ff ff    	jb     80104bb1 <scheduler+0x23>
				  thread = 0;
			  }

    }

    release(&ptable.lock);
80104c58:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c5f:	e8 ec 07 00 00       	call   80105450 <release>

  }
80104c64:	e9 2b ff ff ff       	jmp    80104b94 <scheduler+0x6>

80104c69 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c69:	55                   	push   %ebp
80104c6a:	89 e5                	mov    %esp,%ebp
80104c6c:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c6f:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c76:	e8 9d 08 00 00       	call   80105518 <holding>
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	75 0c                	jne    80104c8b <sched+0x22>
    panic("sched ptable.lock");
80104c7f:	c7 04 24 49 8e 10 80 	movl   $0x80108e49,(%esp)
80104c86:	e8 af b8 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104c8b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c91:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c97:	83 f8 01             	cmp    $0x1,%eax
80104c9a:	74 0c                	je     80104ca8 <sched+0x3f>
    panic("sched locks");
80104c9c:	c7 04 24 5b 8e 10 80 	movl   $0x80108e5b,(%esp)
80104ca3:	e8 92 b8 ff ff       	call   8010053a <panic>
  if(thread->state == RUNNING)
80104ca8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cae:	8b 40 04             	mov    0x4(%eax),%eax
80104cb1:	83 f8 04             	cmp    $0x4,%eax
80104cb4:	75 0c                	jne    80104cc2 <sched+0x59>
    panic("sched running");
80104cb6:	c7 04 24 67 8e 10 80 	movl   $0x80108e67,(%esp)
80104cbd:	e8 78 b8 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104cc2:	e8 27 f6 ff ff       	call   801042ee <readeflags>
80104cc7:	25 00 02 00 00       	and    $0x200,%eax
80104ccc:	85 c0                	test   %eax,%eax
80104cce:	74 0c                	je     80104cdc <sched+0x73>
    panic("sched interruptible");
80104cd0:	c7 04 24 75 8e 10 80 	movl   $0x80108e75,(%esp)
80104cd7:	e8 5e b8 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104cdc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ce2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  swtch(&thread->context, cpu->scheduler);
80104ceb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf1:	8b 40 04             	mov    0x4(%eax),%eax
80104cf4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104cfb:	83 c2 14             	add    $0x14,%edx
80104cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d02:	89 14 24             	mov    %edx,(%esp)
80104d05:	e8 c9 0b 00 00       	call   801058d3 <swtch>
  cpu->intena = intena;
80104d0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d13:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d19:	c9                   	leave  
80104d1a:	c3                   	ret    

80104d1b <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d1b:	55                   	push   %ebp
80104d1c:	89 e5                	mov    %esp,%ebp
80104d1e:	83 ec 18             	sub    $0x18,%esp

  acquire(&ptable.lock);  //DOC: yieldlock
80104d21:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d28:	e8 c1 06 00 00       	call   801053ee <acquire>
  thread->state = RUNNABLE;
80104d2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d33:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

  sched();
80104d3a:	e8 2a ff ff ff       	call   80104c69 <sched>

  release(&ptable.lock);
80104d3f:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d46:	e8 05 07 00 00       	call   80105450 <release>
}
80104d4b:	c9                   	leave  
80104d4c:	c3                   	ret    

80104d4d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d4d:	55                   	push   %ebp
80104d4e:	89 e5                	mov    %esp,%ebp
80104d50:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d53:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d5a:	e8 f1 06 00 00       	call   80105450 <release>

  if (first) {
80104d5f:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104d64:	85 c0                	test   %eax,%eax
80104d66:	74 0f                	je     80104d77 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104d68:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104d6f:	00 00 00 
    initlog();
80104d72:	e8 9d e4 ff ff       	call   80103214 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104d77:	c9                   	leave  
80104d78:	c3                   	ret    

80104d79 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d79:	55                   	push   %ebp
80104d7a:	89 e5                	mov    %esp,%ebp
80104d7c:	83 ec 18             	sub    $0x18,%esp
  if(thread == 0)
80104d7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	75 0c                	jne    80104d95 <sleep+0x1c>
    panic("sleep");
80104d89:	c7 04 24 89 8e 10 80 	movl   $0x80108e89,(%esp)
80104d90:	e8 a5 b7 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104d95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d99:	75 0c                	jne    80104da7 <sleep+0x2e>
    panic("sleep without lk");
80104d9b:	c7 04 24 8f 8e 10 80 	movl   $0x80108e8f,(%esp)
80104da2:	e8 93 b7 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104da7:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104dae:	74 17                	je     80104dc7 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104db0:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104db7:	e8 32 06 00 00       	call   801053ee <acquire>
    release(lk);
80104dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dbf:	89 04 24             	mov    %eax,(%esp)
80104dc2:	e8 89 06 00 00       	call   80105450 <release>
  }

  // Go to sleep.
  thread->chan = chan;
80104dc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dcd:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd0:	89 50 18             	mov    %edx,0x18(%eax)
  thread->state = SLEEPING;
80104dd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd9:	c7 40 04 02 00 00 00 	movl   $0x2,0x4(%eax)
  sched();
80104de0:	e8 84 fe ff ff       	call   80104c69 <sched>

  // Tidy up.
  thread->chan = 0;
80104de5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104deb:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104df2:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104df9:	74 17                	je     80104e12 <sleep+0x99>
    release(&ptable.lock);
80104dfb:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e02:	e8 49 06 00 00       	call   80105450 <release>
    acquire(lk);
80104e07:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e0a:	89 04 24             	mov    %eax,(%esp)
80104e0d:	e8 dc 05 00 00       	call   801053ee <acquire>
  }
}
80104e12:	c9                   	leave  
80104e13:	c3                   	ret    

80104e14 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e1a:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104e21:	eb 43                	jmp    80104e66 <wakeup1+0x52>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e26:	83 c0 70             	add    $0x70,%eax
80104e29:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104e2c:	eb 24                	jmp    80104e52 <wakeup1+0x3e>
		if(t->state == SLEEPING && t->chan == chan)
80104e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e31:	8b 40 04             	mov    0x4(%eax),%eax
80104e34:	83 f8 02             	cmp    $0x2,%eax
80104e37:	75 15                	jne    80104e4e <wakeup1+0x3a>
80104e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e3c:	8b 40 18             	mov    0x18(%eax),%eax
80104e3f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e42:	75 0a                	jne    80104e4e <wakeup1+0x3a>
		  t->state = RUNNABLE;
80104e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e47:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104e4e:	83 45 f8 1c          	addl   $0x1c,-0x8(%ebp)
80104e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e55:	05 30 02 00 00       	add    $0x230,%eax
80104e5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e5d:	77 cf                	ja     80104e2e <wakeup1+0x1a>
wakeup1(void *chan)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e5f:	81 45 fc 34 02 00 00 	addl   $0x234,-0x4(%ebp)
80104e66:	81 7d fc b4 c6 11 80 	cmpl   $0x8011c6b4,-0x4(%ebp)
80104e6d:	72 b4                	jb     80104e23 <wakeup1+0xf>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
		if(t->state == SLEEPING && t->chan == chan)
		  t->state = RUNNABLE;
	 }
}
80104e6f:	c9                   	leave  
80104e70:	c3                   	ret    

80104e71 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e71:	55                   	push   %ebp
80104e72:	89 e5                	mov    %esp,%ebp
80104e74:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104e77:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e7e:	e8 6b 05 00 00       	call   801053ee <acquire>
  wakeup1(chan);
80104e83:	8b 45 08             	mov    0x8(%ebp),%eax
80104e86:	89 04 24             	mov    %eax,(%esp)
80104e89:	e8 86 ff ff ff       	call   80104e14 <wakeup1>
  release(&ptable.lock);
80104e8e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e95:	e8 b6 05 00 00       	call   80105450 <release>
}
80104e9a:	c9                   	leave  
80104e9b:	c3                   	ret    

80104e9c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e9c:	55                   	push   %ebp
80104e9d:	89 e5                	mov    %esp,%ebp
80104e9f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
80104ea2:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ea9:	e8 40 05 00 00       	call   801053ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eae:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104eb5:	eb 60                	jmp    80104f17 <kill+0x7b>
    if(p->pid == pid){
80104eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eba:	8b 40 0c             	mov    0xc(%eax),%eax
80104ebd:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ec0:	75 4e                	jne    80104f10 <kill+0x74>
      p->killed = 1;
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecf:	83 c0 70             	add    $0x70,%eax
80104ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104ed5:	eb 19                	jmp    80104ef0 <kill+0x54>
			 if(t->state == SLEEPING)
80104ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eda:	8b 40 04             	mov    0x4(%eax),%eax
80104edd:	83 f8 02             	cmp    $0x2,%eax
80104ee0:	75 0a                	jne    80104eec <kill+0x50>
					t->state = RUNNABLE;
80104ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ee5:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104eec:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef3:	05 30 02 00 00       	add    $0x230,%eax
80104ef8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104efb:	77 da                	ja     80104ed7 <kill+0x3b>
			 if(t->state == SLEEPING)
					t->state = RUNNABLE;
      }
      // Wake process from sleep if necessary.

      release(&ptable.lock);
80104efd:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f04:	e8 47 05 00 00       	call   80105450 <release>
      return 0;
80104f09:	b8 00 00 00 00       	mov    $0x0,%eax
80104f0e:	eb 21                	jmp    80104f31 <kill+0x95>
kill(int pid)
{
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f10:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104f17:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104f1e:	72 97                	jb     80104eb7 <kill+0x1b>

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f20:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f27:	e8 24 05 00 00       	call   80105450 <release>
  return -1;
80104f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f31:	c9                   	leave  
80104f32:	c3                   	ret    

80104f33 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f33:	55                   	push   %ebp
80104f34:	89 e5                	mov    %esp,%ebp
80104f36:	83 ec 58             	sub    $0x58,%esp
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f39:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104f40:	e9 dc 00 00 00       	jmp    80105021 <procdump+0xee>
    if(p->state == UNUSED)
80104f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f48:	8b 40 08             	mov    0x8(%eax),%eax
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	75 05                	jne    80104f54 <procdump+0x21>
      continue;
80104f4f:	e9 c6 00 00 00       	jmp    8010501a <procdump+0xe7>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f57:	8b 40 08             	mov    0x8(%eax),%eax
80104f5a:	83 f8 05             	cmp    $0x5,%eax
80104f5d:	77 23                	ja     80104f82 <procdump+0x4f>
80104f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f62:	8b 40 08             	mov    0x8(%eax),%eax
80104f65:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f6c:	85 c0                	test   %eax,%eax
80104f6e:	74 12                	je     80104f82 <procdump+0x4f>
      state = states[p->state];
80104f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f73:	8b 40 08             	mov    0x8(%eax),%eax
80104f76:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f80:	eb 07                	jmp    80104f89 <procdump+0x56>
    else
      state = "???";
80104f82:	c7 45 ec a0 8e 10 80 	movl   $0x80108ea0,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8c:	8d 50 60             	lea    0x60(%eax),%edx
80104f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f92:	8b 40 0c             	mov    0xc(%eax),%eax
80104f95:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104f99:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f9c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa4:	c7 04 24 a4 8e 10 80 	movl   $0x80108ea4,(%esp)
80104fab:	e8 f0 b3 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb3:	8b 40 08             	mov    0x8(%eax),%eax
80104fb6:	83 f8 02             	cmp    $0x2,%eax
80104fb9:	75 53                	jne    8010500e <procdump+0xdb>
      getcallerpcs((uint*)thread->context->ebp+2, pc);
80104fbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fc1:	8b 40 14             	mov    0x14(%eax),%eax
80104fc4:	8b 40 0c             	mov    0xc(%eax),%eax
80104fc7:	83 c0 08             	add    $0x8,%eax
80104fca:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104fcd:	89 54 24 04          	mov    %edx,0x4(%esp)
80104fd1:	89 04 24             	mov    %eax,(%esp)
80104fd4:	e8 c6 04 00 00       	call   8010549f <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fe0:	eb 1b                	jmp    80104ffd <procdump+0xca>
        cprintf(" %p", pc[i]);
80104fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fed:	c7 04 24 ad 8e 10 80 	movl   $0x80108ead,(%esp)
80104ff4:	e8 a7 b3 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)thread->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ff9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ffd:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105001:	7f 0b                	jg     8010500e <procdump+0xdb>
80105003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105006:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010500a:	85 c0                	test   %eax,%eax
8010500c:	75 d4                	jne    80104fe2 <procdump+0xaf>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010500e:	c7 04 24 b1 8e 10 80 	movl   $0x80108eb1,(%esp)
80105015:	e8 86 b3 ff ff       	call   801003a0 <cprintf>
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010501a:	81 45 f0 34 02 00 00 	addl   $0x234,-0x10(%ebp)
80105021:	81 7d f0 b4 c6 11 80 	cmpl   $0x8011c6b4,-0x10(%ebp)
80105028:	0f 82 17 ff ff ff    	jb     80104f45 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010502e:	c9                   	leave  
8010502f:	c3                   	ret    

80105030 <wakeupThreads>:



void
wakeupThreads(void *chan)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 10             	sub    $0x10,%esp


  struct thread *t;
  for(t= thread->proc->threads; t < &thread->proc->threads[NTHREAD]; t++){
80105036:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010503c:	8b 40 0c             	mov    0xc(%eax),%eax
8010503f:	83 c0 70             	add    $0x70,%eax
80105042:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105045:	eb 24                	jmp    8010506b <wakeupThreads+0x3b>
		  if(t->state == SLEEPING && t->chan == chan){
80105047:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010504a:	8b 40 04             	mov    0x4(%eax),%eax
8010504d:	83 f8 02             	cmp    $0x2,%eax
80105050:	75 15                	jne    80105067 <wakeupThreads+0x37>
80105052:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105055:	8b 40 18             	mov    0x18(%eax),%eax
80105058:	3b 45 08             	cmp    0x8(%ebp),%eax
8010505b:	75 0a                	jne    80105067 <wakeupThreads+0x37>
			  t->state =  RUNNABLE;
8010505d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105060:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
wakeupThreads(void *chan)
{


  struct thread *t;
  for(t= thread->proc->threads; t < &thread->proc->threads[NTHREAD]; t++){
80105067:	83 45 fc 1c          	addl   $0x1c,-0x4(%ebp)
8010506b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105071:	8b 40 0c             	mov    0xc(%eax),%eax
80105074:	05 30 02 00 00       	add    $0x230,%eax
80105079:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010507c:	77 c9                	ja     80105047 <wakeupThreads+0x17>
		  if(t->state == SLEEPING && t->chan == chan){
			  t->state =  RUNNABLE;
			  }
   }
}
8010507e:	c9                   	leave  
8010507f:	c3                   	ret    

80105080 <kthread_create>:


int
kthread_create(void*(*start_func)(), void* stack, uint stack_size){
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
80105086:	83 ec 2c             	sub    $0x2c,%esp
	  struct thread *t ;


	  char *sp;

	  acquire(&ptable.lock);
80105089:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105090:	e8 59 03 00 00       	call   801053ee <acquire>
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105095:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010509b:	8b 40 0c             	mov    0xc(%eax),%eax
8010509e:	83 c0 70             	add    $0x70,%eax
801050a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050a4:	eb 53                	jmp    801050f9 <kthread_create+0x79>
	    if(t->state == UNUSED){
801050a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050a9:	8b 40 04             	mov    0x4(%eax),%eax
801050ac:	85 c0                	test   %eax,%eax
801050ae:	75 45                	jne    801050f5 <kthread_create+0x75>
	       goto found;
801050b0:	90                   	nop
	  }
	  release(&ptable.lock);
	  return -1;

	  found:
	       t->state=EMBRYO;
801050b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050b4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	       t->pid= nextpid++;
801050bb:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801050c0:	8d 50 01             	lea    0x1(%eax),%edx
801050c3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801050c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050cc:	89 42 08             	mov    %eax,0x8(%edx)
	       increaseNumOfThreadsAlive();
801050cf:	e8 46 f7 ff ff       	call   8010481a <increaseNumOfThreadsAlive>
	       release(&ptable.lock);
801050d4:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801050db:	e8 70 03 00 00       	call   80105450 <release>
	       if((t->kstack = kalloc()) == 0){
801050e0:	e8 0f da ff ff       	call   80102af4 <kalloc>
801050e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050e8:	89 02                	mov    %eax,(%edx)
801050ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050ed:	8b 00                	mov    (%eax),%eax
801050ef:	85 c0                	test   %eax,%eax
801050f1:	75 43                	jne    80105136 <kthread_create+0xb6>
801050f3:	eb 2d                	jmp    80105122 <kthread_create+0xa2>


	  char *sp;

	  acquire(&ptable.lock);
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
801050f5:	83 45 e4 1c          	addl   $0x1c,-0x1c(%ebp)
801050f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050ff:	8b 40 0c             	mov    0xc(%eax),%eax
80105102:	05 30 02 00 00       	add    $0x230,%eax
80105107:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
8010510a:	77 9a                	ja     801050a6 <kthread_create+0x26>
	    if(t->state == UNUSED){
	       goto found;
	    }
	  }
	  release(&ptable.lock);
8010510c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105113:	e8 38 03 00 00       	call   80105450 <release>
	  return -1;
80105118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511d:	e9 dc 00 00 00       	jmp    801051fe <kthread_create+0x17e>
	       t->state=EMBRYO;
	       t->pid= nextpid++;
	       increaseNumOfThreadsAlive();
	       release(&ptable.lock);
	       if((t->kstack = kalloc()) == 0){
	        t->state = UNUSED;
80105122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105125:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	        return -1;
8010512c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105131:	e9 c8 00 00 00       	jmp    801051fe <kthread_create+0x17e>
	       }
	       sp = t->kstack + KSTACKSIZE;
80105136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105139:	8b 00                	mov    (%eax),%eax
8010513b:	05 00 10 00 00       	add    $0x1000,%eax
80105140:	89 45 e0             	mov    %eax,-0x20(%ebp)
	       sp -= sizeof *t->tf;
80105143:	83 6d e0 4c          	subl   $0x4c,-0x20(%ebp)

	       t->tf = (struct trapframe*)sp ;
80105147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010514a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010514d:	89 50 10             	mov    %edx,0x10(%eax)
	       sp -= 4;
80105150:	83 6d e0 04          	subl   $0x4,-0x20(%ebp)
	       *(uint*)sp = (uint)trapret;
80105154:	ba 50 6b 10 80       	mov    $0x80106b50,%edx
80105159:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010515c:	89 10                	mov    %edx,(%eax)
	       sp -= sizeof *t->context;
8010515e:	83 6d e0 14          	subl   $0x14,-0x20(%ebp)
	       t->context = (struct context*)sp;
80105162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105165:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105168:	89 50 14             	mov    %edx,0x14(%eax)
	       memset(t->context, 0, sizeof *t->context);
8010516b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010516e:	8b 40 14             	mov    0x14(%eax),%eax
80105171:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105178:	00 
80105179:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105180:	00 
80105181:	89 04 24             	mov    %eax,(%esp)
80105184:	e8 b9 04 00 00       	call   80105642 <memset>


	       t->context->eip = (uint)forkret;
80105189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010518c:	8b 40 14             	mov    0x14(%eax),%eax
8010518f:	ba 4d 4d 10 80       	mov    $0x80104d4d,%edx
80105194:	89 50 10             	mov    %edx,0x10(%eax)
	       *t->tf=*thread->tf;
80105197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010519a:	8b 50 10             	mov    0x10(%eax),%edx
8010519d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a3:	8b 40 10             	mov    0x10(%eax),%eax
801051a6:	89 c3                	mov    %eax,%ebx
801051a8:	b8 13 00 00 00       	mov    $0x13,%eax
801051ad:	89 d7                	mov    %edx,%edi
801051af:	89 de                	mov    %ebx,%esi
801051b1:	89 c1                	mov    %eax,%ecx
801051b3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	       t->tf->eip = (uint)start_func;
801051b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051b8:	8b 40 10             	mov    0x10(%eax),%eax
801051bb:	8b 55 08             	mov    0x8(%ebp),%edx
801051be:	89 50 38             	mov    %edx,0x38(%eax)
	       t->tf->esp = (uint)(stack+stack_size);
801051c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051c4:	8b 40 10             	mov    0x10(%eax),%eax
801051c7:	8b 55 10             	mov    0x10(%ebp),%edx
801051ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051cd:	01 ca                	add    %ecx,%edx
801051cf:	89 50 44             	mov    %edx,0x44(%eax)
	       t->tf->eflags = FL_IF;
801051d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051d5:	8b 40 10             	mov    0x10(%eax),%eax
801051d8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	       t->proc = thread->proc;
801051df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051e5:	8b 50 0c             	mov    0xc(%eax),%edx
801051e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051eb:	89 50 0c             	mov    %edx,0xc(%eax)
	       t->state = RUNNABLE;
801051ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051f1:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	       return t->pid;
801051f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051fb:	8b 40 08             	mov    0x8(%eax),%eax


}
801051fe:	83 c4 2c             	add    $0x2c,%esp
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5f                   	pop    %edi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    

80105206 <kthread_id>:

int kthread_id(){
80105206:	55                   	push   %ebp
80105207:	89 e5                	mov    %esp,%ebp

	return thread->pid;
80105209:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010520f:	8b 40 08             	mov    0x8(%eax),%eax
}
80105212:	5d                   	pop    %ebp
80105213:	c3                   	ret    

80105214 <kthread_exit>:

void kthread_exit(){
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	83 ec 28             	sub    $0x28,%esp




	 struct proc *proc =thread->proc;
8010521a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105220:	8b 40 0c             	mov    0xc(%eax),%eax
80105223:	89 45 f4             	mov    %eax,-0xc(%ebp)


	 acquire(&ptable.lock);
80105226:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010522d:	e8 bc 01 00 00       	call   801053ee <acquire>

	 thread->state= ZOMBIE;
80105232:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105238:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)

	 if (proc->numOfThreads == 1 ){  //tis is ta lst tred
8010523f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105242:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80105248:	83 f8 01             	cmp    $0x1,%eax
8010524b:	75 11                	jne    8010525e <kthread_exit+0x4a>
		 	release(&ptable.lock);
8010524d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105254:	e8 f7 01 00 00       	call   80105450 <release>
		 	exit();
80105259:	e8 42 f6 ff ff       	call   801048a0 <exit>

	 }

	 decreaseNumOfThreadsAlive();
8010525e:	e8 ec f5 ff ff       	call   8010484f <decreaseNumOfThreadsAlive>

	 wakeup1(thread);
80105263:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105269:	89 04 24             	mov    %eax,(%esp)
8010526c:	e8 a3 fb ff ff       	call   80104e14 <wakeup1>

	 sched();
80105271:	e8 f3 f9 ff ff       	call   80104c69 <sched>
	 panic("zombie exit");
80105276:	c7 04 24 3d 8e 10 80 	movl   $0x80108e3d,(%esp)
8010527d:	e8 b8 b2 ff ff       	call   8010053a <panic>

80105282 <kthread_join>:
}

int kthread_join(int thread_id){
80105282:	55                   	push   %ebp
80105283:	89 e5                	mov    %esp,%ebp
80105285:	83 ec 28             	sub    $0x28,%esp
	//printf( "thread id : %d ", thread_id);
	  int found;
	  struct thread *t;
	  struct thread *threadFound;

	  acquire(&ptable.lock);
80105288:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010528f:	e8 5a 01 00 00       	call   801053ee <acquire>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;
80105294:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
8010529b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a1:	8b 40 0c             	mov    0xc(%eax),%eax
801052a4:	83 c0 70             	add    $0x70,%eax
801052a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801052aa:	e9 8e 00 00 00       	jmp    8010533d <kthread_join+0xbb>

	      if(t->pid != thread_id)
801052af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052b2:	8b 40 08             	mov    0x8(%eax),%eax
801052b5:	3b 45 08             	cmp    0x8(%ebp),%eax
801052b8:	74 02                	je     801052bc <kthread_join+0x3a>
	        continue;
801052ba:	eb 7d                	jmp    80105339 <kthread_join+0xb7>
	      found = 1;
801052bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	      threadFound= t;
801052c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	      if(t->state == ZOMBIE){
801052c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cc:	8b 40 04             	mov    0x4(%eax),%eax
801052cf:	83 f8 05             	cmp    $0x5,%eax
801052d2:	75 65                	jne    80105339 <kthread_join+0xb7>
	        // Found one.
	        t->chan= 0;
801052d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
			t->context = 0;
801052de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
			t->pid = 0;
801052e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			t->proc = 0;
801052f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			t->state = 0;
801052fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			t->state= UNUSED;
80105306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105309:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			if (t->kstack)
80105310:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105313:	8b 00                	mov    (%eax),%eax
80105315:	85 c0                	test   %eax,%eax
80105317:	74 0d                	je     80105326 <kthread_join+0xa4>
				kfree(t->kstack);
80105319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010531c:	8b 00                	mov    (%eax),%eax
8010531e:	89 04 24             	mov    %eax,(%esp)
80105321:	e8 35 d7 ff ff       	call   80102a5b <kfree>

	        release(&ptable.lock);
80105326:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010532d:	e8 1e 01 00 00       	call   80105450 <release>
	        return 0;
80105332:	b8 00 00 00 00       	mov    $0x0,%eax
80105337:	eb 5c                	jmp    80105395 <kthread_join+0x113>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105339:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
8010533d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105343:	8b 40 0c             	mov    0xc(%eax),%eax
80105346:	05 30 02 00 00       	add    $0x230,%eax
8010534b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010534e:	0f 87 5b ff ff ff    	ja     801052af <kthread_join+0x2d>
	        return 0;
	      }
	    }


	    if(!found || thread->proc->killed){
80105354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105358:	74 10                	je     8010536a <kthread_join+0xe8>
8010535a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105360:	8b 40 0c             	mov    0xc(%eax),%eax
80105363:	8b 40 18             	mov    0x18(%eax),%eax
80105366:	85 c0                	test   %eax,%eax
80105368:	74 13                	je     8010537d <kthread_join+0xfb>

	      release(&ptable.lock);
8010536a:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105371:	e8 da 00 00 00       	call   80105450 <release>
	      return -1;
80105376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537b:	eb 18                	jmp    80105395 <kthread_join+0x113>
	    }

	    // Wait for thread to exit
	    sleep(threadFound, &ptable.lock);  //DOC: wait-sleep
8010537d:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80105384:	80 
80105385:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105388:	89 04 24             	mov    %eax,(%esp)
8010538b:	e8 e9 f9 ff ff       	call   80104d79 <sleep>

	  }
80105390:	e9 ff fe ff ff       	jmp    80105294 <kthread_join+0x12>


	  return -1;
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    

80105397 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105397:	55                   	push   %ebp
80105398:	89 e5                	mov    %esp,%ebp
8010539a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010539d:	9c                   	pushf  
8010539e:	58                   	pop    %eax
8010539f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801053a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    

801053a7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801053a7:	55                   	push   %ebp
801053a8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801053aa:	fa                   	cli    
}
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    

801053ad <sti>:

static inline void
sti(void)
{
801053ad:	55                   	push   %ebp
801053ae:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801053b0:	fb                   	sti    
}
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret    

801053b3 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801053b3:	55                   	push   %ebp
801053b4:	89 e5                	mov    %esp,%ebp
801053b6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801053b9:	8b 55 08             	mov    0x8(%ebp),%edx
801053bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053c2:	f0 87 02             	lock xchg %eax,(%edx)
801053c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801053c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053cb:	c9                   	leave  
801053cc:	c3                   	ret    

801053cd <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053cd:	55                   	push   %ebp
801053ce:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801053d0:	8b 45 08             	mov    0x8(%ebp),%eax
801053d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801053d6:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801053d9:	8b 45 08             	mov    0x8(%ebp),%eax
801053dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801053e2:	8b 45 08             	mov    0x8(%ebp),%eax
801053e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053ec:	5d                   	pop    %ebp
801053ed:	c3                   	ret    

801053ee <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801053ee:	55                   	push   %ebp
801053ef:	89 e5                	mov    %esp,%ebp
801053f1:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801053f4:	e8 49 01 00 00       	call   80105542 <pushcli>
  if(holding(lk))
801053f9:	8b 45 08             	mov    0x8(%ebp),%eax
801053fc:	89 04 24             	mov    %eax,(%esp)
801053ff:	e8 14 01 00 00       	call   80105518 <holding>
80105404:	85 c0                	test   %eax,%eax
80105406:	74 0c                	je     80105414 <acquire+0x26>
    panic("acquire");
80105408:	c7 04 24 dd 8e 10 80 	movl   $0x80108edd,(%esp)
8010540f:	e8 26 b1 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105414:	90                   	nop
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010541f:	00 
80105420:	89 04 24             	mov    %eax,(%esp)
80105423:	e8 8b ff ff ff       	call   801053b3 <xchg>
80105428:	85 c0                	test   %eax,%eax
8010542a:	75 e9                	jne    80105415 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010542c:	8b 45 08             	mov    0x8(%ebp),%eax
8010542f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105436:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105439:	8b 45 08             	mov    0x8(%ebp),%eax
8010543c:	83 c0 0c             	add    $0xc,%eax
8010543f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105443:	8d 45 08             	lea    0x8(%ebp),%eax
80105446:	89 04 24             	mov    %eax,(%esp)
80105449:	e8 51 00 00 00       	call   8010549f <getcallerpcs>
}
8010544e:	c9                   	leave  
8010544f:	c3                   	ret    

80105450 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105456:	8b 45 08             	mov    0x8(%ebp),%eax
80105459:	89 04 24             	mov    %eax,(%esp)
8010545c:	e8 b7 00 00 00       	call   80105518 <holding>
80105461:	85 c0                	test   %eax,%eax
80105463:	75 0c                	jne    80105471 <release+0x21>
    panic("release");
80105465:	c7 04 24 e5 8e 10 80 	movl   $0x80108ee5,(%esp)
8010546c:	e8 c9 b0 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105471:	8b 45 08             	mov    0x8(%ebp),%eax
80105474:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010547b:	8b 45 08             	mov    0x8(%ebp),%eax
8010547e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105485:	8b 45 08             	mov    0x8(%ebp),%eax
80105488:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010548f:	00 
80105490:	89 04 24             	mov    %eax,(%esp)
80105493:	e8 1b ff ff ff       	call   801053b3 <xchg>

  popcli();
80105498:	e8 e9 00 00 00       	call   80105586 <popcli>
}
8010549d:	c9                   	leave  
8010549e:	c3                   	ret    

8010549f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010549f:	55                   	push   %ebp
801054a0:	89 e5                	mov    %esp,%ebp
801054a2:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801054a5:	8b 45 08             	mov    0x8(%ebp),%eax
801054a8:	83 e8 08             	sub    $0x8,%eax
801054ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801054ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801054b5:	eb 38                	jmp    801054ef <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054bb:	74 38                	je     801054f5 <getcallerpcs+0x56>
801054bd:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801054c4:	76 2f                	jbe    801054f5 <getcallerpcs+0x56>
801054c6:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801054ca:	74 29                	je     801054f5 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801054cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d9:	01 c2                	add    %eax,%edx
801054db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054de:	8b 40 04             	mov    0x4(%eax),%eax
801054e1:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801054e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e6:	8b 00                	mov    (%eax),%eax
801054e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801054eb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054ef:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054f3:	7e c2                	jle    801054b7 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054f5:	eb 19                	jmp    80105510 <getcallerpcs+0x71>
    pcs[i] = 0;
801054f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105501:	8b 45 0c             	mov    0xc(%ebp),%eax
80105504:	01 d0                	add    %edx,%eax
80105506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010550c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105510:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105514:	7e e1                	jle    801054f7 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105516:	c9                   	leave  
80105517:	c3                   	ret    

80105518 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105518:	55                   	push   %ebp
80105519:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010551b:	8b 45 08             	mov    0x8(%ebp),%eax
8010551e:	8b 00                	mov    (%eax),%eax
80105520:	85 c0                	test   %eax,%eax
80105522:	74 17                	je     8010553b <holding+0x23>
80105524:	8b 45 08             	mov    0x8(%ebp),%eax
80105527:	8b 50 08             	mov    0x8(%eax),%edx
8010552a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105530:	39 c2                	cmp    %eax,%edx
80105532:	75 07                	jne    8010553b <holding+0x23>
80105534:	b8 01 00 00 00       	mov    $0x1,%eax
80105539:	eb 05                	jmp    80105540 <holding+0x28>
8010553b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105540:	5d                   	pop    %ebp
80105541:	c3                   	ret    

80105542 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105542:	55                   	push   %ebp
80105543:	89 e5                	mov    %esp,%ebp
80105545:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105548:	e8 4a fe ff ff       	call   80105397 <readeflags>
8010554d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105550:	e8 52 fe ff ff       	call   801053a7 <cli>
  if(cpu->ncli++ == 0)
80105555:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010555c:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105562:	8d 48 01             	lea    0x1(%eax),%ecx
80105565:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010556b:	85 c0                	test   %eax,%eax
8010556d:	75 15                	jne    80105584 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010556f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105575:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105578:	81 e2 00 02 00 00    	and    $0x200,%edx
8010557e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105584:	c9                   	leave  
80105585:	c3                   	ret    

80105586 <popcli>:

void
popcli(void)
{
80105586:	55                   	push   %ebp
80105587:	89 e5                	mov    %esp,%ebp
80105589:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010558c:	e8 06 fe ff ff       	call   80105397 <readeflags>
80105591:	25 00 02 00 00       	and    $0x200,%eax
80105596:	85 c0                	test   %eax,%eax
80105598:	74 0c                	je     801055a6 <popcli+0x20>
    panic("popcli - interruptible");
8010559a:	c7 04 24 ed 8e 10 80 	movl   $0x80108eed,(%esp)
801055a1:	e8 94 af ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
801055a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055ac:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801055b2:	83 ea 01             	sub    $0x1,%edx
801055b5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055bb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055c1:	85 c0                	test   %eax,%eax
801055c3:	79 0c                	jns    801055d1 <popcli+0x4b>
    panic("popcli");
801055c5:	c7 04 24 04 8f 10 80 	movl   $0x80108f04,(%esp)
801055cc:	e8 69 af ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801055d1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055d7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055dd:	85 c0                	test   %eax,%eax
801055df:	75 15                	jne    801055f6 <popcli+0x70>
801055e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055e7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801055ed:	85 c0                	test   %eax,%eax
801055ef:	74 05                	je     801055f6 <popcli+0x70>
    sti();
801055f1:	e8 b7 fd ff ff       	call   801053ad <sti>
}
801055f6:	c9                   	leave  
801055f7:	c3                   	ret    

801055f8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801055f8:	55                   	push   %ebp
801055f9:	89 e5                	mov    %esp,%ebp
801055fb:	57                   	push   %edi
801055fc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801055fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105600:	8b 55 10             	mov    0x10(%ebp),%edx
80105603:	8b 45 0c             	mov    0xc(%ebp),%eax
80105606:	89 cb                	mov    %ecx,%ebx
80105608:	89 df                	mov    %ebx,%edi
8010560a:	89 d1                	mov    %edx,%ecx
8010560c:	fc                   	cld    
8010560d:	f3 aa                	rep stos %al,%es:(%edi)
8010560f:	89 ca                	mov    %ecx,%edx
80105611:	89 fb                	mov    %edi,%ebx
80105613:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105616:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105619:	5b                   	pop    %ebx
8010561a:	5f                   	pop    %edi
8010561b:	5d                   	pop    %ebp
8010561c:	c3                   	ret    

8010561d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010561d:	55                   	push   %ebp
8010561e:	89 e5                	mov    %esp,%ebp
80105620:	57                   	push   %edi
80105621:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105622:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105625:	8b 55 10             	mov    0x10(%ebp),%edx
80105628:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562b:	89 cb                	mov    %ecx,%ebx
8010562d:	89 df                	mov    %ebx,%edi
8010562f:	89 d1                	mov    %edx,%ecx
80105631:	fc                   	cld    
80105632:	f3 ab                	rep stos %eax,%es:(%edi)
80105634:	89 ca                	mov    %ecx,%edx
80105636:	89 fb                	mov    %edi,%ebx
80105638:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010563b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010563e:	5b                   	pop    %ebx
8010563f:	5f                   	pop    %edi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret    

80105642 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105642:	55                   	push   %ebp
80105643:	89 e5                	mov    %esp,%ebp
80105645:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105648:	8b 45 08             	mov    0x8(%ebp),%eax
8010564b:	83 e0 03             	and    $0x3,%eax
8010564e:	85 c0                	test   %eax,%eax
80105650:	75 49                	jne    8010569b <memset+0x59>
80105652:	8b 45 10             	mov    0x10(%ebp),%eax
80105655:	83 e0 03             	and    $0x3,%eax
80105658:	85 c0                	test   %eax,%eax
8010565a:	75 3f                	jne    8010569b <memset+0x59>
    c &= 0xFF;
8010565c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105663:	8b 45 10             	mov    0x10(%ebp),%eax
80105666:	c1 e8 02             	shr    $0x2,%eax
80105669:	89 c2                	mov    %eax,%edx
8010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566e:	c1 e0 18             	shl    $0x18,%eax
80105671:	89 c1                	mov    %eax,%ecx
80105673:	8b 45 0c             	mov    0xc(%ebp),%eax
80105676:	c1 e0 10             	shl    $0x10,%eax
80105679:	09 c1                	or     %eax,%ecx
8010567b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567e:	c1 e0 08             	shl    $0x8,%eax
80105681:	09 c8                	or     %ecx,%eax
80105683:	0b 45 0c             	or     0xc(%ebp),%eax
80105686:	89 54 24 08          	mov    %edx,0x8(%esp)
8010568a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010568e:	8b 45 08             	mov    0x8(%ebp),%eax
80105691:	89 04 24             	mov    %eax,(%esp)
80105694:	e8 84 ff ff ff       	call   8010561d <stosl>
80105699:	eb 19                	jmp    801056b4 <memset+0x72>
  } else
    stosb(dst, c, n);
8010569b:	8b 45 10             	mov    0x10(%ebp),%eax
8010569e:	89 44 24 08          	mov    %eax,0x8(%esp)
801056a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801056a9:	8b 45 08             	mov    0x8(%ebp),%eax
801056ac:	89 04 24             	mov    %eax,(%esp)
801056af:	e8 44 ff ff ff       	call   801055f8 <stosb>
  return dst;
801056b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801056b7:	c9                   	leave  
801056b8:	c3                   	ret    

801056b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056b9:	55                   	push   %ebp
801056ba:	89 e5                	mov    %esp,%ebp
801056bc:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801056bf:	8b 45 08             	mov    0x8(%ebp),%eax
801056c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801056c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801056cb:	eb 30                	jmp    801056fd <memcmp+0x44>
    if(*s1 != *s2)
801056cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056d0:	0f b6 10             	movzbl (%eax),%edx
801056d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056d6:	0f b6 00             	movzbl (%eax),%eax
801056d9:	38 c2                	cmp    %al,%dl
801056db:	74 18                	je     801056f5 <memcmp+0x3c>
      return *s1 - *s2;
801056dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056e0:	0f b6 00             	movzbl (%eax),%eax
801056e3:	0f b6 d0             	movzbl %al,%edx
801056e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056e9:	0f b6 00             	movzbl (%eax),%eax
801056ec:	0f b6 c0             	movzbl %al,%eax
801056ef:	29 c2                	sub    %eax,%edx
801056f1:	89 d0                	mov    %edx,%eax
801056f3:	eb 1a                	jmp    8010570f <memcmp+0x56>
    s1++, s2++;
801056f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056f9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056fd:	8b 45 10             	mov    0x10(%ebp),%eax
80105700:	8d 50 ff             	lea    -0x1(%eax),%edx
80105703:	89 55 10             	mov    %edx,0x10(%ebp)
80105706:	85 c0                	test   %eax,%eax
80105708:	75 c3                	jne    801056cd <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010570a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010570f:	c9                   	leave  
80105710:	c3                   	ret    

80105711 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105711:	55                   	push   %ebp
80105712:	89 e5                	mov    %esp,%ebp
80105714:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105717:	8b 45 0c             	mov    0xc(%ebp),%eax
8010571a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010571d:	8b 45 08             	mov    0x8(%ebp),%eax
80105720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105723:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105726:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105729:	73 3d                	jae    80105768 <memmove+0x57>
8010572b:	8b 45 10             	mov    0x10(%ebp),%eax
8010572e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105731:	01 d0                	add    %edx,%eax
80105733:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105736:	76 30                	jbe    80105768 <memmove+0x57>
    s += n;
80105738:	8b 45 10             	mov    0x10(%ebp),%eax
8010573b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010573e:	8b 45 10             	mov    0x10(%ebp),%eax
80105741:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105744:	eb 13                	jmp    80105759 <memmove+0x48>
      *--d = *--s;
80105746:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010574a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010574e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105751:	0f b6 10             	movzbl (%eax),%edx
80105754:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105757:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105759:	8b 45 10             	mov    0x10(%ebp),%eax
8010575c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010575f:	89 55 10             	mov    %edx,0x10(%ebp)
80105762:	85 c0                	test   %eax,%eax
80105764:	75 e0                	jne    80105746 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105766:	eb 26                	jmp    8010578e <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105768:	eb 17                	jmp    80105781 <memmove+0x70>
      *d++ = *s++;
8010576a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010576d:	8d 50 01             	lea    0x1(%eax),%edx
80105770:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105773:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105776:	8d 4a 01             	lea    0x1(%edx),%ecx
80105779:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010577c:	0f b6 12             	movzbl (%edx),%edx
8010577f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105781:	8b 45 10             	mov    0x10(%ebp),%eax
80105784:	8d 50 ff             	lea    -0x1(%eax),%edx
80105787:	89 55 10             	mov    %edx,0x10(%ebp)
8010578a:	85 c0                	test   %eax,%eax
8010578c:	75 dc                	jne    8010576a <memmove+0x59>
      *d++ = *s++;

  return dst;
8010578e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105791:	c9                   	leave  
80105792:	c3                   	ret    

80105793 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105793:	55                   	push   %ebp
80105794:	89 e5                	mov    %esp,%ebp
80105796:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105799:	8b 45 10             	mov    0x10(%ebp),%eax
8010579c:	89 44 24 08          	mov    %eax,0x8(%esp)
801057a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a7:	8b 45 08             	mov    0x8(%ebp),%eax
801057aa:	89 04 24             	mov    %eax,(%esp)
801057ad:	e8 5f ff ff ff       	call   80105711 <memmove>
}
801057b2:	c9                   	leave  
801057b3:	c3                   	ret    

801057b4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801057b7:	eb 0c                	jmp    801057c5 <strncmp+0x11>
    n--, p++, q++;
801057b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801057bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801057c1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801057c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057c9:	74 1a                	je     801057e5 <strncmp+0x31>
801057cb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ce:	0f b6 00             	movzbl (%eax),%eax
801057d1:	84 c0                	test   %al,%al
801057d3:	74 10                	je     801057e5 <strncmp+0x31>
801057d5:	8b 45 08             	mov    0x8(%ebp),%eax
801057d8:	0f b6 10             	movzbl (%eax),%edx
801057db:	8b 45 0c             	mov    0xc(%ebp),%eax
801057de:	0f b6 00             	movzbl (%eax),%eax
801057e1:	38 c2                	cmp    %al,%dl
801057e3:	74 d4                	je     801057b9 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801057e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057e9:	75 07                	jne    801057f2 <strncmp+0x3e>
    return 0;
801057eb:	b8 00 00 00 00       	mov    $0x0,%eax
801057f0:	eb 16                	jmp    80105808 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801057f2:	8b 45 08             	mov    0x8(%ebp),%eax
801057f5:	0f b6 00             	movzbl (%eax),%eax
801057f8:	0f b6 d0             	movzbl %al,%edx
801057fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801057fe:	0f b6 00             	movzbl (%eax),%eax
80105801:	0f b6 c0             	movzbl %al,%eax
80105804:	29 c2                	sub    %eax,%edx
80105806:	89 d0                	mov    %edx,%eax
}
80105808:	5d                   	pop    %ebp
80105809:	c3                   	ret    

8010580a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010580a:	55                   	push   %ebp
8010580b:	89 e5                	mov    %esp,%ebp
8010580d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105810:	8b 45 08             	mov    0x8(%ebp),%eax
80105813:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105816:	90                   	nop
80105817:	8b 45 10             	mov    0x10(%ebp),%eax
8010581a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010581d:	89 55 10             	mov    %edx,0x10(%ebp)
80105820:	85 c0                	test   %eax,%eax
80105822:	7e 1e                	jle    80105842 <strncpy+0x38>
80105824:	8b 45 08             	mov    0x8(%ebp),%eax
80105827:	8d 50 01             	lea    0x1(%eax),%edx
8010582a:	89 55 08             	mov    %edx,0x8(%ebp)
8010582d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105830:	8d 4a 01             	lea    0x1(%edx),%ecx
80105833:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105836:	0f b6 12             	movzbl (%edx),%edx
80105839:	88 10                	mov    %dl,(%eax)
8010583b:	0f b6 00             	movzbl (%eax),%eax
8010583e:	84 c0                	test   %al,%al
80105840:	75 d5                	jne    80105817 <strncpy+0xd>
    ;
  while(n-- > 0)
80105842:	eb 0c                	jmp    80105850 <strncpy+0x46>
    *s++ = 0;
80105844:	8b 45 08             	mov    0x8(%ebp),%eax
80105847:	8d 50 01             	lea    0x1(%eax),%edx
8010584a:	89 55 08             	mov    %edx,0x8(%ebp)
8010584d:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105850:	8b 45 10             	mov    0x10(%ebp),%eax
80105853:	8d 50 ff             	lea    -0x1(%eax),%edx
80105856:	89 55 10             	mov    %edx,0x10(%ebp)
80105859:	85 c0                	test   %eax,%eax
8010585b:	7f e7                	jg     80105844 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010585d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105860:	c9                   	leave  
80105861:	c3                   	ret    

80105862 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105862:	55                   	push   %ebp
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105868:	8b 45 08             	mov    0x8(%ebp),%eax
8010586b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010586e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105872:	7f 05                	jg     80105879 <safestrcpy+0x17>
    return os;
80105874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105877:	eb 31                	jmp    801058aa <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105879:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010587d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105881:	7e 1e                	jle    801058a1 <safestrcpy+0x3f>
80105883:	8b 45 08             	mov    0x8(%ebp),%eax
80105886:	8d 50 01             	lea    0x1(%eax),%edx
80105889:	89 55 08             	mov    %edx,0x8(%ebp)
8010588c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010588f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105892:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105895:	0f b6 12             	movzbl (%edx),%edx
80105898:	88 10                	mov    %dl,(%eax)
8010589a:	0f b6 00             	movzbl (%eax),%eax
8010589d:	84 c0                	test   %al,%al
8010589f:	75 d8                	jne    80105879 <safestrcpy+0x17>
    ;
  *s = 0;
801058a1:	8b 45 08             	mov    0x8(%ebp),%eax
801058a4:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801058a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    

801058ac <strlen>:

int
strlen(const char *s)
{
801058ac:	55                   	push   %ebp
801058ad:	89 e5                	mov    %esp,%ebp
801058af:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801058b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058b9:	eb 04                	jmp    801058bf <strlen+0x13>
801058bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058c2:	8b 45 08             	mov    0x8(%ebp),%eax
801058c5:	01 d0                	add    %edx,%eax
801058c7:	0f b6 00             	movzbl (%eax),%eax
801058ca:	84 c0                	test   %al,%al
801058cc:	75 ed                	jne    801058bb <strlen+0xf>
    ;
  return n;
801058ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058d1:	c9                   	leave  
801058d2:	c3                   	ret    

801058d3 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801058d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801058d7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801058db:	55                   	push   %ebp
  pushl %ebx
801058dc:	53                   	push   %ebx
  pushl %esi
801058dd:	56                   	push   %esi
  pushl %edi
801058de:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058df:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058e1:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801058e3:	5f                   	pop    %edi
  popl %esi
801058e4:	5e                   	pop    %esi
  popl %ebx
801058e5:	5b                   	pop    %ebx
  popl %ebp
801058e6:	5d                   	pop    %ebp
  ret
801058e7:	c3                   	ret    

801058e8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058e8:	55                   	push   %ebp
801058e9:	89 e5                	mov    %esp,%ebp
  if(addr >= thread->proc->sz || addr+4 > thread->proc->sz)
801058eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f1:	8b 40 0c             	mov    0xc(%eax),%eax
801058f4:	8b 00                	mov    (%eax),%eax
801058f6:	3b 45 08             	cmp    0x8(%ebp),%eax
801058f9:	76 15                	jbe    80105910 <fetchint+0x28>
801058fb:	8b 45 08             	mov    0x8(%ebp),%eax
801058fe:	8d 50 04             	lea    0x4(%eax),%edx
80105901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105907:	8b 40 0c             	mov    0xc(%eax),%eax
8010590a:	8b 00                	mov    (%eax),%eax
8010590c:	39 c2                	cmp    %eax,%edx
8010590e:	76 07                	jbe    80105917 <fetchint+0x2f>
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	eb 0f                	jmp    80105926 <fetchint+0x3e>
  *ip = *(int*)(addr);
80105917:	8b 45 08             	mov    0x8(%ebp),%eax
8010591a:	8b 10                	mov    (%eax),%edx
8010591c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591f:	89 10                	mov    %edx,(%eax)
  return 0;
80105921:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105926:	5d                   	pop    %ebp
80105927:	c3                   	ret    

80105928 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105928:	55                   	push   %ebp
80105929:	89 e5                	mov    %esp,%ebp
8010592b:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= thread->proc->sz)
8010592e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105934:	8b 40 0c             	mov    0xc(%eax),%eax
80105937:	8b 00                	mov    (%eax),%eax
80105939:	3b 45 08             	cmp    0x8(%ebp),%eax
8010593c:	77 07                	ja     80105945 <fetchstr+0x1d>
    return -1;
8010593e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105943:	eb 49                	jmp    8010598e <fetchstr+0x66>
  *pp = (char*)addr;
80105945:	8b 55 08             	mov    0x8(%ebp),%edx
80105948:	8b 45 0c             	mov    0xc(%ebp),%eax
8010594b:	89 10                	mov    %edx,(%eax)
  ep = (char*)thread->proc->sz;
8010594d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105953:	8b 40 0c             	mov    0xc(%eax),%eax
80105956:	8b 00                	mov    (%eax),%eax
80105958:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010595b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010595e:	8b 00                	mov    (%eax),%eax
80105960:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105963:	eb 1c                	jmp    80105981 <fetchstr+0x59>
    if(*s == 0)
80105965:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105968:	0f b6 00             	movzbl (%eax),%eax
8010596b:	84 c0                	test   %al,%al
8010596d:	75 0e                	jne    8010597d <fetchstr+0x55>
      return s - *pp;
8010596f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105972:	8b 45 0c             	mov    0xc(%ebp),%eax
80105975:	8b 00                	mov    (%eax),%eax
80105977:	29 c2                	sub    %eax,%edx
80105979:	89 d0                	mov    %edx,%eax
8010597b:	eb 11                	jmp    8010598e <fetchstr+0x66>

  if(addr >= thread->proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)thread->proc->sz;
  for(s = *pp; s < ep; s++)
8010597d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105981:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105984:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105987:	72 dc                	jb     80105965 <fetchstr+0x3d>
    if(*s == 0)
      return s - *pp;
  return -1;
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    

80105990 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  return fetchint(thread->tf->esp + 4 + 4*n, ip);
80105996:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010599c:	8b 40 10             	mov    0x10(%eax),%eax
8010599f:	8b 50 44             	mov    0x44(%eax),%edx
801059a2:	8b 45 08             	mov    0x8(%ebp),%eax
801059a5:	c1 e0 02             	shl    $0x2,%eax
801059a8:	01 d0                	add    %edx,%eax
801059aa:	8d 50 04             	lea    0x4(%eax),%edx
801059ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801059b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b4:	89 14 24             	mov    %edx,(%esp)
801059b7:	e8 2c ff ff ff       	call   801058e8 <fetchint>
}
801059bc:	c9                   	leave  
801059bd:	c3                   	ret    

801059be <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801059be:	55                   	push   %ebp
801059bf:	89 e5                	mov    %esp,%ebp
801059c1:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801059c4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801059cb:	8b 45 08             	mov    0x8(%ebp),%eax
801059ce:	89 04 24             	mov    %eax,(%esp)
801059d1:	e8 ba ff ff ff       	call   80105990 <argint>
801059d6:	85 c0                	test   %eax,%eax
801059d8:	79 07                	jns    801059e1 <argptr+0x23>
    return -1;
801059da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059df:	eb 43                	jmp    80105a24 <argptr+0x66>
  if((uint)i >= thread->proc->sz || (uint)i+size > thread->proc->sz)
801059e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059e4:	89 c2                	mov    %eax,%edx
801059e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059ec:	8b 40 0c             	mov    0xc(%eax),%eax
801059ef:	8b 00                	mov    (%eax),%eax
801059f1:	39 c2                	cmp    %eax,%edx
801059f3:	73 19                	jae    80105a0e <argptr+0x50>
801059f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059f8:	89 c2                	mov    %eax,%edx
801059fa:	8b 45 10             	mov    0x10(%ebp),%eax
801059fd:	01 c2                	add    %eax,%edx
801059ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a05:	8b 40 0c             	mov    0xc(%eax),%eax
80105a08:	8b 00                	mov    (%eax),%eax
80105a0a:	39 c2                	cmp    %eax,%edx
80105a0c:	76 07                	jbe    80105a15 <argptr+0x57>
    return -1;
80105a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a13:	eb 0f                	jmp    80105a24 <argptr+0x66>
  *pp = (char*)i;
80105a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a18:	89 c2                	mov    %eax,%edx
80105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1d:	89 10                	mov    %edx,(%eax)
  return 0;
80105a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a24:	c9                   	leave  
80105a25:	c3                   	ret    

80105a26 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105a26:	55                   	push   %ebp
80105a27:	89 e5                	mov    %esp,%ebp
80105a29:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105a2c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a33:	8b 45 08             	mov    0x8(%ebp),%eax
80105a36:	89 04 24             	mov    %eax,(%esp)
80105a39:	e8 52 ff ff ff       	call   80105990 <argint>
80105a3e:	85 c0                	test   %eax,%eax
80105a40:	79 07                	jns    80105a49 <argstr+0x23>
    return -1;
80105a42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a47:	eb 12                	jmp    80105a5b <argstr+0x35>
  return fetchstr(addr, pp);
80105a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a4f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a53:	89 04 24             	mov    %eax,(%esp)
80105a56:	e8 cd fe ff ff       	call   80105928 <fetchstr>
}
80105a5b:	c9                   	leave  
80105a5c:	c3                   	ret    

80105a5d <syscall>:
[SYS_kthread_join]    	sys_kthread_join,
};

void
syscall(void)
{
80105a5d:	55                   	push   %ebp
80105a5e:	89 e5                	mov    %esp,%ebp
80105a60:	53                   	push   %ebx
80105a61:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = thread->tf->eax;
80105a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a6a:	8b 40 10             	mov    0x10(%eax),%eax
80105a6d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a77:	7e 30                	jle    80105aa9 <syscall+0x4c>
80105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7c:	83 f8 19             	cmp    $0x19,%eax
80105a7f:	77 28                	ja     80105aa9 <syscall+0x4c>
80105a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a84:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	74 1a                	je     80105aa9 <syscall+0x4c>
    thread->tf->eax = syscalls[num]();
80105a8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a95:	8b 58 10             	mov    0x10(%eax),%ebx
80105a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9b:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105aa2:	ff d0                	call   *%eax
80105aa4:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105aa7:	eb 43                	jmp    80105aec <syscall+0x8f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            thread->proc->pid, thread->proc->name, num);
80105aa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aaf:	8b 40 0c             	mov    0xc(%eax),%eax
80105ab2:	8d 48 60             	lea    0x60(%eax),%ecx
80105ab5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105abb:	8b 40 0c             	mov    0xc(%eax),%eax

  num = thread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    thread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105abe:	8b 40 0c             	mov    0xc(%eax),%eax
80105ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ac4:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105ac8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ad0:	c7 04 24 0b 8f 10 80 	movl   $0x80108f0b,(%esp)
80105ad7:	e8 c4 a8 ff ff       	call   801003a0 <cprintf>
            thread->proc->pid, thread->proc->name, num);
    thread->tf->eax = -1;
80105adc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae2:	8b 40 10             	mov    0x10(%eax),%eax
80105ae5:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105aec:	83 c4 24             	add    $0x24,%esp
80105aef:	5b                   	pop    %ebx
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    

80105af2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105af2:	55                   	push   %ebp
80105af3:	89 e5                	mov    %esp,%ebp
80105af5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105af8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105afb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aff:	8b 45 08             	mov    0x8(%ebp),%eax
80105b02:	89 04 24             	mov    %eax,(%esp)
80105b05:	e8 86 fe ff ff       	call   80105990 <argint>
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	79 07                	jns    80105b15 <argfd+0x23>
    return -1;
80105b0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b13:	eb 53                	jmp    80105b68 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=thread->proc->ofile[fd]) == 0)
80105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	78 24                	js     80105b40 <argfd+0x4e>
80105b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1f:	83 f8 0f             	cmp    $0xf,%eax
80105b22:	7f 1c                	jg     80105b40 <argfd+0x4e>
80105b24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b2a:	8b 40 0c             	mov    0xc(%eax),%eax
80105b2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b30:	83 c2 04             	add    $0x4,%edx
80105b33:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b3e:	75 07                	jne    80105b47 <argfd+0x55>
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b45:	eb 21                	jmp    80105b68 <argfd+0x76>
  if(pfd)
80105b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b4b:	74 08                	je     80105b55 <argfd+0x63>
    *pfd = fd;
80105b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b53:	89 10                	mov    %edx,(%eax)
  if(pf)
80105b55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b59:	74 08                	je     80105b63 <argfd+0x71>
    *pf = f;
80105b5b:	8b 45 10             	mov    0x10(%ebp),%eax
80105b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b61:	89 10                	mov    %edx,(%eax)
  return 0;
80105b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b68:	c9                   	leave  
80105b69:	c3                   	ret    

80105b6a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b6a:	55                   	push   %ebp
80105b6b:	89 e5                	mov    %esp,%ebp
80105b6d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b77:	eb 36                	jmp    80105baf <fdalloc+0x45>
    if(thread->proc->ofile[fd] == 0){
80105b79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b7f:	8b 40 0c             	mov    0xc(%eax),%eax
80105b82:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b85:	83 c2 04             	add    $0x4,%edx
80105b88:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	75 1b                	jne    80105bab <fdalloc+0x41>
      thread->proc->ofile[fd] = f;
80105b90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b96:	8b 40 0c             	mov    0xc(%eax),%eax
80105b99:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b9c:	8d 4a 04             	lea    0x4(%edx),%ecx
80105b9f:	8b 55 08             	mov    0x8(%ebp),%edx
80105ba2:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
      return fd;
80105ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ba9:	eb 0f                	jmp    80105bba <fdalloc+0x50>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105bab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105baf:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105bb3:	7e c4                	jle    80105b79 <fdalloc+0xf>
    if(thread->proc->ofile[fd] == 0){
      thread->proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bba:	c9                   	leave  
80105bbb:	c3                   	ret    

80105bbc <sys_dup>:

int
sys_dup(void)
{
80105bbc:	55                   	push   %ebp
80105bbd:	89 e5                	mov    %esp,%ebp
80105bbf:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105bc2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105bd0:	00 
80105bd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105bd8:	e8 15 ff ff ff       	call   80105af2 <argfd>
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	79 07                	jns    80105be8 <sys_dup+0x2c>
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be6:	eb 29                	jmp    80105c11 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105beb:	89 04 24             	mov    %eax,(%esp)
80105bee:	e8 77 ff ff ff       	call   80105b6a <fdalloc>
80105bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bfa:	79 07                	jns    80105c03 <sys_dup+0x47>
    return -1;
80105bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c01:	eb 0e                	jmp    80105c11 <sys_dup+0x55>
  filedup(f);
80105c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c06:	89 04 24             	mov    %eax,(%esp)
80105c09:	e8 87 b3 ff ff       	call   80100f95 <filedup>
  return fd;
80105c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105c11:	c9                   	leave  
80105c12:	c3                   	ret    

80105c13 <sys_read>:

int
sys_read(void)
{
80105c13:	55                   	push   %ebp
80105c14:	89 e5                	mov    %esp,%ebp
80105c16:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c27:	00 
80105c28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c2f:	e8 be fe ff ff       	call   80105af2 <argfd>
80105c34:	85 c0                	test   %eax,%eax
80105c36:	78 35                	js     80105c6d <sys_read+0x5a>
80105c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105c46:	e8 45 fd ff ff       	call   80105990 <argint>
80105c4b:	85 c0                	test   %eax,%eax
80105c4d:	78 1e                	js     80105c6d <sys_read+0x5a>
80105c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c52:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c56:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c59:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c64:	e8 55 fd ff ff       	call   801059be <argptr>
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	79 07                	jns    80105c74 <sys_read+0x61>
    return -1;
80105c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c72:	eb 19                	jmp    80105c8d <sys_read+0x7a>
  return fileread(f, p, n);
80105c74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c77:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c81:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c85:	89 04 24             	mov    %eax,(%esp)
80105c88:	e8 75 b4 ff ff       	call   80101102 <fileread>
}
80105c8d:	c9                   	leave  
80105c8e:	c3                   	ret    

80105c8f <sys_write>:

int
sys_write(void)
{
80105c8f:	55                   	push   %ebp
80105c90:	89 e5                	mov    %esp,%ebp
80105c92:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c98:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ca3:	00 
80105ca4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cab:	e8 42 fe ff ff       	call   80105af2 <argfd>
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	78 35                	js     80105ce9 <sys_write+0x5a>
80105cb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105cc2:	e8 c9 fc ff ff       	call   80105990 <argint>
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	78 1e                	js     80105ce9 <sys_write+0x5a>
80105ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cce:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cd2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ce0:	e8 d9 fc ff ff       	call   801059be <argptr>
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	79 07                	jns    80105cf0 <sys_write+0x61>
    return -1;
80105ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cee:	eb 19                	jmp    80105d09 <sys_write+0x7a>
  return filewrite(f, p, n);
80105cf0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105cf3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105cfd:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d01:	89 04 24             	mov    %eax,(%esp)
80105d04:	e8 b5 b4 ff ff       	call   801011be <filewrite>
}
80105d09:	c9                   	leave  
80105d0a:	c3                   	ret    

80105d0b <sys_close>:

int
sys_close(void)
{
80105d0b:	55                   	push   %ebp
80105d0c:	89 e5                	mov    %esp,%ebp
80105d0e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105d11:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d14:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d18:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d26:	e8 c7 fd ff ff       	call   80105af2 <argfd>
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	79 07                	jns    80105d36 <sys_close+0x2b>
    return -1;
80105d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d34:	eb 27                	jmp    80105d5d <sys_close+0x52>
  thread->proc->ofile[fd] = 0;
80105d36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d3c:	8b 40 0c             	mov    0xc(%eax),%eax
80105d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d42:	83 c2 04             	add    $0x4,%edx
80105d45:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80105d4c:	00 
  fileclose(f);
80105d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d50:	89 04 24             	mov    %eax,(%esp)
80105d53:	e8 85 b2 ff ff       	call   80100fdd <fileclose>
  return 0;
80105d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    

80105d5f <sys_fstat>:

int
sys_fstat(void)
{
80105d5f:	55                   	push   %ebp
80105d60:	89 e5                	mov    %esp,%ebp
80105d62:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d68:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d6c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d73:	00 
80105d74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d7b:	e8 72 fd ff ff       	call   80105af2 <argfd>
80105d80:	85 c0                	test   %eax,%eax
80105d82:	78 1f                	js     80105da3 <sys_fstat+0x44>
80105d84:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105d8b:	00 
80105d8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d9a:	e8 1f fc ff ff       	call   801059be <argptr>
80105d9f:	85 c0                	test   %eax,%eax
80105da1:	79 07                	jns    80105daa <sys_fstat+0x4b>
    return -1;
80105da3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da8:	eb 12                	jmp    80105dbc <sys_fstat+0x5d>
  return filestat(f, st);
80105daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	89 54 24 04          	mov    %edx,0x4(%esp)
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 f7 b2 ff ff       	call   801010b3 <filestat>
}
80105dbc:	c9                   	leave  
80105dbd:	c3                   	ret    

80105dbe <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105dbe:	55                   	push   %ebp
80105dbf:	89 e5                	mov    %esp,%ebp
80105dc1:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105dc4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dd2:	e8 4f fc ff ff       	call   80105a26 <argstr>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	78 17                	js     80105df2 <sys_link+0x34>
80105ddb:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80105de2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105de9:	e8 38 fc ff ff       	call   80105a26 <argstr>
80105dee:	85 c0                	test   %eax,%eax
80105df0:	79 0a                	jns    80105dfc <sys_link+0x3e>
    return -1;
80105df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df7:	e9 42 01 00 00       	jmp    80105f3e <sys_link+0x180>

  begin_op();
80105dfc:	e8 21 d6 ff ff       	call   80103422 <begin_op>
  if((ip = namei(old)) == 0){
80105e01:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105e04:	89 04 24             	mov    %eax,(%esp)
80105e07:	e8 0c c6 ff ff       	call   80102418 <namei>
80105e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e13:	75 0f                	jne    80105e24 <sys_link+0x66>
    end_op();
80105e15:	e8 8c d6 ff ff       	call   801034a6 <end_op>
    return -1;
80105e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1f:	e9 1a 01 00 00       	jmp    80105f3e <sys_link+0x180>
  }

  ilock(ip);
80105e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e27:	89 04 24             	mov    %eax,(%esp)
80105e2a:	e8 3b ba ff ff       	call   8010186a <ilock>
  if(ip->type == T_DIR){
80105e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e32:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e36:	66 83 f8 01          	cmp    $0x1,%ax
80105e3a:	75 1a                	jne    80105e56 <sys_link+0x98>
    iunlockput(ip);
80105e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3f:	89 04 24             	mov    %eax,(%esp)
80105e42:	e8 a7 bc ff ff       	call   80101aee <iunlockput>
    end_op();
80105e47:	e8 5a d6 ff ff       	call   801034a6 <end_op>
    return -1;
80105e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e51:	e9 e8 00 00 00       	jmp    80105f3e <sys_link+0x180>
  }

  ip->nlink++;
80105e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e59:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e5d:	8d 50 01             	lea    0x1(%eax),%edx
80105e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e63:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6a:	89 04 24             	mov    %eax,(%esp)
80105e6d:	e8 3c b8 ff ff       	call   801016ae <iupdate>
  iunlock(ip);
80105e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e75:	89 04 24             	mov    %eax,(%esp)
80105e78:	e8 3b bb ff ff       	call   801019b8 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e80:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105e83:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e87:	89 04 24             	mov    %eax,(%esp)
80105e8a:	e8 ab c5 ff ff       	call   8010243a <nameiparent>
80105e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e96:	75 02                	jne    80105e9a <sys_link+0xdc>
    goto bad;
80105e98:	eb 68                	jmp    80105f02 <sys_link+0x144>
  ilock(dp);
80105e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9d:	89 04 24             	mov    %eax,(%esp)
80105ea0:	e8 c5 b9 ff ff       	call   8010186a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea8:	8b 10                	mov    (%eax),%edx
80105eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ead:	8b 00                	mov    (%eax),%eax
80105eaf:	39 c2                	cmp    %eax,%edx
80105eb1:	75 20                	jne    80105ed3 <sys_link+0x115>
80105eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb6:	8b 40 04             	mov    0x4(%eax),%eax
80105eb9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ebd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec7:	89 04 24             	mov    %eax,(%esp)
80105eca:	e8 86 c2 ff ff       	call   80102155 <dirlink>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	79 0d                	jns    80105ee0 <sys_link+0x122>
    iunlockput(dp);
80105ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed6:	89 04 24             	mov    %eax,(%esp)
80105ed9:	e8 10 bc ff ff       	call   80101aee <iunlockput>
    goto bad;
80105ede:	eb 22                	jmp    80105f02 <sys_link+0x144>
  }
  iunlockput(dp);
80105ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee3:	89 04 24             	mov    %eax,(%esp)
80105ee6:	e8 03 bc ff ff       	call   80101aee <iunlockput>
  iput(ip);
80105eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eee:	89 04 24             	mov    %eax,(%esp)
80105ef1:	e8 27 bb ff ff       	call   80101a1d <iput>

  end_op();
80105ef6:	e8 ab d5 ff ff       	call   801034a6 <end_op>

  return 0;
80105efb:	b8 00 00 00 00       	mov    $0x0,%eax
80105f00:	eb 3c                	jmp    80105f3e <sys_link+0x180>

bad:
  ilock(ip);
80105f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f05:	89 04 24             	mov    %eax,(%esp)
80105f08:	e8 5d b9 ff ff       	call   8010186a <ilock>
  ip->nlink--;
80105f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f10:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f14:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f1a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f21:	89 04 24             	mov    %eax,(%esp)
80105f24:	e8 85 b7 ff ff       	call   801016ae <iupdate>
  iunlockput(ip);
80105f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2c:	89 04 24             	mov    %eax,(%esp)
80105f2f:	e8 ba bb ff ff       	call   80101aee <iunlockput>
  end_op();
80105f34:	e8 6d d5 ff ff       	call   801034a6 <end_op>
  return -1;
80105f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f3e:	c9                   	leave  
80105f3f:	c3                   	ret    

80105f40 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f46:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105f4d:	eb 4b                	jmp    80105f9a <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f52:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105f59:	00 
80105f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f5e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f61:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f65:	8b 45 08             	mov    0x8(%ebp),%eax
80105f68:	89 04 24             	mov    %eax,(%esp)
80105f6b:	e8 07 be ff ff       	call   80101d77 <readi>
80105f70:	83 f8 10             	cmp    $0x10,%eax
80105f73:	74 0c                	je     80105f81 <isdirempty+0x41>
      panic("isdirempty: readi");
80105f75:	c7 04 24 27 8f 10 80 	movl   $0x80108f27,(%esp)
80105f7c:	e8 b9 a5 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105f81:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105f85:	66 85 c0             	test   %ax,%ax
80105f88:	74 07                	je     80105f91 <isdirempty+0x51>
      return 0;
80105f8a:	b8 00 00 00 00       	mov    $0x0,%eax
80105f8f:	eb 1b                	jmp    80105fac <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f94:	83 c0 10             	add    $0x10,%eax
80105f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa0:	8b 40 18             	mov    0x18(%eax),%eax
80105fa3:	39 c2                	cmp    %eax,%edx
80105fa5:	72 a8                	jb     80105f4f <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105fa7:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105fac:	c9                   	leave  
80105fad:	c3                   	ret    

80105fae <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105fae:	55                   	push   %ebp
80105faf:	89 e5                	mov    %esp,%ebp
80105fb1:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105fb4:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fc2:	e8 5f fa ff ff       	call   80105a26 <argstr>
80105fc7:	85 c0                	test   %eax,%eax
80105fc9:	79 0a                	jns    80105fd5 <sys_unlink+0x27>
    return -1;
80105fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd0:	e9 af 01 00 00       	jmp    80106184 <sys_unlink+0x1d6>

  begin_op();
80105fd5:	e8 48 d4 ff ff       	call   80103422 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105fda:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105fdd:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105fe0:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fe4:	89 04 24             	mov    %eax,(%esp)
80105fe7:	e8 4e c4 ff ff       	call   8010243a <nameiparent>
80105fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ff3:	75 0f                	jne    80106004 <sys_unlink+0x56>
    end_op();
80105ff5:	e8 ac d4 ff ff       	call   801034a6 <end_op>
    return -1;
80105ffa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fff:	e9 80 01 00 00       	jmp    80106184 <sys_unlink+0x1d6>
  }

  ilock(dp);
80106004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106007:	89 04 24             	mov    %eax,(%esp)
8010600a:	e8 5b b8 ff ff       	call   8010186a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010600f:	c7 44 24 04 39 8f 10 	movl   $0x80108f39,0x4(%esp)
80106016:	80 
80106017:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010601a:	89 04 24             	mov    %eax,(%esp)
8010601d:	e8 48 c0 ff ff       	call   8010206a <namecmp>
80106022:	85 c0                	test   %eax,%eax
80106024:	0f 84 45 01 00 00    	je     8010616f <sys_unlink+0x1c1>
8010602a:	c7 44 24 04 3b 8f 10 	movl   $0x80108f3b,0x4(%esp)
80106031:	80 
80106032:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106035:	89 04 24             	mov    %eax,(%esp)
80106038:	e8 2d c0 ff ff       	call   8010206a <namecmp>
8010603d:	85 c0                	test   %eax,%eax
8010603f:	0f 84 2a 01 00 00    	je     8010616f <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106045:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106048:	89 44 24 08          	mov    %eax,0x8(%esp)
8010604c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010604f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106056:	89 04 24             	mov    %eax,(%esp)
80106059:	e8 2e c0 ff ff       	call   8010208c <dirlookup>
8010605e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106065:	75 05                	jne    8010606c <sys_unlink+0xbe>
    goto bad;
80106067:	e9 03 01 00 00       	jmp    8010616f <sys_unlink+0x1c1>
  ilock(ip);
8010606c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606f:	89 04 24             	mov    %eax,(%esp)
80106072:	e8 f3 b7 ff ff       	call   8010186a <ilock>

  if(ip->nlink < 1)
80106077:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010607e:	66 85 c0             	test   %ax,%ax
80106081:	7f 0c                	jg     8010608f <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106083:	c7 04 24 3e 8f 10 80 	movl   $0x80108f3e,(%esp)
8010608a:	e8 ab a4 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010608f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106092:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106096:	66 83 f8 01          	cmp    $0x1,%ax
8010609a:	75 1f                	jne    801060bb <sys_unlink+0x10d>
8010609c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010609f:	89 04 24             	mov    %eax,(%esp)
801060a2:	e8 99 fe ff ff       	call   80105f40 <isdirempty>
801060a7:	85 c0                	test   %eax,%eax
801060a9:	75 10                	jne    801060bb <sys_unlink+0x10d>
    iunlockput(ip);
801060ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ae:	89 04 24             	mov    %eax,(%esp)
801060b1:	e8 38 ba ff ff       	call   80101aee <iunlockput>
    goto bad;
801060b6:	e9 b4 00 00 00       	jmp    8010616f <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
801060bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801060c2:	00 
801060c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060ca:	00 
801060cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060ce:	89 04 24             	mov    %eax,(%esp)
801060d1:	e8 6c f5 ff ff       	call   80105642 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801060d9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801060e0:	00 
801060e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801060e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801060ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ef:	89 04 24             	mov    %eax,(%esp)
801060f2:	e8 e4 bd ff ff       	call   80101edb <writei>
801060f7:	83 f8 10             	cmp    $0x10,%eax
801060fa:	74 0c                	je     80106108 <sys_unlink+0x15a>
    panic("unlink: writei");
801060fc:	c7 04 24 50 8f 10 80 	movl   $0x80108f50,(%esp)
80106103:	e8 32 a4 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80106108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010610f:	66 83 f8 01          	cmp    $0x1,%ax
80106113:	75 1c                	jne    80106131 <sys_unlink+0x183>
    dp->nlink--;
80106115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106118:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010611c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010611f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106122:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106129:	89 04 24             	mov    %eax,(%esp)
8010612c:	e8 7d b5 ff ff       	call   801016ae <iupdate>
  }
  iunlockput(dp);
80106131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106134:	89 04 24             	mov    %eax,(%esp)
80106137:	e8 b2 b9 ff ff       	call   80101aee <iunlockput>

  ip->nlink--;
8010613c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106143:	8d 50 ff             	lea    -0x1(%eax),%edx
80106146:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106149:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010614d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106150:	89 04 24             	mov    %eax,(%esp)
80106153:	e8 56 b5 ff ff       	call   801016ae <iupdate>
  iunlockput(ip);
80106158:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615b:	89 04 24             	mov    %eax,(%esp)
8010615e:	e8 8b b9 ff ff       	call   80101aee <iunlockput>

  end_op();
80106163:	e8 3e d3 ff ff       	call   801034a6 <end_op>

  return 0;
80106168:	b8 00 00 00 00       	mov    $0x0,%eax
8010616d:	eb 15                	jmp    80106184 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
8010616f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106172:	89 04 24             	mov    %eax,(%esp)
80106175:	e8 74 b9 ff ff       	call   80101aee <iunlockput>
  end_op();
8010617a:	e8 27 d3 ff ff       	call   801034a6 <end_op>
  return -1;
8010617f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106184:	c9                   	leave  
80106185:	c3                   	ret    

80106186 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106186:	55                   	push   %ebp
80106187:	89 e5                	mov    %esp,%ebp
80106189:	83 ec 48             	sub    $0x48,%esp
8010618c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010618f:	8b 55 10             	mov    0x10(%ebp),%edx
80106192:	8b 45 14             	mov    0x14(%ebp),%eax
80106195:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106199:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010619d:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801061a1:	8d 45 de             	lea    -0x22(%ebp),%eax
801061a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a8:	8b 45 08             	mov    0x8(%ebp),%eax
801061ab:	89 04 24             	mov    %eax,(%esp)
801061ae:	e8 87 c2 ff ff       	call   8010243a <nameiparent>
801061b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ba:	75 0a                	jne    801061c6 <create+0x40>
    return 0;
801061bc:	b8 00 00 00 00       	mov    $0x0,%eax
801061c1:	e9 7e 01 00 00       	jmp    80106344 <create+0x1be>
  ilock(dp);
801061c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c9:	89 04 24             	mov    %eax,(%esp)
801061cc:	e8 99 b6 ff ff       	call   8010186a <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801061d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d8:	8d 45 de             	lea    -0x22(%ebp),%eax
801061db:	89 44 24 04          	mov    %eax,0x4(%esp)
801061df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e2:	89 04 24             	mov    %eax,(%esp)
801061e5:	e8 a2 be ff ff       	call   8010208c <dirlookup>
801061ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061f1:	74 47                	je     8010623a <create+0xb4>
    iunlockput(dp);
801061f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f6:	89 04 24             	mov    %eax,(%esp)
801061f9:	e8 f0 b8 ff ff       	call   80101aee <iunlockput>
    ilock(ip);
801061fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106201:	89 04 24             	mov    %eax,(%esp)
80106204:	e8 61 b6 ff ff       	call   8010186a <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106209:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010620e:	75 15                	jne    80106225 <create+0x9f>
80106210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106213:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106217:	66 83 f8 02          	cmp    $0x2,%ax
8010621b:	75 08                	jne    80106225 <create+0x9f>
      return ip;
8010621d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106220:	e9 1f 01 00 00       	jmp    80106344 <create+0x1be>
    iunlockput(ip);
80106225:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106228:	89 04 24             	mov    %eax,(%esp)
8010622b:	e8 be b8 ff ff       	call   80101aee <iunlockput>
    return 0;
80106230:	b8 00 00 00 00       	mov    $0x0,%eax
80106235:	e9 0a 01 00 00       	jmp    80106344 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010623a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010623e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106241:	8b 00                	mov    (%eax),%eax
80106243:	89 54 24 04          	mov    %edx,0x4(%esp)
80106247:	89 04 24             	mov    %eax,(%esp)
8010624a:	e8 80 b3 ff ff       	call   801015cf <ialloc>
8010624f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106256:	75 0c                	jne    80106264 <create+0xde>
    panic("create: ialloc");
80106258:	c7 04 24 5f 8f 10 80 	movl   $0x80108f5f,(%esp)
8010625f:	e8 d6 a2 ff ff       	call   8010053a <panic>

  ilock(ip);
80106264:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106267:	89 04 24             	mov    %eax,(%esp)
8010626a:	e8 fb b5 ff ff       	call   8010186a <ilock>
  ip->major = major;
8010626f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106272:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106276:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010627a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627d:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106281:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106285:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106288:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010628e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106291:	89 04 24             	mov    %eax,(%esp)
80106294:	e8 15 b4 ff ff       	call   801016ae <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106299:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010629e:	75 6a                	jne    8010630a <create+0x184>
    dp->nlink++;  // for ".."
801062a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062a7:	8d 50 01             	lea    0x1(%eax),%edx
801062aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ad:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801062b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b4:	89 04 24             	mov    %eax,(%esp)
801062b7:	e8 f2 b3 ff ff       	call   801016ae <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801062bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062bf:	8b 40 04             	mov    0x4(%eax),%eax
801062c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801062c6:	c7 44 24 04 39 8f 10 	movl   $0x80108f39,0x4(%esp)
801062cd:	80 
801062ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d1:	89 04 24             	mov    %eax,(%esp)
801062d4:	e8 7c be ff ff       	call   80102155 <dirlink>
801062d9:	85 c0                	test   %eax,%eax
801062db:	78 21                	js     801062fe <create+0x178>
801062dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e0:	8b 40 04             	mov    0x4(%eax),%eax
801062e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801062e7:	c7 44 24 04 3b 8f 10 	movl   $0x80108f3b,0x4(%esp)
801062ee:	80 
801062ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f2:	89 04 24             	mov    %eax,(%esp)
801062f5:	e8 5b be ff ff       	call   80102155 <dirlink>
801062fa:	85 c0                	test   %eax,%eax
801062fc:	79 0c                	jns    8010630a <create+0x184>
      panic("create dots");
801062fe:	c7 04 24 6e 8f 10 80 	movl   $0x80108f6e,(%esp)
80106305:	e8 30 a2 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010630a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630d:	8b 40 04             	mov    0x4(%eax),%eax
80106310:	89 44 24 08          	mov    %eax,0x8(%esp)
80106314:	8d 45 de             	lea    -0x22(%ebp),%eax
80106317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010631b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631e:	89 04 24             	mov    %eax,(%esp)
80106321:	e8 2f be ff ff       	call   80102155 <dirlink>
80106326:	85 c0                	test   %eax,%eax
80106328:	79 0c                	jns    80106336 <create+0x1b0>
    panic("create: dirlink");
8010632a:	c7 04 24 7a 8f 10 80 	movl   $0x80108f7a,(%esp)
80106331:	e8 04 a2 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106339:	89 04 24             	mov    %eax,(%esp)
8010633c:	e8 ad b7 ff ff       	call   80101aee <iunlockput>

  return ip;
80106341:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106344:	c9                   	leave  
80106345:	c3                   	ret    

80106346 <sys_open>:

int
sys_open(void)
{
80106346:	55                   	push   %ebp
80106347:	89 e5                	mov    %esp,%ebp
80106349:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010634c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010634f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106353:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010635a:	e8 c7 f6 ff ff       	call   80105a26 <argstr>
8010635f:	85 c0                	test   %eax,%eax
80106361:	78 17                	js     8010637a <sys_open+0x34>
80106363:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106366:	89 44 24 04          	mov    %eax,0x4(%esp)
8010636a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106371:	e8 1a f6 ff ff       	call   80105990 <argint>
80106376:	85 c0                	test   %eax,%eax
80106378:	79 0a                	jns    80106384 <sys_open+0x3e>
    return -1;
8010637a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637f:	e9 5c 01 00 00       	jmp    801064e0 <sys_open+0x19a>

  begin_op();
80106384:	e8 99 d0 ff ff       	call   80103422 <begin_op>

  if(omode & O_CREATE){
80106389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010638c:	25 00 02 00 00       	and    $0x200,%eax
80106391:	85 c0                	test   %eax,%eax
80106393:	74 3b                	je     801063d0 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106395:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106398:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010639f:	00 
801063a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801063a7:	00 
801063a8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801063af:	00 
801063b0:	89 04 24             	mov    %eax,(%esp)
801063b3:	e8 ce fd ff ff       	call   80106186 <create>
801063b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801063bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063bf:	75 6b                	jne    8010642c <sys_open+0xe6>
      end_op();
801063c1:	e8 e0 d0 ff ff       	call   801034a6 <end_op>
      return -1;
801063c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063cb:	e9 10 01 00 00       	jmp    801064e0 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801063d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063d3:	89 04 24             	mov    %eax,(%esp)
801063d6:	e8 3d c0 ff ff       	call   80102418 <namei>
801063db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063e2:	75 0f                	jne    801063f3 <sys_open+0xad>
      end_op();
801063e4:	e8 bd d0 ff ff       	call   801034a6 <end_op>
      return -1;
801063e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ee:	e9 ed 00 00 00       	jmp    801064e0 <sys_open+0x19a>
    }
    ilock(ip);
801063f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f6:	89 04 24             	mov    %eax,(%esp)
801063f9:	e8 6c b4 ff ff       	call   8010186a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801063fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106401:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106405:	66 83 f8 01          	cmp    $0x1,%ax
80106409:	75 21                	jne    8010642c <sys_open+0xe6>
8010640b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010640e:	85 c0                	test   %eax,%eax
80106410:	74 1a                	je     8010642c <sys_open+0xe6>
      iunlockput(ip);
80106412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106415:	89 04 24             	mov    %eax,(%esp)
80106418:	e8 d1 b6 ff ff       	call   80101aee <iunlockput>
      end_op();
8010641d:	e8 84 d0 ff ff       	call   801034a6 <end_op>
      return -1;
80106422:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106427:	e9 b4 00 00 00       	jmp    801064e0 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010642c:	e8 04 ab ff ff       	call   80100f35 <filealloc>
80106431:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106438:	74 14                	je     8010644e <sys_open+0x108>
8010643a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643d:	89 04 24             	mov    %eax,(%esp)
80106440:	e8 25 f7 ff ff       	call   80105b6a <fdalloc>
80106445:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106448:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010644c:	79 28                	jns    80106476 <sys_open+0x130>
    if(f)
8010644e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106452:	74 0b                	je     8010645f <sys_open+0x119>
      fileclose(f);
80106454:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106457:	89 04 24             	mov    %eax,(%esp)
8010645a:	e8 7e ab ff ff       	call   80100fdd <fileclose>
    iunlockput(ip);
8010645f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106462:	89 04 24             	mov    %eax,(%esp)
80106465:	e8 84 b6 ff ff       	call   80101aee <iunlockput>
    end_op();
8010646a:	e8 37 d0 ff ff       	call   801034a6 <end_op>
    return -1;
8010646f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106474:	eb 6a                	jmp    801064e0 <sys_open+0x19a>
  }
  iunlock(ip);
80106476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106479:	89 04 24             	mov    %eax,(%esp)
8010647c:	e8 37 b5 ff ff       	call   801019b8 <iunlock>
  end_op();
80106481:	e8 20 d0 ff ff       	call   801034a6 <end_op>

  f->type = FD_INODE;
80106486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106489:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010648f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106492:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106495:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801064a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a5:	83 e0 01             	and    $0x1,%eax
801064a8:	85 c0                	test   %eax,%eax
801064aa:	0f 94 c0             	sete   %al
801064ad:	89 c2                	mov    %eax,%edx
801064af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b2:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801064b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064b8:	83 e0 01             	and    $0x1,%eax
801064bb:	85 c0                	test   %eax,%eax
801064bd:	75 0a                	jne    801064c9 <sys_open+0x183>
801064bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064c2:	83 e0 02             	and    $0x2,%eax
801064c5:	85 c0                	test   %eax,%eax
801064c7:	74 07                	je     801064d0 <sys_open+0x18a>
801064c9:	b8 01 00 00 00       	mov    $0x1,%eax
801064ce:	eb 05                	jmp    801064d5 <sys_open+0x18f>
801064d0:	b8 00 00 00 00       	mov    $0x0,%eax
801064d5:	89 c2                	mov    %eax,%edx
801064d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064da:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801064dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801064e0:	c9                   	leave  
801064e1:	c3                   	ret    

801064e2 <sys_mkdir>:

int
sys_mkdir(void)
{
801064e2:	55                   	push   %ebp
801064e3:	89 e5                	mov    %esp,%ebp
801064e5:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064e8:	e8 35 cf ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801064ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801064f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064fb:	e8 26 f5 ff ff       	call   80105a26 <argstr>
80106500:	85 c0                	test   %eax,%eax
80106502:	78 2c                	js     80106530 <sys_mkdir+0x4e>
80106504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106507:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010650e:	00 
8010650f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106516:	00 
80106517:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010651e:	00 
8010651f:	89 04 24             	mov    %eax,(%esp)
80106522:	e8 5f fc ff ff       	call   80106186 <create>
80106527:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010652a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010652e:	75 0c                	jne    8010653c <sys_mkdir+0x5a>
    end_op();
80106530:	e8 71 cf ff ff       	call   801034a6 <end_op>
    return -1;
80106535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010653a:	eb 15                	jmp    80106551 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010653c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653f:	89 04 24             	mov    %eax,(%esp)
80106542:	e8 a7 b5 ff ff       	call   80101aee <iunlockput>
  end_op();
80106547:	e8 5a cf ff ff       	call   801034a6 <end_op>
  return 0;
8010654c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106551:	c9                   	leave  
80106552:	c3                   	ret    

80106553 <sys_mknod>:

int
sys_mknod(void)
{
80106553:	55                   	push   %ebp
80106554:	89 e5                	mov    %esp,%ebp
80106556:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106559:	e8 c4 ce ff ff       	call   80103422 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010655e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106561:	89 44 24 04          	mov    %eax,0x4(%esp)
80106565:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010656c:	e8 b5 f4 ff ff       	call   80105a26 <argstr>
80106571:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106578:	78 5e                	js     801065d8 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010657a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010657d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106581:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106588:	e8 03 f4 ff ff       	call   80105990 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010658d:	85 c0                	test   %eax,%eax
8010658f:	78 47                	js     801065d8 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106591:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106594:	89 44 24 04          	mov    %eax,0x4(%esp)
80106598:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010659f:	e8 ec f3 ff ff       	call   80105990 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801065a4:	85 c0                	test   %eax,%eax
801065a6:	78 30                	js     801065d8 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801065a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ab:	0f bf c8             	movswl %ax,%ecx
801065ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065b1:	0f bf d0             	movswl %ax,%edx
801065b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801065b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801065bb:	89 54 24 08          	mov    %edx,0x8(%esp)
801065bf:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801065c6:	00 
801065c7:	89 04 24             	mov    %eax,(%esp)
801065ca:	e8 b7 fb ff ff       	call   80106186 <create>
801065cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065d6:	75 0c                	jne    801065e4 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801065d8:	e8 c9 ce ff ff       	call   801034a6 <end_op>
    return -1;
801065dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e2:	eb 15                	jmp    801065f9 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801065e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e7:	89 04 24             	mov    %eax,(%esp)
801065ea:	e8 ff b4 ff ff       	call   80101aee <iunlockput>
  end_op();
801065ef:	e8 b2 ce ff ff       	call   801034a6 <end_op>
  return 0;
801065f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065f9:	c9                   	leave  
801065fa:	c3                   	ret    

801065fb <sys_chdir>:

int
sys_chdir(void)
{
801065fb:	55                   	push   %ebp
801065fc:	89 e5                	mov    %esp,%ebp
801065fe:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106601:	e8 1c ce ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106606:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106609:	89 44 24 04          	mov    %eax,0x4(%esp)
8010660d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106614:	e8 0d f4 ff ff       	call   80105a26 <argstr>
80106619:	85 c0                	test   %eax,%eax
8010661b:	78 14                	js     80106631 <sys_chdir+0x36>
8010661d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106620:	89 04 24             	mov    %eax,(%esp)
80106623:	e8 f0 bd ff ff       	call   80102418 <namei>
80106628:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010662b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010662f:	75 0c                	jne    8010663d <sys_chdir+0x42>
    end_op();
80106631:	e8 70 ce ff ff       	call   801034a6 <end_op>
    return -1;
80106636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663b:	eb 67                	jmp    801066a4 <sys_chdir+0xa9>
  }
  ilock(ip);
8010663d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106640:	89 04 24             	mov    %eax,(%esp)
80106643:	e8 22 b2 ff ff       	call   8010186a <ilock>
  if(ip->type != T_DIR){
80106648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010664f:	66 83 f8 01          	cmp    $0x1,%ax
80106653:	74 17                	je     8010666c <sys_chdir+0x71>
    iunlockput(ip);
80106655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106658:	89 04 24             	mov    %eax,(%esp)
8010665b:	e8 8e b4 ff ff       	call   80101aee <iunlockput>
    end_op();
80106660:	e8 41 ce ff ff       	call   801034a6 <end_op>
    return -1;
80106665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666a:	eb 38                	jmp    801066a4 <sys_chdir+0xa9>
  }
  iunlock(ip);
8010666c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666f:	89 04 24             	mov    %eax,(%esp)
80106672:	e8 41 b3 ff ff       	call   801019b8 <iunlock>
  iput(thread->proc->cwd);
80106677:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010667d:	8b 40 0c             	mov    0xc(%eax),%eax
80106680:	8b 40 5c             	mov    0x5c(%eax),%eax
80106683:	89 04 24             	mov    %eax,(%esp)
80106686:	e8 92 b3 ff ff       	call   80101a1d <iput>
  end_op();
8010668b:	e8 16 ce ff ff       	call   801034a6 <end_op>
  thread->proc->cwd = ip;
80106690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106696:	8b 40 0c             	mov    0xc(%eax),%eax
80106699:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010669c:	89 50 5c             	mov    %edx,0x5c(%eax)
  return 0;
8010669f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066a4:	c9                   	leave  
801066a5:	c3                   	ret    

801066a6 <sys_exec>:

int
sys_exec(void)
{
801066a6:	55                   	push   %ebp
801066a7:	89 e5                	mov    %esp,%ebp
801066a9:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801066af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801066b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066bd:	e8 64 f3 ff ff       	call   80105a26 <argstr>
801066c2:	85 c0                	test   %eax,%eax
801066c4:	78 1a                	js     801066e0 <sys_exec+0x3a>
801066c6:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801066cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801066d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801066d7:	e8 b4 f2 ff ff       	call   80105990 <argint>
801066dc:	85 c0                	test   %eax,%eax
801066de:	79 0a                	jns    801066ea <sys_exec+0x44>
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e5:	e9 c8 00 00 00       	jmp    801067b2 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801066ea:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801066f1:	00 
801066f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066f9:	00 
801066fa:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106700:	89 04 24             	mov    %eax,(%esp)
80106703:	e8 3a ef ff ff       	call   80105642 <memset>
  for(i=0;; i++){
80106708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010670f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106712:	83 f8 1f             	cmp    $0x1f,%eax
80106715:	76 0a                	jbe    80106721 <sys_exec+0x7b>
      return -1;
80106717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671c:	e9 91 00 00 00       	jmp    801067b2 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106724:	c1 e0 02             	shl    $0x2,%eax
80106727:	89 c2                	mov    %eax,%edx
80106729:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010672f:	01 c2                	add    %eax,%edx
80106731:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010673b:	89 14 24             	mov    %edx,(%esp)
8010673e:	e8 a5 f1 ff ff       	call   801058e8 <fetchint>
80106743:	85 c0                	test   %eax,%eax
80106745:	79 07                	jns    8010674e <sys_exec+0xa8>
      return -1;
80106747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674c:	eb 64                	jmp    801067b2 <sys_exec+0x10c>
    if(uarg == 0){
8010674e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106754:	85 c0                	test   %eax,%eax
80106756:	75 26                	jne    8010677e <sys_exec+0xd8>
      argv[i] = 0;
80106758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106762:	00 00 00 00 
      break;
80106766:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106770:	89 54 24 04          	mov    %edx,0x4(%esp)
80106774:	89 04 24             	mov    %eax,(%esp)
80106777:	e8 76 a3 ff ff       	call   80100af2 <exec>
8010677c:	eb 34                	jmp    801067b2 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010677e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106784:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106787:	c1 e2 02             	shl    $0x2,%edx
8010678a:	01 c2                	add    %eax,%edx
8010678c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106792:	89 54 24 04          	mov    %edx,0x4(%esp)
80106796:	89 04 24             	mov    %eax,(%esp)
80106799:	e8 8a f1 ff ff       	call   80105928 <fetchstr>
8010679e:	85 c0                	test   %eax,%eax
801067a0:	79 07                	jns    801067a9 <sys_exec+0x103>
      return -1;
801067a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a7:	eb 09                	jmp    801067b2 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801067a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801067ad:	e9 5d ff ff ff       	jmp    8010670f <sys_exec+0x69>
  return exec(path, argv);
}
801067b2:	c9                   	leave  
801067b3:	c3                   	ret    

801067b4 <sys_pipe>:

int
sys_pipe(void)
{
801067b4:	55                   	push   %ebp
801067b5:	89 e5                	mov    %esp,%ebp
801067b7:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801067ba:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801067c1:	00 
801067c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801067c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067d0:	e8 e9 f1 ff ff       	call   801059be <argptr>
801067d5:	85 c0                	test   %eax,%eax
801067d7:	79 0a                	jns    801067e3 <sys_pipe+0x2f>
    return -1;
801067d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067de:	e9 a1 00 00 00       	jmp    80106884 <sys_pipe+0xd0>
  if(pipealloc(&rf, &wf) < 0)
801067e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ea:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067ed:	89 04 24             	mov    %eax,(%esp)
801067f0:	e8 3e d7 ff ff       	call   80103f33 <pipealloc>
801067f5:	85 c0                	test   %eax,%eax
801067f7:	79 0a                	jns    80106803 <sys_pipe+0x4f>
    return -1;
801067f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067fe:	e9 81 00 00 00       	jmp    80106884 <sys_pipe+0xd0>
  fd0 = -1;
80106803:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010680a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010680d:	89 04 24             	mov    %eax,(%esp)
80106810:	e8 55 f3 ff ff       	call   80105b6a <fdalloc>
80106815:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010681c:	78 14                	js     80106832 <sys_pipe+0x7e>
8010681e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106821:	89 04 24             	mov    %eax,(%esp)
80106824:	e8 41 f3 ff ff       	call   80105b6a <fdalloc>
80106829:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010682c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106830:	79 3a                	jns    8010686c <sys_pipe+0xb8>
    if(fd0 >= 0)
80106832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106836:	78 17                	js     8010684f <sys_pipe+0x9b>
      thread->proc->ofile[fd0] = 0;
80106838:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010683e:	8b 40 0c             	mov    0xc(%eax),%eax
80106841:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106844:	83 c2 04             	add    $0x4,%edx
80106847:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
8010684e:	00 
    fileclose(rf);
8010684f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106852:	89 04 24             	mov    %eax,(%esp)
80106855:	e8 83 a7 ff ff       	call   80100fdd <fileclose>
    fileclose(wf);
8010685a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010685d:	89 04 24             	mov    %eax,(%esp)
80106860:	e8 78 a7 ff ff       	call   80100fdd <fileclose>
    return -1;
80106865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010686a:	eb 18                	jmp    80106884 <sys_pipe+0xd0>
  }
  fd[0] = fd0;
8010686c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010686f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106872:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106877:	8d 50 04             	lea    0x4(%eax),%edx
8010687a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010687d:	89 02                	mov    %eax,(%edx)
  return 0;
8010687f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    

80106886 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106886:	55                   	push   %ebp
80106887:	89 e5                	mov    %esp,%ebp
80106889:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010688c:	e8 d6 dd ff ff       	call   80104667 <fork>
}
80106891:	c9                   	leave  
80106892:	c3                   	ret    

80106893 <sys_exit>:

int
sys_exit(void)
{
80106893:	55                   	push   %ebp
80106894:	89 e5                	mov    %esp,%ebp
80106896:	83 ec 08             	sub    $0x8,%esp
  exit();
80106899:	e8 02 e0 ff ff       	call   801048a0 <exit>
  return 0;  // not reached
8010689e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068a3:	c9                   	leave  
801068a4:	c3                   	ret    

801068a5 <sys_wait>:

int
sys_wait(void)
{
801068a5:	55                   	push   %ebp
801068a6:	89 e5                	mov    %esp,%ebp
801068a8:	83 ec 08             	sub    $0x8,%esp
  return wait();
801068ab:	e8 66 e1 ff ff       	call   80104a16 <wait>
}
801068b0:	c9                   	leave  
801068b1:	c3                   	ret    

801068b2 <sys_kill>:

int
sys_kill(void)
{
801068b2:	55                   	push   %ebp
801068b3:	89 e5                	mov    %esp,%ebp
801068b5:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801068bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068c6:	e8 c5 f0 ff ff       	call   80105990 <argint>
801068cb:	85 c0                	test   %eax,%eax
801068cd:	79 07                	jns    801068d6 <sys_kill+0x24>
    return -1;
801068cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d4:	eb 0b                	jmp    801068e1 <sys_kill+0x2f>
  return kill(pid);
801068d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d9:	89 04 24             	mov    %eax,(%esp)
801068dc:	e8 bb e5 ff ff       	call   80104e9c <kill>
}
801068e1:	c9                   	leave  
801068e2:	c3                   	ret    

801068e3 <sys_getpid>:

int
sys_getpid(void)
{
801068e3:	55                   	push   %ebp
801068e4:	89 e5                	mov    %esp,%ebp
  return thread->proc->pid;
801068e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ec:	8b 40 0c             	mov    0xc(%eax),%eax
801068ef:	8b 40 0c             	mov    0xc(%eax),%eax
}
801068f2:	5d                   	pop    %ebp
801068f3:	c3                   	ret    

801068f4 <sys_sbrk>:

int
sys_sbrk(void)
{
801068f4:	55                   	push   %ebp
801068f5:	89 e5                	mov    %esp,%ebp
801068f7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801068fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80106901:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106908:	e8 83 f0 ff ff       	call   80105990 <argint>
8010690d:	85 c0                	test   %eax,%eax
8010690f:	79 07                	jns    80106918 <sys_sbrk+0x24>
    return -1;
80106911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106916:	eb 27                	jmp    8010693f <sys_sbrk+0x4b>
  addr = thread->proc->sz;
80106918:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010691e:	8b 40 0c             	mov    0xc(%eax),%eax
80106921:	8b 00                	mov    (%eax),%eax
80106923:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106929:	89 04 24             	mov    %eax,(%esp)
8010692c:	e8 91 dc ff ff       	call   801045c2 <growproc>
80106931:	85 c0                	test   %eax,%eax
80106933:	79 07                	jns    8010693c <sys_sbrk+0x48>
    return -1;
80106935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693a:	eb 03                	jmp    8010693f <sys_sbrk+0x4b>
  return addr;
8010693c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010693f:	c9                   	leave  
80106940:	c3                   	ret    

80106941 <sys_sleep>:

int
sys_sleep(void)
{
80106941:	55                   	push   %ebp
80106942:	89 e5                	mov    %esp,%ebp
80106944:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106947:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010694a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010694e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106955:	e8 36 f0 ff ff       	call   80105990 <argint>
8010695a:	85 c0                	test   %eax,%eax
8010695c:	79 07                	jns    80106965 <sys_sleep+0x24>
    return -1;
8010695e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106963:	eb 6f                	jmp    801069d4 <sys_sleep+0x93>
  acquire(&tickslock);
80106965:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
8010696c:	e8 7d ea ff ff       	call   801053ee <acquire>
  ticks0 = ticks;
80106971:	a1 00 cf 11 80       	mov    0x8011cf00,%eax
80106976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106979:	eb 37                	jmp    801069b2 <sys_sleep+0x71>
    if(thread->proc->killed){
8010697b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106981:	8b 40 0c             	mov    0xc(%eax),%eax
80106984:	8b 40 18             	mov    0x18(%eax),%eax
80106987:	85 c0                	test   %eax,%eax
80106989:	74 13                	je     8010699e <sys_sleep+0x5d>
      release(&tickslock);
8010698b:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
80106992:	e8 b9 ea ff ff       	call   80105450 <release>
      return -1;
80106997:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699c:	eb 36                	jmp    801069d4 <sys_sleep+0x93>
    }
    sleep(&ticks, &tickslock);
8010699e:	c7 44 24 04 c0 c6 11 	movl   $0x8011c6c0,0x4(%esp)
801069a5:	80 
801069a6:	c7 04 24 00 cf 11 80 	movl   $0x8011cf00,(%esp)
801069ad:	e8 c7 e3 ff ff       	call   80104d79 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069b2:	a1 00 cf 11 80       	mov    0x8011cf00,%eax
801069b7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069ba:	89 c2                	mov    %eax,%edx
801069bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069bf:	39 c2                	cmp    %eax,%edx
801069c1:	72 b8                	jb     8010697b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069c3:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
801069ca:	e8 81 ea ff ff       	call   80105450 <release>
  return 0;
801069cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d4:	c9                   	leave  
801069d5:	c3                   	ret    

801069d6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069d6:	55                   	push   %ebp
801069d7:	89 e5                	mov    %esp,%ebp
801069d9:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801069dc:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
801069e3:	e8 06 ea ff ff       	call   801053ee <acquire>
  xticks = ticks;
801069e8:	a1 00 cf 11 80       	mov    0x8011cf00,%eax
801069ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801069f0:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
801069f7:	e8 54 ea ff ff       	call   80105450 <release>
  return xticks;
801069fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801069ff:	c9                   	leave  
80106a00:	c3                   	ret    

80106a01 <sys_kthread_create>:




int sys_kthread_create(void){
80106a01:	55                   	push   %ebp
80106a02:	89 e5                	mov    %esp,%ebp
80106a04:	83 ec 28             	sub    $0x28,%esp

	int start_func;
	int stack;
	int stack_size;

	if ( argint(0,&start_func)<0  || argint(1,&stack)<0  ||argint(2,&stack_size)<0 )
80106a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a15:	e8 76 ef ff ff       	call   80105990 <argint>
80106a1a:	85 c0                	test   %eax,%eax
80106a1c:	78 2e                	js     80106a4c <sys_kthread_create+0x4b>
80106a1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a21:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a2c:	e8 5f ef ff ff       	call   80105990 <argint>
80106a31:	85 c0                	test   %eax,%eax
80106a33:	78 17                	js     80106a4c <sys_kthread_create+0x4b>
80106a35:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a38:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a3c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a43:	e8 48 ef ff ff       	call   80105990 <argint>
80106a48:	85 c0                	test   %eax,%eax
80106a4a:	79 07                	jns    80106a53 <sys_kthread_create+0x52>
		return -1;
80106a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a51:	eb 1d                	jmp    80106a70 <sys_kthread_create+0x6f>


	return kthread_create((void *) start_func, (void *) stack, (uint) stack_size);
80106a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a56:	89 c1                	mov    %eax,%ecx
80106a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a5b:	89 c2                	mov    %eax,%edx
80106a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a64:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a68:	89 04 24             	mov    %eax,(%esp)
80106a6b:	e8 10 e6 ff ff       	call   80105080 <kthread_create>

}
80106a70:	c9                   	leave  
80106a71:	c3                   	ret    

80106a72 <sys_kthread_id>:
int sys_kthread_id(void){
80106a72:	55                   	push   %ebp
80106a73:	89 e5                	mov    %esp,%ebp
80106a75:	83 ec 08             	sub    $0x8,%esp
	return kthread_id();
80106a78:	e8 89 e7 ff ff       	call   80105206 <kthread_id>
}
80106a7d:	c9                   	leave  
80106a7e:	c3                   	ret    

80106a7f <sys_kthread_exit>:

int  sys_kthread_exit(void){
80106a7f:	55                   	push   %ebp
80106a80:	89 e5                	mov    %esp,%ebp
80106a82:	83 ec 08             	sub    $0x8,%esp
	kthread_exit();
80106a85:	e8 8a e7 ff ff       	call   80105214 <kthread_exit>
	return 0;
80106a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a8f:	c9                   	leave  
80106a90:	c3                   	ret    

80106a91 <sys_kthread_join>:

int sys_kthread_join(void){
80106a91:	55                   	push   %ebp
80106a92:	89 e5                	mov    %esp,%ebp
80106a94:	83 ec 28             	sub    $0x28,%esp

	int thread_id;

	if (argint(0, &thread_id)<0)
80106a97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106aa5:	e8 e6 ee ff ff       	call   80105990 <argint>
80106aaa:	85 c0                	test   %eax,%eax
80106aac:	79 07                	jns    80106ab5 <sys_kthread_join+0x24>
		return -1;
80106aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ab3:	eb 0b                	jmp    80106ac0 <sys_kthread_join+0x2f>

	return kthread_join(thread_id);
80106ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab8:	89 04 24             	mov    %eax,(%esp)
80106abb:	e8 c2 e7 ff ff       	call   80105282 <kthread_join>

}
80106ac0:	c9                   	leave  
80106ac1:	c3                   	ret    

80106ac2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106ac2:	55                   	push   %ebp
80106ac3:	89 e5                	mov    %esp,%ebp
80106ac5:	83 ec 08             	sub    $0x8,%esp
80106ac8:	8b 55 08             	mov    0x8(%ebp),%edx
80106acb:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ace:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ad2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ad5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ad9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106add:	ee                   	out    %al,(%dx)
}
80106ade:	c9                   	leave  
80106adf:	c3                   	ret    

80106ae0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106ae6:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106aed:	00 
80106aee:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106af5:	e8 c8 ff ff ff       	call   80106ac2 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106afa:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106b01:	00 
80106b02:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106b09:	e8 b4 ff ff ff       	call   80106ac2 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106b0e:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106b15:	00 
80106b16:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106b1d:	e8 a0 ff ff ff       	call   80106ac2 <outb>
  picenable(IRQ_TIMER);
80106b22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b29:	e8 98 d2 ff ff       	call   80103dc6 <picenable>
}
80106b2e:	c9                   	leave  
80106b2f:	c3                   	ret    

80106b30 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106b30:	1e                   	push   %ds
  pushl %es
80106b31:	06                   	push   %es
  pushl %fs
80106b32:	0f a0                	push   %fs
  pushl %gs
80106b34:	0f a8                	push   %gs
  pushal
80106b36:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106b37:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106b3b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106b3d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106b3f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106b43:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106b45:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106b47:	54                   	push   %esp
  call trap
80106b48:	e8 d8 01 00 00       	call   80106d25 <trap>
  addl $4, %esp
80106b4d:	83 c4 04             	add    $0x4,%esp

80106b50 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106b50:	61                   	popa   
  popl %gs
80106b51:	0f a9                	pop    %gs
  popl %fs
80106b53:	0f a1                	pop    %fs
  popl %es
80106b55:	07                   	pop    %es
  popl %ds
80106b56:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106b57:	83 c4 08             	add    $0x8,%esp
  iret
80106b5a:	cf                   	iret   

80106b5b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106b5b:	55                   	push   %ebp
80106b5c:	89 e5                	mov    %esp,%ebp
80106b5e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b64:	83 e8 01             	sub    $0x1,%eax
80106b67:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106b72:	8b 45 08             	mov    0x8(%ebp),%eax
80106b75:	c1 e8 10             	shr    $0x10,%eax
80106b78:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106b7c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106b7f:	0f 01 18             	lidtl  (%eax)
}
80106b82:	c9                   	leave  
80106b83:	c3                   	ret    

80106b84 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106b84:	55                   	push   %ebp
80106b85:	89 e5                	mov    %esp,%ebp
80106b87:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b8a:	0f 20 d0             	mov    %cr2,%eax
80106b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106b93:	c9                   	leave  
80106b94:	c3                   	ret    

80106b95 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106b95:	55                   	push   %ebp
80106b96:	89 e5                	mov    %esp,%ebp
80106b98:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106b9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ba2:	e9 c3 00 00 00       	jmp    80106c6a <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106baa:	8b 04 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%eax
80106bb1:	89 c2                	mov    %eax,%edx
80106bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb6:	66 89 14 c5 00 c7 11 	mov    %dx,-0x7fee3900(,%eax,8)
80106bbd:	80 
80106bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc1:	66 c7 04 c5 02 c7 11 	movw   $0x8,-0x7fee38fe(,%eax,8)
80106bc8:	80 08 00 
80106bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bce:	0f b6 14 c5 04 c7 11 	movzbl -0x7fee38fc(,%eax,8),%edx
80106bd5:	80 
80106bd6:	83 e2 e0             	and    $0xffffffe0,%edx
80106bd9:	88 14 c5 04 c7 11 80 	mov    %dl,-0x7fee38fc(,%eax,8)
80106be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be3:	0f b6 14 c5 04 c7 11 	movzbl -0x7fee38fc(,%eax,8),%edx
80106bea:	80 
80106beb:	83 e2 1f             	and    $0x1f,%edx
80106bee:	88 14 c5 04 c7 11 80 	mov    %dl,-0x7fee38fc(,%eax,8)
80106bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf8:	0f b6 14 c5 05 c7 11 	movzbl -0x7fee38fb(,%eax,8),%edx
80106bff:	80 
80106c00:	83 e2 f0             	and    $0xfffffff0,%edx
80106c03:	83 ca 0e             	or     $0xe,%edx
80106c06:	88 14 c5 05 c7 11 80 	mov    %dl,-0x7fee38fb(,%eax,8)
80106c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c10:	0f b6 14 c5 05 c7 11 	movzbl -0x7fee38fb(,%eax,8),%edx
80106c17:	80 
80106c18:	83 e2 ef             	and    $0xffffffef,%edx
80106c1b:	88 14 c5 05 c7 11 80 	mov    %dl,-0x7fee38fb(,%eax,8)
80106c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c25:	0f b6 14 c5 05 c7 11 	movzbl -0x7fee38fb(,%eax,8),%edx
80106c2c:	80 
80106c2d:	83 e2 9f             	and    $0xffffff9f,%edx
80106c30:	88 14 c5 05 c7 11 80 	mov    %dl,-0x7fee38fb(,%eax,8)
80106c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c3a:	0f b6 14 c5 05 c7 11 	movzbl -0x7fee38fb(,%eax,8),%edx
80106c41:	80 
80106c42:	83 ca 80             	or     $0xffffff80,%edx
80106c45:	88 14 c5 05 c7 11 80 	mov    %dl,-0x7fee38fb(,%eax,8)
80106c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4f:	8b 04 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%eax
80106c56:	c1 e8 10             	shr    $0x10,%eax
80106c59:	89 c2                	mov    %eax,%edx
80106c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c5e:	66 89 14 c5 06 c7 11 	mov    %dx,-0x7fee38fa(,%eax,8)
80106c65:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c6a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106c71:	0f 8e 30 ff ff ff    	jle    80106ba7 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c77:	a1 a8 c1 10 80       	mov    0x8010c1a8,%eax
80106c7c:	66 a3 00 c9 11 80    	mov    %ax,0x8011c900
80106c82:	66 c7 05 02 c9 11 80 	movw   $0x8,0x8011c902
80106c89:	08 00 
80106c8b:	0f b6 05 04 c9 11 80 	movzbl 0x8011c904,%eax
80106c92:	83 e0 e0             	and    $0xffffffe0,%eax
80106c95:	a2 04 c9 11 80       	mov    %al,0x8011c904
80106c9a:	0f b6 05 04 c9 11 80 	movzbl 0x8011c904,%eax
80106ca1:	83 e0 1f             	and    $0x1f,%eax
80106ca4:	a2 04 c9 11 80       	mov    %al,0x8011c904
80106ca9:	0f b6 05 05 c9 11 80 	movzbl 0x8011c905,%eax
80106cb0:	83 c8 0f             	or     $0xf,%eax
80106cb3:	a2 05 c9 11 80       	mov    %al,0x8011c905
80106cb8:	0f b6 05 05 c9 11 80 	movzbl 0x8011c905,%eax
80106cbf:	83 e0 ef             	and    $0xffffffef,%eax
80106cc2:	a2 05 c9 11 80       	mov    %al,0x8011c905
80106cc7:	0f b6 05 05 c9 11 80 	movzbl 0x8011c905,%eax
80106cce:	83 c8 60             	or     $0x60,%eax
80106cd1:	a2 05 c9 11 80       	mov    %al,0x8011c905
80106cd6:	0f b6 05 05 c9 11 80 	movzbl 0x8011c905,%eax
80106cdd:	83 c8 80             	or     $0xffffff80,%eax
80106ce0:	a2 05 c9 11 80       	mov    %al,0x8011c905
80106ce5:	a1 a8 c1 10 80       	mov    0x8010c1a8,%eax
80106cea:	c1 e8 10             	shr    $0x10,%eax
80106ced:	66 a3 06 c9 11 80    	mov    %ax,0x8011c906
  
  initlock(&tickslock, "time");
80106cf3:	c7 44 24 04 8c 8f 10 	movl   $0x80108f8c,0x4(%esp)
80106cfa:	80 
80106cfb:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
80106d02:	e8 c6 e6 ff ff       	call   801053cd <initlock>
}
80106d07:	c9                   	leave  
80106d08:	c3                   	ret    

80106d09 <idtinit>:

void
idtinit(void)
{
80106d09:	55                   	push   %ebp
80106d0a:	89 e5                	mov    %esp,%ebp
80106d0c:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106d0f:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106d16:	00 
80106d17:	c7 04 24 00 c7 11 80 	movl   $0x8011c700,(%esp)
80106d1e:	e8 38 fe ff ff       	call   80106b5b <lidt>
}
80106d23:	c9                   	leave  
80106d24:	c3                   	ret    

80106d25 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106d25:	55                   	push   %ebp
80106d26:	89 e5                	mov    %esp,%ebp
80106d28:	57                   	push   %edi
80106d29:	56                   	push   %esi
80106d2a:	53                   	push   %ebx
80106d2b:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d31:	8b 40 30             	mov    0x30(%eax),%eax
80106d34:	83 f8 40             	cmp    $0x40,%eax
80106d37:	75 45                	jne    80106d7e <trap+0x59>
    if(thread->proc->killed)
80106d39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d3f:	8b 40 0c             	mov    0xc(%eax),%eax
80106d42:	8b 40 18             	mov    0x18(%eax),%eax
80106d45:	85 c0                	test   %eax,%eax
80106d47:	74 05                	je     80106d4e <trap+0x29>
      exit();
80106d49:	e8 52 db ff ff       	call   801048a0 <exit>
    thread->tf = tf;
80106d4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d54:	8b 55 08             	mov    0x8(%ebp),%edx
80106d57:	89 50 10             	mov    %edx,0x10(%eax)
    syscall();
80106d5a:	e8 fe ec ff ff       	call   80105a5d <syscall>
    if(thread->proc->killed)
80106d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d65:	8b 40 0c             	mov    0xc(%eax),%eax
80106d68:	8b 40 18             	mov    0x18(%eax),%eax
80106d6b:	85 c0                	test   %eax,%eax
80106d6d:	74 0a                	je     80106d79 <trap+0x54>
      exit();
80106d6f:	e8 2c db ff ff       	call   801048a0 <exit>
    return;
80106d74:	e9 7d 02 00 00       	jmp    80106ff6 <trap+0x2d1>
80106d79:	e9 78 02 00 00       	jmp    80106ff6 <trap+0x2d1>
  }

  switch(tf->trapno){
80106d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d81:	8b 40 30             	mov    0x30(%eax),%eax
80106d84:	83 e8 20             	sub    $0x20,%eax
80106d87:	83 f8 1f             	cmp    $0x1f,%eax
80106d8a:	0f 87 bc 00 00 00    	ja     80106e4c <trap+0x127>
80106d90:	8b 04 85 44 90 10 80 	mov    -0x7fef6fbc(,%eax,4),%eax
80106d97:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106d99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d9f:	0f b6 00             	movzbl (%eax),%eax
80106da2:	84 c0                	test   %al,%al
80106da4:	75 31                	jne    80106dd7 <trap+0xb2>
      acquire(&tickslock);
80106da6:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
80106dad:	e8 3c e6 ff ff       	call   801053ee <acquire>
      ticks++;
80106db2:	a1 00 cf 11 80       	mov    0x8011cf00,%eax
80106db7:	83 c0 01             	add    $0x1,%eax
80106dba:	a3 00 cf 11 80       	mov    %eax,0x8011cf00
      wakeup(&ticks);
80106dbf:	c7 04 24 00 cf 11 80 	movl   $0x8011cf00,(%esp)
80106dc6:	e8 a6 e0 ff ff       	call   80104e71 <wakeup>
      release(&tickslock);
80106dcb:	c7 04 24 c0 c6 11 80 	movl   $0x8011c6c0,(%esp)
80106dd2:	e8 79 e6 ff ff       	call   80105450 <release>
    }
    lapiceoi();
80106dd7:	e8 06 c1 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106ddc:	e9 64 01 00 00       	jmp    80106f45 <trap+0x220>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106de1:	e8 0a b9 ff ff       	call   801026f0 <ideintr>
    lapiceoi();
80106de6:	e8 f7 c0 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106deb:	e9 55 01 00 00       	jmp    80106f45 <trap+0x220>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106df0:	e8 bc be ff ff       	call   80102cb1 <kbdintr>
    lapiceoi();
80106df5:	e8 e8 c0 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106dfa:	e9 46 01 00 00       	jmp    80106f45 <trap+0x220>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106dff:	e8 e7 03 00 00       	call   801071eb <uartintr>
    lapiceoi();
80106e04:	e8 d9 c0 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106e09:	e9 37 01 00 00       	jmp    80106f45 <trap+0x220>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80106e11:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106e14:	8b 45 08             	mov    0x8(%ebp),%eax
80106e17:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e1b:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106e1e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e24:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e27:	0f b6 c0             	movzbl %al,%eax
80106e2a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106e2e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e32:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e36:	c7 04 24 94 8f 10 80 	movl   $0x80108f94,(%esp)
80106e3d:	e8 5e 95 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106e42:	e8 9b c0 ff ff       	call   80102ee2 <lapiceoi>
    break;
80106e47:	e9 f9 00 00 00       	jmp    80106f45 <trap+0x220>
   
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
80106e4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e52:	85 c0                	test   %eax,%eax
80106e54:	74 11                	je     80106e67 <trap+0x142>
80106e56:	8b 45 08             	mov    0x8(%ebp),%eax
80106e59:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e5d:	0f b7 c0             	movzwl %ax,%eax
80106e60:	83 e0 03             	and    $0x3,%eax
80106e63:	85 c0                	test   %eax,%eax
80106e65:	75 60                	jne    80106ec7 <trap+0x1a2>
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
80106e67:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e6e:	0f b7 c0             	movzwl %ax,%eax
80106e71:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e75:	c7 04 24 b8 8f 10 80 	movl   $0x80108fb8,(%esp)
80106e7c:	e8 1f 95 ff ff       	call   801003a0 <cprintf>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e81:	e8 fe fc ff ff       	call   80106b84 <rcr2>
80106e86:	8b 55 08             	mov    0x8(%ebp),%edx
80106e89:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e8c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106e93:	0f b6 12             	movzbl (%edx),%edx
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e96:	0f b6 ca             	movzbl %dl,%ecx
80106e99:	8b 55 08             	mov    0x8(%ebp),%edx
80106e9c:	8b 52 30             	mov    0x30(%edx),%edx
80106e9f:	89 44 24 10          	mov    %eax,0x10(%esp)
80106ea3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106ea7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106eab:	89 54 24 04          	mov    %edx,0x4(%esp)
80106eaf:	c7 04 24 c8 8f 10 80 	movl   $0x80108fc8,(%esp)
80106eb6:	e8 e5 94 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106ebb:	c7 04 24 fa 8f 10 80 	movl   $0x80108ffa,(%esp)
80106ec2:	e8 73 96 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ec7:	e8 b8 fc ff ff       	call   80106b84 <rcr2>
80106ecc:	89 c2                	mov    %eax,%edx
80106ece:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed1:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106ed4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106eda:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106edd:	0f b6 f0             	movzbl %al,%esi
80106ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee3:	8b 58 34             	mov    0x34(%eax),%ebx
80106ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee9:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80106eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ef2:	8b 40 0c             	mov    0xc(%eax),%eax
80106ef5:	83 c0 60             	add    $0x60,%eax
80106ef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106efb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f01:	8b 40 0c             	mov    0xc(%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f04:	8b 40 0c             	mov    0xc(%eax),%eax
80106f07:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106f0b:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106f0f:	89 74 24 14          	mov    %esi,0x14(%esp)
80106f13:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106f17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106f1b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106f1e:	89 74 24 08          	mov    %esi,0x8(%esp)
80106f22:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f26:	c7 04 24 00 90 10 80 	movl   $0x80109000,(%esp)
80106f2d:	e8 6e 94 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    thread->proc->killed = 1;
80106f32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f38:	8b 40 0c             	mov    0xc(%eax),%eax
80106f3b:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
80106f42:	eb 01                	jmp    80106f45 <trap+0x220>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106f44:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(thread && thread->proc  && thread->proc->killed && (tf->cs&3) == DPL_USER)
80106f45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f4b:	85 c0                	test   %eax,%eax
80106f4d:	74 34                	je     80106f83 <trap+0x25e>
80106f4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f55:	8b 40 0c             	mov    0xc(%eax),%eax
80106f58:	85 c0                	test   %eax,%eax
80106f5a:	74 27                	je     80106f83 <trap+0x25e>
80106f5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f62:	8b 40 0c             	mov    0xc(%eax),%eax
80106f65:	8b 40 18             	mov    0x18(%eax),%eax
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	74 17                	je     80106f83 <trap+0x25e>
80106f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f73:	0f b7 c0             	movzwl %ax,%eax
80106f76:	83 e0 03             	and    $0x3,%eax
80106f79:	83 f8 03             	cmp    $0x3,%eax
80106f7c:	75 05                	jne    80106f83 <trap+0x25e>
    exit();
80106f7e:	e8 1d d9 ff ff       	call   801048a0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if(thread && thread->proc && thread->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106f83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f89:	85 c0                	test   %eax,%eax
80106f8b:	74 2b                	je     80106fb8 <trap+0x293>
80106f8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f93:	8b 40 0c             	mov    0xc(%eax),%eax
80106f96:	85 c0                	test   %eax,%eax
80106f98:	74 1e                	je     80106fb8 <trap+0x293>
80106f9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fa0:	8b 40 04             	mov    0x4(%eax),%eax
80106fa3:	83 f8 04             	cmp    $0x4,%eax
80106fa6:	75 10                	jne    80106fb8 <trap+0x293>
80106fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fab:	8b 40 30             	mov    0x30(%eax),%eax
80106fae:	83 f8 20             	cmp    $0x20,%eax
80106fb1:	75 05                	jne    80106fb8 <trap+0x293>

    yield();
80106fb3:	e8 63 dd ff ff       	call   80104d1b <yield>

  }

  // Check if the process has been killed since we yielded
  if(thread && thread->proc && thread->proc->killed && (tf->cs&3) == DPL_USER)
80106fb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fbe:	85 c0                	test   %eax,%eax
80106fc0:	74 34                	je     80106ff6 <trap+0x2d1>
80106fc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fc8:	8b 40 0c             	mov    0xc(%eax),%eax
80106fcb:	85 c0                	test   %eax,%eax
80106fcd:	74 27                	je     80106ff6 <trap+0x2d1>
80106fcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd5:	8b 40 0c             	mov    0xc(%eax),%eax
80106fd8:	8b 40 18             	mov    0x18(%eax),%eax
80106fdb:	85 c0                	test   %eax,%eax
80106fdd:	74 17                	je     80106ff6 <trap+0x2d1>
80106fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fe6:	0f b7 c0             	movzwl %ax,%eax
80106fe9:	83 e0 03             	and    $0x3,%eax
80106fec:	83 f8 03             	cmp    $0x3,%eax
80106fef:	75 05                	jne    80106ff6 <trap+0x2d1>
    exit();
80106ff1:	e8 aa d8 ff ff       	call   801048a0 <exit>
}
80106ff6:	83 c4 3c             	add    $0x3c,%esp
80106ff9:	5b                   	pop    %ebx
80106ffa:	5e                   	pop    %esi
80106ffb:	5f                   	pop    %edi
80106ffc:	5d                   	pop    %ebp
80106ffd:	c3                   	ret    

80106ffe <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106ffe:	55                   	push   %ebp
80106fff:	89 e5                	mov    %esp,%ebp
80107001:	83 ec 14             	sub    $0x14,%esp
80107004:	8b 45 08             	mov    0x8(%ebp),%eax
80107007:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010700b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010700f:	89 c2                	mov    %eax,%edx
80107011:	ec                   	in     (%dx),%al
80107012:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107015:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107019:	c9                   	leave  
8010701a:	c3                   	ret    

8010701b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010701b:	55                   	push   %ebp
8010701c:	89 e5                	mov    %esp,%ebp
8010701e:	83 ec 08             	sub    $0x8,%esp
80107021:	8b 55 08             	mov    0x8(%ebp),%edx
80107024:	8b 45 0c             	mov    0xc(%ebp),%eax
80107027:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010702b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010702e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107032:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107036:	ee                   	out    %al,(%dx)
}
80107037:	c9                   	leave  
80107038:	c3                   	ret    

80107039 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107039:	55                   	push   %ebp
8010703a:	89 e5                	mov    %esp,%ebp
8010703c:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010703f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107046:	00 
80107047:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010704e:	e8 c8 ff ff ff       	call   8010701b <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107053:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010705a:	00 
8010705b:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107062:	e8 b4 ff ff ff       	call   8010701b <outb>
  outb(COM1+0, 115200/9600);
80107067:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010706e:	00 
8010706f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107076:	e8 a0 ff ff ff       	call   8010701b <outb>
  outb(COM1+1, 0);
8010707b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107082:	00 
80107083:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010708a:	e8 8c ff ff ff       	call   8010701b <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010708f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107096:	00 
80107097:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010709e:	e8 78 ff ff ff       	call   8010701b <outb>
  outb(COM1+4, 0);
801070a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070aa:	00 
801070ab:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801070b2:	e8 64 ff ff ff       	call   8010701b <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801070b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801070be:	00 
801070bf:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801070c6:	e8 50 ff ff ff       	call   8010701b <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801070cb:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801070d2:	e8 27 ff ff ff       	call   80106ffe <inb>
801070d7:	3c ff                	cmp    $0xff,%al
801070d9:	75 02                	jne    801070dd <uartinit+0xa4>
    return;
801070db:	eb 6a                	jmp    80107147 <uartinit+0x10e>
  uart = 1;
801070dd:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
801070e4:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801070e7:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801070ee:	e8 0b ff ff ff       	call   80106ffe <inb>
  inb(COM1+0);
801070f3:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070fa:	e8 ff fe ff ff       	call   80106ffe <inb>
  picenable(IRQ_COM1);
801070ff:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107106:	e8 bb cc ff ff       	call   80103dc6 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010710b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107112:	00 
80107113:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010711a:	e8 50 b8 ff ff       	call   8010296f <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010711f:	c7 45 f4 c4 90 10 80 	movl   $0x801090c4,-0xc(%ebp)
80107126:	eb 15                	jmp    8010713d <uartinit+0x104>
    uartputc(*p);
80107128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712b:	0f b6 00             	movzbl (%eax),%eax
8010712e:	0f be c0             	movsbl %al,%eax
80107131:	89 04 24             	mov    %eax,(%esp)
80107134:	e8 10 00 00 00       	call   80107149 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107139:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010713d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107140:	0f b6 00             	movzbl (%eax),%eax
80107143:	84 c0                	test   %al,%al
80107145:	75 e1                	jne    80107128 <uartinit+0xef>
    uartputc(*p);
}
80107147:	c9                   	leave  
80107148:	c3                   	ret    

80107149 <uartputc>:

void
uartputc(int c)
{
80107149:	55                   	push   %ebp
8010714a:	89 e5                	mov    %esp,%ebp
8010714c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010714f:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107154:	85 c0                	test   %eax,%eax
80107156:	75 02                	jne    8010715a <uartputc+0x11>
    return;
80107158:	eb 4b                	jmp    801071a5 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010715a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107161:	eb 10                	jmp    80107173 <uartputc+0x2a>
    microdelay(10);
80107163:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010716a:	e8 98 bd ff ff       	call   80102f07 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010716f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107173:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107177:	7f 16                	jg     8010718f <uartputc+0x46>
80107179:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107180:	e8 79 fe ff ff       	call   80106ffe <inb>
80107185:	0f b6 c0             	movzbl %al,%eax
80107188:	83 e0 20             	and    $0x20,%eax
8010718b:	85 c0                	test   %eax,%eax
8010718d:	74 d4                	je     80107163 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010718f:	8b 45 08             	mov    0x8(%ebp),%eax
80107192:	0f b6 c0             	movzbl %al,%eax
80107195:	89 44 24 04          	mov    %eax,0x4(%esp)
80107199:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801071a0:	e8 76 fe ff ff       	call   8010701b <outb>
}
801071a5:	c9                   	leave  
801071a6:	c3                   	ret    

801071a7 <uartgetc>:

static int
uartgetc(void)
{
801071a7:	55                   	push   %ebp
801071a8:	89 e5                	mov    %esp,%ebp
801071aa:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801071ad:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801071b2:	85 c0                	test   %eax,%eax
801071b4:	75 07                	jne    801071bd <uartgetc+0x16>
    return -1;
801071b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071bb:	eb 2c                	jmp    801071e9 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801071bd:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801071c4:	e8 35 fe ff ff       	call   80106ffe <inb>
801071c9:	0f b6 c0             	movzbl %al,%eax
801071cc:	83 e0 01             	and    $0x1,%eax
801071cf:	85 c0                	test   %eax,%eax
801071d1:	75 07                	jne    801071da <uartgetc+0x33>
    return -1;
801071d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071d8:	eb 0f                	jmp    801071e9 <uartgetc+0x42>
  return inb(COM1+0);
801071da:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801071e1:	e8 18 fe ff ff       	call   80106ffe <inb>
801071e6:	0f b6 c0             	movzbl %al,%eax
}
801071e9:	c9                   	leave  
801071ea:	c3                   	ret    

801071eb <uartintr>:

void
uartintr(void)
{
801071eb:	55                   	push   %ebp
801071ec:	89 e5                	mov    %esp,%ebp
801071ee:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801071f1:	c7 04 24 a7 71 10 80 	movl   $0x801071a7,(%esp)
801071f8:	e8 b0 95 ff ff       	call   801007ad <consoleintr>
}
801071fd:	c9                   	leave  
801071fe:	c3                   	ret    

801071ff <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $0
80107201:	6a 00                	push   $0x0
  jmp alltraps
80107203:	e9 28 f9 ff ff       	jmp    80106b30 <alltraps>

80107208 <vector1>:
.globl vector1
vector1:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $1
8010720a:	6a 01                	push   $0x1
  jmp alltraps
8010720c:	e9 1f f9 ff ff       	jmp    80106b30 <alltraps>

80107211 <vector2>:
.globl vector2
vector2:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $2
80107213:	6a 02                	push   $0x2
  jmp alltraps
80107215:	e9 16 f9 ff ff       	jmp    80106b30 <alltraps>

8010721a <vector3>:
.globl vector3
vector3:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $3
8010721c:	6a 03                	push   $0x3
  jmp alltraps
8010721e:	e9 0d f9 ff ff       	jmp    80106b30 <alltraps>

80107223 <vector4>:
.globl vector4
vector4:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $4
80107225:	6a 04                	push   $0x4
  jmp alltraps
80107227:	e9 04 f9 ff ff       	jmp    80106b30 <alltraps>

8010722c <vector5>:
.globl vector5
vector5:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $5
8010722e:	6a 05                	push   $0x5
  jmp alltraps
80107230:	e9 fb f8 ff ff       	jmp    80106b30 <alltraps>

80107235 <vector6>:
.globl vector6
vector6:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $6
80107237:	6a 06                	push   $0x6
  jmp alltraps
80107239:	e9 f2 f8 ff ff       	jmp    80106b30 <alltraps>

8010723e <vector7>:
.globl vector7
vector7:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $7
80107240:	6a 07                	push   $0x7
  jmp alltraps
80107242:	e9 e9 f8 ff ff       	jmp    80106b30 <alltraps>

80107247 <vector8>:
.globl vector8
vector8:
  pushl $8
80107247:	6a 08                	push   $0x8
  jmp alltraps
80107249:	e9 e2 f8 ff ff       	jmp    80106b30 <alltraps>

8010724e <vector9>:
.globl vector9
vector9:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $9
80107250:	6a 09                	push   $0x9
  jmp alltraps
80107252:	e9 d9 f8 ff ff       	jmp    80106b30 <alltraps>

80107257 <vector10>:
.globl vector10
vector10:
  pushl $10
80107257:	6a 0a                	push   $0xa
  jmp alltraps
80107259:	e9 d2 f8 ff ff       	jmp    80106b30 <alltraps>

8010725e <vector11>:
.globl vector11
vector11:
  pushl $11
8010725e:	6a 0b                	push   $0xb
  jmp alltraps
80107260:	e9 cb f8 ff ff       	jmp    80106b30 <alltraps>

80107265 <vector12>:
.globl vector12
vector12:
  pushl $12
80107265:	6a 0c                	push   $0xc
  jmp alltraps
80107267:	e9 c4 f8 ff ff       	jmp    80106b30 <alltraps>

8010726c <vector13>:
.globl vector13
vector13:
  pushl $13
8010726c:	6a 0d                	push   $0xd
  jmp alltraps
8010726e:	e9 bd f8 ff ff       	jmp    80106b30 <alltraps>

80107273 <vector14>:
.globl vector14
vector14:
  pushl $14
80107273:	6a 0e                	push   $0xe
  jmp alltraps
80107275:	e9 b6 f8 ff ff       	jmp    80106b30 <alltraps>

8010727a <vector15>:
.globl vector15
vector15:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $15
8010727c:	6a 0f                	push   $0xf
  jmp alltraps
8010727e:	e9 ad f8 ff ff       	jmp    80106b30 <alltraps>

80107283 <vector16>:
.globl vector16
vector16:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $16
80107285:	6a 10                	push   $0x10
  jmp alltraps
80107287:	e9 a4 f8 ff ff       	jmp    80106b30 <alltraps>

8010728c <vector17>:
.globl vector17
vector17:
  pushl $17
8010728c:	6a 11                	push   $0x11
  jmp alltraps
8010728e:	e9 9d f8 ff ff       	jmp    80106b30 <alltraps>

80107293 <vector18>:
.globl vector18
vector18:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $18
80107295:	6a 12                	push   $0x12
  jmp alltraps
80107297:	e9 94 f8 ff ff       	jmp    80106b30 <alltraps>

8010729c <vector19>:
.globl vector19
vector19:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $19
8010729e:	6a 13                	push   $0x13
  jmp alltraps
801072a0:	e9 8b f8 ff ff       	jmp    80106b30 <alltraps>

801072a5 <vector20>:
.globl vector20
vector20:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $20
801072a7:	6a 14                	push   $0x14
  jmp alltraps
801072a9:	e9 82 f8 ff ff       	jmp    80106b30 <alltraps>

801072ae <vector21>:
.globl vector21
vector21:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $21
801072b0:	6a 15                	push   $0x15
  jmp alltraps
801072b2:	e9 79 f8 ff ff       	jmp    80106b30 <alltraps>

801072b7 <vector22>:
.globl vector22
vector22:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $22
801072b9:	6a 16                	push   $0x16
  jmp alltraps
801072bb:	e9 70 f8 ff ff       	jmp    80106b30 <alltraps>

801072c0 <vector23>:
.globl vector23
vector23:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $23
801072c2:	6a 17                	push   $0x17
  jmp alltraps
801072c4:	e9 67 f8 ff ff       	jmp    80106b30 <alltraps>

801072c9 <vector24>:
.globl vector24
vector24:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $24
801072cb:	6a 18                	push   $0x18
  jmp alltraps
801072cd:	e9 5e f8 ff ff       	jmp    80106b30 <alltraps>

801072d2 <vector25>:
.globl vector25
vector25:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $25
801072d4:	6a 19                	push   $0x19
  jmp alltraps
801072d6:	e9 55 f8 ff ff       	jmp    80106b30 <alltraps>

801072db <vector26>:
.globl vector26
vector26:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $26
801072dd:	6a 1a                	push   $0x1a
  jmp alltraps
801072df:	e9 4c f8 ff ff       	jmp    80106b30 <alltraps>

801072e4 <vector27>:
.globl vector27
vector27:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $27
801072e6:	6a 1b                	push   $0x1b
  jmp alltraps
801072e8:	e9 43 f8 ff ff       	jmp    80106b30 <alltraps>

801072ed <vector28>:
.globl vector28
vector28:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $28
801072ef:	6a 1c                	push   $0x1c
  jmp alltraps
801072f1:	e9 3a f8 ff ff       	jmp    80106b30 <alltraps>

801072f6 <vector29>:
.globl vector29
vector29:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $29
801072f8:	6a 1d                	push   $0x1d
  jmp alltraps
801072fa:	e9 31 f8 ff ff       	jmp    80106b30 <alltraps>

801072ff <vector30>:
.globl vector30
vector30:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $30
80107301:	6a 1e                	push   $0x1e
  jmp alltraps
80107303:	e9 28 f8 ff ff       	jmp    80106b30 <alltraps>

80107308 <vector31>:
.globl vector31
vector31:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $31
8010730a:	6a 1f                	push   $0x1f
  jmp alltraps
8010730c:	e9 1f f8 ff ff       	jmp    80106b30 <alltraps>

80107311 <vector32>:
.globl vector32
vector32:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $32
80107313:	6a 20                	push   $0x20
  jmp alltraps
80107315:	e9 16 f8 ff ff       	jmp    80106b30 <alltraps>

8010731a <vector33>:
.globl vector33
vector33:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $33
8010731c:	6a 21                	push   $0x21
  jmp alltraps
8010731e:	e9 0d f8 ff ff       	jmp    80106b30 <alltraps>

80107323 <vector34>:
.globl vector34
vector34:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $34
80107325:	6a 22                	push   $0x22
  jmp alltraps
80107327:	e9 04 f8 ff ff       	jmp    80106b30 <alltraps>

8010732c <vector35>:
.globl vector35
vector35:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $35
8010732e:	6a 23                	push   $0x23
  jmp alltraps
80107330:	e9 fb f7 ff ff       	jmp    80106b30 <alltraps>

80107335 <vector36>:
.globl vector36
vector36:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $36
80107337:	6a 24                	push   $0x24
  jmp alltraps
80107339:	e9 f2 f7 ff ff       	jmp    80106b30 <alltraps>

8010733e <vector37>:
.globl vector37
vector37:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $37
80107340:	6a 25                	push   $0x25
  jmp alltraps
80107342:	e9 e9 f7 ff ff       	jmp    80106b30 <alltraps>

80107347 <vector38>:
.globl vector38
vector38:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $38
80107349:	6a 26                	push   $0x26
  jmp alltraps
8010734b:	e9 e0 f7 ff ff       	jmp    80106b30 <alltraps>

80107350 <vector39>:
.globl vector39
vector39:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $39
80107352:	6a 27                	push   $0x27
  jmp alltraps
80107354:	e9 d7 f7 ff ff       	jmp    80106b30 <alltraps>

80107359 <vector40>:
.globl vector40
vector40:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $40
8010735b:	6a 28                	push   $0x28
  jmp alltraps
8010735d:	e9 ce f7 ff ff       	jmp    80106b30 <alltraps>

80107362 <vector41>:
.globl vector41
vector41:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $41
80107364:	6a 29                	push   $0x29
  jmp alltraps
80107366:	e9 c5 f7 ff ff       	jmp    80106b30 <alltraps>

8010736b <vector42>:
.globl vector42
vector42:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $42
8010736d:	6a 2a                	push   $0x2a
  jmp alltraps
8010736f:	e9 bc f7 ff ff       	jmp    80106b30 <alltraps>

80107374 <vector43>:
.globl vector43
vector43:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $43
80107376:	6a 2b                	push   $0x2b
  jmp alltraps
80107378:	e9 b3 f7 ff ff       	jmp    80106b30 <alltraps>

8010737d <vector44>:
.globl vector44
vector44:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $44
8010737f:	6a 2c                	push   $0x2c
  jmp alltraps
80107381:	e9 aa f7 ff ff       	jmp    80106b30 <alltraps>

80107386 <vector45>:
.globl vector45
vector45:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $45
80107388:	6a 2d                	push   $0x2d
  jmp alltraps
8010738a:	e9 a1 f7 ff ff       	jmp    80106b30 <alltraps>

8010738f <vector46>:
.globl vector46
vector46:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $46
80107391:	6a 2e                	push   $0x2e
  jmp alltraps
80107393:	e9 98 f7 ff ff       	jmp    80106b30 <alltraps>

80107398 <vector47>:
.globl vector47
vector47:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $47
8010739a:	6a 2f                	push   $0x2f
  jmp alltraps
8010739c:	e9 8f f7 ff ff       	jmp    80106b30 <alltraps>

801073a1 <vector48>:
.globl vector48
vector48:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $48
801073a3:	6a 30                	push   $0x30
  jmp alltraps
801073a5:	e9 86 f7 ff ff       	jmp    80106b30 <alltraps>

801073aa <vector49>:
.globl vector49
vector49:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $49
801073ac:	6a 31                	push   $0x31
  jmp alltraps
801073ae:	e9 7d f7 ff ff       	jmp    80106b30 <alltraps>

801073b3 <vector50>:
.globl vector50
vector50:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $50
801073b5:	6a 32                	push   $0x32
  jmp alltraps
801073b7:	e9 74 f7 ff ff       	jmp    80106b30 <alltraps>

801073bc <vector51>:
.globl vector51
vector51:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $51
801073be:	6a 33                	push   $0x33
  jmp alltraps
801073c0:	e9 6b f7 ff ff       	jmp    80106b30 <alltraps>

801073c5 <vector52>:
.globl vector52
vector52:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $52
801073c7:	6a 34                	push   $0x34
  jmp alltraps
801073c9:	e9 62 f7 ff ff       	jmp    80106b30 <alltraps>

801073ce <vector53>:
.globl vector53
vector53:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $53
801073d0:	6a 35                	push   $0x35
  jmp alltraps
801073d2:	e9 59 f7 ff ff       	jmp    80106b30 <alltraps>

801073d7 <vector54>:
.globl vector54
vector54:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $54
801073d9:	6a 36                	push   $0x36
  jmp alltraps
801073db:	e9 50 f7 ff ff       	jmp    80106b30 <alltraps>

801073e0 <vector55>:
.globl vector55
vector55:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $55
801073e2:	6a 37                	push   $0x37
  jmp alltraps
801073e4:	e9 47 f7 ff ff       	jmp    80106b30 <alltraps>

801073e9 <vector56>:
.globl vector56
vector56:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $56
801073eb:	6a 38                	push   $0x38
  jmp alltraps
801073ed:	e9 3e f7 ff ff       	jmp    80106b30 <alltraps>

801073f2 <vector57>:
.globl vector57
vector57:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $57
801073f4:	6a 39                	push   $0x39
  jmp alltraps
801073f6:	e9 35 f7 ff ff       	jmp    80106b30 <alltraps>

801073fb <vector58>:
.globl vector58
vector58:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $58
801073fd:	6a 3a                	push   $0x3a
  jmp alltraps
801073ff:	e9 2c f7 ff ff       	jmp    80106b30 <alltraps>

80107404 <vector59>:
.globl vector59
vector59:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $59
80107406:	6a 3b                	push   $0x3b
  jmp alltraps
80107408:	e9 23 f7 ff ff       	jmp    80106b30 <alltraps>

8010740d <vector60>:
.globl vector60
vector60:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $60
8010740f:	6a 3c                	push   $0x3c
  jmp alltraps
80107411:	e9 1a f7 ff ff       	jmp    80106b30 <alltraps>

80107416 <vector61>:
.globl vector61
vector61:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $61
80107418:	6a 3d                	push   $0x3d
  jmp alltraps
8010741a:	e9 11 f7 ff ff       	jmp    80106b30 <alltraps>

8010741f <vector62>:
.globl vector62
vector62:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $62
80107421:	6a 3e                	push   $0x3e
  jmp alltraps
80107423:	e9 08 f7 ff ff       	jmp    80106b30 <alltraps>

80107428 <vector63>:
.globl vector63
vector63:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $63
8010742a:	6a 3f                	push   $0x3f
  jmp alltraps
8010742c:	e9 ff f6 ff ff       	jmp    80106b30 <alltraps>

80107431 <vector64>:
.globl vector64
vector64:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $64
80107433:	6a 40                	push   $0x40
  jmp alltraps
80107435:	e9 f6 f6 ff ff       	jmp    80106b30 <alltraps>

8010743a <vector65>:
.globl vector65
vector65:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $65
8010743c:	6a 41                	push   $0x41
  jmp alltraps
8010743e:	e9 ed f6 ff ff       	jmp    80106b30 <alltraps>

80107443 <vector66>:
.globl vector66
vector66:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $66
80107445:	6a 42                	push   $0x42
  jmp alltraps
80107447:	e9 e4 f6 ff ff       	jmp    80106b30 <alltraps>

8010744c <vector67>:
.globl vector67
vector67:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $67
8010744e:	6a 43                	push   $0x43
  jmp alltraps
80107450:	e9 db f6 ff ff       	jmp    80106b30 <alltraps>

80107455 <vector68>:
.globl vector68
vector68:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $68
80107457:	6a 44                	push   $0x44
  jmp alltraps
80107459:	e9 d2 f6 ff ff       	jmp    80106b30 <alltraps>

8010745e <vector69>:
.globl vector69
vector69:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $69
80107460:	6a 45                	push   $0x45
  jmp alltraps
80107462:	e9 c9 f6 ff ff       	jmp    80106b30 <alltraps>

80107467 <vector70>:
.globl vector70
vector70:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $70
80107469:	6a 46                	push   $0x46
  jmp alltraps
8010746b:	e9 c0 f6 ff ff       	jmp    80106b30 <alltraps>

80107470 <vector71>:
.globl vector71
vector71:
  pushl $0
80107470:	6a 00                	push   $0x0
  pushl $71
80107472:	6a 47                	push   $0x47
  jmp alltraps
80107474:	e9 b7 f6 ff ff       	jmp    80106b30 <alltraps>

80107479 <vector72>:
.globl vector72
vector72:
  pushl $0
80107479:	6a 00                	push   $0x0
  pushl $72
8010747b:	6a 48                	push   $0x48
  jmp alltraps
8010747d:	e9 ae f6 ff ff       	jmp    80106b30 <alltraps>

80107482 <vector73>:
.globl vector73
vector73:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $73
80107484:	6a 49                	push   $0x49
  jmp alltraps
80107486:	e9 a5 f6 ff ff       	jmp    80106b30 <alltraps>

8010748b <vector74>:
.globl vector74
vector74:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $74
8010748d:	6a 4a                	push   $0x4a
  jmp alltraps
8010748f:	e9 9c f6 ff ff       	jmp    80106b30 <alltraps>

80107494 <vector75>:
.globl vector75
vector75:
  pushl $0
80107494:	6a 00                	push   $0x0
  pushl $75
80107496:	6a 4b                	push   $0x4b
  jmp alltraps
80107498:	e9 93 f6 ff ff       	jmp    80106b30 <alltraps>

8010749d <vector76>:
.globl vector76
vector76:
  pushl $0
8010749d:	6a 00                	push   $0x0
  pushl $76
8010749f:	6a 4c                	push   $0x4c
  jmp alltraps
801074a1:	e9 8a f6 ff ff       	jmp    80106b30 <alltraps>

801074a6 <vector77>:
.globl vector77
vector77:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $77
801074a8:	6a 4d                	push   $0x4d
  jmp alltraps
801074aa:	e9 81 f6 ff ff       	jmp    80106b30 <alltraps>

801074af <vector78>:
.globl vector78
vector78:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $78
801074b1:	6a 4e                	push   $0x4e
  jmp alltraps
801074b3:	e9 78 f6 ff ff       	jmp    80106b30 <alltraps>

801074b8 <vector79>:
.globl vector79
vector79:
  pushl $0
801074b8:	6a 00                	push   $0x0
  pushl $79
801074ba:	6a 4f                	push   $0x4f
  jmp alltraps
801074bc:	e9 6f f6 ff ff       	jmp    80106b30 <alltraps>

801074c1 <vector80>:
.globl vector80
vector80:
  pushl $0
801074c1:	6a 00                	push   $0x0
  pushl $80
801074c3:	6a 50                	push   $0x50
  jmp alltraps
801074c5:	e9 66 f6 ff ff       	jmp    80106b30 <alltraps>

801074ca <vector81>:
.globl vector81
vector81:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $81
801074cc:	6a 51                	push   $0x51
  jmp alltraps
801074ce:	e9 5d f6 ff ff       	jmp    80106b30 <alltraps>

801074d3 <vector82>:
.globl vector82
vector82:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $82
801074d5:	6a 52                	push   $0x52
  jmp alltraps
801074d7:	e9 54 f6 ff ff       	jmp    80106b30 <alltraps>

801074dc <vector83>:
.globl vector83
vector83:
  pushl $0
801074dc:	6a 00                	push   $0x0
  pushl $83
801074de:	6a 53                	push   $0x53
  jmp alltraps
801074e0:	e9 4b f6 ff ff       	jmp    80106b30 <alltraps>

801074e5 <vector84>:
.globl vector84
vector84:
  pushl $0
801074e5:	6a 00                	push   $0x0
  pushl $84
801074e7:	6a 54                	push   $0x54
  jmp alltraps
801074e9:	e9 42 f6 ff ff       	jmp    80106b30 <alltraps>

801074ee <vector85>:
.globl vector85
vector85:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $85
801074f0:	6a 55                	push   $0x55
  jmp alltraps
801074f2:	e9 39 f6 ff ff       	jmp    80106b30 <alltraps>

801074f7 <vector86>:
.globl vector86
vector86:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $86
801074f9:	6a 56                	push   $0x56
  jmp alltraps
801074fb:	e9 30 f6 ff ff       	jmp    80106b30 <alltraps>

80107500 <vector87>:
.globl vector87
vector87:
  pushl $0
80107500:	6a 00                	push   $0x0
  pushl $87
80107502:	6a 57                	push   $0x57
  jmp alltraps
80107504:	e9 27 f6 ff ff       	jmp    80106b30 <alltraps>

80107509 <vector88>:
.globl vector88
vector88:
  pushl $0
80107509:	6a 00                	push   $0x0
  pushl $88
8010750b:	6a 58                	push   $0x58
  jmp alltraps
8010750d:	e9 1e f6 ff ff       	jmp    80106b30 <alltraps>

80107512 <vector89>:
.globl vector89
vector89:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $89
80107514:	6a 59                	push   $0x59
  jmp alltraps
80107516:	e9 15 f6 ff ff       	jmp    80106b30 <alltraps>

8010751b <vector90>:
.globl vector90
vector90:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $90
8010751d:	6a 5a                	push   $0x5a
  jmp alltraps
8010751f:	e9 0c f6 ff ff       	jmp    80106b30 <alltraps>

80107524 <vector91>:
.globl vector91
vector91:
  pushl $0
80107524:	6a 00                	push   $0x0
  pushl $91
80107526:	6a 5b                	push   $0x5b
  jmp alltraps
80107528:	e9 03 f6 ff ff       	jmp    80106b30 <alltraps>

8010752d <vector92>:
.globl vector92
vector92:
  pushl $0
8010752d:	6a 00                	push   $0x0
  pushl $92
8010752f:	6a 5c                	push   $0x5c
  jmp alltraps
80107531:	e9 fa f5 ff ff       	jmp    80106b30 <alltraps>

80107536 <vector93>:
.globl vector93
vector93:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $93
80107538:	6a 5d                	push   $0x5d
  jmp alltraps
8010753a:	e9 f1 f5 ff ff       	jmp    80106b30 <alltraps>

8010753f <vector94>:
.globl vector94
vector94:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $94
80107541:	6a 5e                	push   $0x5e
  jmp alltraps
80107543:	e9 e8 f5 ff ff       	jmp    80106b30 <alltraps>

80107548 <vector95>:
.globl vector95
vector95:
  pushl $0
80107548:	6a 00                	push   $0x0
  pushl $95
8010754a:	6a 5f                	push   $0x5f
  jmp alltraps
8010754c:	e9 df f5 ff ff       	jmp    80106b30 <alltraps>

80107551 <vector96>:
.globl vector96
vector96:
  pushl $0
80107551:	6a 00                	push   $0x0
  pushl $96
80107553:	6a 60                	push   $0x60
  jmp alltraps
80107555:	e9 d6 f5 ff ff       	jmp    80106b30 <alltraps>

8010755a <vector97>:
.globl vector97
vector97:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $97
8010755c:	6a 61                	push   $0x61
  jmp alltraps
8010755e:	e9 cd f5 ff ff       	jmp    80106b30 <alltraps>

80107563 <vector98>:
.globl vector98
vector98:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $98
80107565:	6a 62                	push   $0x62
  jmp alltraps
80107567:	e9 c4 f5 ff ff       	jmp    80106b30 <alltraps>

8010756c <vector99>:
.globl vector99
vector99:
  pushl $0
8010756c:	6a 00                	push   $0x0
  pushl $99
8010756e:	6a 63                	push   $0x63
  jmp alltraps
80107570:	e9 bb f5 ff ff       	jmp    80106b30 <alltraps>

80107575 <vector100>:
.globl vector100
vector100:
  pushl $0
80107575:	6a 00                	push   $0x0
  pushl $100
80107577:	6a 64                	push   $0x64
  jmp alltraps
80107579:	e9 b2 f5 ff ff       	jmp    80106b30 <alltraps>

8010757e <vector101>:
.globl vector101
vector101:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $101
80107580:	6a 65                	push   $0x65
  jmp alltraps
80107582:	e9 a9 f5 ff ff       	jmp    80106b30 <alltraps>

80107587 <vector102>:
.globl vector102
vector102:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $102
80107589:	6a 66                	push   $0x66
  jmp alltraps
8010758b:	e9 a0 f5 ff ff       	jmp    80106b30 <alltraps>

80107590 <vector103>:
.globl vector103
vector103:
  pushl $0
80107590:	6a 00                	push   $0x0
  pushl $103
80107592:	6a 67                	push   $0x67
  jmp alltraps
80107594:	e9 97 f5 ff ff       	jmp    80106b30 <alltraps>

80107599 <vector104>:
.globl vector104
vector104:
  pushl $0
80107599:	6a 00                	push   $0x0
  pushl $104
8010759b:	6a 68                	push   $0x68
  jmp alltraps
8010759d:	e9 8e f5 ff ff       	jmp    80106b30 <alltraps>

801075a2 <vector105>:
.globl vector105
vector105:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $105
801075a4:	6a 69                	push   $0x69
  jmp alltraps
801075a6:	e9 85 f5 ff ff       	jmp    80106b30 <alltraps>

801075ab <vector106>:
.globl vector106
vector106:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $106
801075ad:	6a 6a                	push   $0x6a
  jmp alltraps
801075af:	e9 7c f5 ff ff       	jmp    80106b30 <alltraps>

801075b4 <vector107>:
.globl vector107
vector107:
  pushl $0
801075b4:	6a 00                	push   $0x0
  pushl $107
801075b6:	6a 6b                	push   $0x6b
  jmp alltraps
801075b8:	e9 73 f5 ff ff       	jmp    80106b30 <alltraps>

801075bd <vector108>:
.globl vector108
vector108:
  pushl $0
801075bd:	6a 00                	push   $0x0
  pushl $108
801075bf:	6a 6c                	push   $0x6c
  jmp alltraps
801075c1:	e9 6a f5 ff ff       	jmp    80106b30 <alltraps>

801075c6 <vector109>:
.globl vector109
vector109:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $109
801075c8:	6a 6d                	push   $0x6d
  jmp alltraps
801075ca:	e9 61 f5 ff ff       	jmp    80106b30 <alltraps>

801075cf <vector110>:
.globl vector110
vector110:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $110
801075d1:	6a 6e                	push   $0x6e
  jmp alltraps
801075d3:	e9 58 f5 ff ff       	jmp    80106b30 <alltraps>

801075d8 <vector111>:
.globl vector111
vector111:
  pushl $0
801075d8:	6a 00                	push   $0x0
  pushl $111
801075da:	6a 6f                	push   $0x6f
  jmp alltraps
801075dc:	e9 4f f5 ff ff       	jmp    80106b30 <alltraps>

801075e1 <vector112>:
.globl vector112
vector112:
  pushl $0
801075e1:	6a 00                	push   $0x0
  pushl $112
801075e3:	6a 70                	push   $0x70
  jmp alltraps
801075e5:	e9 46 f5 ff ff       	jmp    80106b30 <alltraps>

801075ea <vector113>:
.globl vector113
vector113:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $113
801075ec:	6a 71                	push   $0x71
  jmp alltraps
801075ee:	e9 3d f5 ff ff       	jmp    80106b30 <alltraps>

801075f3 <vector114>:
.globl vector114
vector114:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $114
801075f5:	6a 72                	push   $0x72
  jmp alltraps
801075f7:	e9 34 f5 ff ff       	jmp    80106b30 <alltraps>

801075fc <vector115>:
.globl vector115
vector115:
  pushl $0
801075fc:	6a 00                	push   $0x0
  pushl $115
801075fe:	6a 73                	push   $0x73
  jmp alltraps
80107600:	e9 2b f5 ff ff       	jmp    80106b30 <alltraps>

80107605 <vector116>:
.globl vector116
vector116:
  pushl $0
80107605:	6a 00                	push   $0x0
  pushl $116
80107607:	6a 74                	push   $0x74
  jmp alltraps
80107609:	e9 22 f5 ff ff       	jmp    80106b30 <alltraps>

8010760e <vector117>:
.globl vector117
vector117:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $117
80107610:	6a 75                	push   $0x75
  jmp alltraps
80107612:	e9 19 f5 ff ff       	jmp    80106b30 <alltraps>

80107617 <vector118>:
.globl vector118
vector118:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $118
80107619:	6a 76                	push   $0x76
  jmp alltraps
8010761b:	e9 10 f5 ff ff       	jmp    80106b30 <alltraps>

80107620 <vector119>:
.globl vector119
vector119:
  pushl $0
80107620:	6a 00                	push   $0x0
  pushl $119
80107622:	6a 77                	push   $0x77
  jmp alltraps
80107624:	e9 07 f5 ff ff       	jmp    80106b30 <alltraps>

80107629 <vector120>:
.globl vector120
vector120:
  pushl $0
80107629:	6a 00                	push   $0x0
  pushl $120
8010762b:	6a 78                	push   $0x78
  jmp alltraps
8010762d:	e9 fe f4 ff ff       	jmp    80106b30 <alltraps>

80107632 <vector121>:
.globl vector121
vector121:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $121
80107634:	6a 79                	push   $0x79
  jmp alltraps
80107636:	e9 f5 f4 ff ff       	jmp    80106b30 <alltraps>

8010763b <vector122>:
.globl vector122
vector122:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $122
8010763d:	6a 7a                	push   $0x7a
  jmp alltraps
8010763f:	e9 ec f4 ff ff       	jmp    80106b30 <alltraps>

80107644 <vector123>:
.globl vector123
vector123:
  pushl $0
80107644:	6a 00                	push   $0x0
  pushl $123
80107646:	6a 7b                	push   $0x7b
  jmp alltraps
80107648:	e9 e3 f4 ff ff       	jmp    80106b30 <alltraps>

8010764d <vector124>:
.globl vector124
vector124:
  pushl $0
8010764d:	6a 00                	push   $0x0
  pushl $124
8010764f:	6a 7c                	push   $0x7c
  jmp alltraps
80107651:	e9 da f4 ff ff       	jmp    80106b30 <alltraps>

80107656 <vector125>:
.globl vector125
vector125:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $125
80107658:	6a 7d                	push   $0x7d
  jmp alltraps
8010765a:	e9 d1 f4 ff ff       	jmp    80106b30 <alltraps>

8010765f <vector126>:
.globl vector126
vector126:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $126
80107661:	6a 7e                	push   $0x7e
  jmp alltraps
80107663:	e9 c8 f4 ff ff       	jmp    80106b30 <alltraps>

80107668 <vector127>:
.globl vector127
vector127:
  pushl $0
80107668:	6a 00                	push   $0x0
  pushl $127
8010766a:	6a 7f                	push   $0x7f
  jmp alltraps
8010766c:	e9 bf f4 ff ff       	jmp    80106b30 <alltraps>

80107671 <vector128>:
.globl vector128
vector128:
  pushl $0
80107671:	6a 00                	push   $0x0
  pushl $128
80107673:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107678:	e9 b3 f4 ff ff       	jmp    80106b30 <alltraps>

8010767d <vector129>:
.globl vector129
vector129:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $129
8010767f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107684:	e9 a7 f4 ff ff       	jmp    80106b30 <alltraps>

80107689 <vector130>:
.globl vector130
vector130:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $130
8010768b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107690:	e9 9b f4 ff ff       	jmp    80106b30 <alltraps>

80107695 <vector131>:
.globl vector131
vector131:
  pushl $0
80107695:	6a 00                	push   $0x0
  pushl $131
80107697:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010769c:	e9 8f f4 ff ff       	jmp    80106b30 <alltraps>

801076a1 <vector132>:
.globl vector132
vector132:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $132
801076a3:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801076a8:	e9 83 f4 ff ff       	jmp    80106b30 <alltraps>

801076ad <vector133>:
.globl vector133
vector133:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $133
801076af:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801076b4:	e9 77 f4 ff ff       	jmp    80106b30 <alltraps>

801076b9 <vector134>:
.globl vector134
vector134:
  pushl $0
801076b9:	6a 00                	push   $0x0
  pushl $134
801076bb:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801076c0:	e9 6b f4 ff ff       	jmp    80106b30 <alltraps>

801076c5 <vector135>:
.globl vector135
vector135:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $135
801076c7:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801076cc:	e9 5f f4 ff ff       	jmp    80106b30 <alltraps>

801076d1 <vector136>:
.globl vector136
vector136:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $136
801076d3:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801076d8:	e9 53 f4 ff ff       	jmp    80106b30 <alltraps>

801076dd <vector137>:
.globl vector137
vector137:
  pushl $0
801076dd:	6a 00                	push   $0x0
  pushl $137
801076df:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801076e4:	e9 47 f4 ff ff       	jmp    80106b30 <alltraps>

801076e9 <vector138>:
.globl vector138
vector138:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $138
801076eb:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801076f0:	e9 3b f4 ff ff       	jmp    80106b30 <alltraps>

801076f5 <vector139>:
.globl vector139
vector139:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $139
801076f7:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801076fc:	e9 2f f4 ff ff       	jmp    80106b30 <alltraps>

80107701 <vector140>:
.globl vector140
vector140:
  pushl $0
80107701:	6a 00                	push   $0x0
  pushl $140
80107703:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107708:	e9 23 f4 ff ff       	jmp    80106b30 <alltraps>

8010770d <vector141>:
.globl vector141
vector141:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $141
8010770f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107714:	e9 17 f4 ff ff       	jmp    80106b30 <alltraps>

80107719 <vector142>:
.globl vector142
vector142:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $142
8010771b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107720:	e9 0b f4 ff ff       	jmp    80106b30 <alltraps>

80107725 <vector143>:
.globl vector143
vector143:
  pushl $0
80107725:	6a 00                	push   $0x0
  pushl $143
80107727:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010772c:	e9 ff f3 ff ff       	jmp    80106b30 <alltraps>

80107731 <vector144>:
.globl vector144
vector144:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $144
80107733:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107738:	e9 f3 f3 ff ff       	jmp    80106b30 <alltraps>

8010773d <vector145>:
.globl vector145
vector145:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $145
8010773f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107744:	e9 e7 f3 ff ff       	jmp    80106b30 <alltraps>

80107749 <vector146>:
.globl vector146
vector146:
  pushl $0
80107749:	6a 00                	push   $0x0
  pushl $146
8010774b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107750:	e9 db f3 ff ff       	jmp    80106b30 <alltraps>

80107755 <vector147>:
.globl vector147
vector147:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $147
80107757:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010775c:	e9 cf f3 ff ff       	jmp    80106b30 <alltraps>

80107761 <vector148>:
.globl vector148
vector148:
  pushl $0
80107761:	6a 00                	push   $0x0
  pushl $148
80107763:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107768:	e9 c3 f3 ff ff       	jmp    80106b30 <alltraps>

8010776d <vector149>:
.globl vector149
vector149:
  pushl $0
8010776d:	6a 00                	push   $0x0
  pushl $149
8010776f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107774:	e9 b7 f3 ff ff       	jmp    80106b30 <alltraps>

80107779 <vector150>:
.globl vector150
vector150:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $150
8010777b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107780:	e9 ab f3 ff ff       	jmp    80106b30 <alltraps>

80107785 <vector151>:
.globl vector151
vector151:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $151
80107787:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010778c:	e9 9f f3 ff ff       	jmp    80106b30 <alltraps>

80107791 <vector152>:
.globl vector152
vector152:
  pushl $0
80107791:	6a 00                	push   $0x0
  pushl $152
80107793:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107798:	e9 93 f3 ff ff       	jmp    80106b30 <alltraps>

8010779d <vector153>:
.globl vector153
vector153:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $153
8010779f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801077a4:	e9 87 f3 ff ff       	jmp    80106b30 <alltraps>

801077a9 <vector154>:
.globl vector154
vector154:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $154
801077ab:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801077b0:	e9 7b f3 ff ff       	jmp    80106b30 <alltraps>

801077b5 <vector155>:
.globl vector155
vector155:
  pushl $0
801077b5:	6a 00                	push   $0x0
  pushl $155
801077b7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801077bc:	e9 6f f3 ff ff       	jmp    80106b30 <alltraps>

801077c1 <vector156>:
.globl vector156
vector156:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $156
801077c3:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801077c8:	e9 63 f3 ff ff       	jmp    80106b30 <alltraps>

801077cd <vector157>:
.globl vector157
vector157:
  pushl $0
801077cd:	6a 00                	push   $0x0
  pushl $157
801077cf:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801077d4:	e9 57 f3 ff ff       	jmp    80106b30 <alltraps>

801077d9 <vector158>:
.globl vector158
vector158:
  pushl $0
801077d9:	6a 00                	push   $0x0
  pushl $158
801077db:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801077e0:	e9 4b f3 ff ff       	jmp    80106b30 <alltraps>

801077e5 <vector159>:
.globl vector159
vector159:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $159
801077e7:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801077ec:	e9 3f f3 ff ff       	jmp    80106b30 <alltraps>

801077f1 <vector160>:
.globl vector160
vector160:
  pushl $0
801077f1:	6a 00                	push   $0x0
  pushl $160
801077f3:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801077f8:	e9 33 f3 ff ff       	jmp    80106b30 <alltraps>

801077fd <vector161>:
.globl vector161
vector161:
  pushl $0
801077fd:	6a 00                	push   $0x0
  pushl $161
801077ff:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107804:	e9 27 f3 ff ff       	jmp    80106b30 <alltraps>

80107809 <vector162>:
.globl vector162
vector162:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $162
8010780b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107810:	e9 1b f3 ff ff       	jmp    80106b30 <alltraps>

80107815 <vector163>:
.globl vector163
vector163:
  pushl $0
80107815:	6a 00                	push   $0x0
  pushl $163
80107817:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010781c:	e9 0f f3 ff ff       	jmp    80106b30 <alltraps>

80107821 <vector164>:
.globl vector164
vector164:
  pushl $0
80107821:	6a 00                	push   $0x0
  pushl $164
80107823:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107828:	e9 03 f3 ff ff       	jmp    80106b30 <alltraps>

8010782d <vector165>:
.globl vector165
vector165:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $165
8010782f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107834:	e9 f7 f2 ff ff       	jmp    80106b30 <alltraps>

80107839 <vector166>:
.globl vector166
vector166:
  pushl $0
80107839:	6a 00                	push   $0x0
  pushl $166
8010783b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107840:	e9 eb f2 ff ff       	jmp    80106b30 <alltraps>

80107845 <vector167>:
.globl vector167
vector167:
  pushl $0
80107845:	6a 00                	push   $0x0
  pushl $167
80107847:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010784c:	e9 df f2 ff ff       	jmp    80106b30 <alltraps>

80107851 <vector168>:
.globl vector168
vector168:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $168
80107853:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107858:	e9 d3 f2 ff ff       	jmp    80106b30 <alltraps>

8010785d <vector169>:
.globl vector169
vector169:
  pushl $0
8010785d:	6a 00                	push   $0x0
  pushl $169
8010785f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107864:	e9 c7 f2 ff ff       	jmp    80106b30 <alltraps>

80107869 <vector170>:
.globl vector170
vector170:
  pushl $0
80107869:	6a 00                	push   $0x0
  pushl $170
8010786b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107870:	e9 bb f2 ff ff       	jmp    80106b30 <alltraps>

80107875 <vector171>:
.globl vector171
vector171:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $171
80107877:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010787c:	e9 af f2 ff ff       	jmp    80106b30 <alltraps>

80107881 <vector172>:
.globl vector172
vector172:
  pushl $0
80107881:	6a 00                	push   $0x0
  pushl $172
80107883:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107888:	e9 a3 f2 ff ff       	jmp    80106b30 <alltraps>

8010788d <vector173>:
.globl vector173
vector173:
  pushl $0
8010788d:	6a 00                	push   $0x0
  pushl $173
8010788f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107894:	e9 97 f2 ff ff       	jmp    80106b30 <alltraps>

80107899 <vector174>:
.globl vector174
vector174:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $174
8010789b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801078a0:	e9 8b f2 ff ff       	jmp    80106b30 <alltraps>

801078a5 <vector175>:
.globl vector175
vector175:
  pushl $0
801078a5:	6a 00                	push   $0x0
  pushl $175
801078a7:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801078ac:	e9 7f f2 ff ff       	jmp    80106b30 <alltraps>

801078b1 <vector176>:
.globl vector176
vector176:
  pushl $0
801078b1:	6a 00                	push   $0x0
  pushl $176
801078b3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801078b8:	e9 73 f2 ff ff       	jmp    80106b30 <alltraps>

801078bd <vector177>:
.globl vector177
vector177:
  pushl $0
801078bd:	6a 00                	push   $0x0
  pushl $177
801078bf:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801078c4:	e9 67 f2 ff ff       	jmp    80106b30 <alltraps>

801078c9 <vector178>:
.globl vector178
vector178:
  pushl $0
801078c9:	6a 00                	push   $0x0
  pushl $178
801078cb:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801078d0:	e9 5b f2 ff ff       	jmp    80106b30 <alltraps>

801078d5 <vector179>:
.globl vector179
vector179:
  pushl $0
801078d5:	6a 00                	push   $0x0
  pushl $179
801078d7:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801078dc:	e9 4f f2 ff ff       	jmp    80106b30 <alltraps>

801078e1 <vector180>:
.globl vector180
vector180:
  pushl $0
801078e1:	6a 00                	push   $0x0
  pushl $180
801078e3:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801078e8:	e9 43 f2 ff ff       	jmp    80106b30 <alltraps>

801078ed <vector181>:
.globl vector181
vector181:
  pushl $0
801078ed:	6a 00                	push   $0x0
  pushl $181
801078ef:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801078f4:	e9 37 f2 ff ff       	jmp    80106b30 <alltraps>

801078f9 <vector182>:
.globl vector182
vector182:
  pushl $0
801078f9:	6a 00                	push   $0x0
  pushl $182
801078fb:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107900:	e9 2b f2 ff ff       	jmp    80106b30 <alltraps>

80107905 <vector183>:
.globl vector183
vector183:
  pushl $0
80107905:	6a 00                	push   $0x0
  pushl $183
80107907:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010790c:	e9 1f f2 ff ff       	jmp    80106b30 <alltraps>

80107911 <vector184>:
.globl vector184
vector184:
  pushl $0
80107911:	6a 00                	push   $0x0
  pushl $184
80107913:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107918:	e9 13 f2 ff ff       	jmp    80106b30 <alltraps>

8010791d <vector185>:
.globl vector185
vector185:
  pushl $0
8010791d:	6a 00                	push   $0x0
  pushl $185
8010791f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107924:	e9 07 f2 ff ff       	jmp    80106b30 <alltraps>

80107929 <vector186>:
.globl vector186
vector186:
  pushl $0
80107929:	6a 00                	push   $0x0
  pushl $186
8010792b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107930:	e9 fb f1 ff ff       	jmp    80106b30 <alltraps>

80107935 <vector187>:
.globl vector187
vector187:
  pushl $0
80107935:	6a 00                	push   $0x0
  pushl $187
80107937:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010793c:	e9 ef f1 ff ff       	jmp    80106b30 <alltraps>

80107941 <vector188>:
.globl vector188
vector188:
  pushl $0
80107941:	6a 00                	push   $0x0
  pushl $188
80107943:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107948:	e9 e3 f1 ff ff       	jmp    80106b30 <alltraps>

8010794d <vector189>:
.globl vector189
vector189:
  pushl $0
8010794d:	6a 00                	push   $0x0
  pushl $189
8010794f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107954:	e9 d7 f1 ff ff       	jmp    80106b30 <alltraps>

80107959 <vector190>:
.globl vector190
vector190:
  pushl $0
80107959:	6a 00                	push   $0x0
  pushl $190
8010795b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107960:	e9 cb f1 ff ff       	jmp    80106b30 <alltraps>

80107965 <vector191>:
.globl vector191
vector191:
  pushl $0
80107965:	6a 00                	push   $0x0
  pushl $191
80107967:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010796c:	e9 bf f1 ff ff       	jmp    80106b30 <alltraps>

80107971 <vector192>:
.globl vector192
vector192:
  pushl $0
80107971:	6a 00                	push   $0x0
  pushl $192
80107973:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107978:	e9 b3 f1 ff ff       	jmp    80106b30 <alltraps>

8010797d <vector193>:
.globl vector193
vector193:
  pushl $0
8010797d:	6a 00                	push   $0x0
  pushl $193
8010797f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107984:	e9 a7 f1 ff ff       	jmp    80106b30 <alltraps>

80107989 <vector194>:
.globl vector194
vector194:
  pushl $0
80107989:	6a 00                	push   $0x0
  pushl $194
8010798b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107990:	e9 9b f1 ff ff       	jmp    80106b30 <alltraps>

80107995 <vector195>:
.globl vector195
vector195:
  pushl $0
80107995:	6a 00                	push   $0x0
  pushl $195
80107997:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010799c:	e9 8f f1 ff ff       	jmp    80106b30 <alltraps>

801079a1 <vector196>:
.globl vector196
vector196:
  pushl $0
801079a1:	6a 00                	push   $0x0
  pushl $196
801079a3:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801079a8:	e9 83 f1 ff ff       	jmp    80106b30 <alltraps>

801079ad <vector197>:
.globl vector197
vector197:
  pushl $0
801079ad:	6a 00                	push   $0x0
  pushl $197
801079af:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801079b4:	e9 77 f1 ff ff       	jmp    80106b30 <alltraps>

801079b9 <vector198>:
.globl vector198
vector198:
  pushl $0
801079b9:	6a 00                	push   $0x0
  pushl $198
801079bb:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801079c0:	e9 6b f1 ff ff       	jmp    80106b30 <alltraps>

801079c5 <vector199>:
.globl vector199
vector199:
  pushl $0
801079c5:	6a 00                	push   $0x0
  pushl $199
801079c7:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801079cc:	e9 5f f1 ff ff       	jmp    80106b30 <alltraps>

801079d1 <vector200>:
.globl vector200
vector200:
  pushl $0
801079d1:	6a 00                	push   $0x0
  pushl $200
801079d3:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801079d8:	e9 53 f1 ff ff       	jmp    80106b30 <alltraps>

801079dd <vector201>:
.globl vector201
vector201:
  pushl $0
801079dd:	6a 00                	push   $0x0
  pushl $201
801079df:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801079e4:	e9 47 f1 ff ff       	jmp    80106b30 <alltraps>

801079e9 <vector202>:
.globl vector202
vector202:
  pushl $0
801079e9:	6a 00                	push   $0x0
  pushl $202
801079eb:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801079f0:	e9 3b f1 ff ff       	jmp    80106b30 <alltraps>

801079f5 <vector203>:
.globl vector203
vector203:
  pushl $0
801079f5:	6a 00                	push   $0x0
  pushl $203
801079f7:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801079fc:	e9 2f f1 ff ff       	jmp    80106b30 <alltraps>

80107a01 <vector204>:
.globl vector204
vector204:
  pushl $0
80107a01:	6a 00                	push   $0x0
  pushl $204
80107a03:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a08:	e9 23 f1 ff ff       	jmp    80106b30 <alltraps>

80107a0d <vector205>:
.globl vector205
vector205:
  pushl $0
80107a0d:	6a 00                	push   $0x0
  pushl $205
80107a0f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a14:	e9 17 f1 ff ff       	jmp    80106b30 <alltraps>

80107a19 <vector206>:
.globl vector206
vector206:
  pushl $0
80107a19:	6a 00                	push   $0x0
  pushl $206
80107a1b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a20:	e9 0b f1 ff ff       	jmp    80106b30 <alltraps>

80107a25 <vector207>:
.globl vector207
vector207:
  pushl $0
80107a25:	6a 00                	push   $0x0
  pushl $207
80107a27:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a2c:	e9 ff f0 ff ff       	jmp    80106b30 <alltraps>

80107a31 <vector208>:
.globl vector208
vector208:
  pushl $0
80107a31:	6a 00                	push   $0x0
  pushl $208
80107a33:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107a38:	e9 f3 f0 ff ff       	jmp    80106b30 <alltraps>

80107a3d <vector209>:
.globl vector209
vector209:
  pushl $0
80107a3d:	6a 00                	push   $0x0
  pushl $209
80107a3f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107a44:	e9 e7 f0 ff ff       	jmp    80106b30 <alltraps>

80107a49 <vector210>:
.globl vector210
vector210:
  pushl $0
80107a49:	6a 00                	push   $0x0
  pushl $210
80107a4b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a50:	e9 db f0 ff ff       	jmp    80106b30 <alltraps>

80107a55 <vector211>:
.globl vector211
vector211:
  pushl $0
80107a55:	6a 00                	push   $0x0
  pushl $211
80107a57:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a5c:	e9 cf f0 ff ff       	jmp    80106b30 <alltraps>

80107a61 <vector212>:
.globl vector212
vector212:
  pushl $0
80107a61:	6a 00                	push   $0x0
  pushl $212
80107a63:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a68:	e9 c3 f0 ff ff       	jmp    80106b30 <alltraps>

80107a6d <vector213>:
.globl vector213
vector213:
  pushl $0
80107a6d:	6a 00                	push   $0x0
  pushl $213
80107a6f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a74:	e9 b7 f0 ff ff       	jmp    80106b30 <alltraps>

80107a79 <vector214>:
.globl vector214
vector214:
  pushl $0
80107a79:	6a 00                	push   $0x0
  pushl $214
80107a7b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a80:	e9 ab f0 ff ff       	jmp    80106b30 <alltraps>

80107a85 <vector215>:
.globl vector215
vector215:
  pushl $0
80107a85:	6a 00                	push   $0x0
  pushl $215
80107a87:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a8c:	e9 9f f0 ff ff       	jmp    80106b30 <alltraps>

80107a91 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a91:	6a 00                	push   $0x0
  pushl $216
80107a93:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a98:	e9 93 f0 ff ff       	jmp    80106b30 <alltraps>

80107a9d <vector217>:
.globl vector217
vector217:
  pushl $0
80107a9d:	6a 00                	push   $0x0
  pushl $217
80107a9f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107aa4:	e9 87 f0 ff ff       	jmp    80106b30 <alltraps>

80107aa9 <vector218>:
.globl vector218
vector218:
  pushl $0
80107aa9:	6a 00                	push   $0x0
  pushl $218
80107aab:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ab0:	e9 7b f0 ff ff       	jmp    80106b30 <alltraps>

80107ab5 <vector219>:
.globl vector219
vector219:
  pushl $0
80107ab5:	6a 00                	push   $0x0
  pushl $219
80107ab7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107abc:	e9 6f f0 ff ff       	jmp    80106b30 <alltraps>

80107ac1 <vector220>:
.globl vector220
vector220:
  pushl $0
80107ac1:	6a 00                	push   $0x0
  pushl $220
80107ac3:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ac8:	e9 63 f0 ff ff       	jmp    80106b30 <alltraps>

80107acd <vector221>:
.globl vector221
vector221:
  pushl $0
80107acd:	6a 00                	push   $0x0
  pushl $221
80107acf:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107ad4:	e9 57 f0 ff ff       	jmp    80106b30 <alltraps>

80107ad9 <vector222>:
.globl vector222
vector222:
  pushl $0
80107ad9:	6a 00                	push   $0x0
  pushl $222
80107adb:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107ae0:	e9 4b f0 ff ff       	jmp    80106b30 <alltraps>

80107ae5 <vector223>:
.globl vector223
vector223:
  pushl $0
80107ae5:	6a 00                	push   $0x0
  pushl $223
80107ae7:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107aec:	e9 3f f0 ff ff       	jmp    80106b30 <alltraps>

80107af1 <vector224>:
.globl vector224
vector224:
  pushl $0
80107af1:	6a 00                	push   $0x0
  pushl $224
80107af3:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107af8:	e9 33 f0 ff ff       	jmp    80106b30 <alltraps>

80107afd <vector225>:
.globl vector225
vector225:
  pushl $0
80107afd:	6a 00                	push   $0x0
  pushl $225
80107aff:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b04:	e9 27 f0 ff ff       	jmp    80106b30 <alltraps>

80107b09 <vector226>:
.globl vector226
vector226:
  pushl $0
80107b09:	6a 00                	push   $0x0
  pushl $226
80107b0b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b10:	e9 1b f0 ff ff       	jmp    80106b30 <alltraps>

80107b15 <vector227>:
.globl vector227
vector227:
  pushl $0
80107b15:	6a 00                	push   $0x0
  pushl $227
80107b17:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b1c:	e9 0f f0 ff ff       	jmp    80106b30 <alltraps>

80107b21 <vector228>:
.globl vector228
vector228:
  pushl $0
80107b21:	6a 00                	push   $0x0
  pushl $228
80107b23:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b28:	e9 03 f0 ff ff       	jmp    80106b30 <alltraps>

80107b2d <vector229>:
.globl vector229
vector229:
  pushl $0
80107b2d:	6a 00                	push   $0x0
  pushl $229
80107b2f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107b34:	e9 f7 ef ff ff       	jmp    80106b30 <alltraps>

80107b39 <vector230>:
.globl vector230
vector230:
  pushl $0
80107b39:	6a 00                	push   $0x0
  pushl $230
80107b3b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107b40:	e9 eb ef ff ff       	jmp    80106b30 <alltraps>

80107b45 <vector231>:
.globl vector231
vector231:
  pushl $0
80107b45:	6a 00                	push   $0x0
  pushl $231
80107b47:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107b4c:	e9 df ef ff ff       	jmp    80106b30 <alltraps>

80107b51 <vector232>:
.globl vector232
vector232:
  pushl $0
80107b51:	6a 00                	push   $0x0
  pushl $232
80107b53:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b58:	e9 d3 ef ff ff       	jmp    80106b30 <alltraps>

80107b5d <vector233>:
.globl vector233
vector233:
  pushl $0
80107b5d:	6a 00                	push   $0x0
  pushl $233
80107b5f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b64:	e9 c7 ef ff ff       	jmp    80106b30 <alltraps>

80107b69 <vector234>:
.globl vector234
vector234:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $234
80107b6b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b70:	e9 bb ef ff ff       	jmp    80106b30 <alltraps>

80107b75 <vector235>:
.globl vector235
vector235:
  pushl $0
80107b75:	6a 00                	push   $0x0
  pushl $235
80107b77:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b7c:	e9 af ef ff ff       	jmp    80106b30 <alltraps>

80107b81 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b81:	6a 00                	push   $0x0
  pushl $236
80107b83:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b88:	e9 a3 ef ff ff       	jmp    80106b30 <alltraps>

80107b8d <vector237>:
.globl vector237
vector237:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $237
80107b8f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b94:	e9 97 ef ff ff       	jmp    80106b30 <alltraps>

80107b99 <vector238>:
.globl vector238
vector238:
  pushl $0
80107b99:	6a 00                	push   $0x0
  pushl $238
80107b9b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ba0:	e9 8b ef ff ff       	jmp    80106b30 <alltraps>

80107ba5 <vector239>:
.globl vector239
vector239:
  pushl $0
80107ba5:	6a 00                	push   $0x0
  pushl $239
80107ba7:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107bac:	e9 7f ef ff ff       	jmp    80106b30 <alltraps>

80107bb1 <vector240>:
.globl vector240
vector240:
  pushl $0
80107bb1:	6a 00                	push   $0x0
  pushl $240
80107bb3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107bb8:	e9 73 ef ff ff       	jmp    80106b30 <alltraps>

80107bbd <vector241>:
.globl vector241
vector241:
  pushl $0
80107bbd:	6a 00                	push   $0x0
  pushl $241
80107bbf:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107bc4:	e9 67 ef ff ff       	jmp    80106b30 <alltraps>

80107bc9 <vector242>:
.globl vector242
vector242:
  pushl $0
80107bc9:	6a 00                	push   $0x0
  pushl $242
80107bcb:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107bd0:	e9 5b ef ff ff       	jmp    80106b30 <alltraps>

80107bd5 <vector243>:
.globl vector243
vector243:
  pushl $0
80107bd5:	6a 00                	push   $0x0
  pushl $243
80107bd7:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107bdc:	e9 4f ef ff ff       	jmp    80106b30 <alltraps>

80107be1 <vector244>:
.globl vector244
vector244:
  pushl $0
80107be1:	6a 00                	push   $0x0
  pushl $244
80107be3:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107be8:	e9 43 ef ff ff       	jmp    80106b30 <alltraps>

80107bed <vector245>:
.globl vector245
vector245:
  pushl $0
80107bed:	6a 00                	push   $0x0
  pushl $245
80107bef:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107bf4:	e9 37 ef ff ff       	jmp    80106b30 <alltraps>

80107bf9 <vector246>:
.globl vector246
vector246:
  pushl $0
80107bf9:	6a 00                	push   $0x0
  pushl $246
80107bfb:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c00:	e9 2b ef ff ff       	jmp    80106b30 <alltraps>

80107c05 <vector247>:
.globl vector247
vector247:
  pushl $0
80107c05:	6a 00                	push   $0x0
  pushl $247
80107c07:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c0c:	e9 1f ef ff ff       	jmp    80106b30 <alltraps>

80107c11 <vector248>:
.globl vector248
vector248:
  pushl $0
80107c11:	6a 00                	push   $0x0
  pushl $248
80107c13:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c18:	e9 13 ef ff ff       	jmp    80106b30 <alltraps>

80107c1d <vector249>:
.globl vector249
vector249:
  pushl $0
80107c1d:	6a 00                	push   $0x0
  pushl $249
80107c1f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c24:	e9 07 ef ff ff       	jmp    80106b30 <alltraps>

80107c29 <vector250>:
.globl vector250
vector250:
  pushl $0
80107c29:	6a 00                	push   $0x0
  pushl $250
80107c2b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c30:	e9 fb ee ff ff       	jmp    80106b30 <alltraps>

80107c35 <vector251>:
.globl vector251
vector251:
  pushl $0
80107c35:	6a 00                	push   $0x0
  pushl $251
80107c37:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c3c:	e9 ef ee ff ff       	jmp    80106b30 <alltraps>

80107c41 <vector252>:
.globl vector252
vector252:
  pushl $0
80107c41:	6a 00                	push   $0x0
  pushl $252
80107c43:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107c48:	e9 e3 ee ff ff       	jmp    80106b30 <alltraps>

80107c4d <vector253>:
.globl vector253
vector253:
  pushl $0
80107c4d:	6a 00                	push   $0x0
  pushl $253
80107c4f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c54:	e9 d7 ee ff ff       	jmp    80106b30 <alltraps>

80107c59 <vector254>:
.globl vector254
vector254:
  pushl $0
80107c59:	6a 00                	push   $0x0
  pushl $254
80107c5b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c60:	e9 cb ee ff ff       	jmp    80106b30 <alltraps>

80107c65 <vector255>:
.globl vector255
vector255:
  pushl $0
80107c65:	6a 00                	push   $0x0
  pushl $255
80107c67:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c6c:	e9 bf ee ff ff       	jmp    80106b30 <alltraps>

80107c71 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107c71:	55                   	push   %ebp
80107c72:	89 e5                	mov    %esp,%ebp
80107c74:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107c77:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c7a:	83 e8 01             	sub    $0x1,%eax
80107c7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c81:	8b 45 08             	mov    0x8(%ebp),%eax
80107c84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107c88:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8b:	c1 e8 10             	shr    $0x10,%eax
80107c8e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107c92:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107c95:	0f 01 10             	lgdtl  (%eax)
}
80107c98:	c9                   	leave  
80107c99:	c3                   	ret    

80107c9a <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107c9a:	55                   	push   %ebp
80107c9b:	89 e5                	mov    %esp,%ebp
80107c9d:	83 ec 04             	sub    $0x4,%esp
80107ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ca7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107cab:	0f 00 d8             	ltr    %ax
}
80107cae:	c9                   	leave  
80107caf:	c3                   	ret    

80107cb0 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	83 ec 04             	sub    $0x4,%esp
80107cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80107cb9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107cbd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107cc1:	8e e8                	mov    %eax,%gs
}
80107cc3:	c9                   	leave  
80107cc4:	c3                   	ret    

80107cc5 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107cc5:	55                   	push   %ebp
80107cc6:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80107ccb:	0f 22 d8             	mov    %eax,%cr3
}
80107cce:	5d                   	pop    %ebp
80107ccf:	c3                   	ret    

80107cd0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd6:	05 00 00 00 80       	add    $0x80000000,%eax
80107cdb:	5d                   	pop    %ebp
80107cdc:	c3                   	ret    

80107cdd <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107cdd:	55                   	push   %ebp
80107cde:	89 e5                	mov    %esp,%ebp
80107ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce3:	05 00 00 00 80       	add    $0x80000000,%eax
80107ce8:	5d                   	pop    %ebp
80107ce9:	c3                   	ret    

80107cea <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107cea:	55                   	push   %ebp
80107ceb:	89 e5                	mov    %esp,%ebp
80107ced:	53                   	push   %ebx
80107cee:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107cf1:	e8 94 b1 ff ff       	call   80102e8a <cpunum>
80107cf6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107cfc:	05 80 33 11 80       	add    $0x80113380,%eax
80107d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d07:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d10:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d19:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d20:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d24:	83 e2 f0             	and    $0xfffffff0,%edx
80107d27:	83 ca 0a             	or     $0xa,%edx
80107d2a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d30:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d34:	83 ca 10             	or     $0x10,%edx
80107d37:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d41:	83 e2 9f             	and    $0xffffff9f,%edx
80107d44:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d4e:	83 ca 80             	or     $0xffffff80,%edx
80107d51:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d57:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d5b:	83 ca 0f             	or     $0xf,%edx
80107d5e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d64:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d68:	83 e2 ef             	and    $0xffffffef,%edx
80107d6b:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d71:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d75:	83 e2 df             	and    $0xffffffdf,%edx
80107d78:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d82:	83 ca 40             	or     $0x40,%edx
80107d85:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d8f:	83 ca 80             	or     $0xffffff80,%edx
80107d92:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d98:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9f:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107da6:	ff ff 
80107da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dab:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107db2:	00 00 
80107db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db7:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dc8:	83 e2 f0             	and    $0xfffffff0,%edx
80107dcb:	83 ca 02             	or     $0x2,%edx
80107dce:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dde:	83 ca 10             	or     $0x10,%edx
80107de1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dea:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107df1:	83 e2 9f             	and    $0xffffff9f,%edx
80107df4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfd:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e04:	83 ca 80             	or     $0xffffff80,%edx
80107e07:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e10:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e17:	83 ca 0f             	or     $0xf,%edx
80107e1a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e23:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e2a:	83 e2 ef             	and    $0xffffffef,%edx
80107e2d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e36:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e3d:	83 e2 df             	and    $0xffffffdf,%edx
80107e40:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e49:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e50:	83 ca 40             	or     $0x40,%edx
80107e53:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e63:	83 ca 80             	or     $0xffffff80,%edx
80107e66:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6f:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e79:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107e80:	ff ff 
80107e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e85:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107e8c:	00 00 
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ea2:	83 e2 f0             	and    $0xfffffff0,%edx
80107ea5:	83 ca 0a             	or     $0xa,%edx
80107ea8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107eb8:	83 ca 10             	or     $0x10,%edx
80107ebb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ecb:	83 ca 60             	or     $0x60,%edx
80107ece:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ede:	83 ca 80             	or     $0xffffff80,%edx
80107ee1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eea:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ef1:	83 ca 0f             	or     $0xf,%edx
80107ef4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f04:	83 e2 ef             	and    $0xffffffef,%edx
80107f07:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f10:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f17:	83 e2 df             	and    $0xffffffdf,%edx
80107f1a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f23:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f2a:	83 ca 40             	or     $0x40,%edx
80107f2d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f36:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f3d:	83 ca 80             	or     $0xffffff80,%edx
80107f40:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f49:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f53:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107f5a:	ff ff 
80107f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5f:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107f66:	00 00 
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f75:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f7c:	83 e2 f0             	and    $0xfffffff0,%edx
80107f7f:	83 ca 02             	or     $0x2,%edx
80107f82:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f92:	83 ca 10             	or     $0x10,%edx
80107f95:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fa5:	83 ca 60             	or     $0x60,%edx
80107fa8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fb8:	83 ca 80             	or     $0xffffff80,%edx
80107fbb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fcb:	83 ca 0f             	or     $0xf,%edx
80107fce:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fde:	83 e2 ef             	and    $0xffffffef,%edx
80107fe1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fea:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ff1:	83 e2 df             	and    $0xffffffdf,%edx
80107ff4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108004:	83 ca 40             	or     $0x40,%edx
80108007:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010800d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108010:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108017:	83 ca 80             	or     $0xffffff80,%edx
8010801a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108023:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010802a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802d:	05 b4 00 00 00       	add    $0xb4,%eax
80108032:	89 c3                	mov    %eax,%ebx
80108034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108037:	05 b4 00 00 00       	add    $0xb4,%eax
8010803c:	c1 e8 10             	shr    $0x10,%eax
8010803f:	89 c1                	mov    %eax,%ecx
80108041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108044:	05 b4 00 00 00       	add    $0xb4,%eax
80108049:	c1 e8 18             	shr    $0x18,%eax
8010804c:	89 c2                	mov    %eax,%edx
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108058:	00 00 
8010805a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805d:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108067:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010806d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108070:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108077:	83 e1 f0             	and    $0xfffffff0,%ecx
8010807a:	83 c9 02             	or     $0x2,%ecx
8010807d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010808d:	83 c9 10             	or     $0x10,%ecx
80108090:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801080a0:	83 e1 9f             	and    $0xffffff9f,%ecx
801080a3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801080a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ac:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801080b3:	83 c9 80             	or     $0xffffff80,%ecx
801080b6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801080bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bf:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801080c6:	83 e1 f0             	and    $0xfffffff0,%ecx
801080c9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801080cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d2:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801080d9:	83 e1 ef             	and    $0xffffffef,%ecx
801080dc:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801080e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e5:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801080ec:	83 e1 df             	and    $0xffffffdf,%ecx
801080ef:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801080f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f8:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801080ff:	83 c9 40             	or     $0x40,%ecx
80108102:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108112:	83 c9 80             	or     $0xffffff80,%ecx
80108115:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010811b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811e:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108127:	83 c0 70             	add    $0x70,%eax
8010812a:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108131:	00 
80108132:	89 04 24             	mov    %eax,(%esp)
80108135:	e8 37 fb ff ff       	call   80107c71 <lgdt>
  loadgs(SEG_KCPU << 3);
8010813a:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108141:	e8 6a fb ff ff       	call   80107cb0 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108149:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  thread = 0;
8010814f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108156:	00 00 00 00 
}
8010815a:	83 c4 24             	add    $0x24,%esp
8010815d:	5b                   	pop    %ebx
8010815e:	5d                   	pop    %ebp
8010815f:	c3                   	ret    

80108160 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108160:	55                   	push   %ebp
80108161:	89 e5                	mov    %esp,%ebp
80108163:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108166:	8b 45 0c             	mov    0xc(%ebp),%eax
80108169:	c1 e8 16             	shr    $0x16,%eax
8010816c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108173:	8b 45 08             	mov    0x8(%ebp),%eax
80108176:	01 d0                	add    %edx,%eax
80108178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010817b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010817e:	8b 00                	mov    (%eax),%eax
80108180:	83 e0 01             	and    $0x1,%eax
80108183:	85 c0                	test   %eax,%eax
80108185:	74 17                	je     8010819e <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108187:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818a:	8b 00                	mov    (%eax),%eax
8010818c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108191:	89 04 24             	mov    %eax,(%esp)
80108194:	e8 44 fb ff ff       	call   80107cdd <p2v>
80108199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010819c:	eb 4b                	jmp    801081e9 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010819e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801081a2:	74 0e                	je     801081b2 <walkpgdir+0x52>
801081a4:	e8 4b a9 ff ff       	call   80102af4 <kalloc>
801081a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081b0:	75 07                	jne    801081b9 <walkpgdir+0x59>
      return 0;
801081b2:	b8 00 00 00 00       	mov    $0x0,%eax
801081b7:	eb 47                	jmp    80108200 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801081b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081c0:	00 
801081c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081c8:	00 
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	89 04 24             	mov    %eax,(%esp)
801081cf:	e8 6e d4 ff ff       	call   80105642 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801081d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d7:	89 04 24             	mov    %eax,(%esp)
801081da:	e8 f1 fa ff ff       	call   80107cd0 <v2p>
801081df:	83 c8 07             	or     $0x7,%eax
801081e2:	89 c2                	mov    %eax,%edx
801081e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e7:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801081e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ec:	c1 e8 0c             	shr    $0xc,%eax
801081ef:	25 ff 03 00 00       	and    $0x3ff,%eax
801081f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fe:	01 d0                	add    %edx,%eax
}
80108200:	c9                   	leave  
80108201:	c3                   	ret    

80108202 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108202:	55                   	push   %ebp
80108203:	89 e5                	mov    %esp,%ebp
80108205:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010820b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108213:	8b 55 0c             	mov    0xc(%ebp),%edx
80108216:	8b 45 10             	mov    0x10(%ebp),%eax
80108219:	01 d0                	add    %edx,%eax
8010821b:	83 e8 01             	sub    $0x1,%eax
8010821e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108226:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010822d:	00 
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	89 44 24 04          	mov    %eax,0x4(%esp)
80108235:	8b 45 08             	mov    0x8(%ebp),%eax
80108238:	89 04 24             	mov    %eax,(%esp)
8010823b:	e8 20 ff ff ff       	call   80108160 <walkpgdir>
80108240:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108243:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108247:	75 07                	jne    80108250 <mappages+0x4e>
      return -1;
80108249:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010824e:	eb 48                	jmp    80108298 <mappages+0x96>
    if(*pte & PTE_P)
80108250:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108253:	8b 00                	mov    (%eax),%eax
80108255:	83 e0 01             	and    $0x1,%eax
80108258:	85 c0                	test   %eax,%eax
8010825a:	74 0c                	je     80108268 <mappages+0x66>
      panic("remap");
8010825c:	c7 04 24 cc 90 10 80 	movl   $0x801090cc,(%esp)
80108263:	e8 d2 82 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80108268:	8b 45 18             	mov    0x18(%ebp),%eax
8010826b:	0b 45 14             	or     0x14(%ebp),%eax
8010826e:	83 c8 01             	or     $0x1,%eax
80108271:	89 c2                	mov    %eax,%edx
80108273:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108276:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010827e:	75 08                	jne    80108288 <mappages+0x86>
      break;
80108280:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108281:	b8 00 00 00 00       	mov    $0x0,%eax
80108286:	eb 10                	jmp    80108298 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108288:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010828f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108296:	eb 8e                	jmp    80108226 <mappages+0x24>
  return 0;
}
80108298:	c9                   	leave  
80108299:	c3                   	ret    

8010829a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010829a:	55                   	push   %ebp
8010829b:	89 e5                	mov    %esp,%ebp
8010829d:	53                   	push   %ebx
8010829e:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801082a1:	e8 4e a8 ff ff       	call   80102af4 <kalloc>
801082a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082ad:	75 0a                	jne    801082b9 <setupkvm+0x1f>
    return 0;
801082af:	b8 00 00 00 00       	mov    $0x0,%eax
801082b4:	e9 98 00 00 00       	jmp    80108351 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801082b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082c0:	00 
801082c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082c8:	00 
801082c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082cc:	89 04 24             	mov    %eax,(%esp)
801082cf:	e8 6e d3 ff ff       	call   80105642 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801082d4:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801082db:	e8 fd f9 ff ff       	call   80107cdd <p2v>
801082e0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801082e5:	76 0c                	jbe    801082f3 <setupkvm+0x59>
    panic("PHYSTOP too high");
801082e7:	c7 04 24 d2 90 10 80 	movl   $0x801090d2,(%esp)
801082ee:	e8 47 82 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082f3:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801082fa:	eb 49                	jmp    80108345 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801082fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ff:	8b 48 0c             	mov    0xc(%eax),%ecx
80108302:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108305:	8b 50 04             	mov    0x4(%eax),%edx
80108308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830b:	8b 58 08             	mov    0x8(%eax),%ebx
8010830e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108311:	8b 40 04             	mov    0x4(%eax),%eax
80108314:	29 c3                	sub    %eax,%ebx
80108316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108319:	8b 00                	mov    (%eax),%eax
8010831b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010831f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108323:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108327:	89 44 24 04          	mov    %eax,0x4(%esp)
8010832b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010832e:	89 04 24             	mov    %eax,(%esp)
80108331:	e8 cc fe ff ff       	call   80108202 <mappages>
80108336:	85 c0                	test   %eax,%eax
80108338:	79 07                	jns    80108341 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010833a:	b8 00 00 00 00       	mov    $0x0,%eax
8010833f:	eb 10                	jmp    80108351 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108341:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108345:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010834c:	72 ae                	jb     801082fc <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010834e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108351:	83 c4 34             	add    $0x34,%esp
80108354:	5b                   	pop    %ebx
80108355:	5d                   	pop    %ebp
80108356:	c3                   	ret    

80108357 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108357:	55                   	push   %ebp
80108358:	89 e5                	mov    %esp,%ebp
8010835a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010835d:	e8 38 ff ff ff       	call   8010829a <setupkvm>
80108362:	a3 58 cf 11 80       	mov    %eax,0x8011cf58
  switchkvm();
80108367:	e8 02 00 00 00       	call   8010836e <switchkvm>
}
8010836c:	c9                   	leave  
8010836d:	c3                   	ret    

8010836e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010836e:	55                   	push   %ebp
8010836f:	89 e5                	mov    %esp,%ebp
80108371:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108374:	a1 58 cf 11 80       	mov    0x8011cf58,%eax
80108379:	89 04 24             	mov    %eax,(%esp)
8010837c:	e8 4f f9 ff ff       	call   80107cd0 <v2p>
80108381:	89 04 24             	mov    %eax,(%esp)
80108384:	e8 3c f9 ff ff       	call   80107cc5 <lcr3>
}
80108389:	c9                   	leave  
8010838a:	c3                   	ret    

8010838b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct thread *t)
{
8010838b:	55                   	push   %ebp
8010838c:	89 e5                	mov    %esp,%ebp
8010838e:	53                   	push   %ebx
8010838f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108392:	e8 ab d1 ff ff       	call   80105542 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108397:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010839d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083a4:	83 c2 08             	add    $0x8,%edx
801083a7:	89 d3                	mov    %edx,%ebx
801083a9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083b0:	83 c2 08             	add    $0x8,%edx
801083b3:	c1 ea 10             	shr    $0x10,%edx
801083b6:	89 d1                	mov    %edx,%ecx
801083b8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083bf:	83 c2 08             	add    $0x8,%edx
801083c2:	c1 ea 18             	shr    $0x18,%edx
801083c5:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801083cc:	67 00 
801083ce:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801083d5:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801083db:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801083e2:	83 e1 f0             	and    $0xfffffff0,%ecx
801083e5:	83 c9 09             	or     $0x9,%ecx
801083e8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801083ee:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801083f5:	83 c9 10             	or     $0x10,%ecx
801083f8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801083fe:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108405:	83 e1 9f             	and    $0xffffff9f,%ecx
80108408:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010840e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108415:	83 c9 80             	or     $0xffffff80,%ecx
80108418:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010841e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108425:	83 e1 f0             	and    $0xfffffff0,%ecx
80108428:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010842e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108435:	83 e1 ef             	and    $0xffffffef,%ecx
80108438:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010843e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108445:	83 e1 df             	and    $0xffffffdf,%ecx
80108448:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010844e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108455:	83 c9 40             	or     $0x40,%ecx
80108458:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010845e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108465:	83 e1 7f             	and    $0x7f,%ecx
80108468:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010846e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108474:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010847a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108481:	83 e2 ef             	and    $0xffffffef,%edx
80108484:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010848a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108490:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)thread->kstack + KSTACKSIZE;
80108496:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010849c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801084a3:	8b 12                	mov    (%edx),%edx
801084a5:	81 c2 00 10 00 00    	add    $0x1000,%edx
801084ab:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801084ae:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801084b5:	e8 e0 f7 ff ff       	call   80107c9a <ltr>
  if(t->proc->pgdir == 0)
801084ba:	8b 45 08             	mov    0x8(%ebp),%eax
801084bd:	8b 40 0c             	mov    0xc(%eax),%eax
801084c0:	8b 40 04             	mov    0x4(%eax),%eax
801084c3:	85 c0                	test   %eax,%eax
801084c5:	75 0c                	jne    801084d3 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801084c7:	c7 04 24 e3 90 10 80 	movl   $0x801090e3,(%esp)
801084ce:	e8 67 80 ff ff       	call   8010053a <panic>
  lcr3(v2p(t->proc->pgdir ));  // switch to new address space
801084d3:	8b 45 08             	mov    0x8(%ebp),%eax
801084d6:	8b 40 0c             	mov    0xc(%eax),%eax
801084d9:	8b 40 04             	mov    0x4(%eax),%eax
801084dc:	89 04 24             	mov    %eax,(%esp)
801084df:	e8 ec f7 ff ff       	call   80107cd0 <v2p>
801084e4:	89 04 24             	mov    %eax,(%esp)
801084e7:	e8 d9 f7 ff ff       	call   80107cc5 <lcr3>

  popcli();
801084ec:	e8 95 d0 ff ff       	call   80105586 <popcli>
}
801084f1:	83 c4 14             	add    $0x14,%esp
801084f4:	5b                   	pop    %ebx
801084f5:	5d                   	pop    %ebp
801084f6:	c3                   	ret    

801084f7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801084f7:	55                   	push   %ebp
801084f8:	89 e5                	mov    %esp,%ebp
801084fa:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801084fd:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108504:	76 0c                	jbe    80108512 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108506:	c7 04 24 f7 90 10 80 	movl   $0x801090f7,(%esp)
8010850d:	e8 28 80 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108512:	e8 dd a5 ff ff       	call   80102af4 <kalloc>
80108517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010851a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108521:	00 
80108522:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108529:	00 
8010852a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010852d:	89 04 24             	mov    %eax,(%esp)
80108530:	e8 0d d1 ff ff       	call   80105642 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108538:	89 04 24             	mov    %eax,(%esp)
8010853b:	e8 90 f7 ff ff       	call   80107cd0 <v2p>
80108540:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108547:	00 
80108548:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010854c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108553:	00 
80108554:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010855b:	00 
8010855c:	8b 45 08             	mov    0x8(%ebp),%eax
8010855f:	89 04 24             	mov    %eax,(%esp)
80108562:	e8 9b fc ff ff       	call   80108202 <mappages>
  memmove(mem, init, sz);
80108567:	8b 45 10             	mov    0x10(%ebp),%eax
8010856a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010856e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108571:	89 44 24 04          	mov    %eax,0x4(%esp)
80108575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108578:	89 04 24             	mov    %eax,(%esp)
8010857b:	e8 91 d1 ff ff       	call   80105711 <memmove>
}
80108580:	c9                   	leave  
80108581:	c3                   	ret    

80108582 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108582:	55                   	push   %ebp
80108583:	89 e5                	mov    %esp,%ebp
80108585:	53                   	push   %ebx
80108586:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108589:	8b 45 0c             	mov    0xc(%ebp),%eax
8010858c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108591:	85 c0                	test   %eax,%eax
80108593:	74 0c                	je     801085a1 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108595:	c7 04 24 14 91 10 80 	movl   $0x80109114,(%esp)
8010859c:	e8 99 7f ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801085a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085a8:	e9 a9 00 00 00       	jmp    80108656 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801085b3:	01 d0                	add    %edx,%eax
801085b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085bc:	00 
801085bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801085c1:	8b 45 08             	mov    0x8(%ebp),%eax
801085c4:	89 04 24             	mov    %eax,(%esp)
801085c7:	e8 94 fb ff ff       	call   80108160 <walkpgdir>
801085cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801085d3:	75 0c                	jne    801085e1 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801085d5:	c7 04 24 37 91 10 80 	movl   $0x80109137,(%esp)
801085dc:	e8 59 7f ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801085e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085e4:	8b 00                	mov    (%eax),%eax
801085e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801085ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f1:	8b 55 18             	mov    0x18(%ebp),%edx
801085f4:	29 c2                	sub    %eax,%edx
801085f6:	89 d0                	mov    %edx,%eax
801085f8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801085fd:	77 0f                	ja     8010860e <loaduvm+0x8c>
      n = sz - i;
801085ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108602:	8b 55 18             	mov    0x18(%ebp),%edx
80108605:	29 c2                	sub    %eax,%edx
80108607:	89 d0                	mov    %edx,%eax
80108609:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010860c:	eb 07                	jmp    80108615 <loaduvm+0x93>
    else
      n = PGSIZE;
8010860e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108618:	8b 55 14             	mov    0x14(%ebp),%edx
8010861b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010861e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108621:	89 04 24             	mov    %eax,(%esp)
80108624:	e8 b4 f6 ff ff       	call   80107cdd <p2v>
80108629:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010862c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108630:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108634:	89 44 24 04          	mov    %eax,0x4(%esp)
80108638:	8b 45 10             	mov    0x10(%ebp),%eax
8010863b:	89 04 24             	mov    %eax,(%esp)
8010863e:	e8 34 97 ff ff       	call   80101d77 <readi>
80108643:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108646:	74 07                	je     8010864f <loaduvm+0xcd>
      return -1;
80108648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010864d:	eb 18                	jmp    80108667 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010864f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108659:	3b 45 18             	cmp    0x18(%ebp),%eax
8010865c:	0f 82 4b ff ff ff    	jb     801085ad <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108662:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108667:	83 c4 24             	add    $0x24,%esp
8010866a:	5b                   	pop    %ebx
8010866b:	5d                   	pop    %ebp
8010866c:	c3                   	ret    

8010866d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010866d:	55                   	push   %ebp
8010866e:	89 e5                	mov    %esp,%ebp
80108670:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108673:	8b 45 10             	mov    0x10(%ebp),%eax
80108676:	85 c0                	test   %eax,%eax
80108678:	79 0a                	jns    80108684 <allocuvm+0x17>
    return 0;
8010867a:	b8 00 00 00 00       	mov    $0x0,%eax
8010867f:	e9 c1 00 00 00       	jmp    80108745 <allocuvm+0xd8>
  if(newsz < oldsz)
80108684:	8b 45 10             	mov    0x10(%ebp),%eax
80108687:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010868a:	73 08                	jae    80108694 <allocuvm+0x27>
    return oldsz;
8010868c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010868f:	e9 b1 00 00 00       	jmp    80108745 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108694:	8b 45 0c             	mov    0xc(%ebp),%eax
80108697:	05 ff 0f 00 00       	add    $0xfff,%eax
8010869c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801086a4:	e9 8d 00 00 00       	jmp    80108736 <allocuvm+0xc9>
    mem = kalloc();
801086a9:	e8 46 a4 ff ff       	call   80102af4 <kalloc>
801086ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801086b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086b5:	75 2c                	jne    801086e3 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801086b7:	c7 04 24 55 91 10 80 	movl   $0x80109155,(%esp)
801086be:	e8 dd 7c ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801086c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801086ca:	8b 45 10             	mov    0x10(%ebp),%eax
801086cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801086d1:	8b 45 08             	mov    0x8(%ebp),%eax
801086d4:	89 04 24             	mov    %eax,(%esp)
801086d7:	e8 6b 00 00 00       	call   80108747 <deallocuvm>
      return 0;
801086dc:	b8 00 00 00 00       	mov    $0x0,%eax
801086e1:	eb 62                	jmp    80108745 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801086e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086ea:	00 
801086eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801086f2:	00 
801086f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f6:	89 04 24             	mov    %eax,(%esp)
801086f9:	e8 44 cf ff ff       	call   80105642 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801086fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108701:	89 04 24             	mov    %eax,(%esp)
80108704:	e8 c7 f5 ff ff       	call   80107cd0 <v2p>
80108709:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010870c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108713:	00 
80108714:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108718:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010871f:	00 
80108720:	89 54 24 04          	mov    %edx,0x4(%esp)
80108724:	8b 45 08             	mov    0x8(%ebp),%eax
80108727:	89 04 24             	mov    %eax,(%esp)
8010872a:	e8 d3 fa ff ff       	call   80108202 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010872f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108739:	3b 45 10             	cmp    0x10(%ebp),%eax
8010873c:	0f 82 67 ff ff ff    	jb     801086a9 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108742:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108745:	c9                   	leave  
80108746:	c3                   	ret    

80108747 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108747:	55                   	push   %ebp
80108748:	89 e5                	mov    %esp,%ebp
8010874a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010874d:	8b 45 10             	mov    0x10(%ebp),%eax
80108750:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108753:	72 08                	jb     8010875d <deallocuvm+0x16>
    return oldsz;
80108755:	8b 45 0c             	mov    0xc(%ebp),%eax
80108758:	e9 a4 00 00 00       	jmp    80108801 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010875d:	8b 45 10             	mov    0x10(%ebp),%eax
80108760:	05 ff 0f 00 00       	add    $0xfff,%eax
80108765:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010876a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010876d:	e9 80 00 00 00       	jmp    801087f2 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108775:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010877c:	00 
8010877d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108781:	8b 45 08             	mov    0x8(%ebp),%eax
80108784:	89 04 24             	mov    %eax,(%esp)
80108787:	e8 d4 f9 ff ff       	call   80108160 <walkpgdir>
8010878c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010878f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108793:	75 09                	jne    8010879e <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108795:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010879c:	eb 4d                	jmp    801087eb <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010879e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087a1:	8b 00                	mov    (%eax),%eax
801087a3:	83 e0 01             	and    $0x1,%eax
801087a6:	85 c0                	test   %eax,%eax
801087a8:	74 41                	je     801087eb <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801087aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087ad:	8b 00                	mov    (%eax),%eax
801087af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801087b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087bb:	75 0c                	jne    801087c9 <deallocuvm+0x82>
        panic("kfree");
801087bd:	c7 04 24 6d 91 10 80 	movl   $0x8010916d,(%esp)
801087c4:	e8 71 7d ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
801087c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087cc:	89 04 24             	mov    %eax,(%esp)
801087cf:	e8 09 f5 ff ff       	call   80107cdd <p2v>
801087d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801087d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801087da:	89 04 24             	mov    %eax,(%esp)
801087dd:	e8 79 a2 ff ff       	call   80102a5b <kfree>
      *pte = 0;
801087e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801087eb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087f8:	0f 82 74 ff ff ff    	jb     80108772 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801087fe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108801:	c9                   	leave  
80108802:	c3                   	ret    

80108803 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108803:	55                   	push   %ebp
80108804:	89 e5                	mov    %esp,%ebp
80108806:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108809:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010880d:	75 0c                	jne    8010881b <freevm+0x18>
    panic("freevm: no pgdir");
8010880f:	c7 04 24 73 91 10 80 	movl   $0x80109173,(%esp)
80108816:	e8 1f 7d ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010881b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108822:	00 
80108823:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010882a:	80 
8010882b:	8b 45 08             	mov    0x8(%ebp),%eax
8010882e:	89 04 24             	mov    %eax,(%esp)
80108831:	e8 11 ff ff ff       	call   80108747 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010883d:	eb 48                	jmp    80108887 <freevm+0x84>
    if(pgdir[i] & PTE_P){
8010883f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108849:	8b 45 08             	mov    0x8(%ebp),%eax
8010884c:	01 d0                	add    %edx,%eax
8010884e:	8b 00                	mov    (%eax),%eax
80108850:	83 e0 01             	and    $0x1,%eax
80108853:	85 c0                	test   %eax,%eax
80108855:	74 2c                	je     80108883 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108861:	8b 45 08             	mov    0x8(%ebp),%eax
80108864:	01 d0                	add    %edx,%eax
80108866:	8b 00                	mov    (%eax),%eax
80108868:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010886d:	89 04 24             	mov    %eax,(%esp)
80108870:	e8 68 f4 ff ff       	call   80107cdd <p2v>
80108875:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010887b:	89 04 24             	mov    %eax,(%esp)
8010887e:	e8 d8 a1 ff ff       	call   80102a5b <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108883:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108887:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010888e:	76 af                	jbe    8010883f <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108890:	8b 45 08             	mov    0x8(%ebp),%eax
80108893:	89 04 24             	mov    %eax,(%esp)
80108896:	e8 c0 a1 ff ff       	call   80102a5b <kfree>
}
8010889b:	c9                   	leave  
8010889c:	c3                   	ret    

8010889d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010889d:	55                   	push   %ebp
8010889e:	89 e5                	mov    %esp,%ebp
801088a0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088aa:	00 
801088ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801088ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801088b2:	8b 45 08             	mov    0x8(%ebp),%eax
801088b5:	89 04 24             	mov    %eax,(%esp)
801088b8:	e8 a3 f8 ff ff       	call   80108160 <walkpgdir>
801088bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801088c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088c4:	75 0c                	jne    801088d2 <clearpteu+0x35>
    panic("clearpteu");
801088c6:	c7 04 24 84 91 10 80 	movl   $0x80109184,(%esp)
801088cd:	e8 68 7c ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801088d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d5:	8b 00                	mov    (%eax),%eax
801088d7:	83 e0 fb             	and    $0xfffffffb,%eax
801088da:	89 c2                	mov    %eax,%edx
801088dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088df:	89 10                	mov    %edx,(%eax)
}
801088e1:	c9                   	leave  
801088e2:	c3                   	ret    

801088e3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801088e3:	55                   	push   %ebp
801088e4:	89 e5                	mov    %esp,%ebp
801088e6:	53                   	push   %ebx
801088e7:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801088ea:	e8 ab f9 ff ff       	call   8010829a <setupkvm>
801088ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088f6:	75 0a                	jne    80108902 <copyuvm+0x1f>
    return 0;
801088f8:	b8 00 00 00 00       	mov    $0x0,%eax
801088fd:	e9 fd 00 00 00       	jmp    801089ff <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108909:	e9 d0 00 00 00       	jmp    801089de <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010890e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108911:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108918:	00 
80108919:	89 44 24 04          	mov    %eax,0x4(%esp)
8010891d:	8b 45 08             	mov    0x8(%ebp),%eax
80108920:	89 04 24             	mov    %eax,(%esp)
80108923:	e8 38 f8 ff ff       	call   80108160 <walkpgdir>
80108928:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010892b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010892f:	75 0c                	jne    8010893d <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108931:	c7 04 24 8e 91 10 80 	movl   $0x8010918e,(%esp)
80108938:	e8 fd 7b ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
8010893d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108940:	8b 00                	mov    (%eax),%eax
80108942:	83 e0 01             	and    $0x1,%eax
80108945:	85 c0                	test   %eax,%eax
80108947:	75 0c                	jne    80108955 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108949:	c7 04 24 a8 91 10 80 	movl   $0x801091a8,(%esp)
80108950:	e8 e5 7b ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108958:	8b 00                	mov    (%eax),%eax
8010895a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010895f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108962:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108965:	8b 00                	mov    (%eax),%eax
80108967:	25 ff 0f 00 00       	and    $0xfff,%eax
8010896c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010896f:	e8 80 a1 ff ff       	call   80102af4 <kalloc>
80108974:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108977:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010897b:	75 02                	jne    8010897f <copyuvm+0x9c>
      goto bad;
8010897d:	eb 70                	jmp    801089ef <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010897f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108982:	89 04 24             	mov    %eax,(%esp)
80108985:	e8 53 f3 ff ff       	call   80107cdd <p2v>
8010898a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108991:	00 
80108992:	89 44 24 04          	mov    %eax,0x4(%esp)
80108996:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108999:	89 04 24             	mov    %eax,(%esp)
8010899c:	e8 70 cd ff ff       	call   80105711 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801089a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801089a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089a7:	89 04 24             	mov    %eax,(%esp)
801089aa:	e8 21 f3 ff ff       	call   80107cd0 <v2p>
801089af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801089b2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801089b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801089ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801089c1:	00 
801089c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801089c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089c9:	89 04 24             	mov    %eax,(%esp)
801089cc:	e8 31 f8 ff ff       	call   80108202 <mappages>
801089d1:	85 c0                	test   %eax,%eax
801089d3:	79 02                	jns    801089d7 <copyuvm+0xf4>
      goto bad;
801089d5:	eb 18                	jmp    801089ef <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801089d7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089e4:	0f 82 24 ff ff ff    	jb     8010890e <copyuvm+0x2b>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }

  return d;
801089ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ed:	eb 10                	jmp    801089ff <copyuvm+0x11c>

bad:

  freevm(d);
801089ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f2:	89 04 24             	mov    %eax,(%esp)
801089f5:	e8 09 fe ff ff       	call   80108803 <freevm>
  return 0;
801089fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089ff:	83 c4 44             	add    $0x44,%esp
80108a02:	5b                   	pop    %ebx
80108a03:	5d                   	pop    %ebp
80108a04:	c3                   	ret    

80108a05 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a05:	55                   	push   %ebp
80108a06:	89 e5                	mov    %esp,%ebp
80108a08:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a12:	00 
80108a13:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80108a1d:	89 04 24             	mov    %eax,(%esp)
80108a20:	e8 3b f7 ff ff       	call   80108160 <walkpgdir>
80108a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2b:	8b 00                	mov    (%eax),%eax
80108a2d:	83 e0 01             	and    $0x1,%eax
80108a30:	85 c0                	test   %eax,%eax
80108a32:	75 07                	jne    80108a3b <uva2ka+0x36>
    return 0;
80108a34:	b8 00 00 00 00       	mov    $0x0,%eax
80108a39:	eb 25                	jmp    80108a60 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3e:	8b 00                	mov    (%eax),%eax
80108a40:	83 e0 04             	and    $0x4,%eax
80108a43:	85 c0                	test   %eax,%eax
80108a45:	75 07                	jne    80108a4e <uva2ka+0x49>
    return 0;
80108a47:	b8 00 00 00 00       	mov    $0x0,%eax
80108a4c:	eb 12                	jmp    80108a60 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a51:	8b 00                	mov    (%eax),%eax
80108a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a58:	89 04 24             	mov    %eax,(%esp)
80108a5b:	e8 7d f2 ff ff       	call   80107cdd <p2v>
}
80108a60:	c9                   	leave  
80108a61:	c3                   	ret    

80108a62 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a62:	55                   	push   %ebp
80108a63:	89 e5                	mov    %esp,%ebp
80108a65:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108a68:	8b 45 10             	mov    0x10(%ebp),%eax
80108a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108a6e:	e9 87 00 00 00       	jmp    80108afa <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108a73:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a81:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a85:	8b 45 08             	mov    0x8(%ebp),%eax
80108a88:	89 04 24             	mov    %eax,(%esp)
80108a8b:	e8 75 ff ff ff       	call   80108a05 <uva2ka>
80108a90:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108a93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a97:	75 07                	jne    80108aa0 <copyout+0x3e>
      return -1;
80108a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a9e:	eb 69                	jmp    80108b09 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aa3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108aa6:	29 c2                	sub    %eax,%edx
80108aa8:	89 d0                	mov    %edx,%eax
80108aaa:	05 00 10 00 00       	add    $0x1000,%eax
80108aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ab5:	3b 45 14             	cmp    0x14(%ebp),%eax
80108ab8:	76 06                	jbe    80108ac0 <copyout+0x5e>
      n = len;
80108aba:	8b 45 14             	mov    0x14(%ebp),%eax
80108abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ac6:	29 c2                	sub    %eax,%edx
80108ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108acb:	01 c2                	add    %eax,%edx
80108acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ad0:	89 44 24 08          	mov    %eax,0x8(%esp)
80108ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108adb:	89 14 24             	mov    %edx,(%esp)
80108ade:	e8 2e cc ff ff       	call   80105711 <memmove>
    len -= n;
80108ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ae6:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aec:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108af2:	05 00 10 00 00       	add    $0x1000,%eax
80108af7:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108afa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108afe:	0f 85 6f ff ff ff    	jne    80108a73 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b09:	c9                   	leave  
80108b0a:	c3                   	ret    
