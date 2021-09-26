function [G, indU, labelU,fig] = marking()
%
% marking load the image and let the user to mark at most 5 regions on the
% image.
% 
% [G, indU, labelU,fig] = marking()
%
% If you use this code for your research, please cite
%
% Aletti G. , Benfenati A., Naldi G., A Semiautomatic Multi–Label Color
%   Image Segmentation Coupling Dirichlet Problem and Colour Distances,
%   Journal of Imaging, MDPI
%
% -------------------------------------------------------------------------
% OUTPUT
%
% G       : (double array) image to be segmented
% indU    : (double array) vector containing the positions of the marked
%                          regions. It refers to the vectorized version of
%                          the original image.
% labelU  : (double array) vector containing the corresponding labels.
% -------------------------------------------------------------------------
%
% Authors  : G. Aletti (giacomo.aletti@unimi.it)
%            A. Benfenati (alessandro.benfenati@unimi.it)
%            G. Naldi (giovanni.naldi@unimi.it)
%

% Create Window
fig             = uifigure;
fig.Position    = [200,200,180,350];
fig.Name        = 'Marking!';
fig.Resize      = 'off';
btnLength       = ceil(fig.Position(3)*0.8);

sprintf('Line 1\nLine 2');

% Menu for selecting the image to label: the list contains all the images
% present in the current folder. The user may write the path of a
% particular image.
LIST = getImages();
dd = uidropdown(fig,'Items',LIST,...
    'Value',LIST{1},...
    'Position',[(fig.Position(3)-btnLength)/2, 310, btnLength, 22],...
    'Editable','on');

% Loading the selected image
G      = [];
indU   = [];
labelU = [];

uibutton(fig,'push',...
    'Position',[(fig.Position(3)-btnLength)/2, 280, btnLength, 22],...
    'ButtonPushedFcn', @(btn,event) load(btn,dd),...
    'Text','Load Image');
%i = 1;

% 5 Labels are considered.
for k = 1:5
    uibutton(fig,'push',...
        'Position',[(fig.Position(3)-btnLength)/2, 255-k*25, btnLength, 22],...
        'ButtonPushedFcn', @(btn,event) label(btn),...
        'Text', sprintf('Set label %d',k));
end

uibutton(fig,'push',...
    'Position',[(fig.Position(3)-btnLength)/2, 85, btnLength, 22],...
    'ButtonPushedFcn', @(btn,event) save_cb(btn),...
    'Text','Save Mask');


uibutton(fig,'push',...
    'Position',[(fig.Position(3)-btnLength)/2, 55, btnLength, 22],...
    'ButtonPushedFcn', @(btn,event) help_cb(btn),...
    'Text','Help');

uibutton(fig,'push',...
    'Position',[(fig.Position(3)-btnLength)/2, 25, btnLength, 22],...
    'ButtonPushedFcn', @(btn,event) exit_cb(btn,fig),...
    'Text','Done');

% rectangle(fig.UIAxes, 'Position', [25,25,50,50])

end

function label(btn)
    % Setting the label and marking the region
    Cols = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250;
        0.4940    0.1840    0.5560;
        0.4660    0.6740    0.1880];

    global X Y mask i;
    i           = -(btn.Position(2)-255)/25;
    title(sprintf('Marking region nr %d',i));
    hf          = drawpolygon('FaceAlpha',0.1,'Color',Cols(i,:));
    hf.Label    = sprintf('%d',i);
    P           = hf.Position;
    [in,on]     = inpolygon(X(:),Y(:),P(:,1),P(:,2));
    mask(in|on) = i;
end

function load(btn,dd)
    % Function per caricare l'immagine selezionata nel menu a tendina
    global X Y mask ;

    try
        G = imread(dd.Value);
    catch ME
        if(strcmp(ME.identifier,'MATLAB:imagesci:imread:fileDoesNotExist'))
            error('No image found.')
        end

    end
    sg = size(G);
    imagesc(G), axis image, axis off
    [X,Y]   = meshgrid(1:sg(2),1:sg(1));
    mask    = zeros(sg(1:2));
    assignin('base','G',G);
end


function save_cb(btn)
    global mask;

    imagesc(mask);
    axis image
    axis off
    numMasks = max(mask(:));
    indTEMP = cell(1,numMasks);
    labelTEMP = cell(1,numMasks);
    for k = 1:max(mask(:))
        indTEMP{k} = find(mask==k);
        labelTEMP{k} = k*ones(numel(find(mask==k)),1);
    end
    indTEMP = cat(1,indTEMP{:});
    labelTEMP = cat(1,labelTEMP{:});

    assignin('base','indU', indTEMP);
    assignin('base','labelU', labelTEMP);
end

function exit_cb(btn,fig)
    close all;
    closereq();
end

function help_cb(btn)
    fprintf('Select one image in the current folder or write the path in the menu.\n')
    fprintf('Load the image, select which label (from 1 to 5) mark on the image.\n')
    fprintf('Multiple istances of the same label are supported. To mark a region,\n')
    fprintf('select the polygonal area with the left mouse button, to close the \n')
    fprintf('polygon click the right mouse button. To save the marked regions, click\n')
    fprintf('on the Save Mask button. Once the labelling process is finished, click\n')
    fprintf('on the Done Button.\n')
end

function list = getImages()
    % jpeg
    L = dir('*.jpeg');
    list = cell(1,length(L));
    for i = 1:length(L)
        list{i} = L(i).name;
    end
    % bmp
    L = dir('*.bmp');
    list2 = cell(1,length(L));
    for i = 1:length(L)
        list2{i} = L(i).name;
    end
    list = [list,list2];
    % jpg
    L = dir('*.jpg');
    list2 = cell(1,length(L));
    for i = 1:length(L)
        list2{i} = L(i).name;
    end
    list = [list,list2];
    % png
    L = dir('*.png');
    list2 = cell(1,length(L));
    for i = 1:length(L)
        list2{i} = L(i).name;
    end
    list = [list,list2];
end