% Author: Relja Arandjelovic (relja@relja.info)

function y= relja_rootsift(x)
    if ~(isa(x,'single') || isa(x,'double'))
        x= double(x);
    end
    y= sqrt( relja_l1normalize_col(x) );
end

function Y= relja_l1normalize_col( X )
    Y= bsxfun(@rdivide, X, sum(abs(X),1) + 1e-12 );
end
