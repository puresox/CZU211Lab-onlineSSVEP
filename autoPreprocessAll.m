clear;
clc;

eeglab nogui;
inputDir = './dataset/SSVEP1/raw';
outputDir = './dataset/SSVEP1/preprocessed';
subdir  = dir( inputDir );

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
            isequal( subdir( i ).name, '..')||...
            ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    subDir = subdir( i ).name;
    autoPreprocessOne(inputDir,outputDir,subDir);
end