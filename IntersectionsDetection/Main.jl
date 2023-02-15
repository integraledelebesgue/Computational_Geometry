push!(LOAD_PATH, @__DIR__)

using Plots
using PyCall
using JSON
using RandomSegmentGenerator
using PlotPreprocess
using AVLTrees
using BasicDataTypes
using SweepLine


function readFromInterface()::SegmentList

    pushfirst!(PyVector(pyimport("sys")."path"), "")
    pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
    interface = pyimport("GraphicInterface")
    #return map(x -> Tuple(x), sort.(map(x -> [x[1], x[2]], interface.runCanvas()), lt=lexiOrderLowerThan))

    return interface.runCanvas()

end


function readFromFile(fileName::String)::SegmentList

    local convert = line::String -> parse.(Float64, split(line, [',']))
    local group = line::Array{Float64, 1} -> ([line[1], line[2]], [line[3], line[4]])


    segmentList::SegmentList = SegmentList()

    open(fileName) do file  
        while !eof(file)
            push!(segmentList, group(convert(file)))
        end
    end

    return segmentList

end


function saveToFile(fileName::String, result::Dict{Point, Tuple{Segment, Segment}})::Nothing

    segmentData = JSON.json(result)

    open(fileName * ".json", "w") do file
        write(file, segmentData)
    end

    return nothing

end


function main(;inputMode::Symbol = :interactive, outputMode::Symbol = :plot, count::Int = 10, fileToRead::Maybe{String} = nothing, fileToWrite::Maybe{String} = nothing)::Nothing

    segments::SegmentList = []

    if inputMode == :random
        
        if count <= 0
            throw(ArgumentError("Segments count must be positive, $count was provided."))
        end

        segments = generateRandomSegments(count, [0.0, 0.0], [10.0, 10.0]) |> sortSegments

    elseif inputMode == :interactive

        segments = readFromInterface() |> sortSegments

    elseif inputMode == :file

        segments = readFromFile(fileToRead)

    else
        throw(ArgumentError("Unexpected input mode: $inputMode. Possible modes: :random, :interactive, :file."))
    end
    

    start_time::Float64 = time()

    intersections::Dict{Point, Tuple{Segment, Segment}} = findAllIntersections(segments)

    println("$(length(collect(keys(intersections)))) points found in $(round(time() - start_time, digits=5)) s")


    if outputMode == :plot
            
        plot(size=(500, 500)) |> display
        
        for segment in segments
            plotSegment!(segment) |> display
        end

        plot!(plotPreprocess(collect(keys(intersections)), edge=false), label = "Intersections", seriestype = :scatter, seriescolor = :orange) |> display

    elseif outputMode == :file
        saveToFile(fileToWrite, intersections)
    else
        throw(ArgumentError("Unexpected output mode: $outputMode. Possible modes: :plot, :file"))
    end

    return nothing

end


main(
    inputMode = :random,
    outputMode = :plot,
    count = 50
)
