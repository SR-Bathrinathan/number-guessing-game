# Number Guessing Game

This is a simple number guessing game written in **Bash** that interacts with a **PostgreSQL** database to store user stats.

## Features
- Existing users game history is displayed before game.
- New users are added to database.
- The game generates a **random number between 1 and 1000**, and the user must guess it.
- The database stores:
  - **Total games played**
  - **Best game (fewest guesses taken to win)**
