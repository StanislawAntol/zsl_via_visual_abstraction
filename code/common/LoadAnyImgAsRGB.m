%<FUNCTIONNAME> <Function description.>
%
%  [<outputs>] = <FunctionName>(<inputs>) is for <description>.
%
%  INPUT
%    -<input1>:     <input1 description>
%    -<input2>:     <input2 description>
%
%  OUTPUT
%    -<output1>:    <output2 description>
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

function img = LoadAnyImgAsRGB(path, filename)
    
    fullFilename = fullfile(path, filename);
    parts = strsplit(filename, '.');
    ext = parts{2};
    
    if ( strcmpi(ext, 'gif') == 0 ) % if not-gif
        img = imread( fullFilename );
    else % gif (possibly animated)
        try
            [img, imgMap] = imread( fullFilename, 1 ); % first frame
        catch
            [img, imgMap] = imread( fullFilename );
        end

        % Convert to RGB
        if ( ndims(img) < 3 )
            img = ind2rgb(img, imgMap);
        end
    end

    if ( ndims(img) == 2 ) % black-and-white image
        temp = [];
        temp(:, :, 1) = img;
        temp(:, :, 2) = img;
        temp(:, :, 3) = img;
        img = uint8(temp);
    end

end