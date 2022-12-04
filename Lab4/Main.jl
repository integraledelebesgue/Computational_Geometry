push!(LOAD_PATH, @__DIR__)

using PyCall
using AVLTrees
using BasicDataTypes
using SweepLine

function readFromInterface()

    pushfirst!(PyVector(pyimport("sys")."path"), "")
    pushfirst!(PyVector(pyimport("sys")."path"), @__DIR__)
    interface = pyimport("GraphicInterface")
    return map(x -> [x[1], x[2]], interface.runCanvas()) .|> lexiOrderLowerThan

end


function test()

    tree = AVLTree()

    #insert(tree, 1.0, "napis1")
    #insert(tree, 2.5, "napisik2")
    #insert(tree, 1.5, "napisik3")

    insert(tree, 5.0, "napis1")
    insert(tree, 1.5, "napisik2")
    insert(tree, 2.5, "napisik3")
    insert(tree, 10.0, "napisik4")
    insert(tree, -1.0, "napisik5")
    insert(tree, 2.0, "napisik6")

    printTreeInOrder(tree)

    #println(findMax(tree).value)
    #println("Następnikiem $(tree.guard.right.left.right.value) jest $(findSuccessorNode(tree.guard.right.left.right).value)")

    deleteNode(tree.guard.right.left)

    printTreeInOrder(tree)

end


function main()

    segments = readFromInterface()
    println(segments)

end

main()