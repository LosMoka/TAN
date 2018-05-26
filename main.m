fe = 44100; %%freq d'éch d'un CD-ROM
[xo,fx0] = audioread('johan2.wav');%%Signal de parole
[x1,fx1] = audioread('chute.wav'); %%Signal quelconque

%xo = xo / mean(xo);
%x1 = x1 / mean(x1);

[a,dn,x] = cepstre(xo,x1,60);
xf = rebuild(a,length(x),dn);

soundsc(real(xf),fe);