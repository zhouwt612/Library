%ex1-18
fid=fopen('test.dat', 'w');
count=fwrite(fid, A, 'float');
fclose(fid);
fid=fopen('test.dat', 'r');
[B,count]=fread(fid, [3,inf],'float')
fclose(fid);

