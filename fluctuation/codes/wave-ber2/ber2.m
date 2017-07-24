%%%OOK 误码率计算 P42 公式2-37 
function bb=ber2(IP,deltaf)
global Pt;
global wl;
global Ts;
%Pt=1;
%global wl;
n=0.75;
R=0.85;
A=100;%待定
e=1.6022.*10.^(-19);


%wl=800*10^-9;
a=0; Dr=0.25;  G=100;%zengyi
F=G^0.5;
%Ts=10^-8;
IB=10^-8; Idc=10^-9; Rl=50;
T=300; hp=6.6260693*10^(-34); e=1.60217733*10^(-19); Kc=1.3806505*10^(-23);
v=3*10^8/wl; 
Ib=pi*Dr^2*IB/4;%背景光功率
i=e*n.*IP./(hp*v).*abs(cos(deltaf));
%Ks=IP*Ts*n/(hp*v);
Ks=i.*Ts./e;
Kb=Ib*Ts*n/(hp*v); 
deltaT=2*Kc*T*Ts/Rl;%热噪声
m0=G*e*Kb+Idc*Ts;
delta00=G^2*F*e^2*Kb+deltaT;
m1=G*e*(Kb+Ks)+Idc*Ts;
delta11=G^2*e^2*F*(Ks+Kb)+deltaT; 

delta1=sqrt(delta11);delta0=sqrt(delta00);   %公式修改 将积分中 高斯噪声方差做开方

% gama=(m0.*delta1.^2-m1.*delta0.^2)./(delta1.^2-delta0.^2)+delta0.*delta1./(delta1.^2-delta0.^2).*...
%     sqrt((m1-m0).^2+2*(delta1.^2-delta0.^2).*log(delta1./delta0));
gama=0;

% 
% BER0_11=1./sqrt(2*pi*delta00)*exp(-(y-m0).^2/(2*delta00))./2; 
% BER0_11=1./sqrt(2*pi*delta00)*exp(-(y-m1).^2/(2*delta00))./2;
%修改公式 高斯计分 方差开方
% BER1_01=1./sqrt(2.*pi.*delta11).*exp(-(y-m1).^2./(2.*delta11))./2;
% 修改公式 高斯计分 方差开方

% BER_n1=int(BER0_11,y,gama,1000)+int(BER1_01,y,-1000,gama)
% ber=(1-0.5.*erfc((gama-m1)./sqrt(2.*delta11))).*0.5+(0.5.*erfc((gama+m0)./sqrt(2.*delta00))).*0.5
ber=(1-0.5.*erfc((gama-m1)./sqrt(2.*delta11))).*0.5+(0.5.*erfc((gama+m1)./sqrt(2.*delta11))).*0.5;
ber1=2.*ber.*(1-ber);
H=38000000; h0=100;a=0; r=0;
l=(H-h0)*sec(a);
theta=30*10^(-6); %束散角
W=l*theta/2;%接收面光班半径
alfa=1;
%能量损耗


%以下公式是按照P63 仿真得到 针对下行链路 
I_0l=alfa*Pt*Dr^2/(2*W^2); %平均接收光强
%修改之一， 后面 10^9 用于单位换算  我们发现这样能够得到更好的结果

% dr0=drl(0);
%dr0=0.0068;%正确值
dr0=0.3;
% 修改之一，该数值是由 P63 公式 3-27 计算得到  针对下行链路 确保无误 
bitrate=1e8;                                       %比特率          %考虑比特率对误码率影响
Tb=1./bitrate;
fIF=1.*10^8;%待定
fgvar=2*pi.*fIF.*Tb;
%deltaf=zeros(1,10000);
%deltaf=linspace(-100,100,10000);
fg=1./(sqrt(2*pi.*fgvar)).*exp(-deltaf.^2./(2.*fgvar));
pr=1./(sqrt(2*pi*dr0))./(IP) .* ...
   exp(-(log(IP/I_0l)+2*r^2/(W^2)+dr0/2).^2./(2*dr0));%27页2-10

%bb=pr.*ber2;
bb=pr.*ber1.*fg;
%bb=pr;