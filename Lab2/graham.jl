module graham

export findHullGraham


using utilities

ϵ = 1e-09

function findHullGraham(point_list::Array{Array{Float64, 1}, 1}; animate::Bool=false)::Union{Array{Array{Float64, 1}, 1}, Tuple{Array{Array{Float64, 1}, 1}, Vector{Vector{Array{Float64, 1}}}}}

    stack = Vector{Array{Float64, 1}}()
    stack_history = Vector{Vector{Array{Float64, 1}}}()
    n = length(point_list)

    sortByAngle!(point_list)

    for i in 1:2
        push!(stack, point_list[i])
    end

    i = 3
    stack_top = 2

    while i <= n

        if abs( myDet(stack[stack_top-1], stack[stack_top], point_list[i]) ) <= ϵ
            pop!(stack)
            push!(stack, point_list[i])
            i += 1

        elseif myDet(stack[stack_top-1], stack[stack_top], point_list[i]) < 0.0
            push!(stack, point_list[i])
            stack_top += 1
            i += 1

        else
            pop!(stack)
            stack_top -= 1

        end

        if animate
            push!(stack_history, deepcopy(stack))
        end

    end

    push!(stack, point_list[1])

    if animate
        push!(stack_history, deepcopy(stack))
        return stack, stack_history
    else
        return stack
    end

end


end