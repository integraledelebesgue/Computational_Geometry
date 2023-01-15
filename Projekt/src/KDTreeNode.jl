module KDTreeNode
export KDNode, isLeaf, dfs, getChildren

using Statistics: median
using BasicDatatypes: Maybe, Point, PointList, Interval, indefiniteInclusion, AbstractNode
using Queries: Query, fitQueryToSquare


struct KDNode <: AbstractNode

    points::PointList

    centre::Float64

    x_interval::Interval
    y_interval::Interval

    left::Maybe{KDNode}
    right::Maybe{KDNode}
    
    KDNode(points::PointList, direction::Symbol = :x) = new(constructKDNode(points, direction)...)

end


function toggleDirection(direction::Symbol)::Symbol

    if direction == :x
        return :y
    end

    return :x

end


function constructKDNode(points::PointList, direction::Symbol)::Tuple{PointList, Float64, Interval, Interval, Maybe{KDNode}, Maybe{KDNode}}

    if length(points) == 1
        return points, points[1][1], (points[1][1], points[1][1]), (points[1][2], points[1][2]), nothing, nothing
    end
    
    centre::Float64 = getCentre(points, direction)

    left::Maybe{PointList} = getLeft(points, centre, direction)
    right::Maybe{PointList} = getRight(points, centre, direction)

    return (
        points, 
        centre,
        (minimum(x -> x[1], points), maximum(x -> x[1], points)),
        (minimum(x -> x[2], points), maximum(x -> x[2], points)),
        left !== nothing ? KDNode(left, toggleDirection(direction)) : nothing,
        right !== nothing ? KDNode(right, toggleDirection(direction)) : nothing
    )

end


function getCentre(points::PointList, direction::Symbol)::Float64

    function mapToX(points::PointList)::Array{Float64, 1}
        return map(x -> x[1], points)
    end

    function mapToY(points::PointList)::Array{Float64, 1}
        return map(x -> x[2], points)
    end


    if direction == :x
        return median(mapToX(points))
    end

    return median(mapToY(points))

end


function nonTrivial(points::PointList)::Maybe{PointList}

    return length(points) > 0 ? points : nothing

end


function getLeft(points::PointList, centre::Float64, direction::Symbol)::Maybe{PointList}

    if direction == :x
        return filter(x -> x[1] ≤ centre, points) |> nonTrivial
    end

    return filter(x -> x[2] ≤ centre, points) |> nonTrivial

end


function getRight(points::PointList, centre::Float64, direction::Symbol)::Maybe{PointList}

    if direction == :x
        return filter(x -> x[1] > centre, points) |> nonTrivial
    end

    return filter(x -> x[2] > centre, points) |> nonTrivial

end


function getChildren(node::KDNode)::Array{KDNode, 1}

    return filter(x -> x !== nothing, [node.left, node.right])

end


function isLeaf(node::KDNode)::Bool

    return length(node.points) == 1

end


function dfs(node::Maybe{KDNode}, query::Maybe{Query})::PointList

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


end #module
