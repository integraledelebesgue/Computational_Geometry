push!(LOAD_PATH, @__DIR__)

using Random: rand

function map_generator(n::Integer)::Nothing

    local_parametrization = Dict([(0, () -> rand(2) .+ 5.0), (1, () -> rand(2) .- 5.0)])

    for point in map(i -> local_parametrization[i%2](), 1:n)
    end

    return nothing

end


function channel_generator(n::Integer)::Nothing

    local local_parametrization::Dict{Integer, Function} = Dict([(0, () -> rand(2) .+ 5.0), (1, () -> rand(2) .- 5.0)])

    function stream()::Channel{Array{Float64, 1}}
        Channel{Array{Float64, 1}}() do channel
            for i in 1:n
                put!(channel, local_parametrization[i%2]())
            end
        end
    end

    point_stream = stream()

    for point in stream()
    end

    return nothing

end


function normal_generator(n::Integer)::Nothing

    for point in eachcol(rand(2, n))
    end

    return nothing
end

n = 1000000

#@time map_generator(n)
@time channel_generator(n)
#@time normal_generator(n)

# (count)    1000                                                                  10 000 
# (map)      0.129550 seconds (478.76 k allocations: 24.287 MiB, 5.60% gc time)    0.120875 seconds (505.75 k allocations: 26.139 MiB, 5.05% gc time)
# (channel)  0.079991 seconds (274.79 k allocations: 13.937 MiB)                   0.078256 seconds (274.78 k allocations: 13.937 MiB)
# (normal)   0.007317 seconds (24.34 k allocations: 1.185 MiB)                     0.009864 seconds (24.33 k allocations: 1.322 MiB)
#
#            1 000 000 (!) 
#            0.353349 seconds (3.48 M allocations: 230.073 MiB, 17.51% gc time)
#            2.296894 seconds (5.75 M allocations: 275.916 MiB, 6.63% gc time)  (with iteration)
#            0.095217 seconds (24.33 k allocations: 16.428 MiB, 82.60% gc time)
#
# Tests (1000) and (10 000) for channel_generator had been done only for channel emplacement, without further actions;
# Test (1 000 000) includes channel iteration