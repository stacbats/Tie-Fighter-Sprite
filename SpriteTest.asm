BasicUpstart2(Enter)

* =$c000 "Prog Start"               // SYS 49152

// LABELS ***
    .var CLEARSCREEN    = $e544     // Kernal for Clearing Screen
    .var SPENA          = $d015     // Enable Sprite
    .var SPOX           = $d000     // Register, Sprite 0 Pos x          
    .var SPOY           = $d001     // Register, Sprite 0 Pos y 

// MACROS ***
.macro SCREEN_UPDATE_A(colour){
    lda #colour // Enter your colour for the below
    sta $d020   // Border
    sta $d021   // Screen
}

Enter:
    SCREEN_UPDATE_A(0)              // Macro to change screen to desired colour
    jsr CLEARSCREEN                 // Kernal routine   (- print chr$(147))  

    lda #$01                        // Load A with 1 (for our Sprite (A=1))
    sta SPENA                       // Store in Address (Enable the sprite( poke53269,1)


    lda #$c0                        //Sprite Pointer  (192*64 = 12288 = $3000 for our sprites)
    sta $07f8                       //Memory Register (Poke 2040,192) 


    lda #$20                        //Load A with value (Our place on screenA=144
    sta SPOX                        //Store it in address ( poke53248,144 ( our sprite X position)
    lda #$35
    sta SPOY                        //Store it in address ( poke53248,144 ( our sprite Y position)

    lda#$0                          // *****   Load A with value  NEW
    sta$d010                        // *****   Store it in address  NEW

MOVESP:
    ldx $d000                       //  Load Address into X (X= peek(53248)
    ldy $d001                       //  Load Address into Y (Y= peek(53249)

LOOP:                               // (goto)

    lda #50                        // Load A with value (Delaying
    cmp $d012 //raster
    bne LOOP

    sty SPOY                        // Store and increase
    inx                             // Increment the value (X=X+1)

    stx SPOX
    lda $d010
    and #%00000001

    bne!CheckXPos+
    ldx SPOX 
    bne LOOP
    lda #$01
    sta $d010

    jmp MOVESP

!CheckXPos:
    ldx SPOX
    cpx #$60
    bne MOVESP
    lda #$0
    sta $d010
    sta SPOX
    jmp MOVESP

 
*=$3000 "Sprite Bin"
.import binary  "TIEFIGHT - Sprites.bin"