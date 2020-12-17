; FILENAME: EXP04.ASM - B18030620
.586

DATA SEGMENT USE16
    OLD0B     DD ?
    FLAG      DB 0
DATA ENDS

CODE SEGMENT USE16
    ASSUME CS:CODE, DS:DATA

BEG:
    MOV     AX, DATA
	  MOV     DS, AX      ; ��ʼ�� DS
	  CLI                 ; �ر��ж�
	  CALL    I8250       ; ��ʼ�� 8250 (����)
	  CALL    I8259       ; ���� 8259A �������ж�
	  CALL    RD0B        ; ���ж�����
	  CALL    WR0B        ; д�ж�����
	  STI                 ; �����ж�
SCAN:
    CMP		FLAG, 1
	  JE		RETURN        ; ���յ� esc ���˳�
	  MOV 	AH, 1
	  INT 	16H           ; �����̻�����
	  JZ 		SCAN          ; ���ַ����������
	  MOV 	DX, 2FDH
	  IN 		AL, DX
	  TEST 	AL, 20H       ; ��ⷢ�ͱ��ּĴ����Ƿ�Ϊ��
	  JZ 		SCAN          ; ��Ϊ���򲻷���
	  MOV 	AH, 0
	  INT 	16H 					; Ϊ�����ȡ���̻�����
	  AND 	AL, 7FH
	  MOV 	DX, 2F8H
	  OUT 	DX, AL        ; ��������д�뷢�ͻ�����
	  CMP 	AL, 1BH
	  JNE 	SCAN          ; ����������һ���ַ�
LAST:
		MOV 	DX, 2FDH
		IN 		AL, DX
		TEST 	AL, 40H
		JZ 		LAST          ; �������ǰȷ�����ݷ������
RETURN:
		CALL 	RESET
		MOV 	AH, 4CH
		INT 	21H


; ��ʼ�� 8250 (����)
; �����ڶ˿ں� 3F��ʵ����ͳһʹ�ø����� 2F �˿ں�
I8250 PROC
    MOV   DX, 2FBH
	  MOV   AL, 80H
	  OUT   DX, AL       ; ����Ѱַλ
	  MOV   DX, 2F9H
	  MOV   AL, 00H
	  OUT   DX, AL       ; ������λ (0060H��1200bps)
	  MOV   DX, 2F8H
	  MOV   AL, 60H
	  OUT   DX, AL        ; ������λ (0060H��1200bps)
	  MOV   DX, 2FBH
	  MOV   AL, 00000011B
	  OUT   DX, AL        ; ������ (8 λ����λ����������)
	  MOV   DX, 2F9H
	  MOV   AL, 01H
	  OUT   DX, AL        ; �ж������Ĵ��� (����Ϊ��ѯ������Ϊ�ж�)
	  MOV   DX, 2FCH
	  MOV   AL, 0BH
	  OUT   DX, AL        ; ���� MODEM (0B �����жϣ�10H �ڻ��Լ�)
	  RET
I8250 ENDP

; ���� 8259A �������ж�
I8259 PROC
    IN    AL, 21H
	  AND   AL, 11110111B
	  OUT   21H, AL
	  RET
I8259 ENDP

; ���ж�����
RD0B PROC
	  MOV   AX, 350BH
	  INT   21H
	  MOV   WORD PTR OLD0B, BX
	  MOV   WORD PTR OLD0B+2, ES
	  RET
RD0B ENDP

; д�ж�����
WR0B PROC
	  PUSH  DS
  	MOV   AX, CODE
	  MOV   DS, AX
	  MOV   DX, OFFSET RECEIVE
	  MOV   AX, 250BH
	  INT   21H
	  POP   DS
	  RET
WR0B ENDP

; ��������
RECEIVE PROC
	  PUSHA
	  PUSH    DS
	  MOV     AX, DATA
	  MOV     DS, AX
	  MOV     DX, 2F8H
	  IN      AL, DX      ; ��ȡ���ջ�����������
	  AND     AL, 7FH
	  CMP     AL, 1BH     ; �ж��Ƿ�Ϊ�˳��ַ� (esc ��)
	  JE      NEXT
  	MOV     AH, 2
  	MOV     DL, AL
  	INT     21H         ; ��ʾ�ַ�
  	JMP     EXIT
NEXT:
    MOV     FLAG, 1
EXIT:
    MOV     AL, 20H
	  OUT     20H, AL
	  POP     DS
	  POPA
	  IRET
RECEIVE ENDP

; ����
RESET PROC 
	  IN    AL, 21H
	  OR    AL, 00001000B
  	OUT   21H, AL
  	MOV   DX, WORD PTR OLD0B
  	MOV   DS, WORD PTR OLD0B+2
  	MOV   AX, 250BH
  	INT   21H
  	RET
RESET ENDP

CODE ENDS
    END   BEG