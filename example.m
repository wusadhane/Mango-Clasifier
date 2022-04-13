close all
clear all

traindir = 'Training';              % nama folder tempat menyimpan data training
testdir = 'Testing';                % nama folder tempat menyimpan data testing

%% TRAINING

balllist = dir(traindir);          % mendapatkan daftar isi folder training
balllist(1) = [];                  % menghapus dua isi pertama '.' dan '..'
balllist(1) = [];
balllist = {balllist.name}';      % mendapatkan nama folder yang berada dalam folder training

% Membuat folder untuk menyimpan citra training hasil segmentasi
trainimgdir = 'Train Images';
if ~exist(trainimgdir)
    mkdir(trainimgdir);
end

train_data = [];
for i=1:size(balllist,1)
    train_kelas = balllist{i};
    imglist = dir([traindir '\' train_kelas]);
    imglist(1) = [];
    imglist(1) = [];
    imglist = {imglist.name}';
    
    for j=1:size(imglist,1)
        % 1. MEMBACA CITRA INPUT UNTUK TRAINING
        imgname = imglist{j};
        iminput = imread([traindir '\' train_kelas '\' imgname]);
        imgray = rgb2gray(iminput);
        
        % 2. SEGMENTASI (menggunakan Otsu Thresholding)
        t = graythresh(imgray);
        imbw = 1-im2bw(iminput, t);
%         figure, imshow(imbw);
        
        % 3. EKSTRAKSI FITUR RATA-RATA NILAI RGB
        imobj = repmat(imbw, [1,1,3]);
        imobj = imobj .* im2double(iminput);
%         figure, imshow(imobj);
        imwrite(imobj, [trainimgdir '\' train_kelas '_' imgname]);      % menyimpan citra ke folder

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
        
        train_data = [train_data; {train_kelas}, imgname, fred, fgreen, fblue];
    end
end

xlswrite('train_features.xlsx', train_data, 1, 'A1');       % Menyimpan fitur ke file excel


%% TESTING -- Proses yang dilakukan terhadap data training dan testing harus sama

testlist = dir(testdir);          % mendapatkan daftar isi folder training
testlist(1) = [];                 % menghapus dua isi pertama '.' dan '..'
testlist(1) = [];
testlist = {testlist.name}';      % mendapatkan nama folder yang berada dalam folder training

% Membuat folder untuk menyimpan citra testing hasil segmentasi
testimgdir = 'Test Images';
if ~exist(testimgdir)
    mkdir(testimgdir);
end

test_data = [];
for i=1:size(testlist,1)
    % 1. MEMBACA CITRA INPUT UNTUK TESTING
    imgname = testlist{i};
    test_class = imgname(1:end-5);          % mendapatkan kelas dari data testing berdasarkan nama file (menghapus ekstensi file .jpg)
    iminput = imread([testdir '\' imgname]);
    imgray = rgb2gray(iminput);

    % 2. SEGMENTASI (menggunakan Otsu Thresholding)
    t = graythresh(imgray);
    imbw = 1-im2bw(iminput, t);
%     figure, imshow(imbw);

    % 3. EKSTRAKSI FITUR RATA-RATA NILAI RGB
    imobj = repmat(imbw, [1,1,3]);
    imobj = imobj .* im2double(iminput);
%     figure, imshow(imobj);
    imwrite(imobj, [testimgdir '\' imgname]);       % menyimpan citra ke folder
    
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

    test_data = [test_data; {test_class}, fred, fgreen, fblue];
end


%% 5. KLASIFIKASI (menggunakan Multiclass SVM)
% Membaca file excel berisi fitur dan mengelompokkannya menjadi fitur dan label
[num, raw] = xlsread('train_features.xlsx');
trainX = num(:,:);
trainY = raw(:,1);
% Mengambil fitur dan label dari data testing
testX = cell2mat(test_data(:,2:end));
testY = test_data(:,1);

categories = {'Basket';'Sepak';'Voli'};
result = cell(size(testY));
numClasses = size(categories,1);

% 5.1. Membuat model dari data training
for i=1:numClasses
	G1vAll=(strcmp(trainY,categories(i)));
	models(i) = svmtrain(trainX, G1vAll, 'kernel_function', 'linear');
end

% 5.2. Melakukan klasifikasi terhadap data testing
for i=1:size(testX,1)
	for j=1:numClasses
        if(svmclassify(models(j),testX(i,:))) 
            break;
        end
    end
	result(i) = categories(j);
end

% 5.3. Menghitung akurasi metode
accuracy = 0;    
for i=1:size(result,1)
    if (strcmp(result(i),testY(i)))
        accuracy = accuracy + 1;
	end
end

[gr_w gr_h] = size(testY);
accuracy = (accuracy / gr_w)*100;
disp(['Akurasi = ' num2str(accuracy) '%']);

