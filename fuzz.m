function [finA]=nufuzz(C,c0,ir)

 [no_input,no_col]=size(C); 
obs = C(:,no_col);    
 A = [];
 B = [];

for i = 1:no_input
    if(obs(i) == 1)
        A = [A;C(i,1:no_col-1)];
    else
        B = [B;C(i,1:no_col-1)];
    end
end
[x y]=size(A);
[x1 y1]=size(B);

        s = sum(A,1)/x; 
        h = sum(B,1)/x1;

distancec1=zeros(x1,1);    
for i = 1:x1
   diff = B(i,1:no_col-1) - h(1:no_col-1);
   distancec1(i) = sqrt(diff * diff');
end

[val ind]=max(distancec1);
rn=val;


diff = s-h ;
db= sqrt(diff * diff');
for i = 1:no_input
        diff = C(i,1:no_col-1)-s ;
        dist1= sqrt(diff * diff');
        diff = C(i,1:no_col-1)-h ;
        dist2= sqrt(diff * diff');
        
    if(obs(i) == 1)
        memb(i,1)=1;
      
    else 
        memb(i,1)=(1/(ir+1))+(ir/(ir+1))*(exp(c0*((dist1-dist2)/db-dist2/rn))-exp(-2*c0))/(exp(c0)-exp(-2*c0));
      
    end
end
finA=[C memb];

end
   