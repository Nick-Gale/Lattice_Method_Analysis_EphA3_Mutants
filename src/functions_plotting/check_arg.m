function val = check_arg(p, arg, allowed) 
    val = allowed{1};
    if isfield(p, arg)
        val = getfield(p, arg);
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