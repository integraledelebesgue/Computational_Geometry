using Base: ident_cmp
using Plots: scatter, scatter!

points = [rand(2) * 10.0 for _ in 1:50]

start_point = minimum(reverse, points) |> reverse

getX(point) = getindex(point, 1)
getY(point) = getindex(point, 2)

scatter(@view(points[:]) .|> getX, @view(points[:]) .|> getY)
scatter!([start_point[1]], [start_point[2]], seriescolor = :red)