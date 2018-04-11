%-------------Implementing Forward-Backward Algorithm for general data-----------------%
%The whole program runs on the basic assumption that probability of all the elements of a row or a column=0 is approximately 0 
clear ; close all; clc

%-------------------Initialisation-----------------------------%

% Let this model have t states namely (state1, state2,...,state t)
% Let us define T as transmission matrix

t=5; % Change here for different number of states

T=rand(t,t); % Random Initialisation
p=sum(T,2);
T= T ./ p; % Transmission matrix with each row sum to 1
T;

% Let each state give rise to k events namely (event1, event2,..., event k)
% Let us define B as emission matrix

k=4; % Change here for different number of events

B=rand (t,k); % Random Initialisation
p=sum(B,2);
B=B ./ p; % Emission matrix with each row sum to 1
B;
% Let E be the event vector (ie which event happened on the given day / Sequence of events) and let the sample space have d days in in total

d=10; % Change here for different number of days (ie how long we have seen the events)

E=randi([1,k],d,1); % Random Initialisation

% Let initial state probability vector be pi0

pi0=rand(t,1); % Random Initialisation
pi0=pi0 / sum(pi0); % Such that sum of all the elements of the vector is 1
pi0;

% Let final state probability vector be b0

b0=ones(t,1); % It is a vector of all 1's

prev_f=zeros(t,d);
prev_b=zeros(t,d);
this_f=zeros(t,d);
this_b=zeros(t,d);

prev_f=[pi0 prev_f(:,2:d)];
prev_b=[prev_b(:,1:(d-1)) b0];

%prev_f describes the previous matrix in forward algorithm while
%prev_b is the previous matrix in backward algorithm

%------------------------Forward Algorithm------------------------------%

%General formula used -> this (column)= Observation*Transmission*Previous(column-1)

for i=1:d
	O=diag(B(:,E(i)),0); % The diagonal observation matrix 
	this_f(:,i)=O*T*prev_f(:,i);
	p=sum(this_f(:,i));
	this_f(:,i)=this_f(:,i)/p;
	if i< d
		prev_f(:,i+1)=this_f(:,i);
	endif
endfor

%this_f contains the forward part of the answer

%---------------------Backward Algorithm------------------------------%
%General formula used -> this (column)= Transmission*Observation*Previous(column+1)
for j=1:d
	i=d-j+1;
	O=diag(B(:,E(i)),0); % The diagonal observation matrix
	this_b(:,i)=T*O*prev_b(:,i);
	p=sum(this_b(:,i));
	this_b(:,i)=this_b(:,i)/p;
	if i>1
		prev_b(:,i-1)=this_b(:,i);
	endif
endfor

%this_b contains the backward part of the answer

%-------------------Smoothing------------------------------%

this_f_final= [pi0 this_f];
this_b_final= [this_b b0];

answer=this_f_final .* this_b_final; 
answer=answer ./ sum(answer); % Probability of each state for a day is stored as a vector in that day's column
answer=answer(:,2:d+1); % We take out the first column as that corresponds to day 0 
[val, index]=max(answer, [], 1); % Getting which state is maximum on each particular day
index
%Each index gives the most likely state on that particular day