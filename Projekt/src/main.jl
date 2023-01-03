push!(LOAD_PATH, @__DIR__)

using Plots
using BasicDatatypes
using QuadTree
using PlotPreprocess
using Queries
using QueryProcessing


function generatePoints(n::Int, x_lim::Interval, y_lim::Interval)::PointList

    function randomPoint()::Channel{Point}

        Channel{Point}() do channel
            for _ ∈ 1:n
                put!(channel, [x_lim[1], y_lim[1]] + rand(Float64, 2) .* [x_lim[2] - x_lim[1], y_lim[2] - y_lim[1]])
            end
        end

    end


    return randomPoint() |> collect

end


function plotEverything(points::PointList, result::PointList, filename::Maybe{String} = nothing)::Nothing

    plot(size = (500, 500)) |> display
    plot!(plotPreprocess(points)..., seriestype = :scatter) |> display
    plot!(plotPreprocess(result)..., seriestype = :scatter) |> display

    if filename !== nothing
        savefig("$(filename).png")
    end

    return nothing

end


function commentResult(n::Int, construction_time::Float64, result_len::Int, execution_time::Float64)::Nothing

    println("--------------------------------------------")
    println("For $(n) points:")
    println("Tree construted in $(construction_time) s")
    println("Constraint satisfied by $(result_len) points")
    println("Executed in $(round(execution_time, digits = 5)) s")

    return nothing

end


function main(n::Int, x_min::Float64, x_max::Float64, y_min::Float64, y_max::Float64)

    points = generatePoints(n, (x_min, x_max), (y_min, y_max))
    
    qt = Quadtree(points)
    
    constraint_1 = Constraint(-0.2, 12.5, 1.0, 2.0)
    
    result, execution_time = solveSatisfy(qt, constraint_1)
    
    plotEverything(points, result, "obrazek")
    commentResult(n, qt.construction_time, length(result), execution_time)

end


main(10000, 0.0, 5.0, 0.0, 5.0)

