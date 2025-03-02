#!/bin/bash

#number guessing game

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GAME() {
  RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))

  NUMBER_OF_GUESS=1

  echo $RANDOM_NUMBER

  echo -e "\nGuess the secret number between 1 and 1000:"

  read NUMBER_GUESS

  until (( $NUMBER_GUESS == RANDOM_NUMBER ))
  do
    if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
    elif [[ $NUMBER_GUESS -gt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
    elif [[ $NUMBER_GUESS -lt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
    fi
    read NUMBER_GUESS
    (( NUMBER_OF_GUESS += 1 ))
  done

  echo -e "\nYou guessed it in $NUMBER_OF_GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
}

echo -e "\n~~ Number Guessing Game ~~\n"

echo enter your username:

read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

#if user not there
if [[ -z $USER_ID ]]
then
  #then create user
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")
else
  echo "$($PSQL "SELECT games_played, best_game FROM users WHERE user_id = $USER_ID ;")" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

GAMES_PLAYED=$($PSQL "SELECT games_played FROM users where user_id = $USER_ID")
(( GAMES_PLAYED += 1 ))
UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE user_id = $USER_ID;")

GAME

BEST_GAME=$($PSQL "SELECT best_game FROM users where user_id = $USER_ID")
if [[ $BEST_GAME -lt $NUMBER_OF_GUESS ]]
then
  BEST_GAME_UPDATE_RESULT=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESS where user_id = $USER_ID;")
fi
