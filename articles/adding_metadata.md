# Adding metadata

Metadata—including details about creators, rights, and descriptions—is
essential for ensuring accountability, legal compliance, and clarity in
the management and use of assessment items and tests. This information
helps track content origin and ownership, while also providing clear
descriptions that facilitate better organization and retrieval of
assessment resources.

We utilize ONYX’s metadata implementation, which largely supports the
IEEE Learning Object Metadata (LOM) standard. As a result, metadata is
stored in XML format within the IMS manifest of the test data. However,
it is important to note that this metadata may not be displayed by other
learning management systems, and even OPAL may overwrite it. The primary
purpose is to maintain metadata within the original xml files being
shared.

Here is an example of metadata with two contributors in the yaml
section:

    ---
    title: Demonstration of metadata
    type: essay
    knit: rqti::render_qtijs
    identifier: demo_metadata

    metadata:
      contributor:
        - name: Andrey Shevandrin
          role: author
        - name: Johannes Titz 
          role: author
      description: Demonstration of metadata
      rights: CC BY SA Andrey Shevandrin and Johannes Titz (2024).
    ---

    # question

    Essay exercise with metadata attributes in the yaml section.

Currently, the metadata may contain the following information:

- **description**: A string providing a description of the task content.
- **rights**: A string outlining the usage rights and terms associated
  with the task.
- **version**: A string indicating the version of the task.
- **contributor**: A list of contributor details, where each contributor
  entry may include the following information:
  - **name**: A string representing the contributor’s name.
  - **role**: A string specifying the type of contribution. Possible
    values include: author, publisher, unknown, initiator, terminator,
    validator, editor, graphical designer, technical implementer,
    content provider, technical validator, educational validator, script
    writer, instructional designer, and subject matter expert. By
    default, `rqti` sets this value to “author”.
  - **contribution_date**: A string representing the date of
    contribution. By default, `rqti` sets this to the current system
    date.

If you are working on a set of tasks, setting metadata for each one
individually can be tedious. To streamline this process, you can use the
environment variables `RQTI_AUTHOR` and `RQTI_RIGHTS`, which will
automatically populate these fields with default values.

For example, you can create an `.Rprofile` file and set the default
author and usage rights as follows:

``` r
Sys.setenv(RQTI_AUTHOR = "Ada Lovelace")
Sys.setenv(RQTI_RIGHTS = "CC BY SA")
```

If you need to use non-default values, just specify the yaml attributes,
which will override the environment variables.
