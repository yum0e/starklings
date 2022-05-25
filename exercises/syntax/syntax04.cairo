%lang starknet

# Function and other definitions can be scoped in namespaces, making the code more readable.

# TODO: make the test pass!

# Do not change anything but the test
namespace my_namespace:
    func returns_something() -> (result : felt):
        return (42)
    end

    # Change the following test to make it pass
    @external
    func test_hello{syscall_ptr : felt*}():
        let (result) = returns_something()
        assert result = 42
        return ()
    end
end


