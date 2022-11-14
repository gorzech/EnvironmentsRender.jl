module EnvironmentsRender
using Environments
using Environments: PendulumState, PendulumData, PendulumEnv, pendulum_env_state_size
import Environments: render!

using GLMakie

# Write your package code here.
include("pendulums/abstract_inverted_pendulum_render.jl")

end
