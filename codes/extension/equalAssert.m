% Codes for ECCV-16 work `Deep Cascaded Bi-Network for Face Hallucination'
% Any question please contact Shizhan Zhu: zhshzhutah2@gmail.com
% Released on August 19, 2016

function equalAssert(A,B,mode,epsilon)

if ~exist('mode','var')
    mode = 0;
end;

switch mode
    case 0 % double accurate scalar input
        assert(length(A) == 1 && length(B) == 1, 'Not numerical scalar real number input!');
        assert(A==B, ['EqualAssert (mode two accurate scalars) failed!, [' num2str(A) ' | ' num2str(B) '].']);
    case 1 % double numerical scalar input
        assert(length(A) == 1 && length(B) == 1, 'Not numerical scalar real number input!');
        if ~exist('epsilon','var'), epsilon = 0.0001; end;
        assert(abs(A-B) < epsilon, ...
            ['EqualAssert (mode two numerical scalars) failed!, [' num2str(A) ' | ' num2str(B) '].']);
    case 2 % double strings input
        assert(ischar(A) && ischar(B), 'Not char input!');
        assert(strcmp(A,B), ['EqualAssert (mode two strings) failed! [' A ' | ' B '].']);
    otherwise
        error('What mode is this?');
end;

end

