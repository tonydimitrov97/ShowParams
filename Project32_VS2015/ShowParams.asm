INCLUDE IRVINE32.INC

ExitProcess proto, dwExitCode:dword

MySample Proto,								;Prototype for MySample procedure		
	first:DWORD,							;First parameter
	second:DWORD,							;Second parameter
	third:DWORD							;Third parameter

ShowParams Proto,							;Prototype for ShowParams
	numParams:DWORD							;Number of parameters

.code									;Beginning of code
main PROC								;Begin main procedure

INVOKE MySample, 1234h, 5000h, 6543h					;Three parameters to be displayed

INVOKE EXITPROCESS, 0
main endp								;End main
;-----------------------------------------;MySample
;
;Sample procedure to call ShowParams
;
;Receives: Three parameters
;Returns:  NA
;-----------------------------------------
MySample Proc,								;Begin proc
	first:DWORD,							;First parameter
	second:DWORD,							;Second parameter
	third:DWORD							;Third parameter

paramCount = 3								;Number of parameters passed
INVOKE ShowParams, paramCount						;Calling ShowParams

	ret								;Return to main
Mysample EndP								;End proc
;-----------------------------------------
;ShowParams
;
;Displays address and contents of function
;that called it
;
;Receives: Number of parameters
;Returns:  NA
;-----------------------------------------
ShowParams Proc,							
	numParams:DWORD
LOCAL prompt1[18]:BYTE,							;Local variable for heading
	prompt2[9]: BYTE						;Local variable for address prompt

lea edx, prompt1							;Loads effective address of heading
mov dword ptr [edx], "catS"						;Assigning values to prompt
mov dword ptr [edx + 4], "ap k"						;must be in reverse order due to
mov dword ptr [edx + 8], "emar"						;little endian order
mov dword ptr [edx + 12], "sret"					;Can only assign 4 chars at a time
mov word ptr [edx + 16], ':'						;"                               "		
call WriteString							;Displays edx offset, heading
call crlf								;New line

mov ecx, 27								;Sets loop counter for underline
mov al, 45								;Sets al to ASCII value of hyphen
L2:									;Start loop
	call WriteChar							;Display al
	loop L2								;Dec ecx, check if 0, if not loop
call crlf								;New line

lea esi, prompt2							;Loads address of second prompt
mov dword ptr [edx], "rddA"						;Same rules as prompt1
mov dword ptr [edx + 4], " sse"						;"                   "
mov byte ptr [edx + 8], 0						;Null character to stop displaying

mov ecx, numParams							;Sets loop counter to num of params

L1:									;Beginning of loop
	call WriteString						;Display "Address"
	lea eax, [ebp + 20]						;Loads address of first parameter
	call Writehex							;Displays address in hex
	mov al, 32							;ASCII character of space
	call WriteChar							;Displays spaces
	mov al, 61							;ASCII character for =
	call WriteChar							;Displays equal sign
	mov al, 32							;ASCII character of space
	call WriteChar							;Displays space
	mov eax, [ebp + 20]						;Moves value of first param in eax
	call WriteHex							;Displays value in hex
	call crlf							;New line
	add ebp, 4							;Moves into next parameter
	loop L1								;Dec ecx, check if 0, if not loop

ret									;Return to value after call
ShowParams Endp								;End of showParams
end main								;End program
