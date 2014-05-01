% Matlab Code for Dynamic Baysian network using bnet package

clear all;clc;
%install bnet package first
addpath(genpathKPM(pwd));

% describe the graph
intra = zeros(2);
intra(1,2) = 1;
inter = zeros(2);
inter(1,1) = 1;
n = 2;

hnodes = 1;
onodes = [1,2];
ss = 2; % slice size

X = 5; % size of hidden state for now let's take 2
Y = 3; % hidden continuous node

ns = [X Y];

eclass1 = 1:2;
eclass2 = [3 2];

bnet = mk_dbn(intra, inter, ns, 'discrete', 1, 'observed', [1,2], 'eclass1', eclass1, 'eclass2', eclass2);

disp('draw network graph')
unfold = 2;
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
bnet.CPD{2} = gaussian_CPD(bnet, 2);
bnet.CPD{3} = tabular_CPD(bnet, 3);

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
% load data from dropbox
dat_all = importdata('C:\dropbox\action.csv');
data = dat_all.data;
y = data(:,[1:4]);
T = length(data);
y = y';
% y = num2cell([zeros(2,T);data']);
% cases{1}(onodes,:) = y(onodes,:);
% aa = mat2cell(y,[1,3],ones(1,T));
cases{1}(onodes,:) = mat2cell(y,[1,3],ones(1,T));
[bnet2, LLtrace] = learn_params_dbn_em(engine, cases, 'max_iter', 50);

% violate object privacy
s1=struct(bnet2.CPD{1});
s2=struct(bnet2.CPD{2});
s3=struct(bnet2.CPD{3});

%% inference
% engine2 = smoother_engine(hmm_2TBN_inf_engine(bnet2));
bnet2.observed = 2;
engine2 = smoother_engine(jtree_2TBN_inf_engine(bnet2));
test_nodes = 2;
y_test = data(:,[2:4]);
cases_test{1}(test_nodes,:) = mat2cell(y_test',3,ones(1,T));
evidence = cases_test{1};
engine2 = enter_evidence(engine2, evidence);
proba = zeros(T,5); 
for t=1:T
    m = marginal_nodes(engine2, 1, t);
    proba(t,:) = m.T;
end

%% plot inference results and cmp


