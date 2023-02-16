CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
if [[ -f ./compile-error.txt ]]
    then
    rm *.txt
fi
if [[ -f ./ListExamples.class ]]
    then
    rm ListExamples.java *.class
fi
git clone $1 student-submission
if [[ !(-f ./student-submission/ListExamples.java) ]] 
    then
    echo "ListExamples.java not found."
    exit
fi

#Copy .java files into a new directory
cp ./student-submission/ListExamples.java ./

#Test the student submission
javac ListExamples.java 2> compile-error.txt
if [[ $? -ne 0 ]] 
    then
    echo "ListExamples.java failed compiling."
    cat compile-error.txt
    exit
fi

pwd

javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> test-compile-error.txt
if [[ $? -ne 0 ]] 
    then
    echo "Tests failed compiling."
    cat test-compile-error.txt
    exit
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > test-output.txt
cat test-output.txt
head -n 2 test-output.txt > lines-1to2.txt 
tail -n 1 lines-1to2.txt > line2.txt
ERRORS=`grep -o -i "E" line2.txt | wc -l`

#cat lines-1to2.txt
NUMTESTS=`grep -o -i "\." line2.txt | wc -l`
#echo "ERRORS:"$ERRORS
SUCCESSES=$(($NUMTESTS-$ERRORS))
echo $SUCCESSES "/" $NUMTESTS
#echo `($ERRORS/$NUMTESTS)`


#echo $ERRORS
#if [[ $ERRORS -eq 0 ]]
#    then
#    echo "100%"
#    exit
#else 
#    echo "0%"
#    exit
#fi