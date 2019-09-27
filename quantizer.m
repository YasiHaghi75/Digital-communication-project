function[x,y] = quantizer(input,M)
m1   = 6/M;
for i=1:M
    input(input<=(3-(i-1)*m1) & input>(3-i*m1))=3-(i-1/2)*m1;
end
x    = input;
for i=1:M
    input(input==3-(i-1/2)*m1)=i-1;
end
y    = input;
end