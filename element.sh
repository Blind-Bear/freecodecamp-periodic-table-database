#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Intro Prompt
  if [[ -z $1 ]]
  then
  echo "Please provide an element as an argument."

  else
# Read input
  INPUT=$1
  INPUT_FORMATTED=$(echo $INPUT | sed -E 's/^ *| *$//g')

  # If input is number
    if [[ $INPUT_FORMATTED =~ ^[0-9]+$ ]]
    then
    ATOMIC_NUMBER_SEARCH=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT_FORMATTED")

    # If found set variable
      if ! [[ -z $ATOMIC_NUMBER_SEARCH ]]
      then
        FOUND_SEARCH=$ATOMIC_NUMBER_SEARCH

      fi
    fi
  # If input is <= 2 characters & not a number
    if ! [[ $INPUT_FORMATTED =~ [0-9] ]] && (( $(echo -n "$INPUT_FORMATTED" | wc -m) <= 2 ))
    then
    SYMBOL_SEARCH=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$INPUT_FORMATTED'")

    # If found set variable
      if ! [[ -z $SYMBOL_SEARCH ]]
      then
        FOUND_SEARCH=$SYMBOL_SEARCH

      fi
    fi
  # If input is > 2 characters & not a number
    if ! [[ $INPUT_FORMATTED =~ [0-9] ]] && (( $(echo -n "$INPUT_FORMATTED" | wc -m) > 2 ))
    then
    NAME_SEARCH=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$INPUT_FORMATTED'")

    # If found set variable
      if ! [[ -z $NAME_SEARCH ]]
      then
        FOUND_SEARCH=$NAME_SEARCH

      fi
    fi

# If input was not found
    if [[ -z $FOUND_SEARCH ]]
    then
      echo "I could not find that element in the database."
      
    fi
    
# If input was found
    if ! [[ -z $FOUND_SEARCH ]]
    then
      echo $FOUND_SEARCH | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
      do
        echo -E "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
