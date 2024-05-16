#! /bin/bash

# Connection settings
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

WELCOME()
{
  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  echo -e "Welcome to My Salon, how can I help you?\n"
}

SERVICES_PRINTER()
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

  SERVICES_CHOOSER
}

SERVICES_CHOOSER()
{
    # Choosing the service
    read SERVICE_ID_SELECTED
    SERVICES_EXISTING_RESULT=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    # Check if the input is correct
    if [[ -z $SERVICES_EXISTING_RESULT ]]
    then
      # Input not valid, return to SERVICES_MENU
      SERVICES_PRINTER "I could not find that service. What would you like today?"
    fi
}

CUSTOMERS_INFO_READER()
{
  # Register the client's phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Checking if the phone number already exist
  PHONE_EXISTING_RESULT=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # If the phone number doesn't exist, the client's name will be added in the database
  if [[ -z $PHONE_EXISTING_RESULT ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # Customer info registration in 'customers'
    CUSTOMER_INFO_REGISTRATION_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  # This part of the code will be used to set appointment time
  SERVICE_NAME_RESULT=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nWhat time would you like your $SERVICE_NAME_RESULT, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # Appointment info registration in 'customers'
  CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  APPOINTMENT_INFO_REGISTRATION_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_RESULT, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")


  echo -e "\nI have put you down for a $SERVICE_NAME_RESULT at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}




#####   MAIN PROGRAM   #####
for i in 1 2
do
  WELCOME
  SERVICES_PRINTER  # Will call SERVICES_CHOOSER until the input will be correct
  CUSTOMERS_INFO_READER
done
