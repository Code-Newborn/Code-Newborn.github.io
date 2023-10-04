% SIR粒子滤波的应用
clear all
close all
clc

% 初始化
x_init = 0.1; % 初始值
x_N = 1; % 模型噪声的协方差
x_R = 1; % 测量噪声的协方差
T = 75; % 共进行75次
N = 1000; % 粒子数，越大效果越好，计算量也越大

% 将我们的初始先验粒子分布初始化为真实初始值周围的高斯分布

V = 2; % 初始粒子高斯分布的方差
X_ParticleModel = zeros(N, 75); % 沿模型演化获得的粒子值
X_Particle = zeros(N, 75); % 重采样后获得的粒子值
Z_ParticleModel = zeros(N, 75); % 粒子值测量获得的演化序列
Particle_Probility = zeros(N, 75); % 粒子权重演化序列
Particle_NormProbility = zeros(N, T); % 粒子归一化权重演化序列

X_Value = zeros(1, T); % 沿模型演化获得的实际值
X_EstValue = zeros(1, T); % 粒子滤波后的估计值
Z_Value = zeros(1, T); % 实际值对应的测量值

for i = 1:N
    X_ParticleModel(i, 1) = x_init + sqrt(V) * randn(1, 1); % 在初值x=0.1的高斯分布，随机产生初始的N个粒子
end
X_Value(1, 1) = x_init;
X_EstValue(1, 1) = x_init;

for t = 2:T
    % 实际值与观测值在程序中进行虚拟生成，真实环境下实际值无法获取，观测值可以通过测量获得
    % 实际值，系统模型（含高斯不确定量）
    X_Value(1, t) = 0.5 * X_Value(1, t-1) + 25 * X_Value(1, t-1) / (1 + X_Value(1, t-1)^2) + 8 * cos(1.2*(t - 1)) + sqrt(x_N) * randn;
    % 观测值，测量模型，含高斯测量误差
    Z_Value(1, t) = X_Value(1, t)^2 / 20 + sqrt(x_R) * randn;
    for i = 1:N
        % 粒子预测值
        X_ParticleModel(i, t) = 0.5 * X_ParticleModel(i, t-1) + 25 * X_ParticleModel(i, t-1) / (1 + X_ParticleModel(i, t-1)^2) + 8 * cos(1.2*(t - 1)) + sqrt(x_N) * randn;
        % 粒子观测值
        Z_ParticleModel(i, t) = X_ParticleModel(i, t)^2 / 20;
        % 粒子观测值的权重
        Particle_Probility(i, t) = (1 / sqrt(2*pi*x_R)) * exp(-(Z_Value(1, t) - Z_ParticleModel(i, t))^2/(2 * x_R));
    end
    Particle_NormProbility(:, t) = Particle_Probility(:, t) ./ sum(Particle_Probility(:, t)); % 归一化权重
    % 重采样（独立随机采样）
    for i = 1:N
        % 粒子权重大的会有大概率进行保留复制，权重小的粒子数量少
        X_Particle(i, t) = X_ParticleModel(find(rand <= cumsum(Particle_NormProbility(:, t)),1), t);
    end
    
    % 状态估计，重采样以后，每个粒子的权重都变成了1/N，用所有粒子的采样值均值估计真实值
    X_EstValue(1, t) = mean(X_Particle(:, t));
end


t = 1:T;
figure(1);
plot(t, X_Value(1, :), '.-b', t, X_EstValue(1, :), '-.r', 'linewidth', 3);
set(gca, 'FontSize', 12);
set(gcf, 'Color', 'White');
xlabel('Step');
ylabel('Value');
legend('真实值', '估计值');