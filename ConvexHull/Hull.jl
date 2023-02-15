module Hull
export convex_hull

using BasicDatatypes: PointList
using Graham: convex_hull_graham
using Jarvis: convex_hull_jarvis


const methods = Dict(
    :graham => convex_hull_graham,
    :jarvis => convex_hull_jarvis
)


function convex_hull(points::PointList; method::Symbol, accuracy::Float64 = 1e-09)::PointList

    return methods[method](points, accuracy = accuracy)

end

end #module