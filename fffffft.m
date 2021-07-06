Fs = 1000;            % 采样率
T = 1/Fs;             % 采样周期
L = 2000;             % 时长
t = (0:L-1)*T;        % 时间向量
X = EEG.data(8,:,1);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f(1:100),P1(1:100)) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')