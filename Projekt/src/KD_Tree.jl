module KD_Tree
export KDTree#, recursiveDFS

using BasicDatatypes: AbstractTree, PointList
using KDTreeNode: KDNode, isLeaf, getChildren, dfs
using Queries: Query


struct KDTree <: AbstractTree

    root::KDNode
    depth::Int
    construction_time::Float64

    search_function::Function

    KDTree(points::PointList, search_function::Function = recursiveDFS) = new(constructKDTree(points, search_function)...)

end


function constructKDTree(points::PointList, search_function::Function)::Tuple{KDNode, Int, Float64, Function}

    start_time::Float64 = time()
    _root::KDNode = KDNode(points)
    end_time::Float64 = time()

    return (_root, getDepth(_root), round(end_time-start_time, digits=5), search_function)

end


function getDepth(node::KDNode)::Int

    if isLeaf(node)
        return 0
    end

    return 1 + maximum(getDepth, getChildren(node))

end


function recursiveDFS(tree::KDTree, query::Query)::PointList

    return dfs(tree.root, query)

end

end #module