//*****************************************************************************
// Name: Aiden Peace
// Program: String_copy.s
// Class: CS 3B #19640
// Lab:  RASM3
// Date: 11/03/2022
//*****************************************************************************
//******************************************************************************//
// String_copy (CONTRACT):
// ****************************************************************************//
// Subroutine String_copy: malloc's enough bytes and copies the source string
// into the newly allocated string in X0.
//
// Pointed to by X0, returns an integer number which represents the number of
// characters (length) in a given string including white spaces.
// X0: Holds the address to the first byte of a valid C-String
// LR: Contains the return address
// Returned registers contents: Address of the first byte of newly copied string.
// All AAPCS registers are preserved.
// X1, X2, X3, and utilized and not preserved
//*****************************************************************************//
.data
.global String_copy
.text

String_copy:
        // AAPCS registers as preserved due to not being used
        STR X19, [SP, #-16]!    // PUSH
        STR X20, [SP, #-16]!    // PUSH
        STR X21, [SP, #-16]!    // PUSH
        STR X22, [SP, #-16]!    // PUSH
        STR X23, [SP, #-16]!    // PUSH
        STR X24, [SP, #-16]!    // PUSH
        STR X25, [SP, #-16]!    // PUSH
        STR X26, [SP, #-16]!    // PUSH
        STR X27, [SP, #-16]!    // PUSH
        STR X28, [SP, #-16]!    // PUSH
        STR X29, [SP, #-16]!    // PUSH

        // we have have preserved the LR due to BL MALLOC
        STR X30, [SP, #-16]!    // PUSH LR
        STR X0, [SP, #-16]!     // PUSH X0 on to the stack, saved the addresss of src

        // Get the String_length of Source to determain the number of
        // bytes needed for the new String (malloc'd)
        BL String_length        // branches to String_length()

        // X0 + 1 is the number of bytes needed to malloc for the copied C-String
        ADD X0, X0, #1          // +1 preserved space for null
        STR X0, [SP, #-16]!     // PUSH X0 onto the stack, saved length + 1

        BL malloc               // Make sure that we have preserved X19-0

        LDR X1, [SP], #16       // POPPED length of src string + 1
        LDR X2, [SP], #16       // POPPED & src string + 1
        MOV X3, X0              // Copy dest string address, used for copying

        // we need a do while loop
        // X1 points to first digit (leftmost) of srcStr
        // X2 has the number iterations (characters to copy)
        // X3 points to first digit (leftmost) of desString
 topLoop:

        CMP X1, #0              // while (count != 0)
        B.EQ botLoop            // {
        LDRB W4, [X2], #1       //      W4 = srcStr[count]
        STRB W4, [X3], #1       //      dstStr[count] = W4
        SUB X1, X1, #1          //      decrement the counter
        B topLoop               // }

botLoop:
        // POPPED IN REVERSE ORDER (LIFO)
        LDR X30, [SP], #16      // POP
        LDR X29, [SP], #16      // POP
        LDR X28, [SP], #16      // POP
        LDR X27, [SP], #16      // POP
        LDR X26, [SP], #16      // POP
        LDR X25, [SP], #16      // POP
        LDR X24, [SP], #16      // POP
        LDR X23, [SP], #16      // POP
        LDR X22, [SP], #16      // POP
        LDR X21, [SP], #16      // POP
        LDR X20, [SP], #16      // POP
        LDR X19, [SP], #16      // POP

        RET LR                  // Return to caller

.end                    // end segment
