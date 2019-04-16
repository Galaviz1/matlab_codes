% Perform measurement with the TI test bed. Send -> Receive -> Time alignment data
close all, format short;
FontSizeSize = 16 ;
markersizeSize = 1 ;

%% Sampling Frequency for DAC and ADC
dac_fs = 307.2e6 ;
dac_ts = 1 / dac_fs ;
adc_fs = 614.4e6 ;
adc_ts = 1 / adc_fs ;

%% Number of sample sent is fixed depending on the FPGA design
NumSampTx = 2^16 ;
A         = 2^15 ;

%% Generating signal
indxData = 2 ;
load LTE_0_10MHz_307p2.mat ;
PrefixLength = 1024 ;
xWindows     = [ 0.5 + 0.5 * sin( pi * linspace( -1 , 1 , PrefixLength ) / 2 ) ones( 1 , NumSampTx - 2*PrefixLength ) 0.5 + 0.5 * sin( pi * linspace( 1 , -1 , PrefixLength ) / 2 ) ] ;
x            = xWindows' .* ( signalInput( indxData * NumSampTx : ( indxData + 1 ) * NumSampTx - 1 ) ) ;
x1           = x / max( abs( x ) ) ;
xback        = x.';
%clear x ;
BW_MHz( 1 )  = 10 ;


figure(1);
plot(abs(complex(xback)));
figure(2);
plot(abs(complex(x)));
figure(3);
plot(abs(complex(x1)));

figure(4);
xreal = real( x1 ).';
plot(xreal);
figure(5);
ximag = imag( x1 ).';
plot(ximag);


if 0
% M = x1;
% data = 0:x1-1;
% sym = qammod(data,M);
% 
% scatterplot(sym,1,0,'r*');
% grid on
% for k = 1:M
%     text(real(sym(k))-0.4,imag(sym(k))+0.4,num2str(data(k)));
% end
% axis([-4 4 -2 2])
% Algorithm
% MATLAB script
%% Constants
FRM=2048;
MaxNumErrs=200;MaxNumBits=1e7;
EbNo_vector=0:10;BER_vector=zeros(size(EbNo_vector));
%% Initializations
Modulator = comm.QPSKModulator('BitInput',true);
AWGN = comm.AWGNChannel;
DeModulator = comm.QPSKDemodulator('BitOutput',true);
BitError = comm.ErrorRate;
%% Outer Loop computing Bit-error rate as a function of EbNo
for EbNo = EbNo_vector
snr = EbNo + 10*log10(2);
AWGN.EbNo=snr;
numErrs = 0; numBits = 0;results=zeros(3,1);
%% Inner loop modeling transmitter, channel model and receiver for each EbNo
while ((numErrs < MaxNumErrs) && (numBits < MaxNumBits))
% Transmitter
u = randi([0 1], FRM,1); % Generate random bits
mod_sig = step(Modulator, u); % QPSK Modulator
% Channel
rx_sig = step(AWGN, mod_sig); % AWGN channel
% Receiver
y = step(DeModulator, rx_sig); % QPSK Demodulator
results = step(BitError, u, y); % Update BER
numErrs = results(2);
numBits = results(3);
end
% Compute BER
ber = results(1); bits= results(3);
%% Clean up & collect results
reset(BitError);
BER_vector(EbNo+1)=ber;
end
%% Visualize results
EbNoLin = 10.^(EbNo_vector/10);
theoretical_results = 0.5*erfc(sqrt(EbNoLin));
semilogy(EbNo_vector, BER_vector)
grid;title('BER vs. EbNo - QPSK modulation');
xlabel('Eb/No (dB)');ylabel('BER');hold;
semilogy(EbNo_vector,theoretical_results,'dr');hold;
legend('Simulation','Theoretical');
end
