module hull

export normalHull, animatedHull

using Plots

using generators 
using utilities
using graham
using jarvis

Plots.default(overwrite_figure=true)

function functionToString(name::Function)::String
    if name == square
        return "square"
    elseif name == circle
        return "circle"
    elseif name == square_border
        return "square_border"
    elseif name == square_diagonals
        return "square_diagonals"
    end

    return ""
end


function stringToFunction(name::String)::Function
    if name == "square"
        return square
    elseif name == "circle"
        return circle
    elseif name == "square_border"
        return square_border
    elseif name == "square_diagonals"
        return square_diagonals
    end

    return square
end


function animatedHull(n::Int, method="Graham", point_set="square")
    # method ∈ {"Graham", "Jarvis"}
    #set ∈ {square, circle, square_border, square_diagonal}

    points = stringToFunction(point_set)(n, 10.0*n)

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

    gif(animation, join([method, "_", point_set, "_", string(n), ".gif"]), fps=10)

end


function normalHull(n::Int, method="Graham", point_set="square")
    # method ∈ {"Graham", "Jarvis"}
    #set ∈ {square, circle, square_border, square_diagonal}

    points = stringToFunction(point_set)(n, 10.0*n)

    plot(plotPreprocess(points), seriestype = :scatter, label = "Points", size=(1000, 1000))

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

    savefig(join([method, "_", point_set, "_", string(n), ".png"]))

end


function testAlgorithms()

    for alg in [findHullGraham, findHullJarvis]
        
        print("--\n")
        
        for fun in [square, circle, square_border, square_diagonals]
            
            for n in [1e04, 1e05, 1e06]
                point_set::Array{Array{Float64, 1}, 1} = fun(Int(n), 10.0 * Int(n))
                
                start_time::Float64 = time()

                hull::Array{Array{Float64, 1}, 1} = alg(point_set)

                print(time() - start_time, " s\n")
            end

        end

    end

end

end
