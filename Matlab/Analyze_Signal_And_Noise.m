function [tot_var,noise_var,log_tot_var,mean_log_noise_var,std_log_noise_var,snr_std] = Analyze_Signal_And_Noise(signal,noise)

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
