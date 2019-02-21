function [ ] = create_crystal_fcc(l1,l2,l3)

% la, l2, l3 in nanometers

%lattice parameter of fcc Fe

%% %%%%%% check the value!
a = 0.3515
%% %%%%%%
atomvolume = a^3/4;
density=1/atomvolume;

%% create fcc lattice

n1=floor(l1/a);
n2=floor(l2/a);
n3=floor(l3/a);
i=0:n1-1;
j=0:n2-1;
k=0:n3-1;

X1 = transpose(a * i);
X2 = transpose(a/2 + a * i);
Y1 = a * j;
Y2 = a / 2 + a * j;
Z1 = a * k;
Z2 = a / 2 + a * k;

%corners
A=repmat(X1,n2,1);
A=repmat(A,n3,1);
%face bottom
B=repmat(X2,n2,1);
B=repmat(B,n3,1);
%need another A for face side y and another B for face side x
%corner, bottom, side y, sidex
X=[A;B;A;B];
length(X)
clear A
clear B
for m = 1:n2
    %corner and size face x
    yA(((m-1)*n1+1):m*n1,1) = Y1(m);
    %bottom and size face y
    yB(((m-1)*n1+1):m*n1,1) = Y2(m);
end
yA=repmat(yA,n3,1);
yB=repmat(yB,n3,1);
Y=[yA;yB;yB;yA];
length(Y)
clear yA
clear yB
for m = 1:n3
    %corner and bottom
    zA(((m-1)*n1*n2+1):m*n1*n2,1) = Z1(m);
    %side y and side x
    zB(((m-1)*n1*n2+1):m*n1*n2,1) = Z2(m);
end
Z=[zA;zA;zB;zB];
length(Z)
clear zA
clear zB

N=length(X)
mass=zeros(N,1);

%[X,Y,Z]

%figure(1)
%scatter3(X,Y,Z ,50,[0 0 1],'fill')
%axis equal

savepos(X,Y,Z,mass,'crystal-fcc-50-50-100.pos')