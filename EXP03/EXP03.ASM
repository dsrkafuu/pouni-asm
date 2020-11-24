.MODEL    SMALL
.486
CODE      SEGMENT USE16
          ASSUME CS:CODE

BEG:      JMP  START
CCONPORT  EQU  213H          ; ���ƿڵ�ַ
CCONBIT1  EQU  00010110B     ; ������ 0 ������
CCONBIT2  EQU  01010110B     ; ������ 1 ������
CCONBIT3  EQU  10010110B     ; ������ 2 ������
CDPORT1   EQU  210H          ; ������ 0 ���ݶ˿ڵ�ַ
CDPORT2   EQU  211H          ; ������ 1 ���ݶ˿ڵ�ַ
CDPORT3   EQU  212H          ; ������ 2 ���ݶ˿ڵ�ַ
CHDBIT1   EQU  00H           ; 100kHz / 65536 = 1.5Hz
CHDBIT2   EQU  250           ; 10kHz  / 250   = 40Hz
CHDBIT3   EQU  100           ; 1kHz   / 100   = 10Hz

START:    NOP                ; ������ʱ
          MOV  DX, CCONPORT  ; д������� 0
          MOV  AL, CCONBIT1
          OUT  DX, AL
          MOV  DX, CDPORT1   ; д���ֵ 0
          MOV  AL, CHDBIT1
          OUT  DX, AL

          MOV  DX, CCONPORT  ; д������� 1
          MOV  AL, CCONBIT2
          OUT  DX, AL
          MOV  DX, CDPORT2   ; д���ֵ 1
          MOV  AL, CHDBIT2
          OUT  DX, AL

          MOV  DX, CCONPORT  ; д������� 2
          MOV  AL, CCONBIT3
          OUT  DX, AL
          MOV  DX, CDPORT3   ; д���ֵ 2
          MOV  AL, CHDBIT3
          OUT  DX, AL

WT:       NOP
          JMP  WT

CODE      ENDS
          END  BEG