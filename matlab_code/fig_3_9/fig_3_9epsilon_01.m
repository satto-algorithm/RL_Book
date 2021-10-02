function fig_3_9epsilon_01()  
row = 3;
col = 4;
start.row = 3;
start.col = 4;
start;
goal.row= 1;
goal.col = 1;
goal;
N_goal.row=2;
N_goal.col=1;
N_goal;
barrier.row=2;
barrier.col=3;
barrier;
max_episode=2000;
return_Q=zeros(row,col,4,2);
policy_value=zeros(row,col);
policy1=zeros(row,col);
Q= zeros(row,col,4);
global policy;
policy=zeros(row,col);
policy(3,1)=4;
policy(3,2)=1;
policy(2,2)=1;
policy(1,2)=3;
policy(3,3)=4;
policy(1,3)=3;
policy(3,4)=1;
policy(2,4)=1;
policy(1,4)=3;
small_enough=0.001;
theta=randn(1,4)/2;
disp(theta);
delta=[];
for times=1:max_episode
    alpha=0.001;
    biggest_change=0;
    state_G=play_game(policy);
    len_stateG=length(state_G);
    seen_state_action=zeros(row,col,4);
    for tin=1:len_stateG
        sag=state_G(tin,:);
        s=sag{1};
        a=sag{2};
        G=sag{3};
        if seen_state_action(s(1),s(2),a)==0
           return_Q(s(1),s(2),a,1)=return_Q(s(1),s(2),a,1)+1;
           return_Q(s(1),s(2),a,2)=return_Q(s(1),s(2),a,2)+G;
           Q(s(1),s(2),a)=return_Q(s(1),s(2),a,2)/return_Q(s(1),s(2),a,1);
           [G1,~]=max(Q(s(1),s(2),:));
           old_theta=theta;
           x=stox(s(1),s(2));
           v_hat=dot(theta,x);
           theta=theta+(alpha*((G1-v_hat)*x));
           biggest_change=max(biggest_change,abs(sum(old_theta-theta)));
           seen_state_action(s(1),s(2),a)=G;
        else
           do=0;
        end 
    end
    delta=[delta; biggest_change];
   for r=1:row
    for c=1:col
        if policy(r,c)~=0
            [val,in] =max(Q(r,c,:));  
            policy1(r,c)=in;
            policy_value(r,c)=val;
        end
    end
   end
end
plot(delta)
pause(1)
% disp("this is optimal policy")
draw_a_grid(policy1, row, col,start,goal,barrier,N_goal)
disp(policy_value)
disp(policy1)
disp(Q)
end
function xs=stox(s1,s2)
    xs=[s1,s2,s1*s2,1];
end
function state=play_game(policy)
    gamma = 0.9;
    width=4;
    height=3;
    start=[3,4];
    goal=[1,1];
    N_goal=[2,1];
    barrier=[2,3];
    game=grid(); 
    game.initialization(width,height,start,goal,barrier,N_goal);
    game.reset();
    a=policy(game.start(1),game.start(2));  
    action=random_action(a);
    r=0;
    all_SAR=[];
    all_SAR=[all_SAR;{start,action,r}];
    while (1)
        out=game.step(action);
        n_state=out{1};
        r=out{2};
        done=out{3};
        if done==1
             all_SAR=[all_SAR;{n_state,0,r}];
            break;
        end
        a=policy(game.current(1),game.current(2));
        action=random_action(a);
        all_SAR=[all_SAR;{n_state,action,r}];
    end
    t=length(all_SAR);
    G=0;
    t_SAG=[];
    for steps=1:t
        r_out=all_SAR((t-(steps-1)),:);
        states=r_out{1};
        actions=r_out{2};
        reward=r_out{3};
        if steps==1
            do=0;
        else
            t_SAG=[t_SAG;{states,actions,G}];
        end
        G=round((reward+gamma*G),3);
        
    end
    state=t_SAG;  
end
function action = random_action(a)
    p=rand(1);
    eps=0.1;
    if p<(1-eps)
        action=a;
    else
        action=randi([1,4],1);
    end
end


