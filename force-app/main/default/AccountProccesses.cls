///////////////////////////////////////////////////////////////////////////////////
//
// AccountProcesses
// Created on: 1/31/2019
// Author: Evan Strohm
// Description: Apex methods for the Bank App in Project 0
//
///////////////////////////////////////////////////////////////////////////////////

public with sharing class AccountProccesses {
    
    public static void checkOverdrawn(String id) {
        // SOQL query to find the relevant account
        // Check if balance is below 0
        // If it is, change the status and update
    }

    public static void newTransaction() {
        // ???
    }

    public static void updateBalance(String id) {
        // SOQL query to find the relevant account
        // SOQL query to find all unprocessed transactions
        // Sum them and add to (subtract from) balance
        // Update the account
    }

}
