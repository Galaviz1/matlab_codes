clear all;
close all;
clc;


I = importdata('S1Re');
Q = importdata('S1Im');

signalInput = complex( I , Q ) ;

%FIR arbitrary shape lowpass filter
f = [0 0.25 0.26 1] ; % frequency breakpoints
m = [1 1 0 0] ;       % magnitude breakpoints
b = fir2(70,f,m) ;    % Frequency sampling-based 70th-order FIR filter design

%   Y = FILTER(B,A,X) filters 
%   the data in X with the filter described by vectors A and B to create the filtered data Y

%   y = interp(x,4) Interpolate a signal by a factor of four                        
I = filter( b , 1 , interp( I , 16 ) ) ;
Q = filter( b , 1 , interp( Q , 16 ) ) ;

I = filter( b , 1 , I ) ;
Q = filter( b , 1 , Q ) ;
I = filter( b , 1 , I ) ;
Q = filter( b , 1 , Q ) ;

x = complex( I , Q ) ;
xup = resample( x , 5 , 4 ) ; %upsample 245.76*5/4 = 307.2

%Fs = 245.76;
Fs = 307.2 ;
freq = linspace( -Fs/2 , Fs/2 , length( x ) ) ; 

frequp = linspace( -Fs/2 , Fs/2 , length( xup ) ) ; 

figure (1) %after upsamlping 
plot(frequp , 20*log10(abs(fftshift(fft(xup)))))

signalInput=xup;
%save ('LTE1MHz307p2v1.mat', 'signalInput');

%figure (2) % Fs 245.76
%plot(freq, 20*log10(abs(fftshift(fft(x)))))