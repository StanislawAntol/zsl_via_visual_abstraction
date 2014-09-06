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

function apprSents = CreateAppearenceSentences(options, p1, expr, gaze, gend)
    
    apprSents = cell(3, 1);
    
    if ( p1 ~= 0 )
        p1 = '1';
        p2 = '2';
    else
        p1 = '2';
        p2 = '1';
    end
    
    if ( gaze == 0 )
        apprSents{1} = sprintf('%s is NOT looking at %s.', p1, p2);
    elseif ( gaze == 1 )
        apprSents{1} = sprintf('%s is looking at %s.', p1, p2);
    else
       fprintf('Warning, bad gaze.\n');
       apprSents{1} = '';
    end
        
    if ( gend == 0 )
        apprSents{2} = sprintf('%s is male.', p1);
    elseif ( gend == 1 )
        apprSents{2} = sprintf('%s is female.', p1);
    else
       fprintf('Warning, bad gender.\n');
       apprSents{2} = '';
    end
    
    if ( (expr > 0) && (expr <= length(options.exprList)) )
        apprSents{3} = sprintf('%s has a %s face.', p1, options.exprNames{expr});
    else
        fprintf('Warning, bad expression.\n');
        apprSents{3} = '';
    end

end
