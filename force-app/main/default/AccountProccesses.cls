///////////////////////////////////////////////////////////////////////////////////
//
// AccountProcesses
// Created on: 1/31/2019
// Author: Evan Strohm
// Description: Apex methods for the Bank App in Project 0
//
///////////////////////////////////////////////////////////////////////////////////

public with sharing class AccountProccesses {
    
    public static void checkOverdrawn(Id accId) {
        // SOQL query to find the relevant account
        Account acc = [SELECT Id, Balance__c, Status__c FROM Account WHERE ID = :accId];
        // Check if balance is below 0
        if (acc.Balance__c < 0) {
            // If it is, change the status and update
            acc.Status__c = 'Overdrawn';
            update acc;
        }
    }

    public static void newTransaction(Id accId) {
        // Make a new transaction
        Transaction__c newTrans = new Transaction__c();
        // Somehow associate it with the relevant account
        Account acc = [SELECT Id FROM Account WHERE Id = :accId];
        newTrans.Account__c = acc.Id;
        // Insert the transaction
        insert newTrans;
        // Run the other 2 methods
        updateBalance(null);
    }

    public static void updateBalance(Id accId) {
        // SOQL query to find the relevant account
        Account acc = [SELECT Id, Balance__c FROM Account WHERE ID = :accId];

        // SOQL query to find all unprocessed transactions
        for (Transaction__c t : [SELECT Amount__c, Account__r.Id, Processed__c, RecordTypeId FROM Transaction__c WHERE Account__r.Id = :accId AND Processed__c = false]) {
            // Sum them and add to (subtract from) balance
            if (t.RecordTypeId == 'Deposit') {
                acc.Balance__c += t.Amount__c;
            }
            else {  // RecordTypeId == 'Withdrawal'
                System.debug(t.RecordTypeId);    // Check that
                acc.Balance__c -= t.Amount__c;
            }
        }
        
        // Update the account
        update acc;
        // Run checkOverdrawn
        checkOverdrawn(acc.Id);
    }

    public static void classAccountExample() {
        List<Account> accs = new List<Account>();
        List<Opportunity> opps = new List<Opportunity>();

        // Find the account with the MOST annual revenue
        accs = [SELECT Name, AnnualRevenue FROM Account WHERE AnnualRevenue != null ORDER BY AnnualRevenue DESC LIMIT 1];
        System.debug(accs);

        // Find the account with the LEAST annual revenue
        accs = [SELECT Name, AnnualRevenue FROM Account WHERE AnnualRevenue != null ORDER BY AnnualRevenue ASC LIMIT 1];
        System.debug(accs);

        // Find the OLDEST account
        accs = [SELECT Name, CreatedDate FROM Account ORDER BY CreatedDate ASC LIMIT 1];
        System.debug(accs);

        // Find the account with the MOST open opportunities
        // accs = [SELECT Name, (SELECT isCLosed, AccountName FROM Opportunity WHERE isClosed = false AND AccountName = Name) FROM Account ORDER BY c Desc LIMIT 1];
        System.debug(accs);

        // Find the account with the most valuable individual opportunity
        //accs = [SELECT ];

        // Find the account with the most valuable sum of opportunities



        // Find the oldest open opportunity
        opps = [SELECT Name, CreatedDate, IsClosed FROM Opportunity WHERE IsClosed = False ORDER BY CreatedDate ASC LIMIT 1];
        System.debug(opps);

        // Find the newest closed won opportunity
        opps = [SELECT Name, CloseDate, IsClosed, IsWon FROM Opportunity WHERE IsClosed = True AND IsWon = True ORDER BY CreatedDate Desc LIMIT 1];
        System.debug(opps);

        // Find the most valuable closed lost opportunity
        opps = [SELECT Name, Amount, IsClosed, IsWon FROM Opportunity WHERE IsClosed = True AND IsWon = False ORDER BY Amount Desc LIMIT 1];
        System.debug(opps);
    }

}
