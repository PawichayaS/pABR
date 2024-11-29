function [s_l, s_r, ix_l, ix_r] = Create_pABR_Sounds(freqs,stim_rate,epoch_dur,f_samp,n_cycles,edge_skip,plot_flag)
% This function creates pABR sounds. It returns two sound vectors, one for each ear,
% as well as the samples within the sound vectors at which the tones at each frequency occur. 
% The input parameters are decsribed next to the default value assignments below.

%% Sound parameters
if nargin < 1; freqs = 1000.*[1 2 4 8 16]; end % Tone frequencies to include (Hz)
if nargin < 2; stim_rate = 40; end %Number of tones per second for each frequency - keep this number even!
if nargin < 3; epoch_dur = 100; end % Total duration of sound (s)
if nargin < 4; f_samp = 44100; end % Sampling rate for sound (Hz)
if nargin < 5; n_cycles = 5; end % Number of cycles per tone pip
if nargin < 6; edge_skip = 0.05; end % Don't put any tones this close to the start or end of file (s)
if nargin < 7; plot_flag = 1; end % Plot the first few tones?

%% Create waveforms for each frequency
for i_freq = 1:length(freqs),

    dur = ceil(n_cycles*f_samp/freqs(i_freq));

    win = blackman(dur);

    dur = n_cycles/freqs(i_freq);

    t = [0:(1/f_samp):(ceil(dur*f_samp)-1)/f_samp]';

    waves{i_freq} = cos(2*pi*freqs(i_freq)*t).*win;

end

%% Create sound
dur = floor(epoch_dur*f_samp);

s_l = zeros(dur,1);
s_r = s_l;

edge = floor(edge_skip*f_samp);
ix_all = edge+1:dur-edge;

polarity = 1;

for i_freq = 1:length(freqs),

    ix = ix_all(randperm(length(ix_all)));
    ix_l{i_freq} = sort(ix(1:(stim_rate*epoch_dur)));

    for i_stim = 1:stim_rate*epoch_dur,

        rng = ix(i_stim)-ceil(length(waves{i_freq})/2):ix(i_stim)-ceil(length(waves{i_freq})/2)+length(waves{i_freq})-1;

        s_l(rng) = s_l(rng)+polarity*waves{i_freq};

        polarity = -polarity;

    end

    ix = ix_all(randperm(length(ix_all)));
    ix_r{i_freq} = sort(ix(1:(stim_rate*epoch_dur)));

    for i_stim = 1:stim_rate*epoch_dur,

        rng = ix(i_stim)-ceil(length(waves{i_freq})/2):ix(i_stim)-ceil(length(waves{i_freq})/2)+length(waves{i_freq})-1;

        s_r(rng) = s_r(rng)+polarity*waves{i_freq};

        polarity = -polarity;

    end
end

%% Plot the sounds and label the first tone for each frequency
if plot_flag
    x_max = floor(f_samp/10);
    t = 1/f_samp:1/f_samp:dur/f_samp;
    figure
    subplot(2,1,1)
    plot(t(1:x_max),s_l(1:x_max)),
    for i_freq = 1:length(freqs),
        x = ix_l{i_freq}(1);
        text(t(x),1,num2str(freqs(i_freq)));
    end  
    subplot(2,1,2)
    plot(t(1:x_max),s_r(1:x_max)),
    for i_freq = 1:length(freqs),
        x = ix_r{i_freq}(1);
        text(t(x),1,num2str(freqs(i_freq)));
    end
    xlabel('Time (s)')
end
