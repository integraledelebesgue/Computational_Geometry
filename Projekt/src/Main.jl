push!(LOAD_PATH, @__DIR__)

using Plots: plot, plot!, savefig
using BasicDatatypes: Maybe, Point, PointList, Interval
using QuadTree: Quadtree
using KD_Tree: KDTree
using PlotPreprocess: plotPreprocess
using Queries: Constraint, constraintToString
using QueryProcessing: solveSatisfy
using DelimitedFiles: writedlm


function generateUniformPoints(n::Int, x_lim::Interval, y_lim::Interval)::PointList

    function randomPoint()::Channel{Point}

        Channel{Point}() do channel
            for _ ∈ 1:n
                put!(channel, [x_lim[1], y_lim[1]] + rand(Float64, 2) .* [x_lim[2] - x_lim[1], y_lim[2] - y_lim[1]])
            end
        end

    end

    return randomPoint() |> collect

end


function generateClusterPoints(points_per_cluster::Int, cluster_params::Tuple{Point, Float64}...)::PointList

    function randomPoint(centre::Point, deviation::Float64)::Channel{Point}

        Channel{Point}() do channel
            for _ ∈ 1:points_per_cluster
                put!(channel, centre + randn(Float64, 2) * deviation)
            end
        end

    end

    return reduce(vcat, [collect(randomPoint(centre, deviation)) for (centre, deviation) in cluster_params])

end


function plotEverything!(points::PointList, results_constraints::Tuple{PointList, Maybe{Constraint}}...)::Nothing

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


function readPointsFromFile(filename::String)::PointList

    local convert = record::String -> parse.(Float64, split(record, [',']))

    list::PointList = []

    try
        open(filename) do file
            while !eof(file)
                push!(list, convert(file))
            end
        end
        
        return list

    catch Exception  # Safety level: Data Science
        println(Exception)
        return []
    end

end


function saveToFile!(filename::String, points::PointList, constraint::Maybe{Constraint} = nothing)::Nothing

    local commentConstraint = _constraint::Maybe{Constraint} -> _constraint !== nothing ? ["Points satisfing constraint x ∈ $(_constraint.x_interval) ∧ y ∈ $(_constraint.y_interval)"] : []

    writedlm("$(filename).txt", [commentConstraint(constraint) ; points], ',')

end


function savePlotToFile!(filename::String)::Nothing

    savefig("$(filename).png")
    
    return nothing

end


function main(n::Int, x_min::Float64, x_max::Float64, y_min::Float64, y_max::Float64)

        # Generate random dataset:
    #points = generateUniformPoints(n, (x_min, x_max), (y_min, y_max))  # Points unoformly distributed on a rectangle area
    points = generateClusterPoints(n, ([0.0, 0.0], 3.0), ([5.0, -5.0], 0.5), ([0.0, -6.0], 0.25))  # Sum of normally distributed points clusters

        # Maybe read dataset from text file:
    #points = readPointsFromFile(filename)

        # Choose search strategy:
    tree = Quadtree(points)
    #tree = KDTree(points)
    
        #Declare constraints:
    constraint_1 = Constraint(2.0, 7.5, -6.5, -3.5)
    constraint_2 = Constraint(nothing, nothing, 0.0, 3.0)
    constraint_3 = Constraint(-2.5, 2.5, -7.0, -5.0)
    
        # Perform search:
    result_1, execution_time_1 = solveSatisfy(tree, constraint_1)
    result_2, execution_time_2 = solveSatisfy(tree, constraint_2)
    result_3, execution_time_3 = solveSatisfy(tree, constraint_3)

        # Maybe process asynchronously:
    #results = solveSatisfyConcurrent(tree, constraint_1, constraint_2)

        # Plot results:
    plotEverything!(points, (result_1, constraint_1), (result_2, constraint_2), (result_3, constraint_3))
    
        # Dispay detailed information:
    commentResult!(n, constraint_1, tree.construction_time, length(result_1), execution_time_1)
    commentResult!(n, constraint_2, tree.construction_time, length(result_2), execution_time_2)
    commentResult!(n, constraint_3, tree.construction_time, length(result_3), execution_time_3)
    
        # Maybe save results to file:
    #saveToFile!("lista_punktow", result_1, constraint_1)  # Add constraint annotation on top
    #saveToFile!("lista_punktow", result_1)  # Don't add constraint annotation
    
        # Maybe save plot to file:
    #savePlotToFile!("wykres")

end


main(100, 0.0, 5.0, 0.0, 5.0)
