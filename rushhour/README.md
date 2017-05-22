This is the Rush_Hour project.
ThinkFun, Inc., www.thinkfun.com
rushbrute.hs contains the brute force version, using DFS
rush_hour.hs contains the heuristic version

-- our heuristic is as follows, where a smaller number is better:
--
-- (100 * (total positions to the right of "XX") - 50 * (empty spaces to the right of "XX"))
--
-- The idea is that the closer "XX" is to the right, the closer the puzzle is to being solved.
-- "XX" is closer to the right when it has fewer empty or blocked positions to its right.
-- Also, positions filled by other vehicles require more moves to free up, 
-- so filled spaces are twice as costly as empty spaces for our heuristic calculation.  
--
-- We implement our heruistic by sorting the states by this value in our state generation function.

Here are some sample inputs from Rush Hour app on AppStore
Easy Level:
rush_hour ["-----A",
	   "-----A",
	   "---XXA",
	   "------",
	   "---CDD",
	   "---C--"]
code:
rush_hour ["-----A","-----A","---XXA","------","---CDD","---C--"]

rush_hour ["------",
	   "-AAABB",
	   "XX-C-D",
           "---C-D",
	   "---CEE",
	   "------"]
code:
rush_hour ["------","-AAABB","XX-C-D","---C-D","---CEE","------"]

Medium Level:
rush_hour ["--ABBB",
	   "--AD--",
	   "-XXD--",
	   "-C-D--",
	   "-CIIKL",
	   "--JJKL"]
code:
rush_hour ["--ABBB","--AD--", "-XXD--","-C-D--","-CIIKL","--JJKL"]

can't solve hard in reasonable time
Hard Level:
rush_hour ["-ABBCC",
	   "-A--DE",
	   "XX--DE",
	   "FFF-D-",
	   "--GHH-",
	   "IIG---"]
code:
rush_hour ["-ABBCC","-A--DE","XX--DE","FFF-D-","--GHH-","IIG---"]

Expert Level:
rush_hour ["a--bbc",
	   "adddec",
	   "XXfgeh",
	   "iifg-h",
	   "---jkk",
	   "---j--"]
copycode:
rush_hour ["a--bbc","adddec","XXfgeh","iifg-h","---jkk","---j--"]

