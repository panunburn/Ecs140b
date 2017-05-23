This is the Rush_Hour project.
Weiran Guo(912916431)
Allen Speers(912113700)
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
bruteforce with 40 states
heuristic with 23 states

rush_hour ["------",
	   "-AAABB",
	   "XX-C-D",
           "---C-D",
	   "---CEE",
	   "------"]
code:
rush_hour ["------","-AAABB","XX-C-D","---C-D","---CEE","------"]
bruteforce with 10 states
heuristic with 10 states

Medium Level:
rush_hour ["------",
	   "--B---",
	   "XXB--C",
	   "--AA-C",
	   "-----C",
	   "-DDDEE"]
code:
rush_hour ["------","--B---","XXB--C","--AA-C","-----C","-DDDEE"]
bruteforce with 104 states
heuristic with 11 states

rush_hour ["--ABBB",
	   "--AD--",
	   "-XXD--",
	   "-C-D--",
	   "-CIIKL",
	   "--JJKL"]
code:
rush_hour ["--ABBB","--AD--", "-XXD--","-C-D--","-CIIKL","--JJKL"]
bruteforce with 669 states
heuristic with 208 states
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

can't solve expert in reasonable time
Expert Level:
rush_hour ["a--bbc",
	   "adddec",
	   "XXfgeh",
	   "iifg-h",
	   "---jkk",
	   "---j--"]
copycode:
rush_hour ["a--bbc","adddec","XXfgeh","iifg-h","---jkk","---j--"]

might improve by adding general heuristic function for all cars with corresponding exit
