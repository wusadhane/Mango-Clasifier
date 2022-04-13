function [ imbw, imobj, features ] = segment_feature( iminput )
    
    imgray = rgb2gray(iminput);
    
    % 2. SEGMENTASI (menggunakan Otsu Thresholding)
    t = graythresh(imgray);
    imbw = 1-im2bw(iminput, t);
    % figure, imshow(imbw);

    % 3. EKSTRAKSI FITUR RATA-RATA NILAI RGB
    imobj = repmat(imbw, [1,1,3]);
    imobj = imobj .* im2double(iminput);
    % figure, imshow(imobj);
    
    % 3.1. Mencari piksel objek (yang tidak berwarna hitam)
    imall = imobj(:,:,1) + imobj(:,:,2) + imobj(:,:,3); 
    idxnotzero = find(imall ~= 0);

    % 3.2. Mendapatkan matriks dari masing-masing channel RGB
    imred = imobj(:,:,1);
    imgreen = imobj(:,:,2);
    imblue = imobj(:,:,3);

    % 3.3. Mendapatkan fitur rata-rata RGB dari piksel objek (yang tidak berwarna hitam)
    fred = mean(imred(idxnotzero));
    fgreen = mean(imgreen(idxnotzero));
    fblue = mean(imblue(idxnotzero));
    
     % 3.4. segmentasi texture citra
     
    features = [fred, fgreen, fblue];
end

