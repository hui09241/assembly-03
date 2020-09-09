INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
GCD PROTO,x:SDWORD,y:SDWORD
.data
	 Out1 BYTE "請輸入數字: ",0
	 Out2 BYTE "輸出結果: ",0
	 A    SDWORD 0
	 B    SDWORD 0

.code
main PROC
	call   Clrscr      ;清除螢幕
Cycle:
    mov edx,OFFSET Out1
	call WriteString
	call Crlf
	call ReadInt
	mov A,eax

	mov edx,OFFSET Out1
	call WriteString
	call Crlf
	call ReadInt
	mov B,eax
	
	INVOKE GCD,A,B
	
	mov edx,OFFSET Out2
	call WriteString
	call Crlf
	call WriteInt
	call Crlf
	loop Cycle

	INVOKE ExitProcess , 0
main ENDP
GCD PROC USES edx ecx ebx,x:SDWORD,y:SDWORD
	
	mov eax,x
	cmp eax,0
	jl L1
	jge L2

L1:               ;做X絕對值
	mov eax,-1
	mov ebx,x
	mul ebx
	mov x,eax

L2:
	mov eax,y
	cmp eax,0
	jl L3
	jge L4

L3:              ;做Y絕對值
	mov eax,-1 
	mov ebx,y
	mul ebx
	mov y,eax

L4:	 mov ecx,y
	.while(ecx>0)
		mov edx,0
		mov eax,x
		cdq
		mov ebx,y
		idiv ebx
		mov eax,y
		mov x,eax
		mov y,edx
		mov ecx,edx
	.EndW

	mov eax, x
	ret 
GCD ENDP
END main