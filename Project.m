clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%CHOOSE_SNR_and_MODULATION_BITS_HERE%%%%%%%%%%%%%%
%>>>>>>>>>>>>>>>>>>>>>>>T is adjustable<<<<<<<<<<<<<<<<<<<<<<<<%
SNr     = 8;
modb    = 2;
T     = 0.001;
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs    = 10^6;
t     = 1/fs:1/fs:T;

f1    = 495*10^3;
f2    = 465*10^3;
f3    = 340*10^3;

input = sin(f1*t+pi/6)+sin(f2*t+pi/4)+sin(f3*t+65*pi/180);

%%%%%%%%%%%%%%%%%%%%%%%%quantization%%%%%%%%%%%%%%%%%%%%%%
qb      = floor(3*10^6*modb/fs);
[inputq1,inputq2]= quantizer(input,2^qb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%modulation%%%%%%%%%%%%%%%%%%%%%%%%%%
E       = (1.5*10^(SNr/10))^(1/2);
symbol  = de2bi(inputq2);
symbolS = size(symbol);
symbol1 = reshape(symbol,1,symbolS(1)*symbolS(2));
symbol2 = reshape(symbol1,symbolS(1)*symbolS(2)/modb,modb);
symbol3 = bi2de(symbol2)';
coded1  = E*dpskmod(symbol3,2^modb);

n1      = normrnd(0,1,1,T*fs*qb/modb);
n2      = normrnd(0,1,1,T*fs*qb/modb);
received= coded1+n1+i*n2;
pha     = angle(received);
if(modb == 4)
pha     = decision16(pha);
else
pha     = decision4(pha);
end
decoded1= E*exp(pha*i);
decoded2= dpskdemod(decoded1/E,2^modb);
decoded3= de2bi(decoded2);
decoded4= reshape(decoded3,symbolS(1),symbolS(2));
decoded5= bi2de(decoded4)';
decoded6= dequantizer(decoded5,2^qb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%RESULTS%%%%%%%%%%%%%%%%%%%%%%%%%%%
distortion= vpa(sum((decoded6-input).^2)/(T*fs)) 
err       = vpa(sum(sum((decoded4-symbol).^2))/(symbolS(1)*symbolS(2)))







