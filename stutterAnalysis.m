function [nsd, ts] = stutterAnalysis(filename, threshold)
nsd = 0; ts = [];
if nargin < 1
    filename = 'severe_stutter.wav';
end
if nargin < 2
   threshold = 0.07; 
end
[sig, fs] = audioread(filename);
%sig contains sample data for the audio file
%fs contains the sample rate for the audio file
[nsamples,nchannels] = size(sig);
if nchannels > 1
    % Add normalized left & right channel
    sig = (sig(:,1)/max(sig(:,1))) + (sig(:,2)/max(sig(:,1)));
end
t = (0:1/fs:((nsamples-1)/fs)).';
%soundsc(sig,fs);
tstutter1 = (t>1.5) & (t<2.5);
tstutter2 = (t>3.2) & (t<4);
tstutter3 = (t>10.2) & (t<14);
stutter1 = sig(tstutter1);
stutter2 = sig(tstutter2);
stutter3 = sig(tstutter3);
%soundsc(stutter1,fs);
%soundsc(stutter2,fs);
%soundsc(stutter3,fs);

%cross correlation
acor1 = xcorr(sig,stutter1);
acor2 = xcorr(sig,stutter2);
acor3 = xcorr(sig,stutter3);

%acor1 = acor1 ./ norm(acor1,2);
%acor2 = acor2 ./ norm(acor2,2);
%acor3 = acor3 ./ norm(acor3,2);

a=.95;

pre_emp=filter([1,-a],1,sig);


windowed=pre_emp.*hamming(length(t));



%nframe = floor(nsamples/windowed);
%ffts = abs(fft(windowed));
%ffts = ffts(1:nsamples/2);
%f = fs* (0:nsamples/2-1)/nsamples;
nfft = 2^nextpow2(length(windowed));
transform = fft(windowed,nfft);
logmagspec = log(abs(transform(1:nfft/2+1))+eps);
cepstrum = dct(logmagspec);
%z = idct(cepstrum,t);
cepstrum = cepstrum(1:800);




%convert to db
cep = 20*log10(windowed); 
   

figure(1);
subplot(6,1,1);
plot(t,sig)
subplot(6,1,2);
plot(t,pre_emp)
subplot(6,1,3);
plot(t,windowed)
subplot(6,1,4);
plot(t,cep)
%subplot(6,1,5);
%plot(t,z)
t = t(1:800);
subplot(6,1,6);
plot(t,cepstrum)
disp(nfft);



