--program assignment 2
--Weiran Guo(912916431)

myremoveduplicates l1
  | l1 == [] = []
  | (elem (head l1) (tail l1)) = myremoveduplicates (tail l1)
  | otherwise = (head l1):(myremoveduplicates (tail l1))

myremoveduplicates_pm [] = []
myremoveduplicates_pm (x:xs) | (elem x xs) = myremoveduplicates_pm xs
myremoveduplicates_pm (x:xs) = x:(myremoveduplicates_pm xs)

myintersection l1 l2
  | l1 == [] || l2 == [] = []
  | (elem (head l1) l2) = myappend [head l1] (myintersection (tail l1) l2)
  | otherwise = myintersection (tail l1) l2

myintersection_pm [] l2 = []
myintersection_pm l1 [] = []
myintersection_pm (x1:xs1) l2 | (elem x1 l2) = x1:(myintersection_pm xs1 l2)
myintersection_pm (x1:xs1) l2 = myintersection_pm xs1 l2

--   | elem (head (mylast list) 
-- mylast :: String -> String
mylast list
   | list == [] = list
   | (tail list) == [] = ([head list])
   | otherwise = mylast (tail list)

mylast_pm [] = []
mylast_pm (x:[]) = [x]
mylast_pm (x:xs) = mylast_pm xs

myreverse list
  | list == [] = []
  | otherwise = myappend (myreverse (tail list)) ([head list])

myreverse_pm [] = []
myreverse_pm (x:[]) = [x]
myreverse_pm (x:xs) = myappend_pm (myreverse xs) [x]

myreplaceall n1 n2 list
  | list == [] = []
  | (head list) == n2 = n1:(myreplaceall n1 n2 (tail list))
  | otherwise = (head list):(myreplaceall n1 n2 (tail list))

myreplaceall_pm n1 n2 [] = []
myreplaceall_pm n1 n2 (x:xs) | n2 == x = n1:(myreplaceall n1 n2 xs)
myreplaceall_pm n1 n2 (x:xs) = x:(myreplaceall_pm n1 n2 xs)

myappend list1 list2
  | list1 == [] = list2
  | otherwise   = (head list1):(myappend (tail list1) list2)

myappend_pm [] list2     = list2
myappend_pm (x:xs) list2 = x:(myappend_pm xs list2)
 
