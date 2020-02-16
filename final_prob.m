load('data.mat')
%%devide the data into test and train
F1_train=F1(1:100,:);
F1_test=F1(101:1000,:);
F2_train=F2(1:100,:);
F2_test=F2(101:1000,:);

%%%normalize F1 to get Z1
for i = 1:1000
    m = mean(F1(i,:));
    s = std(F1(i,:));
    for j=1:5
        Z1(i,j) = (F1(i,j)-m)/s;
    end
end
 Z1_train=Z1(1:100,:);
 Z1_test=Z1(101:1000,:);

 %%%find the mean std deviation of each class
m1=mean(F1_train);
s1=std(F1_train);
m2=mean(F2_train);
s2=std(F2_train);
m3=mean(Z1);
s3=std(Z1);

%%case1
[acc_f1, err_rate_f1]=calc_accuracy(F1_test,m1,s1,0,0,0);
sprintf("Accuracy of F1=%0.2f and Error rate=%0.2f",acc_f1,err_rate_f1)
%%%case2
[acc_z1, err_rate_z1]=calc_accuracy(Z1_test,m3,s3,0,0,0);
%%case 3
sprintf("Accuracy of Z1=%0.2f and Error rate=%0.2f",acc_z1,err_rate_z1)
[acc_f2,err_rate_f2]=calc_accuracy(F2_test,m2,s2,0,0,0);
sprintf("Accuracy of F2=%0.2f and Error rate=%0.2f",acc_f2,err_rate_f2)

%%case 4

[acc_Z1F2, err_rate_Z1F2]=calc_accuracy(Z1_test,m3,s3,F2_test,m2,s2);

sprintf("Accuracy of Z1F2=%0.2f and Error rate=%0.2f",acc_Z1F2,err_rate_Z1F2)

%%%plot Z1 vs F2
plot(Z1,F2,'o');
legend('C1','C2','C3','C4','C5');
xlabel('Z1');
ylabel('F2');
title('Z1 vs F2');

function [accuracy, err_rate]=calc_accuracy(ds,m,s,ds1,m1,s1)
%P=@(x,m,s)((1/(sqrt(2*pi)*s))*exp(-(x-m)^2/2*s^2));%%normal distribution function

correct_count=zeros(1,5);
for i=1:5
    count=0;
    pred_class=zeros(1,900);
    for j=1:900   
        for k=1:5
            if length(ds1)>1
                   p_d_1(k)=normpdf(ds(j,i),m(k),s(k));
                   p_d_2(k)=normpdf(ds1(j,i),m1(k),s1(k));
                   p_bayes(k)=p_d_1(k)*p_d_2(k)*(1/5); %%%using bayes theorem
            else
                
                p_d(k)=normpdf(ds(j,i),m(k),s(k));
                p_bayes(k)=p_d(k)*(1/5); %%% using Bayes theorem
            end
        end
        %display(p_bayes)
        [v,c]=max(p_bayes);
        if c==i 
                count=count+1;
                pred_class(j)=c;
        end
    end
    correct_count(i)=count; %%correct classification count for each class
      
end
accuracy=(sum(correct_count)/4500)*100;
err_rate=100-accuracy;
end


% scatter(Z1(:,1),F2(:,1,'r'));
% hold on
% scatter(Z1(:,2),F2(:,1,'r');
% hold on
% scatter(Z1(:,1),F2(:,1,'r');
% hold on
% scatter(Z1(:,1),F2(:,1,'r');
% hold on
% scatter(Z1(:,1),F2(:,1,'r');
% hold on 
% scatter(Z1(:,1),F2(:,1,'r');
% xlabel('Z1');
% ylabel('F2');     
% legend('C1','C2','C3','C4','C5');


