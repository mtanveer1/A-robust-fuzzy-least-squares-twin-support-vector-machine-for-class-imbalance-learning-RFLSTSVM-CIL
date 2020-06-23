function [accuracy,train_Time]=rflstsvm(A,A_test,c,c0,mew,ir)
mew1=1/(2*mew*mew);
[m,n]=size(A);[m_test,n_test]=size(A_test);
x0=A(:,1:n-1);y0=A(:,n);
xtest0=A_test(:,1:n_test-1);ytest0=A_test(:,n_test);
Cf=[x0 y0];
tic
C=fuzz(Cf,c0,ir);
time1=toc;
[no_input,no_col]=size(C);
  mem=C(:,no_col);
  C=C(:,1:no_col-1);
 
  [no_input,no_col]=size(C);
  obs = C(:,no_col);    
  A = [];
 B = [];
 Amem = [];
 Bmem = [];
for i = 1:no_input
    if(obs(i) == 1)
        A = [A;C(i,1:no_col-1)];
        Amem=[Amem;mem(i)];
    else
        B = [B;C(i,1:no_col-1)];
        Bmem=[Bmem;mem(i)];
    end
end
%----------------Training-------------
C=[A;B];
m1=size(A,1);m2=size(B,1);m3=size(C,1);
e1=ones(m1,1);e2=ones(m2,1);
K = zeros (m1,m3);
tic
for i =1: m1
    for j =1: m3
        nom = norm( A(i ,:) - C(j ,:) );
        K(i,j)=exp(-mew1*nom*nom);
    end
end
S1=diag(Amem);
S2=diag(Bmem);
G1=[K e1];
G2=[S1*K S1*e1];
GGT1=G1*G1';
GGT2=G2*G2';

K = zeros (m2,m3);
for i =1: m2
    for j =1: m3
        nom = norm( B(i ,:) - C(j ,:) );
        K(i,j)=exp(-mew1*nom*nom);
    end
end
H1=[S2*K S2*e2];
H2=[K e2];
HHT1=H1*H1';
HHT2=H2*H2';

eps=1e-5;
I1=speye(m+1);
% S=[];

if (m1<m2)
    I2=speye(m2);
    Y1=eps\(I1-H1'*((eps*I2+HHT1)\H1));
    GY1=G1*Y1;YGT1=Y1*G1';GYGT1=G1*YGT1;
    Y2=eps\(I1-H2'*((eps*I2+HHT2)\H2));
    GY2=G2*Y2;YGT2=Y2*G2';GYGT2=G2*YGT2;
    I=speye(m1);
    u1=-(Y1-YGT1*((c*I+GYGT1)\GY1))*H1'*S2*e2;
    u2=c*(Y2-YGT2*(((c\I)+GYGT2)\GY2))*G2'*e1;
else
    I2=speye(m1);
    Z1=(I1-G1'*((eps*I2+GGT1)\G1))*(1/eps);
    HZ1=H1*Z1;ZHT1=Z1*H1';HZHT1=H1*ZHT1;
    Z2=(I1-G2'*((eps*I2+GGT2)\G2))*(1/eps);
    HZ2=H2*Z2;ZHT2=Z2*H2';HZHT2=H2*ZHT2;
    I=speye(m2);
    u1=-c*(Z1-ZHT1*((c\I+HZHT1)\HZ1))*H1'*S2*e2;
    u2=(Z2-ZHT2*(((c*I)+HZHT2)\HZ2))*G2'*e1;       
end

train_Time=time1+toc;
%---------------Testing---------------

no_test=size(xtest0,1);
K = zeros(no_test,m3);
for i =1: no_test
    for j =1: m3
        nom = norm( xtest0(i ,:) - C(j ,:) );
        K(i,j )=exp(-mew1*nom*nom);
    end
end
K=[K ones(no_test,1)];
preY1=K*u1/norm(u1(1:size(u1,1)-1,:));preY2=K*u2/norm(u2(1:size(u2,1)-1,:));
predicted_class=[];
for i=1:no_test
    if abs(preY1(i))< abs(preY2(i))
        predicted_class=[predicted_class;1];
    else
        predicted_class=[predicted_class;-1];
    end

end


%%%%%%% accuracy
no_test=m_test;
  classifier=predicted_class;
  obs1=ytest0;
  match = 0.;
match1=0;

posval=0;
negval=0;

for i = 1:no_test
    if(obs1(i)==1)
    if(classifier(i) == obs1(i))
        match = match+1;
    end
     posval=posval+1;
    elseif(obs1(i)==-1)
        if(classifier(i) ~= obs1(i))
        match1 = match1+1;
        end
    negval=negval+1;
    end
end
if(posval~=0)
a_pos=(match/posval)
else
a_pos=0;
end

if(negval~=0)
am_neg=(match1/negval)
else
am_neg=0;
end

AUC=(1+a_pos-am_neg)/2;

accuracy=AUC*100


return
end
