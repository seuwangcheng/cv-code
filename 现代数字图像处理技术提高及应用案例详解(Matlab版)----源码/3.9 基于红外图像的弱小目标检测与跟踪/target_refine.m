function P2=target_refine(Pr,Pc,im2,r1)
% ���ܣ������һ֡ͼ���������λ�ã���һ֡��⵽�ģ����������Ƿ��������㣻
local_region1=zeros(2*r1+1,2*r1+1);
P2=zeros(1000,1000);
for i1=1:length(Pr)
   for a=Pr(i1)-r1:Pr(i1)+r1
    for b=Pc(i1)-r1:Pc(i1)+r1
        local_region1=im2(a-r1:a+r1,b-r1:b+r1);
        P2(a,b)=im2(a,b)/sum(sum(local_region1));
    end
  end
end
