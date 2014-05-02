clear all;clc;
addpath(genpathKPM(pwd));

% one hidden node, 
intra = zeros(8);
for j=2:8
    intra(1,j) = 1;
end
inter = zeros(8);
inter(1,1) = 1;

hnodes = 1;
onodes = 2:8;
ss = 8; % slice size

%dimension for each nodes
% [action, mean, var, cov, mag, diff, fft,entropy]
ns = [5 3 3 3 1 3 3 3];

eclass1 = 1:8;
eclass2 = [9 2:8];

% training, assume all are observable
bnet = mk_dbn(intra, inter, ns, 'discrete', 1, 'observed', [1:8], 'eclass1', eclass1, 'eclass2', eclass2);

disp('draw network graph')
unfold = 3;
flip = 0;
[dummyx, dummyy, h] = draw_dbn(bnet.intra, bnet.inter, flip, unfold);
col = rand(size(h,1),3);
for i=1:length(h),
  col = rand(1,3);
  % patches
  set(h(i,2),'facecolor', col); drawnow;
  % text
  set(h(i,1),'color', 1-col); drawnow;
end;

bnet.CPD{1} = tabular_CPD(bnet, 1);
for j=2:8
    bnet.CPD{j} = gaussian_CPD(bnet, j);
end
bnet.CPD{9} = tabular_CPD(bnet, 9);

%% learning
% engine = {};
%engine{end+1} = hmm_inf_engine(bnet);
% engine{end+1} = jtree_unrolled_dbn_inf_engine(bnet, T);
%engine{end+1} = smoother_engine(hmm_2TBN_inf_engine(bnet));
engine = smoother_engine(jtree_2TBN_inf_engine(bnet));

% inf_time = cmp_inference_dbn(bnet, engine, T, 'check_ll',1);
% learning_time = cmp_learning_dbn(bnet, engine, T, 'check_ll', 1);


ncases = 1;
cases = cell(1, ncases);
% for i=1:ncases
%   ev = sample_dbn(bnet, T);
%   cases{i} = cell(ss,T);
%   cases{i}(onodes,:) = ev(onodes, :);
% end
dat_all = importdata('C:\dropbox\action.csv');
data = dat_all.data;
y = data(:,[1:20]);
T = length(data);
y = y';
% y = num2cell([zeros(2,T);data']);
% cases{1}(onodes,:) = y(onodes,:);
% aa = mat2cell(y,[1,3],ones(1,T));
cases{1}(1:8,:) = mat2cell(y,[1,3,3,3,1,3,3,3],ones(1,T));
[bnet2, LLtrace] = learn_params_dbn_em(engine, cases, 'max_iter', 50);

% violate object privacy
s1=struct(bnet2.CPD{1});
s2=struct(bnet2.CPD{2});
s9=struct(bnet2.CPD{9});

%% inference
% engine2 = smoother_engine(hmm_2TBN_inf_engine(bnet2));
% now only measurements are observable i.e. nodes 2:8
test_nodes = 2:8;
bnet2.observed = test_nodes;
engine2 = smoother_engine(jtree_2TBN_inf_engine(bnet2));
y_test = data(:,[2:20]);
cases_test{1}(test_nodes,:) = mat2cell(y_test',[3,3,3,1,3,3,3],ones(1,T));
evidence = cases_test{1};
engine2 = enter_evidence(engine2, evidence);
proba = zeros(T,5); 
for t=1:T
    m = marginal_nodes(engine2, 1, t);
    proba(t,:) = m.T;
end

%% plot inference results and cmp
[proba_stat,stat_est] = max(proba,[],2);
figure;
plot(stat_est,'b','lineWidth',3);hold on;
plot(data(:,1),'r.-','lineWidth',3);

accuracy = sum(stat_est==data(:,1))/length(stat_est)



