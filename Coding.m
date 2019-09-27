clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%CHOOSE_SNR_and_CODE_BITS_HERE%%%%%%%%%%%%%%%%
%>>>>>>>>>>>>>>>>>>>>>>>T is adjustable<<<<<<<<<<<<<<<<<<<<<<<<%
SNr     = 8;
cb      = 85;
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
modb  = 4;
%%%%%%%%%%%%%%%%%%%%%%%%quantization%%%%%%%%%%%%%%%%%%%%%%
qb      = floor(3*10^6*modb/(fs*127/cb));
[inputq1,inputq2]= quantizer(input,2^qb);
%%%%%%%%%%%%%%%%%%%%%%modulation&coder%%%%%%%%%%%%%%%%%%%%
E       = (1.5*10^(SNr/10))^(1/2);
symbola = de2bi(inputq2);
symbolS1= size(symbola);
zp      = ceil(T*fs*qb/modb/cb)*cb*modb-T*fs*qb;
symbol1 = [reshape(symbola,1,symbolS1(1)*symbolS1(2)),zeros(1,zp)];
symbolS = size(symbol1);
symbolb = reshape(symbol1,symbolS(1)*symbolS(2)/cb,cb);
symbolc = symbolb;
symbold = gf(symbolc,1);
symbole = bchenc(symbold,127,cb);
symbolf = double(symbole.x);
s       = size(symbolf);
symbolg = reshape(symbolf,1,s(1)*s(2));
symbol2 = reshape(symbolg,s(1)*s(2)/modb,modb);
symbol3 = bi2de(symbol2)';
coded1  = E*dpskmod(symbol3,2^modb);
n1      = normrnd(0,1,1,(T*fs*qb+zp)/cb/modb*127);
n2      = normrnd(0,1,1,(T*fs*qb+zp)/cb/modb*127);
coded11 = coded1+n1+n2*i;
pha     = angle(coded1);
if(modb == 4)
pha     = decision16(pha);
else
pha     = decision4(pha);
end
decoded1= E*exp(pha*i);
decoded2= dpskdemod(decoded1/E,2^modb);
decoded3= de2bi(decoded2);
decoded4= reshape(decoded3,s(1),s(2));
decoded5= gf(decoded4);
decoded6= bchdec(decoded5,127,cb);
decoded7= double(decoded6.x);
for( i =1:s(1))
    if(decoded7(i,:)== symbolb(i,:))
    else
        decoded7(i,:)=decoded4(i,1:cb);
    end
end
sd      = size(decoded7);
decoded8=reshape(decoded7,1,sd(1)*sd(2));
decoded9=reshape(decoded8(1:T*fs*qb),symbolS1(1),symbolS1(2));
decoded10=bi2de(decoded9)';
decoded11=dequantizer(decoded10,2^qb);

distortion= vpa(sum((decoded11-input).^2)/(fs*T))
err       = vpa(sum(sum((decoded9-symbola).^2))/(symbolS1(1)*symbolS1(2)))