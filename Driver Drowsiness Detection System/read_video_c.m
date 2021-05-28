cam = webcam();
v = VideoWriter('myFile.mp4');
v.FrameRate=3;
open(v);
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
faceDetector = vision.CascadeObjectDetector();
eyeDetector= vision.CascadeObjectDetector('EyePairBig');
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
runLoop = true;
b2=[240,320,125,125];
str = 'Please open your eyes';
while runLoop
    videoFrame = snapshot(cam);
    %videoFrame=rgb2gray(videoFrame);
    bbox = faceDetector(videoFrame);
    E=step(eyeDetector,videoFrame);
    box_color='yellow';
    try
    [word,l,r]=adv_eyes(videoFrame,bbox);
    catch ME
    end
    videoFrame=insertText(videoFrame,[0 20],l);
    videoFrame=insertText(videoFrame,[0 40],r);
    videoFrame=insertText(videoFrame,[0 60],word);
    %if (sum(sum(E))==0)
    if ~isempty(word)
    %if isempty(E)
            str = 'Please open your eyes';
            box_color='red';
            %NET.addAssembly('System.Speech');
            %obj = System.Speech.Synthesis.SpeechSynthesizer;
            %obj.Volume = 100;
            %Speak(obj, str);
    end
    s='';
    if ~isempty(bbox)
        if ((bbox(2)-b2(2))^2+(bbox(1)-b2(1))^2)^0.5>5
            s='moving';
        else
            s='';
        end
        b2=bbox;
    end
    videoFrame = insertObjectAnnotation(videoFrame, 'Rectangle', bbox,s); 
    videoFrame = insertObjectAnnotation(videoFrame, 'Rectangle', E,'eyes'); 
    videoFrame=insertText(videoFrame,[0 0] ,datestr(now,'HH:MM:SS'),'BoxColor',box_color);
    step(videoPlayer, videoFrame);
   writeVideo(v,videoFrame);
    runLoop = isOpen(videoPlayer);
    pause(.5);
end
clear cam;
close(v);
release(faceDetector);
release(eyeDetector);
release(videoPlayer);