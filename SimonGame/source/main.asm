TITLE MASM Template	(main.asm)
; Description:  Simon Game
; Author:   Sabin Sapkota, Pragalva Dhungana      
; Date:     12/6/2018
INCLUDE Irvine32.inc    
; TODO: PLACE SYMBOLIC INTEGER CONSTANTS HERE 
.CONST

.data
str1 BYTE "  ",0
col DWORD  128 DUP(?) 
redcol BYTE 4
bluecol BYTE 1
yellowcol BYTE 6
Greencol BYTE 2
GameCount DWORD 2
InputPrompt BYTE "Input the sequence it blinked one color at a time",0
InputPrompt2 BYTE "Use 0 for red, 1 for blue, 2 for green and 3 for yellow ",0
OutputWrong BYTE "Wrong Color",0

stage DWORD 2


.code
main PROC

mov ecx, GameCount
mov esi, OFFSET col

L0:
    ;Checks to see if the loop is running for the first time
	;If it is then moves offset col to esi which resets the esi for a new stage 
	mov eax, stage
	.IF GameCount == eax
	mov esi, OFFSET col
	.ENDIF

	call Randomize

	;loop
	.IF ecx > 1
	mov eax, 4
	call RandomRange
	call check ;check which color was genetrated
	call array_fill ;fills the array with the generated color
	.ENDIF

		mov ecx, 8 ;set loop counter
		labelROW:
			push ecx
			mov ecx, 8; Set the column counter
			labelCOL: ;loop to print the red color
					movzx eax, redcol
					mov ebx, 16
					mul ebx
					add eax, 15
					call Color 
			LOOP labelCOL 
			mov ecx, 8 
			labelCOL2:  ;loop to print blue color
					movzx eax, bluecol
					mov ebx, 16
					mul ebx
					add eax, 15
					call Color 
			LOOP labelCOL2
			pop ecx
			call Crlf
		LOOP labelROW

		mov ecx, 8 ;set loop counter
		labelROW2:
			push ecx
			mov ecx, 8; Set the column counter
			labelCOL3: ;Loop that Prints the green color
					movzx eax, Greencol
					mov ebx, 16
					mul ebx
					add eax, 15
					call Color 
			LOOP labelCOL3 
			mov ecx, 8 
			labelCOL4:  ;loop that prints yellow color
					movzx eax, yellowcol
					mov ebx, 16
					mul ebx
					add eax, 15
					call Color 
			LOOP labelCOL4
			pop ecx
			call Crlf
		LOOP labelROW2
		
		
		;Resets everything to black
		mov eax,white+(Black*16)
		call SetTexTColor
		mov eax, 1000
		call Delay

		;Clears the screen for next blinking
		mov ecx, GameCount
		.IF ecx > 1
		call Clrscr
		.ENDIF

		;Rest to normal
		mov redcol,4 
		mov yellowcol, 6
		mov bluecol, 1
		mov Greencol, 2

		;Checking function when the loop is in its last stage
		.IF ecx == 1
		call DisplayForInput

		;Loop to record users input
		push ecx
		mov ebx,0
		mov ecx, stage
		sub ecx, 1
			L1:
				call ReadDec
				cmp eax, col[ebx]
				jne Wrong
				add ebx,4 
				LOOP L1
		pop ecx
		.ENDIF
	
	;loop to the run in a particular level
	mov eax, 1
	dec ecx
	mov GameCount, ecx
	jnz L0
	call Clrscr

	;Increases the level of the game
	mov ecx, stage
	add ecx, 1
	mov GameCount, ecx
	mov stage, ecx
	jmp L0

;when the answer is wrong the program jumps to this line
Wrong:
		mov edx, OFFSET OutputWrong
		call WriteString
		call crlf
exit
main ENDP

; (insert additional procedures here)

Color PROC
;-----------------------------------------------------------------
;Returns color assostiaed with a random number
;Recives EAX
;-----------------------------------------------------------------
	call SetTexTColor
	mov edx, OFFSET str1
	call WriteString
    ret
Color ENDP

array_fill PROC
;-----------------------------------------------------------------
;Fills and array with numbers
;Recieves esi
;-----------------------------------------------------------------
	mov [esi], eax ;saves the number in an array for later use
	add esi, 4
	ret
array_fill ENDP

check PROC
;----------------------------------------------------------------------------
;Checks to see which number was generated and based in that changes the color
;Assosiated with that to a brighter chage to give an illution of blinking
;Recives EAX
;----------------------------------------------------------------------------
	.IF eax==0
		mov redcol, 12
	.ELSEIF eax==1
		mov bluecol, 9
	.ELSEIF eax==2
		mov greencol, 10
	.ELSE 
		mov yellowcol, 14
	.ENDIF
	ret
check ENDP

DisplayForInput PROC
;-------------------------------------------
;Function that prompts the user for input
;Requires no argument
;-------------------------------------------- 
	mov edx, OFFSET InputPrompt
		call WriteString
		call Crlf

	mov edx, OFFSET InputPrompt2
		call WriteString
		call Crlf
		ret
DisplayForInput ENDP
END 