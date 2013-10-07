function snpm_init
% Example how to use matlabbatch in a simple application. Two steps are
% necessary: 
% 1) write configuration files that define the user interface for the
%    application (for this example: cfg_example_master and related files)
%    and collect it in a cfg_mlbatch_appcfg file
% 2) at application startup, include path to cfg_mlbatch_appcfg and
%    application cfg_ files in MATLAB path. Once cfg_util is called for
%    the first time, it will collect all applications and add them to its
%    configuration. 
% This example application does nothing else then cfg_util
% initialisation. A real application would do much more (GUI setup for
% non-batch GUI elements, computations etc.).
%    
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: toy_example.m 1716 2008-05-23 08:18:45Z volkmar $

rev = '$Rev: 1716 $'; %#ok

if exist('snpm_defaults')~=2
  error('Cannot initialize - SnPM toolbox not found in path')
end
if isempty(whos('global','SnPMdefs'))
  snpm_defaults
end

% the application config resides in the current directory, therefore add
% this to the path
p = fileparts(mfilename('fullpath'));
addpath(fullfile(p,'config'));

% Commented as we do not want to automatically open the batch window.
% Instead a menu is created and depending on the use interaction, the batch
% will be open with a specific type of job.
% % cfg_util initialisation
% cfg_util('initcfg');
% % fire up batch user interface
% cfg_ui;
