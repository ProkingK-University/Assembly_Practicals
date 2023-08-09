main: get_pin.o calculate_account.o
	ld -o main get_pin.o calculate_account.o

get_pin.o: get_pin.asm
	yasm -f elf64 -g dwarf2 -l get_pin.lst get_pin.asm

calculate_account.o: calculate_account.asm
	yasm -f elf64 -g dwarf2 -l calculate_account.lst calculate_account.asm

clean:
	rm -f *.o *.lst main

run:
	./main
