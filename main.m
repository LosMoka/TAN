fe = 44100; %%freq d'éch d'un CD-ROM
[xo,fx0] = audioread('test.wav');%%Signal de parole
[x1,fx1] = audioread('chute.wav'); %%Signal quelconque

[a,dn] = cepstre(xo,x1);
xf = rebuild(a,length(x1),dn);

soundsc(xf,fe);