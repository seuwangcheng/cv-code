%������ں�ͼ��1
 load bust
X1=X;
map1=map;
subplot(131);image(X1);
colormap(map1);title('ԭʼͼ��1');
axis square
%������ں�ͼ��2
  load mask
X2=X;
map2=map;
 %�ԻҶ�ֵ����100�����ؽ�����ǿ��С��100�����ؽ��м���
 for i=1:256
     for j=1:256
        if(X2(i,j)>100)
           X2(i,j)=1.2*X2(i,j);
         else
            X2(i,j)=0.5*X2(i,j);
         end
      end
   end
subplot(132)
image(X2);colormap(map2);title('ԭʼͼ��2');
axis square
%��ԭʼͼ��1����С���ֽ�
[c1,s1]=wavedec2(X1,2,'sym4');
%�Էֽ��ĵ�Ƶ���ֽ�����ǿ
sizec1=size(c1);
for I=1:sizec1(2)
       c1(I)=1.2*c1(I);
   end
%��ԭʼͼ��2���зֽ�
[c2,s2]=wavedec2(X2,2,'sym4');
%���ֽ��ĵ�Ƶ�����͸�Ƶ����������ӣ�������Ȩ��ϵ��0.5
c=c1+c2;
c=0.5*c;
s=s1+s2;
s=0.5*s;
 %����С���ع�
xx=waverec2(c,s,'sym4');
subplot(133);image(xx);title('�ں�ͼ��');
axis square
