# Calc
A simple calculator created to deal with memory management in assembler during generating and reducing a syntax tree.

## Algorithm
1. Read a string and surround it with brackets.
2. Split the string into tokens skipping unrelated characters (e.g new line character or spaces).
3. Make a syntax tree from the tokens dynamically allocating memory for every node of the tree.
4. Solve the expression recursively reducing the tree and freeing memory after solving a subtree.

## Usage
Run `make.sh` to compile the source code.

Run `test.py` to check the correctness.

The absence of memory leaks can be checked with valgrind manually.

## Restrictions
The purpose wasn't to create an effective calculator therefore the functionality is very restricted. It supports only plus, minus and multiply operations for integer numbers. And there shouldn't be an operator followed by another operator therefore unary plus and minus should be surround with brackets. Also there is no error handling therefore incorrect input usually causes a fault.

## Examples of correct input
```
-1
2+2*2
2*(2+2)
((-13))-9+3
0*17-17+(7)*(19*19)
((13)+7+20)+(19*16*11-20)
(-8)+16*3-(20)*(2)*5+16+14*0-2*2-(2-13*13+5)*(9+15*11-((11))+17+7)
```
