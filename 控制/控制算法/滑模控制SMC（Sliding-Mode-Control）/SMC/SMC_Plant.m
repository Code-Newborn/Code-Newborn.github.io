%{
t: 系统时间
x :系统状态
u: 系统输入，即为Simulink中输入给S-Function的数据
flag: 系统状态，自动生成，返回的flag决定系统当前执行到哪个S-Function子函数
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
sizes.NumContStates = 2; % 连续状态变量数
sizes.NumDiscStates = 0; % 离散状态变量数
sizes.NumOutputs = 2; % 输出变量数
sizes.NumInputs = 1; % 输入变量数
sizes.DirFeedthrough = 0;% 设置输入端口的信号是否在函数mdlOutputs中使用,即其中是否出现u
sizes.NumSampleTimes = 0;% 需要的样本时间，一般为1
sys = simsizes(sizes);
x0 = [-0.15, -0.15]; % 状态变量初始值
str = [];
ts = [];
function sys = mdlDerivatives(t, x, u)% 产生系统状态导数
sys(1) = x(2); 
sys(2) = -25 * x(2) + 133 * u;
function sys = mdlOutputs(t, x, u)% 产生系统输出
sys(1) = x(1);  % 输出变量1为角度theta
sys(2) = x(2);  % 输出变量2为速度dtheta