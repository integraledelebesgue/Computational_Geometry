module KD_Tree
export KDTree, recursiveDFS

using BasicDatatypes
using KDTreeNode
using Queries


struct KDTree <: AbstractTree
    root::KDNode
    depth::Int
    construction_time::Float64

    KDTree(points::PointList) = new(constructKDTree(points)...)
end


function constructKDTree(points::PointList)::Tuple{KDNode, Int, Float64}

    start_time::Float64 = time()
    _root::KDNode = KDNode(points)
    end_time::Float64 = time()

    return (_root, getDepth(_root), round(end_time-start_time, digits=5))

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