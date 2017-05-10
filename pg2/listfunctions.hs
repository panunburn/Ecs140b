myintersection l1 l2
  | l1 == [] || l2 == [] = []
  | (elem (head l1) l2) = myappend [head l1] (myintersection (tail l1) l2)
  | otherwise = myintersection (tail l1) l2

myintersection_pm [] l2 = []
myintersection_pm l1 [] = []
myintersection_pm (x1:xs1) (x1:xs2) = myappend_pm [x1] (myintersection_pm xs1 (x1:xs2))
myintersection_pm (x1:xs1) l2 = myintersection_pm xs1 l2

myremoveduplicates list
   | list == [] = []
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

myappend list1 list2
  | list1 == [] = list2
  | otherwise   = (head list1):(myappend (tail list1) list2)

myappend_pm [] list2     = list2
myappend_pm (x:xs) list2 = x:(myappend_pm xs list2)
 
