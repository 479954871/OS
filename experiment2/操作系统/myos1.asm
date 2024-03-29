;程序源代码（myos1.asm）
org  7c00h		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 0xa200
OffSetOfUserPrg2 equ 0xa400
OffSetOfUserPrg3 equ 0xa600
OffSetOfUserPrg4 equ 0xa800

Start:
	mov ax, 3
	int 10h
	
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Message		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
    mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
Start2:
	mov ah,0        ; 从键盘获取输入
	int 16H
	mov cl,al
	
	;mov	bp, Message		 ; BP=当前串的偏移地址
	;mov	ax, ds		 ; ES:BP = 串地址
	;mov	es, ax		 ; 置ES=DS
	;mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	;mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)

	mov ah,2                 ; 功能号
    mov al,1                 ;扇区数
    mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
    mov dh,0                 ;磁头号 ; 起始编号为0
    mov ch,0                 ;柱面号 ; 起始编号为0
	cmp cl,'1'
	je stone
	cmp cl,'2'
	je xxx1
	cmp cl,'3'
	je xxx2
	cmp cl,'4'
	je xxx3
	jmp sret

stone:

	mov bx,OffSetOfUserPrg1
	mov cl,2                 ;起始扇区号 ; 起始编号为1
	jmp LoadnEx
	
xxx1:
	mov bx,OffSetOfUserPrg2
	mov cl,3                 ;起始扇区号 ; 起始编号为1
	jmp LoadnEx
	
xxx2:
	mov bx,OffSetOfUserPrg3
	mov cl,4                 ;起始扇区号 ; 起始编号为1
	jmp LoadnEx
	
xxx3:
	mov bx,OffSetOfUserPrg4
	mov cl,5                 ;起始扇区号 ; 起始编号为1
	jmp LoadnEx
	
sret:
	jmp Start
	
LoadnEx:
     ;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域中
      jmp bx
AfterRun:
      jmp $                      ;无限循环


Message:
      db '                Press 1.stone,2.xxx1,3.xxx2,4.xxx3...by 17341055'
MessageLength  equ ($-Message)
times 510-($-$$) db 0
db 0x55,0xaa
