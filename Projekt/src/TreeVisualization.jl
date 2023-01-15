module TreeVisualization
export visualize!

using BasicDatatypes: Maybe, AbstractTree, AbstractNode, Square
using Interactive: plotPointList!, plotSquare!


function visualize!(tree::AbstractTree)

    squareList::Array{Square, 1} = []

    visualizationDFS(tree, tree.root, squareList)

    for square in squareList
        plotSquare!(square)
    end

end


function visualizationDFS(tree::AbstractTree, node::Maybe{AbstractNode}, squareList::Array{Square, 1})::Nothing

    for child in tree.traversal_function(node)
        push!(
            squareList, 
            (
                [child.x_interval[1], child.y_interval[1]],
                [child.x_interval[2], child.y_interval[1]],
                [child.x_interval[2], child.y_interval[2]],
                [child.x_interval[1], child.y_interval[2]]
            )
        )
        visualizationDFS(tree, child, squareList)
    end

    return nothing

end

end #module