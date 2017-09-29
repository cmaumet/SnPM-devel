#!/bin/bash        
usage()
{
cat << EOF
usage: $0 options

This script create an SnPM release.

OPTIONS:
   -h      Show this message
   -n      Path to new directory
   -o      Path to old directory
   -u      Path to update directory
EOF
}

NEWDIR=
OLDDIR=
UPDATE=
while getopts “hn:o:u:” OPTION
do
     case $OPTION in
         h)
             echo option h
             usage
             exit 1
             ;;
         n)
             NEWDIR=$OPTARG
             ;;
         o)
             OLDDIR=$OPTARG
             ;;
         u)
             UPDATE=$OPTARG
             ;;                          
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $NEWDIR ]] || [[ -z $OLDDIR ]] || [[ -z $UPDATE ]] 
then
     usage
     exit 1
fi

# # setup folders for our different stages
# new=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/core/SnPM13_05
# old=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/core/SnPM13_00/SnPM13
# diff=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/core/SnPM13_05_up
if [ ! -d "$UPDATE" ]; then
	mkdir $UPDATE
fi

cd $NEWDIR

echo `ls`
for f in `ls`
do
	if [[ -f $f ]]; then
	# Diff the files - ignore the output...
	    diff $f $OLDDIR > /dev/null 2>&1
	# ...but get the status
	    status=$?
	    if [ $status -eq 0 ] ; then
	# Files are identical - don't copy the file
	        echo $f unchanged
	    elif [ $status -eq 1 ] ; then
	# Files differ - copy new file
	        echo $f changed
	        cp -v $f $UPDATE
	    elif [ $status -eq 2 ] ; then
	# Old file doesn't exist - copy new file
	        echo old $f does not exist
	        cp -v $f $UPDATE
	    fi
	elif [[ -d $f ]]; then
		echo $f is a directory
		cd $f
		for subf in `ls`
		do
			if [[ -f $subf ]]; then
				# Diff the files - ignore the output...
				    diff $subf $OLDDIR/$f > /dev/null 2>&1
				# ...but get the status
				    status=$?
				    # if [ $status -eq 0 ] ; then
				# Files are identical - don't copy the file
				        # echo $f unchanged
				    if [ $status -eq 1 ] ; then
				# Files differ - copy new file
				        echo $f/$subf changed
				        if [ ! -d $UPDATE/$f ]; then
				        	mkdir -v $UPDATE/$f
				        fi
				        cp -v $subf $UPDATE/$f
				    elif [ $status -eq 2 ] ; then
				# Old file doesn't exist - copy new file
				        echo old $subf does not exist
				        if [ ! -d $UPDATE/$f ]; then
				        	mkdir -v $UPDATE/$f
				        fi
				        cp -v $subf $UPDATE/$f
				    fi
			elif [[ -d $subf ]]; then
				echo $subf is a directory
				cd $subf
				for subsubf in `ls`
				do
					if [[ -f $subsubf ]]; then
						# Diff the files - ignore the output...
						    diff $subf $OLDDIR/$f/$subf > /dev/null 2>&1
						# ...but get the status
						    status=$?
						    # if [ $status -eq 0 ] ; then
						# Files are identical - don't copy the file
						        # echo $f unchanged
						    if [ $status -eq 1 ] ; then
						# Files differ - copy new file
						        echo $f/$subf/$subsubf changed
						        if [ ! -d $UPDATE/$f ]; then
						        	mkdir -v $UPDATE/$f
						        fi
						        if [ ! -d $UPDATE/$f/$subf ]; then
						        	mkdir -v $UPDATE/$f/$subf
						        fi
						        cp -v $subsubf $UPDATE/$f/$subf
						    elif [ $status -eq 2 ] ; then
						# Old file doesn't exist - copy new file
						        echo old $subf does not exist
						        if [ ! -d $UPDATE/$f ]; then
						        	mkdir -v $UPDATE/$f
						        fi
						        if [ ! -d $UPDATE/$f/$subf ]; then
						        	mkdir -v $UPDATE/$f/$subf
						        fi
						        cp -v $subsubf $UPDATE/$f/$subf
						    fi
					elif [[ -d $subf ]]; then
							#statements
						echo WARNING: Too many intricate levels
					fi
				done
			fi
		done
		cd $NEWDIR
	fi
done