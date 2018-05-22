fe = 44100; %%freq d'éch d'un CD-ROM
[xo,fx0] = audioread('test.wav');%%Signal de parole
[x1,fx1] = audioread('chute2s.wav'); %%Signal quelconque

[a,dn,u] = cepstre(xo,x1,100000);
xf = rebuild(a,length(x1),dn);

soundsc(real(xf),fe);