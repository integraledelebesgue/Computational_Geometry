

function applyFunction(x::Int, f::Function)::Nothing
    println(f(x))
    return nothing
end

applyFunction(1, x::Int -> 2x)
