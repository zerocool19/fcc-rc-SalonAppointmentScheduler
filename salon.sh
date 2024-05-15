#! /bin/bash

# Connection settings
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

SERVICES_MENU()
{
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES_NAME_RESULT=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES_NAME_RESULT" | while read SERVICE_ID BAR NAME
  do 
      echo "$SERVICE_ID) $NAME"
  done
}

# This part of code will loop the service menu until a correct input will be entered
SERVICES_MENU
while [[ 1==1 ]]
do
  # Choosing the service
  read SERVICE_INPUT
  SERVICES_EXISTING_RESULT=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_INPUT")

  # Check if the input is correct
  if [[ -z $SERVICES_EXISTING_RESULT ]]
  then
    # Return to SERVICES_MENU
    SERVICES_MENU "I could not find that service. What would you like today?"
  else
    break
  fi
done

# Register the client's phone number
echo -e "\nWhat's your phone number?"
read PHONE_INPUT

# Checking if the phone number already exist
PHONE_EXISTING_RESULT=$($PSQL "SELECT * FROM customers WHERE phone = '$PHONE_INPUT'")

# If the phone number doesn't exist, the client's name will be added in the database
if [[ -z $PHONE_EXISTING_RESULT ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CLIENT_NAME
fi

# This part of the code will be used to set appointment time








