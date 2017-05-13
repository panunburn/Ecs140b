-- might also want to do some formatting here to make it print out pretty
rush_hour start = reverse (statesearch [start] [])


-- DFS state space search algorithm
-- largely inspired by pegpuzzle.hs

-- don't need goal parameter for this game
-- instead, use a check goal function

-- each state is a list of strings, 
-- so a list of states is a list of list of strings

statesearch :: [[String]] -> [[String]] -> [[String]]
-- state is head of unexplored list, it is the current node being processed
-- siblings is the tail of unexplored list, it contains sibling nodes to state
statesearch (state:siblings) path
    -- if nothing to process, backtrack to parent by retruning null
   | null (state:siblings)          = []
    -- if found goal, return solution to puzzle
   | isGoal state                   = state:path
    -- try to expand current node and contune DFS
   | (not (null processChildren))   = processChildren
    -- if no solution found (processChildren returned null)
    -- then move to next sibling node
   | otherwise                      = 
        statesearch siblings path
    -- define processChildren
    -- need to generate new states (children nodes) from current state
    -- also need to ensure no loops by making sure new states are not also in path
    -- the path to the child node is the path to the parent, plus the parent
     where processChildren = statesearch 
                       (generateNewStates state path) 
                       (state:path)


-- Check if state satisfies the goal.
-- The state meets the goal iff the last two characters 
-- of the third string in state are 'X'
isGoal :: [String] -> Bool
isGoal (_:_:(_:_:_:_:['X','X']):_) = True
isGoal notSolution = False

