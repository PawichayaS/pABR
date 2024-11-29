function [signal,noise] = Extract_Signal_And_Noise(voltage,triggers,f_samp,offset,dur,n_noise,median_flag,plot_flag);

% Inputs:
% voltage   -   the recorded voltage [samps x 1]
% triggers  -   the start sample of each tone [freqs x trials]
% f_samp    -   the sampling rate of the recording
% offset    -   the start time of the averaging window relative to the tone
% dur       -   the duration of the averaging window
% n_noise   -   the number of independent random samples for estimating chance
% raw_flag  -   1 to return median over trials, 0 to return all trials
% plot_flag -   1 to plot results, 0 otherwise

% Outputs:
% signal    -   the average voltage in the window following each tone
% noise     -   the average voltage in random windows

% Note that alternating polarity tones at each frequency are assumed

if nargin < 3; f_samp = 44100; end
if nargin < 4; offset = 0.092; end
if nargin < 5; dur = 0.011; end
if nargin < 6; n_noise = 32; end
if nargin < 7; median_flag = 0; end
if nargin < 8; plot_flag = 0; end

offset_samps = floor(offset*f_samp);
avg_samps = floor(dur*f_samp);
trial_samps = size(voltage,1);
[n_freqs,n_tones] = size(triggers);

signal = NaN(avg_samps+1,n_freqs,n_tones);
noise = NaN(avg_samps+1,n_noise,n_tones);

% Grab the voltage in the window following each trigger
for i_freq = 1:n_freqs,
    for i_tone = 1:n_tones,

        rng = triggers(i_freq,i_tone)+offset_samps:triggers(i_freq,i_tone)+offset_samps+avg_samps;

        try % If too close to beginning or end to grab a full waveform, then skip
            signal(:,i_freq,i_tone) = voltage(rng);
        catch
            keyboard
        end
    end
end

% Grab the voltage in random windows
for i_noise = 1:n_noise,
    for i_tone = 1:n_tones,

        temp = randi(trial_samps,1);
        rng = temp+offset_samps:temp+offset_samps+avg_samps;

        while rng(1)<1 | rng(end)>length(voltage) % If too close to beginning or end to grab a full waveform, try again
            temp = randi(trial_samps,1);
            rng = temp+offset_samps:temp+offset_samps+avg_samps;
        end
        noise(:,i_noise,i_tone) = voltage(rng);
    end
end


if median_flag,
    signal = median(signal,3);
    noise = median(noise,3);
end

if plot_flag,
    figure
    dt = 1/f_samp;
    if median_flag,
        y_max = max(abs(signal(:)));
    else
        temp = median(signal,3);
        y_max = max(abs(temp(:)));
    end
    t = dt:dt:(avg_samps+1)*dt;
    for i_freq = 1:n_freqs,
        subplot(1,n_freqs,i_freq)
        if median_flag,
            plot(1000*t,noise,'k')
            hold on
            plot(1000*t,signal(:,i_freq),'r');
        else
            plot(1000*t,median(noise,3),'k')
            hold on
            plot(1000*t,median(signal(:,i_freq,:),3),'r');
        end
        xlabel('Time (ms)')
        set(gca,'YLim',[-y_max y_max]);
    end
end
