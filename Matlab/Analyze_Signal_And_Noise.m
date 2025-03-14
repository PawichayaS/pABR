function [tot_var,noise_var,log_tot_var,mean_log_noise_var,std_log_noise_var,snr_std] = Analyze_Signal_And_Noise(signal,noise)

% Inputs:
% signal    -   the average voltage in the window following each tone [time bins x freqs x levels x trials]
% noise     -   the average voltage in random windows [time bins x noise_instances x levels x trials]

% Outputs:
% tot_var   -   the total variance over time of the ABR waveform for each frequency and level after averaging across trials [freqs x levels]
% noise_var -   the noise variance in the ABR waveform for each noise instance and level after averaging across trials [noise_instances x levels]
% log_tot_var - the log of tot_var [freqs x levels]
% mean_log_noise_var - the mean over noise instances of the log of noise_var, repeated to match the number of frequencies [freqs x levels]
% std_log_noise_var  - the standard deviation over noise instances of the log of noise_var, repeated to match the number of frequencies [freqs x levels]
% snr_std   - the signal-to-noise ration of the estimated ABR expressed in terms of the standard deviation of the noise distribution [freqs x levels]

[n_samps,n_freqs,n_levels,n_trials] = size(signal);

n_noise = size(noise,2);

avg_signal = median(signal,4);
avg_noise = median(noise,4);

tot_var = squeeze(var(avg_signal));
noise_var = squeeze(var(avg_noise));

log_tot_var = log(tot_var);
mean_log_noise_var = squeeze(mean(log(noise_var)));
std_log_noise_var = squeeze(std(log(noise_var)));

mean_log_noise_var = repmat(mean_log_noise_var,[n_freqs 1]);
std_log_noise_var = repmat(std_log_noise_var,[n_freqs 1]);

snr_std = (log_tot_var-mean_log_noise_var)./std_log_noise_var;

