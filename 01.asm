INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
	 out1		 BYTE    "��J�r��S�G", 0
	 S           BYTE    100 DUP(?)
	 countS      SDWORD   0
	 out2        BYTE    "s1=",0
	 S1          BYTE    100 DUP(?)
	 out3        BYTE    "s2=",0
	 S2          BYTE    100 DUP(?)
	 dot         BYTE    ".",0
	 count       SDWORD  0                ;�аO��
	 LengthS     SDWORD  0

.code
main PROC
	call Clrscr ;�M���ù�
	mov edx , OFFSET out1 ;��X�r��S
	call WriteString
	mov edx,offset S
	mov ecx,(SIZEOF S)-1
	call readstring
	mov  LengthS,eax
	;call Crlf

	mov ecx,LengthS     ;��X�r��S����
	;sub ecx,1           ;�]�������r��Ÿ��A�G��1���j��n�]������
	mov esi, OFFSET dot ;��"."
	mov ebx,[esi]       ;�N"."��JEBX��

	
NotF:
	mov esi, OFFSET S   ;�}�l�@�Ӥ@�Ӥ��"365.25"
	add esi,countS      ;coutS�Ψӭp������ĴX��
	mov al,[esi]       ;���JEAC��
	.if (bl==al)        ;�NSTRING���C�Ӧr���P"."�����
		mov ecx,0         ;�NECX�k0
	   jmp Fbegin
    .endif
	mov esi, OFFSET S1   ;����Ƴ���offset
	add esi,countS       ;�[�W�L�O�ĴX��
	mov [esi],al        ;���JS1���T��m
	add countS,1         ;�[�L~
	loop NotF

	;mov eax,countS
	;call WriteInt
    


Fbegin:
	mov edx , OFFSET out2 ;��X�r��S
	call WriteString
	mov edx ,OFFSET S1 ;��X�޲��r����
	call WriteString
	call Crlf
	mov ecx,countS
	sub ecx,1
	;mov eax,ecx
	;call WriteInt
	;mov esi, OFFSET S   ;�}�l�@�Ӥ@�Ӥ��"365.25"
	;add esi, countS      ;coutS�Ψӭp������ĴX��
	;add esi,1

Float:
	mov esi, OFFSET S   ;�}�l�@�Ӥ@�Ӥ��"365.25"
	add esi, countS      ;coutS�Ψӭp������ĴX��
	add esi,1
	mov al,[esi]       
	mov esi, OFFSET S2   ;����Ƴ���offset
	add esi,count
	mov [esi],al
	add count,1
	add countS,1
	loop Float

	mov edx , OFFSET out3 ;��X�r��S
	call WriteString
	mov edx ,OFFSET S2 ;��X�޲��r����
	call WriteString
	call Crlf
	
	INVOKE ExitProcess , 0
main ENDP
END main