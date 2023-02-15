module Generators
export generateClusterPoints, generateUniformPoints

using BasicDatatypes: Point, PointList, Interval


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


end #module