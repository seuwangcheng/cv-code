function y=mywavedec2(x,dim)
% ���� MYWAVEDEC2() ��������� x ���� dim ��ֽ⣬�õ���Ӧ�ķֽ�ϵ������ y
% ���������x ���� �������	
%           dim ���� �ֽ������
% ���������y ���� �ֽ�ϵ������
x=modmat(x,dim);            % ���ȹ淶���������ʹ�����������ܱ� 2^dim ����
subplot(121);imshow(x);title('ԭʼͼ��');   % �����淶�����Դͼ��
[m,n]=size(x);              % ����淶������x��������
xd=double(x);               % ������x�����ݸ�ʽת��Ϊ�ʺ���ֵ�����double��ʽ
for i=1:dim
    xd=modmat(xd,1);
    [dLL,dHL,dLH,dHH]=mydwt2(xd);   % ����С���ֽ�
    tmp=[dLL,dHL;dLH,dHH];          % ���ֽ�ϵ�����뻺�����
    xd=dLL;                         % ������������Ͻǲ��ֵ��Ӿ�����Ϊ��һ��ֽ��Դ����
    [row,col]=size(tmp);            % �����������������
    y(1:row,1:col)=tmp;             % ����������������������Ӧ����
end
yd=uint8(y);            % �������������ݸ�ʽת��Ϊ�ʺ���ʾͼ���uint8��ʽ
for i=1:dim             % �Ծ��� yd ���зֽ��ߴ��������ֽ�ͼ��ķֽ���
    m=m-mod(m,2);
    n=n-mod(n,2);
    yd(m/2,1:n)=255;
    yd(1:m,n/2)=255;
    m=m/2;n=n/2;
end
subplot(122);imshow(yd);title([ num2str(dim) ' ��С���ֽ�ͼ��']); 
