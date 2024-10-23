function [] = ccleaner()
    global op;
    f = fields(op);
    for k = 1 numel(f)
        a.(f{k}) = [];
    end
end