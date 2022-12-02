module PointClassification
export classifyPoints, filterChains

using BasicDatatypes
using GeometricPredicates: orient

ϵ = 0.0


function filterChains(polygon::PointList, set::CyclicLinkedHashSet)::Tuple{PointList, PointList}

    n::Int = length(polygon)

    first::Point = [Inf, Inf]
    last::Point = [-Inf, -Inf]

    for point in polygon
        if point[1] < first[1]
            first = point
        end

        if point[1] > last[1]
            last = point
        end

    end

    upper::PointList = PointList()
    lower::PointList = PointList()
    curr::Point = last

    while curr != first
        push!(lower, curr)
        curr = getNext(set, curr)
    end

    while curr != last
        push!(upper, curr)
        curr = getNext(set, curr)
    end

    return (upper, lower)

end


function classifyPoints(points::PointList, set::CyclicLinkedHashSet)::Tuple{PointList, PointList, PointList, PointList, PointList}

    starting::PointList = PointList()
    closing::PointList = PointList()
    connective::PointList = PointList()
    separative::PointList = PointList()
    correct::PointList = PointList()

    for point in points
        classify!(point, starting, closing, connective, separative, correct, set)
    end

    return (starting, closing, connective, separative, correct)

end


function classify!(point::Point, starting::PointList, closing::PointList, connective::PointList, separative::PointList, correct::PointList, set::CyclicLinkedHashSet)::Nothing

    previous::Point = getPrevious(set, point)
    next::Point = getNext(set, point)

    if next[1] > point[1] && previous[1] > point[1]

        if orient(previous, point, next) > ϵ
            push!(starting, point)
        
        elseif orient(previous, point, next) < -ϵ
            push!(separative, point)
        end

    elseif next[1] < point[1] && previous[1] < point[1]

        if orient(previous, point, next) > ϵ
            push!(closing, point)
        elseif orient(previous, point, next) < -ϵ
            push!(connective, point)
        end

    else
        push!(correct, point)
    end

    return nothing

end


end #module