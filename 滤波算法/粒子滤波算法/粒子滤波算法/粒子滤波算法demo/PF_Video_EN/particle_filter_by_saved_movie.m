clc;clear;

% Parameters
% reference : http://www.mathworks.com/matlabcentral/fileexchange/33666-simple-particle-filter-demo
F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];    % ״̬ת�ƾ���

Npop_particles = 4000;

Xstd_rgb = 50;  % ����
Xstd_pos = 25;  % λ�ñ���
Xstd_vec = 5;   % �ٶȱ���

Xrgb_trgt = [255; 0; 0];    % �����ɫ

% Loading Movie
vr = VideoReader('Person.wmv');

Npix_resolution = [vr.Width vr.Height];
Nfrm_movie = floor(vr.Duration * vr.FrameRate);

% Object Tracking by Particle Filter

X = create_particles(Npix_resolution, Npop_particles); % ���ӳ�ʼ�����ڻ����в������ȷֲ����������

for k = 1:Nfrm_movie
    
    % Getting Image
    Y_k = read(vr, k);
    
    % Forecasting
    %ͨ��״̬ģ��Ԥ��  ������õ�������һʱ�̻����ϵ�������
    X = update_particles(F_update, Xstd_pos, Xstd_vec, X); 
    
    % Calculating Log Likelihood
    L = calc_log_likelihood(Xstd_rgb, Xrgb_trgt, X(1:2, :), Y_k);
    
    % Resampling
    X = resample_particles(X, L);

    % Showing Image
    show_particles(X, Y_k); 
%    show_state_estimated(X, Y_k);

end

