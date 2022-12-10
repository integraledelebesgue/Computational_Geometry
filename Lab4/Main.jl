push!(LOAD_PATH, @__DIR__)

using Plots
using PyCall
using PlotPreprocess
using AVLTrees
using BasicDataTypes
using SweepLine


function readFromInterface()::SegmentList

    pushfirst!(PyVector(pyimport("sys")."path"), "")
    pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
    interface = pyimport("GraphicInterface")
    return map(x -> Tuple(x), sort.(map(x -> [x[1], x[2]], interface.runCanvas()), lt=lexiOrderLowerThan))

end


function main()::Nothing

    segments::SegmentList = readFromInterface()

    start_time::Float64 = time()

    intersections::Dict{Point, Tuple{Segment, Segment}} = findAllIntersections(segments)

    println("$(length(collect(keys(intersections)))) points found in $(round(time() - start_time, digits=5)) s")

    plot(size=(500, 500)) |> display
    
    for segment in segments
        plotSegment!(segment) |> display
    end

    plot!(plotPreprocess(collect(keys(intersections)), edge=false), label = "Intersections", seriestype = :scatter, seriescolor = :orange) |> display

    return nothing

end


main()
