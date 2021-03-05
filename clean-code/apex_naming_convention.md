## Naming Convention

The naming convention will help you to have clean and 
straightforward variables and class names for 
your project. It will minimize the risk of 
having not descriptive names for your variables and 
classes.

* project code style
* refactoring process
* implementation of new features
* the code review process
* fire right PMD static code analysis rule set

###Index Table

| Index | Rule Name                  | PMD Rule                                                 |
|-------|----------------------------|----------------------------------------------------------|
| N1    | Apex Class                 | [ClassNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#classnamingconventions )                                   |
| N2    | Functional Class Naming    |                                                          |
| N3    | Apex Test Class            | [ClassNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#classnamingconventions )                                    |
| N4    | Apex Interface             | [ClassNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#classnamingconventions )                                    |
| N5    | Interface Implementation   | [ClassNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#classnamingconventions )                                    |
| N6    | Apex Methods               | [MethodNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#methodnamingconventions )                                  |
| N7    | Apex Methods Parameters    | [FormalParameterNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#formalparameternamingconventions )                         |
| N8    | Apex Variables             | [FieldNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#fieldnamingconventions )<br>[LocalVariableNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#localvariablenamingconventions ) |
| N9    | Apex Variables - Constants | [PropertyNamingConventions]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#propertynamingconventions )                                |
| N10   | Other metadata naming      |                                                          |

`N1 - Apex Class`

1. Names should be nouns, in mixed case with the first letter of each word capitalized.
2. Try to keep your names simple and descriptive.
3. Use whole words and avoid acronyms and abbreviations. 

*If you use prefixes on your project*

4 - Use the prefix to combine classes by the function, module, or project

```
public with sharing class AmountCalculator {
//..
public class OpportunityWrapper {
//..
}
}
@IsTest
class MyClassTest {
//..
}
//Good naming
//|...AccountTriggerHandler
// |...Test_AccountHelper
// |...Test_ContactHelper
//|...SPMS_Connector
// |...SPMS_Response
// SBCPT_CustomerAssessmentController

//Bad Naming
//CustomerAssessment 
//SmallBusinessConfigureAndPricingTool_CustomerAssessmentController
//SBCPTCustomerAssessmentController
```

`N2 - Functional Class Naming: - N5`

1. Apex Controller for Aura, LWC, Visualforce - The class name is typically suffixed by 'Controller' e.g. SolarEnergyController, NewAccountController

2. Batch Apex Class - The class name should be suffixed by 'Batch'. e.g. AccountRefundBatch, ValidateOpportunityBatch

3. Trigger: Main sObject trigger name should be suffixed by 'Trigger', and the handler Class should be suffixed by 'TriggerHandler' e.g. AccountTrigger, AccountTriggerHandler

4. Invocable: Apex class name  which will be called form flows should be suffixed by 'Invocable' e.g. AccountDiscountCalculatorInvocable 

5. Exceptions: should be suffixed by 'Exception' e.g. WrongInputParamFormatException 


```
// Visualforce controller
public class <Visualforce_Page_Name>Controller {
}

// Visualforce controller extension
public class <Visualforce_Page_Name>ControllerExtension {
}

// Ligthning Component Controller
public class <Lightning_Component_Name>ControllerLT {
}

// Batch class
global class AccountDaylyUpdateBatch implements Database.Batchable<sObject> {
}

// Schedule class
global class OpportunityWeeklyReportSchedule implements Schedulable {
}

//Service class
public class AccountService {
}

//Utilities class
public class TestUtilities {
}
```

`N3 - Apex Test Class`

If you start a new project use the following naming convention based on your team agreement:
```
@IsTest
public class MyClass_Test {}

// or

@IsTest
public class MyClassTest {}
```

`N4 - Apex Interface`

Follow Java Style declaration
```
public interface IPurchaseOrder {
    // All other functionality excluded
    Double discount();
}
```
`N5 - Interface Implementation`

If a class implements an interface, it should use the name of the interface as part of its name, adding something specific for this implementation to it, or Impl if that does not make sense.

```
public interface ICoupon {
    Double getDiscount();
}

public class Coupon implements ICoupon {

    public Double getDiscount() {
        return 0.25;
    }
    
}

public interface IBillable {
    void completeBilling();
}

public class Corporation implements IBillable {
    public void completeBilling() {
        callBillingService();
    }
}
```

```
public with sharing class FileBasedRepository implements IRepository
public with sharing class AccountPurchaseOrder implements IPurchaseOrder
```



`N6 - Apex Methods`

1. Methods should be verbs in mixed case with the first letter lowercase. Within each method, name capital letters separate words.
2. Always start your method with "get" or "filterBy" if it returns a variable, object, or data structure like Map, List, or Wrapper
3. When a method is used to set a value start the method name with 'set'.
4. Always start your method with "is" if it returns a Boolean
5. If method return void use verbs to specify and action like "do", "perform", "calculate", "initiate", "clean", "update", "insert" etc


```
public List<Account> getFilteredByParamAccount(...){}
public setResentlyUpdatedContacts(...){}
public Boolean isAccessableForUpdate(..){}
public void doRecalculationOfDiscount(..){}
```

`N7 - Apex Methods Parameters`

1. Parameter names are written in *lowerCamelCase*.
2. One-character parameter names should be avoided.
3. Numerous parameters in methods should be avoided. 
4. If method requires a lot of entry parameters they should be packed into a class with appropriate properties.
5. Method argument names should describe their intent and usage

```
public void processUserData(String firstName, String lastName, String email, Date dateOfBirth, String socialNumber ) {
} // This is not acceptable, a lot of parameters, it's a challenge to maintain methods like this

public void processUserData(User userData) {
} // This is fine, parameters are packed into a new User class and method takes only one parameter

public class User {
    String firstName;
    String lastName;
    String email;
    Date dateOfBirth;
    String socialNumber;
}
```

`N8 - Apex Variables`

1. All variables are in mixed case with a lowercase first letter. Words are separated by capital letters
2. Use descriptive naming which explain variable purpose and usage
```
public Integer indexForDiscount;
private Float myWidth;

public Integer index; //poor naming
```

`N9 - Apex Variables - Constants`

Names should be all uppercase with words separated by underscores ('_'). Example:
```
public static final Integer MAX_LIMIT = 99;
public static final String CASE_ESCALATION_TYP = 'Escalation'


// Constants
public static final Integer NUMBER = 5;
public static final List<String> NAMES = new List<String> { 'Ed', 'Ann' };
public static final Map<String, Integer> AGES = new Map<String, Integer> { 'Ed' => 35, 'Ann' => 32};
public Enum someEnum { ENUM_CONSTANT };

// Not constants
private static String nonFinal = "non-final";
private final String nonStatic = "non-static";

```



`N10 - Other Metadata Naming`


| Metadata N                         | Proposed Naming                                                         | Wrong Naming                                                                                                                                                                                                            |
|-----------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Approval Process                  | Submit Assessment Record                                                | Approve Record – Unclear what record is approved and when that happens. Send Email On Record Approval – Describes the actions the process performs, instead of the conditions that fired it.                            |
| Approval Process Step             | Auto Approved - Value within personal limit  Approval - Sent to Manager | Approved - Meets conditions – Not descriptive enough; does not state what was evaluated.                                                                                                                                |
| Custom Fields and Objects         | CountryCode                                                             | CCode – Use of abbreviations leads to unclarity. Country_Code – Uses underscores.                                                                                                                                       |
| Field Updates                     | Set City to Tel Aviv                                                    | Update City – Not enough information.                                                                                                                                                                                   |
| Lightning App                     | AccountManagementApp                                                    | AccountApp – Too generic; not clear what the app does.                                                                                                                                                                  |
| Lightning Component               | accountLookup                                                           | LGN_UX_AccountLookup – redundant prefix                                                                                                                                                                             |
| Lightning Event                   | AccountSelectedEvt                                                      | AccountLookupEvt – Not clear what event is being performed. Is the account being selected? Viewed? Deleted?                                                                                                             |
| Lightning Web Component           | accountLookup                                                           | AccountLookup – Starts with a capital letter (the LWC framework does not allow this). Misses "Cmp" suffix.                                                                                                              |
| Platform Event                    | New Order Event                                                         | Order – Not clear that it is an event. Order Event – Too general, we might have multiple events associated with orders.                                                                                                 |
| Process Builder                   | <sObject> - Case Rejection Process                                      | Case Process – Not clear whether it's the Handler or a Sub Process Builder. Case Set Status to Rejected – Simple action that does not warrant a separate Process Builder; should have been defined in the Case Handler. |
| Process Builder Decision Criteria | Has Related Relationship(s) Age > 80 AND Type Check                     | Create Task – Describes the actions being performed. Age > 80 OR Status = Active AND Record Type = Client OR Customer – Too long for UI.                                                                                |
| Validation Rule                   | Street Address < 60 chars Occupation Required                           | Validate Address – Superfluous use of the word 'validate'; does not allow future additional validation rules to easily distinguish what the rule is checking.                                                           |
| VisualForce Page                  | SBCPT_BundleConfigurations                                              | BundleConfigurations – Lacks project namespace. SmallBusinessConfigureAndPricingTool_Bundle_Configurations – Namespace too long + uses underscores within the page name.                                                |
| Workflow Rule                     | Date of Birth Changed                                                   | Contact - Send Email and Update Inactive Flag – Too long + describes the actions performed.                                                                                                                             |












