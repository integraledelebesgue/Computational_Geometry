module Queries
export Constraint, Query, fitQueryToSquare, constraintToString

using BasicDatatypes: Maybe, Interval, intersectIntervals, validateInterval


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

    # Trivial case:
    if (x_first === nothing && x_second === nothing && y_first === nothing && y_second === nothing)
        return true, (-Inf, Inf), (-Inf, Inf)
    end

    x_interval::Interval = (
        x_first !== nothing ? x_first : -Inf,
        x_second !== nothing ? x_second : Inf
    )

    y_interval::Interval = (
        y_first !== nothing ? y_first : -Inf,
        y_second !== nothing ? y_second : Inf
    )

    if validateInterval(x_interval) === nothing
        throw(ArgumentError("Interval ($(x_first), $(x_second)) is not valid."))
    end

    if validateInterval(y_interval) === nothing
        throw(ArgumentError("Interval ($(y_first), $(y_second)) is not valid."))
    end

    return false, x_interval, y_interval

end


function fitQueryToSquare(query::Query, x_interval::Interval, y_interval::Interval)::Maybe{Query}

    x_intersection::Maybe{Interval} = intersectIntervals(x_interval, query.x_interval)
    y_intersection::Maybe{Interval} = intersectIntervals(y_interval, query.y_interval)

    if x_intersection === nothing || y_intersection === nothing
        return nothing
    end

    return Query(x_intersection, y_intersection)

end


function constraintToString(constraint::Constraint)::String

    local substituteInfinity = interval::Interval -> (
        "($(interval[1] == -Inf ? "-∞" : interval[1]), $(interval[2] == Inf ? "∞" : interval[2]))"
    )

    return join([
        constraint.x_interval !== (-Inf, Inf) ? "x ∈ $(substituteInfinity(constraint.x_interval))" : "x ∈ ℝ",
        " ∧ ",
        constraint.y_interval !== (-Inf, Inf) ? "y ∈ $(substituteInfinity(constraint.y_interval))" : "y ∈ ℝ"
    ])

end

end #module