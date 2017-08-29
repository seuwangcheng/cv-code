function [smat,mp,np] = submat(x,p,level);
% 功能：取输入矩阵中以点P为中心、阶数为（2*level+1）的方阵作为输出的子矩阵
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
% 设置子矩阵的边界值
up=m-level;    
down=m+level;
left=n-level;   
right=n+level;
% 若子矩阵的某一边界值超出输入矩阵的相应边界，就进行边界处理，
% 即超出边界后往相反方向平移，使其恰好与边界重合
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
% 获取作为输出的子矩阵，并计算点p在输出的子矩阵中的位置
smat = x(up:down,left:right);
mp=m-up+1;np=n-left+1;
