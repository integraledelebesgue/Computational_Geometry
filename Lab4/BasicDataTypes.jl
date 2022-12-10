module BasicDataTypes
export Maybe, Point, PointList, Segment, SegmentList, newSegment, lexiOrderLowerThan, segmentsIntersect, getY, findIntersection

using LinearAlgebra: cross


Maybe{T} = Union{T, Nothing}

Point = Array{Float64, 1}
PointList = Array{Point, 1}
Segment = Tuple{Point, Point}
SegmentList = Array{Segment, 1}


function newSegment()::Segment

    return Tuple((Point(), Point()))

end


function lexiOrderLowerThan(point1::Point, point2::Point)::Bool

    return point1[1] < point2[1] || (point1[1] == point2[1] && point1[2] < point2[2])

end


function segmentsIntersect(segment1::Segment, segment2::Segment)::Bool

    function crossProd(point1::Point, point2::Point)
        return pop!(cross(push!.(deepcopy([point1, point2]), 0)...))
    end

    function direction(point1::Point, point2::Point, point3::Point)
        return crossProd(point3 - point1, point2 - point1)
    end

    function onSegment(segment::Segment, point::Point)

        min_x::Float64 = min(segment[1][1], segment[2][1])
        max_x::Float64 = max(segment[1][1], segment[2][1])
        min_y::Float64 = min(segment[1][2], segment[2][2])
        max_y::Float64 = max(segment[1][2], segment[2][2])
                
        return min_x <= point[1] <= max_x && min_y <= point[2] <= max_y

    end


    dir1::Float64 = direction(segment2..., segment1[1])
    dir2::Float64 = direction(segment2..., segment1[2])
    dir3::Float64 = direction(segment1..., segment2[1])
    dir4::Float64 = direction(segment1..., segment2[2])

    if (dir1 * dir2 < 0.0) && (dir3 * dir4 < 0.0)
        return true
    
    elseif dir1 ≈ 0.0 && onSegment(segment2, segment1[1])
        return true

    elseif dir2 ≈ 0.0 && onSegment(segment2, segment1[2])
        return true

    elseif dir3 ≈ 0.0 && onSegment(segment1, segment2[1])
        return true

    elseif dir4 ≈ 0.0 && onSegment(segment1, segment2[2])
        return true
    end

    return false

end


function getSlope(segment::Segment)::Float64

    return ((segment[2][2] - segment[1][2]) / (segment[2][1] - segment[1][1]))

end

function getIntercept(segment::Segment)::Float64

    return segment[1][2] - segment[1][1] * getSlope(segment)

end


function getY(segment::Segment, x::Float64)::Float64

    return segment[1][2] + (x - segment[1][1]) * getSlope(segment)

end


function findIntersection(segment1::Segment, segment2::Segment)::Point

    A = [getSlope.([segment1, segment2]) [-1.0, -1.0]]
    b = -getIntercept.([segment1, segment2])
   
    return A \ b

end


end #module
