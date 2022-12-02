module GeometricPredicates
export orient, checkNeighbours, triangleInPolygon

using BasicDatatypes
using LinearAlgebra: det, cross

ϵ = 0.0


function orient(A::Point, B::Point, C::Point)::Float64
    # Dodatni: C leży na lewo od AB, 
    # Ujemny: C leży na prawo od AB

    local toMatrix = point_list::PointList -> reduce(hcat, point_list)'

    return push!.(deepcopy.([A, B, C]), 1) |> toMatrix |> det

end


function checkNeighbours(A::Point, B::Point, set::CyclicLinkedHashSet)::Bool

    return A == getNext(set, B) || A == getPrevious(set, B)

end


function triangleInPolygon(A::Point, B::Point, C::Point, lower_chain::PointList)::Bool

    if B in lower_chain
        return orient(A, B, C) > ϵ
    end

    return orient(A, B, C) < -ϵ

end


end #module