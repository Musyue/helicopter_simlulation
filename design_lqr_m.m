clc
% clear all
A=[
0 0 1 0 0 0 0.0009 0 0;
0 0 0 0.9992 0 0 -0.0389 0 0;
0 0 -0.0302 -0.0056 -0.0003 585.1165 11.4448 -59.529 0;
0 0 0 -0.0707 267.7499 -0.0003 0 0 0;
0 0 0 -1.0000 -3.3607 2.2223 0 0 0;
0 0 -1 0 2.4483 -3.3607 0 0 0;
0 0 0.0579 0.0108 0.0049 0.0037 -21.9557 114.2 0;
0 0 0 0 0 0 -1 0 0;
0 0 0 0.0389 0 0 0.9992 0 0;
];
B=[
0 0 0;
0 0 0;
0 0 43.3635;
0 0 0;
0.2026 2.5878 0;
2.5878 -0.0663 0;
0 0 -83.1883;
0 0 -3.8500;
0 0 0;
];
% B=[
% 0 0 0 0 0 0 0 0 0;
% 0 0 0 0 0 0 0 0 0;
% 0 0 43.3635 0 0 0 0 0 0;
% 0 0 0 0 0 0 0 0 0;
% 0.2026 2.5878 0 0 0 0 0 0 0;
% 2.5878 -0.0663 0 0 0 0 0 0 0;
% 0 0 -83.1883 0 0 0 0 0 0;
% 0 0 -3.8500 0 0 0 0 0 0;
% 0 0 0 0 0 0 0 0 0;
% ];
E=[
0 0 0;
0 0 0;
-0.0001 0.1756 -0.0395;
0.0000 0.0003 0.0338;
0 0 0;
0 0 0;
-0.0002 -0.3396 0.6424;
0 0 0;
0 0 0;
];
% trim=[0.0389 0.0009 0 0 -0.0009 0.0049 0 0 0 -0.1746 0.0072 0.0054 0];
% syms b1 b2 b3 b4 b5 b6 a1 a2 a3
% a1=13
% a2=12
% a3=30
% b1=13
% b2=12
% b3=1
% b4=1
% b5=1
% b6=6
C1=[1 0 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 1;
];

Q=[  1     0     0     0     0     0     0     0     0;
     0     1     0     0     0     0     0     0     0;
     0     0     1     0     0     0     0     0     0;
     0     0     0     1     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     1     0     0;
     0     0     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0     0     1;]

R=0.001
% R=[  0.09     0     0;
%      0     0.09     0;
%      0     0     0.09]

% P=are(A,B,Q)

% F=inv(R)*B'*P
[X1,K1,L1] = icare(A,[],Q'*Q,[],[],[],-B*B');
F=inv(R)*B'*X1
Abk=A-B*F
eigabk=eig(Abk)

Qe=0.001*eye(9);

Re=0.004;

% %for kalman
[X2,K2,L2] = icare(A,[],Qe'*Qe,[],[],[],-C1*C1');
% Pk=are(A,C1,Qe)
Ke=X2*C1'*inv(Re)
Ack=A-Ke*C1
eigack=eig(Ack)
x0=[0;-0.1;0;0;0;0;0;0;0.1;0;0;0;0;0;0;0;0;0]
GG=C1*inv(A-B*F)*B
G=inv([GG(1:2,:);GG(9,:)])
% G=inv(C1*inv(A-B*F)*B)
Ac=[A-B*F B*F;zeros(9) A-Ke*C1]
Zero_tem=[
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0;
         0         0         0];
Bc=[B*G;Zero_tem]
Cc=[C1 zeros(9)]

% Vw=[E;E-Ke*[0;0;1;1;0;0;1;0;0]]
Vw=[E;E]
Vke=[[0;0;0;0;0;0;0;0;0];-Ke*[1;1;1;1;0;0;1;0;1]]
Rref=[0;0;0]
Kee=[zeros(9);Ke]
% syms s
% Ls=vpa(F*inv(s*eye(9)-A+B*F+Ke*C1)*(C1*inv(s*eye(9)-A)*B))