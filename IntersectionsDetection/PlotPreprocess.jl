module PlotPreprocess
export plotPreprocess, plotSegment!


using Plots
using BasicDataTypes


function plotPreprocess(points::Array{Array{Float64, 1}, 1}; edge=false)::Tuple{Array{Float64, 1}, Array{Float64, 1}}

    return (
        [point[1] for point in points] |> (edge ? x -> push!(x, points[1][1]) : identity),
        [point[2] for point in points] |> (edge ? x -> push!(x, points[1][2]) : identity)
        )

end

function plotSegment!(segment::Tuple{Point, Point})

    plot!([segment[1][1], segment[2][1]], [segment[1][2], segment[2][2]], label=nothing, seriescolor = :steelblue)

end


end # module