@isTest
public with sharing class ApexP0ExercisesTest {
    
    @isTest static void TestFibonacci() {
        List<Integer> results = new List<Integer>();

        results.add(ApexP0Exercises.nFibonacci(0));
        results.add(ApexP0Exercises.nFibonacci(1));
        results.add(ApexP0Exercises.nFibonacci(2));
        results.add(ApexP0Exercises.nFibonacci(10));

        System.assertEquals(4, results.size());
        System.assertEquals(new List<Integer> {0, 1, 1, 55}, results);
    }

    @isTest static void TestSort() {
        List<Integer> unsorted = new List<Integer> {5,4,3,2,6,1,3};

        ApexP0Exercises.sortArray(unsorted);

        for(Integer i = 0; i < unsorted.size() - 1; i++) {
            System.assert(unsorted[i] <= unsorted[i+1]);
        }
    }

    @isTest static void TestFactorial() {
        List<Integer> results = new List<Integer>();

        results.add(ApexP0Exercises.nFactorial(0));
        results.add(ApexP0Exercises.nFactorial(1));
        results.add(ApexP0Exercises.nFactorial(3));

        System.assertEquals(3, results.size());
        System.assertEquals(new List<Integer> {1,1,6}, results);
    }

    @isTest static void TestRotateLeft() {
        List<Integer> l = new List<Integer> {1,2,3,4,5};
        List<List<Integer>> results = new List<List<Integer>>();

        results.add(ApexP0Exercises.rotateLeftNTimes(l, 1));
        results.add(ApexP0Exercises.rotateLeftNTimes(l, 6));
        results.add(ApexP0Exercises.rotateLeftNTimes(l, 3));

        System.assertEquals(3, results.size());
        System.assertEquals(new List<Integer> {2,3,4,5,1}, results[0]);
        System.assertEquals(new List<Integer> {2,3,4,5,1}, results[1]);
        System.assertEquals(new List<Integer> {4,5,1,2,3}, results[2]);
    }

    @isTest static void TestBalancedBrackets() {
        List<String> goodInputs = new List<String> {'()', '()()', '(())', '({[]})'};
        List<String> badInputs = new List<String> {'(', ')', '(()', '([)]', ']', '}', '(]', '(}', '[)'};

        for (String s : goodInputs) {
            System.assert(ApexP0Exercises.bracketsAreBalanced(s));
        }
        for (String s : badInputs) {
            System.assert(!ApexP0Exercises.bracketsAreBalanced(s));
        }
    }

    @isTest static void TestUpdateAccountSize() {
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name='small co', NumberOfEmployees=3));
        accs.add(new Account(Name='med co', NumberOfEmployees=1001));
        accs.add(new Account(Name='large co', NumberOfEmployees=10001));
        insert accs;

        ApexP0Exercises.updateAccountSize();

        accs = [SELECT Name, Size__c, NumberOfEmployees 
                FROM Account 
                WHERE Name Like '% co' 
                ORDER BY NumberOfEmployees ASC];
        System.assertEquals(3, accs.size());
        System.assertEquals(3, accs[0].NumberOfEmployees);
        System.assertEquals(1001, accs[1].NumberOfEmployees);
        System.assertEquals(10001, accs[2].NumberOfEmployees);

        System.assertEquals('Small', accs[0].Size__c);
        System.assertEquals('Medium', accs[1].Size__c);
        System.assertEquals('Large', accs[2].Size__c);
    }

    @isTest static void TestUpdateCALeads() {
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(LastName='Test 0',Status='Open',State='ca',Company='testers inc'));
        leads.add(new Lead(LastName='Test 1',Status='Open',State='ny',Company='testers inc'));
        insert leads;

        ApexP0Exercises.updateCALeads();

        leads = [SELECT LastName, Status, State
                 FROM Lead
                 WHERE LastName Like 'test _'
                 AND State='ca'];
        System.assertEquals(1, leads.size());
        System.assertEquals('Closed - Not Converted', leads[0].Status);
        leads = [SELECT LastName, Status, State
                 FROM Lead
                 WHERE LastName Like 'test _'
                 AND State='ny'];
        System.assertEquals(1, leads.size());
        System.assertEquals('Open', leads[0].Status);
    }

    @isTest static void TestClosePastDueOpportunities() {
        List<Opportunity> opps = new List<Opportunity>();
        Date today = Date.Today();
        opps.add(new Opportunity(Name='Test 0', CloseDate=(Today-1), StageName='Prospecting'));
        opps.add(new Opportunity(Name='Test 1', CloseDate=(Today+1), StageName='Prospecting'));
        insert opps;

        ApexP0Exercises.closePastDueOpportunities();

        opps = [SELECT Name, StageName
                FROM Opportunity
                WHERE Name='Test 0'];
        System.assertEquals(1, opps.size());
        System.assertEquals('Closed Lost', opps[0].stageName);

        opps = [SELECT Name, StageName
                FROM Opportunity
                WHERE Name='Test 1'];
        System.assertEquals(1, opps.size());
        System.assertEquals('Prospecting', opps[0].stageName);
    }
}
