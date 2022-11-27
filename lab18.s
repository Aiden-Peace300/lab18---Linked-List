//******************************************************************************//
// Name: Aiden Peace
// Class: CS3B
// Assignment: lab18 Linked list
// Date: November 17, 2022 at 8:00 PM
// lab18:
// this is the first assignment in which we will need to implement a linked list
// For simplicity, we are going to forego getting the input from the user and use
// five static strings to simulate that interaction from the user. You are still
// required to copy these "static" strings to the heap.
//*****************************************************************************//

	.equ	MAXKB,	1024		// max for keyboard size

.data
	kbBuf:		.skip		MAXKB
	tempptr:	.quad		0
	head:		.quad		0		// NULL
	tail:		.quad		0		// NULL
	str1:  		.asciz 		"The Cat in the Hat"
	str2:  		.asciz 		"\n"
	str3:  		.asciz  	"By Dr. Seuss"
	str4:  		.asciz  	"\n"
	str5:  		.asciz 		"The sun did not shine."
	szPrompt:	.asciz		" "
	cLF:		.byte		0xA		// newline
	newNode:	.quad		0		// NULL
	currentNode:	.quad		0		// NULL

.global _start		// Provide program starting address to linker
.text
_start:

	// add strings
	LDR	X0, =str1
	BL	insertLast
	LDR	X0, =str2
	BL	insertLast
	LDR	X0, =str3
	BL	insertLast
	LDR	X0, =str4
	BL	insertLast
	LDR	x0, =str5
	BL	insertLast

	// ------- TRAVERSE THE LL ------ //
	BL	traverse

exit:
	// Setup the parameters to exit the program
	// and then call Linux to do it.
	MOV	X0, #0		// Use 0 return code
	MOV	X8, #93		// Service cmd code 93 terminates this program
	SVC	0		// Call linux to terminate the program

insertLast:
	STR	X30, [SP, #-16]!	// PUSH LR
	
	MOV	X20, X0		// copy string address to x20

	// newNode = new nodeType; // create the new node
	MOV	X0, #16
	BL	malloc

	LDR 	X1,=newNode
	STR	X0,[X1]

	// ------------------ END CREATE NEW NODE -----------------//
	// Make a copy kbBuf into a newly malloc'd string
	MOV	X0, X20
	BL	String_copy

	LDR	X1,=newNode
	LDR	X1,[X1]
	STR	X0,[X1]

	// newNode->next = nullptr;	// setthe link first of newNode to nullptr
	MOV	X3, #0
	ADD	X1, X1, #8		// MakeX1 -> NEXT FIELD
	STR	X3, [X1]		// Store NULL into the NEXT FIELD

	// ------------------- THE INSERTION PART ------------------- //

	// If (head == nullptr) 	// if the list is empty, newNode is both the first and last node
	LDR	X0,=head
	LDR	X0,[X0]
	CBNZ	X0,NOTEMPTY		// option #1

	LDR	X1, =newNode
	LDR	X1,[X1]

	LDR	X0, =head
	STR	X1,[X0]			// head = newNode
	LDR	X0,=tail
	STR	X1,[X0]			// tail = newNode

	B	insertLastEnd

NOTEMPTY:
	// else 			// the list is not empty, insert newNode after last
	// {
	// tail->next = newNode;	// insert newNode after next
	LDR	X0,=tail		// X0 = address of the tail variable
	LDR	X0,[X0]			// X0 now has the address to the last node
	LDR	X1,=newNode		// X1 has the address of the newNode variable
	LDR 	X1,[X1]			// X1 now has the address of the new node

	STR	X1, [X0,#8]		// tail->next = newNode

	// tail = newNode;		// made tail point to the actual last node in the list
	LDR	X0, =tail		// reload the tail variable
	STR	X1,[X0]

insertLastEnd:
	LDR	X30, [SP], #16		// POP
	RET

// View All strings
traverse:
	STR	X30, [SP, #-16]!	// PUSH LDR

	LDR	X0, =head		// X0 = currentNode
	LDR	X0,[X0]			// X0 = *X0

	// cuurentNode = head
	LDR	X1,=currentNode
	STR	X0,[X1]

traverse_top:

	// While (currentNode != NULL)
	CMP	X0,#0
	B.EQ	traverse_end

	LDR	X0,[X0]			// X0 = **currentNode
	BL	putstring

	LDR	X0,=cLF
	BL	putch

	// currentNode = currentNode->next;
	LDR	X1,=currentNode
	LDR	X1,[X1]
	ADD	X1, X1, #8
	LDR	X1,[X1]			// Now pointing to the next node

	LDR	X0,=currentNode
	STR	X1,[X0]

	MOV	X0,X1

	B	traverse_top

traverse_end:

	LDR	X30, [SP], #16		// POP
	RET

.end
