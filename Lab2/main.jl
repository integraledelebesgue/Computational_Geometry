push!(LOAD_PATH, @__DIR__)

using Plots: plot, plot!, Plot

using BasicDatatypes: Point, PointList
using Generators: simple_set, span_set, ellipsoidal_set
using Visualization: plot_points!, plot_hull!
using Hull: convex_hull


function main()::Nothing

    point_list::PointList = simple_set(100, (0.0, 5.0), (0.0, 5.0))

    #point_list::PointList = span_set(
    #    (100, 100, 100, 100),
    #    ([1.0, 1.0], [1.0, -1.0], [1.0, 0.0], [0.0, 1.0]),
    #    ([0.0, 0.0], [0.0, 5.0], [0.0, 0.0], [0.0, 0.0]),
    #    ((0.0, 5.0), (0.0, 5.0), (0.0, 5.0), (0.0, 5.0))
    #)

    #point_list::PointList = ellipsoidal_set(1000, [0.0, 0.0], 5.0, 2.0)

    plot(size = (500, 500)) |> display
    plot_points!(point_list, color = :magenta) |> display

    hull::PointList = @time convex_hull(point_list, method = :jarvis)

    plot_hull!(hull) |> display
    plot_points!(hull, color = :orange, label = "Hull points") |> display

    return nothing

end


main()
