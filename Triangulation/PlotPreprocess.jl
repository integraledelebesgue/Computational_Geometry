module PlotPreprocess
export plotPreprocess, plotDiagonal!


using Plots
using BasicDatatypes


function plotPreprocess(points::Array{Array{Float64, 1}, 1}; edge=false)::Tuple{Array{Float64, 1}, Array{Float64, 1}}

    return (
        [point[1] for point in points] |> (edge ? x -> push!(x, points[1][1]) : identity),
        [point[2] for point in points] |> (edge ? x -> push!(x, points[1][2]) : identity)
        )

end

function plotDiagonal!(diagonal::Tuple{Point, Point})

    plot!([diagonal[1][1], diagonal[2][1]], [diagonal[1][2], diagonal[2][2]], label=nothing, seriescolor = :steelblue)

end


end # module