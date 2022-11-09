module utilities

export plotPreprocess, myDet, sortByAngle!, translatePoints, inverseTranslation

using LinearAlgebra


function plotPreprocess(points::Array{Array{Float64, 1}, 1})::Tuple{Array{Float64, 1}, Array{Float64, 1}}

    return ([p[1] for p in points], [p[2] for p in points])

end


function myDet(A::AbstractArray{Float64, 1}, B::AbstractArray{Float64, 1}, C::AbstractArray{Float64, 1})::Float64
    # Dodatni: C leży na lewo od AB, 
    # Ujemny: C leży na prawo od AB

    local toMatrix = (vector_list) -> reduce(hcat, vector_list)'

    return push!.(deepcopy.([A, B, C]), 1) |> toMatrix |> det

end


function sortByAngle!(point_list::Array{Array{Float64,1},1})::Nothing

    local distance = (x::Array{Float64, 1}, y::Array{Float64, 1}) -> sqrt(reduce(+, (x-y).^2))
    local angleKey = x::Array{Float64, 1} -> x != best ? myDet(best + [-1.0, 0.0], x, best + [1.0, 0.0]) / distance(x, best) : -Inf
    #local angleOrder = (x, y) -> myDet(best, x, y) < 0

    function angleOrder(x, y)
        if myDet(best, x, y) < 0
            return true
        elseif myDet(best, x, y) == 0
            return sqrt(reduce(+, x.^2)) <= sqrt(reduce(+, y.^2))
        end
        return false
    end

    best = [Inf, Inf]

    for point in point_list
        if point[2] < best[2]
            best = point
        elseif point[2] == best[2] && point[1] < best[1]
            best = point
        end
    end

    filter!(x -> x != best, point_list)

    sort!(point_list, lt=angleOrder)

    pushfirst!(point_list, best)

    return nothing

end


function translatePoints(point_list)

    best = [Inf, Inf]

    for point in point_list
        if point[2] < best[2]
            best = point
        elseif point[2] == best[2] && point[1] < best[1]
            best = point
        end
    end

    return [point - best for point in point_list], best

end


function inverseTranslation(hull, translation_vector)
    
    return [point + translation_vector for point in hull]

end


end