function mem=memProfile(tmp,unit)
tmp = struct2dataset(tmp);
mem = sum(tmp.bytes);
switch lower(unit)
    case 'gb'
        mem = double(mem)/1024/1024/1024;
    case 'mb'
        mem = double(mem)/1024/1024;
    case 'kb'
        mem = double(mem)/1024;
end



