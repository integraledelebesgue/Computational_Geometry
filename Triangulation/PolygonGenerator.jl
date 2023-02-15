module PolygonGenerator
export generateMonotonePolygon

using Random: rand
using BasicDatatypes

#ϵ = 1e-12


function numbersGen(count::Int)::Channel{Float64}

    Channel{Float64}() do channel
        for _ ∈ 1:count
            put!(channel, rand(Float64, 1)[1])
        end
    end

end


function generateMonotonePolygon(count::Int, x_end::Float64)::PointList

    Δ::Float64 = x_end/(count-1)
    x_coords::Array{Float64, 1} = [i * Δ for i in 0:count-1]
    y_coords_positive = numbersGen(count) |> collect .|> ((x -> count*x) ∘ abs)
    y_coords_negative = numbersGen(count) |> collect .|> ((x -> -count*x) ∘ abs)

    x_coords_transformed_1 = (x_coords |> reverse) + (numbersGen(count) |> collect .|> x -> x * Δ/2)
    x_coords_transformed_2 = x_coords + (numbersGen(count) |> collect .|> x -> x * Δ/2)

    return [[ [x_coords_transformed_1[i], y_coords_positive[i]] for i in 1:count ] ; [ [x_coords_transformed_2[i], y_coords_negative[i]] for i in 1:count ]]
    
end


end #module
