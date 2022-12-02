push!(LOAD_PATH, @__DIR__)

using Plots
using QuadTree
using PlotPreprocess

n = 10
points = [rand(Float64, 2) for _ in 1:n]

qt = Quadtree(points)

println(qt.depth)
println(qt.construction_time)
