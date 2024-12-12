This project implements a number-guessing game in assembly language. The program utilizes basic assembly programming constructs, including calling library functions, handling input/output, and implementing control flows.

Features
Random Number Generation:
The program generates a random number using a user-provided seed.

Guessing Logic:
The user attempts to guess the number. After each guess:

If incorrect, the program informs the user.
In "Easy Mode," the program provides a hint whether the guess was above or below the target number.
Double or Nothing:
If the user guesses correctly, they can choose to continue to another round. In subsequent rounds:

The number range doubles.
The seed is multiplied by 2 to generate a new random number.
Game Termination:
The game ends:

After the user chooses not to continue after winning a round.
If the user exceeds the maximum number of incorrect guesses (5).
