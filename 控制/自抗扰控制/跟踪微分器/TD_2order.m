t = 0:0.1:10;
data_indx = 1:1:length(t);
x = sawtooth(t);
y = awgn(x, 10, 'measured');
for index = data_indx
    [x1(index), x2(index)] = TD_2order1(y(index));
end

plot(t,y,t,x1,t,x2);
legend('ԭ�ź�','�����ź�','����΢��')

function [x1, x2] = TD_2order1(u)
T = 0.01;
r = 10;
h = 0.1;
persistent x_1 x_2
if isempty(x_1)
    x_1 = 0;
end
if isempty(x_2)
    x_2 = 0;
end
x1k = x_1;
x2k = x_2;
x_1 = x1k + T * x2k;
x_2 = x2k + T * fhan(x1k, x2k, u, r, h);
x1 = x_1;
x2 = x_2;
end

function f = fhan(x1, x2, u, r, h)
d = r * h; %hΪ�˲�����  rΪ����ϵ����rԽ�����Ч��Խ�ã���΢���źŻ����Ӹ�Ƶ����
d0 = d * h; %��֮��΢���ź�Խƽ���������һ�����ͺ�
y = x1 - u + h * x2;
a0 = sqrt(d^2+8*r*abs(y));
if abs(y) <= d0
    a = x2 + y / h;
else
    a = x2 + 0.5 * (a0 - d) * sign(y);
end
if abs(a) <= d
    f = -r * a / d;
else
    f = -r * sign(a);
end
end
