////////////////////////////////////////////////////////////////////////////////////
//
// ApexP0Exercises
// Created on: 1/30/2019
// Author: Evan Strohm
// Description: Implementation of the assigned Apex problems for Project 0
//
///////////////////////////////////////////////////////////////////////////////////
public class ApexP0Exercises {
	/*
	 * 1. Return the nth Fibonacci number
	 * Test Cases:
	 * Input: 0 	Output: 0
	 * Input: 1	Output: 1
	 * Input: 2 	Output: 1
	 * Input: 10	Output: 55
	 */
	public static Integer nFibonacci( Integer n ){
		// Base Cases as given
		if (n == 0)
			return 0;
		else if (n == 1)
			return 1;
		
		// "Recursive" computation (performed iteratively)
		// lo stores F_i-2, and hi stores F_i-1 at the start of each loop
		// Thus, when we update hi = lo + hi, we're computing F_i-2 + F_i-1, which
		// is exactly the formula for F_i. Then, we update lo to F_i-1, and use these
		// to compute the next value, until we've found the one we were after

		Integer lo = 0, hi = 1;
		for (Integer i = 2; i <= n; i++) {
			Integer tmp = hi;
			hi = lo + hi;
			lo = tmp;
		}

		
		return hi;
	}

	/*
	 * 2. Sort an array of integers.
	 * Test Cases:
	 * Input: [2,4,5,1,3,1] 	Output: [1,1,2,3,4,5]
	 * Input: [5,4,3,2,1] 	Output: [1,2,3,4,5]
	 *
	 * Don't use the sort() method... that would be lame.
	 */
	public static Integer[] sortArray( Integer[] intList ) {
		// Insertion Sort (in-place)
		// At each iteration, find the smallest remaining element, and move it to
		// the front of the remaining elements, then repeat
		// TODO: Figure out whether it should be in place
		for(Integer i = 0; i < intList.size(); i++) {	// Finding the i-th smallest element
			// Assume the first element is the smallest, for comparison purposes
			Integer min = intList[i];
			Integer mindex = i;
			for(Integer j = i; j < intList.size(); j++) {	// Loop over remaining elements
				// If you find a smaller one, replace the current smallest
				if (intList[j] < min) {
					min = intList[j];
					mindex = j;
				}
			}
			// Swap the smallest value to the front of the list
			Integer tmp = intList[i];
			intList[i] = intList[mindex];
			intList[mindex] = tmp;
		}
		return intList;
	}

	/*
	 * 3. Return the factorial of n.
	 * Test Cases:
	 * Input: 0	Output: 1
	 * Input: 1	Output: 1
	 * Input: 3	Output: 6
	 */
	public static Integer nFactorial( Integer n) {
		// Base case: 0! = 1! = 1
		if (n <= 1)
			return 1;
		// Recursive call: n! = n * (n-1)!
		else
			return n * nFactorial(n-1);
	}

	/*
	 * 4. Rotate left
	 * Given an array, array, and an integer, n, rotate the values in array left n times and return array
	 * Test Cases:
	 * Input: [1,2,3,4,5], 1	Output: [2,3,4,5,1]
	 * Input: [1,2,3,4,5], 6	Output: [2,3,4,5,1]
	 * Input: [1,2,3,4,5], 3	Output: [4,5,1,2,3]
	 */
	public static Integer[] rotateLeftNTimes( Integer[] array2, Integer n) {
		// Returns an array rotated n places left
		// TODO: figure out if it should be in place

		// For each element, figure out its target location in the new array, then put it there
		Integer[] tmp = new Integer[array2.size()];
		for(Integer i = 0; i < array2.size(); i++) {
			// Calculate the new index - this would be done with a modulo operator, but it seems that Apex
			// doesn't have such an operator, so I'm computing it myself (it should be newIndex = i-n % size)
			Integer newIndex = i-n;
			while (newIndex < 0)
				newIndex += array2.size();
			tmp[newIndex] = array2[i];
			//tmp[(i - n) % array2.size()] = array2[i];
		}
		return tmp;
	}

	/*
	 * 5. Balanced Brackets
	 * A bracket is any one of the following: (, ), {, }, [, or ]
	 * 
	 * The following are balanced brackets:
	 *    ( )
	 *    ( ) ( )
	 *    ( ( ) )
	 *    ( { [ ] } )
	 *
	 * The following are NOT balanced brackets:
	 *   (
	 *   )
	 *   ( ( )
	 *   ( [ ) ]
	 *
	 * Return true if balanced
	 * Return false if not balanced
	 */

	public static Boolean bracketsAreBalanced( String s ) {
		// The high-level logic:
		//		Any string with balanced brackets conforms to the following grammar:
		//			S -> S ( S ) S
		//			S -> S [ S ] S
		//			S -> S { S } S
		//			S -> letter/number*
		//		Since this is a grammar, the natural solution is to use some sort of a stack
		//		We only care about the brackets, so we can ignore other characters
		//		The idea is that any open bracket MUST be followed by a corresponding close
		//		bracket, possibly with a string of balanced brackets in between. Thus, when
		//		we put find an open bracket, we put it on the stack, and remove it when (if)
		//		we find its match.
		//	At the implementation level, we've simulated a stack with an array and integer to
		//	keep track of the top, and since Apex has no character type, we're using integers
		//	instead, so we make a note of the relevant character values:
		//		'(' = 40
		// 		')' = 41
		//		'[' = 91
		//		']' = 93
		//		'{' = 123
		//		'}' = 125

		// A simulated stack, since we know the max number of elements on it
		List<Integer> stack = new List<Integer>(s.length());
		Integer top = 0;
		
		for(Integer i = 0; i < s.length(); i++) {
			switch on s.charAt(i) {
				// Put any opening brackets onto the stack
				when 40, 91, 123 {
					stack[top++] = s.charAt(i);
				}
				
				// For each closing bracket, check if the matching open is on top of the stack
				// 		If it is not, the brackets are not balanced
				// 		If it is, remove the pair and keep processing
				when 41 {
					if (top <= 0)
						return false;
					if (stack[--top] != 40)
						return false;
					else
						stack[top] = null;
				}
				when 93 {
					if (top <= 0)
						return false;
					if (stack[--top] != 91)
						return false;
					else
						stack[top] = null;
				}
				when 125 {
					if (top <= 0)
						return false;
					if (stack[--top] != 123)
						return false;
					else
						stack[top] = null;
				}
				
				// Ignore all other characters, e.g. ( a [ xyz ] ji ) is effectively ( [ ] )
				when else {
					
				}
			}
		}
		// If there were any unmatched open brackets, then the string is unbalanced
		if (top > 0)
			return false;
		return true;
	}

	/* You should NOT be submitting answers that you find online. You will be expected to be able to defend any of these solutions without notice. */

	/*
	 * 6. Create a method that retrieves a list of all accounts and updates those accounts.
	 * 	 Create a custom field on the Account standard object called Size__c that will be a 
	 * picklist containing small/medium/large.
	 * 	Create a method that retrieves a list of all accounts. 
	 * 		- If an account has between 1-1000 employees then it is classified as small.
	 * 		- If an account has between 1001-10000 employees it is classified as medium.
	 * 		- If an account has more than 10000 employees it is classified as large.
	 * 	Update the Size__c field on each account to reflect the amount of employees in the Account.
	 */
	public static void updateAccountSize( ) {
		// Make a list of leads to reduce our DML queries
		List<Account> accounts = new List<Account>();
		// Grab all accounts that we want to update, and only the fields we care about
		for(Account a : [SELECT Id, NumberOfEmployees, Size__c FROM Account]) {
			// Update the Size based on the number of employees
			if (a.NumberOfEmployees >= 1 && a.NumberOfEmployees <= 1000)
				a.Size__c = 'Small';
			else if (a.NumberOfEmployees >= 1001 && a.NumberOfEmployees <= 10000)
				a.Size__c = 'Medium';
			else
				a.Size__c = 'Large';
			accounts.add(a);
		}
		// Push the changes to the database as 1 DML query
		update accounts;
		
	}

	/* 
	 * 7. Create a method that will find all leads that contain 'ca' in their fields. 
	 * 	If a lead is located in California(CA), change their Lead Status field to 'Closed - Not 
	 * Converted' and their description should display the message, "We are no longer doing 
	 * business in California."
	 */
	public static void updateCALeads( ) {
		// Make a list of leads to reduce our DML queries
		List<Lead> leads = new List<Lead>();
		// Gather all relevant leads, i.e. those ones in California
		for (Lead l : [SELECT Id, Status, Description, Address FROM Lead WHERE state = 'ca']) {
			// Give them new statuses and descriptions 
			l.Status = 'Closed - Not Converted';
			l.Description = 'We are no longer doing business in California';
			leads.add(l);
		}
		// Push the changes to the database as one DML query
		update leads;
	}

	/*
	 * 8. Create a method that will find all Opportunities which have already passed their Close Date 
	 * and have a Stage field that is not 'Closed Won'. Since they have passed their Close Date and 
	 * they are not marked as 'Closed Won', they should be marked as 'Closed Lost'.
	 */
	public static void closePastDueOpportunities( ) {
		// Make a list of leads to reduce our DML queries
		List<Opportunity> opps = new List<Opportunity>();
		Date today = Date.today();
		// Gather the relevant opportunities, i.e. those whose close date is in the past (i.e. less than today's date) and are not closed won
		for (opportunity o : [SELECT Id, CloseDate, StageName FROM Opportunity WHERE CloseDate < :today AND StageName != 'Closed Won']) {
			// Update their Stage
			o.StageName = 'Closed Lost';
			opps.add(o);
		}
		// Push the changes to the database as one DML query
		update opps;
	}
}