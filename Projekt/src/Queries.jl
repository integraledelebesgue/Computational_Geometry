module Queries

using BasicDatatypes


struct SafeQuery

    relaxed::Bool  # Convention: at least one constraint is nothing => query is relaxed

    x_interval::Maybe{Interval}
    y_interval::Maybe{Interval}

    SafeQuery(x_first::Maybe{Float64}, x_second::Maybe{Float64}, y_first::Maybe{Float64}, y_second::Maybe{Float64}) = new(constructNewSafeQuery(x_first, x_second, y_first, y_second)...)

end


struct SubQuery

    x_interval::Maybe{Interval}
    y_interval::Maybe{Interval}

end


function constructNewSafeQuery(x_first::Maybe{Float64}, x_second::Maybe{Float64}, y_first::Maybe{Float64}, y_second::Maybe{Float64})::Tuple{Bool, Maybe{Interval}, Maybe{Interval}}

    # Invalid cases:
    if x_first > x_second  || (x_first  === nothing ⊻ x_second === nothing)
        throw(ArgumentError("Interval ($(x_first), $(x_second)) is not valid."))
    elseif y_first > y_second || (y_first  === nothing ⊻ y_second === nothing)
        throw(ArgumentError("Interval ($(y_first), $(y_second)) is not valid."))

    # Trivial cases:
    elseif (x_first === nothing && x_second === nothing && y_first === nothing && y_second === nothing)
        return (true, nothing, nothing)

    elseif (x_first === nothing && x_second === nothing) 
        return (true, nothing, (y_first, y_second))

    elseif (y_first === nothing && y_second === nothing)
        return (true, (x_first, x_second), nothing)
    
    # Normal case:
    else
        return (false, Interval((x_first, x_second)), Interval((y_first, y_second)))
    end

end


function fitToInterval(query::SubQuery, interval::Interval)::Maybe{SubQuery}

end


end #module