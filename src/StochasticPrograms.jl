__precompile__()
module StochasticPrograms

# Standard library
using LinearAlgebra
using SparseArrays
using Distributed
using Printf

# External libraries
using JuMP
using Distributions
using MathProgBase
using MacroTools
using MacroTools: @q, postwalk, prewalk
using Reexport
using ProgressMeter

import Base: getindex, length, in, issubset, show

const MPB = MathProgBase

export
    StochasticModel,
    StochasticProgram,
    Probability,
    AbstractScenario,
    Scenario,
    StageParameters,
    parameters,
    AbstractSampler,
    Sampler,
    ConfidenceInterval,
    StochasticSolution,
    AbstractStructuredSolver,
    AbstractStructuredModel,
    AbstractSampledSolver,
    AbstractSampledModel,
    StructuredModel,
    SampledModel,
    optimize_structured!,
    optimize_sampled!,
    fill_solution!,
    stochastic_solution,
    solverstr,
    internal_solver,
    Crash,
    CrashMethod,
    spsolver,
    spsolver_model,
    distributed,
    deferred,
    set_spsolver,
    internal_model,
    add_scenario!,
    add_scenarios!,
    scenarioproblems,
    decision_length,
    recourse_length,
    first_stage_nconstraints,
    first_stage_dims,
    nstages,
    scenario,
    scenarios,
    scenariotype,
    scenariotext,
    stage_parameters,
    stage_probability,
    probability,
    ExpectedScenario,
    expected,
    has_generator,
    generator,
    subproblem,
    subproblems,
    nsubproblems,
    parentmodel,
    masterterms,
    transfer_model!,
    nscenarios,
    AbstractSampler,
    sample,
    sampler,
    sample!,
    generate!,
    stage_one_model,
    stage_two_model,
    outcome_model,
    evaluate_decision,
    lower_bound,
    lower,
    upper,
    confidence,
    confidence_interval,
    lower_bound,
    upper_bound,
    gap,
    instantiate,
    optimize!,
    decision,
    optimal_decision,
    optimal_value,
    calculate_objective_value,
    @scenario,
    @sampler,
    @first_stage,
    @second_stage,
    @stage,
    @stochastic_model,
    @zero,
    @expectation,
    @sample,
    @decision,
    @parameters,
    @uncertain,
    WS,
    WS_decision,
    EWS,
    SAA,
    DEP,
    VRP,
    EVPI,
    EVP,
    EVP_decision,
    EV,
    EEV,
    VSS

macro exportJuMP()
    Expr(:export, names(JuMP)...)
end
@exportJuMP

include("types/types.jl")
include("methods/methods.jl")
include("spinterface.jl")
include("crash.jl")
include("solvers/solvers.jl")

end # module
