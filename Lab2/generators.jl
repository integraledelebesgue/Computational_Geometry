module generators

export square, circle, square_border, square_diagonals

using Random

function points(count::Int)::Channel{Vector{Float64}}

    Channel{Vector{Float64}}() do channel
        for _ ∈ 1:count
            put!(channel, rand(Float64, 2))
        end
    end

end


function params(count::Int)::Channel{Float64}

    Channel{Float64}() do channel
        for _ ∈ 1:count
            put!(channel, rand())
        end
    end

end


function choices(count::Int, range::Int)::Channel{Char}

    Channel{Char}() do channel
        for x ∈ randstring('a':'a'+range-1, count)
            put!(channel, x)
        end
    end

end


function square(count::Int, range::AbstractFloat)::Array{Float64, 2}

    local square_param = point::Vector{Float64} -> [-range, -range] + (point * 2range)

    return reduce(hcat, points(count) |> collect .|> square_param)

end


function circle(count::Int, radius::Float64)::Array{Float64, 2}

    local circle_param = param::Float64 -> ( param * 2π .|> [cos, sin] ) .* radius

    return reduce(hcat, params(count) |> collect .|> circle_param)

end


function square_border(count::Int, range::Float64)::Array{Float64, 2}
    
    # Sides scheme:
    #     b b b
    #   a       c
    #   a   0   c
    #   a       c
    #     d d d
    #
    
    function border_param(args::Tuple{Char, Float64})::Vector{Float64}
        
        side = args[1]
        param = args[2]
       
        if side == 'a'
            return [-range, -range] + [0, 1] * 2range * param
        
        elseif side == 'b' 
            return [-range, range] + [1, 0] * 2range * param

        elseif side == 'c'
            return [range, -range] + [0, 1] * 2range * param

        elseif side == 'd'
            return [-range, -range] + [1, 0] * 2range * param

        end
            
    end


    return reduce( 
        hcat,
        [
            [ [-range, -range], [-range, range], [range, range], [range, -range] ];
            zip(collect(choices(count, 4)), collect(params(count))) |> collect .|> border_param
        ]
    )
end


function square_diagonals(count::Int, range::Float64)::Array{Float64, 2}

    # Sides scheme:
    #     
    #   a c   d 
    #   a   0   
    #   a d   c 
    #     b b b
    #

    function diagonal_param(args::Tuple{Char, Float64})::Vector{Float64}

        side = args[1]
        param = args[2]
       
        if side == 'a'
            return [-range, -range] + [0, 1] * 2range * param
        
        elseif side == 'b' 
            return [-range, -range] + [1, 0] * 2range * param

        elseif side == 'c'
            return [-range, range] + [1, -1] * 2range * param

        elseif side == 'd'
            return [-range, -range] + [1, 1] * 2range * param

        end

    end

    return reduce(
        hcat,    
        [
            [ [-range, -range], [-range, range], [range, range], [range, -range] ];
            zip(collect(choices(count, 4)), collect(params(count))) |> collect .|> diagonal_param
        ]
    )
    
end


end
