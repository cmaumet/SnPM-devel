% Prepare a release of SnPM. 
% Example of usage: release_SnPM('SnPM13.0.7', '/tmp/SnPM_release')
%_______________________________________________________________________
% Copyright (C) 2017 The University of Oxford
% Id: snpm_release.m  SnPM13 2017/09/28
% Camille Maumet
function snpm_release(version, release_dir, prev_release)
%     minor = 1;
    snpm_online_dir = release_dir;
    snpm_code_dir = spm_file(which('snpm'), 'path');
    
    if ~isdir(snpm_online_dir)
        error([release_dir ' does not exist.'])
    end
    
    % Create new version directory (to be able to delete it at once instead 
    % of each manually)
    snpm_new_version_dir = fullfile(snpm_online_dir, 'new');
    if ~isdir(snpm_new_version_dir)
        mkdir(snpm_new_version_dir)
    end
    
    core_dir = fullfile(snpm_online_dir, 'core');
    update_dir = fullfile(snpm_online_dir, 'updates');
    
    SnPM_ver = version;
    version_numbers = split(version, '.');
    major = version_numbers{1};
    minor = version_numbers{2};
    subver = version_numbers{3};
    
    log_dir = fullfile(snpm_new_version_dir, ['logs_' SnPM_ver]);
    if ~isdir(log_dir)
        mkdir(log_dir);
    end
    disp(log_dir);
    
    cwd = pwd;
    cd(spm_file(snpm_code_dir, 'path'));
    
    % Create a zip file containing all m-files found in the tree
    zip_filename = [SnPM_ver '.zip'];
    zip(zip_filename, {'SnPM13/*.m', 'SnPM13/*.txt', 'SnPM13/config/*.m', 'SnPM13/test/*.m'});
    
    % Move the zip into the release folder
    movefile(zip_filename, snpm_new_version_dir)

    % --- Go into release folder
    cd(snpm_new_version_dir)
    unzip(zip_filename)
    % Rename code folder with version name into separate folder
    movefile('SnPM13', SnPM_ver)
    
    % Create update directory
%     snpm_ref_dir = 

    visdiff(prev_release, SnPM_ver)
% SNPM_REF_DIR=/Users/cmaumet/Projects/SnPM/SnPM_online/SnPM13/core/SnPM13_00/SnPM13
% 
% 
% echo ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${SUBVER}
% ~/Projects/SnPM/dev/create_update.sh -n ${SNPM_NEW_VERSION_DIR}/${SNPM_VER} -o ${SNPM_REF_DIR} -u ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER/./_} > ${LOGDIR}/log_create_update.txt
% 
% # cd ../updates -> Need to write README first
% # zip SnPM13_updates_${SUBVER}.zip -r ./SnPM13_updates_${SUBVER} > ${LOGDIR}/log_zip_update.txt
% 
% # # - Faire un diff de SnPM13.XX avec précédente version pour mettre a jour le README de l'update
% # cd ../core
% PREVVER=0`expr $SUBVER - 1`
% PREVMINOR=${MINOR}
% 
% DIFFILE_WITHPREV=diff_${MINOR}${SUBVER}${MINOR}${PREVVER}.txt
% echo "diff"
% echo $COREDIR/SnPM13_${PREVMINOR}_${PREVVER}
% echo $SNPM_NEW_VERSION_DIR/${SNPM_VER}
% diff -r $COREDIR/SnPM13_${PREVMINOR}_${PREVVER} $SNPM_NEW_VERSION_DIR/${SNPM_VER} > ${LOGDIR}/${DIFFILE_WITHPREV}
% # Copy previous README
% cp $UPDATEDIR/SnPM13_updates_${PREVMINOR}_${PREVVER}/README.txt ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER}
% 
% # DIFFFILE_WITHREF=diff_${SUBVER}$00.txt
% # diff `pwd`/${SNPM_VER} ${SNPM_REF_DIR} > ${DIFFFILE_WITHREF}
% open ${LOGDIR}/${DIFFILE_WITHPREV}
% open ${SNPM_NEW_VERSION_DIR}/SnPM13_updates_${MINOR}_${SUBVER}/README.txt
% cd ${UPDATEDIR}
% echo "---> To do:" Update README according to ${DIFFILE_WITHPREV}
% echo "---> To do: " zip SnPM13_updates_${MINOR}_${SUBVER}.zip -r ./SnPM13_updates_${MINOR}_${SUBVER}
% 
% # - Une fois OK, mettre SnPM13_YY.zip en ligne
% echo "---> To do:" Upload ${SNPM_VER}.zip online
% echo "---> To do:" Upload SnPM13_updates_${MINOR}_${SUBVER}.zip online
% echo "---> To do: Copy README in github repo"
% echo "---> To do: git tag"

end