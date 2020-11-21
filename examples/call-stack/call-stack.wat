(module
  ;; import console helper functions
  (import "console" "logInt" (func $console.logInt (param i32)))
  (import "console" "logString" (func $console.logString (param i32)))
  (import "console" "debugMemory" (func $console.debugMemory ))
  
  ;; import memory
  (import "js" "memory" (memory 1))
  
  (global $STACK_POINTER (mut i32) (i32.const 16))
  (global $FRAME_POINTER (mut i32) (i32.const 16))
  (global $STACK_ORIGIN i32 (i32.const 16))
  (global $STACK_ITEM_LEN i32 (i32.const 4))
  (data (i32.const 4) "strn")
  (func $setup
    (i32.store (i32.const 0) (i32.const 4)) ;; store len of str
  )
  
  (func $pushCallStack (param $newValue i32)
    ;; store new value
    (i32.store (global.get $STACK_POINTER) (local.get $newValue))
    ;; increment stack pointer
    (global.set $STACK_POINTER (i32.add (global.get $STACK_POINTER) (global.get $STACK_ITEM_LEN)) )
  )
  (func $popCallStack (result i32) (local $DEBUG i32)
    ;; decrement stack pointer
    (global.set $STACK_POINTER (i32.sub (global.get $STACK_POINTER) (global.get $STACK_ITEM_LEN)) )
    
    ;; get current value
    (i32.load (global.get $STACK_POINTER))
    local.set $DEBUG
    (i32.store (global.get $STACK_POINTER) (i32.const 0)) ;; we write over the value with zeroes for easy debugging but in practice this isn't required, we just have to mark it as free
    local.get $DEBUG
  )
  (func $stackFrameInit
    (local $prevFramePointer i32)
    (local.set $prevFramePointer (global.get $FRAME_POINTER))
    (global.set $FRAME_POINTER (global.get $STACK_POINTER))
    ;; add pointer to previouse frame
    local.get $prevFramePointer
    call $pushCallStack
  )
  (func $clearStackFrame (local $newFramePointer i32)
    ;; only run if the stack has some content
    global.get $FRAME_POINTER
    global.get $STACK_POINTER
    i32.lt_u
    if
  		loop
    		;; pop until we've reached the frame pointer
    		call $popCallStack
    		local.set $newFramePointer ;; we only use this for the last one, but this ensures it will work on the last one
    
    		;; this will re-run the loop if they aren't equal
    		global.get $FRAME_POINTER
    		global.get $STACK_POINTER
    		i32.lt_u
    		br_if 0
    		;; if it doesn't branch
    		;; set FRAME_POINTER to newFramePointer
    		local.get $newFramePointer
    		global.set $FRAME_POINTER
   		end
    end
  )
  (func $getOnStack (param $offset i32) (result i32) (local $returnVal i32)
    (global.set $STACK_POINTER (i32.sub (global.get $STACK_POINTER) (local.get $offset)) )
    (i32.load (global.get $STACK_POINTER))
    local.set $returnVal
    (global.set $STACK_POINTER (i32.add (global.get $STACK_POINTER) (local.get $offset)) )
    local.get $returnVal
  )
  (func $getPointerOnStack (param $offset i32)(result i32)
    global.get $STACK_POINTER
    local.get $offset
    i32.sub
  )
  (func (export "main")
    call $setup
    call $stackFrameInit
    
    (i32.load (i32.const 0)) ;; new val
    call $pushCallStack
    
    (i32.load (i32.const 4)) ;; new val
    call $pushCallStack
    
    i32.const 8 ;; negative offset from pointer
    call $getPointerOnStack
    call $console.logString
    
    call $console.debugMemory
    
    call $clearStackFrame
    call $console.debugMemory
  )
)