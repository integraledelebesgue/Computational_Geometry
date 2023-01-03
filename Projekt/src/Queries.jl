module Queries
export Constraint, Query, fitQueryToSquare

using BasicDatatypes


struct Constraint

    relaxed::Bool  # Convention: query is relaxed iff at least one constraint is nothing

    x_interval::Maybe{Interval}
    y_interval::Maybe{Interval}

    Constraint(x_first::Maybe{Float64}, x_second::Maybe{Float64}, y_first::Maybe{Float64}, y_second::Maybe{Float64}) = new(constructNewConstraint(x_first, x_second, y_first, y_second)...)

end


struct Query

    x_interval::Maybe{Interval}
    y_interval::Maybe{Interval}

end


function constructNewConstraint(x_first::Maybe{Float64}, x_second::Maybe{Float64}, y_first::Maybe{Float64}, y_second::Maybe{Float64})::Tuple{Bool, Maybe{Interval}, Maybe{Interval}}

    # Invalid cases:
    if x_first > x_second  || ( (x_first  === nothing) ⊻ (x_second === nothing))
        throw(ArgumentError("Interval ($(x_first), $(x_second)) is not valid."))
    elseif y_first > y_second || ((y_first  === nothing) ⊻ (y_second === nothing))
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


function fitQueryToSquare(query::Query, x_interval::Interval, y_interval::Interval)::Maybe{Query}

    x_intersection::Maybe{Interval} = intersectIntervals(x_interval, query.x_interval)
    y_intersection::Maybe{Interval} = intersectIntervals(y_interval, query.y_interval)

    if x_intersection === nothing || y_intersection === nothing
        return nothing
    end

    return Query(x_intersection, y_intersection)

end


end #module