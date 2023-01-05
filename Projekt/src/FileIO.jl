module FileIO
export readPointsFromFile, saveResultToFile!, savePlotToFile!

using BasicDatatypes: Point, PointList, Interval, Maybe
using Queries: Constraint, constraintToString
using Plots: savefig


function readPointsFromFile(filename::String)::PointList

    local convert = record::String -> parse.(Float64, split(record, [',']))

    list::PointList = []

    try
        open(filename) do file
            while !eof(file)
                push!(list, convert(file))
            end
        end
        
        return list

    catch Exception  # Safety level: Data Science
        println(Exception)
        return []
    end

end


function saveResultToFile!(filename::String, points::PointList, constraint::Maybe{Constraint} = nothing)::Nothing

    local commentConstraint = _constraint::Maybe{Constraint} -> _constraint !== nothing ? ["Points satisfing constraint $(constraintToString(constraint))"] : []

    writedlm("$(filename).txt", [commentConstraint(constraint) ; points], ',')

end


function savePlotToFile!(filename::String)::Nothing

    savefig("$(filename).png")
    
    return nothing

end


end #module