INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
.data
	 out1		               BYTE    "�п�J�Q���ơG", 0
	 out2		               BYTE    "�п�J���ơG", 0
	 inputdividend             BYTE    1000 DUP(?)
	 inputdivisor			   BYTE    1000 DUP(?)
	 dot                       BYTE    ".",0
	 dotdividend               SDWORD  0                 ;�Q���Ƥp���I�ᦳ�X��
	 dotdivisor                SDWORD  0                 ;���Ƥp���I�ᦳ�X��
	 dotdividendfromstart      SDWORD  0                 ;�Q���ƶ}�Y��p���I���Z��(����p���I)
	 dotdivisorformstart       SDWORD  0                 ;���ƶ}�Y��p���I���Z��(����p���I)
	 tempfordividendecx        SDWORD  0                 ;�s��J�X�Ӧr���i�Q����
	 tempfordivisorecx         SDWORD  0                 ;�s��J�X�Ӧr���i����
	 tempdividend              BYTE    1000 DUP(?)
	 tempdivisor               BYTE    1000 DUP(?)
	 tempforinput              SDWORD  0  
	 tempforstring             SDWORD  0
	 howlongdividend           SDWORD  0                 ;�h���p���I�ᬰ�X��
	 howlongdivisor            SDWORD  0                 ;�h���p���I�ᬰ�X��
	 max                       SDWORD  0                 ;�p���I����
	 dividend                  DWORD   0
	 divisor                   DWORD   0
	 boolean                   SDWORD  0                 ;�ΨӬ�boolean��
	 quotient                  DWORD  0                 ;�ΨӦs��Ӽ�
	 remainder                 DWORD  0                 ;�ΨӦs��l��
	 out3		               BYTE    "�ӼơG", 0
	 out4		               BYTE    "�l�ơG", 0
	 remainder_adj             BYTE   1000 DUP(?)
	 remainder_adj_ans         BYTE   1000 DUP(?)
	 remainder_adj_ans_reverse BYTE   1000 DUP(?) 
	 temp                      SDWORD  0                 ;�̫��X
.code
main PROC
	call Clrscr ;�M���ù�
;--------------------------------------------------------------�Q���Ƨ@�k
	mov edx , OFFSET out1                        ;�����ϥΪ̿�J�Q����
	call WriteString
	mov edx  , OFFSET inputdividend               ; ���w�w�İ� 
    mov ecx  , ( SIZEOF inputdividend ) - 1       ; ����null�A���w�̤jŪ���r�����
    call ReadString                                ; ��J�r��

	mov  esi  , OFFSET dot                   ;��Jdot
	mov  ebx  , [esi]

	mov  esi  , OFFSET inputdividend
	mov  tempfordividendecx,eax
	mov  ecx,eax
FindDotInDividend:                          ;��X dot�b�Q���ư}�C�ĴX��
		mov  al ,[esi]
	.if(al==bl)
	    jmp FindoutDividend
	 .else
		add dotdividend,1
	.endif
		add esi,1
	loop FindDotInDividend
FindoutDividend:	
	mov eax,dotdividend               ;��p���I���٦��X��
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

;----------------------------------------------------------------------���Ƨ@�k
	mov edx , OFFSET out2                        ;�����ϥΪ̿�J����
	call WriteString
	mov edx  , OFFSET inputdivisor               ; ���w�w�İ� 
    mov ecx  , ( SIZEOF inputdivisor ) - 1       ; ����null�A���w�̤jŪ���r�����
    call ReadString                              ; ��J�r��
	 
	mov  esi  , OFFSET dot                       ;��Jdot
	mov  ebx  , [esi]
	
	mov  esi  , OFFSET inputdivisor
	mov  tempfordivisorecx,eax
	mov  ecx,eax
FindDotInDivisor:                                ;��Xdot�b���ư}�C�ĴX��
		mov  al ,[esi]
	.if(al==bl)
	    jmp FindoutDivisor
	 .else
		add dotdivisor,1
	.endif
		add esi,1
	loop FindDotInDivisor
FindoutDivisor:	
	mov eax,dotdivisor    ;��p���I���٦��X��
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

;-----------------------------------------------------------------����p���I����

		mov eax,dotdividend 
		mov edx,dotdivisor 
		mov  esi  , OFFSET dot                   ;��Jdot  ;���ե�
		mov  ebx  , [esi]
		.if(eax==edx) ;�p���I��ۦP���
		  mov  max,eax
		  mov  ecx,tempfordividendecx
LoopforcopyDividend_1:                                          ;copy�Q���Ʀ�temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;���T��J1104
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
LoopforcopyDivisor_1:                                           ;copy���Ʀ�temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;���T��J21
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

		  ;mov edx , OFFSET tempdividend                        ;���ե�
		  ;call WriteString
		  ;call crlf
		 ; mov edx , OFFSET tempdivisor                        ;���ե�
		  ;call WriteString

		.elseif(eax>edx) ;�Q���ƪ��p���I���Ƥ���h
		    mov  max,eax
			mov  ecx,tempfordividendecx
LoopforcopyDividend_2:                                          ;copy�Q���Ʀ�temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;���T��J1104
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
LoopforcopyDivisor_2:                                           ;copy���Ʀ�temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;���T��J21
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
			mov  esi  , OFFSET tempdivisor ;���T��J21
			add  esi , tempforstring
			mov  eax , 30h
			mov  [esi],eax
			add tempforstring,1
			loop addmorezero_2

			mov eax,tempforstring
			mov howlongdivisor,eax

			;mov edx , OFFSET tempdividend                        ;���ե�
		    ;call WriteString
		   ; call crlf
		   ; mov edx , OFFSET tempdivisor                        ;���ե�
		    ;call WriteString
			
		.elseif(edx>eax) ;���ƪ��p���I���Ƥ���h
		    mov  max,edx
		    mov  ecx,tempfordivisorecx 
LoopforcopyDivisor_3:                                           ;copy���Ʀ�temp
			mov  esi  , OFFSET inputdivisor 
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdivisor ;���T��J21
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
LoopforcopyDividend_3:                     ;copy�Q���Ʀ�temp
			mov  esi  , OFFSET inputdividend
			add  esi ,tempforinput
			mov  al ,[esi]
			.if(al>bl)
			mov  esi  , OFFSET tempdividend ;���T��J1104
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
			mov  esi  , OFFSET tempdividend;���T��J21
			add  esi , tempforstring
			mov  eax , 30h
			mov  [esi],eax
			add tempforstring,1
			loop addmorezero_3

			mov eax,tempforstring
			mov howlongdividend,eax

			;mov edx , OFFSET tempdividend                        ;���ե�
		    ;call WriteString
		    ;call crlf
		    ;mov edx , OFFSET tempdivisor                        ;���ե�
		    ;call WriteString
		.endif
;----------------------------------------------------------------�W�������ɧ�0�A�U����JDWORD��
			;mov eax,howlongdividend  ;�Q���ƥh���p���I�ᬰ�X��
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
			
			;mov eax,dividend;���ե�
			;call writehex;���ե�
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

			;mov eax,divisor;���ե�
			;call writehex;���ե�
			;call crlf
;-------------------------------------------------------------------------�����Y��k��@���k			
		    mov ecx,dividend
			mov ebx,divisor
.while(ecx>ebx)
			clc
			mov al,BYTE PTR [dividend+0]           ;�̧C1byte
			mov bl,BYTE PTR [divisor+0]
			sub al,bl
			das
			mov BYTE PTR [dividend+0],al

			mov al,BYTE PTR [dividend+1]           ;�̧C2byte
			mov bl,BYTE PTR [divisor+1]
			.if(CARRY?)                             ;�ݬO�_�ɦ�
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+1],al

			mov al,BYTE PTR [dividend+2]           ;�̧C3byte
			mov bl,BYTE PTR [divisor+2]
			.if(CARRY?)                             ;�ݬO�_�ɦ�
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+2],al

			mov al,BYTE PTR [dividend+3]           ;�̧C4byte
			mov bl,BYTE PTR [divisor+3]
			.if(CARRY?)                             ;�ݬO�_�ɦ�
				sub al,1
				clc
			.endif
			sub al,bl
			das
			mov BYTE PTR [dividend+3],al

	        add quotient,1                          ;�Ӽ�+1
			mov ecx,dividend                        ;�d�ݰ��ƬO�_�j��l��

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
;------------------------------------------------------------------------------------��X
Ans_adj:
			mov edx , OFFSET out3                        ;�D�㰣��X��
			call WriteString
			mov eax,quotient
			call writedec
			call crlf
			mov edx , OFFSET out4                        ;�㰣��X�l
			call WriteString
			                                              ;�վ�l��
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

			mov ecx,0                                    ;�[�W�p���I
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
reverse_dividend:                                         ;�ϦV
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
			
			
output_r:                                               ;�e�����D0
			
             mov ecx,8
			 sub ecx,temp
			 mov esi,offset remainder_adj_ans_reverse
			 add esi,temp
			 mov al,[esi]
			 .if(al=='.')
				jmp output_r_adj
			 .endif
L1:                                                      ;��X�o~
			 mov al,[esi]
			 call writechar
			 inc esi
			 loop L1
			 
			 jmp End1

output_r_adj:                                                ;�e�����O0
			 mov al,'0'
			 call writechar
			 mov ecx,8
			 sub ecx,temp
			 mov esi,offset remainder_adj_ans_reverse
			 add esi,temp
L2:                                                      ;��X�o~
			 mov al,[esi]
			 call writechar
			 inc esi
			 loop L2

			jmp End1
;-----------------------------------------------------------------------------�㰣��X
Ans_q_r:                                                 ;�㰣  OK
			mov edx , OFFSET out3                        ;�㰣��X��
			call WriteString
		    mov eax,quotient
			add eax,1
			call writedec
			call crlf

			mov edx , OFFSET out4                        ;�㰣��X�l
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