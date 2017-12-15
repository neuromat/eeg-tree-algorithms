function ctt = Find_ctt(Rythm, ctt, x)

if strcmp(Rythm,'Ter')==1
     if x==2
        ctt=2;
     elseif ctt==2 && x==1 
        ctt=21;   
     elseif ctt==2 && x==0
        ctt=20;   
     elseif ctt==21 && x==1
        ctt=11;   
     elseif ctt==21 && x==0
        ctt=10;   
     elseif ctt==20 && x==1
        ctt=01;   
     elseif ctt==20 && x==0
        ctt=00;
     end   
     
elseif strcmp(Rythm,'Qua')==1
     if x==2
        ctt=2;
    elseif ctt==2 && x==1 
        ctt=21;
    elseif ctt==2 && x==0
        ctt=20;
    elseif ctt==21  
        ctt=10;
    elseif ctt==20  
        ctt=200;
    elseif ctt==10 && x==1 
        ctt=01;    
    elseif ctt==10 && x==0 
        ctt=100;   
    elseif ctt==200 && x==1   
        ctt=01;
    elseif ctt==200 && x==0   
        ctt=000;
    end
 end
end