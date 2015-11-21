%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Neighbor-Sensitive Hashing (NSH)
%     Yongjoo Park, Michael Cafarella, and Barzan Mozafari. In PVLDB Vol 9(3) 2015
%     pyongjoo@umich.edu
%     http://www-personal.umich.edu/~pyongjoo/
%
% This is a demo using a simple 10-D uniform dataset. Please contact the author
% by his email for any questions, bug reports, etc.
%
% Details of this demo: This demo code compares the performance of NSH against
% two other learning-based hashing algorithms using a randomly generated 10-D
% uniform dataset. This code has been tested in Matlab R2013a and R2015a.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create a 10-D uniform dataset and test queries
Nx = 1e5;           % dataset size
Nd = 10;            % data dimension
Nq = 1000;          % test query counts
k  = 10;            % define 'k' of kNN search
r  = k*10;          % define retrieval counts slightly larger than 'k'

rng(0);             % set to any number
X = rand(Nx, Nd);
Q = rand(Nq, Nd);

fprintf('Dataset size: %d\n', Nx);
fprintf('Test query count: %d\n', Nq);
fprintf('The value of k: %d\n', k);
fprintf('The value of r: %d\n', r);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute groundtruth data
fprintf('\nGenerating Groundtruth.. this make take a while..  ');
G = zeros(size(Q,1), k);
parfor i = 1:size(Q,1)
    dd = distMat(Q(i,:),X);
    [B,I] = sort(dd);
    index = I(1:k);
    G(i,:) = index;
end
fprintf('done.\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train a model of Neighbor-Sensitive Hashing
codesizeToTest = [8, 16, 32, 64, 128];
nshRecalls = zeros(length(codesizeToTest),1);

fprintf('\nTesting Neighbor-Sensitive Hashing for:\n');
for i = 1:length(codesizeToTest)
    codesize = codesizeToTest(i);
    fprintf('  codesize: %d\n', codesize);

    model = trainNSH(X, codesize);
    XB = model.hash(X);
    QB = model.hash(Q);
    hD = hammingDist(QB, XB);
    nshRecalls(i) = computeRecall(hD, G, r);
end
fprintf('Finished testing Neighbor-Sensitive Hashing.\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute recall scores of competing methods
spectralRecalls  = zeros(length(codesizeToTest),1);
sphericalRecalls = zeros(length(codesizeToTest),1);

fprintf('\nTesting other competing kNN hashing algorithms for:\n');
fprintf('Note: Some messages may be printed from the internals of those algorithms.\n')
for i = 1:length(codesizeToTest)
    codesize = codesizeToTest(i);
    fprintf('  codesize: %d\n', codesize);

    % Spectral hashing
    SHparam.nbits = codesize;
    SHparam = trainSH(X, SHparam);
    XB = compressSH(X, SHparam);
    QB = compressSH(Q, SHparam);
    hD = hammingDist(QB, XB);
    spectralRecalls(i) = computeRecall(hD, G, r);

    % Spherical hashing
    [centers, radii] = SphericalHashing(X, codesize);
    XB = compressSPH(X, centers, radii);
    QB = compressSPH(Q, centers, radii);
    hD = hammingDist(QB, XB);
    sphericalRecalls(i) = computeRecall(hD, G, r);
end
fprintf('Finished testing other algorithms.\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display evaluation results
fprintf('Neighbor-Sensitive Hashing Recalls:\n');
disp(nshRecalls);
fprintf('Spectral Hashing Recalls:\n');
disp(spectralRecalls);
fprintf('Spherical Hashing Recalls:\n');
disp(sphericalRecalls);

xtickphony = 1:length(codesizeToTest);
plot(xtickphony, nshRecalls, '.-', ...
     xtickphony, spectralRecalls, '.--', ...
     xtickphony, sphericalRecalls, '.:', ...
     'LineWidth', 2, 'Marker', 's', 'MarkerSize', 10);
title('Hashcode length vs. Recall');
xlabel('Hashcode Length');
ylabel('Recall');
axis([1 length(xtickphony) 0 1]);
set(gca, 'XTick', xtickphony, 'XTickLabel', codesizeToTest);
legend('Neighbor-Sensitive Hashing', 'Spectral Hashing', 'Spherical Hashing', 'Location', 'Northwest');
grid on;



