# Create an Zip archive of QTI test

Generic function for creating zip archive with set of XML documents of
specification the test following the QTI schema v2.1

## Usage

``` r
createZip(object, input, output, file_name, zip_only)

# S4 method for class 'AssessmentTest'
createZip(object, input, output, file_name, zip_only)

# S4 method for class 'AssessmentTestOpal'
createZip(object, input, output, file_name, zip_only)
```

## Arguments

- object:

  an instance of the S4 object
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md)
  or
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)

- input:

  string, optional; a source folder with xml files

- output:

  string, optional; a folder to store zip and xml files; working
  directory by default

- file_name:

  string, optional; file name of zip archive

- zip_only:

  boolean, optional; returns only zip file in case of TRUE or zip, xml
  and downloads files in case of FALSE value
