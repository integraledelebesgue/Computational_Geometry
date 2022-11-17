push!(LOAD_PATH, @__DIR__)

using hull

function main()

    # Wywołanie funkcji w celu użycia programu:

    #normalHull()
    #normalHull(1000, "Jarvis", "square_diagonals")
    normalHull(10, "Graham", "square")

end

main()