push!(LOAD_PATH, @__DIR__)

using Plots
using PyCall
using PolygonGenerator
using PlotPreprocess
using GeometricPredicates
using PointClassification
using BasicDatatypes
using PolygonTriangulation


function readFromFile(filename::String)::Maybe{PointList}

    local convert = str::String -> parse.(Float64, split(str, [',', '(', ')']))

    point_list::PointList = PointList()

    try

        open(filename) do file  
            while !eof(file)
                push!(point_list, convert(f))
            end
        end

        return point_list

    catch ArgumentError
        println("Load error: ", filename)
        return nothing
    end

end


function main(n::Int = 10, explicit_polygon::Maybe{PointList}=nothing; readfrom::Maybe{String}=nothing, click::Bool=false, display_plot::Bool=false, animate::Bool=false, tofile::Maybe{String}=nothing, display_classification::Bool=false, display_chains::Bool=false)

    polygon::PointList = PointList()

    # Initialize polygon from file / via interactive canvas / random
    if explicit_polygon === nothing

        if click
            pushfirst!(PyVector(pyimport("sys")."path"), "")
            pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
            interface = pyimport("InteractivePlot")
            polygon = map(x -> [x[1], x[2]], interface.runCanvas())
            
        elseif readfrom !== nothing
            polygon = readFromFile(readfrom)
            
            if polygon === nothing
                println("No polygon!")
                return nothing
            end
        
        else
            polygon = generateMonotonePolygon(n, Float64(n^2))        
        end
    
    else
        polygon = explicit_polygon
    end

    # Initialize a very special structure:
    special_set::CyclicLinkedHashSet = CyclicLinkedHashSet(polygon)

    # Classify points to check if polygon is monotone:
    (starting::PointList, closing::PointList, connective::PointList, separative::PointList, correct::PointList) = classifyPoints(polygon, special_set)

    # Detect chains:
    (upper::PointList, lower::PointList) = filterChains(polygon, special_set)

    # Proceed with triangulation:
    start_time::Float64 = time()

    diagonals::Array{Tuple{Point, Point}, 1} = triangulatePolygon(polygon, upper, lower, special_set)

    println(round(time() - start_time, digits=5), " s")

    # Display results:
    if  display_plot

        plot(size=(500, 500)) |> display
        plot!(plotPreprocess(polygon, edge=true), label = "Edges", seriescolor = :black) |> display
        plot!(plotPreprocess(polygon, edge=false), label = "Vertices", seriestype = :scatter, seriescolor = :orange) |> display

        if display_chains
            plot!(plotPreprocess(lower, edge=false), seriestype = :scatter, label="Upper Chain") |> display
            plot!(plotPreprocess(upper, edge=false), seriestype = :scatter, label="Lower Chain") |> display
        end

        if display_classification
            plot!(plotPreprocess(starting, edge=false), label = "Starting", seriestype = :scatter, seriescolor = :black) |> display
            plot!(plotPreprocess(closing, edge=false), label = "Closing", seriestype = :scatter, seriescolor = :red) |> display
            plot!(plotPreprocess(connective, edge=false), label = "Connective", seriestype = :scatter) |> display
            plot!(plotPreprocess(separative, edge=false), label = "Separative", seriestype = :scatter) |> display
            plot!(plotPreprocess(correct, edge=false), label = "Correct", seriestype = :scatter, seriescolor = :blue) |> display
        end

        
        if length(diagonals) > 0
            for diagonal ∈ diagonals
                plotDiagonal!(diagonal) |> display
                
                if animate
                    sleep(0.5)
                end
            end
        end
        

        if tofile !== nothing
            savefig(join([tofile, ".png"]))
        end

    end
    
end


hardcase1 = [[10.0, 20.0], [20.0, 50.0], [25.0, 30.0], [35.0, 70.0], [45.0, 15.0], [50.0, 45.0], [60.0, 5.0]]  # Tzw. łapka

# Przykłady wywołania:

# Losowy wielokąt:
"""
main(
    10,
    readfrom=nothing,
    click=false,
    display_plot=true,
    animate=false,
    display_classification=false,
    display_chains=false
)
"""

# Wielokąt zadany interaktywnie, z wizualizacją podziału na łańcuchy:
"""
main(
    readfrom=nothing,
    click=true,
    display_plot=true,
    animate=false,
    display_classification=false,
    display_chains=true
)
"""

# Wywołanie dla wielokąta "hardcase1":
main(
    10,
    #hardcase1,
    readfrom=nothing,
    click=true,
    display_plot=true,
    animate=false,
    display_classification=false,
    display_chains=false,
)


