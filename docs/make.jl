using Documenter, AssignOnce

makedocs(
    modules = [AssignOnce],
    format = Documenter.HTML(),
    checkdocs = :exports,
    sitename = "AssignOnce.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/goretkin/AssignOnce.jl.git",
)
