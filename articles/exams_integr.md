# Integration of the exams Package in rqti

    #> Registered S3 method overwritten by 'textutils':
    #>   method             from 
    #>   toLatex.data.frame exams

## Using exams Rmd files in section()

In addition to native `rqti` task definitions, the `rqti` package allows
the use of tasks written in the format of the `exams` package.

This integration makes it possible to reuse existing `exams` R Markdown
files and include them directly in `rqti` workflows.  
When an `.Rmd` file is provided, `rqti` automatically detects its format
based on the structure of the file. Based on this detection, the file is
processed accordingly.

R Markdown files from the `exams` package can be passed directly to the
[`section()`](https://shevandrin.github.io/rqti/reference/section.md)
function, just like native `rqti` tasks and/or objects.

``` r

sect <- section(
        content = c(
            "rqti_task.Rmd",      # native rqti format
            "exams_task.Rmd",     # exams format
            sc_object            # existing rqti object
        )
)
```

rqti converts exams_task.Rmd into an XML file in QTI 2.1 format using
functionality from the exams package.

## Integration with OpenOLAT configuration

The rqti package also relies on functionality from the exams package to
create configuration files required by learning management systems such
as OpenOLAT.

In particular, the configuration file (QTI21PackageConfig.xml) is
generated using helper functions from exams. This ensures compatibility
with OpenOLAT while keeping the implementation aligned with existing
tools.
