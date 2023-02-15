module Jarvis
using Base: ident_cmp, identify_package, list_append!!
export convex_hull_jarvis

using BasicDatatypes: Point, PointList, orient
using DataStructures: MutableLinkedList


function convex_hull_jarvis(points::PointList; accuracy::Float64)::PointList

    local ⪉(x::Float64, y::Float64)::Bool = !isapprox(x, y, atol = accuracy) && x < y

    start_point::Point = minimum(identity, points)
    helper_point::Point = start_point + [-1.0, 0.0]

    hull::PointList = [helper_point, start_point]

    points_chain::MutableLinkedList{Point} = MutableLinkedList{Point}(points...)

    next_point::Point = [0.0, 0.0]
    next_index::Integer = 0

    while true


        next_point = hull[end-1]

        for (list_index::Integer, point::Point) in points_chain |> collect |> enumerate
            if orient(hull[end], next_point, point) ⪉ 0.0
                next_point = point
                next_index = list_index
            end
        end
        
        if next_point == hull[2]
            break
        end

        push!(hull, next_point)
        delete!(points_chain, next_index)

    end

    popfirst!(hull)

    return hull

end


end #module