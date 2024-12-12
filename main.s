#David Goldstein 331010835
.extern rand
.extern printf
.extern scanf
.extern srand
.extern fflush
.section .rodata
prompt_seed: .asciz "Enter configuration seed: "
prompt_guess: .asciz "What is your guess? "
prompt_incorrect: .asciz "Incorrect. "
prompt_win: .asciz "Double or nothing! Would you like to continue to another round? (y/n) "
prompt_easy: .asciz "Would you like to play in easy mode? (y/n) "
prompt_above: .asciz "Your guess was below the actual number ...\n"
prompt_below: .asciz "Your guess was above the actual number ...\n"
prompt_congratz: .asciz "Congratz! You won %d rounds!"
prompt_lose: .asciz "\nGame over, you lost :(. The correct answer was %d"
input_fmt: .asciz "%d"
input_char: .asciz "%c"

.section .data
random_number: .long 0
user_input: .long 0
rounds_won: .long 0
seed_value: .long 0
guss_input: .long 0
easy_mode: .long 0
count_lose: .long 0
take_char: .long 0
continuous_value: .long 0
range_random: .long 10
.section .text
.global main

main:

#we need rsp%16==0, so I sub 8

sub $8, %rsp

#print: Enter a seed value:

lea prompt_seed(%rip), %rdi
xor %rax, %rax
call printf

#take the number from the user

lea seed_value(%rip), %rsi
lea input_fmt(%rip), %rdi
xor %rax, %rax
call scanf

#clean the buffer with getchar

xor %rax, %rax
call getchar

#call function srand, this put the seed for the random number

movq seed_value(%rip),%rdi
call srand

#call rand function
#division the random number with range_random, take the module

call rand
movq range_random(%rip), %rcx
cqo
idiv %ecx
inc %edx
mov %edx, random_number

#print: Would you like to play in easy mode? (y/n)

lea prompt_easy(%rip), %rdi
xor %rax, %rax
call printf

# take the 'n' or 'y' from the user and go to the correct option

lea take_char(%rip), %rsi
lea input_char(%rip), %rdi
xor %rax, %rax
call scanf
xor %rax, %rax
call getchar

#if the user put y, go to easy mode else go to normal mode

cmpb $'y',take_char(%rip)
je easy_modeF
jmp normal_mode

easy_modeF:

#print "What is your guess?"

lea prompt_guess(%rip),%rdi
xor %rax, %rax
call printf

#take from the user the number

lea guss_input(%rip),%rsi
lea input_fmt(%rip),%rdi
xor %rax, %rax
call scanf
xor %rax, %rax
call getchar

#put the number from the user in exa and check if its the correct number

mov guss_input(%rip), %eax
cmp random_number(%rip), %eax

#if its correct number jump to function correct

je correct_guess

#if its not the number, print "incorrect"

lea prompt_incorrect(%rip),%rdi
xor %rax, %rax
call printf

#add 1 to count lose because it not thr correct number

mov count_lose(%rip), %al
inc %al
mov %al, count_lose(%rip)

#check if count lose==5 go to lose function

#if count lose<5 I check if the guss is below or above the number

cmp $5, %al
je lose_game
mov guss_input(%rip), %eax
cmp random_number(%rip), %eax
jl above_number
jg below_number



above_number:
lea prompt_above(%rip),%rdi
xor %rax, %rax
call printf
jmp easy_modeF

below_number:
lea prompt_below(%rip),%rdi
xor %rax, %rax
call printf
jmp easy_modeF


normal_mode:

#print

lea prompt_guess(%rip),%rdi
xor %rax, %rax
call printf

#take the guss number from the user

lea guss_input(%rip),%rsi
lea input_fmt(%rip),%rdi
xor %rax, %rax
call scanf
xor %rax, %rax
call getchar

#check if the guss is correct

mov guss_input(%rip), %eax
cmp random_number(%rip), %eax

#if its correct go to correct function

je correct_guess

#if its not the correct number print

lea prompt_incorrect(%rip),%rdi
xor %rax, %rax
call printf

#count_lose++

mov count_lose(%rip), %al
inc %al

#comper count_lose to 5

mov %al, count_lose(%rip)
cmp $5, %al

#if its 5 go to lose function, else continue this function

je lose_game
jmp normal_mode


lose_game:

#print the lose message

movb random_number(%rip), %al
movzbl %al, %esi
lea prompt_lose(%rip), %rdi
xor %rax, %rax
call printf

#without \n in the end of the string its not print so I use fflush function

mov $0, %rdi
xor %rax, %rax
call fflush
jmp end


correct_guess:

#mult the seed

mov seed_value(%rip),%eax
add %eax,%eax
mov %eax,seed_value(%rip)

#call srand with the new seed

mov seed_value(%rip),%rdi
call srand

#mult the range_random, the new random number will be between 1 to 2*N

mov range_random(%rip),%eax
add %eax,%eax
mov %eax,range_random(%rip)

#division the random number with user input, take the module

call rand
mov range_random(%rip), %rcx
cqo
idiv %ecx
inc %edx
mov %edx, random_number

#count_lose be 0 now because the user knew the correct number

movl $0,count_lose(%rip)

#count win plus 1, print if the user want to continue play

incl rounds_won(%rip)
lea prompt_win(%rip), %rdi
xor %rax, %rax
call printf

#take the answer

lea continuous_value(%rip), %rsi
lea input_char(%rip), %rdi
xor %rax, %rax
call scanf
xor %rax, %rax
call getchar

#check the answer, if no go to win function

cmpl $'n',continuous_value(%rip)
je win

#check what mode we go according the answer in the start

cmpl $'n', take_char(%rip)
je normal_mode
jmp easy_modeF


win:

#print pormat win and the number of win

lea prompt_congratz(%rip),%rdi
mov rounds_won(%rip),%esi
xor %rax,%rax
call printf

#without \n in the end of the string its not print so I use fflush function

mov $0, %rdi
xor %rax, %rax
call fflush
jmp end


end:
mov $60, %rax
xor %rdi, %rdi
syscall
