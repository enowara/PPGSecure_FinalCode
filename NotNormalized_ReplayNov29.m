function NotNormalized_ReplayNov29(savefolder, folderMain, folderReal, folderAttackf, folderAttackh, dLibFolder)

% no normalization
folderMain = '/media/ewa/SH/ReplayAttackDirectories/';
folderReal = 'train/real/';
folderAttackf = 'train/attack/fixed/';  % both contain photo, vid in adverse and controlled
folderAttackh = 'train/attack/hand/';
% 
% savefolder = 'Nov30NotNormReplay'; % with gaussian filtering and saving the whole raw PPG matrix
mkdir(savefolder);
load('EwaHighPass.mat')
load('EwaLowPass.mat')

mkdir(savefolder);
for f = 1:3
    if f == 1
        folderEnd = folderReal;
    end
    if f == 2
        folderEnd = folderAttackf;

    end
    if f == 3
        folderEnd = folderAttackh;
    end
    fileNameList = dir([[folderMain folderEnd] ['*' '.mov']]); %
    for i =1:length(fileNameList)
        imgCells{i} = fileNameList(i).name;  
    end
    [cs,index] = sort_nat(imgCells,'ascend');
    img_names = cs;
    
for m = 1:length(fileNameList)
    try
            vidName = img_names{m};       
            % read in the videos
            v = VideoReader([folderMain folderEnd vidName]);
            videoLength = v.Duration;
            videoRate = v.FrameRate;
            numFrame = videoLength*videoRate;
            width = v.Width;
            height = v.Height; 

            frames = read(v);
            vg = frames(:,:,2,:);
            vg = permute(vg,[1,2,4,3]);
%             firstFrame = frames(:,:,:,1);
            firstFrame = vg(:,:,1);
            figure, imshow(firstFrame)
%% face ROI
%      load(['Data/IDAP1stFrameNew/' num2str(f) 'Dlib/dLib-' vidName '.png.mat'])
     load([dLibFolder num2str(f) 'Dlib/dLib-' vidName '.png.mat'])

        firstPoints = pointsResized;
        figure, imshow(firstFrame)
        hold on
        plot(firstPoints(:,1), firstPoints(:,2), '.g', 'MarkerSize',15)

% define faceROI
 whole = [firstPoints(1:68,1), firstPoints(1:68,2)];
    % whole face - lots of missing parts
    % between eyebrows and chin
    eyebrows1 = [firstPoints(18:22,1), firstPoints(18:22,2)];
    eyebrows2 = [firstPoints(23:27,1), firstPoints(23:27,2)];
    eyebrows = [eyebrows1; eyebrows2];
    
    chin = [firstPoints(1:17,1), firstPoints(1:17,2)];
    
        eyebrowsWidth = max(eyebrows(:,1)) - min(eyebrows(:,1));
    forehead1 = [eyebrows(:,1), (eyebrows(:,2)-round(eyebrowsWidth/2))];
    forehead2 = [eyebrows(:,1), (eyebrows(:,2))];

% plot([whole_face(:,1)], [whole_face(:,2)], 'r.');

whole_face1 = [forehead1(:,1); chin(end:-1:1,1)];
whole_face2 = [forehead1(:,2); chin(end:-1:1,2)];
whole_face = [(whole_face1(:)) whole_face2];

regionMask_whole_face = roipoly(firstFrame, whole_face(:,1), whole_face(:,2));

eyes = [firstPoints(48:-1:37,1), firstPoints(48:-1:37,2)];
eyes1 = [firstPoints(37:42,1), firstPoints(37:42,2)];
eyes2 = [firstPoints(43:48,1), firstPoints(43:48,2)];

[valeye1, indeye1]= max(eyes1(:,2));
[valeye3, indeye3]= min(eyes1(:,1));

[valeye2, indeye2]= max(eyes2(:,2));
[valeye4, indeye4]= max(eyes2(:,1));

shiftDown = max(eyes(:,2))- min(eyes(:,2)); % about hte width of the eye = 20

eyeROI = [[forehead2(:,1); valeye4; eyes2(indeye2,1); eyes1(indeye1,1); valeye3], ... 
    [forehead2(:,2); eyes1(indeye4,2)+shiftDown; valeye2+shiftDown; valeye1+shiftDown; eyes1(indeye3,2)+shiftDown ]];

regionMask_eyes = roipoly(firstFrame, eyeROI(:,1), eyeROI(:,2));
region_no_eyes = regionMask_whole_face - regionMask_eyes;
mouth = [firstPoints(49:60,1), firstPoints(49:60,2)];
regionMask_mouth = roipoly(firstFrame, mouth(:,1), mouth(:,2));

faceROI = region_no_eyes - regionMask_mouth;
%% apply tracking and get pointsList out
smallmask =  faceROI; % regionMask_whole_face; %foreheadMasksubsampled;% faceROIsubsampled; %foreheadMask;
rr = 8; % use 2 if normalizing face ROI, else 8
pointsList = KLTtrackerMASK(vg,smallmask, rr);
%% smooth    
numFrame = size(vg,3);
Gauss_sigma = 2.5; % should be based on size of ROI?
vgSpatFilt = zeros(size(vg,1), size(vg,2), floor(numFrame)); %zeros(240, 320,floor(numFrame));  
% filter on the whole frame because the shape of ROI is changing
for g = 1:numFrame
    nextFrame = vg(:,:,g); % imresize(vg(:,:,g), [240 320]);
    spatFiltImg = imgaussfilt(nextFrame, Gauss_sigma);
%         figure, imshow(spatFiltImg)
    vgSpatFilt(:,:,g) = spatFiltImg;
end 
 %% define F, L, R
    eyebrows1 = [firstPoints(18:22,1), firstPoints(18:22,2)];
    eyebrows2 = [firstPoints(23:27,1), firstPoints(23:27,2)];
    eyebrows = [eyebrows1; eyebrows2];
    forehead2 = [eyebrows(:,1), (eyebrows(:,2))];
    %%%%%%%%%%%%%    
   foreheadGrid = find(pointsList(1,:,2) < (max(forehead2(:,2)))); 
    
Lcheekx = [whole(1:7,1); whole(37,1); whole(32,1); whole(40:42,1); whole(49,1)];
Lcheeky = [whole(1:7,2); whole(37,2); whole(32,2); whole(40:42,2); whole(49,2)]; 
LcheekBound = boundary(Lcheekx, Lcheeky);
Lcheek = [Lcheekx(LcheekBound)  Lcheeky(LcheekBound)];
[inL,onL] = inpolygon(pointsList(1,:,1),pointsList(1,:,2),Lcheek(:,1),Lcheek(:,2));

Rcheekx = [whole(11:17,1); whole(43,1); whole(36,1); whole(46:48,1); whole(55,1)];
Rcheeky = [whole(11:17,2); whole(43,2); whole(36,2); whole(46:48,2); whole(55,2)]; 
RcheekBound = boundary(Rcheekx, Rcheeky);
Rcheek = [Rcheekx(RcheekBound)  Rcheeky(RcheekBound)];
[inR,onR] = inpolygon(pointsList(1,:,1),pointsList(1,:,2),Rcheek(:,1),Rcheek(:,2));
%% define grid points for each frame
gridPointsF = pointsList(:,foreheadGrid,:);
gridPointsL = cat(3, pointsList(:,inL,1), pointsList(:,inL,2));
gridPointsR = cat(3, pointsList(:,inR,1), pointsList(:,inR,2));

figure, imshow(firstFrame)
hold on
plot(gridPointsF(1,:,1), gridPointsF(1,:,2), '.g', 'MarkerSize',15)
%% get PPG
nn = 10; 
[PPGrawF] = getPPG(vgSpatFilt, gridPointsF, nn); %     PPGraw - no mean subtraction or temporal filtering
[PPGrawL] = getPPG(vgSpatFilt, gridPointsL, nn);
[PPGrawR] = getPPG(vgSpatFilt, gridPointsR, nn);
[PPGraw_whole] = getPPG(vgSpatFilt, pointsList, nn); % not averaged, without mean sub.
PPGrawF = double(PPGrawF);
PPGrawL = double(PPGrawL);
PPGrawR = double(PPGrawR);
%% FFT
% subtract mean
clear PPGF
for c = 1:size(PPGrawF,2)
    PPGF(:,c) = PPGrawF(:,c) - mean(PPGrawF(:,c));
end
clear PPGR
for c = 1:size(PPGrawR,2)
    PPGR(:,c) = PPGrawR(:,c) - mean(PPGrawR(:,c));
end
clear PPGL
for c = 1:size(PPGrawL,2)
    PPGL(:,c) = PPGrawL(:,c) - mean(PPGrawL(:,c));
end

%% bandpass filter
clear PPGraw2 
clear PPGFfilt
for c = 1:size(gridPointsF,2)
        PPGraw1 = PPGF(:,c);  % with mean subtracted
        PPGraw2(:,c) = PPGraw1;
           PPG2filt0 =  PPGraw2(:,c);
            PPG2filt1 = filtfilt(b, 1, PPG2filt0); %low pass
           PPG2filt2 = filtfilt(b_i, a_i, PPG2filt1); % high pass
%            PPG2filt1 = filtfilt(lowpass_5,1,PPG2filt0);  %low pass
%            PPG2filt2 = filtfilt(highpass_05,IIR_part,PPG2filt1); % high pass
           PPGFfilt(:,c) = PPG2filt2;
end
clear PPGraw2 
clear PPGLfilt
for c = 1:size(gridPointsL,2)
        PPGraw1 = PPGL(:,c);  % with mean subtracted
        PPGraw2(:,c) = PPGraw1;
           PPG2filt0 =  PPGraw2(:,c);
            PPG2filt1 = filtfilt(b, 1, PPG2filt0); %low pass
           PPG2filt2 = filtfilt(b_i, a_i, PPG2filt1); % high pass
%            PPG2filt1 = filtfilt(lowpass_5,1,PPG2filt0);  %low pass
%            PPG2filt2 = filtfilt(highpass_05,IIR_part,PPG2filt1); % high pass
           PPGLfilt(:,c) = PPG2filt2;
end
clear PPGraw2 
clear PPGRfilt
for c = 1:size(gridPointsR,2)
        PPGraw1 = PPGR(:,c);  % with mean subtracted
        PPGraw2(:,c) = PPGraw1;
           PPG2filt0 =  PPGraw2(:,c);
            PPG2filt1 = filtfilt(b, 1, PPG2filt0); %low pass
           PPG2filt2 = filtfilt(b_i, a_i, PPG2filt1); % high pass
%            PPG2filt1 = filtfilt(lowpass_5,1,PPG2filt0);  %low pass
%            PPG2filt2 = filtfilt(highpass_05,IIR_part,PPG2filt1); % high pass
           PPGRfilt(:,c) = PPG2filt2;
end

%% save 
save([savefolder '/' num2str(f) '-'  num2str(m) '-' 'point.mat'], 'pointsList', 'gridPointsF', 'gridPointsL', 'gridPointsR')
save([savefolder '/' num2str(f) '-'  num2str(m) '-'  'PPGraw.mat'], 'PPGraw_whole', 'PPGrawF' , 'PPGrawL', 'PPGrawR')
save([savefolder '/' num2str(f) '-'  num2str(m) '-'  'PPGfilt.mat'], 'PPGFfilt', 'PPGLfilt', 'PPGRfilt')

disp([num2str(f) '-'   num2str(m)])
    catch 
        continue
    end
    end 
end
end