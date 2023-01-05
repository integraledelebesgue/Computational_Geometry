module QueryProcessing
export solveSatisfy, concurrentSolve

using BasicDatatypes: AbstractTree, Interval, PointList
using QuadTree: Quadtree
using Queries: Constraint, Query
using KD_Tree: KDTree


function solveSatisfy(tree::AbstractTree, constraint::Constraint)::Tuple{PointList, Float64}

    start_time::Float64 = time()

    if constraint.relaxed
        return tree.root.points, start_time - time()
    end

    return tree.search_function(tree, Query(constraint.x_interval, constraint.y_interval)), time() - start_time

end


function concurrentSolve(tree::AbstractTree, constraints::Constraint...)::Array{Tuple{PointList, Float64}, 1}

end



end #module