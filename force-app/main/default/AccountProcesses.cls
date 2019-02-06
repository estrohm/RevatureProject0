///////////////////////////////////////////////////////////////////////////////////
//
// AccountProcesses
// Created on: 1/31/2019
// Author: Evan Strohm
// Description: Apex methods for the Bank App in Project 0
//
///////////////////////////////////////////////////////////////////////////////////

public with sharing class AccountProcesses {

    // RecordTypeId constants gathered from SOQL queries
    static final Id single = '0121U000000681gQAA', joint = '0121U000000681lQAA';
    static final Id deposit = '0121U00000067w1QAA', withdrawal = '0121U00000067w6QAA';
    
    public static void checkOverdrawn(Id accId) {
        // SOQL query to find the relevant account
        Account acc = [SELECT Id, Balance__c, Status__c FROM Account WHERE ID = :accId];
        // Check if balance is below 0
        if (acc.Balance__c < 0) {
            // If it is, mark it as overdrawn
            acc.Status__c = 'Overdrawn';
        } else {
            // Otherwise, mark it as in good standing
            acc.Status__c = 'In Good Standing';
        }
        // Update the account to reflect the changes
        update acc;
    }

    public static void newTransaction(Id accId, Decimal amt) {
        // Make a new transaction
        Transaction__c newTrans = new Transaction__c();
        // Give it appropriate account and amount fields
        Account acc = [SELECT Id FROM Account WHERE Id = :accId];
        newTrans.Account__c = acc.Id;
        // Give it the correct record type
        if (amt >= 0) {
            newTrans.RecordTypeId = deposit;
        } else {
            newTrans.RecordTypeId = withdrawal;
            amt *= -1;
        }
        newTrans.Amount__c = amt;
        // Insert the transaction
        insert newTrans;
        // Run the other 2 methods
        updateBalance(accId);
    }

    public static void updateBalance(Id accId) {
        // SOQL query to find the relevant account
        Account acc = [SELECT Id, Balance__c FROM Account WHERE ID = :accId];

        List<Transaction__c> transactions = [SELECT Amount__c, Account__r.Id, Processed__c, RecordTypeId FROM Transaction__c WHERE Account__r.Id = :accId AND Processed__c = false];

        // SOQL query to find all unprocessed transactions
        for (Transaction__c t : transactions) {
            // Sum them and add to (subtract from) balance
            if (t.RecordTypeId == deposit) {
                acc.Balance__c += t.Amount__c;
            }
            else {  // RecordTypeId == withdrawal
                System.debug(t.RecordTypeId);    // Verify that
                acc.Balance__c -= t.Amount__c;
            }
            // Mark the transaction as processed
            t.Processed__c = true;
        }
        
        // Update the transactions
        update transactions;
        // Update the account
        update acc;
        // Run checkOverdrawn
        checkOverdrawn(acc.Id);
    }

}
