source = load('./Data/source.mat');
target = load('./Data/target.mat');

ICP(source.source, target.target, 40, 1);