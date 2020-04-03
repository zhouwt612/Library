%ex1-20
x=[1:10];
fid=fopen('exp.dat','w');   %
fwrite(fid,x);
fclose(fid);
fid=fopen('exp.dat','r');
status=fseek(fid,6,'bof');
x1=fread(fid,1)
position=ftell(fid)
x2=fread(fid,1)
fclose(fid);