# VectorAffineDecisionFunction #
# ========================== #
mutable struct VectorAffineDecisionConstraintBridge{T, S} <: MOIB.Constraint.AbstractBridge
    constraint::CI{MOI.VectorAffineFunction{T}, S}
    decision_function::VectorAffineDecisionFunction{T}
    set::S
end

function MOIB.Constraint.bridge_constraint(::Type{VectorAffineDecisionConstraintBridge{T, S}},
                                           model,
                                           f::VectorAffineDecisionFunction{T},
                                           set::S) where {T, S}
    # All decisions have been mapped to the variable part terms
    # at this point.
    F = MOI.VectorAffineFunction{T}
    # Add the bridged constraint
    constraint = MOI.add_constraint(model,
                                    f.variable_part,
                                    set)
    # Save the constraint index, the decision function, and the set, to allow modifications
    return VectorAffineDecisionConstraintBridge{T, S}(constraint, f, set)
end

function MOI.supports_constraint(::Type{<:VectorAffineDecisionConstraintBridge{T}},
                                 ::Type{<:VectorAffineDecisionFunction{T}},
                                 ::Type{<:MOI.AbstractVectorSet}) where {T}
    return true
end
function MOIB.added_constrained_variable_types(::Type{<:VectorAffineDecisionConstraintBridge})
    return Tuple{DataType}[]
end
function MOIB.added_constraint_types(::Type{<:VectorAffineDecisionConstraintBridge{T, S}}) where {T, S}
    return [(MOI.VectorAffineFunction{T}, S)]
end
function MOIB.Constraint.concrete_bridge_type(::Type{<:VectorAffineDecisionConstraintBridge{T}},
                                              ::Type{<:VectorAffineDecisionFunction{T}},
                                              S::Type{<:MOI.AbstractVectorSet}) where T
    return VectorAffineDecisionConstraintBridge{T, S}
end

MOI.get(b::VectorAffineDecisionConstraintBridge{T, S}, ::MOI.NumberOfConstraints{MOI.VectorAffineFunction{T}, S}) where {T, S} = 1
MOI.get(b::VectorAffineDecisionConstraintBridge{T, S}, ::MOI.ListOfConstraintIndices{MOI.VectorAffineFunction{T}, S}) where {T, S} = [b.constraint]

function MOI.get(model::MOI.ModelLike, attr::MOI.ConstraintFunction,
                 bridge::VectorAffineDecisionConstraintBridge{T}) where T
    f = bridge.decision_function
    # Remove mapped variables to properly unbridge
    from_decision(v) = begin
        result = any(t -> t.variable_index == v, f.decision_part.terms)
    end
    g = VectorAffineDecisionFunction(
        MOIU.filter_variables(v -> !from_decision(v), f.variable_part),
        copy(f.decision_part))
    return g
end

function MOI.get(model::MOI.ModelLike, attr::MOI.ConstraintSet,
                 bridge::VectorAffineDecisionConstraintBridge{T}) where T
    return bridge.set
end

function MOI.get(model::MOI.ModelLike, attr::MOI.ConstraintPrimal,
                 bridge::VectorAffineDecisionConstraintBridge{T}) where T
    return MOI.get(model, attr, bridge.constraint)
end

function MOI.get(model::MOI.ModelLike, attr::MOI.ConstraintDual,
                 bridge::VectorAffineDecisionConstraintBridge{T}) where T
    return MOI.get(model, attr, bridge.constraint)
end

function MOI.get(model::MOI.ModelLike, ::DecisionIndex,
                 bridge::VectorAffineDecisionConstraintBridge{T}) where T
    return bridge.constraint
end

function MOI.delete(model::MOI.ModelLike, bridge::VectorAffineDecisionConstraintBridge)
    MOI.delete(model, bridge.constraint)
    return nothing
end

function MOI.set(model::MOI.ModelLike, ::MOI.ConstraintFunction,
                 bridge::VectorAffineDecisionConstraintBridge{T,S},
                 f::VectorAffineDecisionFunction{T}) where {T,S}
    # Update bridge functions and function constant
    bridge.decision_function = f
    # Modify constraint function
    MOI.set(model, MOI.ConstraintFunction(), bridge.constraint,
            f.variable_part)
    return nothing
end

function MOI.set(model::MOI.ModelLike, ::MOI.ConstraintSet,
                 bridge::VectorAffineDecisionConstraintBridge{T,S}, change::S) where {T,S}
    f = bridge.decision_function
    bridge.set = change
    MOI.set(model, MOI.ConstraintSet(), bridge.constraint, change)
    return nothing
end

function MOI.modify(model::MOI.ModelLike, bridge::VectorAffineDecisionConstraintBridge{T,S}, change::MOI.VectorConstantChange) where {T,S}
    f = bridge.decision_function
    # Modify variable part of decision function
    f.variable_part.constants .= change.new_constant
    MOI.set(model, MOI.ConstraintFunction(), bridge.constraint,
            f.variable_part)
    return nothing
end

function MOI.modify(model::MOI.ModelLike, bridge::VectorAffineDecisionConstraintBridge{T,S}, change::MOI.MultirowChange) where {T,S}
    f = bridge.decision_function
    # Modify variable part of decision function
    modify_coefficients!(f.variable_part.terms, change.decision, change.new_coefficients)
    # Modify decision part if variable originated from a decision
    if !isempty(findall(t -> t.scalar_term.variable_index == change.variable, f.decision_part.terms))
        modify_coefficients!(f.decision_part.terms, change.variable, change.new_coefficients)
    end
    # Modify the variable part of the constraint as usual
    MOI.modify(model, bridge.constraint, change)
    return nothing
end

function MOI.modify(model::MOI.ModelLike, bridge::VectorAffineDecisionConstraintBridge{T,S}, change::DecisionMultirowChange) where {T,S}
    f = bridge.decision_function
    # Update the decision coefficient
    modify_coefficients!(f.decision_part.terms, change.decision, change.new_coefficients)
    # Update mapped variable through MultiRowChange
    MOI.modify(model, bridge, MOI.MultiRowChange(change.decision, change.new_coefficients))
    return nothing
end
