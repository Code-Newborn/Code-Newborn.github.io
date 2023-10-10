function X = resample_particles(X, L_log)

% Calculating Cumulative Distribution

L = exp(L_log - max(L_log));
Q = L / sum(L, 2);  % a = sum(L,2)  a��Ԫ��Ϊ���������ۼ�ֵ
R = cumsum(Q, 2);   % Ȩֵ�ۼ�

% Generating Random Numbers

N = size(X, 2);
T = rand(1, N); % �����ֵ

% Resampling
X_temp = zeros(size(X));
%����û���ò�����֮ǰ˵��histc����������Ŀ�ĺ�Ч����һ����
for i = 1 : N
    X_temp(:,i) = X(:,find(T(i) <= R,1));               % ����Ȩ�ش�Ľ���õ����
end                                                     % find( ,1) ���ص�һ�� ����ǰ������������ �±�
X = X_temp;
% [~, I] = histc(T, R);
% X = X(:, I + 1);
