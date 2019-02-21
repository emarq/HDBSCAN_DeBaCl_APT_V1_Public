%Opening the pos file

function [pos]=open_pos(file_name);
fid=fopen(file_name,'r');
fseek(fid,0,-1);
atomx=fread(fid, inf, 'float32', 12, 'b');
fseek(fid,4,-1);
atomy=fread(fid, inf, 'float32', 12, 'b');
fseek(fid,8,-1);
atomz=fread(fid, inf, 'float32', 12, 'b');
fseek(fid,12,-1);
mass=fread(fid, inf, 'float32', 12, 'b');
pos=[atomx, atomy, atomz, mass];
end