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

function basicFeatures = ComputeBasicFeatures(options, partXY)

%  2 people global orientations, one orientation of angle between box centers, 2 distance
if ( options.numPeople > 1 )
    basicFeatures = zeros(options.numImgs, (options.numPeople+1)*options.numOrient+options.numPeople);
else
    basicFeatures = zeros(options.numImgs, options.numOrient);
end
avgScale = 0.0;
numScale = 0;

for i = 1:options.numImgs
    for j = 1:options.numPeople
        baseBodyIdx = mod( j, options.numPeople )+1;
        personBase = partXY{i, baseBodyIdx};
        
        mean = [struct('x', 'y'); struct('x', 'y')];
        
        if (personBase.x(options.ihead) == -1.0 || ...
                personBase.y(options.ihead) == -1.0 || ...
                personBase.x(options.ishoulderL) == -1.0 || ...
                personBase.y(options.ishoulderL) == -1.0 || ...
                personBase.x(options.ishoulderR) == -1.0 || ...
                personBase.y(options.ishoulderR) == -1.0 || ...
                personBase.x(options.ihipL) == -1.0 || ...
                personBase.y(options.ihipL) == -1.0 || ...
                personBase.x(options.ihipR) == -1.0 || ...
                personBase.y(options.ihipR) == -1.0 ...
                )
            % do nothing
            
        else
            
            mean(1+1).x = (personBase.x(options.ishoulderL) + personBase.x(options.ishoulderR) + personBase.x(options.ihipL) + personBase.x(options.ihipR)) / 4.0;
            mean(1+1).y = (personBase.y(options.ishoulderL) + personBase.y(options.ishoulderR) + personBase.y(options.ihipL) + personBase.y(options.ihipR)) / 4.0;
            
            mean(0+1).x = personBase.x(options.ihead);
            mean(0+1).y = personBase.y(options.ihead);
            
            scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
            avgScale = avgScale + scaleBody;
            numScale = numScale+1;
        end
    end
end

avgScale = avgScale/numScale;
fprintf('Average body scale = %f\n', avgScale);

for i = 1:options.numImgs
    fvec = [];
    hists = cell(options.numPeople, 1);
    dists = cell(options.numPeople, 1);
    
    for j = 1:options.numPeople
        
        baseBodyIdx = mod( j - 1, options.numPeople ) + 1; % Might need to change for other features
        personIJIdx = mod( j , options.numPeople ) + 1;
        personIJ   = partXY{i, personIJIdx};
        personBase = partXY{i, baseBodyIdx};
        
        mean = [struct('x', 'y'); struct('x', 'y')];
        scaleBody = avgScale;
        
        if ( 1 ) % Compute Orientation Features
            
            hist = -1*ones(1, options.numOrient);
            midShoulder.x = -1;
            midShoulder.y = -1;
            head.x = -1;
            head.y = -1;
            
            if (    personBase.x(options.ihead) == -1 || ...
                    personBase.y(options.ihead) == -1 || ...
                    personBase.x(options.ishoulderL) == -1 || ...
                    personBase.y(options.ishoulderL) == -1 || ...
                    personBase.x(options.ishoulderR) == -1 || ...
                    personBase.y(options.ishoulderR) == -1 )
                
                hists{j} = -1*ones(1, options.numOrient);
            else
                midShoulder.x = ( personBase.x(options.ishoulderL) + personBase.x(options.ishoulderR) ) / 2.0;
                midShoulder.y = ( personBase.y(options.ishoulderL) + personBase.y(options.ishoulderR) ) / 2.0;
                
                head.x = personBase.x(options.ihead);
                head.y = personBase.y(options.ihead);
                
                orienBody = single( single(pi) + atan2(head.y - midShoulder.y, head.x - midShoulder.x) );
                
                orienIdx = single( orienBody / single( single(2.0) * pi ) );
                orienIdx = single( orienIdx * single(options.numOrient-single(0.001)) );
                
                orienDel = single( orienIdx - single(floor(orienIdx)) );
                
                hist = zeros(1, options.numOrient);
                
                idx1 = floor(orienIdx) + 1;
                idx2 = mod(idx1, options.numOrient) + 1;
                hist( idx1 ) = single( single(1.0) - orienDel );
                hist( idx2 ) = orienDel;
                hists{j} = hist;
            end
        end
        
        if ( 1 ) % Compute Distance Feature
            
            if (    personBase.x(options.ihead) == -1.0 || ...
                    personBase.y(options.ihead) == -1.0 || ...
                    personBase.x(options.ishoulderL) == -1.0 || ...
                    personBase.y(options.ishoulderL) == -1.0 || ...
                    personBase.x(options.ishoulderR) == -1.0 || ...
                    personBase.y(options.ishoulderR) == -1.0 || ...
                    personBase.x(options.ihipL) == -1.0 || ...
                    personBase.y(options.ihipL) == -1.0 || ...
                    personBase.x(options.ihipR) == -1.0 || ...
                    personBase.y(options.ihipR) == -1.0 ...
                    )
                % do nothing
                
            else
                mean(1+1).x = (personBase.x(options.ishoulderL) + personBase.x(options.ishoulderR) + personBase.x(options.ihipL) + personBase.x(options.ihipR)) / 4.0;
                mean(1+1).y = (personBase.y(options.ishoulderL) + personBase.y(options.ishoulderR) + personBase.y(options.ihipL) + personBase.y(options.ihipR)) / 4.0;
                
                mean(0+1).x = personBase.x(options.ihead);
                mean(0+1).y = personBase.y(options.ihead);
                
                scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
            end
            
            arrayBaseX = personBase.x;
            presentPartsBaseX = (arrayBaseX ~= -1);
            arrayBaseX = arrayBaseX.*presentPartsBaseX;
            x0Base = sum(arrayBaseX)/sum(presentPartsBaseX);
            
            arrayBaseY = personBase.y;
            presentPartsBaseY = (arrayBaseY ~= -1);
            arrayBaseX = arrayBaseY.*presentPartsBaseY;
            y0Base = sum(arrayBaseY)/sum(presentPartsBaseY);
            
            arrayIJX = personIJ.x;
            presentPartsIJX = (arrayIJX ~= -1);
            arrayIJX = arrayIJX.*presentPartsIJX;
            x0IJ = sum(arrayIJX)/sum(presentPartsIJX);
            
            arrayIJY = personIJ.y;
            presentPartsIJY = (arrayIJY ~= -1);
            arrayIJX = arrayIJY.*presentPartsIJY;
            y0IJ = sum(arrayIJY)/sum(presentPartsIJY);
            
            if ( sum(presentPartsBaseX) == 0 || sum(presentPartsBaseY) == 0 || ...
                 sum(presentPartsIJX) == 0 || sum(presentPartsIJY) == 0 ) % Other person is not there???
                dists{j} = -1.0;
                hists{j} = -1*ones(1, options.numOrient);
                fprintf('Warning: Missing other person.\n');
            else
                x0 = (x0IJ-x0Base)/scaleBody;
                y0 = (y0IJ-y0Base)/scaleBody;
                
%                 denom = 0.50; % Same as Global
                denom = 1.4; % 3->1 Gaussians, so 3x bigger?
                if (options.isReal == 1)
                    denom = 0.8*denom;
                end
                dists{j} = exp(-(x0*x0 + y0*y0) / denom);
                
                
                if ( j == 1 )
                    orienRelation = single( single(pi) + atan2(y0IJ-y0Base, x0IJ-x0Base) );
                    orienIdx = single( orienRelation / single( single(2.0) * pi ) );
                    orienIdx = single( orienIdx * single(options.numOrient-single(0.001)) );
                    orienDel = single( orienIdx - single(floor(orienIdx)) );
                    
                    histRelation = zeros(1, options.numOrient);
                    
                    idx1 = floor(orienIdx) + 1;
                    idx2 = mod(idx1, options.numOrient) + 1;
                    histRelation( idx1 ) = single( single(1.0) - orienDel );
                    histRelation( idx2 ) = orienDel;
                end
                
            end
            
        end
    end
    
    if ( options.numPeople > 1 )
        for j = 1:options.numPeople
            fvec = [fvec, hists{j}];
        end
        
        fvec = [fvec, histRelation];
        
        for j = 1:options.numPeople
            fvec = [fvec, dists{j}];
        end
    else
        fvec = hists{1};
    end
    
    basicFeatures(i, :) = fvec;
end

end