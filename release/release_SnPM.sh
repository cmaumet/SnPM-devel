#!/bin/bash        
usage()
{
cat << EOF
usage: $0 options

This script create an SnPM release.

OPTIONS:
   -h      Show this message
   -i      SnPM version (e.g. SnPM13.01)
EOF
}

SNPM_VER=
while getopts “hi:” OPTION
do
     case $OPTION in
         h)
             echo option h
             usage
             exit 1
             ;;
         i)
             SNPM_VER=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $SNPM_VER ]] 
then
     usage
     exit 1
fi

MINOR=1

SNPM_ONLINE_DIR=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13
SNPM_CODE_DIR=/Users/cmaumet/Softs/dev/SnPM/spm12/toolbox/

#  Create new version directory (to be able to delete it at once instead of each manually)
SNPM_NEW_VERSION_DIR=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/new
if [ ! -d "$SNPM_NEW_VERSION_DIR" ]; then
    mkdir $SNPM_NEW_VERSION_DIR
fi

COREDIR=$SNPM_ONLINE_DIR/core
UPDATEDIR=$SNPM_ONLINE_DIR/updates

echo core folder: $COREDIR
echo update folder: $UPDATEDIR

# Remove . from SnPM version name (twice for minor and major)
SUBVER=`echo ${SNPM_VER} | tail -c 3`
echo version=13.${MINOR}.${SUBVER}

SNPM_VER=SnPM13_${MINOR}_${SUBVER}


#  Create log directory
LOGDIR=$SNPM_NEW_VERSION_DIR/logs${SNPM_VER}
if [ ! -d "$LOGDIR" ]; then
    mkdir $LOGDIR
fi
echo log folder: $LOGDIR

# --- Go into code folder
cd $SNPM_CODE_DIR

# # Tag (git) current version
# cd ./SnPM13
# # merge with master
# git checkout master
# git merge SnPM13
# git tag -a SnPM13.${SUBVER}  -m "SnPM version 13."${SUBVER} > ${LOGDIR}/log_01_tag.txt
# # Push only if tagging succeeded
# status=$?
# if [ $status -eq 0 ]; then
#     git push --tag
# fi
# cd ..

# Create a zip file containing all m-files found in the tree
zip -r ${SNPM_VER}.zip `find ./SnPM13 -type f \( -name '*.txt' -o -name '*.m' \)` > ${LOGDIR}/log_02_zip.txt
# Move the zip into the release folder
mv ${SNPM_VER}.zip ${SNPM_NEW_VERSION_DIR}

# --- Go into release folder
cd ${SNPM_NEW_VERSION_DIR}

# Créer l'update en regardant la différence entre SnPM13_00 et SnPM13_YY:
# Unzip the code to be released
unzip ${SNPM_VER}.zip > ${LOGDIR}/log_unzip.txt 

# Rename code folder with version name into separate folder
mv ./SnPM13 ./${SNPM_VER} > ${LOGDIR}/log_mv.txt

# Create update directory
SNPM_REF_DIR=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/core/SnPM13_00/SnPM13


echo ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${SUBVER}
~/Projects/SnPM/dev/create_update.sh -n ${SNPM_NEW_VERSION_DIR}/${SNPM_VER} -o ${SNPM_REF_DIR} -u ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER/./_} > ${LOGDIR}/log_create_update.txt

# cd ../updates -> Need to write README first
# zip SnPM13_updates_${SUBVER}.zip -r ./SnPM13_updates_${SUBVER} > ${LOGDIR}/log_zip_update.txt

# # - Faire un diff de SnPM13.XX avec précédente version pour mettre a jour le README de l'update
# cd ../core
PREVVER=0`expr $SUBVER - 1`
PREVMINOR=${MINOR}

DIFFILE_WITHPREV=diff_${MINOR}${SUBVER}${MINOR}${PREVVER}.txt
echo "diff"
echo $COREDIR/SnPM13_${PREVMINOR}_${PREVVER}
echo $SNPM_NEW_VERSION_DIR/${SNPM_VER}
diff -r $COREDIR/SnPM13_${PREVMINOR}_${PREVVER} $SNPM_NEW_VERSION_DIR/${SNPM_VER} > ${LOGDIR}/${DIFFILE_WITHPREV}
# Copy previous README
cp $UPDATEDIR/SnPM13_updates_${PREVMINOR}_${PREVVER}/README.txt ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER}

# DIFFFILE_WITHREF=diff_${SUBVER}$00.txt
# diff `pwd`/${SNPM_VER} ${SNPM_REF_DIR} > ${DIFFFILE_WITHREF}
open ${LOGDIR}/${DIFFILE_WITHPREV}
open ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER}/README.txt
cd ${UPDATEDIR}
echo "---> To do:" Update README according to ${DIFFILE_WITHPREV}
echo "---> To do: " zip SnPM13_updates_${MINOR}_${SUBVER}.zip -r ./SnPM13_updates_${MINOR}_${SUBVER}

# - Une fois OK, mettre SnPM13_YY.zip en ligne
echo "---> To do:" Upload ${SNPM_VER}.zip online
echo "---> To do:" Upload SnPM13_updates_${MINOR}_${SUBVER}.zip online
echo "---> To do: Copy README in github repo"
echo "---> To do: git tag"



