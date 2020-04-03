%ex1-19
fid = fopen('data1.txt', 'w');
fprintf(fid,'%12.8f  %12.8f  %12.8f  %12.8f\n',A);
fclose(fid);
fid = fopen('data1.txt', 'r');
B=fscanf(fid,'%g  %g  %g  %g\n',[3 inf]);
fclose(fid);

