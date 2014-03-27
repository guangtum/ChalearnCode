% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
%                               SAMPLE CODE FOR THE
%                    MULTIMODAL GESTURE RECOGNITION CHALLENGE
%    
%                             version 0.1 -- JUNE 2013
%                                   
% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY
% THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL CONTRIBUTORS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE.
% 

clear all; close all; clc;

% Specify the paths to development, validation and eventually test data
dev_data_dir='C:\ICMI_challenge\all\';
valid_data_dir='C:\ICMI_challenge\validation_all\';

% provide a filename for your run
run_name='-1NN-DTW-AVGSEG';

% % % extract the zip files only the first time you run this code
% extract_zip_files(dev_data_dir);
% extract_zip_files(valid_data_dir);

% parameters for the extraction of features
params.use_joints=1:20; % which out of the 20 joints to use
params.scale=0.05;      % scale parameter for the extraction of motion energy
params.tau=3;           % window size for the buffer representation

% Load training data
[TS,LT] = load_challenge_data(dev_data_dir,params);
fprintf(['Loading development data ...\n']);

% Load validation data
[VS,LV] = load_challenge_data(valid_data_dir,params);
fprintf(['Loading validation data ...\n']);

% get the average duration of gestures
for i=1:length(TS),
    LG(i)=size(TS(i).XYZ,2);
end


fprintf(['Recognition process ...\n']);
% k-value for knn
k=1;

% subsample training data, it may be expensive to use all for knn
ss_size=100;
r=randperm(length(TS));
TS=TS(r(1:ss_size));

% open the file for the submission
fid = fopen([strrep(strrep(datestr(now),':',''),' ','')  run_name '.csv'],'w');
fprintf(fid,['Id,Sequence\n']);
%% classify validation gestures using a simple segmenter and classifier
for i=1:length(VS),
    fprintf('.');
    NumFrames=size(VS(i).XYZ,2);
    
    % get the maximum number of gestures in this video sequence
    N=min(max(1, round(NumFrames/mean(LG))), max(LT));    
    step=round(NumFrames/N);  
    b=1; e=step;    
    an=[strrep(VS(i).name,'Sample','') ',' ];        
       
    for ii=1:N
        if ii==1, 
            b=1;e=step;
        else
            b=e+1; e=min(e+step, NumFrames);
        end
        
        ofin=b:e;
        GES=VS(i).XYZ(:,ofin);
            
        for jj=1:length(TS),
            [DistXp(jj),DXp,kXp(jj),wXp]=dtw(TS(jj).XYZ,GES);
            if ~isempty(TS(jj).id_labels),
                clbs(jj)=TS(jj).id_labels;
            else
                clbs(jj)=randi(20);
            end
            
        end
        [AA,BB]=sort(DistXp);
        an=[an num2str(clbs(BB(1:k))) ' '];                    
        clear DistXp kXp AA BB clbs;
    end
    fprintf(fid,[an '\n']);    
end
fprintf('\n');
fclose(fid);

