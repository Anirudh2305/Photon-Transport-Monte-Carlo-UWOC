tic
%% Parameters
lamda=532*1e-9;
beam_width=3e-3;
source_div=20*pi/180; %radians (20o)
g=0.924; % Henyey-Greenstein constant
Roulette_threshold=1e-4;
alpha=10;
a=0.295;
b=1.875;
c=a+b;
albedo=b/c;
D=50e-2; % Lens diameter
%Z=20; % Distance between source and receiver(m) along Z-axis.
N=1e6;
%%
Intensity=zeros(6,1);
for Z=0:2:10 
    I=0;
 for i=1:N
     %Initialization
    pho=Photon;
    pho.wt=1;
    thetaO= -source_div + (source_div-(-source_div))*rand;
    phiO=2*pi*rand;
    pho.mux=sin(thetaO)*cos(phiO);
    pho.muy=sin(thetaO)*sin(phiO);
    pho.muz=cos(thetaO);
    pho.z=0;
    pho.y= -beam_width/2 + ((beam_width/2)-(-beam_width/2))*rand;
    pho.x= -beam_width/2 + ((beam_width/2)-(-beam_width/2))*rand;
    while pho.wt~=0
        % Path length
        s=-log(rand)/c;
        pho=updateDir(pho,s);
       % check if received or not           
        if pho.z>=Z
            x_int=pho.x+((Z-pho.z)/pho.muz)*pho.mux;
            y_int=pho.y+((Z-pho.z)/pho.muz)*pho.muy;
            if sqrt(x_int^2+y_int^2)<=D/2
                I=I+pho.wt;
            end
            break;
        end
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
 Intensity((Z/2)+1)=I/N;
end 
toc
%%
IHar50=Intensity;
for i=1:6
    IHar50(i)=20*log10(IHar50(i));
end
%%
x1=0:10:100;
x2=0:7:63;
x3=0:5:40;
x4=0:2:10;
plot(x1,IPS50,'-o','LineWidth',1.2);
hold on
plot(x2,ICO50,'-+','LineWidth',1.2);
hold on
plot(x3,ICoast50,'-_','LineWidth',1.2);
hold on
plot(x4,IHar50,'-s','LineWidth',1.2);
xlabel("Distance(m)")
ylabel("Received Intensity(dB)")
title("Intensity vs Distance(D=50cm)")
legend("pure","clean","coastal","Harbor");
grid('on')
xlim([0 100]) 
ylim([-100 0])
%%
%{
x1=0:7:63;
plot(x1,ICO50,'-o','LineWidth',1.2);
xlabel("Distance(m)")
ylabel("Received Intensity(dB)")
title("Intensity vs Distance(D=50cm)")
%}
%%
%IHarbour=IHarbour(1:6);
%%
%{
x1=0:10:100;
plot(x1,IPS50,'-o','LineWidth',1.2);
xlabel("Distance(m)")
ylabel("Received Intensity(dB)")
title("Intensity vs Distance(D=50cm)")
%}
%{
set(gca,"linewidth", 1.5,"fontsize", 16)
x1=0:5:50;
plot(x1,IPure_Sea,'-o','LineWidth',1.2);
hold on
plot(x1,IClean_Ocean,'-+','LineWidth',1.2);
hold on
x2=0:5:25;
plot(x2,IHarbour,'-_','LineWidth',1.2);
x3=0:2:4;
plot(x3,IHarbor(1:3),'-s','LineWidth',1.2);
xlabel("Distance(m)")
ylabel("Received Intensity(dB)")
title("Intensity vs Distance(D=3mm)")
legend("pure","clean","coastal","Harbor");
grid('on')
%}
