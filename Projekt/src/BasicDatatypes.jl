module BasicDatatypes
export Maybe, Point, PointList, Interval, intersectIntervals, indefiniteInclusion, AbstractTree

# Generic
Maybe{T} = Union{T, Nothing}

# Abstract
abstract type AbstractTree end

# Specialised
Point = Array{Float64, 1}
PointList = Array{Point, 1}
Interval = Tuple{Float64, Float64}
KDTree = Nothing
KDNode = Nothing


# Functions

function validateInterval(interval::Interval)::Maybe{Interval}
    return interval[1] ≤ interval[2] ? interval : nothing
end


function intersectIntervals(interval_1::Interval, interval_2::Interval)::Maybe{Interval}

    return (max(interval_1[1], interval_2[1]), min(interval_1[2], interval_2[2])) |> validateInterval

end


function indefiniteInclusion(inner_interval::Interval, outer_interval::Interval)::Bool

    return outer_interval[1] ≤ inner_interval[1] && inner_interval[2] ≤ outer_interval[2]

end


end # module