abstract type AbstractExecution end
# Execution API #
# ------------------------------------------------------------
nthetas(lshaped::AbstractLShapedSolver) = nthetas(lshaped, lshaped.execution)
initialize_subproblems!(lshaped::AbstractLShapedSolver, scenarioproblems::AbstractScenarioProblems, x::AbstractVector, subsolver::MPB.AbstractMathProgSolver) = initialize_subproblems!(lshaped.execution, scenarioproblems, x, subsolver)
finish_initilization!(lshaped::AbstractLShapedSolver) = finish_initilization!(lshaped, lshaped.execution)
iterate!(lshaped::AbstractLShapedSolver) = iterate!(lshaped, lshaped.execution)
start_workers!(lshaped::AbstractLShapedSolver) = start_workers!(lshaped, lshaped.execution)
close_workers!(lshaped::AbstractLShapedSolver) = close_workers!(lshaped, lshaped.execution)
resolve_subproblems!(lshaped::AbstractLShapedSolver) = resolve_subproblems!(lshaped, lshaped.execution)
current_decision(lshaped::AbstractLShapedSolver) = current_decision(lshaped, lshaped.execution)
calculate_objective_value(lshaped::AbstractLShapedSolver) = calculate_objective_value(lshaped, lshaped.execution)
timestamp(lshaped::AbstractLShapedSolver) = timestamp(lshaped, lshaped.execution)
incumbent_decision(lshaped::AbstractLShapedSolver, t::Integer, regularizer::AbstractRegularization) = incumbent_decision(lshaped, t, regularizer, lshaped.execution)
incumbent_objective(lshaped::AbstractLShapedSolver, t::Integer, regularizer::AbstractRegularization) = incumbent_objective(lshaped, t, regularizer, lshaped.execution)
incumbent_trustregion(lshaped::AbstractLShapedSolver, t::Integer, regularizer::AbstractRegularization) = incumbent_trustregion(lshaped, t, regularizer, lshaped.execution)
readd_cuts!(lshaped::AbstractLShapedSolver, consolidation::Consolidation) = readd_cuts!(lshaped, consolidation, lshaped.execution)
subobjectives(lshaped::AbstractLShapedSolver) = subobjectives(lshaped, lshaped.execution)
set_subobjectives(lshaped::AbstractLShapedSolver, Qs::AbstractVector) = set_subobjectives(lshaped, Qs, lshaped.execution)
model_objectives(lshaped::AbstractLShapedSolver) = model_objectives(lshaped, lshaped.execution)
set_model_objectives(lshaped::AbstractLShapedSolver, Qs::AbstractVector) = set_model_objectives(lshaped, Qs, lshaped.execution)
fill_submodels!(lshaped::AbstractLShapedSolver, scenarioproblems::AbstractScenarioProblems) = fill_submodels!(lshaped, scenarioproblems, lshaped.execution)

# ------------------------------------------------------------
include("common.jl")
include("serial.jl")
include("distributed.jl")
include("synchronous.jl")
include("asynchronous.jl")
