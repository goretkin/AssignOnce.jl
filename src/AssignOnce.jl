module AssignOnce

export @assignonce

import MacroTools

"""
match e.g. `x = rhs` but not e.g. `(x, y) = rhs`
"""
function match_simple_assignment(ex)
    MacroTools.@capture(ex,
        lhs_Symbol = rhs_
    )
    return (lhs=lhs, rhs=rhs)
end

"""
If you want to execute the same script multiple times as you develop it, but have a few expensive statements that need to be executed just once (e.g. load a dataset) you can do

`@assignonce x = load_data()`

TODO: give error if not called from a global (i.e. module) scope
"""
macro assignonce(ex)
  global lhs
  (lhs, rhs) = match_simple_assignment(ex)

  assignment = :($lhs = $(rhs))
  @assert assignment == ex
  # quote to avoid macro hygiene since these expressions are to be evaluated in the macro invocation scope
  lhs_quote = QuoteNode(lhs)
  ex_quote = QuoteNode(ex)
  # expand string interpolations at parse time: https://github.com/JuliaLang/julia/issues/1557#issuecomment-10503787
  exec_msg = "executing $ex"
  skip_msg = "skipping $ex"
  quote
    if !isdefined(@__MODULE__, $lhs_quote)
      println($exec_msg)
      (@__MODULE__).eval($ex_quote)
      println("\tcomplete")
    else
      println($skip_msg)
    end
  end
end


end # module
