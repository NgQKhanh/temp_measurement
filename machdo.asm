;=================================
; do nhiet do
;=================================

org 000h
jmp setup 

org 0003h
	inc r1 
	setb c						;bam reset (c = 1) 
	setb 7fh
	reti
	
org 0013h
	dec r1
	setb 7fh
	reti
	
setup:
	mov r1,#50						; set nhiet do canh bao ban dau la 50

	eoc  bit p2.5	
	ale  bit p2.6
	start bit p2.7

	led1 bit p2.0
	led2 bit p2.1
	led3 bit p2.2
	led4 bit p2.3
		
	tang bit p3.2
	giam bit p3.3
	coi  bit p3.7
	clr coi

	setb ex0
	setb ex1
	setb ea
	setb it0
	setb it1

	clr 7fh
	mov r4,#1

main:	 
	
	lcall lay_mau
	ljmp kiemtra
	kocanhbao: 
	jb 7fh,setnhietdo
	mov a, r2
	lcall chuyen_doi
	mov r7,#150
	de: lcall hien_thi
	djnz r7,de
	jmp main

lay_mau:
	clr 7eh
	setb ale
	setb start
	clr start
	jnb eoc,$	   
	clr ale
	mov a,p1
	mov r2,a
	ret
	
chuyen_doi:
	clr coi
	mov b,#10					; tach cs tram chuc don vi
	div ab
	mov 10h,b           
	mov b,#10
	div ab
	mov 11h,b			
	mov 12h,a			
	
	mov dptr,#900h				; chuyen sang ma led
	mov a,10h
	movc a,@a + dptr
	mov 20h,a			 
	mov a,11h
	movc a,@a + dptr
	mov 21h,a			
	mov a,12h
	movc a,@a + dptr
	mov 22h,a		
	ret
	
kiemtra:
	SubB   a,r1					;kiem tra nhiet do ( neu a >= r1 thi c = 0; a < r1 thi c = 1)	
	jc kocanhbao        		; c = 1 thi khong canh bao
	jmp canhbao					; c = 0 thi bat canh bao
	
hien_thi:	
	mov p0,#9ch					; hien thi do
	setb led4
	lcall delay
	clr led4	
	mov p0,20h
	setb led3
	lcall delay
	clr led3
	mov p0,21h
	setb led2
	lcall delay
	clr led2	
	mov p0,22h
	setb led1
	lcall delay
	clr led1
	ret
	
setnhietdo: 					; hien thi r1 va delay 1 khoang thoi gian	
	clr 7fh
	mov 50H,#5
loop1: 
	mov 51H,#250       
loop:    
	mov a,r1
	lcall chuyen_doi
	lcall hien_thi
	djnz 51H,loop
    djnz 50H,loop1	 
	jb 7fh,setnhietdo
	jmp main
	
canhbao:
	setb  coi					; bat coi canh bao
	mov p0,#80h				; hien thi nhap nhay 8888
	anl p2,#0f0h
	lcall delay_500ms
	orl p2,#0fh
	lcall delay_500ms	
	jnc canhbao					; neu chua bam reset (c = 0) tiep tuc canh bao
	jmp main
	
delay: 
	mov 6eh,#150
	djnz 6eh,$
	ret
	
delay_500ms:
	mov 50H,#200
loop2: 
	mov 51H,#250
	djnz 51H,$
	djnz 50H,loop2
	ret

org 900h
db 0C0h, 0F9h,0A4h, 0B0h,99h, 92h, 82h, 0f8h, 80h, 90h
	
END

