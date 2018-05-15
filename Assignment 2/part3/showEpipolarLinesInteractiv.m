function showEpipolarLinesInteractiv(image1, image2, F0, F1, F2)
% showEpipolarLinesInteractiv - Disaplys two figures, one for each image.
% The user can select a point in first figure(image), and the corresponding
% epipolar line in the second image will be drawn in the second figure.
%
% Syntax:  showEpipolarLinesInteractiv(image1, image2, F0[, F1, F2])
%
% Inputs:
%   image1, image1 - grayscale/rbg images.
%   F0, F1, F2 - 3 by 3 Fundamental matrices. F1 and F3 are OPTIONAL

    no_matrices = 1;
    switch nargin
        case 4
            no_matrices = 2;
        case 5
            no_matrices = 3;  
    end
    

    fig1 = figure(1);
    position_figure(1, 2, 1)
    clf
    imshow(image1)

    hold on

    fig2 = figure(2);
    position_figure(1, 2, 2)
    clf
    imshow(image2)

    count = 1;
    while(1) 
        figure(1)
        [x, y , mb]=ginput(1);
        if mb==1 
            figure(2)
            hold on
            switch no_matrices
                case 1
                    drawLineInFig(F0, x, y, image2, '-');
                case 2
                    drawLineInFig(F0, x, y, image2, '-');
                    drawLineInFig(F1, x, y, image2, '-.');
                case 3
                    drawLineInFig(F0, x, y, image2, '-');
                    drawLineInFig(F1, x, y, image2, '-.');
                    drawLineInFig(F2, x, y, image2, ':');  
            end
            % optionally display points
            figure(1)
            handlesPointsInImage(:,count)=plot(x,y,'.r');
        end
        if mb==3
            ind=knnsearch(data(1:2,:)',[x,y]);
            data(:,ind)=[];
            % if points were displayed
            delete(handlesPointsInImage(:,ind));
            handlesPointsInImage(:,ind)=[];
        end
        if mb==2 % Middle mouse button exits the pick mode
            break;
        end 
        count = count +1;
    end
end


function drawLineInFig(F, x, y, image, lineStyle)
    line = F * [x;y;1];
    a = line(1);
    b = line(2);
    c = line(3);
    width = size(image,2);
    x = 0:0.01:width;
    y = (-a*x - c)/b;
    plot(x,y, lineStyle)
end