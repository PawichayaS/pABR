% This script analyses a set of pABR recordings.
% Each file "Example_Voltage_And_Triggers_X" contains the recording
% made at X dB SPL and onset indices for 1000 tones at 1, 2, 4, 8, and 16kHz.

%% Extract signal and noise from raw data files

f_samp = 44100; % The sampling frequency of the ABR recording
offset = 0.092; % The delay between the onset of a tone in the sound file and the onset of the ABR waveform in the recording
dur = 0.011; % The duration of the ABR waveform
n_noise = 32; % The number of random sample waveform to extract for computing the noise distribution

signal = [];
noise = [];

for level = 0:10:100,

    load(sprintf('Example_Voltage_And_Triggers_%d',level));

    [temp_signal,temp_noise] = Extract_Signal_And_Noise(voltage,triggers,f_samp,offset,dur,n_noise);

    signal = cat(3,signal,permute(temp_signal,[1 2 4 3]));
    noise = cat(3,noise,permute(temp_noise,[1 2 4 3]));

end

signal = single(signal);
noise = single(noise);

save('Example_Signal_And_Noise','signal','noise');

%% Analyze signal and noise and estimate threshold

levels = 0:10:100; % Sound levels in dB SPL for each recording
freqs = [1 2 4 8 16]; % pABR tone frequencies

load('Example_Signal_And_Noise');

[tot_var,noise_var,log_tot_var,mean_log_noise_var,std_log_noise_var,snr_std] = Analyze_Signal_And_Noise(signal,noise);

save('Example_Signal_And_Noise_Analysis','tot_var','noise_var','log_tot_var','mean_log_noise_var','std_log_noise_var','snr_std');

std_thresh = 4.264; %Corresponding to p < 1e-5;

% Interpolate to 1 dB resolution
temp = interp1(levels,snr_std',levels(1):levels(end));

figure
for i_freq = 1:length(freqs),

    thresh(i_freq) = levels(1)+find(temp(:,i_freq)>std_thresh,1)-1;

    subplot(1,length(freqs),i_freq)
    h = plot(levels,snr_std(i_freq,:));
    hold on
    plot([levels(1) thresh(i_freq)],[std_thresh std_thresh]);
    plot([thresh(i_freq) thresh(i_freq)],[0 std_thresh]);
    plot(thresh(i_freq),0,'o');
    ylabel('Amplitude')
    xlabel('Sound level')
    ylim([-2 22])
    text(60,0,num2str(thresh(i_freq)));
end
subplot(1,length(freqs),ceil(length(freqs)/2))
title('ABR amplitude expressed as standard deviations above amplitude expected by chance')

