## Code Formatting

Code formatting is the process of formatting your APEX, Javascript, Aura Component, or Web Component markup. 

Use automatic IDE formatting or code formatting rules to aligning with your team formatting style. This will improve your team:


* project code style
* refactoring process
* implementation of new features
* the code review process
* code merge process



### Indexing table

| Index | Rule Name                          | PMD Rule                                                                                             |
|-------|------------------------------------|------------------------------------------------------------------------------------------------------|
| F1    | Clean Class Layout                 | [FieldDeclarationsShouldBeAtStart]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#fielddeclarationsshouldbeatstart )                                                                   |
| F2    | Braces                             | [WhileLoopsMustUseBraces]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#whileloopsmustusebraces )<br>[ForLoopsMustUseBraces]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#forloopsmustusebraces )<br>[IfStmtsMustUseBraces]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#ifstmtsmustusebraces )<br>[IfElseStmtsMustUseBraces]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#ifelsestmtsmustusebraces ) |
| F3    | Overloads: "Never Split"           |                                                                                                      |
| F4    | Variable per line                  | [OneDeclarationPerLine]( https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#onedeclarationperline )                                                                                 |
| F5    | Nonempty block: K & R Style        |                                                                                                      |
| F6    | Indentation                        |                                                                                                      |
| F7    | Column Limit                       |                                                                                                      |
| F8    | Wrapping Lines                     |                                                                                                      |
| F9    | Blank lines                        |                                                                                                      |
| F10   | Blank spaces                       |                                                                                                      |
| F11   | if, if-else, if else-if statements |                                                                                                      |
| F12   | switch statement                   |                                                                                                      |
| F13   | try - catch                        |                                                                                                      |
| F14   | loops                              |                                                                                                      |
| F15   | SOQL / SOSL                        |                                                                                                      |
| F16   | Comments                           |                                                                                                      |
| F17   | ApexDoc                            | [ApexDoc]( https://pmd.github.io/latest/pmd_rules_apex_documentation.html#apexdoc )                                                                                              |

`F1 - Clean Class Layout`

> The order you choose for the members and initializers of your class can have a great effect on learnability. However, there's no single correct recipe for how to do it; different classes may order their contents in different ways.
  What is important is that each class uses some logical order, which its maintainer could explain if asked. For example, new methods are not just habitually added to the end of the class, as that would yield "chronological by date added" ordering, which is not a logical ordering.
1. Use the same class template for each class

```
<visability> <data access> class <name>
{
//Static variable
//Static Methods
//Non-Static Variables
..
// Constructors
..
// getter & setter methods
..
// Action Methods
..
// Logical Methods
// Inner Classes and Functions
}
```

`F2 - Braces`

Braces are used with if, else, for, do and while statements, even when the body is empty or contains only a single statement.
[Apex properties](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_properties.htm) may be written like:
1 -
```
public class AutomaticProperty {
   public Integer myReadOnlyProp { get; }
   public Double myReadWriteProp { get; set; }
   public String myWriteOnlyProp { set; }
   private Enum Suit { CLUBS, HEARTS, SPADES, DIAMONDS }
   public List<String> example = new List<String> {'one', 'two', 'three' };
   public List<String> example2 = new List<String> {'one', 
                                                    'two', 
                                                    'three' }; // formatting for long declaration
}
```
2 -
```
public class BasicProperty {
   public Integer prop {
      get { return prop; }
      set { prop = value; }
   }
}
```
3 - 
```
public class BasicClass {
 
   // Property declaration
   access_modifier return_type property_name {
      get {
         //Get accessor code block
      }
      set {
         //Set accessor code block
      }
   } 
}
```

4 - 
```
public class StaticProperty {
   private static Integer staticMember;
   private Integer nonStaticMember;

   // The following produces a system error
   // public static Integer myBadStaticProp { return NonStaticMember; }
   
   @decorator
   public static Integer myGoodStaticProp { 
     get { return staticMember; } 
     set { staticMember = value; } 
   }
  
   public Integer myGoodNonStaticProp { 
     get { return nonStaticMember; } 
     set { nonStaticMember = value; } 
   } 
}

```

5 -
```
global virtual class PropertyVisibility {
   // X is private for read and public for write
   public Integer x { private get; set; }
   // Y can be globally read but only written within a class
   global Integer y { get; public set; }
   // Z can be read within the class but only subclasses can set it
   public Integer z { get; protected set; }
}
```

`F3 - Overloads: "Never Split"`

> When a class has multiple constructors or multiple methods with the same name, these appear sequentially, with no other code in between (not even private members).


`F4 - Variable per line`

> One declaration per line is recommended since it encourages commenting, and it does not lead to confusing code. It also is more clear about the explicit initialization of variables as discussed in Initialization.

```
Integer level = 0; // level where user enters the system
Integer horizontalSize = 0; // horizontal size of current level layer
```

`F5 - Nonempty block: K & R Style`

Braces follow the Kernighan and Ritchie style ("Egyptian brackets") for nonempty blocks and block-like constructs:

1. No line break before the opening brace.
2. Line break after the opening brace.
3. Line break before the closing brace.
4. Line break after the closing brace, only if that brace terminates a statement or terminates the body of a method, constructor, or named class. For example, there is no line break after the brace if it is followed by else or a comma.

```
private void exampleMethod() {
    if (getSomeValue()) {
        callToSomeMethod();
    } else {
        callToAnotherMethod();
    }
} 
```

`F6 - Indentation`

> Four spaces should be used as a unit of indentation. Use spaces or let your editor convert tabs to spaces as some editors might show the tabs different than they were intended! Tabs must be set exactly every 4 spaces.

`F7 - Column Limit- 80`

> Although Apex code has a column limit of 120 characters it is recommended to avoid lines longer than 80 characters, since they're not handled well by many terminals and tools. Except as noted below, any line that would exceed this limit must be line-wrapped
Exceptions:

1. Lines were obeying the column limit is not possible (for example, a long URL in ApexDoc).
2. Command lines in a comment that may be cut-and-pasted into a shell.


`F8 - Wrapping lines`

> When an expression will not fit on a single line, break it according to these general principles:
1. break after a comma;
2. break before an operator (. "dot" operator);
3. prefer higher level breaks to lower level breaks;
4. indent the new line with a tab tp the same vertical line;
5. if the above rules lead to confusing code or to code that's squished up against the right margin, please use common sense.

Note: The primary goal for line wrapping is to have clear code, not necessarily code that fits in the smallest number of lines.


```
//add examples of wrapping lines
```

`F9 - Blank lines`

> Blank lines improve readability by setting of sections of code that are logically related. One blank line should always be used in the following circumstances:

1. between class and interface definitions;
2. between methods;
3. before a block or single line commend; (if-else, loops etc )
4. between logical sections inside a method to improve readability.

```
public without sharing class LeadHelper {
    
    public static final String CLOSED_LEAD_STATUS = 'Closed';
    private Lead updatedLead;
    
    public LeadHelper() {
        //...
    }

    public Boolean isLeadClosed(Id leadId) {
        //...retrieve lead logic
        //...main logic

        while (index > 5) {
            // ...
        }

        return result;
    }
}
```

`F10 - Blank spaces`
> Blank spaces should be used in the following circumstances:
1. A keyword followed by a parenthesis should be separated by a space
2. Note that blanks should not be used between a method call and its opening parenthesis. This helps to distinguish keywords from function calls;
3. Blanks should appear after commas in argument lists;
4. All binary and ternary operators except "." should be separated from their operands by spaces. Blanks should never separate unary operators such as unary minus, increment("++") and decrement("--") from their operands:
5. The expressions in a for statement should be separated by blanks:
6. Casts should be followed by a blank:


```
// 1
while (index > 5) {
    // ...
}

//4
a += c + d;
a = (a + b) / (c * d);
a = (b > c) ? b : c;
xCoord--;

//5
for (expr1; cond1; expr2) {
}

//6
myInstance.doIt((TreeFrame) frame);
 
```

`F11 - if, if-else, if else-if else statements`

> There are a lot of nested possibilities for if-else constructions. All these variations can be programmed in very cryptic ways that easily and often will lead to buggy code. By being more explicit in the used coding style a lot of confusion can be taken away.
  When using only one statement in a compound block brackets are optional. It is good practice, and therefore required, to always use brackets because mistakes can be made easily when adding a second statement and brackets are forgotten.
  The following example illustrates the correct use of brackets in a few different if-then-else constructions:

```
if(condition) execute();

if (condition) {
    statement1;
    statement2;
} else {
    statement3;
}

if (condition) {
    statement1;
    statement2;
} else if (condition1) {
    statement3;
    statement4;
} else {
    statement5;
    statement6;
}

```


`F12 - Switch statement`

The next example shows the sample code that uses the guidelines for a switch statement:

```
switch on expression {
    when value1 { // when block 1
        // code block 1
    }
    when value2 { // when block 2
        // code block 2
    }
    when value3 { // when block 3
        // code block 3
    }
    when else { // default block, optional
        // code block 4
    }
}
```
`F13 - try - catch`
1. Catch block cannot be empty.

A try - catch statement should have the following format:

```
try {
    statements;
} catch (ExceptionClass e) {
    statements;
}
try {
    statements;
} catch (ExceptionClass e) {
    statements;
} finally {
    statements;
}
```

`F14 - loops`

```
for (sObject s : sObjects) {
    //...
}

for (Integer i = 0; i < 5; i++) {
    //...
}

while (condition) {
    //...
}

do {
    //...
} while (condition);

```

`F15 - SOQL/SOSL`

Key words must contain only capital letters:
```
Id accountId = ...;
//line length doesn't exceed 120 characters
List<Account> accounts = [SELECT Name, BillingState FROM Account WHERE Id = :accountId];


//line length exceed 120 characters
List<Case> cases = [SELECT Id, 
                            Subject, 
                            Description,
                            Status
                            FROM Case
                            WHERE AccountId = :accountId
                            ORDER BY CreatedDate DESC
                            ];

//with inner query

List<Case> cases = [SELECT Id, 
                            Subject, 
                            Description,
                            Status, 
                                (SELECT Id
                                FROM Custom__r
                                WHERE CreatedDate = TODAY)
                            FROM Case
                            WHERE AccountId = :accountId
                            ORDER BY CreatedDate DESC
                            ];

```

`F16 - Comments`

Comments should be served as an overview of your method/class and for technical documentation purpose only which make possible to generate apex docs and will better structure the code. 
Do not:

1. Do not use comments to explain code behaviour, instead make code simpler, split the methods, rewrite the code, so it will be obvious what is intent of your code
2. Do not use comments to explain the poor naming for class, method, variable, instead  choose the right naming and refactor the code
3. Do not use obvious comments which make code hard to read.




`F17 - ApexDoc`

> Please reference to ApexDoc file in your project to find the right formatting for ApexDoc

At minimum ApexDoc block should be presented for each:

1. Class, Interface declaration.
2. Method declaration  
3. (Optional) class property

> [ApexDoc](https://github.com/SalesforceFoundation/ApexDoc) is a java app that you can use to document your Salesforce Apex classes. You tell ApexDoc where your class files are, and it will generate a set of static HTML pages that fully document each class, including its properties and methods. Each static HTML page will include an expandable menu on its left hand side, that shows a 2-level tree structure of all of your classes. Command line parameters allow you to control many aspects of ApexDoc, such as providing your own banner HTML for the pages to use.
```
