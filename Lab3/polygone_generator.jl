module polygone_generator

using Random


function points(count::Int)::Channel{Array{Float64, 1}}

    Channel{Array{Float64, 1}}() do channel
        for _ ∈ 1:count
            put!(channel, randn(Float64, 2))
        end
    end

end


function monotone_polygon(count::Int, end_x::Float64)::Array{Array{Float64, 1}, 1}

    x_coords::Array{Float64, 1} = [i * end_x/(count-1) for i in 0:count-1]

    ys = points(count) |> collect .|> x -> abs.(x) .|> x -> x .* [1.0, -1.0]

end