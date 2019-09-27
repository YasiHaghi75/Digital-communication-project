function y = decision4(pha)
pha(pha>-pi/4 & pha<=pi/4) = 0;
pha(pha>-3*pi/4 & pha<=-pi/4) = -pi/2;
pha(pha>pi/4 & pha<=3*pi/4) = pi/2;
pha((pha>3*pi/4 & pha<=pi) | (pha>-pi & pha<=-3*pi/4) ) = pi;
y = pha;
end