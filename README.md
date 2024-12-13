This repo contains code in Matlab and Python for analyzing parallel auditory brainstem response (pABR) recordings as originally conceived by Polonenko and Maddox (Trends in Hearing, 2019).

![image](https://github.com/user-attachments/assets/4b51b013-f097-4e94-b059-b30d23cd21c0)

There are functions for creating the sounds and functions for analyzing the recordings. 

An example dataset is included to demonstrate the analysis functions. Each file "Example_Voltage_And_Triggers_X" in the dataset contains a recording made in response to sounds presented at X dB SPL along with onset indices for 1000 tones at 1, 2, 4, 8, and 16kHz. (Note that the sampling rates for our sounds and recordings are the same (44.1kHz); if you use different sampling rates for your sounds and recordings you will need to update the code to account for that.)

**Matlab**

To create sounds in Matlab, use the function Create_pABR_Sounds.m. The input arguments are described in the function comments.

To analyze recordings in Matlab, use the functions Extract_Signal_And_Noise.m and Analyze_Signal_And_Noise.m.

To see how these functions are used to analyze the example dataset, see Example_Script.m

It should produce the following plot:

![image](https://github.com/user-attachments/assets/b1e93107-36be-4975-b941-a2ca507652bd)

Each panel shows the results for one frequency (1, 2, 4, 8, and 16kHz), with the ABR amplitude (in d'-like units) plotted against the sound level (in dB SPL) with the threshold indicated.





**Python**

It is crucial to import the necessary libraries before starting the code, as they enable the execution and generation of the desired sounds. All the required libraries are showcased within the script.

To create sounds, we use the Create_pABR_Sounds function located in the Python folder. The input variables are detailed in the comments. After executing the function, we call it to generate the results.

To analyze recorded sounds, we use the functions Extract_Signal_And_Noise.ipynb and Analyze_Signal_And_Noise.

To understand how these functions are utilized for analysis, refer to the example dataset. See the Example_Script.

The execution of the script should produce the following plot:


![image](https://github.com/user-attachments/assets/b0dd8f81-fac3-4487-9ca5-79cb81c70a4f)




