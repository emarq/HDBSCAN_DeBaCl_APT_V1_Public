%saving a pos file
function savepos(x,y,z,m,FileName)

fid = fopen(FileName,'W','b')
nb=length(x);

fwrite(fid,x(1),'float32');
fwrite(fid,y(1),'float32');
fwrite(fid,z(1),'float32');
fwrite(fid,m(1),'float32');

ind=2:nb;
nn=4;
fseek(fid, nn,-1);
fwrite(fid,x(ind),'float32', 12);
fseek(fid, nn+4, -1);
fwrite(fid,y(ind),'float32', 12);
fseek(fid, nn+8, -1);
fwrite(fid,z(ind),'float32', 12);

fseek(fid, nn+12, -1);
fwrite(fid,m(ind),'float32', 12);
fclose(fid);

end