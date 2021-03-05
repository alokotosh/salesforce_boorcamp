ApexDoc
=======

ApexDoc is a java app that you can use to document your Salesforce Apex classes.  You tell ApexDoc where your class files are, and it will generate a set of static HTML pages that fully document each class, including its properties and methods.  Each static HTML page will include an expandable menu on its left hand side, that shows a 2-level tree structure of all of your classes.  Command line parameters allow you to control many aspects of ApexDoc, such as providing your own banner HTML for the pages to use.


## Documenting Class Files
ApexDoc scans each class file, and looks for comment blocks with special keywords to identify the documentation to include for a given class, property, or method.  The comment blocks must always begin with /** (or additional *'s) and can cover multiple lines.  Each line must start with * (or whitespace and then *).  The comment block ends with */.  Special tokens are called out with @token.
### Class Comments
Located in the lines above the class declaration.  The special tokens are all optional.

| token | description |
|-------|-------------|
| @author | the author of the class |
| @date | the date the class was first implemented |
| @group | a group to display this class under, in the menu hierarchy|
| @group-content | a relative path to a static html file that provides content about the group|
| @description | one or more lines that provide an overview of the class|

Example
```
/**
* @author alokotosh
* @date 1 Sep 2020
*
* @group Accounts
* @group-content ../../ApexDocContent/Accounts.htm
*
* @description Trigger Handler on Accounts that handles ensuring the correct system flags are set on
* our special accounts (Household, One-to-One), and also detects changes on Household Account that requires
* name updating.
*
*/
public with sharing class ACCT_Accounts_TDTM extends TDTM_Runnable {
```

### Property Comments
Located in the lines above a property.  The special tokens are all optional.

| token | description |
|-------|-------------|
| @description | one or more lines that describe the property|

Example
```
    /********************************************************************************************************
    * @description specifies whether state and country picklists are enabled in this org.
    * returns true if enabled.
    */

    public static Boolean isStateCountryPicklistsEnabled {
        get {
```

### Method Comments
In order for ApexDoc to identify class methods, the method line must contain an explicit scope (global, public, private, testMethod, webService).  The comment block is located in the lines above a method.  The special tokens are all optional.

| token | description |
|-------|-------------|
| @description | one or more lines that provide an overview of the method|
| @param *param name* | a description of what the parameter does|
| @return | a description of the return value from the method|
| @example (optional) | Example code usage. This will be wrapped in <code> tags to preserve whitespace|
Example
```
    /*******************************************************************************************************
    * @description Returns field describe data
    * @param objectName - the name of the object to look up
    * @param fieldName - the name of the field to look up
    * @return the describe field result for the given field
    * @example
    * Account a = new Account();
    */
    public static Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName) {
```