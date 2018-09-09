%----------------------Question-----------------%

%Solving the rain man problem with help of 
%Forward-Backward algorithm

% We have two possible states
%State1=Rain
%State2=No Rain

%Also weather has 70% chance of being the same each day 
%and 30% chance of changing

%Each state has two events associated with it 
%Event1=Umbrella
%Event2=No Umbrella

%The observed sequence of events is {Umbrella, Umbrella, No Umbrella, Umbrella, Umbrella}

%Predict the weather on each day.

%----------------------Solution---------------------%

%We can model this with HMM and solve the question with Forward Backward Algorithm

% Transition Matrix , 
%
%				T= 0.7   0.3
%				   0.3   0.7
%

% Emission Matrix, 
%
%				B= 0.9   0.1
%				   0.2   0.8
%
% Let the initial state vector be, pi0 = 0.5
%									     0.5

% Final Probability Vector, b0 = 1.0
%                                1.0
%Event Matrix (umbrella = 1, no umbrella = 2)
%
%                   1
%					1	
%				 E= 2
%					1
%					1

%--------------------Initialisation---------------------------%

clear ; close all; clc
T=[0.7 0.3; 0.3 0.7];
B=[0.9,0.1; 0.2 0.8];
pi0=[0.5;0.5];
b0=[1;1];
E=[1;1;2;1;1];
m=size(E,1);
n=size(pi0,1);
prev_f=zeros(n,m);
prev_b=zeros(n,m);
this_f=zeros(n,m);
this_b=zeros(n,m);
prev_f=[pi0 prev_f(:,2:m)];
prev_b=[prev_b(:,1:(m-1)) b0];
%---------------------Forward Algorithm----------------------%

for i=1:m
	O=diag(B(:,E(i)),0); % The diagonal observation matrix 
	this_f(:,i)=O*T*prev_f(:,i);
	p=sum(this_f(:,i));
	this_f(:,i)=this_f(:,i)/p;
	if i< m
		prev_f(:,i+1)=this_f(:,i);
	endif
endfor

%--------------------Backward Algorithm-------------------------%
for j=1:m
	i=m-j+1;
	O=diag(B(:,E(i)),0); % The diagonal observation matrix
	this_b(:,i)=T*O*prev_b(:,i);
	p=sum(this_b(:,i));
	this_b(:,i)=this_b(:,i)/p;
	if i>1
		prev_b(:,i-1)=this_b(:,i);
	endif
endfor
%--------------------Smoothing---------------------------%
this_f_final= [pi0 this_f];
this_b_final= [this_b b0];

answer=this_f_final .* this_b_final;
answer=answer ./ sum(answer);
answer=answer(:,2:m+1);
[val, index]=max(answer, [], 1);
index

%index=1 means rain while index=2 means no rain that day
% hence by checking the index values for each day we can predict whether
% that was a rainy day or not.

%Did I make this change????