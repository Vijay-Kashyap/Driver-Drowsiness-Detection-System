function [word,l,r]=adv_eyes(Iorg,bb)
BBold=0;
BB1old=0;
%faceDetector = vision.CascadeObjectDetector;
FDetect = vision.CascadeObjectDetector('RightEye');
F1Detect = vision.CascadeObjectDetector('LeftEye');
Iorg=rgb2gray(Iorg);
%bb = step(faceDetector, Iorg);
try
bbnorg=bb(1,:);   % change 1  if there are multiple number of faces

bbn(1)=bbnorg(1);
bbn(2)=bbnorg(2)+(bbnorg(4)/5);
bbn(4)=(1.5.*bbnorg(4))/5;
bbn(3)=(bbnorg(3))/2;

bbn1(1)=bbnorg(1)+(bbnorg(3)/2);
bbn1(2)=bbnorg(2)+(bbnorg(4)/5);
bbn1(4)=(1.5.*bbnorg(4))/5;
bbn1(3)=(bbnorg(3))/2;

I=imcrop(Iorg,bbn(1,:));
I1=imcrop(Iorg,bbn1(1,:));

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
BB1 = step(F1Detect,I1);

if(numel(BB)~=0 && numel(BB1)~=0)
    BBold=BB;
    BB1old=BB1;
else
    BB=BBold;
    BB1=BB1old;
end

left=imcrop(I,BB(1,:));
right=imcrop(I1,BB1(1,:));

left=imresize(left,[24 24]);
right=imresize(right,[24 24]);

load('svmclass');
teleft = extractHOGFeatures(left);
releft=predict(cl,teleft);
teright = extractHOGFeatures(right);
reright=predict(cl,teright);
f=reright || releft;
if(f==1)
    %word='eyes active';
    word='';
else
    word='blinking';
end
if(releft==1)
    l='Right Eye: open';
else
    l='Right Eye: closed';
end
if(reright==1)
    r='Left Eye: open';
else
    r='Leftz Eye: closed';
end
%Iorg=insertText(Iorg,[0 0],l);
%Iorg=insertText(Iorg,[0 20],r);
%Iorg=insertText(Iorg,[0 40],word);
catch ME
    l=''; r='';word='';
end
end
