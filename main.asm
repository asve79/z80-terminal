	module main

	include "main.mac"
	include "z80-sdk/strings/strings.mac"
	include "z80-sdk/windows_bmw/wind.mac"
	include "z80-sdk/sockets/uart_zifi.mac"

;- MAIN PROCEDURE -
PROG	
	_printw wnd_main
	_prints	msg_keys
	CALL	init
	_cur_on

mloop   CALL	check_rcv
	CALL    spkeyb.CONINW	;main loop entry
	JZ	mloop		;wait a press key
	PUSH 	AF
	_iscmdmode		;if comman mode on go to cmdmodeproc
	JZ	cmdmodeproc
	;process terminal mode
	POP	AF
	CP	01Dh
	JZ	exit		;if SS+Q pressed, exit
	CP	#08		;left cursor key pressed
	JZ	mloop
	CP	#19		;right cursor key pressed
	JZ	mloop
	CP	#1A		;up cursor key pressed
	JZ	mloop
	CP	#18		;down cursor key pressed
	JZ	mloop
	CP	01Ch		;if Ss+W pressed - terminal command
	JZ	opencmdmode	
	CP	#7F		;//delete key pressed
	JZ	delsymtermmode	
	CP	13		;//enter key pressed
	JZ	enterkeytermmode
	CALL	puttotermbufer	;//put char to command bufer and print
	;_SendChar
	JP	mloop
cmdmodeproc ;process comman mode
	POP	AF
	CP	#08		;left cursor key pressed
	JZ	mloop
	CP	#19		;right cursor key pressed
	JZ	mloop
	CP	#1A		;up cursor key pressed
	JZ	mloop
	CP	#18		;down cursor key pressed
	JZ	mloop
	CP	01Dh
	JZ	closecmdmode	;if SS+Q pressed, exit
	CP	01Ch		;if Ss+W pressed - terminal command
	JZ	closecmdmode
	CP	#7F		;//delete key pressed
	JZ	delsymcmdmode	
	CP	13		;//enter key pressed
	JZ	enterkeycmdmode
	CALL	puttocmdbufer	;//put char to terminal bufer and print
	JP	mloop

opencmdmode ;open command window
	LD	A,1		;if terminal command mode is off
	LD	(mode),A	;turn on termianl mode
	_cur_off
	_printw	wnd_cmd		;print command window
	_prints	command_bufer	;print content of command buffer
	_cur_on
	JP	mloop
;----
closecmdmode ;close the commend window
	XOR	A
	LD	(mode),A
	_cur_off		
	_endw
	_cur_on
	JP	mloop
;-----
delsymcmdmode	;delete symbol in command bufer
	_findzero command_bufer	;//get ptr on last symbol+1 in buffer
	JR	delsymproc	;//get ptr on last symbol+1 in buffer
delsymtermmode	;delete symbol in terminal mode
	_findzero input_bufer	;//get ptr on last symbol+1 in buffer
delsymproc	;delete symbol main proc
	OR	A
	JZ	mloop		;//if nothing in bufer (length=0)
	DEC	HL
	XOR	A
	LD	(HL),A		;//erase symbol
	LD	A,8		;/cusor to left
	_printc
	LD	A,' '		;//space
	_printc
	LD	A,8		;//left again
	_printc
	JP	mloop
;----
enterkeycmdmode	;enter key pressed in command window. execute command if it exists
;	_isopencommand  cmd_bufer,eccm1	;//'open'  command
;	_isclosecommand cmd_bufer,eccm1 ;//'close' command
	_ishelpcommand  command,eccm1	;//'help' command
	_isaboutcommand command,eccm1	;//'about' command
	_isexitcommand command,eccm1	;//'exit' command
	_clearwindow			;// wrong command:  clear window
eccm1	_fillzero command_bufer, 100	;clear command buffer
	JP 	mloop
;----
enterkeytermmode	;enter key pressed in terminal window
	_findzero input_bufer
	LD	B,A
	LD	A,13		;/add 13 code for <CR><LF> EOL command
	LD	(HL),A
	INC	HL
	LD	A,10		;/add 10 code for <CR><LF> EOL command
	LD	(HL),A
	INC	HL
	XOR	A
	LD	(HL),A
	LD	HL,input_bufer
;	PUSH	HL
;	_prints input_bufer
;	POP	HL
1	LD	A,(HL)
	OR	A
	JZ	ekcm_nc
	_SendChar
	INC	HL
	JR	1b

ekcm_nc	_fillzero input_bufer,255
	_cur_off
	LD	A,13
	_printc
	_cur_on
	JP	mloop
;- routine -
puttocmdbufer	;put symbol in command bufer
	PUSH	AF
	_findzero command_bufer
	JR	puttobufer
puttotermbufer	;put symbol to terminal bufer
	PUSH 	AF
	_findzero input_bufer
puttobufer	;main procedure for put to bufer;TODO make insert mode with shift content
	POP	AF
	LD	(HL),A
	_printc		;out characte
	RET

exit	_cur_off		
	_closew
	RET

fillzero
	_fillzero command_bufer, 100
	RET

init	XOR	A
	LD 	(mode),A	;set terminal mode
	_init_zifi
	RET	Z
	_prints msg_nozifi
	RET


;/ inctease counter every interrupt
INCCNTR LD	A,(im_cntr)
	INC	A
	LD	(im_cntr),A
	;call	wind.A_HEX
	RET

//check receve info from connection
check_rcv	;
	LD	A,(im_cntr)
;	call	wind.A_HEX
	AND	#F0
	RET	Z		;skip N tick's
	XOR	A
	LD	(im_cntr),A
	_istermmode
	RET	NZ		;//if terminal mode, then no print error status
rcv1	_input_fifo_status
	OR	A
	RET	Z		;//Return if zero
;	push	AF		;//debug
;	CALL	wind.A_HEX
;	POP	AF
	_ReceveChar		;//get char
	_printc			;//print it
	JR	rcv1

	include "maindata.asm"
	include "z80-sdk/sockets/uart_zifi.a80"
	include "z80-sdk/strings/strings.a80"

	endmodule