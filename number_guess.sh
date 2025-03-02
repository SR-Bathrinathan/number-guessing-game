#!/bin/bash

#number guessing game

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

echo enter your username:

read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

#if user not there
if [[ -z $USER_ID ]]
then
  #then create user
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES($USERNAME)")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  echo "$($PSQL "SELECT games_played, best_game FROM users WHERE user_id = $USER_ID ;")" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
  done
fi