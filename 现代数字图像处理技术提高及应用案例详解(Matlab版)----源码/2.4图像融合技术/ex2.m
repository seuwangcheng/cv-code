% I1��I2 Ϊ����ԭʼͼ��
% ������ͼ�����С���ֽ�
y1=mywavedec2(I1,dim);
y2=mywavedec2(I2,dim);
% ���ݵ�Ƶ�ں��㷨����ͼ���ں�
[r,c]=size(y1);           
% ����ȡ����Դͼ����Ӧ��С���ֽ�ϵ������ֵ����ߵ�ֵ��Ϊ�ں�ͼ��ķֽ�ϵ��

for i=1:r           
    for j=1:c
        if ( abs(y1(i,j)) >= abs(y2(i,j)) )
            y3(i,j)=y1(i,j);
        elseif ( abs(y1(i,j)) < abs(y2(i,j)) )
            y3(i,j)=y2(i,j);
        end
    end
end
