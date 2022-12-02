module QuadNode
export Quadnode, isLeaf

using BasicDatatypes


struct Quadnode

    points::PointList

    centre::Point

    x_range::Interval
    y_range::Interval

    first::Maybe{Quadnode}  # Convention: first is closed
    second::Maybe{Quadnode}
    third::Maybe{Quadnode}
    forth::Maybe{Quadnode}

    Quadnode(points::PointList) = new(constructQuadnode(points)...)

end


function constructQuadnode(points::PointList)::Tuple{PointList, Point, Tuple{Float64, Float64}, Tuple{Float64, Float64}, Maybe{Quadnode}, Maybe{Quadnode}, Maybe{Quadnode}, Maybe{Quadnode}}

    if length(points) == 1
        return (points, points[1], (points[1][1], points[1][1]), (points[1][2], points[1][2]), nothing, nothing, nothing, nothing)
    end

    centre::Point = getCentre(points)
    first::Maybe{PointList} = getFirst(points, centre)
    second::Maybe{PointList} = getSecond(points, centre)
    third::Maybe{PointList} = getThird(points, centre)
    forth::Maybe{PointList} = getForth(points, centre)

    return (
        points, 
        centre,
        (minimum(x -> x[1], points), maximum(x -> x[1], points)),
        (minimum(x -> x[2], points), maximum(x -> x[2], points)),
        first !== nothing ? Quadnode(first) : nothing, 
        second !== nothing ? Quadnode(second) : nothing, 
        third !== nothing ? Quadnode(third) : nothing, 
        forth !== nothing ? Quadnode(forth) : nothing
    )

end


function nonTrivial(points::PointList)::Maybe{PointList}

    return length(points) > 0 ? points : nothing

end


function getCentre(points::PointList)::Point

    return reduce(+, points) ./ length(points)

end


function getFirst(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] >= centre[1] && point[2] >= centre[2]), points) |> nonTrivial

end


function getSecond(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] < centre[1] && point[2] > centre[2]), points) |> nonTrivial

end


function getThird(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] < centre[1] && point[2] < centre[2]), points) |> nonTrivial

end


function getForth(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] > centre[1] && point[2] < centre[2]), points) |> nonTrivial

end


function getChildren(node::Quadnode)::Array{Maybe{Quadnode}, 1}

    return filter(x -> x !== nothing, [node.first, node.second, node.third, node.forth])

end


function isLeaf(node::Quadnode)::Bool

    return length(node.points) == 1

end


function fitToNode(x_interval::Interval, y_interval::Interval, node::Quadnode)::Tuple{Interval, Interval}

    return (intersectIntervals(x_interval, node.x_range), intersectIntervals(y_interval, node.y_range))

end


end # module
