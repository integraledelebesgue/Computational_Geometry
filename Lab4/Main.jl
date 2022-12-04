push!(LOAD_PATH, @__DIR__)

using Plots
using PyCall
using PlotPreprocess
using AVLTrees
using BasicDataTypes
using SweepLine


function readFromInterface()

    pushfirst!(PyVector(pyimport("sys")."path"), "")
    pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
    interface = pyimport("GraphicInterface")
    return map(x -> Tuple(x), sort.(map(x -> [x[1], x[2]], interface.runCanvas()), lt=lexiOrderLowerThan))

end


function main()

    segments = readFromInterface()

    intersections = findAllIntersections(segments)

    plot(size=(500, 500)) |> display
    
    for segment in segments
        plotSegment!(segment) |> display
    end

    plot!(plotPreprocess(collect(keys(intersections)), edge=false), label = "Intersections", seriestype = :scatter, seriescolor = :orange) |> display

end


main()
