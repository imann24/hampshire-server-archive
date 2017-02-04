;;; ================================================================================================================================
;;; kernel.asm
;;; Scott F. H. Kaplan -- sfkaplan@cs.amherst.edu
;;;
;;; The assembly core that perform the basic initialization of the kernel, bootstrapping the installation of trap handlers and
;;; configuring the kernel's memory space.
;;; ================================================================================================================================


;;; ================================================================================================================================
	.Code
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Entry point.

__start:	

	;; Find RAM.  Start the search at the beginning of the device table.
	COPY		%G0			*+_static_device_table_base
	
RAM_search_loop_top:

	;; End the search with failure if we've reached the end of the table without finding RAM.
	BEQ		+RAM_search_failure	*%G0		*+_static_none_device_code

	;; If this entry is RAM, then end the loop successfully.
	BEQ		+RAM_found		*%G0		*+_static_RAM_device_code

	;; This entry is not RAM, so advance to the next entry.
	ADDUS		%G0			%G0		*+_static_dt_entry_size	; %G0 = &dt[RAM]
	JUMP		+RAM_search_loop_top

RAM_search_failure:

	;; Record a code to indicate the error, and then halt.
	COPY		%G5		*+_static_kernel_error_RAM_not_found
	NOOP
	NOOP
	HALT

RAM_found:
	
	;; RAM has been found.  If it is big enough, create and initialize a stack.
	ADDUS		%G1		%G0		*+_static_dt_base_offset  ; %G1 = &RAM[base]
	COPY		%G1		*%G1 					  ; %G1 = RAM[base]
	ADDUS		%G2		%G0		*+_static_dt_limit_offset ; %G2 = &RAM[limit]
	COPY		%G2		*%G2 					  ; %G2 = RAM[limit]
	SUB		%G0		%G2		%G1 			  ; %G0 = |RAM|
	MULUS		%G4		*+_static_min_RAM_KB	 *+_static_bytes_per_KB ; %G4 = |min_RAM|
	BLT		+RAM_too_small	%G0		%G4
	MULUS		%G4		*+_static_kernel_KB_size *+_static_bytes_per_KB ; %G4 = |kmem|
	ADDUS		%SP		%G1		%G4  			  ; %SP = kernel[base] + |kmem| = kernel[limit]
	COPY		%FP		%SP 					  ; Initialize %FP

	;; Copy the RAM and kernel bases and limits to statically allocated spaces.
	COPY		*+_static_RAM_base		%G1
	COPY		*+_static_RAM_limit		%G2
	COPY		*+_static_kernel_base		%G1
	COPY		*+_static_kernel_limit		%SP

	;; With the stack initialized, call main() to begin booting proper.
	SUBUS		%SP		%SP		8		; Push pFP / ra
	COPY		*%SP		%FP		  		; pFP = %FP
	ADDUS		%FP		%SP		4		; %FP = &ra
	CALL		+_procedure_main		*%FP

	;; We should never be here, but wrap it up properly.
	COPY		%FP		*%SP 				; %FP = pFP
	ADDUS		%SP		%SP		8               ; Pop pFP / ra

	;; This is where the code is currently breaking:
	COPY		%G5		*+_static_kernel_error_main_returned
	HALT

RAM_too_small:
	;; Set an error code and halt.
	COPY		%G5		*+_static_kernel_error_small_RAM
	HALT
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Procedure: main
;;; Callee preserved registers:
;;;   [None] This procedure never returns, so don't bother with preservation.
;;; Parameters:
;;; Caller preserved registers:
;;;   [%FP + 0]: FP
;;; Return address:
;;;   [%FP + 4]
;;; Return value:
;;;   [None]
;;; Locals:

_procedure_main:

	;; YOUR CODE HERE: Write code that initializes the kernel and executes the first user program.

	JUMP +_procedure_initialize_interrupt_buffer
	

_continue_main_process_1:

	JUMP +_procedure_initialize_trap_table

_continue_main_process_2:


_procedure_load_next_user_program:	
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_banner_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12


	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_msg1
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12


	SUBUS		%SP		%SP		4
	SUBUS		%SP		%SP		20
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		*+_static_ROM_device_code
	ADDUS		%G4		%FP		8
	COPY		*%G4		*+_static_current_user_program_pointer
	ADDUS		%G4		%FP		12
	CALL		+_procedure_find_device		*%G4
	ADDUS		%G4		%FP		4
	COPY		%G4		*%G4
	BEQ		+_main_fail	%G4		0
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		20
	ADDUS		%G3		%FP		-4
	COPY		*%G3		%G4
	COPY 		%G3 		*%G3

	NOOP
	
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_end_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_msg2
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12


	SUBUS		%SP		%SP		16
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		%G3
	ADDUS		%G4		%FP		8
	COPY		*%G4		+_static_kernel_limit
	ADDUS		%G4		%FP		12
	CALL		+_procedure_copy_user_program	*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		16

	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_end_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	

	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_msg3
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12


	;; Increment the user program counter
	ADDUS		*+_static_current_user_program_pointer		*+_static_current_user_program_pointer		1

	COPY		%G4		+_static_kernel_limit
	JUMPMD		*%G4		2

	ADDUS		%G0		%FP		8
	JUMP		*%G0
	
;;; ================================================================================================================================

_main_fail:
	
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_abort_msg
	ADDUS 		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	;; A marker to help identify this point in code
	NOOP
	HALT


;;; ================================================================================================================================	
;;; Procedure: find_device
;;; Callee preserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G2
;;;   [%FP - 16]: G4
;;; Parameters:
;;;   [%FP + 4]: The device type to find.
;;;   [%FP + 8]: The instance of the given device type to find (e.g., the 3rd ROM).
;;; Caller preserved registers:
;;;   [%FP + 0]:  FP
;;; Return address:
;;;   [%FP + 12]
;;; Return value:
;;;   [%FP + 16]: If found, a pointer to the correct device table entry; otherwise, null.
;;; Locals:
;;;   %G0: The device type to find (taken from parameter for convenience).
;;;   %G1: The instance of the given device type to find. (from parameter).
;;;   %G2: The current pointer into the device table.

_procedure_find_device:

	;; Prologue: Move FP to mark the separation of subframes.
	COPY		%FP		%SP
	
	;; Preserve the registers used on the stack.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G2
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4
	
	;; Initialize the locals.
	ADDUS		%G0		%FP		4
	COPY		%G0		*%G0
	ADDUS		%G1		%FP		8
	COPY		%G1		*%G1
	COPY		%G2		*+_static_device_table_base
	
find_device_loop_top:

	;; End the search with failure if we've reached the end of the table without finding the device.
	BEQ		+find_device_loop_failure	*%G2		*+_static_none_device_code

	;; If this entry matches the device type we seek, then decrement the instance count.  If the instance count hits zero, then
	;; the search ends successfully.
	BNEQ		+find_device_continue_loop	*%G2		%G0
	SUB		%G1				%G1		1
	BEQ		+find_device_loop_success	%G1		0
	
find_device_continue_loop:	

	;; Advance to the next entry.
	ADDUS		%G2			%G2		*+_static_dt_entry_size
	JUMP		+find_device_loop_top

find_device_loop_failure:

	;; Set the return value to a null pointer.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			0			; rv = null
	JUMP		+find_device_return

find_device_loop_success:

	;; Set the return pointer into the device table that currently points to the given iteration of the given type.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			%G2			; rv = &dt[<device>]
	;; Fall through...
	
find_device_return:

	;; Epilogue: Restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G2		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%FP		%FP		12 	; %FP = &ra
	NOOP
	NOOP
	JUMP		*%FP
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Procedure: print
;;; Callee preserved registers:
;;;   [%FP - 4]: G0
;;;   [%FP - 8]: G3
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   [%FP + 4]: A pointer to the beginning of a null-terminated string.
;;; Caller preserved registers:
;;;   [%FP + 0]: FP
;;; Return address:
;;;   [%FP + 8]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0: Pointer to the current position in the string.
	
_procedure_print:

	;; Prologue: Move FP to mark the separation of subframes.
	COPY		%FP		%SP
	
	;; Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G3
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; Call prologue: If not yet initialized, set the console base/limit statics.
	BNEQ		+print_init_loop	*+_static_console_base		0
	SUBUS		%SP		%SP		8		; Push ra / rv
	SUBUS		%SP		%SP		4 		; Push arg[1]
	COPY		*%SP		1				; Find the 1st device of the given type.
	SUBUS		%SP		%SP		4		; Push arg[0]
	COPY		*%SP		*+_static_console_device_code	; Find a console device.
	SUBUS		%SP		%SP		4 		; Push pFP
	COPY		*%SP		%FP
	ADDUS		%FP		%SP		12		; %FP = &ra
	CALL		+_procedure_find_device		*%FP
	;; Call epilogue
	COPY		%FP		*%SP		   		; %FP = pFP
	ADDUS		%SP		%SP		16		; Pop pFP / arg[0,1] / ra
	COPY		%G4		*%SP				; %G4 = rv = &dt[console]
	ADDUS		%SP		%SP		4		; Pop rv

	;; Panic if the console was not found.
	BNEQ		+print_found_console	%G4		0
	COPY		%G5		*+_static_kernel_error_console_not_found
	HALT
	
print_found_console:	
	ADDUS		%G3		%G4		*+_static_dt_base_offset  ; %G3 = &console[base]
	COPY		*+_static_console_base		*%G3			  ; Store static console[base]
	ADDUS		%G3		%G4		*+_static_dt_limit_offset ; %G3 = &console[limit]
	COPY		*+_static_console_limit		*%G3			  ; Store static console[limit]
	
print_init_loop:	

	;; Loop through the characters of the given string until the null character is found.
	ADDUS		%G0		%FP		4 		; %G0 = &arg[0]
        COPY		%G0		*%G0				; %G0 = str_ptr
print_loop_top:
	COPYB		%G4		*%G0 				; %G4 = current_char

	;; The loop should end if this is a null character
	BEQ		+print_loop_end	%G4		0

	;; Scroll without copying the character if this is a newline.
	COPY		%G3		*+_static_newline_char		; %G3 = <newline>
	BEQ		+print_scroll_call	%G4	%G3

	;; Assume that the cursor is in a valid location.  Copy the current character into it.
	;; The cursor position c maps to buffer location: console[limit] - width + c
	SUBUS		%G3		*+_static_console_limit	*+_static_console_width	   ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column		   ; %G3 = console[limit] - width + c
	COPYB		*%G3		%G4						   ; &(height - 1, c) = current_char
	
	;; Advance the cursor, scrolling if necessary.
	ADD		*+_static_cursor_column	*+_static_cursor_column		1	; c = c + 1
	BLT		+print_scroll_end	*+_static_cursor_column	*+_static_console_width	; Skip scrolling if c < width
	;; Fall through...
	
print_scroll_call:
	;; Call prologue.
	SUBUS		%SP		%SP		8				; Push pFP / ra
	COPY		*%SP		%FP						; pFP = %FP
	ADDUS		%FP		%SP		4				; %FP = &ra
	CALL		+_procedure_scroll_console	*%FP
	;; Call epilogue.
	COPY		%FP		*%SP 						; %FP = pFP
	ADDUS		%SP		%SP		8				; Pop pFP / ra

print_scroll_end:
	;; Place the cursor character in its new position.
	SUBUS		%G3		*+_static_console_limit		*+_static_console_width ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column	        ; %G3 = console[limit] - width + c	
	COPY		%G4		*+_static_cursor_char				        ; %G4 = <cursor>
	COPYB		*%G3		%G4					        ; console@cursor = <cursor>
	
	;; Iterate by advancing to the next character in the string.
	ADDUS		%G0		%G0		1
	JUMP		+print_loop_top

print_loop_end:
	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G3		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%FP		%FP		8 		; %FP = &ra
	NOOP
	JUMP		*%FP
;;; ================================================================================================================================


;;; ================================================================================================================================
;;; Procedure: scroll_console
;;; Description: Scroll the console and reset the cursor at the 0th column.
;;; Callee reserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   <none>
;;; Caller preserved registers:
;;;   [%FP + 0]:  FP
;;; Return address:
;;;   [%FP + 4]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0:  The current destination address.
;;;   %G1:  The current source address.

_procedure_scroll_console:

	;; Prologue: Move FP to mark the separation of subframes.
	COPY		%FP		%SP

	;; Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; Initialize locals.
	COPY		%G0		*+_static_console_base			   ; %G0 = console[base]
	ADDUS		%G1		%G0		*+_static_console_width	   ; %G1 = console[base] + width

	;; Clear the cursor.
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	ADDUS		%G4		%G4		*+_static_cursor_column			; %G4 = console[limit] - width + c
	COPYB		*%G4		*+_static_space_char					; Clear cursor.

	;; Copy from the source to the destination.
	;;   %G3 = DMA portal
	;;   %G4 = DMA transfer length
	ADDUS		%G3		8		*+_static_device_table_base ; %G3 = &controller[limit]
	SUBUS		%G3		*%G3		12                          ; %G3 = controller[limit] - 3*|word| = &DMA_portal
	SUBUS		%G4		*+_static_console_limit	%G0 		    ; %G4 = console[base] - console[limit] = |console|
	SUBUS		%G4		%G4		*+_static_console_width     ; %G4 = |console| - width

	;; Copy the source, destination, and length into the portal.  The last step triggers the DMA copy.
	COPY		*%G3		%G1 					; DMA[source] = console[base] + width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	COPY		*%G3		%G0 					; DMA[destination] = console[base]
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		%G4 					; DMA[length] = |console| - width; DMA trigger

	;; Perform a DMA transfer to blank the last line with spaces.
	SUBUS		%G3		%G3		8 			; %G3 = &DMA_portal
	COPY		*%G3		+_string_blank_line			; DMA[source] = &blank_line
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	SUBUS		*%G3		*+_static_console_limit	*+_static_console_width	; DMA[destination] = console[limit] - width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		*+_static_console_width			; DMA[length] = width; DMA trigger
	
	;; Reset the cursor position.
	COPY		*+_static_cursor_column		0			                ; c = 0
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	COPYB		*%G4		*+_static_cursor_char				   	; Set cursor.
	
	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%FP		%FP		4 		; %FP = &ra
	NOOP
	JUMP		*%FP
;;; ================================================================================================================================


	
;;; ================================================================================================================================
_procedure_initialize_interrupt_buffer:
	SETIBR +_static_id_base
	JUMP +_continue_main_process_1
	
_procedure_initialize_trap_table:
	;; Set the trap table address
	SETTBR +_static_trap_table
	
	;; Copy methods to values here

	;; Copy invalid address handler
	COPY		%G0		+_procedure_handle_invalid_address
	COPY		%G1		+_static_invalid_address
	COPY		*%G1		%G0

	;; Copy invalid register handler
	COPY		%G0		+_procedure_handle_invalid_register
	COPY		%G1		+_static_invalid_register
	COPY		*%G1		%G0


	;; Copy bus error handler
	COPY		%G0		+_procedure_handle_bus_error
	COPY		%G1		+_static_bus_error
	COPY		*%G1		%G0
	

	;; Copy clock alarm handler
	COPY		%G0		+_procedure_handle_clock_alarm
	COPY		%G1		+_static_clock_alarm
	COPY		*%G1		%G0

	;; Copy divide by zero handler
	COPY		%G0		+_procedure_handle_divide_by_zero
	COPY		%G1		+_static_divide_by_zero
	COPY		*%G1		%G0

	;; Copy overflow handler
	COPY		%G0		+_procedure_handle_overflow
	COPY		%G1		+_static_overflow
	COPY		*%G1		%G0

	;; Copy permission violation hander
	COPY		%G0		+_procedure_handle_permission_violation
	COPY		%G1		+_static_permission_violation
	COPY		*%G1		%G0

	;; Copy invalid shift amount handler
	COPY		%G0		+_procedure_handle_invalid_shift_amount
	COPY		%G1		+_static_invalid_shift_amount
	COPY		*%G1		%G0

	;; Copy system call handler
	COPY		%G0		+_procedure_handle_system_call
	COPY		%G1		+_static_system_call
	COPY		*%G1		%G0

	;; Return to the main process
	JUMP +_continue_main_process_2

;;; Placeholder Debugging: Using count of NOOP commands as an enum	
_procedure_handle_invalid_address:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_invalid_address_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	HALT

_procedure_handle_invalid_register:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_invalid_register_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	HALT

_procedure_handle_bus_error:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_bus_error_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	HALT

_procedure_handle_clock_alarm:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_clock_alarm_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	HALT

_procedure_handle_divide_by_zero:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_divide_by_zero_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	HALT

_procedure_handle_overflow:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_overflow_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	HALT

_procedure_handle_permission_violation:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_permission_violation_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	HALT

_procedure_handle_invalid_shift_amount:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_invalid_shift_amount_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	HALT

_procedure_handle_system_call:

	;; System call is stored in register 0: check whether program exited normally
	BEQ		+_system_call_normal		%G0		*+_static_syscall_exit_code_normal

	;; Print error message if exit code was not zero
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_system_call_error_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12

	;; Exit if the system call does not equal zero
	HALT

_system_call_normal:
	SUBUS		%SP		%SP		12
	COPY		*%SP		%FP
	COPY		%FP		%SP
	ADDUS		%G4		%FP		4
	COPY		*%G4		+_string_system_call_normal_msg
	ADDUS		%G4		%FP		8
	CALL		+_procedure_print		*%G4
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12
	JUMP		+_procedure_load_next_user_program
	

_procedure_copy_user_program:

	ADDUS		%G4		%FP		4
	ADDUS		%G0		*%G4		*+_static_dt_base_offset
	COPY		%G0		*%G0
	ADDUS		%G2		*%G4		*+_static_dt_limit_offset
	COPY		%G2		*%G2
	SUBUS		%G2		%G2		%G0
	ADDUS		%G1		%FP		8
	COPY		%G1		*+_static_kernel_limit
	
	COPY		%G3		0
	;; Initializing the loop counter
	
_copy_user_program_loop:
	ADD		%G3		%G3		1

	COPYB		*%G1		*%G0

	ADDUS		%G0		%G0		1
	ADDUS		%G1		%G1		1
	NOOP
	BLT		+_copy_user_program_loop	%G3		%G2

finished_copying_user_program:
	ADDUS		%G4		%FP		12
	JUMP		*%G4
	
;;; ================================================================================================================================

	
;;; ================================================================================================================================
	
	.Numeric

	;; A special marker that indicates the beginning of the statics.  The value is just a magic cookie, in case any code wants
	;; to check that this is the correct location (with high probability).
_static_statics_start_marker:	0xdeadcafe

	;; Device table location and codes.
_static_device_table_base:	0x00001000
_static_dt_entry_size:		12
_static_dt_base_offset:		4
_static_dt_limit_offset:	8
_static_none_device_code:	0
_static_controller_device_code:	1
_static_ROM_device_code:	2
_static_RAM_device_code:	3
_static_console_device_code:	4

	;; Error codes.
_static_kernel_error_RAM_not_found:	0xffff0001
_static_kernel_error_main_returned:	0xffff0002
_static_kernel_error_small_RAM:		0xffff0003	
_static_kernel_error_console_not_found:	0xffff0004
_static_kernel_error_unimplemented:	0xffff00ff
	
	;; Constants for printing and console management.
_static_console_width:		80
_static_console_height:		24
_static_space_char:		0x20202020 ; Four copies for faster scrolling.  If used with COPYB, only the low byte is used.
_static_cursor_char:		0x5f
_static_newline_char:		0x0a

	;; Other constants.
_static_min_RAM_KB:		64
_static_bytes_per_KB:		1024
_static_bytes_per_page:		4096	; 4 KB/page
_static_kernel_KB_size:		32	; KB taken by the kernel.

	;; Statically allocated variables.
_static_cursor_column:		0	; The column position of the cursor (always on the last row).
_static_RAM_base:		0
_static_RAM_limit:		0
_static_console_base:		0
_static_console_limit:		0
_static_kernel_base:		0
_static_kernel_limit:		0

	;; Trap Table
_static_trap_table:
_static_invalid_address:	0
_static_invalid_register:	0
_static_bus_error:		0
_static_clock_alarm:		0
_static_divide_by_zero:		0
_static_overflow:		0
_static_invalid_instruction:	0
_static_permission_violation:	0
_static_invalid_shift_amount:	0
_static_system_call:		0

_static_id_base:	0
			0

	;; User Program Variables
_static_current_user_program_pointer:	3
_static_syscall_exit_code_normal:		0x00000000
;;; ================================================================================================================================

;;; ================================================================================================================================





	
;;; ================================================================================================================================


;;; ================================================================================================================================
	.Text

	;; Error Messages
_string_invalid_address_msg:	"ERROR: Invalid Address. Halting the program"
_string_invalid_register_msg:	"ERROR: Invalid Register. Halting the program."
_string_bus_error_msg:		"ERROR: Bus Error. Halting the program"
_string_clock_alarm_msg:	"Clock alarm. Halting the program"
_string_divide_by_zero_msg:	"ERROR: Divided by zero. Halting program"
_string_overflow_msg:		"ERROR: Arithmetic overflow. Halting the program"
_string_invalid_instruction_msg:	"ERROR: Invalid instruction. Halting the program"
_string_permission_violation_msg:	"ERROR: Permission violation. Halting the program"
_string_invalid_shift_amount_msg:	"ERROR: Invalid arithmetic bit shift. Halting the program"
_string_system_call_normal_msg:	"System call. Exit Code 0\n"
_string_system_call_error_msg:	"ERROR: System call. Unrecognized exit code. Halting the program."
_string_banner_msg:	"k-System kernel\n"
_string_stage1_msg:	"Searching for user program"
_string_copyright_msg:	"Scott F. H. Kaplan / sfkaplan@cs.amherst.edu\n"
_string_done_msg:	"done.\n"
_string_abort_msg:	"failed!  Halting now.\n"
_string_blank_line:	"                                                                                "
_string_msg1:		"Searching for the user program in ROM\n"
_string_msg2:		"Copying user program into RAM\n"
_string_msg3:		"Vectoring into the user program\n"
_string_end_msg:	"Process complete\n"
;;; ================================================================================================================================
