function adaptivePenCalculation(bestPopFitness)
    global eas;
    eas.adaptationBeta_1 = 1.5;
    eas.adaptationBeta_2 = 1.75
    max_adaptation_value = 200;
    min_adaptation_value = 1;
    
    
    if(size(eas.adaptive_array) < 10)
        
        eas.adaptive_array{end+1} = bestPopFitness;
        return;

    end

    for i = 2: length(eas.adaptive_array)
        
        eas.adaptive_array{i-1} = eas.adaptive_array{i};
    
    end

    eas.adaptive_array{end} = bestPopFitness;    
    
    unfs = false;
    fs = false;

    for i = 1:10
        pop = eas.adaptive_array{i};
        if (unfs && fs)
            break;
        end
        
        if  0 == pop(eas.fitIdx.pen)
            fs = true;
        else
            unfs = true;
        end
    end

    if fs && unfs
        eas.adaptive_pen_mult = 1 * eas.adaptive_pen_mult;
    elseif fs && eas.adaptive_pen_mult > min_adaptation_value
        eas.adaptive_pen_mult = (1/eas.adaptationBeta_1) * eas.adaptive_pen_mult  ;
    elseif unfs
        eas.adaptive_pen_mult = (eas.adaptationBeta_2) * eas.adaptive_pen_mult;
    end
end