module QuadTree
export Quadtree

using QuadNode
using BasicDatatypes


struct Quadtree
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

    return 1 + maximum(getDepth, filter(x -> x !== nothing, [node.first, node.second, node.third, node.forth]))

end


end # module