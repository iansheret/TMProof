function tests = test_Queue
%TEST_QUEUE Unit tests for the Queue class.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_queue_is_initially_empty(test_case)
q = Queue;
verifyEqual(test_case, q.num_items, 0);
end

function test_added_item_is_stored(test_case)
q = Queue;
q.push(12);
verifyEqual(test_case, q.num_items, 1);
end

function test_pop_on_empty_queue_is_an_error(test_case)
q = Queue;
f = @() q.pop();
verifyError(test_case, f, 'Queue:pop_empty_queue');
end

function test_retrieved_item_is_correct(test_case)
q = Queue;
q.push(12);
x = q.pop();
verifyEqual(test_case, x, 12);
end

function test_retrieving_item_reduces_the_number_of_items(test_case)
q = Queue;
q.push(12);
q.pop();
verifyEqual(test_case, q.num_items, 0);
end

function test_items_come_out_in_the_right_order(test_case)
q = Queue;
q.push(11);
q.push(12);
q.push(13);
a = q.pop();
q.push(14);
b = q.pop();
c = q.pop();
d = q.pop();
verifyEqual(test_case, a, 11);
verifyEqual(test_case, b, 12);
verifyEqual(test_case, c, 13);
verifyEqual(test_case, d, 14);
end

function test_capacity_shrinks_when_half_is_unused(test_case)
q = Queue;
for i=1:100
    q.push(0);
end
for i=1:50
    q.pop();
    capacity(i) = q.capacity;
end
expected_capacity(1:49) = 100;
expected_capacity(50)  = 50;
verifyEqual(test_case, capacity, expected_capacity);
end

function test_capacity_doesnt_shrink_when_below_threshold(test_case)
q = Queue;
for i=1:99
    q.push(0);
end
for i=1:99
    q.pop();
    capacity(i) = q.capacity;
end
expected_capacity(1:99) = 99;
verifyEqual(test_case, capacity, expected_capacity);
end

function test_correct_elements_are_retrieved_after_shrink(test_case)
q = Queue;
for i=1:100
    q.push(i+12);
end
for i=1:100
    x(i) = q.pop();
end
expected_x = 13:112;
verifyEqual(test_case, x, expected_x);
end

function test_queue_can_handle_structs(test_case)
q = Queue;
obj.field = 12;
q.push(obj);
verifyEqual(test_case, q.pop, obj);
end