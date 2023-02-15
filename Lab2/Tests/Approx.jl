
ϵ = 1e-08
≈(x::Float64, y::Float64)::Bool = isapprox(x, y, atol=ϵ)

function set_eps(accuracy::Float64)::Nothing

    global ϵ
    ϵ = accuracy

    return nothing

end

set_eps(1e-09)
println(ϵ)