function [] = autoPreprocessOne(inputDir,outputDir,subDir)
% eeglab nogui;
inputpath = fullfile( inputDir, subDir );
% 1数据导入
% [filename, pathname] = uigetfile({'*.bdf;*.edf;*.*'}, 'Pick a recorded EEG data file','MultiSelect', 'on');
filename = {'data.bdf','evt.bdf'};
EEG = pop_importNeuracle(filename, inputpath);
EEG.etc.eeglabvers = '2021.0'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG.setname='s1';
EEG = eeg_checkset( EEG );
% 保存events
EEG.events = [EEG.event.type];
% 2导联定位
% use BESA file for 4-shell dipfit spherical model
EEG=pop_chanedit(EEG, 'lookup','D:\\puresox\\code\\MATLAB\\eeglab\\plugins\\dipfit4.0\\standard_BESA\\standard-10-5-cap385.elp');
EEG.setname='s2';
EEG = eeg_checkset( EEG );
% 3删除无用数据
% EEG = pop_select( EEG, 'nochannel',{'ECG','HEOR','HEOL','VEOU','VEOL'});
EEG = pop_select( EEG, 'channel',{'Pz','P3','P4','PO7','PO8','Oz','O1','O2'});
EEG.setname='s3';
EEG = eeg_checkset( EEG );
% 4滤波-带通滤波
EEG = pop_eegfiltnew(EEG, 'locutoff',5,'hicutoff',40);
EEG.setname='s4-1';
EEG = eeg_checkset( EEG );
% 4滤波-凹陷滤波
EEG = pop_eegfiltnew(EEG, 'locutoff',49,'hicutoff',51,'revfilt',1);
EEG.setname='s4-2';
EEG = eeg_checkset( EEG );
% 5重参考
EEG = pop_reref( EEG, []);
EEG.setname='s5';
EEG = eeg_checkset( EEG );
% 6降低采样率
% EEG = pop_resample( EEG, 1000);
% EEG.setname='s6';
% EEG = eeg_checkset( EEG );
% 7插值坏导
% EEG = pop_interp(EEG, [59], 'spherical');
% 8独立主成分分析

% 9分段
EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  }, [0.14  2.14], 'newname', 's9', 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
% 小波
n=4;
for i=1:40
    for j=1:8
        wdata=EEG.data(j,:,i);
        m_wav='db5';
        [c,l]=wavedec(wdata,n,m_wav);
        
        % 时域波形
        % 重构1~4层逼近信号
        a4=wrcoef('a',c,l,'db5',n);
        EEG.data(j,:,i)=a4;
    end
end
% 10基线校正
EEG = pop_rmbase( EEG, [],[]);
EEG.setname='s10';
EEG = eeg_checkset( EEG );
% 11剔除坏段
% 显示数据
% pop_eegplot( EEG, 1, 1, 1);
% 12保存数据
outputpath = fullfile( outputDir,subDir );
mkdir(outputDir,subDir);
EEG = pop_saveset( EEG, 'filename','s12.set','filepath',outputpath);
end