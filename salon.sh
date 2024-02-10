#!/bin/bash

echo -e "\n~~~Fancy Salon~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


    echo -e "Welcome to my salon! How may I help you?\n" 



    #get availble services
    echo -e "\nThere are the Services available right now.\n"
    AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo -e "$SERVICE_ID) $NAME"
    done

    

    

    #if service not avialble
    VALID_SERVICE=0
    while [[ $VALID_SERVICE -eq 0 ]]; do
        read SERVICE_ID_SELECTED
        SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        if [[ -z $SERVICE_AVAILABILITY ]]
        then
            echo -e "\nPlease enter a valid option"
            echo -e "\nThese are the Services available right now.\n"
            echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
            do
                echo -e "$SERVICE_ID) $NAME"
            done
        else
            VALID_SERVICE=1
        fi
    done
    #get customer details
    echo -e "\n What is your phone number?"
    read CUSTOMER_PHONE
        
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #if customer name is not found
    if [[ -z $CUSTOMER_NAME ]]
    then
        #get customer details
        echo -e "\nWe don't have your record. What's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_DETAILS=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
        
    fi
    #get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nAt What time do you want to Schedule appointment? "
    read SERVICE_TIME
    #insert appointment details
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\n I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 


