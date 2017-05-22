-- might also want to do some formatting here to make it print out pretty
-- nevermind, he said we don't have to do that

-- load build-in sort function in haskell

module RushHour
(
rush_hour, statesearch, isGoal, generateNewStates, findNewRight, newRow,
generateNewRight, generateNewRightHelp, rowsToState, trimDuplicates, mirrorState,
mirrorAllStates, generateNewLeft, generateNewDown, generateNewUp, evalState,
compareStates, charPos, countChar
)   where 
import Data.List

rush_hour start = (reverse (statesearch [start] []))


-- DFS state space search algorithm
-- largely inspired by pegpuzzle.hs

-- don't need goal parameter for this game
-- instead, use a check goal function

-- each state is a list of strings, 
-- so a list of states is a list of list of strings

statesearch :: [[String]] -> [[String]] -> [[String]]
-- state is head of unexplored list, it is the current node being processed
-- siblings is the tail of unexplored list, it contains sibling nodes to state
-- states = (state:siblings)
statesearch states path
    -- if nothing to process, backtrack to parent by retruning null
   | null states          = []
    -- if found goal, return solution to puzzle
   | isGoal (head states)                   = (head states):path
    -- try to expand current node and contune DFS
   | (not (null processChildren))   = processChildren
    -- if no solution found (processChildren returned null)
    -- then move to next sibling node
   | otherwise                      = 
        statesearch (tail states) path
    -- define processChildren
    -- need to generate new states (children nodes) from current state
    -- also need to ensure no loops by making sure new states are not also in path
    -- the path to the child node is the path to the parent, plus the parent
     where processChildren = statesearch 
                       (generateNewStates (head states) path) 
                       ((head states):path)


-- Check if state satisfies the goal.
-- The state meets the goal iff the last two characters 
-- of the third string in state are 'X'
isGoal :: [String] -> Bool
isGoal (_:_:(_:_:_:_:['X','X']):_) = True
isGoal notSolution = False


-- From current states and previous states in path, 
-- generates all new possible states that are not
-- already in the path (to avoid cycles).
-- Assumes states are given in preprocessed format.
generateNewStates :: [String] -> [[String]] -> [[String]]
generateNewStates currState path
    | currState == []    = []
    | otherwise          = 
                          sortBy compareStates $ 
                           (trimDuplicates path (concat  [generateNewRight currState, generateNewDown currState,
                                                          generateNewUp currState, generateNewLeft currState]))


-- Finds position, length, and character represenation of a car that can be moved right
findNewRight :: String -> Char -> Int -> Int -> Int -> [(Char, Int, Int)] -> [(Char, Int, Int)]
-- below are the argument names
-- findNewRight currRow prevChar carLength carIndex currentIndex foundTuples

-- if get to empty list, return the information for movable cars found
findNewRight [] _ _ _ _ foundTuples = foundTuples
findNewRight ('-':cs) prevChar carLength carIndex currentIndex foundTuples
    | carLength > 1 = findNewRight cs '-' 0 0 (currentIndex + 1) ((prevChar, carLength, carIndex):foundTuples)
    | otherwise     = findNewRight cs '_' 0 0 (currentIndex + 1) foundTuples
findNewRight (c:cs) prevChar carLength carIndex currentIndex foundTuples
    | c == prevChar = findNewRight cs c (carLength + 1) carIndex     (currentIndex + 1) foundTuples
    | otherwise     = findNewRight cs c 1               currentIndex (currentIndex + 1) foundTuples

-- use a tuple returned by findNewRight to generate a new row
-- below are the argument names
-- newRow oldRow foundTuple index 
newRow :: String -> (Char, Int, Int) -> Int -> String
newRow [] _ _ = []
newRow (c:cs) (car, length, startIndex) currentIndex
  | currentIndex == startIndex = ('-':(newRow cs (car, length, startIndex) (currentIndex + 1)))
  | currentIndex > startIndex && currentIndex <= (startIndex + length)
                               = (car:(newRow cs (car, length, startIndex) (currentIndex + 1)))
  | otherwise                  = ( c :(newRow cs (car, length, startIndex) (currentIndex + 1)))


-- generating new move right states.
-- kinda brute forcing it, but whatev
generateNewRight :: [String] -> [[String]]
generateNewRight parentState = generateNewRightHelp [] parentState

-- pretty much appends new generated states from a row to generated states from previous rows
generateNewRightHelp :: [String] -> [String] -> [[String]]
generateNewRightHelp _ [] = []
generateNewRightHelp above (row:below)
    | null rowData = generateNewRightHelp (above ++ [row]) below
    | otherwise    = (rowsToState rowData above row below) ++ (generateNewRightHelp (above ++ [row]) below)
    where rowData = findNewRight row '-' 0 0 0 []

-- generates new states generated by a row 
rowsToState :: [(Char, Int, Int)] -> [String] -> String -> [String] -> [[String]]
rowsToState [] _ _ _ = []
rowsToState (t:ts) above row below = (above ++ [(newRow row t 0)] ++ below):(rowsToState ts above row below)

-- makes sure no cycles in search tree
-- trimDuplicates newStates path
trimDuplicates :: [[String]] -> [[String]] -> [[String]]
trimDuplicates _ [] = []
trimDuplicates path (state:ss) 
    | elem state path = trimDuplicates ss path
    | otherwise       = state:(trimDuplicates path ss)

-- probably can use map for these, but lol
mirrorState :: [String] -> [String]
mirrorState [] = []
mirrorState (h:t) = (reverse h):(mirrorState t)

mirrorAllStates :: [[String]] -> [[String]]
mirrorAllStates [] = []
mirrorAllStates (h:t) = (mirrorState h):(mirrorAllStates t)


generateNewLeft :: [String] -> [[String]]
generateNewLeft parentState = mirrorAllStates (generateNewRight (mirrorState parentState))
-- could have instead writting as follows
-- generateNewLeft parentState = map (map reverse) (generateNewRight (map reverse parentState))


-- this doesn't seem to be alredy imported in my terminal for some reason
-- so i'm copying the source code for transpose here
-- import the Data.List
-- transpose               :: [[a]] -> [[a]]
-- transpose []             = []
-- transpose ([]   : xss)   = transpose xss
-- transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

generateNewDown :: [String] -> [[String]]
generateNewDown parentState = map transpose (generateNewRight (transpose parentState))

generateNewUp :: [String] -> [[String]]
generateNewUp parentState = map transpose (generateNewLeft (transpose parentState))

-- heuristic part
-- evaluation is based on empty spaces to the right of "XX" + 5*(blocked spaces to the right of "XX")
-- lower is better
-- a greedy algorithm
evalState state
    | null state = 10000
    | otherwise  = emptyOnRight + 5 * blockOnRight
    where xtailpos = (charPos 'X' (state!!2));
          emptyOnRight = (countChar '-' (drop xtailpos (state!!2)))
          blockOnRight = (5 - xtailpos - emptyOnRight)

-- our own comparison function for evaluating states
compareStates s1 s2
    | (evalState s1) > (evalState s2) = GT
    | (evalState s2) > (evalState s1) = LT
    | otherwise                       = EQ
charPos:: Char -> String -> Int
charPos cha str
    | cha == (head str)  = 0
    | otherwise          = 1 + charPos cha (tail str)

countChar:: Char -> String -> Int
countChar cha str
    | null str           = 0
    | cha == (head str)  = 1 + countChar cha (tail str)
    | otherwise          = countChar cha (tail str)

