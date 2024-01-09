test_that("Testing createQtiTest() method for the object of character
          in case if the file does not exist", {

        path <- test_path("fileNotExist.xml")

        expect_error({
            createQtiTest(path)
            }, "The file does not exist")
})

test_that("Testing createQtiTest() method for the object of character
          in case if the file exist", {

        path_1 <- test_path("file/test_create_qti_task_Order.xml")
        path_2 <- test_path("file/rmd/test_OneInRowTable_example.Rmd")

        sut_1 <- createQtiTest(path_1)
        sut_2 <- createQtiTest(path_2)

        expected_path_1 <- file.path(getwd(),"Preview.zip")
        expected_path_2 <- file.path(getwd(),"test_OneInRowTable_example.zip")

        expect_equal(sut_1,expected_path_1)
        expect_equal(sut_2,expected_path_2)
        unlink("Preview.zip",recursive = TRUE)
        unlink("test_test_OneInRowTable_example.zip",recursive = TRUE)
})
