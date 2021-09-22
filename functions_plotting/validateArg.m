function val = validateArg(p, arg, default, allowed) 

    val = default;
    if (iscell(allowed))
        if isfield(p, arg)
            val = getfield(p, arg);
            if (length(allowed) > 0)
                if (~ismember(val, allowed))
                    argstr = [];
                    for i=1:length(allowed)
                        argstr = [argstr sprintf('''%s'' ', allowed{i})];
                    end
                    error(['''' val ''' is not an allowed option for ''' ...
                           arg '''. Select one of ' argstr '.'])
                end
            end
        end
    end
end    

% Local Variables:
% matlab-indent-level: 4
% matlab-indent-function-body: t
% End:
