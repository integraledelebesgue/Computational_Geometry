module RandomSegmentGenerator
export generateRandomSegments

using BasicDataTypes

function randomPoints(pointsCount::Int, xLim::Float64, yLim::Float64)::Channel{Point}

    Channel{Point}() do channel
        for _ ∈ 1:pointsCount
            put!(channel, [xLim, yLim] .* rand(Float64, 2))
        end
    end

end


function generateRandomSegments(segmentCount::Int, lowerLeft::Point, upperRight::Point)::SegmentList

    starts::PointList = collect(randomPoints(segmentCount, upperRight-lowerLeft...))
    ends::PointList = collect(randomPoints(segmentCount, upperRight-lowerLeft...))

    return collect(zip(starts, ends))

end


end #module