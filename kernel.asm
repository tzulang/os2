
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
8010003a:	c7 44 24 04 7c 90 10 	movl   $0x8010907c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 01 58 00 00       	call   8010584f <initlock>

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
801000bd:	e8 ae 57 00 00       	call   80105870 <acquire>

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
80100104:	e8 c9 57 00 00       	call   801058d2 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 f7 4c 00 00       	call   80104e1b <sleep>
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
8010017c:	e8 51 57 00 00       	call   801058d2 <release>
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
80100198:	c7 04 24 83 90 10 80 	movl   $0x80109083,(%esp)
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
801001ef:	c7 04 24 94 90 10 80 	movl   $0x80109094,(%esp)
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
80100229:	c7 04 24 9b 90 10 80 	movl   $0x8010909b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 2f 56 00 00       	call   80105870 <acquire>

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
8010029d:	e8 71 4c 00 00       	call   80104f13 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 24 56 00 00       	call   801058d2 <release>
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
801003bb:	e8 b0 54 00 00       	call   80105870 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 a2 90 10 80 	movl   $0x801090a2,(%esp)
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
801004b0:	c7 45 ec ab 90 10 80 	movl   $0x801090ab,-0x14(%ebp)
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
80100533:	e8 9a 53 00 00       	call   801058d2 <release>
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
8010055f:	c7 04 24 b2 90 10 80 	movl   $0x801090b2,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 c1 90 10 80 	movl   $0x801090c1,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 8d 53 00 00       	call   80105921 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 c3 90 10 80 	movl   $0x801090c3,(%esp)
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
801006b2:	e8 dc 54 00 00       	call   80105b93 <memmove>
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
801006e1:	e8 de 53 00 00       	call   80105ac4 <memset>
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
80100776:	e8 3f 6f 00 00       	call   801076ba <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 33 6f 00 00       	call   801076ba <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 27 6f 00 00       	call   801076ba <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 1a 6f 00 00       	call   801076ba <uartputc>
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
801007ba:	e8 b1 50 00 00       	call   80105870 <acquire>
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
801007ea:	e8 e6 47 00 00       	call   80104fd5 <procdump>
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
801008f3:	e8 1b 46 00 00       	call   80104f13 <wakeup>
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
80100914:	e8 b9 4f 00 00       	call   801058d2 <release>
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
80100939:	e8 32 4f 00 00       	call   80105870 <acquire>
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
8010095c:	e8 71 4f 00 00       	call   801058d2 <release>
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
80100985:	e8 91 44 00 00       	call   80104e1b <sleep>

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
80100a01:	e8 cc 4e 00 00       	call   801058d2 <release>
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
80100a35:	e8 36 4e 00 00       	call   80105870 <acquire>
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
80100a6f:	e8 5e 4e 00 00       	call   801058d2 <release>
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
80100a8a:	c7 44 24 04 c7 90 10 	movl   $0x801090c7,0x4(%esp)
80100a91:	80 
80100a92:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a99:	e8 b1 4d 00 00       	call   8010584f <initlock>
  initlock(&input.lock, "input");
80100a9e:	c7 44 24 04 cf 90 10 	movl   $0x801090cf,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100aad:	e8 9d 4d 00 00       	call   8010584f <initlock>

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
80100b76:	e8 90 7c 00 00       	call   8010880b <setupkvm>
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
80100c17:	e8 c2 7f 00 00       	call   80108bde <allocuvm>
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
80100c55:	e8 99 7e 00 00       	call   80108af3 <loaduvm>
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
80100cc3:	e8 16 7f 00 00       	call   80108bde <allocuvm>
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
80100ce8:	e8 21 81 00 00       	call   80108e0e <clearpteu>
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
80100d1e:	e8 0b 50 00 00       	call   80105d2e <strlen>
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
80100d47:	e8 e2 4f 00 00       	call   80105d2e <strlen>
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
80100d77:	e8 57 82 00 00       	call   80108fd3 <copyout>
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
80100e1e:	e8 b0 81 00 00       	call   80108fd3 <copyout>
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
80100e79:	e8 66 4e 00 00       	call   80105ce4 <safestrcpy>

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
80100ee7:	e8 10 7a 00 00       	call   801088fc <switchuvm>

  freevm(oldpgdir);
80100eec:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eef:	89 04 24             	mov    %eax,(%esp)
80100ef2:	e8 7d 7e 00 00       	call   80108d74 <freevm>
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
80100f0a:	e8 65 7e 00 00       	call   80108d74 <freevm>
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
80100f32:	c7 44 24 04 d5 90 10 	movl   $0x801090d5,0x4(%esp)
80100f39:	80 
80100f3a:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f41:	e8 09 49 00 00       	call   8010584f <initlock>
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
80100f55:	e8 16 49 00 00       	call   80105870 <acquire>
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
80100f7e:	e8 4f 49 00 00       	call   801058d2 <release>
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
80100f9c:	e8 31 49 00 00       	call   801058d2 <release>
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
80100fb5:	e8 b6 48 00 00       	call   80105870 <acquire>
  if(f->ref < 1)
80100fba:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbd:	8b 40 04             	mov    0x4(%eax),%eax
80100fc0:	85 c0                	test   %eax,%eax
80100fc2:	7f 0c                	jg     80100fd0 <filedup+0x28>
    panic("filedup");
80100fc4:	c7 04 24 dc 90 10 80 	movl   $0x801090dc,(%esp)
80100fcb:	e8 6a f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd3:	8b 40 04             	mov    0x4(%eax),%eax
80100fd6:	8d 50 01             	lea    0x1(%eax),%edx
80100fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fdf:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fe6:	e8 e7 48 00 00       	call   801058d2 <release>
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
80100ffd:	e8 6e 48 00 00       	call   80105870 <acquire>
  if(f->ref < 1)
80101002:	8b 45 08             	mov    0x8(%ebp),%eax
80101005:	8b 40 04             	mov    0x4(%eax),%eax
80101008:	85 c0                	test   %eax,%eax
8010100a:	7f 0c                	jg     80101018 <fileclose+0x28>
    panic("fileclose");
8010100c:	c7 04 24 e4 90 10 80 	movl   $0x801090e4,(%esp)
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
80101038:	e8 95 48 00 00       	call   801058d2 <release>
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
80101082:	e8 4b 48 00 00       	call   801058d2 <release>
  
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
801011c3:	c7 04 24 ee 90 10 80 	movl   $0x801090ee,(%esp)
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
801012cf:	c7 04 24 f7 90 10 80 	movl   $0x801090f7,(%esp)
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
80101301:	c7 04 24 07 91 10 80 	movl   $0x80109107,(%esp)
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
80101347:	e8 47 48 00 00       	call   80105b93 <memmove>
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
8010138d:	e8 32 47 00 00       	call   80105ac4 <memset>
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
801014ea:	c7 04 24 11 91 10 80 	movl   $0x80109111,(%esp)
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
8010157c:	c7 04 24 27 91 10 80 	movl   $0x80109127,(%esp)
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
801015cc:	c7 44 24 04 3a 91 10 	movl   $0x8010913a,0x4(%esp)
801015d3:	80 
801015d4:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015db:	e8 6f 42 00 00       	call   8010584f <initlock>
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
8010165d:	e8 62 44 00 00       	call   80105ac4 <memset>
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
801016b3:	c7 04 24 41 91 10 80 	movl   $0x80109141,(%esp)
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
8010175c:	e8 32 44 00 00       	call   80105b93 <memmove>
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
80101786:	e8 e5 40 00 00       	call   80105870 <acquire>

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
801017d0:	e8 fd 40 00 00       	call   801058d2 <release>
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
80101803:	c7 04 24 53 91 10 80 	movl   $0x80109153,(%esp)
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
80101841:	e8 8c 40 00 00       	call   801058d2 <release>

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
80101858:	e8 13 40 00 00       	call   80105870 <acquire>
  ip->ref++;
8010185d:	8b 45 08             	mov    0x8(%ebp),%eax
80101860:	8b 40 08             	mov    0x8(%eax),%eax
80101863:	8d 50 01             	lea    0x1(%eax),%edx
80101866:	8b 45 08             	mov    0x8(%ebp),%eax
80101869:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010186c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101873:	e8 5a 40 00 00       	call   801058d2 <release>
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
80101893:	c7 04 24 63 91 10 80 	movl   $0x80109163,(%esp)
8010189a:	e8 9b ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010189f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018a6:	e8 c5 3f 00 00       	call   80105870 <acquire>
  while(ip->flags & I_BUSY)
801018ab:	eb 13                	jmp    801018c0 <ilock+0x43>
    sleep(ip, &icache.lock);
801018ad:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018b4:	80 
801018b5:	8b 45 08             	mov    0x8(%ebp),%eax
801018b8:	89 04 24             	mov    %eax,(%esp)
801018bb:	e8 5b 35 00 00       	call   80104e1b <sleep>

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
801018e5:	e8 e8 3f 00 00       	call   801058d2 <release>

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
80101990:	e8 fe 41 00 00       	call   80105b93 <memmove>
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
801019bd:	c7 04 24 69 91 10 80 	movl   $0x80109169,(%esp)
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
801019ee:	c7 04 24 78 91 10 80 	movl   $0x80109178,(%esp)
801019f5:	e8 40 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019fa:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a01:	e8 6a 3e 00 00       	call   80105870 <acquire>
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
80101a1d:	e8 f1 34 00 00       	call   80104f13 <wakeup>
  release(&icache.lock);
80101a22:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a29:	e8 a4 3e 00 00       	call   801058d2 <release>
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
80101a3d:	e8 2e 3e 00 00       	call   80105870 <acquire>
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
80101a7b:	c7 04 24 80 91 10 80 	movl   $0x80109180,(%esp)
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
80101a9f:	e8 2e 3e 00 00       	call   801058d2 <release>
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
80101aca:	e8 a1 3d 00 00       	call   80105870 <acquire>
    ip->flags = 0;
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	89 04 24             	mov    %eax,(%esp)
80101adf:	e8 2f 34 00 00       	call   80104f13 <wakeup>
  }
  ip->ref--;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 08             	mov    0x8(%eax),%eax
80101aea:	8d 50 ff             	lea    -0x1(%eax),%edx
80101aed:	8b 45 08             	mov    0x8(%ebp),%eax
80101af0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101afa:	e8 d3 3d 00 00       	call   801058d2 <release>
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
80101c1a:	c7 04 24 8a 91 10 80 	movl   $0x8010918a,(%esp)
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
80101ebb:	e8 d3 3c 00 00       	call   80105b93 <memmove>
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
8010201a:	e8 74 3b 00 00       	call   80105b93 <memmove>
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
80102098:	e8 99 3b 00 00       	call   80105c36 <strncmp>
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
801020b2:	c7 04 24 9d 91 10 80 	movl   $0x8010919d,(%esp)
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
801020f0:	c7 04 24 af 91 10 80 	movl   $0x801091af,(%esp)
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
801021d5:	c7 04 24 af 91 10 80 	movl   $0x801091af,(%esp)
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
8010221a:	e8 6d 3a 00 00       	call   80105c8c <strncpy>
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
8010224c:	c7 04 24 bc 91 10 80 	movl   $0x801091bc,(%esp)
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
801022d1:	e8 bd 38 00 00       	call   80105b93 <memmove>
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
801022ec:	e8 a2 38 00 00       	call   80105b93 <memmove>
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
8010253e:	c7 44 24 04 c4 91 10 	movl   $0x801091c4,0x4(%esp)
80102545:	80 
80102546:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010254d:	e8 fd 32 00 00       	call   8010584f <initlock>
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
801025ea:	c7 04 24 c8 91 10 80 	movl   $0x801091c8,(%esp)
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
80102710:	e8 5b 31 00 00       	call   80105870 <acquire>
  if((b = idequeue) == 0){
80102715:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010271d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102721:	75 11                	jne    80102734 <ideintr+0x31>
    release(&idelock);
80102723:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010272a:	e8 a3 31 00 00       	call   801058d2 <release>
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
8010279d:	e8 71 27 00 00       	call   80104f13 <wakeup>
  
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
801027bf:	e8 0e 31 00 00       	call   801058d2 <release>
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
801027d8:	c7 04 24 d1 91 10 80 	movl   $0x801091d1,(%esp)
801027df:	e8 56 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027e4:	8b 45 08             	mov    0x8(%ebp),%eax
801027e7:	8b 00                	mov    (%eax),%eax
801027e9:	83 e0 06             	and    $0x6,%eax
801027ec:	83 f8 02             	cmp    $0x2,%eax
801027ef:	75 0c                	jne    801027fd <iderw+0x37>
    panic("iderw: nothing to do");
801027f1:	c7 04 24 e5 91 10 80 	movl   $0x801091e5,(%esp)
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
80102810:	c7 04 24 fa 91 10 80 	movl   $0x801091fa,(%esp)
80102817:	e8 1e dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010281c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102823:	e8 48 30 00 00       	call   80105870 <acquire>

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
8010287e:	e8 98 25 00 00       	call   80104e1b <sleep>
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
80102897:	e8 36 30 00 00       	call   801058d2 <release>
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
80102925:	c7 04 24 18 92 10 80 	movl   $0x80109218,(%esp)
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
801029df:	c7 44 24 04 4a 92 10 	movl   $0x8010924a,0x4(%esp)
801029e6:	80 
801029e7:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801029ee:	e8 5c 2e 00 00       	call   8010584f <initlock>
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
80102a9b:	c7 04 24 4f 92 10 80 	movl   $0x8010924f,(%esp)
80102aa2:	e8 93 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102aa7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aae:	00 
80102aaf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ab6:	00 
80102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aba:	89 04 24             	mov    %eax,(%esp)
80102abd:	e8 02 30 00 00       	call   80105ac4 <memset>

  if(kmem.use_lock)
80102ac2:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	74 0c                	je     80102ad7 <kfree+0x69>
    acquire(&kmem.lock);
80102acb:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102ad2:	e8 99 2d 00 00       	call   80105870 <acquire>
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
80102b00:	e8 cd 2d 00 00       	call   801058d2 <release>
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
80102b1d:	e8 4e 2d 00 00       	call   80105870 <acquire>
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
80102b4a:	e8 83 2d 00 00       	call   801058d2 <release>
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
80102eca:	c7 04 24 58 92 10 80 	movl   $0x80109258,(%esp)
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
8010312d:	e8 09 2a 00 00       	call   80105b3b <memcmp>
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
8010322d:	c7 44 24 04 84 92 10 	movl   $0x80109284,0x4(%esp)
80103234:	80 
80103235:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010323c:	e8 0e 26 00 00       	call   8010584f <initlock>
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
801032f0:	e8 9e 28 00 00       	call   80105b93 <memmove>
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
80103442:	e8 29 24 00 00       	call   80105870 <acquire>
  while(1){
    if(log.committing){
80103447:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010344c:	85 c0                	test   %eax,%eax
8010344e:	74 16                	je     80103466 <begin_op+0x31>
      sleep(&log, &log.lock);
80103450:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103457:	80 
80103458:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010345f:	e8 b7 19 00 00       	call   80104e1b <sleep>
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
80103493:	e8 83 19 00 00       	call   80104e1b <sleep>
80103498:	eb 1b                	jmp    801034b5 <begin_op+0x80>
    } else {
      log.outstanding += 1;
8010349a:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010349f:	83 c0 01             	add    $0x1,%eax
801034a2:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
801034a7:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034ae:	e8 1f 24 00 00       	call   801058d2 <release>
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
801034cd:	e8 9e 23 00 00       	call   80105870 <acquire>
  log.outstanding -= 1;
801034d2:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034d7:	83 e8 01             	sub    $0x1,%eax
801034da:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801034df:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034e4:	85 c0                	test   %eax,%eax
801034e6:	74 0c                	je     801034f4 <end_op+0x3b>
    panic("log.committing");
801034e8:	c7 04 24 88 92 10 80 	movl   $0x80109288,(%esp)
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
80103517:	e8 f7 19 00 00       	call   80104f13 <wakeup>
  }
  release(&log.lock);
8010351c:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103523:	e8 aa 23 00 00       	call   801058d2 <release>

  if(do_commit){
80103528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010352c:	74 33                	je     80103561 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010352e:	e8 de 00 00 00       	call   80103611 <commit>
    acquire(&log.lock);
80103533:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010353a:	e8 31 23 00 00       	call   80105870 <acquire>
    log.committing = 0;
8010353f:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103546:	00 00 00 
    wakeup(&log);
80103549:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103550:	e8 be 19 00 00       	call   80104f13 <wakeup>
    release(&log.lock);
80103555:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010355c:	e8 71 23 00 00       	call   801058d2 <release>
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
801035d7:	e8 b7 25 00 00       	call   80105b93 <memmove>
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
80103662:	c7 04 24 97 92 10 80 	movl   $0x80109297,(%esp)
80103669:	e8 cc ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010366e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103673:	85 c0                	test   %eax,%eax
80103675:	7f 0c                	jg     80103683 <log_write+0x43>
    panic("log_write outside of trans");
80103677:	c7 04 24 ad 92 10 80 	movl   $0x801092ad,(%esp)
8010367e:	e8 b7 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103683:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010368a:	e8 e1 21 00 00       	call   80105870 <acquire>
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
80103701:	e8 cc 21 00 00       	call   801058d2 <release>
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
80103759:	e8 6a 51 00 00       	call   801088c8 <kvmalloc>
  mpinit();        // collect info about this machine
8010375e:	e8 46 04 00 00       	call   80103ba9 <mpinit>
  lapicinit();
80103763:	e8 dc f5 ff ff       	call   80102d44 <lapicinit>
  seginit();       // set up segments
80103768:	e8 ee 4a 00 00       	call   8010825b <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010376d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103773:	0f b6 00             	movzbl (%eax),%eax
80103776:	0f b6 c0             	movzbl %al,%eax
80103779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010377d:	c7 04 24 c8 92 10 80 	movl   $0x801092c8,(%esp)
80103784:	e8 17 cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103789:	e8 79 06 00 00       	call   80103e07 <picinit>
  ioapicinit();    // another interrupt controller
8010378e:	e8 3c f1 ff ff       	call   801028cf <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103793:	e8 ec d2 ff ff       	call   80100a84 <consoleinit>
  uartinit();      // serial port
80103798:	e8 0d 3e 00 00       	call   801075aa <uartinit>
  pinit();         // process table
8010379d:	e8 75 0b 00 00       	call   80104317 <pinit>
  tvinit();        // trap vectors
801037a2:	e8 5f 39 00 00       	call   80107106 <tvinit>
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
801037c4:	e8 88 38 00 00       	call   80107051 <timerinit>
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
801037f2:	e8 e8 50 00 00       	call   801088df <switchkvm>
  seginit();
801037f7:	e8 5f 4a 00 00       	call   8010825b <seginit>
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
8010381c:	c7 04 24 df 92 10 80 	movl   $0x801092df,(%esp)
80103823:	e8 78 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103828:	e8 4d 3a 00 00       	call   8010727a <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010382d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103833:	05 a8 00 00 00       	add    $0xa8,%eax
80103838:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010383f:	00 
80103840:	89 04 24             	mov    %eax,(%esp)
80103843:	e8 da fe ff ff       	call   80103722 <xchg>
  scheduler();     // start running processes
80103848:	e8 e3 13 00 00       	call   80104c30 <scheduler>

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
8010387a:	e8 14 23 00 00       	call   80105b93 <memmove>

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
801039fc:	c7 44 24 04 f0 92 10 	movl   $0x801092f0,0x4(%esp)
80103a03:	80 
80103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a07:	89 04 24             	mov    %eax,(%esp)
80103a0a:	e8 2c 21 00 00       	call   80105b3b <memcmp>
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
80103b3d:	c7 44 24 04 f5 92 10 	movl   $0x801092f5,0x4(%esp)
80103b44:	80 
80103b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b48:	89 04 24             	mov    %eax,(%esp)
80103b4b:	e8 eb 1f 00 00       	call   80105b3b <memcmp>
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
80103c19:	8b 04 85 38 93 10 80 	mov    -0x7fef6cc8(,%eax,4),%eax
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
80103c52:	c7 04 24 fa 92 10 80 	movl   $0x801092fa,(%esp)
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
80103ce5:	c7 04 24 18 93 10 80 	movl   $0x80109318,(%esp)
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
80103fde:	c7 44 24 04 4c 93 10 	movl   $0x8010934c,0x4(%esp)
80103fe5:	80 
80103fe6:	89 04 24             	mov    %eax,(%esp)
80103fe9:	e8 61 18 00 00       	call   8010584f <initlock>
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
80104095:	e8 d6 17 00 00       	call   80105870 <acquire>
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
801040b8:	e8 56 0e 00 00       	call   80104f13 <wakeup>
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
801040d7:	e8 37 0e 00 00       	call   80104f13 <wakeup>
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
801040fc:	e8 d1 17 00 00       	call   801058d2 <release>
    kfree((char*)p);
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	89 04 24             	mov    %eax,(%esp)
80104107:	e8 62 e9 ff ff       	call   80102a6e <kfree>
8010410c:	eb 0b                	jmp    80104119 <pipeclose+0x90>
  } else
    release(&p->lock);
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 04 24             	mov    %eax,(%esp)
80104114:	e8 b9 17 00 00       	call   801058d2 <release>
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
80104127:	e8 44 17 00 00       	call   80105870 <acquire>
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
8010415d:	e8 70 17 00 00       	call   801058d2 <release>
        return -1;
80104162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104167:	e9 9f 00 00 00       	jmp    8010420b <pipewrite+0xf0>
      }
      wakeup(&p->nread);
8010416c:	8b 45 08             	mov    0x8(%ebp),%eax
8010416f:	05 34 02 00 00       	add    $0x234,%eax
80104174:	89 04 24             	mov    %eax,(%esp)
80104177:	e8 97 0d 00 00       	call   80104f13 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010417c:	8b 45 08             	mov    0x8(%ebp),%eax
8010417f:	8b 55 08             	mov    0x8(%ebp),%edx
80104182:	81 c2 38 02 00 00    	add    $0x238,%edx
80104188:	89 44 24 04          	mov    %eax,0x4(%esp)
8010418c:	89 14 24             	mov    %edx,(%esp)
8010418f:	e8 87 0c 00 00       	call   80104e1b <sleep>
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
801041f8:	e8 16 0d 00 00       	call   80104f13 <wakeup>
  release(&p->lock);
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	89 04 24             	mov    %eax,(%esp)
80104203:	e8 ca 16 00 00       	call   801058d2 <release>
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
8010421a:	e8 51 16 00 00       	call   80105870 <acquire>
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
80104237:	e8 96 16 00 00       	call   801058d2 <release>
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
80104259:	e8 bd 0b 00 00       	call   80104e1b <sleep>
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
801042e8:	e8 26 0c 00 00       	call   80104f13 <wakeup>
  release(&p->lock);
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	89 04 24             	mov    %eax,(%esp)
801042f3:	e8 da 15 00 00       	call   801058d2 <release>
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



void
pinit(void)
{
80104317:	55                   	push   %ebp
80104318:	89 e5                	mov    %esp,%ebp
8010431a:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010431d:	c7 44 24 04 54 93 10 	movl   $0x80109354,0x4(%esp)
80104324:	80 
80104325:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010432c:	e8 1e 15 00 00       	call   8010584f <initlock>


}
80104331:	c9                   	leave  
80104332:	c3                   	ret    

80104333 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104333:	55                   	push   %ebp
80104334:	89 e5                	mov    %esp,%ebp
80104336:	83 ec 28             	sub    $0x28,%esp
  struct thread *threads;
  char *sp;



  acquire(&ptable.lock);
80104339:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104340:	e8 2b 15 00 00       	call   80105870 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104345:	c7 45 f4 b4 5c 11 80 	movl   $0x80115cb4,-0xc(%ebp)
8010434c:	e9 8e 00 00 00       	jmp    801043df <allocproc+0xac>
     if(p->state == UNUSED)
80104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104354:	8b 40 08             	mov    0x8(%eax),%eax
80104357:	85 c0                	test   %eax,%eax
80104359:	75 7d                	jne    801043d8 <allocproc+0xa5>
      goto found;
8010435b:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
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

  threads->state=EMBRYO;
8010437c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010437f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  threads->proc=p;
80104386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104389:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438c:	89 50 0c             	mov    %edx,0xc(%eax)

  p->pid = nextpid++;
8010438f:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104394:	8d 50 01             	lea    0x1(%eax),%edx
80104397:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010439d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a0:	89 42 0c             	mov    %eax,0xc(%edx)
  threads->pid =nextpid++;
801043a3:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801043a8:	8d 50 01             	lea    0x1(%eax),%edx
801043ab:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801043b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043b4:	89 42 08             	mov    %eax,0x8(%edx)

  release(&ptable.lock);
801043b7:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801043be:	e8 0f 15 00 00       	call   801058d2 <release>

  // Allocate kernel stack.
  if((threads->kstack = kalloc()) == 0){
801043c3:	e8 3f e7 ff ff       	call   80102b07 <kalloc>
801043c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043cb:	89 02                	mov    %eax,(%edx)
801043cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043d0:	8b 00                	mov    (%eax),%eax
801043d2:	85 c0                	test   %eax,%eax
801043d4:	75 44                	jne    8010441a <allocproc+0xe7>
801043d6:	eb 27                	jmp    801043ff <allocproc+0xcc>
  char *sp;



  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d8:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
801043df:	81 7d f4 b4 e9 11 80 	cmpl   $0x8011e9b4,-0xc(%ebp)
801043e6:	0f 82 65 ff ff ff    	jb     80104351 <allocproc+0x1e>
     if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801043ec:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801043f3:	e8 da 14 00 00       	call   801058d2 <release>
  return 0;
801043f8:	b8 00 00 00 00       	mov    $0x0,%eax
801043fd:	eb 7f                	jmp    8010447e <allocproc+0x14b>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((threads->kstack = kalloc()) == 0){
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
  threads->tf = (struct trapframe*)sp;
8010442b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104431:	89 50 10             	mov    %edx,0x10(%eax)


  // which returns to trapret.
  // Set up new context to start executing at forkret,

  sp -= 4;
80104434:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80104438:	ba c1 70 10 80       	mov    $0x801070c1,%edx
8010443d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104440:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *threads->context;
80104442:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  threads->context = (struct context*)sp;
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
80104468:	e8 57 16 00 00       	call   80105ac4 <memset>
  threads->context->eip = (uint)forkret;
8010446d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104470:	8b 40 14             	mov    0x14(%eax),%eax
80104473:	ba ef 4d 10 80       	mov    $0x80104def,%edx
80104478:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010447e:	c9                   	leave  
8010447f:	c3                   	ret    

80104480 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	83 ec 28             	sub    $0x28,%esp

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  struct kthread_mutex_t *m;
  
  for (	 m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80104486:	c7 45 f4 80 39 11 80 	movl   $0x80113980,-0xc(%ebp)
8010448d:	eb 0d                	jmp    8010449c <userinit+0x1c>
	  m->state=UNUSED_MUTEX;
8010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  struct kthread_mutex_t *m;
  
  for (	 m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80104498:	83 45 f4 58          	addl   $0x58,-0xc(%ebp)
8010449c:	81 7d f4 80 4f 11 80 	cmpl   $0x80114f80,-0xc(%ebp)
801044a3:	72 ea                	jb     8010448f <userinit+0xf>
	  m->state=UNUSED_MUTEX;

  }
  p = allocproc();
801044a5:	e8 89 fe ff ff       	call   80104333 <allocproc>
801044aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  initproc = p;
801044ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044b0:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
801044b5:	e8 51 43 00 00       	call   8010880b <setupkvm>
801044ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044bd:	89 42 04             	mov    %eax,0x4(%edx)
801044c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044c3:	8b 40 04             	mov    0x4(%eax),%eax
801044c6:	85 c0                	test   %eax,%eax
801044c8:	75 0c                	jne    801044d6 <userinit+0x56>
    panic("userinit: out of memory?");
801044ca:	c7 04 24 5b 93 10 80 	movl   $0x8010935b,(%esp)
801044d1:	e8 64 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044d6:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044de:	8b 40 04             	mov    0x4(%eax),%eax
801044e1:	89 54 24 08          	mov    %edx,0x8(%esp)
801044e5:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801044ec:	80 
801044ed:	89 04 24             	mov    %eax,(%esp)
801044f0:	e8 73 45 00 00       	call   80108a68 <inituvm>
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
8010451a:	e8 a5 15 00 00       	call   80105ac4 <memset>
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
801045af:	c7 44 24 04 74 93 10 	movl   $0x80109374,0x4(%esp)
801045b6:	80 
801045b7:	89 04 24             	mov    %eax,(%esp)
801045ba:	e8 25 17 00 00       	call   80105ce4 <safestrcpy>
  p->cwd = namei("/");
801045bf:	c7 04 24 7d 93 10 80 	movl   $0x8010937d,(%esp)
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
int
growproc(int n)
{
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *proc= thread->proc;
801045fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104600:	8b 40 0c             	mov    0xc(%eax),%eax
80104603:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sz = proc->sz;
80104606:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104609:	8b 00                	mov    (%eax),%eax
8010460b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010460e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104612:	7e 31                	jle    80104645 <growproc+0x51>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104614:	8b 55 08             	mov    0x8(%ebp),%edx
80104617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461a:	01 c2                	add    %eax,%edx
8010461c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010461f:	8b 40 04             	mov    0x4(%eax),%eax
80104622:	89 54 24 08          	mov    %edx,0x8(%esp)
80104626:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104629:	89 54 24 04          	mov    %edx,0x4(%esp)
8010462d:	89 04 24             	mov    %eax,(%esp)
80104630:	e8 a9 45 00 00       	call   80108bde <allocuvm>
80104635:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010463c:	75 3e                	jne    8010467c <growproc+0x88>
      return -1;
8010463e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104643:	eb 52                	jmp    80104697 <growproc+0xa3>
  } else if(n < 0){
80104645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104649:	79 31                	jns    8010467c <growproc+0x88>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010464b:	8b 55 08             	mov    0x8(%ebp),%edx
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	01 c2                	add    %eax,%edx
80104653:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104656:	8b 40 04             	mov    0x4(%eax),%eax
80104659:	89 54 24 08          	mov    %edx,0x8(%esp)
8010465d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104660:	89 54 24 04          	mov    %edx,0x4(%esp)
80104664:	89 04 24             	mov    %eax,(%esp)
80104667:	e8 4c 46 00 00       	call   80108cb8 <deallocuvm>
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
8010468d:	e8 6a 42 00 00       	call   801088fc <switchuvm>
  return 0;
80104692:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104697:	c9                   	leave  
80104698:	c3                   	ret    

80104699 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104699:	55                   	push   %ebp
8010469a:	89 e5                	mov    %esp,%ebp
8010469c:	57                   	push   %edi
8010469d:	56                   	push   %esi
8010469e:	53                   	push   %ebx
8010469f:	83 ec 3c             	sub    $0x3c,%esp
  int i, pid;
  struct proc *np;
  struct proc *proc=thread->proc;
801046a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a8:	8b 40 0c             	mov    0xc(%eax),%eax
801046ab:	89 45 e0             	mov    %eax,-0x20(%ebp)




  // Allocate process.
  if((np = allocproc()) == 0)
801046ae:	e8 80 fc ff ff       	call   80104333 <allocproc>
801046b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801046b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801046ba:	75 0a                	jne    801046c6 <fork+0x2d>
    return -1;
801046bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c1:	e9 97 01 00 00       	jmp    8010485d <fork+0x1c4>

  nt= np->threads;
801046c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046c9:	83 c0 70             	add    $0x70,%eax
801046cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Copy process state from p.

  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d2:	8b 10                	mov    (%eax),%edx
801046d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046d7:	8b 40 04             	mov    0x4(%eax),%eax
801046da:	89 54 24 04          	mov    %edx,0x4(%esp)
801046de:	89 04 24             	mov    %eax,(%esp)
801046e1:	e8 6e 47 00 00       	call   80108e54 <copyuvm>
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
80104725:	e9 33 01 00 00       	jmp    8010485d <fork+0x1c4>
  }

  np->sz = proc->sz;
8010472a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472d:	8b 10                	mov    (%eax),%edx
8010472f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104732:	89 10                	mov    %edx,(%eax)
  nt->proc= np;
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

  for(i = 0; i < NOFILE; i++)
80104771:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104778:	eb 37                	jmp    801047b1 <fork+0x118>
    if(proc->ofile[i])
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

  for(i = 0; i < NOFILE; i++)
801047ad:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047b1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047b5:	7e c3                	jle    8010477a <fork+0xe1>
    if(proc->ofile[i])
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
801047e6:	e8 f9 14 00 00       	call   80105ce4 <safestrcpy>
 
  pid = np->pid;
801047eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047ee:	8b 40 0c             	mov    0xc(%eax),%eax
801047f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  nt->pid= nextpid++;
801047f4:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801047f9:	8d 50 01             	lea    0x1(%eax),%edx
801047fc:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104802:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104805:	89 42 08             	mov    %eax,0x8(%edx)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104808:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010480f:	e8 5c 10 00 00       	call   80105870 <acquire>
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
80104835:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010483c:	e8 91 10 00 00       	call   801058d2 <release>
  cprintf ("num o tred : %d \n", proc->numOfThreads);
80104841:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104844:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
8010484a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010484e:	c7 04 24 7f 93 10 80 	movl   $0x8010937f,(%esp)
80104855:	e8 46 bb ff ff       	call   801003a0 <cprintf>
  return pid;
8010485a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
8010485d:	83 c4 3c             	add    $0x3c,%esp
80104860:	5b                   	pop    %ebx
80104861:	5e                   	pop    %esi
80104862:	5f                   	pop    %edi
80104863:	5d                   	pop    %ebp
80104864:	c3                   	ret    

80104865 <increaseNumOfThreadsAlive>:


void
increaseNumOfThreadsAlive(void){
80104865:	55                   	push   %ebp
80104866:	89 e5                	mov    %esp,%ebp
80104868:	83 ec 28             	sub    $0x28,%esp
	int i = thread->proc->numOfThreads++;
8010486b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104871:	8b 50 0c             	mov    0xc(%eax),%edx
80104874:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
8010487a:	8d 48 01             	lea    0x1(%eax),%ecx
8010487d:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
80104883:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("num o threads %d \n" , i);
80104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104889:	89 44 24 04          	mov    %eax,0x4(%esp)
8010488d:	c7 04 24 91 93 10 80 	movl   $0x80109391,(%esp)
80104894:	e8 07 bb ff ff       	call   801003a0 <cprintf>
	if(i > NTHREAD)
80104899:	83 7d f4 10          	cmpl   $0x10,-0xc(%ebp)
8010489d:	7e 0c                	jle    801048ab <increaseNumOfThreadsAlive+0x46>
		panic("Too many threads");
8010489f:	c7 04 24 a4 93 10 80 	movl   $0x801093a4,(%esp)
801048a6:	e8 8f bc ff ff       	call   8010053a <panic>
}
801048ab:	c9                   	leave  
801048ac:	c3                   	ret    

801048ad <decreaseNumOfThreadsAlive>:


void
decreaseNumOfThreadsAlive(void){
801048ad:	55                   	push   %ebp
801048ae:	89 e5                	mov    %esp,%ebp
801048b0:	83 ec 28             	sub    $0x28,%esp

	int i = thread->proc->numOfThreads--;
801048b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b9:	8b 50 0c             	mov    0xc(%eax),%edx
801048bc:	8b 82 30 02 00 00    	mov    0x230(%edx),%eax
801048c2:	8d 48 ff             	lea    -0x1(%eax),%ecx
801048c5:	89 8a 30 02 00 00    	mov    %ecx,0x230(%edx)
801048cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("num o threads %d 0\n" , i);
801048ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801048d5:	c7 04 24 b5 93 10 80 	movl   $0x801093b5,(%esp)
801048dc:	e8 bf ba ff ff       	call   801003a0 <cprintf>
	if(i < 0)
801048e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048e5:	79 0c                	jns    801048f3 <decreaseNumOfThreadsAlive+0x46>
		panic("Not enough threads");
801048e7:	c7 04 24 c9 93 10 80 	movl   $0x801093c9,(%esp)
801048ee:	e8 47 bc ff ff       	call   8010053a <panic>
}
801048f3:	c9                   	leave  
801048f4:	c3                   	ret    

801048f5 <procIsAlive>:

int
procIsAlive(){
801048f5:	55                   	push   %ebp
801048f6:	89 e5                	mov    %esp,%ebp
	return thread->proc->numOfThreads > 0;
801048f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104901:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104907:	85 c0                	test   %eax,%eax
80104909:	0f 9f c0             	setg   %al
8010490c:	0f b6 c0             	movzbl %al,%eax
}
8010490f:	5d                   	pop    %ebp
80104910:	c3                   	ret    

80104911 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104911:	55                   	push   %ebp
80104912:	89 e5                	mov    %esp,%ebp
80104914:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct proc *proc =thread->proc;
80104917:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491d:	8b 40 0c             	mov    0xc(%eax),%eax
80104920:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct thread *t;
  int fd;

  if(proc == initproc)
80104923:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104928:	39 45 e8             	cmp    %eax,-0x18(%ebp)
8010492b:	75 0c                	jne    80104939 <exit+0x28>
    panic("init exiting");
8010492d:	c7 04 24 dc 93 10 80 	movl   $0x801093dc,(%esp)
80104934:	e8 01 bc ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104939:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104940:	eb 3b                	jmp    8010497d <exit+0x6c>
    if(proc->ofile[fd]){
80104942:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104945:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104948:	83 c2 04             	add    $0x4,%edx
8010494b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010494f:	85 c0                	test   %eax,%eax
80104951:	74 26                	je     80104979 <exit+0x68>
      fileclose(proc->ofile[fd]);
80104953:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104956:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104959:	83 c2 04             	add    $0x4,%edx
8010495c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104960:	89 04 24             	mov    %eax,(%esp)
80104963:	e8 88 c6 ff ff       	call   80100ff0 <fileclose>
      proc->ofile[fd] = 0;
80104968:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010496b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010496e:	83 c2 04             	add    $0x4,%edx
80104971:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80104978:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104979:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010497d:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
80104981:	7e bf                	jle    80104942 <exit+0x31>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104983:	e8 ad ea ff ff       	call   80103435 <begin_op>
  iput(proc->cwd);
80104988:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010498b:	8b 40 5c             	mov    0x5c(%eax),%eax
8010498e:	89 04 24             	mov    %eax,(%esp)
80104991:	e8 9a d0 ff ff       	call   80101a30 <iput>
  end_op();
80104996:	e8 1e eb ff ff       	call   801034b9 <end_op>
  proc->cwd = 0;
8010499b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010499e:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)

  acquire(&ptable.lock);
801049a5:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801049ac:	e8 bf 0e 00 00       	call   80105870 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801049b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049b4:	8b 40 10             	mov    0x10(%eax),%eax
801049b7:	89 04 24             	mov    %eax,(%esp)
801049ba:	e8 f7 04 00 00       	call   80104eb6 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049bf:	c7 45 f4 b4 5c 11 80 	movl   $0x80115cb4,-0xc(%ebp)
801049c6:	eb 36                	jmp    801049fe <exit+0xed>
    if(p->parent == proc){
801049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cb:	8b 40 10             	mov    0x10(%eax),%eax
801049ce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801049d1:	75 24                	jne    801049f7 <exit+0xe6>
      p->parent = initproc;
801049d3:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
801049d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049dc:	89 50 10             	mov    %edx,0x10(%eax)
      if(p->state == ZOMBIE)
801049df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e2:	8b 40 08             	mov    0x8(%eax),%eax
801049e5:	83 f8 05             	cmp    $0x5,%eax
801049e8:	75 0d                	jne    801049f7 <exit+0xe6>
        wakeup1(initproc);
801049ea:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049ef:	89 04 24             	mov    %eax,(%esp)
801049f2:	e8 bf 04 00 00       	call   80104eb6 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f7:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
801049fe:	81 7d f4 b4 e9 11 80 	cmpl   $0x8011e9b4,-0xc(%ebp)
80104a05:	72 c1                	jb     801049c8 <exit+0xb7>
    }
  }

  ;

  proc->killed = 1;
80104a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a0a:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
  for (t = proc->threads; t < &proc->threads[NTHREAD]; t++){
80104a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a14:	83 c0 70             	add    $0x70,%eax
80104a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104a1a:	eb 46                	jmp    80104a62 <exit+0x151>
  		if (t->state != RUNNING && t->state != UNUSED && t!=thread){
80104a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a1f:	8b 40 04             	mov    0x4(%eax),%eax
80104a22:	83 f8 04             	cmp    $0x4,%eax
80104a25:	74 37                	je     80104a5e <exit+0x14d>
80104a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2a:	8b 40 04             	mov    0x4(%eax),%eax
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	74 2d                	je     80104a5e <exit+0x14d>
80104a31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a37:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104a3a:	74 22                	je     80104a5e <exit+0x14d>
  			t->state = ZOMBIE;
80104a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3f:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)
  			if( thread->proc->numOfThreads>0)
80104a46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a4c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a4f:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104a55:	85 c0                	test   %eax,%eax
80104a57:	7e 05                	jle    80104a5e <exit+0x14d>
  				  	  	  decreaseNumOfThreadsAlive();
80104a59:	e8 4f fe ff ff       	call   801048ad <decreaseNumOfThreadsAlive>
  }

  ;

  proc->killed = 1;
  for (t = proc->threads; t < &proc->threads[NTHREAD]; t++){
80104a5e:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a65:	05 30 02 00 00       	add    $0x230,%eax
80104a6a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104a6d:	77 ad                	ja     80104a1c <exit+0x10b>

  		}
  	}

  // Jump into the scheduler, never to return.
  if( thread->proc->numOfThreads>0)
80104a6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a75:	8b 40 0c             	mov    0xc(%eax),%eax
80104a78:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104a7e:	85 c0                	test   %eax,%eax
80104a80:	7e 05                	jle    80104a87 <exit+0x176>
	  	  	  decreaseNumOfThreadsAlive();
80104a82:	e8 26 fe ff ff       	call   801048ad <decreaseNumOfThreadsAlive>
  thread->state = ZOMBIE;
80104a87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8d:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)
 if(!procIsAlive())
80104a94:	e8 5c fe ff ff       	call   801048f5 <procIsAlive>
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	75 0a                	jne    80104aa7 <exit+0x196>
	  proc->state = ZOMBIE;
80104a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104aa0:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)


  sched();
80104aa7:	e8 5f 02 00 00       	call   80104d0b <sched>
  panic("zombie exit");
80104aac:	c7 04 24 e9 93 10 80 	movl   $0x801093e9,(%esp)
80104ab3:	e8 82 ba ff ff       	call   8010053a <panic>

80104ab8 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104ab8:	55                   	push   %ebp
80104ab9:	89 e5                	mov    %esp,%ebp
80104abb:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *proc=thread->proc;
80104abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct thread *t;

  acquire(&ptable.lock);
80104aca:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104ad1:	e8 9a 0d 00 00       	call   80105870 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104ad6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104add:	c7 45 f4 b4 5c 11 80 	movl   $0x80115cb4,-0xc(%ebp)
80104ae4:	e9 fd 00 00 00       	jmp    80104be6 <wait+0x12e>
      if(p->parent != proc)
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	8b 40 10             	mov    0x10(%eax),%eax
80104aef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104af2:	74 05                	je     80104af9 <wait+0x41>
        continue;
80104af4:	e9 e6 00 00 00       	jmp    80104bdf <wait+0x127>
      havekids = 1;
80104af9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	8b 40 08             	mov    0x8(%eax),%eax
80104b06:	83 f8 05             	cmp    $0x5,%eax
80104b09:	0f 85 d0 00 00 00    	jne    80104bdf <wait+0x127>
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b12:	83 c0 70             	add    $0x70,%eax
80104b15:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104b18:	eb 61                	jmp    80104b7b <wait+0xc3>

    		  if (t->state == ZOMBIE){
80104b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b1d:	8b 40 04             	mov    0x4(%eax),%eax
80104b20:	83 f8 05             	cmp    $0x5,%eax
80104b23:	75 52                	jne    80104b77 <wait+0xbf>
				  t->chan= 0;
80104b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b28:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
				  t->context = 0;
80104b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b32:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				  t->pid = 0;
80104b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				  t->proc = 0;
80104b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				  t->state = 0;
80104b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				 // t->tf = 0;
				  t->state= UNUSED;
80104b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				  if (t->kstack)
80104b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b64:	8b 00                	mov    (%eax),%eax
80104b66:	85 c0                	test   %eax,%eax
80104b68:	74 0d                	je     80104b77 <wait+0xbf>
					  kfree(t->kstack);
80104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b6d:	8b 00                	mov    (%eax),%eax
80104b6f:	89 04 24             	mov    %eax,(%esp)
80104b72:	e8 f7 de ff ff       	call   80102a6e <kfree>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
    	  // Found one.

    	  for( t=proc->threads; t< &proc->threads[NTHREAD]; t++){
80104b77:	83 45 ec 1c          	addl   $0x1c,-0x14(%ebp)
80104b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b7e:	05 30 02 00 00       	add    $0x230,%eax
80104b83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104b86:	77 92                	ja     80104b1a <wait+0x62>
				  if (t->kstack)
					  kfree(t->kstack);
    		  }
    	  }

        pid = p->pid;
80104b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

        freevm(p->pgdir);
80104b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b94:	8b 40 04             	mov    0x4(%eax),%eax
80104b97:	89 04 24             	mov    %eax,(%esp)
80104b9a:	e8 d5 41 00 00       	call   80108d74 <freevm>
        p->state = UNUSED;
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        p->pid = 0;
80104ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->parent = 0;
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->name[0] = 0;
80104bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc0:	c6 40 60 00          	movb   $0x0,0x60(%eax)
        p->killed = 0;
80104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        release(&ptable.lock);
80104bce:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104bd5:	e8 f8 0c 00 00       	call   801058d2 <release>
        return pid;
80104bda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104bdd:	eb 4f                	jmp    80104c2e <wait+0x176>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bdf:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104be6:	81 7d f4 b4 e9 11 80 	cmpl   $0x8011e9b4,-0xc(%ebp)
80104bed:	0f 82 f6 fe ff ff    	jb     80104ae9 <wait+0x31>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bf7:	74 0a                	je     80104c03 <wait+0x14b>
80104bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104bfc:	8b 40 18             	mov    0x18(%eax),%eax
80104bff:	85 c0                	test   %eax,%eax
80104c01:	74 13                	je     80104c16 <wait+0x15e>
      release(&ptable.lock);
80104c03:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104c0a:	e8 c3 0c 00 00       	call   801058d2 <release>
      return -1;
80104c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c14:	eb 18                	jmp    80104c2e <wait+0x176>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c16:	c7 44 24 04 80 5c 11 	movl   $0x80115c80,0x4(%esp)
80104c1d:	80 
80104c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104c21:	89 04 24             	mov    %eax,(%esp)
80104c24:	e8 f2 01 00 00       	call   80104e1b <sleep>
  }
80104c29:	e9 a8 fe ff ff       	jmp    80104ad6 <wait+0x1e>
  return -1;
}
80104c2e:	c9                   	leave  
80104c2f:	c3                   	ret    

80104c30 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c36:	e8 d6 f6 ff ff       	call   80104311 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c3b:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104c42:	e8 29 0c 00 00       	call   80105870 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c47:	c7 45 f4 b4 5c 11 80 	movl   $0x80115cb4,-0xc(%ebp)
80104c4e:	e9 9a 00 00 00       	jmp    80104ced <scheduler+0xbd>

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
80104c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c56:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	7e 0d                	jle    80104c6d <scheduler+0x3d>
80104c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c63:	8b 40 08             	mov    0x8(%eax),%eax
80104c66:	83 f8 03             	cmp    $0x3,%eax
80104c69:	74 02                	je     80104c6d <scheduler+0x3d>
					continue;
80104c6b:	eb 79                	jmp    80104ce6 <scheduler+0xb6>
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c70:	83 c0 70             	add    $0x70,%eax
80104c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104c76:	eb 61                	jmp    80104cd9 <scheduler+0xa9>

				  if(t->state != RUNNABLE)
80104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7b:	8b 40 04             	mov    0x4(%eax),%eax
80104c7e:	83 f8 03             	cmp    $0x3,%eax
80104c81:	74 02                	je     80104c85 <scheduler+0x55>
					continue;
80104c83:	eb 50                	jmp    80104cd5 <scheduler+0xa5>
				  // Switch to chosen process.  It is the process's job
				  // to release ptable.lock and then reacquire it
				  // before jumping back to us.
				  thread = t;
80104c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c88:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
				  switchuvm(thread);
80104c8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c94:	89 04 24             	mov    %eax,(%esp)
80104c97:	e8 60 3c 00 00       	call   801088fc <switchuvm>
				  t->state = RUNNING;
80104c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c9f:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
				  swtch(&cpu->scheduler, thread->context);
80104ca6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cac:	8b 40 14             	mov    0x14(%eax),%eax
80104caf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cb6:	83 c2 04             	add    $0x4,%edx
80104cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cbd:	89 14 24             	mov    %edx,(%esp)
80104cc0:	e8 90 10 00 00       	call   80105d55 <swtch>
				  switchkvm();
80104cc5:	e8 15 3c 00 00       	call   801088df <switchkvm>

				  // Process is done running for now.
				  // It should have changed its p->state before coming back.
				  thread = 0;
80104cca:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cd1:	00 00 00 00 

			  if((p->numOfThreads > 0) && (p->state != RUNNABLE)){
					continue;
			   }

			  for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104cd5:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdc:	05 30 02 00 00       	add    $0x230,%eax
80104ce1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104ce4:	77 92                	ja     80104c78 <scheduler+0x48>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce6:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104ced:	81 7d f4 b4 e9 11 80 	cmpl   $0x8011e9b4,-0xc(%ebp)
80104cf4:	0f 82 59 ff ff ff    	jb     80104c53 <scheduler+0x23>
				  thread = 0;
			  }

    }

    release(&ptable.lock);
80104cfa:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104d01:	e8 cc 0b 00 00       	call   801058d2 <release>

  }
80104d06:	e9 2b ff ff ff       	jmp    80104c36 <scheduler+0x6>

80104d0b <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d11:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104d18:	e8 7d 0c 00 00       	call   8010599a <holding>
80104d1d:	85 c0                	test   %eax,%eax
80104d1f:	75 0c                	jne    80104d2d <sched+0x22>
    panic("sched ptable.lock");
80104d21:	c7 04 24 f5 93 10 80 	movl   $0x801093f5,(%esp)
80104d28:	e8 0d b8 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104d2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d33:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d39:	83 f8 01             	cmp    $0x1,%eax
80104d3c:	74 0c                	je     80104d4a <sched+0x3f>
    panic("sched locks");
80104d3e:	c7 04 24 07 94 10 80 	movl   $0x80109407,(%esp)
80104d45:	e8 f0 b7 ff ff       	call   8010053a <panic>
  if(thread->state == RUNNING)
80104d4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d50:	8b 40 04             	mov    0x4(%eax),%eax
80104d53:	83 f8 04             	cmp    $0x4,%eax
80104d56:	75 0c                	jne    80104d64 <sched+0x59>
    panic("sched running");
80104d58:	c7 04 24 13 94 10 80 	movl   $0x80109413,(%esp)
80104d5f:	e8 d6 b7 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104d64:	e8 98 f5 ff ff       	call   80104301 <readeflags>
80104d69:	25 00 02 00 00       	and    $0x200,%eax
80104d6e:	85 c0                	test   %eax,%eax
80104d70:	74 0c                	je     80104d7e <sched+0x73>
    panic("sched interruptible");
80104d72:	c7 04 24 21 94 10 80 	movl   $0x80109421,(%esp)
80104d79:	e8 bc b7 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104d7e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d84:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  swtch(&thread->context, cpu->scheduler);
80104d8d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d93:	8b 40 04             	mov    0x4(%eax),%eax
80104d96:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d9d:	83 c2 14             	add    $0x14,%edx
80104da0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104da4:	89 14 24             	mov    %edx,(%esp)
80104da7:	e8 a9 0f 00 00       	call   80105d55 <swtch>
  cpu->intena = intena;
80104dac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104db5:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dbb:	c9                   	leave  
80104dbc:	c3                   	ret    

80104dbd <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104dbd:	55                   	push   %ebp
80104dbe:	89 e5                	mov    %esp,%ebp
80104dc0:	83 ec 18             	sub    $0x18,%esp

  acquire(&ptable.lock);  //DOC: yieldlock
80104dc3:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104dca:	e8 a1 0a 00 00       	call   80105870 <acquire>
  thread->state = RUNNABLE;
80104dcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd5:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

  sched();
80104ddc:	e8 2a ff ff ff       	call   80104d0b <sched>

  release(&ptable.lock);
80104de1:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104de8:	e8 e5 0a 00 00       	call   801058d2 <release>
}
80104ded:	c9                   	leave  
80104dee:	c3                   	ret    

80104def <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104def:	55                   	push   %ebp
80104df0:	89 e5                	mov    %esp,%ebp
80104df2:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104df5:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104dfc:	e8 d1 0a 00 00       	call   801058d2 <release>

  if (first) {
80104e01:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e06:	85 c0                	test   %eax,%eax
80104e08:	74 0f                	je     80104e19 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e0a:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e11:	00 00 00 
    initlog();
80104e14:	e8 0e e4 ff ff       	call   80103227 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104e19:	c9                   	leave  
80104e1a:	c3                   	ret    

80104e1b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e1b:	55                   	push   %ebp
80104e1c:	89 e5                	mov    %esp,%ebp
80104e1e:	83 ec 18             	sub    $0x18,%esp
  if(thread == 0)
80104e21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e27:	85 c0                	test   %eax,%eax
80104e29:	75 0c                	jne    80104e37 <sleep+0x1c>
    panic("sleep");
80104e2b:	c7 04 24 35 94 10 80 	movl   $0x80109435,(%esp)
80104e32:	e8 03 b7 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104e37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e3b:	75 0c                	jne    80104e49 <sleep+0x2e>
    panic("sleep without lk");
80104e3d:	c7 04 24 3b 94 10 80 	movl   $0x8010943b,(%esp)
80104e44:	e8 f1 b6 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e49:	81 7d 0c 80 5c 11 80 	cmpl   $0x80115c80,0xc(%ebp)
80104e50:	74 17                	je     80104e69 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e52:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104e59:	e8 12 0a 00 00       	call   80105870 <acquire>
    release(lk);
80104e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e61:	89 04 24             	mov    %eax,(%esp)
80104e64:	e8 69 0a 00 00       	call   801058d2 <release>
  }

  // Go to sleep.
  thread->chan = chan;
80104e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6f:	8b 55 08             	mov    0x8(%ebp),%edx
80104e72:	89 50 18             	mov    %edx,0x18(%eax)
  thread->state = SLEEPING;
80104e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7b:	c7 40 04 02 00 00 00 	movl   $0x2,0x4(%eax)
  sched();
80104e82:	e8 84 fe ff ff       	call   80104d0b <sched>

  // Tidy up.
  thread->chan = 0;
80104e87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e8d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e94:	81 7d 0c 80 5c 11 80 	cmpl   $0x80115c80,0xc(%ebp)
80104e9b:	74 17                	je     80104eb4 <sleep+0x99>
    release(&ptable.lock);
80104e9d:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104ea4:	e8 29 0a 00 00       	call   801058d2 <release>
    acquire(lk);
80104ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eac:	89 04 24             	mov    %eax,(%esp)
80104eaf:	e8 bc 09 00 00       	call   80105870 <acquire>
  }
}
80104eb4:	c9                   	leave  
80104eb5:	c3                   	ret    

80104eb6 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104eb6:	55                   	push   %ebp
80104eb7:	89 e5                	mov    %esp,%ebp
80104eb9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ebc:	c7 45 fc b4 5c 11 80 	movl   $0x80115cb4,-0x4(%ebp)
80104ec3:	eb 43                	jmp    80104f08 <wakeup1+0x52>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec8:	83 c0 70             	add    $0x70,%eax
80104ecb:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104ece:	eb 24                	jmp    80104ef4 <wakeup1+0x3e>
		if(t->state == SLEEPING && t->chan == chan)
80104ed0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ed3:	8b 40 04             	mov    0x4(%eax),%eax
80104ed6:	83 f8 02             	cmp    $0x2,%eax
80104ed9:	75 15                	jne    80104ef0 <wakeup1+0x3a>
80104edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ede:	8b 40 18             	mov    0x18(%eax),%eax
80104ee1:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ee4:	75 0a                	jne    80104ef0 <wakeup1+0x3a>
		  t->state = RUNNABLE;
80104ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ee9:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
80104ef0:	83 45 f8 1c          	addl   $0x1c,-0x8(%ebp)
80104ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ef7:	05 30 02 00 00       	add    $0x230,%eax
80104efc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104eff:	77 cf                	ja     80104ed0 <wakeup1+0x1a>
wakeup1(void *chan)
{
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f01:	81 45 fc 34 02 00 00 	addl   $0x234,-0x4(%ebp)
80104f08:	81 7d fc b4 e9 11 80 	cmpl   $0x8011e9b4,-0x4(%ebp)
80104f0f:	72 b4                	jb     80104ec5 <wakeup1+0xf>
	 for( t=p->threads; t< &p->threads[NTHREAD]; t++){
		if(t->state == SLEEPING && t->chan == chan)
		  t->state = RUNNABLE;
	 }
}
80104f11:	c9                   	leave  
80104f12:	c3                   	ret    

80104f13 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f13:	55                   	push   %ebp
80104f14:	89 e5                	mov    %esp,%ebp
80104f16:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104f19:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104f20:	e8 4b 09 00 00       	call   80105870 <acquire>
  wakeup1(chan);
80104f25:	8b 45 08             	mov    0x8(%ebp),%eax
80104f28:	89 04 24             	mov    %eax,(%esp)
80104f2b:	e8 86 ff ff ff       	call   80104eb6 <wakeup1>
  release(&ptable.lock);
80104f30:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104f37:	e8 96 09 00 00       	call   801058d2 <release>
}
80104f3c:	c9                   	leave  
80104f3d:	c3                   	ret    

80104f3e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f3e:	55                   	push   %ebp
80104f3f:	89 e5                	mov    %esp,%ebp
80104f41:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
80104f44:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104f4b:	e8 20 09 00 00       	call   80105870 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f50:	c7 45 f4 b4 5c 11 80 	movl   $0x80115cb4,-0xc(%ebp)
80104f57:	eb 60                	jmp    80104fb9 <kill+0x7b>
    if(p->pid == pid){
80104f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f5f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f62:	75 4e                	jne    80104fb2 <kill+0x74>
      p->killed = 1;
80104f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f67:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f71:	83 c0 70             	add    $0x70,%eax
80104f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104f77:	eb 19                	jmp    80104f92 <kill+0x54>
			 if(t->state == SLEEPING)
80104f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f7c:	8b 40 04             	mov    0x4(%eax),%eax
80104f7f:	83 f8 02             	cmp    $0x2,%eax
80104f82:	75 0a                	jne    80104f8e <kill+0x50>
					t->state = RUNNABLE;
80104f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f87:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      for (t = p->threads; t < &p->threads[NTHREAD]; t++){
80104f8e:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	05 30 02 00 00       	add    $0x230,%eax
80104f9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104f9d:	77 da                	ja     80104f79 <kill+0x3b>
			 if(t->state == SLEEPING)
					t->state = RUNNABLE;
      }
      // Wake process from sleep if necessary.

      release(&ptable.lock);
80104f9f:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104fa6:	e8 27 09 00 00       	call   801058d2 <release>
      return 0;
80104fab:	b8 00 00 00 00       	mov    $0x0,%eax
80104fb0:	eb 21                	jmp    80104fd3 <kill+0x95>
kill(int pid)
{
  struct proc *p;
  struct thread *t;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb2:	81 45 f4 34 02 00 00 	addl   $0x234,-0xc(%ebp)
80104fb9:	81 7d f4 b4 e9 11 80 	cmpl   $0x8011e9b4,-0xc(%ebp)
80104fc0:	72 97                	jb     80104f59 <kill+0x1b>

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104fc2:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80104fc9:	e8 04 09 00 00       	call   801058d2 <release>
  return -1;
80104fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fd3:	c9                   	leave  
80104fd4:	c3                   	ret    

80104fd5 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fd5:	55                   	push   %ebp
80104fd6:	89 e5                	mov    %esp,%ebp
80104fd8:	83 ec 58             	sub    $0x58,%esp
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fdb:	c7 45 f0 b4 5c 11 80 	movl   $0x80115cb4,-0x10(%ebp)
80104fe2:	e9 dc 00 00 00       	jmp    801050c3 <procdump+0xee>
    if(p->state == UNUSED)
80104fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fea:	8b 40 08             	mov    0x8(%eax),%eax
80104fed:	85 c0                	test   %eax,%eax
80104fef:	75 05                	jne    80104ff6 <procdump+0x21>
      continue;
80104ff1:	e9 c6 00 00 00       	jmp    801050bc <procdump+0xe7>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff9:	8b 40 08             	mov    0x8(%eax),%eax
80104ffc:	83 f8 05             	cmp    $0x5,%eax
80104fff:	77 23                	ja     80105024 <procdump+0x4f>
80105001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105004:	8b 40 08             	mov    0x8(%eax),%eax
80105007:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010500e:	85 c0                	test   %eax,%eax
80105010:	74 12                	je     80105024 <procdump+0x4f>
      state = states[p->state];
80105012:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105015:	8b 40 08             	mov    0x8(%eax),%eax
80105018:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010501f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105022:	eb 07                	jmp    8010502b <procdump+0x56>
    else
      state = "???";
80105024:	c7 45 ec 4c 94 10 80 	movl   $0x8010944c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010502b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502e:	8d 50 60             	lea    0x60(%eax),%edx
80105031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105034:	8b 40 0c             	mov    0xc(%eax),%eax
80105037:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010503b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010503e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105042:	89 44 24 04          	mov    %eax,0x4(%esp)
80105046:	c7 04 24 50 94 10 80 	movl   $0x80109450,(%esp)
8010504d:	e8 4e b3 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80105052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105055:	8b 40 08             	mov    0x8(%eax),%eax
80105058:	83 f8 02             	cmp    $0x2,%eax
8010505b:	75 53                	jne    801050b0 <procdump+0xdb>
      getcallerpcs((uint*)thread->context->ebp+2, pc);
8010505d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105063:	8b 40 14             	mov    0x14(%eax),%eax
80105066:	8b 40 0c             	mov    0xc(%eax),%eax
80105069:	83 c0 08             	add    $0x8,%eax
8010506c:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010506f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105073:	89 04 24             	mov    %eax,(%esp)
80105076:	e8 a6 08 00 00       	call   80105921 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010507b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105082:	eb 1b                	jmp    8010509f <procdump+0xca>
        cprintf(" %p", pc[i]);
80105084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105087:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010508b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010508f:	c7 04 24 59 94 10 80 	movl   $0x80109459,(%esp)
80105096:	e8 05 b3 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)thread->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010509b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010509f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050a3:	7f 0b                	jg     801050b0 <procdump+0xdb>
801050a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050ac:	85 c0                	test   %eax,%eax
801050ae:	75 d4                	jne    80105084 <procdump+0xaf>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050b0:	c7 04 24 5d 94 10 80 	movl   $0x8010945d,(%esp)
801050b7:	e8 e4 b2 ff ff       	call   801003a0 <cprintf>
  struct proc *p;

  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050bc:	81 45 f0 34 02 00 00 	addl   $0x234,-0x10(%ebp)
801050c3:	81 7d f0 b4 e9 11 80 	cmpl   $0x8011e9b4,-0x10(%ebp)
801050ca:	0f 82 17 ff ff ff    	jb     80104fe7 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050d0:	c9                   	leave  
801050d1:	c3                   	ret    

801050d2 <wakeupThreads>:



void
wakeupThreads(void *chan)
{
801050d2:	55                   	push   %ebp
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	83 ec 10             	sub    $0x10,%esp


  struct thread *t;
  for(t= thread->proc->threads; t < &thread->proc->threads[NTHREAD]; t++){
801050d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050de:	8b 40 0c             	mov    0xc(%eax),%eax
801050e1:	83 c0 70             	add    $0x70,%eax
801050e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801050e7:	eb 24                	jmp    8010510d <wakeupThreads+0x3b>
		  if(t->state == SLEEPING && t->chan == chan){
801050e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050ec:	8b 40 04             	mov    0x4(%eax),%eax
801050ef:	83 f8 02             	cmp    $0x2,%eax
801050f2:	75 15                	jne    80105109 <wakeupThreads+0x37>
801050f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f7:	8b 40 18             	mov    0x18(%eax),%eax
801050fa:	3b 45 08             	cmp    0x8(%ebp),%eax
801050fd:	75 0a                	jne    80105109 <wakeupThreads+0x37>
			  t->state =  RUNNABLE;
801050ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105102:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
wakeupThreads(void *chan)
{


  struct thread *t;
  for(t= thread->proc->threads; t < &thread->proc->threads[NTHREAD]; t++){
80105109:	83 45 fc 1c          	addl   $0x1c,-0x4(%ebp)
8010510d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105113:	8b 40 0c             	mov    0xc(%eax),%eax
80105116:	05 30 02 00 00       	add    $0x230,%eax
8010511b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010511e:	77 c9                	ja     801050e9 <wakeupThreads+0x17>
		  if(t->state == SLEEPING && t->chan == chan){
			  t->state =  RUNNABLE;
			  }
   }
}
80105120:	c9                   	leave  
80105121:	c3                   	ret    

80105122 <kthread_create>:


int
kthread_create(void*(*start_func)(), void* stack, uint stack_size){
80105122:	55                   	push   %ebp
80105123:	89 e5                	mov    %esp,%ebp
80105125:	57                   	push   %edi
80105126:	56                   	push   %esi
80105127:	53                   	push   %ebx
80105128:	83 ec 2c             	sub    $0x2c,%esp
	  struct thread *t ;


	  char *sp;

	  acquire(&ptable.lock);
8010512b:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80105132:	e8 39 07 00 00       	call   80105870 <acquire>
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105137:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513d:	8b 40 0c             	mov    0xc(%eax),%eax
80105140:	83 c0 70             	add    $0x70,%eax
80105143:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105146:	eb 53                	jmp    8010519b <kthread_create+0x79>
	    if(t->state == UNUSED){
80105148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010514b:	8b 40 04             	mov    0x4(%eax),%eax
8010514e:	85 c0                	test   %eax,%eax
80105150:	75 45                	jne    80105197 <kthread_create+0x75>
	       goto found;
80105152:	90                   	nop
	  }
	  release(&ptable.lock);
	  return -1;

	  found:
	       t->state=EMBRYO;
80105153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105156:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	       t->pid= nextpid++;
8010515d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80105162:	8d 50 01             	lea    0x1(%eax),%edx
80105165:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010516b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010516e:	89 42 08             	mov    %eax,0x8(%edx)
	       increaseNumOfThreadsAlive();
80105171:	e8 ef f6 ff ff       	call   80104865 <increaseNumOfThreadsAlive>
	       release(&ptable.lock);
80105176:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010517d:	e8 50 07 00 00       	call   801058d2 <release>
	       if((t->kstack = kalloc()) == 0){
80105182:	e8 80 d9 ff ff       	call   80102b07 <kalloc>
80105187:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010518a:	89 02                	mov    %eax,(%edx)
8010518c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010518f:	8b 00                	mov    (%eax),%eax
80105191:	85 c0                	test   %eax,%eax
80105193:	75 43                	jne    801051d8 <kthread_create+0xb6>
80105195:	eb 2d                	jmp    801051c4 <kthread_create+0xa2>


	  char *sp;

	  acquire(&ptable.lock);
	  for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
80105197:	83 45 e4 1c          	addl   $0x1c,-0x1c(%ebp)
8010519b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a1:	8b 40 0c             	mov    0xc(%eax),%eax
801051a4:	05 30 02 00 00       	add    $0x230,%eax
801051a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
801051ac:	77 9a                	ja     80105148 <kthread_create+0x26>
	    if(t->state == UNUSED){
	       goto found;
	    }
	  }
	  release(&ptable.lock);
801051ae:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801051b5:	e8 18 07 00 00       	call   801058d2 <release>
	  return -1;
801051ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bf:	e9 dc 00 00 00       	jmp    801052a0 <kthread_create+0x17e>
	       t->state=EMBRYO;
	       t->pid= nextpid++;
	       increaseNumOfThreadsAlive();
	       release(&ptable.lock);
	       if((t->kstack = kalloc()) == 0){
	        t->state = UNUSED;
801051c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	        return -1;
801051ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d3:	e9 c8 00 00 00       	jmp    801052a0 <kthread_create+0x17e>
	       }
	       sp = t->kstack + KSTACKSIZE;
801051d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051db:	8b 00                	mov    (%eax),%eax
801051dd:	05 00 10 00 00       	add    $0x1000,%eax
801051e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	       sp -= sizeof *t->tf;
801051e5:	83 6d e0 4c          	subl   $0x4c,-0x20(%ebp)

	       t->tf = (struct trapframe*)sp ;
801051e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
801051ef:	89 50 10             	mov    %edx,0x10(%eax)
	       sp -= 4;
801051f2:	83 6d e0 04          	subl   $0x4,-0x20(%ebp)
	       *(uint*)sp = (uint)trapret;
801051f6:	ba c1 70 10 80       	mov    $0x801070c1,%edx
801051fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051fe:	89 10                	mov    %edx,(%eax)
	       sp -= sizeof *t->context;
80105200:	83 6d e0 14          	subl   $0x14,-0x20(%ebp)
	       t->context = (struct context*)sp;
80105204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105207:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010520a:	89 50 14             	mov    %edx,0x14(%eax)
	       memset(t->context, 0, sizeof *t->context);
8010520d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105210:	8b 40 14             	mov    0x14(%eax),%eax
80105213:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010521a:	00 
8010521b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105222:	00 
80105223:	89 04 24             	mov    %eax,(%esp)
80105226:	e8 99 08 00 00       	call   80105ac4 <memset>


	       t->context->eip = (uint)forkret;
8010522b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010522e:	8b 40 14             	mov    0x14(%eax),%eax
80105231:	ba ef 4d 10 80       	mov    $0x80104def,%edx
80105236:	89 50 10             	mov    %edx,0x10(%eax)
	       *t->tf=*thread->tf;
80105239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010523c:	8b 50 10             	mov    0x10(%eax),%edx
8010523f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105245:	8b 40 10             	mov    0x10(%eax),%eax
80105248:	89 c3                	mov    %eax,%ebx
8010524a:	b8 13 00 00 00       	mov    $0x13,%eax
8010524f:	89 d7                	mov    %edx,%edi
80105251:	89 de                	mov    %ebx,%esi
80105253:	89 c1                	mov    %eax,%ecx
80105255:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	       t->tf->eip = (uint)start_func;
80105257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010525a:	8b 40 10             	mov    0x10(%eax),%eax
8010525d:	8b 55 08             	mov    0x8(%ebp),%edx
80105260:	89 50 38             	mov    %edx,0x38(%eax)
	       t->tf->esp = (uint)(stack+stack_size);
80105263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105266:	8b 40 10             	mov    0x10(%eax),%eax
80105269:	8b 55 10             	mov    0x10(%ebp),%edx
8010526c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010526f:	01 ca                	add    %ecx,%edx
80105271:	89 50 44             	mov    %edx,0x44(%eax)
	       t->tf->eflags = FL_IF;
80105274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105277:	8b 40 10             	mov    0x10(%eax),%eax
8010527a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	       t->proc = thread->proc;
80105281:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105287:	8b 50 0c             	mov    0xc(%eax),%edx
8010528a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010528d:	89 50 0c             	mov    %edx,0xc(%eax)
	       t->state = RUNNABLE;
80105290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105293:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
	       return t->pid;
8010529a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010529d:	8b 40 08             	mov    0x8(%eax),%eax


}
801052a0:	83 c4 2c             	add    $0x2c,%esp
801052a3:	5b                   	pop    %ebx
801052a4:	5e                   	pop    %esi
801052a5:	5f                   	pop    %edi
801052a6:	5d                   	pop    %ebp
801052a7:	c3                   	ret    

801052a8 <kthread_id>:

int kthread_id(){
801052a8:	55                   	push   %ebp
801052a9:	89 e5                	mov    %esp,%ebp

	return thread->pid;
801052ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b1:	8b 40 08             	mov    0x8(%eax),%eax
}
801052b4:	5d                   	pop    %ebp
801052b5:	c3                   	ret    

801052b6 <kthread_exit>:

void kthread_exit(){
801052b6:	55                   	push   %ebp
801052b7:	89 e5                	mov    %esp,%ebp
801052b9:	83 ec 28             	sub    $0x28,%esp




	 struct proc *proc =thread->proc;
801052bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c2:	8b 40 0c             	mov    0xc(%eax),%eax
801052c5:	89 45 f4             	mov    %eax,-0xc(%ebp)


	 acquire(&ptable.lock);
801052c8:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801052cf:	e8 9c 05 00 00       	call   80105870 <acquire>

	 thread->state= ZOMBIE;
801052d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052da:	c7 40 04 05 00 00 00 	movl   $0x5,0x4(%eax)

	 if (proc->numOfThreads == 1 ){  //tis is ta lst tred
801052e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e4:	8b 80 30 02 00 00    	mov    0x230(%eax),%eax
801052ea:	83 f8 01             	cmp    $0x1,%eax
801052ed:	75 11                	jne    80105300 <kthread_exit+0x4a>
		 	release(&ptable.lock);
801052ef:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801052f6:	e8 d7 05 00 00       	call   801058d2 <release>
		 	exit();
801052fb:	e8 11 f6 ff ff       	call   80104911 <exit>
	 }




	 decreaseNumOfThreadsAlive();
80105300:	e8 a8 f5 ff ff       	call   801048ad <decreaseNumOfThreadsAlive>
	 wakeup1(thread);
80105305:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010530b:	89 04 24             	mov    %eax,(%esp)
8010530e:	e8 a3 fb ff ff       	call   80104eb6 <wakeup1>
	 sched();
80105313:	e8 f3 f9 ff ff       	call   80104d0b <sched>
	 panic("zombie exit");
80105318:	c7 04 24 e9 93 10 80 	movl   $0x801093e9,(%esp)
8010531f:	e8 16 b2 ff ff       	call   8010053a <panic>

80105324 <kthread_join>:
}

int kthread_join(int thread_id){
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 28             	sub    $0x28,%esp
	//printf( "thread id : %d ", thread_id);
	  int found;
	  struct thread *t;
	  struct thread *threadFound;

	  acquire(&ptable.lock);
8010532a:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80105331:	e8 3a 05 00 00       	call   80105870 <acquire>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;
80105336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
8010533d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105343:	8b 40 0c             	mov    0xc(%eax),%eax
80105346:	83 c0 70             	add    $0x70,%eax
80105349:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010534c:	e9 8e 00 00 00       	jmp    801053df <kthread_join+0xbb>

	      if(t->pid != thread_id)
80105351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105354:	8b 40 08             	mov    0x8(%eax),%eax
80105357:	3b 45 08             	cmp    0x8(%ebp),%eax
8010535a:	74 02                	je     8010535e <kthread_join+0x3a>
	        continue;
8010535c:	eb 7d                	jmp    801053db <kthread_join+0xb7>
	      found = 1;
8010535e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	      threadFound= t;
80105365:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105368:	89 45 ec             	mov    %eax,-0x14(%ebp)

	      if(t->state == ZOMBIE){
8010536b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536e:	8b 40 04             	mov    0x4(%eax),%eax
80105371:	83 f8 05             	cmp    $0x5,%eax
80105374:	75 65                	jne    801053db <kthread_join+0xb7>
	        // Found one.
	        t->chan= 0;
80105376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105379:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
			t->context = 0;
80105380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105383:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
			t->pid = 0;
8010538a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			t->proc = 0;
80105394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105397:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			t->state = 0;
8010539e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			t->state= UNUSED;
801053a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			if (t->kstack)
801053b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053b5:	8b 00                	mov    (%eax),%eax
801053b7:	85 c0                	test   %eax,%eax
801053b9:	74 0d                	je     801053c8 <kthread_join+0xa4>
				kfree(t->kstack);
801053bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053be:	8b 00                	mov    (%eax),%eax
801053c0:	89 04 24             	mov    %eax,(%esp)
801053c3:	e8 a6 d6 ff ff       	call   80102a6e <kfree>

	        release(&ptable.lock);
801053c8:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801053cf:	e8 fe 04 00 00       	call   801058d2 <release>
	        return 0;
801053d4:	b8 00 00 00 00       	mov    $0x0,%eax
801053d9:	eb 5c                	jmp    80105437 <kthread_join+0x113>

	  for(;;){
	    // Scan through table looking for zombie children.
	    found = 0;

	    for(t = thread->proc->threads ; t<&thread->proc->threads[NTHREAD];t++){
801053db:	83 45 f0 1c          	addl   $0x1c,-0x10(%ebp)
801053df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e5:	8b 40 0c             	mov    0xc(%eax),%eax
801053e8:	05 30 02 00 00       	add    $0x230,%eax
801053ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801053f0:	0f 87 5b ff ff ff    	ja     80105351 <kthread_join+0x2d>
	        return 0;
	      }
	    }


	    if(!found || thread->proc->killed){
801053f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053fa:	74 10                	je     8010540c <kthread_join+0xe8>
801053fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105402:	8b 40 0c             	mov    0xc(%eax),%eax
80105405:	8b 40 18             	mov    0x18(%eax),%eax
80105408:	85 c0                	test   %eax,%eax
8010540a:	74 13                	je     8010541f <kthread_join+0xfb>

	      release(&ptable.lock);
8010540c:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80105413:	e8 ba 04 00 00       	call   801058d2 <release>
	      return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb 18                	jmp    80105437 <kthread_join+0x113>
	    }

	    // Wait for thread to exit
	    sleep(threadFound, &ptable.lock);  //DOC: wait-sleep
8010541f:	c7 44 24 04 80 5c 11 	movl   $0x80115c80,0x4(%esp)
80105426:	80 
80105427:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010542a:	89 04 24             	mov    %eax,(%esp)
8010542d:	e8 e9 f9 ff ff       	call   80104e1b <sleep>

	  }
80105432:	e9 ff fe ff ff       	jmp    80105336 <kthread_join+0x12>


	  return -1;
}
80105437:	c9                   	leave  
80105438:	c3                   	ret    

80105439 <EmptyQueue>:



int EmptyQueue(struct kthread_mutex_t *m){
80105439:	55                   	push   %ebp
8010543a:	89 e5                	mov    %esp,%ebp

  return (m->threads_queue[0]==0);
8010543c:	8b 45 08             	mov    0x8(%ebp),%eax
8010543f:	8b 40 0c             	mov    0xc(%eax),%eax
80105442:	85 c0                	test   %eax,%eax
80105444:	0f 94 c0             	sete   %al
80105447:	0f b6 c0             	movzbl %al,%eax

}
8010544a:	5d                   	pop    %ebp
8010544b:	c3                   	ret    

8010544c <pushThreadToMutexQueue>:

void pushThreadToMutexQueue(struct thread *t , struct kthread_mutex_t *m){
8010544c:	55                   	push   %ebp
8010544d:	89 e5                	mov    %esp,%ebp
8010544f:	83 ec 18             	sub    $0x18,%esp

  if (m->last == NTHREAD)
80105452:	8b 45 0c             	mov    0xc(%ebp),%eax
80105455:	8b 40 50             	mov    0x50(%eax),%eax
80105458:	83 f8 10             	cmp    $0x10,%eax
8010545b:	75 0c                	jne    80105469 <pushThreadToMutexQueue+0x1d>
	  panic ("Mutex oveflow\n");
8010545d:	c7 04 24 5f 94 10 80 	movl   $0x8010945f,(%esp)
80105464:	e8 d1 b0 ff ff       	call   8010053a <panic>


  m->threads_queue[m->last]= t;
80105469:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546c:	8b 50 50             	mov    0x50(%eax),%edx
8010546f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105472:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105475:	89 4c 90 0c          	mov    %ecx,0xc(%eax,%edx,4)

  m->last++;
80105479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547c:	8b 40 50             	mov    0x50(%eax),%eax
8010547f:	8d 50 01             	lea    0x1(%eax),%edx
80105482:	8b 45 0c             	mov    0xc(%ebp),%eax
80105485:	89 50 50             	mov    %edx,0x50(%eax)

}
80105488:	c9                   	leave  
80105489:	c3                   	ret    

8010548a <popThreadToMutexQueue>:


struct thread * popThreadToMutexQueue(struct kthread_mutex_t *m){
8010548a:	55                   	push   %ebp
8010548b:	89 e5                	mov    %esp,%ebp
8010548d:	83 ec 28             	sub    $0x28,%esp

  struct thread * toReturn = m->threads_queue[m->first];
80105490:	8b 45 08             	mov    0x8(%ebp),%eax
80105493:	8b 50 4c             	mov    0x4c(%eax),%edx
80105496:	8b 45 08             	mov    0x8(%ebp),%eax
80105499:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010549d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;


  if (toReturn==0)
801054a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054a4:	75 0c                	jne    801054b2 <popThreadToMutexQueue+0x28>
	  	  panic("Mutex over pop. Can't pop this... \n");
801054a6:	c7 04 24 70 94 10 80 	movl   $0x80109470,(%esp)
801054ad:	e8 88 b0 ff ff       	call   8010053a <panic>


  for (i =1 ; i< NTHREAD ; i++){
801054b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801054b9:	eb 2b                	jmp    801054e6 <popThreadToMutexQueue+0x5c>

	  m->threads_queue[i-1]= m->threads_queue[i];
801054bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054be:	8d 48 ff             	lea    -0x1(%eax),%ecx
801054c1:	8b 45 08             	mov    0x8(%ebp),%eax
801054c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c7:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
801054cb:	8b 45 08             	mov    0x8(%ebp),%eax
801054ce:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)

	  if (m->threads_queue[i]==0)
801054d2:	8b 45 08             	mov    0x8(%ebp),%eax
801054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054d8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801054dc:	85 c0                	test   %eax,%eax
801054de:	75 02                	jne    801054e2 <popThreadToMutexQueue+0x58>
		  break;
801054e0:	eb 0a                	jmp    801054ec <popThreadToMutexQueue+0x62>

  if (toReturn==0)
	  	  panic("Mutex over pop. Can't pop this... \n");


  for (i =1 ; i< NTHREAD ; i++){
801054e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801054e6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ea:	7e cf                	jle    801054bb <popThreadToMutexQueue+0x31>

	  if (m->threads_queue[i]==0)
		  break;

  }
  m->last--;
801054ec:	8b 45 08             	mov    0x8(%ebp),%eax
801054ef:	8b 40 50             	mov    0x50(%eax),%eax
801054f2:	8d 50 ff             	lea    -0x1(%eax),%edx
801054f5:	8b 45 08             	mov    0x8(%ebp),%eax
801054f8:	89 50 50             	mov    %edx,0x50(%eax)
  m->threads_queue[NTHREAD-1]=0;
801054fb:	8b 45 08             	mov    0x8(%ebp),%eax
801054fe:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)


  return toReturn;
80105505:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105508:	c9                   	leave  
80105509:	c3                   	ret    

8010550a <kthread_mutex_alloc>:


int kthread_mutex_alloc(void){
8010550a:	55                   	push   %ebp
8010550b:	89 e5                	mov    %esp,%ebp
8010550d:	83 ec 28             	sub    $0x28,%esp

    int index=0;
80105510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct kthread_mutex_t *m;

    for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105517:	c7 45 f0 80 39 11 80 	movl   $0x80113980,-0x10(%ebp)
8010551e:	eb 6c                	jmp    8010558c <kthread_mutex_alloc+0x82>

        if(m->state == UNUSED_MUTEX){
80105520:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105523:	8b 00                	mov    (%eax),%eax
80105525:	85 c0                	test   %eax,%eax
80105527:	75 5b                	jne    80105584 <kthread_mutex_alloc+0x7a>
          m->state = USED_MUTEX;
80105529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
          m->id = index;
80105532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105535:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105538:	89 50 04             	mov    %edx,0x4(%eax)
          m->queueLock= &mutextable.mutexspinLock[index];
8010553b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553e:	6b c0 34             	imul   $0x34,%eax,%eax
80105541:	05 00 16 00 00       	add    $0x1600,%eax
80105546:	8d 90 80 39 11 80    	lea    -0x7feec680(%eax),%edx
8010554c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010554f:	89 50 54             	mov    %edx,0x54(%eax)
          initlock(m->queueLock, "mutexLock");
80105552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105555:	8b 40 54             	mov    0x54(%eax),%eax
80105558:	c7 44 24 04 94 94 10 	movl   $0x80109494,0x4(%esp)
8010555f:	80 
80105560:	89 04 24             	mov    %eax,(%esp)
80105563:	e8 e7 02 00 00       	call   8010584f <initlock>
          m->last = 0;
80105568:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010556b:	c7 40 50 00 00 00 00 	movl   $0x0,0x50(%eax)
          m->first = 0;
80105572:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105575:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
          return m->id;
8010557c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557f:	8b 40 04             	mov    0x4(%eax),%eax
80105582:	eb 16                	jmp    8010559a <kthread_mutex_alloc+0x90>
        } else {
        	index++;
80105584:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int kthread_mutex_alloc(void){

    int index=0;
    struct kthread_mutex_t *m;

    for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105588:	83 45 f0 58          	addl   $0x58,-0x10(%ebp)
8010558c:	81 7d f0 80 4f 11 80 	cmpl   $0x80114f80,-0x10(%ebp)
80105593:	72 8b                	jb     80105520 <kthread_mutex_alloc+0x16>
        } else {
        	index++;
        }
    }

  return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010559a:	c9                   	leave  
8010559b:	c3                   	ret    

8010559c <kthread_mutex_dealloc>:

int kthread_mutex_dealloc(int mutex_id){
8010559c:	55                   	push   %ebp
8010559d:	89 e5                	mov    %esp,%ebp
8010559f:	83 ec 28             	sub    $0x28,%esp

  struct kthread_mutex_t *m;

  cprintf("1- %d\n", mutex_id);
801055a2:	8b 45 08             	mov    0x8(%ebp),%eax
801055a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a9:	c7 04 24 9e 94 10 80 	movl   $0x8010949e,(%esp)
801055b0:	e8 eb ad ff ff       	call   801003a0 <cprintf>
  for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
801055b5:	c7 45 f4 80 39 11 80 	movl   $0x80113980,-0xc(%ebp)
801055bc:	eb 79                	jmp    80105637 <kthread_mutex_dealloc+0x9b>


	  if(  m->id== mutex_id ){    //mutesx is not locked
801055be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c1:	8b 40 04             	mov    0x4(%eax),%eax
801055c4:	3b 45 08             	cmp    0x8(%ebp),%eax
801055c7:	75 6a                	jne    80105633 <kthread_mutex_dealloc+0x97>
		  cprintf("id-%d  st-%d  locked %d\n", m->id , m->state, m->locked);
801055c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055cc:	8b 48 08             	mov    0x8(%eax),%ecx
801055cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d2:	8b 10                	mov    (%eax),%edx
801055d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d7:	8b 40 04             	mov    0x4(%eax),%eax
801055da:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801055de:	89 54 24 08          	mov    %edx,0x8(%esp)
801055e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801055e6:	c7 04 24 a5 94 10 80 	movl   $0x801094a5,(%esp)
801055ed:	e8 ae ad ff ff       	call   801003a0 <cprintf>
		  if(  m->state==USED_MUTEX &&  !m->locked ){
801055f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f5:	8b 00                	mov    (%eax),%eax
801055f7:	83 f8 01             	cmp    $0x1,%eax
801055fa:	75 30                	jne    8010562c <kthread_mutex_dealloc+0x90>
801055fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ff:	8b 40 08             	mov    0x8(%eax),%eax
80105602:	85 c0                	test   %eax,%eax
80105604:	75 26                	jne    8010562c <kthread_mutex_dealloc+0x90>
					  m->state = UNUSED_MUTEX;
80105606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					  m->id= -1;
8010560f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105612:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
					  cprintf("dealoc\n");
80105619:	c7 04 24 be 94 10 80 	movl   $0x801094be,(%esp)
80105620:	e8 7b ad ff ff       	call   801003a0 <cprintf>
					  return 0;
80105625:	b8 00 00 00 00       	mov    $0x0,%eax
8010562a:	eb 1d                	jmp    80105649 <kthread_mutex_dealloc+0xad>
		  }
		  return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 16                	jmp    80105649 <kthread_mutex_dealloc+0xad>
int kthread_mutex_dealloc(int mutex_id){

  struct kthread_mutex_t *m;

  cprintf("1- %d\n", mutex_id);
  for ( m= mutextable.mutexes; m < &mutextable.mutexes[MAX_MUTEXES]; m++){
80105633:	83 45 f4 58          	addl   $0x58,-0xc(%ebp)
80105637:	81 7d f4 80 4f 11 80 	cmpl   $0x80114f80,-0xc(%ebp)
8010563e:	0f 82 7a ff ff ff    	jb     801055be <kthread_mutex_dealloc+0x22>
		  }
		  return -1;
        }
  }

  return -1;
80105644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105649:	c9                   	leave  
8010564a:	c3                   	ret    

8010564b <kthread_mutex_lock>:

int kthread_mutex_lock(int mutex_id){
8010564b:	55                   	push   %ebp
8010564c:	89 e5                	mov    %esp,%ebp
8010564e:	83 ec 28             	sub    $0x28,%esp

 // pushcli(); // disable interrupts to avoid deadlock.
  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];
80105651:	8b 45 08             	mov    0x8(%ebp),%eax
80105654:	6b c0 58             	imul   $0x58,%eax,%eax
80105657:	05 80 39 11 80       	add    $0x80113980,%eax
8010565c:	89 45 f4             	mov    %eax,-0xc(%ebp)



  if (m->state==UNUSED_MUTEX){
8010565f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105662:	8b 00                	mov    (%eax),%eax
80105664:	85 c0                	test   %eax,%eax
80105666:	75 07                	jne    8010566f <kthread_mutex_lock+0x24>

		return -1;
80105668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566d:	eb 76                	jmp    801056e5 <kthread_mutex_lock+0x9a>
  }
  acquire(m->queueLock);
8010566f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105672:	8b 40 54             	mov    0x54(%eax),%eax
80105675:	89 04 24             	mov    %eax,(%esp)
80105678:	e8 f3 01 00 00       	call   80105870 <acquire>
  if (m->locked == 1){ //mutex is locked so push the thread into the queue
8010567d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105680:	8b 40 08             	mov    0x8(%eax),%eax
80105683:	83 f8 01             	cmp    $0x1,%eax
80105686:	75 40                	jne    801056c8 <kthread_mutex_lock+0x7d>
	 //   cprintf("the mutax is locked so thread %d is queued\n", thread->pid);
		pushThreadToMutexQueue(thread, m);
80105688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105691:	89 54 24 04          	mov    %edx,0x4(%esp)
80105695:	89 04 24             	mov    %eax,(%esp)
80105698:	e8 af fd ff ff       	call   8010544c <pushThreadToMutexQueue>
		acquire(&ptable.lock);
8010569d:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801056a4:	e8 c7 01 00 00       	call   80105870 <acquire>

		release(m->queueLock);
801056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ac:	8b 40 54             	mov    0x54(%eax),%eax
801056af:	89 04 24             	mov    %eax,(%esp)
801056b2:	e8 1b 02 00 00       	call   801058d2 <release>
		sched();
801056b7:	e8 4f f6 ff ff       	call   80104d0b <sched>
		release(&ptable.lock);
801056bc:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
801056c3:	e8 0a 02 00 00       	call   801058d2 <release>

  }
 // cprintf("the mutax is unlocked so thread %d is locking it\n", thread->pid);
  m->locked = 1;
801056c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

  release(m->queueLock);
801056d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d5:	8b 40 54             	mov    0x54(%eax),%eax
801056d8:	89 04 24             	mov    %eax,(%esp)
801056db:	e8 f2 01 00 00       	call   801058d2 <release>
  return 0;
801056e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    

801056e7 <kthread_mutex_unlock>:

int kthread_mutex_unlock(int mutex_id){
801056e7:	55                   	push   %ebp
801056e8:	89 e5                	mov    %esp,%ebp
801056ea:	83 ec 28             	sub    $0x28,%esp



  struct kthread_mutex_t *m = &mutextable.mutexes[mutex_id];
801056ed:	8b 45 08             	mov    0x8(%ebp),%eax
801056f0:	6b c0 58             	imul   $0x58,%eax,%eax
801056f3:	05 80 39 11 80       	add    $0x80113980,%eax
801056f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct thread *t;

  if (m->state==UNUSED_MUTEX){
801056fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fe:	8b 00                	mov    (%eax),%eax
80105700:	85 c0                	test   %eax,%eax
80105702:	75 0a                	jne    8010570e <kthread_mutex_unlock+0x27>

			return -1;
80105704:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105709:	e9 90 00 00 00       	jmp    8010579e <kthread_mutex_unlock+0xb7>
	  }
  acquire(m->queueLock);
8010570e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105711:	8b 40 54             	mov    0x54(%eax),%eax
80105714:	89 04 24             	mov    %eax,(%esp)
80105717:	e8 54 01 00 00       	call   80105870 <acquire>

  if(m->locked == 0){   //mutex is unlocked already
8010571c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571f:	8b 40 08             	mov    0x8(%eax),%eax
80105722:	85 c0                	test   %eax,%eax
80105724:	75 15                	jne    8010573b <kthread_mutex_unlock+0x54>
	  release(m->queueLock);
80105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105729:	8b 40 54             	mov    0x54(%eax),%eax
8010572c:	89 04 24             	mov    %eax,(%esp)
8010572f:	e8 9e 01 00 00       	call   801058d2 <release>
	  return -1;
80105734:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105739:	eb 63                	jmp    8010579e <kthread_mutex_unlock+0xb7>
  }

  if(!EmptyQueue(m)){ // someone is waiting
8010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573e:	89 04 24             	mov    %eax,(%esp)
80105741:	e8 f3 fc ff ff       	call   80105439 <EmptyQueue>
80105746:	85 c0                	test   %eax,%eax
80105748:	75 37                	jne    80105781 <kthread_mutex_unlock+0x9a>
      t =  popThreadToMutexQueue(m);
8010574a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574d:	89 04 24             	mov    %eax,(%esp)
80105750:	e8 35 fd ff ff       	call   8010548a <popThreadToMutexQueue>
80105755:	89 45 f0             	mov    %eax,-0x10(%ebp)
      acquire(&ptable.lock);
80105758:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010575f:	e8 0c 01 00 00       	call   80105870 <acquire>
      t->state = RUNNABLE;
80105764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105767:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
      release(&ptable.lock);
8010576e:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80105775:	e8 58 01 00 00       	call   801058d2 <release>
      return 0;
8010577a:	b8 00 00 00 00       	mov    $0x0,%eax
8010577f:	eb 1d                	jmp    8010579e <kthread_mutex_unlock+0xb7>
  }

  //no one is waiting
  m->locked = 0;
80105781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105784:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  release(m->queueLock);
8010578b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010578e:	8b 40 54             	mov    0x54(%eax),%eax
80105791:	89 04 24             	mov    %eax,(%esp)
80105794:	e8 39 01 00 00       	call   801058d2 <release>
  return 0;
80105799:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <kthread_mutex_yieldlock>:



int kthread_mutex_yieldlock(int mutex_id1, int mutex_id2){
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 28             	sub    $0x28,%esp
  struct kthread_mutex_t *m1, *m2;
  struct thread *t=0;
801057a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  m1 = &mutextable.mutexes[mutex_id1];
801057ad:	8b 45 08             	mov    0x8(%ebp),%eax
801057b0:	6b c0 58             	imul   $0x58,%eax,%eax
801057b3:	05 80 39 11 80       	add    $0x80113980,%eax
801057b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m2 = &mutextable.mutexes[mutex_id2];
801057bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801057be:	6b c0 58             	imul   $0x58,%eax,%eax
801057c1:	05 80 39 11 80       	add    $0x80113980,%eax
801057c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if(m1->locked == 0){
801057c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057cc:	8b 40 08             	mov    0x8(%eax),%eax
801057cf:	85 c0                	test   %eax,%eax
801057d1:	75 07                	jne    801057da <kthread_mutex_yieldlock+0x3a>
    return -1;
801057d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d8:	eb 3d                	jmp    80105817 <kthread_mutex_yieldlock+0x77>
  }

  if (!EmptyQueue(m2)){ 					//someone is waiting in mutex_id2
801057da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057dd:	89 04 24             	mov    %eax,(%esp)
801057e0:	e8 54 fc ff ff       	call   80105439 <EmptyQueue>
801057e5:	85 c0                	test   %eax,%eax
801057e7:	75 1f                	jne    80105808 <kthread_mutex_yieldlock+0x68>
   t =  popThreadToMutexQueue( m2);
801057e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057ec:	89 04 24             	mov    %eax,(%esp)
801057ef:	e8 96 fc ff ff       	call   8010548a <popThreadToMutexQueue>
801057f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   t->state = RUNNABLE;
801057f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fa:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
   return 0;
80105801:	b8 00 00 00 00       	mov    $0x0,%eax
80105806:	eb 0f                	jmp    80105817 <kthread_mutex_yieldlock+0x77>
  }

  // no one is waiting in mutex_id2
   m2->locked = 0;
80105808:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010580b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
   return 0;
80105812:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105817:	c9                   	leave  
80105818:	c3                   	ret    

80105819 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105819:	55                   	push   %ebp
8010581a:	89 e5                	mov    %esp,%ebp
8010581c:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010581f:	9c                   	pushf  
80105820:	58                   	pop    %eax
80105821:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105824:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105827:	c9                   	leave  
80105828:	c3                   	ret    

80105829 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105829:	55                   	push   %ebp
8010582a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010582c:	fa                   	cli    
}
8010582d:	5d                   	pop    %ebp
8010582e:	c3                   	ret    

8010582f <sti>:

static inline void
sti(void)
{
8010582f:	55                   	push   %ebp
80105830:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105832:	fb                   	sti    
}
80105833:	5d                   	pop    %ebp
80105834:	c3                   	ret    

80105835 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105835:	55                   	push   %ebp
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010583b:	8b 55 08             	mov    0x8(%ebp),%edx
8010583e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105841:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105844:	f0 87 02             	lock xchg %eax,(%edx)
80105847:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010584a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    

8010584f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010584f:	55                   	push   %ebp
80105850:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105852:	8b 45 08             	mov    0x8(%ebp),%eax
80105855:	8b 55 0c             	mov    0xc(%ebp),%edx
80105858:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010585b:	8b 45 08             	mov    0x8(%ebp),%eax
8010585e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105864:	8b 45 08             	mov    0x8(%ebp),%eax
80105867:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010586e:	5d                   	pop    %ebp
8010586f:	c3                   	ret    

80105870 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105876:	e8 49 01 00 00       	call   801059c4 <pushcli>
  if(holding(lk))
8010587b:	8b 45 08             	mov    0x8(%ebp),%eax
8010587e:	89 04 24             	mov    %eax,(%esp)
80105881:	e8 14 01 00 00       	call   8010599a <holding>
80105886:	85 c0                	test   %eax,%eax
80105888:	74 0c                	je     80105896 <acquire+0x26>
    panic("acquire");
8010588a:	c7 04 24 f0 94 10 80 	movl   $0x801094f0,(%esp)
80105891:	e8 a4 ac ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0);
80105896:	90                   	nop
80105897:	8b 45 08             	mov    0x8(%ebp),%eax
8010589a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801058a1:	00 
801058a2:	89 04 24             	mov    %eax,(%esp)
801058a5:	e8 8b ff ff ff       	call   80105835 <xchg>
801058aa:	85 c0                	test   %eax,%eax
801058ac:	75 e9                	jne    80105897 <acquire+0x27>

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801058ae:	8b 45 08             	mov    0x8(%ebp),%eax
801058b1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801058b8:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801058bb:	8b 45 08             	mov    0x8(%ebp),%eax
801058be:	83 c0 0c             	add    $0xc,%eax
801058c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c5:	8d 45 08             	lea    0x8(%ebp),%eax
801058c8:	89 04 24             	mov    %eax,(%esp)
801058cb:	e8 51 00 00 00       	call   80105921 <getcallerpcs>
}
801058d0:	c9                   	leave  
801058d1:	c3                   	ret    

801058d2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801058d2:	55                   	push   %ebp
801058d3:	89 e5                	mov    %esp,%ebp
801058d5:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801058d8:	8b 45 08             	mov    0x8(%ebp),%eax
801058db:	89 04 24             	mov    %eax,(%esp)
801058de:	e8 b7 00 00 00       	call   8010599a <holding>
801058e3:	85 c0                	test   %eax,%eax
801058e5:	75 0c                	jne    801058f3 <release+0x21>
    panic("release");
801058e7:	c7 04 24 f8 94 10 80 	movl   $0x801094f8,(%esp)
801058ee:	e8 47 ac ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
801058f3:	8b 45 08             	mov    0x8(%ebp),%eax
801058f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801058fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105900:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105907:	8b 45 08             	mov    0x8(%ebp),%eax
8010590a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105911:	00 
80105912:	89 04 24             	mov    %eax,(%esp)
80105915:	e8 1b ff ff ff       	call   80105835 <xchg>

  popcli();
8010591a:	e8 e9 00 00 00       	call   80105a08 <popcli>
}
8010591f:	c9                   	leave  
80105920:	c3                   	ret    

80105921 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105921:	55                   	push   %ebp
80105922:	89 e5                	mov    %esp,%ebp
80105924:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105927:	8b 45 08             	mov    0x8(%ebp),%eax
8010592a:	83 e8 08             	sub    $0x8,%eax
8010592d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105930:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105937:	eb 38                	jmp    80105971 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105939:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010593d:	74 38                	je     80105977 <getcallerpcs+0x56>
8010593f:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105946:	76 2f                	jbe    80105977 <getcallerpcs+0x56>
80105948:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010594c:	74 29                	je     80105977 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010594e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105958:	8b 45 0c             	mov    0xc(%ebp),%eax
8010595b:	01 c2                	add    %eax,%edx
8010595d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105960:	8b 40 04             	mov    0x4(%eax),%eax
80105963:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105965:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105968:	8b 00                	mov    (%eax),%eax
8010596a:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010596d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105971:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105975:	7e c2                	jle    80105939 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105977:	eb 19                	jmp    80105992 <getcallerpcs+0x71>
    pcs[i] = 0;
80105979:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010597c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105983:	8b 45 0c             	mov    0xc(%ebp),%eax
80105986:	01 d0                	add    %edx,%eax
80105988:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010598e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105992:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105996:	7e e1                	jle    80105979 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105998:	c9                   	leave  
80105999:	c3                   	ret    

8010599a <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010599a:	55                   	push   %ebp
8010599b:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010599d:	8b 45 08             	mov    0x8(%ebp),%eax
801059a0:	8b 00                	mov    (%eax),%eax
801059a2:	85 c0                	test   %eax,%eax
801059a4:	74 17                	je     801059bd <holding+0x23>
801059a6:	8b 45 08             	mov    0x8(%ebp),%eax
801059a9:	8b 50 08             	mov    0x8(%eax),%edx
801059ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801059b2:	39 c2                	cmp    %eax,%edx
801059b4:	75 07                	jne    801059bd <holding+0x23>
801059b6:	b8 01 00 00 00       	mov    $0x1,%eax
801059bb:	eb 05                	jmp    801059c2 <holding+0x28>
801059bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059c2:	5d                   	pop    %ebp
801059c3:	c3                   	ret    

801059c4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801059ca:	e8 4a fe ff ff       	call   80105819 <readeflags>
801059cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801059d2:	e8 52 fe ff ff       	call   80105829 <cli>
  if(cpu->ncli++ == 0)
801059d7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801059de:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801059e4:	8d 48 01             	lea    0x1(%eax),%ecx
801059e7:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801059ed:	85 c0                	test   %eax,%eax
801059ef:	75 15                	jne    80105a06 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801059f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801059f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059fa:	81 e2 00 02 00 00    	and    $0x200,%edx
80105a00:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105a06:	c9                   	leave  
80105a07:	c3                   	ret    

80105a08 <popcli>:

void
popcli(void)
{
80105a08:	55                   	push   %ebp
80105a09:	89 e5                	mov    %esp,%ebp
80105a0b:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105a0e:	e8 06 fe ff ff       	call   80105819 <readeflags>
80105a13:	25 00 02 00 00       	and    $0x200,%eax
80105a18:	85 c0                	test   %eax,%eax
80105a1a:	74 0c                	je     80105a28 <popcli+0x20>
    panic("popcli - interruptible");
80105a1c:	c7 04 24 00 95 10 80 	movl   $0x80109500,(%esp)
80105a23:	e8 12 ab ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105a28:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a2e:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105a34:	83 ea 01             	sub    $0x1,%edx
80105a37:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105a3d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105a43:	85 c0                	test   %eax,%eax
80105a45:	79 0c                	jns    80105a53 <popcli+0x4b>
    panic("popcli");
80105a47:	c7 04 24 17 95 10 80 	movl   $0x80109517,(%esp)
80105a4e:	e8 e7 aa ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105a53:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a59:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	75 15                	jne    80105a78 <popcli+0x70>
80105a63:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a69:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105a6f:	85 c0                	test   %eax,%eax
80105a71:	74 05                	je     80105a78 <popcli+0x70>
    sti();
80105a73:	e8 b7 fd ff ff       	call   8010582f <sti>
}
80105a78:	c9                   	leave  
80105a79:	c3                   	ret    

80105a7a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105a7a:	55                   	push   %ebp
80105a7b:	89 e5                	mov    %esp,%ebp
80105a7d:	57                   	push   %edi
80105a7e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105a7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a82:	8b 55 10             	mov    0x10(%ebp),%edx
80105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a88:	89 cb                	mov    %ecx,%ebx
80105a8a:	89 df                	mov    %ebx,%edi
80105a8c:	89 d1                	mov    %edx,%ecx
80105a8e:	fc                   	cld    
80105a8f:	f3 aa                	rep stos %al,%es:(%edi)
80105a91:	89 ca                	mov    %ecx,%edx
80105a93:	89 fb                	mov    %edi,%ebx
80105a95:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a98:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105a9b:	5b                   	pop    %ebx
80105a9c:	5f                   	pop    %edi
80105a9d:	5d                   	pop    %ebp
80105a9e:	c3                   	ret    

80105a9f <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105a9f:	55                   	push   %ebp
80105aa0:	89 e5                	mov    %esp,%ebp
80105aa2:	57                   	push   %edi
80105aa3:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105aa7:	8b 55 10             	mov    0x10(%ebp),%edx
80105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aad:	89 cb                	mov    %ecx,%ebx
80105aaf:	89 df                	mov    %ebx,%edi
80105ab1:	89 d1                	mov    %edx,%ecx
80105ab3:	fc                   	cld    
80105ab4:	f3 ab                	rep stos %eax,%es:(%edi)
80105ab6:	89 ca                	mov    %ecx,%edx
80105ab8:	89 fb                	mov    %edi,%ebx
80105aba:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105abd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105ac0:	5b                   	pop    %ebx
80105ac1:	5f                   	pop    %edi
80105ac2:	5d                   	pop    %ebp
80105ac3:	c3                   	ret    

80105ac4 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105aca:	8b 45 08             	mov    0x8(%ebp),%eax
80105acd:	83 e0 03             	and    $0x3,%eax
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	75 49                	jne    80105b1d <memset+0x59>
80105ad4:	8b 45 10             	mov    0x10(%ebp),%eax
80105ad7:	83 e0 03             	and    $0x3,%eax
80105ada:	85 c0                	test   %eax,%eax
80105adc:	75 3f                	jne    80105b1d <memset+0x59>
    c &= 0xFF;
80105ade:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ae8:	c1 e8 02             	shr    $0x2,%eax
80105aeb:	89 c2                	mov    %eax,%edx
80105aed:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af0:	c1 e0 18             	shl    $0x18,%eax
80105af3:	89 c1                	mov    %eax,%ecx
80105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af8:	c1 e0 10             	shl    $0x10,%eax
80105afb:	09 c1                	or     %eax,%ecx
80105afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b00:	c1 e0 08             	shl    $0x8,%eax
80105b03:	09 c8                	or     %ecx,%eax
80105b05:	0b 45 0c             	or     0xc(%ebp),%eax
80105b08:	89 54 24 08          	mov    %edx,0x8(%esp)
80105b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b10:	8b 45 08             	mov    0x8(%ebp),%eax
80105b13:	89 04 24             	mov    %eax,(%esp)
80105b16:	e8 84 ff ff ff       	call   80105a9f <stosl>
80105b1b:	eb 19                	jmp    80105b36 <memset+0x72>
  } else
    stosb(dst, c, n);
80105b1d:	8b 45 10             	mov    0x10(%ebp),%eax
80105b20:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b27:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80105b2e:	89 04 24             	mov    %eax,(%esp)
80105b31:	e8 44 ff ff ff       	call   80105a7a <stosb>
  return dst;
80105b36:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105b39:	c9                   	leave  
80105b3a:	c3                   	ret    

80105b3b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105b3b:	55                   	push   %ebp
80105b3c:	89 e5                	mov    %esp,%ebp
80105b3e:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105b41:	8b 45 08             	mov    0x8(%ebp),%eax
80105b44:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105b47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105b4d:	eb 30                	jmp    80105b7f <memcmp+0x44>
    if(*s1 != *s2)
80105b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b52:	0f b6 10             	movzbl (%eax),%edx
80105b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b58:	0f b6 00             	movzbl (%eax),%eax
80105b5b:	38 c2                	cmp    %al,%dl
80105b5d:	74 18                	je     80105b77 <memcmp+0x3c>
      return *s1 - *s2;
80105b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b62:	0f b6 00             	movzbl (%eax),%eax
80105b65:	0f b6 d0             	movzbl %al,%edx
80105b68:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b6b:	0f b6 00             	movzbl (%eax),%eax
80105b6e:	0f b6 c0             	movzbl %al,%eax
80105b71:	29 c2                	sub    %eax,%edx
80105b73:	89 d0                	mov    %edx,%eax
80105b75:	eb 1a                	jmp    80105b91 <memcmp+0x56>
    s1++, s2++;
80105b77:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b7b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105b7f:	8b 45 10             	mov    0x10(%ebp),%eax
80105b82:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b85:	89 55 10             	mov    %edx,0x10(%ebp)
80105b88:	85 c0                	test   %eax,%eax
80105b8a:	75 c3                	jne    80105b4f <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b91:	c9                   	leave  
80105b92:	c3                   	ret    

80105b93 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105b93:	55                   	push   %ebp
80105b94:	89 e5                	mov    %esp,%ebp
80105b96:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80105ba2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ba8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105bab:	73 3d                	jae    80105bea <memmove+0x57>
80105bad:	8b 45 10             	mov    0x10(%ebp),%eax
80105bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bb3:	01 d0                	add    %edx,%eax
80105bb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105bb8:	76 30                	jbe    80105bea <memmove+0x57>
    s += n;
80105bba:	8b 45 10             	mov    0x10(%ebp),%eax
80105bbd:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105bc0:	8b 45 10             	mov    0x10(%ebp),%eax
80105bc3:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105bc6:	eb 13                	jmp    80105bdb <memmove+0x48>
      *--d = *--s;
80105bc8:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105bcc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd3:	0f b6 10             	movzbl (%eax),%edx
80105bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105bd9:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105bdb:	8b 45 10             	mov    0x10(%ebp),%eax
80105bde:	8d 50 ff             	lea    -0x1(%eax),%edx
80105be1:	89 55 10             	mov    %edx,0x10(%ebp)
80105be4:	85 c0                	test   %eax,%eax
80105be6:	75 e0                	jne    80105bc8 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105be8:	eb 26                	jmp    80105c10 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105bea:	eb 17                	jmp    80105c03 <memmove+0x70>
      *d++ = *s++;
80105bec:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105bef:	8d 50 01             	lea    0x1(%eax),%edx
80105bf2:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105bf5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bf8:	8d 4a 01             	lea    0x1(%edx),%ecx
80105bfb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105bfe:	0f b6 12             	movzbl (%edx),%edx
80105c01:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105c03:	8b 45 10             	mov    0x10(%ebp),%eax
80105c06:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c09:	89 55 10             	mov    %edx,0x10(%ebp)
80105c0c:	85 c0                	test   %eax,%eax
80105c0e:	75 dc                	jne    80105bec <memmove+0x59>
      *d++ = *s++;

  return dst;
80105c10:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105c13:	c9                   	leave  
80105c14:	c3                   	ret    

80105c15 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105c15:	55                   	push   %ebp
80105c16:	89 e5                	mov    %esp,%ebp
80105c18:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105c1b:	8b 45 10             	mov    0x10(%ebp),%eax
80105c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c29:	8b 45 08             	mov    0x8(%ebp),%eax
80105c2c:	89 04 24             	mov    %eax,(%esp)
80105c2f:	e8 5f ff ff ff       	call   80105b93 <memmove>
}
80105c34:	c9                   	leave  
80105c35:	c3                   	ret    

80105c36 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105c36:	55                   	push   %ebp
80105c37:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105c39:	eb 0c                	jmp    80105c47 <strncmp+0x11>
    n--, p++, q++;
80105c3b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105c3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105c43:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c4b:	74 1a                	je     80105c67 <strncmp+0x31>
80105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80105c50:	0f b6 00             	movzbl (%eax),%eax
80105c53:	84 c0                	test   %al,%al
80105c55:	74 10                	je     80105c67 <strncmp+0x31>
80105c57:	8b 45 08             	mov    0x8(%ebp),%eax
80105c5a:	0f b6 10             	movzbl (%eax),%edx
80105c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c60:	0f b6 00             	movzbl (%eax),%eax
80105c63:	38 c2                	cmp    %al,%dl
80105c65:	74 d4                	je     80105c3b <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105c67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c6b:	75 07                	jne    80105c74 <strncmp+0x3e>
    return 0;
80105c6d:	b8 00 00 00 00       	mov    $0x0,%eax
80105c72:	eb 16                	jmp    80105c8a <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105c74:	8b 45 08             	mov    0x8(%ebp),%eax
80105c77:	0f b6 00             	movzbl (%eax),%eax
80105c7a:	0f b6 d0             	movzbl %al,%edx
80105c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c80:	0f b6 00             	movzbl (%eax),%eax
80105c83:	0f b6 c0             	movzbl %al,%eax
80105c86:	29 c2                	sub    %eax,%edx
80105c88:	89 d0                	mov    %edx,%eax
}
80105c8a:	5d                   	pop    %ebp
80105c8b:	c3                   	ret    

80105c8c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105c8c:	55                   	push   %ebp
80105c8d:	89 e5                	mov    %esp,%ebp
80105c8f:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105c92:	8b 45 08             	mov    0x8(%ebp),%eax
80105c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105c98:	90                   	nop
80105c99:	8b 45 10             	mov    0x10(%ebp),%eax
80105c9c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c9f:	89 55 10             	mov    %edx,0x10(%ebp)
80105ca2:	85 c0                	test   %eax,%eax
80105ca4:	7e 1e                	jle    80105cc4 <strncpy+0x38>
80105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca9:	8d 50 01             	lea    0x1(%eax),%edx
80105cac:	89 55 08             	mov    %edx,0x8(%ebp)
80105caf:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cb2:	8d 4a 01             	lea    0x1(%edx),%ecx
80105cb5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105cb8:	0f b6 12             	movzbl (%edx),%edx
80105cbb:	88 10                	mov    %dl,(%eax)
80105cbd:	0f b6 00             	movzbl (%eax),%eax
80105cc0:	84 c0                	test   %al,%al
80105cc2:	75 d5                	jne    80105c99 <strncpy+0xd>
    ;
  while(n-- > 0)
80105cc4:	eb 0c                	jmp    80105cd2 <strncpy+0x46>
    *s++ = 0;
80105cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc9:	8d 50 01             	lea    0x1(%eax),%edx
80105ccc:	89 55 08             	mov    %edx,0x8(%ebp)
80105ccf:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105cd2:	8b 45 10             	mov    0x10(%ebp),%eax
80105cd5:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cd8:	89 55 10             	mov    %edx,0x10(%ebp)
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	7f e7                	jg     80105cc6 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    

80105ce4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105cea:	8b 45 08             	mov    0x8(%ebp),%eax
80105ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105cf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105cf4:	7f 05                	jg     80105cfb <safestrcpy+0x17>
    return os;
80105cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cf9:	eb 31                	jmp    80105d2c <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105cfb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d03:	7e 1e                	jle    80105d23 <safestrcpy+0x3f>
80105d05:	8b 45 08             	mov    0x8(%ebp),%eax
80105d08:	8d 50 01             	lea    0x1(%eax),%edx
80105d0b:	89 55 08             	mov    %edx,0x8(%ebp)
80105d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d11:	8d 4a 01             	lea    0x1(%edx),%ecx
80105d14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105d17:	0f b6 12             	movzbl (%edx),%edx
80105d1a:	88 10                	mov    %dl,(%eax)
80105d1c:	0f b6 00             	movzbl (%eax),%eax
80105d1f:	84 c0                	test   %al,%al
80105d21:	75 d8                	jne    80105cfb <safestrcpy+0x17>
    ;
  *s = 0;
80105d23:	8b 45 08             	mov    0x8(%ebp),%eax
80105d26:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d2c:	c9                   	leave  
80105d2d:	c3                   	ret    

80105d2e <strlen>:

int
strlen(const char *s)
{
80105d2e:	55                   	push   %ebp
80105d2f:	89 e5                	mov    %esp,%ebp
80105d31:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105d34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d3b:	eb 04                	jmp    80105d41 <strlen+0x13>
80105d3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d41:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d44:	8b 45 08             	mov    0x8(%ebp),%eax
80105d47:	01 d0                	add    %edx,%eax
80105d49:	0f b6 00             	movzbl (%eax),%eax
80105d4c:	84 c0                	test   %al,%al
80105d4e:	75 ed                	jne    80105d3d <strlen+0xf>
    ;
  return n;
80105d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d53:	c9                   	leave  
80105d54:	c3                   	ret    

80105d55 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105d55:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105d59:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105d5d:	55                   	push   %ebp
  pushl %ebx
80105d5e:	53                   	push   %ebx
  pushl %esi
80105d5f:	56                   	push   %esi
  pushl %edi
80105d60:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105d61:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105d63:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105d65:	5f                   	pop    %edi
  popl %esi
80105d66:	5e                   	pop    %esi
  popl %ebx
80105d67:	5b                   	pop    %ebx
  popl %ebp
80105d68:	5d                   	pop    %ebp
  ret
80105d69:	c3                   	ret    

80105d6a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105d6a:	55                   	push   %ebp
80105d6b:	89 e5                	mov    %esp,%ebp
  if(addr >= thread->proc->sz || addr+4 > thread->proc->sz)
80105d6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d73:	8b 40 0c             	mov    0xc(%eax),%eax
80105d76:	8b 00                	mov    (%eax),%eax
80105d78:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d7b:	76 15                	jbe    80105d92 <fetchint+0x28>
80105d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80105d80:	8d 50 04             	lea    0x4(%eax),%edx
80105d83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d89:	8b 40 0c             	mov    0xc(%eax),%eax
80105d8c:	8b 00                	mov    (%eax),%eax
80105d8e:	39 c2                	cmp    %eax,%edx
80105d90:	76 07                	jbe    80105d99 <fetchint+0x2f>
    return -1;
80105d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d97:	eb 0f                	jmp    80105da8 <fetchint+0x3e>
  *ip = *(int*)(addr);
80105d99:	8b 45 08             	mov    0x8(%ebp),%eax
80105d9c:	8b 10                	mov    (%eax),%edx
80105d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105da1:	89 10                	mov    %edx,(%eax)
  return 0;
80105da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105da8:	5d                   	pop    %ebp
80105da9:	c3                   	ret    

80105daa <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105daa:	55                   	push   %ebp
80105dab:	89 e5                	mov    %esp,%ebp
80105dad:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= thread->proc->sz)
80105db0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105db6:	8b 40 0c             	mov    0xc(%eax),%eax
80105db9:	8b 00                	mov    (%eax),%eax
80105dbb:	3b 45 08             	cmp    0x8(%ebp),%eax
80105dbe:	77 07                	ja     80105dc7 <fetchstr+0x1d>
    return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	eb 49                	jmp    80105e10 <fetchstr+0x66>
  *pp = (char*)addr;
80105dc7:	8b 55 08             	mov    0x8(%ebp),%edx
80105dca:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dcd:	89 10                	mov    %edx,(%eax)
  ep = (char*)thread->proc->sz;
80105dcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dd5:	8b 40 0c             	mov    0xc(%eax),%eax
80105dd8:	8b 00                	mov    (%eax),%eax
80105dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de0:	8b 00                	mov    (%eax),%eax
80105de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105de5:	eb 1c                	jmp    80105e03 <fetchstr+0x59>
    if(*s == 0)
80105de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105dea:	0f b6 00             	movzbl (%eax),%eax
80105ded:	84 c0                	test   %al,%al
80105def:	75 0e                	jne    80105dff <fetchstr+0x55>
      return s - *pp;
80105df1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105df7:	8b 00                	mov    (%eax),%eax
80105df9:	29 c2                	sub    %eax,%edx
80105dfb:	89 d0                	mov    %edx,%eax
80105dfd:	eb 11                	jmp    80105e10 <fetchstr+0x66>

  if(addr >= thread->proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)thread->proc->sz;
  for(s = *pp; s < ep; s++)
80105dff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105e09:	72 dc                	jb     80105de7 <fetchstr+0x3d>
    if(*s == 0)
      return s - *pp;
  return -1;
80105e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e10:	c9                   	leave  
80105e11:	c3                   	ret    

80105e12 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105e12:	55                   	push   %ebp
80105e13:	89 e5                	mov    %esp,%ebp
80105e15:	83 ec 08             	sub    $0x8,%esp
  return fetchint(thread->tf->esp + 4 + 4*n, ip);
80105e18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e1e:	8b 40 10             	mov    0x10(%eax),%eax
80105e21:	8b 50 44             	mov    0x44(%eax),%edx
80105e24:	8b 45 08             	mov    0x8(%ebp),%eax
80105e27:	c1 e0 02             	shl    $0x2,%eax
80105e2a:	01 d0                	add    %edx,%eax
80105e2c:	8d 50 04             	lea    0x4(%eax),%edx
80105e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e32:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e36:	89 14 24             	mov    %edx,(%esp)
80105e39:	e8 2c ff ff ff       	call   80105d6a <fetchint>
}
80105e3e:	c9                   	leave  
80105e3f:	c3                   	ret    

80105e40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105e46:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105e49:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80105e50:	89 04 24             	mov    %eax,(%esp)
80105e53:	e8 ba ff ff ff       	call   80105e12 <argint>
80105e58:	85 c0                	test   %eax,%eax
80105e5a:	79 07                	jns    80105e63 <argptr+0x23>
    return -1;
80105e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e61:	eb 43                	jmp    80105ea6 <argptr+0x66>
  if((uint)i >= thread->proc->sz || (uint)i+size > thread->proc->sz)
80105e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e66:	89 c2                	mov    %eax,%edx
80105e68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e6e:	8b 40 0c             	mov    0xc(%eax),%eax
80105e71:	8b 00                	mov    (%eax),%eax
80105e73:	39 c2                	cmp    %eax,%edx
80105e75:	73 19                	jae    80105e90 <argptr+0x50>
80105e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e7a:	89 c2                	mov    %eax,%edx
80105e7c:	8b 45 10             	mov    0x10(%ebp),%eax
80105e7f:	01 c2                	add    %eax,%edx
80105e81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e87:	8b 40 0c             	mov    0xc(%eax),%eax
80105e8a:	8b 00                	mov    (%eax),%eax
80105e8c:	39 c2                	cmp    %eax,%edx
80105e8e:	76 07                	jbe    80105e97 <argptr+0x57>
    return -1;
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e95:	eb 0f                	jmp    80105ea6 <argptr+0x66>
  *pp = (char*)i;
80105e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e9a:	89 c2                	mov    %eax,%edx
80105e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e9f:	89 10                	mov    %edx,(%eax)
  return 0;
80105ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ea6:	c9                   	leave  
80105ea7:	c3                   	ret    

80105ea8 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ea8:	55                   	push   %ebp
80105ea9:	89 e5                	mov    %esp,%ebp
80105eab:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105eae:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80105eb8:	89 04 24             	mov    %eax,(%esp)
80105ebb:	e8 52 ff ff ff       	call   80105e12 <argint>
80105ec0:	85 c0                	test   %eax,%eax
80105ec2:	79 07                	jns    80105ecb <argstr+0x23>
    return -1;
80105ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec9:	eb 12                	jmp    80105edd <argstr+0x35>
  return fetchstr(addr, pp);
80105ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ece:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ed5:	89 04 24             	mov    %eax,(%esp)
80105ed8:	e8 cd fe ff ff       	call   80105daa <fetchstr>
}
80105edd:	c9                   	leave  
80105ede:	c3                   	ret    

80105edf <syscall>:

};

void
syscall(void)
{
80105edf:	55                   	push   %ebp
80105ee0:	89 e5                	mov    %esp,%ebp
80105ee2:	53                   	push   %ebx
80105ee3:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = thread->tf->eax;
80105ee6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eec:	8b 40 10             	mov    0x10(%eax),%eax
80105eef:	8b 40 1c             	mov    0x1c(%eax),%eax
80105ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ef9:	7e 30                	jle    80105f2b <syscall+0x4c>
80105efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efe:	83 f8 1e             	cmp    $0x1e,%eax
80105f01:	77 28                	ja     80105f2b <syscall+0x4c>
80105f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f06:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	74 1a                	je     80105f2b <syscall+0x4c>
    thread->tf->eax = syscalls[num]();
80105f11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f17:	8b 58 10             	mov    0x10(%eax),%ebx
80105f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f1d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105f24:	ff d0                	call   *%eax
80105f26:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105f29:	eb 43                	jmp    80105f6e <syscall+0x8f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            thread->proc->pid, thread->proc->name, num);
80105f2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f31:	8b 40 0c             	mov    0xc(%eax),%eax
80105f34:	8d 48 60             	lea    0x60(%eax),%ecx
80105f37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f3d:	8b 40 0c             	mov    0xc(%eax),%eax

  num = thread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    thread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105f40:	8b 40 0c             	mov    0xc(%eax),%eax
80105f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f46:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105f4a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f52:	c7 04 24 1e 95 10 80 	movl   $0x8010951e,(%esp)
80105f59:	e8 42 a4 ff ff       	call   801003a0 <cprintf>
            thread->proc->pid, thread->proc->name, num);
    thread->tf->eax = -1;
80105f5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f64:	8b 40 10             	mov    0x10(%eax),%eax
80105f67:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105f6e:	83 c4 24             	add    $0x24,%esp
80105f71:	5b                   	pop    %ebx
80105f72:	5d                   	pop    %ebp
80105f73:	c3                   	ret    

80105f74 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105f7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f81:	8b 45 08             	mov    0x8(%ebp),%eax
80105f84:	89 04 24             	mov    %eax,(%esp)
80105f87:	e8 86 fe ff ff       	call   80105e12 <argint>
80105f8c:	85 c0                	test   %eax,%eax
80105f8e:	79 07                	jns    80105f97 <argfd+0x23>
    return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f95:	eb 53                	jmp    80105fea <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=thread->proc->ofile[fd]) == 0)
80105f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	78 24                	js     80105fc2 <argfd+0x4e>
80105f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa1:	83 f8 0f             	cmp    $0xf,%eax
80105fa4:	7f 1c                	jg     80105fc2 <argfd+0x4e>
80105fa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fac:	8b 40 0c             	mov    0xc(%eax),%eax
80105faf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fb2:	83 c2 04             	add    $0x4,%edx
80105fb5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fc0:	75 07                	jne    80105fc9 <argfd+0x55>
    return -1;
80105fc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc7:	eb 21                	jmp    80105fea <argfd+0x76>
  if(pfd)
80105fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105fcd:	74 08                	je     80105fd7 <argfd+0x63>
    *pfd = fd;
80105fcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fd5:	89 10                	mov    %edx,(%eax)
  if(pf)
80105fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105fdb:	74 08                	je     80105fe5 <argfd+0x71>
    *pf = f;
80105fdd:	8b 45 10             	mov    0x10(%ebp),%eax
80105fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fe3:	89 10                	mov    %edx,(%eax)
  return 0;
80105fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fea:	c9                   	leave  
80105feb:	c3                   	ret    

80105fec <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105fec:	55                   	push   %ebp
80105fed:	89 e5                	mov    %esp,%ebp
80105fef:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ff2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ff9:	eb 36                	jmp    80106031 <fdalloc+0x45>
    if(thread->proc->ofile[fd] == 0){
80105ffb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106001:	8b 40 0c             	mov    0xc(%eax),%eax
80106004:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106007:	83 c2 04             	add    $0x4,%edx
8010600a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010600e:	85 c0                	test   %eax,%eax
80106010:	75 1b                	jne    8010602d <fdalloc+0x41>
      thread->proc->ofile[fd] = f;
80106012:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106018:	8b 40 0c             	mov    0xc(%eax),%eax
8010601b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010601e:	8d 4a 04             	lea    0x4(%edx),%ecx
80106021:	8b 55 08             	mov    0x8(%ebp),%edx
80106024:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
      return fd;
80106028:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010602b:	eb 0f                	jmp    8010603c <fdalloc+0x50>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010602d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106031:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106035:	7e c4                	jle    80105ffb <fdalloc+0xf>
    if(thread->proc->ofile[fd] == 0){
      thread->proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010603c:	c9                   	leave  
8010603d:	c3                   	ret    

8010603e <sys_dup>:

int
sys_dup(void)
{
8010603e:	55                   	push   %ebp
8010603f:	89 e5                	mov    %esp,%ebp
80106041:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106044:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106047:	89 44 24 08          	mov    %eax,0x8(%esp)
8010604b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106052:	00 
80106053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010605a:	e8 15 ff ff ff       	call   80105f74 <argfd>
8010605f:	85 c0                	test   %eax,%eax
80106061:	79 07                	jns    8010606a <sys_dup+0x2c>
    return -1;
80106063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106068:	eb 29                	jmp    80106093 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010606a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606d:	89 04 24             	mov    %eax,(%esp)
80106070:	e8 77 ff ff ff       	call   80105fec <fdalloc>
80106075:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010607c:	79 07                	jns    80106085 <sys_dup+0x47>
    return -1;
8010607e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106083:	eb 0e                	jmp    80106093 <sys_dup+0x55>
  filedup(f);
80106085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106088:	89 04 24             	mov    %eax,(%esp)
8010608b:	e8 18 af ff ff       	call   80100fa8 <filedup>
  return fd;
80106090:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106093:	c9                   	leave  
80106094:	c3                   	ret    

80106095 <sys_read>:

int
sys_read(void)
{
80106095:	55                   	push   %ebp
80106096:	89 e5                	mov    %esp,%ebp
80106098:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010609b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010609e:	89 44 24 08          	mov    %eax,0x8(%esp)
801060a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060a9:	00 
801060aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b1:	e8 be fe ff ff       	call   80105f74 <argfd>
801060b6:	85 c0                	test   %eax,%eax
801060b8:	78 35                	js     801060ef <sys_read+0x5a>
801060ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060c8:	e8 45 fd ff ff       	call   80105e12 <argint>
801060cd:	85 c0                	test   %eax,%eax
801060cf:	78 1e                	js     801060ef <sys_read+0x5a>
801060d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801060d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060db:	89 44 24 04          	mov    %eax,0x4(%esp)
801060df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060e6:	e8 55 fd ff ff       	call   80105e40 <argptr>
801060eb:	85 c0                	test   %eax,%eax
801060ed:	79 07                	jns    801060f6 <sys_read+0x61>
    return -1;
801060ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f4:	eb 19                	jmp    8010610f <sys_read+0x7a>
  return fileread(f, p, n);
801060f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801060f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106103:	89 54 24 04          	mov    %edx,0x4(%esp)
80106107:	89 04 24             	mov    %eax,(%esp)
8010610a:	e8 06 b0 ff ff       	call   80101115 <fileread>
}
8010610f:	c9                   	leave  
80106110:	c3                   	ret    

80106111 <sys_write>:

int
sys_write(void)
{
80106111:	55                   	push   %ebp
80106112:	89 e5                	mov    %esp,%ebp
80106114:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106117:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010611a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010611e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106125:	00 
80106126:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010612d:	e8 42 fe ff ff       	call   80105f74 <argfd>
80106132:	85 c0                	test   %eax,%eax
80106134:	78 35                	js     8010616b <sys_write+0x5a>
80106136:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106144:	e8 c9 fc ff ff       	call   80105e12 <argint>
80106149:	85 c0                	test   %eax,%eax
8010614b:	78 1e                	js     8010616b <sys_write+0x5a>
8010614d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106150:	89 44 24 08          	mov    %eax,0x8(%esp)
80106154:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106157:	89 44 24 04          	mov    %eax,0x4(%esp)
8010615b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106162:	e8 d9 fc ff ff       	call   80105e40 <argptr>
80106167:	85 c0                	test   %eax,%eax
80106169:	79 07                	jns    80106172 <sys_write+0x61>
    return -1;
8010616b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106170:	eb 19                	jmp    8010618b <sys_write+0x7a>
  return filewrite(f, p, n);
80106172:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106175:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010617f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106183:	89 04 24             	mov    %eax,(%esp)
80106186:	e8 46 b0 ff ff       	call   801011d1 <filewrite>
}
8010618b:	c9                   	leave  
8010618c:	c3                   	ret    

8010618d <sys_close>:

int
sys_close(void)
{
8010618d:	55                   	push   %ebp
8010618e:	89 e5                	mov    %esp,%ebp
80106190:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106193:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106196:	89 44 24 08          	mov    %eax,0x8(%esp)
8010619a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010619d:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061a8:	e8 c7 fd ff ff       	call   80105f74 <argfd>
801061ad:	85 c0                	test   %eax,%eax
801061af:	79 07                	jns    801061b8 <sys_close+0x2b>
    return -1;
801061b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b6:	eb 27                	jmp    801061df <sys_close+0x52>
  thread->proc->ofile[fd] = 0;
801061b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061be:	8b 40 0c             	mov    0xc(%eax),%eax
801061c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c4:	83 c2 04             	add    $0x4,%edx
801061c7:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801061ce:	00 
  fileclose(f);
801061cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d2:	89 04 24             	mov    %eax,(%esp)
801061d5:	e8 16 ae ff ff       	call   80100ff0 <fileclose>
  return 0;
801061da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061df:	c9                   	leave  
801061e0:	c3                   	ret    

801061e1 <sys_fstat>:

int
sys_fstat(void)
{
801061e1:	55                   	push   %ebp
801061e2:	89 e5                	mov    %esp,%ebp
801061e4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801061e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801061ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061f5:	00 
801061f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061fd:	e8 72 fd ff ff       	call   80105f74 <argfd>
80106202:	85 c0                	test   %eax,%eax
80106204:	78 1f                	js     80106225 <sys_fstat+0x44>
80106206:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010620d:	00 
8010620e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106211:	89 44 24 04          	mov    %eax,0x4(%esp)
80106215:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010621c:	e8 1f fc ff ff       	call   80105e40 <argptr>
80106221:	85 c0                	test   %eax,%eax
80106223:	79 07                	jns    8010622c <sys_fstat+0x4b>
    return -1;
80106225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622a:	eb 12                	jmp    8010623e <sys_fstat+0x5d>
  return filestat(f, st);
8010622c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010622f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106232:	89 54 24 04          	mov    %edx,0x4(%esp)
80106236:	89 04 24             	mov    %eax,(%esp)
80106239:	e8 88 ae ff ff       	call   801010c6 <filestat>
}
8010623e:	c9                   	leave  
8010623f:	c3                   	ret    

80106240 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106246:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106249:	89 44 24 04          	mov    %eax,0x4(%esp)
8010624d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106254:	e8 4f fc ff ff       	call   80105ea8 <argstr>
80106259:	85 c0                	test   %eax,%eax
8010625b:	78 17                	js     80106274 <sys_link+0x34>
8010625d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106260:	89 44 24 04          	mov    %eax,0x4(%esp)
80106264:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010626b:	e8 38 fc ff ff       	call   80105ea8 <argstr>
80106270:	85 c0                	test   %eax,%eax
80106272:	79 0a                	jns    8010627e <sys_link+0x3e>
    return -1;
80106274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106279:	e9 42 01 00 00       	jmp    801063c0 <sys_link+0x180>

  begin_op();
8010627e:	e8 b2 d1 ff ff       	call   80103435 <begin_op>
  if((ip = namei(old)) == 0){
80106283:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106286:	89 04 24             	mov    %eax,(%esp)
80106289:	e8 9d c1 ff ff       	call   8010242b <namei>
8010628e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106295:	75 0f                	jne    801062a6 <sys_link+0x66>
    end_op();
80106297:	e8 1d d2 ff ff       	call   801034b9 <end_op>
    return -1;
8010629c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a1:	e9 1a 01 00 00       	jmp    801063c0 <sys_link+0x180>
  }

  ilock(ip);
801062a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a9:	89 04 24             	mov    %eax,(%esp)
801062ac:	e8 cc b5 ff ff       	call   8010187d <ilock>
  if(ip->type == T_DIR){
801062b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062b8:	66 83 f8 01          	cmp    $0x1,%ax
801062bc:	75 1a                	jne    801062d8 <sys_link+0x98>
    iunlockput(ip);
801062be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c1:	89 04 24             	mov    %eax,(%esp)
801062c4:	e8 38 b8 ff ff       	call   80101b01 <iunlockput>
    end_op();
801062c9:	e8 eb d1 ff ff       	call   801034b9 <end_op>
    return -1;
801062ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d3:	e9 e8 00 00 00       	jmp    801063c0 <sys_link+0x180>
  }

  ip->nlink++;
801062d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062db:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062df:	8d 50 01             	lea    0x1(%eax),%edx
801062e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801062e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ec:	89 04 24             	mov    %eax,(%esp)
801062ef:	e8 cd b3 ff ff       	call   801016c1 <iupdate>
  iunlock(ip);
801062f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f7:	89 04 24             	mov    %eax,(%esp)
801062fa:	e8 cc b6 ff ff       	call   801019cb <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801062ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106302:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106305:	89 54 24 04          	mov    %edx,0x4(%esp)
80106309:	89 04 24             	mov    %eax,(%esp)
8010630c:	e8 3c c1 ff ff       	call   8010244d <nameiparent>
80106311:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106318:	75 02                	jne    8010631c <sys_link+0xdc>
    goto bad;
8010631a:	eb 68                	jmp    80106384 <sys_link+0x144>
  ilock(dp);
8010631c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631f:	89 04 24             	mov    %eax,(%esp)
80106322:	e8 56 b5 ff ff       	call   8010187d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010632a:	8b 10                	mov    (%eax),%edx
8010632c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632f:	8b 00                	mov    (%eax),%eax
80106331:	39 c2                	cmp    %eax,%edx
80106333:	75 20                	jne    80106355 <sys_link+0x115>
80106335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106338:	8b 40 04             	mov    0x4(%eax),%eax
8010633b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010633f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106342:	89 44 24 04          	mov    %eax,0x4(%esp)
80106346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106349:	89 04 24             	mov    %eax,(%esp)
8010634c:	e8 17 be ff ff       	call   80102168 <dirlink>
80106351:	85 c0                	test   %eax,%eax
80106353:	79 0d                	jns    80106362 <sys_link+0x122>
    iunlockput(dp);
80106355:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106358:	89 04 24             	mov    %eax,(%esp)
8010635b:	e8 a1 b7 ff ff       	call   80101b01 <iunlockput>
    goto bad;
80106360:	eb 22                	jmp    80106384 <sys_link+0x144>
  }
  iunlockput(dp);
80106362:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106365:	89 04 24             	mov    %eax,(%esp)
80106368:	e8 94 b7 ff ff       	call   80101b01 <iunlockput>
  iput(ip);
8010636d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106370:	89 04 24             	mov    %eax,(%esp)
80106373:	e8 b8 b6 ff ff       	call   80101a30 <iput>

  end_op();
80106378:	e8 3c d1 ff ff       	call   801034b9 <end_op>

  return 0;
8010637d:	b8 00 00 00 00       	mov    $0x0,%eax
80106382:	eb 3c                	jmp    801063c0 <sys_link+0x180>

bad:
  ilock(ip);
80106384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106387:	89 04 24             	mov    %eax,(%esp)
8010638a:	e8 ee b4 ff ff       	call   8010187d <ilock>
  ip->nlink--;
8010638f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106392:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106396:	8d 50 ff             	lea    -0x1(%eax),%edx
80106399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801063a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a3:	89 04 24             	mov    %eax,(%esp)
801063a6:	e8 16 b3 ff ff       	call   801016c1 <iupdate>
  iunlockput(ip);
801063ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ae:	89 04 24             	mov    %eax,(%esp)
801063b1:	e8 4b b7 ff ff       	call   80101b01 <iunlockput>
  end_op();
801063b6:	e8 fe d0 ff ff       	call   801034b9 <end_op>
  return -1;
801063bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063c0:	c9                   	leave  
801063c1:	c3                   	ret    

801063c2 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801063c2:	55                   	push   %ebp
801063c3:	89 e5                	mov    %esp,%ebp
801063c5:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063c8:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801063cf:	eb 4b                	jmp    8010641c <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801063db:	00 
801063dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801063e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801063e7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ea:	89 04 24             	mov    %eax,(%esp)
801063ed:	e8 98 b9 ff ff       	call   80101d8a <readi>
801063f2:	83 f8 10             	cmp    $0x10,%eax
801063f5:	74 0c                	je     80106403 <isdirempty+0x41>
      panic("isdirempty: readi");
801063f7:	c7 04 24 3a 95 10 80 	movl   $0x8010953a,(%esp)
801063fe:	e8 37 a1 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80106403:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106407:	66 85 c0             	test   %ax,%ax
8010640a:	74 07                	je     80106413 <isdirempty+0x51>
      return 0;
8010640c:	b8 00 00 00 00       	mov    $0x0,%eax
80106411:	eb 1b                	jmp    8010642e <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106416:	83 c0 10             	add    $0x10,%eax
80106419:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010641c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010641f:	8b 45 08             	mov    0x8(%ebp),%eax
80106422:	8b 40 18             	mov    0x18(%eax),%eax
80106425:	39 c2                	cmp    %eax,%edx
80106427:	72 a8                	jb     801063d1 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106429:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010642e:	c9                   	leave  
8010642f:	c3                   	ret    

80106430 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106436:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106439:	89 44 24 04          	mov    %eax,0x4(%esp)
8010643d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106444:	e8 5f fa ff ff       	call   80105ea8 <argstr>
80106449:	85 c0                	test   %eax,%eax
8010644b:	79 0a                	jns    80106457 <sys_unlink+0x27>
    return -1;
8010644d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106452:	e9 af 01 00 00       	jmp    80106606 <sys_unlink+0x1d6>

  begin_op();
80106457:	e8 d9 cf ff ff       	call   80103435 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010645c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010645f:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106462:	89 54 24 04          	mov    %edx,0x4(%esp)
80106466:	89 04 24             	mov    %eax,(%esp)
80106469:	e8 df bf ff ff       	call   8010244d <nameiparent>
8010646e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106475:	75 0f                	jne    80106486 <sys_unlink+0x56>
    end_op();
80106477:	e8 3d d0 ff ff       	call   801034b9 <end_op>
    return -1;
8010647c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106481:	e9 80 01 00 00       	jmp    80106606 <sys_unlink+0x1d6>
  }

  ilock(dp);
80106486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106489:	89 04 24             	mov    %eax,(%esp)
8010648c:	e8 ec b3 ff ff       	call   8010187d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106491:	c7 44 24 04 4c 95 10 	movl   $0x8010954c,0x4(%esp)
80106498:	80 
80106499:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010649c:	89 04 24             	mov    %eax,(%esp)
8010649f:	e8 d9 bb ff ff       	call   8010207d <namecmp>
801064a4:	85 c0                	test   %eax,%eax
801064a6:	0f 84 45 01 00 00    	je     801065f1 <sys_unlink+0x1c1>
801064ac:	c7 44 24 04 4e 95 10 	movl   $0x8010954e,0x4(%esp)
801064b3:	80 
801064b4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801064b7:	89 04 24             	mov    %eax,(%esp)
801064ba:	e8 be bb ff ff       	call   8010207d <namecmp>
801064bf:	85 c0                	test   %eax,%eax
801064c1:	0f 84 2a 01 00 00    	je     801065f1 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801064c7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801064ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ce:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801064d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801064d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d8:	89 04 24             	mov    %eax,(%esp)
801064db:	e8 bf bb ff ff       	call   8010209f <dirlookup>
801064e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064e7:	75 05                	jne    801064ee <sys_unlink+0xbe>
    goto bad;
801064e9:	e9 03 01 00 00       	jmp    801065f1 <sys_unlink+0x1c1>
  ilock(ip);
801064ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f1:	89 04 24             	mov    %eax,(%esp)
801064f4:	e8 84 b3 ff ff       	call   8010187d <ilock>

  if(ip->nlink < 1)
801064f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106500:	66 85 c0             	test   %ax,%ax
80106503:	7f 0c                	jg     80106511 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106505:	c7 04 24 51 95 10 80 	movl   $0x80109551,(%esp)
8010650c:	e8 29 a0 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106514:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106518:	66 83 f8 01          	cmp    $0x1,%ax
8010651c:	75 1f                	jne    8010653d <sys_unlink+0x10d>
8010651e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106521:	89 04 24             	mov    %eax,(%esp)
80106524:	e8 99 fe ff ff       	call   801063c2 <isdirempty>
80106529:	85 c0                	test   %eax,%eax
8010652b:	75 10                	jne    8010653d <sys_unlink+0x10d>
    iunlockput(ip);
8010652d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106530:	89 04 24             	mov    %eax,(%esp)
80106533:	e8 c9 b5 ff ff       	call   80101b01 <iunlockput>
    goto bad;
80106538:	e9 b4 00 00 00       	jmp    801065f1 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
8010653d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106544:	00 
80106545:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010654c:	00 
8010654d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106550:	89 04 24             	mov    %eax,(%esp)
80106553:	e8 6c f5 ff ff       	call   80105ac4 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106558:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010655b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106562:	00 
80106563:	89 44 24 08          	mov    %eax,0x8(%esp)
80106567:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010656a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010656e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106571:	89 04 24             	mov    %eax,(%esp)
80106574:	e8 75 b9 ff ff       	call   80101eee <writei>
80106579:	83 f8 10             	cmp    $0x10,%eax
8010657c:	74 0c                	je     8010658a <sys_unlink+0x15a>
    panic("unlink: writei");
8010657e:	c7 04 24 63 95 10 80 	movl   $0x80109563,(%esp)
80106585:	e8 b0 9f ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
8010658a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010658d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106591:	66 83 f8 01          	cmp    $0x1,%ax
80106595:	75 1c                	jne    801065b3 <sys_unlink+0x183>
    dp->nlink--;
80106597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010659a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010659e:	8d 50 ff             	lea    -0x1(%eax),%edx
801065a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801065a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ab:	89 04 24             	mov    %eax,(%esp)
801065ae:	e8 0e b1 ff ff       	call   801016c1 <iupdate>
  }
  iunlockput(dp);
801065b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b6:	89 04 24             	mov    %eax,(%esp)
801065b9:	e8 43 b5 ff ff       	call   80101b01 <iunlockput>

  ip->nlink--;
801065be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801065c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065cb:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801065cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d2:	89 04 24             	mov    %eax,(%esp)
801065d5:	e8 e7 b0 ff ff       	call   801016c1 <iupdate>
  iunlockput(ip);
801065da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065dd:	89 04 24             	mov    %eax,(%esp)
801065e0:	e8 1c b5 ff ff       	call   80101b01 <iunlockput>

  end_op();
801065e5:	e8 cf ce ff ff       	call   801034b9 <end_op>

  return 0;
801065ea:	b8 00 00 00 00       	mov    $0x0,%eax
801065ef:	eb 15                	jmp    80106606 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
801065f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f4:	89 04 24             	mov    %eax,(%esp)
801065f7:	e8 05 b5 ff ff       	call   80101b01 <iunlockput>
  end_op();
801065fc:	e8 b8 ce ff ff       	call   801034b9 <end_op>
  return -1;
80106601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106606:	c9                   	leave  
80106607:	c3                   	ret    

80106608 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106608:	55                   	push   %ebp
80106609:	89 e5                	mov    %esp,%ebp
8010660b:	83 ec 48             	sub    $0x48,%esp
8010660e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106611:	8b 55 10             	mov    0x10(%ebp),%edx
80106614:	8b 45 14             	mov    0x14(%ebp),%eax
80106617:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010661b:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010661f:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106623:	8d 45 de             	lea    -0x22(%ebp),%eax
80106626:	89 44 24 04          	mov    %eax,0x4(%esp)
8010662a:	8b 45 08             	mov    0x8(%ebp),%eax
8010662d:	89 04 24             	mov    %eax,(%esp)
80106630:	e8 18 be ff ff       	call   8010244d <nameiparent>
80106635:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010663c:	75 0a                	jne    80106648 <create+0x40>
    return 0;
8010663e:	b8 00 00 00 00       	mov    $0x0,%eax
80106643:	e9 7e 01 00 00       	jmp    801067c6 <create+0x1be>
  ilock(dp);
80106648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664b:	89 04 24             	mov    %eax,(%esp)
8010664e:	e8 2a b2 ff ff       	call   8010187d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106653:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106656:	89 44 24 08          	mov    %eax,0x8(%esp)
8010665a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010665d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106664:	89 04 24             	mov    %eax,(%esp)
80106667:	e8 33 ba ff ff       	call   8010209f <dirlookup>
8010666c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010666f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106673:	74 47                	je     801066bc <create+0xb4>
    iunlockput(dp);
80106675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106678:	89 04 24             	mov    %eax,(%esp)
8010667b:	e8 81 b4 ff ff       	call   80101b01 <iunlockput>
    ilock(ip);
80106680:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106683:	89 04 24             	mov    %eax,(%esp)
80106686:	e8 f2 b1 ff ff       	call   8010187d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010668b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106690:	75 15                	jne    801066a7 <create+0x9f>
80106692:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106695:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106699:	66 83 f8 02          	cmp    $0x2,%ax
8010669d:	75 08                	jne    801066a7 <create+0x9f>
      return ip;
8010669f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a2:	e9 1f 01 00 00       	jmp    801067c6 <create+0x1be>
    iunlockput(ip);
801066a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066aa:	89 04 24             	mov    %eax,(%esp)
801066ad:	e8 4f b4 ff ff       	call   80101b01 <iunlockput>
    return 0;
801066b2:	b8 00 00 00 00       	mov    $0x0,%eax
801066b7:	e9 0a 01 00 00       	jmp    801067c6 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801066bc:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801066c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c3:	8b 00                	mov    (%eax),%eax
801066c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801066c9:	89 04 24             	mov    %eax,(%esp)
801066cc:	e8 11 af ff ff       	call   801015e2 <ialloc>
801066d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066d8:	75 0c                	jne    801066e6 <create+0xde>
    panic("create: ialloc");
801066da:	c7 04 24 72 95 10 80 	movl   $0x80109572,(%esp)
801066e1:	e8 54 9e ff ff       	call   8010053a <panic>

  ilock(ip);
801066e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e9:	89 04 24             	mov    %eax,(%esp)
801066ec:	e8 8c b1 ff ff       	call   8010187d <ilock>
  ip->major = major;
801066f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f4:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801066f8:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801066fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ff:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106703:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106707:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010670a:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106713:	89 04 24             	mov    %eax,(%esp)
80106716:	e8 a6 af ff ff       	call   801016c1 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010671b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106720:	75 6a                	jne    8010678c <create+0x184>
    dp->nlink++;  // for ".."
80106722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106725:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106729:	8d 50 01             	lea    0x1(%eax),%edx
8010672c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106736:	89 04 24             	mov    %eax,(%esp)
80106739:	e8 83 af ff ff       	call   801016c1 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010673e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106741:	8b 40 04             	mov    0x4(%eax),%eax
80106744:	89 44 24 08          	mov    %eax,0x8(%esp)
80106748:	c7 44 24 04 4c 95 10 	movl   $0x8010954c,0x4(%esp)
8010674f:	80 
80106750:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106753:	89 04 24             	mov    %eax,(%esp)
80106756:	e8 0d ba ff ff       	call   80102168 <dirlink>
8010675b:	85 c0                	test   %eax,%eax
8010675d:	78 21                	js     80106780 <create+0x178>
8010675f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106762:	8b 40 04             	mov    0x4(%eax),%eax
80106765:	89 44 24 08          	mov    %eax,0x8(%esp)
80106769:	c7 44 24 04 4e 95 10 	movl   $0x8010954e,0x4(%esp)
80106770:	80 
80106771:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106774:	89 04 24             	mov    %eax,(%esp)
80106777:	e8 ec b9 ff ff       	call   80102168 <dirlink>
8010677c:	85 c0                	test   %eax,%eax
8010677e:	79 0c                	jns    8010678c <create+0x184>
      panic("create dots");
80106780:	c7 04 24 81 95 10 80 	movl   $0x80109581,(%esp)
80106787:	e8 ae 9d ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010678c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678f:	8b 40 04             	mov    0x4(%eax),%eax
80106792:	89 44 24 08          	mov    %eax,0x8(%esp)
80106796:	8d 45 de             	lea    -0x22(%ebp),%eax
80106799:	89 44 24 04          	mov    %eax,0x4(%esp)
8010679d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a0:	89 04 24             	mov    %eax,(%esp)
801067a3:	e8 c0 b9 ff ff       	call   80102168 <dirlink>
801067a8:	85 c0                	test   %eax,%eax
801067aa:	79 0c                	jns    801067b8 <create+0x1b0>
    panic("create: dirlink");
801067ac:	c7 04 24 8d 95 10 80 	movl   $0x8010958d,(%esp)
801067b3:	e8 82 9d ff ff       	call   8010053a <panic>

  iunlockput(dp);
801067b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067bb:	89 04 24             	mov    %eax,(%esp)
801067be:	e8 3e b3 ff ff       	call   80101b01 <iunlockput>

  return ip;
801067c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801067c6:	c9                   	leave  
801067c7:	c3                   	ret    

801067c8 <sys_open>:

int
sys_open(void)
{
801067c8:	55                   	push   %ebp
801067c9:	89 e5                	mov    %esp,%ebp
801067cb:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801067ce:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801067d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067dc:	e8 c7 f6 ff ff       	call   80105ea8 <argstr>
801067e1:	85 c0                	test   %eax,%eax
801067e3:	78 17                	js     801067fc <sys_open+0x34>
801067e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067f3:	e8 1a f6 ff ff       	call   80105e12 <argint>
801067f8:	85 c0                	test   %eax,%eax
801067fa:	79 0a                	jns    80106806 <sys_open+0x3e>
    return -1;
801067fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106801:	e9 5c 01 00 00       	jmp    80106962 <sys_open+0x19a>

  begin_op();
80106806:	e8 2a cc ff ff       	call   80103435 <begin_op>

  if(omode & O_CREATE){
8010680b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010680e:	25 00 02 00 00       	and    $0x200,%eax
80106813:	85 c0                	test   %eax,%eax
80106815:	74 3b                	je     80106852 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106817:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010681a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106821:	00 
80106822:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106829:	00 
8010682a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106831:	00 
80106832:	89 04 24             	mov    %eax,(%esp)
80106835:	e8 ce fd ff ff       	call   80106608 <create>
8010683a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010683d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106841:	75 6b                	jne    801068ae <sys_open+0xe6>
      end_op();
80106843:	e8 71 cc ff ff       	call   801034b9 <end_op>
      return -1;
80106848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684d:	e9 10 01 00 00       	jmp    80106962 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106852:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106855:	89 04 24             	mov    %eax,(%esp)
80106858:	e8 ce bb ff ff       	call   8010242b <namei>
8010685d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106864:	75 0f                	jne    80106875 <sys_open+0xad>
      end_op();
80106866:	e8 4e cc ff ff       	call   801034b9 <end_op>
      return -1;
8010686b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106870:	e9 ed 00 00 00       	jmp    80106962 <sys_open+0x19a>
    }
    ilock(ip);
80106875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106878:	89 04 24             	mov    %eax,(%esp)
8010687b:	e8 fd af ff ff       	call   8010187d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106883:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106887:	66 83 f8 01          	cmp    $0x1,%ax
8010688b:	75 21                	jne    801068ae <sys_open+0xe6>
8010688d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106890:	85 c0                	test   %eax,%eax
80106892:	74 1a                	je     801068ae <sys_open+0xe6>
      iunlockput(ip);
80106894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106897:	89 04 24             	mov    %eax,(%esp)
8010689a:	e8 62 b2 ff ff       	call   80101b01 <iunlockput>
      end_op();
8010689f:	e8 15 cc ff ff       	call   801034b9 <end_op>
      return -1;
801068a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068a9:	e9 b4 00 00 00       	jmp    80106962 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801068ae:	e8 95 a6 ff ff       	call   80100f48 <filealloc>
801068b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068ba:	74 14                	je     801068d0 <sys_open+0x108>
801068bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068bf:	89 04 24             	mov    %eax,(%esp)
801068c2:	e8 25 f7 ff ff       	call   80105fec <fdalloc>
801068c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801068ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801068ce:	79 28                	jns    801068f8 <sys_open+0x130>
    if(f)
801068d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068d4:	74 0b                	je     801068e1 <sys_open+0x119>
      fileclose(f);
801068d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068d9:	89 04 24             	mov    %eax,(%esp)
801068dc:	e8 0f a7 ff ff       	call   80100ff0 <fileclose>
    iunlockput(ip);
801068e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e4:	89 04 24             	mov    %eax,(%esp)
801068e7:	e8 15 b2 ff ff       	call   80101b01 <iunlockput>
    end_op();
801068ec:	e8 c8 cb ff ff       	call   801034b9 <end_op>
    return -1;
801068f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f6:	eb 6a                	jmp    80106962 <sys_open+0x19a>
  }
  iunlock(ip);
801068f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068fb:	89 04 24             	mov    %eax,(%esp)
801068fe:	e8 c8 b0 ff ff       	call   801019cb <iunlock>
  end_op();
80106903:	e8 b1 cb ff ff       	call   801034b9 <end_op>

  f->type = FD_INODE;
80106908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010690b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106914:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106917:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010691a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010691d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106927:	83 e0 01             	and    $0x1,%eax
8010692a:	85 c0                	test   %eax,%eax
8010692c:	0f 94 c0             	sete   %al
8010692f:	89 c2                	mov    %eax,%edx
80106931:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106934:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010693a:	83 e0 01             	and    $0x1,%eax
8010693d:	85 c0                	test   %eax,%eax
8010693f:	75 0a                	jne    8010694b <sys_open+0x183>
80106941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106944:	83 e0 02             	and    $0x2,%eax
80106947:	85 c0                	test   %eax,%eax
80106949:	74 07                	je     80106952 <sys_open+0x18a>
8010694b:	b8 01 00 00 00       	mov    $0x1,%eax
80106950:	eb 05                	jmp    80106957 <sys_open+0x18f>
80106952:	b8 00 00 00 00       	mov    $0x0,%eax
80106957:	89 c2                	mov    %eax,%edx
80106959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010695c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010695f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106962:	c9                   	leave  
80106963:	c3                   	ret    

80106964 <sys_mkdir>:

int
sys_mkdir(void)
{
80106964:	55                   	push   %ebp
80106965:	89 e5                	mov    %esp,%ebp
80106967:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010696a:	e8 c6 ca ff ff       	call   80103435 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010696f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106972:	89 44 24 04          	mov    %eax,0x4(%esp)
80106976:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010697d:	e8 26 f5 ff ff       	call   80105ea8 <argstr>
80106982:	85 c0                	test   %eax,%eax
80106984:	78 2c                	js     801069b2 <sys_mkdir+0x4e>
80106986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106989:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106990:	00 
80106991:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106998:	00 
80106999:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801069a0:	00 
801069a1:	89 04 24             	mov    %eax,(%esp)
801069a4:	e8 5f fc ff ff       	call   80106608 <create>
801069a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069b0:	75 0c                	jne    801069be <sys_mkdir+0x5a>
    end_op();
801069b2:	e8 02 cb ff ff       	call   801034b9 <end_op>
    return -1;
801069b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bc:	eb 15                	jmp    801069d3 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801069be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c1:	89 04 24             	mov    %eax,(%esp)
801069c4:	e8 38 b1 ff ff       	call   80101b01 <iunlockput>
  end_op();
801069c9:	e8 eb ca ff ff       	call   801034b9 <end_op>
  return 0;
801069ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d3:	c9                   	leave  
801069d4:	c3                   	ret    

801069d5 <sys_mknod>:

int
sys_mknod(void)
{
801069d5:	55                   	push   %ebp
801069d6:	89 e5                	mov    %esp,%ebp
801069d8:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801069db:	e8 55 ca ff ff       	call   80103435 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801069e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801069e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069ee:	e8 b5 f4 ff ff       	call   80105ea8 <argstr>
801069f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069fa:	78 5e                	js     80106a5a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801069fc:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a0a:	e8 03 f4 ff ff       	call   80105e12 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106a0f:	85 c0                	test   %eax,%eax
80106a11:	78 47                	js     80106a5a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106a13:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a21:	e8 ec f3 ff ff       	call   80105e12 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106a26:	85 c0                	test   %eax,%eax
80106a28:	78 30                	js     80106a5a <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106a2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a2d:	0f bf c8             	movswl %ax,%ecx
80106a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a33:	0f bf d0             	movswl %ax,%edx
80106a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106a39:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106a3d:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a41:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106a48:	00 
80106a49:	89 04 24             	mov    %eax,(%esp)
80106a4c:	e8 b7 fb ff ff       	call   80106608 <create>
80106a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a58:	75 0c                	jne    80106a66 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106a5a:	e8 5a ca ff ff       	call   801034b9 <end_op>
    return -1;
80106a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a64:	eb 15                	jmp    80106a7b <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a69:	89 04 24             	mov    %eax,(%esp)
80106a6c:	e8 90 b0 ff ff       	call   80101b01 <iunlockput>
  end_op();
80106a71:	e8 43 ca ff ff       	call   801034b9 <end_op>
  return 0;
80106a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a7b:	c9                   	leave  
80106a7c:	c3                   	ret    

80106a7d <sys_chdir>:

int
sys_chdir(void)
{
80106a7d:	55                   	push   %ebp
80106a7e:	89 e5                	mov    %esp,%ebp
80106a80:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106a83:	e8 ad c9 ff ff       	call   80103435 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106a88:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a96:	e8 0d f4 ff ff       	call   80105ea8 <argstr>
80106a9b:	85 c0                	test   %eax,%eax
80106a9d:	78 14                	js     80106ab3 <sys_chdir+0x36>
80106a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aa2:	89 04 24             	mov    %eax,(%esp)
80106aa5:	e8 81 b9 ff ff       	call   8010242b <namei>
80106aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ab1:	75 0c                	jne    80106abf <sys_chdir+0x42>
    end_op();
80106ab3:	e8 01 ca ff ff       	call   801034b9 <end_op>
    return -1;
80106ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106abd:	eb 67                	jmp    80106b26 <sys_chdir+0xa9>
  }
  ilock(ip);
80106abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ac2:	89 04 24             	mov    %eax,(%esp)
80106ac5:	e8 b3 ad ff ff       	call   8010187d <ilock>
  if(ip->type != T_DIR){
80106aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106acd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106ad1:	66 83 f8 01          	cmp    $0x1,%ax
80106ad5:	74 17                	je     80106aee <sys_chdir+0x71>
    iunlockput(ip);
80106ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ada:	89 04 24             	mov    %eax,(%esp)
80106add:	e8 1f b0 ff ff       	call   80101b01 <iunlockput>
    end_op();
80106ae2:	e8 d2 c9 ff ff       	call   801034b9 <end_op>
    return -1;
80106ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aec:	eb 38                	jmp    80106b26 <sys_chdir+0xa9>
  }
  iunlock(ip);
80106aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af1:	89 04 24             	mov    %eax,(%esp)
80106af4:	e8 d2 ae ff ff       	call   801019cb <iunlock>
  iput(thread->proc->cwd);
80106af9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aff:	8b 40 0c             	mov    0xc(%eax),%eax
80106b02:	8b 40 5c             	mov    0x5c(%eax),%eax
80106b05:	89 04 24             	mov    %eax,(%esp)
80106b08:	e8 23 af ff ff       	call   80101a30 <iput>
  end_op();
80106b0d:	e8 a7 c9 ff ff       	call   801034b9 <end_op>
  thread->proc->cwd = ip;
80106b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b18:	8b 40 0c             	mov    0xc(%eax),%eax
80106b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b1e:	89 50 5c             	mov    %edx,0x5c(%eax)
  return 0;
80106b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b26:	c9                   	leave  
80106b27:	c3                   	ret    

80106b28 <sys_exec>:

int
sys_exec(void)
{
80106b28:	55                   	push   %ebp
80106b29:	89 e5                	mov    %esp,%ebp
80106b2b:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106b31:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b34:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b3f:	e8 64 f3 ff ff       	call   80105ea8 <argstr>
80106b44:	85 c0                	test   %eax,%eax
80106b46:	78 1a                	js     80106b62 <sys_exec+0x3a>
80106b48:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b59:	e8 b4 f2 ff ff       	call   80105e12 <argint>
80106b5e:	85 c0                	test   %eax,%eax
80106b60:	79 0a                	jns    80106b6c <sys_exec+0x44>
    return -1;
80106b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b67:	e9 c8 00 00 00       	jmp    80106c34 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106b6c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106b73:	00 
80106b74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b7b:	00 
80106b7c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106b82:	89 04 24             	mov    %eax,(%esp)
80106b85:	e8 3a ef ff ff       	call   80105ac4 <memset>
  for(i=0;; i++){
80106b8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b94:	83 f8 1f             	cmp    $0x1f,%eax
80106b97:	76 0a                	jbe    80106ba3 <sys_exec+0x7b>
      return -1;
80106b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9e:	e9 91 00 00 00       	jmp    80106c34 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba6:	c1 e0 02             	shl    $0x2,%eax
80106ba9:	89 c2                	mov    %eax,%edx
80106bab:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106bb1:	01 c2                	add    %eax,%edx
80106bb3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bbd:	89 14 24             	mov    %edx,(%esp)
80106bc0:	e8 a5 f1 ff ff       	call   80105d6a <fetchint>
80106bc5:	85 c0                	test   %eax,%eax
80106bc7:	79 07                	jns    80106bd0 <sys_exec+0xa8>
      return -1;
80106bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bce:	eb 64                	jmp    80106c34 <sys_exec+0x10c>
    if(uarg == 0){
80106bd0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106bd6:	85 c0                	test   %eax,%eax
80106bd8:	75 26                	jne    80106c00 <sys_exec+0xd8>
      argv[i] = 0;
80106bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bdd:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106be4:	00 00 00 00 
      break;
80106be8:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bec:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106bf2:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bf6:	89 04 24             	mov    %eax,(%esp)
80106bf9:	e8 f4 9e ff ff       	call   80100af2 <exec>
80106bfe:	eb 34                	jmp    80106c34 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106c00:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c09:	c1 e2 02             	shl    $0x2,%edx
80106c0c:	01 c2                	add    %eax,%edx
80106c0e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106c14:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c18:	89 04 24             	mov    %eax,(%esp)
80106c1b:	e8 8a f1 ff ff       	call   80105daa <fetchstr>
80106c20:	85 c0                	test   %eax,%eax
80106c22:	79 07                	jns    80106c2b <sys_exec+0x103>
      return -1;
80106c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c29:	eb 09                	jmp    80106c34 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106c2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106c2f:	e9 5d ff ff ff       	jmp    80106b91 <sys_exec+0x69>
  return exec(path, argv);
}
80106c34:	c9                   	leave  
80106c35:	c3                   	ret    

80106c36 <sys_pipe>:

int
sys_pipe(void)
{
80106c36:	55                   	push   %ebp
80106c37:	89 e5                	mov    %esp,%ebp
80106c39:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106c3c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106c43:	00 
80106c44:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c52:	e8 e9 f1 ff ff       	call   80105e40 <argptr>
80106c57:	85 c0                	test   %eax,%eax
80106c59:	79 0a                	jns    80106c65 <sys_pipe+0x2f>
    return -1;
80106c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c60:	e9 a1 00 00 00       	jmp    80106d06 <sys_pipe+0xd0>
  if(pipealloc(&rf, &wf) < 0)
80106c65:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c68:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c6c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c6f:	89 04 24             	mov    %eax,(%esp)
80106c72:	e8 cf d2 ff ff       	call   80103f46 <pipealloc>
80106c77:	85 c0                	test   %eax,%eax
80106c79:	79 0a                	jns    80106c85 <sys_pipe+0x4f>
    return -1;
80106c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c80:	e9 81 00 00 00       	jmp    80106d06 <sys_pipe+0xd0>
  fd0 = -1;
80106c85:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c8f:	89 04 24             	mov    %eax,(%esp)
80106c92:	e8 55 f3 ff ff       	call   80105fec <fdalloc>
80106c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c9e:	78 14                	js     80106cb4 <sys_pipe+0x7e>
80106ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca3:	89 04 24             	mov    %eax,(%esp)
80106ca6:	e8 41 f3 ff ff       	call   80105fec <fdalloc>
80106cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106cae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106cb2:	79 3a                	jns    80106cee <sys_pipe+0xb8>
    if(fd0 >= 0)
80106cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cb8:	78 17                	js     80106cd1 <sys_pipe+0x9b>
      thread->proc->ofile[fd0] = 0;
80106cba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc0:	8b 40 0c             	mov    0xc(%eax),%eax
80106cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cc6:	83 c2 04             	add    $0x4,%edx
80106cc9:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80106cd0:	00 
    fileclose(rf);
80106cd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106cd4:	89 04 24             	mov    %eax,(%esp)
80106cd7:	e8 14 a3 ff ff       	call   80100ff0 <fileclose>
    fileclose(wf);
80106cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cdf:	89 04 24             	mov    %eax,(%esp)
80106ce2:	e8 09 a3 ff ff       	call   80100ff0 <fileclose>
    return -1;
80106ce7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cec:	eb 18                	jmp    80106d06 <sys_pipe+0xd0>
  }
  fd[0] = fd0;
80106cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106cf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cf4:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106cf9:	8d 50 04             	lea    0x4(%eax),%edx
80106cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cff:	89 02                	mov    %eax,(%edx)
  return 0;
80106d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d06:	c9                   	leave  
80106d07:	c3                   	ret    

80106d08 <sys_fork>:
#include "proc.h"
#include "kthread.h"

int
sys_fork(void)
{
80106d08:	55                   	push   %ebp
80106d09:	89 e5                	mov    %esp,%ebp
80106d0b:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106d0e:	e8 86 d9 ff ff       	call   80104699 <fork>
}
80106d13:	c9                   	leave  
80106d14:	c3                   	ret    

80106d15 <sys_exit>:

int
sys_exit(void)
{
80106d15:	55                   	push   %ebp
80106d16:	89 e5                	mov    %esp,%ebp
80106d18:	83 ec 08             	sub    $0x8,%esp
  exit();
80106d1b:	e8 f1 db ff ff       	call   80104911 <exit>
  return 0;  // not reached
80106d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d25:	c9                   	leave  
80106d26:	c3                   	ret    

80106d27 <sys_wait>:

int
sys_wait(void)
{
80106d27:	55                   	push   %ebp
80106d28:	89 e5                	mov    %esp,%ebp
80106d2a:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106d2d:	e8 86 dd ff ff       	call   80104ab8 <wait>
}
80106d32:	c9                   	leave  
80106d33:	c3                   	ret    

80106d34 <sys_kill>:

int
sys_kill(void)
{
80106d34:	55                   	push   %ebp
80106d35:	89 e5                	mov    %esp,%ebp
80106d37:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106d3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d48:	e8 c5 f0 ff ff       	call   80105e12 <argint>
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	79 07                	jns    80106d58 <sys_kill+0x24>
    return -1;
80106d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d56:	eb 0b                	jmp    80106d63 <sys_kill+0x2f>
  return kill(pid);
80106d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d5b:	89 04 24             	mov    %eax,(%esp)
80106d5e:	e8 db e1 ff ff       	call   80104f3e <kill>
}
80106d63:	c9                   	leave  
80106d64:	c3                   	ret    

80106d65 <sys_getpid>:

int
sys_getpid(void)
{
80106d65:	55                   	push   %ebp
80106d66:	89 e5                	mov    %esp,%ebp
  return thread->proc->pid;
80106d68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d6e:	8b 40 0c             	mov    0xc(%eax),%eax
80106d71:	8b 40 0c             	mov    0xc(%eax),%eax
}
80106d74:	5d                   	pop    %ebp
80106d75:	c3                   	ret    

80106d76 <sys_sbrk>:

int
sys_sbrk(void)
{
80106d76:	55                   	push   %ebp
80106d77:	89 e5                	mov    %esp,%ebp
80106d79:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106d7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d8a:	e8 83 f0 ff ff       	call   80105e12 <argint>
80106d8f:	85 c0                	test   %eax,%eax
80106d91:	79 07                	jns    80106d9a <sys_sbrk+0x24>
    return -1;
80106d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d98:	eb 27                	jmp    80106dc1 <sys_sbrk+0x4b>
  addr = thread->proc->sz;
80106d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da0:	8b 40 0c             	mov    0xc(%eax),%eax
80106da3:	8b 00                	mov    (%eax),%eax
80106da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dab:	89 04 24             	mov    %eax,(%esp)
80106dae:	e8 41 d8 ff ff       	call   801045f4 <growproc>
80106db3:	85 c0                	test   %eax,%eax
80106db5:	79 07                	jns    80106dbe <sys_sbrk+0x48>
    return -1;
80106db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dbc:	eb 03                	jmp    80106dc1 <sys_sbrk+0x4b>
  return addr;
80106dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106dc1:	c9                   	leave  
80106dc2:	c3                   	ret    

80106dc3 <sys_sleep>:

int
sys_sleep(void)
{
80106dc3:	55                   	push   %ebp
80106dc4:	89 e5                	mov    %esp,%ebp
80106dc6:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106dc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106dd7:	e8 36 f0 ff ff       	call   80105e12 <argint>
80106ddc:	85 c0                	test   %eax,%eax
80106dde:	79 07                	jns    80106de7 <sys_sleep+0x24>
    return -1;
80106de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106de5:	eb 6f                	jmp    80106e56 <sys_sleep+0x93>
  acquire(&tickslock);
80106de7:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106dee:	e8 7d ea ff ff       	call   80105870 <acquire>
  ticks0 = ticks;
80106df3:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106dfb:	eb 37                	jmp    80106e34 <sys_sleep+0x71>
    if(thread->proc->killed){
80106dfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e03:	8b 40 0c             	mov    0xc(%eax),%eax
80106e06:	8b 40 18             	mov    0x18(%eax),%eax
80106e09:	85 c0                	test   %eax,%eax
80106e0b:	74 13                	je     80106e20 <sys_sleep+0x5d>
      release(&tickslock);
80106e0d:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e14:	e8 b9 ea ff ff       	call   801058d2 <release>
      return -1;
80106e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e1e:	eb 36                	jmp    80106e56 <sys_sleep+0x93>
    }
    sleep(&ticks, &tickslock);
80106e20:	c7 44 24 04 c0 e9 11 	movl   $0x8011e9c0,0x4(%esp)
80106e27:	80 
80106e28:	c7 04 24 00 f2 11 80 	movl   $0x8011f200,(%esp)
80106e2f:	e8 e7 df ff ff       	call   80104e1b <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106e34:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106e39:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106e3c:	89 c2                	mov    %eax,%edx
80106e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e41:	39 c2                	cmp    %eax,%edx
80106e43:	72 b8                	jb     80106dfd <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106e45:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e4c:	e8 81 ea ff ff       	call   801058d2 <release>
  return 0;
80106e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e56:	c9                   	leave  
80106e57:	c3                   	ret    

80106e58 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106e58:	55                   	push   %ebp
80106e59:	89 e5                	mov    %esp,%ebp
80106e5b:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106e5e:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e65:	e8 06 ea ff ff       	call   80105870 <acquire>
  xticks = ticks;
80106e6a:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80106e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106e72:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80106e79:	e8 54 ea ff ff       	call   801058d2 <release>
  return xticks;
80106e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106e81:	c9                   	leave  
80106e82:	c3                   	ret    

80106e83 <sys_kthread_create>:




int sys_kthread_create(void){
80106e83:	55                   	push   %ebp
80106e84:	89 e5                	mov    %esp,%ebp
80106e86:	83 ec 28             	sub    $0x28,%esp

	int start_func;
	int stack;
	int stack_size;

	if ( argint(0,&start_func)<0  || argint(1,&stack)<0  ||argint(2,&stack_size)<0 )
80106e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e97:	e8 76 ef ff ff       	call   80105e12 <argint>
80106e9c:	85 c0                	test   %eax,%eax
80106e9e:	78 2e                	js     80106ece <sys_kthread_create+0x4b>
80106ea0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ea7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106eae:	e8 5f ef ff ff       	call   80105e12 <argint>
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	78 17                	js     80106ece <sys_kthread_create+0x4b>
80106eb7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106eba:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ebe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106ec5:	e8 48 ef ff ff       	call   80105e12 <argint>
80106eca:	85 c0                	test   %eax,%eax
80106ecc:	79 07                	jns    80106ed5 <sys_kthread_create+0x52>
		return -1;
80106ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ed3:	eb 1d                	jmp    80106ef2 <sys_kthread_create+0x6f>


	return kthread_create((void *) start_func, (void *) stack, (uint) stack_size);
80106ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ed8:	89 c1                	mov    %eax,%ecx
80106eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106edd:	89 c2                	mov    %eax,%edx
80106edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106ee6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106eea:	89 04 24             	mov    %eax,(%esp)
80106eed:	e8 30 e2 ff ff       	call   80105122 <kthread_create>

}
80106ef2:	c9                   	leave  
80106ef3:	c3                   	ret    

80106ef4 <sys_kthread_id>:
int sys_kthread_id(void){
80106ef4:	55                   	push   %ebp
80106ef5:	89 e5                	mov    %esp,%ebp
80106ef7:	83 ec 08             	sub    $0x8,%esp
	return kthread_id();
80106efa:	e8 a9 e3 ff ff       	call   801052a8 <kthread_id>
}
80106eff:	c9                   	leave  
80106f00:	c3                   	ret    

80106f01 <sys_kthread_exit>:

int  sys_kthread_exit(void){
80106f01:	55                   	push   %ebp
80106f02:	89 e5                	mov    %esp,%ebp
80106f04:	83 ec 08             	sub    $0x8,%esp
	kthread_exit();
80106f07:	e8 aa e3 ff ff       	call   801052b6 <kthread_exit>
	return 0;
80106f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f11:	c9                   	leave  
80106f12:	c3                   	ret    

80106f13 <sys_kthread_join>:

int sys_kthread_join(void){
80106f13:	55                   	push   %ebp
80106f14:	89 e5                	mov    %esp,%ebp
80106f16:	83 ec 28             	sub    $0x28,%esp

	int thread_id;

	if (argint(0, &thread_id)<0)
80106f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f27:	e8 e6 ee ff ff       	call   80105e12 <argint>
80106f2c:	85 c0                	test   %eax,%eax
80106f2e:	79 07                	jns    80106f37 <sys_kthread_join+0x24>
		return -1;
80106f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f35:	eb 0b                	jmp    80106f42 <sys_kthread_join+0x2f>

	return kthread_join(thread_id);
80106f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3a:	89 04 24             	mov    %eax,(%esp)
80106f3d:	e8 e2 e3 ff ff       	call   80105324 <kthread_join>

}
80106f42:	c9                   	leave  
80106f43:	c3                   	ret    

80106f44 <sys_kthread_mutex_alloc>:

int sys_kthread_mutex_alloc(void){
80106f44:	55                   	push   %ebp
80106f45:	89 e5                	mov    %esp,%ebp
80106f47:	83 ec 08             	sub    $0x8,%esp
  return kthread_mutex_alloc();
80106f4a:	e8 bb e5 ff ff       	call   8010550a <kthread_mutex_alloc>
}
80106f4f:	c9                   	leave  
80106f50:	c3                   	ret    

80106f51 <sys_kthread_mutex_dealloc>:

int sys_kthread_mutex_dealloc(void){
80106f51:	55                   	push   %ebp
80106f52:	89 e5                	mov    %esp,%ebp
80106f54:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106f57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f65:	e8 a8 ee ff ff       	call   80105e12 <argint>
80106f6a:	85 c0                	test   %eax,%eax
80106f6c:	79 07                	jns    80106f75 <sys_kthread_mutex_dealloc+0x24>
    return -1;
80106f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f73:	eb 0b                	jmp    80106f80 <sys_kthread_mutex_dealloc+0x2f>
  return kthread_mutex_dealloc(mutex_id);
80106f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f78:	89 04 24             	mov    %eax,(%esp)
80106f7b:	e8 1c e6 ff ff       	call   8010559c <kthread_mutex_dealloc>
}
80106f80:	c9                   	leave  
80106f81:	c3                   	ret    

80106f82 <sys_kthread_mutex_lock>:

int sys_kthread_mutex_lock(void){
80106f82:	55                   	push   %ebp
80106f83:	89 e5                	mov    %esp,%ebp
80106f85:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106f88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f96:	e8 77 ee ff ff       	call   80105e12 <argint>
80106f9b:	85 c0                	test   %eax,%eax
80106f9d:	79 07                	jns    80106fa6 <sys_kthread_mutex_lock+0x24>
    return -1;
80106f9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fa4:	eb 0b                	jmp    80106fb1 <sys_kthread_mutex_lock+0x2f>
  return kthread_mutex_lock(mutex_id);
80106fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fa9:	89 04 24             	mov    %eax,(%esp)
80106fac:	e8 9a e6 ff ff       	call   8010564b <kthread_mutex_lock>
}
80106fb1:	c9                   	leave  
80106fb2:	c3                   	ret    

80106fb3 <sys_kthread_mutex_unlock>:

int sys_kthread_mutex_unlock(void){
80106fb3:	55                   	push   %ebp
80106fb4:	89 e5                	mov    %esp,%ebp
80106fb6:	83 ec 28             	sub    $0x28,%esp

  int mutex_id;

  if (argint(0, &mutex_id)<0)
80106fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106fc7:	e8 46 ee ff ff       	call   80105e12 <argint>
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	79 07                	jns    80106fd7 <sys_kthread_mutex_unlock+0x24>
    return -1;
80106fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fd5:	eb 0b                	jmp    80106fe2 <sys_kthread_mutex_unlock+0x2f>
  return kthread_mutex_unlock(mutex_id);
80106fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fda:	89 04 24             	mov    %eax,(%esp)
80106fdd:	e8 05 e7 ff ff       	call   801056e7 <kthread_mutex_unlock>
}
80106fe2:	c9                   	leave  
80106fe3:	c3                   	ret    

80106fe4 <sys_kthread_mutex_yieldlock>:

int sys_kthread_mutex_yieldlock(void){
80106fe4:	55                   	push   %ebp
80106fe5:	89 e5                	mov    %esp,%ebp
80106fe7:	83 ec 28             	sub    $0x28,%esp

  int mutex_id1;
  int mutex_id2;

  if (argint(0, &mutex_id1)<0 || argint(0, &mutex_id2)<0 )
80106fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fed:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ff1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ff8:	e8 15 ee ff ff       	call   80105e12 <argint>
80106ffd:	85 c0                	test   %eax,%eax
80106fff:	78 17                	js     80107018 <sys_kthread_mutex_yieldlock+0x34>
80107001:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107004:	89 44 24 04          	mov    %eax,0x4(%esp)
80107008:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010700f:	e8 fe ed ff ff       	call   80105e12 <argint>
80107014:	85 c0                	test   %eax,%eax
80107016:	79 07                	jns    8010701f <sys_kthread_mutex_yieldlock+0x3b>
    return -1;
80107018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010701d:	eb 12                	jmp    80107031 <sys_kthread_mutex_yieldlock+0x4d>

  return kthread_mutex_yieldlock(mutex_id1, mutex_id2);
8010701f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107025:	89 54 24 04          	mov    %edx,0x4(%esp)
80107029:	89 04 24             	mov    %eax,(%esp)
8010702c:	e8 6f e7 ff ff       	call   801057a0 <kthread_mutex_yieldlock>
}
80107031:	c9                   	leave  
80107032:	c3                   	ret    

80107033 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107033:	55                   	push   %ebp
80107034:	89 e5                	mov    %esp,%ebp
80107036:	83 ec 08             	sub    $0x8,%esp
80107039:	8b 55 08             	mov    0x8(%ebp),%edx
8010703c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107043:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107046:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010704a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010704e:	ee                   	out    %al,(%dx)
}
8010704f:	c9                   	leave  
80107050:	c3                   	ret    

80107051 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107051:	55                   	push   %ebp
80107052:	89 e5                	mov    %esp,%ebp
80107054:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107057:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010705e:	00 
8010705f:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80107066:	e8 c8 ff ff ff       	call   80107033 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010706b:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80107072:	00 
80107073:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010707a:	e8 b4 ff ff ff       	call   80107033 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010707f:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80107086:	00 
80107087:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010708e:	e8 a0 ff ff ff       	call   80107033 <outb>
  picenable(IRQ_TIMER);
80107093:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010709a:	e8 3a cd ff ff       	call   80103dd9 <picenable>
}
8010709f:	c9                   	leave  
801070a0:	c3                   	ret    

801070a1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801070a1:	1e                   	push   %ds
  pushl %es
801070a2:	06                   	push   %es
  pushl %fs
801070a3:	0f a0                	push   %fs
  pushl %gs
801070a5:	0f a8                	push   %gs
  pushal
801070a7:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801070a8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801070ac:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801070ae:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801070b0:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801070b4:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801070b6:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801070b8:	54                   	push   %esp
  call trap
801070b9:	e8 d8 01 00 00       	call   80107296 <trap>
  addl $4, %esp
801070be:	83 c4 04             	add    $0x4,%esp

801070c1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801070c1:	61                   	popa   
  popl %gs
801070c2:	0f a9                	pop    %gs
  popl %fs
801070c4:	0f a1                	pop    %fs
  popl %es
801070c6:	07                   	pop    %es
  popl %ds
801070c7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801070c8:	83 c4 08             	add    $0x8,%esp
  iret
801070cb:	cf                   	iret   

801070cc <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801070cc:	55                   	push   %ebp
801070cd:	89 e5                	mov    %esp,%ebp
801070cf:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801070d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801070d5:	83 e8 01             	sub    $0x1,%eax
801070d8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070dc:	8b 45 08             	mov    0x8(%ebp),%eax
801070df:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070e3:	8b 45 08             	mov    0x8(%ebp),%eax
801070e6:	c1 e8 10             	shr    $0x10,%eax
801070e9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801070ed:	8d 45 fa             	lea    -0x6(%ebp),%eax
801070f0:	0f 01 18             	lidtl  (%eax)
}
801070f3:	c9                   	leave  
801070f4:	c3                   	ret    

801070f5 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801070f5:	55                   	push   %ebp
801070f6:	89 e5                	mov    %esp,%ebp
801070f8:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801070fb:	0f 20 d0             	mov    %cr2,%eax
801070fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107101:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107104:	c9                   	leave  
80107105:	c3                   	ret    

80107106 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107106:	55                   	push   %ebp
80107107:	89 e5                	mov    %esp,%ebp
80107109:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010710c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107113:	e9 c3 00 00 00       	jmp    801071db <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711b:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
80107122:	89 c2                	mov    %eax,%edx
80107124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107127:	66 89 14 c5 00 ea 11 	mov    %dx,-0x7fee1600(,%eax,8)
8010712e:	80 
8010712f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107132:	66 c7 04 c5 02 ea 11 	movw   $0x8,-0x7fee15fe(,%eax,8)
80107139:	80 08 00 
8010713c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010713f:	0f b6 14 c5 04 ea 11 	movzbl -0x7fee15fc(,%eax,8),%edx
80107146:	80 
80107147:	83 e2 e0             	and    $0xffffffe0,%edx
8010714a:	88 14 c5 04 ea 11 80 	mov    %dl,-0x7fee15fc(,%eax,8)
80107151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107154:	0f b6 14 c5 04 ea 11 	movzbl -0x7fee15fc(,%eax,8),%edx
8010715b:	80 
8010715c:	83 e2 1f             	and    $0x1f,%edx
8010715f:	88 14 c5 04 ea 11 80 	mov    %dl,-0x7fee15fc(,%eax,8)
80107166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107169:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
80107170:	80 
80107171:	83 e2 f0             	and    $0xfffffff0,%edx
80107174:	83 ca 0e             	or     $0xe,%edx
80107177:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
8010717e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107181:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
80107188:	80 
80107189:	83 e2 ef             	and    $0xffffffef,%edx
8010718c:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
80107193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107196:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
8010719d:	80 
8010719e:	83 e2 9f             	and    $0xffffff9f,%edx
801071a1:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
801071a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ab:	0f b6 14 c5 05 ea 11 	movzbl -0x7fee15fb(,%eax,8),%edx
801071b2:	80 
801071b3:	83 ca 80             	or     $0xffffff80,%edx
801071b6:	88 14 c5 05 ea 11 80 	mov    %dl,-0x7fee15fb(,%eax,8)
801071bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c0:	8b 04 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%eax
801071c7:	c1 e8 10             	shr    $0x10,%eax
801071ca:	89 c2                	mov    %eax,%edx
801071cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071cf:	66 89 14 c5 06 ea 11 	mov    %dx,-0x7fee15fa(,%eax,8)
801071d6:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801071d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071db:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801071e2:	0f 8e 30 ff ff ff    	jle    80107118 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801071e8:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
801071ed:	66 a3 00 ec 11 80    	mov    %ax,0x8011ec00
801071f3:	66 c7 05 02 ec 11 80 	movw   $0x8,0x8011ec02
801071fa:	08 00 
801071fc:	0f b6 05 04 ec 11 80 	movzbl 0x8011ec04,%eax
80107203:	83 e0 e0             	and    $0xffffffe0,%eax
80107206:	a2 04 ec 11 80       	mov    %al,0x8011ec04
8010720b:	0f b6 05 04 ec 11 80 	movzbl 0x8011ec04,%eax
80107212:	83 e0 1f             	and    $0x1f,%eax
80107215:	a2 04 ec 11 80       	mov    %al,0x8011ec04
8010721a:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
80107221:	83 c8 0f             	or     $0xf,%eax
80107224:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107229:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
80107230:	83 e0 ef             	and    $0xffffffef,%eax
80107233:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107238:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
8010723f:	83 c8 60             	or     $0x60,%eax
80107242:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107247:	0f b6 05 05 ec 11 80 	movzbl 0x8011ec05,%eax
8010724e:	83 c8 80             	or     $0xffffff80,%eax
80107251:	a2 05 ec 11 80       	mov    %al,0x8011ec05
80107256:	a1 bc c1 10 80       	mov    0x8010c1bc,%eax
8010725b:	c1 e8 10             	shr    $0x10,%eax
8010725e:	66 a3 06 ec 11 80    	mov    %ax,0x8011ec06
  
  initlock(&tickslock, "time");
80107264:	c7 44 24 04 a0 95 10 	movl   $0x801095a0,0x4(%esp)
8010726b:	80 
8010726c:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80107273:	e8 d7 e5 ff ff       	call   8010584f <initlock>
}
80107278:	c9                   	leave  
80107279:	c3                   	ret    

8010727a <idtinit>:

void
idtinit(void)
{
8010727a:	55                   	push   %ebp
8010727b:	89 e5                	mov    %esp,%ebp
8010727d:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107280:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107287:	00 
80107288:	c7 04 24 00 ea 11 80 	movl   $0x8011ea00,(%esp)
8010728f:	e8 38 fe ff ff       	call   801070cc <lidt>
}
80107294:	c9                   	leave  
80107295:	c3                   	ret    

80107296 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107296:	55                   	push   %ebp
80107297:	89 e5                	mov    %esp,%ebp
80107299:	57                   	push   %edi
8010729a:	56                   	push   %esi
8010729b:	53                   	push   %ebx
8010729c:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010729f:	8b 45 08             	mov    0x8(%ebp),%eax
801072a2:	8b 40 30             	mov    0x30(%eax),%eax
801072a5:	83 f8 40             	cmp    $0x40,%eax
801072a8:	75 45                	jne    801072ef <trap+0x59>
    if(thread->proc->killed)
801072aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072b0:	8b 40 0c             	mov    0xc(%eax),%eax
801072b3:	8b 40 18             	mov    0x18(%eax),%eax
801072b6:	85 c0                	test   %eax,%eax
801072b8:	74 05                	je     801072bf <trap+0x29>
      exit();
801072ba:	e8 52 d6 ff ff       	call   80104911 <exit>
    thread->tf = tf;
801072bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072c5:	8b 55 08             	mov    0x8(%ebp),%edx
801072c8:	89 50 10             	mov    %edx,0x10(%eax)
    syscall();
801072cb:	e8 0f ec ff ff       	call   80105edf <syscall>
    if(thread->proc->killed)
801072d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072d6:	8b 40 0c             	mov    0xc(%eax),%eax
801072d9:	8b 40 18             	mov    0x18(%eax),%eax
801072dc:	85 c0                	test   %eax,%eax
801072de:	74 0a                	je     801072ea <trap+0x54>
      exit();
801072e0:	e8 2c d6 ff ff       	call   80104911 <exit>
    return;
801072e5:	e9 7d 02 00 00       	jmp    80107567 <trap+0x2d1>
801072ea:	e9 78 02 00 00       	jmp    80107567 <trap+0x2d1>
  }

  switch(tf->trapno){
801072ef:	8b 45 08             	mov    0x8(%ebp),%eax
801072f2:	8b 40 30             	mov    0x30(%eax),%eax
801072f5:	83 e8 20             	sub    $0x20,%eax
801072f8:	83 f8 1f             	cmp    $0x1f,%eax
801072fb:	0f 87 bc 00 00 00    	ja     801073bd <trap+0x127>
80107301:	8b 04 85 58 96 10 80 	mov    -0x7fef69a8(,%eax,4),%eax
80107308:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010730a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107310:	0f b6 00             	movzbl (%eax),%eax
80107313:	84 c0                	test   %al,%al
80107315:	75 31                	jne    80107348 <trap+0xb2>
      acquire(&tickslock);
80107317:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
8010731e:	e8 4d e5 ff ff       	call   80105870 <acquire>
      ticks++;
80107323:	a1 00 f2 11 80       	mov    0x8011f200,%eax
80107328:	83 c0 01             	add    $0x1,%eax
8010732b:	a3 00 f2 11 80       	mov    %eax,0x8011f200
      wakeup(&ticks);
80107330:	c7 04 24 00 f2 11 80 	movl   $0x8011f200,(%esp)
80107337:	e8 d7 db ff ff       	call   80104f13 <wakeup>
      release(&tickslock);
8010733c:	c7 04 24 c0 e9 11 80 	movl   $0x8011e9c0,(%esp)
80107343:	e8 8a e5 ff ff       	call   801058d2 <release>
    }
    lapiceoi();
80107348:	e8 a8 bb ff ff       	call   80102ef5 <lapiceoi>
    break;
8010734d:	e9 64 01 00 00       	jmp    801074b6 <trap+0x220>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107352:	e8 ac b3 ff ff       	call   80102703 <ideintr>
    lapiceoi();
80107357:	e8 99 bb ff ff       	call   80102ef5 <lapiceoi>
    break;
8010735c:	e9 55 01 00 00       	jmp    801074b6 <trap+0x220>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107361:	e8 5e b9 ff ff       	call   80102cc4 <kbdintr>
    lapiceoi();
80107366:	e8 8a bb ff ff       	call   80102ef5 <lapiceoi>
    break;
8010736b:	e9 46 01 00 00       	jmp    801074b6 <trap+0x220>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107370:	e8 e7 03 00 00       	call   8010775c <uartintr>
    lapiceoi();
80107375:	e8 7b bb ff ff       	call   80102ef5 <lapiceoi>
    break;
8010737a:	e9 37 01 00 00       	jmp    801074b6 <trap+0x220>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010737f:	8b 45 08             	mov    0x8(%ebp),%eax
80107382:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107385:	8b 45 08             	mov    0x8(%ebp),%eax
80107388:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010738c:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010738f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107395:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107398:	0f b6 c0             	movzbl %al,%eax
8010739b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010739f:	89 54 24 08          	mov    %edx,0x8(%esp)
801073a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801073a7:	c7 04 24 a8 95 10 80 	movl   $0x801095a8,(%esp)
801073ae:	e8 ed 8f ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801073b3:	e8 3d bb ff ff       	call   80102ef5 <lapiceoi>
    break;
801073b8:	e9 f9 00 00 00       	jmp    801074b6 <trap+0x220>
   
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
801073bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073c3:	85 c0                	test   %eax,%eax
801073c5:	74 11                	je     801073d8 <trap+0x142>
801073c7:	8b 45 08             	mov    0x8(%ebp),%eax
801073ca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073ce:	0f b7 c0             	movzwl %ax,%eax
801073d1:	83 e0 03             	and    $0x3,%eax
801073d4:	85 c0                	test   %eax,%eax
801073d6:	75 60                	jne    80107438 <trap+0x1a2>
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
801073d8:	8b 45 08             	mov    0x8(%ebp),%eax
801073db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073df:	0f b7 c0             	movzwl %ax,%eax
801073e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801073e6:	c7 04 24 cc 95 10 80 	movl   $0x801095cc,(%esp)
801073ed:	e8 ae 8f ff ff       	call   801003a0 <cprintf>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801073f2:	e8 fe fc ff ff       	call   801070f5 <rcr2>
801073f7:	8b 55 08             	mov    0x8(%ebp),%edx
801073fa:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801073fd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107404:	0f b6 12             	movzbl (%edx),%edx
  //PAGEBREAK: 13
  default:
    if(thread == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf(" thread %p %p \n", tf->cs);
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107407:	0f b6 ca             	movzbl %dl,%ecx
8010740a:	8b 55 08             	mov    0x8(%ebp),%edx
8010740d:	8b 52 30             	mov    0x30(%edx),%edx
80107410:	89 44 24 10          	mov    %eax,0x10(%esp)
80107414:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80107418:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010741c:	89 54 24 04          	mov    %edx,0x4(%esp)
80107420:	c7 04 24 dc 95 10 80 	movl   $0x801095dc,(%esp)
80107427:	e8 74 8f ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010742c:	c7 04 24 0e 96 10 80 	movl   $0x8010960e,(%esp)
80107433:	e8 02 91 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107438:	e8 b8 fc ff ff       	call   801070f5 <rcr2>
8010743d:	89 c2                	mov    %eax,%edx
8010743f:	8b 45 08             	mov    0x8(%ebp),%eax
80107442:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
80107445:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010744b:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010744e:	0f b6 f0             	movzbl %al,%esi
80107451:	8b 45 08             	mov    0x8(%ebp),%eax
80107454:	8b 58 34             	mov    0x34(%eax),%ebx
80107457:	8b 45 08             	mov    0x8(%ebp),%eax
8010745a:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
8010745d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107463:	8b 40 0c             	mov    0xc(%eax),%eax
80107466:	83 c0 60             	add    $0x60,%eax
80107469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010746c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107472:	8b 40 0c             	mov    0xc(%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107475:	8b 40 0c             	mov    0xc(%eax),%eax
80107478:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010747c:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107480:	89 74 24 14          	mov    %esi,0x14(%esp)
80107484:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107488:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010748c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010748f:	89 74 24 08          	mov    %esi,0x8(%esp)
80107493:	89 44 24 04          	mov    %eax,0x4(%esp)
80107497:	c7 04 24 14 96 10 80 	movl   $0x80109614,(%esp)
8010749e:	e8 fd 8e ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
			thread->proc->pid, thread->proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    thread->proc->killed = 1;
801074a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074a9:	8b 40 0c             	mov    0xc(%eax),%eax
801074ac:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
801074b3:	eb 01                	jmp    801074b6 <trap+0x220>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801074b5:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(thread && thread->proc  && thread->proc->killed && (tf->cs&3) == DPL_USER)
801074b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074bc:	85 c0                	test   %eax,%eax
801074be:	74 34                	je     801074f4 <trap+0x25e>
801074c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074c6:	8b 40 0c             	mov    0xc(%eax),%eax
801074c9:	85 c0                	test   %eax,%eax
801074cb:	74 27                	je     801074f4 <trap+0x25e>
801074cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074d3:	8b 40 0c             	mov    0xc(%eax),%eax
801074d6:	8b 40 18             	mov    0x18(%eax),%eax
801074d9:	85 c0                	test   %eax,%eax
801074db:	74 17                	je     801074f4 <trap+0x25e>
801074dd:	8b 45 08             	mov    0x8(%ebp),%eax
801074e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801074e4:	0f b7 c0             	movzwl %ax,%eax
801074e7:	83 e0 03             	and    $0x3,%eax
801074ea:	83 f8 03             	cmp    $0x3,%eax
801074ed:	75 05                	jne    801074f4 <trap+0x25e>
    exit();
801074ef:	e8 1d d4 ff ff       	call   80104911 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if(thread && thread->proc && thread->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801074f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074fa:	85 c0                	test   %eax,%eax
801074fc:	74 2b                	je     80107529 <trap+0x293>
801074fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107504:	8b 40 0c             	mov    0xc(%eax),%eax
80107507:	85 c0                	test   %eax,%eax
80107509:	74 1e                	je     80107529 <trap+0x293>
8010750b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107511:	8b 40 04             	mov    0x4(%eax),%eax
80107514:	83 f8 04             	cmp    $0x4,%eax
80107517:	75 10                	jne    80107529 <trap+0x293>
80107519:	8b 45 08             	mov    0x8(%ebp),%eax
8010751c:	8b 40 30             	mov    0x30(%eax),%eax
8010751f:	83 f8 20             	cmp    $0x20,%eax
80107522:	75 05                	jne    80107529 <trap+0x293>

    yield();
80107524:	e8 94 d8 ff ff       	call   80104dbd <yield>

  }

  // Check if the process has been killed since we yielded
  if(thread && thread->proc && thread->proc->killed && (tf->cs&3) == DPL_USER)
80107529:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010752f:	85 c0                	test   %eax,%eax
80107531:	74 34                	je     80107567 <trap+0x2d1>
80107533:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107539:	8b 40 0c             	mov    0xc(%eax),%eax
8010753c:	85 c0                	test   %eax,%eax
8010753e:	74 27                	je     80107567 <trap+0x2d1>
80107540:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107546:	8b 40 0c             	mov    0xc(%eax),%eax
80107549:	8b 40 18             	mov    0x18(%eax),%eax
8010754c:	85 c0                	test   %eax,%eax
8010754e:	74 17                	je     80107567 <trap+0x2d1>
80107550:	8b 45 08             	mov    0x8(%ebp),%eax
80107553:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107557:	0f b7 c0             	movzwl %ax,%eax
8010755a:	83 e0 03             	and    $0x3,%eax
8010755d:	83 f8 03             	cmp    $0x3,%eax
80107560:	75 05                	jne    80107567 <trap+0x2d1>
    exit();
80107562:	e8 aa d3 ff ff       	call   80104911 <exit>
}
80107567:	83 c4 3c             	add    $0x3c,%esp
8010756a:	5b                   	pop    %ebx
8010756b:	5e                   	pop    %esi
8010756c:	5f                   	pop    %edi
8010756d:	5d                   	pop    %ebp
8010756e:	c3                   	ret    

8010756f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010756f:	55                   	push   %ebp
80107570:	89 e5                	mov    %esp,%ebp
80107572:	83 ec 14             	sub    $0x14,%esp
80107575:	8b 45 08             	mov    0x8(%ebp),%eax
80107578:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010757c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107580:	89 c2                	mov    %eax,%edx
80107582:	ec                   	in     (%dx),%al
80107583:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107586:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010758a:	c9                   	leave  
8010758b:	c3                   	ret    

8010758c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010758c:	55                   	push   %ebp
8010758d:	89 e5                	mov    %esp,%ebp
8010758f:	83 ec 08             	sub    $0x8,%esp
80107592:	8b 55 08             	mov    0x8(%ebp),%edx
80107595:	8b 45 0c             	mov    0xc(%ebp),%eax
80107598:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010759c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010759f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801075a3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801075a7:	ee                   	out    %al,(%dx)
}
801075a8:	c9                   	leave  
801075a9:	c3                   	ret    

801075aa <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801075aa:	55                   	push   %ebp
801075ab:	89 e5                	mov    %esp,%ebp
801075ad:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801075b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801075b7:	00 
801075b8:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801075bf:	e8 c8 ff ff ff       	call   8010758c <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801075c4:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801075cb:	00 
801075cc:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801075d3:	e8 b4 ff ff ff       	call   8010758c <outb>
  outb(COM1+0, 115200/9600);
801075d8:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801075df:	00 
801075e0:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801075e7:	e8 a0 ff ff ff       	call   8010758c <outb>
  outb(COM1+1, 0);
801075ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801075f3:	00 
801075f4:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801075fb:	e8 8c ff ff ff       	call   8010758c <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107600:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107607:	00 
80107608:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010760f:	e8 78 ff ff ff       	call   8010758c <outb>
  outb(COM1+4, 0);
80107614:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010761b:	00 
8010761c:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107623:	e8 64 ff ff ff       	call   8010758c <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107628:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010762f:	00 
80107630:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107637:	e8 50 ff ff ff       	call   8010758c <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010763c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107643:	e8 27 ff ff ff       	call   8010756f <inb>
80107648:	3c ff                	cmp    $0xff,%al
8010764a:	75 02                	jne    8010764e <uartinit+0xa4>
    return;
8010764c:	eb 6a                	jmp    801076b8 <uartinit+0x10e>
  uart = 1;
8010764e:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107655:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107658:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010765f:	e8 0b ff ff ff       	call   8010756f <inb>
  inb(COM1+0);
80107664:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010766b:	e8 ff fe ff ff       	call   8010756f <inb>
  picenable(IRQ_COM1);
80107670:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107677:	e8 5d c7 ff ff       	call   80103dd9 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010767c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107683:	00 
80107684:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010768b:	e8 f2 b2 ff ff       	call   80102982 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107690:	c7 45 f4 d8 96 10 80 	movl   $0x801096d8,-0xc(%ebp)
80107697:	eb 15                	jmp    801076ae <uartinit+0x104>
    uartputc(*p);
80107699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769c:	0f b6 00             	movzbl (%eax),%eax
8010769f:	0f be c0             	movsbl %al,%eax
801076a2:	89 04 24             	mov    %eax,(%esp)
801076a5:	e8 10 00 00 00       	call   801076ba <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801076aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801076ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b1:	0f b6 00             	movzbl (%eax),%eax
801076b4:	84 c0                	test   %al,%al
801076b6:	75 e1                	jne    80107699 <uartinit+0xef>
    uartputc(*p);
}
801076b8:	c9                   	leave  
801076b9:	c3                   	ret    

801076ba <uartputc>:

void
uartputc(int c)
{
801076ba:	55                   	push   %ebp
801076bb:	89 e5                	mov    %esp,%ebp
801076bd:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801076c0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801076c5:	85 c0                	test   %eax,%eax
801076c7:	75 02                	jne    801076cb <uartputc+0x11>
    return;
801076c9:	eb 4b                	jmp    80107716 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801076d2:	eb 10                	jmp    801076e4 <uartputc+0x2a>
    microdelay(10);
801076d4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801076db:	e8 3a b8 ff ff       	call   80102f1a <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801076e4:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801076e8:	7f 16                	jg     80107700 <uartputc+0x46>
801076ea:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801076f1:	e8 79 fe ff ff       	call   8010756f <inb>
801076f6:	0f b6 c0             	movzbl %al,%eax
801076f9:	83 e0 20             	and    $0x20,%eax
801076fc:	85 c0                	test   %eax,%eax
801076fe:	74 d4                	je     801076d4 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80107700:	8b 45 08             	mov    0x8(%ebp),%eax
80107703:	0f b6 c0             	movzbl %al,%eax
80107706:	89 44 24 04          	mov    %eax,0x4(%esp)
8010770a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107711:	e8 76 fe ff ff       	call   8010758c <outb>
}
80107716:	c9                   	leave  
80107717:	c3                   	ret    

80107718 <uartgetc>:

static int
uartgetc(void)
{
80107718:	55                   	push   %ebp
80107719:	89 e5                	mov    %esp,%ebp
8010771b:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010771e:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107723:	85 c0                	test   %eax,%eax
80107725:	75 07                	jne    8010772e <uartgetc+0x16>
    return -1;
80107727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010772c:	eb 2c                	jmp    8010775a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010772e:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107735:	e8 35 fe ff ff       	call   8010756f <inb>
8010773a:	0f b6 c0             	movzbl %al,%eax
8010773d:	83 e0 01             	and    $0x1,%eax
80107740:	85 c0                	test   %eax,%eax
80107742:	75 07                	jne    8010774b <uartgetc+0x33>
    return -1;
80107744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107749:	eb 0f                	jmp    8010775a <uartgetc+0x42>
  return inb(COM1+0);
8010774b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107752:	e8 18 fe ff ff       	call   8010756f <inb>
80107757:	0f b6 c0             	movzbl %al,%eax
}
8010775a:	c9                   	leave  
8010775b:	c3                   	ret    

8010775c <uartintr>:

void
uartintr(void)
{
8010775c:	55                   	push   %ebp
8010775d:	89 e5                	mov    %esp,%ebp
8010775f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107762:	c7 04 24 18 77 10 80 	movl   $0x80107718,(%esp)
80107769:	e8 3f 90 ff ff       	call   801007ad <consoleintr>
}
8010776e:	c9                   	leave  
8010776f:	c3                   	ret    

80107770 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $0
80107772:	6a 00                	push   $0x0
  jmp alltraps
80107774:	e9 28 f9 ff ff       	jmp    801070a1 <alltraps>

80107779 <vector1>:
.globl vector1
vector1:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $1
8010777b:	6a 01                	push   $0x1
  jmp alltraps
8010777d:	e9 1f f9 ff ff       	jmp    801070a1 <alltraps>

80107782 <vector2>:
.globl vector2
vector2:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $2
80107784:	6a 02                	push   $0x2
  jmp alltraps
80107786:	e9 16 f9 ff ff       	jmp    801070a1 <alltraps>

8010778b <vector3>:
.globl vector3
vector3:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $3
8010778d:	6a 03                	push   $0x3
  jmp alltraps
8010778f:	e9 0d f9 ff ff       	jmp    801070a1 <alltraps>

80107794 <vector4>:
.globl vector4
vector4:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $4
80107796:	6a 04                	push   $0x4
  jmp alltraps
80107798:	e9 04 f9 ff ff       	jmp    801070a1 <alltraps>

8010779d <vector5>:
.globl vector5
vector5:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $5
8010779f:	6a 05                	push   $0x5
  jmp alltraps
801077a1:	e9 fb f8 ff ff       	jmp    801070a1 <alltraps>

801077a6 <vector6>:
.globl vector6
vector6:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $6
801077a8:	6a 06                	push   $0x6
  jmp alltraps
801077aa:	e9 f2 f8 ff ff       	jmp    801070a1 <alltraps>

801077af <vector7>:
.globl vector7
vector7:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $7
801077b1:	6a 07                	push   $0x7
  jmp alltraps
801077b3:	e9 e9 f8 ff ff       	jmp    801070a1 <alltraps>

801077b8 <vector8>:
.globl vector8
vector8:
  pushl $8
801077b8:	6a 08                	push   $0x8
  jmp alltraps
801077ba:	e9 e2 f8 ff ff       	jmp    801070a1 <alltraps>

801077bf <vector9>:
.globl vector9
vector9:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $9
801077c1:	6a 09                	push   $0x9
  jmp alltraps
801077c3:	e9 d9 f8 ff ff       	jmp    801070a1 <alltraps>

801077c8 <vector10>:
.globl vector10
vector10:
  pushl $10
801077c8:	6a 0a                	push   $0xa
  jmp alltraps
801077ca:	e9 d2 f8 ff ff       	jmp    801070a1 <alltraps>

801077cf <vector11>:
.globl vector11
vector11:
  pushl $11
801077cf:	6a 0b                	push   $0xb
  jmp alltraps
801077d1:	e9 cb f8 ff ff       	jmp    801070a1 <alltraps>

801077d6 <vector12>:
.globl vector12
vector12:
  pushl $12
801077d6:	6a 0c                	push   $0xc
  jmp alltraps
801077d8:	e9 c4 f8 ff ff       	jmp    801070a1 <alltraps>

801077dd <vector13>:
.globl vector13
vector13:
  pushl $13
801077dd:	6a 0d                	push   $0xd
  jmp alltraps
801077df:	e9 bd f8 ff ff       	jmp    801070a1 <alltraps>

801077e4 <vector14>:
.globl vector14
vector14:
  pushl $14
801077e4:	6a 0e                	push   $0xe
  jmp alltraps
801077e6:	e9 b6 f8 ff ff       	jmp    801070a1 <alltraps>

801077eb <vector15>:
.globl vector15
vector15:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $15
801077ed:	6a 0f                	push   $0xf
  jmp alltraps
801077ef:	e9 ad f8 ff ff       	jmp    801070a1 <alltraps>

801077f4 <vector16>:
.globl vector16
vector16:
  pushl $0
801077f4:	6a 00                	push   $0x0
  pushl $16
801077f6:	6a 10                	push   $0x10
  jmp alltraps
801077f8:	e9 a4 f8 ff ff       	jmp    801070a1 <alltraps>

801077fd <vector17>:
.globl vector17
vector17:
  pushl $17
801077fd:	6a 11                	push   $0x11
  jmp alltraps
801077ff:	e9 9d f8 ff ff       	jmp    801070a1 <alltraps>

80107804 <vector18>:
.globl vector18
vector18:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $18
80107806:	6a 12                	push   $0x12
  jmp alltraps
80107808:	e9 94 f8 ff ff       	jmp    801070a1 <alltraps>

8010780d <vector19>:
.globl vector19
vector19:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $19
8010780f:	6a 13                	push   $0x13
  jmp alltraps
80107811:	e9 8b f8 ff ff       	jmp    801070a1 <alltraps>

80107816 <vector20>:
.globl vector20
vector20:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $20
80107818:	6a 14                	push   $0x14
  jmp alltraps
8010781a:	e9 82 f8 ff ff       	jmp    801070a1 <alltraps>

8010781f <vector21>:
.globl vector21
vector21:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $21
80107821:	6a 15                	push   $0x15
  jmp alltraps
80107823:	e9 79 f8 ff ff       	jmp    801070a1 <alltraps>

80107828 <vector22>:
.globl vector22
vector22:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $22
8010782a:	6a 16                	push   $0x16
  jmp alltraps
8010782c:	e9 70 f8 ff ff       	jmp    801070a1 <alltraps>

80107831 <vector23>:
.globl vector23
vector23:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $23
80107833:	6a 17                	push   $0x17
  jmp alltraps
80107835:	e9 67 f8 ff ff       	jmp    801070a1 <alltraps>

8010783a <vector24>:
.globl vector24
vector24:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $24
8010783c:	6a 18                	push   $0x18
  jmp alltraps
8010783e:	e9 5e f8 ff ff       	jmp    801070a1 <alltraps>

80107843 <vector25>:
.globl vector25
vector25:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $25
80107845:	6a 19                	push   $0x19
  jmp alltraps
80107847:	e9 55 f8 ff ff       	jmp    801070a1 <alltraps>

8010784c <vector26>:
.globl vector26
vector26:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $26
8010784e:	6a 1a                	push   $0x1a
  jmp alltraps
80107850:	e9 4c f8 ff ff       	jmp    801070a1 <alltraps>

80107855 <vector27>:
.globl vector27
vector27:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $27
80107857:	6a 1b                	push   $0x1b
  jmp alltraps
80107859:	e9 43 f8 ff ff       	jmp    801070a1 <alltraps>

8010785e <vector28>:
.globl vector28
vector28:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $28
80107860:	6a 1c                	push   $0x1c
  jmp alltraps
80107862:	e9 3a f8 ff ff       	jmp    801070a1 <alltraps>

80107867 <vector29>:
.globl vector29
vector29:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $29
80107869:	6a 1d                	push   $0x1d
  jmp alltraps
8010786b:	e9 31 f8 ff ff       	jmp    801070a1 <alltraps>

80107870 <vector30>:
.globl vector30
vector30:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $30
80107872:	6a 1e                	push   $0x1e
  jmp alltraps
80107874:	e9 28 f8 ff ff       	jmp    801070a1 <alltraps>

80107879 <vector31>:
.globl vector31
vector31:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $31
8010787b:	6a 1f                	push   $0x1f
  jmp alltraps
8010787d:	e9 1f f8 ff ff       	jmp    801070a1 <alltraps>

80107882 <vector32>:
.globl vector32
vector32:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $32
80107884:	6a 20                	push   $0x20
  jmp alltraps
80107886:	e9 16 f8 ff ff       	jmp    801070a1 <alltraps>

8010788b <vector33>:
.globl vector33
vector33:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $33
8010788d:	6a 21                	push   $0x21
  jmp alltraps
8010788f:	e9 0d f8 ff ff       	jmp    801070a1 <alltraps>

80107894 <vector34>:
.globl vector34
vector34:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $34
80107896:	6a 22                	push   $0x22
  jmp alltraps
80107898:	e9 04 f8 ff ff       	jmp    801070a1 <alltraps>

8010789d <vector35>:
.globl vector35
vector35:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $35
8010789f:	6a 23                	push   $0x23
  jmp alltraps
801078a1:	e9 fb f7 ff ff       	jmp    801070a1 <alltraps>

801078a6 <vector36>:
.globl vector36
vector36:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $36
801078a8:	6a 24                	push   $0x24
  jmp alltraps
801078aa:	e9 f2 f7 ff ff       	jmp    801070a1 <alltraps>

801078af <vector37>:
.globl vector37
vector37:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $37
801078b1:	6a 25                	push   $0x25
  jmp alltraps
801078b3:	e9 e9 f7 ff ff       	jmp    801070a1 <alltraps>

801078b8 <vector38>:
.globl vector38
vector38:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $38
801078ba:	6a 26                	push   $0x26
  jmp alltraps
801078bc:	e9 e0 f7 ff ff       	jmp    801070a1 <alltraps>

801078c1 <vector39>:
.globl vector39
vector39:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $39
801078c3:	6a 27                	push   $0x27
  jmp alltraps
801078c5:	e9 d7 f7 ff ff       	jmp    801070a1 <alltraps>

801078ca <vector40>:
.globl vector40
vector40:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $40
801078cc:	6a 28                	push   $0x28
  jmp alltraps
801078ce:	e9 ce f7 ff ff       	jmp    801070a1 <alltraps>

801078d3 <vector41>:
.globl vector41
vector41:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $41
801078d5:	6a 29                	push   $0x29
  jmp alltraps
801078d7:	e9 c5 f7 ff ff       	jmp    801070a1 <alltraps>

801078dc <vector42>:
.globl vector42
vector42:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $42
801078de:	6a 2a                	push   $0x2a
  jmp alltraps
801078e0:	e9 bc f7 ff ff       	jmp    801070a1 <alltraps>

801078e5 <vector43>:
.globl vector43
vector43:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $43
801078e7:	6a 2b                	push   $0x2b
  jmp alltraps
801078e9:	e9 b3 f7 ff ff       	jmp    801070a1 <alltraps>

801078ee <vector44>:
.globl vector44
vector44:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $44
801078f0:	6a 2c                	push   $0x2c
  jmp alltraps
801078f2:	e9 aa f7 ff ff       	jmp    801070a1 <alltraps>

801078f7 <vector45>:
.globl vector45
vector45:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $45
801078f9:	6a 2d                	push   $0x2d
  jmp alltraps
801078fb:	e9 a1 f7 ff ff       	jmp    801070a1 <alltraps>

80107900 <vector46>:
.globl vector46
vector46:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $46
80107902:	6a 2e                	push   $0x2e
  jmp alltraps
80107904:	e9 98 f7 ff ff       	jmp    801070a1 <alltraps>

80107909 <vector47>:
.globl vector47
vector47:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $47
8010790b:	6a 2f                	push   $0x2f
  jmp alltraps
8010790d:	e9 8f f7 ff ff       	jmp    801070a1 <alltraps>

80107912 <vector48>:
.globl vector48
vector48:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $48
80107914:	6a 30                	push   $0x30
  jmp alltraps
80107916:	e9 86 f7 ff ff       	jmp    801070a1 <alltraps>

8010791b <vector49>:
.globl vector49
vector49:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $49
8010791d:	6a 31                	push   $0x31
  jmp alltraps
8010791f:	e9 7d f7 ff ff       	jmp    801070a1 <alltraps>

80107924 <vector50>:
.globl vector50
vector50:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $50
80107926:	6a 32                	push   $0x32
  jmp alltraps
80107928:	e9 74 f7 ff ff       	jmp    801070a1 <alltraps>

8010792d <vector51>:
.globl vector51
vector51:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $51
8010792f:	6a 33                	push   $0x33
  jmp alltraps
80107931:	e9 6b f7 ff ff       	jmp    801070a1 <alltraps>

80107936 <vector52>:
.globl vector52
vector52:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $52
80107938:	6a 34                	push   $0x34
  jmp alltraps
8010793a:	e9 62 f7 ff ff       	jmp    801070a1 <alltraps>

8010793f <vector53>:
.globl vector53
vector53:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $53
80107941:	6a 35                	push   $0x35
  jmp alltraps
80107943:	e9 59 f7 ff ff       	jmp    801070a1 <alltraps>

80107948 <vector54>:
.globl vector54
vector54:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $54
8010794a:	6a 36                	push   $0x36
  jmp alltraps
8010794c:	e9 50 f7 ff ff       	jmp    801070a1 <alltraps>

80107951 <vector55>:
.globl vector55
vector55:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $55
80107953:	6a 37                	push   $0x37
  jmp alltraps
80107955:	e9 47 f7 ff ff       	jmp    801070a1 <alltraps>

8010795a <vector56>:
.globl vector56
vector56:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $56
8010795c:	6a 38                	push   $0x38
  jmp alltraps
8010795e:	e9 3e f7 ff ff       	jmp    801070a1 <alltraps>

80107963 <vector57>:
.globl vector57
vector57:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $57
80107965:	6a 39                	push   $0x39
  jmp alltraps
80107967:	e9 35 f7 ff ff       	jmp    801070a1 <alltraps>

8010796c <vector58>:
.globl vector58
vector58:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $58
8010796e:	6a 3a                	push   $0x3a
  jmp alltraps
80107970:	e9 2c f7 ff ff       	jmp    801070a1 <alltraps>

80107975 <vector59>:
.globl vector59
vector59:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $59
80107977:	6a 3b                	push   $0x3b
  jmp alltraps
80107979:	e9 23 f7 ff ff       	jmp    801070a1 <alltraps>

8010797e <vector60>:
.globl vector60
vector60:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $60
80107980:	6a 3c                	push   $0x3c
  jmp alltraps
80107982:	e9 1a f7 ff ff       	jmp    801070a1 <alltraps>

80107987 <vector61>:
.globl vector61
vector61:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $61
80107989:	6a 3d                	push   $0x3d
  jmp alltraps
8010798b:	e9 11 f7 ff ff       	jmp    801070a1 <alltraps>

80107990 <vector62>:
.globl vector62
vector62:
  pushl $0
80107990:	6a 00                	push   $0x0
  pushl $62
80107992:	6a 3e                	push   $0x3e
  jmp alltraps
80107994:	e9 08 f7 ff ff       	jmp    801070a1 <alltraps>

80107999 <vector63>:
.globl vector63
vector63:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $63
8010799b:	6a 3f                	push   $0x3f
  jmp alltraps
8010799d:	e9 ff f6 ff ff       	jmp    801070a1 <alltraps>

801079a2 <vector64>:
.globl vector64
vector64:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $64
801079a4:	6a 40                	push   $0x40
  jmp alltraps
801079a6:	e9 f6 f6 ff ff       	jmp    801070a1 <alltraps>

801079ab <vector65>:
.globl vector65
vector65:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $65
801079ad:	6a 41                	push   $0x41
  jmp alltraps
801079af:	e9 ed f6 ff ff       	jmp    801070a1 <alltraps>

801079b4 <vector66>:
.globl vector66
vector66:
  pushl $0
801079b4:	6a 00                	push   $0x0
  pushl $66
801079b6:	6a 42                	push   $0x42
  jmp alltraps
801079b8:	e9 e4 f6 ff ff       	jmp    801070a1 <alltraps>

801079bd <vector67>:
.globl vector67
vector67:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $67
801079bf:	6a 43                	push   $0x43
  jmp alltraps
801079c1:	e9 db f6 ff ff       	jmp    801070a1 <alltraps>

801079c6 <vector68>:
.globl vector68
vector68:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $68
801079c8:	6a 44                	push   $0x44
  jmp alltraps
801079ca:	e9 d2 f6 ff ff       	jmp    801070a1 <alltraps>

801079cf <vector69>:
.globl vector69
vector69:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $69
801079d1:	6a 45                	push   $0x45
  jmp alltraps
801079d3:	e9 c9 f6 ff ff       	jmp    801070a1 <alltraps>

801079d8 <vector70>:
.globl vector70
vector70:
  pushl $0
801079d8:	6a 00                	push   $0x0
  pushl $70
801079da:	6a 46                	push   $0x46
  jmp alltraps
801079dc:	e9 c0 f6 ff ff       	jmp    801070a1 <alltraps>

801079e1 <vector71>:
.globl vector71
vector71:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $71
801079e3:	6a 47                	push   $0x47
  jmp alltraps
801079e5:	e9 b7 f6 ff ff       	jmp    801070a1 <alltraps>

801079ea <vector72>:
.globl vector72
vector72:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $72
801079ec:	6a 48                	push   $0x48
  jmp alltraps
801079ee:	e9 ae f6 ff ff       	jmp    801070a1 <alltraps>

801079f3 <vector73>:
.globl vector73
vector73:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $73
801079f5:	6a 49                	push   $0x49
  jmp alltraps
801079f7:	e9 a5 f6 ff ff       	jmp    801070a1 <alltraps>

801079fc <vector74>:
.globl vector74
vector74:
  pushl $0
801079fc:	6a 00                	push   $0x0
  pushl $74
801079fe:	6a 4a                	push   $0x4a
  jmp alltraps
80107a00:	e9 9c f6 ff ff       	jmp    801070a1 <alltraps>

80107a05 <vector75>:
.globl vector75
vector75:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $75
80107a07:	6a 4b                	push   $0x4b
  jmp alltraps
80107a09:	e9 93 f6 ff ff       	jmp    801070a1 <alltraps>

80107a0e <vector76>:
.globl vector76
vector76:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $76
80107a10:	6a 4c                	push   $0x4c
  jmp alltraps
80107a12:	e9 8a f6 ff ff       	jmp    801070a1 <alltraps>

80107a17 <vector77>:
.globl vector77
vector77:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $77
80107a19:	6a 4d                	push   $0x4d
  jmp alltraps
80107a1b:	e9 81 f6 ff ff       	jmp    801070a1 <alltraps>

80107a20 <vector78>:
.globl vector78
vector78:
  pushl $0
80107a20:	6a 00                	push   $0x0
  pushl $78
80107a22:	6a 4e                	push   $0x4e
  jmp alltraps
80107a24:	e9 78 f6 ff ff       	jmp    801070a1 <alltraps>

80107a29 <vector79>:
.globl vector79
vector79:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $79
80107a2b:	6a 4f                	push   $0x4f
  jmp alltraps
80107a2d:	e9 6f f6 ff ff       	jmp    801070a1 <alltraps>

80107a32 <vector80>:
.globl vector80
vector80:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $80
80107a34:	6a 50                	push   $0x50
  jmp alltraps
80107a36:	e9 66 f6 ff ff       	jmp    801070a1 <alltraps>

80107a3b <vector81>:
.globl vector81
vector81:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $81
80107a3d:	6a 51                	push   $0x51
  jmp alltraps
80107a3f:	e9 5d f6 ff ff       	jmp    801070a1 <alltraps>

80107a44 <vector82>:
.globl vector82
vector82:
  pushl $0
80107a44:	6a 00                	push   $0x0
  pushl $82
80107a46:	6a 52                	push   $0x52
  jmp alltraps
80107a48:	e9 54 f6 ff ff       	jmp    801070a1 <alltraps>

80107a4d <vector83>:
.globl vector83
vector83:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $83
80107a4f:	6a 53                	push   $0x53
  jmp alltraps
80107a51:	e9 4b f6 ff ff       	jmp    801070a1 <alltraps>

80107a56 <vector84>:
.globl vector84
vector84:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $84
80107a58:	6a 54                	push   $0x54
  jmp alltraps
80107a5a:	e9 42 f6 ff ff       	jmp    801070a1 <alltraps>

80107a5f <vector85>:
.globl vector85
vector85:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $85
80107a61:	6a 55                	push   $0x55
  jmp alltraps
80107a63:	e9 39 f6 ff ff       	jmp    801070a1 <alltraps>

80107a68 <vector86>:
.globl vector86
vector86:
  pushl $0
80107a68:	6a 00                	push   $0x0
  pushl $86
80107a6a:	6a 56                	push   $0x56
  jmp alltraps
80107a6c:	e9 30 f6 ff ff       	jmp    801070a1 <alltraps>

80107a71 <vector87>:
.globl vector87
vector87:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $87
80107a73:	6a 57                	push   $0x57
  jmp alltraps
80107a75:	e9 27 f6 ff ff       	jmp    801070a1 <alltraps>

80107a7a <vector88>:
.globl vector88
vector88:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $88
80107a7c:	6a 58                	push   $0x58
  jmp alltraps
80107a7e:	e9 1e f6 ff ff       	jmp    801070a1 <alltraps>

80107a83 <vector89>:
.globl vector89
vector89:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $89
80107a85:	6a 59                	push   $0x59
  jmp alltraps
80107a87:	e9 15 f6 ff ff       	jmp    801070a1 <alltraps>

80107a8c <vector90>:
.globl vector90
vector90:
  pushl $0
80107a8c:	6a 00                	push   $0x0
  pushl $90
80107a8e:	6a 5a                	push   $0x5a
  jmp alltraps
80107a90:	e9 0c f6 ff ff       	jmp    801070a1 <alltraps>

80107a95 <vector91>:
.globl vector91
vector91:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $91
80107a97:	6a 5b                	push   $0x5b
  jmp alltraps
80107a99:	e9 03 f6 ff ff       	jmp    801070a1 <alltraps>

80107a9e <vector92>:
.globl vector92
vector92:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $92
80107aa0:	6a 5c                	push   $0x5c
  jmp alltraps
80107aa2:	e9 fa f5 ff ff       	jmp    801070a1 <alltraps>

80107aa7 <vector93>:
.globl vector93
vector93:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $93
80107aa9:	6a 5d                	push   $0x5d
  jmp alltraps
80107aab:	e9 f1 f5 ff ff       	jmp    801070a1 <alltraps>

80107ab0 <vector94>:
.globl vector94
vector94:
  pushl $0
80107ab0:	6a 00                	push   $0x0
  pushl $94
80107ab2:	6a 5e                	push   $0x5e
  jmp alltraps
80107ab4:	e9 e8 f5 ff ff       	jmp    801070a1 <alltraps>

80107ab9 <vector95>:
.globl vector95
vector95:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $95
80107abb:	6a 5f                	push   $0x5f
  jmp alltraps
80107abd:	e9 df f5 ff ff       	jmp    801070a1 <alltraps>

80107ac2 <vector96>:
.globl vector96
vector96:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $96
80107ac4:	6a 60                	push   $0x60
  jmp alltraps
80107ac6:	e9 d6 f5 ff ff       	jmp    801070a1 <alltraps>

80107acb <vector97>:
.globl vector97
vector97:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $97
80107acd:	6a 61                	push   $0x61
  jmp alltraps
80107acf:	e9 cd f5 ff ff       	jmp    801070a1 <alltraps>

80107ad4 <vector98>:
.globl vector98
vector98:
  pushl $0
80107ad4:	6a 00                	push   $0x0
  pushl $98
80107ad6:	6a 62                	push   $0x62
  jmp alltraps
80107ad8:	e9 c4 f5 ff ff       	jmp    801070a1 <alltraps>

80107add <vector99>:
.globl vector99
vector99:
  pushl $0
80107add:	6a 00                	push   $0x0
  pushl $99
80107adf:	6a 63                	push   $0x63
  jmp alltraps
80107ae1:	e9 bb f5 ff ff       	jmp    801070a1 <alltraps>

80107ae6 <vector100>:
.globl vector100
vector100:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $100
80107ae8:	6a 64                	push   $0x64
  jmp alltraps
80107aea:	e9 b2 f5 ff ff       	jmp    801070a1 <alltraps>

80107aef <vector101>:
.globl vector101
vector101:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $101
80107af1:	6a 65                	push   $0x65
  jmp alltraps
80107af3:	e9 a9 f5 ff ff       	jmp    801070a1 <alltraps>

80107af8 <vector102>:
.globl vector102
vector102:
  pushl $0
80107af8:	6a 00                	push   $0x0
  pushl $102
80107afa:	6a 66                	push   $0x66
  jmp alltraps
80107afc:	e9 a0 f5 ff ff       	jmp    801070a1 <alltraps>

80107b01 <vector103>:
.globl vector103
vector103:
  pushl $0
80107b01:	6a 00                	push   $0x0
  pushl $103
80107b03:	6a 67                	push   $0x67
  jmp alltraps
80107b05:	e9 97 f5 ff ff       	jmp    801070a1 <alltraps>

80107b0a <vector104>:
.globl vector104
vector104:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $104
80107b0c:	6a 68                	push   $0x68
  jmp alltraps
80107b0e:	e9 8e f5 ff ff       	jmp    801070a1 <alltraps>

80107b13 <vector105>:
.globl vector105
vector105:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $105
80107b15:	6a 69                	push   $0x69
  jmp alltraps
80107b17:	e9 85 f5 ff ff       	jmp    801070a1 <alltraps>

80107b1c <vector106>:
.globl vector106
vector106:
  pushl $0
80107b1c:	6a 00                	push   $0x0
  pushl $106
80107b1e:	6a 6a                	push   $0x6a
  jmp alltraps
80107b20:	e9 7c f5 ff ff       	jmp    801070a1 <alltraps>

80107b25 <vector107>:
.globl vector107
vector107:
  pushl $0
80107b25:	6a 00                	push   $0x0
  pushl $107
80107b27:	6a 6b                	push   $0x6b
  jmp alltraps
80107b29:	e9 73 f5 ff ff       	jmp    801070a1 <alltraps>

80107b2e <vector108>:
.globl vector108
vector108:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $108
80107b30:	6a 6c                	push   $0x6c
  jmp alltraps
80107b32:	e9 6a f5 ff ff       	jmp    801070a1 <alltraps>

80107b37 <vector109>:
.globl vector109
vector109:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $109
80107b39:	6a 6d                	push   $0x6d
  jmp alltraps
80107b3b:	e9 61 f5 ff ff       	jmp    801070a1 <alltraps>

80107b40 <vector110>:
.globl vector110
vector110:
  pushl $0
80107b40:	6a 00                	push   $0x0
  pushl $110
80107b42:	6a 6e                	push   $0x6e
  jmp alltraps
80107b44:	e9 58 f5 ff ff       	jmp    801070a1 <alltraps>

80107b49 <vector111>:
.globl vector111
vector111:
  pushl $0
80107b49:	6a 00                	push   $0x0
  pushl $111
80107b4b:	6a 6f                	push   $0x6f
  jmp alltraps
80107b4d:	e9 4f f5 ff ff       	jmp    801070a1 <alltraps>

80107b52 <vector112>:
.globl vector112
vector112:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $112
80107b54:	6a 70                	push   $0x70
  jmp alltraps
80107b56:	e9 46 f5 ff ff       	jmp    801070a1 <alltraps>

80107b5b <vector113>:
.globl vector113
vector113:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $113
80107b5d:	6a 71                	push   $0x71
  jmp alltraps
80107b5f:	e9 3d f5 ff ff       	jmp    801070a1 <alltraps>

80107b64 <vector114>:
.globl vector114
vector114:
  pushl $0
80107b64:	6a 00                	push   $0x0
  pushl $114
80107b66:	6a 72                	push   $0x72
  jmp alltraps
80107b68:	e9 34 f5 ff ff       	jmp    801070a1 <alltraps>

80107b6d <vector115>:
.globl vector115
vector115:
  pushl $0
80107b6d:	6a 00                	push   $0x0
  pushl $115
80107b6f:	6a 73                	push   $0x73
  jmp alltraps
80107b71:	e9 2b f5 ff ff       	jmp    801070a1 <alltraps>

80107b76 <vector116>:
.globl vector116
vector116:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $116
80107b78:	6a 74                	push   $0x74
  jmp alltraps
80107b7a:	e9 22 f5 ff ff       	jmp    801070a1 <alltraps>

80107b7f <vector117>:
.globl vector117
vector117:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $117
80107b81:	6a 75                	push   $0x75
  jmp alltraps
80107b83:	e9 19 f5 ff ff       	jmp    801070a1 <alltraps>

80107b88 <vector118>:
.globl vector118
vector118:
  pushl $0
80107b88:	6a 00                	push   $0x0
  pushl $118
80107b8a:	6a 76                	push   $0x76
  jmp alltraps
80107b8c:	e9 10 f5 ff ff       	jmp    801070a1 <alltraps>

80107b91 <vector119>:
.globl vector119
vector119:
  pushl $0
80107b91:	6a 00                	push   $0x0
  pushl $119
80107b93:	6a 77                	push   $0x77
  jmp alltraps
80107b95:	e9 07 f5 ff ff       	jmp    801070a1 <alltraps>

80107b9a <vector120>:
.globl vector120
vector120:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $120
80107b9c:	6a 78                	push   $0x78
  jmp alltraps
80107b9e:	e9 fe f4 ff ff       	jmp    801070a1 <alltraps>

80107ba3 <vector121>:
.globl vector121
vector121:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $121
80107ba5:	6a 79                	push   $0x79
  jmp alltraps
80107ba7:	e9 f5 f4 ff ff       	jmp    801070a1 <alltraps>

80107bac <vector122>:
.globl vector122
vector122:
  pushl $0
80107bac:	6a 00                	push   $0x0
  pushl $122
80107bae:	6a 7a                	push   $0x7a
  jmp alltraps
80107bb0:	e9 ec f4 ff ff       	jmp    801070a1 <alltraps>

80107bb5 <vector123>:
.globl vector123
vector123:
  pushl $0
80107bb5:	6a 00                	push   $0x0
  pushl $123
80107bb7:	6a 7b                	push   $0x7b
  jmp alltraps
80107bb9:	e9 e3 f4 ff ff       	jmp    801070a1 <alltraps>

80107bbe <vector124>:
.globl vector124
vector124:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $124
80107bc0:	6a 7c                	push   $0x7c
  jmp alltraps
80107bc2:	e9 da f4 ff ff       	jmp    801070a1 <alltraps>

80107bc7 <vector125>:
.globl vector125
vector125:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $125
80107bc9:	6a 7d                	push   $0x7d
  jmp alltraps
80107bcb:	e9 d1 f4 ff ff       	jmp    801070a1 <alltraps>

80107bd0 <vector126>:
.globl vector126
vector126:
  pushl $0
80107bd0:	6a 00                	push   $0x0
  pushl $126
80107bd2:	6a 7e                	push   $0x7e
  jmp alltraps
80107bd4:	e9 c8 f4 ff ff       	jmp    801070a1 <alltraps>

80107bd9 <vector127>:
.globl vector127
vector127:
  pushl $0
80107bd9:	6a 00                	push   $0x0
  pushl $127
80107bdb:	6a 7f                	push   $0x7f
  jmp alltraps
80107bdd:	e9 bf f4 ff ff       	jmp    801070a1 <alltraps>

80107be2 <vector128>:
.globl vector128
vector128:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $128
80107be4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107be9:	e9 b3 f4 ff ff       	jmp    801070a1 <alltraps>

80107bee <vector129>:
.globl vector129
vector129:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $129
80107bf0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107bf5:	e9 a7 f4 ff ff       	jmp    801070a1 <alltraps>

80107bfa <vector130>:
.globl vector130
vector130:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $130
80107bfc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107c01:	e9 9b f4 ff ff       	jmp    801070a1 <alltraps>

80107c06 <vector131>:
.globl vector131
vector131:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $131
80107c08:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107c0d:	e9 8f f4 ff ff       	jmp    801070a1 <alltraps>

80107c12 <vector132>:
.globl vector132
vector132:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $132
80107c14:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107c19:	e9 83 f4 ff ff       	jmp    801070a1 <alltraps>

80107c1e <vector133>:
.globl vector133
vector133:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $133
80107c20:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107c25:	e9 77 f4 ff ff       	jmp    801070a1 <alltraps>

80107c2a <vector134>:
.globl vector134
vector134:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $134
80107c2c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107c31:	e9 6b f4 ff ff       	jmp    801070a1 <alltraps>

80107c36 <vector135>:
.globl vector135
vector135:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $135
80107c38:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107c3d:	e9 5f f4 ff ff       	jmp    801070a1 <alltraps>

80107c42 <vector136>:
.globl vector136
vector136:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $136
80107c44:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107c49:	e9 53 f4 ff ff       	jmp    801070a1 <alltraps>

80107c4e <vector137>:
.globl vector137
vector137:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $137
80107c50:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107c55:	e9 47 f4 ff ff       	jmp    801070a1 <alltraps>

80107c5a <vector138>:
.globl vector138
vector138:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $138
80107c5c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107c61:	e9 3b f4 ff ff       	jmp    801070a1 <alltraps>

80107c66 <vector139>:
.globl vector139
vector139:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $139
80107c68:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107c6d:	e9 2f f4 ff ff       	jmp    801070a1 <alltraps>

80107c72 <vector140>:
.globl vector140
vector140:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $140
80107c74:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107c79:	e9 23 f4 ff ff       	jmp    801070a1 <alltraps>

80107c7e <vector141>:
.globl vector141
vector141:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $141
80107c80:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107c85:	e9 17 f4 ff ff       	jmp    801070a1 <alltraps>

80107c8a <vector142>:
.globl vector142
vector142:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $142
80107c8c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107c91:	e9 0b f4 ff ff       	jmp    801070a1 <alltraps>

80107c96 <vector143>:
.globl vector143
vector143:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $143
80107c98:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107c9d:	e9 ff f3 ff ff       	jmp    801070a1 <alltraps>

80107ca2 <vector144>:
.globl vector144
vector144:
  pushl $0
80107ca2:	6a 00                	push   $0x0
  pushl $144
80107ca4:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107ca9:	e9 f3 f3 ff ff       	jmp    801070a1 <alltraps>

80107cae <vector145>:
.globl vector145
vector145:
  pushl $0
80107cae:	6a 00                	push   $0x0
  pushl $145
80107cb0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107cb5:	e9 e7 f3 ff ff       	jmp    801070a1 <alltraps>

80107cba <vector146>:
.globl vector146
vector146:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $146
80107cbc:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107cc1:	e9 db f3 ff ff       	jmp    801070a1 <alltraps>

80107cc6 <vector147>:
.globl vector147
vector147:
  pushl $0
80107cc6:	6a 00                	push   $0x0
  pushl $147
80107cc8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107ccd:	e9 cf f3 ff ff       	jmp    801070a1 <alltraps>

80107cd2 <vector148>:
.globl vector148
vector148:
  pushl $0
80107cd2:	6a 00                	push   $0x0
  pushl $148
80107cd4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107cd9:	e9 c3 f3 ff ff       	jmp    801070a1 <alltraps>

80107cde <vector149>:
.globl vector149
vector149:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $149
80107ce0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107ce5:	e9 b7 f3 ff ff       	jmp    801070a1 <alltraps>

80107cea <vector150>:
.globl vector150
vector150:
  pushl $0
80107cea:	6a 00                	push   $0x0
  pushl $150
80107cec:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107cf1:	e9 ab f3 ff ff       	jmp    801070a1 <alltraps>

80107cf6 <vector151>:
.globl vector151
vector151:
  pushl $0
80107cf6:	6a 00                	push   $0x0
  pushl $151
80107cf8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107cfd:	e9 9f f3 ff ff       	jmp    801070a1 <alltraps>

80107d02 <vector152>:
.globl vector152
vector152:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $152
80107d04:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107d09:	e9 93 f3 ff ff       	jmp    801070a1 <alltraps>

80107d0e <vector153>:
.globl vector153
vector153:
  pushl $0
80107d0e:	6a 00                	push   $0x0
  pushl $153
80107d10:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107d15:	e9 87 f3 ff ff       	jmp    801070a1 <alltraps>

80107d1a <vector154>:
.globl vector154
vector154:
  pushl $0
80107d1a:	6a 00                	push   $0x0
  pushl $154
80107d1c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107d21:	e9 7b f3 ff ff       	jmp    801070a1 <alltraps>

80107d26 <vector155>:
.globl vector155
vector155:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $155
80107d28:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107d2d:	e9 6f f3 ff ff       	jmp    801070a1 <alltraps>

80107d32 <vector156>:
.globl vector156
vector156:
  pushl $0
80107d32:	6a 00                	push   $0x0
  pushl $156
80107d34:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107d39:	e9 63 f3 ff ff       	jmp    801070a1 <alltraps>

80107d3e <vector157>:
.globl vector157
vector157:
  pushl $0
80107d3e:	6a 00                	push   $0x0
  pushl $157
80107d40:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107d45:	e9 57 f3 ff ff       	jmp    801070a1 <alltraps>

80107d4a <vector158>:
.globl vector158
vector158:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $158
80107d4c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107d51:	e9 4b f3 ff ff       	jmp    801070a1 <alltraps>

80107d56 <vector159>:
.globl vector159
vector159:
  pushl $0
80107d56:	6a 00                	push   $0x0
  pushl $159
80107d58:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107d5d:	e9 3f f3 ff ff       	jmp    801070a1 <alltraps>

80107d62 <vector160>:
.globl vector160
vector160:
  pushl $0
80107d62:	6a 00                	push   $0x0
  pushl $160
80107d64:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107d69:	e9 33 f3 ff ff       	jmp    801070a1 <alltraps>

80107d6e <vector161>:
.globl vector161
vector161:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $161
80107d70:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107d75:	e9 27 f3 ff ff       	jmp    801070a1 <alltraps>

80107d7a <vector162>:
.globl vector162
vector162:
  pushl $0
80107d7a:	6a 00                	push   $0x0
  pushl $162
80107d7c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107d81:	e9 1b f3 ff ff       	jmp    801070a1 <alltraps>

80107d86 <vector163>:
.globl vector163
vector163:
  pushl $0
80107d86:	6a 00                	push   $0x0
  pushl $163
80107d88:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107d8d:	e9 0f f3 ff ff       	jmp    801070a1 <alltraps>

80107d92 <vector164>:
.globl vector164
vector164:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $164
80107d94:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107d99:	e9 03 f3 ff ff       	jmp    801070a1 <alltraps>

80107d9e <vector165>:
.globl vector165
vector165:
  pushl $0
80107d9e:	6a 00                	push   $0x0
  pushl $165
80107da0:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107da5:	e9 f7 f2 ff ff       	jmp    801070a1 <alltraps>

80107daa <vector166>:
.globl vector166
vector166:
  pushl $0
80107daa:	6a 00                	push   $0x0
  pushl $166
80107dac:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107db1:	e9 eb f2 ff ff       	jmp    801070a1 <alltraps>

80107db6 <vector167>:
.globl vector167
vector167:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $167
80107db8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107dbd:	e9 df f2 ff ff       	jmp    801070a1 <alltraps>

80107dc2 <vector168>:
.globl vector168
vector168:
  pushl $0
80107dc2:	6a 00                	push   $0x0
  pushl $168
80107dc4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107dc9:	e9 d3 f2 ff ff       	jmp    801070a1 <alltraps>

80107dce <vector169>:
.globl vector169
vector169:
  pushl $0
80107dce:	6a 00                	push   $0x0
  pushl $169
80107dd0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107dd5:	e9 c7 f2 ff ff       	jmp    801070a1 <alltraps>

80107dda <vector170>:
.globl vector170
vector170:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $170
80107ddc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107de1:	e9 bb f2 ff ff       	jmp    801070a1 <alltraps>

80107de6 <vector171>:
.globl vector171
vector171:
  pushl $0
80107de6:	6a 00                	push   $0x0
  pushl $171
80107de8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107ded:	e9 af f2 ff ff       	jmp    801070a1 <alltraps>

80107df2 <vector172>:
.globl vector172
vector172:
  pushl $0
80107df2:	6a 00                	push   $0x0
  pushl $172
80107df4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107df9:	e9 a3 f2 ff ff       	jmp    801070a1 <alltraps>

80107dfe <vector173>:
.globl vector173
vector173:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $173
80107e00:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107e05:	e9 97 f2 ff ff       	jmp    801070a1 <alltraps>

80107e0a <vector174>:
.globl vector174
vector174:
  pushl $0
80107e0a:	6a 00                	push   $0x0
  pushl $174
80107e0c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107e11:	e9 8b f2 ff ff       	jmp    801070a1 <alltraps>

80107e16 <vector175>:
.globl vector175
vector175:
  pushl $0
80107e16:	6a 00                	push   $0x0
  pushl $175
80107e18:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107e1d:	e9 7f f2 ff ff       	jmp    801070a1 <alltraps>

80107e22 <vector176>:
.globl vector176
vector176:
  pushl $0
80107e22:	6a 00                	push   $0x0
  pushl $176
80107e24:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107e29:	e9 73 f2 ff ff       	jmp    801070a1 <alltraps>

80107e2e <vector177>:
.globl vector177
vector177:
  pushl $0
80107e2e:	6a 00                	push   $0x0
  pushl $177
80107e30:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107e35:	e9 67 f2 ff ff       	jmp    801070a1 <alltraps>

80107e3a <vector178>:
.globl vector178
vector178:
  pushl $0
80107e3a:	6a 00                	push   $0x0
  pushl $178
80107e3c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107e41:	e9 5b f2 ff ff       	jmp    801070a1 <alltraps>

80107e46 <vector179>:
.globl vector179
vector179:
  pushl $0
80107e46:	6a 00                	push   $0x0
  pushl $179
80107e48:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107e4d:	e9 4f f2 ff ff       	jmp    801070a1 <alltraps>

80107e52 <vector180>:
.globl vector180
vector180:
  pushl $0
80107e52:	6a 00                	push   $0x0
  pushl $180
80107e54:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107e59:	e9 43 f2 ff ff       	jmp    801070a1 <alltraps>

80107e5e <vector181>:
.globl vector181
vector181:
  pushl $0
80107e5e:	6a 00                	push   $0x0
  pushl $181
80107e60:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107e65:	e9 37 f2 ff ff       	jmp    801070a1 <alltraps>

80107e6a <vector182>:
.globl vector182
vector182:
  pushl $0
80107e6a:	6a 00                	push   $0x0
  pushl $182
80107e6c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107e71:	e9 2b f2 ff ff       	jmp    801070a1 <alltraps>

80107e76 <vector183>:
.globl vector183
vector183:
  pushl $0
80107e76:	6a 00                	push   $0x0
  pushl $183
80107e78:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107e7d:	e9 1f f2 ff ff       	jmp    801070a1 <alltraps>

80107e82 <vector184>:
.globl vector184
vector184:
  pushl $0
80107e82:	6a 00                	push   $0x0
  pushl $184
80107e84:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107e89:	e9 13 f2 ff ff       	jmp    801070a1 <alltraps>

80107e8e <vector185>:
.globl vector185
vector185:
  pushl $0
80107e8e:	6a 00                	push   $0x0
  pushl $185
80107e90:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107e95:	e9 07 f2 ff ff       	jmp    801070a1 <alltraps>

80107e9a <vector186>:
.globl vector186
vector186:
  pushl $0
80107e9a:	6a 00                	push   $0x0
  pushl $186
80107e9c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107ea1:	e9 fb f1 ff ff       	jmp    801070a1 <alltraps>

80107ea6 <vector187>:
.globl vector187
vector187:
  pushl $0
80107ea6:	6a 00                	push   $0x0
  pushl $187
80107ea8:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107ead:	e9 ef f1 ff ff       	jmp    801070a1 <alltraps>

80107eb2 <vector188>:
.globl vector188
vector188:
  pushl $0
80107eb2:	6a 00                	push   $0x0
  pushl $188
80107eb4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107eb9:	e9 e3 f1 ff ff       	jmp    801070a1 <alltraps>

80107ebe <vector189>:
.globl vector189
vector189:
  pushl $0
80107ebe:	6a 00                	push   $0x0
  pushl $189
80107ec0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107ec5:	e9 d7 f1 ff ff       	jmp    801070a1 <alltraps>

80107eca <vector190>:
.globl vector190
vector190:
  pushl $0
80107eca:	6a 00                	push   $0x0
  pushl $190
80107ecc:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107ed1:	e9 cb f1 ff ff       	jmp    801070a1 <alltraps>

80107ed6 <vector191>:
.globl vector191
vector191:
  pushl $0
80107ed6:	6a 00                	push   $0x0
  pushl $191
80107ed8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107edd:	e9 bf f1 ff ff       	jmp    801070a1 <alltraps>

80107ee2 <vector192>:
.globl vector192
vector192:
  pushl $0
80107ee2:	6a 00                	push   $0x0
  pushl $192
80107ee4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107ee9:	e9 b3 f1 ff ff       	jmp    801070a1 <alltraps>

80107eee <vector193>:
.globl vector193
vector193:
  pushl $0
80107eee:	6a 00                	push   $0x0
  pushl $193
80107ef0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ef5:	e9 a7 f1 ff ff       	jmp    801070a1 <alltraps>

80107efa <vector194>:
.globl vector194
vector194:
  pushl $0
80107efa:	6a 00                	push   $0x0
  pushl $194
80107efc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107f01:	e9 9b f1 ff ff       	jmp    801070a1 <alltraps>

80107f06 <vector195>:
.globl vector195
vector195:
  pushl $0
80107f06:	6a 00                	push   $0x0
  pushl $195
80107f08:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107f0d:	e9 8f f1 ff ff       	jmp    801070a1 <alltraps>

80107f12 <vector196>:
.globl vector196
vector196:
  pushl $0
80107f12:	6a 00                	push   $0x0
  pushl $196
80107f14:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107f19:	e9 83 f1 ff ff       	jmp    801070a1 <alltraps>

80107f1e <vector197>:
.globl vector197
vector197:
  pushl $0
80107f1e:	6a 00                	push   $0x0
  pushl $197
80107f20:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107f25:	e9 77 f1 ff ff       	jmp    801070a1 <alltraps>

80107f2a <vector198>:
.globl vector198
vector198:
  pushl $0
80107f2a:	6a 00                	push   $0x0
  pushl $198
80107f2c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107f31:	e9 6b f1 ff ff       	jmp    801070a1 <alltraps>

80107f36 <vector199>:
.globl vector199
vector199:
  pushl $0
80107f36:	6a 00                	push   $0x0
  pushl $199
80107f38:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107f3d:	e9 5f f1 ff ff       	jmp    801070a1 <alltraps>

80107f42 <vector200>:
.globl vector200
vector200:
  pushl $0
80107f42:	6a 00                	push   $0x0
  pushl $200
80107f44:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107f49:	e9 53 f1 ff ff       	jmp    801070a1 <alltraps>

80107f4e <vector201>:
.globl vector201
vector201:
  pushl $0
80107f4e:	6a 00                	push   $0x0
  pushl $201
80107f50:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107f55:	e9 47 f1 ff ff       	jmp    801070a1 <alltraps>

80107f5a <vector202>:
.globl vector202
vector202:
  pushl $0
80107f5a:	6a 00                	push   $0x0
  pushl $202
80107f5c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107f61:	e9 3b f1 ff ff       	jmp    801070a1 <alltraps>

80107f66 <vector203>:
.globl vector203
vector203:
  pushl $0
80107f66:	6a 00                	push   $0x0
  pushl $203
80107f68:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107f6d:	e9 2f f1 ff ff       	jmp    801070a1 <alltraps>

80107f72 <vector204>:
.globl vector204
vector204:
  pushl $0
80107f72:	6a 00                	push   $0x0
  pushl $204
80107f74:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107f79:	e9 23 f1 ff ff       	jmp    801070a1 <alltraps>

80107f7e <vector205>:
.globl vector205
vector205:
  pushl $0
80107f7e:	6a 00                	push   $0x0
  pushl $205
80107f80:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107f85:	e9 17 f1 ff ff       	jmp    801070a1 <alltraps>

80107f8a <vector206>:
.globl vector206
vector206:
  pushl $0
80107f8a:	6a 00                	push   $0x0
  pushl $206
80107f8c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107f91:	e9 0b f1 ff ff       	jmp    801070a1 <alltraps>

80107f96 <vector207>:
.globl vector207
vector207:
  pushl $0
80107f96:	6a 00                	push   $0x0
  pushl $207
80107f98:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107f9d:	e9 ff f0 ff ff       	jmp    801070a1 <alltraps>

80107fa2 <vector208>:
.globl vector208
vector208:
  pushl $0
80107fa2:	6a 00                	push   $0x0
  pushl $208
80107fa4:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107fa9:	e9 f3 f0 ff ff       	jmp    801070a1 <alltraps>

80107fae <vector209>:
.globl vector209
vector209:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $209
80107fb0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107fb5:	e9 e7 f0 ff ff       	jmp    801070a1 <alltraps>

80107fba <vector210>:
.globl vector210
vector210:
  pushl $0
80107fba:	6a 00                	push   $0x0
  pushl $210
80107fbc:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107fc1:	e9 db f0 ff ff       	jmp    801070a1 <alltraps>

80107fc6 <vector211>:
.globl vector211
vector211:
  pushl $0
80107fc6:	6a 00                	push   $0x0
  pushl $211
80107fc8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107fcd:	e9 cf f0 ff ff       	jmp    801070a1 <alltraps>

80107fd2 <vector212>:
.globl vector212
vector212:
  pushl $0
80107fd2:	6a 00                	push   $0x0
  pushl $212
80107fd4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107fd9:	e9 c3 f0 ff ff       	jmp    801070a1 <alltraps>

80107fde <vector213>:
.globl vector213
vector213:
  pushl $0
80107fde:	6a 00                	push   $0x0
  pushl $213
80107fe0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107fe5:	e9 b7 f0 ff ff       	jmp    801070a1 <alltraps>

80107fea <vector214>:
.globl vector214
vector214:
  pushl $0
80107fea:	6a 00                	push   $0x0
  pushl $214
80107fec:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107ff1:	e9 ab f0 ff ff       	jmp    801070a1 <alltraps>

80107ff6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107ff6:	6a 00                	push   $0x0
  pushl $215
80107ff8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107ffd:	e9 9f f0 ff ff       	jmp    801070a1 <alltraps>

80108002 <vector216>:
.globl vector216
vector216:
  pushl $0
80108002:	6a 00                	push   $0x0
  pushl $216
80108004:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108009:	e9 93 f0 ff ff       	jmp    801070a1 <alltraps>

8010800e <vector217>:
.globl vector217
vector217:
  pushl $0
8010800e:	6a 00                	push   $0x0
  pushl $217
80108010:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108015:	e9 87 f0 ff ff       	jmp    801070a1 <alltraps>

8010801a <vector218>:
.globl vector218
vector218:
  pushl $0
8010801a:	6a 00                	push   $0x0
  pushl $218
8010801c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108021:	e9 7b f0 ff ff       	jmp    801070a1 <alltraps>

80108026 <vector219>:
.globl vector219
vector219:
  pushl $0
80108026:	6a 00                	push   $0x0
  pushl $219
80108028:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010802d:	e9 6f f0 ff ff       	jmp    801070a1 <alltraps>

80108032 <vector220>:
.globl vector220
vector220:
  pushl $0
80108032:	6a 00                	push   $0x0
  pushl $220
80108034:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108039:	e9 63 f0 ff ff       	jmp    801070a1 <alltraps>

8010803e <vector221>:
.globl vector221
vector221:
  pushl $0
8010803e:	6a 00                	push   $0x0
  pushl $221
80108040:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108045:	e9 57 f0 ff ff       	jmp    801070a1 <alltraps>

8010804a <vector222>:
.globl vector222
vector222:
  pushl $0
8010804a:	6a 00                	push   $0x0
  pushl $222
8010804c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108051:	e9 4b f0 ff ff       	jmp    801070a1 <alltraps>

80108056 <vector223>:
.globl vector223
vector223:
  pushl $0
80108056:	6a 00                	push   $0x0
  pushl $223
80108058:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010805d:	e9 3f f0 ff ff       	jmp    801070a1 <alltraps>

80108062 <vector224>:
.globl vector224
vector224:
  pushl $0
80108062:	6a 00                	push   $0x0
  pushl $224
80108064:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108069:	e9 33 f0 ff ff       	jmp    801070a1 <alltraps>

8010806e <vector225>:
.globl vector225
vector225:
  pushl $0
8010806e:	6a 00                	push   $0x0
  pushl $225
80108070:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108075:	e9 27 f0 ff ff       	jmp    801070a1 <alltraps>

8010807a <vector226>:
.globl vector226
vector226:
  pushl $0
8010807a:	6a 00                	push   $0x0
  pushl $226
8010807c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108081:	e9 1b f0 ff ff       	jmp    801070a1 <alltraps>

80108086 <vector227>:
.globl vector227
vector227:
  pushl $0
80108086:	6a 00                	push   $0x0
  pushl $227
80108088:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010808d:	e9 0f f0 ff ff       	jmp    801070a1 <alltraps>

80108092 <vector228>:
.globl vector228
vector228:
  pushl $0
80108092:	6a 00                	push   $0x0
  pushl $228
80108094:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108099:	e9 03 f0 ff ff       	jmp    801070a1 <alltraps>

8010809e <vector229>:
.globl vector229
vector229:
  pushl $0
8010809e:	6a 00                	push   $0x0
  pushl $229
801080a0:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801080a5:	e9 f7 ef ff ff       	jmp    801070a1 <alltraps>

801080aa <vector230>:
.globl vector230
vector230:
  pushl $0
801080aa:	6a 00                	push   $0x0
  pushl $230
801080ac:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801080b1:	e9 eb ef ff ff       	jmp    801070a1 <alltraps>

801080b6 <vector231>:
.globl vector231
vector231:
  pushl $0
801080b6:	6a 00                	push   $0x0
  pushl $231
801080b8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801080bd:	e9 df ef ff ff       	jmp    801070a1 <alltraps>

801080c2 <vector232>:
.globl vector232
vector232:
  pushl $0
801080c2:	6a 00                	push   $0x0
  pushl $232
801080c4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801080c9:	e9 d3 ef ff ff       	jmp    801070a1 <alltraps>

801080ce <vector233>:
.globl vector233
vector233:
  pushl $0
801080ce:	6a 00                	push   $0x0
  pushl $233
801080d0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801080d5:	e9 c7 ef ff ff       	jmp    801070a1 <alltraps>

801080da <vector234>:
.globl vector234
vector234:
  pushl $0
801080da:	6a 00                	push   $0x0
  pushl $234
801080dc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801080e1:	e9 bb ef ff ff       	jmp    801070a1 <alltraps>

801080e6 <vector235>:
.globl vector235
vector235:
  pushl $0
801080e6:	6a 00                	push   $0x0
  pushl $235
801080e8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801080ed:	e9 af ef ff ff       	jmp    801070a1 <alltraps>

801080f2 <vector236>:
.globl vector236
vector236:
  pushl $0
801080f2:	6a 00                	push   $0x0
  pushl $236
801080f4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801080f9:	e9 a3 ef ff ff       	jmp    801070a1 <alltraps>

801080fe <vector237>:
.globl vector237
vector237:
  pushl $0
801080fe:	6a 00                	push   $0x0
  pushl $237
80108100:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108105:	e9 97 ef ff ff       	jmp    801070a1 <alltraps>

8010810a <vector238>:
.globl vector238
vector238:
  pushl $0
8010810a:	6a 00                	push   $0x0
  pushl $238
8010810c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108111:	e9 8b ef ff ff       	jmp    801070a1 <alltraps>

80108116 <vector239>:
.globl vector239
vector239:
  pushl $0
80108116:	6a 00                	push   $0x0
  pushl $239
80108118:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010811d:	e9 7f ef ff ff       	jmp    801070a1 <alltraps>

80108122 <vector240>:
.globl vector240
vector240:
  pushl $0
80108122:	6a 00                	push   $0x0
  pushl $240
80108124:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108129:	e9 73 ef ff ff       	jmp    801070a1 <alltraps>

8010812e <vector241>:
.globl vector241
vector241:
  pushl $0
8010812e:	6a 00                	push   $0x0
  pushl $241
80108130:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108135:	e9 67 ef ff ff       	jmp    801070a1 <alltraps>

8010813a <vector242>:
.globl vector242
vector242:
  pushl $0
8010813a:	6a 00                	push   $0x0
  pushl $242
8010813c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108141:	e9 5b ef ff ff       	jmp    801070a1 <alltraps>

80108146 <vector243>:
.globl vector243
vector243:
  pushl $0
80108146:	6a 00                	push   $0x0
  pushl $243
80108148:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010814d:	e9 4f ef ff ff       	jmp    801070a1 <alltraps>

80108152 <vector244>:
.globl vector244
vector244:
  pushl $0
80108152:	6a 00                	push   $0x0
  pushl $244
80108154:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108159:	e9 43 ef ff ff       	jmp    801070a1 <alltraps>

8010815e <vector245>:
.globl vector245
vector245:
  pushl $0
8010815e:	6a 00                	push   $0x0
  pushl $245
80108160:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108165:	e9 37 ef ff ff       	jmp    801070a1 <alltraps>

8010816a <vector246>:
.globl vector246
vector246:
  pushl $0
8010816a:	6a 00                	push   $0x0
  pushl $246
8010816c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108171:	e9 2b ef ff ff       	jmp    801070a1 <alltraps>

80108176 <vector247>:
.globl vector247
vector247:
  pushl $0
80108176:	6a 00                	push   $0x0
  pushl $247
80108178:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010817d:	e9 1f ef ff ff       	jmp    801070a1 <alltraps>

80108182 <vector248>:
.globl vector248
vector248:
  pushl $0
80108182:	6a 00                	push   $0x0
  pushl $248
80108184:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108189:	e9 13 ef ff ff       	jmp    801070a1 <alltraps>

8010818e <vector249>:
.globl vector249
vector249:
  pushl $0
8010818e:	6a 00                	push   $0x0
  pushl $249
80108190:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108195:	e9 07 ef ff ff       	jmp    801070a1 <alltraps>

8010819a <vector250>:
.globl vector250
vector250:
  pushl $0
8010819a:	6a 00                	push   $0x0
  pushl $250
8010819c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801081a1:	e9 fb ee ff ff       	jmp    801070a1 <alltraps>

801081a6 <vector251>:
.globl vector251
vector251:
  pushl $0
801081a6:	6a 00                	push   $0x0
  pushl $251
801081a8:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801081ad:	e9 ef ee ff ff       	jmp    801070a1 <alltraps>

801081b2 <vector252>:
.globl vector252
vector252:
  pushl $0
801081b2:	6a 00                	push   $0x0
  pushl $252
801081b4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801081b9:	e9 e3 ee ff ff       	jmp    801070a1 <alltraps>

801081be <vector253>:
.globl vector253
vector253:
  pushl $0
801081be:	6a 00                	push   $0x0
  pushl $253
801081c0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801081c5:	e9 d7 ee ff ff       	jmp    801070a1 <alltraps>

801081ca <vector254>:
.globl vector254
vector254:
  pushl $0
801081ca:	6a 00                	push   $0x0
  pushl $254
801081cc:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801081d1:	e9 cb ee ff ff       	jmp    801070a1 <alltraps>

801081d6 <vector255>:
.globl vector255
vector255:
  pushl $0
801081d6:	6a 00                	push   $0x0
  pushl $255
801081d8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801081dd:	e9 bf ee ff ff       	jmp    801070a1 <alltraps>

801081e2 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801081e2:	55                   	push   %ebp
801081e3:	89 e5                	mov    %esp,%ebp
801081e5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801081e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801081eb:	83 e8 01             	sub    $0x1,%eax
801081ee:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801081f2:	8b 45 08             	mov    0x8(%ebp),%eax
801081f5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801081f9:	8b 45 08             	mov    0x8(%ebp),%eax
801081fc:	c1 e8 10             	shr    $0x10,%eax
801081ff:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108203:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108206:	0f 01 10             	lgdtl  (%eax)
}
80108209:	c9                   	leave  
8010820a:	c3                   	ret    

8010820b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010820b:	55                   	push   %ebp
8010820c:	89 e5                	mov    %esp,%ebp
8010820e:	83 ec 04             	sub    $0x4,%esp
80108211:	8b 45 08             	mov    0x8(%ebp),%eax
80108214:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108218:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010821c:	0f 00 d8             	ltr    %ax
}
8010821f:	c9                   	leave  
80108220:	c3                   	ret    

80108221 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108221:	55                   	push   %ebp
80108222:	89 e5                	mov    %esp,%ebp
80108224:	83 ec 04             	sub    $0x4,%esp
80108227:	8b 45 08             	mov    0x8(%ebp),%eax
8010822a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010822e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108232:	8e e8                	mov    %eax,%gs
}
80108234:	c9                   	leave  
80108235:	c3                   	ret    

80108236 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108236:	55                   	push   %ebp
80108237:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108239:	8b 45 08             	mov    0x8(%ebp),%eax
8010823c:	0f 22 d8             	mov    %eax,%cr3
}
8010823f:	5d                   	pop    %ebp
80108240:	c3                   	ret    

80108241 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108241:	55                   	push   %ebp
80108242:	89 e5                	mov    %esp,%ebp
80108244:	8b 45 08             	mov    0x8(%ebp),%eax
80108247:	05 00 00 00 80       	add    $0x80000000,%eax
8010824c:	5d                   	pop    %ebp
8010824d:	c3                   	ret    

8010824e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010824e:	55                   	push   %ebp
8010824f:	89 e5                	mov    %esp,%ebp
80108251:	8b 45 08             	mov    0x8(%ebp),%eax
80108254:	05 00 00 00 80       	add    $0x80000000,%eax
80108259:	5d                   	pop    %ebp
8010825a:	c3                   	ret    

8010825b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010825b:	55                   	push   %ebp
8010825c:	89 e5                	mov    %esp,%ebp
8010825e:	53                   	push   %ebx
8010825f:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108262:	e8 36 ac ff ff       	call   80102e9d <cpunum>
80108267:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010826d:	05 80 33 11 80       	add    $0x80113380,%eax
80108272:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108278:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010827e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108281:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828a:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010828e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108291:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108295:	83 e2 f0             	and    $0xfffffff0,%edx
80108298:	83 ca 0a             	or     $0xa,%edx
8010829b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010829e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801082a5:	83 ca 10             	or     $0x10,%edx
801082a8:	88 50 7d             	mov    %dl,0x7d(%eax)
801082ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ae:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801082b2:	83 e2 9f             	and    $0xffffff9f,%edx
801082b5:	88 50 7d             	mov    %dl,0x7d(%eax)
801082b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801082bf:	83 ca 80             	or     $0xffffff80,%edx
801082c2:	88 50 7d             	mov    %dl,0x7d(%eax)
801082c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082cc:	83 ca 0f             	or     $0xf,%edx
801082cf:	88 50 7e             	mov    %dl,0x7e(%eax)
801082d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082d9:	83 e2 ef             	and    $0xffffffef,%edx
801082dc:	88 50 7e             	mov    %dl,0x7e(%eax)
801082df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082e6:	83 e2 df             	and    $0xffffffdf,%edx
801082e9:	88 50 7e             	mov    %dl,0x7e(%eax)
801082ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ef:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801082f3:	83 ca 40             	or     $0x40,%edx
801082f6:	88 50 7e             	mov    %dl,0x7e(%eax)
801082f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082fc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108300:	83 ca 80             	or     $0xffffff80,%edx
80108303:	88 50 7e             	mov    %dl,0x7e(%eax)
80108306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108309:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010830d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108310:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108317:	ff ff 
80108319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831c:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108323:	00 00 
80108325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108328:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010832f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108332:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108339:	83 e2 f0             	and    $0xfffffff0,%edx
8010833c:	83 ca 02             	or     $0x2,%edx
8010833f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108348:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010834f:	83 ca 10             	or     $0x10,%edx
80108352:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108362:	83 e2 9f             	and    $0xffffff9f,%edx
80108365:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108375:	83 ca 80             	or     $0xffffff80,%edx
80108378:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010837e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108381:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108388:	83 ca 0f             	or     $0xf,%edx
8010838b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108394:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010839b:	83 e2 ef             	and    $0xffffffef,%edx
8010839e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801083ae:	83 e2 df             	and    $0xffffffdf,%edx
801083b1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ba:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801083c1:	83 ca 40             	or     $0x40,%edx
801083c4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801083d4:	83 ca 80             	or     $0xffffff80,%edx
801083d7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801083e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ea:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801083f1:	ff ff 
801083f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f6:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801083fd:	00 00 
801083ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108402:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108413:	83 e2 f0             	and    $0xfffffff0,%edx
80108416:	83 ca 0a             	or     $0xa,%edx
80108419:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010841f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108422:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108429:	83 ca 10             	or     $0x10,%edx
8010842c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108435:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010843c:	83 ca 60             	or     $0x60,%edx
8010843f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108448:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010844f:	83 ca 80             	or     $0xffffff80,%edx
80108452:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108462:	83 ca 0f             	or     $0xf,%edx
80108465:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010846b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010846e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108475:	83 e2 ef             	and    $0xffffffef,%edx
80108478:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010847e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108481:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108488:	83 e2 df             	and    $0xffffffdf,%edx
8010848b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108494:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010849b:	83 ca 40             	or     $0x40,%edx
8010849e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801084a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801084ae:	83 ca 80             	or     $0xffffff80,%edx
801084b1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801084b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ba:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801084c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c4:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801084cb:	ff ff 
801084cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d0:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801084d7:	00 00 
801084d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084dc:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801084e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e6:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801084ed:	83 e2 f0             	and    $0xfffffff0,%edx
801084f0:	83 ca 02             	or     $0x2,%edx
801084f3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801084f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108503:	83 ca 10             	or     $0x10,%edx
80108506:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010850c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010850f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108516:	83 ca 60             	or     $0x60,%edx
80108519:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010851f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108522:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108529:	83 ca 80             	or     $0xffffff80,%edx
8010852c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108535:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010853c:	83 ca 0f             	or     $0xf,%edx
8010853f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108545:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108548:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010854f:	83 e2 ef             	and    $0xffffffef,%edx
80108552:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108562:	83 e2 df             	and    $0xffffffdf,%edx
80108565:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010856b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010856e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108575:	83 ca 40             	or     $0x40,%edx
80108578:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010857e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108581:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108588:	83 ca 80             	or     $0xffffff80,%edx
8010858b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108594:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010859b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859e:	05 b4 00 00 00       	add    $0xb4,%eax
801085a3:	89 c3                	mov    %eax,%ebx
801085a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a8:	05 b4 00 00 00       	add    $0xb4,%eax
801085ad:	c1 e8 10             	shr    $0x10,%eax
801085b0:	89 c1                	mov    %eax,%ecx
801085b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b5:	05 b4 00 00 00       	add    $0xb4,%eax
801085ba:	c1 e8 18             	shr    $0x18,%eax
801085bd:	89 c2                	mov    %eax,%edx
801085bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c2:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801085c9:	00 00 
801085cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ce:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801085d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d8:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801085de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e1:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801085e8:	83 e1 f0             	and    $0xfffffff0,%ecx
801085eb:	83 c9 02             	or     $0x2,%ecx
801085ee:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801085f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801085fe:	83 c9 10             	or     $0x10,%ecx
80108601:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860a:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108611:	83 e1 9f             	and    $0xffffff9f,%ecx
80108614:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010861a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010861d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108624:	83 c9 80             	or     $0xffffff80,%ecx
80108627:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010862d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108630:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108637:	83 e1 f0             	and    $0xfffffff0,%ecx
8010863a:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108643:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010864a:	83 e1 ef             	and    $0xffffffef,%ecx
8010864d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108656:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010865d:	83 e1 df             	and    $0xffffffdf,%ecx
80108660:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108669:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108670:	83 c9 40             	or     $0x40,%ecx
80108673:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108683:	83 c9 80             	or     $0xffffff80,%ecx
80108686:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010868c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868f:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108698:	83 c0 70             	add    $0x70,%eax
8010869b:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801086a2:	00 
801086a3:	89 04 24             	mov    %eax,(%esp)
801086a6:	e8 37 fb ff ff       	call   801081e2 <lgdt>
  loadgs(SEG_KCPU << 3);
801086ab:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801086b2:	e8 6a fb ff ff       	call   80108221 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801086b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ba:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  thread = 0;
801086c0:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801086c7:	00 00 00 00 
}
801086cb:	83 c4 24             	add    $0x24,%esp
801086ce:	5b                   	pop    %ebx
801086cf:	5d                   	pop    %ebp
801086d0:	c3                   	ret    

801086d1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801086d1:	55                   	push   %ebp
801086d2:	89 e5                	mov    %esp,%ebp
801086d4:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801086d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801086da:	c1 e8 16             	shr    $0x16,%eax
801086dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086e4:	8b 45 08             	mov    0x8(%ebp),%eax
801086e7:	01 d0                	add    %edx,%eax
801086e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801086ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ef:	8b 00                	mov    (%eax),%eax
801086f1:	83 e0 01             	and    $0x1,%eax
801086f4:	85 c0                	test   %eax,%eax
801086f6:	74 17                	je     8010870f <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801086f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086fb:	8b 00                	mov    (%eax),%eax
801086fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108702:	89 04 24             	mov    %eax,(%esp)
80108705:	e8 44 fb ff ff       	call   8010824e <p2v>
8010870a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010870d:	eb 4b                	jmp    8010875a <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010870f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108713:	74 0e                	je     80108723 <walkpgdir+0x52>
80108715:	e8 ed a3 ff ff       	call   80102b07 <kalloc>
8010871a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010871d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108721:	75 07                	jne    8010872a <walkpgdir+0x59>
      return 0;
80108723:	b8 00 00 00 00       	mov    $0x0,%eax
80108728:	eb 47                	jmp    80108771 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010872a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108731:	00 
80108732:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108739:	00 
8010873a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873d:	89 04 24             	mov    %eax,(%esp)
80108740:	e8 7f d3 ff ff       	call   80105ac4 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108748:	89 04 24             	mov    %eax,(%esp)
8010874b:	e8 f1 fa ff ff       	call   80108241 <v2p>
80108750:	83 c8 07             	or     $0x7,%eax
80108753:	89 c2                	mov    %eax,%edx
80108755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108758:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010875a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010875d:	c1 e8 0c             	shr    $0xc,%eax
80108760:	25 ff 03 00 00       	and    $0x3ff,%eax
80108765:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010876c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876f:	01 d0                	add    %edx,%eax
}
80108771:	c9                   	leave  
80108772:	c3                   	ret    

80108773 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108773:	55                   	push   %ebp
80108774:	89 e5                	mov    %esp,%ebp
80108776:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108779:	8b 45 0c             	mov    0xc(%ebp),%eax
8010877c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108784:	8b 55 0c             	mov    0xc(%ebp),%edx
80108787:	8b 45 10             	mov    0x10(%ebp),%eax
8010878a:	01 d0                	add    %edx,%eax
8010878c:	83 e8 01             	sub    $0x1,%eax
8010878f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108797:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010879e:	00 
8010879f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801087a6:	8b 45 08             	mov    0x8(%ebp),%eax
801087a9:	89 04 24             	mov    %eax,(%esp)
801087ac:	e8 20 ff ff ff       	call   801086d1 <walkpgdir>
801087b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087b8:	75 07                	jne    801087c1 <mappages+0x4e>
      return -1;
801087ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087bf:	eb 48                	jmp    80108809 <mappages+0x96>
    if(*pte & PTE_P)
801087c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087c4:	8b 00                	mov    (%eax),%eax
801087c6:	83 e0 01             	and    $0x1,%eax
801087c9:	85 c0                	test   %eax,%eax
801087cb:	74 0c                	je     801087d9 <mappages+0x66>
      panic("remap");
801087cd:	c7 04 24 e0 96 10 80 	movl   $0x801096e0,(%esp)
801087d4:	e8 61 7d ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801087d9:	8b 45 18             	mov    0x18(%ebp),%eax
801087dc:	0b 45 14             	or     0x14(%ebp),%eax
801087df:	83 c8 01             	or     $0x1,%eax
801087e2:	89 c2                	mov    %eax,%edx
801087e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087e7:	89 10                	mov    %edx,(%eax)
    if(a == last)
801087e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801087ef:	75 08                	jne    801087f9 <mappages+0x86>
      break;
801087f1:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801087f2:	b8 00 00 00 00       	mov    $0x0,%eax
801087f7:	eb 10                	jmp    80108809 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801087f9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108800:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108807:	eb 8e                	jmp    80108797 <mappages+0x24>
  return 0;
}
80108809:	c9                   	leave  
8010880a:	c3                   	ret    

8010880b <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010880b:	55                   	push   %ebp
8010880c:	89 e5                	mov    %esp,%ebp
8010880e:	53                   	push   %ebx
8010880f:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108812:	e8 f0 a2 ff ff       	call   80102b07 <kalloc>
80108817:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010881a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010881e:	75 0a                	jne    8010882a <setupkvm+0x1f>
    return 0;
80108820:	b8 00 00 00 00       	mov    $0x0,%eax
80108825:	e9 98 00 00 00       	jmp    801088c2 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
8010882a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108831:	00 
80108832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108839:	00 
8010883a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010883d:	89 04 24             	mov    %eax,(%esp)
80108840:	e8 7f d2 ff ff       	call   80105ac4 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108845:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
8010884c:	e8 fd f9 ff ff       	call   8010824e <p2v>
80108851:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108856:	76 0c                	jbe    80108864 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108858:	c7 04 24 e6 96 10 80 	movl   $0x801096e6,(%esp)
8010885f:	e8 d6 7c ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108864:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010886b:	eb 49                	jmp    801088b6 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010886d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108870:	8b 48 0c             	mov    0xc(%eax),%ecx
80108873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108876:	8b 50 04             	mov    0x4(%eax),%edx
80108879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010887c:	8b 58 08             	mov    0x8(%eax),%ebx
8010887f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108882:	8b 40 04             	mov    0x4(%eax),%eax
80108885:	29 c3                	sub    %eax,%ebx
80108887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010888a:	8b 00                	mov    (%eax),%eax
8010888c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108890:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108894:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010889c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010889f:	89 04 24             	mov    %eax,(%esp)
801088a2:	e8 cc fe ff ff       	call   80108773 <mappages>
801088a7:	85 c0                	test   %eax,%eax
801088a9:	79 07                	jns    801088b2 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801088ab:	b8 00 00 00 00       	mov    $0x0,%eax
801088b0:	eb 10                	jmp    801088c2 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801088b2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801088b6:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801088bd:	72 ae                	jb     8010886d <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801088bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801088c2:	83 c4 34             	add    $0x34,%esp
801088c5:	5b                   	pop    %ebx
801088c6:	5d                   	pop    %ebp
801088c7:	c3                   	ret    

801088c8 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801088c8:	55                   	push   %ebp
801088c9:	89 e5                	mov    %esp,%ebp
801088cb:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801088ce:	e8 38 ff ff ff       	call   8010880b <setupkvm>
801088d3:	a3 58 f2 11 80       	mov    %eax,0x8011f258
  switchkvm();
801088d8:	e8 02 00 00 00       	call   801088df <switchkvm>
}
801088dd:	c9                   	leave  
801088de:	c3                   	ret    

801088df <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801088df:	55                   	push   %ebp
801088e0:	89 e5                	mov    %esp,%ebp
801088e2:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801088e5:	a1 58 f2 11 80       	mov    0x8011f258,%eax
801088ea:	89 04 24             	mov    %eax,(%esp)
801088ed:	e8 4f f9 ff ff       	call   80108241 <v2p>
801088f2:	89 04 24             	mov    %eax,(%esp)
801088f5:	e8 3c f9 ff ff       	call   80108236 <lcr3>
}
801088fa:	c9                   	leave  
801088fb:	c3                   	ret    

801088fc <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct thread *t)
{
801088fc:	55                   	push   %ebp
801088fd:	89 e5                	mov    %esp,%ebp
801088ff:	53                   	push   %ebx
80108900:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108903:	e8 bc d0 ff ff       	call   801059c4 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108908:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010890e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108915:	83 c2 08             	add    $0x8,%edx
80108918:	89 d3                	mov    %edx,%ebx
8010891a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108921:	83 c2 08             	add    $0x8,%edx
80108924:	c1 ea 10             	shr    $0x10,%edx
80108927:	89 d1                	mov    %edx,%ecx
80108929:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108930:	83 c2 08             	add    $0x8,%edx
80108933:	c1 ea 18             	shr    $0x18,%edx
80108936:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010893d:	67 00 
8010893f:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108946:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
8010894c:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108953:	83 e1 f0             	and    $0xfffffff0,%ecx
80108956:	83 c9 09             	or     $0x9,%ecx
80108959:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010895f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108966:	83 c9 10             	or     $0x10,%ecx
80108969:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010896f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108976:	83 e1 9f             	and    $0xffffff9f,%ecx
80108979:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010897f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108986:	83 c9 80             	or     $0xffffff80,%ecx
80108989:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010898f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108996:	83 e1 f0             	and    $0xfffffff0,%ecx
80108999:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010899f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089a6:	83 e1 ef             	and    $0xffffffef,%ecx
801089a9:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089af:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089b6:	83 e1 df             	and    $0xffffffdf,%ecx
801089b9:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089bf:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089c6:	83 c9 40             	or     $0x40,%ecx
801089c9:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089cf:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801089d6:	83 e1 7f             	and    $0x7f,%ecx
801089d9:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801089df:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801089e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801089eb:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801089f2:	83 e2 ef             	and    $0xffffffef,%edx
801089f5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801089fb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108a01:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)thread->kstack + KSTACKSIZE;
80108a07:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108a0d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108a14:	8b 12                	mov    (%edx),%edx
80108a16:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108a1c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108a1f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108a26:	e8 e0 f7 ff ff       	call   8010820b <ltr>
  if(t->proc->pgdir == 0)
80108a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80108a2e:	8b 40 0c             	mov    0xc(%eax),%eax
80108a31:	8b 40 04             	mov    0x4(%eax),%eax
80108a34:	85 c0                	test   %eax,%eax
80108a36:	75 0c                	jne    80108a44 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108a38:	c7 04 24 f7 96 10 80 	movl   $0x801096f7,(%esp)
80108a3f:	e8 f6 7a ff ff       	call   8010053a <panic>
  lcr3(v2p(t->proc->pgdir ));  // switch to new address space
80108a44:	8b 45 08             	mov    0x8(%ebp),%eax
80108a47:	8b 40 0c             	mov    0xc(%eax),%eax
80108a4a:	8b 40 04             	mov    0x4(%eax),%eax
80108a4d:	89 04 24             	mov    %eax,(%esp)
80108a50:	e8 ec f7 ff ff       	call   80108241 <v2p>
80108a55:	89 04 24             	mov    %eax,(%esp)
80108a58:	e8 d9 f7 ff ff       	call   80108236 <lcr3>

  popcli();
80108a5d:	e8 a6 cf ff ff       	call   80105a08 <popcli>
}
80108a62:	83 c4 14             	add    $0x14,%esp
80108a65:	5b                   	pop    %ebx
80108a66:	5d                   	pop    %ebp
80108a67:	c3                   	ret    

80108a68 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108a68:	55                   	push   %ebp
80108a69:	89 e5                	mov    %esp,%ebp
80108a6b:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108a6e:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108a75:	76 0c                	jbe    80108a83 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108a77:	c7 04 24 0b 97 10 80 	movl   $0x8010970b,(%esp)
80108a7e:	e8 b7 7a ff ff       	call   8010053a <panic>
  mem = kalloc();
80108a83:	e8 7f a0 ff ff       	call   80102b07 <kalloc>
80108a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108a8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a92:	00 
80108a93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108a9a:	00 
80108a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9e:	89 04 24             	mov    %eax,(%esp)
80108aa1:	e8 1e d0 ff ff       	call   80105ac4 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa9:	89 04 24             	mov    %eax,(%esp)
80108aac:	e8 90 f7 ff ff       	call   80108241 <v2p>
80108ab1:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108ab8:	00 
80108ab9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108abd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108ac4:	00 
80108ac5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108acc:	00 
80108acd:	8b 45 08             	mov    0x8(%ebp),%eax
80108ad0:	89 04 24             	mov    %eax,(%esp)
80108ad3:	e8 9b fc ff ff       	call   80108773 <mappages>
  memmove(mem, init, sz);
80108ad8:	8b 45 10             	mov    0x10(%ebp),%eax
80108adb:	89 44 24 08          	mov    %eax,0x8(%esp)
80108adf:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae9:	89 04 24             	mov    %eax,(%esp)
80108aec:	e8 a2 d0 ff ff       	call   80105b93 <memmove>
}
80108af1:	c9                   	leave  
80108af2:	c3                   	ret    

80108af3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108af3:	55                   	push   %ebp
80108af4:	89 e5                	mov    %esp,%ebp
80108af6:	53                   	push   %ebx
80108af7:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108afa:	8b 45 0c             	mov    0xc(%ebp),%eax
80108afd:	25 ff 0f 00 00       	and    $0xfff,%eax
80108b02:	85 c0                	test   %eax,%eax
80108b04:	74 0c                	je     80108b12 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108b06:	c7 04 24 28 97 10 80 	movl   $0x80109728,(%esp)
80108b0d:	e8 28 7a ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b19:	e9 a9 00 00 00       	jmp    80108bc7 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b21:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b24:	01 d0                	add    %edx,%eax
80108b26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b2d:	00 
80108b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b32:	8b 45 08             	mov    0x8(%ebp),%eax
80108b35:	89 04 24             	mov    %eax,(%esp)
80108b38:	e8 94 fb ff ff       	call   801086d1 <walkpgdir>
80108b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b44:	75 0c                	jne    80108b52 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108b46:	c7 04 24 4b 97 10 80 	movl   $0x8010974b,(%esp)
80108b4d:	e8 e8 79 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b55:	8b 00                	mov    (%eax),%eax
80108b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b62:	8b 55 18             	mov    0x18(%ebp),%edx
80108b65:	29 c2                	sub    %eax,%edx
80108b67:	89 d0                	mov    %edx,%eax
80108b69:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108b6e:	77 0f                	ja     80108b7f <loaduvm+0x8c>
      n = sz - i;
80108b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b73:	8b 55 18             	mov    0x18(%ebp),%edx
80108b76:	29 c2                	sub    %eax,%edx
80108b78:	89 d0                	mov    %edx,%eax
80108b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b7d:	eb 07                	jmp    80108b86 <loaduvm+0x93>
    else
      n = PGSIZE;
80108b7f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b89:	8b 55 14             	mov    0x14(%ebp),%edx
80108b8c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b92:	89 04 24             	mov    %eax,(%esp)
80108b95:	e8 b4 f6 ff ff       	call   8010824e <p2v>
80108b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108b9d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108ba1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ba9:	8b 45 10             	mov    0x10(%ebp),%eax
80108bac:	89 04 24             	mov    %eax,(%esp)
80108baf:	e8 d6 91 ff ff       	call   80101d8a <readi>
80108bb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108bb7:	74 07                	je     80108bc0 <loaduvm+0xcd>
      return -1;
80108bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108bbe:	eb 18                	jmp    80108bd8 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108bc0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bca:	3b 45 18             	cmp    0x18(%ebp),%eax
80108bcd:	0f 82 4b ff ff ff    	jb     80108b1e <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bd8:	83 c4 24             	add    $0x24,%esp
80108bdb:	5b                   	pop    %ebx
80108bdc:	5d                   	pop    %ebp
80108bdd:	c3                   	ret    

80108bde <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108bde:	55                   	push   %ebp
80108bdf:	89 e5                	mov    %esp,%ebp
80108be1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108be4:	8b 45 10             	mov    0x10(%ebp),%eax
80108be7:	85 c0                	test   %eax,%eax
80108be9:	79 0a                	jns    80108bf5 <allocuvm+0x17>
    return 0;
80108beb:	b8 00 00 00 00       	mov    $0x0,%eax
80108bf0:	e9 c1 00 00 00       	jmp    80108cb6 <allocuvm+0xd8>
  if(newsz < oldsz)
80108bf5:	8b 45 10             	mov    0x10(%ebp),%eax
80108bf8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bfb:	73 08                	jae    80108c05 <allocuvm+0x27>
    return oldsz;
80108bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c00:	e9 b1 00 00 00       	jmp    80108cb6 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108c05:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c08:	05 ff 0f 00 00       	add    $0xfff,%eax
80108c0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108c15:	e9 8d 00 00 00       	jmp    80108ca7 <allocuvm+0xc9>
    mem = kalloc();
80108c1a:	e8 e8 9e ff ff       	call   80102b07 <kalloc>
80108c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c26:	75 2c                	jne    80108c54 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108c28:	c7 04 24 69 97 10 80 	movl   $0x80109769,(%esp)
80108c2f:	e8 6c 77 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108c34:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c37:	89 44 24 08          	mov    %eax,0x8(%esp)
80108c3b:	8b 45 10             	mov    0x10(%ebp),%eax
80108c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c42:	8b 45 08             	mov    0x8(%ebp),%eax
80108c45:	89 04 24             	mov    %eax,(%esp)
80108c48:	e8 6b 00 00 00       	call   80108cb8 <deallocuvm>
      return 0;
80108c4d:	b8 00 00 00 00       	mov    $0x0,%eax
80108c52:	eb 62                	jmp    80108cb6 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108c54:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c5b:	00 
80108c5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108c63:	00 
80108c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c67:	89 04 24             	mov    %eax,(%esp)
80108c6a:	e8 55 ce ff ff       	call   80105ac4 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c72:	89 04 24             	mov    %eax,(%esp)
80108c75:	e8 c7 f5 ff ff       	call   80108241 <v2p>
80108c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c7d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108c84:	00 
80108c85:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c89:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c90:	00 
80108c91:	89 54 24 04          	mov    %edx,0x4(%esp)
80108c95:	8b 45 08             	mov    0x8(%ebp),%eax
80108c98:	89 04 24             	mov    %eax,(%esp)
80108c9b:	e8 d3 fa ff ff       	call   80108773 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108ca0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108caa:	3b 45 10             	cmp    0x10(%ebp),%eax
80108cad:	0f 82 67 ff ff ff    	jb     80108c1a <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108cb3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108cb6:	c9                   	leave  
80108cb7:	c3                   	ret    

80108cb8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108cb8:	55                   	push   %ebp
80108cb9:	89 e5                	mov    %esp,%ebp
80108cbb:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108cbe:	8b 45 10             	mov    0x10(%ebp),%eax
80108cc1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108cc4:	72 08                	jb     80108cce <deallocuvm+0x16>
    return oldsz;
80108cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cc9:	e9 a4 00 00 00       	jmp    80108d72 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108cce:	8b 45 10             	mov    0x10(%ebp),%eax
80108cd1:	05 ff 0f 00 00       	add    $0xfff,%eax
80108cd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108cde:	e9 80 00 00 00       	jmp    80108d63 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ced:	00 
80108cee:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80108cf5:	89 04 24             	mov    %eax,(%esp)
80108cf8:	e8 d4 f9 ff ff       	call   801086d1 <walkpgdir>
80108cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108d00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108d04:	75 09                	jne    80108d0f <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108d06:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108d0d:	eb 4d                	jmp    80108d5c <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d12:	8b 00                	mov    (%eax),%eax
80108d14:	83 e0 01             	and    $0x1,%eax
80108d17:	85 c0                	test   %eax,%eax
80108d19:	74 41                	je     80108d5c <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d1e:	8b 00                	mov    (%eax),%eax
80108d20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108d2c:	75 0c                	jne    80108d3a <deallocuvm+0x82>
        panic("kfree");
80108d2e:	c7 04 24 81 97 10 80 	movl   $0x80109781,(%esp)
80108d35:	e8 00 78 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d3d:	89 04 24             	mov    %eax,(%esp)
80108d40:	e8 09 f5 ff ff       	call   8010824e <p2v>
80108d45:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d4b:	89 04 24             	mov    %eax,(%esp)
80108d4e:	e8 1b 9d ff ff       	call   80102a6e <kfree>
      *pte = 0;
80108d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108d5c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d66:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d69:	0f 82 74 ff ff ff    	jb     80108ce3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108d6f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108d72:	c9                   	leave  
80108d73:	c3                   	ret    

80108d74 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108d74:	55                   	push   %ebp
80108d75:	89 e5                	mov    %esp,%ebp
80108d77:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108d7e:	75 0c                	jne    80108d8c <freevm+0x18>
    panic("freevm: no pgdir");
80108d80:	c7 04 24 87 97 10 80 	movl   $0x80109787,(%esp)
80108d87:	e8 ae 77 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108d8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108d93:	00 
80108d94:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108d9b:	80 
80108d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80108d9f:	89 04 24             	mov    %eax,(%esp)
80108da2:	e8 11 ff ff ff       	call   80108cb8 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108da7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108dae:	eb 48                	jmp    80108df8 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108dba:	8b 45 08             	mov    0x8(%ebp),%eax
80108dbd:	01 d0                	add    %edx,%eax
80108dbf:	8b 00                	mov    (%eax),%eax
80108dc1:	83 e0 01             	and    $0x1,%eax
80108dc4:	85 c0                	test   %eax,%eax
80108dc6:	74 2c                	je     80108df4 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80108dd5:	01 d0                	add    %edx,%eax
80108dd7:	8b 00                	mov    (%eax),%eax
80108dd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108dde:	89 04 24             	mov    %eax,(%esp)
80108de1:	e8 68 f4 ff ff       	call   8010824e <p2v>
80108de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dec:	89 04 24             	mov    %eax,(%esp)
80108def:	e8 7a 9c ff ff       	call   80102a6e <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108df4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108df8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108dff:	76 af                	jbe    80108db0 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108e01:	8b 45 08             	mov    0x8(%ebp),%eax
80108e04:	89 04 24             	mov    %eax,(%esp)
80108e07:	e8 62 9c ff ff       	call   80102a6e <kfree>
}
80108e0c:	c9                   	leave  
80108e0d:	c3                   	ret    

80108e0e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108e0e:	55                   	push   %ebp
80108e0f:	89 e5                	mov    %esp,%ebp
80108e11:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108e14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108e1b:	00 
80108e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e23:	8b 45 08             	mov    0x8(%ebp),%eax
80108e26:	89 04 24             	mov    %eax,(%esp)
80108e29:	e8 a3 f8 ff ff       	call   801086d1 <walkpgdir>
80108e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108e35:	75 0c                	jne    80108e43 <clearpteu+0x35>
    panic("clearpteu");
80108e37:	c7 04 24 98 97 10 80 	movl   $0x80109798,(%esp)
80108e3e:	e8 f7 76 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e46:	8b 00                	mov    (%eax),%eax
80108e48:	83 e0 fb             	and    $0xfffffffb,%eax
80108e4b:	89 c2                	mov    %eax,%edx
80108e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e50:	89 10                	mov    %edx,(%eax)
}
80108e52:	c9                   	leave  
80108e53:	c3                   	ret    

80108e54 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108e54:	55                   	push   %ebp
80108e55:	89 e5                	mov    %esp,%ebp
80108e57:	53                   	push   %ebx
80108e58:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108e5b:	e8 ab f9 ff ff       	call   8010880b <setupkvm>
80108e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108e63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108e67:	75 0a                	jne    80108e73 <copyuvm+0x1f>
    return 0;
80108e69:	b8 00 00 00 00       	mov    $0x0,%eax
80108e6e:	e9 fd 00 00 00       	jmp    80108f70 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e7a:	e9 d0 00 00 00       	jmp    80108f4f <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e82:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108e89:	00 
80108e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80108e91:	89 04 24             	mov    %eax,(%esp)
80108e94:	e8 38 f8 ff ff       	call   801086d1 <walkpgdir>
80108e99:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108e9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ea0:	75 0c                	jne    80108eae <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108ea2:	c7 04 24 a2 97 10 80 	movl   $0x801097a2,(%esp)
80108ea9:	e8 8c 76 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eb1:	8b 00                	mov    (%eax),%eax
80108eb3:	83 e0 01             	and    $0x1,%eax
80108eb6:	85 c0                	test   %eax,%eax
80108eb8:	75 0c                	jne    80108ec6 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108eba:	c7 04 24 bc 97 10 80 	movl   $0x801097bc,(%esp)
80108ec1:	e8 74 76 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ec9:	8b 00                	mov    (%eax),%eax
80108ecb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ed0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ed6:	8b 00                	mov    (%eax),%eax
80108ed8:	25 ff 0f 00 00       	and    $0xfff,%eax
80108edd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108ee0:	e8 22 9c ff ff       	call   80102b07 <kalloc>
80108ee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ee8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108eec:	75 02                	jne    80108ef0 <copyuvm+0x9c>
      goto bad;
80108eee:	eb 70                	jmp    80108f60 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ef3:	89 04 24             	mov    %eax,(%esp)
80108ef6:	e8 53 f3 ff ff       	call   8010824e <p2v>
80108efb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108f02:	00 
80108f03:	89 44 24 04          	mov    %eax,0x4(%esp)
80108f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108f0a:	89 04 24             	mov    %eax,(%esp)
80108f0d:	e8 81 cc ff ff       	call   80105b93 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108f12:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108f15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108f18:	89 04 24             	mov    %eax,(%esp)
80108f1b:	e8 21 f3 ff ff       	call   80108241 <v2p>
80108f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108f23:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108f27:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108f2b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108f32:	00 
80108f33:	89 54 24 04          	mov    %edx,0x4(%esp)
80108f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f3a:	89 04 24             	mov    %eax,(%esp)
80108f3d:	e8 31 f8 ff ff       	call   80108773 <mappages>
80108f42:	85 c0                	test   %eax,%eax
80108f44:	79 02                	jns    80108f48 <copyuvm+0xf4>
      goto bad;
80108f46:	eb 18                	jmp    80108f60 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108f48:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f52:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108f55:	0f 82 24 ff ff ff    	jb     80108e7f <copyuvm+0x2b>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }

  return d;
80108f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f5e:	eb 10                	jmp    80108f70 <copyuvm+0x11c>

bad:

  freevm(d);
80108f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f63:	89 04 24             	mov    %eax,(%esp)
80108f66:	e8 09 fe ff ff       	call   80108d74 <freevm>
  return 0;
80108f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f70:	83 c4 44             	add    $0x44,%esp
80108f73:	5b                   	pop    %ebx
80108f74:	5d                   	pop    %ebp
80108f75:	c3                   	ret    

80108f76 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108f76:	55                   	push   %ebp
80108f77:	89 e5                	mov    %esp,%ebp
80108f79:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108f7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108f83:	00 
80108f84:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f87:	89 44 24 04          	mov    %eax,0x4(%esp)
80108f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80108f8e:	89 04 24             	mov    %eax,(%esp)
80108f91:	e8 3b f7 ff ff       	call   801086d1 <walkpgdir>
80108f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9c:	8b 00                	mov    (%eax),%eax
80108f9e:	83 e0 01             	and    $0x1,%eax
80108fa1:	85 c0                	test   %eax,%eax
80108fa3:	75 07                	jne    80108fac <uva2ka+0x36>
    return 0;
80108fa5:	b8 00 00 00 00       	mov    $0x0,%eax
80108faa:	eb 25                	jmp    80108fd1 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108faf:	8b 00                	mov    (%eax),%eax
80108fb1:	83 e0 04             	and    $0x4,%eax
80108fb4:	85 c0                	test   %eax,%eax
80108fb6:	75 07                	jne    80108fbf <uva2ka+0x49>
    return 0;
80108fb8:	b8 00 00 00 00       	mov    $0x0,%eax
80108fbd:	eb 12                	jmp    80108fd1 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc2:	8b 00                	mov    (%eax),%eax
80108fc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fc9:	89 04 24             	mov    %eax,(%esp)
80108fcc:	e8 7d f2 ff ff       	call   8010824e <p2v>
}
80108fd1:	c9                   	leave  
80108fd2:	c3                   	ret    

80108fd3 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108fd3:	55                   	push   %ebp
80108fd4:	89 e5                	mov    %esp,%ebp
80108fd6:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108fd9:	8b 45 10             	mov    0x10(%ebp),%eax
80108fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108fdf:	e9 87 00 00 00       	jmp    8010906b <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fe7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80108ff9:	89 04 24             	mov    %eax,(%esp)
80108ffc:	e8 75 ff ff ff       	call   80108f76 <uva2ka>
80109001:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109004:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109008:	75 07                	jne    80109011 <copyout+0x3e>
      return -1;
8010900a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010900f:	eb 69                	jmp    8010907a <copyout+0xa7>
    n = PGSIZE - (va - va0);
80109011:	8b 45 0c             	mov    0xc(%ebp),%eax
80109014:	8b 55 ec             	mov    -0x14(%ebp),%edx
80109017:	29 c2                	sub    %eax,%edx
80109019:	89 d0                	mov    %edx,%eax
8010901b:	05 00 10 00 00       	add    $0x1000,%eax
80109020:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109026:	3b 45 14             	cmp    0x14(%ebp),%eax
80109029:	76 06                	jbe    80109031 <copyout+0x5e>
      n = len;
8010902b:	8b 45 14             	mov    0x14(%ebp),%eax
8010902e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109031:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109034:	8b 55 0c             	mov    0xc(%ebp),%edx
80109037:	29 c2                	sub    %eax,%edx
80109039:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010903c:	01 c2                	add    %eax,%edx
8010903e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109041:	89 44 24 08          	mov    %eax,0x8(%esp)
80109045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109048:	89 44 24 04          	mov    %eax,0x4(%esp)
8010904c:	89 14 24             	mov    %edx,(%esp)
8010904f:	e8 3f cb ff ff       	call   80105b93 <memmove>
    len -= n;
80109054:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109057:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010905a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010905d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109060:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109063:	05 00 10 00 00       	add    $0x1000,%eax
80109068:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010906b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010906f:	0f 85 6f ff ff ff    	jne    80108fe4 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109075:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010907a:	c9                   	leave  
8010907b:	c3                   	ret    
