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

function [nNet, predIdxsYtoX, predIdxsXtoY, isOrd1, varargout] = GRNN(options, parameters, yToX, spread, XTrain, YTrain, XTest1, YTest1, YTest2)

    if ( nargin >= 9 )
        twoInput = 1;
        if ( yToX == 1 )
            numOutputs = 2;
        else
            numOutputs = 1;
        end
    else
        twoInput = 0;
        numOutputs = 1;
    end

    if ( yToX == 0 )

        nNet = newgrnn(XTrain', YTrain', spread);
        XTest1AsY = sim(nNet, XTest1')';
        
        varargout{1} = XTest1AsY;

        if (twoInput)
            [predIdxsYtoX, predIdxsXtoY, isOrd1] = NearestNeighborMatching(XTest1AsY, YTest1, YTest2);
        else
            [predIdxsYtoX, predIdxsXtoY, isOrd1] = NearestNeighborMatching(XTest1AsY, YTest1);
        end

    else

        nNet = newgrnn(YTrain', XTrain', spread);
        YTest1AsX = sim(nNet, YTest1')';
        varargout{1} = YTest1AsX;
        
        if (twoInput)
            YTest2AsX = sim(nNet, YTest2')';
            varargout{2} = YTest2AsX;
            [predIdxsYtoX, predIdxsXtoY, isOrd1] = NearestNeighborMatching(XTest1, YTest1AsX, YTest2AsX);
        else
            [predIdxsYtoX, predIdxsXtoY, isOrd1] = NearestNeighborMatching(XTest1, YTest1AsX);
        end
    end

end