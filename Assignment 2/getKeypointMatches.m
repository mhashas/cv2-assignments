function [f1, d1, f2, d2, matches, scores] = getKeypointMatches(img1, img2)
    [f1,d1] = extractSIFT(img1);
    [f2,d2] = extractSIFT(img2);

    [matches, scores] = vl_ubcmatch(d1, d2);
end