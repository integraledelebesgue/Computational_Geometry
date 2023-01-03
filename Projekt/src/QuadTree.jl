module QuadTree
export Quadtree, recursiveDFS

using QuadNode
using BasicDatatypes
using Queries


struct Quadtree <: AbstractTree
    root::Quadnode
    depth::Int
    construction_time::Float64

    Quadtree(points::PointList) = new(constructQuadTree(points)...)
end


function constructQuadTree(points::PointList)::Tuple{Quadnode, Int, Float64}

    start_time::Float64 = time()
    _root::Quadnode = Quadnode(points)
    end_time::Float64 = time()

    return (_root, getDepth(_root), round(end_time-start_time, digits=5))

end


function getDepth(node::Quadnode)::Int

    if isLeaf(node)
        return 0
    end

    return 1 + maximum(getDepth, getChildren(node))

end


function recursiveDFS(tree::Quadtree, query::Query)::PointList

    return dfs(tree.root, query)

end


end # module