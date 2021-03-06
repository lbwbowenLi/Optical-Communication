I1=zeros(1,16);
I2=zeros(1,16);
I3=zeros(1,16);

BER1=zeros(1,16);
BER2=zeros(1,16);
BER3=zeros(1,16);

global theta;
global Ts;
global Pt;
Pt=1;
%global Ts;
m=[(1/1)*10^-8,0.5*10^-8,(1/2.5)*10^-9];
Ts=m(1);
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I1(i)=x+y;
i=i+1;
end
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6
  BER1(i)=quadl('report_1',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%2
Ts=m(2);
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6 
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I2(i)=x+y;
i=i+1;
end
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6
  BER2(i)=quadl('report_1',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%%3
Ts=m(3);
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I3(i)=x+y;
i=i+1;
end
i=1;
for theta=20*10^-6:2*10^-6:50*10^-6
  BER3(i)=quadl('report_1',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%输出
P1=20:2:50;
%semilogy(P1,I1,'-*');

QX=semilogy(P1,I1,'-sr',P1,I2,'-pm',P1,I3,'-*b',P1,BER1,'-^r',P1,BER2,'-om',P1,BER3,'->b');
xlabel('θ(μrad)');
ylabel('BER');
set(QX,'LineWidth',2.0);  %将图中的曲线加粗，1.0表示线的粗细
%set(gca,'box','off','Ytick',[])
%legend('考虑相位起伏100M','考虑相位起伏200M','考虑相位起伏2.5G','不考虑相位起伏100M','不考虑相位起伏200M','不考虑相位起伏2.5G',3);
legend('with phase fluctuation,100M','with phase fluctuation,200M','with phase fluctuation,2.5G','without phase fluctuation,100M','without phase fluctuation,200M','without phase fluctuation,2.5G',3);

%P1=0.1:0.1:4;
%plot(P1,I);


