module BasicDatatypes
export Point, PointList, Maybe, ListNode, CyclicLinkedHashSet, getNext, getPrevious


Maybe{T} = Union{T, Nothing}

Point = Array{Float64, 1}
PointList = Array{Point, 1}


mutable struct ListNode

    point::Point
    prev::Maybe{ListNode}
    next::Maybe{ListNode}

end


struct CyclicLinkedList

    first::Maybe{ListNode}
    last::Maybe{ListNode}

    CyclicLinkedList(points::PointList) = new(constructCyclicLinkedList(points)...)

end


struct CyclicLinkedHashSet

    map::Dict{Point, ListNode}
    cycle::CyclicLinkedList

    CyclicLinkedHashSet(points::PointList) = new(constructCyclicLinkedHashSet(points)...)

end


#CyclicLinkedList:
function constructCyclicLinkedList(points::PointList)::Tuple{ListNode, ListNode}

    n::Int = length(points)

    first::ListNode = ListNode(points[1], nothing, nothing)
    last::ListNode = ListNode(points[n], nothing, nothing)

    first.prev = last
    last.next = first

    prev::ListNode = first

    for i in 2:n-1

        curr = ListNode(points[i], prev, nothing)
        prev.next = curr
        prev = curr

    end

    prev.next = last
    last.prev = prev

    return (first, last)

end


function constructCyclicLinkedHashSet(points::PointList)::Tuple{Dict{Point, ListNode}, CyclicLinkedList}

    n::Int = length(points)
    cyclic_list::CyclicLinkedList = CyclicLinkedList(points)
    map::Dict{Point, ListNode} = Dict{Point, ListNode}()
    iterator::ListNode = cyclic_list.first

    for i in 1:n
        map[points[i]] = iterator
        iterator = iterator.next
    end

    return (map, cyclic_list)
    
end

function getNext(set::CyclicLinkedHashSet, item::Point)::Maybe{Point}

    return get(set.map, item, nothing).next.point

end


function getPrevious(set::CyclicLinkedHashSet, item::Point)::Maybe{Point}

    return get(set.map, item, nothing).prev.point

end


end # module