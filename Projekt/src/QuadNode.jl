module QuadNode
export Quadnode, isLeaf, dfs, getChildren

using BasicDatatypes: Maybe, Point, PointList, Interval, indefiniteInclusion 
using Queries: Query, fitQueryToSquare


struct Quadnode

    points::PointList

    centre::Point

    x_interval::Interval
    y_interval::Interval

    first::Maybe{Quadnode}  # Convention: first is closed
    second::Maybe{Quadnode}
    third::Maybe{Quadnode}
    forth::Maybe{Quadnode}

    Quadnode(points::PointList) = new(constructQuadnode(points)...)

end


function constructQuadnode(points::PointList)::Tuple{PointList, Point, Interval, Interval, Maybe{Quadnode}, Maybe{Quadnode}, Maybe{Quadnode}, Maybe{Quadnode}}

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

    return filter(point -> (point[1] ≥ centre[1] && point[2] ≥ centre[2]), points) |> nonTrivial

end


function getSecond(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] < centre[1] && point[2] > centre[2]), points) |> nonTrivial

end


function getThird(points::PointList, centre::Point)::Maybe{PointList}

    return filter(point -> (point[1] ≤ centre[1] && point[2] ≤ centre[2]), points) |> nonTrivial

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


function dfs(node::Maybe{Quadnode}, query::Maybe{Query})::PointList

    # safe none-query handle
    if query === nothing
        return []
    end

    # base recursion case: one point satisfies constraint
    if isLeaf(node)
        return node.points
    end

    # base recursion case: all poins satisfy constraint
    if indefiniteInclusion(node.x_interval, query.x_interval) && indefiniteInclusion(node.y_interval, query.y_interval)
        return node.points
    end

    # recursive call
    return reduce(vcat, [dfs(child, fitQueryToSquare(query, child.x_interval, child.y_interval)) for child in getChildren(node)])

end

end # module
