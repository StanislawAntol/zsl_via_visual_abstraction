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

function [predictions, prob_class] = DAP(binary_predicates_train, binary_predicates_test, prob_matrix)

    [nclasses_train, nattributes] = size(binary_predicates_train);
    [nclasses_test,  nattributes] = size(binary_predicates_test);
    [num_test, nattributes] = size(prob_matrix);

    %First estimate individual priors of attributes
    if ( nclasses_train > 0 )
        pr_a=zeros(1,nattributes);
        for aid=1:nattributes
            pr_a(aid)=sum(binary_predicates_train(:,aid))/length(binary_predicates_train(:,aid));
            if pr_a(aid)==0 || pr_a(aid)==1
                pr_a(aid)=0.5;
            end
        end
    else
        pr_a=0.5*ones(1,nattributes);
    end

%     pr_a
    %Then for each one of the test data, estimate the probability of each class
    prob_class=zeros(num_test,nclasses_test);
    for im_id=1:num_test
        for class_id=1:nclasses_test
            p=0;
            for aid=1:nattributes
                if binary_predicates_test(class_id,aid)==1
                    p=p-log(pr_a(aid));
                else
                    p=p-log(1-pr_a(aid));
                end


                if binary_predicates_test(class_id,aid)==1
                    p=p+log(prob_matrix(im_id,aid));
                else
                    p=p+log(1-prob_matrix(im_id,aid));
                end
            end
            prob_class(im_id,class_id)=p;
        end
    end

    predictions=zeros(num_test,1);
    for im_id=1:num_test
        [~, predictions(im_id)] = max(prob_class(im_id,:));
    end

end
