%lang starknet

# Hints

# Hints are the Cairo way to defer part of the program execution to an external program
# Memory can be accessed and assigned inside a hint by using variables identifiers.
# e.g., inside a hint variable `a` is accessed through `ids.a`

# TODO: Assign the value of `res` inside a hint.

func basic_hint() -> (value : felt):
    alloc_locals
    local res
    %{ ids.res = 42 %}
    # TODO: Insert hint here
    return (res)
end

# Do not change the test
@external
func test_basic_hint{syscall_ptr : felt*}():
    let (value) = basic_hint()
    assert 41 = value - 1
    return ()
end
