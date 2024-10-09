function drawMinMax(lengthDomain,figure)
    %%Lower bound 0.1 0.2 for x
    one_int = 0.1/lengthDomain(2);
    annotation(figure,'line',[0.1 0.2],...
    [0.9 0.9],'Color', "#36bc7f" );
    annotation(figure,'textbox',[0.08 0.89 0.02 0.024 ],'String',{string(lengthDomain(2))},'FitBoxToText','on','EdgeColor','none');
    annotation(figure,'textbox',[0.205 0.89 0.02 0.024 ],'String',{'Max'},'FitBoxToText','on','EdgeColor','none');

    minLength = [0.1,0.1+one_int*lengthDomain(1)];

    annotation(figure,'line',minLength,...
    [0.85 0.85],'Color',"#be6a7f");
    annotation(figure,'textbox',[0.085 0.84 0.02 0.024 ],'String',{string(lengthDomain(1))},'FitBoxToText','on','EdgeColor','none');
    annotation(figure,'textbox',[(0.1+one_int*lengthDomain(1) + 0.005) 0.83 0.02 0.035 ],'String',{'Min'},'FitBoxToText','on','EdgeColor','none');
end