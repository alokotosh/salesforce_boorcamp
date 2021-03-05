## Code Review Process

Code review is a required process of maintaining code quality, readability and maintainability.
Your architect od technical lead is responsible to establish this process correctly to minimize
the project risk and maintain code quality standards.

Best practices:
1. Use rules which you agreed to follow to raise you concern.
2. Assign more than one reviewer. The best if the whole team will review the target functionality. 

The following document propose 2 variants of code review process:


#### Prerequisites to all variants  
- [X] The whole team during ceremony agreed to utilize a Code Formatting, Naming Convention, ApexDocs and Code Quality guidelines during development and code review process.
- [X] The whole team agreed that ANY code sniped in those documents can be user to raise the concern or give the directives of what is wrong and what needs to be fixed.

- [X] (Optional) Necessary changes was made to each of the guidelines to resolve any disputes.
- [X] Developer reviewed the list of changes or list of new items that was developed and tested by him prior to code review.
- [X] Developer agreed that all changes which he/she made are following Code Formatting, Naming Convention, ApexDocs and Code Quality guidelines.

`Variant 1 - GIT`
- [ ] Developer send merge request and assign it for review 
- [ ] Reviewer will investigate implementation for subject of Code Quality/Best Practises violation
- [ ] Reviewer will check naming convention violation
- [ ] Reviewer will check code formatting violation
- [ ] Reviewer will check comments block/ApexDoc violation
- [ ] Reviewer will leave a comments in version control and discuss it with developer
- [ ] Developer agree to resolve the list of issues
- [ ] Repeat from step 1


`Variant 2 - List of changes`
- [ ] Developer will prepare the list of ALL changes which he made (All metadata)
- [ ] Reviewer will retrieve those changes to his project
- [ ] Reviewer will investigate implementation for subject of Code Quality/Best Practises rule violations
- [ ] Reviewer will check naming convention rule violations
- [ ] Reviewer will check code formatting rule violations
- [ ] Reviewer will check comment blocks/ApexDoc rule violations
- [ ] Reviewer will generate a list of changes that needed and discuss it with developer
- [ ] Developer agreed to resolve the list of issues
- [ ] Repeat from step 1 


#### Rule references example 

Apex:
- AccountTriggerHandler: l10,N4
- AccountTriggerHandler: l15,N6.3
- AccountTriggerHandler: l23,N8
- CaseResolutionService: l51,F5
- CaseResolutionService: l67,N7
- DisputeCenterController: l4, N2.1


