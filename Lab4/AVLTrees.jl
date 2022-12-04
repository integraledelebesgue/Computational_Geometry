module AVLTrees
export Node, AVLTree, insert!, printTreeInOrder, findSuccessor, findPredecessor, delete!


mutable struct Node
    key
    value
    left
    right
    parent

    Node(_key, _value) = new(_key, _value, nothing, nothing, nothing)
end


mutable struct AVLTree
    guard
    map

    AVLTree() = new(Node(nothing, nothing), Dict{Segment, Node}())
end


function height(parent)

    if parent ≡ nothing
        return 0
    end

    return 1 + max(
        height(parent.left), 
        height(parent.right)
    )

end


function difference(parent)
    return height(parent.left) - height(parent.right)
end


function rightRotation(parent)

    if parent === parent.parent.left
        parent.parent.left = parent.left
    else
        parent.parent.right = parent.left
    end

    parent.left.right = parent
    parent.left.parent = parent.parent # dodane
    parent.parent = parent.left # dodane
    parent.left = nothing

end


function leftRotation(parent)

    if parent === parent.parent.left
        parent.parent.left = parent.right
    else
        parent.parent.right = parent.right
    end

    parent.right.left = parent
    parent.right.parent = parent.parent # dodane
    parent.parent = parent.right # dodane
    parent.right = nothing

end


function rightLeftRotation(parent)

    #println("=> right-left rotation")

    middle = parent.right
    parent.right = middle.left
    middle.left.parent = parent # dodane
    middle.parent = middle.left # dodane
    middle.left.right = middle
    middle.left = nothing

    leftRotation(parent)

end


function leftRightRotation(parent)

    middle = parent.left
    parent.left = middle.right
    middle.right.parent = parent # dodane
    middle.parent = middle.right # dodane
    middle.right.left = middle
    middle.right = nothing

    rightRotation(parent)

end


function balance(parent)

    balance_factor = difference(parent)

    #print("Balance factor for $(parent) is $(balance_factor) ")

    if balance_factor > 1
        difference(parent.left) > 0 ? leftRotation(parent) : leftRightRotation(parent)
        
    elseif balance_factor < -1
        difference(parent.right) > 0 ? rightLeftRotation(parent) : rightRotation(parent)
    end

end


function insertRec(root, to_insert)

    #print("Inserting $(to_insert) to $(root)")

    if to_insert.key < root.key

        #print(".left ")
        
        if root.left !== nothing
            #println("recursively")
            insertRec(root.left, to_insert)
        else
            #println("as new connection")
            root.left = to_insert
            to_insert.parent = root
        end

        balance(root)
    
    elseif to_insert.key >= root.key

        #print(".right ")
        
        if root.right !== nothing
            #println("recursively")
            insertRec(root.right, to_insert)
        else
            #println("as new connection")
            root.right = to_insert
            to_insert.parent = root
        end
        
        balance(root)
    end

end


function insert!(tree, key, value)

    newNode = Node(key, value)
    map[value] = newNode

    if tree.guard.right !== nothing
        insertRec(tree.guard.right, newNode)
        return
    end

    tree.guard.right = newNode
    tree.guard.right.parent = tree.guard
    return

end


function printTreeInOrder(tree)

    function printRec(node, message="")

        if node === nothing
            return
        end

        println(message, "key: $(node.key), value: $(node.value)")
        printRec(node.left, message * "\t")
        printRec(node.right, message * "\t")

        return

    end


    printRec(tree.guard.right)

end


function findMaxNode(node)

    curr = deepcopy(node)

    while curr.right !== nothing
        curr = curr.right
    end

    return curr

end


function findMinNode(node)

    curr = deepcopy(node)

    while curr.left !== nothing
        curr = curr.left
    end

    return curr

end


function findMax(tree)

    return findMaxNode(tree.guard.right)

end


function findMin(tree)

    return findMinNode(tree.guard.right)

end


function findSuccessorNode(node)

    if node.right !== nothing
        return findMinNode(node.right)
    end
    
    curr = deepcopy(node)

    while curr.parent !== nothing

        #print("curr = $(curr.value), ")
        #print("in loop... ")

        if curr.parent.left === curr
            return curr.parent
        end

        curr = curr.parent

    end

    return nothing

end


function findPredecessorNode(node)

    if node.left !== nothing
        return findMaxNode(node.left)
    end

    curr = deepcopy(node)

    while curr.parent !== nothing

        if curr.parent.right === curr
            return curr.parent.right
        end

        curr = curr.parent

    end

    return nothing

end


function monadicReturn(node)

    if node !== nothing
        return node.value
    end

    return nothing

end


function findSuccessor(tree, segment)

    return findSuccessorNode(tree.map[segment]) |> monadicReturn

end


function findPredecessor(tree, segment)

    return findPredecessorNode(tree.map[segment]) |> monadicReturn

end


function deleteNode(node)

    function replaceNode(node, new_node)  # paste new_node in node's place

        if node.parent.left === node
            node.parent.left = new_node
        else
            node.parent.right = new_node
        end

        if new_node !== nothing
            new_node.parent = node.parent
        end

    end


    if node.left !== nothing && node.right !== nothing

        successor = findSuccessorNode(node)
        replaceNode(node, successor)
        insertRec(successor, node.left)

    elseif node.left === nothing  # delete one-child-on-right node

        replaceNode(node, node.right)
    
    elseif node.right === nothing  # delete one-child-on-left node

        replaceNode(node, node.left)
    
    else # delete leaf

        replaceNode(node, nothing)
    
    end

end


function delete!(tree, segment)

    deleteNode(tree.map[segment])
    delete!(tree.map, segment)

end


end #module