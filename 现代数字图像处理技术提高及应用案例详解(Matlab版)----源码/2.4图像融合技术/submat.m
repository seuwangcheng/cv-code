function [smat,mp,np] = submat(x,p,level);
% ���ܣ�ȡ����������Ե�PΪ���ġ�����Ϊ��2*level+1���ķ�����Ϊ������Ӿ���
[row,col]=size(x);
m=p(1); n=p(2);
if (m>row)||(n>col)
    error('Point p is out of matrix X !');
    return;
end
if ((2*level+1)>row)||((2*level+1)>col)
    error('Too large sample area level !');
    return;
end
% �����Ӿ���ı߽�ֵ
up=m-level;    
down=m+level;
left=n-level;   
right=n+level;
% ���Ӿ����ĳһ�߽�ֵ��������������Ӧ�߽磬�ͽ��б߽紦��
% �������߽�����෴����ƽ�ƣ�ʹ��ǡ����߽��غ�
if left<1
    right=right+1-left;
    left=1;
end
if right>col
    left=left+col-right;
    right=col;
end
if up<1
    down=down+1-up;
    up=1;
end
if down>row
    up=up+row-down;
    down=row;
end
% ��ȡ��Ϊ������Ӿ��󣬲������p��������Ӿ����е�λ��
smat = x(up:down,left:right);
mp=m-up+1;np=n-left+1;
