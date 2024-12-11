
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	08c0006f          	j	10174 <main>

00000000000100ec <getpid>:
   100ec:	fe010113          	addi	sp,sp,-32
   100f0:	00813c23          	sd	s0,24(sp)
   100f4:	02010413          	addi	s0,sp,32
   100f8:	fe843783          	ld	a5,-24(s0)
   100fc:	0ac00893          	li	a7,172
   10100:	00000073          	ecall
   10104:	00050793          	mv	a5,a0
   10108:	fef43423          	sd	a5,-24(s0)
   1010c:	fe843783          	ld	a5,-24(s0)
   10110:	00078513          	mv	a0,a5
   10114:	01813403          	ld	s0,24(sp)
   10118:	02010113          	addi	sp,sp,32
   1011c:	00008067          	ret

0000000000010120 <wait>:
   10120:	fd010113          	addi	sp,sp,-48
   10124:	02813423          	sd	s0,40(sp)
   10128:	03010413          	addi	s0,sp,48
   1012c:	00050793          	mv	a5,a0
   10130:	fcf42e23          	sw	a5,-36(s0)
   10134:	fe042623          	sw	zero,-20(s0)
   10138:	0100006f          	j	10148 <wait+0x28>
   1013c:	fec42783          	lw	a5,-20(s0)
   10140:	0017879b          	addiw	a5,a5,1
   10144:	fef42623          	sw	a5,-20(s0)
   10148:	fec42783          	lw	a5,-20(s0)
   1014c:	00078713          	mv	a4,a5
   10150:	fdc42783          	lw	a5,-36(s0)
   10154:	0007071b          	sext.w	a4,a4
   10158:	0007879b          	sext.w	a5,a5
   1015c:	fef760e3          	bltu	a4,a5,1013c <wait+0x1c>
   10160:	00000013          	nop
   10164:	00000013          	nop
   10168:	02813403          	ld	s0,40(sp)
   1016c:	03010113          	addi	sp,sp,48
   10170:	00008067          	ret

0000000000010174 <main>:
   10174:	fe010113          	addi	sp,sp,-32
   10178:	00113c23          	sd	ra,24(sp)
   1017c:	00813823          	sd	s0,16(sp)
   10180:	02010413          	addi	s0,sp,32
   10184:	f69ff0ef          	jal	100ec <getpid>
   10188:	00050593          	mv	a1,a0
   1018c:	00010613          	mv	a2,sp
   10190:	00002797          	auipc	a5,0x2
   10194:	e7078793          	addi	a5,a5,-400 # 12000 <counter>
   10198:	0007a783          	lw	a5,0(a5)
   1019c:	0017879b          	addiw	a5,a5,1
   101a0:	0007871b          	sext.w	a4,a5
   101a4:	00002797          	auipc	a5,0x2
   101a8:	e5c78793          	addi	a5,a5,-420 # 12000 <counter>
   101ac:	00e7a023          	sw	a4,0(a5)
   101b0:	00002797          	auipc	a5,0x2
   101b4:	e5078793          	addi	a5,a5,-432 # 12000 <counter>
   101b8:	0007a783          	lw	a5,0(a5)
   101bc:	00078693          	mv	a3,a5
   101c0:	00001517          	auipc	a0,0x1
   101c4:	fe850513          	addi	a0,a0,-24 # 111a8 <printf+0xfc>
   101c8:	6e5000ef          	jal	110ac <printf>
   101cc:	fe042623          	sw	zero,-20(s0)
   101d0:	0100006f          	j	101e0 <main+0x6c>
   101d4:	fec42783          	lw	a5,-20(s0)
   101d8:	0017879b          	addiw	a5,a5,1
   101dc:	fef42623          	sw	a5,-20(s0)
   101e0:	fec42783          	lw	a5,-20(s0)
   101e4:	0007871b          	sext.w	a4,a5
   101e8:	500007b7          	lui	a5,0x50000
   101ec:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <__global_pointer$+0x4ffed7fe>
   101f0:	fee7f2e3          	bgeu	a5,a4,101d4 <main+0x60>
   101f4:	f91ff06f          	j	10184 <main+0x10>

00000000000101f8 <putc>:
   101f8:	fe010113          	addi	sp,sp,-32
   101fc:	00813c23          	sd	s0,24(sp)
   10200:	02010413          	addi	s0,sp,32
   10204:	00050793          	mv	a5,a0
   10208:	fef42623          	sw	a5,-20(s0)
   1020c:	00002797          	auipc	a5,0x2
   10210:	df878793          	addi	a5,a5,-520 # 12004 <tail>
   10214:	0007a783          	lw	a5,0(a5)
   10218:	0017871b          	addiw	a4,a5,1
   1021c:	0007069b          	sext.w	a3,a4
   10220:	00002717          	auipc	a4,0x2
   10224:	de470713          	addi	a4,a4,-540 # 12004 <tail>
   10228:	00d72023          	sw	a3,0(a4)
   1022c:	fec42703          	lw	a4,-20(s0)
   10230:	0ff77713          	zext.b	a4,a4
   10234:	00002697          	auipc	a3,0x2
   10238:	dd468693          	addi	a3,a3,-556 # 12008 <buffer>
   1023c:	00f687b3          	add	a5,a3,a5
   10240:	00e78023          	sb	a4,0(a5)
   10244:	fec42783          	lw	a5,-20(s0)
   10248:	0ff7f793          	zext.b	a5,a5
   1024c:	0007879b          	sext.w	a5,a5
   10250:	00078513          	mv	a0,a5
   10254:	01813403          	ld	s0,24(sp)
   10258:	02010113          	addi	sp,sp,32
   1025c:	00008067          	ret

0000000000010260 <isspace>:
   10260:	fe010113          	addi	sp,sp,-32
   10264:	00813c23          	sd	s0,24(sp)
   10268:	02010413          	addi	s0,sp,32
   1026c:	00050793          	mv	a5,a0
   10270:	fef42623          	sw	a5,-20(s0)
   10274:	fec42783          	lw	a5,-20(s0)
   10278:	0007871b          	sext.w	a4,a5
   1027c:	02000793          	li	a5,32
   10280:	02f70263          	beq	a4,a5,102a4 <isspace+0x44>
   10284:	fec42783          	lw	a5,-20(s0)
   10288:	0007871b          	sext.w	a4,a5
   1028c:	00800793          	li	a5,8
   10290:	00e7de63          	bge	a5,a4,102ac <isspace+0x4c>
   10294:	fec42783          	lw	a5,-20(s0)
   10298:	0007871b          	sext.w	a4,a5
   1029c:	00d00793          	li	a5,13
   102a0:	00e7c663          	blt	a5,a4,102ac <isspace+0x4c>
   102a4:	00100793          	li	a5,1
   102a8:	0080006f          	j	102b0 <isspace+0x50>
   102ac:	00000793          	li	a5,0
   102b0:	00078513          	mv	a0,a5
   102b4:	01813403          	ld	s0,24(sp)
   102b8:	02010113          	addi	sp,sp,32
   102bc:	00008067          	ret

00000000000102c0 <strtol>:
   102c0:	fb010113          	addi	sp,sp,-80
   102c4:	04113423          	sd	ra,72(sp)
   102c8:	04813023          	sd	s0,64(sp)
   102cc:	05010413          	addi	s0,sp,80
   102d0:	fca43423          	sd	a0,-56(s0)
   102d4:	fcb43023          	sd	a1,-64(s0)
   102d8:	00060793          	mv	a5,a2
   102dc:	faf42e23          	sw	a5,-68(s0)
   102e0:	fe043423          	sd	zero,-24(s0)
   102e4:	fe0403a3          	sb	zero,-25(s0)
   102e8:	fc843783          	ld	a5,-56(s0)
   102ec:	fcf43c23          	sd	a5,-40(s0)
   102f0:	0100006f          	j	10300 <strtol+0x40>
   102f4:	fd843783          	ld	a5,-40(s0)
   102f8:	00178793          	addi	a5,a5,1
   102fc:	fcf43c23          	sd	a5,-40(s0)
   10300:	fd843783          	ld	a5,-40(s0)
   10304:	0007c783          	lbu	a5,0(a5)
   10308:	0007879b          	sext.w	a5,a5
   1030c:	00078513          	mv	a0,a5
   10310:	f51ff0ef          	jal	10260 <isspace>
   10314:	00050793          	mv	a5,a0
   10318:	fc079ee3          	bnez	a5,102f4 <strtol+0x34>
   1031c:	fd843783          	ld	a5,-40(s0)
   10320:	0007c783          	lbu	a5,0(a5)
   10324:	00078713          	mv	a4,a5
   10328:	02d00793          	li	a5,45
   1032c:	00f71e63          	bne	a4,a5,10348 <strtol+0x88>
   10330:	00100793          	li	a5,1
   10334:	fef403a3          	sb	a5,-25(s0)
   10338:	fd843783          	ld	a5,-40(s0)
   1033c:	00178793          	addi	a5,a5,1
   10340:	fcf43c23          	sd	a5,-40(s0)
   10344:	0240006f          	j	10368 <strtol+0xa8>
   10348:	fd843783          	ld	a5,-40(s0)
   1034c:	0007c783          	lbu	a5,0(a5)
   10350:	00078713          	mv	a4,a5
   10354:	02b00793          	li	a5,43
   10358:	00f71863          	bne	a4,a5,10368 <strtol+0xa8>
   1035c:	fd843783          	ld	a5,-40(s0)
   10360:	00178793          	addi	a5,a5,1
   10364:	fcf43c23          	sd	a5,-40(s0)
   10368:	fbc42783          	lw	a5,-68(s0)
   1036c:	0007879b          	sext.w	a5,a5
   10370:	06079c63          	bnez	a5,103e8 <strtol+0x128>
   10374:	fd843783          	ld	a5,-40(s0)
   10378:	0007c783          	lbu	a5,0(a5)
   1037c:	00078713          	mv	a4,a5
   10380:	03000793          	li	a5,48
   10384:	04f71e63          	bne	a4,a5,103e0 <strtol+0x120>
   10388:	fd843783          	ld	a5,-40(s0)
   1038c:	00178793          	addi	a5,a5,1
   10390:	fcf43c23          	sd	a5,-40(s0)
   10394:	fd843783          	ld	a5,-40(s0)
   10398:	0007c783          	lbu	a5,0(a5)
   1039c:	00078713          	mv	a4,a5
   103a0:	07800793          	li	a5,120
   103a4:	00f70c63          	beq	a4,a5,103bc <strtol+0xfc>
   103a8:	fd843783          	ld	a5,-40(s0)
   103ac:	0007c783          	lbu	a5,0(a5)
   103b0:	00078713          	mv	a4,a5
   103b4:	05800793          	li	a5,88
   103b8:	00f71e63          	bne	a4,a5,103d4 <strtol+0x114>
   103bc:	01000793          	li	a5,16
   103c0:	faf42e23          	sw	a5,-68(s0)
   103c4:	fd843783          	ld	a5,-40(s0)
   103c8:	00178793          	addi	a5,a5,1
   103cc:	fcf43c23          	sd	a5,-40(s0)
   103d0:	0180006f          	j	103e8 <strtol+0x128>
   103d4:	00800793          	li	a5,8
   103d8:	faf42e23          	sw	a5,-68(s0)
   103dc:	00c0006f          	j	103e8 <strtol+0x128>
   103e0:	00a00793          	li	a5,10
   103e4:	faf42e23          	sw	a5,-68(s0)
   103e8:	fd843783          	ld	a5,-40(s0)
   103ec:	0007c783          	lbu	a5,0(a5)
   103f0:	00078713          	mv	a4,a5
   103f4:	02f00793          	li	a5,47
   103f8:	02e7f863          	bgeu	a5,a4,10428 <strtol+0x168>
   103fc:	fd843783          	ld	a5,-40(s0)
   10400:	0007c783          	lbu	a5,0(a5)
   10404:	00078713          	mv	a4,a5
   10408:	03900793          	li	a5,57
   1040c:	00e7ee63          	bltu	a5,a4,10428 <strtol+0x168>
   10410:	fd843783          	ld	a5,-40(s0)
   10414:	0007c783          	lbu	a5,0(a5)
   10418:	0007879b          	sext.w	a5,a5
   1041c:	fd07879b          	addiw	a5,a5,-48
   10420:	fcf42a23          	sw	a5,-44(s0)
   10424:	0800006f          	j	104a4 <strtol+0x1e4>
   10428:	fd843783          	ld	a5,-40(s0)
   1042c:	0007c783          	lbu	a5,0(a5)
   10430:	00078713          	mv	a4,a5
   10434:	06000793          	li	a5,96
   10438:	02e7f863          	bgeu	a5,a4,10468 <strtol+0x1a8>
   1043c:	fd843783          	ld	a5,-40(s0)
   10440:	0007c783          	lbu	a5,0(a5)
   10444:	00078713          	mv	a4,a5
   10448:	07a00793          	li	a5,122
   1044c:	00e7ee63          	bltu	a5,a4,10468 <strtol+0x1a8>
   10450:	fd843783          	ld	a5,-40(s0)
   10454:	0007c783          	lbu	a5,0(a5)
   10458:	0007879b          	sext.w	a5,a5
   1045c:	fa97879b          	addiw	a5,a5,-87
   10460:	fcf42a23          	sw	a5,-44(s0)
   10464:	0400006f          	j	104a4 <strtol+0x1e4>
   10468:	fd843783          	ld	a5,-40(s0)
   1046c:	0007c783          	lbu	a5,0(a5)
   10470:	00078713          	mv	a4,a5
   10474:	04000793          	li	a5,64
   10478:	06e7f863          	bgeu	a5,a4,104e8 <strtol+0x228>
   1047c:	fd843783          	ld	a5,-40(s0)
   10480:	0007c783          	lbu	a5,0(a5)
   10484:	00078713          	mv	a4,a5
   10488:	05a00793          	li	a5,90
   1048c:	04e7ee63          	bltu	a5,a4,104e8 <strtol+0x228>
   10490:	fd843783          	ld	a5,-40(s0)
   10494:	0007c783          	lbu	a5,0(a5)
   10498:	0007879b          	sext.w	a5,a5
   1049c:	fc97879b          	addiw	a5,a5,-55
   104a0:	fcf42a23          	sw	a5,-44(s0)
   104a4:	fd442783          	lw	a5,-44(s0)
   104a8:	00078713          	mv	a4,a5
   104ac:	fbc42783          	lw	a5,-68(s0)
   104b0:	0007071b          	sext.w	a4,a4
   104b4:	0007879b          	sext.w	a5,a5
   104b8:	02f75663          	bge	a4,a5,104e4 <strtol+0x224>
   104bc:	fbc42703          	lw	a4,-68(s0)
   104c0:	fe843783          	ld	a5,-24(s0)
   104c4:	02f70733          	mul	a4,a4,a5
   104c8:	fd442783          	lw	a5,-44(s0)
   104cc:	00f707b3          	add	a5,a4,a5
   104d0:	fef43423          	sd	a5,-24(s0)
   104d4:	fd843783          	ld	a5,-40(s0)
   104d8:	00178793          	addi	a5,a5,1
   104dc:	fcf43c23          	sd	a5,-40(s0)
   104e0:	f09ff06f          	j	103e8 <strtol+0x128>
   104e4:	00000013          	nop
   104e8:	fc043783          	ld	a5,-64(s0)
   104ec:	00078863          	beqz	a5,104fc <strtol+0x23c>
   104f0:	fc043783          	ld	a5,-64(s0)
   104f4:	fd843703          	ld	a4,-40(s0)
   104f8:	00e7b023          	sd	a4,0(a5)
   104fc:	fe744783          	lbu	a5,-25(s0)
   10500:	0ff7f793          	zext.b	a5,a5
   10504:	00078863          	beqz	a5,10514 <strtol+0x254>
   10508:	fe843783          	ld	a5,-24(s0)
   1050c:	40f007b3          	neg	a5,a5
   10510:	0080006f          	j	10518 <strtol+0x258>
   10514:	fe843783          	ld	a5,-24(s0)
   10518:	00078513          	mv	a0,a5
   1051c:	04813083          	ld	ra,72(sp)
   10520:	04013403          	ld	s0,64(sp)
   10524:	05010113          	addi	sp,sp,80
   10528:	00008067          	ret

000000000001052c <puts_wo_nl>:
   1052c:	fd010113          	addi	sp,sp,-48
   10530:	02113423          	sd	ra,40(sp)
   10534:	02813023          	sd	s0,32(sp)
   10538:	03010413          	addi	s0,sp,48
   1053c:	fca43c23          	sd	a0,-40(s0)
   10540:	fcb43823          	sd	a1,-48(s0)
   10544:	fd043783          	ld	a5,-48(s0)
   10548:	00079863          	bnez	a5,10558 <puts_wo_nl+0x2c>
   1054c:	00001797          	auipc	a5,0x1
   10550:	c9478793          	addi	a5,a5,-876 # 111e0 <printf+0x134>
   10554:	fcf43823          	sd	a5,-48(s0)
   10558:	fd043783          	ld	a5,-48(s0)
   1055c:	fef43423          	sd	a5,-24(s0)
   10560:	0240006f          	j	10584 <puts_wo_nl+0x58>
   10564:	fe843783          	ld	a5,-24(s0)
   10568:	00178713          	addi	a4,a5,1
   1056c:	fee43423          	sd	a4,-24(s0)
   10570:	0007c783          	lbu	a5,0(a5)
   10574:	0007871b          	sext.w	a4,a5
   10578:	fd843783          	ld	a5,-40(s0)
   1057c:	00070513          	mv	a0,a4
   10580:	000780e7          	jalr	a5
   10584:	fe843783          	ld	a5,-24(s0)
   10588:	0007c783          	lbu	a5,0(a5)
   1058c:	fc079ce3          	bnez	a5,10564 <puts_wo_nl+0x38>
   10590:	fe843703          	ld	a4,-24(s0)
   10594:	fd043783          	ld	a5,-48(s0)
   10598:	40f707b3          	sub	a5,a4,a5
   1059c:	0007879b          	sext.w	a5,a5
   105a0:	00078513          	mv	a0,a5
   105a4:	02813083          	ld	ra,40(sp)
   105a8:	02013403          	ld	s0,32(sp)
   105ac:	03010113          	addi	sp,sp,48
   105b0:	00008067          	ret

00000000000105b4 <print_dec_int>:
   105b4:	f9010113          	addi	sp,sp,-112
   105b8:	06113423          	sd	ra,104(sp)
   105bc:	06813023          	sd	s0,96(sp)
   105c0:	07010413          	addi	s0,sp,112
   105c4:	faa43423          	sd	a0,-88(s0)
   105c8:	fab43023          	sd	a1,-96(s0)
   105cc:	00060793          	mv	a5,a2
   105d0:	f8d43823          	sd	a3,-112(s0)
   105d4:	f8f40fa3          	sb	a5,-97(s0)
   105d8:	f9f44783          	lbu	a5,-97(s0)
   105dc:	0ff7f793          	zext.b	a5,a5
   105e0:	02078663          	beqz	a5,1060c <print_dec_int+0x58>
   105e4:	fa043703          	ld	a4,-96(s0)
   105e8:	fff00793          	li	a5,-1
   105ec:	03f79793          	slli	a5,a5,0x3f
   105f0:	00f71e63          	bne	a4,a5,1060c <print_dec_int+0x58>
   105f4:	00001597          	auipc	a1,0x1
   105f8:	bf458593          	addi	a1,a1,-1036 # 111e8 <printf+0x13c>
   105fc:	fa843503          	ld	a0,-88(s0)
   10600:	f2dff0ef          	jal	1052c <puts_wo_nl>
   10604:	00050793          	mv	a5,a0
   10608:	2a00006f          	j	108a8 <print_dec_int+0x2f4>
   1060c:	f9043783          	ld	a5,-112(s0)
   10610:	00c7a783          	lw	a5,12(a5)
   10614:	00079a63          	bnez	a5,10628 <print_dec_int+0x74>
   10618:	fa043783          	ld	a5,-96(s0)
   1061c:	00079663          	bnez	a5,10628 <print_dec_int+0x74>
   10620:	00000793          	li	a5,0
   10624:	2840006f          	j	108a8 <print_dec_int+0x2f4>
   10628:	fe0407a3          	sb	zero,-17(s0)
   1062c:	f9f44783          	lbu	a5,-97(s0)
   10630:	0ff7f793          	zext.b	a5,a5
   10634:	02078063          	beqz	a5,10654 <print_dec_int+0xa0>
   10638:	fa043783          	ld	a5,-96(s0)
   1063c:	0007dc63          	bgez	a5,10654 <print_dec_int+0xa0>
   10640:	00100793          	li	a5,1
   10644:	fef407a3          	sb	a5,-17(s0)
   10648:	fa043783          	ld	a5,-96(s0)
   1064c:	40f007b3          	neg	a5,a5
   10650:	faf43023          	sd	a5,-96(s0)
   10654:	fe042423          	sw	zero,-24(s0)
   10658:	f9f44783          	lbu	a5,-97(s0)
   1065c:	0ff7f793          	zext.b	a5,a5
   10660:	02078863          	beqz	a5,10690 <print_dec_int+0xdc>
   10664:	fef44783          	lbu	a5,-17(s0)
   10668:	0ff7f793          	zext.b	a5,a5
   1066c:	00079e63          	bnez	a5,10688 <print_dec_int+0xd4>
   10670:	f9043783          	ld	a5,-112(s0)
   10674:	0057c783          	lbu	a5,5(a5)
   10678:	00079863          	bnez	a5,10688 <print_dec_int+0xd4>
   1067c:	f9043783          	ld	a5,-112(s0)
   10680:	0047c783          	lbu	a5,4(a5)
   10684:	00078663          	beqz	a5,10690 <print_dec_int+0xdc>
   10688:	00100793          	li	a5,1
   1068c:	0080006f          	j	10694 <print_dec_int+0xe0>
   10690:	00000793          	li	a5,0
   10694:	fcf40ba3          	sb	a5,-41(s0)
   10698:	fd744783          	lbu	a5,-41(s0)
   1069c:	0017f793          	andi	a5,a5,1
   106a0:	fcf40ba3          	sb	a5,-41(s0)
   106a4:	fa043703          	ld	a4,-96(s0)
   106a8:	00a00793          	li	a5,10
   106ac:	02f777b3          	remu	a5,a4,a5
   106b0:	0ff7f713          	zext.b	a4,a5
   106b4:	fe842783          	lw	a5,-24(s0)
   106b8:	0017869b          	addiw	a3,a5,1
   106bc:	fed42423          	sw	a3,-24(s0)
   106c0:	0307071b          	addiw	a4,a4,48
   106c4:	0ff77713          	zext.b	a4,a4
   106c8:	ff078793          	addi	a5,a5,-16
   106cc:	008787b3          	add	a5,a5,s0
   106d0:	fce78423          	sb	a4,-56(a5)
   106d4:	fa043703          	ld	a4,-96(s0)
   106d8:	00a00793          	li	a5,10
   106dc:	02f757b3          	divu	a5,a4,a5
   106e0:	faf43023          	sd	a5,-96(s0)
   106e4:	fa043783          	ld	a5,-96(s0)
   106e8:	fa079ee3          	bnez	a5,106a4 <print_dec_int+0xf0>
   106ec:	f9043783          	ld	a5,-112(s0)
   106f0:	00c7a783          	lw	a5,12(a5)
   106f4:	00078713          	mv	a4,a5
   106f8:	fff00793          	li	a5,-1
   106fc:	02f71063          	bne	a4,a5,1071c <print_dec_int+0x168>
   10700:	f9043783          	ld	a5,-112(s0)
   10704:	0037c783          	lbu	a5,3(a5)
   10708:	00078a63          	beqz	a5,1071c <print_dec_int+0x168>
   1070c:	f9043783          	ld	a5,-112(s0)
   10710:	0087a703          	lw	a4,8(a5)
   10714:	f9043783          	ld	a5,-112(s0)
   10718:	00e7a623          	sw	a4,12(a5)
   1071c:	fe042223          	sw	zero,-28(s0)
   10720:	f9043783          	ld	a5,-112(s0)
   10724:	0087a703          	lw	a4,8(a5)
   10728:	fe842783          	lw	a5,-24(s0)
   1072c:	fcf42823          	sw	a5,-48(s0)
   10730:	f9043783          	ld	a5,-112(s0)
   10734:	00c7a783          	lw	a5,12(a5)
   10738:	fcf42623          	sw	a5,-52(s0)
   1073c:	fd042783          	lw	a5,-48(s0)
   10740:	00078593          	mv	a1,a5
   10744:	fcc42783          	lw	a5,-52(s0)
   10748:	00078613          	mv	a2,a5
   1074c:	0006069b          	sext.w	a3,a2
   10750:	0005879b          	sext.w	a5,a1
   10754:	00f6d463          	bge	a3,a5,1075c <print_dec_int+0x1a8>
   10758:	00058613          	mv	a2,a1
   1075c:	0006079b          	sext.w	a5,a2
   10760:	40f707bb          	subw	a5,a4,a5
   10764:	0007871b          	sext.w	a4,a5
   10768:	fd744783          	lbu	a5,-41(s0)
   1076c:	0007879b          	sext.w	a5,a5
   10770:	40f707bb          	subw	a5,a4,a5
   10774:	fef42023          	sw	a5,-32(s0)
   10778:	0280006f          	j	107a0 <print_dec_int+0x1ec>
   1077c:	fa843783          	ld	a5,-88(s0)
   10780:	02000513          	li	a0,32
   10784:	000780e7          	jalr	a5
   10788:	fe442783          	lw	a5,-28(s0)
   1078c:	0017879b          	addiw	a5,a5,1
   10790:	fef42223          	sw	a5,-28(s0)
   10794:	fe042783          	lw	a5,-32(s0)
   10798:	fff7879b          	addiw	a5,a5,-1
   1079c:	fef42023          	sw	a5,-32(s0)
   107a0:	fe042783          	lw	a5,-32(s0)
   107a4:	0007879b          	sext.w	a5,a5
   107a8:	fcf04ae3          	bgtz	a5,1077c <print_dec_int+0x1c8>
   107ac:	fd744783          	lbu	a5,-41(s0)
   107b0:	0ff7f793          	zext.b	a5,a5
   107b4:	04078463          	beqz	a5,107fc <print_dec_int+0x248>
   107b8:	fef44783          	lbu	a5,-17(s0)
   107bc:	0ff7f793          	zext.b	a5,a5
   107c0:	00078663          	beqz	a5,107cc <print_dec_int+0x218>
   107c4:	02d00793          	li	a5,45
   107c8:	01c0006f          	j	107e4 <print_dec_int+0x230>
   107cc:	f9043783          	ld	a5,-112(s0)
   107d0:	0057c783          	lbu	a5,5(a5)
   107d4:	00078663          	beqz	a5,107e0 <print_dec_int+0x22c>
   107d8:	02b00793          	li	a5,43
   107dc:	0080006f          	j	107e4 <print_dec_int+0x230>
   107e0:	02000793          	li	a5,32
   107e4:	fa843703          	ld	a4,-88(s0)
   107e8:	00078513          	mv	a0,a5
   107ec:	000700e7          	jalr	a4
   107f0:	fe442783          	lw	a5,-28(s0)
   107f4:	0017879b          	addiw	a5,a5,1
   107f8:	fef42223          	sw	a5,-28(s0)
   107fc:	fe842783          	lw	a5,-24(s0)
   10800:	fcf42e23          	sw	a5,-36(s0)
   10804:	0280006f          	j	1082c <print_dec_int+0x278>
   10808:	fa843783          	ld	a5,-88(s0)
   1080c:	03000513          	li	a0,48
   10810:	000780e7          	jalr	a5
   10814:	fe442783          	lw	a5,-28(s0)
   10818:	0017879b          	addiw	a5,a5,1
   1081c:	fef42223          	sw	a5,-28(s0)
   10820:	fdc42783          	lw	a5,-36(s0)
   10824:	0017879b          	addiw	a5,a5,1
   10828:	fcf42e23          	sw	a5,-36(s0)
   1082c:	f9043783          	ld	a5,-112(s0)
   10830:	00c7a703          	lw	a4,12(a5)
   10834:	fd744783          	lbu	a5,-41(s0)
   10838:	0007879b          	sext.w	a5,a5
   1083c:	40f707bb          	subw	a5,a4,a5
   10840:	0007871b          	sext.w	a4,a5
   10844:	fdc42783          	lw	a5,-36(s0)
   10848:	0007879b          	sext.w	a5,a5
   1084c:	fae7cee3          	blt	a5,a4,10808 <print_dec_int+0x254>
   10850:	fe842783          	lw	a5,-24(s0)
   10854:	fff7879b          	addiw	a5,a5,-1
   10858:	fcf42c23          	sw	a5,-40(s0)
   1085c:	03c0006f          	j	10898 <print_dec_int+0x2e4>
   10860:	fd842783          	lw	a5,-40(s0)
   10864:	ff078793          	addi	a5,a5,-16
   10868:	008787b3          	add	a5,a5,s0
   1086c:	fc87c783          	lbu	a5,-56(a5)
   10870:	0007871b          	sext.w	a4,a5
   10874:	fa843783          	ld	a5,-88(s0)
   10878:	00070513          	mv	a0,a4
   1087c:	000780e7          	jalr	a5
   10880:	fe442783          	lw	a5,-28(s0)
   10884:	0017879b          	addiw	a5,a5,1
   10888:	fef42223          	sw	a5,-28(s0)
   1088c:	fd842783          	lw	a5,-40(s0)
   10890:	fff7879b          	addiw	a5,a5,-1
   10894:	fcf42c23          	sw	a5,-40(s0)
   10898:	fd842783          	lw	a5,-40(s0)
   1089c:	0007879b          	sext.w	a5,a5
   108a0:	fc07d0e3          	bgez	a5,10860 <print_dec_int+0x2ac>
   108a4:	fe442783          	lw	a5,-28(s0)
   108a8:	00078513          	mv	a0,a5
   108ac:	06813083          	ld	ra,104(sp)
   108b0:	06013403          	ld	s0,96(sp)
   108b4:	07010113          	addi	sp,sp,112
   108b8:	00008067          	ret

00000000000108bc <vprintfmt>:
   108bc:	f4010113          	addi	sp,sp,-192
   108c0:	0a113c23          	sd	ra,184(sp)
   108c4:	0a813823          	sd	s0,176(sp)
   108c8:	0c010413          	addi	s0,sp,192
   108cc:	f4a43c23          	sd	a0,-168(s0)
   108d0:	f4b43823          	sd	a1,-176(s0)
   108d4:	f4c43423          	sd	a2,-184(s0)
   108d8:	f8043023          	sd	zero,-128(s0)
   108dc:	f8043423          	sd	zero,-120(s0)
   108e0:	fe042623          	sw	zero,-20(s0)
   108e4:	7a40006f          	j	11088 <vprintfmt+0x7cc>
   108e8:	f8044783          	lbu	a5,-128(s0)
   108ec:	72078e63          	beqz	a5,11028 <vprintfmt+0x76c>
   108f0:	f5043783          	ld	a5,-176(s0)
   108f4:	0007c783          	lbu	a5,0(a5)
   108f8:	00078713          	mv	a4,a5
   108fc:	02300793          	li	a5,35
   10900:	00f71863          	bne	a4,a5,10910 <vprintfmt+0x54>
   10904:	00100793          	li	a5,1
   10908:	f8f40123          	sb	a5,-126(s0)
   1090c:	7700006f          	j	1107c <vprintfmt+0x7c0>
   10910:	f5043783          	ld	a5,-176(s0)
   10914:	0007c783          	lbu	a5,0(a5)
   10918:	00078713          	mv	a4,a5
   1091c:	03000793          	li	a5,48
   10920:	00f71863          	bne	a4,a5,10930 <vprintfmt+0x74>
   10924:	00100793          	li	a5,1
   10928:	f8f401a3          	sb	a5,-125(s0)
   1092c:	7500006f          	j	1107c <vprintfmt+0x7c0>
   10930:	f5043783          	ld	a5,-176(s0)
   10934:	0007c783          	lbu	a5,0(a5)
   10938:	00078713          	mv	a4,a5
   1093c:	06c00793          	li	a5,108
   10940:	04f70063          	beq	a4,a5,10980 <vprintfmt+0xc4>
   10944:	f5043783          	ld	a5,-176(s0)
   10948:	0007c783          	lbu	a5,0(a5)
   1094c:	00078713          	mv	a4,a5
   10950:	07a00793          	li	a5,122
   10954:	02f70663          	beq	a4,a5,10980 <vprintfmt+0xc4>
   10958:	f5043783          	ld	a5,-176(s0)
   1095c:	0007c783          	lbu	a5,0(a5)
   10960:	00078713          	mv	a4,a5
   10964:	07400793          	li	a5,116
   10968:	00f70c63          	beq	a4,a5,10980 <vprintfmt+0xc4>
   1096c:	f5043783          	ld	a5,-176(s0)
   10970:	0007c783          	lbu	a5,0(a5)
   10974:	00078713          	mv	a4,a5
   10978:	06a00793          	li	a5,106
   1097c:	00f71863          	bne	a4,a5,1098c <vprintfmt+0xd0>
   10980:	00100793          	li	a5,1
   10984:	f8f400a3          	sb	a5,-127(s0)
   10988:	6f40006f          	j	1107c <vprintfmt+0x7c0>
   1098c:	f5043783          	ld	a5,-176(s0)
   10990:	0007c783          	lbu	a5,0(a5)
   10994:	00078713          	mv	a4,a5
   10998:	02b00793          	li	a5,43
   1099c:	00f71863          	bne	a4,a5,109ac <vprintfmt+0xf0>
   109a0:	00100793          	li	a5,1
   109a4:	f8f402a3          	sb	a5,-123(s0)
   109a8:	6d40006f          	j	1107c <vprintfmt+0x7c0>
   109ac:	f5043783          	ld	a5,-176(s0)
   109b0:	0007c783          	lbu	a5,0(a5)
   109b4:	00078713          	mv	a4,a5
   109b8:	02000793          	li	a5,32
   109bc:	00f71863          	bne	a4,a5,109cc <vprintfmt+0x110>
   109c0:	00100793          	li	a5,1
   109c4:	f8f40223          	sb	a5,-124(s0)
   109c8:	6b40006f          	j	1107c <vprintfmt+0x7c0>
   109cc:	f5043783          	ld	a5,-176(s0)
   109d0:	0007c783          	lbu	a5,0(a5)
   109d4:	00078713          	mv	a4,a5
   109d8:	02a00793          	li	a5,42
   109dc:	00f71e63          	bne	a4,a5,109f8 <vprintfmt+0x13c>
   109e0:	f4843783          	ld	a5,-184(s0)
   109e4:	00878713          	addi	a4,a5,8
   109e8:	f4e43423          	sd	a4,-184(s0)
   109ec:	0007a783          	lw	a5,0(a5)
   109f0:	f8f42423          	sw	a5,-120(s0)
   109f4:	6880006f          	j	1107c <vprintfmt+0x7c0>
   109f8:	f5043783          	ld	a5,-176(s0)
   109fc:	0007c783          	lbu	a5,0(a5)
   10a00:	00078713          	mv	a4,a5
   10a04:	03000793          	li	a5,48
   10a08:	04e7f663          	bgeu	a5,a4,10a54 <vprintfmt+0x198>
   10a0c:	f5043783          	ld	a5,-176(s0)
   10a10:	0007c783          	lbu	a5,0(a5)
   10a14:	00078713          	mv	a4,a5
   10a18:	03900793          	li	a5,57
   10a1c:	02e7ec63          	bltu	a5,a4,10a54 <vprintfmt+0x198>
   10a20:	f5043783          	ld	a5,-176(s0)
   10a24:	f5040713          	addi	a4,s0,-176
   10a28:	00a00613          	li	a2,10
   10a2c:	00070593          	mv	a1,a4
   10a30:	00078513          	mv	a0,a5
   10a34:	88dff0ef          	jal	102c0 <strtol>
   10a38:	00050793          	mv	a5,a0
   10a3c:	0007879b          	sext.w	a5,a5
   10a40:	f8f42423          	sw	a5,-120(s0)
   10a44:	f5043783          	ld	a5,-176(s0)
   10a48:	fff78793          	addi	a5,a5,-1
   10a4c:	f4f43823          	sd	a5,-176(s0)
   10a50:	62c0006f          	j	1107c <vprintfmt+0x7c0>
   10a54:	f5043783          	ld	a5,-176(s0)
   10a58:	0007c783          	lbu	a5,0(a5)
   10a5c:	00078713          	mv	a4,a5
   10a60:	02e00793          	li	a5,46
   10a64:	06f71863          	bne	a4,a5,10ad4 <vprintfmt+0x218>
   10a68:	f5043783          	ld	a5,-176(s0)
   10a6c:	00178793          	addi	a5,a5,1
   10a70:	f4f43823          	sd	a5,-176(s0)
   10a74:	f5043783          	ld	a5,-176(s0)
   10a78:	0007c783          	lbu	a5,0(a5)
   10a7c:	00078713          	mv	a4,a5
   10a80:	02a00793          	li	a5,42
   10a84:	00f71e63          	bne	a4,a5,10aa0 <vprintfmt+0x1e4>
   10a88:	f4843783          	ld	a5,-184(s0)
   10a8c:	00878713          	addi	a4,a5,8
   10a90:	f4e43423          	sd	a4,-184(s0)
   10a94:	0007a783          	lw	a5,0(a5)
   10a98:	f8f42623          	sw	a5,-116(s0)
   10a9c:	5e00006f          	j	1107c <vprintfmt+0x7c0>
   10aa0:	f5043783          	ld	a5,-176(s0)
   10aa4:	f5040713          	addi	a4,s0,-176
   10aa8:	00a00613          	li	a2,10
   10aac:	00070593          	mv	a1,a4
   10ab0:	00078513          	mv	a0,a5
   10ab4:	80dff0ef          	jal	102c0 <strtol>
   10ab8:	00050793          	mv	a5,a0
   10abc:	0007879b          	sext.w	a5,a5
   10ac0:	f8f42623          	sw	a5,-116(s0)
   10ac4:	f5043783          	ld	a5,-176(s0)
   10ac8:	fff78793          	addi	a5,a5,-1
   10acc:	f4f43823          	sd	a5,-176(s0)
   10ad0:	5ac0006f          	j	1107c <vprintfmt+0x7c0>
   10ad4:	f5043783          	ld	a5,-176(s0)
   10ad8:	0007c783          	lbu	a5,0(a5)
   10adc:	00078713          	mv	a4,a5
   10ae0:	07800793          	li	a5,120
   10ae4:	02f70663          	beq	a4,a5,10b10 <vprintfmt+0x254>
   10ae8:	f5043783          	ld	a5,-176(s0)
   10aec:	0007c783          	lbu	a5,0(a5)
   10af0:	00078713          	mv	a4,a5
   10af4:	05800793          	li	a5,88
   10af8:	00f70c63          	beq	a4,a5,10b10 <vprintfmt+0x254>
   10afc:	f5043783          	ld	a5,-176(s0)
   10b00:	0007c783          	lbu	a5,0(a5)
   10b04:	00078713          	mv	a4,a5
   10b08:	07000793          	li	a5,112
   10b0c:	30f71263          	bne	a4,a5,10e10 <vprintfmt+0x554>
   10b10:	f5043783          	ld	a5,-176(s0)
   10b14:	0007c783          	lbu	a5,0(a5)
   10b18:	00078713          	mv	a4,a5
   10b1c:	07000793          	li	a5,112
   10b20:	00f70663          	beq	a4,a5,10b2c <vprintfmt+0x270>
   10b24:	f8144783          	lbu	a5,-127(s0)
   10b28:	00078663          	beqz	a5,10b34 <vprintfmt+0x278>
   10b2c:	00100793          	li	a5,1
   10b30:	0080006f          	j	10b38 <vprintfmt+0x27c>
   10b34:	00000793          	li	a5,0
   10b38:	faf403a3          	sb	a5,-89(s0)
   10b3c:	fa744783          	lbu	a5,-89(s0)
   10b40:	0017f793          	andi	a5,a5,1
   10b44:	faf403a3          	sb	a5,-89(s0)
   10b48:	fa744783          	lbu	a5,-89(s0)
   10b4c:	0ff7f793          	zext.b	a5,a5
   10b50:	00078c63          	beqz	a5,10b68 <vprintfmt+0x2ac>
   10b54:	f4843783          	ld	a5,-184(s0)
   10b58:	00878713          	addi	a4,a5,8
   10b5c:	f4e43423          	sd	a4,-184(s0)
   10b60:	0007b783          	ld	a5,0(a5)
   10b64:	01c0006f          	j	10b80 <vprintfmt+0x2c4>
   10b68:	f4843783          	ld	a5,-184(s0)
   10b6c:	00878713          	addi	a4,a5,8
   10b70:	f4e43423          	sd	a4,-184(s0)
   10b74:	0007a783          	lw	a5,0(a5)
   10b78:	02079793          	slli	a5,a5,0x20
   10b7c:	0207d793          	srli	a5,a5,0x20
   10b80:	fef43023          	sd	a5,-32(s0)
   10b84:	f8c42783          	lw	a5,-116(s0)
   10b88:	02079463          	bnez	a5,10bb0 <vprintfmt+0x2f4>
   10b8c:	fe043783          	ld	a5,-32(s0)
   10b90:	02079063          	bnez	a5,10bb0 <vprintfmt+0x2f4>
   10b94:	f5043783          	ld	a5,-176(s0)
   10b98:	0007c783          	lbu	a5,0(a5)
   10b9c:	00078713          	mv	a4,a5
   10ba0:	07000793          	li	a5,112
   10ba4:	00f70663          	beq	a4,a5,10bb0 <vprintfmt+0x2f4>
   10ba8:	f8040023          	sb	zero,-128(s0)
   10bac:	4d00006f          	j	1107c <vprintfmt+0x7c0>
   10bb0:	f5043783          	ld	a5,-176(s0)
   10bb4:	0007c783          	lbu	a5,0(a5)
   10bb8:	00078713          	mv	a4,a5
   10bbc:	07000793          	li	a5,112
   10bc0:	00f70a63          	beq	a4,a5,10bd4 <vprintfmt+0x318>
   10bc4:	f8244783          	lbu	a5,-126(s0)
   10bc8:	00078a63          	beqz	a5,10bdc <vprintfmt+0x320>
   10bcc:	fe043783          	ld	a5,-32(s0)
   10bd0:	00078663          	beqz	a5,10bdc <vprintfmt+0x320>
   10bd4:	00100793          	li	a5,1
   10bd8:	0080006f          	j	10be0 <vprintfmt+0x324>
   10bdc:	00000793          	li	a5,0
   10be0:	faf40323          	sb	a5,-90(s0)
   10be4:	fa644783          	lbu	a5,-90(s0)
   10be8:	0017f793          	andi	a5,a5,1
   10bec:	faf40323          	sb	a5,-90(s0)
   10bf0:	fc042e23          	sw	zero,-36(s0)
   10bf4:	f5043783          	ld	a5,-176(s0)
   10bf8:	0007c783          	lbu	a5,0(a5)
   10bfc:	00078713          	mv	a4,a5
   10c00:	05800793          	li	a5,88
   10c04:	00f71863          	bne	a4,a5,10c14 <vprintfmt+0x358>
   10c08:	00000797          	auipc	a5,0x0
   10c0c:	5f878793          	addi	a5,a5,1528 # 11200 <upperxdigits.1>
   10c10:	00c0006f          	j	10c1c <vprintfmt+0x360>
   10c14:	00000797          	auipc	a5,0x0
   10c18:	60478793          	addi	a5,a5,1540 # 11218 <lowerxdigits.0>
   10c1c:	f8f43c23          	sd	a5,-104(s0)
   10c20:	fe043783          	ld	a5,-32(s0)
   10c24:	00f7f793          	andi	a5,a5,15
   10c28:	f9843703          	ld	a4,-104(s0)
   10c2c:	00f70733          	add	a4,a4,a5
   10c30:	fdc42783          	lw	a5,-36(s0)
   10c34:	0017869b          	addiw	a3,a5,1
   10c38:	fcd42e23          	sw	a3,-36(s0)
   10c3c:	00074703          	lbu	a4,0(a4)
   10c40:	ff078793          	addi	a5,a5,-16
   10c44:	008787b3          	add	a5,a5,s0
   10c48:	f8e78023          	sb	a4,-128(a5)
   10c4c:	fe043783          	ld	a5,-32(s0)
   10c50:	0047d793          	srli	a5,a5,0x4
   10c54:	fef43023          	sd	a5,-32(s0)
   10c58:	fe043783          	ld	a5,-32(s0)
   10c5c:	fc0792e3          	bnez	a5,10c20 <vprintfmt+0x364>
   10c60:	f8c42783          	lw	a5,-116(s0)
   10c64:	00078713          	mv	a4,a5
   10c68:	fff00793          	li	a5,-1
   10c6c:	02f71663          	bne	a4,a5,10c98 <vprintfmt+0x3dc>
   10c70:	f8344783          	lbu	a5,-125(s0)
   10c74:	02078263          	beqz	a5,10c98 <vprintfmt+0x3dc>
   10c78:	f8842703          	lw	a4,-120(s0)
   10c7c:	fa644783          	lbu	a5,-90(s0)
   10c80:	0007879b          	sext.w	a5,a5
   10c84:	0017979b          	slliw	a5,a5,0x1
   10c88:	0007879b          	sext.w	a5,a5
   10c8c:	40f707bb          	subw	a5,a4,a5
   10c90:	0007879b          	sext.w	a5,a5
   10c94:	f8f42623          	sw	a5,-116(s0)
   10c98:	f8842703          	lw	a4,-120(s0)
   10c9c:	fa644783          	lbu	a5,-90(s0)
   10ca0:	0007879b          	sext.w	a5,a5
   10ca4:	0017979b          	slliw	a5,a5,0x1
   10ca8:	0007879b          	sext.w	a5,a5
   10cac:	40f707bb          	subw	a5,a4,a5
   10cb0:	0007871b          	sext.w	a4,a5
   10cb4:	fdc42783          	lw	a5,-36(s0)
   10cb8:	f8f42a23          	sw	a5,-108(s0)
   10cbc:	f8c42783          	lw	a5,-116(s0)
   10cc0:	f8f42823          	sw	a5,-112(s0)
   10cc4:	f9442783          	lw	a5,-108(s0)
   10cc8:	00078593          	mv	a1,a5
   10ccc:	f9042783          	lw	a5,-112(s0)
   10cd0:	00078613          	mv	a2,a5
   10cd4:	0006069b          	sext.w	a3,a2
   10cd8:	0005879b          	sext.w	a5,a1
   10cdc:	00f6d463          	bge	a3,a5,10ce4 <vprintfmt+0x428>
   10ce0:	00058613          	mv	a2,a1
   10ce4:	0006079b          	sext.w	a5,a2
   10ce8:	40f707bb          	subw	a5,a4,a5
   10cec:	fcf42c23          	sw	a5,-40(s0)
   10cf0:	0280006f          	j	10d18 <vprintfmt+0x45c>
   10cf4:	f5843783          	ld	a5,-168(s0)
   10cf8:	02000513          	li	a0,32
   10cfc:	000780e7          	jalr	a5
   10d00:	fec42783          	lw	a5,-20(s0)
   10d04:	0017879b          	addiw	a5,a5,1
   10d08:	fef42623          	sw	a5,-20(s0)
   10d0c:	fd842783          	lw	a5,-40(s0)
   10d10:	fff7879b          	addiw	a5,a5,-1
   10d14:	fcf42c23          	sw	a5,-40(s0)
   10d18:	fd842783          	lw	a5,-40(s0)
   10d1c:	0007879b          	sext.w	a5,a5
   10d20:	fcf04ae3          	bgtz	a5,10cf4 <vprintfmt+0x438>
   10d24:	fa644783          	lbu	a5,-90(s0)
   10d28:	0ff7f793          	zext.b	a5,a5
   10d2c:	04078463          	beqz	a5,10d74 <vprintfmt+0x4b8>
   10d30:	f5843783          	ld	a5,-168(s0)
   10d34:	03000513          	li	a0,48
   10d38:	000780e7          	jalr	a5
   10d3c:	f5043783          	ld	a5,-176(s0)
   10d40:	0007c783          	lbu	a5,0(a5)
   10d44:	00078713          	mv	a4,a5
   10d48:	05800793          	li	a5,88
   10d4c:	00f71663          	bne	a4,a5,10d58 <vprintfmt+0x49c>
   10d50:	05800793          	li	a5,88
   10d54:	0080006f          	j	10d5c <vprintfmt+0x4a0>
   10d58:	07800793          	li	a5,120
   10d5c:	f5843703          	ld	a4,-168(s0)
   10d60:	00078513          	mv	a0,a5
   10d64:	000700e7          	jalr	a4
   10d68:	fec42783          	lw	a5,-20(s0)
   10d6c:	0027879b          	addiw	a5,a5,2
   10d70:	fef42623          	sw	a5,-20(s0)
   10d74:	fdc42783          	lw	a5,-36(s0)
   10d78:	fcf42a23          	sw	a5,-44(s0)
   10d7c:	0280006f          	j	10da4 <vprintfmt+0x4e8>
   10d80:	f5843783          	ld	a5,-168(s0)
   10d84:	03000513          	li	a0,48
   10d88:	000780e7          	jalr	a5
   10d8c:	fec42783          	lw	a5,-20(s0)
   10d90:	0017879b          	addiw	a5,a5,1
   10d94:	fef42623          	sw	a5,-20(s0)
   10d98:	fd442783          	lw	a5,-44(s0)
   10d9c:	0017879b          	addiw	a5,a5,1
   10da0:	fcf42a23          	sw	a5,-44(s0)
   10da4:	f8c42703          	lw	a4,-116(s0)
   10da8:	fd442783          	lw	a5,-44(s0)
   10dac:	0007879b          	sext.w	a5,a5
   10db0:	fce7c8e3          	blt	a5,a4,10d80 <vprintfmt+0x4c4>
   10db4:	fdc42783          	lw	a5,-36(s0)
   10db8:	fff7879b          	addiw	a5,a5,-1
   10dbc:	fcf42823          	sw	a5,-48(s0)
   10dc0:	03c0006f          	j	10dfc <vprintfmt+0x540>
   10dc4:	fd042783          	lw	a5,-48(s0)
   10dc8:	ff078793          	addi	a5,a5,-16
   10dcc:	008787b3          	add	a5,a5,s0
   10dd0:	f807c783          	lbu	a5,-128(a5)
   10dd4:	0007871b          	sext.w	a4,a5
   10dd8:	f5843783          	ld	a5,-168(s0)
   10ddc:	00070513          	mv	a0,a4
   10de0:	000780e7          	jalr	a5
   10de4:	fec42783          	lw	a5,-20(s0)
   10de8:	0017879b          	addiw	a5,a5,1
   10dec:	fef42623          	sw	a5,-20(s0)
   10df0:	fd042783          	lw	a5,-48(s0)
   10df4:	fff7879b          	addiw	a5,a5,-1
   10df8:	fcf42823          	sw	a5,-48(s0)
   10dfc:	fd042783          	lw	a5,-48(s0)
   10e00:	0007879b          	sext.w	a5,a5
   10e04:	fc07d0e3          	bgez	a5,10dc4 <vprintfmt+0x508>
   10e08:	f8040023          	sb	zero,-128(s0)
   10e0c:	2700006f          	j	1107c <vprintfmt+0x7c0>
   10e10:	f5043783          	ld	a5,-176(s0)
   10e14:	0007c783          	lbu	a5,0(a5)
   10e18:	00078713          	mv	a4,a5
   10e1c:	06400793          	li	a5,100
   10e20:	02f70663          	beq	a4,a5,10e4c <vprintfmt+0x590>
   10e24:	f5043783          	ld	a5,-176(s0)
   10e28:	0007c783          	lbu	a5,0(a5)
   10e2c:	00078713          	mv	a4,a5
   10e30:	06900793          	li	a5,105
   10e34:	00f70c63          	beq	a4,a5,10e4c <vprintfmt+0x590>
   10e38:	f5043783          	ld	a5,-176(s0)
   10e3c:	0007c783          	lbu	a5,0(a5)
   10e40:	00078713          	mv	a4,a5
   10e44:	07500793          	li	a5,117
   10e48:	08f71063          	bne	a4,a5,10ec8 <vprintfmt+0x60c>
   10e4c:	f8144783          	lbu	a5,-127(s0)
   10e50:	00078c63          	beqz	a5,10e68 <vprintfmt+0x5ac>
   10e54:	f4843783          	ld	a5,-184(s0)
   10e58:	00878713          	addi	a4,a5,8
   10e5c:	f4e43423          	sd	a4,-184(s0)
   10e60:	0007b783          	ld	a5,0(a5)
   10e64:	0140006f          	j	10e78 <vprintfmt+0x5bc>
   10e68:	f4843783          	ld	a5,-184(s0)
   10e6c:	00878713          	addi	a4,a5,8
   10e70:	f4e43423          	sd	a4,-184(s0)
   10e74:	0007a783          	lw	a5,0(a5)
   10e78:	faf43423          	sd	a5,-88(s0)
   10e7c:	fa843583          	ld	a1,-88(s0)
   10e80:	f5043783          	ld	a5,-176(s0)
   10e84:	0007c783          	lbu	a5,0(a5)
   10e88:	0007871b          	sext.w	a4,a5
   10e8c:	07500793          	li	a5,117
   10e90:	40f707b3          	sub	a5,a4,a5
   10e94:	00f037b3          	snez	a5,a5
   10e98:	0ff7f793          	zext.b	a5,a5
   10e9c:	f8040713          	addi	a4,s0,-128
   10ea0:	00070693          	mv	a3,a4
   10ea4:	00078613          	mv	a2,a5
   10ea8:	f5843503          	ld	a0,-168(s0)
   10eac:	f08ff0ef          	jal	105b4 <print_dec_int>
   10eb0:	00050793          	mv	a5,a0
   10eb4:	fec42703          	lw	a4,-20(s0)
   10eb8:	00f707bb          	addw	a5,a4,a5
   10ebc:	fef42623          	sw	a5,-20(s0)
   10ec0:	f8040023          	sb	zero,-128(s0)
   10ec4:	1b80006f          	j	1107c <vprintfmt+0x7c0>
   10ec8:	f5043783          	ld	a5,-176(s0)
   10ecc:	0007c783          	lbu	a5,0(a5)
   10ed0:	00078713          	mv	a4,a5
   10ed4:	06e00793          	li	a5,110
   10ed8:	04f71c63          	bne	a4,a5,10f30 <vprintfmt+0x674>
   10edc:	f8144783          	lbu	a5,-127(s0)
   10ee0:	02078463          	beqz	a5,10f08 <vprintfmt+0x64c>
   10ee4:	f4843783          	ld	a5,-184(s0)
   10ee8:	00878713          	addi	a4,a5,8
   10eec:	f4e43423          	sd	a4,-184(s0)
   10ef0:	0007b783          	ld	a5,0(a5)
   10ef4:	faf43823          	sd	a5,-80(s0)
   10ef8:	fec42703          	lw	a4,-20(s0)
   10efc:	fb043783          	ld	a5,-80(s0)
   10f00:	00e7b023          	sd	a4,0(a5)
   10f04:	0240006f          	j	10f28 <vprintfmt+0x66c>
   10f08:	f4843783          	ld	a5,-184(s0)
   10f0c:	00878713          	addi	a4,a5,8
   10f10:	f4e43423          	sd	a4,-184(s0)
   10f14:	0007b783          	ld	a5,0(a5)
   10f18:	faf43c23          	sd	a5,-72(s0)
   10f1c:	fb843783          	ld	a5,-72(s0)
   10f20:	fec42703          	lw	a4,-20(s0)
   10f24:	00e7a023          	sw	a4,0(a5)
   10f28:	f8040023          	sb	zero,-128(s0)
   10f2c:	1500006f          	j	1107c <vprintfmt+0x7c0>
   10f30:	f5043783          	ld	a5,-176(s0)
   10f34:	0007c783          	lbu	a5,0(a5)
   10f38:	00078713          	mv	a4,a5
   10f3c:	07300793          	li	a5,115
   10f40:	02f71e63          	bne	a4,a5,10f7c <vprintfmt+0x6c0>
   10f44:	f4843783          	ld	a5,-184(s0)
   10f48:	00878713          	addi	a4,a5,8
   10f4c:	f4e43423          	sd	a4,-184(s0)
   10f50:	0007b783          	ld	a5,0(a5)
   10f54:	fcf43023          	sd	a5,-64(s0)
   10f58:	fc043583          	ld	a1,-64(s0)
   10f5c:	f5843503          	ld	a0,-168(s0)
   10f60:	dccff0ef          	jal	1052c <puts_wo_nl>
   10f64:	00050793          	mv	a5,a0
   10f68:	fec42703          	lw	a4,-20(s0)
   10f6c:	00f707bb          	addw	a5,a4,a5
   10f70:	fef42623          	sw	a5,-20(s0)
   10f74:	f8040023          	sb	zero,-128(s0)
   10f78:	1040006f          	j	1107c <vprintfmt+0x7c0>
   10f7c:	f5043783          	ld	a5,-176(s0)
   10f80:	0007c783          	lbu	a5,0(a5)
   10f84:	00078713          	mv	a4,a5
   10f88:	06300793          	li	a5,99
   10f8c:	02f71e63          	bne	a4,a5,10fc8 <vprintfmt+0x70c>
   10f90:	f4843783          	ld	a5,-184(s0)
   10f94:	00878713          	addi	a4,a5,8
   10f98:	f4e43423          	sd	a4,-184(s0)
   10f9c:	0007a783          	lw	a5,0(a5)
   10fa0:	fcf42623          	sw	a5,-52(s0)
   10fa4:	fcc42703          	lw	a4,-52(s0)
   10fa8:	f5843783          	ld	a5,-168(s0)
   10fac:	00070513          	mv	a0,a4
   10fb0:	000780e7          	jalr	a5
   10fb4:	fec42783          	lw	a5,-20(s0)
   10fb8:	0017879b          	addiw	a5,a5,1
   10fbc:	fef42623          	sw	a5,-20(s0)
   10fc0:	f8040023          	sb	zero,-128(s0)
   10fc4:	0b80006f          	j	1107c <vprintfmt+0x7c0>
   10fc8:	f5043783          	ld	a5,-176(s0)
   10fcc:	0007c783          	lbu	a5,0(a5)
   10fd0:	00078713          	mv	a4,a5
   10fd4:	02500793          	li	a5,37
   10fd8:	02f71263          	bne	a4,a5,10ffc <vprintfmt+0x740>
   10fdc:	f5843783          	ld	a5,-168(s0)
   10fe0:	02500513          	li	a0,37
   10fe4:	000780e7          	jalr	a5
   10fe8:	fec42783          	lw	a5,-20(s0)
   10fec:	0017879b          	addiw	a5,a5,1
   10ff0:	fef42623          	sw	a5,-20(s0)
   10ff4:	f8040023          	sb	zero,-128(s0)
   10ff8:	0840006f          	j	1107c <vprintfmt+0x7c0>
   10ffc:	f5043783          	ld	a5,-176(s0)
   11000:	0007c783          	lbu	a5,0(a5)
   11004:	0007871b          	sext.w	a4,a5
   11008:	f5843783          	ld	a5,-168(s0)
   1100c:	00070513          	mv	a0,a4
   11010:	000780e7          	jalr	a5
   11014:	fec42783          	lw	a5,-20(s0)
   11018:	0017879b          	addiw	a5,a5,1
   1101c:	fef42623          	sw	a5,-20(s0)
   11020:	f8040023          	sb	zero,-128(s0)
   11024:	0580006f          	j	1107c <vprintfmt+0x7c0>
   11028:	f5043783          	ld	a5,-176(s0)
   1102c:	0007c783          	lbu	a5,0(a5)
   11030:	00078713          	mv	a4,a5
   11034:	02500793          	li	a5,37
   11038:	02f71063          	bne	a4,a5,11058 <vprintfmt+0x79c>
   1103c:	f8043023          	sd	zero,-128(s0)
   11040:	f8043423          	sd	zero,-120(s0)
   11044:	00100793          	li	a5,1
   11048:	f8f40023          	sb	a5,-128(s0)
   1104c:	fff00793          	li	a5,-1
   11050:	f8f42623          	sw	a5,-116(s0)
   11054:	0280006f          	j	1107c <vprintfmt+0x7c0>
   11058:	f5043783          	ld	a5,-176(s0)
   1105c:	0007c783          	lbu	a5,0(a5)
   11060:	0007871b          	sext.w	a4,a5
   11064:	f5843783          	ld	a5,-168(s0)
   11068:	00070513          	mv	a0,a4
   1106c:	000780e7          	jalr	a5
   11070:	fec42783          	lw	a5,-20(s0)
   11074:	0017879b          	addiw	a5,a5,1
   11078:	fef42623          	sw	a5,-20(s0)
   1107c:	f5043783          	ld	a5,-176(s0)
   11080:	00178793          	addi	a5,a5,1
   11084:	f4f43823          	sd	a5,-176(s0)
   11088:	f5043783          	ld	a5,-176(s0)
   1108c:	0007c783          	lbu	a5,0(a5)
   11090:	84079ce3          	bnez	a5,108e8 <vprintfmt+0x2c>
   11094:	fec42783          	lw	a5,-20(s0)
   11098:	00078513          	mv	a0,a5
   1109c:	0b813083          	ld	ra,184(sp)
   110a0:	0b013403          	ld	s0,176(sp)
   110a4:	0c010113          	addi	sp,sp,192
   110a8:	00008067          	ret

00000000000110ac <printf>:
   110ac:	f8010113          	addi	sp,sp,-128
   110b0:	02113c23          	sd	ra,56(sp)
   110b4:	02813823          	sd	s0,48(sp)
   110b8:	04010413          	addi	s0,sp,64
   110bc:	fca43423          	sd	a0,-56(s0)
   110c0:	00b43423          	sd	a1,8(s0)
   110c4:	00c43823          	sd	a2,16(s0)
   110c8:	00d43c23          	sd	a3,24(s0)
   110cc:	02e43023          	sd	a4,32(s0)
   110d0:	02f43423          	sd	a5,40(s0)
   110d4:	03043823          	sd	a6,48(s0)
   110d8:	03143c23          	sd	a7,56(s0)
   110dc:	fe042623          	sw	zero,-20(s0)
   110e0:	04040793          	addi	a5,s0,64
   110e4:	fcf43023          	sd	a5,-64(s0)
   110e8:	fc043783          	ld	a5,-64(s0)
   110ec:	fc878793          	addi	a5,a5,-56
   110f0:	fcf43823          	sd	a5,-48(s0)
   110f4:	fd043783          	ld	a5,-48(s0)
   110f8:	00078613          	mv	a2,a5
   110fc:	fc843583          	ld	a1,-56(s0)
   11100:	fffff517          	auipc	a0,0xfffff
   11104:	0f850513          	addi	a0,a0,248 # 101f8 <putc>
   11108:	fb4ff0ef          	jal	108bc <vprintfmt>
   1110c:	00050793          	mv	a5,a0
   11110:	fef42623          	sw	a5,-20(s0)
   11114:	00100793          	li	a5,1
   11118:	fef43023          	sd	a5,-32(s0)
   1111c:	00001797          	auipc	a5,0x1
   11120:	ee878793          	addi	a5,a5,-280 # 12004 <tail>
   11124:	0007a783          	lw	a5,0(a5)
   11128:	0017871b          	addiw	a4,a5,1
   1112c:	0007069b          	sext.w	a3,a4
   11130:	00001717          	auipc	a4,0x1
   11134:	ed470713          	addi	a4,a4,-300 # 12004 <tail>
   11138:	00d72023          	sw	a3,0(a4)
   1113c:	00001717          	auipc	a4,0x1
   11140:	ecc70713          	addi	a4,a4,-308 # 12008 <buffer>
   11144:	00f707b3          	add	a5,a4,a5
   11148:	00078023          	sb	zero,0(a5)
   1114c:	00001797          	auipc	a5,0x1
   11150:	eb878793          	addi	a5,a5,-328 # 12004 <tail>
   11154:	0007a603          	lw	a2,0(a5)
   11158:	fe043703          	ld	a4,-32(s0)
   1115c:	00001697          	auipc	a3,0x1
   11160:	eac68693          	addi	a3,a3,-340 # 12008 <buffer>
   11164:	fd843783          	ld	a5,-40(s0)
   11168:	04000893          	li	a7,64
   1116c:	00070513          	mv	a0,a4
   11170:	00068593          	mv	a1,a3
   11174:	00060613          	mv	a2,a2
   11178:	00000073          	ecall
   1117c:	00050793          	mv	a5,a0
   11180:	fcf43c23          	sd	a5,-40(s0)
   11184:	00001797          	auipc	a5,0x1
   11188:	e8078793          	addi	a5,a5,-384 # 12004 <tail>
   1118c:	0007a023          	sw	zero,0(a5)
   11190:	fec42783          	lw	a5,-20(s0)
   11194:	00078513          	mv	a0,a5
   11198:	03813083          	ld	ra,56(sp)
   1119c:	03013403          	ld	s0,48(sp)
   111a0:	08010113          	addi	sp,sp,128
   111a4:	00008067          	ret
