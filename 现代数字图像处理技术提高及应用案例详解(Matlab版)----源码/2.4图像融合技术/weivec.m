function w = weivec(x,p)
%���ܣ��������r*c���󣬼�����Ե�pΪ����ʱ�������Ķ�ӦȨֵ
% �����pԽ����Ȩֵ��Խ��Ȩֵ��ͨ���к��еĸ�˹�ֲ���Ȩ��ӵõ���
[r,c]=size(x);
p1=p(1);    p2=p(2);
sig=1;
for i=1:r
    for j=1:c
        w(i,j)=0.5*(gaussmf(i,[sig p1])+gaussmf(j,[sig p2]));
    end
end
