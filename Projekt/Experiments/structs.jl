push!(LOAD_PATH, @__DIR__)

using mypackage


struct strukturka
    x::Int
    y::Int

    strukturka(x, y) = new(buildStrukturka(x, y)...)
end


function buildStrukturka(ex::Int, wy::Int)

    return ex > 0 ? (ex, 2wy) : (-ex, 5wy)

end


strct1 = strukturka(1, 1)
strct2 = strukturka(-1, 5)


print(strct1.x, ", ", strct1.y, "\n")
print(strct2.x, ", ", strct2.y, "\n")

strct3 = QuadNode(1, 2)