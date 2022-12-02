module QueryProcessing
export executeQuery

using BasicDatatypes
using QuadTree


function executeQuery(tree::Union{Quadtree, KDTree}, x_interval::Maybe{Interval}, y_interval::Maybe{Interval})::PointList

    function treeDFS(node::AbstractNode, x_interval::Interval, y_interval::Interval)::PointList

        if isLeaf(node)
            return []
        end 

        return reduce(vcat, [treeDFS])



    end



end





end #module