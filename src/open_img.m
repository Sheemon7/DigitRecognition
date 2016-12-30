fid=fopen('data\data9.txt','r'); %open the file corresponding to digit 8
for m = 1:900
    [t1,N]=fread(fid,[28 28],'uchar'); %read in the first training example and store it in a 28x28 size matrix t1
    t1 = t1';
    image(t1);
    t1 = (t1 > 0) * 255;
end

