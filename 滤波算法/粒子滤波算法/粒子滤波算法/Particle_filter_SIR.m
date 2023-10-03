% SIR�����˲���Ӧ��
clear all
close all
clc

% ��ʼ��
x_init = 0.1; % ��ʼֵ
x_N = 1; % ģ��������Э����
x_R = 1; % ����������Э����
T = 75; % ������75��
N = 1000; % ��������Խ��Ч��Խ�ã�������ҲԽ��

% �����ǵĳ�ʼ�������ӷֲ���ʼ��Ϊ��ʵ��ʼֵ��Χ�ĸ�˹�ֲ�

V = 2; % ��ʼ���Ӹ�˹�ֲ��ķ���
X_ParticleModel = zeros(N, 75); % ��ģ���ݻ���õ�����ֵ
X_Particle = zeros(N, 75); % �ز������õ�����ֵ
Z_ParticleModel = zeros(N, 75); % ����ֵ������õ��ݻ�����
Particle_Probility = zeros(N, 75); % ����Ȩ���ݻ�����
Particle_NormProbility = zeros(N, T); % ���ӹ�һ��Ȩ���ݻ�����

X_Value = zeros(1, T); % ��ģ���ݻ���õ�ʵ��ֵ
X_EstValue = zeros(1, T); % �����˲���Ĺ���ֵ
Z_Value = zeros(1, T); % ʵ��ֵ��Ӧ�Ĳ���ֵ

for i = 1:N
    X_ParticleModel(i, 1) = x_init + sqrt(V) * randn(1, 1); % �ڳ�ֵx=0.1�ĸ�˹�ֲ������������ʼ��N������
end
X_Value(1, 1) = x_init;
X_EstValue(1, 1) = x_init;

for t = 2:T
    % ʵ��ֵ��۲�ֵ�ڳ����н����������ɣ���ʵ������ʵ��ֵ�޷���ȡ���۲�ֵ����ͨ���������
    % ʵ��ֵ��ϵͳģ�ͣ�����˹��ȷ������
    X_Value(1, t) = 0.5 * X_Value(1, t-1) + 25 * X_Value(1, t-1) / (1 + X_Value(1, t-1)^2) + 8 * cos(1.2*(t - 1)) + sqrt(x_N) * randn;
    % �۲�ֵ������ģ�ͣ�����˹�������
    Z_Value(1, t) = X_Value(1, t)^2 / 20 + sqrt(x_R) * randn;
    for i = 1:N
        % ����Ԥ��ֵ
        X_ParticleModel(i, t) = 0.5 * X_ParticleModel(i, t-1) + 25 * X_ParticleModel(i, t-1) / (1 + X_ParticleModel(i, t-1)^2) + 8 * cos(1.2*(t - 1)) + sqrt(x_N) * randn;
        % ���ӹ۲�ֵ
        Z_ParticleModel(i, t) = X_ParticleModel(i, t)^2 / 20;
        % ���ӹ۲�ֵ��Ȩ��
        Particle_Probility(i, t) = (1 / sqrt(2*pi*x_R)) * exp(-(Z_Value(1, t) - Z_ParticleModel(i, t))^2/(2 * x_R));
    end
    Particle_NormProbility(:, t) = Particle_Probility(:, t) ./ sum(Particle_Probility(:, t)); % ��һ��Ȩ��
    % �ز������������������
    for i = 1:N
        % ����Ȩ�ش�Ļ��д���ʽ��б������ƣ�Ȩ��С������������
        X_Particle(i, t) = X_ParticleModel(find(rand <= cumsum(Particle_NormProbility(:, t)),1), t);
    end
    
    % ״̬���ƣ��ز����Ժ�ÿ�����ӵ�Ȩ�ض������1/N�����������ӵĲ���ֵ��ֵ������ʵֵ
    X_EstValue(1, t) = mean(X_Particle(:, t));
end


t = 1:T;
figure(1);
plot(t, X_Value(1, :), '.-b', t, X_EstValue(1, :), '-.r', 'linewidth', 3);
set(gca, 'FontSize', 12);
set(gcf, 'Color', 'White');
xlabel('Step');
ylabel('Value');
legend('��ʵֵ', '����ֵ');