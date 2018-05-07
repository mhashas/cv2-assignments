function [T] = getNormalisingT(points)
    xList = points(1,:);
    yList = points(2,:);
    mx = mean(xList, 2);

    my = mean(yList, 2);

    d = mean(sqrt((xList - mx).^2 + (yList - my).^2), 2);

    T = [sqrt(2)/d 0 -(mx*sqrt(2))/d ; 0 sqrt(2)/d -(my*sqrt(2))/d ; 0 0 1];
end