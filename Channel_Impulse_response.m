tic
%% Parameters
%mu=1.325
speed=2.26e+8;
lamda=532*1e-9;
beam_width=3e-3;
source_div=20*pi/180; %radians (20o)
g=0.924; % Henyey-Greenstein constant
Roulette_threshold=1e-4;
alpha=10;
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
%----------- Clear Ocean-----------------%

a=0.069;
b=0.08;
c=a+b;
albedo=b/c;
%}
D=20e-2; % Lens diameter
Z=20; % Distance between source and receiver(m) along Z-axis.
N=1e6;
%storeWT=zeros(N,1);
%storeAP=zeros(N,1);
cross=0;
I=0;
dist=zeros(6000,1);
imp=zeros(6000,1);
for i=1:N
    d=0;
    pho=Photon;
    pho.wt=1;
    %pho.x=0;
    pho.x=beam_width*rand;
    pho.z=0;
    %pho.y= -beam_width/2 + ((beam_width/2)-(-beam_width/2))*rand;
    pho.y=beam_width*rand;
    thetaO= -source_div + (source_div-(-source_div))*rand;
    phiO=2*pi*rand;
    pho.mux=sin(thetaO)*cos(phiO);
    pho.muy=sin(thetaO)*sin(phiO);
    pho.muz=cos(thetaO);
    while pho.wt~=0
        s=-log(rand)/c;
        pho=updateDir(pho,s);
        
        if pho.z>=Z
            x_int=pho.x+((Z-pho.z)/pho.muz)*pho.mux;
            y_int=pho.y+((Z-pho.z)/pho.muz)*pho.muy;
            if sqrt(x_int^2+y_int^2)<=D/2
                I=I+pho.wt;         
                cross=cross+1;
                imp(cross)=pho.wt;
                %calc resi
                resi=sqrt((pho.x-x_int)^2 + (pho.y-y_int)^2 + (pho.z-Z)^2);
                d=d+s-resi;
                dist(cross)=d;
            end
            break;
        end
        d=d+s;
        %}

        % find theta and phi and then change DCs
        theta=Hen_Green(g);
        phi=2*pi*rand;
        pho=updateDC(pho,theta,phi);
        % Reduce weight and check for roulette threshold
        pho.wt=pho.wt*albedo;
        if(pho.wt<=Roulette_threshold)
            pho.wt=0;
        end
    end
end
    
I=I/N;
IR=10*log10(I);
toc
%%
time=dist/speed;
time=time(1:cross);
imp=imp(1:cross);
[time2,I]=sort(time);
imp2=imp(I);
%%
Int2=10*log10(imp2/N);
plot(time2(1:100:1300),Int2(1:100:1300),'-o','LineWidth',1.2);
%}
%{
time=dist/speed;
time=time(1:cross);
imp=imp(1:cross);
[imp2,I]=sort(imp);
time2=time(I);
Int2=10*log10(imp2/N);
plot(time2(1:100:5500),Int2(1:100:5500),'-o','LineWidth',1.2);
%}