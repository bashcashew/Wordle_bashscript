#!/usr/bin/env zsh

## As a sidenote, please take notice of the above; If you are to use a Linux machine ofc change binbash ;)
#########################################################################
#### SETS UP THE SOURCES FOR THE SCRIPT TO RUN WITH...

## This ZSH/ SH script is designd to integrate NYTimes Wordle into a local shellscript. :D

# -- SETTING UP WORD LIST FROM AN EXTERNAL SOURCE --
#words=($(curl -s YOUR-OWN-LINK-TO-A-TXT-FILE | grep '^\w\w\w\w\w$' | tr '[a-z] '[A-Z]'))

# -- SETTING UP WORD LIST FROM AN INTERNAL SOURE --
words=($(grep '^\w\w\w\w\w$' ~/PATH/TO/TEXT/FILE | tr '[a-z]' '[A-Z]'))


#########################################################################
#### PROCEED BELOW FOR THE WORDLE SCRIPT; THIS IS STRUCTURED SO THAT IF YOU WIN OR LOSE, YOU WILL BE PROMPTED.
#### IN FURTHER ITERATIONS, A POP-UP WILL BE INCLUDED FOR MAC USERS.

# If the word list is empty or not found, this will fail to fetch values
if [[ ${#words[@]} -eq 0 ]]; then
    echo "Failed to fetch the word list or the list is empty."
    exit 1
fi

# Radnomly selects a word from the fetched list to use in the game where there are a total of SIX guesses (can of course be changed)
actual=${words[$((RANDOM % ${#words[@]} + 1))]}
end=false
guess_count=0
max_guess=6

# If the first argument is "unlimit", allow unlimited guesses
if [[ $1 == "unlimit" ]]; then
    max_guess=999999
fi

#########################################################################
#### CONTINUE WITH THE ACTUAL GAME CONSTRUCTION BELOW AFTER PREVIOUS STEPS HAVE BEEN IMPLEMENTED PROPERLY
# START the Wordle Game Loop
while [[ $end != true ]]; do
    guess_count=$((guess_count + 1))
    if [[ $guess_count -le $max_guess ]]; then
        echo "Enter your guess ($guess_count / $max_guess):"
        read guess
        guess=$(echo $guess | tr '[a-z]' '[A-Z]')

        # Check if the guess is a valid 5-letter word
        if [[ " ${words[*]} " =~ " $guess " ]]; then
            output=""
            remaining=""

            # This will check if the answer is correct and will output the response if you won :D
            if [[ $actual == $guess ]]; then
                echo "You guessed correctly! 🥹
vvv       vvvvv       vvv   vvv   vvvvvvv    vvv   vvvvvvv    vvv   vvvvvvvv   vvvvvvv     vvv
 vvv     vvv vvv     vvv    vvv   vvv  vvv   vvv   vvv  vvv   vvv   vvv        vvv   vv    vvv
  vvv   vvv   vvv   vvv     vvv   vvv   vvv  vvv   vvv   vvv  vvv   vvvvvv     vvvvvvv     vvv
   vvv vvv     vvv vvv      vvv   vvv    vvv vvv   vvv    vvv vvv   vvv        vvv   vv    
    vvvvv       vvvvv       vvv   vvv     vvvvvv   vvv     vvvvvv   vvvvvvvv   vvv    vv   vvv"
                for ((i = 0; i < ${#actual}; i++)); do
                    output+="\033[30;102m ${guess[$i+1]} \033[0m"
                done
                printf "$output\n"
                end=true
            else
                for ((i = 0; i < ${#actual}; i++)); do
                    if [[ "${actual[$i+1]}" != "${guess[$i+1]}" ]]; then
                        remaining+=${actual[$i+1]}
                    fi
                done

                # This provides the feedback for the input/ guess; is the guess a real word or is it a 5-letter word...
                for ((i = 0; i < ${#actual}; i++)); do
                    if [[ "${actual[$i+1]}" != "${guess[$i+1]}" ]]; then
                        if [[ "$remaining" == *"${guess[$i+1]}"* ]]; then
                            output+="\033[30;103m ${guess[$i+1]} \033[0m"
                            remaining=${remaining/"${guess[$i+1]}"/}
                        else
                            output+="\033[30;107m ${guess[$i+1]} \033[0m"
                        fi
                    else
                        output+="\033[30;102m ${guess[$i+1]} \033[0m"
                    fi
                done
                printf "$output\n"
            fi
        else
            echo "Please enter a valid word with 5 letters!"
            guess_count=$((guess_count - 1))
        fi
    else
        # This outputs the antaonist output to winning, and outputs the response if you lose D:
        echo "You lose!🥺 The word is: $actual"
        end=true
    fi
done

