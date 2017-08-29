L=zeros(7,6);L(2:6,2:3)=1;L(5:6,4:5)=1
c=chaincode4(L)
L2=rot90(L);
c2=chaincode4(L2)
L=zeros(7,6);L(2:6,2:3)=1;L(5:6,4:5)=1
c=chaincode4(L);
lc=length(c);
c1=[c(2:lc) c(1)];
mod(c1-c,4);
L2=rot90(L);
c=chaincode4(L2);
lc=length(c);
c2=[c(2:lc) c(1)];
