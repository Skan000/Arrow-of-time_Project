clear all

%WM Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/WMemory/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsWMem = processed;
save('Concat_TaskWM_100.mat','concatPatientsWMem')

%Gamble Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Gambling/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsGamble = processed;
save('Concat_Gamble_100.mat','concatPatientsGamble')

%Social Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Social/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsSocial = processed;
save('Concat_Social_100.mat','concatPatientsSocial')

%Motor Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Motor/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsMotor = processed;
save('Concat_Motor_100.mat','concatPatientsMotor')

%Language Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Language/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsLanguage = processed;
save('Concat_Language_100.mat','concatPatientsLanguage')

%Relational Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Relational/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsRelational = processed;
save('Concat_Relational_100.mat','concatPatientsRelational')

%Emotion Tasks
path='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Task/Emotion/';

files=dir(path);
processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files(2+i).name);
    load(filename);
    processed(:,:,i)=zscore(TCS')';
end
concatPatientsEmotion = processed;
save('Concat_Emotion_100.mat','concatPatientsEmotion')

%All rest runs
path1LR='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Rest/Rest1LR/';
files1LR=dir(path);
path1RL='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Rest/Rest1RL/';
files1RL=dir(path);
path2LR='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Rest/Rest2LR/';
files2LR=dir(path);
path2RL='../../../media/miplab-nas3/HCP-Data/100_unrelated_rest_task/preprocessing_code/TCS/Rest/Rest2RL/';
files2RL=dir(path);

processed=[];
nPatients=100;
for i=1:nPatients
    filename=path+string(files1LR(2+i).name);
    load(filename);
    processed(:,:,(i-1)*4+1)=zscore(TCS')';
    filename=path+string(files1RL(2+i).name);
    load(filename);
    processed(:,:,(i-1)*4+2)=zscore(TCS')';
    filename=path+string(files2LR(2+i).name);
    load(filename);
    processed(:,:,(i-1)*4+3)=zscore(TCS')';
    filename=path+string(files2RL(2+i).name);
    load(filename);
    processed(:,:,(i-1)*4+4)=zscore(TCS')';
end
concatPatientsAllRestSep = processed;
save('Concat_AllRestSep_100.mat','concatPatientsAllRestSep')