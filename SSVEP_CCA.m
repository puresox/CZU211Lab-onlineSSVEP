clear;
clc;

Fs = 1000;            % 采样率
T = 1/Fs;             % 采样周期
L = 2000;             % 时长
t = (0:L-1)*T;        % 时间向量
frequencies = [7.5,8.57,10,12];
frequencyNum = length(frequencies);
harmonicNum = 3;
% 构造参考信号
Ys=[];
for i=1:frequencyNum
    for j=1:harmonicNum
        timeArray = 2*pi*j*frequencies(i)*t;
        Ys=[Ys;sin(timeArray);cos(timeArray)];
    end
end

eeglab nogui;
maindir = './dataset/SSVEP1/preprocessed';
subdir  = dir( maindir );
temp = 0;
% 数据导入
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
            isequal( subdir( i ).name, '..')||...
            ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    inputpath = fullfile( maindir, subdir( i ).name );
    EEG = pop_loadset( 'filename','s12.set','filepath',inputpath);
    % 处理每个分段
    epochNum = size(EEG.data,3);
    for epochIndex=1:epochNum
        X(:,:) = EEG.data(:,:,epochIndex);
        % 与不同频率的参考信号CCA
        result = [];
        for j=1:frequencyNum
            Y(:,:) = Ys(2*harmonicNum*(j-1)+1:2*harmonicNum*j,:);
            [A,B,r,U,V,stats] = canoncorr(X.',Y.');% 转置
            result(j) = r(1);
        end
        [M,I] = max(result);
        if string(I) == EEG.events(epochIndex)
            temp = temp+1;
        end
    end
end
temp/54