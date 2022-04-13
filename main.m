function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 20-May-2021 02:11:20

% Begin initialization code - DO NOT EDIT
% guide('main.fig') %untuk mengatur tampilan dalam GUI
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function txttest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bttest.
function bttest_Callback(hObject, eventdata, handles)
% hObject    handle to bttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tempat gambar agar kosong
cla(handles.bimg,'reset');
set(handles.bimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.rimg,'reset');
set(handles.rimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.gimg,'reset')
set(handles.gimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.bimg,'reset');
set(handles.bimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
set(handles.txtkelas, 'String', 'KELAS = ');

set(handles.txtred, 'String', 'RED = ');
set(handles.txtgreen, 'String', 'GREEN = ');
set(handles.txtblue, 'String', 'BLUE = ');

% mencari dan membaca file gambar
[tes_img tes_path] = uigetfile({'*.jpg'; '*.png'; '*.bmp'; '*.tif'}, 'Pilih file testing');
set(handles.txttest, 'String', tes_path);
im_tes = imread([tes_path tes_img]);

% menampilkan gambar
set(handles.inp,'HandleVisibility', 'ON');
axes(handles.inp);
imshow(im_tes);
handles.im_tes = im_tes;
set(handles.btproses, 'Enable', 'On');
guidata(hObject,handles);


% --- Executes on button press in btproses.
function btproses_Callback(hObject, eventdata, handles)
% hObject    handle to btproses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tempat gambar agar kosong
cla(handles.rimg,'reset');
set(handles.rimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.gimg,'reset')
set(handles.gimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.bimg,'reset');
set(handles.bimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');

set(handles.txtred, 'String', 'RED = ');
set(handles.txtgreen, 'String', 'GREEN = ');
set(handles.txtblue, 'String', 'BLUE = ');

% melakukan segmentasi dan ekstraksi fitur
im_tes = handles.im_tes;   
[imbw, imobj, test_features] = segment_feature(im_tes);
assignin('base', 'fitur_test', test_features);

% menampilkan hasil segmentasi
set(handles.bwimg,'HandleVisibility', 'ON');
axes(handles.bwimg);
imshow(imbw);

set(handles.objimg,'HandleVisibility', 'ON');
axes(handles.objimg);
imshow(imobj);

% menampilkan channel red dan nilai rata-ratanya
set(handles.rimg,'HandleVisibility', 'ON');
axes(handles.rimg);
imshow(imobj(:,:,1));
set(handles.txtred, 'String', ['RED = ' num2str(test_features(1,1))]);

% menampilkan channel green dan nilai rata-ratanya
set(handles.gimg,'HandleVisibility', 'ON');
axes(handles.gimg);
imshow(imobj(:,:,2));
set(handles.txtgreen, 'String', ['GREEN = ' num2str(test_features(1,2))]);

% menampilkan channel blue dan nilai rata-ratanya
set(handles.bimg,'HandleVisibility', 'ON');
axes(handles.bimg);
imshow(imobj(:,:,3));
set(handles.txtblue, 'String', ['BLUE = ' num2str(test_features(1,3))]);


% melakukan pemrosesan data training
traindir = handles.traindir;
balllist = dir(traindir);          % mendapatkan daftar isi folder training
balllist(1) = [];                  % menghapus dua isi pertama '.' dan '..'
balllist(1) = [];
balllist = {balllist.name}';      % mendapatkan nama folder yang berada dalam folder training

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
        [imbw, imobj, features] = segment_feature(iminput);

        train_data = [train_data; {train_kelas}, imgname, features(1,1), features(1,2), features(1,3)];
    end
end

xlswrite('train_features.xlsx', train_data, 1, 'A1');       % Menyimpan fitur ke file excel

% melakukan klasifikasi
% Membaca file excel berisi fitur dan mengelompokkannya menjadi fitur dan label
[num, raw] = xlsread('train_features.xlsx');
trainX = num(:,:);
trainY = raw(:,1);
% Mengambil fitur dari data testing
testX = test_features;

categories = {'Basket';'Sepak';'Voli'};
numClasses = size(categories,1);


% 5.1. Membuat model dari data training
for i=1:numClasses
	G1vAll=(strcmp(trainY,categories(i)));
	models(i) = svmtrain(trainX, G1vAll, 'kernel_function', 'linear');
end

% 5.2. Melakukan klasifikasi terhadap data testing
for i=1:numClasses
    if(svmclassify(models(i),testX)) 
        break;
    end
end
result = cell2mat(categories(i));

set(handles.txtkelas, 'String', ['KELAS = ' result]);
assignin('base', 'test_result', result);

% --- Executes when user attempts to close main.
function main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure

% menutup form Testing dan menampilkan form Main
delete(hObject);



function txttrain_Callback(hObject, eventdata, handles)
% hObject    handle to txttrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txttrain as text
%        str2double(get(hObject,'String')) returns contents of txttrain as a double


% --- Executes during object creation, after setting all properties.
function txttrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txttrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bttrain.
function bttrain_Callback(hObject, eventdata, handles)
% hObject    handle to bttrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tempat gambar agar kosong
cla(handles.inp,'reset');
set(handles.inp,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');

cla(handles.rimg,'reset');
set(handles.rimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.gimg,'reset')
set(handles.gimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.bimg,'reset');
set(handles.bimg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
set(handles.txtkelas, 'String', 'KELAS = ');

set(handles.txtred, 'String', 'RED = ');
set(handles.txtgreen, 'String', 'GREEN = ');
set(handles.txtblue, 'String', 'BLUE = ');

% mencari folder training
train_path = uigetdir();
set(handles.txttrain, 'String', train_path);
set(handles.bttest, 'Enable', 'On');
handles.traindir = train_path;
guidata(hObject,handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function txttest_Callback(hObject, eventdata, handles)
% hObject    handle to txttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txttest as text
%        str2double(get(hObject,'String')) returns contents of txttest as a double


% --- Executes during object creation, after setting all properties.
function text10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
