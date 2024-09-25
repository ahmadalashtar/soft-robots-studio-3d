function intersections = collisionCheck(conf)
    global op;
    intersections = 0;
    for i = 1:size(conf,1)
        if conf(i,3)==0
            nUsedLinks = i-1;
            break;
        end
    end


end

function intersect = doIntersect(startPt,endPt,obstacle)

end