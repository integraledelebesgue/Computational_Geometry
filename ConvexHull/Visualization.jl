module Visualization
export plot_points!, plot_hull!

using Plots: plot!, Plot
using BasicDatatypes: Point, PointList

getX(point::Point)::Float64 = getindex(point, 1)
getY(point::Point)::Float64 = getindex(point, 2)


function plot_points!(point_list::PointList; color::Symbol = :magenta, label::String = "Point set")::Plot

    points::SubArray = @view(point_list[:])

    return plot!(
        points .|> getX,
        points .|> getY,
        seriescolor = color,
        seriestype = :scatter,
        aspect_ratio = :equal,
        label = label
    )

end


function plot_hull!(point_list::PointList; color::Symbol = :black)::Plot

    cyclic_points::SubArray = @view(push!(point_list, point_list[1])[:])

    return plot!(
        cyclic_points .|> getX,
        cyclic_points .|> getY,
        seriescolor = color,
        aspect_ratio = :equal,
        label = "Hull"
    )

end


end #module