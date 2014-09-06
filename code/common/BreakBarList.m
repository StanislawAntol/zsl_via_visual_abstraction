%BREAKBARLIST This helps process the human agreement data.
%  list = BreakBarList(str) is used to extract the data
%         from the human agreement strings.
%
%  INPUT
%    -str:          String containing a line of the human agreement data.
%
%  OUTPUT
%    -list:         User choices as array of numbers for easier parsing.
%
%  Author: Devi Parikh (parikh@vt.edu)                     Date: 2014-08-18

function list = BreakBarList(str)

    k = strfind(str,'|');
    if isempty(k)==0
        list = str2num(str);
    else
        list = [];
        for i=1:(length(k)+1)
            if i==1
                list(i) = str2num(str(1:k(i)-1));
            elseif i==(length(k)+1)
                list(i) = str2num(str(k(i-1)+1:end));
            else
                list(i) = str2num(str(k(i-1)+1:k(i)-1));
            end
        end
    end
end