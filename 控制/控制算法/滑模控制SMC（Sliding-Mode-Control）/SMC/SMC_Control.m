%{
t: 系统时间
x :系统状态
u: 系统输入，即为Simulink中输入给S-Function的数据
flag: 系统状态，自动生成，返回的flag决定系统当前执行到哪个S-Function子函数
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
sizes.NumContStates = 0;% 连续状态变量数
sizes.NumDiscStates = 0;% 离散状态变量数
sizes.NumOutputs = 3;% 输出变量数
sizes.NumInputs = 3;% 输入变量数
sizes.DirFeedthrough = 1;% 设置输入端口的信号是否在函数mdlOutputs中使用,即其中是否出现u
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0 = [];
str = [];
ts = [];
function sys = mdlOutputs(t, x, u)
thd = u(1); % 输入变量1为角度指令
dthd = cos(t);
ddthd = -sin(t);

th = u(2);  % 输入变量2为实际角度
dth = u(3);% 输入变量3为实际速度

c = 15;
e = thd - th;
de = dthd - dth;
s = c * e + de;

fx = 25 * dth;
b = 133;

epc = 5;
k = 10;
ut = 1 / b * (epc * sign(s) + k * s + c * de + ddthd + fx); % 滑模控制律

sys(1) = ut;    % 输出变量1为控制量
sys(2) = e;     % 输出变量2为误差
sys(3) = de;    % 输出变量3为误差一阶导数