push!(LOAD_PATH, @__DIR__)

using Plots
using PolygonGenerator
using PlotPreprocess


function main(n::Int = 10)

    polygon::Array{Array{Float64, 1}, 1} = generateMonotonePolygon(n, Float64(n^2))

    plot(plotPreprocess(polygon, edge=true), label = "Edges")
    plot!(plotPreprocess(polygon, edge=false), label = "Vertices", seriestype = :scatter)

end


main()