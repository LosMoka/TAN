fe = 44100; %%freq d'éch d'un CD-ROM
xo = rand(1,fe*10);%%Signal de parole

%Découpage du signal de parole

space = 4000;
x = xo;%[zeros(1,space),xo];

%%T < 125ms (durée max d'un phonème)
%%T > 20 ms (voix basse d'un homme : 50hz)

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
 
Mmax = floor(length(x)/dn)-1;

u = zeros(Mmax+1,length(q));

for m = 0:Mmax-1
    for qv = -N/2:N/2-1
        u(m+1,qv+N/2+1) = x(m*dn+qv+N/2+1)*w(qv+N/2+1);
    end
end
%%Transformation de Fourier à court terme

X = zeros(Mmax+1,N);

for m = 0:Mmax-1
   uf = u(m+1,1:N);
   UF = abs(fft(uf));
   for k = 1:N
        X(m+1,k) = UF(k);
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

jseuil=0;

cprime=zeros(Mmax+1,N);
for j=jseuil:Mmax-jseuil-1
    for k = 1:N
        cprime(j+1,k) = c(j+1,k);
    end
end

%calcul du logarithme de la reponse frequentielle
Cprime=zeros(Mmax+1,N);
for m=0:Mmax-1
    cm = cprime(m+1,1:N);
   CM = abs(fft(cm));
   for k = 1:N
        Cprime(m+1,k) = CM(k);
   end
end

%Calcul de l'estimée de la réponse fréquentielle
H=zeros(Mmax+1,N);
for m=0:Mmax-1
   hm = Cprime(m+1,1:N);
   HM = abs(fft(cm));
   for k = 1:N
        H(m+1,k) = exp(HM(k));
   end
end


%%Reconstruction
x2 = zeros(1,length(x));

for n=1:length(x)-2*dn
    m = floor(n/dn);
    qv = n-m*dn;
    %fprintf('qv : %d qv-dn : %d\n',qv+dn,qv-dn);
    x2(n) = u(m+1,qv+dn+1)+u(m+1+1,qv+1);
end
%x2 = x-x2;
xf = x2;%(space+1:length(x2));






