.model small
.stack 100h

.data
;All Globall Variables Data

	vector1Msg db "Vector 1: $"				; this string is used for vector 1 msg	
	vector2Msg db "Vector 2: $"				; this string is used for vector 2 msg		
	outputMsg db "Vector Sum: $"			; this string is used for sum of two vectors msg
	newLine db 13,10,'$'					; this string is used for new Line		
			
	count db 0								; used for check no of digits in decimal out	put

; these two arrays used for vector1 and vector2
	vector1 dw 3,5			
	vector2 dw 2,14

;addition of vector result will be saved in result array 
	result dw 0,0

.code

main proc
	
;This is our Main Program
	
	mov ax,@data
	mov ds,ax
	
	call displayVector1				;print vector1
	call printNewLine				;print newLine
	call displayVector2				;print vector2
	call printNewLine				;print newLine
	call vectorSum					;calculate sum of two vectors
	call displayResult				;print result of addition of two vectors vector1 and vector2
		
	mov ah,4ch
	int 21h

MAIN ENDP

;this procedure will calculate vector sum
vectorSum proc

	;here si and di are pointer of array vector1 and vector2 respectively
	mov si, offset vector1
	mov di, offset vector2
	
	;calculate sum of X-axis
	mov ax,[si]
	add ax,[di]
	
	add si,2
	add di,2
	
	;calculate sum of Y-axis
	mov bx,[si]
	add bx,[di]
	
	;saving Result
	mov si,offset result
	mov [si],ax
	add si,2
	mov [si],bx

	ret 
vectorSum endp

;this procedure will display vector1
displayVector1 proc
	mov ah,09h
	mov dx,offset vector1Msg
	int 21h
	
	mov si,offset vector1
	mov ax,[si]
	call decimalOutput
	
	mov ah,02h
	mov dl,','
	int 21h
	
	add si,2
	mov ax,[si]
	call decimalOutput
	ret
displayVector1 endp
	
;this procedure will display vector2
displayVector2 proc
	mov ah,09h
	mov dx,offset vector2Msg
	int 21h
	
	mov si,offset vector2
	mov ax,[si]
	call decimalOutput
		
	mov ah,02h
	mov dl,','
	int 21h
	
	add si,2
	mov ax,[si]
	call decimalOutput
	ret
displayVector2 endp

;this procedure will print new Line
printNewLine proc
	mov ah,09h
	mov dx,offset newLine
	int 21h
	ret
printNewLine endP

;this procedure will display the vector sum result
displayResult proc

	mov ah,09h
	mov dx,offset outputMsg
	int 21h
	
	mov si,offset result
	mov ax,[si]
	call decimalOutput
		
	mov ah,02h
	mov dl,','
	int 21h
	
	add si,2
	mov ax,[si]
	call decimalOutput
	ret
displayResult endp

;this procedure will display a decimal number
decimalOutput proc
	
	cmp ax,0
	JE printZero		; if number is zero then display zero only
	
	;seperate each digit by diving number by 10 and push reminder on stack
	mov bl,10
pushDigit:
	div bl
	mov dl,ah
	mov ah,0
	push dx
	inc count
	cmp ax,0
	JE endPushDigit
	JMP pushDigit

endPushDigit:
	;print each digit from stack
	mov bl,1
startPop:
	cmp bl,count
	JA endPop
	pop dx
	inc bl
	add dl,30h
	mov ah,02h
	int 21h
	JMP startPop
	
	;print zero on screen
printZero:
	mov ah,02h
	mov dl,'0'
	int 21h

endPop:
	mov count,0
	ret
	
decimalOutput endp

END MAIN