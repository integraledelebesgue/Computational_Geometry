using Plots: plot

PointList = Array{Array{Float64, 1}, 1}
Point = Array{Float64, 1}

function simple_point_set(count::Integer, x_lim::Tuple{Float64, Float64}, y_lim::Tuple{Float64, Float64})::PointList

    #return map(
    #    point -> [x_lim[1], y_lim[1]] + point .* [x_lim[2] - x_lim[1], y_lim[2] - y_lim[1]],
    #    [rand(2) for _ in 1:count]
    #)

    local scaling = x::Point -> x .* [x_lim[2] - x_lim[1], y_lim[2] - y_lim[1]]
    local shift = x::Point -> x + [x_lim[1], y_lim[1]]

    [rand(2) for _ in 1:count] .|> scaling .|> shift

end


function span_set(counts::NTuple{N, Integer}, basis::NTuple{N, Point}, lims::NTuple{N, Tuple{Float64, Float64}})::PointList where {N}

    function span(count::Integer, vector::Point, lim::Tuple{Float64, Float64})

        return (rand(count) .* (lim[2] - lim[1]) .+ lim[1]) .|> (param::Float64 -> param * vector)  
    
    end
    

    return reduce(
        vcat,
        [span(counts[i], basis[i], lims[i]) for i in eachindex(counts)]
    )

end


function ellipsoidal_set(count::Integer, centre::Point, x_radius::Float64, y_radius::Float64)::PointList

    local x = param::Float64 -> centre[1] + x_radius * cos(param)
    local y = param::Float64 -> centre[2] + y_radius * sin(param)

    return map(
        param::Float64 -> param .|> [x, y],
        2π * rand(count)
    )

end


# (1 000 000 points)
# (map)
# 0.446440 seconds (5.00 M allocations: 473.023 MiB, 44.09% gc time)
# (pipeline)
# 0.384174 seconds (5.00 M allocations: 473.023 MiB, 36.16% gc time)

#point_set = @time simple_point_set(1000000, (0.0, 5.0), (0.0, 5.0))
#span_set((1, 2), ([1.0, 0.0], [0.0, 1.0]), ((0.0, 1.0), (0.0, 1.0)))
s = ellipsoidal_set(100, [1.0, 1.0], 1.0, 1.0)

plot(@view(s[:]) .|> x -> x[1], @view(s[:]) .|> x -> x[2], seriestype = :scatter)