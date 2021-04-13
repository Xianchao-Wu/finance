%P = [0.99 0.01; 0.05 0.95]
%N=2
function [pai]=dingchangfenbu(P)
    % ’è?í•ª•z
    [N,M] = size(P)
    A = [P'- eye(N); ones(1, N)];
    e = [zeros(N, 1); 1];
    pai = inv(A' * A) * A' * e;
    disp(pai' == pai' * P)
    disp('--pai--');
    disp(pai)
    disp('--pai.T * P--');
    disp((pai' * P)')
    return;
    %pai'
    %pai' * P

