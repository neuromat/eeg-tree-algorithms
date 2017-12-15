function Z_final = Statistic (Y1_e,Y2_e,Y3_e,c,Proj)
d1=length(Y1_e(1,1,:));
d2=length(Y2_e(1,1,:));
if~isempty(Y3_e)
d3=length(Y3_e(1,1,:)); 
end
R1=[]; %projected data of cct_1
R2=[]; %projected data of cct_2
R3=[]; %projected data of cct_2
Z_final=0;
P=length(Proj(:,1));
if P>1
    proj = P;
else proj=Proj;
end
for m=1:proj
    if P>1
        B=Proj(m,:);
    else B=Brownian_Brigde(113);
    end
    
    for r=1:d1 %%numero de amostras para ctt_1
        Y1e_r=Y1_e(1,:,r);
        R1(r)=dot(Y1e_r,B);
    end
    for r=1:d2 %%numero de amostras para ctt_2
        Y2e_r=Y2_e(1,:,r);
        R2(r)=dot(Y2e_r,B);
    end
    if ~isempty(Y3_e)
        for r=1:d3 %%numero de amostras para ctt_2
            Y3e_r=Y3_e(1,:,r);
            R3(r)=dot(Y3e_r,B);
        end
    end
    
    %% Testing the projected data
    if isempty(Y3_e)
        [~,~,D] = kstest2(R1,R2);
        C=sqrt(d1*d2/(d1+d2));
        if D*C > c
            Z_final=Z_final+1;
        end
    else
        [~,~,D1] = kstest2(R1,R2);
        C1=sqrt(d1*d2/(d1+d2) );
        [~,~,D2] = kstest2(R1,R3);
        C2=sqrt(d1*d3/(d1+d3) );
        [~,~,D3] = kstest2(R3,R2);
        C3=sqrt(d3*d2/(d3+d2) );
        if D1*C1 > c || D2*C2 > c || D3*C3 > c 
            Z_final=Z_final+1;
        end
    end
end
end