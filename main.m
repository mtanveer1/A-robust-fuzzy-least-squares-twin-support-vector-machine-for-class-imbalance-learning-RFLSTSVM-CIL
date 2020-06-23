clc;
clear all;
close all;
file1 = fopen('result.txt','a+');
fprintf(file1,'%s\n',date);

          
 for load_file = 1:2
    %% initializing variables
    no_part = 10.;
    %% to load file
    switch load_file


       case 1
            file = 'ecoli-0-1_vs_2-3-5';
            test_start =121;
            cvs1=10;
            mus=32;
			epsv=0.4;
       case 2
            file = 'ecoli-0-1_vs_5';
            test_start =121;
            cvs1=10;
            mus=32;
			epsv=0.4;
            
      
        otherwise
            continue;
    end
% %parameters 
        cvs1=[10^-5,10^-4,10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3,10^4,10^5];
       mus=[2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5];
         cvs0=[0.5,1,1.5,2,2.5];
   
         
         
%Data file call from folder   

filename = strcat('./newd/',file,'.mat');
    A = load(filename);
    [m,n] = size(A);
%define the class level +1 or -1    
    for i=1:m
        if A(i,n)==0
            A(i,n)=-1;
        end
    end
    test = A(test_start:m,:);
    train = A(1:test_start-1,:);


    [no_input,no_col] = size(train);
  
    x1 = train(:,1:no_col-1);
    y1 = train(:,no_col);
	    
    [no_test,no_col] = size(test);
    xtest0 = test(:,1:no_col-1);
    ytest0 = test(:,no_col);

%Combining all the column in one variable
    A=[x1 y1];    %training data
    [m,n] = size(A);
    A_test=[xtest0,ytest0];    %testing data
    p=0;
    for i=1:m
        if A(i,n)==1
            p=p+1;
        end
    end
    ir=(m-p)/(p);
 %% initializing crossvalidation variables

    [lengthA,n] = size(A);
    min_err = -10^-10.;

  
  for C1 = 1:length(cvs1)
            c = cvs1(C1)
             for C0 = 1:length(cvs0)
            c0 = cvs0(C0)
           for mv = 1:length(mus)
                    mu = mus(mv)

                    avgerror = 0;
                    block_size = lengthA/(no_part*1.0);
                    part = 0;
                    t_1 = 0;
                    t_2 = 0;
                    while ceil((part+1) * block_size) <= lengthA
                   %% seprating testing and training datapoints for
                   % crossvalidation
                                t_1 = ceil(part*block_size);
                                t_2 = ceil((part+1)*block_size);
                                B_t = [A(t_1+1 :t_2,:)];
                                Data = [A(1:t_1,:); A(t_2+1:lengthA,:)];
                   %% testing and training
                                [accuracy_with_zero,time] = rflstsvm(Data,B_t,c,c0,mu,ir);
                                avgerror = avgerror + accuracy_with_zero;
                                part = part+1
                     end
       
               if avgerror > min_err
               min_err = avgerror;
               min_mu = mu;
               min_c1 = c;
               min_c0=c0;
               
           end
%                  
           end
%             
       end
  end
       
   
 [accuracy,time] = NonL_LSTWSVM(A,A_test,min_c1,min_c0,min_mu,ir);
 fprintf(file1,'%s\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n',file,size(A,1),size(A_test,1),accuracy,min_c1,min_c0,min_mu,time);
end