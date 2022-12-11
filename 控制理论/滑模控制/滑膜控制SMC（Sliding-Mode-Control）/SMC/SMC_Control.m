%{
t: ϵͳʱ��
x :ϵͳ״̬
u: ϵͳ���룬��ΪSimulink�������S-Function������
flag: ϵͳ״̬���Զ����ɣ����ص�flag����ϵͳ��ǰִ�е��ĸ�S-Function�Ӻ���
%}
function [sys, x0, str, ts] = SMC_Control(t, x, u, flag)
switch flag
    case 0
        [sys, x0, str, ts] = mdlInitializeSizes;
    case 3
        sys = mdlOutputs(t, x, u);
    case {2, 4, 9}
        sys = [];
    otherwise
        error(['Unhandled flag = ', num2str(flag)]);
end
function [sys, x0, str, ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates = 0;% ����״̬������
sizes.NumDiscStates = 0;% ��ɢ״̬������
sizes.NumOutputs = 3;% ���������
sizes.NumInputs = 3;% ���������
sizes.DirFeedthrough = 1;% ��������˿ڵ��ź��Ƿ��ں���mdlOutputs��ʹ��,�������Ƿ����u
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0 = [];
str = [];
ts = [];
function sys = mdlOutputs(t, x, u)
thd = u(1); % �������1Ϊ�Ƕ�ָ��
dthd = cos(t);
ddthd = -sin(t);

th = u(2);  % �������2Ϊʵ�ʽǶ�
dth = u(3);% �������3Ϊʵ���ٶ�

c = 15;
e = thd - th;
de = dthd - dth;
s = c * e + de;

fx = 25 * dth;
b = 133;

epc = 5;
k = 10;
ut = 1 / b * (epc * sign(s) + k * s + c * de + ddthd + fx); % ��ģ������

sys(1) = ut;    % �������1Ϊ������
sys(2) = e;     % �������2Ϊ���
sys(3) = de;    % �������3Ϊ���һ�׵���