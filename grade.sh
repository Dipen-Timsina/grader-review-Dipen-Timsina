CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

#check that students code contains the listexamples.java file
if [[ -f student-submission/ListExamples.java ]]
then 
    echo "ListExamples.java found."
else 
    echo "ListExamples.java not found. Rename file to ListExamples.java and try again."
    echo "Grade: 0"
    exit 1
fi

#put all the relevant files in the grading area directory, testlistexamples.java, ListExamples.java, lib directory
cp TestListExamples.java grading-area
cp student-submission/ListExamples.java  grading-area
cp -r lib grading-area

#compile the java files and check they compiled sucuessfully
cd grading-area
echo "Compiling the java files"
javac -cp $CPATH *.java
if [[ $? -eq 0 ]]
then
    echo "Compilation successful, The exit code is $?"
else
    echo "Compilation failed, did not compile successfully, please fix"
    echo "Grade: 0"
    exit 1
fi

#run the tests and give grade based on the output of the junit, not just 0 and 100

# Run the tests and redirect the output to a file
echo "Running the tests"  
java -cp "$CPATH" org.junit.runner.JUnitCore TestListExamples > testResults.txt

# Extract and print test results information
Testruns=$(grep "Tests run" testResults.txt)
Failures=$(grep "FAILURES !!!" testResults.txt)

# Check if there were any failures
if grep -q "FAILURES !!!" testResults.txt; then
    echo "Some tests failed."
    grep  "FAILURES !!!" testResults.txt
    echo "Grade: 0"
else
    echo "All tests passed."
    echo "Grade: 100"
fi
