function      [AA,T,nn,no,np,err_of_SSD]=zzcssdblkr(A,tol)

%SSDBLKR  Stability Structural Decomposition for Continus-time Systems
%
%     [AA,T,nn,no,np]=zzcssdblkr(A[,tol])
%
%     puts any square matrix in the following block diagonal form,
%           
%                                | A-    0     0  |  nn
%              AA = inv(T)*A*T = | 0     Ao    0  |  no
%                                | 0     0     A+ |  np
%                         
%     where eigenvalues of (A-), (Ao) and (A+) are, respectively,
%     in the open left-half, jw axis and open right-half s-plane.
%
%     See also SSD, CSSDRESCH, DSSD.

%   Note that: cssdresch uses the function blkrsch.

if nargin==1
   tol=1e-8;
end;

flag=1;
n=size(A,1);
if n==0
   AA=[]; T=[]; nn=0; no=0; np=0; err_of_SSD=0;
   return;
end

tt=real(eig(A,'balance'));
nn=sum(tt<-tol); np=sum(tt>tol); no=n-nn-np;
T=eye(n);
if np~=0 & (nn+no)~=0
   [P,t,t]=blkrsch(A,4,nn+no);
   Tno=P(:,1:nn+no);
   [P,t,t]=blkrsch(-A,4,np);
   Tp=P(:,1:np);
   T=[Tno,Tp];
end
if no~=0 & nn~=0
   tt=inv(T)*A*T;
   Ano=tt(1:nn+no,1:nn+no);
   [P,t,t]=blkrsch(Ano,4,nn);
   Tno=P(:,1:nn);
   [P,t,t]=blkrsch(-Ano,4,no);
   Tp=P(:,1:no);
   tt=[Tno,Tp];
   t=eye(n); t(1:size(tt,1),1:size(tt,2))=tt;
   T=T*t;
end

if cond(T)>1e15
   AA=A;T=eye(n);nn=0;no=0;np=0;err_of_SSD=inf;flag=0;
   return
end

AA=inv(T)*A*T;
tt=blkdiag(ones(nn),ones(no),ones(np));
AA=AA.*tt;
err_of_SSD=norm(AA-inv(T)*A*T);