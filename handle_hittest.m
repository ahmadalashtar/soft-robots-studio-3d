function handle_hittest(app)
    pointer = app.UIFigure.Pointer;
    if pointer == "arrow" || app.Eraser.State == "on"
        turn_children_hittest(app,"on")
    else
        turn_children_hittest(app,"off")
    end
end