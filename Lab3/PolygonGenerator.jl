module PolygonGenerator
export generateMonotonePolygon

using Random

#ϵ = 1e-12


function numbersGen(count::Int)::Channel{Float64}

    Channel{Float64}() do channel
        for _ ∈ 1:count
            put!(channel, rand(Float64, 1)[1])
        end
    end

end


function generateMonotonePolygon(count::Int, x_end::Float64)::Array{Array{Float64, 1}, 1}

    Δ::Float64 = x_end/(count-1)
    x_coords::Array{Float64, 1} = [i * Δ for i in 0:count-1]
    y_coords_positive = numbersGen(count) |> collect .|> abs
    y_coords_negative = numbersGen(count) |> collect .|> ((x -> -x) ∘ abs)

    x_coords_transformed_1 = x_coords + (numbersGen(count) |> collect .|> x -> x * Δ)
    x_coords_transformed_2 = (x_coords |> reverse) + (numbersGen(count) |> collect .|> x -> x * Δ)

    return [[ [x_coords_transformed_1[i], y_coords_positive[i]] for i in 1:count ] ; [ [x_coords_transformed_2[i], y_coords_negative[i]] for i in 1:count ]]
    
end


end
