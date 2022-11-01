push!(LOAD_PATH, @__DIR__)

using generators 
using Plots

n = 200

points = square_diagonals(n, 10.0)

plot(points[1, 1:n], points[2, 1:n], seriestype = :scatter, size=(500, 500))