push!(LOAD_PATH, @__DIR__)

using GeometricSearch


function main(n::Int, x_min::Float64, x_max::Float64, y_min::Float64, y_max::Float64)

        # Generate random dataset:
    #points = generateUniformPoints(n, (x_min, x_max), (y_min, y_max))  # Points unoformly distributed on a rectangle area
    points = generateClusterPoints(n, ([0.0, 0.0], 3.0), ([5.0, -5.0], 0.5), ([0.0, -6.0], 0.25))  # Sum of normally distributed points clusters

        # Mix generators:
    #points = [
    #    generateUniformPoints(10n, (x_min, x_max), (y_min, y_max));
    #    generateClusterPoints(5n, ([0.0, 0.0], 1.0), ([-1.0, -3.0], 0.5))
    #]

        # Read dataset from text file:
    #points = readPointsFromFile(filename)

        # Choose search strategy:
    tree = Quadtree(points)
    #tree = KDTree(points)

        #Declare constraints:
    constraint_1 = Constraint(2.0, 7.5, -6.5, -3.5)
    constraint_2 = Constraint(nothing, nothing, 0.0, 3.0)
    constraint_3 = Constraint(-2.5, 2.5, -7.0, -5.0)

        # Perform search:
    result_1, execution_time_1 = solveSatisfy(tree, constraint_1)
    result_2, execution_time_2 = solveSatisfy(tree, constraint_2)
    result_3, execution_time_3 = solveSatisfy(tree, constraint_3)

        # Process asynchronously:
    #results = solveSatisfyConcurrent(tree, constraint_1, constraint_2)

        # Plot results:
    plotResults!(points, (result_1, constraint_1), (result_2, constraint_2), (result_3, constraint_3))

        # Dispay detailed information:
    commentResult!(n, constraint_1, tree.construction_time, length(result_1), execution_time_1)
    commentResult!(n, constraint_2, tree.construction_time, length(result_2), execution_time_2)
    commentResult!(n, constraint_3, tree.construction_time, length(result_3), execution_time_3)

        # Save results to file:
    #saveResultToFile!("lista_punktow", result_1, constraint_1)  # Add constraint annotation on top
    #saveResultToFile!("lista_punktow", result_1)  # Don't add constraint annotation

        # Save plot to file:
    #savePlotToFile!("wykres")

end


main(100, -5.0, 5.0, -5.0, 5.0)
