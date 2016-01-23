classdef Queue < handle
%INTERVAL A first in first out queue

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.
    
    properties (Access = private)
        buffer = [] % The data, stored as a row vector
        count  = 0  % Number of stored items
        tail   = 1  % Index of the first empty slot
    end
    
    methods
        
        function q = Queue()
        end
        
        function n = num_items(q)
            n = q.count;
        end
        
        function c = capacity(q)
            c = q.tail-1;
        end

        function push(q, item)
            assert(isequal(size(item), [1,1]));
            q.buffer(q.tail) = item;
            q.tail = q.tail + 1;
            q.count = q.count + 1;
        end
        
        function item = pop(q)
            if q.count<1
                error(...
                    'Queue:pop_empty_queue', ...
                    'Attempt to remove an item from an empty queue'); 
            end
            head_idx = q.tail - q.count;
            item = q.buffer(head_idx);
            q.count = q.count - 1;
            
            if q.shrink_required
                q.shrink_storage;
            end
        end
        
    end
    
    methods (Access = private)
        
        function result = shrink_required(q)
            smallest_capacity_to_shrink = 100;
            fill_ratio = q.num_items / q.capacity;
            result =...
                (fill_ratio<=0.5) &&...
                (q.capacity>=smallest_capacity_to_shrink);
        end
        
        function shrink_storage(q)
            first    = q.tail - q.count;
            last     = q.tail - 1;
            q.buffer = q.buffer(first:last);
            q.tail   = q.count + 1;
        end
            
    end
    
end
