function X = update_particles(F_update, Xstd_pos, Xstd_vec, X)
% X 所有粒子组成的矩阵  
% X(1:2, :) 各粒子在画面中的位置
N = size(X, 2);

X = F_update * X;       % 状态转移矩阵

X(1:2,:) = X(1:2,:) + Xstd_pos * randn(2, N);
X(3:4,:) = X(3:4,:) + Xstd_vec * randn(2, N);
