function simple_fun()::Nothing
    print("Sample text $(time()) - ")
end


function generateNumbers(n::Int64)::Array{Int64, 1}

    return randn(Int, n)

end


function evaluate(number::Int64, out_channel::Channel{Array{Float64, 1}})::Nothing

    put!(out_channel, generateNumbers(number))
    
    return nothing

end


function processAsync(numbers::Array{Int64, 1})::Array{Float64, 1}

    ch = Channel{Array{Float64, 1}}()

    foreach(
        x -> (@async evaluate(x, ch)),
        numbers
    )

    println(ch)

    return []

    #return reduce(vcat, take!(ch))

end


println(processAsync([1, 2, 3]))
