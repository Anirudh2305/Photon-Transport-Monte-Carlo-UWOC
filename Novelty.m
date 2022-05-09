tic
%% Parameters
lamda=532*1e-9;
beam_width=3e-3;
source_div=20*pi/180; %radians (20o)
g=0.924; % Henyey-Greenstein constant
Roulette_threshold=1e-4;
alpha=10;
n1=1.325;
n2=1;
reflLoss=((n1-n2)^2)/((n1+n2)^2);
%----Harbor---------%
%{
a=0.295;
b=1.875;
c=a+b;
albedo=b/c;
%}
%-------Pure Sea----------%
%{
a=0.053;
b=0.003;
c=a+b;
albedo=b/c;
%}
%-------Coastal----------%
%{
a=0.088;
b=0.216
c=a+b;
albedo=b/c;
%}
%----------- Clear Ocean-----------------%
a=0.069;
b=0.08;
c=a+b;
albedo=b/c;
%}
D=5e-3; % Lens diameter
%Z=20; % Distance between source and receiver(m) along Z-axis.
depth=1;
N=1e6;
cross=0;
Intensity=zeros(9,1);
for Z=0:5:40
    I=0;
for i=1:N
    pho=Photon;
    pho.wt=1;
    pho.x=beam_width*rand;
    pho.z=0;
    pho.y=beam_width*rand;
    thetaO= -source_div + (source_div-(-source_div))*rand;
    phiO=2*pi*rand;
    pho.mux=sin(thetaO)*cos(phiO);
    pho.muy=sin(thetaO)*sin(phiO);
    pho.muz=cos(thetaO);
    magn=sqrt(pho.mux^2 + pho.muy^2 + pho.muz^2);
    pho.mux=pho.mux/magn;
    pho.muy=pho.muy/magn;
    pho.muz=pho.muz/magn;

    while pho.wt~=0
        isRef=0;
        s=-log(rand)/c;
        pho=updateDir(pho,s);
        if pho.z>=Z
            x_int=pho.x+((Z-pho.z)/pho.muz)*pho.mux;
            y_int=pho.y+((Z-pho.z)/pho.muz)*pho.muy;
            if sqrt(x_int^2+y_int^2)<=D/2
                I=I+pho.wt;
                cross=cross+1;
            end
            break;
        end
%--------------Check reflection------------------------%
       if(pho.y>=depth)
            x_int=pho.x+((depth-pho.y)/pho.muy)*pho.mux;
            z_int=pho.z+((depth-pho.y)/pho.muy)*pho.muz;
            pho.x=x_int;
            pho.y=depth;
            pho.z=z_int;
            inc_ang=acos(pho.muy);
            if(inc_ang>=asin(1/1.325)) % Critical angle check
                 isRef=1;
            else
                break;
            end
       end
%----------------------------------------------%   
        if(isRef==1)
            pho.muy=-pho.muy;
            pho.wt=pho.wt*(1-reflLoss);
        else
        % find theta and phi and then change DCs
        theta=Hen_Green(g);
        phi=2*pi*rand;
        pho=updateDC(pho,theta,phi);
        % Reduce weight and check for roulette threshold
        pho.wt=pho.wt*albedo; 
        end
        if(pho.wt<=Roulette_threshold)
            if rand>(1/alpha)
                pho.wt=0;
            else
                pho.wt=pho.wt*alpha;
            end
        end 
    end
end  
Intensity((Z/5)+1)=I/N;
end
toc
%%
x1=0:5:40;
Intensity=20*log10(Intensity);
plot(x1,Intensity,'-o',"LineWidth",1.2);
