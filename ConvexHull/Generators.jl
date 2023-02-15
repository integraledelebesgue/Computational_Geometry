module Generators
export simple_set, span_set, ellipsoidal_set

using BasicDatatypes: Point, PointList


function simple_set(count::Integer, x_lim::Tuple{Float64, Float64}, y_lim::Tuple{Float64, Float64})::PointList

    local scaling = x::Point -> x .* [x_lim[2] - x_lim[1], y_lim[2] - y_lim[1]]
    local shift = x::Point -> x + [x_lim[1], y_lim[1]]

    return [rand(2) for _ in 1:count] .|> scaling .|> shift

end


function span_set(counts::NTuple{N, Integer}, basis::NTuple{N, Point}, starts::NTuple{N, Point}, lims::NTuple{N, Tuple{Float64, Float64}})::PointList where {N}

    function span(count::Integer, vector::Point, start::Point, lim::Tuple{Float64, Float64})::PointList

        return (rand(count) .* (lim[2] - lim[1]) .+ lim[1]) .|> (param::Float64 -> start + param * vector)  
    
    end
    

    return reduce(
        vcat,
        [span(counts[i], basis[i], starts[i], lims[i]) for i in eachindex(counts)]
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


end #module