-- single line comment
{-
    block comment
-}

myremoveduplicates :: (Eq a) => [a] -> [a]
myremoveduplicates inlist
    | null inlist                        = []
    | elem (head inlist) (tail inlist)   = myremoveduplicates (tail inlist) 
    | otherwise                          = (head inlist) : (myremoveduplicates (tail inlist))


myremoveduplicates_pm :: (Eq a) => [a] -> [a]
myremoveduplicates_pm [] = []
myremoveduplicates_pm (x:xs)
    | elem x xs = myremoveduplicates_pm xs
    | otherwise = x : (myremoveduplicates_pm xs)

myintersection :: (Eq a) => [a] -> [a] -> [a]
myintersection set1 set2
    | null set1             = []
    | elem (head set1) set2 = (head set1) : myintersection (tail set1) set2
    | otherwise             = myintersection (tail set1) set2

myintersection_pm :: (Eq a) => [a] -> [a] -> [a]
myintersection_pm [] _ = []
myintersection_pm (x:xs) set2
    | elem x set2 = x : (myintersection_pm xs set2)
    | otherwise   = myintersection_pm xs set2

mylast :: [a] -> [a]
mylast inlist
    | null inlist        = []
    | null (tail inlist) = (head inlist) : []
    | otherwise          = mylast (tail inlist) 

mylast_pm :: [a] -> [a]
mylast_pm []     = []
mylast_pm (x:[]) = [x]
mylast_pm (_:xs) = mylast_pm xs

myreverse :: [a] -> [a]
myreverse inlist = myreverse_help inlist []

myreverse_help :: [a] -> [a] -> [a]
myreverse_help inlist outlist
    | null inlist = outlist
    | otherwise   = myreverse_help (tail inlist) ((head inlist):outlist)

myreverse_pm :: [a] -> [a]
myreverse_pm inlist = myreverse_pm_help inlist []

myreverse_pm_help :: [a] -> [a] -> [a]
myreverse_pm_help [] outlist     = outlist
myreverse_pm_help (x:xs) outlist = myreverse_pm_help xs (x:outlist) 

myreplaceall :: (Eq a) => a -> a -> [a] -> [a]
myreplaceall new old inlist
    | null inlist            = []
    | old == (head inlist)   = new : (myreplaceall new old (tail inlist))
    | otherwise              = (head inlist) : (myreplaceall new old (tail inlist))

myreplaceall_pm :: (Eq a) => a -> a -> [a] -> [a]
myreplaceall_pm _ _ [] = []
myreplaceall_pm new old (x:xs)
    | old == x  = new : (myreplaceall_pm new old xs)
    | otherwise = x : (myreplaceall_pm new old xs) 

