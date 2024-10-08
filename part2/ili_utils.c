#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
// maybe volatile?
asm volatile("sidt %0;"
			 :"=m"(*idtr)
			 :
			 :
			 );
// </STUDENT FILL>
}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
asm volatile("lidt %0;"
			 :
			 :"m"(*idtr)
			 :
			 );
// <STUDENT FILL>
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
	gate->offset_low=addr;
	gate->offset_middle=addr >> 16;
	gate->offset_high=addr >> 32;
// </STUDENT FILL>
}

unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
/* NOTE:
 * remember how the struct looks in 64
 * 16-low
 * 16-middle
 * 32 high
 */ 
 unsigned long my_address=gate->offset_high;
 my_address=my_address << 16; //place for middle
 my_address+=gate->offset_middle;
 my_address=my_address << 16; //place for low
 my_address+=gate->offset_low;
 return my_address;
 
// </STUDENT FILL>
}
