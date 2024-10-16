#bash

prg="./test"     # program to test
ext="result"     # extension of result file

rm -f *.$ext                # clean up previous results
for f_in in $(ls -t *.in)   # time sorted list of in-files
do
	f_out=$(basename $f_in in)"out"     # out-file name
	if [ -f $f_out ] ;                  # if exists, run test
	then
		tmp=$f_out"."$ext                   # full name of result file
		echo $f_in "->" $tmp "=?" $f_out    # show file names
		$prg <$f_in 2&>$tmp                 # run the program
		diff -q $tmp $f_out                 # compare files 
	fi
done
