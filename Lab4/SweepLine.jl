module SweepLine

using BasicDataTypes
using DataStructures
using AVLTrees


function lexiOrderLowerThan(point1, point2)

    return point1.x < point2.x || (point1.x == point2.x && point1.y < point2.y)

end


function anyIntersect(segments)

    local filterNothing = list -> filter(x -> x !== nothing, list)

    segmentStart = Dict{Point, Segment}()
    segmentEnd = Dict{Point, Segment}()

    #Q = PriorityQueue{Float64, Point, lexiOrderLowerThan}()
    lineStatus = AVLTree()

    # Preprocessing:
    for segment in segments

        segmentEnd[segment[2]] = segment
        segmentStart[segment[1]] = segment
        

        #enqueue!(Q, segment[1][1], segment[1])
        #enqueue!(Q, segment[2][1], segment[2])

    end

    sortedPoints = sort([ [segment[1] for segment in segments] ; [segment[2] for segment in segments] ], lt = lexiOrderLowerThan)

    for point in sortedPoints  # x = point[1]

        if get(segmentStart, point, false)

            currSegment = segmentStart[point]

            insert!(lineStatus, point[2], currSegment)

            successor = findSuccessor(tree, currSegment)
            predecessor = findPredecessor(tree, currSegment)

            if successor !== nothing && segmentsIntersect(currSegment, successor)
                return true
            end

            if predecessor !== nothing && segmentsIntersect(currSegment, predecessor)
                return true
            end

        end

        if get(segmentEnd, point, false)

            currSegment = segmentEnd[point]

            successor = findSuccessor(tree, currSegment)
            predecessor = findPredecessor(tree, currSegment)

            if successor !== nothing && predecessor !== nothing && segmentsIntersect(successor, predecessor)
                return true
            end

            delete!(tree, currSegment)

        end

    end

    return false

end


end #module