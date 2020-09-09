INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
	 out1		               BYTE    "請輸入被除數：", 0
	 out2		               BYTE    "請輸入除數：", 0
	 inputdividend             BYTE    1000 DUP(?)
	 inputdivisor			   BYTE    1000 DUP(?)
	 dot                       BYTE    ".",0
	 dotdividend               SDWORD  0                 ;被除數小數點後有幾位
	 dotdivisor                SDWORD  0                 ;除數小數點後有幾位
	 dotdividendfromstart      SDWORD  0                 ;被除數開頭到小數點的距離(不算小數點)
	 dotdivisorformstart       SDWORD  0                 ;除數開頭到小數點的距離(不算小數點)
	 tempfordividendecx        SDWORD  0                 ;存放入幾個字元進被除數
	 tempfordivisorecx         SDWORD  0                 ;存放入幾個字元進除數
	 tempdividend              BYTE    1000 DUP(?)
	 tempdivisor               BYTE    1000 DUP(?)
	 tempforinput              SDWORD  0  
	 tempforstring             SDWORD  0
	 howlongdividend           SDWORD  0                 ;去掉小數點後為幾位
	 howlongdivisor            SDWORD  0                 ;去掉小數點後為幾位
	 max                       SDWORD  0                 ;小數點後位數
	 dividend                  DWORD   0
	 divisor                   DWORD   0
	 boolean                   SDWORD  0                 ;用來看boolean值
	 quotient                  DWORD  0                 ;用來存放商數
	 remainder                 DWORD  0                 ;用來存放餘數
	 out3		               BYTE    "商數：", 0
	 out4		               BYTE    "餘數：", 0
	 remainder_adj             BYTE   1000 DUP(?)
	 remainder_adj_ans         BYTE   1000 DUP(?)
	 remainder_adj_ans_reverse BYTE   1000 DUP(?) 
	 temp                      SDWORD  0                 ;最後輸出
.code
main PROC
	call Clrscr ;清除螢幕
;--------------------------------------------------------------被除數作法
	mov edx , OFFSET out1                        ;提醒使用者輸入被除數
	call WriteString
	mov edx  , OFFSET inputdividend               ; 指定緩衝區 
    mov ecx  , ( SIZEOF inputdividend ) - 1       ; 扣掉null，指定最大讀取字串長度
    call ReadString                                ; 輸入字串

	mov  esi  , OFFSET dot                   ;放入dot
	mov  ebx  , [esi]

	mov  esi  , OFFSET inputdividend
	mov  tempfordividendecx,eax
	mov  ecx,eax
FindDotInDividend:                          ;找出 dot在被除數陣列第幾個
		mov  al ,[esi]
	.if(al==bl)
	    jmp FindoutDividend
	 .else
		add dotdividend,1
	.endif
		add esi,1
	loop FindDotInDividend
FindoutDividend:	
	mov eax,dotdividend               ;算小數點後還有幾位
	mov dotdividendfromstart,eax
	mov ebx,tempfordividendecx
	.if(eax<ebx)
		mov eax,tempfordividendecx
		sub eax,dotdividend
		sub eax,1
		mov dotdividend,eax
	.else
		mov dotdividend,0
	.endif

;----------------------------------------------------------------------除數作法
	mov edx , OFFSET out2                        ;提醒使用者輸入除數
	call WriteString
	mov edx  , OFFSET inputdivisor               ; 指定緩衝區 
    mov ecx  , ( SIZEOF inputdivisor ) - 1       ; 扣掉null，指定最大讀取字串長度
    call ReadString                              ; 輸入字串
	 
	mov  esi  , OFFSET dot                       ;放入dot
	mov  ebx  , [esi]
	
	mov  esi  , OFFSET inputdivisor
	mov  tempfordivisorecx,eax
	mov  ecx,eax
FindDotInDivisor:                                ;找出dot在除數陣列第幾個
		mov  al ,[esi]
	.if(al==bl)
	    jmp FindoutDivisor
	 .else
		add dotdivisor,1
	.endif
		add esi,1
	loop FindDotInDivisor
FindoutDivisor:	
	mov eax,dotdivisor    ;算小數點後還有幾位
	mov dotdivisorformstart,eax
	mov ebx,tempfordivisorecx
	.if(eax<ebx)
		mov eax,tempfordivisorecx
		sub eax,dotdivisor
		sub eax,1
		mov dotdivisor,eax
	.else
		mov dotdivisor,0
	.endif

;-----------------------------------------------------------------比較小數點後位數

		mov eax,dotdividend 
		mov edx,dotdivisor 
		mov  esi  , OFFSET dot                   ;放入dot  ;測試用
		mov  ebx  , [esi]
		.if(eax==edx) ;小數點後相同位數
		  mov  max,eax
		  mov  ecx,tempfordividendecx
LoopforcopyDividend_1:                                          ;copy被除數至temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;正確放入1104
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
		.else
			add tempforinput,1 
		.endif
			loop LoopforcopyDividend_1

			mov eax,tempforstring
			mov howlongdividend,eax

			mov  tempforinput,0
			mov  tempforstring,0
			mov  ecx,tempfordivisorecx 
LoopforcopyDivisor_1:                                           ;copy除數至temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;正確放入21
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
		.else
			add tempforinput,1 
		.endif
			loop LoopforcopyDivisor_1

			mov eax,tempforstring
			mov howlongdivisor,eax

		  ;mov edx , OFFSET tempdividend                        ;測試用
		  ;call WriteString
		  ;call crlf
		 ; mov edx , OFFSET tempdivisor                        ;測試用
		  ;call WriteString

		.elseif(eax>edx) ;被除數的小數點後位數比較多
		    mov  max,eax
			mov  ecx,tempfordividendecx
LoopforcopyDividend_2:                                          ;copy被除數至temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;正確放入1104
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
		.else
			add tempforinput,1 
		.endif
			loop LoopforcopyDividend_2	

			mov eax,tempforstring
			mov howlongdividend,eax

			mov  tempforinput,0
			mov  tempforstring,0
			mov  ecx,tempfordivisorecx 
LoopforcopyDivisor_2:                                           ;copy除數至temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;正確放入21
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
		.else
			add tempforinput,1 
		.endif
			loop LoopforcopyDivisor_2

			mov ecx,dotdividend
			sub ecx,dotdivisor 
addmorezero_2:
			mov  esi  , OFFSET tempdivisor ;正確放入21
			add  esi , tempforstring
			mov  eax , 30h
			mov  [esi],eax
			add tempforstring,1
			loop addmorezero_2

			mov eax,tempforstring
			mov howlongdivisor,eax

			;mov edx , OFFSET tempdividend                        ;測試用
		    ;call WriteString
		   ; call crlf
		   ; mov edx , OFFSET tempdivisor                        ;測試用
		    ;call WriteString
			
		.elseif(edx>eax) ;除數的小數點後位數比較多
		    mov  max,edx
		    mov  ecx,tempfordivisorecx 
LoopforcopyDivisor_3:                                           ;copy除數至temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;正確放入21
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
			.else
			add tempforinput,1 
			.endif
			loop LoopforcopyDivisor_3

			mov eax,tempforstring
			mov howlongdivisor,eax
			
			mov  tempforinput,0
			mov  tempforstring,0
			mov  ecx,tempfordividendecx
LoopforcopyDividend_3:                     ;copy被除數至temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;正確放入1104
			add  esi ,tempforstring
			mov  [esi],al
			add tempforinput,1
			add tempforstring,1
			.else
			add tempforinput,1 
			.endif
			loop LoopforcopyDividend_3

			mov ecx,dotdivisor 
			sub ecx,dotdividend
addmorezero_3:
			mov  esi  , OFFSET tempdividend;正確放入21
			add  esi , tempforstring
			mov  eax , 30h
			mov  [esi],eax
			add tempforstring,1
			loop addmorezero_3

			mov eax,tempforstring
			mov howlongdividend,eax

			;mov edx , OFFSET tempdividend                        ;測試用
		    ;call WriteString
		    ;call crlf
		    ;mov edx , OFFSET tempdivisor                        ;測試用
		    ;call WriteString
		.endif
;----------------------------------------------------------------上面做完補完0，下面放入DWORD中
			;mov eax,howlongdividend  ;被除數去掉小數點後為幾位
			 mov boolean,0
			 mov ecx,howlongdividend
			 mov esi,offset dividend
			 mov edi,offset tempdividend
addintoDWORD_dividend:
			mov ebx,boolean
			.if(ebx>0)
				shl dividend,4
			.endif
			mov al,[edi]
			sub al,30h
			add [esi],al
			inc edi
			add boolean,1   
			loop addintoDWORD_dividend
			
			;mov eax,dividend;測試用
			;call writehex;測試用
			;call crlf

			mov boolean,0
			mov ecx,howlongdivisor
			mov esi,offset divisor
			mov edi,offset tempdivisor
addintoDWORD_divisor:
			mov ebx,boolean
			.if(ebx>0)
				shl divisor,4
			.endif
			mov al,[edi]
			sub al,30h
			add [esi],al
			inc edi
			add boolean,1   
			loop addintoDWORD_divisor

			;mov eax,divisor;測試用
			;call writehex;測試用
			;call crlf
;-------------------------------------------------------------------------做壓縮減法當作除法			
		    mov ecx,dividend
			mov ebx,divisor
.while(ecx>ebx)
			clc
			mov al,BYTE PTR [dividend+0]           ;最低1byte
			mov bl,BYTE PTR [divisor+0]
			sub al,bl
			das
			mov BYTE PTR [dividend+0],al

			mov al,BYTE PTR [dividend+1]           ;最低2byte
			mov bl,BYTE PTR [divisor+1]
			.if(CARRY?)                             ;看是否借位
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+1],al

			mov al,BYTE PTR [dividend+2]           ;最低3byte
			mov bl,BYTE PTR [divisor+2]
			.if(CARRY?)                             ;看是否借位
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+2],al

			mov al,BYTE PTR [dividend+3]           ;最低4byte
			mov bl,BYTE PTR [divisor+3]
			.if(CARRY?)                             ;看是否借位
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+3],al

	        add quotient,1                          ;商數+1
			mov ecx,dividend                        ;查看除數是否大於餘數

			;mov eax,dividend                        ;++
			;call writehex                           ;++
			;mov eax,quotient                        ;++
			;call writeint                           ;++
			;call crlf                               ;++

			mov ebx,divisor
			mov eax,dividend
			cmp eax,ebx
			je Ans_q_r
			jl Ans_adj
			
			;call crlf                               ;++
.endw
;------------------------------------------------------------------------------------輸出
Ans_adj:
			mov edx , OFFSET out3                        ;非整除輸出商
			call WriteString
			mov eax,quotient
			call writedec
			call crlf
			mov edx , OFFSET out4                        ;整除輸出餘
			call WriteString
			                                              ;調整餘數
			;call crlf
			;mov eax,max
			;call writeint
			;call crlf

			mov ecx,8
			mov esi,offset remainder_adj
			mov edi,offset dividend
adjreverse_dividend:
			mov eax,0
			mov ebx,0
			mov al,[edi]
			mov bl,al
			shl bl,4
			shr bl,4
			add bl,30h
			mov [esi],bl
			shr dividend,4
			inc esi
			loop adjreverse_dividend
			;call crlf

			;mov edx , OFFSET remainder_adj               ;++
			;call WriteString                             ;++
			;call crlf

			mov ecx,0                                    ;加上小數點
			mov esi,offset remainder_adj
			mov edi,offset remainder_adj_ans
			mov eax,max
			mov ebx,0
.while(ecx<8)
			.if(cl==al)
				mov bl,2Eh				
				mov [edi],ebx
				add edi,1
			.endif
			mov ebx,[esi]
			mov [edi],ebx
			inc esi
			inc edi
			add ecx,1
.endw
			;mov edx , OFFSET remainder_adj_ans              ;++
			;call WriteString
			;call crlf

            mov ecx,8
			mov esi,offset remainder_adj_ans
			mov edi,offset remainder_adj_ans_reverse
			add edi,7
reverse_dividend:                                         ;反向
			mov al,[esi]
			mov [edi],al
			inc esi
			sub edi,1
			loop reverse_dividend
			

			;mov edx , OFFSET remainder_adj_ans_reverse               ;++
			;call WriteString
			;call crlf

			mov ecx,8
			mov esi,offset remainder_adj_ans_reverse
check_zero_from_start:
			mov al,[esi]
			.if(al==30h)
				inc temp
			.elseif((al=='.')|| (al>30h))
				jmp output_r
			.endif
			add esi,1
			loop check_zero_from_start
			
			
output_r:                                               ;前面有非0
			
             mov ecx,8
			 sub ecx,temp
			 mov esi,offset remainder_adj_ans_reverse
			 add esi,temp
			 mov al,[esi]
			 .if(al=='.')
				jmp output_r_adj
			 .endif
L1:                                                      ;輸出囉~
			 mov al,[esi]
			 call writechar
			 inc esi
			 loop L1
			 
			 jmp End1

output_r_adj:                                                ;前面都是0
			 mov al,'0'
			 call writechar
			 mov ecx,8
			 sub ecx,temp
			 mov esi,offset remainder_adj_ans_reverse
			 add esi,temp
L2:                                                      ;輸出囉~
			 mov al,[esi]
			 call writechar
			 inc esi
			 loop L2

			jmp End1
;-----------------------------------------------------------------------------整除輸出
Ans_q_r:                                                 ;整除  OK
			mov edx , OFFSET out3                        ;整除輸出商
			call WriteString
		    mov eax,quotient
			add eax,1
			call writedec
			call crlf

			mov edx , OFFSET out4                        ;整除輸出餘
			call WriteString
			mov eax,remainder
			call writedec
			jmp End1

End1:

	        call    crlf 
	call WaitMsg
	INVOKE ExitProcess , 0
main ENDP
END main