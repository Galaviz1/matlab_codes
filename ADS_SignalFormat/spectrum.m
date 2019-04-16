% incomplete function

clear all; clc; close all;
Filename = 'S1Im' ;

FId      = fopen( Filename );
tline    = fgetl( FId );
N        = 1;

while ~feof( FId )
    xI(N)  = str2num(tline);
    N      = N + 1;
    tline  = fgetl( FId );
end
fclose( FId );


[ PxxL , F ] = pwelch( xL , hanning( N1 ) , [], N , 0.5 * Fs_MHz * 1e6 ) ;
[ PxxU , F ] = pwelch( xU , hanning( N1 ) , [], N , 0.5 * Fs_MHz * 1e6 ) ;
F            = ( F - ( 0.5 * Fs_MHz * 1e6 / 2 ) ) / 10^6 ;
indFreq      = find( abs( F ) < 30 * BW_MHz ) ;
PxxL         = fftshift( PxxL ) ;
PxxU         = fftshift( PxxU ) ;