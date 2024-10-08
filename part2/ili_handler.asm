.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
  # what we need?
  # something like push_registers MACRO order? maybe similar to
  # lectures/tutorials? NOTE TO SELF look it up
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15
  pushq %rax
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rbp
  pushq %rsp

# prepare stuff for work
	movq $0, %rax # return value for functions
	movq $0 ,%rdi # first parameter for functions
	movq $0, %rdx # something that won't change when we call what_to_do
	# according to system V (and also need access to 8 bits from 8-15
	
	# get the opcode
	movq 120(%rsp), %rdx
	movq (%rdx), %rdx
	
	# what we do?
	# if start with starter check for lil endian?
	cmpb $0x0f, %dl
	jne only_one_byte_opcode # one byte
	
	# more than one, so two
	# set parameters for what_to_do
	movb %dh, %al # anyway %rax will be changed, it is just a temp now
	movq %rax, %rdi # system V conventions, %rdi is th first parameter
	call what_to_do
	
	# %rax got the result if zero then default
	testq %rax, %rax
	jz default_behaviour
	jmp my_actual_ili_handler_two_bytes # handle things our own way
	
only_one_byte_opcode:
	
	# same as before, but use 0-7 bits
	movb %dl, %al 
	movq %rax, %rdi
	call what_to_do
	testq %rax, %rax
	jz default_behaviour
	jmp my_actual_ili_handler_one_byte
	
my_actual_ili_handler_one_byte:
# put the result of waht to do in %rdi
# pop_back registers
# remember to move %rip

movq %rax, %rdi

popq %rsp
popq %rbp
popq %rsi
popq %rdx
popq %rcx
popq %rbx
popq %rax
popq %r15
popq %r14
popq %r13
popq %r12
popq %r11
popq %r10
popq %r9
popq %r8

addq $1, (%rsp) # it holds the return adress, we go over it
jmp my_ending

my_actual_ili_handler_two_bytes:
# put the result of waht to do in %rdi
# pop_back registers
# remember to move %rip

movq %rax, %rdi

popq %rsp
popq %rbp
popq %rsi
popq %rdx
popq %rcx
popq %rbx
popq %rax
popq %r15
popq %r14
popq %r13
popq %r12
popq %r11
popq %r10
popq %r9
popq %r8

addq $2, (%rsp) # it holds the return adress, we go over it
jmp my_ending

default_behaviour:
# we need to pop_back registers
# also, we need to go to the old handler
# oppisite from pushing them
  popq %rsp
  popq %rbp
  popq %rsi
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  
  jmp * old_ili_handler
  jmp my_ending # not needed, maybe remove
  
my_ending:
  iretq
