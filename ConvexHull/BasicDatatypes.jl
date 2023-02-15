module BasicDatatypes
export Maybe, Point, PointList, orient

using LinearAlgebra: det

Maybe{T} = Union{T, Nothing}

Point = Array{Float64, 1}
PointList = Vector{Point}


function orient(A::Point, B::Point, C::Point)::Float64

    local toMatrix(points::PointList)::Matrix{Float64} = reduce(hcat, points)'

    return push!.(deepcopy.([A, B, C]), 1.0) |> toMatrix |> det

end


end #module