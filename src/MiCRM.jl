module MiCRM

import DifferentialEquations

include("./Parameters.jl")
include("./dx.jl")
include("./MiCRMProblem.jl")

function greet()
	print("hi")
end

end
