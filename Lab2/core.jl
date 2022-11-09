push!(LOAD_PATH, @__DIR__)

using Plots

using generators 
using utilities
using graham
using jarvis

Plots.default(overwrite_figure=true)


function animated_hull()

    points2, translation_vector = translatePoints(points)

    if method == "Graham"
        hull, history = findHullGraham(points2, animate=true)

    elseif method == "Jarvis"
        hull, history = findHullJarvis(points2, animate=true)

    end

    animation = @animate for i in 1:length(history)
        plot(plotPreprocess(history[i]), legend=false)
        plot!(plotPreprocess(points2), seriestype = :scatter, legend=false, size=(500, 500))
    end

    gif(animation, join([method, string(n), ".gif"]), fps=10)

end


function normal_hull()

    plot(plotPreprocess(points), seriestype = :scatter, label = "Points", size=(500, 500))

    points2, translation_vector = translatePoints(points)


    start_time = time()


    if method == "Graham"
        hull = findHullGraham(points2)

    elseif method == "Jarvis"
        hull = findHullJarvis(points2)
        
    end


    print("Computing ", n, " points with ", method, " method took ", time()-start_time, " s")


    translated_hull = inverseTranslation(hull, translation_vector)

    plot!(plotPreprocess(translated_hull), label="Hull edges")
    plot!(plotPreprocess(translated_hull), seriestype = :scatter, label="Hull vertices")

end



n = 100
method = "Graham"
#method = "Jarvis"

points = square_diagonals(n, n * 10.0)

#normal_hull()
animated_hull()
