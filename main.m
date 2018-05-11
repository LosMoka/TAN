xo = rand(1,fe*4);%%Signal de parole
space = 4000;
x = [zeros(1,space),xo];

%%T < 125ms (durée max d'un phonème)
%%T > 20 ms (voix basse d'un homme : 50hz)
fe = 44100; %%freq d'éch d'un CD-ROM
Te = 1/fe;
%%T doit respecter T = 2^N / fe, N entier
%%T doit être trouvé expérimentalement en respectant les contrainte
%%ci-dessus
n = 11; % 10,11,12 correct
N = 2^n;
T = N/fe;

q = -N/2:N/2-1;

w = (1+cos(2*pi*q/N))/2;

s=q*Te;
dn = N/2;
dt = dn*Te;
 
Mmax = floor(length(x)*dt);

u = zeros(Mmax,length(q));

for m = 2:Mmax
    t=m*dt;
    for qv = -N/2:N/2-1
        if m*dn+qv<Mmax
            u(m,qv+N/2+1) = x(m*dn+qv)*w(qv+N/2+1);
        end
    end
end
%%Traitement à faire sur u je suppose ?
%%....

%%Reconstruction
x2 = zeros(1,length(x));

for n=1:length(x)
    m = floor(n/dn);
    qv = n-m*dn;
    %fprintf('qv : %d qv-dn : %d\n',qv+dn,qv-dn);
    x2(n) = u(m+1,qv+dn+1)+u(m+1+1,qv+1);
end
x2 = x-x2;
xf = x2(space+1:length(x2));