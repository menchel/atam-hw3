.global count_above

.section .text
count_above:

pushq %rbp
movq %rsp, %rbp
subq $72, %rsp
movq %rdi,-8(%rbp)
movq %rsi, -16(%rbp)
movq %rbx, -24(%rbp) # counter
movq %r12, -32(%rbp) # base adress for write
movq %r13, -40(%rbp) # current adress to write
movq %r14, -48(%rbp) # byte that we read
movq %r15, -56(%rbp) # file descriptor
movq %rsp, %r12 # keep adress to write
subq $40, %rsp


movq $0, %rbx # reset counter
# syscall open

call get_path
movq %rax, %rdi
movq $2, %rax
movq $0, %rsi
syscall

movq %rax, %rdi # the file descriptor
movq %rdi, %r15
movq %r12, %r13
READ_LOOP:

#read byte
# %rdi holds file descriptor
movq $0, %rax
movq %r13, %rsi
movq $1, %rdx
syscall

cmpq $0, %rax #EOF
je EOF_FOUND

movb (%r13), %r14b # byte to read
cmpb -8(%rbp), %r14b
je SEPERATOR_FOUND # we got seperator

# no seperator, proceed
END_OF_LOOP:
incq %r13
jmp READ_LOOP

SEPERATOR_FOUND:
# we got seperator, witch it with \0 as an end to the num
movb $0, (%r13)
movq %r12, %rdi
call atam_atol
movq %r12, %r13 # bring to start
movq %r15, %rdi # bring back the file descriptor

cmpq -16(%rbp), %rax
jle READ_LOOP
addq $1, %rbx
jmp READ_LOOP

EOF_FOUND:
# same as seperator just no need to update for next loop
movb $0, (%r13)
movq %r12, %rdi
call atam_atol
movq %r15, %rdi # bring back the file descriptor

cmpq -16(%rbp), %rax
jle CLOSE_FILE
addq $1, %rbx
jmp CLOSE_FILE
A:
CLOSE_FILE:
movq $3, %rax
syscall

movq %rbx, %rax # return the counter

# return all the registers
addq $40, %rsp # the reserved spot for the numbers, not needed anymore
movq %rbp, %rsp
popq %rbp
ret
   
