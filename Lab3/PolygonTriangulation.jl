module PolygonTriangulation
export triangulatePolygon


function isMonotone(polygon::Array{Array{Float64, 1}, 1})::Bool
    
    return true

end


function trinagulatePolygon(polygon::Array{Array{Float64, 1}, 1})::Union{Vector{Tuple{Float64, Float64}}, Nothing}

    if isMonotone(polygon)
        return triangulateGreedy(polygon)
    else
        # TODO: monotone decomposition
        return nothing
    end

end


function triangulateGreedy(polygon::Array{Array{Float64, 1}, 1})::Vector{Tuple{Float64, Float64}}

    local isPositive = x::Array{Float64, 1} -> x[2] > 0
    local isNegative = x::Array{Float64, 1} -> x[2] < 0

    positive_y::Array{Array{Float64, 1}, 1} = filter(isPositive, polygon) |> sort
    negative_y::Array{Array{Float64, 1}, 1} = filter(isNegative, polygon) |> sort

end
