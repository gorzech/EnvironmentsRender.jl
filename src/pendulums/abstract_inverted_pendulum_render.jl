function xycoords(state::PendulumState, ipd::PendulumData)
    x = state.y[1]
    θ = state.y[3]
    cart = [
        Point2f(x - ipd.length, -0.04),
        Point2f(x - ipd.length, 0.04),
        Point2f(x + ipd.length, 0.04),
        Point2f(x + ipd.length, -0.04),
    ]
    xi, yi = [x, 0] + 2ipd.length * [-1, 1] .* sincos(θ)
    pole = [Point2f(x, 0.0), Point2f(xi, yi)]
    for i = 5:2:pendulum_env_state_size(state)
        θ = state.y[i]
        xi, yi = [xi, yi] + 2ipd.length * [-1, 1] .* sincos(θ)
        push!(pole, Point2f(xi, yi))
    end
    return cart, pole
end

function render!(env::PendulumEnv)
    @assert !isnothing(env.state) "Call reset before using render function."
    if isnothing(env.screen)
        c, p = xycoords(env.state, env.data)
        cart = Observable(c)
        pole = Observable(p)

        fig = Figure()
        display(fig)
        ax = Axis(fig[1, 1])
        xlims!(ax, -env.opts.x_threshold, env.opts.x_threshold)
        ylims!(ax, -0.06, (pendulum_env_state_size(env) - 2 + 0.1) * env.data.length)
        ax.aspect = DataAspect()

        poly!(ax, cart, color=:grey, strokecolor=:black, strokewidth=1)
        lines!(ax, pole; linewidth=12, color=:red)
        scatter!(
            ax,
            pole;
            marker=:circle,
            strokewidth=2,
            strokecolor=:red,
            color=:red,
            markersize=36
        )
        env.screen = [cart, pole]
    end
    # cart and pole observables
    env.screen[1][], env.screen[2][] = xycoords(env.state, env.data)
    sleep(0.01)
    nothing
end