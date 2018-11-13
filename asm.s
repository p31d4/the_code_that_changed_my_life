        ;IAR Assembler Reference Guide        ;http://peterdn.com/post/e28098Hello-World!e28099-in-ARM-assembly.aspx
		
	;extended loader format ELF file
		
	PUBLIC histrgb	;PUBLIC - Exports symbols to other modules
        EXTERN img_in	; EXTERN - Imports an external symbol.
		
		
        ;SECTION segment :type [flag] [(align)]
        ;SECTION - Begins a section.
        ;section - The name of the section.
        ;type - The memory type, which can be either CODE, CONST, or DATA.
        ;align - The power of two to which the address should be aligned, in most cases in the range 0 to 30. The default align value is 0
        SECTION .text : CODE (2)
        THUMB	;THUMB - Interprets subsequent instructions as Thumb execution-mode instructions.
histrgb:
        ;//R0 : dim_x
        ;//R1 : dim_y
        ;//R2 : img_in
        ;//R3 : img_out	
        MUL	R0, R0, R1		;//Tamanho da imagem
        PUSH	{R0-R12,LR}
        
        //CBZ     R0, END_OF_THE_WORLD

        ;Zera R5
        MOVW	R5,  #0
        MOVW	R6,  #0
        MOVW	R7,  #0
        MOVW	R8,  #0
        MOVW	R9,  #0
        MOVW	R10, #0
        MOVW	R11, #0
        MOVW	R12, #0
        ;Tamanho do vetor de saida
        MOVW	R4, #0x300                      //768
        
        MOV     R1, R3                          //Endereco do histograma de saida

        ;Zera o vetor de saida
CLEAR_HIST_OUT:
	STMIA   R1!, {R5 - R12}
        //STR     R4, [R6, R7, LSL #2]            //Guarda o conteudo de R4 em R6+(R7*4)

        SUB     R4, R4, #8
	CBZ     R4, MAKE_HIST
        B       CLEAR_HIST_OUT
        
MAKE_HIST:

//        MOV           R7, #3
//        MUL		R1, R1, R7

LOOP:
        LDMIA   R2!, {R4 - R12}
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R4, #0, #8          //Carrega em R1 os primeiro byte de R4 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R14 em R3+(R1*4)
        
        UBFX    R1, R4, #8, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R4, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R4, #24, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R5, #0, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R5, #8, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R5, #16, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R5, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R6, #0, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R6, #8, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R6, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R6, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
         //---------------------------------------------------------------------------
        
        UBFX    R1, R7, #0, #8          //Carrega em R1 os primeiro byte de R4 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R4 em R3+(R1*4)
        
        UBFX    R1, R7, #8, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R7, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R7, #24, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R8, #0, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R8, #8, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R8, #16, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R8, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R9, #0, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R9, #8, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R9, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R9, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
         //---------------------------------------------------------------------------
        
        UBFX    R1, R10, #0, #8          //Carrega em R1 os primeiro byte de R4 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R4 em R3+(R1*4)
        
        UBFX    R1, R10, #8, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R10, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R10, #24, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R11, #0, #8          //Carrega em R1 os segundo byte de R5 (G)        
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R11
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R11, #8, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R11, #16, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R11, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        //---------------------------------------------------------------------------
        
        UBFX    R1, R12, #0, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R12, #8, #8         //Carrega em R1 os quarto byte de R5 (R)
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R12, #16, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #256            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)
        
        UBFX    R1, R12, #24, #8         //Carrega em R1 os terceiro byte de R5 (B)
        ADDS    R1, R1, #512            //
        LDR	R14, [R3, R1, LSL #2]   //carrega valor R3+(R1*4) em R14
        ADD	R14, R14, #1            //soma 1 ao valor q estava guardado em R14
        STR     R14, [R3, R1, LSL #2]	//Guarda o q esta em R5 em R3+(R1*4)

        SUB	 R0, R0, #12

////------------------------------------------------------------------------------- R
//        LDRB     R4, [R2], #1                   //carrega conteudo apontado por R2 em R4 (byte R), e atualiza R2
//        LDR	 R5, [R3, R4, LSL #2]           //carrega valor R3+(R4*4) em R5
//                                                //– #off deve ser *4 para LDR e *2 para LDRH  <<<<< slide do professor
//    
//        ADD	 R5, R5, #1                     //soma 1 ao valor q estava guardado em R5
//        STR      R5, [R3, R4, LSL #2]		//Guarda o q esta em R5 em R3+(R4*4)	
////-------------------------------------------------------------------------------
//
////------------------------------------------------------------------------------- G
//	LDRB     R4, [R2], #1                   //carrega conteudo apontado por R2 em R4 (byte G), e atualiza R2
//        ADDS     R4, R4, #256             //R4 = 1024 + (R4*4)
//
//	//ADD      R4, R4, #1024   ;// 4X256
//        //LDR	   R5, [R3, R4, LSL #2]
//	LDR	 R5, [R3, R4, LSL #2]                   //carrega valor (R3 + R4 * 2) em R5
//	ADD      R5, R5, #1
//        STR      R5, [R3, R4, LSL #2]
////-------------------------------------------------------------------------------
//
////------------------------------------------------------------------------------- B
//        LDRB     R4, [R2], #1
//        ADDS     R4, R4, #512
//
//	//ADD      R4, R4, #2048  //8X256
//	LDR	 R5, [R3, R4, LSL #2]       //carrega valor (R3 + R4) em R5
//	ADD      R5, R5, #1
//        STR      R5, [R3, R4, LSL #2]     
////--------------------------------------------------------------------------------B		  
//        SUB	 R1, R1, #1

	CBZ      R0, END_OF_THE_WORLD
		  
	B	 LOOP
          
END_OF_THE_WORLD:
        POP     {R0-R12,LR}
	
        BX      LR

        END
        
//LDR     R8, [R10]              ; Loads R8 from the address in R10.
//LDRNE   R2, [R5, #960]!        ; Loads (conditionally) R2 from a word
//                               ; 960 bytes above the address in R5, and
//                               ; increments R5 by 960
//STR     R2, [R9,#const-struc]  ; const-struc is an expression evaluating
//                               ; to a constant in the range 0-4095.
//STRH    R3, [R4], #4           ; Store R3 as halfword data into address in
//                               ; R4, then increment R4 by 4
//LDRD    R8, R9, [R3, #0x20]    ; Load R8 from a word 8 bytes above the
//                               ; address in R3, and load R9 from a word 9
//                               ; bytes above the address in R3
//STRD    R0, R1, [R8], #-16     ; Store R0 to address in R8, and store R1 to
//                               ; a word 4 bytes above the address in R8, 
//                               ; and then decrement R8 by 16.
//STR    R0, [R5, R1]         ; Store value of R0 into an address equal to
//                                ; sum of R5 and R1
//LDRSB  R0, [R5, R1, LSL #1] ; Read byte value from an address equal to
//                            ; sum of R5 and two times R1, sign extended it
//                            ; to a word value and put it in R0
//STR    R0, [R1, R2, LSL #2] ; Stores R0 to an address equal to sum of R1
//                            ; and four times R2.


