module Interactive
export plotResults!, plotPointList!, commentResult!

using BasicDatatypes: Point, PointList, Maybe
using Queries: Constraint, constraintToString
using Plots: plot, plot!
using PlotPreprocess: plotPreprocess


function plotResults!(points::PointList, results_constraints::Tuple{PointList, Maybe{Constraint}}...)::Nothing

    plot(size = (500, 500)) |> display
    plotPointList!(points)
    foreach(
        result_constraint -> plotPointList!(result_constraint...), 
        results_constraints
    )

    return nothing

end


function plotPointList!(points::PointList, constraint::Maybe{Constraint} = nothing)::Nothing

    plot!(plotPreprocess(points)..., seriestype = :scatter, label = constraint !== nothing ? constraintToString(constraint) : "Point set") |> display
    return nothing

end


function commentResult!(n::Int, constraint::Maybe{Constraint}, construction_time::Float64, result_len::Int, execution_time::Float64)::Nothing

    println("--------------------------------------------")
    constraint !== nothing ? println("Constraint $(constraintToString(constraint))") : print("")
    println("For total $(n) points:")
    println("Tree construted in $(construction_time) s")
    println("Constraint satisfied by $(result_len) points")
    println("Executed in $(round(execution_time, digits = 5)) s")

    return nothing

end

end #module