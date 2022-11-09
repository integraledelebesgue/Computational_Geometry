module jarvis

export findHullJarvis


using utilities


function findHullJarvis(point_list::Array{Array{Float64, 1}, 1}; animate::Bool=false)::Union{Array{Array{Float64, 1}, 1}, Tuple{Array{Array{Float64, 1}, 1}, Vector{Array{Array{Float64, 1}, 1}}}}

    function angleOrder(start, x, y)
        if myDet(start, x, y) < 0
            return true
        #elseif myDet(start, x, y) == 0
        #    return sqrt(reduce(+, x.^2)) <= sqrt(reduce(+, y.^2))
        end
        return false
    end


    best = [Inf, Inf]

    for point in point_list
        if point[2] < best[2]
            best = point
        elseif point[2] == best[2] && point[1] < best[1]
            best = point
        end
    end

    stack_history = Vector{Array{Array{Float64, 1}, 1}}()

    # Zainicjalizuj otoczkę, dodając sztuczny punkt przed pierwszym wierzchołkiem
    hull::Array{Array{Float64, 1}, 1} = Array{Array{Float64, 1}, 1}()
    hull_top::Int = 2
    push!(hull, best + [-1.0, 0.0])
    push!(hull, best)

    next_point = Array{Float64, 1}()

    while true
        # Znajdź punkt next_point, dla którego kąt (hull[top-1], hull[top], next_point) jest największy
        next_point = hull[hull_top-1]

        for point in point_list

            if point == hull[hull_top-1] || point == hull[hull_top]
                continue
            end

            if angleOrder(hull[hull_top], next_point, point)
                next_point = point
            end

        end

        # Jeśli napotkano punkt początkowy, zakończ iterację:
        if next_point == hull[2]
            break
        end

        # Dodaj punkt do otoczki:
        push!(hull, next_point)
        hull_top += 1

        if animate
            push!(stack_history, deepcopy(hull))
        end

    end
    
    # Usuń sztucznie dodany punkt
    popfirst!(hull) 
    
    push!(hull, best) 

    if animate
        push!(stack_history, deepcopy(hull))
        return hull, stack_history
    else
        return hull

    end

end


end