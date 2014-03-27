clear;clc;
str_base = 'A*';
str_num = '';
str_template = 'A* = struct';
str_final = str_template;
for i=1:10
    str_num = num2str(i);
    str_final = strrep(str_template,'*',str_num);
    %str_final = strrep(str_final,'#',str_num);
    eval(str_final);
end