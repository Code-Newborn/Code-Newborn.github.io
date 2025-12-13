function X = resample_particles(X, L_log)

% Calculating Cumulative Distribution

L = exp(L_log - max(L_log));
Q = L / sum(L, 2);  % a = sum(L,2)  a中元素为各行向量累加值
R = cumsum(Q, 2);   % 权值累加

% Generating Random Numbers

N = size(X, 2);
T = rand(1, N); % 随机阈值

% Resampling
X_temp = zeros(size(X));
%这里没有用博客里之前说的histc函数，不过目的和效果是一样的
for i = 1 : N
    X_temp(:,i) = X(:,find(T(i) <= R,1));               % 粒子权重大的将多得到后代
end                                                     % find( ,1) 返回第一个 符合前面条件的数的 下标
X = X_temp;
% [~, I] = histc(T, R);
% X = X(:, I + 1);
