%lang starknet
from starkware.cairo.common.math_cmp import is_le

# TODO
# Rewrite those functions with a high level syntax
@external
func sum_array(array_len : felt, array : felt*) -> (sum : felt):
    # [ap] = [fp - 4]; ap++
    # [ap] = [fp - 3]; ap++
    # [ap] = 0; ap++
    # call rec_sum_array
    # ret
    return rec_sum_array(array_len, array, 0)
end

func rec_sum_array(array_len : felt, array : felt*, sum : felt) -> (sum : felt):
    # jmp continue if [fp - 5] != 0

    # stop:
    # [ap] = [fp - 3]; ap++
    # jmp done

    # continue:
    # [ap] = [[fp - 4]]; ap++
    # [ap] = [fp - 5] - 1; ap++
    # [ap] = [fp - 4] + 1; ap++
    # [ap] = [ap - 3] + [fp - 3]; ap++
    # call rec_sum_array

    # done:
    # ret

    if array_len != 0:
        return rec_sum_array(array_len - 1, array + 1, [array] + sum)
    else:
        return (sum)
    end
end

# TODO
# Rewrite this function with a low level syntax
# It's possible to do it with only registers, labels and conditional jump. No reference or localvar
@external
func max{range_check_ptr}(a : felt, b : felt) -> (max : felt):
    # let (res) = is_le(a, b)
    # if res == 1:
    #     return (b)
    # else:
    #     return (a)
    # end

    [ap] = [fp - 5]; ap++ # range_check_ptr
    [ap] = [fp - 4]; ap++
    [ap] = [fp - 3]; ap++
    call is_le

    # is_le returns values in [ap - 1] and [ap - 2]
    [ap] = [ap - 2]; ap++ # we push the range_check_ptr into the stack
    # this next [ap - 2] refers to the previous [ap - 1] (the is_le boolean) as far as we pushed the range_check_ptr
    jmp b_is_max if [ap - 2] != 0 # != because I assume it's easier for Cairo CPU, and 0 for same reason 

    a_is_max:
    [ap] = [fp - 4]; ap++ # return a
    jmp done

    b_is_max:
    [ap] = [fp - 3]; ap++ # return b
    
    done:
    ret

end

#########
# TESTS #
#########

from starkware.cairo.common.alloc import alloc

@external
func test_max{range_check_ptr}():
    let (m) = max(21, 42)
    assert m = 42
    let (m) = max(42, 21)
    assert m = 42
    return ()
end

@external
func test_sum():
    let (array) = alloc()
    assert array[0] = 1
    assert array[1] = 2
    assert array[2] = 3
    assert array[3] = 4
    assert array[4] = 5
    assert array[5] = 6
    assert array[6] = 7
    assert array[7] = 8
    assert array[8] = 9
    assert array[9] = 10

    let (s) = sum_array(10, array)
    assert s = 55

    return ()
end
