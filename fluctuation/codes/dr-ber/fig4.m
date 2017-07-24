%最终整体系统 误码率计算即仿真图像绘制
global Dr;
% global Pt
BER=zeros(1,30);

i=1;
for Dr=0.05:0.05:1.5;
    BER(i)=(quadl('bef2',0,10^-8));  %DPSK
    %BER1(i)=(quadl('report_1',0,10^-7));  %OOK
    %BER2(i)=(quadl('bef3',0,10^-7)); %QDPSK
    i=i+1;
end
P1=0.05:0.05:1.5;
% figure,

semilogy(P1,BER,'--');

xlabel('Dr/m')
ylabel('BER')