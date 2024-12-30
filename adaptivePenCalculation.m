function adaptivePenCalculation(bestPopFitness)
    %Adaptive penalty method calculation
    %
    %Input:bestPopFitness, the best individual from the population
    %
    %
    %Output:None, but changes the global penalty value eas.adaptive_pen_mult


    global eas;
    eas.adaptationBeta_1 = 1.75
    eas.adaptationBeta_2 = 1.05;
    min_adaptation_value = 1;
    
    % Add current fitness to the adaptive array
    if(size(eas.adaptive_array,2) < eas.adaptive_size)
        
        eas.adaptive_array{end+1} = bestPopFitness;
        return;

    end
    % Shift elements to maintain the circular buffer
    for i = 2: length(eas.adaptive_array)
        
        eas.adaptive_array{i-1} = eas.adaptive_array{i};
    
    end

    eas.adaptive_array{end} = bestPopFitness;

    % Analyze feasibility of the population
    unfs = false; %Flag for unfeasible
    fs = false; %Flag for feasible

    for i = 1:eas.adaptive_size
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

    % Adjust penalty multiplier based on feasibility analysis
    if fs && unfs
        eas.adaptive_pen_mult = 1 * eas.adaptive_pen_mult;
    elseif fs && eas.adaptive_pen_mult > min_adaptation_value
        eas.adaptive_pen_mult = (1/eas.adaptationBeta_1) * eas.adaptive_pen_mult  ;
    elseif unfs
        eas.adaptive_pen_mult = (eas.adaptationBeta_2) * eas.adaptive_pen_mult;
    end
end