
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
8010002d:	b8 3c 37 10 80       	mov    $0x8010373c,%eax
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
8010003a:	c7 44 24 04 5c 90 10 	movl   $0x8010905c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 2d 50 00 00       	call   8010507b <initlock>

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
801000bd:	e8 da 4f 00 00       	call   8010509c <acquire>

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
80100104:	e8 f5 4f 00 00       	call   801050fe <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 6a 4c 00 00       	call   80104d8e <sleep>
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
8010017c:	e8 7d 4f 00 00       	call   801050fe <release>
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
80100198:	c7 04 24 63 90 10 80 	movl   $0x80109063,(%esp)
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
801001d3:	e8 ee 25 00 00       	call   801027c6 <iderw>
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
801001ef:	c7 04 24 74 90 10 80 	movl   $0x80109074,(%esp)
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
80100210:	e8 b1 25 00 00       	call   801027c6 <iderw>
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
80100229:	c7 04 24 7b 90 10 80 	movl   $0x8010907b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 5b 4e 00 00       	call   8010509c <acquire>

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
8010029d:	e8 e4 4b 00 00       	call   80104e86 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 50 4e 00 00       	call   801050fe <release>
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
801003bb:	e8 dc 4c 00 00       	call   8010509c <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 82 90 10 80 	movl   $0x80109082,(%esp)
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
801004b0:	c7 45 ec 8b 90 10 80 	movl   $0x8010908b,-0x14(%ebp)
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
80100533:	e8 c6 4b 00 00       	call   801050fe <release>
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
8010055f:	c7 04 24 92 90 10 80 	movl   $0x80109092,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 a1 90 10 80 	movl   $0x801090a1,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 b9 4b 00 00       	call   8010514d <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 a3 90 10 80 	movl   $0x801090a3,(%esp)
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
801006b2:	e8 b9 54 00 00       	call   80105b70 <memmove>
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
801006e1:	e8 bb 53 00 00       	call   80105aa1 <memset>
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
80100776:	e8 1c 6f 00 00       	call   80107697 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 10 6f 00 00       	call   80107697 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 04 6f 00 00       	call   80107697 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 f7 6e 00 00       	call   80107697 <uartputc>
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
801007ba:	e8 dd 48 00 00       	call   8010509c <acquire>
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
801007ea:	e8 59 47 00 00       	call   80104f48 <procdump>
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
801008f3:	e8 8e 45 00 00       	call   80104e86 <wakeup>
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
80100914:	e8 e5 47 00 00       	call   801050fe <release>
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
80100927:	e8 9f 10 00 00       	call   801019cb <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100939:	e8 5e 47 00 00       	call   8010509c <acquire>
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
8010095c:	e8 9d 47 00 00       	call   801050fe <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 11 0f 00 00       	call   8010187d <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a5 00 00 00       	jmp    80100a1b <consoleread+0x100>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 a0 17 11 	movl   $0x801117a0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
80100985:	e8 04 44 00 00       	call   80104d8e <sleep>

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
80100a01:	e8 f8 46 00 00       	call   801050fe <release>
  ilock(ip);
80100a06:	8b 45 08             	mov    0x8(%ebp),%eax
80100a09:	89 04 24             	mov    %eax,(%esp)
80100a0c:	e8 6c 0e 00 00       	call   8010187d <ilock>

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
80100a29:	e8 9d 0f 00 00       	call   801019cb <iunlock>
  acquire(&cons.lock);
80100a2e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a35:	e8 62 46 00 00       	call   8010509c <acquire>
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
80100a6f:	e8 8a 46 00 00       	call   801050fe <release>
  ilock(ip);
80100a74:	8b 45 08             	mov    0x8(%ebp),%eax
80100a77:	89 04 24             	mov    %eax,(%esp)
80100a7a:	e8 fe 0d 00 00       	call   8010187d <ilock>

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
80100a8a:	c7 44 24 04 a7 90 10 	movl   $0x801090a7,0x4(%esp)
80100a91:	80 
80100a92:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a99:	e8 dd 45 00 00       	call   8010507b <initlock>
  initlock(&input.lock, "input");
80100a9e:	c7 44 24 04 af 90 10 	movl   $0x801090af,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100aad:	e8 c9 45 00 00       	call   8010507b <initlock>

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
80100ad7:	e8 fd 32 00 00       	call   80103dd9 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100adc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae3:	00 
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 92 1e 00 00       	call   80102982 <ioapicenable>
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
80100afb:	e8 35 29 00 00       	call   80103435 <begin_op>
  if((ip = namei(path)) == 0){
80100b00:	8b 45 08             	mov    0x8(%ebp),%eax
80100b03:	89 04 24             	mov    %eax,(%esp)
80100b06:	e8 20 19 00 00       	call   8010242b <namei>
80100b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b12:	75 0f                	jne    80100b23 <exec+0x31>
    end_op();
80100b14:	e8 a0 29 00 00       	call   801034b9 <end_op>
    return -1;
80100b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1e:	e9 07 04 00 00       	jmp    80100f2a <exec+0x438>
  }
  ilock(ip);
80100b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 4f 0d 00 00       	call   8010187d <ilock>
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
80100b55:	e8 30 12 00 00       	call   80101d8a <readi>
80100b5a:	83 f8 33             	cmp    $0x33,%eax
80100b5d:	77 05                	ja     80100b64 <exec+0x72>
    goto bad;
80100b5f:	e9 9a 03 00 00       	jmp    80100efe <exec+0x40c>
  if(elf.magic != ELF_MAGIC)
80100b64:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b6a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6f:	74 05                	je     80100b76 <exec+0x84>
    goto bad;
80100b71:	e9 88 03 00 00       	jmp    80100efe <exec+0x40c>

  if((pgdir = setupkvm()) == 0)
80100b76:	e8 6d 7c 00 00       	call   801087e8 <setupkvm>
80100b7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b82:	75 05                	jne    80100b89 <exec+0x97>
    goto bad;
80100b84:	e9 75 03 00 00       	jmp    80100efe <exec+0x40c>

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
80100bc4:	e8 c1 11 00 00       	call   80101d8a <readi>
80100bc9:	83 f8 20             	cmp    $0x20,%eax
80100bcc:	74 05                	je     80100bd3 <exec+0xe1>
      goto bad;
80100bce:	e9 2b 03 00 00       	jmp    80100efe <exec+0x40c>
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
80100bf3:	e9 06 03 00 00       	jmp    80100efe <exec+0x40c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf8:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfe:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c04:	01 d0                	add    %edx,%eax
80100c06:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c14:	89 04 24             	mov    %eax,(%esp)
80100c17:	e8 9f 7f 00 00       	call   80108bbb <allocuvm>
80100c1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c23:	75 05                	jne    80100c2a <exec+0x138>
      goto bad;
80100c25:	e9 d4 02 00 00       	jmp    80100efe <exec+0x40c>
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
80100c55:	e8 76 7e 00 00       	call   80108ad0 <loaduvm>
80100c5a:	85 c0                	test   %eax,%eax
80100c5c:	79 05                	jns    80100c63 <exec+0x171>
      goto bad;
80100c5e:	e9 9b 02 00 00       	jmp    80100efe <exec+0x40c>
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
80100c89:	e8 73 0e 00 00       	call   80101b01 <iunlockput>
  end_op();
80100c8e:	e8 26 28 00 00       	call   801034b9 <end_op>
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
80100cc3:	e8 f3 7e 00 00       	call   80108bbb <allocuvm>
80100cc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ccb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccf:	75 05                	jne    80100cd6 <exec+0x1e4>
    goto bad;
80100cd1:	e9 28 02 00 00       	jmp    80100efe <exec+0x40c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd9:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce5:	89 04 24             	mov    %eax,(%esp)
80100ce8:	e8 fe 80 00 00       	call   80108deb <clearpteu>
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
80100d05:	e9 f4 01 00 00       	jmp    80100efe <exec+0x40c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d17:	01 d0                	add    %edx,%eax
80100d19:	8b 00                	mov    (%eax),%eax
80100d1b:	89 04 24             	mov    %eax,(%esp)
80100d1e:	e8 e8 4f 00 00       	call   80105d0b <strlen>
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
80100d47:	e8 bf 4f 00 00       	call   80105d0b <strlen>
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
80100d77:	e8 34 82 00 00       	call   80108fb0 <copyout>
80100d7c:	85 c0                	test   %eax,%eax
80100d7e:	79 05                	jns    80100d85 <exec+0x293>
      goto bad;
80100d80:	e9 79 01 00 00       	jmp    80100efe <exec+0x40c>
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
80100e1e:	e8 8d 81 00 00       	call   80108fb0 <copyout>
80100e23:	85 c0                	test   %eax,%eax
80100e25:	79 05                	jns    80100e2c <exec+0x33a>
    goto bad;
80100e27:	e9 d2 00 00 00       	jmp    80100efe <exec+0x40c>

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
80100e79:	e8 43 4e 00 00       	call   80105cc1 <safestrcpy>

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
  thread->proc->numOfThreads=1;
80100ecb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed1:	8b 40 0c             	mov    0xc(%eax),%eax
80100ed4:	c7 80 30 02 00 00 01 	movl   $0x1,0x230(%eax)
80100edb:	00 00 00 
  switchuvm(thread);
80100ede:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee4:	89 04 24             	mov    %eax,(%esp)
80100ee7:	e8 ed 79 00 00       	call   801088d9 <switchuvm>

  freevm(oldpgdir);
80100eec:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eef:	89 04 24             	mov    %eax,(%esp)
80100ef2:	e8 5a 7e 00 00       	call   80108d51 <freevm>
  return 0;
80100ef7:	b8 00 00 00 00       	mov    $0x0,%eax
80100efc:	eb 2c                	jmp    80100f2a <exec+0x438>

 bad:
  if(pgdir)
80100efe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f02:	74 0b                	je     80100f0f <exec+0x41d>
    freevm(pgdir);
80100f04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f07:	89 04 24             	mov    %eax,(%esp)
80100f0a:	e8 42 7e 00 00       	call   80108d51 <freevm>
  if(ip){
80100f0f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f13:	74 10                	je     80100f25 <exec+0x433>
    iunlockput(ip);
80100f15:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f18:	89 04 24             	mov    %eax,(%esp)
80100f1b:	e8 e1 0b 00 00       	call   80101b01 <iunlockput>
    end_op();
80100f20:	e8 94 25 00 00       	call   801034b9 <end_op>
  }
  return -1;
80100f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2a:	c9                   	leave  
80100f2b:	c3                   	ret    

80100f2c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f2c:	55                   	push   %ebp
80100f2d:	89 e5                	mov    %esp,%ebp
80100f2f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f32:	c7 44 24 04 b5 90 10 	movl   $0x801090b5,0x4(%esp)
80100f39:	80 
80100f3a:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f41:	e8 35 41 00 00       	call   8010507b <initlock>
}
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    

80100f48 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f48:	55                   	push   %ebp
80100f49:	89 e5                	mov    %esp,%ebp
80100f4b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f4e:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f55:	e8 42 41 00 00       	call   8010509c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5a:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80100f61:	eb 29                	jmp    80100f8c <filealloc+0x44>
    if(f->ref == 0){
80100f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f66:	8b 40 04             	mov    0x4(%eax),%eax
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	75 1b                	jne    80100f88 <filealloc+0x40>
      f->ref = 1;
80100f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f70:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f77:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f7e:	e8 7b 41 00 00       	call   801050fe <release>
      return f;
80100f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f86:	eb 1e                	jmp    80100fa6 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f88:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f8c:	81 7d f4 f4 21 11 80 	cmpl   $0x801121f4,-0xc(%ebp)
80100f93:	72 ce                	jb     80100f63 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f95:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f9c:	e8 5d 41 00 00       	call   801050fe <release>
  return 0;
80100fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fa6:	c9                   	leave  
80100fa7:	c3                   	ret    

80100fa8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fa8:	55                   	push   %ebp
80100fa9:	89 e5                	mov    %esp,%ebp
80100fab:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fae:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fb5:	e8 e2 40 00 00       	call   8010509c <acquire>
  if(f->ref < 1)
80100fba:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbd:	8b 40 04             	mov    0x4(%eax),%eax
80100fc0:	85 c0                	test   %eax,%eax
80100fc2:	7f 0c                	jg     80100fd0 <filedup+0x28>
    panic("filedup");
80100fc4:	c7 04 24 bc 90 10 80 	movl   $0x801090bc,(%esp)
80100fcb:	e8 6a f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd3:	8b 40 04             	mov    0x4(%eax),%eax
80100fd6:	8d 50 01             	lea    0x1(%eax),%edx
80100fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fdf:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fe6:	e8 13 41 00 00       	call   801050fe <release>
  return f;
80100feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fee:	c9                   	leave  
80100fef:	c3                   	ret    

80100ff0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ff6:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100ffd:	e8 9a 40 00 00       	call   8010509c <acquire>
  if(f->ref < 1)
80101002:	8b 45 08             	mov    0x8(%ebp),%eax
80101005:	8b 40 04             	mov    0x4(%eax),%eax
80101008:	85 c0                	test   %eax,%eax
8010100a:	7f 0c                	jg     80101018 <fileclose+0x28>
    panic("fileclose");
8010100c:	c7 04 24 c4 90 10 80 	movl   $0x801090c4,(%esp)
80101013:	e8 22 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101018:	8b 45 08             	mov    0x8(%ebp),%eax
8010101b:	8b 40 04             	mov    0x4(%eax),%eax
8010101e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101021:	8b 45 08             	mov    0x8(%ebp),%eax
80101024:	89 50 04             	mov    %edx,0x4(%eax)
80101027:	8b 45 08             	mov    0x8(%ebp),%eax
8010102a:	8b 40 04             	mov    0x4(%eax),%eax
8010102d:	85 c0                	test   %eax,%eax
8010102f:	7e 11                	jle    80101042 <fileclose+0x52>
    release(&ftable.lock);
80101031:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101038:	e8 c1 40 00 00       	call   801050fe <release>
8010103d:	e9 82 00 00 00       	jmp    801010c4 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101042:	8b 45 08             	mov    0x8(%ebp),%eax
80101045:	8b 10                	mov    (%eax),%edx
80101047:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010104a:	8b 50 04             	mov    0x4(%eax),%edx
8010104d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101050:	8b 50 08             	mov    0x8(%eax),%edx
80101053:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101056:	8b 50 0c             	mov    0xc(%eax),%edx
80101059:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010105c:	8b 50 10             	mov    0x10(%eax),%edx
8010105f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101062:	8b 40 14             	mov    0x14(%eax),%eax
80101065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101068:	8b 45 08             	mov    0x8(%ebp),%eax
8010106b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101072:	8b 45 08             	mov    0x8(%ebp),%eax
80101075:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010107b:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101082:	e8 77 40 00 00       	call   801050fe <release>
  
  if(ff.type == FD_PIPE)
80101087:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	75 18                	jne    801010a7 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010108f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101093:	0f be d0             	movsbl %al,%edx
80101096:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101099:	89 54 24 04          	mov    %edx,0x4(%esp)
8010109d:	89 04 24             	mov    %eax,(%esp)
801010a0:	e8 e4 2f 00 00       	call   80104089 <pipeclose>
801010a5:	eb 1d                	jmp    801010c4 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010aa:	83 f8 02             	cmp    $0x2,%eax
801010ad:	75 15                	jne    801010c4 <fileclose+0xd4>
    begin_op();
801010af:	e8 81 23 00 00       	call   80103435 <begin_op>
    iput(ff.ip);
801010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010b7:	89 04 24             	mov    %eax,(%esp)
801010ba:	e8 71 09 00 00       	call   80101a30 <iput>
    end_op();
801010bf:	e8 f5 23 00 00       	call   801034b9 <end_op>
  }
}
801010c4:	c9                   	leave  
801010c5:	c3                   	ret    

801010c6 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c6:	55                   	push   %ebp
801010c7:	89 e5                	mov    %esp,%ebp
801010c9:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010cc:	8b 45 08             	mov    0x8(%ebp),%eax
801010cf:	8b 00                	mov    (%eax),%eax
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	75 38                	jne    8010110e <filestat+0x48>
    ilock(f->ip);
801010d6:	8b 45 08             	mov    0x8(%ebp),%eax
801010d9:	8b 40 10             	mov    0x10(%eax),%eax
801010dc:	89 04 24             	mov    %eax,(%esp)
801010df:	e8 99 07 00 00       	call   8010187d <ilock>
    stati(f->ip, st);
801010e4:	8b 45 08             	mov    0x8(%ebp),%eax
801010e7:	8b 40 10             	mov    0x10(%eax),%eax
801010ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801010ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f1:	89 04 24             	mov    %eax,(%esp)
801010f4:	e8 4c 0c 00 00       	call   80101d45 <stati>
    iunlock(f->ip);
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
801010fc:	8b 40 10             	mov    0x10(%eax),%eax
801010ff:	89 04 24             	mov    %eax,(%esp)
80101102:	e8 c4 08 00 00       	call   801019cb <iunlock>
    return 0;
80101107:	b8 00 00 00 00       	mov    $0x0,%eax
8010110c:	eb 05                	jmp    80101113 <filestat+0x4d>
  }
  return -1;
8010110e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101113:	c9                   	leave  
80101114:	c3                   	ret    

80101115 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101115:	55                   	push   %ebp
80101116:	89 e5                	mov    %esp,%ebp
80101118:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010111b:	8b 45 08             	mov    0x8(%ebp),%eax
8010111e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101122:	84 c0                	test   %al,%al
80101124:	75 0a                	jne    80101130 <fileread+0x1b>
    return -1;
80101126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112b:	e9 9f 00 00 00       	jmp    801011cf <fileread+0xba>
  if(f->type == FD_PIPE)
80101130:	8b 45 08             	mov    0x8(%ebp),%eax
80101133:	8b 00                	mov    (%eax),%eax
80101135:	83 f8 01             	cmp    $0x1,%eax
80101138:	75 1e                	jne    80101158 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010113a:	8b 45 08             	mov    0x8(%ebp),%eax
8010113d:	8b 40 0c             	mov    0xc(%eax),%eax
80101140:	8b 55 10             	mov    0x10(%ebp),%edx
80101143:	89 54 24 08          	mov    %edx,0x8(%esp)
80101147:	8b 55 0c             	mov    0xc(%ebp),%edx
8010114a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010114e:	89 04 24             	mov    %eax,(%esp)
80101151:	e8 b7 30 00 00       	call   8010420d <piperead>
80101156:	eb 77                	jmp    801011cf <fileread+0xba>
  if(f->type == FD_INODE){
80101158:	8b 45 08             	mov    0x8(%ebp),%eax
8010115b:	8b 00                	mov    (%eax),%eax
8010115d:	83 f8 02             	cmp    $0x2,%eax
80101160:	75 61                	jne    801011c3 <fileread+0xae>
    ilock(f->ip);
80101162:	8b 45 08             	mov    0x8(%ebp),%eax
80101165:	8b 40 10             	mov    0x10(%eax),%eax
80101168:	89 04 24             	mov    %eax,(%esp)
8010116b:	e8 0d 07 00 00       	call   8010187d <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101170:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	8b 50 14             	mov    0x14(%eax),%edx
80101179:	8b 45 08             	mov    0x8(%ebp),%eax
8010117c:	8b 40 10             	mov    0x10(%eax),%eax
8010117f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101183:	89 54 24 08          	mov    %edx,0x8(%esp)
80101187:	8b 55 0c             	mov    0xc(%ebp),%edx
8010118a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118e:	89 04 24             	mov    %eax,(%esp)
80101191:	e8 f4 0b 00 00       	call   80101d8a <readi>
80101196:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010119d:	7e 11                	jle    801011b0 <fileread+0x9b>
      f->off += r;
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 50 14             	mov    0x14(%eax),%edx
801011a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a8:	01 c2                	add    %eax,%edx
801011aa:	8b 45 08             	mov    0x8(%ebp),%eax
801011ad:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 40 10             	mov    0x10(%eax),%eax
801011b6:	89 04 24             	mov    %eax,(%esp)
801011b9:	e8 0d 08 00 00       	call   801019cb <iunlock>
    return r;
801011be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c1:	eb 0c                	jmp    801011cf <fileread+0xba>
  }
  panic("fileread");
801011c3:	c7 04 24 ce 90 10 80 	movl   $0x801090ce,(%esp)
801011ca:	e8 6b f3 ff ff       	call   8010053a <panic>
}
801011cf:	c9                   	leave  
801011d0:	c3                   	ret    

801011d1 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d1:	55                   	push   %ebp
801011d2:	89 e5                	mov    %esp,%ebp
801011d4:	53                   	push   %ebx
801011d5:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011df:	84 c0                	test   %al,%al
801011e1:	75 0a                	jne    801011ed <filewrite+0x1c>
    return -1;
801011e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011e8:	e9 20 01 00 00       	jmp    8010130d <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011ed:	8b 45 08             	mov    0x8(%ebp),%eax
801011f0:	8b 00                	mov    (%eax),%eax
801011f2:	83 f8 01             	cmp    $0x1,%eax
801011f5:	75 21                	jne    80101218 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011f7:	8b 45 08             	mov    0x8(%ebp),%eax
801011fa:	8b 40 0c             	mov    0xc(%eax),%eax
801011fd:	8b 55 10             	mov    0x10(%ebp),%edx
80101200:	89 54 24 08          	mov    %edx,0x8(%esp)
80101204:	8b 55 0c             	mov    0xc(%ebp),%edx
80101207:	89 54 24 04          	mov    %edx,0x4(%esp)
8010120b:	89 04 24             	mov    %eax,(%esp)
8010120e:	e8 08 2f 00 00       	call   8010411b <pipewrite>
80101213:	e9 f5 00 00 00       	jmp    8010130d <filewrite+0x13c>
  if(f->type == FD_INODE){
80101218:	8b 45 08             	mov    0x8(%ebp),%eax
8010121b:	8b 00                	mov    (%eax),%eax
8010121d:	83 f8 02             	cmp    $0x2,%eax
80101220:	0f 85 db 00 00 00    	jne    80101301 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101226:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010122d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101234:	e9 a8 00 00 00       	jmp    801012e1 <filewrite+0x110>
      int n1 = n - i;
80101239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010123c:	8b 55 10             	mov    0x10(%ebp),%edx
8010123f:	29 c2                	sub    %eax,%edx
80101241:	89 d0                	mov    %edx,%eax
80101243:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101246:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101249:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010124c:	7e 06                	jle    80101254 <filewrite+0x83>
        n1 = max;
8010124e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101251:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101254:	e8 dc 21 00 00       	call   80103435 <begin_op>
      ilock(f->ip);
80101259:	8b 45 08             	mov    0x8(%ebp),%eax
8010125c:	8b 40 10             	mov    0x10(%eax),%eax
8010125f:	89 04 24             	mov    %eax,(%esp)
80101262:	e8 16 06 00 00       	call   8010187d <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101267:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 50 14             	mov    0x14(%eax),%edx
80101270:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101273:	8b 45 0c             	mov    0xc(%ebp),%eax
80101276:	01 c3                	add    %eax,%ebx
80101278:	8b 45 08             	mov    0x8(%ebp),%eax
8010127b:	8b 40 10             	mov    0x10(%eax),%eax
8010127e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101282:	89 54 24 08          	mov    %edx,0x8(%esp)
80101286:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010128a:	89 04 24             	mov    %eax,(%esp)
8010128d:	e8 5c 0c 00 00       	call   80101eee <writei>
80101292:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101299:	7e 11                	jle    801012ac <filewrite+0xdb>
        f->off += r;
8010129b:	8b 45 08             	mov    0x8(%ebp),%eax
8010129e:	8b 50 14             	mov    0x14(%eax),%edx
801012a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a4:	01 c2                	add    %eax,%edx
801012a6:	8b 45 08             	mov    0x8(%ebp),%eax
801012a9:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012ac:	8b 45 08             	mov    0x8(%ebp),%eax
801012af:	8b 40 10             	mov    0x10(%eax),%eax
801012b2:	89 04 24             	mov    %eax,(%esp)
801012b5:	e8 11 07 00 00       	call   801019cb <iunlock>
      end_op();
801012ba:	e8 fa 21 00 00       	call   801034b9 <end_op>

      if(r < 0)
801012bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c3:	79 02                	jns    801012c7 <filewrite+0xf6>
        break;
801012c5:	eb 26                	jmp    801012ed <filewrite+0x11c>
      if(r != n1)
801012c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012cd:	74 0c                	je     801012db <filewrite+0x10a>
        panic("short filewrite");
801012cf:	c7 04 24 d7 90 10 80 	movl   $0x801090d7,(%esp)
801012d6:	e8 5f f2 ff ff       	call   8010053a <panic>
      i += r;
801012db:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012de:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e7:	0f 8c 4c ff ff ff    	jl     80101239 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f0:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f3:	75 05                	jne    801012fa <filewrite+0x129>
801012f5:	8b 45 10             	mov    0x10(%ebp),%eax
801012f8:	eb 05                	jmp    801012ff <filewrite+0x12e>
801012fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ff:	eb 0c                	jmp    8010130d <filewrite+0x13c>
  }
  panic("filewrite");
80101301:	c7 04 24 e7 90 10 80 	movl   $0x801090e7,(%esp)
80101308:	e8 2d f2 ff ff       	call   8010053a <panic>
}
8010130d:	83 c4 24             	add    $0x24,%esp
80101310:	5b                   	pop    %ebx
80101311:	5d                   	pop    %ebp
80101312:	c3                   	ret    

80101313 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101313:	55                   	push   %ebp
80101314:	89 e5                	mov    %esp,%ebp
80101316:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101319:	8b 45 08             	mov    0x8(%ebp),%eax
8010131c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101323:	00 
80101324:	89 04 24             	mov    %eax,(%esp)
80101327:	e8 7a ee ff ff       	call   801001a6 <bread>
8010132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101332:	83 c0 18             	add    $0x18,%eax
80101335:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010133c:	00 
8010133d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101341:	8b 45 0c             	mov    0xc(%ebp),%eax
80101344:	89 04 24             	mov    %eax,(%esp)
80101347:	e8 24 48 00 00       	call   80105b70 <memmove>
  brelse(bp);
8010134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134f:	89 04 24             	mov    %eax,(%esp)
80101352:	e8 c0 ee ff ff       	call   80100217 <brelse>
}
80101357:	c9                   	leave  
80101358:	c3                   	ret    

80101359 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101359:	55                   	push   %ebp
8010135a:	89 e5                	mov    %esp,%ebp
8010135c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010135f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101362:	8b 45 08             	mov    0x8(%ebp),%eax
80101365:	89 54 24 04          	mov    %edx,0x4(%esp)
80101369:	89 04 24             	mov    %eax,(%esp)
8010136c:	e8 35 ee ff ff       	call   801001a6 <bread>
80101371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101377:	83 c0 18             	add    $0x18,%eax
8010137a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101381:	00 
80101382:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101389:	00 
8010138a:	89 04 24             	mov    %eax,(%esp)
8010138d:	e8 0f 47 00 00       	call   80105aa1 <memset>
  log_write(bp);
80101392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101395:	89 04 24             	mov    %eax,(%esp)
80101398:	e8 a3 22 00 00       	call   80103640 <log_write>
  brelse(bp);
8010139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 6f ee ff ff       	call   80100217 <brelse>
}
801013a8:	c9                   	leave  
801013a9:	c3                   	ret    

801013aa <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013aa:	55                   	push   %ebp
801013ab:	89 e5                	mov    %esp,%ebp
801013ad:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013b7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ba:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801013c1:	89 04 24             	mov    %eax,(%esp)
801013c4:	e8 4a ff ff ff       	call   80101313 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013d0:	e9 07 01 00 00       	jmp    801014dc <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d8:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013de:	85 c0                	test   %eax,%eax
801013e0:	0f 48 c2             	cmovs  %edx,%eax
801013e3:	c1 f8 0c             	sar    $0xc,%eax
801013e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013e9:	c1 ea 03             	shr    $0x3,%edx
801013ec:	01 d0                	add    %edx,%eax
801013ee:	83 c0 03             	add    $0x3,%eax
801013f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f5:	8b 45 08             	mov    0x8(%ebp),%eax
801013f8:	89 04 24             	mov    %eax,(%esp)
801013fb:	e8 a6 ed ff ff       	call   801001a6 <bread>
80101400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010140a:	e9 9d 00 00 00       	jmp    801014ac <balloc+0x102>
      m = 1 << (bi % 8);
8010140f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101412:	99                   	cltd   
80101413:	c1 ea 1d             	shr    $0x1d,%edx
80101416:	01 d0                	add    %edx,%eax
80101418:	83 e0 07             	and    $0x7,%eax
8010141b:	29 d0                	sub    %edx,%eax
8010141d:	ba 01 00 00 00       	mov    $0x1,%edx
80101422:	89 c1                	mov    %eax,%ecx
80101424:	d3 e2                	shl    %cl,%edx
80101426:	89 d0                	mov    %edx,%eax
80101428:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142e:	8d 50 07             	lea    0x7(%eax),%edx
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 48 c2             	cmovs  %edx,%eax
80101436:	c1 f8 03             	sar    $0x3,%eax
80101439:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101441:	0f b6 c0             	movzbl %al,%eax
80101444:	23 45 e8             	and    -0x18(%ebp),%eax
80101447:	85 c0                	test   %eax,%eax
80101449:	75 5d                	jne    801014a8 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144e:	8d 50 07             	lea    0x7(%eax),%edx
80101451:	85 c0                	test   %eax,%eax
80101453:	0f 48 c2             	cmovs  %edx,%eax
80101456:	c1 f8 03             	sar    $0x3,%eax
80101459:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101461:	89 d1                	mov    %edx,%ecx
80101463:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101466:	09 ca                	or     %ecx,%edx
80101468:	89 d1                	mov    %edx,%ecx
8010146a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101474:	89 04 24             	mov    %eax,(%esp)
80101477:	e8 c4 21 00 00       	call   80103640 <log_write>
        brelse(bp);
8010147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010147f:	89 04 24             	mov    %eax,(%esp)
80101482:	e8 90 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148d:	01 c2                	add    %eax,%edx
8010148f:	8b 45 08             	mov    0x8(%ebp),%eax
80101492:	89 54 24 04          	mov    %edx,0x4(%esp)
80101496:	89 04 24             	mov    %eax,(%esp)
80101499:	e8 bb fe ff ff       	call   80101359 <bzero>
        return b + bi;
8010149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a4:	01 d0                	add    %edx,%eax
801014a6:	eb 4e                	jmp    801014f6 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ac:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b3:	7f 15                	jg     801014ca <balloc+0x120>
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bb:	01 d0                	add    %edx,%eax
801014bd:	89 c2                	mov    %eax,%edx
801014bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c2:	39 c2                	cmp    %eax,%edx
801014c4:	0f 82 45 ff ff ff    	jb     8010140f <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014cd:	89 04 24             	mov    %eax,(%esp)
801014d0:	e8 42 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014d5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014df:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e2:	39 c2                	cmp    %eax,%edx
801014e4:	0f 82 eb fe ff ff    	jb     801013d5 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ea:	c7 04 24 f1 90 10 80 	movl   $0x801090f1,(%esp)
801014f1:	e8 44 f0 ff ff       	call   8010053a <panic>
}
801014f6:	c9                   	leave  
801014f7:	c3                   	ret    

801014f8 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014f8:	55                   	push   %ebp
801014f9:	89 e5                	mov    %esp,%ebp
801014fb:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014fe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101501:	89 44 24 04          	mov    %eax,0x4(%esp)
80101505:	8b 45 08             	mov    0x8(%ebp),%eax
80101508:	89 04 24             	mov    %eax,(%esp)
8010150b:	e8 03 fe ff ff       	call   80101313 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	c1 e8 0c             	shr    $0xc,%eax
80101516:	89 c2                	mov    %eax,%edx
80101518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010151b:	c1 e8 03             	shr    $0x3,%eax
8010151e:	01 d0                	add    %edx,%eax
80101520:	8d 50 03             	lea    0x3(%eax),%edx
80101523:	8b 45 08             	mov    0x8(%ebp),%eax
80101526:	89 54 24 04          	mov    %edx,0x4(%esp)
8010152a:	89 04 24             	mov    %eax,(%esp)
8010152d:	e8 74 ec ff ff       	call   801001a6 <bread>
80101532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101535:	8b 45 0c             	mov    0xc(%ebp),%eax
80101538:	25 ff 0f 00 00       	and    $0xfff,%eax
8010153d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101540:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101543:	99                   	cltd   
80101544:	c1 ea 1d             	shr    $0x1d,%edx
80101547:	01 d0                	add    %edx,%eax
80101549:	83 e0 07             	and    $0x7,%eax
8010154c:	29 d0                	sub    %edx,%eax
8010154e:	ba 01 00 00 00       	mov    $0x1,%edx
80101553:	89 c1                	mov    %eax,%ecx
80101555:	d3 e2                	shl    %cl,%edx
80101557:	89 d0                	mov    %edx,%eax
80101559:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155f:	8d 50 07             	lea    0x7(%eax),%edx
80101562:	85 c0                	test   %eax,%eax
80101564:	0f 48 c2             	cmovs  %edx,%eax
80101567:	c1 f8 03             	sar    $0x3,%eax
8010156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101572:	0f b6 c0             	movzbl %al,%eax
80101575:	23 45 ec             	and    -0x14(%ebp),%eax
80101578:	85 c0                	test   %eax,%eax
8010157a:	75 0c                	jne    80101588 <bfree+0x90>
    panic("freeing free block");
8010157c:	c7 04 24 07 91 10 80 	movl   $0x80109107,(%esp)
80101583:	e8 b2 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158b:	8d 50 07             	lea    0x7(%eax),%edx
8010158e:	85 c0                	test   %eax,%eax
80101590:	0f 48 c2             	cmovs  %edx,%eax
80101593:	c1 f8 03             	sar    $0x3,%eax
80101596:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101599:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010159e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015a1:	f7 d1                	not    %ecx
801015a3:	21 ca                	and    %ecx,%edx
801015a5:	89 d1                	mov    %edx,%ecx
801015a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015aa:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015b1:	89 04 24             	mov    %eax,(%esp)
801015b4:	e8 87 20 00 00       	call   80103640 <log_write>
  brelse(bp);
801015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015bc:	89 04 24             	mov    %eax,(%esp)
801015bf:	e8 53 ec ff ff       	call   80100217 <brelse>
}
801015c4:	c9                   	leave  
801015c5:	c3                   	ret    

801015c6 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015c6:	55                   	push   %ebp
801015c7:	89 e5                	mov    %esp,%ebp
801015c9:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015cc:	c7 44 24 04 1a 91 10 	movl   $0x8010911a,0x4(%esp)
801015d3:	80 
801015d4:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015db:	e8 9b 3a 00 00       	call   8010507b <initlock>
}
801015e0:	c9                   	leave  
801015e1:	c3                   	ret    

801015e2 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015e2:	55                   	push   %ebp
801015e3:	89 e5                	mov    %esp,%ebp
801015e5:	83 ec 38             	sub    $0x38,%esp
801015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015eb:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015ef:	8b 45 08             	mov    0x8(%ebp),%eax
801015f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801015f9:	89 04 24             	mov    %eax,(%esp)
801015fc:	e8 12 fd ff ff       	call   80101313 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101601:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101608:	e9 98 00 00 00       	jmp    801016a5 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
8010160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101610:	c1 e8 03             	shr    $0x3,%eax
80101613:	83 c0 02             	add    $0x2,%eax
80101616:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161a:	8b 45 08             	mov    0x8(%ebp),%eax
8010161d:	89 04 24             	mov    %eax,(%esp)
80101620:	e8 81 eb ff ff       	call   801001a6 <bread>
80101625:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162b:	8d 50 18             	lea    0x18(%eax),%edx
8010162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101631:	83 e0 07             	and    $0x7,%eax
80101634:	c1 e0 06             	shl    $0x6,%eax
80101637:	01 d0                	add    %edx,%eax
80101639:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010163c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163f:	0f b7 00             	movzwl (%eax),%eax
80101642:	66 85 c0             	test   %ax,%ax
80101645:	75 4f                	jne    80101696 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101647:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010164e:	00 
8010164f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101656:	00 
80101657:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010165a:	89 04 24             	mov    %eax,(%esp)
8010165d:	e8 3f 44 00 00       	call   80105aa1 <memset>
      dip->type = type;
80101662:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101665:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101669:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166f:	89 04 24             	mov    %eax,(%esp)
80101672:	e8 c9 1f 00 00       	call   80103640 <log_write>
      brelse(bp);
80101677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010167a:	89 04 24             	mov    %eax,(%esp)
8010167d:	e8 95 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101685:	89 44 24 04          	mov    %eax,0x4(%esp)
80101689:	8b 45 08             	mov    0x8(%ebp),%eax
8010168c:	89 04 24             	mov    %eax,(%esp)
8010168f:	e8 e5 00 00 00       	call   80101779 <iget>
80101694:	eb 29                	jmp    801016bf <ialloc+0xdd>
    }
    brelse(bp);
80101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101699:	89 04 24             	mov    %eax,(%esp)
8010169c:	e8 76 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016ab:	39 c2                	cmp    %eax,%edx
801016ad:	0f 82 5a ff ff ff    	jb     8010160d <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016b3:	c7 04 24 21 91 10 80 	movl   $0x80109121,(%esp)
801016ba:	e8 7b ee ff ff       	call   8010053a <panic>
}
801016bf:	c9                   	leave  
801016c0:	c3                   	ret    

801016c1 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016c1:	55                   	push   %ebp
801016c2:	89 e5                	mov    %esp,%ebp
801016c4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016c7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ca:	8b 40 04             	mov    0x4(%eax),%eax
801016cd:	c1 e8 03             	shr    $0x3,%eax
801016d0:	8d 50 02             	lea    0x2(%eax),%edx
801016d3:	8b 45 08             	mov    0x8(%ebp),%eax
801016d6:	8b 00                	mov    (%eax),%eax
801016d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801016dc:	89 04 24             	mov    %eax,(%esp)
801016df:	e8 c2 ea ff ff       	call   801001a6 <bread>
801016e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ea:	8d 50 18             	lea    0x18(%eax),%edx
801016ed:	8b 45 08             	mov    0x8(%ebp),%eax
801016f0:	8b 40 04             	mov    0x4(%eax),%eax
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	01 d0                	add    %edx,%eax
801016fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101701:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101705:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101708:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170b:	8b 45 08             	mov    0x8(%ebp),%eax
8010170e:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101712:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101715:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101719:	8b 45 08             	mov    0x8(%ebp),%eax
8010171c:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101720:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101723:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101727:	8b 45 08             	mov    0x8(%ebp),%eax
8010172a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101731:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101735:	8b 45 08             	mov    0x8(%ebp),%eax
80101738:	8b 50 18             	mov    0x18(%eax),%edx
8010173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101741:	8b 45 08             	mov    0x8(%ebp),%eax
80101744:	8d 50 1c             	lea    0x1c(%eax),%edx
80101747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174a:	83 c0 0c             	add    $0xc,%eax
8010174d:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101754:	00 
80101755:	89 54 24 04          	mov    %edx,0x4(%esp)
80101759:	89 04 24             	mov    %eax,(%esp)
8010175c:	e8 0f 44 00 00       	call   80105b70 <memmove>
  log_write(bp);
80101761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101764:	89 04 24             	mov    %eax,(%esp)
80101767:	e8 d4 1e 00 00       	call   80103640 <log_write>
  brelse(bp);
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	89 04 24             	mov    %eax,(%esp)
80101772:	e8 a0 ea ff ff       	call   80100217 <brelse>
}
80101777:	c9                   	leave  
80101778:	c3                   	ret    

80101779 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101779:	55                   	push   %ebp
8010177a:	89 e5                	mov    %esp,%ebp
8010177c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010177f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101786:	e8 11 39 00 00       	call   8010509c <acquire>

  // Is the inode already cached?
  empty = 0;
8010178b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101792:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80101799:	eb 59                	jmp    801017f4 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179e:	8b 40 08             	mov    0x8(%eax),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 35                	jle    801017da <iget+0x61>
801017a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a8:	8b 00                	mov    (%eax),%eax
801017aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801017ad:	75 2b                	jne    801017da <iget+0x61>
801017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b2:	8b 40 04             	mov    0x4(%eax),%eax
801017b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017b8:	75 20                	jne    801017da <iget+0x61>
      ip->ref++;
801017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017bd:	8b 40 08             	mov    0x8(%eax),%eax
801017c0:	8d 50 01             	lea    0x1(%eax),%edx
801017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c6:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017c9:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017d0:	e8 29 39 00 00       	call   801050fe <release>
      return ip;
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	eb 6f                	jmp    80101849 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017de:	75 10                	jne    801017f0 <iget+0x77>
801017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e3:	8b 40 08             	mov    0x8(%eax),%eax
801017e6:	85 c0                	test   %eax,%eax
801017e8:	75 06                	jne    801017f0 <iget+0x77>
      empty = ip;
801017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017f0:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017f4:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
801017fb:	72 9e                	jb     8010179b <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101801:	75 0c                	jne    8010180f <iget+0x96>
    panic("iget: no inodes");
80101803:	c7 04 24 33 91 10 80 	movl   $0x80109133,(%esp)
8010180a:	e8 2b ed ff ff       	call   8010053a <panic>

  ip = empty;
8010180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101818:	8b 55 08             	mov    0x8(%ebp),%edx
8010181b:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101820:	8b 55 0c             	mov    0xc(%ebp),%edx
80101823:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101829:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101833:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010183a:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101841:	e8 b8 38 00 00       	call   801050fe <release>

  return ip;
80101846:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101849:	c9                   	leave  
8010184a:	c3                   	ret    

8010184b <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010184b:	55                   	push   %ebp
8010184c:	89 e5                	mov    %esp,%ebp
8010184e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101851:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101858:	e8 3f 38 00 00       	call   8010509c <acquire>
  ip->ref++;
8010185d:	8b 45 08             	mov    0x8(%ebp),%eax
80101860:	8b 40 08             	mov    0x8(%eax),%eax
80101863:	8d 50 01             	lea    0x1(%eax),%edx
80101866:	8b 45 08             	mov    0x8(%ebp),%eax
80101869:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010186c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101873:	e8 86 38 00 00       	call   801050fe <release>
  return ip;
80101878:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010187b:	c9                   	leave  
8010187c:	c3                   	ret    

8010187d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010187d:	55                   	push   %ebp
8010187e:	89 e5                	mov    %esp,%ebp
80101880:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101887:	74 0a                	je     80101893 <ilock+0x16>
80101889:	8b 45 08             	mov    0x8(%ebp),%eax
8010188c:	8b 40 08             	mov    0x8(%eax),%eax
8010188f:	85 c0                	test   %eax,%eax
80101891:	7f 0c                	jg     8010189f <ilock+0x22>
    panic("ilock");
80101893:	c7 04 24 43 91 10 80 	movl   $0x80109143,(%esp)
8010189a:	e8 9b ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010189f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018a6:	e8 f1 37 00 00       	call   8010509c <acquire>
  while(ip->flags & I_BUSY)
801018ab:	eb 13                	jmp    801018c0 <ilock+0x43>
    sleep(ip, &icache.lock);
801018ad:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018b4:	80 
801018b5:	8b 45 08             	mov    0x8(%ebp),%eax
801018b8:	89 04 24             	mov    %eax,(%esp)
801018bb:	e8 ce 34 00 00       	call   80104d8e <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018c0:	8b 45 08             	mov    0x8(%ebp),%eax
801018c3:	8b 40 0c             	mov    0xc(%eax),%eax
801018c6:	83 e0 01             	and    $0x1,%eax
801018c9:	85 c0                	test   %eax,%eax
801018cb:	75 e0                	jne    801018ad <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018cd:	8b 45 08             	mov    0x8(%ebp),%eax
801018d0:	8b 40 0c             	mov    0xc(%eax),%eax
801018d3:	83 c8 01             	or     $0x1,%eax
801018d6:	89 c2                	mov    %eax,%edx
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018de:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018e5:	e8 14 38 00 00       	call   801050fe <release>

  if(!(ip->flags & I_VALID)){
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	8b 40 0c             	mov    0xc(%eax),%eax
801018f0:	83 e0 02             	and    $0x2,%eax
801018f3:	85 c0                	test   %eax,%eax
801018f5:	0f 85 ce 00 00 00    	jne    801019c9 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018fb:	8b 45 08             	mov    0x8(%ebp),%eax
801018fe:	8b 40 04             	mov    0x4(%eax),%eax
80101901:	c1 e8 03             	shr    $0x3,%eax
80101904:	8d 50 02             	lea    0x2(%eax),%edx
80101907:	8b 45 08             	mov    0x8(%ebp),%eax
8010190a:	8b 00                	mov    (%eax),%eax
8010190c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101910:	89 04 24             	mov    %eax,(%esp)
80101913:	e8 8e e8 ff ff       	call   801001a6 <bread>
80101918:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	8d 50 18             	lea    0x18(%eax),%edx
80101921:	8b 45 08             	mov    0x8(%ebp),%eax
80101924:	8b 40 04             	mov    0x4(%eax),%eax
80101927:	83 e0 07             	and    $0x7,%eax
8010192a:	c1 e0 06             	shl    $0x6,%eax
8010192d:	01 d0                	add    %edx,%eax
8010192f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101935:	0f b7 10             	movzwl (%eax),%edx
80101938:	8b 45 08             	mov    0x8(%ebp),%eax
8010193b:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101942:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101950:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101954:	8b 45 08             	mov    0x8(%ebp),%eax
80101957:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010195b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195e:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101962:	8b 45 08             	mov    0x8(%ebp),%eax
80101965:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101969:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196c:	8b 50 08             	mov    0x8(%eax),%edx
8010196f:	8b 45 08             	mov    0x8(%ebp),%eax
80101972:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101975:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101978:	8d 50 0c             	lea    0xc(%eax),%edx
8010197b:	8b 45 08             	mov    0x8(%ebp),%eax
8010197e:	83 c0 1c             	add    $0x1c,%eax
80101981:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101988:	00 
80101989:	89 54 24 04          	mov    %edx,0x4(%esp)
8010198d:	89 04 24             	mov    %eax,(%esp)
80101990:	e8 db 41 00 00       	call   80105b70 <memmove>
    brelse(bp);
80101995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101998:	89 04 24             	mov    %eax,(%esp)
8010199b:	e8 77 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019a0:	8b 45 08             	mov    0x8(%ebp),%eax
801019a3:	8b 40 0c             	mov    0xc(%eax),%eax
801019a6:	83 c8 02             	or     $0x2,%eax
801019a9:	89 c2                	mov    %eax,%edx
801019ab:	8b 45 08             	mov    0x8(%ebp),%eax
801019ae:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019b1:	8b 45 08             	mov    0x8(%ebp),%eax
801019b4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019b8:	66 85 c0             	test   %ax,%ax
801019bb:	75 0c                	jne    801019c9 <ilock+0x14c>
      panic("ilock: no type");
801019bd:	c7 04 24 49 91 10 80 	movl   $0x80109149,(%esp)
801019c4:	e8 71 eb ff ff       	call   8010053a <panic>
  }
}
801019c9:	c9                   	leave  
801019ca:	c3                   	ret    

801019cb <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019cb:	55                   	push   %ebp
801019cc:	89 e5                	mov    %esp,%ebp
801019ce:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019d5:	74 17                	je     801019ee <iunlock+0x23>
801019d7:	8b 45 08             	mov    0x8(%ebp),%eax
801019da:	8b 40 0c             	mov    0xc(%eax),%eax
801019dd:	83 e0 01             	and    $0x1,%eax
801019e0:	85 c0                	test   %eax,%eax
801019e2:	74 0a                	je     801019ee <iunlock+0x23>
801019e4:	8b 45 08             	mov    0x8(%ebp),%eax
801019e7:	8b 40 08             	mov    0x8(%eax),%eax
801019ea:	85 c0                	test   %eax,%eax
801019ec:	7f 0c                	jg     801019fa <iunlock+0x2f>
    panic("iunlock");
801019ee:	c7 04 24 58 91 10 80 	movl   $0x80109158,(%esp)
801019f5:	e8 40 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019fa:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a01:	e8 96 36 00 00       	call   8010509c <acquire>
  ip->flags &= ~I_BUSY;
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0c:	83 e0 fe             	and    $0xfffffffe,%eax
80101a0f:	89 c2                	mov    %eax,%edx
80101a11:	8b 45 08             	mov    0x8(%ebp),%eax
80101a14:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a17:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1a:	89 04 24             	mov    %eax,(%esp)
80101a1d:	e8 64 34 00 00       	call   80104e86 <wakeup>
  release(&icache.lock);
80101a22:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a29:	e8 d0 36 00 00       	call   801050fe <release>
}
80101a2e:	c9                   	leave  
80101a2f:	c3                   	ret    

80101a30 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a36:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a3d:	e8 5a 36 00 00       	call   8010509c <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a42:	8b 45 08             	mov    0x8(%ebp),%eax
80101a45:	8b 40 08             	mov    0x8(%eax),%eax
80101a48:	83 f8 01             	cmp    $0x1,%eax
80101a4b:	0f 85 93 00 00 00    	jne    80101ae4 <iput+0xb4>
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 0c             	mov    0xc(%eax),%eax
80101a57:	83 e0 02             	and    $0x2,%eax
80101a5a:	85 c0                	test   %eax,%eax
80101a5c:	0f 84 82 00 00 00    	je     80101ae4 <iput+0xb4>
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a69:	66 85 c0             	test   %ax,%ax
80101a6c:	75 76                	jne    80101ae4 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	8b 40 0c             	mov    0xc(%eax),%eax
80101a74:	83 e0 01             	and    $0x1,%eax
80101a77:	85 c0                	test   %eax,%eax
80101a79:	74 0c                	je     80101a87 <iput+0x57>
      panic("iput busy");
80101a7b:	c7 04 24 60 91 10 80 	movl   $0x80109160,(%esp)
80101a82:	e8 b3 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8d:	83 c8 01             	or     $0x1,%eax
80101a90:	89 c2                	mov    %eax,%edx
80101a92:	8b 45 08             	mov    0x8(%ebp),%eax
80101a95:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a98:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a9f:	e8 5a 36 00 00       	call   801050fe <release>
    itrunc(ip);
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	89 04 24             	mov    %eax,(%esp)
80101aaa:	e8 7d 01 00 00       	call   80101c2c <itrunc>
    ip->type = 0;
80101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab2:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80101abb:	89 04 24             	mov    %eax,(%esp)
80101abe:	e8 fe fb ff ff       	call   801016c1 <iupdate>
    acquire(&icache.lock);
80101ac3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101aca:	e8 cd 35 00 00       	call   8010509c <acquire>
    ip->flags = 0;
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	89 04 24             	mov    %eax,(%esp)
80101adf:	e8 a2 33 00 00       	call   80104e86 <wakeup>
  }
  ip->ref--;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 08             	mov    0x8(%eax),%eax
80101aea:	8d 50 ff             	lea    -0x1(%eax),%edx
80101aed:	8b 45 08             	mov    0x8(%ebp),%eax
80101af0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101afa:	e8 ff 35 00 00       	call   801050fe <release>
}
80101aff:	c9                   	leave  
80101b00:	c3                   	ret    

80101b01 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b01:	55                   	push   %ebp
80101b02:	89 e5                	mov    %esp,%ebp
80101b04:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	89 04 24             	mov    %eax,(%esp)
80101b0d:	e8 b9 fe ff ff       	call   801019cb <iunlock>
  iput(ip);
80101b12:	8b 45 08             	mov    0x8(%ebp),%eax
80101b15:	89 04 24             	mov    %eax,(%esp)
80101b18:	e8 13 ff ff ff       	call   80101a30 <iput>
}
80101b1d:	c9                   	leave  
80101b1e:	c3                   	ret    

80101b1f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b1f:	55                   	push   %ebp
80101b20:	89 e5                	mov    %esp,%ebp
80101b22:	53                   	push   %ebx
80101b23:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b26:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b2a:	77 3e                	ja     80101b6a <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b32:	83 c2 04             	add    $0x4,%edx
80101b35:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b40:	75 20                	jne    80101b62 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 00                	mov    (%eax),%eax
80101b47:	89 04 24             	mov    %eax,(%esp)
80101b4a:	e8 5b f8 ff ff       	call   801013aa <balloc>
80101b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b52:	8b 45 08             	mov    0x8(%ebp),%eax
80101b55:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b58:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b5e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b65:	e9 bc 00 00 00       	jmp    80101c26 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b6a:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b6e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b72:	0f 87 a2 00 00 00    	ja     80101c1a <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b85:	75 19                	jne    80101ba0 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 00                	mov    (%eax),%eax
80101b8c:	89 04 24             	mov    %eax,(%esp)
80101b8f:	e8 16 f8 ff ff       	call   801013aa <balloc>
80101b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b9d:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba3:	8b 00                	mov    (%eax),%eax
80101ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ba8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bac:	89 04 24             	mov    %eax,(%esp)
80101baf:	e8 f2 e5 ff ff       	call   801001a6 <bread>
80101bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bba:	83 c0 18             	add    $0x18,%eax
80101bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bcd:	01 d0                	add    %edx,%eax
80101bcf:	8b 00                	mov    (%eax),%eax
80101bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bd8:	75 30                	jne    80101c0a <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bdd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101be7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bea:	8b 45 08             	mov    0x8(%ebp),%eax
80101bed:	8b 00                	mov    (%eax),%eax
80101bef:	89 04 24             	mov    %eax,(%esp)
80101bf2:	e8 b3 f7 ff ff       	call   801013aa <balloc>
80101bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bfd:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c02:	89 04 24             	mov    %eax,(%esp)
80101c05:	e8 36 1a 00 00       	call   80103640 <log_write>
    }
    brelse(bp);
80101c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c0d:	89 04 24             	mov    %eax,(%esp)
80101c10:	e8 02 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c18:	eb 0c                	jmp    80101c26 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c1a:	c7 04 24 6a 91 10 80 	movl   $0x8010916a,(%esp)
80101c21:	e8 14 e9 ff ff       	call   8010053a <panic>
}
80101c26:	83 c4 24             	add    $0x24,%esp
80101c29:	5b                   	pop    %ebx
80101c2a:	5d                   	pop    %ebp
80101c2b:	c3                   	ret    

80101c2c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c2c:	55                   	push   %ebp
80101c2d:	89 e5                	mov    %esp,%ebp
80101c2f:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c39:	eb 44                	jmp    80101c7f <itrunc+0x53>
    if(ip->addrs[i]){
80101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c41:	83 c2 04             	add    $0x4,%edx
80101c44:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c48:	85 c0                	test   %eax,%eax
80101c4a:	74 2f                	je     80101c7b <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c52:	83 c2 04             	add    $0x4,%edx
80101c55:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 00                	mov    (%eax),%eax
80101c5e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c62:	89 04 24             	mov    %eax,(%esp)
80101c65:	e8 8e f8 ff ff       	call   801014f8 <bfree>
      ip->addrs[i] = 0;
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c70:	83 c2 04             	add    $0x4,%edx
80101c73:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c7a:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c7f:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c83:	7e b6                	jle    80101c3b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c8b:	85 c0                	test   %eax,%eax
80101c8d:	0f 84 9b 00 00 00    	je     80101d2e <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c99:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9c:	8b 00                	mov    (%eax),%eax
80101c9e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ca2:	89 04 24             	mov    %eax,(%esp)
80101ca5:	e8 fc e4 ff ff       	call   801001a6 <bread>
80101caa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb0:	83 c0 18             	add    $0x18,%eax
80101cb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cb6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cbd:	eb 3b                	jmp    80101cfa <itrunc+0xce>
      if(a[j])
80101cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ccc:	01 d0                	add    %edx,%eax
80101cce:	8b 00                	mov    (%eax),%eax
80101cd0:	85 c0                	test   %eax,%eax
80101cd2:	74 22                	je     80101cf6 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ce1:	01 d0                	add    %edx,%eax
80101ce3:	8b 10                	mov    (%eax),%edx
80101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce8:	8b 00                	mov    (%eax),%eax
80101cea:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cee:	89 04 24             	mov    %eax,(%esp)
80101cf1:	e8 02 f8 ff ff       	call   801014f8 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cf6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfd:	83 f8 7f             	cmp    $0x7f,%eax
80101d00:	76 bd                	jbe    80101cbf <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d05:	89 04 24             	mov    %eax,(%esp)
80101d08:	e8 0a e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d10:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	8b 00                	mov    (%eax),%eax
80101d18:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d1c:	89 04 24             	mov    %eax,(%esp)
80101d1f:	e8 d4 f7 ff ff       	call   801014f8 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d31:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d38:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3b:	89 04 24             	mov    %eax,(%esp)
80101d3e:	e8 7e f9 ff ff       	call   801016c1 <iupdate>
}
80101d43:	c9                   	leave  
80101d44:	c3                   	ret    

80101d45 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d45:	55                   	push   %ebp
80101d46:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 00                	mov    (%eax),%eax
80101d4d:	89 c2                	mov    %eax,%edx
80101d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d52:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d55:	8b 45 08             	mov    0x8(%ebp),%eax
80101d58:	8b 50 04             	mov    0x4(%eax),%edx
80101d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d61:	8b 45 08             	mov    0x8(%ebp),%eax
80101d64:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d6b:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d71:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d75:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d78:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7f:	8b 50 18             	mov    0x18(%eax),%edx
80101d82:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d85:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d88:	5d                   	pop    %ebp
80101d89:	c3                   	ret    

80101d8a <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d8a:	55                   	push   %ebp
80101d8b:	89 e5                	mov    %esp,%ebp
80101d8d:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d90:	8b 45 08             	mov    0x8(%ebp),%eax
80101d93:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d97:	66 83 f8 03          	cmp    $0x3,%ax
80101d9b:	75 60                	jne    80101dfd <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101da0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da4:	66 85 c0             	test   %ax,%ax
80101da7:	78 20                	js     80101dc9 <readi+0x3f>
80101da9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dac:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db0:	66 83 f8 09          	cmp    $0x9,%ax
80101db4:	7f 13                	jg     80101dc9 <readi+0x3f>
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dbd:	98                   	cwtl   
80101dbe:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101dc5:	85 c0                	test   %eax,%eax
80101dc7:	75 0a                	jne    80101dd3 <readi+0x49>
      return -1;
80101dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dce:	e9 19 01 00 00       	jmp    80101eec <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dda:	98                   	cwtl   
80101ddb:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101de2:	8b 55 14             	mov    0x14(%ebp),%edx
80101de5:	89 54 24 08          	mov    %edx,0x8(%esp)
80101de9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dec:	89 54 24 04          	mov    %edx,0x4(%esp)
80101df0:	8b 55 08             	mov    0x8(%ebp),%edx
80101df3:	89 14 24             	mov    %edx,(%esp)
80101df6:	ff d0                	call   *%eax
80101df8:	e9 ef 00 00 00       	jmp    80101eec <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 40 18             	mov    0x18(%eax),%eax
80101e03:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e06:	72 0d                	jb     80101e15 <readi+0x8b>
80101e08:	8b 45 14             	mov    0x14(%ebp),%eax
80101e0b:	8b 55 10             	mov    0x10(%ebp),%edx
80101e0e:	01 d0                	add    %edx,%eax
80101e10:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e13:	73 0a                	jae    80101e1f <readi+0x95>
    return -1;
80101e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e1a:	e9 cd 00 00 00       	jmp    80101eec <readi+0x162>
  if(off + n > ip->size)
80101e1f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e22:	8b 55 10             	mov    0x10(%ebp),%edx
80101e25:	01 c2                	add    %eax,%edx
80101e27:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2a:	8b 40 18             	mov    0x18(%eax),%eax
80101e2d:	39 c2                	cmp    %eax,%edx
80101e2f:	76 0c                	jbe    80101e3d <readi+0xb3>
    n = ip->size - off;
80101e31:	8b 45 08             	mov    0x8(%ebp),%eax
80101e34:	8b 40 18             	mov    0x18(%eax),%eax
80101e37:	2b 45 10             	sub    0x10(%ebp),%eax
80101e3a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e44:	e9 94 00 00 00       	jmp    80101edd <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e49:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4c:	c1 e8 09             	shr    $0x9,%eax
80101e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e53:	8b 45 08             	mov    0x8(%ebp),%eax
80101e56:	89 04 24             	mov    %eax,(%esp)
80101e59:	e8 c1 fc ff ff       	call   80101b1f <bmap>
80101e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e61:	8b 12                	mov    (%edx),%edx
80101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e67:	89 14 24             	mov    %edx,(%esp)
80101e6a:	e8 37 e3 ff ff       	call   801001a6 <bread>
80101e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e72:	8b 45 10             	mov    0x10(%ebp),%eax
80101e75:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e7a:	89 c2                	mov    %eax,%edx
80101e7c:	b8 00 02 00 00       	mov    $0x200,%eax
80101e81:	29 d0                	sub    %edx,%eax
80101e83:	89 c2                	mov    %eax,%edx
80101e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e88:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e8b:	29 c1                	sub    %eax,%ecx
80101e8d:	89 c8                	mov    %ecx,%eax
80101e8f:	39 c2                	cmp    %eax,%edx
80101e91:	0f 46 c2             	cmovbe %edx,%eax
80101e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e97:	8b 45 10             	mov    0x10(%ebp),%eax
80101e9a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e9f:	8d 50 10             	lea    0x10(%eax),%edx
80101ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea5:	01 d0                	add    %edx,%eax
80101ea7:	8d 50 08             	lea    0x8(%eax),%edx
80101eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ead:	89 44 24 08          	mov    %eax,0x8(%esp)
80101eb1:	89 54 24 04          	mov    %edx,0x4(%esp)
80101eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb8:	89 04 24             	mov    %eax,(%esp)
80101ebb:	e8 b0 3c 00 00       	call   80105b70 <memmove>
    brelse(bp);
80101ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec3:	89 04 24             	mov    %eax,(%esp)
80101ec6:	e8 4c e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ece:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed4:	01 45 10             	add    %eax,0x10(%ebp)
80101ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eda:	01 45 0c             	add    %eax,0xc(%ebp)
80101edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ee0:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ee3:	0f 82 60 ff ff ff    	jb     80101e49 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ee9:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eec:	c9                   	leave  
80101eed:	c3                   	ret    

80101eee <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eee:	55                   	push   %ebp
80101eef:	89 e5                	mov    %esp,%ebp
80101ef1:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101efb:	66 83 f8 03          	cmp    $0x3,%ax
80101eff:	75 60                	jne    80101f61 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f01:	8b 45 08             	mov    0x8(%ebp),%eax
80101f04:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f08:	66 85 c0             	test   %ax,%ax
80101f0b:	78 20                	js     80101f2d <writei+0x3f>
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f14:	66 83 f8 09          	cmp    $0x9,%ax
80101f18:	7f 13                	jg     80101f2d <writei+0x3f>
80101f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f21:	98                   	cwtl   
80101f22:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	75 0a                	jne    80101f37 <writei+0x49>
      return -1;
80101f2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f32:	e9 44 01 00 00       	jmp    8010207b <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f37:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f3e:	98                   	cwtl   
80101f3f:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f46:	8b 55 14             	mov    0x14(%ebp),%edx
80101f49:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f50:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f54:	8b 55 08             	mov    0x8(%ebp),%edx
80101f57:	89 14 24             	mov    %edx,(%esp)
80101f5a:	ff d0                	call   *%eax
80101f5c:	e9 1a 01 00 00       	jmp    8010207b <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f61:	8b 45 08             	mov    0x8(%ebp),%eax
80101f64:	8b 40 18             	mov    0x18(%eax),%eax
80101f67:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f6a:	72 0d                	jb     80101f79 <writei+0x8b>
80101f6c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f72:	01 d0                	add    %edx,%eax
80101f74:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f77:	73 0a                	jae    80101f83 <writei+0x95>
    return -1;
80101f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f7e:	e9 f8 00 00 00       	jmp    8010207b <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f83:	8b 45 14             	mov    0x14(%ebp),%eax
80101f86:	8b 55 10             	mov    0x10(%ebp),%edx
80101f89:	01 d0                	add    %edx,%eax
80101f8b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f90:	76 0a                	jbe    80101f9c <writei+0xae>
    return -1;
80101f92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f97:	e9 df 00 00 00       	jmp    8010207b <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fa3:	e9 9f 00 00 00       	jmp    80102047 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa8:	8b 45 10             	mov    0x10(%ebp),%eax
80101fab:	c1 e8 09             	shr    $0x9,%eax
80101fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb5:	89 04 24             	mov    %eax,(%esp)
80101fb8:	e8 62 fb ff ff       	call   80101b1f <bmap>
80101fbd:	8b 55 08             	mov    0x8(%ebp),%edx
80101fc0:	8b 12                	mov    (%edx),%edx
80101fc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fc6:	89 14 24             	mov    %edx,(%esp)
80101fc9:	e8 d8 e1 ff ff       	call   801001a6 <bread>
80101fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd4:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fd9:	89 c2                	mov    %eax,%edx
80101fdb:	b8 00 02 00 00       	mov    $0x200,%eax
80101fe0:	29 d0                	sub    %edx,%eax
80101fe2:	89 c2                	mov    %eax,%edx
80101fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fe7:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fea:	29 c1                	sub    %eax,%ecx
80101fec:	89 c8                	mov    %ecx,%eax
80101fee:	39 c2                	cmp    %eax,%edx
80101ff0:	0f 46 c2             	cmovbe %edx,%eax
80101ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ffe:	8d 50 10             	lea    0x10(%eax),%edx
80102001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102004:	01 d0                	add    %edx,%eax
80102006:	8d 50 08             	lea    0x8(%eax),%edx
80102009:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102010:	8b 45 0c             	mov    0xc(%ebp),%eax
80102013:	89 44 24 04          	mov    %eax,0x4(%esp)
80102017:	89 14 24             	mov    %edx,(%esp)
8010201a:	e8 51 3b 00 00       	call   80105b70 <memmove>
    log_write(bp);
8010201f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102022:	89 04 24             	mov    %eax,(%esp)
80102025:	e8 16 16 00 00       	call   80103640 <log_write>
    brelse(bp);
8010202a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202d:	89 04 24             	mov    %eax,(%esp)
80102030:	e8 e2 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102035:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102038:	01 45 f4             	add    %eax,-0xc(%ebp)
8010203b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203e:	01 45 10             	add    %eax,0x10(%ebp)
80102041:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102044:	01 45 0c             	add    %eax,0xc(%ebp)
80102047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010204d:	0f 82 55 ff ff ff    	jb     80101fa8 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102053:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102057:	74 1f                	je     80102078 <writei+0x18a>
80102059:	8b 45 08             	mov    0x8(%ebp),%eax
8010205c:	8b 40 18             	mov    0x18(%eax),%eax
8010205f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102062:	73 14                	jae    80102078 <writei+0x18a>
    ip->size = off;
80102064:	8b 45 08             	mov    0x8(%ebp),%eax
80102067:	8b 55 10             	mov    0x10(%ebp),%edx
8010206a:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010206d:	8b 45 08             	mov    0x8(%ebp),%eax
80102070:	89 04 24             	mov    %eax,(%esp)
80102073:	e8 49 f6 ff ff       	call   801016c1 <iupdate>
  }
  return n;
80102078:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010207b:	c9                   	leave  
8010207c:	c3                   	ret    

8010207d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010207d:	55                   	push   %ebp
8010207e:	89 e5                	mov    %esp,%ebp
80102080:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102083:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010208a:	00 
8010208b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	89 04 24             	mov    %eax,(%esp)
80102098:	e8 76 3b 00 00       	call   80105c13 <strncmp>
}
8010209d:	c9                   	leave  
8010209e:	c3                   	ret    

8010209f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010209f:	55                   	push   %ebp
801020a0:	89 e5                	mov    %esp,%ebp
801020a2:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020a5:	8b 45 08             	mov    0x8(%ebp),%eax
801020a8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020ac:	66 83 f8 01          	cmp    $0x1,%ax
801020b0:	74 0c                	je     801020be <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020b2:	c7 04 24 7d 91 10 80 	movl   $0x8010917d,(%esp)
801020b9:	e8 7c e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020c5:	e9 88 00 00 00       	jmp    80102152 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ca:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020d1:	00 
801020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d5:	89 44 24 08          	mov    %eax,0x8(%esp)
801020d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801020e0:	8b 45 08             	mov    0x8(%ebp),%eax
801020e3:	89 04 24             	mov    %eax,(%esp)
801020e6:	e8 9f fc ff ff       	call   80101d8a <readi>
801020eb:	83 f8 10             	cmp    $0x10,%eax
801020ee:	74 0c                	je     801020fc <dirlookup+0x5d>
      panic("dirlink read");
801020f0:	c7 04 24 8f 91 10 80 	movl   $0x8010918f,(%esp)
801020f7:	e8 3e e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020fc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102100:	66 85 c0             	test   %ax,%ax
80102103:	75 02                	jne    80102107 <dirlookup+0x68>
      continue;
80102105:	eb 47                	jmp    8010214e <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102107:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010210a:	83 c0 02             	add    $0x2,%eax
8010210d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102111:	8b 45 0c             	mov    0xc(%ebp),%eax
80102114:	89 04 24             	mov    %eax,(%esp)
80102117:	e8 61 ff ff ff       	call   8010207d <namecmp>
8010211c:	85 c0                	test   %eax,%eax
8010211e:	75 2e                	jne    8010214e <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102124:	74 08                	je     8010212e <dirlookup+0x8f>
        *poff = off;
80102126:	8b 45 10             	mov    0x10(%ebp),%eax
80102129:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010212c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010212e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102132:	0f b7 c0             	movzwl %ax,%eax
80102135:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	8b 00                	mov    (%eax),%eax
8010213d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102140:	89 54 24 04          	mov    %edx,0x4(%esp)
80102144:	89 04 24             	mov    %eax,(%esp)
80102147:	e8 2d f6 ff ff       	call   80101779 <iget>
8010214c:	eb 18                	jmp    80102166 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010214e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102152:	8b 45 08             	mov    0x8(%ebp),%eax
80102155:	8b 40 18             	mov    0x18(%eax),%eax
80102158:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010215b:	0f 87 69 ff ff ff    	ja     801020ca <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102161:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102166:	c9                   	leave  
80102167:	c3                   	ret    

80102168 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102168:	55                   	push   %ebp
80102169:	89 e5                	mov    %esp,%ebp
8010216b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010216e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102175:	00 
80102176:	8b 45 0c             	mov    0xc(%ebp),%eax
80102179:	89 44 24 04          	mov    %eax,0x4(%esp)
8010217d:	8b 45 08             	mov    0x8(%ebp),%eax
80102180:	89 04 24             	mov    %eax,(%esp)
80102183:	e8 17 ff ff ff       	call   8010209f <dirlookup>
80102188:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010218b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010218f:	74 15                	je     801021a6 <dirlink+0x3e>
    iput(ip);
80102191:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102194:	89 04 24             	mov    %eax,(%esp)
80102197:	e8 94 f8 ff ff       	call   80101a30 <iput>
    return -1;
8010219c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a1:	e9 b7 00 00 00       	jmp    8010225d <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ad:	eb 46                	jmp    801021f5 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021b9:	00 
801021ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801021be:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c5:	8b 45 08             	mov    0x8(%ebp),%eax
801021c8:	89 04 24             	mov    %eax,(%esp)
801021cb:	e8 ba fb ff ff       	call   80101d8a <readi>
801021d0:	83 f8 10             	cmp    $0x10,%eax
801021d3:	74 0c                	je     801021e1 <dirlink+0x79>
      panic("dirlink read");
801021d5:	c7 04 24 8f 91 10 80 	movl   $0x8010918f,(%esp)
801021dc:	e8 59 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021e1:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e5:	66 85 c0             	test   %ax,%ax
801021e8:	75 02                	jne    801021ec <dirlink+0x84>
      break;
801021ea:	eb 16                	jmp    80102202 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ef:	83 c0 10             	add    $0x10,%eax
801021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021f8:	8b 45 08             	mov    0x8(%ebp),%eax
801021fb:	8b 40 18             	mov    0x18(%eax),%eax
801021fe:	39 c2                	cmp    %eax,%edx
80102200:	72 ad                	jb     801021af <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102202:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102209:	00 
8010220a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010220d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102211:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102214:	83 c0 02             	add    $0x2,%eax
80102217:	89 04 24             	mov    %eax,(%esp)
8010221a:	e8 4a 3a 00 00       	call   80105c69 <strncpy>
  de.inum = inum;
8010221f:	8b 45 10             	mov    0x10(%ebp),%eax
80102222:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102229:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102230:	00 
80102231:	89 44 24 08          	mov    %eax,0x8(%esp)
80102235:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102238:	89 44 24 04          	mov    %eax,0x4(%esp)
8010223c:	8b 45 08             	mov    0x8(%ebp),%eax
8010223f:	89 04 24             	mov    %eax,(%esp)
80102242:	e8 a7 fc ff ff       	call   80101eee <writei>
80102247:	83 f8 10             	cmp    $0x10,%eax
8010224a:	74 0c                	je     80102258 <dirlink+0xf0>
    panic("dirlink");
8010224c:	c7 04 24 9c 91 10 80 	movl   $0x8010919c,(%esp)
80102253:	e8 e2 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102258:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010225d:	c9                   	leave  
8010225e:	c3                   	ret    

8010225f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010225f:	55                   	push   %ebp
80102260:	89 e5                	mov    %esp,%ebp
80102262:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102265:	eb 04                	jmp    8010226b <skipelem+0xc>
    path++;
80102267:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010226b:	8b 45 08             	mov    0x8(%ebp),%eax
8010226e:	0f b6 00             	movzbl (%eax),%eax
80102271:	3c 2f                	cmp    $0x2f,%al
80102273:	74 f2                	je     80102267 <skipelem+0x8>
    path++;
  if(*path == 0)
80102275:	8b 45 08             	mov    0x8(%ebp),%eax
80102278:	0f b6 00             	movzbl (%eax),%eax
8010227b:	84 c0                	test   %al,%al
8010227d:	75 0a                	jne    80102289 <skipelem+0x2a>
    return 0;
8010227f:	b8 00 00 00 00       	mov    $0x0,%eax
80102284:	e9 86 00 00 00       	jmp    8010230f <skipelem+0xb0>
  s = path;
80102289:	8b 45 08             	mov    0x8(%ebp),%eax
8010228c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010228f:	eb 04                	jmp    80102295 <skipelem+0x36>
    path++;
80102291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102295:	8b 45 08             	mov    0x8(%ebp),%eax
80102298:	0f b6 00             	movzbl (%eax),%eax
8010229b:	3c 2f                	cmp    $0x2f,%al
8010229d:	74 0a                	je     801022a9 <skipelem+0x4a>
8010229f:	8b 45 08             	mov    0x8(%ebp),%eax
801022a2:	0f b6 00             	movzbl (%eax),%eax
801022a5:	84 c0                	test   %al,%al
801022a7:	75 e8                	jne    80102291 <skipelem+0x32>
    path++;
  len = path - s;
801022a9:	8b 55 08             	mov    0x8(%ebp),%edx
801022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022af:	29 c2                	sub    %eax,%edx
801022b1:	89 d0                	mov    %edx,%eax
801022b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022b6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022ba:	7e 1c                	jle    801022d8 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022bc:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022c3:	00 
801022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ce:	89 04 24             	mov    %eax,(%esp)
801022d1:	e8 9a 38 00 00       	call   80105b70 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022d6:	eb 2a                	jmp    80102302 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022db:	89 44 24 08          	mov    %eax,0x8(%esp)
801022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e9:	89 04 24             	mov    %eax,(%esp)
801022ec:	e8 7f 38 00 00       	call   80105b70 <memmove>
    name[len] = 0;
801022f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f7:	01 d0                	add    %edx,%eax
801022f9:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022fc:	eb 04                	jmp    80102302 <skipelem+0xa3>
    path++;
801022fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102302:	8b 45 08             	mov    0x8(%ebp),%eax
80102305:	0f b6 00             	movzbl (%eax),%eax
80102308:	3c 2f                	cmp    $0x2f,%al
8010230a:	74 f2                	je     801022fe <skipelem+0x9f>
    path++;
  return path;
8010230c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010230f:	c9                   	leave  
80102310:	c3                   	ret    

80102311 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102311:	55                   	push   %ebp
80102312:	89 e5                	mov    %esp,%ebp
80102314:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102317:	8b 45 08             	mov    0x8(%ebp),%eax
8010231a:	0f b6 00             	movzbl (%eax),%eax
8010231d:	3c 2f                	cmp    $0x2f,%al
8010231f:	75 1c                	jne    8010233d <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102328:	00 
80102329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102330:	e8 44 f4 ff ff       	call   80101779 <iget>
80102335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(thread->proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102338:	e9 b2 00 00 00       	jmp    801023ef <namex+0xde>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(thread->proc->cwd);
8010233d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102343:	8b 40 0c             	mov    0xc(%eax),%eax
80102346:	8b 40 5c             	mov    0x5c(%eax),%eax
80102349:	89 04 24             	mov    %eax,(%esp)
8010234c:	e8 fa f4 ff ff       	call   8010184b <idup>
80102351:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102354:	e9 96 00 00 00       	jmp    801023ef <namex+0xde>
    ilock(ip);
80102359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235c:	89 04 24             	mov    %eax,(%esp)
8010235f:	e8 19 f5 ff ff       	call   8010187d <ilock>
    if(ip->type != T_DIR){
80102364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102367:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010236b:	66 83 f8 01          	cmp    $0x1,%ax
8010236f:	74 15                	je     80102386 <namex+0x75>
      iunlockput(ip);
80102371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102374:	89 04 24             	mov    %eax,(%esp)
80102377:	e8 85 f7 ff ff       	call   80101b01 <iunlockput>
      return 0;
8010237c:	b8 00 00 00 00       	mov    $0x0,%eax
80102381:	e9 a3 00 00 00       	jmp    80102429 <namex+0x118>
    }
    if(nameiparent && *path == '\0'){
80102386:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010238a:	74 1d                	je     801023a9 <namex+0x98>
8010238c:	8b 45 08             	mov    0x8(%ebp),%eax
8010238f:	0f b6 00             	movzbl (%eax),%eax
80102392:	84 c0                	test   %al,%al
80102394:	75 13                	jne    801023a9 <namex+0x98>
      // Stop one level early.
      iunlock(ip);
80102396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102399:	89 04 24             	mov    %eax,(%esp)
8010239c:	e8 2a f6 ff ff       	call   801019cb <iunlock>
      return ip;
801023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a4:	e9 80 00 00 00       	jmp    80102429 <namex+0x118>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023b0:	00 
801023b1:	8b 45 10             	mov    0x10(%ebp),%eax
801023b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bb:	89 04 24             	mov    %eax,(%esp)
801023be:	e8 dc fc ff ff       	call   8010209f <dirlookup>
801023c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023ca:	75 12                	jne    801023de <namex+0xcd>
      iunlockput(ip);
801023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cf:	89 04 24             	mov    %eax,(%esp)
801023d2:	e8 2a f7 ff ff       	call   80101b01 <iunlockput>
      return 0;
801023d7:	b8 00 00 00 00       	mov    $0x0,%eax
801023dc:	eb 4b                	jmp    80102429 <namex+0x118>
    }
    iunlockput(ip);
801023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e1:	89 04 24             	mov    %eax,(%esp)
801023e4:	e8 18 f7 ff ff       	call   80101b01 <iunlockput>
    ip = next;
801023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(thread->proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ef:	8b 45 10             	mov    0x10(%ebp),%eax
801023f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801023f6:	8b 45 08             	mov    0x8(%ebp),%eax
801023f9:	89 04 24             	mov    %eax,(%esp)
801023fc:	e8 5e fe ff ff       	call   8010225f <skipelem>
80102401:	89 45 08             	mov    %eax,0x8(%ebp)
80102404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102408:	0f 85 4b ff ff ff    	jne    80102359 <namex+0x48>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010240e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102412:	74 12                	je     80102426 <namex+0x115>
    iput(ip);
80102414:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102417:	89 04 24             	mov    %eax,(%esp)
8010241a:	e8 11 f6 ff ff       	call   80101a30 <iput>
    return 0;
8010241f:	b8 00 00 00 00       	mov    $0x0,%eax
80102424:	eb 03                	jmp    80102429 <namex+0x118>
  }
  return ip;
80102426:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102429:	c9                   	leave  
8010242a:	c3                   	ret    

8010242b <namei>:

struct inode*
namei(char *path)
{
8010242b:	55                   	push   %ebp
8010242c:	89 e5                	mov    %esp,%ebp
8010242e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102431:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102434:	89 44 24 08          	mov    %eax,0x8(%esp)
80102438:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010243f:	00 
80102440:	8b 45 08             	mov    0x8(%ebp),%eax
80102443:	89 04 24             	mov    %eax,(%esp)
80102446:	e8 c6 fe ff ff       	call   80102311 <namex>
}
8010244b:	c9                   	leave  
8010244c:	c3                   	ret    

8010244d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010244d:	55                   	push   %ebp
8010244e:	89 e5                	mov    %esp,%ebp
80102450:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102453:	8b 45 0c             	mov    0xc(%ebp),%eax
80102456:	89 44 24 08          	mov    %eax,0x8(%esp)
8010245a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102461:	00 
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	89 04 24             	mov    %eax,(%esp)
80102468:	e8 a4 fe ff ff       	call   80102311 <namex>
}
8010246d:	c9                   	leave  
8010246e:	c3                   	ret    

8010246f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010246f:	55                   	push   %ebp
80102470:	89 e5                	mov    %esp,%ebp
80102472:	83 ec 14             	sub    $0x14,%esp
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
80102478:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010247c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102480:	89 c2                	mov    %eax,%edx
80102482:	ec                   	in     (%dx),%al
80102483:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102486:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010248a:	c9                   	leave  
8010248b:	c3                   	ret    

8010248c <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010248c:	55                   	push   %ebp
8010248d:	89 e5                	mov    %esp,%ebp
8010248f:	57                   	push   %edi
80102490:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102491:	8b 55 08             	mov    0x8(%ebp),%edx
80102494:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102497:	8b 45 10             	mov    0x10(%ebp),%eax
8010249a:	89 cb                	mov    %ecx,%ebx
8010249c:	89 df                	mov    %ebx,%edi
8010249e:	89 c1                	mov    %eax,%ecx
801024a0:	fc                   	cld    
801024a1:	f3 6d                	rep insl (%dx),%es:(%edi)
801024a3:	89 c8                	mov    %ecx,%eax
801024a5:	89 fb                	mov    %edi,%ebx
801024a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024aa:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024ad:	5b                   	pop    %ebx
801024ae:	5f                   	pop    %edi
801024af:	5d                   	pop    %ebp
801024b0:	c3                   	ret    

801024b1 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024b1:	55                   	push   %ebp
801024b2:	89 e5                	mov    %esp,%ebp
801024b4:	83 ec 08             	sub    $0x8,%esp
801024b7:	8b 55 08             	mov    0x8(%ebp),%edx
801024ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801024bd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024c1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024c4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024c8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024cc:	ee                   	out    %al,(%dx)
}
801024cd:	c9                   	leave  
801024ce:	c3                   	ret    

801024cf <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024cf:	55                   	push   %ebp
801024d0:	89 e5                	mov    %esp,%ebp
801024d2:	56                   	push   %esi
801024d3:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024d4:	8b 55 08             	mov    0x8(%ebp),%edx
801024d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024da:	8b 45 10             	mov    0x10(%ebp),%eax
801024dd:	89 cb                	mov    %ecx,%ebx
801024df:	89 de                	mov    %ebx,%esi
801024e1:	89 c1                	mov    %eax,%ecx
801024e3:	fc                   	cld    
801024e4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024e6:	89 c8                	mov    %ecx,%eax
801024e8:	89 f3                	mov    %esi,%ebx
801024ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024ed:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024f0:	5b                   	pop    %ebx
801024f1:	5e                   	pop    %esi
801024f2:	5d                   	pop    %ebp
801024f3:	c3                   	ret    

801024f4 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024fa:	90                   	nop
801024fb:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102502:	e8 68 ff ff ff       	call   8010246f <inb>
80102507:	0f b6 c0             	movzbl %al,%eax
8010250a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010250d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102510:	25 c0 00 00 00       	and    $0xc0,%eax
80102515:	83 f8 40             	cmp    $0x40,%eax
80102518:	75 e1                	jne    801024fb <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010251a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010251e:	74 11                	je     80102531 <idewait+0x3d>
80102520:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102523:	83 e0 21             	and    $0x21,%eax
80102526:	85 c0                	test   %eax,%eax
80102528:	74 07                	je     80102531 <idewait+0x3d>
    return -1;
8010252a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010252f:	eb 05                	jmp    80102536 <idewait+0x42>
  return 0;
80102531:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102536:	c9                   	leave  
80102537:	c3                   	ret    

80102538 <ideinit>:

void
ideinit(void)
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010253e:	c7 44 24 04 a4 91 10 	movl   $0x801091a4,0x4(%esp)
80102545:	80 
80102546:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010254d:	e8 29 2b 00 00       	call   8010507b <initlock>
  picenable(IRQ_IDE);
80102552:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102559:	e8 7b 18 00 00       	call   80103dd9 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010255e:	a1 60 39 11 80       	mov    0x80113960,%eax
80102563:	83 e8 01             	sub    $0x1,%eax
80102566:	89 44 24 04          	mov    %eax,0x4(%esp)
8010256a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102571:	e8 0c 04 00 00       	call   80102982 <ioapicenable>
  idewait(0);
80102576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010257d:	e8 72 ff ff ff       	call   801024f4 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102582:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102589:	00 
8010258a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102591:	e8 1b ff ff ff       	call   801024b1 <outb>
  for(i=0; i<1000; i++){
80102596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010259d:	eb 20                	jmp    801025bf <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010259f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025a6:	e8 c4 fe ff ff       	call   8010246f <inb>
801025ab:	84 c0                	test   %al,%al
801025ad:	74 0c                	je     801025bb <ideinit+0x83>
      havedisk1 = 1;
801025af:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025b6:	00 00 00 
      break;
801025b9:	eb 0d                	jmp    801025c8 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025bf:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025c6:	7e d7                	jle    8010259f <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025c8:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025cf:	00 
801025d0:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025d7:	e8 d5 fe ff ff       	call   801024b1 <outb>
}
801025dc:	c9                   	leave  
801025dd:	c3                   	ret    

801025de <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025de:	55                   	push   %ebp
801025df:	89 e5                	mov    %esp,%ebp
801025e1:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025e8:	75 0c                	jne    801025f6 <idestart+0x18>
    panic("idestart");
801025ea:	c7 04 24 a8 91 10 80 	movl   $0x801091a8,(%esp)
801025f1:	e8 44 df ff ff       	call   8010053a <panic>

  idewait(0);
801025f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025fd:	e8 f2 fe ff ff       	call   801024f4 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102602:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102609:	00 
8010260a:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102611:	e8 9b fe ff ff       	call   801024b1 <outb>
  outb(0x1f2, 1);  // number of sectors
80102616:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010261d:	00 
8010261e:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102625:	e8 87 fe ff ff       	call   801024b1 <outb>
  outb(0x1f3, b->sector & 0xff);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
8010262d:	8b 40 08             	mov    0x8(%eax),%eax
80102630:	0f b6 c0             	movzbl %al,%eax
80102633:	89 44 24 04          	mov    %eax,0x4(%esp)
80102637:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010263e:	e8 6e fe ff ff       	call   801024b1 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102643:	8b 45 08             	mov    0x8(%ebp),%eax
80102646:	8b 40 08             	mov    0x8(%eax),%eax
80102649:	c1 e8 08             	shr    $0x8,%eax
8010264c:	0f b6 c0             	movzbl %al,%eax
8010264f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102653:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010265a:	e8 52 fe ff ff       	call   801024b1 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010265f:	8b 45 08             	mov    0x8(%ebp),%eax
80102662:	8b 40 08             	mov    0x8(%eax),%eax
80102665:	c1 e8 10             	shr    $0x10,%eax
80102668:	0f b6 c0             	movzbl %al,%eax
8010266b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010266f:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102676:	e8 36 fe ff ff       	call   801024b1 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010267b:	8b 45 08             	mov    0x8(%ebp),%eax
8010267e:	8b 40 04             	mov    0x4(%eax),%eax
80102681:	83 e0 01             	and    $0x1,%eax
80102684:	c1 e0 04             	shl    $0x4,%eax
80102687:	89 c2                	mov    %eax,%edx
80102689:	8b 45 08             	mov    0x8(%ebp),%eax
8010268c:	8b 40 08             	mov    0x8(%eax),%eax
8010268f:	c1 e8 18             	shr    $0x18,%eax
80102692:	83 e0 0f             	and    $0xf,%eax
80102695:	09 d0                	or     %edx,%eax
80102697:	83 c8 e0             	or     $0xffffffe0,%eax
8010269a:	0f b6 c0             	movzbl %al,%eax
8010269d:	89 44 24 04          	mov    %eax,0x4(%esp)
801026a1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026a8:	e8 04 fe ff ff       	call   801024b1 <outb>
  if(b->flags & B_DIRTY){
801026ad:	8b 45 08             	mov    0x8(%ebp),%eax
801026b0:	8b 00                	mov    (%eax),%eax
801026b2:	83 e0 04             	and    $0x4,%eax
801026b5:	85 c0                	test   %eax,%eax
801026b7:	74 34                	je     801026ed <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026b9:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026c0:	00 
801026c1:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026c8:	e8 e4 fd ff ff       	call   801024b1 <outb>
    outsl(0x1f0, b->data, 512/4);
801026cd:	8b 45 08             	mov    0x8(%ebp),%eax
801026d0:	83 c0 18             	add    $0x18,%eax
801026d3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026da:	00 
801026db:	89 44 24 04          	mov    %eax,0x4(%esp)
801026df:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026e6:	e8 e4 fd ff ff       	call   801024cf <outsl>
801026eb:	eb 14                	jmp    80102701 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026ed:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026f4:	00 
801026f5:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026fc:	e8 b0 fd ff ff       	call   801024b1 <outb>
  }
}
80102701:	c9                   	leave  
80102702:	c3                   	ret    

80102703 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102703:	55                   	push   %ebp
80102704:	89 e5                	mov    %esp,%ebp
80102706:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102709:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102710:	e8 87 29 00 00       	call   8010509c <acquire>
  if((b = idequeue) == 0){
80102715:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010271d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102721:	75 11                	jne    80102734 <ideintr+0x31>
    release(&idelock);
80102723:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010272a:	e8 cf 29 00 00       	call   801050fe <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010272f:	e9 90 00 00 00       	jmp    801027c4 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102737:	8b 40 14             	mov    0x14(%eax),%eax
8010273a:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102742:	8b 00                	mov    (%eax),%eax
80102744:	83 e0 04             	and    $0x4,%eax
80102747:	85 c0                	test   %eax,%eax
80102749:	75 2e                	jne    80102779 <ideintr+0x76>
8010274b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102752:	e8 9d fd ff ff       	call   801024f4 <idewait>
80102757:	85 c0                	test   %eax,%eax
80102759:	78 1e                	js     80102779 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275e:	83 c0 18             	add    $0x18,%eax
80102761:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102768:	00 
80102769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010276d:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102774:	e8 13 fd ff ff       	call   8010248c <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277c:	8b 00                	mov    (%eax),%eax
8010277e:	83 c8 02             	or     $0x2,%eax
80102781:	89 c2                	mov    %eax,%edx
80102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102786:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010278b:	8b 00                	mov    (%eax),%eax
8010278d:	83 e0 fb             	and    $0xfffffffb,%eax
80102790:	89 c2                	mov    %eax,%edx
80102792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102795:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279a:	89 04 24             	mov    %eax,(%esp)
8010279d:	e8 e4 26 00 00       	call   80104e86 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027a2:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027a7:	85 c0                	test   %eax,%eax
801027a9:	74 0d                	je     801027b8 <ideintr+0xb5>
    idestart(idequeue);
801027ab:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027b0:	89 04 24             	mov    %eax,(%esp)
801027b3:	e8 26 fe ff ff       	call   801025de <idestart>

  release(&idelock);
801027b8:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027bf:	e8 3a 29 00 00       	call   801050fe <release>
}
801027c4:	c9                   	leave  
801027c5:	c3                   	ret    

801027c6 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027c6:	55                   	push   %ebp
801027c7:	89 e5                	mov    %esp,%ebp
801027c9:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027cc:	8b 45 08             	mov    0x8(%ebp),%eax
801027cf:	8b 00                	mov    (%eax),%eax
801027d1:	83 e0 01             	and    $0x1,%eax
801027d4:	85 c0                	test   %eax,%eax
801027d6:	75 0c                	jne    801027e4 <iderw+0x1e>
    panic("iderw: buf not busy");
801027d8:	c7 04 24 b1 91 10 80 	movl   $0x801091b1,(%esp)
801027df:	e8 56 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027e4:	8b 45 08             	mov    0x8(%ebp),%eax
801027e7:	8b 00                	mov    (%eax),%eax
801027e9:	83 e0 06             	and    $0x6,%eax
801027ec:	83 f8 02             	cmp    $0x2,%eax
801027ef:	75 0c                	jne    801027fd <iderw+0x37>
    panic("iderw: nothing to do");
801027f1:	c7 04 24 c5 91 10 80 	movl   $0x801091c5,(%esp)
801027f8:	e8 3d dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102800:	8b 40 04             	mov    0x4(%eax),%eax
80102803:	85 c0                	test   %eax,%eax
80102805:	74 15                	je     8010281c <iderw+0x56>
80102807:	a1 58 c6 10 80       	mov    0x8010c658,%eax
8010280c:	85 c0                	test   %eax,%eax
8010280e:	75 0c                	jne    8010281c <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102810:	c7 04 24 da 91 10 80 	movl   $0x801091da,(%esp)
80102817:	e8 1e dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010281c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102823:	e8 74 28 00 00       	call   8010509c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102828:	8b 45 08             	mov    0x8(%ebp),%eax
8010282b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102832:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102839:	eb 0b                	jmp    80102846 <iderw+0x80>
8010283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283e:	8b 00                	mov    (%eax),%eax
80102840:	83 c0 14             	add    $0x14,%eax
80102843:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102849:	8b 00                	mov    (%eax),%eax
8010284b:	85 c0                	test   %eax,%eax
8010284d:	75 ec                	jne    8010283b <iderw+0x75>
    ;
  *pp = b;
8010284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102852:	8b 55 08             	mov    0x8(%ebp),%edx
80102855:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102857:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010285c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010285f:	75 0d                	jne    8010286e <iderw+0xa8>
    idestart(b);
80102861:	8b 45 08             	mov    0x8(%ebp),%eax
80102864:	89 04 24             	mov    %eax,(%esp)
80102867:	e8 72 fd ff ff       	call   801025de <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010286c:	eb 15                	jmp    80102883 <iderw+0xbd>
8010286e:	eb 13                	jmp    80102883 <iderw+0xbd>
    sleep(b, &idelock);
80102870:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102877:	80 
80102878:	8b 45 08             	mov    0x8(%ebp),%eax
8010287b:	89 04 24             	mov    %eax,(%esp)
8010287e:	e8 0b 25 00 00       	call   80104d8e <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102883:	8b 45 08             	mov    0x8(%ebp),%eax
80102886:	8b 00                	mov    (%eax),%eax
80102888:	83 e0 06             	and    $0x6,%eax
8010288b:	83 f8 02             	cmp    $0x2,%eax
8010288e:	75 e0                	jne    80102870 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102890:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102897:	e8 62 28 00 00       	call   801050fe <release>
}
8010289c:	c9                   	leave  
8010289d:	c3                   	ret    

8010289e <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010289e:	55                   	push   %ebp
8010289f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a1:	a1 34 32 11 80       	mov    0x80113234,%eax
801028a6:	8b 55 08             	mov    0x8(%ebp),%edx
801028a9:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028ab:	a1 34 32 11 80       	mov    0x80113234,%eax
801028b0:	8b 40 10             	mov    0x10(%eax),%eax
}
801028b3:	5d                   	pop    %ebp
801028b4:	c3                   	ret    

801028b5 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028b5:	55                   	push   %ebp
801028b6:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028b8:	a1 34 32 11 80       	mov    0x80113234,%eax
801028bd:	8b 55 08             	mov    0x8(%ebp),%edx
801028c0:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028c2:	a1 34 32 11 80       	mov    0x80113234,%eax
801028c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801028ca:	89 50 10             	mov    %edx,0x10(%eax)
}
801028cd:	5d                   	pop    %ebp
801028ce:	c3                   	ret    

801028cf <ioapicinit>:

void
ioapicinit(void)
{
801028cf:	55                   	push   %ebp
801028d0:	89 e5                	mov    %esp,%ebp
801028d2:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028d5:	a1 64 33 11 80       	mov    0x80113364,%eax
801028da:	85 c0                	test   %eax,%eax
801028dc:	75 05                	jne    801028e3 <ioapicinit+0x14>
    return;
801028de:	e9 9d 00 00 00       	jmp    80102980 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028e3:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
801028ea:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028f4:	e8 a5 ff ff ff       	call   8010289e <ioapicread>
801028f9:	c1 e8 10             	shr    $0x10,%eax
801028fc:	25 ff 00 00 00       	and    $0xff,%eax
80102901:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102904:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010290b:	e8 8e ff ff ff       	call   8010289e <ioapicread>
80102910:	c1 e8 18             	shr    $0x18,%eax
80102913:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102916:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
8010291d:	0f b6 c0             	movzbl %al,%eax
80102920:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102923:	74 0c                	je     80102931 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102925:	c7 04 24 f8 91 10 80 	movl   $0x801091f8,(%esp)
8010292c:	e8 6f da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102931:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102938:	eb 3e                	jmp    80102978 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293d:	83 c0 20             	add    $0x20,%eax
80102940:	0d 00 00 01 00       	or     $0x10000,%eax
80102945:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102948:	83 c2 08             	add    $0x8,%edx
8010294b:	01 d2                	add    %edx,%edx
8010294d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102951:	89 14 24             	mov    %edx,(%esp)
80102954:	e8 5c ff ff ff       	call   801028b5 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295c:	83 c0 08             	add    $0x8,%eax
8010295f:	01 c0                	add    %eax,%eax
80102961:	83 c0 01             	add    $0x1,%eax
80102964:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010296b:	00 
8010296c:	89 04 24             	mov    %eax,(%esp)
8010296f:	e8 41 ff ff ff       	call   801028b5 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102974:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010297e:	7e ba                	jle    8010293a <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102980:	c9                   	leave  
80102981:	c3                   	ret    

80102982 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102982:	55                   	push   %ebp
80102983:	89 e5                	mov    %esp,%ebp
80102985:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102988:	a1 64 33 11 80       	mov    0x80113364,%eax
8010298d:	85 c0                	test   %eax,%eax
8010298f:	75 02                	jne    80102993 <ioapicenable+0x11>
    return;
80102991:	eb 37                	jmp    801029ca <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102993:	8b 45 08             	mov    0x8(%ebp),%eax
80102996:	83 c0 20             	add    $0x20,%eax
80102999:	8b 55 08             	mov    0x8(%ebp),%edx
8010299c:	83 c2 08             	add    $0x8,%edx
8010299f:	01 d2                	add    %edx,%edx
801029a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a5:	89 14 24             	mov    %edx,(%esp)
801029a8:	e8 08 ff ff ff       	call   801028b5 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801029b0:	c1 e0 18             	shl    $0x18,%eax
801029b3:	8b 55 08             	mov    0x8(%ebp),%edx
801029b6:	83 c2 08             	add    $0x8,%edx
801029b9:	01 d2                	add    %edx,%edx
801029bb:	83 c2 01             	add    $0x1,%edx
801029be:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c2:	89 14 24             	mov    %edx,(%esp)
801029c5:	e8 eb fe ff ff       	call   801028b5 <ioapicwrite>
}
801029ca:	c9                   	leave  
801029cb:	c3                   	ret    

801029cc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029cc:	55                   	push   %ebp
801029cd:	89 e5                	mov    %esp,%ebp
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	05 00 00 00 80       	add    $0x80000000,%eax
801029d7:	5d                   	pop    %ebp
801029d8:	c3                   	ret    

801029d9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029d9:	55                   	push   %ebp
801029da:	89 e5                	mov    %esp,%ebp
801029dc:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029df:	c7 44 24 04 2a 92 10 	movl   $0x8010922a,0x4(%esp)
801029e6:	80 
801029e7:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801029ee:	e8 88 26 00 00       	call   8010507b <initlock>
  kmem.use_lock = 0;
801029f3:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
801029fa:	00 00 00 
  freerange(vstart, vend);
801029fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a04:	8b 45 08             	mov    0x8(%ebp),%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 26 00 00 00       	call   80102a35 <freerange>
}
80102a0f:	c9                   	leave  
80102a10:	c3                   	ret    

80102a11 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a11:	55                   	push   %ebp
80102a12:	89 e5                	mov    %esp,%ebp
80102a14:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a17:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a21:	89 04 24             	mov    %eax,(%esp)
80102a24:	e8 0c 00 00 00       	call   80102a35 <freerange>
  kmem.use_lock = 1;
80102a29:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102a30:	00 00 00 
}
80102a33:	c9                   	leave  
80102a34:	c3                   	ret    

80102a35 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
80102a38:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3e:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a4b:	eb 12                	jmp    80102a5f <freerange+0x2a>
    kfree(p);
80102a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a50:	89 04 24             	mov    %eax,(%esp)
80102a53:	e8 16 00 00 00       	call   80102a6e <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a62:	05 00 10 00 00       	add    $0x1000,%eax
80102a67:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a6a:	76 e1                	jbe    80102a4d <freerange+0x18>
    kfree(p);
}
80102a6c:	c9                   	leave  
80102a6d:	c3                   	ret    

80102a6e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a6e:	55                   	push   %ebp
80102a6f:	89 e5                	mov    %esp,%ebp
80102a71:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a74:	8b 45 08             	mov    0x8(%ebp),%eax
80102a77:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a7c:	85 c0                	test   %eax,%eax
80102a7e:	75 1b                	jne    80102a9b <kfree+0x2d>
80102a80:	81 7d 08 5c f2 11 80 	cmpl   $0x8011f25c,0x8(%ebp)
80102a87:	72 12                	jb     80102a9b <kfree+0x2d>
80102a89:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8c:	89 04 24             	mov    %eax,(%esp)
80102a8f:	e8 38 ff ff ff       	call   801029cc <v2p>
80102a94:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a99:	76 0c                	jbe    80102aa7 <kfree+0x39>
    panic("kfree");
80102a9b:	c7 04 24 2f 92 10 80 	movl   $0x8010922f,(%esp)
80102aa2:	e8 93 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102aa7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aae:	00 
80102aaf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ab6:	00 
80102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aba:	89 04 24             	mov    %eax,(%esp)
80102abd:	e8 df 2f 00 00       	call   80105aa1 <memset>

  if(kmem.use_lock)
80102ac2:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	74 0c                	je     80102ad7 <kfree+0x69>
    acquire(&kmem.lock);
80102acb:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102ad2:	e8 c5 25 00 00       	call   8010509c <acquire>
  r = (struct run*)v;
80102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80102ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102add:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae6:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aeb:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102af0:	a1 74 32 11 80       	mov    0x80113274,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	74 0c                	je     80102b05 <kfree+0x97>
    release(&kmem.lock);
80102af9:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b00:	e8 f9 25 00 00       	call   801050fe <release>
}
80102b05:	c9                   	leave  
80102b06:	c3                   	ret    

80102b07 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b07:	55                   	push   %ebp
80102b08:	89 e5                	mov    %esp,%ebp
80102b0a:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b0d:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b12:	85 c0                	test   %eax,%eax
80102b14:	74 0c                	je     80102b22 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b16:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b1d:	e8 7a 25 00 00       	call   8010509c <acquire>
  r = kmem.freelist;
80102b22:	a1 78 32 11 80       	mov    0x80113278,%eax
80102b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b2e:	74 0a                	je     80102b3a <kalloc+0x33>
    kmem.freelist = r->next;
80102b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b33:	8b 00                	mov    (%eax),%eax
80102b35:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b3a:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	74 0c                	je     80102b4f <kalloc+0x48>
    release(&kmem.lock);
80102b43:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b4a:	e8 af 25 00 00       	call   801050fe <release>
  return (char*)r;
80102b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b52:	c9                   	leave  
80102b53:	c3                   	ret    

80102b54 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b54:	55                   	push   %ebp
80102b55:	89 e5                	mov    %esp,%ebp
80102b57:	83 ec 14             	sub    $0x14,%esp
80102b5a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b61:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b65:	89 c2                	mov    %eax,%edx
80102b67:	ec                   	in     (%dx),%al
80102b68:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b6b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    

80102b71 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b71:	55                   	push   %ebp
80102b72:	89 e5                	mov    %esp,%ebp
80102b74:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b77:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b7e:	e8 d1 ff ff ff       	call   80102b54 <inb>
80102b83:	0f b6 c0             	movzbl %al,%eax
80102b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8c:	83 e0 01             	and    $0x1,%eax
80102b8f:	85 c0                	test   %eax,%eax
80102b91:	75 0a                	jne    80102b9d <kbdgetc+0x2c>
    return -1;
80102b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b98:	e9 25 01 00 00       	jmp    80102cc2 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b9d:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102ba4:	e8 ab ff ff ff       	call   80102b54 <inb>
80102ba9:	0f b6 c0             	movzbl %al,%eax
80102bac:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102baf:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bb6:	75 17                	jne    80102bcf <kbdgetc+0x5e>
    shift |= E0ESC;
80102bb8:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bbd:	83 c8 40             	or     $0x40,%eax
80102bc0:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80102bca:	e9 f3 00 00 00       	jmp    80102cc2 <kbdgetc+0x151>
  } else if(data & 0x80){
80102bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd2:	25 80 00 00 00       	and    $0x80,%eax
80102bd7:	85 c0                	test   %eax,%eax
80102bd9:	74 45                	je     80102c20 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bdb:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102be0:	83 e0 40             	and    $0x40,%eax
80102be3:	85 c0                	test   %eax,%eax
80102be5:	75 08                	jne    80102bef <kbdgetc+0x7e>
80102be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bea:	83 e0 7f             	and    $0x7f,%eax
80102bed:	eb 03                	jmp    80102bf2 <kbdgetc+0x81>
80102bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bf8:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bfd:	0f b6 00             	movzbl (%eax),%eax
80102c00:	83 c8 40             	or     $0x40,%eax
80102c03:	0f b6 c0             	movzbl %al,%eax
80102c06:	f7 d0                	not    %eax
80102c08:	89 c2                	mov    %eax,%edx
80102c0a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c0f:	21 d0                	and    %edx,%eax
80102c11:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c16:	b8 00 00 00 00       	mov    $0x0,%eax
80102c1b:	e9 a2 00 00 00       	jmp    80102cc2 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c20:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c25:	83 e0 40             	and    $0x40,%eax
80102c28:	85 c0                	test   %eax,%eax
80102c2a:	74 14                	je     80102c40 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c2c:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c33:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c38:	83 e0 bf             	and    $0xffffffbf,%eax
80102c3b:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c43:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c48:	0f b6 00             	movzbl (%eax),%eax
80102c4b:	0f b6 d0             	movzbl %al,%edx
80102c4e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c53:	09 d0                	or     %edx,%eax
80102c55:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c5d:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c62:	0f b6 00             	movzbl (%eax),%eax
80102c65:	0f b6 d0             	movzbl %al,%edx
80102c68:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c6d:	31 d0                	xor    %edx,%eax
80102c6f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c74:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c79:	83 e0 03             	and    $0x3,%eax
80102c7c:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c86:	01 d0                	add    %edx,%eax
80102c88:	0f b6 00             	movzbl (%eax),%eax
80102c8b:	0f b6 c0             	movzbl %al,%eax
80102c8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c91:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c96:	83 e0 08             	and    $0x8,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 22                	je     80102cbf <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c9d:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ca1:	76 0c                	jbe    80102caf <kbdgetc+0x13e>
80102ca3:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ca7:	77 06                	ja     80102caf <kbdgetc+0x13e>
      c += 'A' - 'a';
80102ca9:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cad:	eb 10                	jmp    80102cbf <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102caf:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cb3:	76 0a                	jbe    80102cbf <kbdgetc+0x14e>
80102cb5:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cb9:	77 04                	ja     80102cbf <kbdgetc+0x14e>
      c += 'a' - 'A';
80102cbb:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cc2:	c9                   	leave  
80102cc3:	c3                   	ret    

80102cc4 <kbdintr>:

void
kbdintr(void)
{
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cca:	c7 04 24 71 2b 10 80 	movl   $0x80102b71,(%esp)
80102cd1:	e8 d7 da ff ff       	call   801007ad <consoleintr>
}
80102cd6:	c9                   	leave  
80102cd7:	c3                   	ret    

80102cd8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cd8:	55                   	push   %ebp
80102cd9:	89 e5                	mov    %esp,%ebp
80102cdb:	83 ec 14             	sub    $0x14,%esp
80102cde:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ce9:	89 c2                	mov    %eax,%edx
80102ceb:	ec                   	in     (%dx),%al
80102cec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cf3:	c9                   	leave  
80102cf4:	c3                   	ret    

80102cf5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cf5:	55                   	push   %ebp
80102cf6:	89 e5                	mov    %esp,%ebp
80102cf8:	83 ec 08             	sub    $0x8,%esp
80102cfb:	8b 55 08             	mov    0x8(%ebp),%edx
80102cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d01:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d05:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d08:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d0c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d10:	ee                   	out    %al,(%dx)
}
80102d11:	c9                   	leave  
80102d12:	c3                   	ret    

80102d13 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d13:	55                   	push   %ebp
80102d14:	89 e5                	mov    %esp,%ebp
80102d16:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d19:	9c                   	pushf  
80102d1a:	58                   	pop    %eax
80102d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d21:	c9                   	leave  
80102d22:	c3                   	ret    

80102d23 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d23:	55                   	push   %ebp
80102d24:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d26:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d2e:	c1 e2 02             	shl    $0x2,%edx
80102d31:	01 c2                	add    %eax,%edx
80102d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d36:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d38:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d3d:	83 c0 20             	add    $0x20,%eax
80102d40:	8b 00                	mov    (%eax),%eax
}
80102d42:	5d                   	pop    %ebp
80102d43:	c3                   	ret    

80102d44 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d4a:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d4f:	85 c0                	test   %eax,%eax
80102d51:	75 05                	jne    80102d58 <lapicinit+0x14>
    return;
80102d53:	e9 43 01 00 00       	jmp    80102e9b <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d58:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d5f:	00 
80102d60:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d67:	e8 b7 ff ff ff       	call   80102d23 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d6c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d73:	00 
80102d74:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d7b:	e8 a3 ff ff ff       	call   80102d23 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d80:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d87:	00 
80102d88:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d8f:	e8 8f ff ff ff       	call   80102d23 <lapicw>
  lapicw(TICR, 10000000); 
80102d94:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d9b:	00 
80102d9c:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102da3:	e8 7b ff ff ff       	call   80102d23 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102da8:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102daf:	00 
80102db0:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102db7:	e8 67 ff ff ff       	call   80102d23 <lapicw>
  lapicw(LINT1, MASKED);
80102dbc:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dc3:	00 
80102dc4:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102dcb:	e8 53 ff ff ff       	call   80102d23 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dd0:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102dd5:	83 c0 30             	add    $0x30,%eax
80102dd8:	8b 00                	mov    (%eax),%eax
80102dda:	c1 e8 10             	shr    $0x10,%eax
80102ddd:	0f b6 c0             	movzbl %al,%eax
80102de0:	83 f8 03             	cmp    $0x3,%eax
80102de3:	76 14                	jbe    80102df9 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102de5:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dec:	00 
80102ded:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102df4:	e8 2a ff ff ff       	call   80102d23 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102df9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e00:	00 
80102e01:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e08:	e8 16 ff ff ff       	call   80102d23 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e14:	00 
80102e15:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1c:	e8 02 ff ff ff       	call   80102d23 <lapicw>
  lapicw(ESR, 0);
80102e21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e28:	00 
80102e29:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e30:	e8 ee fe ff ff       	call   80102d23 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3c:	00 
80102e3d:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e44:	e8 da fe ff ff       	call   80102d23 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e50:	00 
80102e51:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e58:	e8 c6 fe ff ff       	call   80102d23 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e5d:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e64:	00 
80102e65:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e6c:	e8 b2 fe ff ff       	call   80102d23 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e71:	90                   	nop
80102e72:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e77:	05 00 03 00 00       	add    $0x300,%eax
80102e7c:	8b 00                	mov    (%eax),%eax
80102e7e:	25 00 10 00 00       	and    $0x1000,%eax
80102e83:	85 c0                	test   %eax,%eax
80102e85:	75 eb                	jne    80102e72 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e8e:	00 
80102e8f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e96:	e8 88 fe ff ff       	call   80102d23 <lapicw>
}
80102e9b:	c9                   	leave  
80102e9c:	c3                   	ret    

80102e9d <cpunum>:

int
cpunum(void)
{
80102e9d:	55                   	push   %ebp
80102e9e:	89 e5                	mov    %esp,%ebp
80102ea0:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ea3:	e8 6b fe ff ff       	call   80102d13 <readeflags>
80102ea8:	25 00 02 00 00       	and    $0x200,%eax
80102ead:	85 c0                	test   %eax,%eax
80102eaf:	74 25                	je     80102ed6 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102eb1:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102eb6:	8d 50 01             	lea    0x1(%eax),%edx
80102eb9:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102ebf:	85 c0                	test   %eax,%eax
80102ec1:	75 13                	jne    80102ed6 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ec3:	8b 45 04             	mov    0x4(%ebp),%eax
80102ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eca:	c7 04 24 38 92 10 80 	movl   $0x80109238,(%esp)
80102ed1:	e8 ca d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ed6:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102edb:	85 c0                	test   %eax,%eax
80102edd:	74 0f                	je     80102eee <cpunum+0x51>
    return lapic[ID]>>24;
80102edf:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ee4:	83 c0 20             	add    $0x20,%eax
80102ee7:	8b 00                	mov    (%eax),%eax
80102ee9:	c1 e8 18             	shr    $0x18,%eax
80102eec:	eb 05                	jmp    80102ef3 <cpunum+0x56>
  return 0;
80102eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ef3:	c9                   	leave  
80102ef4:	c3                   	ret    

80102ef5 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ef5:	55                   	push   %ebp
80102ef6:	89 e5                	mov    %esp,%ebp
80102ef8:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102efb:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f00:	85 c0                	test   %eax,%eax
80102f02:	74 14                	je     80102f18 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f0b:	00 
80102f0c:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f13:	e8 0b fe ff ff       	call   80102d23 <lapicw>
}
80102f18:	c9                   	leave  
80102f19:	c3                   	ret    

80102f1a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
}
80102f1d:	5d                   	pop    %ebp
80102f1e:	c3                   	ret    

80102f1f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f1f:	55                   	push   %ebp
80102f20:	89 e5                	mov    %esp,%ebp
80102f22:	83 ec 1c             	sub    $0x1c,%esp
80102f25:	8b 45 08             	mov    0x8(%ebp),%eax
80102f28:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f2b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f32:	00 
80102f33:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f3a:	e8 b6 fd ff ff       	call   80102cf5 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f3f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f46:	00 
80102f47:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f4e:	e8 a2 fd ff ff       	call   80102cf5 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f53:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f5d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f65:	8d 50 02             	lea    0x2(%eax),%edx
80102f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f6b:	c1 e8 04             	shr    $0x4,%eax
80102f6e:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f71:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f75:	c1 e0 18             	shl    $0x18,%eax
80102f78:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f7c:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f83:	e8 9b fd ff ff       	call   80102d23 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f88:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f8f:	00 
80102f90:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f97:	e8 87 fd ff ff       	call   80102d23 <lapicw>
  microdelay(200);
80102f9c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fa3:	e8 72 ff ff ff       	call   80102f1a <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fa8:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102faf:	00 
80102fb0:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fb7:	e8 67 fd ff ff       	call   80102d23 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fbc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fc3:	e8 52 ff ff ff       	call   80102f1a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fcf:	eb 40                	jmp    80103011 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fd1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd5:	c1 e0 18             	shl    $0x18,%eax
80102fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fdc:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fe3:	e8 3b fd ff ff       	call   80102d23 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102feb:	c1 e8 0c             	shr    $0xc,%eax
80102fee:	80 cc 06             	or     $0x6,%ah
80102ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff5:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ffc:	e8 22 fd ff ff       	call   80102d23 <lapicw>
    microdelay(200);
80103001:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103008:	e8 0d ff ff ff       	call   80102f1a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010300d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103011:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103015:	7e ba                	jle    80102fd1 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103017:	c9                   	leave  
80103018:	c3                   	ret    

80103019 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103019:	55                   	push   %ebp
8010301a:	89 e5                	mov    %esp,%ebp
8010301c:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010301f:	8b 45 08             	mov    0x8(%ebp),%eax
80103022:	0f b6 c0             	movzbl %al,%eax
80103025:	89 44 24 04          	mov    %eax,0x4(%esp)
80103029:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103030:	e8 c0 fc ff ff       	call   80102cf5 <outb>
  microdelay(200);
80103035:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010303c:	e8 d9 fe ff ff       	call   80102f1a <microdelay>

  return inb(CMOS_RETURN);
80103041:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103048:	e8 8b fc ff ff       	call   80102cd8 <inb>
8010304d:	0f b6 c0             	movzbl %al,%eax
}
80103050:	c9                   	leave  
80103051:	c3                   	ret    

80103052 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103052:	55                   	push   %ebp
80103053:	89 e5                	mov    %esp,%ebp
80103055:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103058:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010305f:	e8 b5 ff ff ff       	call   80103019 <cmos_read>
80103064:	8b 55 08             	mov    0x8(%ebp),%edx
80103067:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103069:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103070:	e8 a4 ff ff ff       	call   80103019 <cmos_read>
80103075:	8b 55 08             	mov    0x8(%ebp),%edx
80103078:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010307b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103082:	e8 92 ff ff ff       	call   80103019 <cmos_read>
80103087:	8b 55 08             	mov    0x8(%ebp),%edx
8010308a:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010308d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103094:	e8 80 ff ff ff       	call   80103019 <cmos_read>
80103099:	8b 55 08             	mov    0x8(%ebp),%edx
8010309c:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010309f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801030a6:	e8 6e ff ff ff       	call   80103019 <cmos_read>
801030ab:	8b 55 08             	mov    0x8(%ebp),%edx
801030ae:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801030b1:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030b8:	e8 5c ff ff ff       	call   80103019 <cmos_read>
801030bd:	8b 55 08             	mov    0x8(%ebp),%edx
801030c0:	89 42 14             	mov    %eax,0x14(%edx)
}
801030c3:	c9                   	leave  
801030c4:	c3                   	ret    

801030c5 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030c5:	55                   	push   %ebp
801030c6:	89 e5                	mov    %esp,%ebp
801030c8:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030cb:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030d2:	e8 42 ff ff ff       	call   80103019 <cmos_read>
801030d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030dd:	83 e0 04             	and    $0x4,%eax
801030e0:	85 c0                	test   %eax,%eax
801030e2:	0f 94 c0             	sete   %al
801030e5:	0f b6 c0             	movzbl %al,%eax
801030e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030eb:	8d 45 d8             	lea    -0x28(%ebp),%eax
801030ee:	89 04 24             	mov    %eax,(%esp)
801030f1:	e8 5c ff ff ff       	call   80103052 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801030f6:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801030fd:	e8 17 ff ff ff       	call   80103019 <cmos_read>
80103102:	25 80 00 00 00       	and    $0x80,%eax
80103107:	85 c0                	test   %eax,%eax
80103109:	74 02                	je     8010310d <cmostime+0x48>
        continue;
8010310b:	eb 36                	jmp    80103143 <cmostime+0x7e>
    fill_rtcdate(&t2);
8010310d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103110:	89 04 24             	mov    %eax,(%esp)
80103113:	e8 3a ff ff ff       	call   80103052 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103118:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010311f:	00 
80103120:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103123:	89 44 24 04          	mov    %eax,0x4(%esp)
80103127:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010312a:	89 04 24             	mov    %eax,(%esp)
8010312d:	e8 e6 29 00 00       	call   80105b18 <memcmp>
80103132:	85 c0                	test   %eax,%eax
80103134:	75 0d                	jne    80103143 <cmostime+0x7e>
      break;
80103136:	90                   	nop
  }

  // convert
  if (bcd) {
80103137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010313b:	0f 84 ac 00 00 00    	je     801031ed <cmostime+0x128>
80103141:	eb 02                	jmp    80103145 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103143:	eb a6                	jmp    801030eb <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103145:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103148:	c1 e8 04             	shr    $0x4,%eax
8010314b:	89 c2                	mov    %eax,%edx
8010314d:	89 d0                	mov    %edx,%eax
8010314f:	c1 e0 02             	shl    $0x2,%eax
80103152:	01 d0                	add    %edx,%eax
80103154:	01 c0                	add    %eax,%eax
80103156:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103159:	83 e2 0f             	and    $0xf,%edx
8010315c:	01 d0                	add    %edx,%eax
8010315e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103161:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103164:	c1 e8 04             	shr    $0x4,%eax
80103167:	89 c2                	mov    %eax,%edx
80103169:	89 d0                	mov    %edx,%eax
8010316b:	c1 e0 02             	shl    $0x2,%eax
8010316e:	01 d0                	add    %edx,%eax
80103170:	01 c0                	add    %eax,%eax
80103172:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103175:	83 e2 0f             	and    $0xf,%edx
80103178:	01 d0                	add    %edx,%eax
8010317a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010317d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103180:	c1 e8 04             	shr    $0x4,%eax
80103183:	89 c2                	mov    %eax,%edx
80103185:	89 d0                	mov    %edx,%eax
80103187:	c1 e0 02             	shl    $0x2,%eax
8010318a:	01 d0                	add    %edx,%eax
8010318c:	01 c0                	add    %eax,%eax
8010318e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103191:	83 e2 0f             	and    $0xf,%edx
80103194:	01 d0                	add    %edx,%eax
80103196:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010319c:	c1 e8 04             	shr    $0x4,%eax
8010319f:	89 c2                	mov    %eax,%edx
801031a1:	89 d0                	mov    %edx,%eax
801031a3:	c1 e0 02             	shl    $0x2,%eax
801031a6:	01 d0                	add    %edx,%eax
801031a8:	01 c0                	add    %eax,%eax
801031aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031ad:	83 e2 0f             	and    $0xf,%edx
801031b0:	01 d0                	add    %edx,%eax
801031b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031b8:	c1 e8 04             	shr    $0x4,%eax
801031bb:	89 c2                	mov    %eax,%edx
801031bd:	89 d0                	mov    %edx,%eax
801031bf:	c1 e0 02             	shl    $0x2,%eax
801031c2:	01 d0                	add    %edx,%eax
801031c4:	01 c0                	add    %eax,%eax
801031c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031c9:	83 e2 0f             	and    $0xf,%edx
801031cc:	01 d0                	add    %edx,%eax
801031ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031d4:	c1 e8 04             	shr    $0x4,%eax
801031d7:	89 c2                	mov    %eax,%edx
801031d9:	89 d0                	mov    %edx,%eax
801031db:	c1 e0 02             	shl    $0x2,%eax
801031de:	01 d0                	add    %edx,%eax
801031e0:	01 c0                	add    %eax,%eax
801031e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031e5:	83 e2 0f             	and    $0xf,%edx
801031e8:	01 d0                	add    %edx,%eax
801031ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801031ed:	8b 45 08             	mov    0x8(%ebp),%eax
801031f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031f3:	89 10                	mov    %edx,(%eax)
801031f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031f8:	89 50 04             	mov    %edx,0x4(%eax)
801031fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031fe:	89 50 08             	mov    %edx,0x8(%eax)
80103201:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103204:	89 50 0c             	mov    %edx,0xc(%eax)
80103207:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010320a:	89 50 10             	mov    %edx,0x10(%eax)
8010320d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103210:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103213:	8b 45 08             	mov    0x8(%ebp),%eax
80103216:	8b 40 14             	mov    0x14(%eax),%eax
80103219:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010321f:	8b 45 08             	mov    0x8(%ebp),%eax
80103222:	89 50 14             	mov    %edx,0x14(%eax)
}
80103225:	c9                   	leave  
80103226:	c3                   	ret    

80103227 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103227:	55                   	push   %ebp
80103228:	89 e5                	mov    %esp,%ebp
8010322a:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010322d:	c7 44 24 04 64 92 10 	movl   $0x80109264,0x4(%esp)
80103234:	80 
80103235:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010323c:	e8 3a 1e 00 00       	call   8010507b <initlock>
  readsb(ROOTDEV, &sb);
80103241:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103244:	89 44 24 04          	mov    %eax,0x4(%esp)
80103248:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010324f:	e8 bf e0 ff ff       	call   80101313 <readsb>
  log.start = sb.size - sb.nlog;
80103254:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010325a:	29 c2                	sub    %eax,%edx
8010325c:	89 d0                	mov    %edx,%eax
8010325e:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103266:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
8010326b:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
80103272:	00 00 00 
  recover_from_log();
80103275:	e8 9a 01 00 00       	call   80103414 <recover_from_log>
}
8010327a:	c9                   	leave  
8010327b:	c3                   	ret    

8010327c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010327c:	55                   	push   %ebp
8010327d:	89 e5                	mov    %esp,%ebp
8010327f:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103282:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103289:	e9 8c 00 00 00       	jmp    8010331a <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010328e:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103297:	01 d0                	add    %edx,%eax
80103299:	83 c0 01             	add    $0x1,%eax
8010329c:	89 c2                	mov    %eax,%edx
8010329e:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032a3:	89 54 24 04          	mov    %edx,0x4(%esp)
801032a7:	89 04 24             	mov    %eax,(%esp)
801032aa:	e8 f7 ce ff ff       	call   801001a6 <bread>
801032af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032b5:	83 c0 10             	add    $0x10,%eax
801032b8:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801032bf:	89 c2                	mov    %eax,%edx
801032c1:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801032ca:	89 04 24             	mov    %eax,(%esp)
801032cd:	e8 d4 ce ff ff       	call   801001a6 <bread>
801032d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032d8:	8d 50 18             	lea    0x18(%eax),%edx
801032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032de:	83 c0 18             	add    $0x18,%eax
801032e1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032e8:	00 
801032e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801032ed:	89 04 24             	mov    %eax,(%esp)
801032f0:	e8 7b 28 00 00       	call   80105b70 <memmove>
    bwrite(dbuf);  // write dst to disk
801032f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f8:	89 04 24             	mov    %eax,(%esp)
801032fb:	e8 dd ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103300:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103303:	89 04 24             	mov    %eax,(%esp)
80103306:	e8 0c cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
8010330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010330e:	89 04 24             	mov    %eax,(%esp)
80103311:	e8 01 cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103316:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010331a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010331f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103322:	0f 8f 66 ff ff ff    	jg     8010328e <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103328:	c9                   	leave  
80103329:	c3                   	ret    

8010332a <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010332a:	55                   	push   %ebp
8010332b:	89 e5                	mov    %esp,%ebp
8010332d:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103330:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103335:	89 c2                	mov    %eax,%edx
80103337:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010333c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103340:	89 04 24             	mov    %eax,(%esp)
80103343:	e8 5e ce ff ff       	call   801001a6 <bread>
80103348:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010334b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334e:	83 c0 18             	add    $0x18,%eax
80103351:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103357:	8b 00                	mov    (%eax),%eax
80103359:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010335e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103365:	eb 1b                	jmp    80103382 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103367:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010336d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103371:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103374:	83 c2 10             	add    $0x10,%edx
80103377:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010337e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103382:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103387:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010338a:	7f db                	jg     80103367 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010338c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010338f:	89 04 24             	mov    %eax,(%esp)
80103392:	e8 80 ce ff ff       	call   80100217 <brelse>
}
80103397:	c9                   	leave  
80103398:	c3                   	ret    

80103399 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103399:	55                   	push   %ebp
8010339a:	89 e5                	mov    %esp,%ebp
8010339c:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010339f:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801033af:	89 04 24             	mov    %eax,(%esp)
801033b2:	e8 ef cd ff ff       	call   801001a6 <bread>
801033b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033bd:	83 c0 18             	add    $0x18,%eax
801033c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033c3:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801033c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033cc:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d5:	eb 1b                	jmp    801033f2 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033da:	83 c0 10             	add    $0x10,%eax
801033dd:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
801033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033ea:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033fa:	7f db                	jg     801033d7 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ff:	89 04 24             	mov    %eax,(%esp)
80103402:	e8 d6 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103407:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010340a:	89 04 24             	mov    %eax,(%esp)
8010340d:	e8 05 ce ff ff       	call   80100217 <brelse>
}
80103412:	c9                   	leave  
80103413:	c3                   	ret    

80103414 <recover_from_log>:

static void
recover_from_log(void)
{
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010341a:	e8 0b ff ff ff       	call   8010332a <read_head>
  install_trans(); // if committed, copy from log to disk
8010341f:	e8 58 fe ff ff       	call   8010327c <install_trans>
  log.lh.n = 0;
80103424:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010342b:	00 00 00 
  write_head(); // clear the log
8010342e:	e8 66 ff ff ff       	call   80103399 <write_head>
}
80103433:	c9                   	leave  
80103434:	c3                   	ret    

80103435 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103435:	55                   	push   %ebp
80103436:	89 e5                	mov    %esp,%ebp
80103438:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010343b:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103442:	e8 55 1c 00 00       	call   8010509c <acquire>
  while(1){
    if(log.committing){
80103447:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010344c:	85 c0                	test   %eax,%eax
8010344e:	74 16                	je     80103466 <begin_op+0x31>
      sleep(&log, &log.lock);
80103450:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103457:	80 
80103458:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010345f:	e8 2a 19 00 00       	call   80104d8e <sleep>
80103464:	eb 4f                	jmp    801034b5 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103466:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
8010346c:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103471:	8d 50 01             	lea    0x1(%eax),%edx
80103474:	89 d0                	mov    %edx,%eax
80103476:	c1 e0 02             	shl    $0x2,%eax
80103479:	01 d0                	add    %edx,%eax
8010347b:	01 c0                	add    %eax,%eax
8010347d:	01 c8                	add    %ecx,%eax
8010347f:	83 f8 1e             	cmp    $0x1e,%eax
80103482:	7e 16                	jle    8010349a <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103484:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
8010348b:	80 
8010348c:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103493:	e8 f6 18 00 00       	call   80104d8e <sleep>
80103498:	eb 1b                	jmp    801034b5 <begin_op+0x80>
    } else {
      log.outstanding += 1;
8010349a:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010349f:	83 c0 01             	add    $0x1,%eax
801034a2:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
801034a7:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034ae:	e8 4b 1c 00 00       	call   801050fe <release>
      break;
801034b3:	eb 02                	jmp    801034b7 <begin_op+0x82>
    }
  }
801034b5:	eb 90                	jmp    80103447 <begin_op+0x12>
}
801034b7:	c9                   	leave  
801034b8:	c3                   	ret    

801034b9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034b9:	55                   	push   %ebp
801034ba:	89 e5                	mov    %esp,%ebp
801034bc:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034c6:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034cd:	e8 ca 1b 00 00       	call   8010509c <acquire>
  log.outstanding -= 1;
801034d2:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034d7:	83 e8 01             	sub    $0x1,%eax
801034da:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801034df:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034e4:	85 c0                	test   %eax,%eax
801034e6:	74 0c                	je     801034f4 <end_op+0x3b>
    panic("log.committing");
801034e8:	c7 04 24 68 92 10 80 	movl   $0x80109268,(%esp)
801034ef:	e8 46 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034f4:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034f9:	85 c0                	test   %eax,%eax
801034fb:	75 13                	jne    80103510 <end_op+0x57>
    do_commit = 1;
801034fd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103504:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
8010350b:	00 00 00 
8010350e:	eb 0c                	jmp    8010351c <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103510:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103517:	e8 6a 19 00 00       	call   80104e86 <wakeup>
  }
  release(&log.lock);
8010351c:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103523:	e8 d6 1b 00 00       	call   801050fe <release>

  if(do_commit){
80103528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010352c:	74 33                	je     80103561 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010352e:	e8 de 00 00 00       	call   80103611 <commit>
    acquire(&log.lock);
80103533:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010353a:	e8 5d 1b 00 00       	call   8010509c <acquire>
    log.committing = 0;
8010353f:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103546:	00 00 00 
    wakeup(&log);
80103549:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103550:	e8 31 19 00 00       	call   80104e86 <wakeup>
    release(&log.lock);
80103555:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010355c:	e8 9d 1b 00 00       	call   801050fe <release>
  }
}
80103561:	c9                   	leave  
80103562:	c3                   	ret    

80103563 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103563:	55                   	push   %ebp
80103564:	89 e5                	mov    %esp,%ebp
80103566:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103570:	e9 8c 00 00 00       	jmp    80103601 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103575:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010357e:	01 d0                	add    %edx,%eax
80103580:	83 c0 01             	add    $0x1,%eax
80103583:	89 c2                	mov    %eax,%edx
80103585:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010358a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010358e:	89 04 24             	mov    %eax,(%esp)
80103591:	e8 10 cc ff ff       	call   801001a6 <bread>
80103596:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010359c:	83 c0 10             	add    $0x10,%eax
8010359f:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801035a6:	89 c2                	mov    %eax,%edx
801035a8:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801035ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801035b1:	89 04 24             	mov    %eax,(%esp)
801035b4:	e8 ed cb ff ff       	call   801001a6 <bread>
801035b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035bf:	8d 50 18             	lea    0x18(%eax),%edx
801035c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035c5:	83 c0 18             	add    $0x18,%eax
801035c8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035cf:	00 
801035d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801035d4:	89 04 24             	mov    %eax,(%esp)
801035d7:	e8 94 25 00 00       	call   80105b70 <memmove>
    bwrite(to);  // write the log
801035dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035df:	89 04 24             	mov    %eax,(%esp)
801035e2:	e8 f6 cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ea:	89 04 24             	mov    %eax,(%esp)
801035ed:	e8 25 cc ff ff       	call   80100217 <brelse>
    brelse(to);
801035f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035f5:	89 04 24             	mov    %eax,(%esp)
801035f8:	e8 1a cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103601:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103606:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103609:	0f 8f 66 ff ff ff    	jg     80103575 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
8010360f:	c9                   	leave  
80103610:	c3                   	ret    

80103611 <commit>:

static void
commit()
{
80103611:	55                   	push   %ebp
80103612:	89 e5                	mov    %esp,%ebp
80103614:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103617:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010361c:	85 c0                	test   %eax,%eax
8010361e:	7e 1e                	jle    8010363e <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103620:	e8 3e ff ff ff       	call   80103563 <write_log>
    write_head();    // Write header to disk -- the real commit
80103625:	e8 6f fd ff ff       	call   80103399 <write_head>
    install_trans(); // Now install writes to home locations
8010362a:	e8 4d fc ff ff       	call   8010327c <install_trans>
    log.lh.n = 0; 
8010362f:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103636:	00 00 00 
    write_head();    // Erase the transaction from the log
80103639:	e8 5b fd ff ff       	call   80103399 <write_head>
  }
}
8010363e:	c9                   	leave  
8010363f:	c3                   	ret    

80103640 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103646:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010364b:	83 f8 1d             	cmp    $0x1d,%eax
8010364e:	7f 12                	jg     80103662 <log_write+0x22>
80103650:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103655:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
8010365b:	83 ea 01             	sub    $0x1,%edx
8010365e:	39 d0                	cmp    %edx,%eax
80103660:	7c 0c                	jl     8010366e <log_write+0x2e>
    panic("too big a transaction");
80103662:	c7 04 24 77 92 10 80 	movl   $0x80109277,(%esp)
80103669:	e8 cc ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010366e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103673:	85 c0                	test   %eax,%eax
80103675:	7f 0c                	jg     80103683 <log_write+0x43>
    panic("log_write outside of trans");
80103677:	c7 04 24 8d 92 10 80 	movl   $0x8010928d,(%esp)
8010367e:	e8 b7 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103683:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010368a:	e8 0d 1a 00 00       	call   8010509c <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010368f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103696:	eb 1f                	jmp    801036b7 <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369b:	83 c0 10             	add    $0x10,%eax
8010369e:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801036a5:	89 c2                	mov    %eax,%edx
801036a7:	8b 45 08             	mov    0x8(%ebp),%eax
801036aa:	8b 40 08             	mov    0x8(%eax),%eax
801036ad:	39 c2                	cmp    %eax,%edx
801036af:	75 02                	jne    801036b3 <log_write+0x73>
      break;
801036b1:	eb 0e                	jmp    801036c1 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036b7:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036bf:	7f d7                	jg     80103698 <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036c1:	8b 45 08             	mov    0x8(%ebp),%eax
801036c4:	8b 40 08             	mov    0x8(%eax),%eax
801036c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036ca:	83 c2 10             	add    $0x10,%edx
801036cd:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
801036d4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036dc:	75 0d                	jne    801036eb <log_write+0xab>
    log.lh.n++;
801036de:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036e3:	83 c0 01             	add    $0x1,%eax
801036e6:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801036eb:	8b 45 08             	mov    0x8(%ebp),%eax
801036ee:	8b 00                	mov    (%eax),%eax
801036f0:	83 c8 04             	or     $0x4,%eax
801036f3:	89 c2                	mov    %eax,%edx
801036f5:	8b 45 08             	mov    0x8(%ebp),%eax
801036f8:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801036fa:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103701:	e8 f8 19 00 00       	call   801050fe <release>
}
80103706:	c9                   	leave  
80103707:	c3                   	ret    

80103708 <v2p>:
80103708:	55                   	push   %ebp
80103709:	89 e5                	mov    %esp,%ebp
8010370b:	8b 45 08             	mov    0x8(%ebp),%eax
8010370e:	05 00 00 00 80       	add    $0x80000000,%eax
80103713:	5d                   	pop    %ebp
80103714:	c3                   	ret    

80103715 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103715:	55                   	push   %ebp
80103716:	89 e5                	mov    %esp,%ebp
80103718:	8b 45 08             	mov    0x8(%ebp),%eax
8010371b:	05 00 00 00 80       	add    $0x80000000,%eax
80103720:	5d                   	pop    %ebp
80103721:	c3                   	ret    

80103722 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103722:	55                   	push   %ebp
80103723:	89 e5                	mov    %esp,%ebp
80103725:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103728:	8b 55 08             	mov    0x8(%ebp),%edx
8010372b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010372e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103731:	f0 87 02             	lock xchg %eax,(%edx)
80103734:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103737:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010373a:	c9                   	leave  
8010373b:	c3                   	ret    

8010373c <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010373c:	55                   	push   %ebp
8010373d:	89 e5                	mov    %esp,%ebp
8010373f:	83 e4 f0             	and    $0xfffffff0,%esp
80103742:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103745:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010374c:	80 
8010374d:	c7 04 24 5c f2 11 80 	movl   $0x8011f25c,(%esp)
80103754:	e8 80 f2 ff ff       	call   801029d9 <kinit1>
  kvmalloc();      // kernel page table
80103759:	e8 47 51 00 00       	call   801088a5 <kvmalloc>
  mpinit();        // collect info about this machine
8010375e:	e8 46 04 00 00       	call   80103ba9 <mpinit>
  lapicinit();
80103763:	e8 dc f5 ff ff       	call   80102d44 <lapicinit>
  seginit();       // set up segments
80103768:	e8 cb 4a 00 00       	call   80108238 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010376d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103773:	0f b6 00             	movzbl (%eax),%eax
80103776:	0f b6 c0             	movzbl %al,%eax
80103779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010377d:	c7 04 24 a8 92 10 80 	movl   $0x801092a8,(%esp)
80103784:	e8 17 cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103789:	e8 79 06 00 00       	call   80103e07 <picinit>
  ioapicinit();    // another interrupt controller
8010378e:	e8 3c f1 ff ff       	call   801028cf <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103793:	e8 ec d2 ff ff       	call   80100a84 <consoleinit>
  uartinit();      // serial port
80103798:	e8 ea 3d 00 00       	call   80107587 <uartinit>
  pinit();         // process table
8010379d:	e8 75 0b 00 00       	call   80104317 <pinit>
  tvinit();        // trap vectors
801037a2:	e8 3c 39 00 00       	call   801070e3 <tvinit>
  binit();         // buffer cache
801037a7:	e8 88 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037ac:	e8 7b d7 ff ff       	call   80100f2c <fileinit>
  iinit();         // inode cache
801037b1:	e8 10 de ff ff       	call   801015c6 <iinit>
  ideinit();       // disk
801037b6:	e8 7d ed ff ff       	call   80102538 <ideinit>
  if(!ismp)
801037bb:	a1 64 33 11 80       	mov    0x80113364,%eax
801037c0:	85 c0                	test   %eax,%eax
801037c2:	75 05                	jne    801037c9 <main+0x8d>
    timerinit();   // uniprocessor timer
801037c4:	e8 65 38 00 00       	call   8010702e <timerinit>
  startothers();   // start other processors
801037c9:	e8 7f 00 00 00       	call   8010384d <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037ce:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037d5:	8e 
801037d6:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037dd:	e8 2f f2 ff ff       	call   80102a11 <kinit2>
  userinit();      // first user process
801037e2:	e8 99 0c 00 00       	call   80104480 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037e7:	e8 1a 00 00 00       	call   80103806 <mpmain>

801037ec <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037ec:	55                   	push   %ebp
801037ed:	89 e5                	mov    %esp,%ebp
801037ef:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801037f2:	e8 c5 50 00 00       	call   801088bc <switchkvm>
  seginit();
801037f7:	e8 3c 4a 00 00       	call   80108238 <seginit>
  lapicinit();
801037fc:	e8 43 f5 ff ff       	call   80102d44 <lapicinit>
  mpmain();
80103801:	e8 00 00 00 00       	call   80103806 <mpmain>

80103806 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103806:	55                   	push   %ebp
80103807:	89 e5                	mov    %esp,%ebp
80103809:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010380c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103812:	0f b6 00             	movzbl (%eax),%eax
80103815:	0f b6 c0             	movzbl %al,%eax
80103818:	89 44 24 04          	mov    %eax,0x4(%esp)
8010381c:	c7 04 24 bf 92 10 80 	movl   $0x801092bf,(%esp)
80103823:	e8 78 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103828:	e8 2a 3a 00 00       	call   80107257 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010382d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103833:	05 a8 00 00 00       	add    $0xa8,%eax
80103838:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010383f:	00 
80103840:	89 04 24             	mov    %eax,(%esp)
80103843:	e8 da fe ff ff       	call   80103722 <xchg>
  scheduler();     // start running processes
80103848:	e8 3a 13 00 00       	call   80104b87 <scheduler>

8010384d <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010384d:	55                   	push   %ebp
8010384e:	89 e5                	mov    %esp,%ebp
80103850:	53                   	push   %ebx
80103851:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103854:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
8010385b:	e8 b5 fe ff ff       	call   80103715 <p2v>
80103860:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103863:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103868:	89 44 24 08          	mov    %eax,0x8(%esp)
8010386c:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103873:	80 
80103874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103877:	89 04 24             	mov    %eax,(%esp)
8010387a:	e8 f1 22 00 00       	call   80105b70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010387f:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103886:	e9 85 00 00 00       	jmp    80103910 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010388b:	e8 0d f6 ff ff       	call   80102e9d <cpunum>
80103890:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103896:	05 80 33 11 80       	add    $0x80113380,%eax
8010389b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010389e:	75 02                	jne    801038a2 <startothers+0x55>
      continue;
801038a0:	eb 67                	jmp    80103909 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038a2:	e8 60 f2 ff ff       	call   80102b07 <kalloc>
801038a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ad:	83 e8 04             	sub    $0x4,%eax
801038b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038b3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038b9:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038be:	83 e8 08             	sub    $0x8,%eax
801038c1:	c7 00 ec 37 10 80    	movl   $0x801037ec,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ca:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038cd:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
801038d4:	e8 2f fe ff ff       	call   80103708 <v2p>
801038d9:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038de:	89 04 24             	mov    %eax,(%esp)
801038e1:	e8 22 fe ff ff       	call   80103708 <v2p>
801038e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038e9:	0f b6 12             	movzbl (%edx),%edx
801038ec:	0f b6 d2             	movzbl %dl,%edx
801038ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801038f3:	89 14 24             	mov    %edx,(%esp)
801038f6:	e8 24 f6 ff ff       	call   80102f1f <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038fb:	90                   	nop
801038fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ff:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103905:	85 c0                	test   %eax,%eax
80103907:	74 f3                	je     801038fc <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103909:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103910:	a1 60 39 11 80       	mov    0x80113960,%eax
80103915:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010391b:	05 80 33 11 80       	add    $0x80113380,%eax
80103920:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103923:	0f 87 62 ff ff ff    	ja     8010388b <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103929:	83 c4 24             	add    $0x24,%esp
8010392c:	5b                   	pop    %ebx
8010392d:	5d                   	pop    %ebp
8010392e:	c3                   	ret    

8010392f <p2v>:
8010392f:	55                   	push   %ebp
80103930:	89 e5                	mov    %esp,%ebp
80103932:	8b 45 08             	mov    0x8(%ebp),%eax
80103935:	05 00 00 00 80       	add    $0x80000000,%eax
8010393a:	5d                   	pop    %ebp
8010393b:	c3                   	ret    

8010393c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010393c:	55                   	push   %ebp
8010393d:	89 e5                	mov    %esp,%ebp
8010393f:	83 ec 14             	sub    $0x14,%esp
80103942:	8b 45 08             	mov    0x8(%ebp),%eax
80103945:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103949:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010394d:	89 c2                	mov    %eax,%edx
8010394f:	ec                   	in     (%dx),%al
80103950:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103953:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103957:	c9                   	leave  
80103958:	c3                   	ret    

80103959 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103959:	55                   	push   %ebp
8010395a:	89 e5                	mov    %esp,%ebp
8010395c:	83 ec 08             	sub    $0x8,%esp
8010395f:	8b 55 08             	mov    0x8(%ebp),%edx
80103962:	8b 45 0c             	mov    0xc(%ebp),%eax
80103965:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103969:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010396c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103970:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103974:	ee                   	out    %al,(%dx)
}
80103975:	c9                   	leave  
80103976:	c3                   	ret    

80103977 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103977:	55                   	push   %ebp
80103978:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010397a:	a1 64 c6 10 80       	mov    0x8010c664,%eax
8010397f:	89 c2                	mov    %eax,%edx
80103981:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103986:	29 c2                	sub    %eax,%edx
80103988:	89 d0                	mov    %edx,%eax
8010398a:	c1 f8 02             	sar    $0x2,%eax
8010398d:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret    

80103995 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103995:	55                   	push   %ebp
80103996:	89 e5                	mov    %esp,%ebp
80103998:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010399b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801039a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801039a9:	eb 15                	jmp    801039c0 <sum+0x2b>
    sum += addr[i];
801039ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039ae:	8b 45 08             	mov    0x8(%ebp),%eax
801039b1:	01 d0                	add    %edx,%eax
801039b3:	0f b6 00             	movzbl (%eax),%eax
801039b6:	0f b6 c0             	movzbl %al,%eax
801039b9:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039bc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039c6:	7c e3                	jl     801039ab <sum+0x16>
    sum += addr[i];
  return sum;
801039c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039cb:	c9                   	leave  
801039cc:	c3                   	ret    

801039cd <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039cd:	55                   	push   %ebp
801039ce:	89 e5                	mov    %esp,%ebp
801039d0:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039d3:	8b 45 08             	mov    0x8(%ebp),%eax
801039d6:	89 04 24             	mov    %eax,(%esp)
801039d9:	e8 51 ff ff ff       	call   8010392f <p2v>
801039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801039e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039e7:	01 d0                	add    %edx,%eax
801039e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039f2:	eb 3f                	jmp    80103a33 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039f4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039fb:	00 
801039fc:	c7 44 24 04 d0 92 10 	movl   $0x801092d0,0x4(%esp)
80103a03:	80 
80103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a07:	89 04 24             	mov    %eax,(%esp)
80103a0a:	e8 09 21 00 00       	call   80105b18 <memcmp>
80103a0f:	85 c0                	test   %eax,%eax
80103a11:	75 1c                	jne    80103a2f <mpsearch1+0x62>
80103a13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a1a:	00 
80103a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1e:	89 04 24             	mov    %eax,(%esp)
80103a21:	e8 6f ff ff ff       	call   80103995 <sum>
80103a26:	84 c0                	test   %al,%al
80103a28:	75 05                	jne    80103a2f <mpsearch1+0x62>
      return (struct mp*)p;
80103a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a2d:	eb 11                	jmp    80103a40 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a2f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a39:	72 b9                	jb     801039f4 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    

80103a42 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a42:	55                   	push   %ebp
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a48:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a52:	83 c0 0f             	add    $0xf,%eax
80103a55:	0f b6 00             	movzbl (%eax),%eax
80103a58:	0f b6 c0             	movzbl %al,%eax
80103a5b:	c1 e0 08             	shl    $0x8,%eax
80103a5e:	89 c2                	mov    %eax,%edx
80103a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a63:	83 c0 0e             	add    $0xe,%eax
80103a66:	0f b6 00             	movzbl (%eax),%eax
80103a69:	0f b6 c0             	movzbl %al,%eax
80103a6c:	09 d0                	or     %edx,%eax
80103a6e:	c1 e0 04             	shl    $0x4,%eax
80103a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a78:	74 21                	je     80103a9b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a7a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a81:	00 
80103a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a85:	89 04 24             	mov    %eax,(%esp)
80103a88:	e8 40 ff ff ff       	call   801039cd <mpsearch1>
80103a8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a94:	74 50                	je     80103ae6 <mpsearch+0xa4>
      return mp;
80103a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a99:	eb 5f                	jmp    80103afa <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9e:	83 c0 14             	add    $0x14,%eax
80103aa1:	0f b6 00             	movzbl (%eax),%eax
80103aa4:	0f b6 c0             	movzbl %al,%eax
80103aa7:	c1 e0 08             	shl    $0x8,%eax
80103aaa:	89 c2                	mov    %eax,%edx
80103aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aaf:	83 c0 13             	add    $0x13,%eax
80103ab2:	0f b6 00             	movzbl (%eax),%eax
80103ab5:	0f b6 c0             	movzbl %al,%eax
80103ab8:	09 d0                	or     %edx,%eax
80103aba:	c1 e0 0a             	shl    $0xa,%eax
80103abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac3:	2d 00 04 00 00       	sub    $0x400,%eax
80103ac8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103acf:	00 
80103ad0:	89 04 24             	mov    %eax,(%esp)
80103ad3:	e8 f5 fe ff ff       	call   801039cd <mpsearch1>
80103ad8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103adf:	74 05                	je     80103ae6 <mpsearch+0xa4>
      return mp;
80103ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ae4:	eb 14                	jmp    80103afa <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ae6:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103aed:	00 
80103aee:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103af5:	e8 d3 fe ff ff       	call   801039cd <mpsearch1>
}
80103afa:	c9                   	leave  
80103afb:	c3                   	ret    

80103afc <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103afc:	55                   	push   %ebp
80103afd:	89 e5                	mov    %esp,%ebp
80103aff:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b02:	e8 3b ff ff ff       	call   80103a42 <mpsearch>
80103b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b0e:	74 0a                	je     80103b1a <mpconfig+0x1e>
80103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b13:	8b 40 04             	mov    0x4(%eax),%eax
80103b16:	85 c0                	test   %eax,%eax
80103b18:	75 0a                	jne    80103b24 <mpconfig+0x28>
    return 0;
80103b1a:	b8 00 00 00 00       	mov    $0x0,%eax
80103b1f:	e9 83 00 00 00       	jmp    80103ba7 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b27:	8b 40 04             	mov    0x4(%eax),%eax
80103b2a:	89 04 24             	mov    %eax,(%esp)
80103b2d:	e8 fd fd ff ff       	call   8010392f <p2v>
80103b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b35:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b3c:	00 
80103b3d:	c7 44 24 04 d5 92 10 	movl   $0x801092d5,0x4(%esp)
80103b44:	80 
80103b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b48:	89 04 24             	mov    %eax,(%esp)
80103b4b:	e8 c8 1f 00 00       	call   80105b18 <memcmp>
80103b50:	85 c0                	test   %eax,%eax
80103b52:	74 07                	je     80103b5b <mpconfig+0x5f>
    return 0;
80103b54:	b8 00 00 00 00       	mov    $0x0,%eax
80103b59:	eb 4c                	jmp    80103ba7 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b62:	3c 01                	cmp    $0x1,%al
80103b64:	74 12                	je     80103b78 <mpconfig+0x7c>
80103b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b69:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b6d:	3c 04                	cmp    $0x4,%al
80103b6f:	74 07                	je     80103b78 <mpconfig+0x7c>
    return 0;
80103b71:	b8 00 00 00 00       	mov    $0x0,%eax
80103b76:	eb 2f                	jmp    80103ba7 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b7f:	0f b7 c0             	movzwl %ax,%eax
80103b82:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b89:	89 04 24             	mov    %eax,(%esp)
80103b8c:	e8 04 fe ff ff       	call   80103995 <sum>
80103b91:	84 c0                	test   %al,%al
80103b93:	74 07                	je     80103b9c <mpconfig+0xa0>
    return 0;
80103b95:	b8 00 00 00 00       	mov    $0x0,%eax
80103b9a:	eb 0b                	jmp    80103ba7 <mpconfig+0xab>
  *pmp = mp;
80103b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ba2:	89 10                	mov    %edx,(%eax)
  return conf;
80103ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103ba7:	c9                   	leave  
80103ba8:	c3                   	ret    

80103ba9 <mpinit>:

void
mpinit(void)
{
80103ba9:	55                   	push   %ebp
80103baa:	89 e5                	mov    %esp,%ebp
80103bac:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103baf:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103bb6:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103bb9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103bbc:	89 04 24             	mov    %eax,(%esp)
80103bbf:	e8 38 ff ff ff       	call   80103afc <mpconfig>
80103bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bcb:	75 05                	jne    80103bd2 <mpinit+0x29>
    return;
80103bcd:	e9 9c 01 00 00       	jmp    80103d6e <mpinit+0x1c5>
  ismp = 1;
80103bd2:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103bd9:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bdf:	8b 40 24             	mov    0x24(%eax),%eax
80103be2:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bea:	83 c0 2c             	add    $0x2c,%eax
80103bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf3:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bf7:	0f b7 d0             	movzwl %ax,%edx
80103bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfd:	01 d0                	add    %edx,%eax
80103bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c02:	e9 f4 00 00 00       	jmp    80103cfb <mpinit+0x152>
    switch(*p){
80103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0a:	0f b6 00             	movzbl (%eax),%eax
80103c0d:	0f b6 c0             	movzbl %al,%eax
80103c10:	83 f8 04             	cmp    $0x4,%eax
80103c13:	0f 87 bf 00 00 00    	ja     80103cd8 <mpinit+0x12f>
80103c19:	8b 04 85 18 93 10 80 	mov    -0x7fef6ce8(,%eax,4),%eax
80103c20:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c25:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c2f:	0f b6 d0             	movzbl %al,%edx
80103c32:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c37:	39 c2                	cmp    %eax,%edx
80103c39:	74 2d                	je     80103c68 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c3e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c42:	0f b6 d0             	movzbl %al,%edx
80103c45:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c4a:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c52:	c7 04 24 da 92 10 80 	movl   $0x801092da,(%esp)
80103c59:	e8 42 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c5e:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103c65:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c6b:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c6f:	0f b6 c0             	movzbl %al,%eax
80103c72:	83 e0 02             	and    $0x2,%eax
80103c75:	85 c0                	test   %eax,%eax
80103c77:	74 15                	je     80103c8e <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c79:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c7e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c84:	05 80 33 11 80       	add    $0x80113380,%eax
80103c89:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103c8e:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103c94:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c99:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c9f:	81 c2 80 33 11 80    	add    $0x80113380,%edx
80103ca5:	88 02                	mov    %al,(%edx)
      ncpu++;
80103ca7:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cac:	83 c0 01             	add    $0x1,%eax
80103caf:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103cb4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103cb8:	eb 41                	jmp    80103cfb <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cc3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cc7:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103ccc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cd0:	eb 29                	jmp    80103cfb <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cd2:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cd6:	eb 23                	jmp    80103cfb <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cdb:	0f b6 00             	movzbl (%eax),%eax
80103cde:	0f b6 c0             	movzbl %al,%eax
80103ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ce5:	c7 04 24 f8 92 10 80 	movl   $0x801092f8,(%esp)
80103cec:	e8 af c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cf1:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103cf8:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d01:	0f 82 00 ff ff ff    	jb     80103c07 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d07:	a1 64 33 11 80       	mov    0x80113364,%eax
80103d0c:	85 c0                	test   %eax,%eax
80103d0e:	75 1d                	jne    80103d2d <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d10:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103d17:	00 00 00 
    lapic = 0;
80103d1a:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103d21:	00 00 00 
    ioapicid = 0;
80103d24:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103d2b:	eb 41                	jmp    80103d6e <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d30:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d34:	84 c0                	test   %al,%al
80103d36:	74 36                	je     80103d6e <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d38:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d3f:	00 
80103d40:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d47:	e8 0d fc ff ff       	call   80103959 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d4c:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d53:	e8 e4 fb ff ff       	call   8010393c <inb>
80103d58:	83 c8 01             	or     $0x1,%eax
80103d5b:	0f b6 c0             	movzbl %al,%eax
80103d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d62:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d69:	e8 eb fb ff ff       	call   80103959 <outb>
  }
}
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    

80103d70 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 08             	sub    $0x8,%esp
80103d76:	8b 55 08             	mov    0x8(%ebp),%edx
80103d79:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d7c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d80:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d83:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d87:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d8b:	ee                   	out    %al,(%dx)
}
80103d8c:	c9                   	leave  
80103d8d:	c3                   	ret    

80103d8e <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103d8e:	55                   	push   %ebp
80103d8f:	89 e5                	mov    %esp,%ebp
80103d91:	83 ec 0c             	sub    $0xc,%esp
80103d94:	8b 45 08             	mov    0x8(%ebp),%eax
80103d97:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103d9b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d9f:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103da5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103da9:	0f b6 c0             	movzbl %al,%eax
80103dac:	89 44 24 04          	mov    %eax,0x4(%esp)
80103db0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103db7:	e8 b4 ff ff ff       	call   80103d70 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103dbc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dc0:	66 c1 e8 08          	shr    $0x8,%ax
80103dc4:	0f b6 c0             	movzbl %al,%eax
80103dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dcb:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103dd2:	e8 99 ff ff ff       	call   80103d70 <outb>
}
80103dd7:	c9                   	leave  
80103dd8:	c3                   	ret    

80103dd9 <picenable>:

void
picenable(int irq)
{
80103dd9:	55                   	push   %ebp
80103dda:	89 e5                	mov    %esp,%ebp
80103ddc:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80103de2:	ba 01 00 00 00       	mov    $0x1,%edx
80103de7:	89 c1                	mov    %eax,%ecx
80103de9:	d3 e2                	shl    %cl,%edx
80103deb:	89 d0                	mov    %edx,%eax
80103ded:	f7 d0                	not    %eax
80103def:	89 c2                	mov    %eax,%edx
80103df1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103df8:	21 d0                	and    %edx,%eax
80103dfa:	0f b7 c0             	movzwl %ax,%eax
80103dfd:	89 04 24             	mov    %eax,(%esp)
80103e00:	e8 89 ff ff ff       	call   80103d8e <picsetmask>
}
80103e05:	c9                   	leave  
80103e06:	c3                   	ret    

80103e07 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e07:	55                   	push   %ebp
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e0d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e14:	00 
80103e15:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e1c:	e8 4f ff ff ff       	call   80103d70 <outb>
  outb(IO_PIC2+1, 0xFF);
80103e21:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e28:	00 
80103e29:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e30:	e8 3b ff ff ff       	call   80103d70 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e35:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e3c:	00 
80103e3d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e44:	e8 27 ff ff ff       	call   80103d70 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e49:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e50:	00 
80103e51:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e58:	e8 13 ff ff ff       	call   80103d70 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e5d:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e64:	00 
80103e65:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e6c:	e8 ff fe ff ff       	call   80103d70 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e71:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e78:	00 
80103e79:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e80:	e8 eb fe ff ff       	call   80103d70 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e85:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e8c:	00 
80103e8d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103e94:	e8 d7 fe ff ff       	call   80103d70 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103e99:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103ea0:	00 
80103ea1:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea8:	e8 c3 fe ff ff       	call   80103d70 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ead:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103eb4:	00 
80103eb5:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebc:	e8 af fe ff ff       	call   80103d70 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ec1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ec8:	00 
80103ec9:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ed0:	e8 9b fe ff ff       	call   80103d70 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ed5:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103edc:	00 
80103edd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ee4:	e8 87 fe ff ff       	call   80103d70 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ee9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103ef0:	00 
80103ef1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ef8:	e8 73 fe ff ff       	call   80103d70 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103efd:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f04:	00 
80103f05:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f0c:	e8 5f fe ff ff       	call   80103d70 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f11:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f18:	00 
80103f19:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f20:	e8 4b fe ff ff       	call   80103d70 <outb>

  if(irqmask != 0xFFFF)
80103f25:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f2c:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f30:	74 12                	je     80103f44 <picinit+0x13d>
    picsetmask(irqmask);
80103f32:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f39:	0f b7 c0             	movzwl %ax,%eax
80103f3c:	89 04 24             	mov    %eax,(%esp)
80103f3f:	e8 4a fe ff ff       	call   80103d8e <picsetmask>
}
80103f44:	c9                   	leave  
80103f45:	c3                   	ret    

80103f46 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f46:	55                   	push   %ebp
80103f47:	89 e5                	mov    %esp,%ebp
80103f49:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f5f:	8b 10                	mov    (%eax),%edx
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f66:	e8 dd cf ff ff       	call   80100f48 <filealloc>
80103f6b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f6e:	89 02                	mov    %eax,(%edx)
80103f70:	8b 45 08             	mov    0x8(%ebp),%eax
80103f73:	8b 00                	mov    (%eax),%eax
80103f75:	85 c0                	test   %eax,%eax
80103f77:	0f 84 c8 00 00 00    	je     80104045 <pipealloc+0xff>
80103f7d:	e8 c6 cf ff ff       	call   80100f48 <filealloc>
80103f82:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f85:	89 02                	mov    %eax,(%edx)
80103f87:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f8a:	8b 00                	mov    (%eax),%eax
80103f8c:	85 c0                	test   %eax,%eax
80103f8e:	0f 84 b1 00 00 00    	je     80104045 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f94:	e8 6e eb ff ff       	call   80102b07 <kalloc>
80103f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fa0:	75 05                	jne    80103fa7 <pipealloc+0x61>
    goto bad;
80103fa2:	e9 9e 00 00 00       	jmp    80104045 <pipealloc+0xff>
  p->readopen = 1;
80103fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103faa:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fb1:	00 00 00 
  p->writeopen = 1;
80103fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb7:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fbe:	00 00 00 
  p->nwrite = 0;
80103fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc4:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fcb:	00 00 00 
  p->nread = 0;
80103fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fd8:	00 00 00 
  initlock(&p->lock, "pipe");
80103fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fde:	c7 44 24 04 2c 93 10 	movl   $0x8010932c,0x4(%esp)
80103fe5:	80 
80103fe6:	89 04 24             	mov    %eax,(%esp)
80103fe9:	e8 8d 10 00 00       	call   8010507b <initlock>
  (*f0)->type = FD_PIPE;
80103fee:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff1:	8b 00                	mov    (%eax),%eax
80103ff3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffc:	8b 00                	mov    (%eax),%eax
80103ffe:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104002:	8b 45 08             	mov    0x8(%ebp),%eax
80104005:	8b 00                	mov    (%eax),%eax
80104007:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	8b 00                	mov    (%eax),%eax
80104010:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104013:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104016:	8b 45 0c             	mov    0xc(%ebp),%eax
80104019:	8b 00                	mov    (%eax),%eax
8010401b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104021:	8b 45 0c             	mov    0xc(%ebp),%eax
80104024:	8b 00                	mov    (%eax),%eax
80104026:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010402a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402d:	8b 00                	mov    (%eax),%eax
8010402f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104033:	8b 45 0c             	mov    0xc(%ebp),%eax
80104036:	8b 00                	mov    (%eax),%eax
80104038:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010403b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010403e:	b8 00 00 00 00       	mov    $0x0,%eax
80104043:	eb 42                	jmp    80104087 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104045:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104049:	74 0b                	je     80104056 <pipealloc+0x110>
    kfree((char*)p);
8010404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404e:	89 04 24             	mov    %eax,(%esp)
80104051:	e8 18 ea ff ff       	call   80102a6e <kfree>
  if(*f0)
80104056:	8b 45 08             	mov    0x8(%ebp),%eax
80104059:	8b 00                	mov    (%eax),%eax
8010405b:	85 c0                	test   %eax,%eax
8010405d:	74 0d                	je     8010406c <pipealloc+0x126>
    fileclose(*f0);
8010405f:	8b 45 08             	mov    0x8(%ebp),%eax
80104062:	8b 00                	mov    (%eax),%eax
80104064:	89 04 24             	mov    %eax,(%esp)
80104067:	e8 84 cf ff ff       	call   80100ff0 <fileclose>
  if(*f1)
8010406c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010406f:	8b 00                	mov    (%eax),%eax
80104071:	85 c0                	test   %eax,%eax
80104073:	74 0d                	je     80104082 <pipealloc+0x13c>
    fileclose(*f1);
80104075:	8b 45 0c             	mov    0xc(%ebp),%eax
80104078:	8b 00                	mov    (%eax),%eax
8010407a:	89 04 24             	mov    %eax,(%esp)
8010407d:	e8 6e cf ff ff       	call   80100ff0 <fileclose>
  return -1;
80104082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104087:	c9                   	leave  
80104088:	c3                   	ret    

80104089 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104089:	55                   	push   %ebp
8010408a:	89 e5                	mov    %esp,%ebp
8010408c:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010408f:	8b 45 08             	mov    0x8(%ebp),%eax
80104092:	89 04 24             	mov    %eax,(%esp)
80104095:	e8 02 10 00 00       	call   8010509c <acquire>
  if(writable){
8010409a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010409e:	74 1f                	je     801040bf <pipeclose+0x36>
    p->writeopen = 0;
801040a0:	8b 45 08             	mov    0x8(%ebp),%eax
801040a3:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801040aa:	00 00 00 
    wakeup(&p->nread);
801040ad:	8b 45 08             	mov    0x8(%ebp),%eax
801040b0:	05 34 02 00 00       	add    $0x234,%eax
801040b5:	89 04 24             	mov    %eax,(%esp)
801040b8:	e8 c9 0d 00 00       	call   80104e86 <wakeup>
801040bd:	eb 1d                	jmp    801040dc <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040bf:	8b 45 08             	mov    0x8(%ebp),%eax
801040c2:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040c9:	00 00 00 
    wakeup(&p->nwrite);
801040cc:	8b 45 08             	mov    0x8(%ebp),%eax
801040cf:	05 38 02 00 00       	add    $0x238,%eax
801040d4:	89 04 24             	mov    %eax,(%esp)
801040d7:	e8 aa 0d 00 00       	call   80104e86 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040dc:	8b 45 08             	mov    0x8(%ebp),%eax
801040df:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040e5:	85 c0                	test   %eax,%eax
801040e7:	75 25                	jne    8010410e <pipeclose+0x85>
801040e9:	8b 45 08             	mov    0x8(%ebp),%eax
801040ec:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040f2:	85 c0                	test   %eax,%eax
801040f4:	75 18                	jne    8010410e <pipeclose+0x85>
    release(&p->lock);
801040f6:	8b 45 08             	mov    0x8(%ebp),%eax
801040f9:	89 04 24             	mov    %eax,(%esp)
801040fc:	e8 fd 0f 00 00       	call   801050fe <release>
    kfree((char*)p);
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	89 04 24             	mov    %eax,(%esp)
80104107:	e8 62 e9 ff ff       	call   80102a6e <kfree>
8010410c:	eb 0b                	jmp    80104119 <pipeclose+0x90>
  } else
    release(&p->lock);
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 04 24             	mov    %eax,(%esp)
80104114:	e8 e5 0f 00 00       	call   801050fe <release>
}
80104119:	c9                   	leave  
8010411a:	c3                   	ret    

8010411b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010411b:	55                   	push   %ebp
8010411c:	89 e5                	mov    %esp,%ebp
8010411e:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104121:	8b 45 08             	mov    0x8(%ebp),%eax
80104124:	89 04 24             	mov    %eax,(%esp)
80104127:	e8 70 0f 00 00       	call   8010509c <acquire>
  for(i = 0; i < n; i++){
8010412c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104133:	e9 a9 00 00 00       	jmp    801041e1 <pipewrite+0xc6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104138:	eb 5a                	jmp    80104194 <pipewrite+0x79>
      if(p->readopen == 0 || thread->proc->killed){
8010413a:	8b 45 08             	mov    0x8(%ebp),%eax
8010413d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104143:	85 c0                	test   %eax,%eax
80104145:	74 10                	je     80104157 <pipewrite+0x3c>
80104147:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010414d:	8b 40 0c             	mov    0xc(%eax),%eax
80104150:	8b 40 18             	mov    0x18(%eax),%eax
80104153:	85 c0                	test   %eax,%eax
80104155:	74 15                	je     8010416c <pipewrite+0x51>
        release(&p->lock);
80104157:	8b 45 08             	mov    0x8(%ebp),%eax
8010415a:	89 04 24             	mov    %eax,(%esp)
8010415d:	e8 9c 0f 00 00       	call   801050fe <release>
        return -1;
80104162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104167:	e9 9f 00 00 00       	jmp    8010420b <pipewrite+0xf0>
      }
      wakeup(&p->nread);
8010416c:	8b 45 08             	mov    0x8(%ebp),%eax
8010416f:	05 34 02 00 00       	add    $0x234,%eax
80104174:	89 04 24             	mov    %eax,(%esp)
80104177:	e8 0a 0d 00 00       	call   80104e86 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010417c:	8b 45 08             	mov    0x8(%ebp),%eax
8010417f:	8b 55 08             	mov    0x8(%ebp),%edx
80104182:	81 c2 38 02 00 00    	add    $0x238,%edx
80104188:	89 44 24 04          	mov    %eax,0x4(%esp)
8010418c:	89 14 24             	mov    %edx,(%esp)
8010418f:	e8 fa 0b 00 00       	call   80104d8e <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
80104197:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010419d:	8b 45 08             	mov    0x8(%ebp),%eax
801041a0:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041a6:	05 00 02 00 00       	add    $0x200,%eax
801041ab:	39 c2                	cmp    %eax,%edx
801041ad:	74 8b                	je     8010413a <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041b8:	8d 48 01             	lea    0x1(%eax),%ecx
801041bb:	8b 55 08             	mov    0x8(%ebp),%edx
801041be:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041c4:	25 ff 01 00 00       	and    $0x1ff,%eax
801041c9:	89 c1                	mov    %eax,%ecx
801041cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d1:	01 d0                	add    %edx,%eax
801041d3:	0f b6 10             	movzbl (%eax),%edx
801041d6:	8b 45 08             	mov    0x8(%ebp),%eax
801041d9:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801041e7:	0f 8c 4b ff ff ff    	jl     80104138 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041ed:	8b 45 08             	mov    0x8(%ebp),%eax
801041f0:	05 34 02 00 00       	add    $0x234,%eax
801041f5:	89 04 24             	mov    %eax,(%esp)
801041f8:	e8 89 0c 00 00       	call   80104e86 <wakeup>
  release(&p->lock);
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	89 04 24             	mov    %eax,(%esp)
80104203:	e8 f6 0e 00 00       	call   801050fe <release>
  return n;
80104208:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010420b:	c9                   	leave  
8010420c:	c3                   	ret    

8010420d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010420d:	55                   	push   %ebp
8010420e:	89 e5                	mov    %esp,%ebp
80104210:	53                   	push   %ebx
80104211:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104214:	8b 45 08             	mov    0x8(%ebp),%eax
80104217:	89 04 24             	mov    %eax,(%esp)
8010421a:	e8 7d 0e 00 00       	call   8010509c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010421f:	eb 3d                	jmp    8010425e <piperead+0x51>
    if(thread->proc->killed){
80104221:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104227:	8b 40 0c             	mov    0xc(%eax),%eax
8010422a:	8b 40 18             	mov    0x18(%eax),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	74 15                	je     80104246 <piperead+0x39>
      release(&p->lock);
80104231:	8b 45 08             	mov    0x8(%ebp),%eax
80104234:	89 04 24             	mov    %eax,(%esp)
80104237:	e8 c2 0e 00 00       	call   801050fe <release>
      return -1;
8010423c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104241:	e9 b5 00 00 00       	jmp    801042fb <piperead+0xee>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104246:	8b 45 08             	mov    0x8(%ebp),%eax
80104249:	8b 55 08             	mov    0x8(%ebp),%edx
8010424c:	81 c2 34 02 00 00    	add    $0x234,%edx
80104252:	89 44 24 04          	mov    %eax,0x4(%esp)
80104256:	89 14 24             	mov    %edx,(%esp)
80104259:	e8 30 0b 00 00       	call   80104d8e <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010425e:	8b 45 08             	mov    0x8(%ebp),%eax
80104261:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104267:	8b 45 08             	mov    0x8(%ebp),%eax
8010426a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104270:	39 c2                	cmp    %eax,%edx
80104272:	75 0d                	jne    80104281 <piperead+0x74>
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	75 a0                	jne    80104221 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104288:	eb 4b                	jmp    801042d5 <piperead+0xc8>
    if(p->nread == p->nwrite)
8010428a:	8b 45 08             	mov    0x8(%ebp),%eax
8010428d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104293:	8b 45 08             	mov    0x8(%ebp),%eax
80104296:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010429c:	39 c2                	cmp    %eax,%edx
8010429e:	75 02                	jne    801042a2 <piperead+0x95>
      break;
801042a0:	eb 3b                	jmp    801042dd <piperead+0xd0>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801042a8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042ab:	8b 45 08             	mov    0x8(%ebp),%eax
801042ae:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042b4:	8d 48 01             	lea    0x1(%eax),%ecx
801042b7:	8b 55 08             	mov    0x8(%ebp),%edx
801042ba:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042c0:	25 ff 01 00 00       	and    $0x1ff,%eax
801042c5:	89 c2                	mov    %eax,%edx
801042c7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ca:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042cf:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d8:	3b 45 10             	cmp    0x10(%ebp),%eax
801042db:	7c ad                	jl     8010428a <piperead+0x7d>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042dd:	8b 45 08             	mov    0x8(%ebp),%eax
801042e0:	05 38 02 00 00       	add    $0x238,%eax
801042e5:	89 04 24             	mov    %eax,(%esp)
801042e8:	e8 99 0b 00 00       	call   80104e86 <wakeup>
  release(&p->lock);
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	89 04 24             	mov    %eax,(%esp)
801042f3:	e8 06 0e 00 00       	call   801050fe <release>
  return i;
801042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042fb:	83 c4 24             	add    $0x24,%esp
801042fe:	5b                   	pop    %ebx
801042ff:	5d                   	pop    %ebp
80104300:	c3                   	ret    

80104301 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104301:	55                   	push   %ebp
80104302:	89 e5                	mov    %esp,%ebp
80104304:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104307:	9c                   	pushf  
80104308:	58                   	pop    %eax
80104309:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010430c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010430f:	c9                   	leave  
80104310:	c3                   	ret    

80104311 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104311:	55                   	push   %ebp
80104312:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104314:	fb                   	sti    
}
80104315:	5d                   	pop    %ebp
80104316:	c3                   	ret    

80104317 <pinit>:

static struct proc *initproc;

void wakeup1(void *chan);

void pinit(void) {
80104317:	55                   	push   %ebp
80104318:	89 e5                	mov    %esp,%ebp
8010431a:	83 ec 18             	sub    $0x18,%esp
	initlock(&ptable.lock, "ptable");
8010431d:	c7 44 24 04 31 93 10 	movl   $0x80109331,0x4(%esp)
80104324:	80 
80104325:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010432c:	e8 4a 0d 00 00       	call   8010507b <initlock>

}
80104331:	c9                   	leave  
80104332:	c3                   	ret    

80104333 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80104333:	55                   	push   %ebp
80104334:	89 e5                	mov    %esp,%ebp
80104336:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	struct thread *threads;
	char *sp;

	acquire(&ptable.lock);
80104339:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104340:	e8 57 0d 00 00       	call   8010509c <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104345:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010434c:	e9 8e 00 00 00       	jmp    801043df <allocproc+0xac>
		if (p->state == UNUSED)
80104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104354:	8b 40 08             	mov    0x8(%eax),%eax
80104357:	85 c0                	test   %eax,%eax
80104359:	75 7d                	jne    801043d8 <allocproc+0xa5>
			goto found;
8010435b:	90                   	nop

	release(&ptable.lock);
	return 0;

	found: p->state = EMBRYO;
8010435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	threads = p->threads;
80104366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104369:	83 c0 70             	add    $0x70,%eax
8010436c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->numOfThreads = 0;
8010436f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104372:	c7 80 30 02 00 00 00 	movl   $0x0,0x230(%eax)
80104379:	00 00 00 

	threads->state = EMBRYO;
8010437c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010437f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	threads->proc = p;
80104386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104389:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438c:	89 50 0c             	mov    %edx,0xc(%eax)

	p->pid = nextpid++;
8010438f:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104394:	8d 50 01             	lea    0x1(%eax),%edx
80104397:	89 15 20 c0 10 80    	mov    %edx,0x8010c020
8010439d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a0:	89 42 0c             	mov    %eax,0xc(%edx)
	threads->pid = nextpid++;
801043a3:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801043a8:	8d 50 01             	lea    0x1(%eax),%edx
801043ab:	89 15 20 c0 10 80    	mov    %edx,0x8010c020
801043b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043b4:	89 42 08             	mov    %eax,0x8(%edx)

	release(&ptable.lock);
801043b7:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043be:	e8 3b 0d 00 00       	call   801050fe <release>

	// Allocate kernel stack.
	if ((threads->kstack = kalloc()) == 0) {
801043c3:	e8 3f e7 ff ff       	call   80102b07 <kalloc>
801043c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043cb:	89 02                	mov    %eax,(%edx)
801043cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043d0:	8b 00                	mov    (%eax),%eax
801043d2:	85 c0                	test   %eax,%eax
801043d4:	75 44                	jne    8010441a <allocproc+0xe7>
801043d6:	eb 27                	jmp    801043ff <allocproc+0xcc>
	struct proc *p;
	struct thread *threads;
	char *sp;

	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d8:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
801043df:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
801043e6:	0f 82 65 ff ff ff    	jb     80104351 <allocproc+0x1e>
		if (p->state == UNUSED)
			goto found;

	release(&ptable.lock);
801043ec:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043f3:	e8 06 0d 00 00       	call   801050fe <release>
	return 0;
801043f8:	b8 00 00 00 00       	mov    $0x0,%eax
801043fd:	eb 7f                	jmp    8010447e <allocproc+0x14b>

	release(&ptable.lock);

	// Allocate kernel stack.
	if ((threads->kstack = kalloc()) == 0) {
		p->state = UNUSED;
801043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		threads->state = UNUSED;
80104409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010440c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		return 0;
80104413:	b8 00 00 00 00       	mov    $0x0,%eax
80104418:	eb 64                	jmp    8010447e <allocproc+0x14b>
	}

	sp = threads->kstack + KSTACKSIZE;
8010441a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010441d:	8b 00                	mov    (%eax),%eax
8010441f:	05 00 10 00 00       	add    $0x1000,%eax
80104424:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Leave room for trap frame.
	sp -= sizeof *threads->tf;
80104427:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
	threads->tf = (struct trapframe*) sp;
8010442b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104431:	89 50 10             	mov    %edx,0x10(%eax)

	// which returns to trapret.
	// Set up new context to start executing at forkret,

	sp -= 4;
80104434:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
	*(uint*) sp = (uint) trapret;
80104438:	ba 9e 70 10 80       	mov    $0x8010709e,%edx
8010443d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104440:	89 10                	mov    %edx,(%eax)

	sp -= sizeof *threads->context;
80104442:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
	threads->context = (struct context*) sp;
80104446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104449:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010444c:	89 50 14             	mov    %edx,0x14(%eax)
	memset(threads->context, 0, sizeof *threads->context);
8010444f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104452:	8b 40 14             	mov    0x14(%eax),%eax
80104455:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010445c:	00 
8010445d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104464:	00 
80104465:	89 04 24             	mov    %eax,(%esp)
80104468:	e8 34 16 00 00       	call   80105aa1 <memset>
	threads->context->eip = (uint) forkret;
8010446d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104470:	8b 40 14             	mov    0x14(%eax),%eax
80104473:	ba 62 4d 10 80       	mov    $0x80104d62,%edx
80104478:	89 50 10             	mov    %edx,0x10(%eax)

	return p;
8010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010447e:	c9                   	leave  
8010447f:	c3                   	ret    

80104480 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void userinit(void) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	83 ec 28             	sub    $0x28,%esp

	struct proc *p;
	extern char _binary_initcode_start[], _binary_initcode_size[];
	struct kthread_mutex_t *m;

	for (m = mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++) {
80104486:	c7 45 f4 c0 c6 11 80 	movl   $0x8011c6c0,-0xc(%ebp)
8010448d:	eb 0d                	jmp    8010449c <userinit+0x1c>
		m->state = UNUSED_MUTEX;
8010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	struct proc *p;
	extern char _binary_initcode_start[], _binary_initcode_size[];
	struct kthread_mutex_t *m;

	for (m = mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++) {
80104498:	83 45 f4 58          	addl   $0x58,-0xc(%ebp)
8010449c:	81 7d f4 c0 dc 11 80 	cmpl   $0x8011dcc0,-0xc(%ebp)
801044a3:	72 ea                	jb     8010448f <userinit+0xf>
		m->state = UNUSED_MUTEX;

	}
	p = allocproc();
801044a5:	e8 89 fe ff ff       	call   80104333 <allocproc>
801044aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	initproc = p;
801044ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044b0:	a3 68 c6 10 80       	mov    %eax,0x8010c668
	if ((p->pgdir = setupkvm()) == 0)
801044b5:	e8 2e 43 00 00       	call   801087e8 <setupkvm>
801044ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044bd:	89 42 04             	mov    %eax,0x4(%edx)
801044c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044c3:	8b 40 04             	mov    0x4(%eax),%eax
801044c6:	85 c0                	test   %eax,%eax
801044c8:	75 0c                	jne    801044d6 <userinit+0x56>
		panic("userinit: out of memory?");
801044ca:	c7 04 24 38 93 10 80 	movl   $0x80109338,(%esp)
801044d1:	e8 64 c0 ff ff       	call   8010053a <panic>
	inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
801044d6:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044de:	8b 40 04             	mov    0x4(%eax),%eax
801044e1:	89 54 24 08          	mov    %edx,0x8(%esp)
801044e5:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801044ec:	80 
801044ed:	89 04 24             	mov    %eax,(%esp)
801044f0:	e8 50 45 00 00       	call   80108a45 <inituvm>
	p->sz = PGSIZE;
801044f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044f8:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
	memset(p->threads->tf, 0, sizeof(*p->threads->tf));
801044fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104501:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104507:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010450e:	00 
8010450f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104516:	00 
80104517:	89 04 24             	mov    %eax,(%esp)
8010451a:	e8 82 15 00 00       	call   80105aa1 <memset>
	p->threads->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010451f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104522:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104528:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
	p->threads->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010452e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104531:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104537:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
	p->threads->tf->es = p->threads->tf->ds;
8010453d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104540:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104546:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104549:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
8010454f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104553:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->threads->tf->ss = p->threads->tf->ds;
80104557:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010455a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104560:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104563:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
80104569:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010456d:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->threads->tf->eflags = FL_IF;
80104571:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104574:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010457a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->threads->tf->esp = PGSIZE;
80104581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104584:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010458a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->threads->tf->eip = 0;  // beginning of initcode.S
80104591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104594:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010459a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

	safestrcpy(p->name, "initcode", sizeof(p->name));
801045a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045a4:	83 c0 60             	add    $0x60,%eax
801045a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045ae:	00 
801045af:	c7 44 24 04 51 93 10 	movl   $0x80109351,0x4(%esp)
801045b6:	80 
801045b7:	89 04 24             	mov    %eax,(%esp)
801045ba:	e8 02 17 00 00       	call   80105cc1 <safestrcpy>
	p->cwd = namei("/");
801045bf:	c7 04 24 5a 93 10 80 	movl   $0x8010935a,(%esp)
801045c6:	e8 60 de ff ff       	call   8010242b <namei>
801045cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045ce:	89 42 5c             	mov    %eax,0x5c(%edx)

	p->numOfThreads = 1;
801045d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045d4:	c7 80 30 02 00 00 01 	movl   $0x1,0x230(%eax)
801045db:	00 00 00 

	p->state = RUNNABLE;
801045de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045e1:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
	p->threads->state = RUNNABLE;
801045e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045eb:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
}
801045f2:	c9                   	leave  
801045f3:	c3                   	ret    

801045f4 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n) {
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	83 ec 28             	sub    $0x28,%esp
	uint sz;
	struct proc *proc = thread->proc;
801045fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104600:	8b 40 0c             	mov    0xc(%eax),%eax
80104603:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sz = proc->sz;
80104606:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104609:	8b 00                	mov    (%eax),%eax
8010460b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (n > 0) {
8010460e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104612:	7e 31                	jle    80104645 <growproc+0x51>
		if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104614:	8b 55 08             	mov    0x8(%ebp),%edx
80104617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461a:	01 c2                	add    %eax,%edx
8010461c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010461f:	8b 40 04             	mov    0x4(%eax),%eax
80104622:	89 54 24 08          	mov    %edx,0x8(%esp)
80104626:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104629:	89 54 24 04          	mov    %edx,0x4(%esp)
8010462d:	89 04 24             	mov    %eax,(%esp)
80104630:	e8 86 45 00 00       	call   80108bbb <allocuvm>
80104635:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010463c:	75 3e                	jne    8010467c <growproc+0x88>
			return -1;
8010463e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104643:	eb 52                	jmp    80104697 <growproc+0xa3>
	} else if (n < 0) {
80104645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104649:	79 31                	jns    8010467c <growproc+0x88>
		if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010464b:	8b 55 08             	mov    0x8(%ebp),%edx
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	01 c2                	add    %eax,%edx
80104653:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104656:	8b 40 04             	mov    0x4(%eax),%eax
80104659:	89 54 24 08          	mov    %edx,0x8(%esp)
8010465d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104660:	89 54 24 04          	mov    %edx,0x4(%esp)
80104664:	89 04 24             	mov    %eax,(%esp)
80104667:	e8 29 46 00 00       	call   80108c95 <deallocuvm>
8010466c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010466f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104673:	75 07                	jne    8010467c <growproc+0x88>
			return -1;
80104675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467a:	eb 1b                	jmp    80104697 <growproc+0xa3>
	}
	proc->sz = sz;
8010467c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010467f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104682:	89 10                	mov    %edx,(%eax)
	switchuvm(thread);
80104684:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468a:	89 04 24             	mov    %eax,(%esp)
8010468d:	e8 47 42 00 00       	call   801088d9 <switchuvm>
	return 0;
80104692:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104697:	c9                   	leave  
80104698:	c3                   	ret    

80104699 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void) {
80104699:	55                   	push   %ebp
8010469a:	89 e5                	mov    %esp,%ebp
8010469c:	57                   	push   %edi
8010469d:	56                   	push   %esi
8010469e:	53                   	push   %ebx
8010469f:	83 ec 3c             	sub    $0x3c,%esp
	int i, pid;
	struct proc *np;
	struct proc *proc = thread->proc;
801046a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a8:	8b 40 0c             	mov    0xc(%eax),%eax
801046ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct thread *nt;

	// Allocate process.
	if ((np = allocproc()) == 0)
801046ae:	e8 80 fc ff ff       	call   80104333 <allocproc>
801046b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801046b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801046ba:	75 0a                	jne    801046c6 <fork+0x2d>
		return -1;
801046bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c1:	e9 7e 01 00 00       	jmp    80104844 <fork+0x1ab>

	nt = np->threads;
801046c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046c9:	83 c0 70             	add    $0x70,%eax
801046cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	// Copy process state from p.

	if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
801046cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d2:	8b 10                	mov    (%eax),%edx
801046d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d7:	8b 40 04             	mov    0x4(%eax),%eax
801046da:	89 54 24 04          	mov    %edx,0x4(%esp)
801046de:	89 04 24             	mov    %eax,(%esp)
801046e1:	e8 4b 47 00 00       	call   80108e31 <copyuvm>
801046e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046e9:	89 42 04             	mov    %eax,0x4(%edx)
801046ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ef:	8b 40 04             	mov    0x4(%eax),%eax
801046f2:	85 c0                	test   %eax,%eax
801046f4:	75 34                	jne    8010472a <fork+0x91>
		kfree(nt->kstack);
801046f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046f9:	8b 00                	mov    (%eax),%eax
801046fb:	89 04 24             	mov    %eax,(%esp)
801046fe:	e8 6b e3 ff ff       	call   80102a6e <kfree>

		nt->kstack = 0;
80104703:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		np->state = UNUSED;
8010470c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010470f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		nt->state = UNUSED;
80104716:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		return -1;
80104720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104725:	e9 1a 01 00 00       	jmp    80104844 <fork+0x1ab>
	}

	np->sz = proc->sz;
8010472a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472d:	8b 10                	mov    (%eax),%edx
8010472f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104732:	89 10                	mov    %edx,(%eax)
	nt->proc = np;
80104734:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104737:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010473a:	89 50 0c             	mov    %edx,0xc(%eax)
	np->parent = proc;
8010473d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104740:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104743:	89 50 10             	mov    %edx,0x10(%eax)
	*nt->tf = *thread->tf;
80104746:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104749:	8b 50 10             	mov    0x10(%eax),%edx
8010474c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104752:	8b 40 10             	mov    0x10(%eax),%eax
80104755:	89 c3                	mov    %eax,%ebx
80104757:	b8 13 00 00 00       	mov    $0x13,%eax
8010475c:	89 d7                	mov    %edx,%edi
8010475e:	89 de                	mov    %ebx,%esi
80104760:	89 c1                	mov    %eax,%ecx
80104762:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	// Clear %eax so that fork returns 0 in the child.
	nt->tf->eax = 0;
80104764:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104767:	8b 40 10             	mov    0x10(%eax),%eax
8010476a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	for (i = 0; i < NOFILE; i++)
80104771:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104778:	eb 37                	jmp    801047b1 <fork+0x118>
		if (proc->ofile[i])
8010477a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010477d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104780:	83 c2 04             	add    $0x4,%edx
80104783:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104787:	85 c0                	test   %eax,%eax
80104789:	74 22                	je     801047ad <fork+0x114>
			np->ofile[i] = filedup(proc->ofile[i]);
8010478b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010478e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104791:	83 c2 04             	add    $0x4,%edx
80104794:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104798:	89 04 24             	mov    %eax,(%esp)
8010479b:	e8 08 c8 ff ff       	call   80100fa8 <filedup>
801047a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047a6:	83 c1 04             	add    $0x4,%ecx
801047a9:	89 44 8a 0c          	mov    %eax,0xc(%edx,%ecx,4)
	*nt->tf = *thread->tf;

	// Clear %eax so that fork returns 0 in the child.
	nt->tf->eax = 0;

	for (i = 0; i < NOFILE; i++)
801047ad:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047b1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047b5:	7e c3                	jle    8010477a <fork+0xe1>
		if (proc->ofile[i])
			np->ofile[i] = filedup(proc->ofile[i]);
	np->cwd = idup(proc->cwd);
801047b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ba:	8b 40 5c             	mov    0x5c(%eax),%eax
801047bd:	89 04 24             	mov    %eax,(%esp)
801047c0:	e8 86 d0 ff ff       	call   8010184b <idup>
801047c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047c8:	89 42 5c             	mov    %eax,0x5c(%edx)

	safestrcpy(np->name, proc->name, sizeof(proc->name));
801047cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ce:	8d 50 60             	lea    0x60(%eax),%edx
801047d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047d4:	83 c0 60             	add    $0x60,%eax
801047d7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801047de:	00 
801047df:	89 54 24 04          	mov    %edx,0x4(%esp)
801047e3:	89 04 24             	mov    %eax,(%esp)
801047e6:	e8 d6 14 00 00       	call   80105cc1 <safestrcpy>

	pid = np->pid;
801047eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047ee:	8b 40 0c             	mov    0xc(%eax),%eax
801047f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	nt->pid = nextpid++;
801047f4:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801047f9:	8d 50 01             	lea    0x1(%eax),%edx
801047fc:	89 15 20 c0 10 80    	mov    %edx,0x8010c020
80104802:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104805:	89 42 08             	mov    %eax,0x8(%edx)

	// lock to force the compiler to emit the np->state write last.
	acquire(&ptable.lock);
80104808:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010480f:	e8 88 08 00 00       	call   8010509c <acquire>
	np->numOfThreads = 1;
80104814:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104817:	c7 80 30 02 00 00 01 	movl   $0x1,0x230(%eax)
8010481e:	00 00 00 
	np->state = RUNNABLE;
80104821:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104824:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
	nt->state = RUNNABLE;
8010482b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010482e:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	release(&ptable.lock);
80104835:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010483c:	e8 bd 08 00 00       	call   801050fe <release>
	//cprintf("num o tred : %d \n", proc->numOfThreads);
	return pid;
80104841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104844:	83 c4 3c             	add    $0x3c,%esp
80104847:	5b                   	pop    %ebx
80104848:	5e                   	pop    %esi
80104849:	5f                   	pop    %edi
8010484a:	5d                   	pop    %ebp
8010484b:	c3                   	ret    

8010484c <procIsAlive>:

int procIsAlive() {
8010484c:	55                   	push   %ebp
8010484d:	89 e5                	mov    %esp,%ebp
	return thread->proc->numOfThreads > 0;
8010484f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104855:	8b 40 0c             	mov    0xc(%eax),%eax
80104858:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
8010485e:	85 c0                	test   %eax,%eax
80104860:	0f 9f c0             	setg   %al
80104863:	0f b6 c0             	movzbl %al,%eax
}
80104866:	5d                   	pop    %ebp
80104867:	c3                   	ret    

80104868 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void) {
80104868:	55                   	push   %ebp
80104869:	89 e5                	mov    %esp,%ebp
8010486b:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	struct proc *proc = thread->proc;
8010486e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104874:	8b 40 0c             	mov    0xc(%eax),%eax
80104877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct thread *t;
	int fd;

	if (proc == initproc)
8010487a:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010487f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
80104882:	75 0c                	jne    80104890 <exit+0x28>
		panic("init exiting");
80104884:	c7 04 24 5c 93 10 80 	movl   $0x8010935c,(%esp)
8010488b:	e8 aa bc ff ff       	call   8010053a <panic>

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
80104890:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104897:	eb 3b                	jmp    801048d4 <exit+0x6c>
		if (proc->ofile[fd]) {
80104899:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010489c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010489f:	83 c2 04             	add    $0x4,%edx
801048a2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048a6:	85 c0                	test   %eax,%eax
801048a8:	74 26                	je     801048d0 <exit+0x68>
			fileclose(proc->ofile[fd]);
801048aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
801048b0:	83 c2 04             	add    $0x4,%edx
801048b3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048b7:	89 04 24             	mov    %eax,(%esp)
801048ba:	e8 31 c7 ff ff       	call   80100ff0 <fileclose>
			proc->ofile[fd] = 0;
801048bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801048c5:	83 c2 04             	add    $0x4,%edx
801048c8:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801048cf:	00 

	if (proc == initproc)
		panic("init exiting");

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
801048d0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801048d4:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
801048d8:	7e bf                	jle    80104899 <exit+0x31>
			fileclose(proc->ofile[fd]);
			proc->ofile[fd] = 0;
		}
	}

	begin_op();
801048da:	e8 56 eb ff ff       	call   80103435 <begin_op>
	iput(proc->cwd);
801048df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048e2:	8b 40 5c             	mov    0x5c(%eax),%eax
801048e5:	89 04 24             	mov    %eax,(%esp)
801048e8:	e8 43 d1 ff ff       	call   80101a30 <iput>
	end_op();
801048ed:	e8 c7 eb ff ff       	call   801034b9 <end_op>
	proc->cwd = 0;
801048f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048f5:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)

	acquire(&ptable.lock);
801048fc:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104903:	e8 94 07 00 00       	call   8010509c <acquire>

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);
80104908:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010490b:	8b 40 10             	mov    0x10(%eax),%eax
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 13 05 00 00       	call   80104e29 <wakeup1>

	// Pass abandoned children to init.
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104916:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010491d:	eb 36                	jmp    80104955 <exit+0xed>
		if (p->parent == proc) {
8010491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104922:	8b 40 10             	mov    0x10(%eax),%eax
80104925:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104928:	75 24                	jne    8010494e <exit+0xe6>
			p->parent = initproc;
8010492a:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104933:	89 50 10             	mov    %edx,0x10(%eax)
			if (p->state == ZOMBIE)
80104936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104939:	8b 40 08             	mov    0x8(%eax),%eax
8010493c:	83 f8 05             	cmp    $0x5,%eax
8010493f:	75 0d                	jne    8010494e <exit+0xe6>
				wakeup1(initproc);
80104941:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104946:	89 04 24             	mov    %eax,(%esp)
80104949:	e8 db 04 00 00       	call   80104e29 <wakeup1>

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);

	// Pass abandoned children to init.
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010494e:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104955:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
8010495c:	72 c1                	jb     8010491f <exit+0xb7>
		}
	}

	;

	proc->killed = 1;
8010495e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104961:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
	for (t = proc->threads; t < &proc->threads[NTHREAD]; t++) {
80104968:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010496b:	83 c0 70             	add    $0x70,%eax
8010496e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104971:	eb 46                	jmp    801049b9 <exit+0x151>
		if (t->state != RUNNING && t->state != UNUSED && t != thread) {
80104973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104976:	8b 40 04             	mov    0x4(%eax),%eax
80104979:	83 f8 04             	cmp    $0x4,%eax
8010497c:	74 37                	je     801049b5 <exit+0x14d>
8010497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104981:	8b 40 04             	mov    0x4(%eax),%eax
80104984:	85 c0                	test   %eax,%eax
80104986:	74 2d                	je     801049b5 <exit+0x14d>
80104988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104991:	74 22                	je     801049b5 <exit+0x14d>
			t->state = ZOMBIE;
80104993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104996:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)
			if (thread->proc->numOfThreads > 0)
8010499d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a3:	8b 40 0c             	mov    0xc(%eax),%eax
801049a6:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
801049ac:	85 c0                	test   %eax,%eax
801049ae:	7e 05                	jle    801049b5 <exit+0x14d>
				decreaseNumOfThreadsAlive();
801049b0:	e8 26 09 00 00       	call   801052db <decreaseNumOfThreadsAlive>
	}

	;

	proc->killed = 1;
	for (t = proc->threads; t < &proc->threads[NTHREAD]; t++) {
801049b5:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
801049b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049bc:	05 30 02 00 00       	add    $0x230,%eax
801049c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801049c4:	77 ad                	ja     80104973 <exit+0x10b>

		}
	}

	// Jump into the scheduler, never to return.
	if (thread->proc->numOfThreads > 0)
801049c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cc:	8b 40 0c             	mov    0xc(%eax),%eax
801049cf:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
801049d5:	85 c0                	test   %eax,%eax
801049d7:	7e 05                	jle    801049de <exit+0x176>
		decreaseNumOfThreadsAlive();
801049d9:	e8 fd 08 00 00       	call   801052db <decreaseNumOfThreadsAlive>
	thread->state = ZOMBIE;
801049de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e4:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)
	if (!procIsAlive())
801049eb:	e8 5c fe ff ff       	call   8010484c <procIsAlive>
801049f0:	85 c0                	test   %eax,%eax
801049f2:	75 0a                	jne    801049fe <exit+0x196>
		proc->state = ZOMBIE;
801049f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049f7:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)

	sched();
801049fe:	e8 5f 02 00 00       	call   80104c62 <sched>
	panic("zombie exit");
80104a03:	c7 04 24 69 93 10 80 	movl   $0x80109369,(%esp)
80104a0a:	e8 2b bb ff ff       	call   8010053a <panic>

80104a0f <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void) {
80104a0f:	55                   	push   %ebp
80104a10:	89 e5                	mov    %esp,%ebp
80104a12:	83 ec 38             	sub    $0x38,%esp
	struct proc *p;
	int havekids, pid;
	struct proc *proc = thread->proc;
80104a15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct thread *t;

	acquire(&ptable.lock);
80104a21:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a28:	e8 6f 06 00 00       	call   8010509c <acquire>
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
80104a2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a34:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104a3b:	e9 fd 00 00 00       	jmp    80104b3d <wait+0x12e>
			if (p->parent != proc)
80104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a43:	8b 40 10             	mov    0x10(%eax),%eax
80104a46:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104a49:	74 05                	je     80104a50 <wait+0x41>
				continue;
80104a4b:	e9 e6 00 00 00       	jmp    80104b36 <wait+0x127>
			havekids = 1;
80104a50:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if (p->state == ZOMBIE) {
80104a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5a:	8b 40 08             	mov    0x8(%eax),%eax
80104a5d:	83 f8 05             	cmp    $0x5,%eax
80104a60:	0f 85 d0 00 00 00    	jne    80104b36 <wait+0x127>
				// Found one.

				for (t = proc->threads; t < &proc->threads[NTHREAD]; t++) {
80104a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a69:	83 c0 70             	add    $0x70,%eax
80104a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a6f:	eb 61                	jmp    80104ad2 <wait+0xc3>

					if (t->state == ZOMBIE) {
80104a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a74:	8b 40 04             	mov    0x4(%eax),%eax
80104a77:	83 f8 05             	cmp    $0x5,%eax
80104a7a:	75 52                	jne    80104ace <wait+0xbf>
						t->chan = 0;
80104a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a7f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
						t->context = 0;
80104a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a89:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
						t->pid = 0;
80104a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						t->proc = 0;
80104a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						t->state = 0;
80104aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
						// t->tf = 0;
						t->state = UNUSED;
80104aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
						if (t->kstack)
80104ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104abb:	8b 00                	mov    (%eax),%eax
80104abd:	85 c0                	test   %eax,%eax
80104abf:	74 0d                	je     80104ace <wait+0xbf>
							kfree(t->kstack);
80104ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ac4:	8b 00                	mov    (%eax),%eax
80104ac6:	89 04 24             	mov    %eax,(%esp)
80104ac9:	e8 a0 df ff ff       	call   80102a6e <kfree>
				continue;
			havekids = 1;
			if (p->state == ZOMBIE) {
				// Found one.

				for (t = proc->threads; t < &proc->threads[NTHREAD]; t++) {
80104ace:	83 45 ec 1c          	addl   $0x1c,-0x14(%ebp)
80104ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ad5:	05 30 02 00 00       	add    $0x230,%eax
80104ada:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104add:	77 92                	ja     80104a71 <wait+0x62>
						if (t->kstack)
							kfree(t->kstack);
					}
				}

				pid = p->pid;
80104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

				freevm(p->pgdir);
80104ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aeb:	8b 40 04             	mov    0x4(%eax),%eax
80104aee:	89 04 24             	mov    %eax,(%esp)
80104af1:	e8 5b 42 00 00       	call   80108d51 <freevm>
				p->state = UNUSED;
80104af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				p->pid = 0;
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->parent = 0;
80104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->name[0] = 0;
80104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b17:	c6 40 60 00          	movb   $0x0,0x60(%eax)
				p->killed = 0;
80104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
				release(&ptable.lock);
80104b25:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b2c:	e8 cd 05 00 00       	call   801050fe <release>
				return pid;
80104b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b34:	eb 4f                	jmp    80104b85 <wait+0x176>

	acquire(&ptable.lock);
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b36:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104b3d:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104b44:	0f 82 f6 fe ff ff    	jb     80104a40 <wait+0x31>
				return pid;
			}
		}

		// No point waiting if we don't have any children.
		if (!havekids || proc->killed) {
80104b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b4e:	74 0a                	je     80104b5a <wait+0x14b>
80104b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b53:	8b 40 18             	mov    0x18(%eax),%eax
80104b56:	85 c0                	test   %eax,%eax
80104b58:	74 13                	je     80104b6d <wait+0x15e>
			release(&ptable.lock);
80104b5a:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b61:	e8 98 05 00 00       	call   801050fe <release>
			return -1;
80104b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b6b:	eb 18                	jmp    80104b85 <wait+0x176>
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b6d:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104b74:	80 
80104b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b78:	89 04 24             	mov    %eax,(%esp)
80104b7b:	e8 0e 02 00 00       	call   80104d8e <sleep>
	}
80104b80:	e9 a8 fe ff ff       	jmp    80104a2d <wait+0x1e>
	return -1;
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    

80104b87 <scheduler>:
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void scheduler(void) {
80104b87:	55                   	push   %ebp
80104b88:	89 e5                	mov    %esp,%ebp
80104b8a:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	struct thread *t;

	for (;;) {
		// Enable interrupts on this processor.
		sti();
80104b8d:	e8 7f f7 ff ff       	call   80104311 <sti>

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
80104b92:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b99:	e8 fe 04 00 00       	call   8010509c <acquire>
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b9e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ba5:	e9 9a 00 00 00       	jmp    80104c44 <scheduler+0xbd>

			if ((p->numOfThreads > 0) && (p->state != RUNNABLE)) {
80104baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bad:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	7e 0d                	jle    80104bc4 <scheduler+0x3d>
80104bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bba:	8b 40 08             	mov    0x8(%eax),%eax
80104bbd:	83 f8 03             	cmp    $0x3,%eax
80104bc0:	74 02                	je     80104bc4 <scheduler+0x3d>
				continue;
80104bc2:	eb 79                	jmp    80104c3d <scheduler+0xb6>
			}

			for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc7:	83 c0 70             	add    $0x70,%eax
80104bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104bcd:	eb 61                	jmp    80104c30 <scheduler+0xa9>

				if (t->state != RUNNABLE)
80104bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bd2:	8b 40 04             	mov    0x4(%eax),%eax
80104bd5:	83 f8 03             	cmp    $0x3,%eax
80104bd8:	74 02                	je     80104bdc <scheduler+0x55>
					continue;
80104bda:	eb 50                	jmp    80104c2c <scheduler+0xa5>
				// Switch to chosen process.  It is the process's job
				// to release ptable.lock and then reacquire it
				// before jumping back to us.
				thread = t;
80104bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdf:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
				switchuvm(thread);
80104be5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104beb:	89 04 24             	mov    %eax,(%esp)
80104bee:	e8 e6 3c 00 00       	call   801088d9 <switchuvm>
				t->state = RUNNING;
80104bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf6:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
				swtch(&cpu->scheduler, thread->context);
80104bfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c03:	8b 40 14             	mov    0x14(%eax),%eax
80104c06:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c0d:	83 c2 04             	add    $0x4,%edx
80104c10:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c14:	89 14 24             	mov    %edx,(%esp)
80104c17:	e8 16 11 00 00       	call   80105d32 <swtch>
				switchkvm();
80104c1c:	e8 9b 3c 00 00       	call   801088bc <switchkvm>

				// Process is done running for now.
				// It should have changed its p->state before coming back.
				thread = 0;
80104c21:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c28:	00 00 00 00 

			if ((p->numOfThreads > 0) && (p->state != RUNNABLE)) {
				continue;
			}

			for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104c2c:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	05 30 02 00 00       	add    $0x230,%eax
80104c38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104c3b:	77 92                	ja     80104bcf <scheduler+0x48>
		// Enable interrupts on this processor.
		sti();

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c3d:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104c44:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104c4b:	0f 82 59 ff ff ff    	jb     80104baa <scheduler+0x23>
				thread = 0;
			}

		}

		release(&ptable.lock);
80104c51:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c58:	e8 a1 04 00 00       	call   801050fe <release>

	}
80104c5d:	e9 2b ff ff ff       	jmp    80104b8d <scheduler+0x6>

80104c62 <sched>:
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void sched(void) {
80104c62:	55                   	push   %ebp
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	83 ec 28             	sub    $0x28,%esp
	int intena;

	if (!holding(&ptable.lock))
80104c68:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c6f:	e8 52 05 00 00       	call   801051c6 <holding>
80104c74:	85 c0                	test   %eax,%eax
80104c76:	75 0c                	jne    80104c84 <sched+0x22>
		panic("sched ptable.lock");
80104c78:	c7 04 24 75 93 10 80 	movl   $0x80109375,(%esp)
80104c7f:	e8 b6 b8 ff ff       	call   8010053a <panic>
	if (cpu->ncli != 1){
80104c84:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c8a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c90:	83 f8 01             	cmp    $0x1,%eax
80104c93:	74 28                	je     80104cbd <sched+0x5b>
		cprintf("%d  \n",cpu->ncli);
80104c95:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c9b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ca5:	c7 04 24 87 93 10 80 	movl   $0x80109387,(%esp)
80104cac:	e8 ef b6 ff ff       	call   801003a0 <cprintf>
		panic("sched locks");
80104cb1:	c7 04 24 8d 93 10 80 	movl   $0x8010938d,(%esp)
80104cb8:	e8 7d b8 ff ff       	call   8010053a <panic>
	}
	if (thread->state == RUNNING)
80104cbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc3:	8b 40 04             	mov    0x4(%eax),%eax
80104cc6:	83 f8 04             	cmp    $0x4,%eax
80104cc9:	75 0c                	jne    80104cd7 <sched+0x75>
		panic("sched running");
80104ccb:	c7 04 24 99 93 10 80 	movl   $0x80109399,(%esp)
80104cd2:	e8 63 b8 ff ff       	call   8010053a <panic>
	if (readeflags() & FL_IF)
80104cd7:	e8 25 f6 ff ff       	call   80104301 <readeflags>
80104cdc:	25 00 02 00 00       	and    $0x200,%eax
80104ce1:	85 c0                	test   %eax,%eax
80104ce3:	74 0c                	je     80104cf1 <sched+0x8f>
		panic("sched interruptible");
80104ce5:	c7 04 24 a7 93 10 80 	movl   $0x801093a7,(%esp)
80104cec:	e8 49 b8 ff ff       	call   8010053a <panic>
	intena = cpu->intena;
80104cf1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	swtch(&thread->context, cpu->scheduler);
80104d00:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d06:	8b 40 04             	mov    0x4(%eax),%eax
80104d09:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d10:	83 c2 14             	add    $0x14,%edx
80104d13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d17:	89 14 24             	mov    %edx,(%esp)
80104d1a:	e8 13 10 00 00       	call   80105d32 <swtch>
	cpu->intena = intena;
80104d1f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d28:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d2e:	c9                   	leave  
80104d2f:	c3                   	ret    

80104d30 <yield>:

// Give up the CPU for one scheduling round.
void yield(void) {
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 18             	sub    $0x18,%esp

	acquire(&ptable.lock);  //DOC: yieldlock
80104d36:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d3d:	e8 5a 03 00 00       	call   8010509c <acquire>
	thread->state = RUNNABLE;
80104d42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d48:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

	sched();
80104d4f:	e8 0e ff ff ff       	call   80104c62 <sched>

	release(&ptable.lock);
80104d54:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d5b:	e8 9e 03 00 00       	call   801050fe <release>
}
80104d60:	c9                   	leave  
80104d61:	c3                   	ret    

80104d62 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80104d62:	55                   	push   %ebp
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	83 ec 18             	sub    $0x18,%esp
	static int first = 1;
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);
80104d68:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d6f:	e8 8a 03 00 00       	call   801050fe <release>

	if (first) {
80104d74:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104d79:	85 c0                	test   %eax,%eax
80104d7b:	74 0f                	je     80104d8c <forkret+0x2a>
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot
		// be run from main().
		first = 0;
80104d7d:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104d84:	00 00 00 
		initlog();
80104d87:	e8 9b e4 ff ff       	call   80103227 <initlog>
	}

	// Return to "caller", actually trapret (see allocproc).
}
80104d8c:	c9                   	leave  
80104d8d:	c3                   	ret    

80104d8e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
80104d8e:	55                   	push   %ebp
80104d8f:	89 e5                	mov    %esp,%ebp
80104d91:	83 ec 18             	sub    $0x18,%esp
	if (thread == 0)
80104d94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	75 0c                	jne    80104daa <sleep+0x1c>
		panic("sleep");
80104d9e:	c7 04 24 bb 93 10 80 	movl   $0x801093bb,(%esp)
80104da5:	e8 90 b7 ff ff       	call   8010053a <panic>

	if (lk == 0)
80104daa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104dae:	75 0c                	jne    80104dbc <sleep+0x2e>
		panic("sleep without lk");
80104db0:	c7 04 24 c1 93 10 80 	movl   $0x801093c1,(%esp)
80104db7:	e8 7e b7 ff ff       	call   8010053a <panic>
	// change p->state and then call sched.
	// Once we hold ptable.lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup runs with ptable.lock locked),
	// so it's okay to release lk.
	if (lk != &ptable.lock) {  //DOC: sleeplock0
80104dbc:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104dc3:	74 17                	je     80104ddc <sleep+0x4e>
		acquire(&ptable.lock);  //DOC: sleeplock1
80104dc5:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104dcc:	e8 cb 02 00 00       	call   8010509c <acquire>
		release(lk);
80104dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dd4:	89 04 24             	mov    %eax,(%esp)
80104dd7:	e8 22 03 00 00       	call   801050fe <release>
	}

	// Go to sleep.
	thread->chan = chan;
80104ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de2:	8b 55 08             	mov    0x8(%ebp),%edx
80104de5:	89 50 18             	mov    %edx,0x18(%eax)
	thread->state = SLEEPING;
80104de8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dee:	c7 40 04 02 00 00 00 	movl   $0x2,0x4(%eax)
	sched();
80104df5:	e8 68 fe ff ff       	call   80104c62 <sched>

	// Tidy up.
	thread->chan = 0;
80104dfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e00:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

	// Reacquire original lock.
	if (lk != &ptable.lock) {  //DOC: sleeplock2
80104e07:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104e0e:	74 17                	je     80104e27 <sleep+0x99>
		release(&ptable.lock);
80104e10:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e17:	e8 e2 02 00 00       	call   801050fe <release>
		acquire(lk);
80104e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e1f:	89 04 24             	mov    %eax,(%esp)
80104e22:	e8 75 02 00 00       	call   8010509c <acquire>
	}
}
80104e27:	c9                   	leave  
80104e28:	c3                   	ret    

80104e29 <wakeup1>:

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
void wakeup1(void *chan) {
80104e29:	55                   	push   %ebp
80104e2a:	89 e5                	mov    %esp,%ebp
80104e2c:	83 ec 10             	sub    $0x10,%esp
	struct proc *p;
	struct thread *t;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e2f:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104e36:	eb 43                	jmp    80104e7b <wakeup1+0x52>
		for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e3b:	83 c0 70             	add    $0x70,%eax
80104e3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104e41:	eb 24                	jmp    80104e67 <wakeup1+0x3e>
			if (t->state == SLEEPING && t->chan == chan)
80104e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e46:	8b 40 04             	mov    0x4(%eax),%eax
80104e49:	83 f8 02             	cmp    $0x2,%eax
80104e4c:	75 15                	jne    80104e63 <wakeup1+0x3a>
80104e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e51:	8b 40 18             	mov    0x18(%eax),%eax
80104e54:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e57:	75 0a                	jne    80104e63 <wakeup1+0x3a>
				t->state = RUNNABLE;
80104e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e5c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
void wakeup1(void *chan) {
	struct proc *p;
	struct thread *t;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104e63:	83 45 f8 1c          	addl   $0x1c,-0x8(%ebp)
80104e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e6a:	05 30 02 00 00       	add    $0x230,%eax
80104e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e72:	77 cf                	ja     80104e43 <wakeup1+0x1a>
// The ptable lock must be held.
void wakeup1(void *chan) {
	struct proc *p;
	struct thread *t;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e74:	81 45 fc 34 02 00 00 	addl   $0x234,-0x4(%ebp)
80104e7b:	81 7d fc b4 c6 11 80 	cmpl   $0x8011c6b4,-0x4(%ebp)
80104e82:	72 b4                	jb     80104e38 <wakeup1+0xf>
		for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
			if (t->state == SLEEPING && t->chan == chan)
				t->state = RUNNABLE;
		}
}
80104e84:	c9                   	leave  
80104e85:	c3                   	ret    

80104e86 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104e86:	55                   	push   %ebp
80104e87:	89 e5                	mov    %esp,%ebp
80104e89:	83 ec 18             	sub    $0x18,%esp
	acquire(&ptable.lock);
80104e8c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e93:	e8 04 02 00 00       	call   8010509c <acquire>
	wakeup1(chan);
80104e98:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9b:	89 04 24             	mov    %eax,(%esp)
80104e9e:	e8 86 ff ff ff       	call   80104e29 <wakeup1>
	release(&ptable.lock);
80104ea3:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104eaa:	e8 4f 02 00 00       	call   801050fe <release>
}
80104eaf:	c9                   	leave  
80104eb0:	c3                   	ret    

80104eb1 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104eb1:	55                   	push   %ebp
80104eb2:	89 e5                	mov    %esp,%ebp
80104eb4:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	struct thread *t;
	acquire(&ptable.lock);
80104eb7:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ebe:	e8 d9 01 00 00       	call   8010509c <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104ec3:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104eca:	eb 60                	jmp    80104f2c <kill+0x7b>
		if (p->pid == pid) {
80104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecf:	8b 40 0c             	mov    0xc(%eax),%eax
80104ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ed5:	75 4e                	jne    80104f25 <kill+0x74>
			p->killed = 1;
80104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eda:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
			for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee4:	83 c0 70             	add    $0x70,%eax
80104ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104eea:	eb 19                	jmp    80104f05 <kill+0x54>
				if (t->state == SLEEPING)
80104eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eef:	8b 40 04             	mov    0x4(%eax),%eax
80104ef2:	83 f8 02             	cmp    $0x2,%eax
80104ef5:	75 0a                	jne    80104f01 <kill+0x50>
					t->state = RUNNABLE;
80104ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104efa:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	struct thread *t;
	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p->pid == pid) {
			p->killed = 1;
			for (t = p->threads; t < &p->threads[NTHREAD]; t++) {
80104f01:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f08:	05 30 02 00 00       	add    $0x230,%eax
80104f0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104f10:	77 da                	ja     80104eec <kill+0x3b>
				if (t->state == SLEEPING)
					t->state = RUNNABLE;
			}
			// Wake process from sleep if necessary.

			release(&ptable.lock);
80104f12:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f19:	e8 e0 01 00 00       	call   801050fe <release>
			return 0;
80104f1e:	b8 00 00 00 00       	mov    $0x0,%eax
80104f23:	eb 21                	jmp    80104f46 <kill+0x95>
// to user space (see trap in trap.c).
int kill(int pid) {
	struct proc *p;
	struct thread *t;
	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104f25:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104f2c:	81 7d f4 b4 c6 11 80 	cmpl   $0x8011c6b4,-0xc(%ebp)
80104f33:	72 97                	jb     80104ecc <kill+0x1b>

			release(&ptable.lock);
			return 0;
		}
	}
	release(&ptable.lock);
80104f35:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f3c:	e8 bd 01 00 00       	call   801050fe <release>
	return -1;
80104f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f46:	c9                   	leave  
80104f47:	c3                   	ret    

80104f48 <procdump>:

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104f48:	55                   	push   %ebp
80104f49:	89 e5                	mov    %esp,%ebp
80104f4b:	83 ec 58             	sub    $0x58,%esp
	struct proc *p;

	char *state;
	uint pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104f4e:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104f55:	e9 dc 00 00 00       	jmp    80105036 <procdump+0xee>
		if (p->state == UNUSED)
80104f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f5d:	8b 40 08             	mov    0x8(%eax),%eax
80104f60:	85 c0                	test   %eax,%eax
80104f62:	75 05                	jne    80104f69 <procdump+0x21>
			continue;
80104f64:	e9 c6 00 00 00       	jmp    8010502f <procdump+0xe7>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6c:	8b 40 08             	mov    0x8(%eax),%eax
80104f6f:	83 f8 05             	cmp    $0x5,%eax
80104f72:	77 23                	ja     80104f97 <procdump+0x4f>
80104f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f77:	8b 40 08             	mov    0x8(%eax),%eax
80104f7a:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104f81:	85 c0                	test   %eax,%eax
80104f83:	74 12                	je     80104f97 <procdump+0x4f>
			state = states[p->state];
80104f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f88:	8b 40 08             	mov    0x8(%eax),%eax
80104f8b:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104f92:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f95:	eb 07                	jmp    80104f9e <procdump+0x56>
		else
			state = "???";
80104f97:	c7 45 ec d2 93 10 80 	movl   $0x801093d2,-0x14(%ebp)
		cprintf("%d %s %s", p->pid, state, p->name);
80104f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa1:	8d 50 60             	lea    0x60(%eax),%edx
80104fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa7:	8b 40 0c             	mov    0xc(%eax),%eax
80104faa:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104fae:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104fb1:	89 54 24 08          	mov    %edx,0x8(%esp)
80104fb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb9:	c7 04 24 d6 93 10 80 	movl   $0x801093d6,(%esp)
80104fc0:	e8 db b3 ff ff       	call   801003a0 <cprintf>
		if (p->state == SLEEPING) {
80104fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc8:	8b 40 08             	mov    0x8(%eax),%eax
80104fcb:	83 f8 02             	cmp    $0x2,%eax
80104fce:	75 53                	jne    80105023 <procdump+0xdb>
			getcallerpcs((uint*) thread->context->ebp + 2, pc);
80104fd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd6:	8b 40 14             	mov    0x14(%eax),%eax
80104fd9:	8b 40 0c             	mov    0xc(%eax),%eax
80104fdc:	83 c0 08             	add    $0x8,%eax
80104fdf:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
80104fe6:	89 04 24             	mov    %eax,(%esp)
80104fe9:	e8 5f 01 00 00       	call   8010514d <getcallerpcs>
			for (i = 0; i < 10 && pc[i] != 0; i++)
80104fee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ff5:	eb 1b                	jmp    80105012 <procdump+0xca>
				cprintf(" %p", pc[i]);
80104ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffa:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105002:	c7 04 24 df 93 10 80 	movl   $0x801093df,(%esp)
80105009:	e8 92 b3 ff ff       	call   801003a0 <cprintf>
		else
			state = "???";
		cprintf("%d %s %s", p->pid, state, p->name);
		if (p->state == SLEEPING) {
			getcallerpcs((uint*) thread->context->ebp + 2, pc);
			for (i = 0; i < 10 && pc[i] != 0; i++)
8010500e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105012:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105016:	7f 0b                	jg     80105023 <procdump+0xdb>
80105018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501b:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010501f:	85 c0                	test   %eax,%eax
80105021:	75 d4                	jne    80104ff7 <procdump+0xaf>
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
80105023:	c7 04 24 e3 93 10 80 	movl   $0x801093e3,(%esp)
8010502a:	e8 71 b3 ff ff       	call   801003a0 <cprintf>
	struct proc *p;

	char *state;
	uint pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010502f:	81 45 f0 34 02 00 00 	addl   $0x234,-0x10(%ebp)
80105036:	81 7d f0 b4 c6 11 80 	cmpl   $0x8011c6b4,-0x10(%ebp)
8010503d:	0f 82 17 ff ff ff    	jb     80104f5a <procdump+0x12>
			for (i = 0; i < 10 && pc[i] != 0; i++)
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
	}
}
80105043:	c9                   	leave  
80105044:	c3                   	ret    

80105045 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105045:	55                   	push   %ebp
80105046:	89 e5                	mov    %esp,%ebp
80105048:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010504b:	9c                   	pushf  
8010504c:	58                   	pop    %eax
8010504d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105050:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105053:	c9                   	leave  
80105054:	c3                   	ret    

80105055 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105055:	55                   	push   %ebp
80105056:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105058:	fa                   	cli    
}
80105059:	5d                   	pop    %ebp
8010505a:	c3                   	ret    

8010505b <sti>:

static inline void
sti(void)
{
8010505b:	55                   	push   %ebp
8010505c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010505e:	fb                   	sti    
}
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    

80105061 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105061:	55                   	push   %ebp
80105062:	89 e5                	mov    %esp,%ebp
80105064:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105067:	8b 55 08             	mov    0x8(%ebp),%edx
8010506a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105070:	f0 87 02             	lock xchg %eax,(%edx)
80105073:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105076:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105079:	c9                   	leave  
8010507a:	c3                   	ret    

8010507b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010507b:	55                   	push   %ebp
8010507c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010507e:	8b 45 08             	mov    0x8(%ebp),%eax
80105081:	8b 55 0c             	mov    0xc(%ebp),%edx
80105084:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105087:	8b 45 08             	mov    0x8(%ebp),%eax
8010508a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105090:	8b 45 08             	mov    0x8(%ebp),%eax
80105093:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010509a:	5d                   	pop    %ebp
8010509b:	c3                   	ret    

8010509c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010509c:	55                   	push   %ebp
8010509d:	89 e5                	mov    %esp,%ebp
8010509f:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050a2:	e8 49 01 00 00       	call   801051f0 <pushcli>


  if(holding(lk)){
801050a7:	8b 45 08             	mov    0x8(%ebp),%eax
801050aa:	89 04 24             	mov    %eax,(%esp)
801050ad:	e8 14 01 00 00       	call   801051c6 <holding>
801050b2:	85 c0                	test   %eax,%eax
801050b4:	74 0c                	je     801050c2 <acquire+0x26>

    panic("acquire");
801050b6:	c7 04 24 0f 94 10 80 	movl   $0x8010940f,(%esp)
801050bd:	e8 78 b4 ff ff       	call   8010053a <panic>
  }
  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0);
801050c2:	90                   	nop
801050c3:	8b 45 08             	mov    0x8(%ebp),%eax
801050c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801050cd:	00 
801050ce:	89 04 24             	mov    %eax,(%esp)
801050d1:	e8 8b ff ff ff       	call   80105061 <xchg>
801050d6:	85 c0                	test   %eax,%eax
801050d8:	75 e9                	jne    801050c3 <acquire+0x27>

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801050da:	8b 45 08             	mov    0x8(%ebp),%eax
801050dd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050e4:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801050e7:	8b 45 08             	mov    0x8(%ebp),%eax
801050ea:	83 c0 0c             	add    $0xc,%eax
801050ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f1:	8d 45 08             	lea    0x8(%ebp),%eax
801050f4:	89 04 24             	mov    %eax,(%esp)
801050f7:	e8 51 00 00 00       	call   8010514d <getcallerpcs>
}
801050fc:	c9                   	leave  
801050fd:	c3                   	ret    

801050fe <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801050fe:	55                   	push   %ebp
801050ff:	89 e5                	mov    %esp,%ebp
80105101:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105104:	8b 45 08             	mov    0x8(%ebp),%eax
80105107:	89 04 24             	mov    %eax,(%esp)
8010510a:	e8 b7 00 00 00       	call   801051c6 <holding>
8010510f:	85 c0                	test   %eax,%eax
80105111:	75 0c                	jne    8010511f <release+0x21>
    panic("release");
80105113:	c7 04 24 17 94 10 80 	movl   $0x80109417,(%esp)
8010511a:	e8 1b b4 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
8010511f:	8b 45 08             	mov    0x8(%ebp),%eax
80105122:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105129:	8b 45 08             	mov    0x8(%ebp),%eax
8010512c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105133:	8b 45 08             	mov    0x8(%ebp),%eax
80105136:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010513d:	00 
8010513e:	89 04 24             	mov    %eax,(%esp)
80105141:	e8 1b ff ff ff       	call   80105061 <xchg>

  popcli();
80105146:	e8 e9 00 00 00       	call   80105234 <popcli>
}
8010514b:	c9                   	leave  
8010514c:	c3                   	ret    

8010514d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010514d:	55                   	push   %ebp
8010514e:	89 e5                	mov    %esp,%ebp
80105150:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105153:	8b 45 08             	mov    0x8(%ebp),%eax
80105156:	83 e8 08             	sub    $0x8,%eax
80105159:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010515c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105163:	eb 38                	jmp    8010519d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105165:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105169:	74 38                	je     801051a3 <getcallerpcs+0x56>
8010516b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105172:	76 2f                	jbe    801051a3 <getcallerpcs+0x56>
80105174:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105178:	74 29                	je     801051a3 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010517a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010517d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105184:	8b 45 0c             	mov    0xc(%ebp),%eax
80105187:	01 c2                	add    %eax,%edx
80105189:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010518c:	8b 40 04             	mov    0x4(%eax),%eax
8010518f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105191:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105194:	8b 00                	mov    (%eax),%eax
80105196:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105199:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010519d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051a1:	7e c2                	jle    80105165 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051a3:	eb 19                	jmp    801051be <getcallerpcs+0x71>
    pcs[i] = 0;
801051a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051af:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b2:	01 d0                	add    %edx,%eax
801051b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051ba:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051be:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051c2:	7e e1                	jle    801051a5 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801051c4:	c9                   	leave  
801051c5:	c3                   	ret    

801051c6 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801051c6:	55                   	push   %ebp
801051c7:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801051c9:	8b 45 08             	mov    0x8(%ebp),%eax
801051cc:	8b 00                	mov    (%eax),%eax
801051ce:	85 c0                	test   %eax,%eax
801051d0:	74 17                	je     801051e9 <holding+0x23>
801051d2:	8b 45 08             	mov    0x8(%ebp),%eax
801051d5:	8b 50 08             	mov    0x8(%eax),%edx
801051d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051de:	39 c2                	cmp    %eax,%edx
801051e0:	75 07                	jne    801051e9 <holding+0x23>
801051e2:	b8 01 00 00 00       	mov    $0x1,%eax
801051e7:	eb 05                	jmp    801051ee <holding+0x28>
801051e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051ee:	5d                   	pop    %ebp
801051ef:	c3                   	ret    

801051f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801051f6:	e8 4a fe ff ff       	call   80105045 <readeflags>
801051fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801051fe:	e8 52 fe ff ff       	call   80105055 <cli>
  if(cpu->ncli++ == 0)
80105203:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010520a:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105210:	8d 48 01             	lea    0x1(%eax),%ecx
80105213:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105219:	85 c0                	test   %eax,%eax
8010521b:	75 15                	jne    80105232 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010521d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105223:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105226:	81 e2 00 02 00 00    	and    $0x200,%edx
8010522c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105232:	c9                   	leave  
80105233:	c3                   	ret    

80105234 <popcli>:

void
popcli(void)
{
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010523a:	e8 06 fe ff ff       	call   80105045 <readeflags>
8010523f:	25 00 02 00 00       	and    $0x200,%eax
80105244:	85 c0                	test   %eax,%eax
80105246:	74 0c                	je     80105254 <popcli+0x20>
    panic("popcli - interruptible");
80105248:	c7 04 24 1f 94 10 80 	movl   $0x8010941f,(%esp)
8010524f:	e8 e6 b2 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105254:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010525a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105260:	83 ea 01             	sub    $0x1,%edx
80105263:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105269:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010526f:	85 c0                	test   %eax,%eax
80105271:	79 0c                	jns    8010527f <popcli+0x4b>
    panic("popcli");
80105273:	c7 04 24 36 94 10 80 	movl   $0x80109436,(%esp)
8010527a:	e8 bb b2 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010527f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105285:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010528b:	85 c0                	test   %eax,%eax
8010528d:	75 15                	jne    801052a4 <popcli+0x70>
8010528f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105295:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010529b:	85 c0                	test   %eax,%eax
8010529d:	74 05                	je     801052a4 <popcli+0x70>
    sti();
8010529f:	e8 b7 fd ff ff       	call   8010505b <sti>
}
801052a4:	c9                   	leave  
801052a5:	c3                   	ret    

801052a6 <increaseNumOfThreadsAlive>:

extern void wakeup1(void *chan);


void
increaseNumOfThreadsAlive(void){
801052a6:	55                   	push   %ebp
801052a7:	89 e5                	mov    %esp,%ebp
801052a9:	83 ec 28             	sub    $0x28,%esp
	int i = thread->proc->numOfThreads++;
801052ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b2:	8b 50 0c             	mov    0xc(%eax),%edx
801052b5:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
801052bb:	8d 48 01             	lea    0x1(%eax),%ecx
801052be:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
801052c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//cprintf("num o threads %d \n" , i);
	if(i > NTHREAD)
801052c7:	83 7d f4 10          	cmpl   $0x10,-0xc(%ebp)
801052cb:	7e 0c                	jle    801052d9 <increaseNumOfThreadsAlive+0x33>
		panic("Too many threads");
801052cd:	c7 04 24 40 94 10 80 	movl   $0x80109440,(%esp)
801052d4:	e8 61 b2 ff ff       	call   8010053a <panic>
}
801052d9:	c9                   	leave  
801052da:	c3                   	ret    

801052db <decreaseNumOfThreadsAlive>:


void
decreaseNumOfThreadsAlive(void){
801052db:	55                   	push   %ebp
801052dc:	89 e5                	mov    %esp,%ebp
801052de:	83 ec 28             	sub    $0x28,%esp

	int i = thread->proc->numOfThreads--;
801052e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e7:	8b 50 0c             	mov    0xc(%eax),%edx
801052ea:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
801052f0:	8d 48 ff             	lea    -0x1(%eax),%ecx
801052f3:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
801052f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//cprintf("num o threads %d 0\n" , i);
	if(i < 0)
801052fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105300:	79 0c                	jns    8010530e <decreaseNumOfThreadsAlive+0x33>
		panic("Not enough threads");
80105302:	c7 04 24 51 94 10 80 	movl   $0x80109451,(%esp)
80105309:	e8 2c b2 ff ff       	call   8010053a <panic>
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    

80105310 <kthread_create>:




int
kthread_create(void*(*start_func)(), void* stack, uint stack_size){
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
80105316:	83 ec 2c             	sub    $0x2c,%esp
	  struct thread *t ;


	  char *sp;

	  acquire(&ptable.lock);
80105319:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105320:	e8 77 fd ff ff       	call   8010509c <acquire>
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105325:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010532b:	8b 40 0c             	mov    0xc(%eax),%eax
8010532e:	83 c0 70             	add    $0x70,%eax
80105331:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105334:	eb 53                	jmp    80105389 <kthread_create+0x79>
	    if(t->state == UNUSED){
80105336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105339:	8b 40 04             	mov    0x4(%eax),%eax
8010533c:	85 c0                	test   %eax,%eax
8010533e:	75 45                	jne    80105385 <kthread_create+0x75>
	       goto found;
80105340:	90                   	nop
	  }
	  release(&ptable.lock);
	  return -1;

	  found:
	       t->state=EMBRYO;
80105341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105344:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	       t->pid= nextpid++;
8010534b:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80105350:	8d 50 01             	lea    0x1(%eax),%edx
80105353:	89 15 20 c0 10 80    	mov    %edx,0x8010c020
80105359:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010535c:	89 42 08             	mov    %eax,0x8(%edx)
	       increaseNumOfThreadsAlive();
8010535f:	e8 42 ff ff ff       	call   801052a6 <increaseNumOfThreadsAlive>
	       release(&ptable.lock);
80105364:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010536b:	e8 8e fd ff ff       	call   801050fe <release>
	       if((t->kstack = kalloc()) == 0){
80105370:	e8 92 d7 ff ff       	call   80102b07 <kalloc>
80105375:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105378:	89 02                	mov    %eax,(%edx)
8010537a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010537d:	8b 00                	mov    (%eax),%eax
8010537f:	85 c0                	test   %eax,%eax
80105381:	75 43                	jne    801053c6 <kthread_create+0xb6>
80105383:	eb 2d                	jmp    801053b2 <kthread_create+0xa2>


	  char *sp;

	  acquire(&ptable.lock);
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105385:	83 45 e4 1c          	addl   $0x1c,-0x1c(%ebp)
80105389:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010538f:	8b 40 0c             	mov    0xc(%eax),%eax
80105392:	05 30 02 00 00       	add    $0x230,%eax
80105397:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
8010539a:	77 9a                	ja     80105336 <kthread_create+0x26>
	    if(t->state == UNUSED){
	       goto found;
	    }
	  }
	  release(&ptable.lock);
8010539c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801053a3:	e8 56 fd ff ff       	call   801050fe <release>
	  return -1;
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ad:	e9 dc 00 00 00       	jmp    8010548e <kthread_create+0x17e>
	       t->state=EMBRYO;
	       t->pid= nextpid++;
	       increaseNumOfThreadsAlive();
	       release(&ptable.lock);
	       if((t->kstack = kalloc()) == 0){
	        t->state = UNUSED;
801053b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	        return -1;
801053bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c1:	e9 c8 00 00 00       	jmp    8010548e <kthread_create+0x17e>
	       }
	       sp = t->kstack + KSTACKSIZE;
801053c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053c9:	8b 00                	mov    (%eax),%eax
801053cb:	05 00 10 00 00       	add    $0x1000,%eax
801053d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	       sp -= sizeof *t->tf;
801053d3:	83 6d e0 4c          	subl   $0x4c,-0x20(%ebp)

	       t->tf = (struct trapframe*)sp ;
801053d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053da:	8b 55 e0             	mov    -0x20(%ebp),%edx
801053dd:	89 50 10             	mov    %edx,0x10(%eax)
	       sp -= 4;
801053e0:	83 6d e0 04          	subl   $0x4,-0x20(%ebp)
	       *(uint*)sp = (uint)trapret;
801053e4:	ba 9e 70 10 80       	mov    $0x8010709e,%edx
801053e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053ec:	89 10                	mov    %edx,(%eax)
	       sp -= sizeof *t->context;
801053ee:	83 6d e0 14          	subl   $0x14,-0x20(%ebp)
	       t->context = (struct context*)sp;
801053f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801053f8:	89 50 14             	mov    %edx,0x14(%eax)
	       memset(t->context, 0, sizeof *t->context);
801053fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053fe:	8b 40 14             	mov    0x14(%eax),%eax
80105401:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105408:	00 
80105409:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105410:	00 
80105411:	89 04 24             	mov    %eax,(%esp)
80105414:	e8 88 06 00 00       	call   80105aa1 <memset>


	       t->context->eip = (uint)forkret;
80105419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010541c:	8b 40 14             	mov    0x14(%eax),%eax
8010541f:	ba 62 4d 10 80       	mov    $0x80104d62,%edx
80105424:	89 50 10             	mov    %edx,0x10(%eax)
	       *t->tf=*thread->tf;
80105427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010542a:	8b 50 10             	mov    0x10(%eax),%edx
8010542d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105433:	8b 40 10             	mov    0x10(%eax),%eax
80105436:	89 c3                	mov    %eax,%ebx
80105438:	b8 13 00 00 00       	mov    $0x13,%eax
8010543d:	89 d7                	mov    %edx,%edi
8010543f:	89 de                	mov    %ebx,%esi
80105441:	89 c1                	mov    %eax,%ecx
80105443:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	       t->tf->eip = (uint)start_func;
80105445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105448:	8b 40 10             	mov    0x10(%eax),%eax
8010544b:	8b 55 08             	mov    0x8(%ebp),%edx
8010544e:	89 50 38             	mov    %edx,0x38(%eax)
	       t->tf->esp = (uint)(stack+stack_size);
80105451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105454:	8b 40 10             	mov    0x10(%eax),%eax
80105457:	8b 55 10             	mov    0x10(%ebp),%edx
8010545a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010545d:	01 ca                	add    %ecx,%edx
8010545f:	89 50 44             	mov    %edx,0x44(%eax)
	       t->tf->eflags = FL_IF;
80105462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105465:	8b 40 10             	mov    0x10(%eax),%eax
80105468:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	       t->proc = thread->proc;
8010546f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105475:	8b 50 0c             	mov    0xc(%eax),%edx
80105478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010547b:	89 50 0c             	mov    %edx,0xc(%eax)
	       t->state = RUNNABLE;
8010547e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105481:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	       return t->pid;
80105488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010548b:	8b 40 08             	mov    0x8(%eax),%eax


}
8010548e:	83 c4 2c             	add    $0x2c,%esp
80105491:	5b                   	pop    %ebx
80105492:	5e                   	pop    %esi
80105493:	5f                   	pop    %edi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret    

80105496 <kthread_id>:

int kthread_id(){
80105496:	55                   	push   %ebp
80105497:	89 e5                	mov    %esp,%ebp

	return thread->pid;
80105499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549f:	8b 40 08             	mov    0x8(%eax),%eax
}
801054a2:	5d                   	pop    %ebp
801054a3:	c3                   	ret    

801054a4 <kthread_exit>:

void kthread_exit(){
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	83 ec 28             	sub    $0x28,%esp




	 struct proc *proc =thread->proc;
801054aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b0:	8b 40 0c             	mov    0xc(%eax),%eax
801054b3:	89 45 f4             	mov    %eax,-0xc(%ebp)


	 acquire(&ptable.lock);
801054b6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801054bd:	e8 da fb ff ff       	call   8010509c <acquire>

	 thread->state= ZOMBIE;
801054c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c8:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)

	 if (proc->numOfThreads == 1 ){  //tis is ta lst tred
801054cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d2:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
801054d8:	83 f8 01             	cmp    $0x1,%eax
801054db:	75 11                	jne    801054ee <kthread_exit+0x4a>
		 	release(&ptable.lock);
801054dd:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801054e4:	e8 15 fc ff ff       	call   801050fe <release>
		 	exit();
801054e9:	e8 7a f3 ff ff       	call   80104868 <exit>

	 }

	 decreaseNumOfThreadsAlive();
801054ee:	e8 e8 fd ff ff       	call   801052db <decreaseNumOfThreadsAlive>
	 wakeup1(thread);
801054f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f9:	89 04 24             	mov    %eax,(%esp)
801054fc:	e8 28 f9 ff ff       	call   80104e29 <wakeup1>
	 sched();
80105501:	e8 5c f7 ff ff       	call   80104c62 <sched>
	 panic("zombie exit");
80105506:	c7 04 24 64 94 10 80 	movl   $0x80109464,(%esp)
8010550d:	e8 28 b0 ff ff       	call   8010053a <panic>

80105512 <kthread_join>:
}

int kthread_join(int thread_id){
80105512:	55                   	push   %ebp
80105513:	89 e5                	mov    %esp,%ebp
80105515:	83 ec 28             	sub    $0x28,%esp
	//printf( "thread id : %d ", thread_id);
	  int found;
	  struct thread *t;
	  struct thread *threadFound;

	  acquire(&ptable.lock);
80105518:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010551f:	e8 78 fb ff ff       	call   8010509c <acquire>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;
80105524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
8010552b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105531:	8b 40 0c             	mov    0xc(%eax),%eax
80105534:	83 c0 70             	add    $0x70,%eax
80105537:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010553a:	e9 8e 00 00 00       	jmp    801055cd <kthread_join+0xbb>

	      if(t->pid != thread_id)
8010553f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105542:	8b 40 08             	mov    0x8(%eax),%eax
80105545:	3b 45 08             	cmp    0x8(%ebp),%eax
80105548:	74 02                	je     8010554c <kthread_join+0x3a>
	        continue;
8010554a:	eb 7d                	jmp    801055c9 <kthread_join+0xb7>
	      found = 1;
8010554c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	      threadFound= t;
80105553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105556:	89 45 ec             	mov    %eax,-0x14(%ebp)

	      if(t->state == ZOMBIE){
80105559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010555c:	8b 40 04             	mov    0x4(%eax),%eax
8010555f:	83 f8 05             	cmp    $0x5,%eax
80105562:	75 65                	jne    801055c9 <kthread_join+0xb7>
	        // Found one.
	        t->chan= 0;
80105564:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105567:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
			t->context = 0;
8010556e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105571:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
			t->pid = 0;
80105578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			t->proc = 0;
80105582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105585:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			t->state = 0;
8010558c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010558f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			t->state= UNUSED;
80105596:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			if (t->kstack)
801055a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a3:	8b 00                	mov    (%eax),%eax
801055a5:	85 c0                	test   %eax,%eax
801055a7:	74 0d                	je     801055b6 <kthread_join+0xa4>
				kfree(t->kstack);
801055a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ac:	8b 00                	mov    (%eax),%eax
801055ae:	89 04 24             	mov    %eax,(%esp)
801055b1:	e8 b8 d4 ff ff       	call   80102a6e <kfree>

	        release(&ptable.lock);
801055b6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801055bd:	e8 3c fb ff ff       	call   801050fe <release>
	        return 0;
801055c2:	b8 00 00 00 00       	mov    $0x0,%eax
801055c7:	eb 5c                	jmp    80105625 <kthread_join+0x113>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
801055c9:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
801055cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d3:	8b 40 0c             	mov    0xc(%eax),%eax
801055d6:	05 30 02 00 00       	add    $0x230,%eax
801055db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801055de:	0f 87 5b ff ff ff    	ja     8010553f <kthread_join+0x2d>
	        return 0;
	      }
	    }


	    if(!found || thread->proc->killed){
801055e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055e8:	74 10                	je     801055fa <kthread_join+0xe8>
801055ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f0:	8b 40 0c             	mov    0xc(%eax),%eax
801055f3:	8b 40 18             	mov    0x18(%eax),%eax
801055f6:	85 c0                	test   %eax,%eax
801055f8:	74 13                	je     8010560d <kthread_join+0xfb>

	      release(&ptable.lock);
801055fa:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105601:	e8 f8 fa ff ff       	call   801050fe <release>
	      return -1;
80105606:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560b:	eb 18                	jmp    80105625 <kthread_join+0x113>
	    }

	    // Wait for thread to exit
	    sleep(threadFound, &ptable.lock);  //DOC: wait-sleep
8010560d:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80105614:	80 
80105615:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105618:	89 04 24             	mov    %eax,(%esp)
8010561b:	e8 6e f7 ff ff       	call   80104d8e <sleep>

	  }
80105620:	e9 ff fe ff ff       	jmp    80105524 <kthread_join+0x12>


	  return -1;
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    

80105627 <EmptyQueue>:





int EmptyQueue(struct kthread_mutex_t *m){
80105627:	55                   	push   %ebp
80105628:	89 e5                	mov    %esp,%ebp

  return (m->threads_queue[0]==0);
8010562a:	8b 45 08             	mov    0x8(%ebp),%eax
8010562d:	8b 40 0c             	mov    0xc(%eax),%eax
80105630:	85 c0                	test   %eax,%eax
80105632:	0f 94 c0             	sete   %al
80105635:	0f b6 c0             	movzbl %al,%eax

}
80105638:	5d                   	pop    %ebp
80105639:	c3                   	ret    

8010563a <pushThreadToMutexQueue>:

void pushThreadToMutexQueue(struct thread *t , struct kthread_mutex_t *m){
8010563a:	55                   	push   %ebp
8010563b:	89 e5                	mov    %esp,%ebp
8010563d:	83 ec 18             	sub    $0x18,%esp

  if (m->last == NTHREAD)
80105640:	8b 45 0c             	mov    0xc(%ebp),%eax
80105643:	8b 40 50             	mov    0x50(%eax),%eax
80105646:	83 f8 10             	cmp    $0x10,%eax
80105649:	75 0c                	jne    80105657 <pushThreadToMutexQueue+0x1d>
	  panic ("Mutex oveflow\n");
8010564b:	c7 04 24 70 94 10 80 	movl   $0x80109470,(%esp)
80105652:	e8 e3 ae ff ff       	call   8010053a <panic>


  m->threads_queue[m->last]= t;
80105657:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565a:	8b 50 50             	mov    0x50(%eax),%edx
8010565d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105660:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105663:	89 4c 90 0c          	mov    %ecx,0xc(%eax,%edx,4)

  m->last++;
80105667:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566a:	8b 40 50             	mov    0x50(%eax),%eax
8010566d:	8d 50 01             	lea    0x1(%eax),%edx
80105670:	8b 45 0c             	mov    0xc(%ebp),%eax
80105673:	89 50 50             	mov    %edx,0x50(%eax)

}
80105676:	c9                   	leave  
80105677:	c3                   	ret    

80105678 <popThreadToMutexQueue>:


struct thread * popThreadToMutexQueue(struct kthread_mutex_t *m){
80105678:	55                   	push   %ebp
80105679:	89 e5                	mov    %esp,%ebp
8010567b:	83 ec 28             	sub    $0x28,%esp

  struct thread * toReturn = m->threads_queue[m->first];
8010567e:	8b 45 08             	mov    0x8(%ebp),%eax
80105681:	8b 50 4c             	mov    0x4c(%eax),%edx
80105684:	8b 45 08             	mov    0x8(%ebp),%eax
80105687:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010568b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;


  if (toReturn==0)
8010568e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105692:	75 0c                	jne    801056a0 <popThreadToMutexQueue+0x28>
	  	  panic("Mutex over pop. Can't pop this... \n");
80105694:	c7 04 24 80 94 10 80 	movl   $0x80109480,(%esp)
8010569b:	e8 9a ae ff ff       	call   8010053a <panic>


  for (i =1 ; i< NTHREAD ; i++){
801056a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801056a7:	eb 2b                	jmp    801056d4 <popThreadToMutexQueue+0x5c>

	  m->threads_queue[i-1]= m->threads_queue[i];
801056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ac:	8d 48 ff             	lea    -0x1(%eax),%ecx
801056af:	8b 45 08             	mov    0x8(%ebp),%eax
801056b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b5:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
801056b9:	8b 45 08             	mov    0x8(%ebp),%eax
801056bc:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	  if (m->threads_queue[i]==0)
801056c0:	8b 45 08             	mov    0x8(%ebp),%eax
801056c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056c6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801056ca:	85 c0                	test   %eax,%eax
801056cc:	75 02                	jne    801056d0 <popThreadToMutexQueue+0x58>
		  break;
801056ce:	eb 0a                	jmp    801056da <popThreadToMutexQueue+0x62>

  if (toReturn==0)
	  	  panic("Mutex over pop. Can't pop this... \n");


  for (i =1 ; i< NTHREAD ; i++){
801056d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801056d4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056d8:	7e cf                	jle    801056a9 <popThreadToMutexQueue+0x31>

	  if (m->threads_queue[i]==0)
		  break;

  }
  m->last--;
801056da:	8b 45 08             	mov    0x8(%ebp),%eax
801056dd:	8b 40 50             	mov    0x50(%eax),%eax
801056e0:	8d 50 ff             	lea    -0x1(%eax),%edx
801056e3:	8b 45 08             	mov    0x8(%ebp),%eax
801056e6:	89 50 50             	mov    %edx,0x50(%eax)
  m->threads_queue[NTHREAD-1]=0;
801056e9:	8b 45 08             	mov    0x8(%ebp),%eax
801056ec:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)


  return toReturn;
801056f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801056f6:	c9                   	leave  
801056f7:	c3                   	ret    

801056f8 <kthread_mutex_alloc>:


int kthread_mutex_alloc(void){
801056f8:	55                   	push   %ebp
801056f9:	89 e5                	mov    %esp,%ebp
801056fb:	83 ec 28             	sub    $0x28,%esp

    int index=0;
801056fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct kthread_mutex_t *m;

    for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105705:	c7 45 f0 c0 c6 11 80 	movl   $0x8011c6c0,-0x10(%ebp)
8010570c:	eb 6c                	jmp    8010577a <kthread_mutex_alloc+0x82>

        if(m->state == UNUSED_MUTEX){
8010570e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105711:	8b 00                	mov    (%eax),%eax
80105713:	85 c0                	test   %eax,%eax
80105715:	75 5b                	jne    80105772 <kthread_mutex_alloc+0x7a>
          m->state = USED_MUTEX;
80105717:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010571a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
          m->id = index;
80105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105723:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105726:	89 50 04             	mov    %edx,0x4(%eax)
          m->queueLock= &mutextable.mutexspinLock[index];
80105729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572c:	6b c0 34             	imul   $0x34,%eax,%eax
8010572f:	05 00 16 00 00       	add    $0x1600,%eax
80105734:	8d 90 c0 c6 11 80    	lea    -0x7fee3940(%eax),%edx
8010573a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573d:	89 50 54             	mov    %edx,0x54(%eax)
          initlock(m->queueLock, "mutexLock");
80105740:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105743:	8b 40 54             	mov    0x54(%eax),%eax
80105746:	c7 44 24 04 a4 94 10 	movl   $0x801094a4,0x4(%esp)
8010574d:	80 
8010574e:	89 04 24             	mov    %eax,(%esp)
80105751:	e8 25 f9 ff ff       	call   8010507b <initlock>
          m->last = 0;
80105756:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105759:	c7 40 50 00 00 00 00 	movl   $0x0,0x50(%eax)
          m->first = 0;
80105760:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105763:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
          return m->id;
8010576a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576d:	8b 40 04             	mov    0x4(%eax),%eax
80105770:	eb 16                	jmp    80105788 <kthread_mutex_alloc+0x90>
        } else {
        	index++;
80105772:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int kthread_mutex_alloc(void){

    int index=0;
    struct kthread_mutex_t *m;

    for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105776:	83 45 f0 58          	addl   $0x58,-0x10(%ebp)
8010577a:	81 7d f0 c0 dc 11 80 	cmpl   $0x8011dcc0,-0x10(%ebp)
80105781:	72 8b                	jb     8010570e <kthread_mutex_alloc+0x16>
        } else {
        	index++;
        }
    }

  return -1;
80105783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105788:	c9                   	leave  
80105789:	c3                   	ret    

8010578a <kthread_mutex_dealloc>:

int kthread_mutex_dealloc(int mutex_id){
8010578a:	55                   	push   %ebp
8010578b:	89 e5                	mov    %esp,%ebp
8010578d:	83 ec 10             	sub    $0x10,%esp

  struct kthread_mutex_t *m;

  //cprintf("1- %d\n", mutex_id);
  for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105790:	c7 45 fc c0 c6 11 80 	movl   $0x8011c6c0,-0x4(%ebp)
80105797:	eb 44                	jmp    801057dd <kthread_mutex_dealloc+0x53>


	  if(  m->id== mutex_id ){    //mutesx is not locked
80105799:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010579c:	8b 40 04             	mov    0x4(%eax),%eax
8010579f:	3b 45 08             	cmp    0x8(%ebp),%eax
801057a2:	75 35                	jne    801057d9 <kthread_mutex_dealloc+0x4f>
		  //cprintf("id-%d  st-%d  locked %d\n", m->id , m->state, m->locked);
		  if(  m->state==USED_MUTEX &&  !m->locked ){
801057a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057a7:	8b 00                	mov    (%eax),%eax
801057a9:	83 f8 01             	cmp    $0x1,%eax
801057ac:	75 24                	jne    801057d2 <kthread_mutex_dealloc+0x48>
801057ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057b1:	8b 40 08             	mov    0x8(%eax),%eax
801057b4:	85 c0                	test   %eax,%eax
801057b6:	75 1a                	jne    801057d2 <kthread_mutex_dealloc+0x48>
					  m->state = UNUSED_MUTEX;
801057b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					  m->id= -1;
801057c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057c4:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
					  //cprintf("dealoc\n");
					  return 0;
801057cb:	b8 00 00 00 00       	mov    $0x0,%eax
801057d0:	eb 19                	jmp    801057eb <kthread_mutex_dealloc+0x61>
		  }
		  return -1;
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb 12                	jmp    801057eb <kthread_mutex_dealloc+0x61>
int kthread_mutex_dealloc(int mutex_id){

  struct kthread_mutex_t *m;

  //cprintf("1- %d\n", mutex_id);
  for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
801057d9:	83 45 fc 58          	addl   $0x58,-0x4(%ebp)
801057dd:	81 7d fc c0 dc 11 80 	cmpl   $0x8011dcc0,-0x4(%ebp)
801057e4:	72 b3                	jb     80105799 <kthread_mutex_dealloc+0xf>
		  }
		  return -1;
        }
  }

  return -1;
801057e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057eb:	c9                   	leave  
801057ec:	c3                   	ret    

801057ed <kthread_mutex_lock>:

int kthread_mutex_lock(int mutex_id){
801057ed:	55                   	push   %ebp
801057ee:	89 e5                	mov    %esp,%ebp
801057f0:	83 ec 28             	sub    $0x28,%esp

 // pushcli(); // disable interrupts to avoid deadlock.
  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];
801057f3:	8b 45 08             	mov    0x8(%ebp),%eax
801057f6:	6b c0 58             	imul   $0x58,%eax,%eax
801057f9:	05 c0 c6 11 80       	add    $0x8011c6c0,%eax
801057fe:	89 45 f4             	mov    %eax,-0xc(%ebp)



  if (m->state==UNUSED_MUTEX){
80105801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105804:	8b 00                	mov    (%eax),%eax
80105806:	85 c0                	test   %eax,%eax
80105808:	75 0a                	jne    80105814 <kthread_mutex_lock+0x27>

		return -1;
8010580a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580f:	e9 91 00 00 00       	jmp    801058a5 <kthread_mutex_lock+0xb8>
  }
  acquire(m->queueLock);
80105814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105817:	8b 40 54             	mov    0x54(%eax),%eax
8010581a:	89 04 24             	mov    %eax,(%esp)
8010581d:	e8 7a f8 ff ff       	call   8010509c <acquire>
  if (m->locked == 1){ //mutex is locked so push the thread into the queue
80105822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105825:	8b 40 08             	mov    0x8(%eax),%eax
80105828:	83 f8 01             	cmp    $0x1,%eax
8010582b:	75 5b                	jne    80105888 <kthread_mutex_lock+0x9b>
	 //   cprintf("the mutax is locked so thread %d is queued\n", thread->pid);
		pushThreadToMutexQueue(thread, m);
8010582d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105833:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105836:	89 54 24 04          	mov    %edx,0x4(%esp)
8010583a:	89 04 24             	mov    %eax,(%esp)
8010583d:	e8 f8 fd ff ff       	call   8010563a <pushThreadToMutexQueue>
		acquire(&ptable.lock);
80105842:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105849:	e8 4e f8 ff ff       	call   8010509c <acquire>
		thread->state =BLOCKED;
8010584e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105854:	c7 40 04 06 00 00 00 	movl   $0x6,0x4(%eax)
		release(m->queueLock);
8010585b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585e:	8b 40 54             	mov    0x54(%eax),%eax
80105861:	89 04 24             	mov    %eax,(%esp)
80105864:	e8 95 f8 ff ff       	call   801050fe <release>
		//cprintf("***************** %d \n", cpu->ncli);
		sched();
80105869:	e8 f4 f3 ff ff       	call   80104c62 <sched>
		acquire(m->queueLock);
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	8b 40 54             	mov    0x54(%eax),%eax
80105874:	89 04 24             	mov    %eax,(%esp)
80105877:	e8 20 f8 ff ff       	call   8010509c <acquire>
		release(&ptable.lock);
8010587c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105883:	e8 76 f8 ff ff       	call   801050fe <release>

  }
 //cprintf("the mutax is unlocked so thread %d is locking it\n", thread->pid);
  m->locked = 1;
80105888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

  release(m->queueLock);
80105892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105895:	8b 40 54             	mov    0x54(%eax),%eax
80105898:	89 04 24             	mov    %eax,(%esp)
8010589b:	e8 5e f8 ff ff       	call   801050fe <release>
  return 0;
801058a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    

801058a7 <kthread_mutex_unlock>:

int kthread_mutex_unlock(int mutex_id){
801058a7:	55                   	push   %ebp
801058a8:	89 e5                	mov    %esp,%ebp
801058aa:	83 ec 28             	sub    $0x28,%esp



  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];
801058ad:	8b 45 08             	mov    0x8(%ebp),%eax
801058b0:	6b c0 58             	imul   $0x58,%eax,%eax
801058b3:	05 c0 c6 11 80       	add    $0x8011c6c0,%eax
801058b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct thread *t;

  if (m->state==UNUSED_MUTEX){
801058bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058be:	8b 00                	mov    (%eax),%eax
801058c0:	85 c0                	test   %eax,%eax
801058c2:	75 0a                	jne    801058ce <kthread_mutex_unlock+0x27>

			return -1;
801058c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c9:	e9 90 00 00 00       	jmp    8010595e <kthread_mutex_unlock+0xb7>
	  }
  acquire(m->queueLock);
801058ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d1:	8b 40 54             	mov    0x54(%eax),%eax
801058d4:	89 04 24             	mov    %eax,(%esp)
801058d7:	e8 c0 f7 ff ff       	call   8010509c <acquire>

  if(m->locked == 0){   //mutex is unlocked already
801058dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058df:	8b 40 08             	mov    0x8(%eax),%eax
801058e2:	85 c0                	test   %eax,%eax
801058e4:	75 15                	jne    801058fb <kthread_mutex_unlock+0x54>
	  release(m->queueLock);
801058e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e9:	8b 40 54             	mov    0x54(%eax),%eax
801058ec:	89 04 24             	mov    %eax,(%esp)
801058ef:	e8 0a f8 ff ff       	call   801050fe <release>
	  return -1;
801058f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f9:	eb 63                	jmp    8010595e <kthread_mutex_unlock+0xb7>
  }

  if(!EmptyQueue(m)){ // someone is waiting
801058fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058fe:	89 04 24             	mov    %eax,(%esp)
80105901:	e8 21 fd ff ff       	call   80105627 <EmptyQueue>
80105906:	85 c0                	test   %eax,%eax
80105908:	75 37                	jne    80105941 <kthread_mutex_unlock+0x9a>
      t =  popThreadToMutexQueue(m);
8010590a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590d:	89 04 24             	mov    %eax,(%esp)
80105910:	e8 63 fd ff ff       	call   80105678 <popThreadToMutexQueue>
80105915:	89 45 f0             	mov    %eax,-0x10(%ebp)
      acquire(&ptable.lock);
80105918:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010591f:	e8 78 f7 ff ff       	call   8010509c <acquire>
      t->state = RUNNABLE;
80105924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105927:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
      release(&ptable.lock);
8010592e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105935:	e8 c4 f7 ff ff       	call   801050fe <release>
      return 0;
8010593a:	b8 00 00 00 00       	mov    $0x0,%eax
8010593f:	eb 1d                	jmp    8010595e <kthread_mutex_unlock+0xb7>
  }

  //no one is waiting
  m->locked = 0;
80105941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105944:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  release(m->queueLock);
8010594b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594e:	8b 40 54             	mov    0x54(%eax),%eax
80105951:	89 04 24             	mov    %eax,(%esp)
80105954:	e8 a5 f7 ff ff       	call   801050fe <release>
  return 0;
80105959:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    

80105960 <kthread_mutex_yieldlock>:



int kthread_mutex_yieldlock(int mutex_id1, int mutex_id2){
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 28             	sub    $0x28,%esp
  struct kthread_mutex_t *m1, *m2;
  struct thread *t=0;
80105966:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  m1 = &mutextable.mutexes[mutex_id1];
8010596d:	8b 45 08             	mov    0x8(%ebp),%eax
80105970:	6b c0 58             	imul   $0x58,%eax,%eax
80105973:	05 c0 c6 11 80       	add    $0x8011c6c0,%eax
80105978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m2 = &mutextable.mutexes[mutex_id2];
8010597b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010597e:	6b c0 58             	imul   $0x58,%eax,%eax
80105981:	05 c0 c6 11 80       	add    $0x8011c6c0,%eax
80105986:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if(m1->locked == 0){
80105989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598c:	8b 40 08             	mov    0x8(%eax),%eax
8010598f:	85 c0                	test   %eax,%eax
80105991:	75 0a                	jne    8010599d <kthread_mutex_yieldlock+0x3d>
    return -1;
80105993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105998:	e9 b8 00 00 00       	jmp    80105a55 <kthread_mutex_yieldlock+0xf5>
  }

  acquire(m2->queueLock);
8010599d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059a0:	8b 40 54             	mov    0x54(%eax),%eax
801059a3:	89 04 24             	mov    %eax,(%esp)
801059a6:	e8 f1 f6 ff ff       	call   8010509c <acquire>
  if (!EmptyQueue(m2)){ 					//someone is waiting in mutex_id2
801059ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059ae:	89 04 24             	mov    %eax,(%esp)
801059b1:	e8 71 fc ff ff       	call   80105627 <EmptyQueue>
801059b6:	85 c0                	test   %eax,%eax
801059b8:	75 6c                	jne    80105a26 <kthread_mutex_yieldlock+0xc6>


	    t =  popThreadToMutexQueue( m2);
801059ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059bd:	89 04 24             	mov    %eax,(%esp)
801059c0:	e8 b3 fc ff ff       	call   80105678 <popThreadToMutexQueue>
801059c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	    acquire(&ptable.lock);
801059c8:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801059cf:	e8 c8 f6 ff ff       	call   8010509c <acquire>
	    thread->state =BLOCKED;
801059d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059da:	c7 40 04 06 00 00 00 	movl   $0x6,0x4(%eax)
	    t->state = RUNNABLE;
801059e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e4:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	    pushThreadToMutexQueue(thread, m2);
801059eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059f4:	89 54 24 04          	mov    %edx,0x4(%esp)
801059f8:	89 04 24             	mov    %eax,(%esp)
801059fb:	e8 3a fc ff ff       	call   8010563a <pushThreadToMutexQueue>
		release(m2->queueLock);
80105a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a03:	8b 40 54             	mov    0x54(%eax),%eax
80105a06:	89 04 24             	mov    %eax,(%esp)
80105a09:	e8 f0 f6 ff ff       	call   801050fe <release>
		sched();
80105a0e:	e8 4f f2 ff ff       	call   80104c62 <sched>

		release(&ptable.lock);
80105a13:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105a1a:	e8 df f6 ff ff       	call   801050fe <release>

		return 0;
80105a1f:	b8 00 00 00 00       	mov    $0x0,%eax
80105a24:	eb 2f                	jmp    80105a55 <kthread_mutex_yieldlock+0xf5>
  }


   // no one is waiting in mutex_id2

   release(m2->queueLock);
80105a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a29:	8b 40 54             	mov    0x54(%eax),%eax
80105a2c:	89 04 24             	mov    %eax,(%esp)
80105a2f:	e8 ca f6 ff ff       	call   801050fe <release>
   kthread_mutex_unlock(m2->id);
80105a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a37:	8b 40 04             	mov    0x4(%eax),%eax
80105a3a:	89 04 24             	mov    %eax,(%esp)
80105a3d:	e8 65 fe ff ff       	call   801058a7 <kthread_mutex_unlock>
   kthread_mutex_unlock(m1->id);
80105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a45:	8b 40 04             	mov    0x4(%eax),%eax
80105a48:	89 04 24             	mov    %eax,(%esp)
80105a4b:	e8 57 fe ff ff       	call   801058a7 <kthread_mutex_unlock>


   return 0;
80105a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    

80105a57 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105a57:	55                   	push   %ebp
80105a58:	89 e5                	mov    %esp,%ebp
80105a5a:	57                   	push   %edi
80105a5b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a5f:	8b 55 10             	mov    0x10(%ebp),%edx
80105a62:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a65:	89 cb                	mov    %ecx,%ebx
80105a67:	89 df                	mov    %ebx,%edi
80105a69:	89 d1                	mov    %edx,%ecx
80105a6b:	fc                   	cld    
80105a6c:	f3 aa                	rep stos %al,%es:(%edi)
80105a6e:	89 ca                	mov    %ecx,%edx
80105a70:	89 fb                	mov    %edi,%ebx
80105a72:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a75:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105a78:	5b                   	pop    %ebx
80105a79:	5f                   	pop    %edi
80105a7a:	5d                   	pop    %ebp
80105a7b:	c3                   	ret    

80105a7c <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105a7c:	55                   	push   %ebp
80105a7d:	89 e5                	mov    %esp,%ebp
80105a7f:	57                   	push   %edi
80105a80:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105a81:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a84:	8b 55 10             	mov    0x10(%ebp),%edx
80105a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a8a:	89 cb                	mov    %ecx,%ebx
80105a8c:	89 df                	mov    %ebx,%edi
80105a8e:	89 d1                	mov    %edx,%ecx
80105a90:	fc                   	cld    
80105a91:	f3 ab                	rep stos %eax,%es:(%edi)
80105a93:	89 ca                	mov    %ecx,%edx
80105a95:	89 fb                	mov    %edi,%ebx
80105a97:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105a9d:	5b                   	pop    %ebx
80105a9e:	5f                   	pop    %edi
80105a9f:	5d                   	pop    %ebp
80105aa0:	c3                   	ret    

80105aa1 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105aa1:	55                   	push   %ebp
80105aa2:	89 e5                	mov    %esp,%ebp
80105aa4:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80105aaa:	83 e0 03             	and    $0x3,%eax
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	75 49                	jne    80105afa <memset+0x59>
80105ab1:	8b 45 10             	mov    0x10(%ebp),%eax
80105ab4:	83 e0 03             	and    $0x3,%eax
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	75 3f                	jne    80105afa <memset+0x59>
    c &= 0xFF;
80105abb:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105ac2:	8b 45 10             	mov    0x10(%ebp),%eax
80105ac5:	c1 e8 02             	shr    $0x2,%eax
80105ac8:	89 c2                	mov    %eax,%edx
80105aca:	8b 45 0c             	mov    0xc(%ebp),%eax
80105acd:	c1 e0 18             	shl    $0x18,%eax
80105ad0:	89 c1                	mov    %eax,%ecx
80105ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ad5:	c1 e0 10             	shl    $0x10,%eax
80105ad8:	09 c1                	or     %eax,%ecx
80105ada:	8b 45 0c             	mov    0xc(%ebp),%eax
80105add:	c1 e0 08             	shl    $0x8,%eax
80105ae0:	09 c8                	or     %ecx,%eax
80105ae2:	0b 45 0c             	or     0xc(%ebp),%eax
80105ae5:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aed:	8b 45 08             	mov    0x8(%ebp),%eax
80105af0:	89 04 24             	mov    %eax,(%esp)
80105af3:	e8 84 ff ff ff       	call   80105a7c <stosl>
80105af8:	eb 19                	jmp    80105b13 <memset+0x72>
  } else
    stosb(dst, c, n);
80105afa:	8b 45 10             	mov    0x10(%ebp),%eax
80105afd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b01:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b04:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b08:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0b:	89 04 24             	mov    %eax,(%esp)
80105b0e:	e8 44 ff ff ff       	call   80105a57 <stosb>
  return dst;
80105b13:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105b16:	c9                   	leave  
80105b17:	c3                   	ret    

80105b18 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105b18:	55                   	push   %ebp
80105b19:	89 e5                	mov    %esp,%ebp
80105b1b:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80105b21:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105b2a:	eb 30                	jmp    80105b5c <memcmp+0x44>
    if(*s1 != *s2)
80105b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b2f:	0f b6 10             	movzbl (%eax),%edx
80105b32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b35:	0f b6 00             	movzbl (%eax),%eax
80105b38:	38 c2                	cmp    %al,%dl
80105b3a:	74 18                	je     80105b54 <memcmp+0x3c>
      return *s1 - *s2;
80105b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3f:	0f b6 00             	movzbl (%eax),%eax
80105b42:	0f b6 d0             	movzbl %al,%edx
80105b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b48:	0f b6 00             	movzbl (%eax),%eax
80105b4b:	0f b6 c0             	movzbl %al,%eax
80105b4e:	29 c2                	sub    %eax,%edx
80105b50:	89 d0                	mov    %edx,%eax
80105b52:	eb 1a                	jmp    80105b6e <memcmp+0x56>
    s1++, s2++;
80105b54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b58:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
80105b5f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b62:	89 55 10             	mov    %edx,0x10(%ebp)
80105b65:	85 c0                	test   %eax,%eax
80105b67:	75 c3                	jne    80105b2c <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b6e:	c9                   	leave  
80105b6f:	c3                   	ret    

80105b70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b79:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b85:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b88:	73 3d                	jae    80105bc7 <memmove+0x57>
80105b8a:	8b 45 10             	mov    0x10(%ebp),%eax
80105b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b90:	01 d0                	add    %edx,%eax
80105b92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b95:	76 30                	jbe    80105bc7 <memmove+0x57>
    s += n;
80105b97:	8b 45 10             	mov    0x10(%ebp),%eax
80105b9a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105b9d:	8b 45 10             	mov    0x10(%ebp),%eax
80105ba0:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105ba3:	eb 13                	jmp    80105bb8 <memmove+0x48>
      *--d = *--s;
80105ba5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105ba9:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bb0:	0f b6 10             	movzbl (%eax),%edx
80105bb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105bb6:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105bb8:	8b 45 10             	mov    0x10(%ebp),%eax
80105bbb:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bbe:	89 55 10             	mov    %edx,0x10(%ebp)
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	75 e0                	jne    80105ba5 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105bc5:	eb 26                	jmp    80105bed <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105bc7:	eb 17                	jmp    80105be0 <memmove+0x70>
      *d++ = *s++;
80105bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105bcc:	8d 50 01             	lea    0x1(%eax),%edx
80105bcf:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105bd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bd5:	8d 4a 01             	lea    0x1(%edx),%ecx
80105bd8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105bdb:	0f b6 12             	movzbl (%edx),%edx
80105bde:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105be0:	8b 45 10             	mov    0x10(%ebp),%eax
80105be3:	8d 50 ff             	lea    -0x1(%eax),%edx
80105be6:	89 55 10             	mov    %edx,0x10(%ebp)
80105be9:	85 c0                	test   %eax,%eax
80105beb:	75 dc                	jne    80105bc9 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105bed:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105bf0:	c9                   	leave  
80105bf1:	c3                   	ret    

80105bf2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105bf2:	55                   	push   %ebp
80105bf3:	89 e5                	mov    %esp,%ebp
80105bf5:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80105bfb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c02:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c06:	8b 45 08             	mov    0x8(%ebp),%eax
80105c09:	89 04 24             	mov    %eax,(%esp)
80105c0c:	e8 5f ff ff ff       	call   80105b70 <memmove>
}
80105c11:	c9                   	leave  
80105c12:	c3                   	ret    

80105c13 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105c13:	55                   	push   %ebp
80105c14:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105c16:	eb 0c                	jmp    80105c24 <strncmp+0x11>
    n--, p++, q++;
80105c18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105c1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105c20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c28:	74 1a                	je     80105c44 <strncmp+0x31>
80105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c2d:	0f b6 00             	movzbl (%eax),%eax
80105c30:	84 c0                	test   %al,%al
80105c32:	74 10                	je     80105c44 <strncmp+0x31>
80105c34:	8b 45 08             	mov    0x8(%ebp),%eax
80105c37:	0f b6 10             	movzbl (%eax),%edx
80105c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c3d:	0f b6 00             	movzbl (%eax),%eax
80105c40:	38 c2                	cmp    %al,%dl
80105c42:	74 d4                	je     80105c18 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105c44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c48:	75 07                	jne    80105c51 <strncmp+0x3e>
    return 0;
80105c4a:	b8 00 00 00 00       	mov    $0x0,%eax
80105c4f:	eb 16                	jmp    80105c67 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105c51:	8b 45 08             	mov    0x8(%ebp),%eax
80105c54:	0f b6 00             	movzbl (%eax),%eax
80105c57:	0f b6 d0             	movzbl %al,%edx
80105c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c5d:	0f b6 00             	movzbl (%eax),%eax
80105c60:	0f b6 c0             	movzbl %al,%eax
80105c63:	29 c2                	sub    %eax,%edx
80105c65:	89 d0                	mov    %edx,%eax
}
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    

80105c69 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105c69:	55                   	push   %ebp
80105c6a:	89 e5                	mov    %esp,%ebp
80105c6c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c72:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105c75:	90                   	nop
80105c76:	8b 45 10             	mov    0x10(%ebp),%eax
80105c79:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c7c:	89 55 10             	mov    %edx,0x10(%ebp)
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	7e 1e                	jle    80105ca1 <strncpy+0x38>
80105c83:	8b 45 08             	mov    0x8(%ebp),%eax
80105c86:	8d 50 01             	lea    0x1(%eax),%edx
80105c89:	89 55 08             	mov    %edx,0x8(%ebp)
80105c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c8f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105c92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105c95:	0f b6 12             	movzbl (%edx),%edx
80105c98:	88 10                	mov    %dl,(%eax)
80105c9a:	0f b6 00             	movzbl (%eax),%eax
80105c9d:	84 c0                	test   %al,%al
80105c9f:	75 d5                	jne    80105c76 <strncpy+0xd>
    ;
  while(n-- > 0)
80105ca1:	eb 0c                	jmp    80105caf <strncpy+0x46>
    *s++ = 0;
80105ca3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca6:	8d 50 01             	lea    0x1(%eax),%edx
80105ca9:	89 55 08             	mov    %edx,0x8(%ebp)
80105cac:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105caf:	8b 45 10             	mov    0x10(%ebp),%eax
80105cb2:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cb5:	89 55 10             	mov    %edx,0x10(%ebp)
80105cb8:	85 c0                	test   %eax,%eax
80105cba:	7f e7                	jg     80105ca3 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105cbf:	c9                   	leave  
80105cc0:	c3                   	ret    

80105cc1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105cc1:	55                   	push   %ebp
80105cc2:	89 e5                	mov    %esp,%ebp
80105cc4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80105cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105ccd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105cd1:	7f 05                	jg     80105cd8 <safestrcpy+0x17>
    return os;
80105cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cd6:	eb 31                	jmp    80105d09 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105cd8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105cdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ce0:	7e 1e                	jle    80105d00 <safestrcpy+0x3f>
80105ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce5:	8d 50 01             	lea    0x1(%eax),%edx
80105ce8:	89 55 08             	mov    %edx,0x8(%ebp)
80105ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cee:	8d 4a 01             	lea    0x1(%edx),%ecx
80105cf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105cf4:	0f b6 12             	movzbl (%edx),%edx
80105cf7:	88 10                	mov    %dl,(%eax)
80105cf9:	0f b6 00             	movzbl (%eax),%eax
80105cfc:	84 c0                	test   %al,%al
80105cfe:	75 d8                	jne    80105cd8 <safestrcpy+0x17>
    ;
  *s = 0;
80105d00:	8b 45 08             	mov    0x8(%ebp),%eax
80105d03:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d09:	c9                   	leave  
80105d0a:	c3                   	ret    

80105d0b <strlen>:

int
strlen(const char *s)
{
80105d0b:	55                   	push   %ebp
80105d0c:	89 e5                	mov    %esp,%ebp
80105d0e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d18:	eb 04                	jmp    80105d1e <strlen+0x13>
80105d1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d21:	8b 45 08             	mov    0x8(%ebp),%eax
80105d24:	01 d0                	add    %edx,%eax
80105d26:	0f b6 00             	movzbl (%eax),%eax
80105d29:	84 c0                	test   %al,%al
80105d2b:	75 ed                	jne    80105d1a <strlen+0xf>
    ;
  return n;
80105d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d30:	c9                   	leave  
80105d31:	c3                   	ret    

80105d32 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105d32:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105d36:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105d3a:	55                   	push   %ebp
  pushl %ebx
80105d3b:	53                   	push   %ebx
  pushl %esi
80105d3c:	56                   	push   %esi
  pushl %edi
80105d3d:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105d3e:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105d40:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105d42:	5f                   	pop    %edi
  popl %esi
80105d43:	5e                   	pop    %esi
  popl %ebx
80105d44:	5b                   	pop    %ebx
  popl %ebp
80105d45:	5d                   	pop    %ebp
  ret
80105d46:	c3                   	ret    

80105d47 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105d47:	55                   	push   %ebp
80105d48:	89 e5                	mov    %esp,%ebp
  if(addr >= thread->proc->sz || addr+4 > thread->proc->sz)
80105d4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d50:	8b 40 0c             	mov    0xc(%eax),%eax
80105d53:	8b 00                	mov    (%eax),%eax
80105d55:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d58:	76 15                	jbe    80105d6f <fetchint+0x28>
80105d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d5d:	8d 50 04             	lea    0x4(%eax),%edx
80105d60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d66:	8b 40 0c             	mov    0xc(%eax),%eax
80105d69:	8b 00                	mov    (%eax),%eax
80105d6b:	39 c2                	cmp    %eax,%edx
80105d6d:	76 07                	jbe    80105d76 <fetchint+0x2f>
    return -1;
80105d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d74:	eb 0f                	jmp    80105d85 <fetchint+0x3e>
  *ip = *(int*)(addr);
80105d76:	8b 45 08             	mov    0x8(%ebp),%eax
80105d79:	8b 10                	mov    (%eax),%edx
80105d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d7e:	89 10                	mov    %edx,(%eax)
  return 0;
80105d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d85:	5d                   	pop    %ebp
80105d86:	c3                   	ret    

80105d87 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105d87:	55                   	push   %ebp
80105d88:	89 e5                	mov    %esp,%ebp
80105d8a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= thread->proc->sz)
80105d8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d93:	8b 40 0c             	mov    0xc(%eax),%eax
80105d96:	8b 00                	mov    (%eax),%eax
80105d98:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d9b:	77 07                	ja     80105da4 <fetchstr+0x1d>
    return -1;
80105d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da2:	eb 49                	jmp    80105ded <fetchstr+0x66>
  *pp = (char*)addr;
80105da4:	8b 55 08             	mov    0x8(%ebp),%edx
80105da7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105daa:	89 10                	mov    %edx,(%eax)
  ep = (char*)thread->proc->sz;
80105dac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105db2:	8b 40 0c             	mov    0xc(%eax),%eax
80105db5:	8b 00                	mov    (%eax),%eax
80105db7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dbd:	8b 00                	mov    (%eax),%eax
80105dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105dc2:	eb 1c                	jmp    80105de0 <fetchstr+0x59>
    if(*s == 0)
80105dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105dc7:	0f b6 00             	movzbl (%eax),%eax
80105dca:	84 c0                	test   %al,%al
80105dcc:	75 0e                	jne    80105ddc <fetchstr+0x55>
      return s - *pp;
80105dce:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dd4:	8b 00                	mov    (%eax),%eax
80105dd6:	29 c2                	sub    %eax,%edx
80105dd8:	89 d0                	mov    %edx,%eax
80105dda:	eb 11                	jmp    80105ded <fetchstr+0x66>

  if(addr >= thread->proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)thread->proc->sz;
  for(s = *pp; s < ep; s++)
80105ddc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105de3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105de6:	72 dc                	jb     80105dc4 <fetchstr+0x3d>
    if(*s == 0)
      return s - *pp;
  return -1;
80105de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ded:	c9                   	leave  
80105dee:	c3                   	ret    

80105def <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105def:	55                   	push   %ebp
80105df0:	89 e5                	mov    %esp,%ebp
80105df2:	83 ec 08             	sub    $0x8,%esp
  return fetchint(thread->tf->esp + 4 + 4*n, ip);
80105df5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dfb:	8b 40 10             	mov    0x10(%eax),%eax
80105dfe:	8b 50 44             	mov    0x44(%eax),%edx
80105e01:	8b 45 08             	mov    0x8(%ebp),%eax
80105e04:	c1 e0 02             	shl    $0x2,%eax
80105e07:	01 d0                	add    %edx,%eax
80105e09:	8d 50 04             	lea    0x4(%eax),%edx
80105e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e13:	89 14 24             	mov    %edx,(%esp)
80105e16:	e8 2c ff ff ff       	call   80105d47 <fetchint>
}
80105e1b:	c9                   	leave  
80105e1c:	c3                   	ret    

80105e1d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105e1d:	55                   	push   %ebp
80105e1e:	89 e5                	mov    %esp,%ebp
80105e20:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105e23:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105e26:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80105e2d:	89 04 24             	mov    %eax,(%esp)
80105e30:	e8 ba ff ff ff       	call   80105def <argint>
80105e35:	85 c0                	test   %eax,%eax
80105e37:	79 07                	jns    80105e40 <argptr+0x23>
    return -1;
80105e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3e:	eb 43                	jmp    80105e83 <argptr+0x66>
  if((uint)i >= thread->proc->sz || (uint)i+size > thread->proc->sz)
80105e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e43:	89 c2                	mov    %eax,%edx
80105e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e4b:	8b 40 0c             	mov    0xc(%eax),%eax
80105e4e:	8b 00                	mov    (%eax),%eax
80105e50:	39 c2                	cmp    %eax,%edx
80105e52:	73 19                	jae    80105e6d <argptr+0x50>
80105e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e57:	89 c2                	mov    %eax,%edx
80105e59:	8b 45 10             	mov    0x10(%ebp),%eax
80105e5c:	01 c2                	add    %eax,%edx
80105e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e64:	8b 40 0c             	mov    0xc(%eax),%eax
80105e67:	8b 00                	mov    (%eax),%eax
80105e69:	39 c2                	cmp    %eax,%edx
80105e6b:	76 07                	jbe    80105e74 <argptr+0x57>
    return -1;
80105e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e72:	eb 0f                	jmp    80105e83 <argptr+0x66>
  *pp = (char*)i;
80105e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e77:	89 c2                	mov    %eax,%edx
80105e79:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e7c:	89 10                	mov    %edx,(%eax)
  return 0;
80105e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e83:	c9                   	leave  
80105e84:	c3                   	ret    

80105e85 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105e85:	55                   	push   %ebp
80105e86:	89 e5                	mov    %esp,%ebp
80105e88:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105e8b:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e92:	8b 45 08             	mov    0x8(%ebp),%eax
80105e95:	89 04 24             	mov    %eax,(%esp)
80105e98:	e8 52 ff ff ff       	call   80105def <argint>
80105e9d:	85 c0                	test   %eax,%eax
80105e9f:	79 07                	jns    80105ea8 <argstr+0x23>
    return -1;
80105ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea6:	eb 12                	jmp    80105eba <argstr+0x35>
  return fetchstr(addr, pp);
80105ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105eab:	8b 55 0c             	mov    0xc(%ebp),%edx
80105eae:	89 54 24 04          	mov    %edx,0x4(%esp)
80105eb2:	89 04 24             	mov    %eax,(%esp)
80105eb5:	e8 cd fe ff ff       	call   80105d87 <fetchstr>
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    

80105ebc <syscall>:

};

void
syscall(void)
{
80105ebc:	55                   	push   %ebp
80105ebd:	89 e5                	mov    %esp,%ebp
80105ebf:	53                   	push   %ebx
80105ec0:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = thread->tf->eax;
80105ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ec9:	8b 40 10             	mov    0x10(%eax),%eax
80105ecc:	8b 40 1c             	mov    0x1c(%eax),%eax
80105ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ed6:	7e 30                	jle    80105f08 <syscall+0x4c>
80105ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edb:	83 f8 1e             	cmp    $0x1e,%eax
80105ede:	77 28                	ja     80105f08 <syscall+0x4c>
80105ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee3:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105eea:	85 c0                	test   %eax,%eax
80105eec:	74 1a                	je     80105f08 <syscall+0x4c>
    thread->tf->eax = syscalls[num]();
80105eee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ef4:	8b 58 10             	mov    0x10(%eax),%ebx
80105ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efa:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105f01:	ff d0                	call   *%eax
80105f03:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105f06:	eb 43                	jmp    80105f4b <syscall+0x8f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            thread->proc->pid, thread->proc->name, num);
80105f08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f0e:	8b 40 0c             	mov    0xc(%eax),%eax
80105f11:	8d 48 60             	lea    0x60(%eax),%ecx
80105f14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f1a:	8b 40 0c             	mov    0xc(%eax),%eax

  num = thread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    thread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105f1d:	8b 40 0c             	mov    0xc(%eax),%eax
80105f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f23:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105f27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f2f:	c7 04 24 ae 94 10 80 	movl   $0x801094ae,(%esp)
80105f36:	e8 65 a4 ff ff       	call   801003a0 <cprintf>
            thread->proc->pid, thread->proc->name, num);
    thread->tf->eax = -1;
80105f3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f41:	8b 40 10             	mov    0x10(%eax),%eax
80105f44:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105f4b:	83 c4 24             	add    $0x24,%esp
80105f4e:	5b                   	pop    %ebx
80105f4f:	5d                   	pop    %ebp
80105f50:	c3                   	ret    

80105f51 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105f51:	55                   	push   %ebp
80105f52:	89 e5                	mov    %esp,%ebp
80105f54:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105f57:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80105f61:	89 04 24             	mov    %eax,(%esp)
80105f64:	e8 86 fe ff ff       	call   80105def <argint>
80105f69:	85 c0                	test   %eax,%eax
80105f6b:	79 07                	jns    80105f74 <argfd+0x23>
    return -1;
80105f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f72:	eb 53                	jmp    80105fc7 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=thread->proc->ofile[fd]) == 0)
80105f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f77:	85 c0                	test   %eax,%eax
80105f79:	78 24                	js     80105f9f <argfd+0x4e>
80105f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7e:	83 f8 0f             	cmp    $0xf,%eax
80105f81:	7f 1c                	jg     80105f9f <argfd+0x4e>
80105f83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f89:	8b 40 0c             	mov    0xc(%eax),%eax
80105f8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f8f:	83 c2 04             	add    $0x4,%edx
80105f92:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f9d:	75 07                	jne    80105fa6 <argfd+0x55>
    return -1;
80105f9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa4:	eb 21                	jmp    80105fc7 <argfd+0x76>
  if(pfd)
80105fa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105faa:	74 08                	je     80105fb4 <argfd+0x63>
    *pfd = fd;
80105fac:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105faf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fb2:	89 10                	mov    %edx,(%eax)
  if(pf)
80105fb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105fb8:	74 08                	je     80105fc2 <argfd+0x71>
    *pf = f;
80105fba:	8b 45 10             	mov    0x10(%ebp),%eax
80105fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fc0:	89 10                	mov    %edx,(%eax)
  return 0;
80105fc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fc7:	c9                   	leave  
80105fc8:	c3                   	ret    

80105fc9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105fc9:	55                   	push   %ebp
80105fca:	89 e5                	mov    %esp,%ebp
80105fcc:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105fd6:	eb 36                	jmp    8010600e <fdalloc+0x45>
    if(thread->proc->ofile[fd] == 0){
80105fd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fde:	8b 40 0c             	mov    0xc(%eax),%eax
80105fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105fe4:	83 c2 04             	add    $0x4,%edx
80105fe7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105feb:	85 c0                	test   %eax,%eax
80105fed:	75 1b                	jne    8010600a <fdalloc+0x41>
      thread->proc->ofile[fd] = f;
80105fef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ff5:	8b 40 0c             	mov    0xc(%eax),%eax
80105ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ffb:	8d 4a 04             	lea    0x4(%edx),%ecx
80105ffe:	8b 55 08             	mov    0x8(%ebp),%edx
80106001:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
      return fd;
80106005:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106008:	eb 0f                	jmp    80106019 <fdalloc+0x50>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010600a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010600e:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106012:	7e c4                	jle    80105fd8 <fdalloc+0xf>
    if(thread->proc->ofile[fd] == 0){
      thread->proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106019:	c9                   	leave  
8010601a:	c3                   	ret    

8010601b <sys_dup>:

int
sys_dup(void)
{
8010601b:	55                   	push   %ebp
8010601c:	89 e5                	mov    %esp,%ebp
8010601e:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106021:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106024:	89 44 24 08          	mov    %eax,0x8(%esp)
80106028:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010602f:	00 
80106030:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106037:	e8 15 ff ff ff       	call   80105f51 <argfd>
8010603c:	85 c0                	test   %eax,%eax
8010603e:	79 07                	jns    80106047 <sys_dup+0x2c>
    return -1;
80106040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106045:	eb 29                	jmp    80106070 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604a:	89 04 24             	mov    %eax,(%esp)
8010604d:	e8 77 ff ff ff       	call   80105fc9 <fdalloc>
80106052:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106059:	79 07                	jns    80106062 <sys_dup+0x47>
    return -1;
8010605b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106060:	eb 0e                	jmp    80106070 <sys_dup+0x55>
  filedup(f);
80106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106065:	89 04 24             	mov    %eax,(%esp)
80106068:	e8 3b af ff ff       	call   80100fa8 <filedup>
  return fd;
8010606d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106070:	c9                   	leave  
80106071:	c3                   	ret    

80106072 <sys_read>:

int
sys_read(void)
{
80106072:	55                   	push   %ebp
80106073:	89 e5                	mov    %esp,%ebp
80106075:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106078:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010607b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010607f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106086:	00 
80106087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010608e:	e8 be fe ff ff       	call   80105f51 <argfd>
80106093:	85 c0                	test   %eax,%eax
80106095:	78 35                	js     801060cc <sys_read+0x5a>
80106097:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010609a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060a5:	e8 45 fd ff ff       	call   80105def <argint>
801060aa:	85 c0                	test   %eax,%eax
801060ac:	78 1e                	js     801060cc <sys_read+0x5a>
801060ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801060b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801060bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060c3:	e8 55 fd ff ff       	call   80105e1d <argptr>
801060c8:	85 c0                	test   %eax,%eax
801060ca:	79 07                	jns    801060d3 <sys_read+0x61>
    return -1;
801060cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d1:	eb 19                	jmp    801060ec <sys_read+0x7a>
  return fileread(f, p, n);
801060d3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801060d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060dc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801060e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801060e4:	89 04 24             	mov    %eax,(%esp)
801060e7:	e8 29 b0 ff ff       	call   80101115 <fileread>
}
801060ec:	c9                   	leave  
801060ed:	c3                   	ret    

801060ee <sys_write>:

int
sys_write(void)
{
801060ee:	55                   	push   %ebp
801060ef:	89 e5                	mov    %esp,%ebp
801060f1:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801060f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801060fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106102:	00 
80106103:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010610a:	e8 42 fe ff ff       	call   80105f51 <argfd>
8010610f:	85 c0                	test   %eax,%eax
80106111:	78 35                	js     80106148 <sys_write+0x5a>
80106113:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106116:	89 44 24 04          	mov    %eax,0x4(%esp)
8010611a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106121:	e8 c9 fc ff ff       	call   80105def <argint>
80106126:	85 c0                	test   %eax,%eax
80106128:	78 1e                	js     80106148 <sys_write+0x5a>
8010612a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612d:	89 44 24 08          	mov    %eax,0x8(%esp)
80106131:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106134:	89 44 24 04          	mov    %eax,0x4(%esp)
80106138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010613f:	e8 d9 fc ff ff       	call   80105e1d <argptr>
80106144:	85 c0                	test   %eax,%eax
80106146:	79 07                	jns    8010614f <sys_write+0x61>
    return -1;
80106148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614d:	eb 19                	jmp    80106168 <sys_write+0x7a>
  return filewrite(f, p, n);
8010614f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106152:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106158:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010615c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106160:	89 04 24             	mov    %eax,(%esp)
80106163:	e8 69 b0 ff ff       	call   801011d1 <filewrite>
}
80106168:	c9                   	leave  
80106169:	c3                   	ret    

8010616a <sys_close>:

int
sys_close(void)
{
8010616a:	55                   	push   %ebp
8010616b:	89 e5                	mov    %esp,%ebp
8010616d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106170:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106173:	89 44 24 08          	mov    %eax,0x8(%esp)
80106177:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010617a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010617e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106185:	e8 c7 fd ff ff       	call   80105f51 <argfd>
8010618a:	85 c0                	test   %eax,%eax
8010618c:	79 07                	jns    80106195 <sys_close+0x2b>
    return -1;
8010618e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106193:	eb 27                	jmp    801061bc <sys_close+0x52>
  thread->proc->ofile[fd] = 0;
80106195:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010619b:	8b 40 0c             	mov    0xc(%eax),%eax
8010619e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061a1:	83 c2 04             	add    $0x4,%edx
801061a4:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801061ab:	00 
  fileclose(f);
801061ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061af:	89 04 24             	mov    %eax,(%esp)
801061b2:	e8 39 ae ff ff       	call   80100ff0 <fileclose>
  return 0;
801061b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061bc:	c9                   	leave  
801061bd:	c3                   	ret    

801061be <sys_fstat>:

int
sys_fstat(void)
{
801061be:	55                   	push   %ebp
801061bf:	89 e5                	mov    %esp,%ebp
801061c1:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801061c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c7:	89 44 24 08          	mov    %eax,0x8(%esp)
801061cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061d2:	00 
801061d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061da:	e8 72 fd ff ff       	call   80105f51 <argfd>
801061df:	85 c0                	test   %eax,%eax
801061e1:	78 1f                	js     80106202 <sys_fstat+0x44>
801061e3:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801061ea:	00 
801061eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061f9:	e8 1f fc ff ff       	call   80105e1d <argptr>
801061fe:	85 c0                	test   %eax,%eax
80106200:	79 07                	jns    80106209 <sys_fstat+0x4b>
    return -1;
80106202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106207:	eb 12                	jmp    8010621b <sys_fstat+0x5d>
  return filestat(f, st);
80106209:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106213:	89 04 24             	mov    %eax,(%esp)
80106216:	e8 ab ae ff ff       	call   801010c6 <filestat>
}
8010621b:	c9                   	leave  
8010621c:	c3                   	ret    

8010621d <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010621d:	55                   	push   %ebp
8010621e:	89 e5                	mov    %esp,%ebp
80106220:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106223:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106226:	89 44 24 04          	mov    %eax,0x4(%esp)
8010622a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106231:	e8 4f fc ff ff       	call   80105e85 <argstr>
80106236:	85 c0                	test   %eax,%eax
80106238:	78 17                	js     80106251 <sys_link+0x34>
8010623a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010623d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106248:	e8 38 fc ff ff       	call   80105e85 <argstr>
8010624d:	85 c0                	test   %eax,%eax
8010624f:	79 0a                	jns    8010625b <sys_link+0x3e>
    return -1;
80106251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106256:	e9 42 01 00 00       	jmp    8010639d <sys_link+0x180>

  begin_op();
8010625b:	e8 d5 d1 ff ff       	call   80103435 <begin_op>
  if((ip = namei(old)) == 0){
80106260:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106263:	89 04 24             	mov    %eax,(%esp)
80106266:	e8 c0 c1 ff ff       	call   8010242b <namei>
8010626b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010626e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106272:	75 0f                	jne    80106283 <sys_link+0x66>
    end_op();
80106274:	e8 40 d2 ff ff       	call   801034b9 <end_op>
    return -1;
80106279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627e:	e9 1a 01 00 00       	jmp    8010639d <sys_link+0x180>
  }

  ilock(ip);
80106283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106286:	89 04 24             	mov    %eax,(%esp)
80106289:	e8 ef b5 ff ff       	call   8010187d <ilock>
  if(ip->type == T_DIR){
8010628e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106291:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106295:	66 83 f8 01          	cmp    $0x1,%ax
80106299:	75 1a                	jne    801062b5 <sys_link+0x98>
    iunlockput(ip);
8010629b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629e:	89 04 24             	mov    %eax,(%esp)
801062a1:	e8 5b b8 ff ff       	call   80101b01 <iunlockput>
    end_op();
801062a6:	e8 0e d2 ff ff       	call   801034b9 <end_op>
    return -1;
801062ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b0:	e9 e8 00 00 00       	jmp    8010639d <sys_link+0x180>
  }

  ip->nlink++;
801062b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062bc:	8d 50 01             	lea    0x1(%eax),%edx
801062bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c2:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801062c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c9:	89 04 24             	mov    %eax,(%esp)
801062cc:	e8 f0 b3 ff ff       	call   801016c1 <iupdate>
  iunlock(ip);
801062d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d4:	89 04 24             	mov    %eax,(%esp)
801062d7:	e8 ef b6 ff ff       	call   801019cb <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801062dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062df:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801062e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801062e6:	89 04 24             	mov    %eax,(%esp)
801062e9:	e8 5f c1 ff ff       	call   8010244d <nameiparent>
801062ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062f5:	75 02                	jne    801062f9 <sys_link+0xdc>
    goto bad;
801062f7:	eb 68                	jmp    80106361 <sys_link+0x144>
  ilock(dp);
801062f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fc:	89 04 24             	mov    %eax,(%esp)
801062ff:	e8 79 b5 ff ff       	call   8010187d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106304:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106307:	8b 10                	mov    (%eax),%edx
80106309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630c:	8b 00                	mov    (%eax),%eax
8010630e:	39 c2                	cmp    %eax,%edx
80106310:	75 20                	jne    80106332 <sys_link+0x115>
80106312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106315:	8b 40 04             	mov    0x4(%eax),%eax
80106318:	89 44 24 08          	mov    %eax,0x8(%esp)
8010631c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010631f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106323:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106326:	89 04 24             	mov    %eax,(%esp)
80106329:	e8 3a be ff ff       	call   80102168 <dirlink>
8010632e:	85 c0                	test   %eax,%eax
80106330:	79 0d                	jns    8010633f <sys_link+0x122>
    iunlockput(dp);
80106332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106335:	89 04 24             	mov    %eax,(%esp)
80106338:	e8 c4 b7 ff ff       	call   80101b01 <iunlockput>
    goto bad;
8010633d:	eb 22                	jmp    80106361 <sys_link+0x144>
  }
  iunlockput(dp);
8010633f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106342:	89 04 24             	mov    %eax,(%esp)
80106345:	e8 b7 b7 ff ff       	call   80101b01 <iunlockput>
  iput(ip);
8010634a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634d:	89 04 24             	mov    %eax,(%esp)
80106350:	e8 db b6 ff ff       	call   80101a30 <iput>

  end_op();
80106355:	e8 5f d1 ff ff       	call   801034b9 <end_op>

  return 0;
8010635a:	b8 00 00 00 00       	mov    $0x0,%eax
8010635f:	eb 3c                	jmp    8010639d <sys_link+0x180>

bad:
  ilock(ip);
80106361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106364:	89 04 24             	mov    %eax,(%esp)
80106367:	e8 11 b5 ff ff       	call   8010187d <ilock>
  ip->nlink--;
8010636c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010636f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106373:	8d 50 ff             	lea    -0x1(%eax),%edx
80106376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106379:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010637d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106380:	89 04 24             	mov    %eax,(%esp)
80106383:	e8 39 b3 ff ff       	call   801016c1 <iupdate>
  iunlockput(ip);
80106388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638b:	89 04 24             	mov    %eax,(%esp)
8010638e:	e8 6e b7 ff ff       	call   80101b01 <iunlockput>
  end_op();
80106393:	e8 21 d1 ff ff       	call   801034b9 <end_op>
  return -1;
80106398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010639d:	c9                   	leave  
8010639e:	c3                   	ret    

8010639f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010639f:	55                   	push   %ebp
801063a0:	89 e5                	mov    %esp,%ebp
801063a2:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063a5:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801063ac:	eb 4b                	jmp    801063f9 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b1:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801063b8:	00 
801063b9:	89 44 24 08          	mov    %eax,0x8(%esp)
801063bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c4:	8b 45 08             	mov    0x8(%ebp),%eax
801063c7:	89 04 24             	mov    %eax,(%esp)
801063ca:	e8 bb b9 ff ff       	call   80101d8a <readi>
801063cf:	83 f8 10             	cmp    $0x10,%eax
801063d2:	74 0c                	je     801063e0 <isdirempty+0x41>
      panic("isdirempty: readi");
801063d4:	c7 04 24 ca 94 10 80 	movl   $0x801094ca,(%esp)
801063db:	e8 5a a1 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
801063e0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801063e4:	66 85 c0             	test   %ax,%ax
801063e7:	74 07                	je     801063f0 <isdirempty+0x51>
      return 0;
801063e9:	b8 00 00 00 00       	mov    $0x0,%eax
801063ee:	eb 1b                	jmp    8010640b <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f3:	83 c0 10             	add    $0x10,%eax
801063f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063fc:	8b 45 08             	mov    0x8(%ebp),%eax
801063ff:	8b 40 18             	mov    0x18(%eax),%eax
80106402:	39 c2                	cmp    %eax,%edx
80106404:	72 a8                	jb     801063ae <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106406:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010640b:	c9                   	leave  
8010640c:	c3                   	ret    

8010640d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010640d:	55                   	push   %ebp
8010640e:	89 e5                	mov    %esp,%ebp
80106410:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106413:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106416:	89 44 24 04          	mov    %eax,0x4(%esp)
8010641a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106421:	e8 5f fa ff ff       	call   80105e85 <argstr>
80106426:	85 c0                	test   %eax,%eax
80106428:	79 0a                	jns    80106434 <sys_unlink+0x27>
    return -1;
8010642a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642f:	e9 af 01 00 00       	jmp    801065e3 <sys_unlink+0x1d6>

  begin_op();
80106434:	e8 fc cf ff ff       	call   80103435 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106439:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010643c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010643f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106443:	89 04 24             	mov    %eax,(%esp)
80106446:	e8 02 c0 ff ff       	call   8010244d <nameiparent>
8010644b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010644e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106452:	75 0f                	jne    80106463 <sys_unlink+0x56>
    end_op();
80106454:	e8 60 d0 ff ff       	call   801034b9 <end_op>
    return -1;
80106459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645e:	e9 80 01 00 00       	jmp    801065e3 <sys_unlink+0x1d6>
  }

  ilock(dp);
80106463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106466:	89 04 24             	mov    %eax,(%esp)
80106469:	e8 0f b4 ff ff       	call   8010187d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010646e:	c7 44 24 04 dc 94 10 	movl   $0x801094dc,0x4(%esp)
80106475:	80 
80106476:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106479:	89 04 24             	mov    %eax,(%esp)
8010647c:	e8 fc bb ff ff       	call   8010207d <namecmp>
80106481:	85 c0                	test   %eax,%eax
80106483:	0f 84 45 01 00 00    	je     801065ce <sys_unlink+0x1c1>
80106489:	c7 44 24 04 de 94 10 	movl   $0x801094de,0x4(%esp)
80106490:	80 
80106491:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106494:	89 04 24             	mov    %eax,(%esp)
80106497:	e8 e1 bb ff ff       	call   8010207d <namecmp>
8010649c:	85 c0                	test   %eax,%eax
8010649e:	0f 84 2a 01 00 00    	je     801065ce <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801064a4:	8d 45 c8             	lea    -0x38(%ebp),%eax
801064a7:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ab:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801064ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801064b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b5:	89 04 24             	mov    %eax,(%esp)
801064b8:	e8 e2 bb ff ff       	call   8010209f <dirlookup>
801064bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064c4:	75 05                	jne    801064cb <sys_unlink+0xbe>
    goto bad;
801064c6:	e9 03 01 00 00       	jmp    801065ce <sys_unlink+0x1c1>
  ilock(ip);
801064cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ce:	89 04 24             	mov    %eax,(%esp)
801064d1:	e8 a7 b3 ff ff       	call   8010187d <ilock>

  if(ip->nlink < 1)
801064d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801064dd:	66 85 c0             	test   %ax,%ax
801064e0:	7f 0c                	jg     801064ee <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
801064e2:	c7 04 24 e1 94 10 80 	movl   $0x801094e1,(%esp)
801064e9:	e8 4c a0 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801064ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064f5:	66 83 f8 01          	cmp    $0x1,%ax
801064f9:	75 1f                	jne    8010651a <sys_unlink+0x10d>
801064fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fe:	89 04 24             	mov    %eax,(%esp)
80106501:	e8 99 fe ff ff       	call   8010639f <isdirempty>
80106506:	85 c0                	test   %eax,%eax
80106508:	75 10                	jne    8010651a <sys_unlink+0x10d>
    iunlockput(ip);
8010650a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650d:	89 04 24             	mov    %eax,(%esp)
80106510:	e8 ec b5 ff ff       	call   80101b01 <iunlockput>
    goto bad;
80106515:	e9 b4 00 00 00       	jmp    801065ce <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
8010651a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106521:	00 
80106522:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106529:	00 
8010652a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010652d:	89 04 24             	mov    %eax,(%esp)
80106530:	e8 6c f5 ff ff       	call   80105aa1 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106535:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106538:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010653f:	00 
80106540:	89 44 24 08          	mov    %eax,0x8(%esp)
80106544:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106547:	89 44 24 04          	mov    %eax,0x4(%esp)
8010654b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010654e:	89 04 24             	mov    %eax,(%esp)
80106551:	e8 98 b9 ff ff       	call   80101eee <writei>
80106556:	83 f8 10             	cmp    $0x10,%eax
80106559:	74 0c                	je     80106567 <sys_unlink+0x15a>
    panic("unlink: writei");
8010655b:	c7 04 24 f3 94 10 80 	movl   $0x801094f3,(%esp)
80106562:	e8 d3 9f ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80106567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010656a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010656e:	66 83 f8 01          	cmp    $0x1,%ax
80106572:	75 1c                	jne    80106590 <sys_unlink+0x183>
    dp->nlink--;
80106574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106577:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010657b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010657e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106581:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106588:	89 04 24             	mov    %eax,(%esp)
8010658b:	e8 31 b1 ff ff       	call   801016c1 <iupdate>
  }
  iunlockput(dp);
80106590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106593:	89 04 24             	mov    %eax,(%esp)
80106596:	e8 66 b5 ff ff       	call   80101b01 <iunlockput>

  ip->nlink--;
8010659b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010659e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801065a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801065ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065af:	89 04 24             	mov    %eax,(%esp)
801065b2:	e8 0a b1 ff ff       	call   801016c1 <iupdate>
  iunlockput(ip);
801065b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ba:	89 04 24             	mov    %eax,(%esp)
801065bd:	e8 3f b5 ff ff       	call   80101b01 <iunlockput>

  end_op();
801065c2:	e8 f2 ce ff ff       	call   801034b9 <end_op>

  return 0;
801065c7:	b8 00 00 00 00       	mov    $0x0,%eax
801065cc:	eb 15                	jmp    801065e3 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
801065ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d1:	89 04 24             	mov    %eax,(%esp)
801065d4:	e8 28 b5 ff ff       	call   80101b01 <iunlockput>
  end_op();
801065d9:	e8 db ce ff ff       	call   801034b9 <end_op>
  return -1;
801065de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065e3:	c9                   	leave  
801065e4:	c3                   	ret    

801065e5 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801065e5:	55                   	push   %ebp
801065e6:	89 e5                	mov    %esp,%ebp
801065e8:	83 ec 48             	sub    $0x48,%esp
801065eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801065ee:	8b 55 10             	mov    0x10(%ebp),%edx
801065f1:	8b 45 14             	mov    0x14(%ebp),%eax
801065f4:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801065f8:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801065fc:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106600:	8d 45 de             	lea    -0x22(%ebp),%eax
80106603:	89 44 24 04          	mov    %eax,0x4(%esp)
80106607:	8b 45 08             	mov    0x8(%ebp),%eax
8010660a:	89 04 24             	mov    %eax,(%esp)
8010660d:	e8 3b be ff ff       	call   8010244d <nameiparent>
80106612:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106619:	75 0a                	jne    80106625 <create+0x40>
    return 0;
8010661b:	b8 00 00 00 00       	mov    $0x0,%eax
80106620:	e9 7e 01 00 00       	jmp    801067a3 <create+0x1be>
  ilock(dp);
80106625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106628:	89 04 24             	mov    %eax,(%esp)
8010662b:	e8 4d b2 ff ff       	call   8010187d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106630:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106633:	89 44 24 08          	mov    %eax,0x8(%esp)
80106637:	8d 45 de             	lea    -0x22(%ebp),%eax
8010663a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106641:	89 04 24             	mov    %eax,(%esp)
80106644:	e8 56 ba ff ff       	call   8010209f <dirlookup>
80106649:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010664c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106650:	74 47                	je     80106699 <create+0xb4>
    iunlockput(dp);
80106652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106655:	89 04 24             	mov    %eax,(%esp)
80106658:	e8 a4 b4 ff ff       	call   80101b01 <iunlockput>
    ilock(ip);
8010665d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106660:	89 04 24             	mov    %eax,(%esp)
80106663:	e8 15 b2 ff ff       	call   8010187d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106668:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010666d:	75 15                	jne    80106684 <create+0x9f>
8010666f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106672:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106676:	66 83 f8 02          	cmp    $0x2,%ax
8010667a:	75 08                	jne    80106684 <create+0x9f>
      return ip;
8010667c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010667f:	e9 1f 01 00 00       	jmp    801067a3 <create+0x1be>
    iunlockput(ip);
80106684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106687:	89 04 24             	mov    %eax,(%esp)
8010668a:	e8 72 b4 ff ff       	call   80101b01 <iunlockput>
    return 0;
8010668f:	b8 00 00 00 00       	mov    $0x0,%eax
80106694:	e9 0a 01 00 00       	jmp    801067a3 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106699:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010669d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a0:	8b 00                	mov    (%eax),%eax
801066a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801066a6:	89 04 24             	mov    %eax,(%esp)
801066a9:	e8 34 af ff ff       	call   801015e2 <ialloc>
801066ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066b5:	75 0c                	jne    801066c3 <create+0xde>
    panic("create: ialloc");
801066b7:	c7 04 24 02 95 10 80 	movl   $0x80109502,(%esp)
801066be:	e8 77 9e ff ff       	call   8010053a <panic>

  ilock(ip);
801066c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c6:	89 04 24             	mov    %eax,(%esp)
801066c9:	e8 af b1 ff ff       	call   8010187d <ilock>
  ip->major = major;
801066ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066d1:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801066d5:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801066d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066dc:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801066e0:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801066e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e7:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801066ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f0:	89 04 24             	mov    %eax,(%esp)
801066f3:	e8 c9 af ff ff       	call   801016c1 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801066f8:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801066fd:	75 6a                	jne    80106769 <create+0x184>
    dp->nlink++;  // for ".."
801066ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106702:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106706:	8d 50 01             	lea    0x1(%eax),%edx
80106709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106713:	89 04 24             	mov    %eax,(%esp)
80106716:	e8 a6 af ff ff       	call   801016c1 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010671b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010671e:	8b 40 04             	mov    0x4(%eax),%eax
80106721:	89 44 24 08          	mov    %eax,0x8(%esp)
80106725:	c7 44 24 04 dc 94 10 	movl   $0x801094dc,0x4(%esp)
8010672c:	80 
8010672d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106730:	89 04 24             	mov    %eax,(%esp)
80106733:	e8 30 ba ff ff       	call   80102168 <dirlink>
80106738:	85 c0                	test   %eax,%eax
8010673a:	78 21                	js     8010675d <create+0x178>
8010673c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673f:	8b 40 04             	mov    0x4(%eax),%eax
80106742:	89 44 24 08          	mov    %eax,0x8(%esp)
80106746:	c7 44 24 04 de 94 10 	movl   $0x801094de,0x4(%esp)
8010674d:	80 
8010674e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106751:	89 04 24             	mov    %eax,(%esp)
80106754:	e8 0f ba ff ff       	call   80102168 <dirlink>
80106759:	85 c0                	test   %eax,%eax
8010675b:	79 0c                	jns    80106769 <create+0x184>
      panic("create dots");
8010675d:	c7 04 24 11 95 10 80 	movl   $0x80109511,(%esp)
80106764:	e8 d1 9d ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676c:	8b 40 04             	mov    0x4(%eax),%eax
8010676f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106773:	8d 45 de             	lea    -0x22(%ebp),%eax
80106776:	89 44 24 04          	mov    %eax,0x4(%esp)
8010677a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677d:	89 04 24             	mov    %eax,(%esp)
80106780:	e8 e3 b9 ff ff       	call   80102168 <dirlink>
80106785:	85 c0                	test   %eax,%eax
80106787:	79 0c                	jns    80106795 <create+0x1b0>
    panic("create: dirlink");
80106789:	c7 04 24 1d 95 10 80 	movl   $0x8010951d,(%esp)
80106790:	e8 a5 9d ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106798:	89 04 24             	mov    %eax,(%esp)
8010679b:	e8 61 b3 ff ff       	call   80101b01 <iunlockput>

  return ip;
801067a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801067a3:	c9                   	leave  
801067a4:	c3                   	ret    

801067a5 <sys_open>:

int
sys_open(void)
{
801067a5:	55                   	push   %ebp
801067a6:	89 e5                	mov    %esp,%ebp
801067a8:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801067ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801067b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067b9:	e8 c7 f6 ff ff       	call   80105e85 <argstr>
801067be:	85 c0                	test   %eax,%eax
801067c0:	78 17                	js     801067d9 <sys_open+0x34>
801067c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801067c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067d0:	e8 1a f6 ff ff       	call   80105def <argint>
801067d5:	85 c0                	test   %eax,%eax
801067d7:	79 0a                	jns    801067e3 <sys_open+0x3e>
    return -1;
801067d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067de:	e9 5c 01 00 00       	jmp    8010693f <sys_open+0x19a>

  begin_op();
801067e3:	e8 4d cc ff ff       	call   80103435 <begin_op>

  if(omode & O_CREATE){
801067e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067eb:	25 00 02 00 00       	and    $0x200,%eax
801067f0:	85 c0                	test   %eax,%eax
801067f2:	74 3b                	je     8010682f <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
801067f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801067fe:	00 
801067ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106806:	00 
80106807:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010680e:	00 
8010680f:	89 04 24             	mov    %eax,(%esp)
80106812:	e8 ce fd ff ff       	call   801065e5 <create>
80106817:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010681a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010681e:	75 6b                	jne    8010688b <sys_open+0xe6>
      end_op();
80106820:	e8 94 cc ff ff       	call   801034b9 <end_op>
      return -1;
80106825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682a:	e9 10 01 00 00       	jmp    8010693f <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
8010682f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106832:	89 04 24             	mov    %eax,(%esp)
80106835:	e8 f1 bb ff ff       	call   8010242b <namei>
8010683a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010683d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106841:	75 0f                	jne    80106852 <sys_open+0xad>
      end_op();
80106843:	e8 71 cc ff ff       	call   801034b9 <end_op>
      return -1;
80106848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684d:	e9 ed 00 00 00       	jmp    8010693f <sys_open+0x19a>
    }
    ilock(ip);
80106852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106855:	89 04 24             	mov    %eax,(%esp)
80106858:	e8 20 b0 ff ff       	call   8010187d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010685d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106860:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106864:	66 83 f8 01          	cmp    $0x1,%ax
80106868:	75 21                	jne    8010688b <sys_open+0xe6>
8010686a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010686d:	85 c0                	test   %eax,%eax
8010686f:	74 1a                	je     8010688b <sys_open+0xe6>
      iunlockput(ip);
80106871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106874:	89 04 24             	mov    %eax,(%esp)
80106877:	e8 85 b2 ff ff       	call   80101b01 <iunlockput>
      end_op();
8010687c:	e8 38 cc ff ff       	call   801034b9 <end_op>
      return -1;
80106881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106886:	e9 b4 00 00 00       	jmp    8010693f <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010688b:	e8 b8 a6 ff ff       	call   80100f48 <filealloc>
80106890:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106897:	74 14                	je     801068ad <sys_open+0x108>
80106899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010689c:	89 04 24             	mov    %eax,(%esp)
8010689f:	e8 25 f7 ff ff       	call   80105fc9 <fdalloc>
801068a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801068a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801068ab:	79 28                	jns    801068d5 <sys_open+0x130>
    if(f)
801068ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068b1:	74 0b                	je     801068be <sys_open+0x119>
      fileclose(f);
801068b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068b6:	89 04 24             	mov    %eax,(%esp)
801068b9:	e8 32 a7 ff ff       	call   80100ff0 <fileclose>
    iunlockput(ip);
801068be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c1:	89 04 24             	mov    %eax,(%esp)
801068c4:	e8 38 b2 ff ff       	call   80101b01 <iunlockput>
    end_op();
801068c9:	e8 eb cb ff ff       	call   801034b9 <end_op>
    return -1;
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	eb 6a                	jmp    8010693f <sys_open+0x19a>
  }
  iunlock(ip);
801068d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d8:	89 04 24             	mov    %eax,(%esp)
801068db:	e8 eb b0 ff ff       	call   801019cb <iunlock>
  end_op();
801068e0:	e8 d4 cb ff ff       	call   801034b9 <end_op>

  f->type = FD_INODE;
801068e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068e8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801068ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068f4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801068f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068fa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106904:	83 e0 01             	and    $0x1,%eax
80106907:	85 c0                	test   %eax,%eax
80106909:	0f 94 c0             	sete   %al
8010690c:	89 c2                	mov    %eax,%edx
8010690e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106911:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106917:	83 e0 01             	and    $0x1,%eax
8010691a:	85 c0                	test   %eax,%eax
8010691c:	75 0a                	jne    80106928 <sys_open+0x183>
8010691e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106921:	83 e0 02             	and    $0x2,%eax
80106924:	85 c0                	test   %eax,%eax
80106926:	74 07                	je     8010692f <sys_open+0x18a>
80106928:	b8 01 00 00 00       	mov    $0x1,%eax
8010692d:	eb 05                	jmp    80106934 <sys_open+0x18f>
8010692f:	b8 00 00 00 00       	mov    $0x0,%eax
80106934:	89 c2                	mov    %eax,%edx
80106936:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106939:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010693c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010693f:	c9                   	leave  
80106940:	c3                   	ret    

80106941 <sys_mkdir>:

int
sys_mkdir(void)
{
80106941:	55                   	push   %ebp
80106942:	89 e5                	mov    %esp,%ebp
80106944:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106947:	e8 e9 ca ff ff       	call   80103435 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010694c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010694f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106953:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010695a:	e8 26 f5 ff ff       	call   80105e85 <argstr>
8010695f:	85 c0                	test   %eax,%eax
80106961:	78 2c                	js     8010698f <sys_mkdir+0x4e>
80106963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106966:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010696d:	00 
8010696e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106975:	00 
80106976:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010697d:	00 
8010697e:	89 04 24             	mov    %eax,(%esp)
80106981:	e8 5f fc ff ff       	call   801065e5 <create>
80106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010698d:	75 0c                	jne    8010699b <sys_mkdir+0x5a>
    end_op();
8010698f:	e8 25 cb ff ff       	call   801034b9 <end_op>
    return -1;
80106994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106999:	eb 15                	jmp    801069b0 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010699b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010699e:	89 04 24             	mov    %eax,(%esp)
801069a1:	e8 5b b1 ff ff       	call   80101b01 <iunlockput>
  end_op();
801069a6:	e8 0e cb ff ff       	call   801034b9 <end_op>
  return 0;
801069ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069b0:	c9                   	leave  
801069b1:	c3                   	ret    

801069b2 <sys_mknod>:

int
sys_mknod(void)
{
801069b2:	55                   	push   %ebp
801069b3:	89 e5                	mov    %esp,%ebp
801069b5:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801069b8:	e8 78 ca ff ff       	call   80103435 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801069bd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801069c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069cb:	e8 b5 f4 ff ff       	call   80105e85 <argstr>
801069d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069d7:	78 5e                	js     80106a37 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801069d9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801069e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801069e7:	e8 03 f4 ff ff       	call   80105def <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801069ec:	85 c0                	test   %eax,%eax
801069ee:	78 47                	js     80106a37 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801069f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801069fe:	e8 ec f3 ff ff       	call   80105def <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106a03:	85 c0                	test   %eax,%eax
80106a05:	78 30                	js     80106a37 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a0a:	0f bf c8             	movswl %ax,%ecx
80106a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a10:	0f bf d0             	movswl %ax,%edx
80106a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106a16:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106a1a:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a1e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106a25:	00 
80106a26:	89 04 24             	mov    %eax,(%esp)
80106a29:	e8 b7 fb ff ff       	call   801065e5 <create>
80106a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a35:	75 0c                	jne    80106a43 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106a37:	e8 7d ca ff ff       	call   801034b9 <end_op>
    return -1;
80106a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a41:	eb 15                	jmp    80106a58 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a46:	89 04 24             	mov    %eax,(%esp)
80106a49:	e8 b3 b0 ff ff       	call   80101b01 <iunlockput>
  end_op();
80106a4e:	e8 66 ca ff ff       	call   801034b9 <end_op>
  return 0;
80106a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a58:	c9                   	leave  
80106a59:	c3                   	ret    

80106a5a <sys_chdir>:

int
sys_chdir(void)
{
80106a5a:	55                   	push   %ebp
80106a5b:	89 e5                	mov    %esp,%ebp
80106a5d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106a60:	e8 d0 c9 ff ff       	call   80103435 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106a65:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a68:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a73:	e8 0d f4 ff ff       	call   80105e85 <argstr>
80106a78:	85 c0                	test   %eax,%eax
80106a7a:	78 14                	js     80106a90 <sys_chdir+0x36>
80106a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a7f:	89 04 24             	mov    %eax,(%esp)
80106a82:	e8 a4 b9 ff ff       	call   8010242b <namei>
80106a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a8e:	75 0c                	jne    80106a9c <sys_chdir+0x42>
    end_op();
80106a90:	e8 24 ca ff ff       	call   801034b9 <end_op>
    return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	eb 67                	jmp    80106b03 <sys_chdir+0xa9>
  }
  ilock(ip);
80106a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a9f:	89 04 24             	mov    %eax,(%esp)
80106aa2:	e8 d6 ad ff ff       	call   8010187d <ilock>
  if(ip->type != T_DIR){
80106aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aaa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106aae:	66 83 f8 01          	cmp    $0x1,%ax
80106ab2:	74 17                	je     80106acb <sys_chdir+0x71>
    iunlockput(ip);
80106ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab7:	89 04 24             	mov    %eax,(%esp)
80106aba:	e8 42 b0 ff ff       	call   80101b01 <iunlockput>
    end_op();
80106abf:	e8 f5 c9 ff ff       	call   801034b9 <end_op>
    return -1;
80106ac4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ac9:	eb 38                	jmp    80106b03 <sys_chdir+0xa9>
  }
  iunlock(ip);
80106acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ace:	89 04 24             	mov    %eax,(%esp)
80106ad1:	e8 f5 ae ff ff       	call   801019cb <iunlock>
  iput(thread->proc->cwd);
80106ad6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106adc:	8b 40 0c             	mov    0xc(%eax),%eax
80106adf:	8b 40 5c             	mov    0x5c(%eax),%eax
80106ae2:	89 04 24             	mov    %eax,(%esp)
80106ae5:	e8 46 af ff ff       	call   80101a30 <iput>
  end_op();
80106aea:	e8 ca c9 ff ff       	call   801034b9 <end_op>
  thread->proc->cwd = ip;
80106aef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106af5:	8b 40 0c             	mov    0xc(%eax),%eax
80106af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106afb:	89 50 5c             	mov    %edx,0x5c(%eax)
  return 0;
80106afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b03:	c9                   	leave  
80106b04:	c3                   	ret    

80106b05 <sys_exec>:

int
sys_exec(void)
{
80106b05:	55                   	push   %ebp
80106b06:	89 e5                	mov    %esp,%ebp
80106b08:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106b0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b11:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b1c:	e8 64 f3 ff ff       	call   80105e85 <argstr>
80106b21:	85 c0                	test   %eax,%eax
80106b23:	78 1a                	js     80106b3f <sys_exec+0x3a>
80106b25:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b36:	e8 b4 f2 ff ff       	call   80105def <argint>
80106b3b:	85 c0                	test   %eax,%eax
80106b3d:	79 0a                	jns    80106b49 <sys_exec+0x44>
    return -1;
80106b3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b44:	e9 c8 00 00 00       	jmp    80106c11 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106b49:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106b50:	00 
80106b51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b58:	00 
80106b59:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106b5f:	89 04 24             	mov    %eax,(%esp)
80106b62:	e8 3a ef ff ff       	call   80105aa1 <memset>
  for(i=0;; i++){
80106b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b71:	83 f8 1f             	cmp    $0x1f,%eax
80106b74:	76 0a                	jbe    80106b80 <sys_exec+0x7b>
      return -1;
80106b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b7b:	e9 91 00 00 00       	jmp    80106c11 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b83:	c1 e0 02             	shl    $0x2,%eax
80106b86:	89 c2                	mov    %eax,%edx
80106b88:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106b8e:	01 c2                	add    %eax,%edx
80106b90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b9a:	89 14 24             	mov    %edx,(%esp)
80106b9d:	e8 a5 f1 ff ff       	call   80105d47 <fetchint>
80106ba2:	85 c0                	test   %eax,%eax
80106ba4:	79 07                	jns    80106bad <sys_exec+0xa8>
      return -1;
80106ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bab:	eb 64                	jmp    80106c11 <sys_exec+0x10c>
    if(uarg == 0){
80106bad:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106bb3:	85 c0                	test   %eax,%eax
80106bb5:	75 26                	jne    80106bdd <sys_exec+0xd8>
      argv[i] = 0;
80106bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bba:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106bc1:	00 00 00 00 
      break;
80106bc5:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bc9:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bd3:	89 04 24             	mov    %eax,(%esp)
80106bd6:	e8 17 9f ff ff       	call   80100af2 <exec>
80106bdb:	eb 34                	jmp    80106c11 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106bdd:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106be6:	c1 e2 02             	shl    $0x2,%edx
80106be9:	01 c2                	add    %eax,%edx
80106beb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bf5:	89 04 24             	mov    %eax,(%esp)
80106bf8:	e8 8a f1 ff ff       	call   80105d87 <fetchstr>
80106bfd:	85 c0                	test   %eax,%eax
80106bff:	79 07                	jns    80106c08 <sys_exec+0x103>
      return -1;
80106c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c06:	eb 09                	jmp    80106c11 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106c08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106c0c:	e9 5d ff ff ff       	jmp    80106b6e <sys_exec+0x69>
  return exec(path, argv);
}
80106c11:	c9                   	leave  
80106c12:	c3                   	ret    

80106c13 <sys_pipe>:

int
sys_pipe(void)
{
80106c13:	55                   	push   %ebp
80106c14:	89 e5                	mov    %esp,%ebp
80106c16:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106c19:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106c20:	00 
80106c21:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c24:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c2f:	e8 e9 f1 ff ff       	call   80105e1d <argptr>
80106c34:	85 c0                	test   %eax,%eax
80106c36:	79 0a                	jns    80106c42 <sys_pipe+0x2f>
    return -1;
80106c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c3d:	e9 a1 00 00 00       	jmp    80106ce3 <sys_pipe+0xd0>
  if(pipealloc(&rf, &wf) < 0)
80106c42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c49:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c4c:	89 04 24             	mov    %eax,(%esp)
80106c4f:	e8 f2 d2 ff ff       	call   80103f46 <pipealloc>
80106c54:	85 c0                	test   %eax,%eax
80106c56:	79 0a                	jns    80106c62 <sys_pipe+0x4f>
    return -1;
80106c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5d:	e9 81 00 00 00       	jmp    80106ce3 <sys_pipe+0xd0>
  fd0 = -1;
80106c62:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c6c:	89 04 24             	mov    %eax,(%esp)
80106c6f:	e8 55 f3 ff ff       	call   80105fc9 <fdalloc>
80106c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c7b:	78 14                	js     80106c91 <sys_pipe+0x7e>
80106c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c80:	89 04 24             	mov    %eax,(%esp)
80106c83:	e8 41 f3 ff ff       	call   80105fc9 <fdalloc>
80106c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c8f:	79 3a                	jns    80106ccb <sys_pipe+0xb8>
    if(fd0 >= 0)
80106c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c95:	78 17                	js     80106cae <sys_pipe+0x9b>
      thread->proc->ofile[fd0] = 0;
80106c97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c9d:	8b 40 0c             	mov    0xc(%eax),%eax
80106ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ca3:	83 c2 04             	add    $0x4,%edx
80106ca6:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80106cad:	00 
    fileclose(rf);
80106cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106cb1:	89 04 24             	mov    %eax,(%esp)
80106cb4:	e8 37 a3 ff ff       	call   80100ff0 <fileclose>
    fileclose(wf);
80106cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cbc:	89 04 24             	mov    %eax,(%esp)
80106cbf:	e8 2c a3 ff ff       	call   80100ff0 <fileclose>
    return -1;
80106cc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc9:	eb 18                	jmp    80106ce3 <sys_pipe+0xd0>
  }
  fd[0] = fd0;
80106ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cd1:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106cd6:	8d 50 04             	lea    0x4(%eax),%edx
80106cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cdc:	89 02                	mov    %eax,(%edx)
  return 0;
80106cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ce3:	c9                   	leave  
80106ce4:	c3                   	ret    

80106ce5 <sys_fork>:
#include "proc.h"
#include "kthread.h"

int
sys_fork(void)
{
80106ce5:	55                   	push   %ebp
80106ce6:	89 e5                	mov    %esp,%ebp
80106ce8:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106ceb:	e8 a9 d9 ff ff       	call   80104699 <fork>
}
80106cf0:	c9                   	leave  
80106cf1:	c3                   	ret    

80106cf2 <sys_exit>:

int
sys_exit(void)
{
80106cf2:	55                   	push   %ebp
80106cf3:	89 e5                	mov    %esp,%ebp
80106cf5:	83 ec 08             	sub    $0x8,%esp
  exit();
80106cf8:	e8 6b db ff ff       	call   80104868 <exit>
  return 0;  // not reached
80106cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d02:	c9                   	leave  
80106d03:	c3                   	ret    

80106d04 <sys_wait>:

int
sys_wait(void)
{
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106d0a:	e8 00 dd ff ff       	call   80104a0f <wait>
}
80106d0f:	c9                   	leave  
80106d10:	c3                   	ret    

80106d11 <sys_kill>:

int
sys_kill(void)
{
80106d11:	55                   	push   %ebp
80106d12:	89 e5                	mov    %esp,%ebp
80106d14:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d25:	e8 c5 f0 ff ff       	call   80105def <argint>
80106d2a:	85 c0                	test   %eax,%eax
80106d2c:	79 07                	jns    80106d35 <sys_kill+0x24>
    return -1;
80106d2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d33:	eb 0b                	jmp    80106d40 <sys_kill+0x2f>
  return kill(pid);
80106d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d38:	89 04 24             	mov    %eax,(%esp)
80106d3b:	e8 71 e1 ff ff       	call   80104eb1 <kill>
}
80106d40:	c9                   	leave  
80106d41:	c3                   	ret    

80106d42 <sys_getpid>:

int
sys_getpid(void)
{
80106d42:	55                   	push   %ebp
80106d43:	89 e5                	mov    %esp,%ebp
  return thread->proc->pid;
80106d45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d4b:	8b 40 0c             	mov    0xc(%eax),%eax
80106d4e:	8b 40 0c             	mov    0xc(%eax),%eax
}
80106d51:	5d                   	pop    %ebp
80106d52:	c3                   	ret    

80106d53 <sys_sbrk>:

int
sys_sbrk(void)
{
80106d53:	55                   	push   %ebp
80106d54:	89 e5                	mov    %esp,%ebp
80106d56:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106d59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d67:	e8 83 f0 ff ff       	call   80105def <argint>
80106d6c:	85 c0                	test   %eax,%eax
80106d6e:	79 07                	jns    80106d77 <sys_sbrk+0x24>
    return -1;
80106d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d75:	eb 27                	jmp    80106d9e <sys_sbrk+0x4b>
  addr = thread->proc->sz;
80106d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7d:	8b 40 0c             	mov    0xc(%eax),%eax
80106d80:	8b 00                	mov    (%eax),%eax
80106d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d88:	89 04 24             	mov    %eax,(%esp)
80106d8b:	e8 64 d8 ff ff       	call   801045f4 <growproc>
80106d90:	85 c0                	test   %eax,%eax
80106d92:	79 07                	jns    80106d9b <sys_sbrk+0x48>
    return -1;
80106d94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d99:	eb 03                	jmp    80106d9e <sys_sbrk+0x4b>
  return addr;
80106d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d9e:	c9                   	leave  
80106d9f:	c3                   	ret    

80106da0 <sys_sleep>:

int
sys_sleep(void)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106da6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106da9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106db4:	e8 36 f0 ff ff       	call   80105def <argint>
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	79 07                	jns    80106dc4 <sys_sleep+0x24>
    return -1;
80106dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc2:	eb 6f                	jmp    80106e33 <sys_sleep+0x93>
  acquire(&tickslock);
80106dc4:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106dcb:	e8 cc e2 ff ff       	call   8010509c <acquire>
  ticks0 = ticks;
80106dd0:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106dd8:	eb 37                	jmp    80106e11 <sys_sleep+0x71>
    if(thread->proc->killed){
80106dda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de0:	8b 40 0c             	mov    0xc(%eax),%eax
80106de3:	8b 40 18             	mov    0x18(%eax),%eax
80106de6:	85 c0                	test   %eax,%eax
80106de8:	74 13                	je     80106dfd <sys_sleep+0x5d>
      release(&tickslock);
80106dea:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106df1:	e8 08 e3 ff ff       	call   801050fe <release>
      return -1;
80106df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dfb:	eb 36                	jmp    80106e33 <sys_sleep+0x93>
    }
    sleep(&ticks, &tickslock);
80106dfd:	c7 44 24 04 c0 e9 11 	movl   $0x8011e9c0,0x4(%esp)
80106e04:	80 
80106e05:	c7 04 24 00 f2 11 80 	movl   $0x8011f200,(%esp)
80106e0c:	e8 7d df ff ff       	call   80104d8e <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106e11:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106e16:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106e19:	89 c2                	mov    %eax,%edx
80106e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e1e:	39 c2                	cmp    %eax,%edx
80106e20:	72 b8                	jb     80106dda <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106e22:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e29:	e8 d0 e2 ff ff       	call   801050fe <release>
  return 0;
80106e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e33:	c9                   	leave  
80106e34:	c3                   	ret    

80106e35 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106e35:	55                   	push   %ebp
80106e36:	89 e5                	mov    %esp,%ebp
80106e38:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106e3b:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e42:	e8 55 e2 ff ff       	call   8010509c <acquire>
  xticks = ticks;
80106e47:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106e4f:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e56:	e8 a3 e2 ff ff       	call   801050fe <release>
  return xticks;
80106e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106e5e:	c9                   	leave  
80106e5f:	c3                   	ret    

80106e60 <sys_kthread_create>:




int sys_kthread_create(void){
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	83 ec 28             	sub    $0x28,%esp

	int start_func;
	int stack;
	int stack_size;

	if ( argint(0,&start_func)<0  || argint(1,&stack)<0  ||argint(2,&stack_size)<0 )
80106e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e69:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e74:	e8 76 ef ff ff       	call   80105def <argint>
80106e79:	85 c0                	test   %eax,%eax
80106e7b:	78 2e                	js     80106eab <sys_kthread_create+0x4b>
80106e7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e80:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106e8b:	e8 5f ef ff ff       	call   80105def <argint>
80106e90:	85 c0                	test   %eax,%eax
80106e92:	78 17                	js     80106eab <sys_kthread_create+0x4b>
80106e94:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106e97:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e9b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106ea2:	e8 48 ef ff ff       	call   80105def <argint>
80106ea7:	85 c0                	test   %eax,%eax
80106ea9:	79 07                	jns    80106eb2 <sys_kthread_create+0x52>
		return -1;
80106eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eb0:	eb 1d                	jmp    80106ecf <sys_kthread_create+0x6f>


	return kthread_create((void *) start_func, (void *) stack, (uint) stack_size);
80106eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106eb5:	89 c1                	mov    %eax,%ecx
80106eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eba:	89 c2                	mov    %eax,%edx
80106ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ebf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106ec3:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ec7:	89 04 24             	mov    %eax,(%esp)
80106eca:	e8 41 e4 ff ff       	call   80105310 <kthread_create>

}
80106ecf:	c9                   	leave  
80106ed0:	c3                   	ret    

80106ed1 <sys_kthread_id>:
int sys_kthread_id(void){
80106ed1:	55                   	push   %ebp
80106ed2:	89 e5                	mov    %esp,%ebp
80106ed4:	83 ec 08             	sub    $0x8,%esp
	return kthread_id();
80106ed7:	e8 ba e5 ff ff       	call   80105496 <kthread_id>
}
80106edc:	c9                   	leave  
80106edd:	c3                   	ret    

80106ede <sys_kthread_exit>:

int  sys_kthread_exit(void){
80106ede:	55                   	push   %ebp
80106edf:	89 e5                	mov    %esp,%ebp
80106ee1:	83 ec 08             	sub    $0x8,%esp
	kthread_exit();
80106ee4:	e8 bb e5 ff ff       	call   801054a4 <kthread_exit>
	return 0;
80106ee9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106eee:	c9                   	leave  
80106eef:	c3                   	ret    

80106ef0 <sys_kthread_join>:

int sys_kthread_join(void){
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 28             	sub    $0x28,%esp

	int thread_id;

	if (argint(0, &thread_id)<0)
80106ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106efd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f04:	e8 e6 ee ff ff       	call   80105def <argint>
80106f09:	85 c0                	test   %eax,%eax
80106f0b:	79 07                	jns    80106f14 <sys_kthread_join+0x24>
		return -1;
80106f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f12:	eb 0b                	jmp    80106f1f <sys_kthread_join+0x2f>

	return kthread_join(thread_id);
80106f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f17:	89 04 24             	mov    %eax,(%esp)
80106f1a:	e8 f3 e5 ff ff       	call   80105512 <kthread_join>

}
80106f1f:	c9                   	leave  
80106f20:	c3                   	ret    

80106f21 <sys_kthread_mutex_alloc>:

int sys_kthread_mutex_alloc(void){
80106f21:	55                   	push   %ebp
80106f22:	89 e5                	mov    %esp,%ebp
80106f24:	83 ec 08             	sub    $0x8,%esp
  return kthread_mutex_alloc();
80106f27:	e8 cc e7 ff ff       	call   801056f8 <kthread_mutex_alloc>
}
80106f2c:	c9                   	leave  
80106f2d:	c3                   	ret    

80106f2e <sys_kthread_mutex_dealloc>:

int sys_kthread_mutex_dealloc(void){
80106f2e:	55                   	push   %ebp
80106f2f:	89 e5                	mov    %esp,%ebp
80106f31:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f37:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f42:	e8 a8 ee ff ff       	call   80105def <argint>
80106f47:	85 c0                	test   %eax,%eax
80106f49:	79 07                	jns    80106f52 <sys_kthread_mutex_dealloc+0x24>
    return -1;
80106f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f50:	eb 0b                	jmp    80106f5d <sys_kthread_mutex_dealloc+0x2f>
  return kthread_mutex_dealloc(mutex_id);
80106f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f55:	89 04 24             	mov    %eax,(%esp)
80106f58:	e8 2d e8 ff ff       	call   8010578a <kthread_mutex_dealloc>
}
80106f5d:	c9                   	leave  
80106f5e:	c3                   	ret    

80106f5f <sys_kthread_mutex_lock>:

int sys_kthread_mutex_lock(void){
80106f5f:	55                   	push   %ebp
80106f60:	89 e5                	mov    %esp,%ebp
80106f62:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f68:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f73:	e8 77 ee ff ff       	call   80105def <argint>
80106f78:	85 c0                	test   %eax,%eax
80106f7a:	79 07                	jns    80106f83 <sys_kthread_mutex_lock+0x24>
    return -1;
80106f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f81:	eb 0b                	jmp    80106f8e <sys_kthread_mutex_lock+0x2f>
  return kthread_mutex_lock(mutex_id);
80106f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f86:	89 04 24             	mov    %eax,(%esp)
80106f89:	e8 5f e8 ff ff       	call   801057ed <kthread_mutex_lock>
}
80106f8e:	c9                   	leave  
80106f8f:	c3                   	ret    

80106f90 <sys_kthread_mutex_unlock>:

int sys_kthread_mutex_unlock(void){
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106fa4:	e8 46 ee ff ff       	call   80105def <argint>
80106fa9:	85 c0                	test   %eax,%eax
80106fab:	79 07                	jns    80106fb4 <sys_kthread_mutex_unlock+0x24>
    return -1;
80106fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fb2:	eb 0b                	jmp    80106fbf <sys_kthread_mutex_unlock+0x2f>
  return kthread_mutex_unlock(mutex_id);
80106fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fb7:	89 04 24             	mov    %eax,(%esp)
80106fba:	e8 e8 e8 ff ff       	call   801058a7 <kthread_mutex_unlock>
}
80106fbf:	c9                   	leave  
80106fc0:	c3                   	ret    

80106fc1 <sys_kthread_mutex_yieldlock>:

int sys_kthread_mutex_yieldlock(void){
80106fc1:	55                   	push   %ebp
80106fc2:	89 e5                	mov    %esp,%ebp
80106fc4:	83 ec 28             	sub    $0x28,%esp

  int mutex_id1;
  int mutex_id2;

  if (argint(0, &mutex_id1)<0 || argint(0, &mutex_id2)<0 )
80106fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fca:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106fd5:	e8 15 ee ff ff       	call   80105def <argint>
80106fda:	85 c0                	test   %eax,%eax
80106fdc:	78 17                	js     80106ff5 <sys_kthread_mutex_yieldlock+0x34>
80106fde:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106fec:	e8 fe ed ff ff       	call   80105def <argint>
80106ff1:	85 c0                	test   %eax,%eax
80106ff3:	79 07                	jns    80106ffc <sys_kthread_mutex_yieldlock+0x3b>
    return -1;
80106ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ffa:	eb 12                	jmp    8010700e <sys_kthread_mutex_yieldlock+0x4d>

  return kthread_mutex_yieldlock(mutex_id1, mutex_id2);
80106ffc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107002:	89 54 24 04          	mov    %edx,0x4(%esp)
80107006:	89 04 24             	mov    %eax,(%esp)
80107009:	e8 52 e9 ff ff       	call   80105960 <kthread_mutex_yieldlock>
}
8010700e:	c9                   	leave  
8010700f:	c3                   	ret    

80107010 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 08             	sub    $0x8,%esp
80107016:	8b 55 08             	mov    0x8(%ebp),%edx
80107019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010701c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107020:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107023:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107027:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010702b:	ee                   	out    %al,(%dx)
}
8010702c:	c9                   	leave  
8010702d:	c3                   	ret    

8010702e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010702e:	55                   	push   %ebp
8010702f:	89 e5                	mov    %esp,%ebp
80107031:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107034:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010703b:	00 
8010703c:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80107043:	e8 c8 ff ff ff       	call   80107010 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107048:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010704f:	00 
80107050:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80107057:	e8 b4 ff ff ff       	call   80107010 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010705c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80107063:	00 
80107064:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010706b:	e8 a0 ff ff ff       	call   80107010 <outb>
  picenable(IRQ_TIMER);
80107070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107077:	e8 5d cd ff ff       	call   80103dd9 <picenable>
}
8010707c:	c9                   	leave  
8010707d:	c3                   	ret    

8010707e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010707e:	1e                   	push   %ds
  pushl %es
8010707f:	06                   	push   %es
  pushl %fs
80107080:	0f a0                	push   %fs
  pushl %gs
80107082:	0f a8                	push   %gs
  pushal
80107084:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107085:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107089:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010708b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010708d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107091:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107093:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107095:	54                   	push   %esp
  call trap
80107096:	e8 d8 01 00 00       	call   80107273 <trap>
  addl $4, %esp
8010709b:	83 c4 04             	add    $0x4,%esp

8010709e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010709e:	61                   	popa   
  popl %gs
8010709f:	0f a9                	pop    %gs
  popl %fs
801070a1:	0f a1                	pop    %fs
  popl %es
801070a3:	07                   	pop    %es
  popl %ds
801070a4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801070a5:	83 c4 08             	add    $0x8,%esp
  iret
801070a8:	cf                   	iret   

801070a9 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801070a9:	55                   	push   %ebp
801070aa:	89 e5                	mov    %esp,%ebp
801070ac:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801070af:	8b 45 0c             	mov    0xc(%ebp),%eax
801070b2:	83 e8 01             	sub    $0x1,%eax
801070b5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070b9:	8b 45 08             	mov    0x8(%ebp),%eax
801070bc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070c0:	8b 45 08             	mov    0x8(%ebp),%eax
801070c3:	c1 e8 10             	shr    $0x10,%eax
801070c6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801070ca:	8d 45 fa             	lea    -0x6(%ebp),%eax
801070cd:	0f 01 18             	lidtl  (%eax)
}
801070d0:	c9                   	leave  
801070d1:	c3                   	ret    

801070d2 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801070d2:	55                   	push   %ebp
801070d3:	89 e5                	mov    %esp,%ebp
801070d5:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801070d8:	0f 20 d0             	mov    %cr2,%eax
801070db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801070de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801070e1:	c9                   	leave  
801070e2:	c3                   	ret    

801070e3 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801070e3:	55                   	push   %ebp
801070e4:	89 e5                	mov    %esp,%ebp
801070e6:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801070e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801070f0:	e9 c3 00 00 00       	jmp    801071b8 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801070f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f8:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
801070ff:	89 c2                	mov    %eax,%edx
80107101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107104:	66 89 14 c5 00 ea 11 	mov    %dx,-0x7fee1600(,%eax,8)
8010710b:	80 
8010710c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010710f:	66 c7 04 c5 02 ea 11 	movw   $0x8,-0x7fee15fe(,%eax,8)
80107116:	80 08 00 
80107119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711c:	0f b6 14 c5 04 ea 11 	movzbl -0x7fee15fc(,%eax,8),%edx
80107123:	80 
80107124:	83 e2 e0             	and    $0xffffffe0,%edx
80107127:	88 14 c5 04 ea 11 80 	mov    %dl,-0x7fee15fc(,%eax,8)
8010712e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107131:	0f b6 14 c5 04 ea 11 	movzbl -0x7fee15fc(,%eax,8),%edx
80107138:	80 
80107139:	83 e2 1f             	and    $0x1f,%edx
8010713c:	88 14 c5 04 ea 11 80 	mov    %dl,-0x7fee15fc(,%eax,8)
80107143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107146:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
8010714d:	80 
8010714e:	83 e2 f0             	and    $0xfffffff0,%edx
80107151:	83 ca 0e             	or     $0xe,%edx
80107154:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
8010715b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010715e:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
80107165:	80 
80107166:	83 e2 ef             	and    $0xffffffef,%edx
80107169:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
80107170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107173:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
8010717a:	80 
8010717b:	83 e2 9f             	and    $0xffffff9f,%edx
8010717e:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
80107185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107188:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
8010718f:	80 
80107190:	83 ca 80             	or     $0xffffff80,%edx
80107193:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
8010719a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719d:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
801071a4:	c1 e8 10             	shr    $0x10,%eax
801071a7:	89 c2                	mov    %eax,%edx
801071a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ac:	66 89 14 c5 06 ea 11 	mov    %dx,-0x7fee15fa(,%eax,8)
801071b3:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801071b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071b8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801071bf:	0f 8e 30 ff ff ff    	jle    801070f5 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801071c5:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
801071ca:	66 a3 00 ec 11 80    	mov    %ax,0x8011ec00
801071d0:	66 c7 05 02 ec 11 80 	movw   $0x8,0x8011ec02
801071d7:	08 00 
801071d9:	0f b6 05 04 ec 11 80 	movzbl 0x8011ec04,%eax
801071e0:	83 e0 e0             	and    $0xffffffe0,%eax
801071e3:	a2 04 ec 11 80       	mov    %al,0x8011ec04
801071e8:	0f b6 05 04 ec 11 80 	movzbl 0x8011ec04,%eax
801071ef:	83 e0 1f             	and    $0x1f,%eax
801071f2:	a2 04 ec 11 80       	mov    %al,0x8011ec04
801071f7:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
801071fe:	83 c8 0f             	or     $0xf,%eax
80107201:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107206:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
8010720d:	83 e0 ef             	and    $0xffffffef,%eax
80107210:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107215:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
8010721c:	83 c8 60             	or     $0x60,%eax
8010721f:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107224:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
8010722b:	83 c8 80             	or     $0xffffff80,%eax
8010722e:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107233:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
80107238:	c1 e8 10             	shr    $0x10,%eax
8010723b:	66 a3 06 ec 11 80    	mov    %ax,0x8011ec06
  
  initlock(&tickslock, "time");
80107241:	c7 44 24 04 30 95 10 	movl   $0x80109530,0x4(%esp)
80107248:	80 
80107249:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80107250:	e8 26 de ff ff       	call   8010507b <initlock>
}
80107255:	c9                   	leave  
80107256:	c3                   	ret    

80107257 <idtinit>:

void
idtinit(void)
{
80107257:	55                   	push   %ebp
80107258:	89 e5                	mov    %esp,%ebp
8010725a:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010725d:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107264:	00 
80107265:	c7 04 24 00 ea 11 80 	movl   $0x8011ea00,(%esp)
8010726c:	e8 38 fe ff ff       	call   801070a9 <lidt>
}
80107271:	c9                   	leave  
80107272:	c3                   	ret    

80107273 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107273:	55                   	push   %ebp
80107274:	89 e5                	mov    %esp,%ebp
80107276:	57                   	push   %edi
80107277:	56                   	push   %esi
80107278:	53                   	push   %ebx
80107279:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010727c:	8b 45 08             	mov    0x8(%ebp),%eax
8010727f:	8b 40 30             	mov    0x30(%eax),%eax
80107282:	83 f8 40             	cmp    $0x40,%eax
80107285:	75 45                	jne    801072cc <trap+0x59>
    if(thread->proc->killed)
80107287:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010728d:	8b 40 0c             	mov    0xc(%eax),%eax
80107290:	8b 40 18             	mov    0x18(%eax),%eax
80107293:	85 c0                	test   %eax,%eax
80107295:	74 05                	je     8010729c <trap+0x29>
      exit();
80107297:	e8 cc d5 ff ff       	call   80104868 <exit>
    thread->tf = tf;
8010729c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072a2:	8b 55 08             	mov    0x8(%ebp),%edx
801072a5:	89 50 10             	mov    %edx,0x10(%eax)
    syscall();
801072a8:	e8 0f ec ff ff       	call   80105ebc <syscall>
    if(thread->proc->killed)
801072ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072b3:	8b 40 0c             	mov    0xc(%eax),%eax
801072b6:	8b 40 18             	mov    0x18(%eax),%eax
801072b9:	85 c0                	test   %eax,%eax
801072bb:	74 0a                	je     801072c7 <trap+0x54>
      exit();
801072bd:	e8 a6 d5 ff ff       	call   80104868 <exit>
    return;
801072c2:	e9 7d 02 00 00       	jmp    80107544 <trap+0x2d1>
801072c7:	e9 78 02 00 00       	jmp    80107544 <trap+0x2d1>
  }

  switch(tf->trapno){
801072cc:	8b 45 08             	mov    0x8(%ebp),%eax
801072cf:	8b 40 30             	mov    0x30(%eax),%eax
801072d2:	83 e8 20             	sub    $0x20,%eax
801072d5:	83 f8 1f             	cmp    $0x1f,%eax
801072d8:	0f 87 bc 00 00 00    	ja     8010739a <trap+0x127>
801072de:	8b 04 85 e8 95 10 80 	mov    -0x7fef6a18(,%eax,4),%eax
801072e5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801072e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801072ed:	0f b6 00             	movzbl (%eax),%eax
801072f0:	84 c0                	test   %al,%al
801072f2:	75 31                	jne    80107325 <trap+0xb2>
      acquire(&tickslock);
801072f4:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
801072fb:	e8 9c dd ff ff       	call   8010509c <acquire>
      ticks++;
80107300:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80107305:	83 c0 01             	add    $0x1,%eax
80107308:	a3 00 f2 11 80       	mov    %eax,0x8011f200
      wakeup(&ticks);
8010730d:	c7 04 24 00 f2 11 80 	movl   $0x8011f200,(%esp)
80107314:	e8 6d db ff ff       	call   80104e86 <wakeup>
      release(&tickslock);
80107319:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80107320:	e8 d9 dd ff ff       	call   801050fe <release>
    }
    lapiceoi();
80107325:	e8 cb bb ff ff       	call   80102ef5 <lapiceoi>
    break;
8010732a:	e9 64 01 00 00       	jmp    80107493 <trap+0x220>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010732f:	e8 cf b3 ff ff       	call   80102703 <ideintr>
    lapiceoi();
80107334:	e8 bc bb ff ff       	call   80102ef5 <lapiceoi>
    break;
80107339:	e9 55 01 00 00       	jmp    80107493 <trap+0x220>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010733e:	e8 81 b9 ff ff       	call   80102cc4 <kbdintr>
    lapiceoi();
80107343:	e8 ad bb ff ff       	call   80102ef5 <lapiceoi>
    break;
80107348:	e9 46 01 00 00       	jmp    80107493 <trap+0x220>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010734d:	e8 e7 03 00 00       	call   80107739 <uartintr>
    lapiceoi();
80107352:	e8 9e bb ff ff       	call   80102ef5 <lapiceoi>
    break;
80107357:	e9 37 01 00 00       	jmp    80107493 <trap+0x220>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010735c:	8b 45 08             	mov    0x8(%ebp),%eax
8010735f:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107362:	8b 45 08             	mov    0x8(%ebp),%eax
80107365:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107369:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010736c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107372:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107375:	0f b6 c0             	movzbl %al,%eax
80107378:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010737c:	89 54 24 08          	mov    %edx,0x8(%esp)
80107380:	89 44 24 04          	mov    %eax,0x4(%esp)
80107384:	c7 04 24 38 95 10 80 	movl   $0x80109538,(%esp)
8010738b:	e8 10 90 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107390:	e8 60 bb ff ff       	call   80102ef5 <lapiceoi>
    break;
80107395:	e9 f9 00 00 00       	jmp    80107493 <trap+0x220>
   
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
8010739a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073a0:	85 c0                	test   %eax,%eax
801073a2:	74 11                	je     801073b5 <trap+0x142>
801073a4:	8b 45 08             	mov    0x8(%ebp),%eax
801073a7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073ab:	0f b7 c0             	movzwl %ax,%eax
801073ae:	83 e0 03             	and    $0x3,%eax
801073b1:	85 c0                	test   %eax,%eax
801073b3:	75 60                	jne    80107415 <trap+0x1a2>
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
801073b5:	8b 45 08             	mov    0x8(%ebp),%eax
801073b8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073bc:	0f b7 c0             	movzwl %ax,%eax
801073bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801073c3:	c7 04 24 5c 95 10 80 	movl   $0x8010955c,(%esp)
801073ca:	e8 d1 8f ff ff       	call   801003a0 <cprintf>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801073cf:	e8 fe fc ff ff       	call   801070d2 <rcr2>
801073d4:	8b 55 08             	mov    0x8(%ebp),%edx
801073d7:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801073da:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801073e1:	0f b6 12             	movzbl (%edx),%edx
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801073e4:	0f b6 ca             	movzbl %dl,%ecx
801073e7:	8b 55 08             	mov    0x8(%ebp),%edx
801073ea:	8b 52 30             	mov    0x30(%edx),%edx
801073ed:	89 44 24 10          	mov    %eax,0x10(%esp)
801073f1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801073f5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801073f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801073fd:	c7 04 24 6c 95 10 80 	movl   $0x8010956c,(%esp)
80107404:	e8 97 8f ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107409:	c7 04 24 9e 95 10 80 	movl   $0x8010959e,(%esp)
80107410:	e8 25 91 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107415:	e8 b8 fc ff ff       	call   801070d2 <rcr2>
8010741a:	89 c2                	mov    %eax,%edx
8010741c:	8b 45 08             	mov    0x8(%ebp),%eax
8010741f:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80107422:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107428:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010742b:	0f b6 f0             	movzbl %al,%esi
8010742e:	8b 45 08             	mov    0x8(%ebp),%eax
80107431:	8b 58 34             	mov    0x34(%eax),%ebx
80107434:	8b 45 08             	mov    0x8(%ebp),%eax
80107437:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
8010743a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107440:	8b 40 0c             	mov    0xc(%eax),%eax
80107443:	83 c0 60             	add    $0x60,%eax
80107446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010744f:	8b 40 0c             	mov    0xc(%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107452:	8b 40 0c             	mov    0xc(%eax),%eax
80107455:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107459:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010745d:	89 74 24 14          	mov    %esi,0x14(%esp)
80107461:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107465:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107469:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010746c:	89 74 24 08          	mov    %esi,0x8(%esp)
80107470:	89 44 24 04          	mov    %eax,0x4(%esp)
80107474:	c7 04 24 a4 95 10 80 	movl   $0x801095a4,(%esp)
8010747b:	e8 20 8f ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    thread->proc->killed = 1;
80107480:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107486:	8b 40 0c             	mov    0xc(%eax),%eax
80107489:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
80107490:	eb 01                	jmp    80107493 <trap+0x220>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107492:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(thread && thread->proc  && thread->proc->killed && (tf->cs&3) == DPL_USER)
80107493:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107499:	85 c0                	test   %eax,%eax
8010749b:	74 34                	je     801074d1 <trap+0x25e>
8010749d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074a3:	8b 40 0c             	mov    0xc(%eax),%eax
801074a6:	85 c0                	test   %eax,%eax
801074a8:	74 27                	je     801074d1 <trap+0x25e>
801074aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074b0:	8b 40 0c             	mov    0xc(%eax),%eax
801074b3:	8b 40 18             	mov    0x18(%eax),%eax
801074b6:	85 c0                	test   %eax,%eax
801074b8:	74 17                	je     801074d1 <trap+0x25e>
801074ba:	8b 45 08             	mov    0x8(%ebp),%eax
801074bd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801074c1:	0f b7 c0             	movzwl %ax,%eax
801074c4:	83 e0 03             	and    $0x3,%eax
801074c7:	83 f8 03             	cmp    $0x3,%eax
801074ca:	75 05                	jne    801074d1 <trap+0x25e>
    exit();
801074cc:	e8 97 d3 ff ff       	call   80104868 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if(thread && thread->proc && thread->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801074d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074d7:	85 c0                	test   %eax,%eax
801074d9:	74 2b                	je     80107506 <trap+0x293>
801074db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074e1:	8b 40 0c             	mov    0xc(%eax),%eax
801074e4:	85 c0                	test   %eax,%eax
801074e6:	74 1e                	je     80107506 <trap+0x293>
801074e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074ee:	8b 40 04             	mov    0x4(%eax),%eax
801074f1:	83 f8 04             	cmp    $0x4,%eax
801074f4:	75 10                	jne    80107506 <trap+0x293>
801074f6:	8b 45 08             	mov    0x8(%ebp),%eax
801074f9:	8b 40 30             	mov    0x30(%eax),%eax
801074fc:	83 f8 20             	cmp    $0x20,%eax
801074ff:	75 05                	jne    80107506 <trap+0x293>

    yield();
80107501:	e8 2a d8 ff ff       	call   80104d30 <yield>

  }

  // Check if the process has been killed since we yielded
  if(thread && thread->proc && thread->proc->killed && (tf->cs&3) == DPL_USER)
80107506:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010750c:	85 c0                	test   %eax,%eax
8010750e:	74 34                	je     80107544 <trap+0x2d1>
80107510:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107516:	8b 40 0c             	mov    0xc(%eax),%eax
80107519:	85 c0                	test   %eax,%eax
8010751b:	74 27                	je     80107544 <trap+0x2d1>
8010751d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107523:	8b 40 0c             	mov    0xc(%eax),%eax
80107526:	8b 40 18             	mov    0x18(%eax),%eax
80107529:	85 c0                	test   %eax,%eax
8010752b:	74 17                	je     80107544 <trap+0x2d1>
8010752d:	8b 45 08             	mov    0x8(%ebp),%eax
80107530:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107534:	0f b7 c0             	movzwl %ax,%eax
80107537:	83 e0 03             	and    $0x3,%eax
8010753a:	83 f8 03             	cmp    $0x3,%eax
8010753d:	75 05                	jne    80107544 <trap+0x2d1>
    exit();
8010753f:	e8 24 d3 ff ff       	call   80104868 <exit>
}
80107544:	83 c4 3c             	add    $0x3c,%esp
80107547:	5b                   	pop    %ebx
80107548:	5e                   	pop    %esi
80107549:	5f                   	pop    %edi
8010754a:	5d                   	pop    %ebp
8010754b:	c3                   	ret    

8010754c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010754c:	55                   	push   %ebp
8010754d:	89 e5                	mov    %esp,%ebp
8010754f:	83 ec 14             	sub    $0x14,%esp
80107552:	8b 45 08             	mov    0x8(%ebp),%eax
80107555:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010755d:	89 c2                	mov    %eax,%edx
8010755f:	ec                   	in     (%dx),%al
80107560:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107563:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107567:	c9                   	leave  
80107568:	c3                   	ret    

80107569 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107569:	55                   	push   %ebp
8010756a:	89 e5                	mov    %esp,%ebp
8010756c:	83 ec 08             	sub    $0x8,%esp
8010756f:	8b 55 08             	mov    0x8(%ebp),%edx
80107572:	8b 45 0c             	mov    0xc(%ebp),%eax
80107575:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107579:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010757c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107580:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107584:	ee                   	out    %al,(%dx)
}
80107585:	c9                   	leave  
80107586:	c3                   	ret    

80107587 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107587:	55                   	push   %ebp
80107588:	89 e5                	mov    %esp,%ebp
8010758a:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010758d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107594:	00 
80107595:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010759c:	e8 c8 ff ff ff       	call   80107569 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801075a1:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801075a8:	00 
801075a9:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801075b0:	e8 b4 ff ff ff       	call   80107569 <outb>
  outb(COM1+0, 115200/9600);
801075b5:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801075bc:	00 
801075bd:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801075c4:	e8 a0 ff ff ff       	call   80107569 <outb>
  outb(COM1+1, 0);
801075c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801075d0:	00 
801075d1:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801075d8:	e8 8c ff ff ff       	call   80107569 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801075dd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801075e4:	00 
801075e5:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801075ec:	e8 78 ff ff ff       	call   80107569 <outb>
  outb(COM1+4, 0);
801075f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801075f8:	00 
801075f9:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107600:	e8 64 ff ff ff       	call   80107569 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107605:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010760c:	00 
8010760d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107614:	e8 50 ff ff ff       	call   80107569 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107619:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107620:	e8 27 ff ff ff       	call   8010754c <inb>
80107625:	3c ff                	cmp    $0xff,%al
80107627:	75 02                	jne    8010762b <uartinit+0xa4>
    return;
80107629:	eb 6a                	jmp    80107695 <uartinit+0x10e>
  uart = 1;
8010762b:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107632:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107635:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010763c:	e8 0b ff ff ff       	call   8010754c <inb>
  inb(COM1+0);
80107641:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107648:	e8 ff fe ff ff       	call   8010754c <inb>
  picenable(IRQ_COM1);
8010764d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107654:	e8 80 c7 ff ff       	call   80103dd9 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107659:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107660:	00 
80107661:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107668:	e8 15 b3 ff ff       	call   80102982 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010766d:	c7 45 f4 68 96 10 80 	movl   $0x80109668,-0xc(%ebp)
80107674:	eb 15                	jmp    8010768b <uartinit+0x104>
    uartputc(*p);
80107676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107679:	0f b6 00             	movzbl (%eax),%eax
8010767c:	0f be c0             	movsbl %al,%eax
8010767f:	89 04 24             	mov    %eax,(%esp)
80107682:	e8 10 00 00 00       	call   80107697 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107687:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010768b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768e:	0f b6 00             	movzbl (%eax),%eax
80107691:	84 c0                	test   %al,%al
80107693:	75 e1                	jne    80107676 <uartinit+0xef>
    uartputc(*p);
}
80107695:	c9                   	leave  
80107696:	c3                   	ret    

80107697 <uartputc>:

void
uartputc(int c)
{
80107697:	55                   	push   %ebp
80107698:	89 e5                	mov    %esp,%ebp
8010769a:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010769d:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801076a2:	85 c0                	test   %eax,%eax
801076a4:	75 02                	jne    801076a8 <uartputc+0x11>
    return;
801076a6:	eb 4b                	jmp    801076f3 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801076af:	eb 10                	jmp    801076c1 <uartputc+0x2a>
    microdelay(10);
801076b1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801076b8:	e8 5d b8 ff ff       	call   80102f1a <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801076c1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801076c5:	7f 16                	jg     801076dd <uartputc+0x46>
801076c7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801076ce:	e8 79 fe ff ff       	call   8010754c <inb>
801076d3:	0f b6 c0             	movzbl %al,%eax
801076d6:	83 e0 20             	and    $0x20,%eax
801076d9:	85 c0                	test   %eax,%eax
801076db:	74 d4                	je     801076b1 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801076dd:	8b 45 08             	mov    0x8(%ebp),%eax
801076e0:	0f b6 c0             	movzbl %al,%eax
801076e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801076e7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801076ee:	e8 76 fe ff ff       	call   80107569 <outb>
}
801076f3:	c9                   	leave  
801076f4:	c3                   	ret    

801076f5 <uartgetc>:

static int
uartgetc(void)
{
801076f5:	55                   	push   %ebp
801076f6:	89 e5                	mov    %esp,%ebp
801076f8:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801076fb:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107700:	85 c0                	test   %eax,%eax
80107702:	75 07                	jne    8010770b <uartgetc+0x16>
    return -1;
80107704:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107709:	eb 2c                	jmp    80107737 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010770b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107712:	e8 35 fe ff ff       	call   8010754c <inb>
80107717:	0f b6 c0             	movzbl %al,%eax
8010771a:	83 e0 01             	and    $0x1,%eax
8010771d:	85 c0                	test   %eax,%eax
8010771f:	75 07                	jne    80107728 <uartgetc+0x33>
    return -1;
80107721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107726:	eb 0f                	jmp    80107737 <uartgetc+0x42>
  return inb(COM1+0);
80107728:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010772f:	e8 18 fe ff ff       	call   8010754c <inb>
80107734:	0f b6 c0             	movzbl %al,%eax
}
80107737:	c9                   	leave  
80107738:	c3                   	ret    

80107739 <uartintr>:

void
uartintr(void)
{
80107739:	55                   	push   %ebp
8010773a:	89 e5                	mov    %esp,%ebp
8010773c:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010773f:	c7 04 24 f5 76 10 80 	movl   $0x801076f5,(%esp)
80107746:	e8 62 90 ff ff       	call   801007ad <consoleintr>
}
8010774b:	c9                   	leave  
8010774c:	c3                   	ret    

8010774d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $0
8010774f:	6a 00                	push   $0x0
  jmp alltraps
80107751:	e9 28 f9 ff ff       	jmp    8010707e <alltraps>

80107756 <vector1>:
.globl vector1
vector1:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $1
80107758:	6a 01                	push   $0x1
  jmp alltraps
8010775a:	e9 1f f9 ff ff       	jmp    8010707e <alltraps>

8010775f <vector2>:
.globl vector2
vector2:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $2
80107761:	6a 02                	push   $0x2
  jmp alltraps
80107763:	e9 16 f9 ff ff       	jmp    8010707e <alltraps>

80107768 <vector3>:
.globl vector3
vector3:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $3
8010776a:	6a 03                	push   $0x3
  jmp alltraps
8010776c:	e9 0d f9 ff ff       	jmp    8010707e <alltraps>

80107771 <vector4>:
.globl vector4
vector4:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $4
80107773:	6a 04                	push   $0x4
  jmp alltraps
80107775:	e9 04 f9 ff ff       	jmp    8010707e <alltraps>

8010777a <vector5>:
.globl vector5
vector5:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $5
8010777c:	6a 05                	push   $0x5
  jmp alltraps
8010777e:	e9 fb f8 ff ff       	jmp    8010707e <alltraps>

80107783 <vector6>:
.globl vector6
vector6:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $6
80107785:	6a 06                	push   $0x6
  jmp alltraps
80107787:	e9 f2 f8 ff ff       	jmp    8010707e <alltraps>

8010778c <vector7>:
.globl vector7
vector7:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $7
8010778e:	6a 07                	push   $0x7
  jmp alltraps
80107790:	e9 e9 f8 ff ff       	jmp    8010707e <alltraps>

80107795 <vector8>:
.globl vector8
vector8:
  pushl $8
80107795:	6a 08                	push   $0x8
  jmp alltraps
80107797:	e9 e2 f8 ff ff       	jmp    8010707e <alltraps>

8010779c <vector9>:
.globl vector9
vector9:
  pushl $0
8010779c:	6a 00                	push   $0x0
  pushl $9
8010779e:	6a 09                	push   $0x9
  jmp alltraps
801077a0:	e9 d9 f8 ff ff       	jmp    8010707e <alltraps>

801077a5 <vector10>:
.globl vector10
vector10:
  pushl $10
801077a5:	6a 0a                	push   $0xa
  jmp alltraps
801077a7:	e9 d2 f8 ff ff       	jmp    8010707e <alltraps>

801077ac <vector11>:
.globl vector11
vector11:
  pushl $11
801077ac:	6a 0b                	push   $0xb
  jmp alltraps
801077ae:	e9 cb f8 ff ff       	jmp    8010707e <alltraps>

801077b3 <vector12>:
.globl vector12
vector12:
  pushl $12
801077b3:	6a 0c                	push   $0xc
  jmp alltraps
801077b5:	e9 c4 f8 ff ff       	jmp    8010707e <alltraps>

801077ba <vector13>:
.globl vector13
vector13:
  pushl $13
801077ba:	6a 0d                	push   $0xd
  jmp alltraps
801077bc:	e9 bd f8 ff ff       	jmp    8010707e <alltraps>

801077c1 <vector14>:
.globl vector14
vector14:
  pushl $14
801077c1:	6a 0e                	push   $0xe
  jmp alltraps
801077c3:	e9 b6 f8 ff ff       	jmp    8010707e <alltraps>

801077c8 <vector15>:
.globl vector15
vector15:
  pushl $0
801077c8:	6a 00                	push   $0x0
  pushl $15
801077ca:	6a 0f                	push   $0xf
  jmp alltraps
801077cc:	e9 ad f8 ff ff       	jmp    8010707e <alltraps>

801077d1 <vector16>:
.globl vector16
vector16:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $16
801077d3:	6a 10                	push   $0x10
  jmp alltraps
801077d5:	e9 a4 f8 ff ff       	jmp    8010707e <alltraps>

801077da <vector17>:
.globl vector17
vector17:
  pushl $17
801077da:	6a 11                	push   $0x11
  jmp alltraps
801077dc:	e9 9d f8 ff ff       	jmp    8010707e <alltraps>

801077e1 <vector18>:
.globl vector18
vector18:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $18
801077e3:	6a 12                	push   $0x12
  jmp alltraps
801077e5:	e9 94 f8 ff ff       	jmp    8010707e <alltraps>

801077ea <vector19>:
.globl vector19
vector19:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $19
801077ec:	6a 13                	push   $0x13
  jmp alltraps
801077ee:	e9 8b f8 ff ff       	jmp    8010707e <alltraps>

801077f3 <vector20>:
.globl vector20
vector20:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $20
801077f5:	6a 14                	push   $0x14
  jmp alltraps
801077f7:	e9 82 f8 ff ff       	jmp    8010707e <alltraps>

801077fc <vector21>:
.globl vector21
vector21:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $21
801077fe:	6a 15                	push   $0x15
  jmp alltraps
80107800:	e9 79 f8 ff ff       	jmp    8010707e <alltraps>

80107805 <vector22>:
.globl vector22
vector22:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $22
80107807:	6a 16                	push   $0x16
  jmp alltraps
80107809:	e9 70 f8 ff ff       	jmp    8010707e <alltraps>

8010780e <vector23>:
.globl vector23
vector23:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $23
80107810:	6a 17                	push   $0x17
  jmp alltraps
80107812:	e9 67 f8 ff ff       	jmp    8010707e <alltraps>

80107817 <vector24>:
.globl vector24
vector24:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $24
80107819:	6a 18                	push   $0x18
  jmp alltraps
8010781b:	e9 5e f8 ff ff       	jmp    8010707e <alltraps>

80107820 <vector25>:
.globl vector25
vector25:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $25
80107822:	6a 19                	push   $0x19
  jmp alltraps
80107824:	e9 55 f8 ff ff       	jmp    8010707e <alltraps>

80107829 <vector26>:
.globl vector26
vector26:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $26
8010782b:	6a 1a                	push   $0x1a
  jmp alltraps
8010782d:	e9 4c f8 ff ff       	jmp    8010707e <alltraps>

80107832 <vector27>:
.globl vector27
vector27:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $27
80107834:	6a 1b                	push   $0x1b
  jmp alltraps
80107836:	e9 43 f8 ff ff       	jmp    8010707e <alltraps>

8010783b <vector28>:
.globl vector28
vector28:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $28
8010783d:	6a 1c                	push   $0x1c
  jmp alltraps
8010783f:	e9 3a f8 ff ff       	jmp    8010707e <alltraps>

80107844 <vector29>:
.globl vector29
vector29:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $29
80107846:	6a 1d                	push   $0x1d
  jmp alltraps
80107848:	e9 31 f8 ff ff       	jmp    8010707e <alltraps>

8010784d <vector30>:
.globl vector30
vector30:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $30
8010784f:	6a 1e                	push   $0x1e
  jmp alltraps
80107851:	e9 28 f8 ff ff       	jmp    8010707e <alltraps>

80107856 <vector31>:
.globl vector31
vector31:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $31
80107858:	6a 1f                	push   $0x1f
  jmp alltraps
8010785a:	e9 1f f8 ff ff       	jmp    8010707e <alltraps>

8010785f <vector32>:
.globl vector32
vector32:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $32
80107861:	6a 20                	push   $0x20
  jmp alltraps
80107863:	e9 16 f8 ff ff       	jmp    8010707e <alltraps>

80107868 <vector33>:
.globl vector33
vector33:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $33
8010786a:	6a 21                	push   $0x21
  jmp alltraps
8010786c:	e9 0d f8 ff ff       	jmp    8010707e <alltraps>

80107871 <vector34>:
.globl vector34
vector34:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $34
80107873:	6a 22                	push   $0x22
  jmp alltraps
80107875:	e9 04 f8 ff ff       	jmp    8010707e <alltraps>

8010787a <vector35>:
.globl vector35
vector35:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $35
8010787c:	6a 23                	push   $0x23
  jmp alltraps
8010787e:	e9 fb f7 ff ff       	jmp    8010707e <alltraps>

80107883 <vector36>:
.globl vector36
vector36:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $36
80107885:	6a 24                	push   $0x24
  jmp alltraps
80107887:	e9 f2 f7 ff ff       	jmp    8010707e <alltraps>

8010788c <vector37>:
.globl vector37
vector37:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $37
8010788e:	6a 25                	push   $0x25
  jmp alltraps
80107890:	e9 e9 f7 ff ff       	jmp    8010707e <alltraps>

80107895 <vector38>:
.globl vector38
vector38:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $38
80107897:	6a 26                	push   $0x26
  jmp alltraps
80107899:	e9 e0 f7 ff ff       	jmp    8010707e <alltraps>

8010789e <vector39>:
.globl vector39
vector39:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $39
801078a0:	6a 27                	push   $0x27
  jmp alltraps
801078a2:	e9 d7 f7 ff ff       	jmp    8010707e <alltraps>

801078a7 <vector40>:
.globl vector40
vector40:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $40
801078a9:	6a 28                	push   $0x28
  jmp alltraps
801078ab:	e9 ce f7 ff ff       	jmp    8010707e <alltraps>

801078b0 <vector41>:
.globl vector41
vector41:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $41
801078b2:	6a 29                	push   $0x29
  jmp alltraps
801078b4:	e9 c5 f7 ff ff       	jmp    8010707e <alltraps>

801078b9 <vector42>:
.globl vector42
vector42:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $42
801078bb:	6a 2a                	push   $0x2a
  jmp alltraps
801078bd:	e9 bc f7 ff ff       	jmp    8010707e <alltraps>

801078c2 <vector43>:
.globl vector43
vector43:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $43
801078c4:	6a 2b                	push   $0x2b
  jmp alltraps
801078c6:	e9 b3 f7 ff ff       	jmp    8010707e <alltraps>

801078cb <vector44>:
.globl vector44
vector44:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $44
801078cd:	6a 2c                	push   $0x2c
  jmp alltraps
801078cf:	e9 aa f7 ff ff       	jmp    8010707e <alltraps>

801078d4 <vector45>:
.globl vector45
vector45:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $45
801078d6:	6a 2d                	push   $0x2d
  jmp alltraps
801078d8:	e9 a1 f7 ff ff       	jmp    8010707e <alltraps>

801078dd <vector46>:
.globl vector46
vector46:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $46
801078df:	6a 2e                	push   $0x2e
  jmp alltraps
801078e1:	e9 98 f7 ff ff       	jmp    8010707e <alltraps>

801078e6 <vector47>:
.globl vector47
vector47:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $47
801078e8:	6a 2f                	push   $0x2f
  jmp alltraps
801078ea:	e9 8f f7 ff ff       	jmp    8010707e <alltraps>

801078ef <vector48>:
.globl vector48
vector48:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $48
801078f1:	6a 30                	push   $0x30
  jmp alltraps
801078f3:	e9 86 f7 ff ff       	jmp    8010707e <alltraps>

801078f8 <vector49>:
.globl vector49
vector49:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $49
801078fa:	6a 31                	push   $0x31
  jmp alltraps
801078fc:	e9 7d f7 ff ff       	jmp    8010707e <alltraps>

80107901 <vector50>:
.globl vector50
vector50:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $50
80107903:	6a 32                	push   $0x32
  jmp alltraps
80107905:	e9 74 f7 ff ff       	jmp    8010707e <alltraps>

8010790a <vector51>:
.globl vector51
vector51:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $51
8010790c:	6a 33                	push   $0x33
  jmp alltraps
8010790e:	e9 6b f7 ff ff       	jmp    8010707e <alltraps>

80107913 <vector52>:
.globl vector52
vector52:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $52
80107915:	6a 34                	push   $0x34
  jmp alltraps
80107917:	e9 62 f7 ff ff       	jmp    8010707e <alltraps>

8010791c <vector53>:
.globl vector53
vector53:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $53
8010791e:	6a 35                	push   $0x35
  jmp alltraps
80107920:	e9 59 f7 ff ff       	jmp    8010707e <alltraps>

80107925 <vector54>:
.globl vector54
vector54:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $54
80107927:	6a 36                	push   $0x36
  jmp alltraps
80107929:	e9 50 f7 ff ff       	jmp    8010707e <alltraps>

8010792e <vector55>:
.globl vector55
vector55:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $55
80107930:	6a 37                	push   $0x37
  jmp alltraps
80107932:	e9 47 f7 ff ff       	jmp    8010707e <alltraps>

80107937 <vector56>:
.globl vector56
vector56:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $56
80107939:	6a 38                	push   $0x38
  jmp alltraps
8010793b:	e9 3e f7 ff ff       	jmp    8010707e <alltraps>

80107940 <vector57>:
.globl vector57
vector57:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $57
80107942:	6a 39                	push   $0x39
  jmp alltraps
80107944:	e9 35 f7 ff ff       	jmp    8010707e <alltraps>

80107949 <vector58>:
.globl vector58
vector58:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $58
8010794b:	6a 3a                	push   $0x3a
  jmp alltraps
8010794d:	e9 2c f7 ff ff       	jmp    8010707e <alltraps>

80107952 <vector59>:
.globl vector59
vector59:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $59
80107954:	6a 3b                	push   $0x3b
  jmp alltraps
80107956:	e9 23 f7 ff ff       	jmp    8010707e <alltraps>

8010795b <vector60>:
.globl vector60
vector60:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $60
8010795d:	6a 3c                	push   $0x3c
  jmp alltraps
8010795f:	e9 1a f7 ff ff       	jmp    8010707e <alltraps>

80107964 <vector61>:
.globl vector61
vector61:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $61
80107966:	6a 3d                	push   $0x3d
  jmp alltraps
80107968:	e9 11 f7 ff ff       	jmp    8010707e <alltraps>

8010796d <vector62>:
.globl vector62
vector62:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $62
8010796f:	6a 3e                	push   $0x3e
  jmp alltraps
80107971:	e9 08 f7 ff ff       	jmp    8010707e <alltraps>

80107976 <vector63>:
.globl vector63
vector63:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $63
80107978:	6a 3f                	push   $0x3f
  jmp alltraps
8010797a:	e9 ff f6 ff ff       	jmp    8010707e <alltraps>

8010797f <vector64>:
.globl vector64
vector64:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $64
80107981:	6a 40                	push   $0x40
  jmp alltraps
80107983:	e9 f6 f6 ff ff       	jmp    8010707e <alltraps>

80107988 <vector65>:
.globl vector65
vector65:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $65
8010798a:	6a 41                	push   $0x41
  jmp alltraps
8010798c:	e9 ed f6 ff ff       	jmp    8010707e <alltraps>

80107991 <vector66>:
.globl vector66
vector66:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $66
80107993:	6a 42                	push   $0x42
  jmp alltraps
80107995:	e9 e4 f6 ff ff       	jmp    8010707e <alltraps>

8010799a <vector67>:
.globl vector67
vector67:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $67
8010799c:	6a 43                	push   $0x43
  jmp alltraps
8010799e:	e9 db f6 ff ff       	jmp    8010707e <alltraps>

801079a3 <vector68>:
.globl vector68
vector68:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $68
801079a5:	6a 44                	push   $0x44
  jmp alltraps
801079a7:	e9 d2 f6 ff ff       	jmp    8010707e <alltraps>

801079ac <vector69>:
.globl vector69
vector69:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $69
801079ae:	6a 45                	push   $0x45
  jmp alltraps
801079b0:	e9 c9 f6 ff ff       	jmp    8010707e <alltraps>

801079b5 <vector70>:
.globl vector70
vector70:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $70
801079b7:	6a 46                	push   $0x46
  jmp alltraps
801079b9:	e9 c0 f6 ff ff       	jmp    8010707e <alltraps>

801079be <vector71>:
.globl vector71
vector71:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $71
801079c0:	6a 47                	push   $0x47
  jmp alltraps
801079c2:	e9 b7 f6 ff ff       	jmp    8010707e <alltraps>

801079c7 <vector72>:
.globl vector72
vector72:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $72
801079c9:	6a 48                	push   $0x48
  jmp alltraps
801079cb:	e9 ae f6 ff ff       	jmp    8010707e <alltraps>

801079d0 <vector73>:
.globl vector73
vector73:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $73
801079d2:	6a 49                	push   $0x49
  jmp alltraps
801079d4:	e9 a5 f6 ff ff       	jmp    8010707e <alltraps>

801079d9 <vector74>:
.globl vector74
vector74:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $74
801079db:	6a 4a                	push   $0x4a
  jmp alltraps
801079dd:	e9 9c f6 ff ff       	jmp    8010707e <alltraps>

801079e2 <vector75>:
.globl vector75
vector75:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $75
801079e4:	6a 4b                	push   $0x4b
  jmp alltraps
801079e6:	e9 93 f6 ff ff       	jmp    8010707e <alltraps>

801079eb <vector76>:
.globl vector76
vector76:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $76
801079ed:	6a 4c                	push   $0x4c
  jmp alltraps
801079ef:	e9 8a f6 ff ff       	jmp    8010707e <alltraps>

801079f4 <vector77>:
.globl vector77
vector77:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $77
801079f6:	6a 4d                	push   $0x4d
  jmp alltraps
801079f8:	e9 81 f6 ff ff       	jmp    8010707e <alltraps>

801079fd <vector78>:
.globl vector78
vector78:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $78
801079ff:	6a 4e                	push   $0x4e
  jmp alltraps
80107a01:	e9 78 f6 ff ff       	jmp    8010707e <alltraps>

80107a06 <vector79>:
.globl vector79
vector79:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $79
80107a08:	6a 4f                	push   $0x4f
  jmp alltraps
80107a0a:	e9 6f f6 ff ff       	jmp    8010707e <alltraps>

80107a0f <vector80>:
.globl vector80
vector80:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $80
80107a11:	6a 50                	push   $0x50
  jmp alltraps
80107a13:	e9 66 f6 ff ff       	jmp    8010707e <alltraps>

80107a18 <vector81>:
.globl vector81
vector81:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $81
80107a1a:	6a 51                	push   $0x51
  jmp alltraps
80107a1c:	e9 5d f6 ff ff       	jmp    8010707e <alltraps>

80107a21 <vector82>:
.globl vector82
vector82:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $82
80107a23:	6a 52                	push   $0x52
  jmp alltraps
80107a25:	e9 54 f6 ff ff       	jmp    8010707e <alltraps>

80107a2a <vector83>:
.globl vector83
vector83:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $83
80107a2c:	6a 53                	push   $0x53
  jmp alltraps
80107a2e:	e9 4b f6 ff ff       	jmp    8010707e <alltraps>

80107a33 <vector84>:
.globl vector84
vector84:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $84
80107a35:	6a 54                	push   $0x54
  jmp alltraps
80107a37:	e9 42 f6 ff ff       	jmp    8010707e <alltraps>

80107a3c <vector85>:
.globl vector85
vector85:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $85
80107a3e:	6a 55                	push   $0x55
  jmp alltraps
80107a40:	e9 39 f6 ff ff       	jmp    8010707e <alltraps>

80107a45 <vector86>:
.globl vector86
vector86:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $86
80107a47:	6a 56                	push   $0x56
  jmp alltraps
80107a49:	e9 30 f6 ff ff       	jmp    8010707e <alltraps>

80107a4e <vector87>:
.globl vector87
vector87:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $87
80107a50:	6a 57                	push   $0x57
  jmp alltraps
80107a52:	e9 27 f6 ff ff       	jmp    8010707e <alltraps>

80107a57 <vector88>:
.globl vector88
vector88:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $88
80107a59:	6a 58                	push   $0x58
  jmp alltraps
80107a5b:	e9 1e f6 ff ff       	jmp    8010707e <alltraps>

80107a60 <vector89>:
.globl vector89
vector89:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $89
80107a62:	6a 59                	push   $0x59
  jmp alltraps
80107a64:	e9 15 f6 ff ff       	jmp    8010707e <alltraps>

80107a69 <vector90>:
.globl vector90
vector90:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $90
80107a6b:	6a 5a                	push   $0x5a
  jmp alltraps
80107a6d:	e9 0c f6 ff ff       	jmp    8010707e <alltraps>

80107a72 <vector91>:
.globl vector91
vector91:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $91
80107a74:	6a 5b                	push   $0x5b
  jmp alltraps
80107a76:	e9 03 f6 ff ff       	jmp    8010707e <alltraps>

80107a7b <vector92>:
.globl vector92
vector92:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $92
80107a7d:	6a 5c                	push   $0x5c
  jmp alltraps
80107a7f:	e9 fa f5 ff ff       	jmp    8010707e <alltraps>

80107a84 <vector93>:
.globl vector93
vector93:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $93
80107a86:	6a 5d                	push   $0x5d
  jmp alltraps
80107a88:	e9 f1 f5 ff ff       	jmp    8010707e <alltraps>

80107a8d <vector94>:
.globl vector94
vector94:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $94
80107a8f:	6a 5e                	push   $0x5e
  jmp alltraps
80107a91:	e9 e8 f5 ff ff       	jmp    8010707e <alltraps>

80107a96 <vector95>:
.globl vector95
vector95:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $95
80107a98:	6a 5f                	push   $0x5f
  jmp alltraps
80107a9a:	e9 df f5 ff ff       	jmp    8010707e <alltraps>

80107a9f <vector96>:
.globl vector96
vector96:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $96
80107aa1:	6a 60                	push   $0x60
  jmp alltraps
80107aa3:	e9 d6 f5 ff ff       	jmp    8010707e <alltraps>

80107aa8 <vector97>:
.globl vector97
vector97:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $97
80107aaa:	6a 61                	push   $0x61
  jmp alltraps
80107aac:	e9 cd f5 ff ff       	jmp    8010707e <alltraps>

80107ab1 <vector98>:
.globl vector98
vector98:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $98
80107ab3:	6a 62                	push   $0x62
  jmp alltraps
80107ab5:	e9 c4 f5 ff ff       	jmp    8010707e <alltraps>

80107aba <vector99>:
.globl vector99
vector99:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $99
80107abc:	6a 63                	push   $0x63
  jmp alltraps
80107abe:	e9 bb f5 ff ff       	jmp    8010707e <alltraps>

80107ac3 <vector100>:
.globl vector100
vector100:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $100
80107ac5:	6a 64                	push   $0x64
  jmp alltraps
80107ac7:	e9 b2 f5 ff ff       	jmp    8010707e <alltraps>

80107acc <vector101>:
.globl vector101
vector101:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $101
80107ace:	6a 65                	push   $0x65
  jmp alltraps
80107ad0:	e9 a9 f5 ff ff       	jmp    8010707e <alltraps>

80107ad5 <vector102>:
.globl vector102
vector102:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $102
80107ad7:	6a 66                	push   $0x66
  jmp alltraps
80107ad9:	e9 a0 f5 ff ff       	jmp    8010707e <alltraps>

80107ade <vector103>:
.globl vector103
vector103:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $103
80107ae0:	6a 67                	push   $0x67
  jmp alltraps
80107ae2:	e9 97 f5 ff ff       	jmp    8010707e <alltraps>

80107ae7 <vector104>:
.globl vector104
vector104:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $104
80107ae9:	6a 68                	push   $0x68
  jmp alltraps
80107aeb:	e9 8e f5 ff ff       	jmp    8010707e <alltraps>

80107af0 <vector105>:
.globl vector105
vector105:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $105
80107af2:	6a 69                	push   $0x69
  jmp alltraps
80107af4:	e9 85 f5 ff ff       	jmp    8010707e <alltraps>

80107af9 <vector106>:
.globl vector106
vector106:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $106
80107afb:	6a 6a                	push   $0x6a
  jmp alltraps
80107afd:	e9 7c f5 ff ff       	jmp    8010707e <alltraps>

80107b02 <vector107>:
.globl vector107
vector107:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $107
80107b04:	6a 6b                	push   $0x6b
  jmp alltraps
80107b06:	e9 73 f5 ff ff       	jmp    8010707e <alltraps>

80107b0b <vector108>:
.globl vector108
vector108:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $108
80107b0d:	6a 6c                	push   $0x6c
  jmp alltraps
80107b0f:	e9 6a f5 ff ff       	jmp    8010707e <alltraps>

80107b14 <vector109>:
.globl vector109
vector109:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $109
80107b16:	6a 6d                	push   $0x6d
  jmp alltraps
80107b18:	e9 61 f5 ff ff       	jmp    8010707e <alltraps>

80107b1d <vector110>:
.globl vector110
vector110:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $110
80107b1f:	6a 6e                	push   $0x6e
  jmp alltraps
80107b21:	e9 58 f5 ff ff       	jmp    8010707e <alltraps>

80107b26 <vector111>:
.globl vector111
vector111:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $111
80107b28:	6a 6f                	push   $0x6f
  jmp alltraps
80107b2a:	e9 4f f5 ff ff       	jmp    8010707e <alltraps>

80107b2f <vector112>:
.globl vector112
vector112:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $112
80107b31:	6a 70                	push   $0x70
  jmp alltraps
80107b33:	e9 46 f5 ff ff       	jmp    8010707e <alltraps>

80107b38 <vector113>:
.globl vector113
vector113:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $113
80107b3a:	6a 71                	push   $0x71
  jmp alltraps
80107b3c:	e9 3d f5 ff ff       	jmp    8010707e <alltraps>

80107b41 <vector114>:
.globl vector114
vector114:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $114
80107b43:	6a 72                	push   $0x72
  jmp alltraps
80107b45:	e9 34 f5 ff ff       	jmp    8010707e <alltraps>

80107b4a <vector115>:
.globl vector115
vector115:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $115
80107b4c:	6a 73                	push   $0x73
  jmp alltraps
80107b4e:	e9 2b f5 ff ff       	jmp    8010707e <alltraps>

80107b53 <vector116>:
.globl vector116
vector116:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $116
80107b55:	6a 74                	push   $0x74
  jmp alltraps
80107b57:	e9 22 f5 ff ff       	jmp    8010707e <alltraps>

80107b5c <vector117>:
.globl vector117
vector117:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $117
80107b5e:	6a 75                	push   $0x75
  jmp alltraps
80107b60:	e9 19 f5 ff ff       	jmp    8010707e <alltraps>

80107b65 <vector118>:
.globl vector118
vector118:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $118
80107b67:	6a 76                	push   $0x76
  jmp alltraps
80107b69:	e9 10 f5 ff ff       	jmp    8010707e <alltraps>

80107b6e <vector119>:
.globl vector119
vector119:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $119
80107b70:	6a 77                	push   $0x77
  jmp alltraps
80107b72:	e9 07 f5 ff ff       	jmp    8010707e <alltraps>

80107b77 <vector120>:
.globl vector120
vector120:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $120
80107b79:	6a 78                	push   $0x78
  jmp alltraps
80107b7b:	e9 fe f4 ff ff       	jmp    8010707e <alltraps>

80107b80 <vector121>:
.globl vector121
vector121:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $121
80107b82:	6a 79                	push   $0x79
  jmp alltraps
80107b84:	e9 f5 f4 ff ff       	jmp    8010707e <alltraps>

80107b89 <vector122>:
.globl vector122
vector122:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $122
80107b8b:	6a 7a                	push   $0x7a
  jmp alltraps
80107b8d:	e9 ec f4 ff ff       	jmp    8010707e <alltraps>

80107b92 <vector123>:
.globl vector123
vector123:
  pushl $0
80107b92:	6a 00                	push   $0x0
  pushl $123
80107b94:	6a 7b                	push   $0x7b
  jmp alltraps
80107b96:	e9 e3 f4 ff ff       	jmp    8010707e <alltraps>

80107b9b <vector124>:
.globl vector124
vector124:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $124
80107b9d:	6a 7c                	push   $0x7c
  jmp alltraps
80107b9f:	e9 da f4 ff ff       	jmp    8010707e <alltraps>

80107ba4 <vector125>:
.globl vector125
vector125:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $125
80107ba6:	6a 7d                	push   $0x7d
  jmp alltraps
80107ba8:	e9 d1 f4 ff ff       	jmp    8010707e <alltraps>

80107bad <vector126>:
.globl vector126
vector126:
  pushl $0
80107bad:	6a 00                	push   $0x0
  pushl $126
80107baf:	6a 7e                	push   $0x7e
  jmp alltraps
80107bb1:	e9 c8 f4 ff ff       	jmp    8010707e <alltraps>

80107bb6 <vector127>:
.globl vector127
vector127:
  pushl $0
80107bb6:	6a 00                	push   $0x0
  pushl $127
80107bb8:	6a 7f                	push   $0x7f
  jmp alltraps
80107bba:	e9 bf f4 ff ff       	jmp    8010707e <alltraps>

80107bbf <vector128>:
.globl vector128
vector128:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $128
80107bc1:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107bc6:	e9 b3 f4 ff ff       	jmp    8010707e <alltraps>

80107bcb <vector129>:
.globl vector129
vector129:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $129
80107bcd:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107bd2:	e9 a7 f4 ff ff       	jmp    8010707e <alltraps>

80107bd7 <vector130>:
.globl vector130
vector130:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $130
80107bd9:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107bde:	e9 9b f4 ff ff       	jmp    8010707e <alltraps>

80107be3 <vector131>:
.globl vector131
vector131:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $131
80107be5:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107bea:	e9 8f f4 ff ff       	jmp    8010707e <alltraps>

80107bef <vector132>:
.globl vector132
vector132:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $132
80107bf1:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107bf6:	e9 83 f4 ff ff       	jmp    8010707e <alltraps>

80107bfb <vector133>:
.globl vector133
vector133:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $133
80107bfd:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107c02:	e9 77 f4 ff ff       	jmp    8010707e <alltraps>

80107c07 <vector134>:
.globl vector134
vector134:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $134
80107c09:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107c0e:	e9 6b f4 ff ff       	jmp    8010707e <alltraps>

80107c13 <vector135>:
.globl vector135
vector135:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $135
80107c15:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107c1a:	e9 5f f4 ff ff       	jmp    8010707e <alltraps>

80107c1f <vector136>:
.globl vector136
vector136:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $136
80107c21:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107c26:	e9 53 f4 ff ff       	jmp    8010707e <alltraps>

80107c2b <vector137>:
.globl vector137
vector137:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $137
80107c2d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107c32:	e9 47 f4 ff ff       	jmp    8010707e <alltraps>

80107c37 <vector138>:
.globl vector138
vector138:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $138
80107c39:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107c3e:	e9 3b f4 ff ff       	jmp    8010707e <alltraps>

80107c43 <vector139>:
.globl vector139
vector139:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $139
80107c45:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107c4a:	e9 2f f4 ff ff       	jmp    8010707e <alltraps>

80107c4f <vector140>:
.globl vector140
vector140:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $140
80107c51:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107c56:	e9 23 f4 ff ff       	jmp    8010707e <alltraps>

80107c5b <vector141>:
.globl vector141
vector141:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $141
80107c5d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107c62:	e9 17 f4 ff ff       	jmp    8010707e <alltraps>

80107c67 <vector142>:
.globl vector142
vector142:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $142
80107c69:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107c6e:	e9 0b f4 ff ff       	jmp    8010707e <alltraps>

80107c73 <vector143>:
.globl vector143
vector143:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $143
80107c75:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107c7a:	e9 ff f3 ff ff       	jmp    8010707e <alltraps>

80107c7f <vector144>:
.globl vector144
vector144:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $144
80107c81:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107c86:	e9 f3 f3 ff ff       	jmp    8010707e <alltraps>

80107c8b <vector145>:
.globl vector145
vector145:
  pushl $0
80107c8b:	6a 00                	push   $0x0
  pushl $145
80107c8d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107c92:	e9 e7 f3 ff ff       	jmp    8010707e <alltraps>

80107c97 <vector146>:
.globl vector146
vector146:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $146
80107c99:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107c9e:	e9 db f3 ff ff       	jmp    8010707e <alltraps>

80107ca3 <vector147>:
.globl vector147
vector147:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $147
80107ca5:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107caa:	e9 cf f3 ff ff       	jmp    8010707e <alltraps>

80107caf <vector148>:
.globl vector148
vector148:
  pushl $0
80107caf:	6a 00                	push   $0x0
  pushl $148
80107cb1:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107cb6:	e9 c3 f3 ff ff       	jmp    8010707e <alltraps>

80107cbb <vector149>:
.globl vector149
vector149:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $149
80107cbd:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107cc2:	e9 b7 f3 ff ff       	jmp    8010707e <alltraps>

80107cc7 <vector150>:
.globl vector150
vector150:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $150
80107cc9:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107cce:	e9 ab f3 ff ff       	jmp    8010707e <alltraps>

80107cd3 <vector151>:
.globl vector151
vector151:
  pushl $0
80107cd3:	6a 00                	push   $0x0
  pushl $151
80107cd5:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107cda:	e9 9f f3 ff ff       	jmp    8010707e <alltraps>

80107cdf <vector152>:
.globl vector152
vector152:
  pushl $0
80107cdf:	6a 00                	push   $0x0
  pushl $152
80107ce1:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107ce6:	e9 93 f3 ff ff       	jmp    8010707e <alltraps>

80107ceb <vector153>:
.globl vector153
vector153:
  pushl $0
80107ceb:	6a 00                	push   $0x0
  pushl $153
80107ced:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107cf2:	e9 87 f3 ff ff       	jmp    8010707e <alltraps>

80107cf7 <vector154>:
.globl vector154
vector154:
  pushl $0
80107cf7:	6a 00                	push   $0x0
  pushl $154
80107cf9:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107cfe:	e9 7b f3 ff ff       	jmp    8010707e <alltraps>

80107d03 <vector155>:
.globl vector155
vector155:
  pushl $0
80107d03:	6a 00                	push   $0x0
  pushl $155
80107d05:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107d0a:	e9 6f f3 ff ff       	jmp    8010707e <alltraps>

80107d0f <vector156>:
.globl vector156
vector156:
  pushl $0
80107d0f:	6a 00                	push   $0x0
  pushl $156
80107d11:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107d16:	e9 63 f3 ff ff       	jmp    8010707e <alltraps>

80107d1b <vector157>:
.globl vector157
vector157:
  pushl $0
80107d1b:	6a 00                	push   $0x0
  pushl $157
80107d1d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107d22:	e9 57 f3 ff ff       	jmp    8010707e <alltraps>

80107d27 <vector158>:
.globl vector158
vector158:
  pushl $0
80107d27:	6a 00                	push   $0x0
  pushl $158
80107d29:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107d2e:	e9 4b f3 ff ff       	jmp    8010707e <alltraps>

80107d33 <vector159>:
.globl vector159
vector159:
  pushl $0
80107d33:	6a 00                	push   $0x0
  pushl $159
80107d35:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107d3a:	e9 3f f3 ff ff       	jmp    8010707e <alltraps>

80107d3f <vector160>:
.globl vector160
vector160:
  pushl $0
80107d3f:	6a 00                	push   $0x0
  pushl $160
80107d41:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107d46:	e9 33 f3 ff ff       	jmp    8010707e <alltraps>

80107d4b <vector161>:
.globl vector161
vector161:
  pushl $0
80107d4b:	6a 00                	push   $0x0
  pushl $161
80107d4d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107d52:	e9 27 f3 ff ff       	jmp    8010707e <alltraps>

80107d57 <vector162>:
.globl vector162
vector162:
  pushl $0
80107d57:	6a 00                	push   $0x0
  pushl $162
80107d59:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107d5e:	e9 1b f3 ff ff       	jmp    8010707e <alltraps>

80107d63 <vector163>:
.globl vector163
vector163:
  pushl $0
80107d63:	6a 00                	push   $0x0
  pushl $163
80107d65:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107d6a:	e9 0f f3 ff ff       	jmp    8010707e <alltraps>

80107d6f <vector164>:
.globl vector164
vector164:
  pushl $0
80107d6f:	6a 00                	push   $0x0
  pushl $164
80107d71:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107d76:	e9 03 f3 ff ff       	jmp    8010707e <alltraps>

80107d7b <vector165>:
.globl vector165
vector165:
  pushl $0
80107d7b:	6a 00                	push   $0x0
  pushl $165
80107d7d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107d82:	e9 f7 f2 ff ff       	jmp    8010707e <alltraps>

80107d87 <vector166>:
.globl vector166
vector166:
  pushl $0
80107d87:	6a 00                	push   $0x0
  pushl $166
80107d89:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107d8e:	e9 eb f2 ff ff       	jmp    8010707e <alltraps>

80107d93 <vector167>:
.globl vector167
vector167:
  pushl $0
80107d93:	6a 00                	push   $0x0
  pushl $167
80107d95:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107d9a:	e9 df f2 ff ff       	jmp    8010707e <alltraps>

80107d9f <vector168>:
.globl vector168
vector168:
  pushl $0
80107d9f:	6a 00                	push   $0x0
  pushl $168
80107da1:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107da6:	e9 d3 f2 ff ff       	jmp    8010707e <alltraps>

80107dab <vector169>:
.globl vector169
vector169:
  pushl $0
80107dab:	6a 00                	push   $0x0
  pushl $169
80107dad:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107db2:	e9 c7 f2 ff ff       	jmp    8010707e <alltraps>

80107db7 <vector170>:
.globl vector170
vector170:
  pushl $0
80107db7:	6a 00                	push   $0x0
  pushl $170
80107db9:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107dbe:	e9 bb f2 ff ff       	jmp    8010707e <alltraps>

80107dc3 <vector171>:
.globl vector171
vector171:
  pushl $0
80107dc3:	6a 00                	push   $0x0
  pushl $171
80107dc5:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107dca:	e9 af f2 ff ff       	jmp    8010707e <alltraps>

80107dcf <vector172>:
.globl vector172
vector172:
  pushl $0
80107dcf:	6a 00                	push   $0x0
  pushl $172
80107dd1:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107dd6:	e9 a3 f2 ff ff       	jmp    8010707e <alltraps>

80107ddb <vector173>:
.globl vector173
vector173:
  pushl $0
80107ddb:	6a 00                	push   $0x0
  pushl $173
80107ddd:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107de2:	e9 97 f2 ff ff       	jmp    8010707e <alltraps>

80107de7 <vector174>:
.globl vector174
vector174:
  pushl $0
80107de7:	6a 00                	push   $0x0
  pushl $174
80107de9:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107dee:	e9 8b f2 ff ff       	jmp    8010707e <alltraps>

80107df3 <vector175>:
.globl vector175
vector175:
  pushl $0
80107df3:	6a 00                	push   $0x0
  pushl $175
80107df5:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107dfa:	e9 7f f2 ff ff       	jmp    8010707e <alltraps>

80107dff <vector176>:
.globl vector176
vector176:
  pushl $0
80107dff:	6a 00                	push   $0x0
  pushl $176
80107e01:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107e06:	e9 73 f2 ff ff       	jmp    8010707e <alltraps>

80107e0b <vector177>:
.globl vector177
vector177:
  pushl $0
80107e0b:	6a 00                	push   $0x0
  pushl $177
80107e0d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107e12:	e9 67 f2 ff ff       	jmp    8010707e <alltraps>

80107e17 <vector178>:
.globl vector178
vector178:
  pushl $0
80107e17:	6a 00                	push   $0x0
  pushl $178
80107e19:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107e1e:	e9 5b f2 ff ff       	jmp    8010707e <alltraps>

80107e23 <vector179>:
.globl vector179
vector179:
  pushl $0
80107e23:	6a 00                	push   $0x0
  pushl $179
80107e25:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107e2a:	e9 4f f2 ff ff       	jmp    8010707e <alltraps>

80107e2f <vector180>:
.globl vector180
vector180:
  pushl $0
80107e2f:	6a 00                	push   $0x0
  pushl $180
80107e31:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107e36:	e9 43 f2 ff ff       	jmp    8010707e <alltraps>

80107e3b <vector181>:
.globl vector181
vector181:
  pushl $0
80107e3b:	6a 00                	push   $0x0
  pushl $181
80107e3d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107e42:	e9 37 f2 ff ff       	jmp    8010707e <alltraps>

80107e47 <vector182>:
.globl vector182
vector182:
  pushl $0
80107e47:	6a 00                	push   $0x0
  pushl $182
80107e49:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107e4e:	e9 2b f2 ff ff       	jmp    8010707e <alltraps>

80107e53 <vector183>:
.globl vector183
vector183:
  pushl $0
80107e53:	6a 00                	push   $0x0
  pushl $183
80107e55:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107e5a:	e9 1f f2 ff ff       	jmp    8010707e <alltraps>

80107e5f <vector184>:
.globl vector184
vector184:
  pushl $0
80107e5f:	6a 00                	push   $0x0
  pushl $184
80107e61:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107e66:	e9 13 f2 ff ff       	jmp    8010707e <alltraps>

80107e6b <vector185>:
.globl vector185
vector185:
  pushl $0
80107e6b:	6a 00                	push   $0x0
  pushl $185
80107e6d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107e72:	e9 07 f2 ff ff       	jmp    8010707e <alltraps>

80107e77 <vector186>:
.globl vector186
vector186:
  pushl $0
80107e77:	6a 00                	push   $0x0
  pushl $186
80107e79:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107e7e:	e9 fb f1 ff ff       	jmp    8010707e <alltraps>

80107e83 <vector187>:
.globl vector187
vector187:
  pushl $0
80107e83:	6a 00                	push   $0x0
  pushl $187
80107e85:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107e8a:	e9 ef f1 ff ff       	jmp    8010707e <alltraps>

80107e8f <vector188>:
.globl vector188
vector188:
  pushl $0
80107e8f:	6a 00                	push   $0x0
  pushl $188
80107e91:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107e96:	e9 e3 f1 ff ff       	jmp    8010707e <alltraps>

80107e9b <vector189>:
.globl vector189
vector189:
  pushl $0
80107e9b:	6a 00                	push   $0x0
  pushl $189
80107e9d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107ea2:	e9 d7 f1 ff ff       	jmp    8010707e <alltraps>

80107ea7 <vector190>:
.globl vector190
vector190:
  pushl $0
80107ea7:	6a 00                	push   $0x0
  pushl $190
80107ea9:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107eae:	e9 cb f1 ff ff       	jmp    8010707e <alltraps>

80107eb3 <vector191>:
.globl vector191
vector191:
  pushl $0
80107eb3:	6a 00                	push   $0x0
  pushl $191
80107eb5:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107eba:	e9 bf f1 ff ff       	jmp    8010707e <alltraps>

80107ebf <vector192>:
.globl vector192
vector192:
  pushl $0
80107ebf:	6a 00                	push   $0x0
  pushl $192
80107ec1:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107ec6:	e9 b3 f1 ff ff       	jmp    8010707e <alltraps>

80107ecb <vector193>:
.globl vector193
vector193:
  pushl $0
80107ecb:	6a 00                	push   $0x0
  pushl $193
80107ecd:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ed2:	e9 a7 f1 ff ff       	jmp    8010707e <alltraps>

80107ed7 <vector194>:
.globl vector194
vector194:
  pushl $0
80107ed7:	6a 00                	push   $0x0
  pushl $194
80107ed9:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107ede:	e9 9b f1 ff ff       	jmp    8010707e <alltraps>

80107ee3 <vector195>:
.globl vector195
vector195:
  pushl $0
80107ee3:	6a 00                	push   $0x0
  pushl $195
80107ee5:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107eea:	e9 8f f1 ff ff       	jmp    8010707e <alltraps>

80107eef <vector196>:
.globl vector196
vector196:
  pushl $0
80107eef:	6a 00                	push   $0x0
  pushl $196
80107ef1:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107ef6:	e9 83 f1 ff ff       	jmp    8010707e <alltraps>

80107efb <vector197>:
.globl vector197
vector197:
  pushl $0
80107efb:	6a 00                	push   $0x0
  pushl $197
80107efd:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107f02:	e9 77 f1 ff ff       	jmp    8010707e <alltraps>

80107f07 <vector198>:
.globl vector198
vector198:
  pushl $0
80107f07:	6a 00                	push   $0x0
  pushl $198
80107f09:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107f0e:	e9 6b f1 ff ff       	jmp    8010707e <alltraps>

80107f13 <vector199>:
.globl vector199
vector199:
  pushl $0
80107f13:	6a 00                	push   $0x0
  pushl $199
80107f15:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107f1a:	e9 5f f1 ff ff       	jmp    8010707e <alltraps>

80107f1f <vector200>:
.globl vector200
vector200:
  pushl $0
80107f1f:	6a 00                	push   $0x0
  pushl $200
80107f21:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107f26:	e9 53 f1 ff ff       	jmp    8010707e <alltraps>

80107f2b <vector201>:
.globl vector201
vector201:
  pushl $0
80107f2b:	6a 00                	push   $0x0
  pushl $201
80107f2d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107f32:	e9 47 f1 ff ff       	jmp    8010707e <alltraps>

80107f37 <vector202>:
.globl vector202
vector202:
  pushl $0
80107f37:	6a 00                	push   $0x0
  pushl $202
80107f39:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107f3e:	e9 3b f1 ff ff       	jmp    8010707e <alltraps>

80107f43 <vector203>:
.globl vector203
vector203:
  pushl $0
80107f43:	6a 00                	push   $0x0
  pushl $203
80107f45:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107f4a:	e9 2f f1 ff ff       	jmp    8010707e <alltraps>

80107f4f <vector204>:
.globl vector204
vector204:
  pushl $0
80107f4f:	6a 00                	push   $0x0
  pushl $204
80107f51:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107f56:	e9 23 f1 ff ff       	jmp    8010707e <alltraps>

80107f5b <vector205>:
.globl vector205
vector205:
  pushl $0
80107f5b:	6a 00                	push   $0x0
  pushl $205
80107f5d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107f62:	e9 17 f1 ff ff       	jmp    8010707e <alltraps>

80107f67 <vector206>:
.globl vector206
vector206:
  pushl $0
80107f67:	6a 00                	push   $0x0
  pushl $206
80107f69:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107f6e:	e9 0b f1 ff ff       	jmp    8010707e <alltraps>

80107f73 <vector207>:
.globl vector207
vector207:
  pushl $0
80107f73:	6a 00                	push   $0x0
  pushl $207
80107f75:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107f7a:	e9 ff f0 ff ff       	jmp    8010707e <alltraps>

80107f7f <vector208>:
.globl vector208
vector208:
  pushl $0
80107f7f:	6a 00                	push   $0x0
  pushl $208
80107f81:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107f86:	e9 f3 f0 ff ff       	jmp    8010707e <alltraps>

80107f8b <vector209>:
.globl vector209
vector209:
  pushl $0
80107f8b:	6a 00                	push   $0x0
  pushl $209
80107f8d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107f92:	e9 e7 f0 ff ff       	jmp    8010707e <alltraps>

80107f97 <vector210>:
.globl vector210
vector210:
  pushl $0
80107f97:	6a 00                	push   $0x0
  pushl $210
80107f99:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107f9e:	e9 db f0 ff ff       	jmp    8010707e <alltraps>

80107fa3 <vector211>:
.globl vector211
vector211:
  pushl $0
80107fa3:	6a 00                	push   $0x0
  pushl $211
80107fa5:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107faa:	e9 cf f0 ff ff       	jmp    8010707e <alltraps>

80107faf <vector212>:
.globl vector212
vector212:
  pushl $0
80107faf:	6a 00                	push   $0x0
  pushl $212
80107fb1:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107fb6:	e9 c3 f0 ff ff       	jmp    8010707e <alltraps>

80107fbb <vector213>:
.globl vector213
vector213:
  pushl $0
80107fbb:	6a 00                	push   $0x0
  pushl $213
80107fbd:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107fc2:	e9 b7 f0 ff ff       	jmp    8010707e <alltraps>

80107fc7 <vector214>:
.globl vector214
vector214:
  pushl $0
80107fc7:	6a 00                	push   $0x0
  pushl $214
80107fc9:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107fce:	e9 ab f0 ff ff       	jmp    8010707e <alltraps>

80107fd3 <vector215>:
.globl vector215
vector215:
  pushl $0
80107fd3:	6a 00                	push   $0x0
  pushl $215
80107fd5:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107fda:	e9 9f f0 ff ff       	jmp    8010707e <alltraps>

80107fdf <vector216>:
.globl vector216
vector216:
  pushl $0
80107fdf:	6a 00                	push   $0x0
  pushl $216
80107fe1:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107fe6:	e9 93 f0 ff ff       	jmp    8010707e <alltraps>

80107feb <vector217>:
.globl vector217
vector217:
  pushl $0
80107feb:	6a 00                	push   $0x0
  pushl $217
80107fed:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ff2:	e9 87 f0 ff ff       	jmp    8010707e <alltraps>

80107ff7 <vector218>:
.globl vector218
vector218:
  pushl $0
80107ff7:	6a 00                	push   $0x0
  pushl $218
80107ff9:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ffe:	e9 7b f0 ff ff       	jmp    8010707e <alltraps>

80108003 <vector219>:
.globl vector219
vector219:
  pushl $0
80108003:	6a 00                	push   $0x0
  pushl $219
80108005:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010800a:	e9 6f f0 ff ff       	jmp    8010707e <alltraps>

8010800f <vector220>:
.globl vector220
vector220:
  pushl $0
8010800f:	6a 00                	push   $0x0
  pushl $220
80108011:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108016:	e9 63 f0 ff ff       	jmp    8010707e <alltraps>

8010801b <vector221>:
.globl vector221
vector221:
  pushl $0
8010801b:	6a 00                	push   $0x0
  pushl $221
8010801d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108022:	e9 57 f0 ff ff       	jmp    8010707e <alltraps>

80108027 <vector222>:
.globl vector222
vector222:
  pushl $0
80108027:	6a 00                	push   $0x0
  pushl $222
80108029:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010802e:	e9 4b f0 ff ff       	jmp    8010707e <alltraps>

80108033 <vector223>:
.globl vector223
vector223:
  pushl $0
80108033:	6a 00                	push   $0x0
  pushl $223
80108035:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010803a:	e9 3f f0 ff ff       	jmp    8010707e <alltraps>

8010803f <vector224>:
.globl vector224
vector224:
  pushl $0
8010803f:	6a 00                	push   $0x0
  pushl $224
80108041:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108046:	e9 33 f0 ff ff       	jmp    8010707e <alltraps>

8010804b <vector225>:
.globl vector225
vector225:
  pushl $0
8010804b:	6a 00                	push   $0x0
  pushl $225
8010804d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108052:	e9 27 f0 ff ff       	jmp    8010707e <alltraps>

80108057 <vector226>:
.globl vector226
vector226:
  pushl $0
80108057:	6a 00                	push   $0x0
  pushl $226
80108059:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010805e:	e9 1b f0 ff ff       	jmp    8010707e <alltraps>

80108063 <vector227>:
.globl vector227
vector227:
  pushl $0
80108063:	6a 00                	push   $0x0
  pushl $227
80108065:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010806a:	e9 0f f0 ff ff       	jmp    8010707e <alltraps>

8010806f <vector228>:
.globl vector228
vector228:
  pushl $0
8010806f:	6a 00                	push   $0x0
  pushl $228
80108071:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108076:	e9 03 f0 ff ff       	jmp    8010707e <alltraps>

8010807b <vector229>:
.globl vector229
vector229:
  pushl $0
8010807b:	6a 00                	push   $0x0
  pushl $229
8010807d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108082:	e9 f7 ef ff ff       	jmp    8010707e <alltraps>

80108087 <vector230>:
.globl vector230
vector230:
  pushl $0
80108087:	6a 00                	push   $0x0
  pushl $230
80108089:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010808e:	e9 eb ef ff ff       	jmp    8010707e <alltraps>

80108093 <vector231>:
.globl vector231
vector231:
  pushl $0
80108093:	6a 00                	push   $0x0
  pushl $231
80108095:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010809a:	e9 df ef ff ff       	jmp    8010707e <alltraps>

8010809f <vector232>:
.globl vector232
vector232:
  pushl $0
8010809f:	6a 00                	push   $0x0
  pushl $232
801080a1:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801080a6:	e9 d3 ef ff ff       	jmp    8010707e <alltraps>

801080ab <vector233>:
.globl vector233
vector233:
  pushl $0
801080ab:	6a 00                	push   $0x0
  pushl $233
801080ad:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801080b2:	e9 c7 ef ff ff       	jmp    8010707e <alltraps>

801080b7 <vector234>:
.globl vector234
vector234:
  pushl $0
801080b7:	6a 00                	push   $0x0
  pushl $234
801080b9:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801080be:	e9 bb ef ff ff       	jmp    8010707e <alltraps>

801080c3 <vector235>:
.globl vector235
vector235:
  pushl $0
801080c3:	6a 00                	push   $0x0
  pushl $235
801080c5:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801080ca:	e9 af ef ff ff       	jmp    8010707e <alltraps>

801080cf <vector236>:
.globl vector236
vector236:
  pushl $0
801080cf:	6a 00                	push   $0x0
  pushl $236
801080d1:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801080d6:	e9 a3 ef ff ff       	jmp    8010707e <alltraps>

801080db <vector237>:
.globl vector237
vector237:
  pushl $0
801080db:	6a 00                	push   $0x0
  pushl $237
801080dd:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801080e2:	e9 97 ef ff ff       	jmp    8010707e <alltraps>

801080e7 <vector238>:
.globl vector238
vector238:
  pushl $0
801080e7:	6a 00                	push   $0x0
  pushl $238
801080e9:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801080ee:	e9 8b ef ff ff       	jmp    8010707e <alltraps>

801080f3 <vector239>:
.globl vector239
vector239:
  pushl $0
801080f3:	6a 00                	push   $0x0
  pushl $239
801080f5:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801080fa:	e9 7f ef ff ff       	jmp    8010707e <alltraps>

801080ff <vector240>:
.globl vector240
vector240:
  pushl $0
801080ff:	6a 00                	push   $0x0
  pushl $240
80108101:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108106:	e9 73 ef ff ff       	jmp    8010707e <alltraps>

8010810b <vector241>:
.globl vector241
vector241:
  pushl $0
8010810b:	6a 00                	push   $0x0
  pushl $241
8010810d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108112:	e9 67 ef ff ff       	jmp    8010707e <alltraps>

80108117 <vector242>:
.globl vector242
vector242:
  pushl $0
80108117:	6a 00                	push   $0x0
  pushl $242
80108119:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010811e:	e9 5b ef ff ff       	jmp    8010707e <alltraps>

80108123 <vector243>:
.globl vector243
vector243:
  pushl $0
80108123:	6a 00                	push   $0x0
  pushl $243
80108125:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010812a:	e9 4f ef ff ff       	jmp    8010707e <alltraps>

8010812f <vector244>:
.globl vector244
vector244:
  pushl $0
8010812f:	6a 00                	push   $0x0
  pushl $244
80108131:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108136:	e9 43 ef ff ff       	jmp    8010707e <alltraps>

8010813b <vector245>:
.globl vector245
vector245:
  pushl $0
8010813b:	6a 00                	push   $0x0
  pushl $245
8010813d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108142:	e9 37 ef ff ff       	jmp    8010707e <alltraps>

80108147 <vector246>:
.globl vector246
vector246:
  pushl $0
80108147:	6a 00                	push   $0x0
  pushl $246
80108149:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010814e:	e9 2b ef ff ff       	jmp    8010707e <alltraps>

80108153 <vector247>:
.globl vector247
vector247:
  pushl $0
80108153:	6a 00                	push   $0x0
  pushl $247
80108155:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010815a:	e9 1f ef ff ff       	jmp    8010707e <alltraps>

8010815f <vector248>:
.globl vector248
vector248:
  pushl $0
8010815f:	6a 00                	push   $0x0
  pushl $248
80108161:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108166:	e9 13 ef ff ff       	jmp    8010707e <alltraps>

8010816b <vector249>:
.globl vector249
vector249:
  pushl $0
8010816b:	6a 00                	push   $0x0
  pushl $249
8010816d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108172:	e9 07 ef ff ff       	jmp    8010707e <alltraps>

80108177 <vector250>:
.globl vector250
vector250:
  pushl $0
80108177:	6a 00                	push   $0x0
  pushl $250
80108179:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010817e:	e9 fb ee ff ff       	jmp    8010707e <alltraps>

80108183 <vector251>:
.globl vector251
vector251:
  pushl $0
80108183:	6a 00                	push   $0x0
  pushl $251
80108185:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010818a:	e9 ef ee ff ff       	jmp    8010707e <alltraps>

8010818f <vector252>:
.globl vector252
vector252:
  pushl $0
8010818f:	6a 00                	push   $0x0
  pushl $252
80108191:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108196:	e9 e3 ee ff ff       	jmp    8010707e <alltraps>

8010819b <vector253>:
.globl vector253
vector253:
  pushl $0
8010819b:	6a 00                	push   $0x0
  pushl $253
8010819d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801081a2:	e9 d7 ee ff ff       	jmp    8010707e <alltraps>

801081a7 <vector254>:
.globl vector254
vector254:
  pushl $0
801081a7:	6a 00                	push   $0x0
  pushl $254
801081a9:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801081ae:	e9 cb ee ff ff       	jmp    8010707e <alltraps>

801081b3 <vector255>:
.globl vector255
vector255:
  pushl $0
801081b3:	6a 00                	push   $0x0
  pushl $255
801081b5:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801081ba:	e9 bf ee ff ff       	jmp    8010707e <alltraps>

801081bf <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801081bf:	55                   	push   %ebp
801081c0:	89 e5                	mov    %esp,%ebp
801081c2:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801081c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801081c8:	83 e8 01             	sub    $0x1,%eax
801081cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801081cf:	8b 45 08             	mov    0x8(%ebp),%eax
801081d2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801081d6:	8b 45 08             	mov    0x8(%ebp),%eax
801081d9:	c1 e8 10             	shr    $0x10,%eax
801081dc:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801081e0:	8d 45 fa             	lea    -0x6(%ebp),%eax
801081e3:	0f 01 10             	lgdtl  (%eax)
}
801081e6:	c9                   	leave  
801081e7:	c3                   	ret    

801081e8 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801081e8:	55                   	push   %ebp
801081e9:	89 e5                	mov    %esp,%ebp
801081eb:	83 ec 04             	sub    $0x4,%esp
801081ee:	8b 45 08             	mov    0x8(%ebp),%eax
801081f1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801081f5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801081f9:	0f 00 d8             	ltr    %ax
}
801081fc:	c9                   	leave  
801081fd:	c3                   	ret    

801081fe <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801081fe:	55                   	push   %ebp
801081ff:	89 e5                	mov    %esp,%ebp
80108201:	83 ec 04             	sub    $0x4,%esp
80108204:	8b 45 08             	mov    0x8(%ebp),%eax
80108207:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010820b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010820f:	8e e8                	mov    %eax,%gs
}
80108211:	c9                   	leave  
80108212:	c3                   	ret    

80108213 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108213:	55                   	push   %ebp
80108214:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108216:	8b 45 08             	mov    0x8(%ebp),%eax
80108219:	0f 22 d8             	mov    %eax,%cr3
}
8010821c:	5d                   	pop    %ebp
8010821d:	c3                   	ret    

8010821e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010821e:	55                   	push   %ebp
8010821f:	89 e5                	mov    %esp,%ebp
80108221:	8b 45 08             	mov    0x8(%ebp),%eax
80108224:	05 00 00 00 80       	add    $0x80000000,%eax
80108229:	5d                   	pop    %ebp
8010822a:	c3                   	ret    

8010822b <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
8010822e:	8b 45 08             	mov    0x8(%ebp),%eax
80108231:	05 00 00 00 80       	add    $0x80000000,%eax
80108236:	5d                   	pop    %ebp
80108237:	c3                   	ret    

80108238 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108238:	55                   	push   %ebp
80108239:	89 e5                	mov    %esp,%ebp
8010823b:	53                   	push   %ebx
8010823c:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010823f:	e8 59 ac ff ff       	call   80102e9d <cpunum>
80108244:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010824a:	05 80 33 11 80       	add    $0x80113380,%eax
8010824f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108255:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010825b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108267:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010826b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108272:	83 e2 f0             	and    $0xfffffff0,%edx
80108275:	83 ca 0a             	or     $0xa,%edx
80108278:	88 50 7d             	mov    %dl,0x7d(%eax)
8010827b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108282:	83 ca 10             	or     $0x10,%edx
80108285:	88 50 7d             	mov    %dl,0x7d(%eax)
80108288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010828f:	83 e2 9f             	and    $0xffffff9f,%edx
80108292:	88 50 7d             	mov    %dl,0x7d(%eax)
80108295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108298:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010829c:	83 ca 80             	or     $0xffffff80,%edx
8010829f:	88 50 7d             	mov    %dl,0x7d(%eax)
801082a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082a9:	83 ca 0f             	or     $0xf,%edx
801082ac:	88 50 7e             	mov    %dl,0x7e(%eax)
801082af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082b6:	83 e2 ef             	and    $0xffffffef,%edx
801082b9:	88 50 7e             	mov    %dl,0x7e(%eax)
801082bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082c3:	83 e2 df             	and    $0xffffffdf,%edx
801082c6:	88 50 7e             	mov    %dl,0x7e(%eax)
801082c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082d0:	83 ca 40             	or     $0x40,%edx
801082d3:	88 50 7e             	mov    %dl,0x7e(%eax)
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082dd:	83 ca 80             	or     $0xffffff80,%edx
801082e0:	88 50 7e             	mov    %dl,0x7e(%eax)
801082e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801082ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ed:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801082f4:	ff ff 
801082f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108300:	00 00 
80108302:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108305:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010830c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108316:	83 e2 f0             	and    $0xfffffff0,%edx
80108319:	83 ca 02             	or     $0x2,%edx
8010831c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108325:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010832c:	83 ca 10             	or     $0x10,%edx
8010832f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108338:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010833f:	83 e2 9f             	and    $0xffffff9f,%edx
80108342:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108352:	83 ca 80             	or     $0xffffff80,%edx
80108355:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108365:	83 ca 0f             	or     $0xf,%edx
80108368:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108371:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108378:	83 e2 ef             	and    $0xffffffef,%edx
8010837b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108384:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010838b:	83 e2 df             	and    $0xffffffdf,%edx
8010838e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108397:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010839e:	83 ca 40             	or     $0x40,%edx
801083a1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083aa:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801083b1:	83 ca 80             	or     $0xffffff80,%edx
801083b4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bd:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801083c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801083ce:	ff ff 
801083d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801083da:	00 00 
801083dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083df:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801083e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801083f0:	83 e2 f0             	and    $0xfffffff0,%edx
801083f3:	83 ca 0a             	or     $0xa,%edx
801083f6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801083fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ff:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108406:	83 ca 10             	or     $0x10,%edx
80108409:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010840f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108412:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108419:	83 ca 60             	or     $0x60,%edx
8010841c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108425:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010842c:	83 ca 80             	or     $0xffffff80,%edx
8010842f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108438:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010843f:	83 ca 0f             	or     $0xf,%edx
80108442:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108452:	83 e2 ef             	and    $0xffffffef,%edx
80108455:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010845b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108465:	83 e2 df             	and    $0xffffffdf,%edx
80108468:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010846e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108471:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108478:	83 ca 40             	or     $0x40,%edx
8010847b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108484:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010848b:	83 ca 80             	or     $0xffffff80,%edx
8010848e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108497:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010849e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a1:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801084a8:	ff ff 
801084aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ad:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801084b4:	00 00 
801084b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b9:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801084c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801084ca:	83 e2 f0             	and    $0xfffffff0,%edx
801084cd:	83 ca 02             	or     $0x2,%edx
801084d0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801084d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801084e0:	83 ca 10             	or     $0x10,%edx
801084e3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801084e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ec:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801084f3:	83 ca 60             	or     $0x60,%edx
801084f6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801084fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ff:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108506:	83 ca 80             	or     $0xffffff80,%edx
80108509:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010850f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108512:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108519:	83 ca 0f             	or     $0xf,%edx
8010851c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108525:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010852c:	83 e2 ef             	and    $0xffffffef,%edx
8010852f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108538:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010853f:	83 e2 df             	and    $0xffffffdf,%edx
80108542:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108548:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010854b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108552:	83 ca 40             	or     $0x40,%edx
80108555:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010855b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108565:	83 ca 80             	or     $0xffffff80,%edx
80108568:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010856e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108571:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010857b:	05 b4 00 00 00       	add    $0xb4,%eax
80108580:	89 c3                	mov    %eax,%ebx
80108582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108585:	05 b4 00 00 00       	add    $0xb4,%eax
8010858a:	c1 e8 10             	shr    $0x10,%eax
8010858d:	89 c1                	mov    %eax,%ecx
8010858f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108592:	05 b4 00 00 00       	add    $0xb4,%eax
80108597:	c1 e8 18             	shr    $0x18,%eax
8010859a:	89 c2                	mov    %eax,%edx
8010859c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801085a6:	00 00 
801085a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ab:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801085b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b5:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801085bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085be:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801085c5:	83 e1 f0             	and    $0xfffffff0,%ecx
801085c8:	83 c9 02             	or     $0x2,%ecx
801085cb:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801085d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d4:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801085db:	83 c9 10             	or     $0x10,%ecx
801085de:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801085e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801085ee:	83 e1 9f             	and    $0xffffff9f,%ecx
801085f1:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801085f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fa:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108601:	83 c9 80             	or     $0xffffff80,%ecx
80108604:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010860a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108614:	83 e1 f0             	and    $0xfffffff0,%ecx
80108617:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010861d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108620:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108627:	83 e1 ef             	and    $0xffffffef,%ecx
8010862a:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108633:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010863a:	83 e1 df             	and    $0xffffffdf,%ecx
8010863d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108646:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010864d:	83 c9 40             	or     $0x40,%ecx
80108650:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108659:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108660:	83 c9 80             	or     $0xffffff80,%ecx
80108663:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010866c:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108675:	83 c0 70             	add    $0x70,%eax
80108678:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010867f:	00 
80108680:	89 04 24             	mov    %eax,(%esp)
80108683:	e8 37 fb ff ff       	call   801081bf <lgdt>
  loadgs(SEG_KCPU << 3);
80108688:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010868f:	e8 6a fb ff ff       	call   801081fe <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108697:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  thread = 0;
8010869d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801086a4:	00 00 00 00 
}
801086a8:	83 c4 24             	add    $0x24,%esp
801086ab:	5b                   	pop    %ebx
801086ac:	5d                   	pop    %ebp
801086ad:	c3                   	ret    

801086ae <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801086ae:	55                   	push   %ebp
801086af:	89 e5                	mov    %esp,%ebp
801086b1:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801086b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801086b7:	c1 e8 16             	shr    $0x16,%eax
801086ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086c1:	8b 45 08             	mov    0x8(%ebp),%eax
801086c4:	01 d0                	add    %edx,%eax
801086c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801086c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086cc:	8b 00                	mov    (%eax),%eax
801086ce:	83 e0 01             	and    $0x1,%eax
801086d1:	85 c0                	test   %eax,%eax
801086d3:	74 17                	je     801086ec <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801086d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086d8:	8b 00                	mov    (%eax),%eax
801086da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086df:	89 04 24             	mov    %eax,(%esp)
801086e2:	e8 44 fb ff ff       	call   8010822b <p2v>
801086e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086ea:	eb 4b                	jmp    80108737 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801086ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801086f0:	74 0e                	je     80108700 <walkpgdir+0x52>
801086f2:	e8 10 a4 ff ff       	call   80102b07 <kalloc>
801086f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801086fe:	75 07                	jne    80108707 <walkpgdir+0x59>
      return 0;
80108700:	b8 00 00 00 00       	mov    $0x0,%eax
80108705:	eb 47                	jmp    8010874e <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108707:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010870e:	00 
8010870f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108716:	00 
80108717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871a:	89 04 24             	mov    %eax,(%esp)
8010871d:	e8 7f d3 ff ff       	call   80105aa1 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108725:	89 04 24             	mov    %eax,(%esp)
80108728:	e8 f1 fa ff ff       	call   8010821e <v2p>
8010872d:	83 c8 07             	or     $0x7,%eax
80108730:	89 c2                	mov    %eax,%edx
80108732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108735:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108737:	8b 45 0c             	mov    0xc(%ebp),%eax
8010873a:	c1 e8 0c             	shr    $0xc,%eax
8010873d:	25 ff 03 00 00       	and    $0x3ff,%eax
80108742:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874c:	01 d0                	add    %edx,%eax
}
8010874e:	c9                   	leave  
8010874f:	c3                   	ret    

80108750 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108750:	55                   	push   %ebp
80108751:	89 e5                	mov    %esp,%ebp
80108753:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108756:	8b 45 0c             	mov    0xc(%ebp),%eax
80108759:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010875e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108761:	8b 55 0c             	mov    0xc(%ebp),%edx
80108764:	8b 45 10             	mov    0x10(%ebp),%eax
80108767:	01 d0                	add    %edx,%eax
80108769:	83 e8 01             	sub    $0x1,%eax
8010876c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108774:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010877b:	00 
8010877c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108783:	8b 45 08             	mov    0x8(%ebp),%eax
80108786:	89 04 24             	mov    %eax,(%esp)
80108789:	e8 20 ff ff ff       	call   801086ae <walkpgdir>
8010878e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108791:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108795:	75 07                	jne    8010879e <mappages+0x4e>
      return -1;
80108797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010879c:	eb 48                	jmp    801087e6 <mappages+0x96>
    if(*pte & PTE_P)
8010879e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087a1:	8b 00                	mov    (%eax),%eax
801087a3:	83 e0 01             	and    $0x1,%eax
801087a6:	85 c0                	test   %eax,%eax
801087a8:	74 0c                	je     801087b6 <mappages+0x66>
      panic("remap");
801087aa:	c7 04 24 70 96 10 80 	movl   $0x80109670,(%esp)
801087b1:	e8 84 7d ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801087b6:	8b 45 18             	mov    0x18(%ebp),%eax
801087b9:	0b 45 14             	or     0x14(%ebp),%eax
801087bc:	83 c8 01             	or     $0x1,%eax
801087bf:	89 c2                	mov    %eax,%edx
801087c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087c4:	89 10                	mov    %edx,(%eax)
    if(a == last)
801087c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801087cc:	75 08                	jne    801087d6 <mappages+0x86>
      break;
801087ce:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801087cf:	b8 00 00 00 00       	mov    $0x0,%eax
801087d4:	eb 10                	jmp    801087e6 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801087d6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801087dd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801087e4:	eb 8e                	jmp    80108774 <mappages+0x24>
  return 0;
}
801087e6:	c9                   	leave  
801087e7:	c3                   	ret    

801087e8 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801087e8:	55                   	push   %ebp
801087e9:	89 e5                	mov    %esp,%ebp
801087eb:	53                   	push   %ebx
801087ec:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801087ef:	e8 13 a3 ff ff       	call   80102b07 <kalloc>
801087f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087fb:	75 0a                	jne    80108807 <setupkvm+0x1f>
    return 0;
801087fd:	b8 00 00 00 00       	mov    $0x0,%eax
80108802:	e9 98 00 00 00       	jmp    8010889f <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108807:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010880e:	00 
8010880f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108816:	00 
80108817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010881a:	89 04 24             	mov    %eax,(%esp)
8010881d:	e8 7f d2 ff ff       	call   80105aa1 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108822:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108829:	e8 fd f9 ff ff       	call   8010822b <p2v>
8010882e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108833:	76 0c                	jbe    80108841 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108835:	c7 04 24 76 96 10 80 	movl   $0x80109676,(%esp)
8010883c:	e8 f9 7c ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108841:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108848:	eb 49                	jmp    80108893 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010884a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884d:	8b 48 0c             	mov    0xc(%eax),%ecx
80108850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108853:	8b 50 04             	mov    0x4(%eax),%edx
80108856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108859:	8b 58 08             	mov    0x8(%eax),%ebx
8010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885f:	8b 40 04             	mov    0x4(%eax),%eax
80108862:	29 c3                	sub    %eax,%ebx
80108864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108867:	8b 00                	mov    (%eax),%eax
80108869:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010886d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108871:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108875:	89 44 24 04          	mov    %eax,0x4(%esp)
80108879:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010887c:	89 04 24             	mov    %eax,(%esp)
8010887f:	e8 cc fe ff ff       	call   80108750 <mappages>
80108884:	85 c0                	test   %eax,%eax
80108886:	79 07                	jns    8010888f <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108888:	b8 00 00 00 00       	mov    $0x0,%eax
8010888d:	eb 10                	jmp    8010889f <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010888f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108893:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010889a:	72 ae                	jb     8010884a <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010889c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010889f:	83 c4 34             	add    $0x34,%esp
801088a2:	5b                   	pop    %ebx
801088a3:	5d                   	pop    %ebp
801088a4:	c3                   	ret    

801088a5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801088a5:	55                   	push   %ebp
801088a6:	89 e5                	mov    %esp,%ebp
801088a8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801088ab:	e8 38 ff ff ff       	call   801087e8 <setupkvm>
801088b0:	a3 58 f2 11 80       	mov    %eax,0x8011f258
  switchkvm();
801088b5:	e8 02 00 00 00       	call   801088bc <switchkvm>
}
801088ba:	c9                   	leave  
801088bb:	c3                   	ret    

801088bc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801088bc:	55                   	push   %ebp
801088bd:	89 e5                	mov    %esp,%ebp
801088bf:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801088c2:	a1 58 f2 11 80       	mov    0x8011f258,%eax
801088c7:	89 04 24             	mov    %eax,(%esp)
801088ca:	e8 4f f9 ff ff       	call   8010821e <v2p>
801088cf:	89 04 24             	mov    %eax,(%esp)
801088d2:	e8 3c f9 ff ff       	call   80108213 <lcr3>
}
801088d7:	c9                   	leave  
801088d8:	c3                   	ret    

801088d9 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct thread *t)
{
801088d9:	55                   	push   %ebp
801088da:	89 e5                	mov    %esp,%ebp
801088dc:	53                   	push   %ebx
801088dd:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801088e0:	e8 0b c9 ff ff       	call   801051f0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801088e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801088eb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801088f2:	83 c2 08             	add    $0x8,%edx
801088f5:	89 d3                	mov    %edx,%ebx
801088f7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801088fe:	83 c2 08             	add    $0x8,%edx
80108901:	c1 ea 10             	shr    $0x10,%edx
80108904:	89 d1                	mov    %edx,%ecx
80108906:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010890d:	83 c2 08             	add    $0x8,%edx
80108910:	c1 ea 18             	shr    $0x18,%edx
80108913:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010891a:	67 00 
8010891c:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108923:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108929:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108930:	83 e1 f0             	and    $0xfffffff0,%ecx
80108933:	83 c9 09             	or     $0x9,%ecx
80108936:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010893c:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108943:	83 c9 10             	or     $0x10,%ecx
80108946:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010894c:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108953:	83 e1 9f             	and    $0xffffff9f,%ecx
80108956:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010895c:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108963:	83 c9 80             	or     $0xffffff80,%ecx
80108966:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010896c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108973:	83 e1 f0             	and    $0xfffffff0,%ecx
80108976:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010897c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108983:	83 e1 ef             	and    $0xffffffef,%ecx
80108986:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010898c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108993:	83 e1 df             	and    $0xffffffdf,%ecx
80108996:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010899c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089a3:	83 c9 40             	or     $0x40,%ecx
801089a6:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089ac:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089b3:	83 e1 7f             	and    $0x7f,%ecx
801089b6:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089bc:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801089c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801089c8:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801089cf:	83 e2 ef             	and    $0xffffffef,%edx
801089d2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801089d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801089de:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)thread->kstack + KSTACKSIZE;
801089e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801089ea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801089f1:	8b 12                	mov    (%edx),%edx
801089f3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801089f9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801089fc:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108a03:	e8 e0 f7 ff ff       	call   801081e8 <ltr>
  if(t->proc->pgdir == 0)
80108a08:	8b 45 08             	mov    0x8(%ebp),%eax
80108a0b:	8b 40 0c             	mov    0xc(%eax),%eax
80108a0e:	8b 40 04             	mov    0x4(%eax),%eax
80108a11:	85 c0                	test   %eax,%eax
80108a13:	75 0c                	jne    80108a21 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108a15:	c7 04 24 87 96 10 80 	movl   $0x80109687,(%esp)
80108a1c:	e8 19 7b ff ff       	call   8010053a <panic>
  lcr3(v2p(t->proc->pgdir ));  // switch to new address space
80108a21:	8b 45 08             	mov    0x8(%ebp),%eax
80108a24:	8b 40 0c             	mov    0xc(%eax),%eax
80108a27:	8b 40 04             	mov    0x4(%eax),%eax
80108a2a:	89 04 24             	mov    %eax,(%esp)
80108a2d:	e8 ec f7 ff ff       	call   8010821e <v2p>
80108a32:	89 04 24             	mov    %eax,(%esp)
80108a35:	e8 d9 f7 ff ff       	call   80108213 <lcr3>

  popcli();
80108a3a:	e8 f5 c7 ff ff       	call   80105234 <popcli>
}
80108a3f:	83 c4 14             	add    $0x14,%esp
80108a42:	5b                   	pop    %ebx
80108a43:	5d                   	pop    %ebp
80108a44:	c3                   	ret    

80108a45 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108a45:	55                   	push   %ebp
80108a46:	89 e5                	mov    %esp,%ebp
80108a48:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108a4b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108a52:	76 0c                	jbe    80108a60 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108a54:	c7 04 24 9b 96 10 80 	movl   $0x8010969b,(%esp)
80108a5b:	e8 da 7a ff ff       	call   8010053a <panic>
  mem = kalloc();
80108a60:	e8 a2 a0 ff ff       	call   80102b07 <kalloc>
80108a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108a68:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a6f:	00 
80108a70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108a77:	00 
80108a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a7b:	89 04 24             	mov    %eax,(%esp)
80108a7e:	e8 1e d0 ff ff       	call   80105aa1 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a86:	89 04 24             	mov    %eax,(%esp)
80108a89:	e8 90 f7 ff ff       	call   8010821e <v2p>
80108a8e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108a95:	00 
80108a96:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108a9a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108aa1:	00 
80108aa2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108aa9:	00 
80108aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80108aad:	89 04 24             	mov    %eax,(%esp)
80108ab0:	e8 9b fc ff ff       	call   80108750 <mappages>
  memmove(mem, init, sz);
80108ab5:	8b 45 10             	mov    0x10(%ebp),%eax
80108ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
80108abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80108abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac6:	89 04 24             	mov    %eax,(%esp)
80108ac9:	e8 a2 d0 ff ff       	call   80105b70 <memmove>
}
80108ace:	c9                   	leave  
80108acf:	c3                   	ret    

80108ad0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108ad0:	55                   	push   %ebp
80108ad1:	89 e5                	mov    %esp,%ebp
80108ad3:	53                   	push   %ebx
80108ad4:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ada:	25 ff 0f 00 00       	and    $0xfff,%eax
80108adf:	85 c0                	test   %eax,%eax
80108ae1:	74 0c                	je     80108aef <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108ae3:	c7 04 24 b8 96 10 80 	movl   $0x801096b8,(%esp)
80108aea:	e8 4b 7a ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108af6:	e9 a9 00 00 00       	jmp    80108ba4 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afe:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b01:	01 d0                	add    %edx,%eax
80108b03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b0a:	00 
80108b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b12:	89 04 24             	mov    %eax,(%esp)
80108b15:	e8 94 fb ff ff       	call   801086ae <walkpgdir>
80108b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b21:	75 0c                	jne    80108b2f <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108b23:	c7 04 24 db 96 10 80 	movl   $0x801096db,(%esp)
80108b2a:	e8 0b 7a ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b32:	8b 00                	mov    (%eax),%eax
80108b34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3f:	8b 55 18             	mov    0x18(%ebp),%edx
80108b42:	29 c2                	sub    %eax,%edx
80108b44:	89 d0                	mov    %edx,%eax
80108b46:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108b4b:	77 0f                	ja     80108b5c <loaduvm+0x8c>
      n = sz - i;
80108b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b50:	8b 55 18             	mov    0x18(%ebp),%edx
80108b53:	29 c2                	sub    %eax,%edx
80108b55:	89 d0                	mov    %edx,%eax
80108b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b5a:	eb 07                	jmp    80108b63 <loaduvm+0x93>
    else
      n = PGSIZE;
80108b5c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b66:	8b 55 14             	mov    0x14(%ebp),%edx
80108b69:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b6f:	89 04 24             	mov    %eax,(%esp)
80108b72:	e8 b4 f6 ff ff       	call   8010822b <p2v>
80108b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108b7a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108b7e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108b82:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b86:	8b 45 10             	mov    0x10(%ebp),%eax
80108b89:	89 04 24             	mov    %eax,(%esp)
80108b8c:	e8 f9 91 ff ff       	call   80101d8a <readi>
80108b91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108b94:	74 07                	je     80108b9d <loaduvm+0xcd>
      return -1;
80108b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b9b:	eb 18                	jmp    80108bb5 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108b9d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba7:	3b 45 18             	cmp    0x18(%ebp),%eax
80108baa:	0f 82 4b ff ff ff    	jb     80108afb <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bb5:	83 c4 24             	add    $0x24,%esp
80108bb8:	5b                   	pop    %ebx
80108bb9:	5d                   	pop    %ebp
80108bba:	c3                   	ret    

80108bbb <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108bbb:	55                   	push   %ebp
80108bbc:	89 e5                	mov    %esp,%ebp
80108bbe:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108bc1:	8b 45 10             	mov    0x10(%ebp),%eax
80108bc4:	85 c0                	test   %eax,%eax
80108bc6:	79 0a                	jns    80108bd2 <allocuvm+0x17>
    return 0;
80108bc8:	b8 00 00 00 00       	mov    $0x0,%eax
80108bcd:	e9 c1 00 00 00       	jmp    80108c93 <allocuvm+0xd8>
  if(newsz < oldsz)
80108bd2:	8b 45 10             	mov    0x10(%ebp),%eax
80108bd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bd8:	73 08                	jae    80108be2 <allocuvm+0x27>
    return oldsz;
80108bda:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bdd:	e9 b1 00 00 00       	jmp    80108c93 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108be2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108be5:	05 ff 0f 00 00       	add    $0xfff,%eax
80108bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108bf2:	e9 8d 00 00 00       	jmp    80108c84 <allocuvm+0xc9>
    mem = kalloc();
80108bf7:	e8 0b 9f ff ff       	call   80102b07 <kalloc>
80108bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108bff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c03:	75 2c                	jne    80108c31 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108c05:	c7 04 24 f9 96 10 80 	movl   $0x801096f9,(%esp)
80108c0c:	e8 8f 77 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108c11:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c14:	89 44 24 08          	mov    %eax,0x8(%esp)
80108c18:	8b 45 10             	mov    0x10(%ebp),%eax
80108c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80108c22:	89 04 24             	mov    %eax,(%esp)
80108c25:	e8 6b 00 00 00       	call   80108c95 <deallocuvm>
      return 0;
80108c2a:	b8 00 00 00 00       	mov    $0x0,%eax
80108c2f:	eb 62                	jmp    80108c93 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108c31:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c38:	00 
80108c39:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108c40:	00 
80108c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c44:	89 04 24             	mov    %eax,(%esp)
80108c47:	e8 55 ce ff ff       	call   80105aa1 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c4f:	89 04 24             	mov    %eax,(%esp)
80108c52:	e8 c7 f5 ff ff       	call   8010821e <v2p>
80108c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c5a:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108c61:	00 
80108c62:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c66:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c6d:	00 
80108c6e:	89 54 24 04          	mov    %edx,0x4(%esp)
80108c72:	8b 45 08             	mov    0x8(%ebp),%eax
80108c75:	89 04 24             	mov    %eax,(%esp)
80108c78:	e8 d3 fa ff ff       	call   80108750 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108c7d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c87:	3b 45 10             	cmp    0x10(%ebp),%eax
80108c8a:	0f 82 67 ff ff ff    	jb     80108bf7 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108c90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108c93:	c9                   	leave  
80108c94:	c3                   	ret    

80108c95 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108c95:	55                   	push   %ebp
80108c96:	89 e5                	mov    %esp,%ebp
80108c98:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108c9b:	8b 45 10             	mov    0x10(%ebp),%eax
80108c9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ca1:	72 08                	jb     80108cab <deallocuvm+0x16>
    return oldsz;
80108ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ca6:	e9 a4 00 00 00       	jmp    80108d4f <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108cab:	8b 45 10             	mov    0x10(%ebp),%eax
80108cae:	05 ff 0f 00 00       	add    $0xfff,%eax
80108cb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108cbb:	e9 80 00 00 00       	jmp    80108d40 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108cca:	00 
80108ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80108cd2:	89 04 24             	mov    %eax,(%esp)
80108cd5:	e8 d4 f9 ff ff       	call   801086ae <walkpgdir>
80108cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108cdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ce1:	75 09                	jne    80108cec <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108ce3:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108cea:	eb 4d                	jmp    80108d39 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cef:	8b 00                	mov    (%eax),%eax
80108cf1:	83 e0 01             	and    $0x1,%eax
80108cf4:	85 c0                	test   %eax,%eax
80108cf6:	74 41                	je     80108d39 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cfb:	8b 00                	mov    (%eax),%eax
80108cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108d05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108d09:	75 0c                	jne    80108d17 <deallocuvm+0x82>
        panic("kfree");
80108d0b:	c7 04 24 11 97 10 80 	movl   $0x80109711,(%esp)
80108d12:	e8 23 78 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d1a:	89 04 24             	mov    %eax,(%esp)
80108d1d:	e8 09 f5 ff ff       	call   8010822b <p2v>
80108d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d28:	89 04 24             	mov    %eax,(%esp)
80108d2b:	e8 3e 9d ff ff       	call   80102a6e <kfree>
      *pte = 0;
80108d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108d39:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d43:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d46:	0f 82 74 ff ff ff    	jb     80108cc0 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108d4c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108d4f:	c9                   	leave  
80108d50:	c3                   	ret    

80108d51 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108d51:	55                   	push   %ebp
80108d52:	89 e5                	mov    %esp,%ebp
80108d54:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108d5b:	75 0c                	jne    80108d69 <freevm+0x18>
    panic("freevm: no pgdir");
80108d5d:	c7 04 24 17 97 10 80 	movl   $0x80109717,(%esp)
80108d64:	e8 d1 77 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108d69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108d70:	00 
80108d71:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108d78:	80 
80108d79:	8b 45 08             	mov    0x8(%ebp),%eax
80108d7c:	89 04 24             	mov    %eax,(%esp)
80108d7f:	e8 11 ff ff ff       	call   80108c95 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108d84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d8b:	eb 48                	jmp    80108dd5 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108d97:	8b 45 08             	mov    0x8(%ebp),%eax
80108d9a:	01 d0                	add    %edx,%eax
80108d9c:	8b 00                	mov    (%eax),%eax
80108d9e:	83 e0 01             	and    $0x1,%eax
80108da1:	85 c0                	test   %eax,%eax
80108da3:	74 2c                	je     80108dd1 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108daf:	8b 45 08             	mov    0x8(%ebp),%eax
80108db2:	01 d0                	add    %edx,%eax
80108db4:	8b 00                	mov    (%eax),%eax
80108db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108dbb:	89 04 24             	mov    %eax,(%esp)
80108dbe:	e8 68 f4 ff ff       	call   8010822b <p2v>
80108dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dc9:	89 04 24             	mov    %eax,(%esp)
80108dcc:	e8 9d 9c ff ff       	call   80102a6e <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108dd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108dd5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108ddc:	76 af                	jbe    80108d8d <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108dde:	8b 45 08             	mov    0x8(%ebp),%eax
80108de1:	89 04 24             	mov    %eax,(%esp)
80108de4:	e8 85 9c ff ff       	call   80102a6e <kfree>
}
80108de9:	c9                   	leave  
80108dea:	c3                   	ret    

80108deb <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108deb:	55                   	push   %ebp
80108dec:	89 e5                	mov    %esp,%ebp
80108dee:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108df1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108df8:	00 
80108df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e00:	8b 45 08             	mov    0x8(%ebp),%eax
80108e03:	89 04 24             	mov    %eax,(%esp)
80108e06:	e8 a3 f8 ff ff       	call   801086ae <walkpgdir>
80108e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108e12:	75 0c                	jne    80108e20 <clearpteu+0x35>
    panic("clearpteu");
80108e14:	c7 04 24 28 97 10 80 	movl   $0x80109728,(%esp)
80108e1b:	e8 1a 77 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e23:	8b 00                	mov    (%eax),%eax
80108e25:	83 e0 fb             	and    $0xfffffffb,%eax
80108e28:	89 c2                	mov    %eax,%edx
80108e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2d:	89 10                	mov    %edx,(%eax)
}
80108e2f:	c9                   	leave  
80108e30:	c3                   	ret    

80108e31 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108e31:	55                   	push   %ebp
80108e32:	89 e5                	mov    %esp,%ebp
80108e34:	53                   	push   %ebx
80108e35:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108e38:	e8 ab f9 ff ff       	call   801087e8 <setupkvm>
80108e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108e40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108e44:	75 0a                	jne    80108e50 <copyuvm+0x1f>
    return 0;
80108e46:	b8 00 00 00 00       	mov    $0x0,%eax
80108e4b:	e9 fd 00 00 00       	jmp    80108f4d <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108e50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e57:	e9 d0 00 00 00       	jmp    80108f2c <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108e66:	00 
80108e67:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80108e6e:	89 04 24             	mov    %eax,(%esp)
80108e71:	e8 38 f8 ff ff       	call   801086ae <walkpgdir>
80108e76:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108e79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108e7d:	75 0c                	jne    80108e8b <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108e7f:	c7 04 24 32 97 10 80 	movl   $0x80109732,(%esp)
80108e86:	e8 af 76 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e8e:	8b 00                	mov    (%eax),%eax
80108e90:	83 e0 01             	and    $0x1,%eax
80108e93:	85 c0                	test   %eax,%eax
80108e95:	75 0c                	jne    80108ea3 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108e97:	c7 04 24 4c 97 10 80 	movl   $0x8010974c,(%esp)
80108e9e:	e8 97 76 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ea6:	8b 00                	mov    (%eax),%eax
80108ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ead:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eb3:	8b 00                	mov    (%eax),%eax
80108eb5:	25 ff 0f 00 00       	and    $0xfff,%eax
80108eba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108ebd:	e8 45 9c ff ff       	call   80102b07 <kalloc>
80108ec2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ec5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108ec9:	75 02                	jne    80108ecd <copyuvm+0x9c>
      goto bad;
80108ecb:	eb 70                	jmp    80108f3d <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ed0:	89 04 24             	mov    %eax,(%esp)
80108ed3:	e8 53 f3 ff ff       	call   8010822b <p2v>
80108ed8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108edf:	00 
80108ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ee7:	89 04 24             	mov    %eax,(%esp)
80108eea:	e8 81 cc ff ff       	call   80105b70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108eef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ef5:	89 04 24             	mov    %eax,(%esp)
80108ef8:	e8 21 f3 ff ff       	call   8010821e <v2p>
80108efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108f00:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108f04:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108f08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108f0f:	00 
80108f10:	89 54 24 04          	mov    %edx,0x4(%esp)
80108f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f17:	89 04 24             	mov    %eax,(%esp)
80108f1a:	e8 31 f8 ff ff       	call   80108750 <mappages>
80108f1f:	85 c0                	test   %eax,%eax
80108f21:	79 02                	jns    80108f25 <copyuvm+0xf4>
      goto bad;
80108f23:	eb 18                	jmp    80108f3d <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108f25:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108f32:	0f 82 24 ff ff ff    	jb     80108e5c <copyuvm+0x2b>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }

  return d;
80108f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f3b:	eb 10                	jmp    80108f4d <copyuvm+0x11c>

bad:

  freevm(d);
80108f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f40:	89 04 24             	mov    %eax,(%esp)
80108f43:	e8 09 fe ff ff       	call   80108d51 <freevm>
  return 0;
80108f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f4d:	83 c4 44             	add    $0x44,%esp
80108f50:	5b                   	pop    %ebx
80108f51:	5d                   	pop    %ebp
80108f52:	c3                   	ret    

80108f53 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108f53:	55                   	push   %ebp
80108f54:	89 e5                	mov    %esp,%ebp
80108f56:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108f59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108f60:	00 
80108f61:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f64:	89 44 24 04          	mov    %eax,0x4(%esp)
80108f68:	8b 45 08             	mov    0x8(%ebp),%eax
80108f6b:	89 04 24             	mov    %eax,(%esp)
80108f6e:	e8 3b f7 ff ff       	call   801086ae <walkpgdir>
80108f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f79:	8b 00                	mov    (%eax),%eax
80108f7b:	83 e0 01             	and    $0x1,%eax
80108f7e:	85 c0                	test   %eax,%eax
80108f80:	75 07                	jne    80108f89 <uva2ka+0x36>
    return 0;
80108f82:	b8 00 00 00 00       	mov    $0x0,%eax
80108f87:	eb 25                	jmp    80108fae <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f8c:	8b 00                	mov    (%eax),%eax
80108f8e:	83 e0 04             	and    $0x4,%eax
80108f91:	85 c0                	test   %eax,%eax
80108f93:	75 07                	jne    80108f9c <uva2ka+0x49>
    return 0;
80108f95:	b8 00 00 00 00       	mov    $0x0,%eax
80108f9a:	eb 12                	jmp    80108fae <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9f:	8b 00                	mov    (%eax),%eax
80108fa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fa6:	89 04 24             	mov    %eax,(%esp)
80108fa9:	e8 7d f2 ff ff       	call   8010822b <p2v>
}
80108fae:	c9                   	leave  
80108faf:	c3                   	ret    

80108fb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108fb0:	55                   	push   %ebp
80108fb1:	89 e5                	mov    %esp,%ebp
80108fb3:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108fb6:	8b 45 10             	mov    0x10(%ebp),%eax
80108fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108fbc:	e9 87 00 00 00       	jmp    80109048 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80108fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80108fd6:	89 04 24             	mov    %eax,(%esp)
80108fd9:	e8 75 ff ff ff       	call   80108f53 <uva2ka>
80108fde:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108fe1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108fe5:	75 07                	jne    80108fee <copyout+0x3e>
      return -1;
80108fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108fec:	eb 69                	jmp    80109057 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ff1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108ff4:	29 c2                	sub    %eax,%edx
80108ff6:	89 d0                	mov    %edx,%eax
80108ff8:	05 00 10 00 00       	add    $0x1000,%eax
80108ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109003:	3b 45 14             	cmp    0x14(%ebp),%eax
80109006:	76 06                	jbe    8010900e <copyout+0x5e>
      n = len;
80109008:	8b 45 14             	mov    0x14(%ebp),%eax
8010900b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010900e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109011:	8b 55 0c             	mov    0xc(%ebp),%edx
80109014:	29 c2                	sub    %eax,%edx
80109016:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109019:	01 c2                	add    %eax,%edx
8010901b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010901e:	89 44 24 08          	mov    %eax,0x8(%esp)
80109022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109025:	89 44 24 04          	mov    %eax,0x4(%esp)
80109029:	89 14 24             	mov    %edx,(%esp)
8010902c:	e8 3f cb ff ff       	call   80105b70 <memmove>
    len -= n;
80109031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109034:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010903a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010903d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109040:	05 00 10 00 00       	add    $0x1000,%eax
80109045:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109048:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010904c:	0f 85 6f ff ff ff    	jne    80108fc1 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109052:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109057:	c9                   	leave  
80109058:	c3                   	ret    
