## Resubmission
This is a resubmission. In this version I have:

* Eliminated the redundant "in R" in the title and description.

* Changed examples in man/AssessmentTest-class.Rd, man/AssessmentTestOpal-class.Rd,
man/start_server.Rd to make them executable.

* Eliminated examples for unexported functions (create_qti_task.Rd, create_qti_test.Rd).

* Eliminated \dontrun, where it was possible. In case of side effects such as creating a folder/files or starting a server, \dontrun is used.

* To deliver information to the console print()/cat() are changed to messages.

* Eliminated the calling of setwd().

The URL for the API was not added to the description because there is no permanent endpoint, each university using LMS Opal has its own.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
