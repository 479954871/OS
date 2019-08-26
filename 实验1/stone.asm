; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.
;  ��Ӧ�� 2014/3
;   MASM����ʽ
;ʵ��һ
	

     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

     org 7c00h					; ������ص�100h������������COM
start:

	;xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
    mov ax,cs                   ; cs = 0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov cx,ax
	mov ax,0B800h				; �ı������Դ���ʼ��ַ
	mov gs,ax					; GS = B800h
	mov byte[char],'A'
	call DispStr
	
DispStr:
	mov ax,BootMessage
	mov bp,ax
	mov cx,len
	mov ax,01301h
	mov bx,000ah
	mov dl,0
	int 10h
	call loop1
	ret
	BootMessage: 
	db "                            17341055  Jiandong Huang"
	len equ $-BootMessage
	
loop1:
	dec word[count]				; �ݼ���������,�൱��--
	jnz loop1					; ������0����ת;jump not zero
	;mov word[count],delay
	dec word[dcount]				; �ݼ���������
      jnz loop1
	mov word[count],delay           ;��ʱcount��dcount=0
	mov word[dcount],ddelay

      mov al,1                  ;al=1
      cmp al,byte[rdul]        ;a1-rdul=0����zf=1 
	jz  DnRt                   ;zf=1,��DnRt
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

DnRt:                        ;�����˶�
	inc word[x]   ;x++
	inc word[y]   ;y++
	mov bx,word[x]       ;bx=x
	mov ax,25          ;ax=25,y�᳤
	sub ax,bx           ;ax=ax-bx
    jz  dr2ur            ;ax=0 jump dr2ur ,��˼������ײ�������ǽ�ˣ�ת�����Ϸ���
	mov bx,word[y]        ;bx=y
	mov ax,80            ;ax=80,x�᳤
	sub ax,bx           ;ax=ax-bx
    jz  dr2dl            ;ax=0,jump dr2dl,��˼������ײ���ұߵ�ǽ������ת����
	mov cl,9Fh
	jmp show            ;����䷽��ȥshow
dr2ur:              ;����to����
      mov word[x],23      ;x=23
      mov byte[rdul],Up_Rt	;rdul=Up_Rt
	  mov cl,9Dh
      jmp show
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt	
	  mov cl,99h
      jmp show

UpRt:                   ;�����˶�
	dec word[x]          ;x--
	inc word[y]         ;y++
	mov bx,word[y]      ;bx=y
	mov ax,80           ;ax=80
	sub ax,bx           ;ax=ax-bx
      jz  ur2ul         ;ax=0,װ��ǽ�����ϱ�����
	mov bx,word[x]      ;bx=x
	mov ax,0            ;ax=-1
	sub ax,bx           ;ax=ax-bx
      jz  ur2dr         ;ax=0,װ��ǽ�����ϱ�����
	 mov cl,9Dh
	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
	  mov cl,9Bh
      jmp show
ur2dr:
      mov word[x],2
      mov byte[rdul],Dn_Rt	
	  mov cl,9Fh
      jmp show

	
	
UpLt:
	dec word[x];x--
	dec word[y];y--
	mov bx,word[x];
	mov ax,0
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  ul2ur
	  mov cl,9Bh
	jmp show

ul2dl:
      mov word[x],2
      mov byte[rdul],Dn_Lt	
	  mov cl,99h
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
	  mov cl,9Dh
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	  mov cl,99h
	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
	  mov cl,9Fh
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
	  mov cl,9Bh
      jmp show
	
show:	
mov al,1
      xor ax,ax                 ; �����Դ��ַ���������Ϊax=0
      mov ax,word[x]            ;ax=x
	mov bx,80                   ;bx=80
	mul bx                      ;�˷�ָ�16λ*16λ������������ax�����32λ����16λdx����16λax��dx-ax=ax*bx
	add ax,word[y]              ;ax=ax+y
	mov bx,2                    ;bx=2
	mul bx                      ;dx-ax=ax*bx
	mov bp,ax                   ;bp=ax.........��ʱbp=(80*x+y)*2=160x+2y
	mov ah,cl				;  0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	mov al,byte[char]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ     
	jmp loop1
	
end:
    jmp $                   ; ֹͣ��������ѭ�� 
	
	

datadef:

	count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; �������˶�
    x    dw 1
    y    dw 0
    char db 'A'


