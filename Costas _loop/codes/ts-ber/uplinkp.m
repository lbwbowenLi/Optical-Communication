function ber=uplinkp(bitrate)
global fai;
%global wavelength;%
%fai=pi./8;
%global fai;
%global fIF;
%tt=1;
% drw=zeros(41,100000);
% wanderw=zeros(1,41);
% angle=0:1.5:60;
% divergence_angle=(5:1.875:80).*10.^(-6);
angle =0;
wavelength=1550*10^-9;
zenith=angle.*pi./180;
H = 38.*10.^6;% satellite height
h0=100;
z = (H-100).*sec(zenith);% distance of transmition

k = 2.*pi./wavelength;% number of wave
Wo=0.1;%光斑半径!!! ; waist=0.0329,保证光斑半径大于腰斑半径
divergence_angle= 30.*10.^(-6);%linspace(5,80,21).*10.^(-6);%

%Fo = z./(1-((z.*divergence_angle./Wo).^2-(2.*z./(k.*Wo.^2)).^2).^(0.5));
Waist=2.*wavelength./(pi.*divergence_angle);%束腰半径 
f=pi*(Waist.^2)/wavelength;%共焦参数
z0=f.*(((Wo./Waist).^2-1).^0.5);%发射点距束腰距离%
Fo=z0+(f.^2)./z0;%发射口径处的曲率半径
Ao=2.*z./(k.*Wo.^2);
Oo = 1+z./Fo;
As = Ao./(Oo.^2+Ao.^2);
W=Wo+divergence_angle.*z./2;
Wmax=max(Wo)+max(divergence_angle).*(H-100).*sec(max(zenith))./2;
r=linspace(0,Wmax,100000);

%Power=0:0.1:4;                                       %平均发射功率
Power=1;
c=3.*(1e8);                                                %光速
ff=c./wavelength;                                          %光频率
yita=0.75;                                                 %量子效率
h=6.625e-34;
%bitrate=1e9;%1e9;
Ts=1./bitrate;
% Ps=(1:1:10000).*(1e-9);
Diameter=0.5;   %cheat接收口径
% Diameter=0:0.04:1.6;
alfa=1;
taoT=1;    %发射天线透过率
taoR=1;    %接收天线透过率
PT=Power*taoT;
I_0l=alfa.*PT.*(Diameter).^2./(2.*W.^2); 

 %-------------------------------光强闪烁方差-------------------------------
 upper_limit=38000000;
 lower_limit=100;
 u2_integral=0;
 for i=1:100000
     lower_a=lower_limit+(upper_limit-lower_limit).*(1./100000).*(i-1);
     upper_b=lower_a+(upper_limit-lower_limit).*(1./100000);
     step_integral_u2=(upper_b-lower_a)./5;
     M=[19 75 50 50 75 19];
     sum_u2=0;
     for j=1:6
         x=lower_a+(j-1).*step_integral_u2;
         v=21;
         A=1.7.*10.^(-14);
         Cn2=0.00594.*(v./27).^2.*(10.^(-5).*x).^10.*exp(-x./1000)+2.7.*10.^(-16).*exp(-x./1500)+A.*exp(-x./100);
         fun_u2=Cn2.*(1-(x-lower_limit)./(H-lower_limit)).^(5./3);% downlink:(x-lower_limit)./(H-lower_limit)
         sum_u2=sum_u2+(5./288).*step_integral_u2.*M(j).*fun_u2;
     end
     u2_integral=u2_integral+sum_u2;
 end
 u2=u2_integral;
 
 upper_limit=38000000;
 lower_limit=100;
 u4_integral=0;
 for i=1:100000
     lower_a=lower_limit+(upper_limit-lower_limit).*(1./100000).*(i-1);
     upper_b=lower_a+(upper_limit-lower_limit).*(1./100000);
     step_integral_u4=(upper_b-lower_a)./5;
     M=[19 75 50 50 75 19];
     sum_u4=0;
     for j=1:6
         x=lower_a+(j-1).*step_integral_u4;
         v=21;
         A=1.7.*10.^(-14);
         Cn2=0.00594.*(v./27).^2.*(10.^(-5).*x).^10.*exp(-x./1000)+2.7.*10.^(-16).*exp(-x./1500)+A.*exp(-x./100);
         Os=Oo./(Oo.^2+Ao.^2);
         Ox=1-Oo./(Oo.^2+Ao.^2);
         As=Ao./(Oo.^2+Ao.^2);
         x1=1-(x-lower_limit)./(H-lower_limit);% downlink:(x-lower_limit)./(H-lower_limit)
 %
         real_s=As.*x1;
         imaginary_s=1-Ox.*x1;
         scope_s=sqrt(real_s.^2+imaginary_s.^2);
         angle_s=atan(imaginary_s./(real_s+0.00000000001));
         complex_e=scope_s.^(5./6).*exp(i.*(5./6).*angle_s);
         real_complex_e=scope_s.^(5./6).*cos((5./6).*angle_s);
         fun_u4=Cn2.*(x1.^(5./6).*real_complex_e-As.^(5./6).*x1.^(5./3));
         %
         sum_u4=sum_u4+5./288.*step_integral_u4.*M(j).*fun_u4;
     end
     u4_integral=u4_integral+sum_u4;
 end
 u4=u4_integral;
 %
 scintillation_uplink=8.702.*k.^(7./6).*(H-lower_limit).^(5./6).*(sec(zenith)).^(11./6).*(u4'*ones(1,100000)+1.667./(Wo'.^2.*(Oo'.^2+Ao'.^2)).*u2.*As'.^(5./6).*H.^2.*(sec(zenith)).^2*(r./z).^2);
 drw=scintillation_uplink;
 %
 % -------------------------------光束漂移方差-------------------------------
 integral=0;
 for i=1:100000
     lower_a=lower_limit+(upper_limit-lower_limit).*(1./100000).*(i-1);
     upper_b=lower_a+(upper_limit-lower_limit).*(1./100000);
     step_integral_u2=(upper_b-lower_a)./5;
     M=[19 75 50 50 75 19];
     sum_u2=0;
     for j=1:6
         x=lower_a+(j-1).*step_integral_u2;
         Cn2=(0.00594.*(v./27).^2.*(10.^(-5).*x).^10.*exp(-x./1000)+2.7.*10.^(-16).*exp(-x./1500)+A.*exp(-x./100));
         fun_u2=Cn2.*(z-x).^2.*(Wo+divergence_angle.*x./2).^(-(1./3));
         sum_u2=sum_u2+(5./288).*step_integral_u2.*M(j).*fun_u2;
     end
     integral=integral+sum_u2;
 end
 wanderw=integral.*2.07;
 
 %
 n=1:100:100000;
 dr0=drw(n);%dr1up;%上行光强闪烁方差
 sita=wanderw;
 IP1=linspace(0.000000000000000001,2*10^-7,1000);
 prI=zeros(1000,1000);

 for tt=1:1000
     pr=1./(sqrt(2*pi.*dr0))./(IP1(tt)).*exp(-(log(IP1(tt)/I_0l)*ones(1,1000)+2*r(n).^2./(W^2)+dr0./2).^2./(2*dr0));
     p=r(n)./sita.*exp(-r(n).^2./2./sita);
     prI(:,tt)=pr.*p;
 end
dR=Wmax/1000;
prI=sum(prI,1);
%figure,plot(IP1,prI);
d1=[0*pi,1*pi,1.5*pi];
dpsk=0;ttt=1;
for ttt=1:1:2
deltaf=linspace(d1(ttt),d1(ttt)+pi,100);
 fIF=1.*10^6;%待定
fgvar=2*pi.*fIF.*Ts;
%fai=0;
fg=1./(sqrt(2*pi.*fgvar)).*exp(-deltaf.^2./(2.*fgvar));
%%%%  BER
 
yita=0.75;     %量子效率
G=100;       %平均增益  refers to Ding's paper
F=G^0.5;    %过量噪声因子
IB=10^-9;   %背景光功率 refers to Ding's paper
Idc=10^-9;  %暗电流
Rl=50;      %负载电阻
T=300;      %有效噪声温度 
hp=6.6260693*10^(-34);   %普朗克常量 
e=1.60217733*10^(-19);   %电子电量
Kc=1.3806505*10^(-23);   %玻尔兹曼常数
ff=c/(wavelength); %光频率
%Be=4e+7;         %APD带宽
Bw=1e-8;% 10 nm the bandwith of optical filter
Ib=pi*Diameter^2*IB*Bw/4;     %进入系统的背景光
%dietav=B0;
%
Kb=yita.*Ib.*Ts/(hp.*ff);
%deltaf=0;
psk=zeros(1000,100);
for tt=1:100
    %bew=e*yita.*IP1./(hp*ff).*abs(cos(fai-deltaf(ttt)));
    %i(:,tt)=bew;
%end
%i=e*yita.*IP1./(hp*ff).*abs(cos(deltaf));
%Ks=i.*Ts./e;
Ks=yita.*IP1.*Ts./(hp.*ff);
deltaTT=2.*Kc.*T.*Ts./Rl; % thermal noise
%
%m0=(G.*e.*Kb+Idc.*Ts)*ones(1,1000);
m1=G.*e.*(Kb+Ks)+Idc.*Ts;
%delta00=((G.*e).^2.*F.*Kb+deltaTT)*ones(1,1000);
delta11=(G.*e).^2.*F.*(Kb+Ks)+deltaTT;

 delta1=sqrt(delta11);
 %delta0=sqrt(delta00);   %公式修改 将积分中 高斯噪声方差做开方
%bero=(1-0.5*erfc((-m1)./sqrt(2.*delta11)))*0.5+(0.5*erfc((m1)./sqrt(2.*delta11)))*0.5; 
%ber=2.*(bero).*(1-bero);
ber1=0.5.*erfc(m1./sqrt(2.*delta11).*cos(fai-deltaf(ttt)));
psk(:,tt)=abs(ber1);
end
bc=(max(IP1)-min(IP1))./1000;
%pr=prI;%pr(1,:)=0;
jfi=zeros(1,100);
  jfi=[prI(1)./2,prI(2:999),prI(1000)./2]*psk.*bc;
  bc=(max(deltaf)-min(deltaf))./100;
  fg2=fg';
  dpsk=dpsk+jfi*fg2.*bc;
end
ber=dpsk;
%gama=(m0.*delta1.^2-m1.*delta0.^2)./(delta1.^2-delta0.^2)+delta0.*delta1./(delta1.^2-delta0.^2).*...
  %   sqrt((m1-m0).^2+2*(delta1.^2-delta0.^2).*log(delta1./delta0));
 %gama(1)=0.0841*1.0e-05;
  %{
  bc=(max(IP1)-min(IP1))./1000;
  bero=(1-0.5*erfc((-m1)./sqrt(2.*delta11)))*0.5+(0.5*erfc((m1)./sqrt(2.*delta11)))*0.5;
  pr=prI';%pr(1,:)=0;
  ook=bero*[pr(1)./2;pr(2:999);pr(1000)./2].*bc;
  ook
 %}
 
 