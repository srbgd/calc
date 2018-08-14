#!/bin/bash

as --64 main.s -o main.o
as --64 append_brackets.s -o append_brackets.o
as --64 tokenize.s -o tokenize.o
as --64 append_token.s -o append_token.o
as --64 append_entry.s -o append_entry.o
as --64 erase_token.s -o erase_token.o
as --64 get_length.s -o get_length.o
as --64 make_expretion.s -o make_expretion.o
as --64 parse.s -o parse.o
as --64 set_type.s -o set_type.o
as --64 reduce.s -o reduce.o
as --64 execute.s -o execute.o
as --64 get_priority.s -o get_priority.o
as --64 get_next_operator.s -o get_next_operator.o
as --64 shift_entries.s -o shift_entries.o
ld -o calc -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -lc main.o append_brackets.o tokenize.o append_token.o append_entry.o erase_token.o get_length.o make_expretion.o parse.o set_type.o reduce.o execute.o get_priority.o get_next_operator.o shift_entries.o
