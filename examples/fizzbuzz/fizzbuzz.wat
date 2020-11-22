(module
  ;; TODO: import the copy & strConcat functions instead of having them here

  ;; import console helper functions
  (import "console" "logString" (func $console.logString (param $offset i32)))
  (import "console" "logInt" (func $console.logInt (param i32)))
  ;; import memory
  (import "js" "memory" (memory 1))
  
  (global $fizzOffset i32 (i32.const 0))
  (global $buzzOffset i32 (i32.const 8))
  
  (data (i32.const 4) "Fizz")
  (data (i32.const 12) "Buzz")
  (func $copy (param $currentOffset i32) (param $newOffset i32) (param $length i32) (local $i i32)
    (local.set $i (i32.const 0))
	loop $l
    
    	(i32.store (i32.add (local.get $newOffset) (local.get $i)) (i32.load (i32.add (local.get $currentOffset) (local.get $i))) )
    
    	(local.set $i (i32.add (i32.const 1) (local.get $i)) )
    	local.get $i
    	local.get $length
    	i32.le_u
    	br_if $l
    end
  )
  (func $strConcat 
    (param $offset1 i32) (param $length1 i32)
    (param $offset2 i32) (param $length2 i32)
    (param $newOffset i32) (result i32)
    (local $newLength i32)
    
    
    local.get $offset1
    local.get $newOffset
    local.get $length1
    call $copy
    (i32.add (i32.const 4) (local.get $offset2) ) ;; the const 4 is the size of a length indicator
    (i32.add (local.get $newOffset) (i32.add (i32.const 4 (; size of the length int ;) ) (local.get $length1)) )
    local.get $length2
    call $copy
    
    (local.set $newLength (i32.add (local.get $length1) (local.get $length2)) )
    
    (i32.store (local.get $newOffset) (local.get $newLength)) 
    
    local.get $newLength
  )
  (func (export "main") (local $iterations i32) (local $divBy3 i32) (local $divBy5 i32)
    (i32.store (global.get $fizzOffset) (i32.const 4)) ;; fizz length
    (i32.store (global.get $buzzOffset) (i32.const 4)) ;; buzz length
    
    (local.set $iterations (i32.const 1))
    
    loop $loop
    	(local.set $divBy3 (i32.eq (i32.rem_u (local.get $iterations) (i32.const 3)) (i32.const 0)))
    	(local.set $divBy5 (i32.eq (i32.rem_u (local.get $iterations) (i32.const 5)) (i32.const 0)))
    
    	(i32.and (local.get $divBy3) (local.get $divBy5))
    	if
    		;; concat the strings
    		global.get $fizzOffset
    		i32.const 4
    		global.get $buzzOffset
    		i32.const 4
    		i32.const 16
    		call $strConcat
    		drop
    
    		i32.const 16
    		call $console.logString
    	else
    		local.get $divBy3
    		if
    			global.get $fizzOffset
    			call $console.logString
    		else
    			local.get $divBy5
    			if
    				global.get $buzzOffset
    				call $console.logString
    			else
    				local.get $iterations
    				call $console.logInt
    			end
    		end
    	end
    
    	
    	(local.set $iterations (i32.add (local.get $iterations) (i32.const 1)))
    
    	local.get $iterations
    	i32.const 100
    	i32.le_u
    	br_if $loop
    end
  )
)