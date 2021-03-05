## Code Quality (In Progress, TBD)

Rules which enforce generally accepted best practices for apex code writting.
The outcome of those rules is:

* alignment with platform limits and multi-tenant architecture
* code which perform well with the expected outcome
* code design which is easy to understand but efficient in the runtime
* avoid anti-patterns



| Index | Rule Name                  | PMD Rule                                                 |
|-------|----------------------------|----------------------------------------------------------|
| C1    | Login in Trigger           | [AvoidLogicInTrigger]( https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#avoidlogicintrigger )                                   |
| C2    | Operations in the Loop     | [OperationWithLimitsInLoop]( https://pmd.github.io/latest/pmd_rules_apex_performance.html#operationwithlimitsinloop )                                                         |
 