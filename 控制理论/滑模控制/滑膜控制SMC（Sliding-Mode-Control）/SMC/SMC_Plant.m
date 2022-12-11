%{
t: ϵͳʱ��
x :ϵͳ״̬
u: ϵͳ���룬��ΪSimulink�������S-Function������
flag: ϵͳ״̬���Զ����ɣ����ص�flag����ϵͳ��ǰִ�е��ĸ�S-Function�Ӻ���
%}
function [sys, x0, str, ts] = SMC_Plant(t, x, u, flag)
switch flag
    case 0
        [sys, x0, str, ts] = mdlInitializeSizes;
    case 1
        sys = mdlDerivatives(t, x, u);
    case 3
        sys = mdlOutputs(t, x, u);
    case {2, 4, 9}
        sys = [];
    otherwise
        error(['Unhandled flag = ', num2str(flag)]);
end
function [sys, x0, str, ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates = 2; % ����״̬������
sizes.NumDiscStates = 0; % ��ɢ״̬������
sizes.NumOutputs = 2; % ���������
sizes.NumInputs = 1; % ���������
sizes.DirFeedthrough = 0;% ��������˿ڵ��ź��Ƿ��ں���mdlOutputs��ʹ��,�������Ƿ����u
sizes.NumSampleTimes = 0;% ��Ҫ������ʱ�䣬һ��Ϊ1
sys = simsizes(sizes);
x0 = [-0.15, -0.15]; % ״̬������ʼֵ
str = [];
ts = [];
function sys = mdlDerivatives(t, x, u)% ����ϵͳ״̬����
sys(1) = x(2); 
sys(2) = -25 * x(2) + 133 * u;
function sys = mdlOutputs(t, x, u)% ����ϵͳ���
sys(1) = x(1);  % �������1Ϊ�Ƕ�theta
sys(2) = x(2);  % �������2Ϊ�ٶ�dtheta