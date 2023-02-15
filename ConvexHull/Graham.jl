module Graham
export convex_hull_graham

using BasicDatatypes: Point, PointList, orient

ϵ = 1e-09
≈(x::Float64, y::Float64)::Bool = isapprox(x, y, atol = ϵ)


function sort_by_angle(points::PointList)::PointList

    start_point::Point = minimum(identity, points)

    local norm(point::Point)::Float64 = reduce(+, point.^2) |> sqrt

    local angle_order(A::Point, B::Point)::Bool = begin
        point_orient::Float64 = orient(start_point, A, B)
        point_orient ≈ 0.0 ? (norm(A) < norm(B)) : (point_orient < 0.0)
    end

    return pushfirst!(
        sort(
            filter(point -> point != start_point, points),
            lt = angle_order
        ),
        start_point
    )
end


function convex_hull_graham(points::PointList; accuracy::Float64)::PointList
    
    n::Integer = length(points)

    global ϵ
    ϵ = accuracy

    sorted_points::PointList = sort_by_angle(points)

    stack::PointList = [sorted_points[1], sorted_points[2]]

    curr_point::Integer = 3
    tail_orient::Float64 = 0.0

    while curr_point ≤ n

        tail_orient = orient(stack[end-1], stack[end], sorted_points[curr_point])

        if tail_orient ≈ 0.0
            pop!(stack)
            push!(stack, sorted_points[curr_point])
            curr_point += 1

        elseif tail_orient < 0.0
            push!(stack, sorted_points[curr_point])
            curr_point += 1

        else
            pop!(stack)
        end

    end

    return stack
    
end


end #module