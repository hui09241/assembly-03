INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
	 out1		 BYTE    "輸入字串S：", 0
	 S           BYTE    100 DUP(?)
	 countS      SDWORD   0
	 out2        BYTE    "s1=",0
	 S1          BYTE    100 DUP(?)
	 out3        BYTE    "s2=",0
	 S2          BYTE    100 DUP(?)
	 dot         BYTE    ".",0
	 count       SDWORD  0                ;標記用
	 LengthS     SDWORD  0

.code
main PROC
	call Clrscr ;清除螢幕
	mov edx , OFFSET out1 ;輸出字串S
	call WriteString
	mov edx,offset S
	mov ecx,(SIZEOF S)-1
	call readstring
	mov  LengthS,eax
	;call Crlf

	mov ecx,LengthS     ;輸出字串S長度
	;sub ecx,1           ;因有結束字串符號，故扣1為迴圈要跑的次數
	mov esi, OFFSET dot ;放"."
	mov ebx,[esi]       ;將"."放入EBX中

	
NotF:
	mov esi, OFFSET S   ;開始一個一個比較"365.25"
	add esi,countS      ;coutS用來計算比較到第幾個
	mov al,[esi]       ;移入EAC中
	.if (bl==al)        ;將STRING中每個字元與"."做比較
		mov ecx,0         ;將ECX歸0
	   jmp Fbegin
    .endif
	mov esi, OFFSET S1   ;找到整數部分offset
	add esi,countS       ;加上他是第幾個
	mov [esi],al        ;移入S1正確位置
	add countS,1         ;加他~
	loop NotF

	;mov eax,countS
	;call WriteInt
    


Fbegin:
	mov edx , OFFSET out2 ;輸出字串S
	call WriteString
	mov edx ,OFFSET S1 ;輸出詭異字串整數
	call WriteString
	call Crlf
	mov ecx,countS
	sub ecx,1
	;mov eax,ecx
	;call WriteInt
	;mov esi, OFFSET S   ;開始一個一個比較"365.25"
	;add esi, countS      ;coutS用來計算比較到第幾個
	;add esi,1

Float:
	mov esi, OFFSET S   ;開始一個一個比較"365.25"
	add esi, countS      ;coutS用來計算比較到第幾個
	add esi,1
	mov al,[esi]       
	mov esi, OFFSET S2   ;找到整數部分offset
	add esi,count
	mov [esi],al
	add count,1
	add countS,1
	loop Float

	mov edx , OFFSET out3 ;輸出字串S
	call WriteString
	mov edx ,OFFSET S2 ;輸出詭異字串整數
	call WriteString
	call Crlf
	
	INVOKE ExitProcess , 0
main ENDP
END main