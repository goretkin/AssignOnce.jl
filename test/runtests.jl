using AssignOnce
using Test


struct InvocationCounter{F}
    f::F
    counter::Ref{Int}
end

InvocationCounter(f) = InvocationCounter(f, Ref(0))

function (c::InvocationCounter)(args...; kwargs...)
    c.counter[] += 1
    c.f(args...; kwargs...)
end


@testset "check test purity 1" begin
    y = 3
end

@testset "check test purity 2" begin
    @test !isdefined(@__MODULE__, :y)
end

@testset "InvocationCounter" begin
    f = InvocationCounter(()->3)
    @test f.counter[] == 0
    @test f() == 3
    @test f.counter[] == 1
    @test f() == 3
    @test f.counter[] == 2
end


# TODO maybe generate a new module, so there is a new global scope, for each test set
@testset "does assignment" begin
    @assert !isdefined(@__MODULE__, :x)
    @assignonce x = 3
    @test isdefined(@__MODULE__, :x)
    @test x == 3
end

# `x` is used up.
# TODO, same thing. would be nice to have a new module scope so we can define `ff` in there

ff = InvocationCounter(()->3)
@testset "does assignment only once" begin
    @assert !isdefined(@__MODULE__, :y)
    @assert ff.counter[] == 0
    @assignonce y = ff()
    @test ff.counter[] == 1
    @assignonce y = ff()
    @test ff.counter[] == 1
    @test isdefined(@__MODULE__, :y)
    @test y == 3
end
