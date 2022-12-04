module BasicDataTypes
export Maybe, Point, Segment, lexiOrderLowerThan, segmentsIntersect

using LinearAlgebra: cross


Maybe{T} = Union{T, Nothing}

Point = Array{Float64, 1}
Segment = Tuple{Point, Point}


function lexiOrderLowerThan(point1, point2)

    return point1[1] < point2[1] || (point1[1] == point2[1] && point1[2] < point2[2])

end


function segmentsIntersect(segment1, segment2)::Bool

    function crossProd(point1, point2)
        return pop!(cross(push!.(deepcopy([point1, point2]), 0)...))
    end

    function direction(point1, point2, point3)
        return crossProd(point3 - point1, point2 - point1)
    end

    function onSegment(segment, point)

        min_x = min(segment[1][1], segment[2][1])
        max_x = max(segment[1][1], segment[2][1])
        min_y = min(segment[1][2], segment[2][2])
        max_y = max(segment[1][2], segment[2][2])
                
        return min_x <= point[1] <= max_x && min_y <= point[2] <= max_y

    end


    dir1 = direction(segment2..., segment1[1])
    dir2 = direction(segment2..., segment1[2])
    dir3 = direction(segment1..., segment2[1])
    dir4 = direction(segment1..., segment2[2])

    if (dir1 * dir2 < 0.0) || (dir3 * dir4 < 0.0)
        return true
    
    elseif d1 == 0.0 && onSegment(segment2, segment1[1])
        return true

    elseif d2 == 0.0 && onSegment(segment2, segment1[2])
        return true

    elseif d3 == 0.0 && onSegment(segment1, segment2[1])
        return true

    elseif d4 == 0.0 && onSegment(segment1, segment2[2])
        return true
    end

    return false

end

end
