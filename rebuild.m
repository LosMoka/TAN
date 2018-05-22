function [ xf ] = rebuild( a,length, dn)
%REBUILD Summary of this function goes here
%   Detailed explanation goes here

%%Reconstruction
x2 = zeros(1,length);
al =size(a);

for n=1:length-2*dn
    m = floor(n/dn);
    qv = n-m*dn;
    %fprintf('qv : %d qv-dn : %d\n',qv+dn,qv-dn)
    x2(n) = a(m+1,qv+dn+1)+a(m+1+1,qv+1);
end
%x2 = x-x2;
xf = x2;%(space+1:length(x2));



end

