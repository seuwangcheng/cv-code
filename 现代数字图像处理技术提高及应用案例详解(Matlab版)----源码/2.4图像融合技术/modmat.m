function y=modmat(x,dim)
% ���� MODMAT() ���������x���й淶����ʹ�����������ܱ� 2^dim ����
% ���������x ���� r*c ά����
%           dim ���� �����ع���ά��
% ���������y ���� rt*ct ά����mod(rt,2^dim)=0��mod(ct,2^dim)=0
[row,col]=size(x);          % �����������������row,col
rt=row - mod(row,2^dim);    % ��row,col�ֱ��ȥ����ģ 2^dim �õ�����
ct=col - mod(col,2^dim);    % ���õĲ�Ϊrt��ct�����ܱ� 2^dim ����
y=x(1:rt,1:ct);             % ������� y Ϊ������� x �� rt*ct ά�Ӿ��� 
