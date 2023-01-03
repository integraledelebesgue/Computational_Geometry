module QueryProcessing
export solveSatisfy

using BasicDatatypes
using QuadTree
using Queries


function solveSatisfy(tree::Quadtree, constraint::Constraint)::Tuple{PointList, Float64}

    start_time::Float64 = time()

    if constraint.relaxed
        if constraint.x_interval === nothing && constraint.y_interval === nothing
            return tree.root.points

        elseif constraint.x_interval === nothing
            return filter(
                point -> constraint.y_interval[1] ≤ point[2] && point[2] ≤ constraint.y_interval[2],
                tree.root.points
            )

        elseif constraint.y_interval === nothing
            return filter(
                point -> constraint.x_interval[1] ≤ point[1] && point[1] ≤ constraint.x_interval[2],
                tree.root.points
            )
        end
    end

    return recursiveDFS(tree, (Query(constraint.x_interval, constraint.y_interval))), time() - start_time

end





end #module