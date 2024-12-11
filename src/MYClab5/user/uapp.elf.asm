
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	08c0006f          	j	8c <main>

Disassembly of section .text.getpid:

0000000000000004 <getpid>:
   4:	fe010113          	addi	sp,sp,-32
   8:	00813c23          	sd	s0,24(sp)
   c:	02010413          	addi	s0,sp,32
  10:	fe843783          	ld	a5,-24(s0)
  14:	0ac00893          	li	a7,172
  18:	00000073          	ecall
  1c:	00050793          	mv	a5,a0
  20:	fef43423          	sd	a5,-24(s0)
  24:	fe843783          	ld	a5,-24(s0)
  28:	00078513          	mv	a0,a5
  2c:	01813403          	ld	s0,24(sp)
  30:	02010113          	addi	sp,sp,32
  34:	00008067          	ret

Disassembly of section .text.wait:

0000000000000038 <wait>:
  38:	fd010113          	addi	sp,sp,-48
  3c:	02813423          	sd	s0,40(sp)
  40:	03010413          	addi	s0,sp,48
  44:	00050793          	mv	a5,a0
  48:	fcf42e23          	sw	a5,-36(s0)
  4c:	fe042623          	sw	zero,-20(s0)
  50:	0100006f          	j	60 <wait+0x28>
  54:	fec42783          	lw	a5,-20(s0)
  58:	0017879b          	addiw	a5,a5,1
  5c:	fef42623          	sw	a5,-20(s0)
  60:	fec42783          	lw	a5,-20(s0)
  64:	00078713          	mv	a4,a5
  68:	fdc42783          	lw	a5,-36(s0)
  6c:	0007071b          	sext.w	a4,a4
  70:	0007879b          	sext.w	a5,a5
  74:	fef760e3          	bltu	a4,a5,54 <wait+0x1c>
  78:	00000013          	nop
  7c:	00000013          	nop
  80:	02813403          	ld	s0,40(sp)
  84:	03010113          	addi	sp,sp,48
  88:	00008067          	ret

Disassembly of section .text.main:

000000000000008c <main>:
  8c:	fe010113          	addi	sp,sp,-32
  90:	00113c23          	sd	ra,24(sp)
  94:	00813823          	sd	s0,16(sp)
  98:	02010413          	addi	s0,sp,32
  9c:	f69ff0ef          	jal	4 <getpid>
  a0:	00050593          	mv	a1,a0
  a4:	00010613          	mv	a2,sp
  a8:	00001797          	auipc	a5,0x1
  ac:	23c78793          	addi	a5,a5,572 # 12e4 <counter>
  b0:	0007a783          	lw	a5,0(a5)
  b4:	0017879b          	addiw	a5,a5,1
  b8:	0007871b          	sext.w	a4,a5
  bc:	00001797          	auipc	a5,0x1
  c0:	22878793          	addi	a5,a5,552 # 12e4 <counter>
  c4:	00e7a023          	sw	a4,0(a5)
  c8:	00001797          	auipc	a5,0x1
  cc:	21c78793          	addi	a5,a5,540 # 12e4 <counter>
  d0:	0007a783          	lw	a5,0(a5)
  d4:	00078693          	mv	a3,a5
  d8:	00001517          	auipc	a0,0x1
  dc:	18850513          	addi	a0,a0,392 # 1260 <printf+0x29c>
  e0:	6e5000ef          	jal	fc4 <printf>
  e4:	fe042623          	sw	zero,-20(s0)
  e8:	0100006f          	j	f8 <main+0x6c>
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	0017879b          	addiw	a5,a5,1
  f4:	fef42623          	sw	a5,-20(s0)
  f8:	fec42783          	lw	a5,-20(s0)
  fc:	0007871b          	sext.w	a4,a5
 100:	500007b7          	lui	a5,0x50000
 104:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <buffer+0x4fffed0e>
 108:	fee7f2e3          	bgeu	a5,a4,ec <main+0x60>
 10c:	f91ff06f          	j	9c <main+0x10>

Disassembly of section .text.putc:

0000000000000110 <putc>:
 110:	fe010113          	addi	sp,sp,-32
 114:	00813c23          	sd	s0,24(sp)
 118:	02010413          	addi	s0,sp,32
 11c:	00050793          	mv	a5,a0
 120:	fef42623          	sw	a5,-20(s0)
 124:	00001797          	auipc	a5,0x1
 128:	1c478793          	addi	a5,a5,452 # 12e8 <tail>
 12c:	0007a783          	lw	a5,0(a5)
 130:	0017871b          	addiw	a4,a5,1
 134:	0007069b          	sext.w	a3,a4
 138:	00001717          	auipc	a4,0x1
 13c:	1b070713          	addi	a4,a4,432 # 12e8 <tail>
 140:	00d72023          	sw	a3,0(a4)
 144:	fec42703          	lw	a4,-20(s0)
 148:	0ff77713          	zext.b	a4,a4
 14c:	00001697          	auipc	a3,0x1
 150:	1a468693          	addi	a3,a3,420 # 12f0 <buffer>
 154:	00f687b3          	add	a5,a3,a5
 158:	00e78023          	sb	a4,0(a5)
 15c:	fec42783          	lw	a5,-20(s0)
 160:	0ff7f793          	zext.b	a5,a5
 164:	0007879b          	sext.w	a5,a5
 168:	00078513          	mv	a0,a5
 16c:	01813403          	ld	s0,24(sp)
 170:	02010113          	addi	sp,sp,32
 174:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000178 <isspace>:
 178:	fe010113          	addi	sp,sp,-32
 17c:	00813c23          	sd	s0,24(sp)
 180:	02010413          	addi	s0,sp,32
 184:	00050793          	mv	a5,a0
 188:	fef42623          	sw	a5,-20(s0)
 18c:	fec42783          	lw	a5,-20(s0)
 190:	0007871b          	sext.w	a4,a5
 194:	02000793          	li	a5,32
 198:	02f70263          	beq	a4,a5,1bc <isspace+0x44>
 19c:	fec42783          	lw	a5,-20(s0)
 1a0:	0007871b          	sext.w	a4,a5
 1a4:	00800793          	li	a5,8
 1a8:	00e7de63          	bge	a5,a4,1c4 <isspace+0x4c>
 1ac:	fec42783          	lw	a5,-20(s0)
 1b0:	0007871b          	sext.w	a4,a5
 1b4:	00d00793          	li	a5,13
 1b8:	00e7c663          	blt	a5,a4,1c4 <isspace+0x4c>
 1bc:	00100793          	li	a5,1
 1c0:	0080006f          	j	1c8 <isspace+0x50>
 1c4:	00000793          	li	a5,0
 1c8:	00078513          	mv	a0,a5
 1cc:	01813403          	ld	s0,24(sp)
 1d0:	02010113          	addi	sp,sp,32
 1d4:	00008067          	ret

Disassembly of section .text.strtol:

00000000000001d8 <strtol>:
 1d8:	fb010113          	addi	sp,sp,-80
 1dc:	04113423          	sd	ra,72(sp)
 1e0:	04813023          	sd	s0,64(sp)
 1e4:	05010413          	addi	s0,sp,80
 1e8:	fca43423          	sd	a0,-56(s0)
 1ec:	fcb43023          	sd	a1,-64(s0)
 1f0:	00060793          	mv	a5,a2
 1f4:	faf42e23          	sw	a5,-68(s0)
 1f8:	fe043423          	sd	zero,-24(s0)
 1fc:	fe0403a3          	sb	zero,-25(s0)
 200:	fc843783          	ld	a5,-56(s0)
 204:	fcf43c23          	sd	a5,-40(s0)
 208:	0100006f          	j	218 <strtol+0x40>
 20c:	fd843783          	ld	a5,-40(s0)
 210:	00178793          	addi	a5,a5,1
 214:	fcf43c23          	sd	a5,-40(s0)
 218:	fd843783          	ld	a5,-40(s0)
 21c:	0007c783          	lbu	a5,0(a5)
 220:	0007879b          	sext.w	a5,a5
 224:	00078513          	mv	a0,a5
 228:	f51ff0ef          	jal	178 <isspace>
 22c:	00050793          	mv	a5,a0
 230:	fc079ee3          	bnez	a5,20c <strtol+0x34>
 234:	fd843783          	ld	a5,-40(s0)
 238:	0007c783          	lbu	a5,0(a5)
 23c:	00078713          	mv	a4,a5
 240:	02d00793          	li	a5,45
 244:	00f71e63          	bne	a4,a5,260 <strtol+0x88>
 248:	00100793          	li	a5,1
 24c:	fef403a3          	sb	a5,-25(s0)
 250:	fd843783          	ld	a5,-40(s0)
 254:	00178793          	addi	a5,a5,1
 258:	fcf43c23          	sd	a5,-40(s0)
 25c:	0240006f          	j	280 <strtol+0xa8>
 260:	fd843783          	ld	a5,-40(s0)
 264:	0007c783          	lbu	a5,0(a5)
 268:	00078713          	mv	a4,a5
 26c:	02b00793          	li	a5,43
 270:	00f71863          	bne	a4,a5,280 <strtol+0xa8>
 274:	fd843783          	ld	a5,-40(s0)
 278:	00178793          	addi	a5,a5,1
 27c:	fcf43c23          	sd	a5,-40(s0)
 280:	fbc42783          	lw	a5,-68(s0)
 284:	0007879b          	sext.w	a5,a5
 288:	06079c63          	bnez	a5,300 <strtol+0x128>
 28c:	fd843783          	ld	a5,-40(s0)
 290:	0007c783          	lbu	a5,0(a5)
 294:	00078713          	mv	a4,a5
 298:	03000793          	li	a5,48
 29c:	04f71e63          	bne	a4,a5,2f8 <strtol+0x120>
 2a0:	fd843783          	ld	a5,-40(s0)
 2a4:	00178793          	addi	a5,a5,1
 2a8:	fcf43c23          	sd	a5,-40(s0)
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	0007c783          	lbu	a5,0(a5)
 2b4:	00078713          	mv	a4,a5
 2b8:	07800793          	li	a5,120
 2bc:	00f70c63          	beq	a4,a5,2d4 <strtol+0xfc>
 2c0:	fd843783          	ld	a5,-40(s0)
 2c4:	0007c783          	lbu	a5,0(a5)
 2c8:	00078713          	mv	a4,a5
 2cc:	05800793          	li	a5,88
 2d0:	00f71e63          	bne	a4,a5,2ec <strtol+0x114>
 2d4:	01000793          	li	a5,16
 2d8:	faf42e23          	sw	a5,-68(s0)
 2dc:	fd843783          	ld	a5,-40(s0)
 2e0:	00178793          	addi	a5,a5,1
 2e4:	fcf43c23          	sd	a5,-40(s0)
 2e8:	0180006f          	j	300 <strtol+0x128>
 2ec:	00800793          	li	a5,8
 2f0:	faf42e23          	sw	a5,-68(s0)
 2f4:	00c0006f          	j	300 <strtol+0x128>
 2f8:	00a00793          	li	a5,10
 2fc:	faf42e23          	sw	a5,-68(s0)
 300:	fd843783          	ld	a5,-40(s0)
 304:	0007c783          	lbu	a5,0(a5)
 308:	00078713          	mv	a4,a5
 30c:	02f00793          	li	a5,47
 310:	02e7f863          	bgeu	a5,a4,340 <strtol+0x168>
 314:	fd843783          	ld	a5,-40(s0)
 318:	0007c783          	lbu	a5,0(a5)
 31c:	00078713          	mv	a4,a5
 320:	03900793          	li	a5,57
 324:	00e7ee63          	bltu	a5,a4,340 <strtol+0x168>
 328:	fd843783          	ld	a5,-40(s0)
 32c:	0007c783          	lbu	a5,0(a5)
 330:	0007879b          	sext.w	a5,a5
 334:	fd07879b          	addiw	a5,a5,-48
 338:	fcf42a23          	sw	a5,-44(s0)
 33c:	0800006f          	j	3bc <strtol+0x1e4>
 340:	fd843783          	ld	a5,-40(s0)
 344:	0007c783          	lbu	a5,0(a5)
 348:	00078713          	mv	a4,a5
 34c:	06000793          	li	a5,96
 350:	02e7f863          	bgeu	a5,a4,380 <strtol+0x1a8>
 354:	fd843783          	ld	a5,-40(s0)
 358:	0007c783          	lbu	a5,0(a5)
 35c:	00078713          	mv	a4,a5
 360:	07a00793          	li	a5,122
 364:	00e7ee63          	bltu	a5,a4,380 <strtol+0x1a8>
 368:	fd843783          	ld	a5,-40(s0)
 36c:	0007c783          	lbu	a5,0(a5)
 370:	0007879b          	sext.w	a5,a5
 374:	fa97879b          	addiw	a5,a5,-87
 378:	fcf42a23          	sw	a5,-44(s0)
 37c:	0400006f          	j	3bc <strtol+0x1e4>
 380:	fd843783          	ld	a5,-40(s0)
 384:	0007c783          	lbu	a5,0(a5)
 388:	00078713          	mv	a4,a5
 38c:	04000793          	li	a5,64
 390:	06e7f863          	bgeu	a5,a4,400 <strtol+0x228>
 394:	fd843783          	ld	a5,-40(s0)
 398:	0007c783          	lbu	a5,0(a5)
 39c:	00078713          	mv	a4,a5
 3a0:	05a00793          	li	a5,90
 3a4:	04e7ee63          	bltu	a5,a4,400 <strtol+0x228>
 3a8:	fd843783          	ld	a5,-40(s0)
 3ac:	0007c783          	lbu	a5,0(a5)
 3b0:	0007879b          	sext.w	a5,a5
 3b4:	fc97879b          	addiw	a5,a5,-55
 3b8:	fcf42a23          	sw	a5,-44(s0)
 3bc:	fd442783          	lw	a5,-44(s0)
 3c0:	00078713          	mv	a4,a5
 3c4:	fbc42783          	lw	a5,-68(s0)
 3c8:	0007071b          	sext.w	a4,a4
 3cc:	0007879b          	sext.w	a5,a5
 3d0:	02f75663          	bge	a4,a5,3fc <strtol+0x224>
 3d4:	fbc42703          	lw	a4,-68(s0)
 3d8:	fe843783          	ld	a5,-24(s0)
 3dc:	02f70733          	mul	a4,a4,a5
 3e0:	fd442783          	lw	a5,-44(s0)
 3e4:	00f707b3          	add	a5,a4,a5
 3e8:	fef43423          	sd	a5,-24(s0)
 3ec:	fd843783          	ld	a5,-40(s0)
 3f0:	00178793          	addi	a5,a5,1
 3f4:	fcf43c23          	sd	a5,-40(s0)
 3f8:	f09ff06f          	j	300 <strtol+0x128>
 3fc:	00000013          	nop
 400:	fc043783          	ld	a5,-64(s0)
 404:	00078863          	beqz	a5,414 <strtol+0x23c>
 408:	fc043783          	ld	a5,-64(s0)
 40c:	fd843703          	ld	a4,-40(s0)
 410:	00e7b023          	sd	a4,0(a5)
 414:	fe744783          	lbu	a5,-25(s0)
 418:	0ff7f793          	zext.b	a5,a5
 41c:	00078863          	beqz	a5,42c <strtol+0x254>
 420:	fe843783          	ld	a5,-24(s0)
 424:	40f007b3          	neg	a5,a5
 428:	0080006f          	j	430 <strtol+0x258>
 42c:	fe843783          	ld	a5,-24(s0)
 430:	00078513          	mv	a0,a5
 434:	04813083          	ld	ra,72(sp)
 438:	04013403          	ld	s0,64(sp)
 43c:	05010113          	addi	sp,sp,80
 440:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

0000000000000444 <puts_wo_nl>:
 444:	fd010113          	addi	sp,sp,-48
 448:	02113423          	sd	ra,40(sp)
 44c:	02813023          	sd	s0,32(sp)
 450:	03010413          	addi	s0,sp,48
 454:	fca43c23          	sd	a0,-40(s0)
 458:	fcb43823          	sd	a1,-48(s0)
 45c:	fd043783          	ld	a5,-48(s0)
 460:	00079863          	bnez	a5,470 <puts_wo_nl+0x2c>
 464:	00001797          	auipc	a5,0x1
 468:	e3478793          	addi	a5,a5,-460 # 1298 <printf+0x2d4>
 46c:	fcf43823          	sd	a5,-48(s0)
 470:	fd043783          	ld	a5,-48(s0)
 474:	fef43423          	sd	a5,-24(s0)
 478:	0240006f          	j	49c <puts_wo_nl+0x58>
 47c:	fe843783          	ld	a5,-24(s0)
 480:	00178713          	addi	a4,a5,1
 484:	fee43423          	sd	a4,-24(s0)
 488:	0007c783          	lbu	a5,0(a5)
 48c:	0007871b          	sext.w	a4,a5
 490:	fd843783          	ld	a5,-40(s0)
 494:	00070513          	mv	a0,a4
 498:	000780e7          	jalr	a5
 49c:	fe843783          	ld	a5,-24(s0)
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	fc079ce3          	bnez	a5,47c <puts_wo_nl+0x38>
 4a8:	fe843703          	ld	a4,-24(s0)
 4ac:	fd043783          	ld	a5,-48(s0)
 4b0:	40f707b3          	sub	a5,a4,a5
 4b4:	0007879b          	sext.w	a5,a5
 4b8:	00078513          	mv	a0,a5
 4bc:	02813083          	ld	ra,40(sp)
 4c0:	02013403          	ld	s0,32(sp)
 4c4:	03010113          	addi	sp,sp,48
 4c8:	00008067          	ret

Disassembly of section .text.print_dec_int:

00000000000004cc <print_dec_int>:
 4cc:	f9010113          	addi	sp,sp,-112
 4d0:	06113423          	sd	ra,104(sp)
 4d4:	06813023          	sd	s0,96(sp)
 4d8:	07010413          	addi	s0,sp,112
 4dc:	faa43423          	sd	a0,-88(s0)
 4e0:	fab43023          	sd	a1,-96(s0)
 4e4:	00060793          	mv	a5,a2
 4e8:	f8d43823          	sd	a3,-112(s0)
 4ec:	f8f40fa3          	sb	a5,-97(s0)
 4f0:	f9f44783          	lbu	a5,-97(s0)
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	02078663          	beqz	a5,524 <print_dec_int+0x58>
 4fc:	fa043703          	ld	a4,-96(s0)
 500:	fff00793          	li	a5,-1
 504:	03f79793          	slli	a5,a5,0x3f
 508:	00f71e63          	bne	a4,a5,524 <print_dec_int+0x58>
 50c:	00001597          	auipc	a1,0x1
 510:	d9458593          	addi	a1,a1,-620 # 12a0 <printf+0x2dc>
 514:	fa843503          	ld	a0,-88(s0)
 518:	f2dff0ef          	jal	444 <puts_wo_nl>
 51c:	00050793          	mv	a5,a0
 520:	2a00006f          	j	7c0 <print_dec_int+0x2f4>
 524:	f9043783          	ld	a5,-112(s0)
 528:	00c7a783          	lw	a5,12(a5)
 52c:	00079a63          	bnez	a5,540 <print_dec_int+0x74>
 530:	fa043783          	ld	a5,-96(s0)
 534:	00079663          	bnez	a5,540 <print_dec_int+0x74>
 538:	00000793          	li	a5,0
 53c:	2840006f          	j	7c0 <print_dec_int+0x2f4>
 540:	fe0407a3          	sb	zero,-17(s0)
 544:	f9f44783          	lbu	a5,-97(s0)
 548:	0ff7f793          	zext.b	a5,a5
 54c:	02078063          	beqz	a5,56c <print_dec_int+0xa0>
 550:	fa043783          	ld	a5,-96(s0)
 554:	0007dc63          	bgez	a5,56c <print_dec_int+0xa0>
 558:	00100793          	li	a5,1
 55c:	fef407a3          	sb	a5,-17(s0)
 560:	fa043783          	ld	a5,-96(s0)
 564:	40f007b3          	neg	a5,a5
 568:	faf43023          	sd	a5,-96(s0)
 56c:	fe042423          	sw	zero,-24(s0)
 570:	f9f44783          	lbu	a5,-97(s0)
 574:	0ff7f793          	zext.b	a5,a5
 578:	02078863          	beqz	a5,5a8 <print_dec_int+0xdc>
 57c:	fef44783          	lbu	a5,-17(s0)
 580:	0ff7f793          	zext.b	a5,a5
 584:	00079e63          	bnez	a5,5a0 <print_dec_int+0xd4>
 588:	f9043783          	ld	a5,-112(s0)
 58c:	0057c783          	lbu	a5,5(a5)
 590:	00079863          	bnez	a5,5a0 <print_dec_int+0xd4>
 594:	f9043783          	ld	a5,-112(s0)
 598:	0047c783          	lbu	a5,4(a5)
 59c:	00078663          	beqz	a5,5a8 <print_dec_int+0xdc>
 5a0:	00100793          	li	a5,1
 5a4:	0080006f          	j	5ac <print_dec_int+0xe0>
 5a8:	00000793          	li	a5,0
 5ac:	fcf40ba3          	sb	a5,-41(s0)
 5b0:	fd744783          	lbu	a5,-41(s0)
 5b4:	0017f793          	andi	a5,a5,1
 5b8:	fcf40ba3          	sb	a5,-41(s0)
 5bc:	fa043703          	ld	a4,-96(s0)
 5c0:	00a00793          	li	a5,10
 5c4:	02f777b3          	remu	a5,a4,a5
 5c8:	0ff7f713          	zext.b	a4,a5
 5cc:	fe842783          	lw	a5,-24(s0)
 5d0:	0017869b          	addiw	a3,a5,1
 5d4:	fed42423          	sw	a3,-24(s0)
 5d8:	0307071b          	addiw	a4,a4,48
 5dc:	0ff77713          	zext.b	a4,a4
 5e0:	ff078793          	addi	a5,a5,-16
 5e4:	008787b3          	add	a5,a5,s0
 5e8:	fce78423          	sb	a4,-56(a5)
 5ec:	fa043703          	ld	a4,-96(s0)
 5f0:	00a00793          	li	a5,10
 5f4:	02f757b3          	divu	a5,a4,a5
 5f8:	faf43023          	sd	a5,-96(s0)
 5fc:	fa043783          	ld	a5,-96(s0)
 600:	fa079ee3          	bnez	a5,5bc <print_dec_int+0xf0>
 604:	f9043783          	ld	a5,-112(s0)
 608:	00c7a783          	lw	a5,12(a5)
 60c:	00078713          	mv	a4,a5
 610:	fff00793          	li	a5,-1
 614:	02f71063          	bne	a4,a5,634 <print_dec_int+0x168>
 618:	f9043783          	ld	a5,-112(s0)
 61c:	0037c783          	lbu	a5,3(a5)
 620:	00078a63          	beqz	a5,634 <print_dec_int+0x168>
 624:	f9043783          	ld	a5,-112(s0)
 628:	0087a703          	lw	a4,8(a5)
 62c:	f9043783          	ld	a5,-112(s0)
 630:	00e7a623          	sw	a4,12(a5)
 634:	fe042223          	sw	zero,-28(s0)
 638:	f9043783          	ld	a5,-112(s0)
 63c:	0087a703          	lw	a4,8(a5)
 640:	fe842783          	lw	a5,-24(s0)
 644:	fcf42823          	sw	a5,-48(s0)
 648:	f9043783          	ld	a5,-112(s0)
 64c:	00c7a783          	lw	a5,12(a5)
 650:	fcf42623          	sw	a5,-52(s0)
 654:	fd042783          	lw	a5,-48(s0)
 658:	00078593          	mv	a1,a5
 65c:	fcc42783          	lw	a5,-52(s0)
 660:	00078613          	mv	a2,a5
 664:	0006069b          	sext.w	a3,a2
 668:	0005879b          	sext.w	a5,a1
 66c:	00f6d463          	bge	a3,a5,674 <print_dec_int+0x1a8>
 670:	00058613          	mv	a2,a1
 674:	0006079b          	sext.w	a5,a2
 678:	40f707bb          	subw	a5,a4,a5
 67c:	0007871b          	sext.w	a4,a5
 680:	fd744783          	lbu	a5,-41(s0)
 684:	0007879b          	sext.w	a5,a5
 688:	40f707bb          	subw	a5,a4,a5
 68c:	fef42023          	sw	a5,-32(s0)
 690:	0280006f          	j	6b8 <print_dec_int+0x1ec>
 694:	fa843783          	ld	a5,-88(s0)
 698:	02000513          	li	a0,32
 69c:	000780e7          	jalr	a5
 6a0:	fe442783          	lw	a5,-28(s0)
 6a4:	0017879b          	addiw	a5,a5,1
 6a8:	fef42223          	sw	a5,-28(s0)
 6ac:	fe042783          	lw	a5,-32(s0)
 6b0:	fff7879b          	addiw	a5,a5,-1
 6b4:	fef42023          	sw	a5,-32(s0)
 6b8:	fe042783          	lw	a5,-32(s0)
 6bc:	0007879b          	sext.w	a5,a5
 6c0:	fcf04ae3          	bgtz	a5,694 <print_dec_int+0x1c8>
 6c4:	fd744783          	lbu	a5,-41(s0)
 6c8:	0ff7f793          	zext.b	a5,a5
 6cc:	04078463          	beqz	a5,714 <print_dec_int+0x248>
 6d0:	fef44783          	lbu	a5,-17(s0)
 6d4:	0ff7f793          	zext.b	a5,a5
 6d8:	00078663          	beqz	a5,6e4 <print_dec_int+0x218>
 6dc:	02d00793          	li	a5,45
 6e0:	01c0006f          	j	6fc <print_dec_int+0x230>
 6e4:	f9043783          	ld	a5,-112(s0)
 6e8:	0057c783          	lbu	a5,5(a5)
 6ec:	00078663          	beqz	a5,6f8 <print_dec_int+0x22c>
 6f0:	02b00793          	li	a5,43
 6f4:	0080006f          	j	6fc <print_dec_int+0x230>
 6f8:	02000793          	li	a5,32
 6fc:	fa843703          	ld	a4,-88(s0)
 700:	00078513          	mv	a0,a5
 704:	000700e7          	jalr	a4
 708:	fe442783          	lw	a5,-28(s0)
 70c:	0017879b          	addiw	a5,a5,1
 710:	fef42223          	sw	a5,-28(s0)
 714:	fe842783          	lw	a5,-24(s0)
 718:	fcf42e23          	sw	a5,-36(s0)
 71c:	0280006f          	j	744 <print_dec_int+0x278>
 720:	fa843783          	ld	a5,-88(s0)
 724:	03000513          	li	a0,48
 728:	000780e7          	jalr	a5
 72c:	fe442783          	lw	a5,-28(s0)
 730:	0017879b          	addiw	a5,a5,1
 734:	fef42223          	sw	a5,-28(s0)
 738:	fdc42783          	lw	a5,-36(s0)
 73c:	0017879b          	addiw	a5,a5,1
 740:	fcf42e23          	sw	a5,-36(s0)
 744:	f9043783          	ld	a5,-112(s0)
 748:	00c7a703          	lw	a4,12(a5)
 74c:	fd744783          	lbu	a5,-41(s0)
 750:	0007879b          	sext.w	a5,a5
 754:	40f707bb          	subw	a5,a4,a5
 758:	0007871b          	sext.w	a4,a5
 75c:	fdc42783          	lw	a5,-36(s0)
 760:	0007879b          	sext.w	a5,a5
 764:	fae7cee3          	blt	a5,a4,720 <print_dec_int+0x254>
 768:	fe842783          	lw	a5,-24(s0)
 76c:	fff7879b          	addiw	a5,a5,-1
 770:	fcf42c23          	sw	a5,-40(s0)
 774:	03c0006f          	j	7b0 <print_dec_int+0x2e4>
 778:	fd842783          	lw	a5,-40(s0)
 77c:	ff078793          	addi	a5,a5,-16
 780:	008787b3          	add	a5,a5,s0
 784:	fc87c783          	lbu	a5,-56(a5)
 788:	0007871b          	sext.w	a4,a5
 78c:	fa843783          	ld	a5,-88(s0)
 790:	00070513          	mv	a0,a4
 794:	000780e7          	jalr	a5
 798:	fe442783          	lw	a5,-28(s0)
 79c:	0017879b          	addiw	a5,a5,1
 7a0:	fef42223          	sw	a5,-28(s0)
 7a4:	fd842783          	lw	a5,-40(s0)
 7a8:	fff7879b          	addiw	a5,a5,-1
 7ac:	fcf42c23          	sw	a5,-40(s0)
 7b0:	fd842783          	lw	a5,-40(s0)
 7b4:	0007879b          	sext.w	a5,a5
 7b8:	fc07d0e3          	bgez	a5,778 <print_dec_int+0x2ac>
 7bc:	fe442783          	lw	a5,-28(s0)
 7c0:	00078513          	mv	a0,a5
 7c4:	06813083          	ld	ra,104(sp)
 7c8:	06013403          	ld	s0,96(sp)
 7cc:	07010113          	addi	sp,sp,112
 7d0:	00008067          	ret

Disassembly of section .text.vprintfmt:

00000000000007d4 <vprintfmt>:
 7d4:	f4010113          	addi	sp,sp,-192
 7d8:	0a113c23          	sd	ra,184(sp)
 7dc:	0a813823          	sd	s0,176(sp)
 7e0:	0c010413          	addi	s0,sp,192
 7e4:	f4a43c23          	sd	a0,-168(s0)
 7e8:	f4b43823          	sd	a1,-176(s0)
 7ec:	f4c43423          	sd	a2,-184(s0)
 7f0:	f8043023          	sd	zero,-128(s0)
 7f4:	f8043423          	sd	zero,-120(s0)
 7f8:	fe042623          	sw	zero,-20(s0)
 7fc:	7a40006f          	j	fa0 <vprintfmt+0x7cc>
 800:	f8044783          	lbu	a5,-128(s0)
 804:	72078e63          	beqz	a5,f40 <vprintfmt+0x76c>
 808:	f5043783          	ld	a5,-176(s0)
 80c:	0007c783          	lbu	a5,0(a5)
 810:	00078713          	mv	a4,a5
 814:	02300793          	li	a5,35
 818:	00f71863          	bne	a4,a5,828 <vprintfmt+0x54>
 81c:	00100793          	li	a5,1
 820:	f8f40123          	sb	a5,-126(s0)
 824:	7700006f          	j	f94 <vprintfmt+0x7c0>
 828:	f5043783          	ld	a5,-176(s0)
 82c:	0007c783          	lbu	a5,0(a5)
 830:	00078713          	mv	a4,a5
 834:	03000793          	li	a5,48
 838:	00f71863          	bne	a4,a5,848 <vprintfmt+0x74>
 83c:	00100793          	li	a5,1
 840:	f8f401a3          	sb	a5,-125(s0)
 844:	7500006f          	j	f94 <vprintfmt+0x7c0>
 848:	f5043783          	ld	a5,-176(s0)
 84c:	0007c783          	lbu	a5,0(a5)
 850:	00078713          	mv	a4,a5
 854:	06c00793          	li	a5,108
 858:	04f70063          	beq	a4,a5,898 <vprintfmt+0xc4>
 85c:	f5043783          	ld	a5,-176(s0)
 860:	0007c783          	lbu	a5,0(a5)
 864:	00078713          	mv	a4,a5
 868:	07a00793          	li	a5,122
 86c:	02f70663          	beq	a4,a5,898 <vprintfmt+0xc4>
 870:	f5043783          	ld	a5,-176(s0)
 874:	0007c783          	lbu	a5,0(a5)
 878:	00078713          	mv	a4,a5
 87c:	07400793          	li	a5,116
 880:	00f70c63          	beq	a4,a5,898 <vprintfmt+0xc4>
 884:	f5043783          	ld	a5,-176(s0)
 888:	0007c783          	lbu	a5,0(a5)
 88c:	00078713          	mv	a4,a5
 890:	06a00793          	li	a5,106
 894:	00f71863          	bne	a4,a5,8a4 <vprintfmt+0xd0>
 898:	00100793          	li	a5,1
 89c:	f8f400a3          	sb	a5,-127(s0)
 8a0:	6f40006f          	j	f94 <vprintfmt+0x7c0>
 8a4:	f5043783          	ld	a5,-176(s0)
 8a8:	0007c783          	lbu	a5,0(a5)
 8ac:	00078713          	mv	a4,a5
 8b0:	02b00793          	li	a5,43
 8b4:	00f71863          	bne	a4,a5,8c4 <vprintfmt+0xf0>
 8b8:	00100793          	li	a5,1
 8bc:	f8f402a3          	sb	a5,-123(s0)
 8c0:	6d40006f          	j	f94 <vprintfmt+0x7c0>
 8c4:	f5043783          	ld	a5,-176(s0)
 8c8:	0007c783          	lbu	a5,0(a5)
 8cc:	00078713          	mv	a4,a5
 8d0:	02000793          	li	a5,32
 8d4:	00f71863          	bne	a4,a5,8e4 <vprintfmt+0x110>
 8d8:	00100793          	li	a5,1
 8dc:	f8f40223          	sb	a5,-124(s0)
 8e0:	6b40006f          	j	f94 <vprintfmt+0x7c0>
 8e4:	f5043783          	ld	a5,-176(s0)
 8e8:	0007c783          	lbu	a5,0(a5)
 8ec:	00078713          	mv	a4,a5
 8f0:	02a00793          	li	a5,42
 8f4:	00f71e63          	bne	a4,a5,910 <vprintfmt+0x13c>
 8f8:	f4843783          	ld	a5,-184(s0)
 8fc:	00878713          	addi	a4,a5,8
 900:	f4e43423          	sd	a4,-184(s0)
 904:	0007a783          	lw	a5,0(a5)
 908:	f8f42423          	sw	a5,-120(s0)
 90c:	6880006f          	j	f94 <vprintfmt+0x7c0>
 910:	f5043783          	ld	a5,-176(s0)
 914:	0007c783          	lbu	a5,0(a5)
 918:	00078713          	mv	a4,a5
 91c:	03000793          	li	a5,48
 920:	04e7f663          	bgeu	a5,a4,96c <vprintfmt+0x198>
 924:	f5043783          	ld	a5,-176(s0)
 928:	0007c783          	lbu	a5,0(a5)
 92c:	00078713          	mv	a4,a5
 930:	03900793          	li	a5,57
 934:	02e7ec63          	bltu	a5,a4,96c <vprintfmt+0x198>
 938:	f5043783          	ld	a5,-176(s0)
 93c:	f5040713          	addi	a4,s0,-176
 940:	00a00613          	li	a2,10
 944:	00070593          	mv	a1,a4
 948:	00078513          	mv	a0,a5
 94c:	88dff0ef          	jal	1d8 <strtol>
 950:	00050793          	mv	a5,a0
 954:	0007879b          	sext.w	a5,a5
 958:	f8f42423          	sw	a5,-120(s0)
 95c:	f5043783          	ld	a5,-176(s0)
 960:	fff78793          	addi	a5,a5,-1
 964:	f4f43823          	sd	a5,-176(s0)
 968:	62c0006f          	j	f94 <vprintfmt+0x7c0>
 96c:	f5043783          	ld	a5,-176(s0)
 970:	0007c783          	lbu	a5,0(a5)
 974:	00078713          	mv	a4,a5
 978:	02e00793          	li	a5,46
 97c:	06f71863          	bne	a4,a5,9ec <vprintfmt+0x218>
 980:	f5043783          	ld	a5,-176(s0)
 984:	00178793          	addi	a5,a5,1
 988:	f4f43823          	sd	a5,-176(s0)
 98c:	f5043783          	ld	a5,-176(s0)
 990:	0007c783          	lbu	a5,0(a5)
 994:	00078713          	mv	a4,a5
 998:	02a00793          	li	a5,42
 99c:	00f71e63          	bne	a4,a5,9b8 <vprintfmt+0x1e4>
 9a0:	f4843783          	ld	a5,-184(s0)
 9a4:	00878713          	addi	a4,a5,8
 9a8:	f4e43423          	sd	a4,-184(s0)
 9ac:	0007a783          	lw	a5,0(a5)
 9b0:	f8f42623          	sw	a5,-116(s0)
 9b4:	5e00006f          	j	f94 <vprintfmt+0x7c0>
 9b8:	f5043783          	ld	a5,-176(s0)
 9bc:	f5040713          	addi	a4,s0,-176
 9c0:	00a00613          	li	a2,10
 9c4:	00070593          	mv	a1,a4
 9c8:	00078513          	mv	a0,a5
 9cc:	80dff0ef          	jal	1d8 <strtol>
 9d0:	00050793          	mv	a5,a0
 9d4:	0007879b          	sext.w	a5,a5
 9d8:	f8f42623          	sw	a5,-116(s0)
 9dc:	f5043783          	ld	a5,-176(s0)
 9e0:	fff78793          	addi	a5,a5,-1
 9e4:	f4f43823          	sd	a5,-176(s0)
 9e8:	5ac0006f          	j	f94 <vprintfmt+0x7c0>
 9ec:	f5043783          	ld	a5,-176(s0)
 9f0:	0007c783          	lbu	a5,0(a5)
 9f4:	00078713          	mv	a4,a5
 9f8:	07800793          	li	a5,120
 9fc:	02f70663          	beq	a4,a5,a28 <vprintfmt+0x254>
 a00:	f5043783          	ld	a5,-176(s0)
 a04:	0007c783          	lbu	a5,0(a5)
 a08:	00078713          	mv	a4,a5
 a0c:	05800793          	li	a5,88
 a10:	00f70c63          	beq	a4,a5,a28 <vprintfmt+0x254>
 a14:	f5043783          	ld	a5,-176(s0)
 a18:	0007c783          	lbu	a5,0(a5)
 a1c:	00078713          	mv	a4,a5
 a20:	07000793          	li	a5,112
 a24:	30f71263          	bne	a4,a5,d28 <vprintfmt+0x554>
 a28:	f5043783          	ld	a5,-176(s0)
 a2c:	0007c783          	lbu	a5,0(a5)
 a30:	00078713          	mv	a4,a5
 a34:	07000793          	li	a5,112
 a38:	00f70663          	beq	a4,a5,a44 <vprintfmt+0x270>
 a3c:	f8144783          	lbu	a5,-127(s0)
 a40:	00078663          	beqz	a5,a4c <vprintfmt+0x278>
 a44:	00100793          	li	a5,1
 a48:	0080006f          	j	a50 <vprintfmt+0x27c>
 a4c:	00000793          	li	a5,0
 a50:	faf403a3          	sb	a5,-89(s0)
 a54:	fa744783          	lbu	a5,-89(s0)
 a58:	0017f793          	andi	a5,a5,1
 a5c:	faf403a3          	sb	a5,-89(s0)
 a60:	fa744783          	lbu	a5,-89(s0)
 a64:	0ff7f793          	zext.b	a5,a5
 a68:	00078c63          	beqz	a5,a80 <vprintfmt+0x2ac>
 a6c:	f4843783          	ld	a5,-184(s0)
 a70:	00878713          	addi	a4,a5,8
 a74:	f4e43423          	sd	a4,-184(s0)
 a78:	0007b783          	ld	a5,0(a5)
 a7c:	01c0006f          	j	a98 <vprintfmt+0x2c4>
 a80:	f4843783          	ld	a5,-184(s0)
 a84:	00878713          	addi	a4,a5,8
 a88:	f4e43423          	sd	a4,-184(s0)
 a8c:	0007a783          	lw	a5,0(a5)
 a90:	02079793          	slli	a5,a5,0x20
 a94:	0207d793          	srli	a5,a5,0x20
 a98:	fef43023          	sd	a5,-32(s0)
 a9c:	f8c42783          	lw	a5,-116(s0)
 aa0:	02079463          	bnez	a5,ac8 <vprintfmt+0x2f4>
 aa4:	fe043783          	ld	a5,-32(s0)
 aa8:	02079063          	bnez	a5,ac8 <vprintfmt+0x2f4>
 aac:	f5043783          	ld	a5,-176(s0)
 ab0:	0007c783          	lbu	a5,0(a5)
 ab4:	00078713          	mv	a4,a5
 ab8:	07000793          	li	a5,112
 abc:	00f70663          	beq	a4,a5,ac8 <vprintfmt+0x2f4>
 ac0:	f8040023          	sb	zero,-128(s0)
 ac4:	4d00006f          	j	f94 <vprintfmt+0x7c0>
 ac8:	f5043783          	ld	a5,-176(s0)
 acc:	0007c783          	lbu	a5,0(a5)
 ad0:	00078713          	mv	a4,a5
 ad4:	07000793          	li	a5,112
 ad8:	00f70a63          	beq	a4,a5,aec <vprintfmt+0x318>
 adc:	f8244783          	lbu	a5,-126(s0)
 ae0:	00078a63          	beqz	a5,af4 <vprintfmt+0x320>
 ae4:	fe043783          	ld	a5,-32(s0)
 ae8:	00078663          	beqz	a5,af4 <vprintfmt+0x320>
 aec:	00100793          	li	a5,1
 af0:	0080006f          	j	af8 <vprintfmt+0x324>
 af4:	00000793          	li	a5,0
 af8:	faf40323          	sb	a5,-90(s0)
 afc:	fa644783          	lbu	a5,-90(s0)
 b00:	0017f793          	andi	a5,a5,1
 b04:	faf40323          	sb	a5,-90(s0)
 b08:	fc042e23          	sw	zero,-36(s0)
 b0c:	f5043783          	ld	a5,-176(s0)
 b10:	0007c783          	lbu	a5,0(a5)
 b14:	00078713          	mv	a4,a5
 b18:	05800793          	li	a5,88
 b1c:	00f71863          	bne	a4,a5,b2c <vprintfmt+0x358>
 b20:	00000797          	auipc	a5,0x0
 b24:	79878793          	addi	a5,a5,1944 # 12b8 <upperxdigits.1>
 b28:	00c0006f          	j	b34 <vprintfmt+0x360>
 b2c:	00000797          	auipc	a5,0x0
 b30:	7a478793          	addi	a5,a5,1956 # 12d0 <lowerxdigits.0>
 b34:	f8f43c23          	sd	a5,-104(s0)
 b38:	fe043783          	ld	a5,-32(s0)
 b3c:	00f7f793          	andi	a5,a5,15
 b40:	f9843703          	ld	a4,-104(s0)
 b44:	00f70733          	add	a4,a4,a5
 b48:	fdc42783          	lw	a5,-36(s0)
 b4c:	0017869b          	addiw	a3,a5,1
 b50:	fcd42e23          	sw	a3,-36(s0)
 b54:	00074703          	lbu	a4,0(a4)
 b58:	ff078793          	addi	a5,a5,-16
 b5c:	008787b3          	add	a5,a5,s0
 b60:	f8e78023          	sb	a4,-128(a5)
 b64:	fe043783          	ld	a5,-32(s0)
 b68:	0047d793          	srli	a5,a5,0x4
 b6c:	fef43023          	sd	a5,-32(s0)
 b70:	fe043783          	ld	a5,-32(s0)
 b74:	fc0792e3          	bnez	a5,b38 <vprintfmt+0x364>
 b78:	f8c42783          	lw	a5,-116(s0)
 b7c:	00078713          	mv	a4,a5
 b80:	fff00793          	li	a5,-1
 b84:	02f71663          	bne	a4,a5,bb0 <vprintfmt+0x3dc>
 b88:	f8344783          	lbu	a5,-125(s0)
 b8c:	02078263          	beqz	a5,bb0 <vprintfmt+0x3dc>
 b90:	f8842703          	lw	a4,-120(s0)
 b94:	fa644783          	lbu	a5,-90(s0)
 b98:	0007879b          	sext.w	a5,a5
 b9c:	0017979b          	slliw	a5,a5,0x1
 ba0:	0007879b          	sext.w	a5,a5
 ba4:	40f707bb          	subw	a5,a4,a5
 ba8:	0007879b          	sext.w	a5,a5
 bac:	f8f42623          	sw	a5,-116(s0)
 bb0:	f8842703          	lw	a4,-120(s0)
 bb4:	fa644783          	lbu	a5,-90(s0)
 bb8:	0007879b          	sext.w	a5,a5
 bbc:	0017979b          	slliw	a5,a5,0x1
 bc0:	0007879b          	sext.w	a5,a5
 bc4:	40f707bb          	subw	a5,a4,a5
 bc8:	0007871b          	sext.w	a4,a5
 bcc:	fdc42783          	lw	a5,-36(s0)
 bd0:	f8f42a23          	sw	a5,-108(s0)
 bd4:	f8c42783          	lw	a5,-116(s0)
 bd8:	f8f42823          	sw	a5,-112(s0)
 bdc:	f9442783          	lw	a5,-108(s0)
 be0:	00078593          	mv	a1,a5
 be4:	f9042783          	lw	a5,-112(s0)
 be8:	00078613          	mv	a2,a5
 bec:	0006069b          	sext.w	a3,a2
 bf0:	0005879b          	sext.w	a5,a1
 bf4:	00f6d463          	bge	a3,a5,bfc <vprintfmt+0x428>
 bf8:	00058613          	mv	a2,a1
 bfc:	0006079b          	sext.w	a5,a2
 c00:	40f707bb          	subw	a5,a4,a5
 c04:	fcf42c23          	sw	a5,-40(s0)
 c08:	0280006f          	j	c30 <vprintfmt+0x45c>
 c0c:	f5843783          	ld	a5,-168(s0)
 c10:	02000513          	li	a0,32
 c14:	000780e7          	jalr	a5
 c18:	fec42783          	lw	a5,-20(s0)
 c1c:	0017879b          	addiw	a5,a5,1
 c20:	fef42623          	sw	a5,-20(s0)
 c24:	fd842783          	lw	a5,-40(s0)
 c28:	fff7879b          	addiw	a5,a5,-1
 c2c:	fcf42c23          	sw	a5,-40(s0)
 c30:	fd842783          	lw	a5,-40(s0)
 c34:	0007879b          	sext.w	a5,a5
 c38:	fcf04ae3          	bgtz	a5,c0c <vprintfmt+0x438>
 c3c:	fa644783          	lbu	a5,-90(s0)
 c40:	0ff7f793          	zext.b	a5,a5
 c44:	04078463          	beqz	a5,c8c <vprintfmt+0x4b8>
 c48:	f5843783          	ld	a5,-168(s0)
 c4c:	03000513          	li	a0,48
 c50:	000780e7          	jalr	a5
 c54:	f5043783          	ld	a5,-176(s0)
 c58:	0007c783          	lbu	a5,0(a5)
 c5c:	00078713          	mv	a4,a5
 c60:	05800793          	li	a5,88
 c64:	00f71663          	bne	a4,a5,c70 <vprintfmt+0x49c>
 c68:	05800793          	li	a5,88
 c6c:	0080006f          	j	c74 <vprintfmt+0x4a0>
 c70:	07800793          	li	a5,120
 c74:	f5843703          	ld	a4,-168(s0)
 c78:	00078513          	mv	a0,a5
 c7c:	000700e7          	jalr	a4
 c80:	fec42783          	lw	a5,-20(s0)
 c84:	0027879b          	addiw	a5,a5,2
 c88:	fef42623          	sw	a5,-20(s0)
 c8c:	fdc42783          	lw	a5,-36(s0)
 c90:	fcf42a23          	sw	a5,-44(s0)
 c94:	0280006f          	j	cbc <vprintfmt+0x4e8>
 c98:	f5843783          	ld	a5,-168(s0)
 c9c:	03000513          	li	a0,48
 ca0:	000780e7          	jalr	a5
 ca4:	fec42783          	lw	a5,-20(s0)
 ca8:	0017879b          	addiw	a5,a5,1
 cac:	fef42623          	sw	a5,-20(s0)
 cb0:	fd442783          	lw	a5,-44(s0)
 cb4:	0017879b          	addiw	a5,a5,1
 cb8:	fcf42a23          	sw	a5,-44(s0)
 cbc:	f8c42703          	lw	a4,-116(s0)
 cc0:	fd442783          	lw	a5,-44(s0)
 cc4:	0007879b          	sext.w	a5,a5
 cc8:	fce7c8e3          	blt	a5,a4,c98 <vprintfmt+0x4c4>
 ccc:	fdc42783          	lw	a5,-36(s0)
 cd0:	fff7879b          	addiw	a5,a5,-1
 cd4:	fcf42823          	sw	a5,-48(s0)
 cd8:	03c0006f          	j	d14 <vprintfmt+0x540>
 cdc:	fd042783          	lw	a5,-48(s0)
 ce0:	ff078793          	addi	a5,a5,-16
 ce4:	008787b3          	add	a5,a5,s0
 ce8:	f807c783          	lbu	a5,-128(a5)
 cec:	0007871b          	sext.w	a4,a5
 cf0:	f5843783          	ld	a5,-168(s0)
 cf4:	00070513          	mv	a0,a4
 cf8:	000780e7          	jalr	a5
 cfc:	fec42783          	lw	a5,-20(s0)
 d00:	0017879b          	addiw	a5,a5,1
 d04:	fef42623          	sw	a5,-20(s0)
 d08:	fd042783          	lw	a5,-48(s0)
 d0c:	fff7879b          	addiw	a5,a5,-1
 d10:	fcf42823          	sw	a5,-48(s0)
 d14:	fd042783          	lw	a5,-48(s0)
 d18:	0007879b          	sext.w	a5,a5
 d1c:	fc07d0e3          	bgez	a5,cdc <vprintfmt+0x508>
 d20:	f8040023          	sb	zero,-128(s0)
 d24:	2700006f          	j	f94 <vprintfmt+0x7c0>
 d28:	f5043783          	ld	a5,-176(s0)
 d2c:	0007c783          	lbu	a5,0(a5)
 d30:	00078713          	mv	a4,a5
 d34:	06400793          	li	a5,100
 d38:	02f70663          	beq	a4,a5,d64 <vprintfmt+0x590>
 d3c:	f5043783          	ld	a5,-176(s0)
 d40:	0007c783          	lbu	a5,0(a5)
 d44:	00078713          	mv	a4,a5
 d48:	06900793          	li	a5,105
 d4c:	00f70c63          	beq	a4,a5,d64 <vprintfmt+0x590>
 d50:	f5043783          	ld	a5,-176(s0)
 d54:	0007c783          	lbu	a5,0(a5)
 d58:	00078713          	mv	a4,a5
 d5c:	07500793          	li	a5,117
 d60:	08f71063          	bne	a4,a5,de0 <vprintfmt+0x60c>
 d64:	f8144783          	lbu	a5,-127(s0)
 d68:	00078c63          	beqz	a5,d80 <vprintfmt+0x5ac>
 d6c:	f4843783          	ld	a5,-184(s0)
 d70:	00878713          	addi	a4,a5,8
 d74:	f4e43423          	sd	a4,-184(s0)
 d78:	0007b783          	ld	a5,0(a5)
 d7c:	0140006f          	j	d90 <vprintfmt+0x5bc>
 d80:	f4843783          	ld	a5,-184(s0)
 d84:	00878713          	addi	a4,a5,8
 d88:	f4e43423          	sd	a4,-184(s0)
 d8c:	0007a783          	lw	a5,0(a5)
 d90:	faf43423          	sd	a5,-88(s0)
 d94:	fa843583          	ld	a1,-88(s0)
 d98:	f5043783          	ld	a5,-176(s0)
 d9c:	0007c783          	lbu	a5,0(a5)
 da0:	0007871b          	sext.w	a4,a5
 da4:	07500793          	li	a5,117
 da8:	40f707b3          	sub	a5,a4,a5
 dac:	00f037b3          	snez	a5,a5
 db0:	0ff7f793          	zext.b	a5,a5
 db4:	f8040713          	addi	a4,s0,-128
 db8:	00070693          	mv	a3,a4
 dbc:	00078613          	mv	a2,a5
 dc0:	f5843503          	ld	a0,-168(s0)
 dc4:	f08ff0ef          	jal	4cc <print_dec_int>
 dc8:	00050793          	mv	a5,a0
 dcc:	fec42703          	lw	a4,-20(s0)
 dd0:	00f707bb          	addw	a5,a4,a5
 dd4:	fef42623          	sw	a5,-20(s0)
 dd8:	f8040023          	sb	zero,-128(s0)
 ddc:	1b80006f          	j	f94 <vprintfmt+0x7c0>
 de0:	f5043783          	ld	a5,-176(s0)
 de4:	0007c783          	lbu	a5,0(a5)
 de8:	00078713          	mv	a4,a5
 dec:	06e00793          	li	a5,110
 df0:	04f71c63          	bne	a4,a5,e48 <vprintfmt+0x674>
 df4:	f8144783          	lbu	a5,-127(s0)
 df8:	02078463          	beqz	a5,e20 <vprintfmt+0x64c>
 dfc:	f4843783          	ld	a5,-184(s0)
 e00:	00878713          	addi	a4,a5,8
 e04:	f4e43423          	sd	a4,-184(s0)
 e08:	0007b783          	ld	a5,0(a5)
 e0c:	faf43823          	sd	a5,-80(s0)
 e10:	fec42703          	lw	a4,-20(s0)
 e14:	fb043783          	ld	a5,-80(s0)
 e18:	00e7b023          	sd	a4,0(a5)
 e1c:	0240006f          	j	e40 <vprintfmt+0x66c>
 e20:	f4843783          	ld	a5,-184(s0)
 e24:	00878713          	addi	a4,a5,8
 e28:	f4e43423          	sd	a4,-184(s0)
 e2c:	0007b783          	ld	a5,0(a5)
 e30:	faf43c23          	sd	a5,-72(s0)
 e34:	fb843783          	ld	a5,-72(s0)
 e38:	fec42703          	lw	a4,-20(s0)
 e3c:	00e7a023          	sw	a4,0(a5)
 e40:	f8040023          	sb	zero,-128(s0)
 e44:	1500006f          	j	f94 <vprintfmt+0x7c0>
 e48:	f5043783          	ld	a5,-176(s0)
 e4c:	0007c783          	lbu	a5,0(a5)
 e50:	00078713          	mv	a4,a5
 e54:	07300793          	li	a5,115
 e58:	02f71e63          	bne	a4,a5,e94 <vprintfmt+0x6c0>
 e5c:	f4843783          	ld	a5,-184(s0)
 e60:	00878713          	addi	a4,a5,8
 e64:	f4e43423          	sd	a4,-184(s0)
 e68:	0007b783          	ld	a5,0(a5)
 e6c:	fcf43023          	sd	a5,-64(s0)
 e70:	fc043583          	ld	a1,-64(s0)
 e74:	f5843503          	ld	a0,-168(s0)
 e78:	dccff0ef          	jal	444 <puts_wo_nl>
 e7c:	00050793          	mv	a5,a0
 e80:	fec42703          	lw	a4,-20(s0)
 e84:	00f707bb          	addw	a5,a4,a5
 e88:	fef42623          	sw	a5,-20(s0)
 e8c:	f8040023          	sb	zero,-128(s0)
 e90:	1040006f          	j	f94 <vprintfmt+0x7c0>
 e94:	f5043783          	ld	a5,-176(s0)
 e98:	0007c783          	lbu	a5,0(a5)
 e9c:	00078713          	mv	a4,a5
 ea0:	06300793          	li	a5,99
 ea4:	02f71e63          	bne	a4,a5,ee0 <vprintfmt+0x70c>
 ea8:	f4843783          	ld	a5,-184(s0)
 eac:	00878713          	addi	a4,a5,8
 eb0:	f4e43423          	sd	a4,-184(s0)
 eb4:	0007a783          	lw	a5,0(a5)
 eb8:	fcf42623          	sw	a5,-52(s0)
 ebc:	fcc42703          	lw	a4,-52(s0)
 ec0:	f5843783          	ld	a5,-168(s0)
 ec4:	00070513          	mv	a0,a4
 ec8:	000780e7          	jalr	a5
 ecc:	fec42783          	lw	a5,-20(s0)
 ed0:	0017879b          	addiw	a5,a5,1
 ed4:	fef42623          	sw	a5,-20(s0)
 ed8:	f8040023          	sb	zero,-128(s0)
 edc:	0b80006f          	j	f94 <vprintfmt+0x7c0>
 ee0:	f5043783          	ld	a5,-176(s0)
 ee4:	0007c783          	lbu	a5,0(a5)
 ee8:	00078713          	mv	a4,a5
 eec:	02500793          	li	a5,37
 ef0:	02f71263          	bne	a4,a5,f14 <vprintfmt+0x740>
 ef4:	f5843783          	ld	a5,-168(s0)
 ef8:	02500513          	li	a0,37
 efc:	000780e7          	jalr	a5
 f00:	fec42783          	lw	a5,-20(s0)
 f04:	0017879b          	addiw	a5,a5,1
 f08:	fef42623          	sw	a5,-20(s0)
 f0c:	f8040023          	sb	zero,-128(s0)
 f10:	0840006f          	j	f94 <vprintfmt+0x7c0>
 f14:	f5043783          	ld	a5,-176(s0)
 f18:	0007c783          	lbu	a5,0(a5)
 f1c:	0007871b          	sext.w	a4,a5
 f20:	f5843783          	ld	a5,-168(s0)
 f24:	00070513          	mv	a0,a4
 f28:	000780e7          	jalr	a5
 f2c:	fec42783          	lw	a5,-20(s0)
 f30:	0017879b          	addiw	a5,a5,1
 f34:	fef42623          	sw	a5,-20(s0)
 f38:	f8040023          	sb	zero,-128(s0)
 f3c:	0580006f          	j	f94 <vprintfmt+0x7c0>
 f40:	f5043783          	ld	a5,-176(s0)
 f44:	0007c783          	lbu	a5,0(a5)
 f48:	00078713          	mv	a4,a5
 f4c:	02500793          	li	a5,37
 f50:	02f71063          	bne	a4,a5,f70 <vprintfmt+0x79c>
 f54:	f8043023          	sd	zero,-128(s0)
 f58:	f8043423          	sd	zero,-120(s0)
 f5c:	00100793          	li	a5,1
 f60:	f8f40023          	sb	a5,-128(s0)
 f64:	fff00793          	li	a5,-1
 f68:	f8f42623          	sw	a5,-116(s0)
 f6c:	0280006f          	j	f94 <vprintfmt+0x7c0>
 f70:	f5043783          	ld	a5,-176(s0)
 f74:	0007c783          	lbu	a5,0(a5)
 f78:	0007871b          	sext.w	a4,a5
 f7c:	f5843783          	ld	a5,-168(s0)
 f80:	00070513          	mv	a0,a4
 f84:	000780e7          	jalr	a5
 f88:	fec42783          	lw	a5,-20(s0)
 f8c:	0017879b          	addiw	a5,a5,1
 f90:	fef42623          	sw	a5,-20(s0)
 f94:	f5043783          	ld	a5,-176(s0)
 f98:	00178793          	addi	a5,a5,1
 f9c:	f4f43823          	sd	a5,-176(s0)
 fa0:	f5043783          	ld	a5,-176(s0)
 fa4:	0007c783          	lbu	a5,0(a5)
 fa8:	84079ce3          	bnez	a5,800 <vprintfmt+0x2c>
 fac:	fec42783          	lw	a5,-20(s0)
 fb0:	00078513          	mv	a0,a5
 fb4:	0b813083          	ld	ra,184(sp)
 fb8:	0b013403          	ld	s0,176(sp)
 fbc:	0c010113          	addi	sp,sp,192
 fc0:	00008067          	ret

Disassembly of section .text.printf:

0000000000000fc4 <printf>:
     fc4:	f8010113          	addi	sp,sp,-128
     fc8:	02113c23          	sd	ra,56(sp)
     fcc:	02813823          	sd	s0,48(sp)
     fd0:	04010413          	addi	s0,sp,64
     fd4:	fca43423          	sd	a0,-56(s0)
     fd8:	00b43423          	sd	a1,8(s0)
     fdc:	00c43823          	sd	a2,16(s0)
     fe0:	00d43c23          	sd	a3,24(s0)
     fe4:	02e43023          	sd	a4,32(s0)
     fe8:	02f43423          	sd	a5,40(s0)
     fec:	03043823          	sd	a6,48(s0)
     ff0:	03143c23          	sd	a7,56(s0)
     ff4:	fe042623          	sw	zero,-20(s0)
     ff8:	04040793          	addi	a5,s0,64
     ffc:	fcf43023          	sd	a5,-64(s0)
    1000:	fc043783          	ld	a5,-64(s0)
    1004:	fc878793          	addi	a5,a5,-56
    1008:	fcf43823          	sd	a5,-48(s0)
    100c:	fd043783          	ld	a5,-48(s0)
    1010:	00078613          	mv	a2,a5
    1014:	fc843583          	ld	a1,-56(s0)
    1018:	fffff517          	auipc	a0,0xfffff
    101c:	0f850513          	addi	a0,a0,248 # 110 <putc>
    1020:	fb4ff0ef          	jal	7d4 <vprintfmt>
    1024:	00050793          	mv	a5,a0
    1028:	fef42623          	sw	a5,-20(s0)
    102c:	00100793          	li	a5,1
    1030:	fef43023          	sd	a5,-32(s0)
    1034:	00000797          	auipc	a5,0x0
    1038:	2b478793          	addi	a5,a5,692 # 12e8 <tail>
    103c:	0007a783          	lw	a5,0(a5)
    1040:	0017871b          	addiw	a4,a5,1
    1044:	0007069b          	sext.w	a3,a4
    1048:	00000717          	auipc	a4,0x0
    104c:	2a070713          	addi	a4,a4,672 # 12e8 <tail>
    1050:	00d72023          	sw	a3,0(a4)
    1054:	00000717          	auipc	a4,0x0
    1058:	29c70713          	addi	a4,a4,668 # 12f0 <buffer>
    105c:	00f707b3          	add	a5,a4,a5
    1060:	00078023          	sb	zero,0(a5)
    1064:	00000797          	auipc	a5,0x0
    1068:	28478793          	addi	a5,a5,644 # 12e8 <tail>
    106c:	0007a603          	lw	a2,0(a5)
    1070:	fe043703          	ld	a4,-32(s0)
    1074:	00000697          	auipc	a3,0x0
    1078:	27c68693          	addi	a3,a3,636 # 12f0 <buffer>
    107c:	fd843783          	ld	a5,-40(s0)
    1080:	04000893          	li	a7,64
    1084:	00070513          	mv	a0,a4
    1088:	00068593          	mv	a1,a3
    108c:	00060613          	mv	a2,a2
    1090:	00000073          	ecall
    1094:	00050793          	mv	a5,a0
    1098:	fcf43c23          	sd	a5,-40(s0)
    109c:	00000797          	auipc	a5,0x0
    10a0:	24c78793          	addi	a5,a5,588 # 12e8 <tail>
    10a4:	0007a023          	sw	zero,0(a5)
    10a8:	fec42783          	lw	a5,-20(s0)
    10ac:	00078513          	mv	a0,a5
    10b0:	03813083          	ld	ra,56(sp)
    10b4:	03013403          	ld	s0,48(sp)
    10b8:	08010113          	addi	sp,sp,128
    10bc:	00008067          	ret
