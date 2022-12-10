module AVLTrees
export Node, AVLTree, insert!, printTreeInOrder, findSuccessor, findPredecessor, delete!, reorder!

using BasicDataTypes

mutable struct Node
    key::Maybe{Float64}
    value::Maybe{Segment}
    left::Maybe{Node}
    right::Maybe{Node}
    parent::Maybe{Node}

    Node(_key, _value) = new(_key, _value, nothing, nothing, nothing)
end


mutable struct AVLTree
    guard::Node
    map::Dict{Segment, Node}

    AVLTree() = new(Node(nothing, nothing), Dict{Segment, Node}())
end


function height(parent::Maybe{Node})::Int16

    if parent ≡ nothing
        return 0
    end

    return 1 + max(
        height(parent.left), 
        height(parent.right)
    )

end


function difference(parent::Node)::Int16

    return height(parent.left) - height(parent.right)

end


function rightRotation(parent::Node)::Nothing

    if parent === parent.parent.left
        parent.parent.left = parent.left
    else
        parent.parent.right = parent.left
    end

    parent.left.right = parent
    parent.left.parent = parent.parent # dodane
    parent.parent = parent.left # dodane
    parent.left = nothing

    return nothing

end


function leftRotation(parent::Node)::Nothing

    if parent === parent.parent.left
        parent.parent.left = parent.right
    else
        parent.parent.right = parent.right
    end

    parent.right.left = parent
    parent.right.parent = parent.parent # dodane
    parent.parent = parent.right # dodane
    parent.right = nothing

    return nothing

end


function rightLeftRotation(parent::Node)::Nothing

    #println("=> right-left rotation")

    middle = parent.right
    parent.right = middle.left
    middle.left.parent = parent # dodane
    middle.parent = middle.left # dodane
    middle.left.right = middle
    middle.left = nothing

    leftRotation(parent)

    return nothing

end


function leftRightRotation(parent::Node)::Nothing

    middle = parent.left
    parent.left = middle.right
    middle.right.parent = parent # dodane
    middle.parent = middle.right # dodane
    middle.right.left = middle
    middle.right = nothing

    rightRotation(parent)

    return nothing

end


function balance(parent::Node)::Nothing

    balance_factor = difference(parent)
    child_factor = 0

    if balance_factor > 1
        child_factor = difference(parent.left)
        child_factor > 0 ? rightRotation(parent) : leftRightRotation(parent)
        
    elseif balance_factor < -1
        child_factor = difference(parent.right)
        child_factor > 0 ? rightLeftRotation(parent) : leftRotation(parent)
    end

    return nothing

end


function insertRec(root::Node, to_insert::Node)::Nothing

    if to_insert.key < root.key

        if root.left !== nothing
            insertRec(root.left, to_insert)
        else
            root.left = to_insert
            to_insert.parent = root
        end

        balance(root)
    
    elseif to_insert.key >= root.key

        if root.right !== nothing
            insertRec(root.right, to_insert)
        else
            root.right = to_insert
            to_insert.parent = root
        end
        
        balance(root)
    end

    return nothing

end


function insert!(tree::AVLTree, key::Float64, value::Segment)::Nothing

    newNode = Node(key, value)
    tree.map[value] = newNode

    if tree.guard.right !== nothing
        insertRec(tree.guard.right, newNode)
        return
    end

    tree.guard.right = newNode
    newNode.parent = tree.guard

    return nothing

end


function printRec(node::Node, message::String="", child::String="")::Nothing

    if node === nothing
        return
    end

    println(message, child, "key: $(node.key), value: $(node.value)")
    printRec(node.left, message * "\t", "left: ")
    printRec(node.right, message * "\t", "right: ")

    return nothing

end


function printTreeInOrder(tree::AVLTree)::Nothing

    printRec(tree.guard.right)
    return nothing

end


function findMaxNode(node::Node)::Node

    curr = deepcopy(node)

    while curr.right !== nothing
        curr = curr.right
    end

    return curr

end


function findMinNode(node::Node)::Node

    curr = deepcopy(node)

    while curr.left !== nothing
        curr = curr.left
    end

    return curr

end


function findMax(tree::AVLTree)::Node

    return findMaxNode(tree.guard.right)

end


function findMin(tree::AVLTree)::Node

    return findMinNode(tree.guard.right)

end


function findSuccessorNode(tree::AVLTree, node::Node)::Maybe{Node}

    if node.right !== nothing
        return findMinNode(node.right)
    end
    
    curr = deepcopy(node)

    while curr.parent !== nothing && curr.parent !== tree.guard.right

        #print("curr = $(curr.value), ")
        #print("in loop... ")

        if curr.parent.left === curr
            return curr.parent
        end

        curr = curr.parent

    end

    return nothing

end


function findPredecessorNode(tree::AVLTree, node::Node)::Maybe{Node}

    if node.left !== nothing
        return findMaxNode(node.left)
    end

    curr = deepcopy(node)

    while curr.parent !== nothing && curr.parent !== tree.guard.right

        if curr.parent.right === curr
            return curr.parent
        end

        curr = curr.parent

    end

    return nothing

end


function monadicReturn(node::Maybe{Node})::Maybe{Segment}

    if node !== nothing
        return node.value
    end

    return nothing

end


function findSuccessor(tree::AVLTree, segment::Segment)::Maybe{Segment}

    return findSuccessorNode(tree,tree.map[segment]) |> monadicReturn

end


function findPredecessor(tree::AVLTree, segment::Segment)::Maybe{Segment}

    return findPredecessorNode(tree, tree.map[segment]) |> monadicReturn

end


function deleteNode(tree::AVLTree, node::Node)::Nothing

    function replaceNode(node, new_node)::Nothing  # paste new_node in node's place

        if node.parent.left === node
            node.parent.left = new_node
        else
            node.parent.right = new_node
        end

        if new_node !== nothing
            new_node.parent = node.parent
        end

        return nothing

    end


    if node.left !== nothing && node.right !== nothing

        successor = findSuccessorNode(tree, node)
        replaceNode(node, successor)
        insertRec(successor, node.left)
        #balance(node.left)

    elseif node.left === nothing  # delete one-child-on-right node

        replaceNode(node, node.right)
    
    elseif node.right === nothing  # delete one-child-on-left node

        replaceNode(node, node.left)
    
    else # delete leaf

        replaceNode(node, nothing)
    
    end

    return nothing

end


function delete!(tree::AVLTree, segment::Segment)::Nothing

    deleteNode(tree, tree.map[segment])
    Base.delete!(tree.map, segment)

    return nothing

end


function reorder!(tree::AVLTree, getNewKey::Function)::Nothing

    # Reorder elements in tree:
    activeSegments = []

    for key in keys(tree.map)
        push!(activeSegments, tree.map[key].value)
        Base.delete!(tree.map, key)
    end

    tree.guard.right = nothing

    for segment in activeSegments
        AVLTrees.insert!(tree, getNewKey(segment), segment)
    end 

    return nothing

end


end #module