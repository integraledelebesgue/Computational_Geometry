module BasicDatatypes
export Maybe, Point, PointList, Interval

# Generic
Maybe{T} = Union{T, Nothing}

# Specialised
Point = Array{Float64, 1}
PointList = Array{Point, 1}
Interval = Tuple{Float64, Float64}
KDTree = Nothing
KDNode = Nothing
AbstractNode = Union{Quadnode, KDNode}


# Functions

function isValid(interval::Interval)::Bool

    return interval[1] < interval[2]

end


function intersectIntervals(interval_1::Interval, interval_2::Interval)::Maybe{Interval}

    if isTrivial(interval_1) && isTrivial(interval2)
        return interval_1
    end

    intersection::Interval = (max(interval_1[1], interval_2[1]), min(interval_1[2], interval_2[2]))

    if !isValid(intersection)
        return nothing
    end

    return intersection

end

end # module