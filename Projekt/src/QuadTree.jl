module QuadTree
export Quadtree

using QuadNode: Quadnode, dfs, isLeaf, getChildren
using BasicDatatypes: AbstractTree, PointList
using Queries: Query


struct Quadtree <: AbstractTree
    root::Quadnode
    depth::Int
    construction_time::Float64

    search_function::Function

    Quadtree(points::PointList, search_function::Function = recursiveDFS) = new(constructQuadTree(points, search_function)...)
end


function constructQuadTree(points::PointList, search_function::Function)::Tuple{Quadnode, Int, Float64, Function}

    start_time::Float64 = time()
    _root::Quadnode = Quadnode(points)
    end_time::Float64 = time()

    return (_root, getDepth(_root), round(end_time-start_time, digits=5), search_function)

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