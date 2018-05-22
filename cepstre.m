function [ a,dn, u ] = cepstre( xo,x1,jseuil, T )
%CEPSTRE Summary of this function goes here
%   Detailed explanation goes here
fe = 44100; %%freq d'éch d'un CD-ROM
%xo;%%Signal de parole
%x1; %%Signal quelconque
%Découpage du signal de parole

space = 4000;
x = xo;%[zeros(1,space),xo];

%%T < 125ms (durée max d'un phonème)
%%T > 20 ms (voix basse d'un homme : 50hz)
Te = 1/fe;
%%T doit respecter T = 2^N / fe, N entier
%%T doit être trouvé expérimentalement en respectant les contrainte
%%ci-dessus
n = 10; % 10,11,12 correct
N = 2^n;
T = N/fe;

q = -N/2:N/2-1;

w = (1+cos(2*pi*q/N))/2;

s=q*Te;
dn = N/2;
dt = dn*Te;
 
Mmax = floor(length(x)/dn)-1;

u = zeros(Mmax+1,length(q));

for m = 0:Mmax-1
    for qv = -N/2:N/2-1
        u(m+1,qv+N/2+1) = x(m*dn+qv+N/2+1)*w(qv+N/2+1);
    end
end
%%Transformation de Fourier à court terme parole

X = zeros(Mmax+1,N);

for m = 1:Mmax
   uf = u(m,1:N);
   UF = fft(uf);
   for k = 1:N
        X(m,k) = UF(k);
   end
end

%Partie transformée court terme signal quelconque

%calcul des découpes de x ramenées en 0
p = zeros(Mmax+1,length(q));

for m = 0: Mmax-1
    for q2 = -N/2:N/2-1
        p(m+1,q2+N/2+1) = x1(m*dn+q2+N/2+1)*w(q2+N/2+1);
    end
end

%calcul du spectre court terme du son quelconque
E = zeros(Mmax+1,N);

for m=0:Mmax-1
    pf = p(m+1,1:N);
    PF =fft(pf);
    for k=1:N
        E(m+1,k) = PF(k);
    end
end
        

%calcul du cepstre court terme du signal de parole
c=zeros(Mmax+1,N);
for m = 0:Mmax-1
   tmp = X(m+1,1:N);
   idft= ifft(log(abs(tmp)));
   for k = 1:N
        c(m+1,k) = idft(k);
   end
end

%fenetrage du cepstre avec jseuil à trouver experimentalement

cprime=c;%zeros(Mmax+1,N);
for j=jseuil:N-jseuil-1
    for k = 1:N
        cprime(j+1,k) = 0;%;c(j+1,k);
    end
end

%calcul du logarithme de la reponse frequentielle
Cprime=zeros(Mmax+1,N);
cm = zeros(1,N);
for m=0:Mmax-1
    cm = cprime(m+1,1:N);
   CM = fft(cm);
   for k = 1:N
        Cprime(m+1,k) = CM(k);
   end
end

%Calcul de l'estimée de la réponse fréquentielle
H=exp(Cprime);%zeros(Mmax+1,N);
%for m=0:Mmax-1
%   hm = Cprime(m+1,1:N);
%   HM = fft(cm);
%   for k = 1:N
%        H(m+1,k) = exp(HM(k));
%   end
%end

%Calcul de l'Action du conduit vocal:
V=zeros(Mmax+1,N);
for m=0:Mmax-1
   for k = 1:N
        V(m+1,k) = E(m+1,k)*H(m+1,k);
   end
end

%FFT-1
a=zeros(Mmax+1,length(q));

for m = 1:Mmax
   af = V(m,1:N);
   adft = ifft(af);
   for k = 1:N
        a(m,k) = adft(k);
   end
end


end

