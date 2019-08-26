;xxx1
; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   MASM汇编格式
;实验二
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 1500					; 计时器延迟计数,用于控制画框的速度
	 show_time equ 100                   ;控制展示时间

     org 0xa400					; 程序加载到100h，可用于生成COM
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs                   ; cs = 0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov ax,0B800h				; 文本窗口显存起始地址
	mov gs,ax					; GS = B800h
sss:
	mov ch,100
loop1:
	dec word[count]				; 递减计数变量,相当于--
	jnz loop1					; 不等于0：跳转;jump not zero
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay           ;此时count和dcount=0
	mov word[dcount],ddelay

      mov al,1                  ;al=1
      cmp al,byte[rdul]        ;a1-rdul=0，则zf=1 
	jz  DnRt                   ;zf=1,跳DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:                        ;右下运动
	inc word[x]   ;x++
	inc word[y]   ;y++
	mov bx,word[x]       ;bx=x
	mov ax,25          ;ax=25,y轴长
	sub ax,bx           ;ax=ax-bx
    jz  dr2ur            ;ax=0 jump dr2ur ,意思是右下撞到下面的墙了，转到左上方向
	mov bx,word[y]        ;bx=y
	mov ax,40            ;ax=80,x轴长
	sub ax,bx           ;ax=ax-bx
    jz  dr2dl            ;ax=0,jump dr2dl,意思是右下撞到右边的墙，方向转左下
	;mov cl,9Fh
	jmp show            ;不需变方向，去show
dr2ur:              ;右下to左上
      mov word[x],23      ;x=23
      mov byte[rdul],Up_Rt	;rdul=Up_Rt
	  ;mov cl,9Dh
      jmp show
dr2dl:
      mov word[y],38
      mov byte[rdul],Dn_Lt	
	  ;mov cl,99h
      jmp show

UpRt:                   ;右上运动
	dec word[x]          ;x--
	inc word[y]         ;y++
	mov bx,word[y]      ;bx=y
	mov ax,40           ;ax=80
	sub ax,bx           ;ax=ax-bx
      jz  ur2ul         ;ax=0,装右墙，右上变左上
	mov bx,word[x]      ;bx=x
	mov ax,0            ;ax=-1
	sub ax,bx           ;ax=ax-bx
      jz  ur2dr         ;ax=0,装上墙，右上变右下
	 ;mov cl,9Dh
	jmp show
ur2ul:
      mov word[y],38
      mov byte[rdul],Up_Lt	
	  ;mov cl,9Bh
      jmp show
ur2dr:
      mov word[x],2
      mov byte[rdul],Dn_Rt	
	  ;mov cl,9Fh
      jmp show

	
	
UpLt:
	dec word[x];x--
	dec word[y];y--
	mov bx,word[x];
	mov ax,0
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,19
	sub ax,bx
      jz  ul2ur
	  ;mov cl,9Bh
	jmp show

ul2dl:
      mov word[x],2
      mov byte[rdul],Dn_Lt	
	  ;mov cl,99h
      jmp show
ul2ur:
      mov word[y],21
      mov byte[rdul],Up_Rt	
	  ;mov cl,9Dh
      jmp show
	  
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,19
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	  ;mov cl,99h
	jmp show

dl2dr:
      mov word[y],21
      mov byte[rdul],Dn_Rt	
	  ;mov cl,9Fh
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
	  ;mov cl,9Bh
      jmp show
	
show:	
    xor ax,ax                 ; 计算显存地址，，异或，意为ax=0
    mov ax,word[x]            ;ax=x
	mov bx,80                   ;bx=80
	mul bx                      ;乘法指令，16位*16位，隐含被乘数ax，结果32位，高16位dx，低16位ax，dx-ax=ax*bx
	add ax,word[y]              ;ax=ax+y
	mov bx,2                    ;bx=2
	mul bx                      ;dx-ax=ax*bx
	mov bp,ax                   ;bp=ax.........此时bp=(80*x+y)*2=160x+2y
	;mov cl,9Fh
	mov ah,9Fh				;  0000：黑底、1111：亮白字（默认值为07h）
	cmp word[jishu], 0
	jz show0
	cmp word[jishu], 1
	jz show1
	cmp word[jishu], 2
	jz show2
	cmp word[jishu], 3
	jz show3
	cmp word[jishu], 4
	jz show4
	cmp word[jishu], 5
	jz show5
	cmp word[jishu], 6
	jz show6
	cmp word[jishu], 7
	jz show7
	
show0:
	mov al,byte[char1]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show1:
	mov al,byte[char2]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show2:
	mov al,byte[char3]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show3:
	mov al,byte[char4]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show4:
	mov al,byte[char1]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show5:
	mov al,byte[char5]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show6:
	mov al,byte[char6]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname
show7:
	mov al,byte[char6]			;  AL = 显示字符值（默认值为20h=空格符）
	jmp nname

nname:
	inc word[jishu]
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	cmp word[jishu], 8
	jz modd
	jmp jjj
	
modd:
	mov word[jishu], 0
	jmp jjj

jjj:
	dec ch
	sub ch,0
    jz  0x7c00
	jmp loop1
	
end:
    jmp $                   ; 停止画框，无限循环 
	
	

datadef:

	count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 1
    y    dw 20
    char1 db '1'
	char2 db '7'
	char3 db '3'
	char4 db '4'
	char5 db '0'
	char6 db '5'
	jishu dw 0