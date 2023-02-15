push!(LOAD_PATH, @__DIR__)


abstract type AbstractStruct end

struct Struct <: AbstractStruct
    x::Int
end

function foo(strct::AbstractStruct)::Nothing
    println(strct.x)
end

strukcik = Struct(1)

foo(strukcik)