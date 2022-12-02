module PolygonTriangulation
export triangulatePolygon

using BasicDatatypes
using GeometricPredicates
using PointClassification


function triangulatePolygon(polygon::PointList, upper::PointList, lower::PointList, set::CyclicLinkedHashSet)::Maybe{Array{Tuple{Point, Point}, 1}}

    local oppositeChains = (x::Point, y::Point) -> ((x ∈ upper && y ∈ lower) || (x ∈ lower && y ∈ upper))

    n::Int = length(polygon)
    points = sort(polygon)

    Stack::PointList = PointList(points[1:2])
    top::Int = 2
    point_on_stack::Point = Point()

    diagonals::Array{Tuple{Point, Point}, 1} = Array{Tuple{Point, Point}, 1}()

    for j in 3:n

        if oppositeChains(Stack[top], points[j])

            while top > 0
                point_on_stack = pop!(Stack)
                top -= 1

                if !checkNeighbours(point_on_stack, points[j], set)
                    push!(diagonals, (point_on_stack, points[j]))
                end
            end

            push!(Stack, points[j-1])
            push!(Stack, points[j])
            top += 2

        else

            first_on_stack::Point = pop!(Stack)
            top -= 1

            while top > 0 && triangleInPolygon(Stack[top], first_on_stack, points[j], lower)
                if !checkNeighbours(first_on_stack, points[j], set)
                    push!(diagonals, (first_on_stack, points[j]))
                end

                if !checkNeighbours(Stack[top], points[j], set)
                    push!(diagonals, (Stack[top], points[j]))
                end

                first_on_stack = pop!(Stack)
                top -= 1
            end

            push!(Stack, first_on_stack)
            push!(Stack, points[j])
            top += 2

        end

    end

    return diagonals

end


end #module
