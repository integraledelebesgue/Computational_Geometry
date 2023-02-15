module SweepLine
export anyIntersect, findAllIntersections

using BasicDataTypes
using DataStructures
using AVLTrees


function anyIntersect(segments::SegmentList)::Bool

    segmentStart::Dict{Point, Segment} = Dict{Point, Segment}()
    segmentEnd::Dict{Point, Segment} = Dict{Point, Segment}()

    lineStatus::AVLTrees.AVLTree = AVLTrees.AVLTree()

    currSegment::Segment = newSegment()
    successor::Maybe{Segment} = newSegment()
    predecessor::Maybe{Segment} = newSegment()

    # Preprocessing:
    for segment in segments

        segmentEnd[segment[2]] = segment
        segmentStart[segment[1]] = segment

    end

    sortedPoints::PointList = sort([ [segment[1] for segment in segments] ; [segment[2] for segment in segments] ], lt = lexiOrderLowerThan)

    for point in sortedPoints

        if get(segmentStart, point, nothing) !== nothing

            currSegment = segmentStart[point]

            AVLTrees.insert!(lineStatus, point[2], currSegment)

            successor = findSuccessor(lineStatus, currSegment)
            predecessor = findPredecessor(lineStatus, currSegment)

            if successor !== nothing && segmentsIntersect(currSegment, successor)
                return true
            end

            if predecessor !== nothing && segmentsIntersect(currSegment, predecessor)
                return true
            end

        end

        if get(segmentEnd, point, nothing) !== nothing

            currSegment = segmentEnd[point]

            successor = findSuccessor(lineStatus, currSegment)
            predecessor = findPredecessor(lineStatus, currSegment)

            if successor !== nothing && predecessor !== nothing && segmentsIntersect(successor, predecessor)
                return true
            end

            AVLTrees.delete!(lineStatus, currSegment)

        end

    end

    return false

end


function findAllIntersections(segments::SegmentList)::Dict{Point, Tuple{Segment, Segment}}

    segmentStart::Dict{Point, Segment} = Dict{Point, Segment}()
    segmentEnd::Dict{Point, Segment} = Dict{Point, Segment}()
    segmentCross::Dict{Point, Tuple{Segment, Segment}} = Dict{Point, Tuple{Segment, Segment}}()
    processedCrosses::Dict{Point, Bool} = Dict{Point, Bool}()

    eventQueue::PriorityQueue{Float64, Point} = PriorityQueue{Float64, Point}()
    lineStatus::AVLTrees.AVLTree = AVLTrees.AVLTree()

    point::Point = Point()
    currSegment::Segment = newSegment()
    successor::Maybe{Segment} = nothing
    predecessor::Maybe{Segment} = nothing
    intersection::Point = Point()
    key1::Float64 = 0.0
    key2::Float64 = 0.0
    segment1::Segment = newSegment()
    segment2::Segment = newSegment()
    predecessor1::Maybe{Segment} = nothing
    successor1::Maybe{Segment} = nothing
    predecessor2::Maybe{Segment} = nothing
    successor2::Maybe{Segment} = nothing

    # Preprocessing:
    for segment in segments

        segmentEnd[segment[2]] = segment
        segmentStart[segment[1]] = segment
        
        enqueue!(eventQueue, segment[1][1], segment[1])
        enqueue!(eventQueue, segment[2][1], segment[2])

    end

    while !isempty(eventQueue)

        point = peek(eventQueue)[2]
        dequeue!(eventQueue)

        #println(point)

        # If current point is beginns a segment:
        if get(segmentStart, point, nothing) !== nothing

            currSegment = segmentStart[point]

            # Reorder elements in tree:
            reorder!(lineStatus, seg -> getY(seg, point[1]))

            # Add current segment
            AVLTrees.insert!(lineStatus, point[2], currSegment)

            # Test for intersection among curr's neighbours:
            successor = findSuccessor(lineStatus, currSegment)
            predecessor = findPredecessor(lineStatus, currSegment)

            if successor !== nothing && segmentsIntersect(currSegment, successor)
                intersection = findIntersection(currSegment, successor)
                segmentCross[intersection] = (currSegment, successor)
                enqueue!(eventQueue, intersection[1], intersection)
            end

            if predecessor !== nothing && segmentsIntersect(currSegment, predecessor)
                intersection = findIntersection(currSegment, predecessor)
                segmentCross[intersection] = (currSegment, predecessor)
                enqueue!(eventQueue, intersection[1], intersection)
            end

        end

        # If current point ends a segment:
        if get(segmentEnd, point, nothing) !== nothing

            currSegment = segmentEnd[point]

            # Reorder elements in tree:
            reorder!(lineStatus, seg -> getY(seg, point[1]))

            # Add current segment
            AVLTrees.insert!(lineStatus, point[2], currSegment)

            successor = findSuccessor(lineStatus, currSegment)
            predecessor = findPredecessor(lineStatus, currSegment)

            if successor !== nothing && predecessor !== nothing && segmentsIntersect(successor, predecessor)
                intersection = findIntersection(successor, predecessor)
                segmentCross[intersection] = (successor, predecessor)
            end

            AVLTrees.delete!(lineStatus, currSegment)

        end

        # If current point is the intersection of two segments:
        if get(segmentCross, point, nothing) !== nothing && !get(processedCrosses, point, false)

            processedCrosses[point] = true

            (segment1, segment2) = segmentCross[point]

            # Delete current segments and save their keys
            key1 = lineStatus.map[segment1].key
            key2 = lineStatus.map[segment2].key

            AVLTrees.delete!(lineStatus, segment1)
            AVLTrees.delete!(lineStatus, segment2)

            # Reorder elements in tree:
            reorder!(lineStatus, seg -> getY(seg, point[1]))

            # Re-insert current segments in opposite order:
            AVLTrees.insert!(lineStatus, key2, segment1)
            AVLTrees.insert!(lineStatus, key1, segment2)

            # Check for 1st segment intersections
            successor1 = findSuccessor(lineStatus, segment1)
            predecessor1 = findPredecessor(lineStatus, segment1)

            if successor1 !== nothing && successor1 != segment2 && segmentsIntersect(segment1, successor1)
                intersection = findIntersection(segment1, successor1)
                segmentCross[intersection] = (segment1, successor1)
                if !haskey(eventQueue, intersection[1])
                    enqueue!(eventQueue, intersection[1], intersection)
           
                end
            end

            if predecessor1 !== nothing && predecessor1 != segment2 && segmentsIntersect(segment1, predecessor1)
                intersection = findIntersection(segment1, predecessor1)
                segmentCross[intersection] = (segment1, predecessor1)
                
                if !haskey(eventQueue, intersection[1])    
                    enqueue!(eventQueue, intersection[1], intersection)
                end
            
            end

            # Check for 2nd segment intersections
            successor2 = findSuccessor(lineStatus, segment2)
            predecessor2 = findPredecessor(lineStatus, segment2)

            if successor2 !== nothing && successor2 != segment1 && segmentsIntersect(segment2, successor2)
                intersection = findIntersection(segment2, successor2)
                segmentCross[intersection] = (segment2, successor2)
                
                if !haskey(eventQueue, intersection[1])
                    enqueue!(eventQueue, intersection[1], intersection)
                end
            end

            if predecessor2 !== nothing && predecessor2 != segment1 && segmentsIntersect(segment2, predecessor2)
                intersection = findIntersection(segment2, predecessor2)
                segmentCross[intersection] = (segment2, predecessor2)
                
                if !haskey(eventQueue, intersection[1])
                    enqueue!(eventQueue, intersection[1], intersection)
                end

            end
        
        end

    end

    return segmentCross

end


end #module