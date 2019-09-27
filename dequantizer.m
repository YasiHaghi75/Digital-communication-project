function y = dequantizer(input,M)
m1   = 6/M;
for i=1:M
    input(input==i-1)=3-(i-1/2)*m1;
end
y    = input;
end