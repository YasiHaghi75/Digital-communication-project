function y= decision16(pha)
pha(pha>-pi/16 & pha<=pi/16)  = 0;
pha(pha>pi/16 & pha<=3*pi/16) = pi/8;
pha(pha>3*pi/16 & pha<=5*pi/16) = pi/4;
pha((pha>5*pi/16 & pha<=7*pi/16)) = 3*pi/8;
pha(pha>7*pi/16 & pha<=9*pi/16)  = pi/2;
pha(pha>9*pi/16 & pha<=11*pi/16) = 5*pi/8;
pha(pha>11*pi/16 & pha<=13*pi/16) = 3*pi/4;
pha(pha>13*pi/16 & pha<=15*pi/16) = 7*pi/8;
pha(pha>-3*pi/16 & pha<=-pi/16) = -pi/8;
pha(pha>-5*pi/16 & pha<=-3*pi/16) = -pi/4;
pha(pha>-7*pi/16 & pha<=-5*pi/16) = -3*pi/8;
pha(pha>-9*pi/16 & pha<=-7*pi/16) = -pi/2;
pha(pha>-11*pi/16 & pha<=-9*pi/16) = -5*pi/8;
pha(pha>-13*pi/16 & pha<=-11*pi/16) = -3*pi/4;
pha(pha>-15*pi/16 & pha<=-13*pi/16) = -7*pi/8;
pha((pha>15*pi/16 & pha<=pi) | (pha>-pi & pha<=-15*pi/16) ) = pi;
y = pha;
end