 
-- must have HUnit modules loaded
-- have this file located in same dir as rushhour.hs
-- to run from ghci, load this file    :l testrushhour
-- Main> runTestTT egtests




import Test.HUnit
import RushHour

import Data.List

targ = ["------","------","----XX","------","------","------"]
exp01 = [["------","------","----XX","------","------","------"]]
start= ["--B---","--B---","XXB---","--AA--","------","------"]
start1= ["ABB---","--B-D-","XXB--C","--AA--","------","-----Z"]
start2= ["ABCDEF","GHIJKL","MNOPQR","STUVWX","YZABCD","EFGHIJ"]
start3= ["abcdef","ghijkl","mnopqr","stuvwx","yz0123","456789"]
start4= ["ABB---","--B-D-","XXB--C","--AA--","------","---ZZZ"]

test01 = TestCase (assertEqual "for: test01" exp01		(rushhour    targ	))
test02 = TestCase (assertEqual "for: test02" True 		(isGoalState targ	))
test03 = TestCase (assertEqual "for: test03" False		(isGoalState start	))
test04 = TestCase (assertEqual "for: test04" "ABX" 		(sort(getCarList start	)))

test05 = TestCase (assertEqual "for: test05" 2			(cpos 'A' (start!!3	)))
test06 = TestCase (assertEqual "for: test06" 0 			(rpos 'B' start		))

test07 = TestCase (assertEqual "for: test07" "" 		(moveRCar 'A' "--AAB-" [] []	))
test08 = TestCase (assertEqual "for: test08" ""			(moveRCar 'A' "--A-B-" [] []	))
test09 = TestCase (assertEqual "for: test09" "---AAA"	(moveRCar 'A' "--AAA-" [] []	))
test10 = TestCase (assertEqual "for: test10" "-AAAAA"	(moveRCar 'A' "AAAAA-" [] []	))
test11 = TestCase (assertEqual "for: test11" "--AACC"	(moveRCar 'A' "-AA-CC" [] []	))
test12 = TestCase (assertEqual "for: test12" "-AAABB"	(moveRCar 'A' "AAA-BB" [] []	))
test13 = TestCase (assertEqual "for: test13" ""			(moveRCar 'A' "AAAAAA" [] []	))
test14 = TestCase (assertEqual "for: test14" ""			(moveRCar 'A' "AAAAAC" [] []	))
test15 = TestCase (assertEqual "for: test15" "-AA---"	(moveRCar 'A' "AA----" [] []	)) 
test16 = TestCase (assertEqual "for: test16" "-AA-B-"	(moveLCar 'A' "--AAB-" [] []	)) 
test17 = TestCase (assertEqual "for: test17" ""			(moveLCar 'A' "--A-B-" [] []	)) 
test18 = TestCase (assertEqual "for: test18" "-AAA--"	(moveLCar 'A' "--AAA-" [] []	)) 
test19 = TestCase (assertEqual "for: test19" ""			(moveLCar 'A' "AAAAA-" [] []	)) 
test20 = TestCase (assertEqual "for: test20" "AA--CC"	(moveLCar 'A' "-AA-CC" [] []	)) 
test21 = TestCase (assertEqual "for: test21" ""			(moveLCar 'A' "AAA-BB" [] []	)) 
test22 = TestCase (assertEqual "for: test22" ""			(moveLCar 'A' "AAAAAA" [] []	)) 
test23 = TestCase (assertEqual "for: test23" ""			(moveLCar 'A' "AAAAAC" [] []	)) 
test24 = TestCase (assertEqual "for: test24" ""			(moveLCar 'A' "AA----" [] []	)) 
test25 = TestCase (assertEqual "for: test25" "---AA-"	(moveLCar 'A' "----AA" [] []	)) 
test26 = TestCase (assertEqual "for: test26" "-AAAA-"	(moveLCar 'A' "--AAAA" [] []	)) 
test27 = TestCase (assertEqual "for: test27" ""			(moveLCar 'A' "--BAAA" [] []	)) 

test28 = TestCase (assertEqual "for: test28" 0			(cpos 'X' (start!!2	)))
test29 = TestCase (assertEqual "for: test29" 3 			(rpos 'A' start		))
test30 = TestCase (assertEqual "for: test30" 2			(rpos 'X' start))
test31 = TestCase (assertEqual "for: test31" 2 			(rpos 'X' targ		))
test32 = TestCase (assertEqual "for: test32" 4 			(cpos 'X' (targ!!2)	))
test33 = TestCase (assertEqual "for: test33" "ABCDXZ"	(sort(getCarList start1	)))
test34 = TestCase (assertEqual "for: test34" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" (sort(getCarList start2	)))
test35 = TestCase (assertEqual "for: test35" "0123456789abcdefghijklmnopqrstuvwxyz" 		(sort(getCarList start3	)))


--start= ["--B---","--B---","XXB---","--AA--","------","------"]
expt37= ["--B---","--B---","XXB---","-AA---","------","------"]
expt38= ["------","------","---XX-","------","------","------"]
expt39= ["ABB---","--B-D-","XXB--C","--AA--","------","--ZZZ-"]
test36 = TestCase (assertEqual "for: test36" [] 		(moveCarLeftInMaze 'B' start	[] ))
test37 = TestCase (assertEqual "for: test37" expt37 	(moveCarLeftInMaze 'A' start	[] ))
test38 = TestCase (assertEqual "for: test38" expt38		(moveCarLeftInMaze 'X' targ		[] ))
test39 = TestCase (assertEqual "for: test39" expt39		(moveCarLeftInMaze 'Z' start4	[] ))


expt41 = ["--B---","--B---","XXB---","---AA-","------","------"]
start5 = ["G-BB--","--E-D-","XXFF-C","--AA--","------","-ZZZ--"]
expt44 = ["G--BB-","--E-D-","XXFF-C","--AA--","------","-ZZZ--"]
expt45 = ["G-BB--","--E-D-","XXFF-C","---AA-","------","-ZZZ--"]
expt46 = ["G-BB--","--E-D-","XX-FFC","--AA--","------","-ZZZ--"]
expt47 = ["G-BB--","--E-D-","XXFF-C","--AA--","------","--ZZZ-"]

test40 = TestCase (assertEqual "for: test40" [] 		(moveCarRightInMaze 'B' start	[] ))
test41 = TestCase (assertEqual "for: test41" expt41 	(moveCarRightInMaze 'A' start	[] ))
test42 = TestCase (assertEqual "for: test42" []			(moveCarRightInMaze 'X' targ	[] ))
test43 = TestCase (assertEqual "for: test43" []			(moveCarRightInMaze 'Z' start4	[] ))
test44 = TestCase (assertEqual "for: test44" expt44		(moveCarRightInMaze 'B' start5	[] ))
test45 = TestCase (assertEqual "for: test45" expt45 	(moveCarRightInMaze 'A' start5	[] ))
test46 = TestCase (assertEqual "for: test46" expt46		(moveCarRightInMaze 'F' start5	[] ))
test47 = TestCase (assertEqual "for: test47" expt47		(moveCarRightInMaze 'Z' start5	[] ))

--moveAllCarsLeft	unexplored visited carlist 
state1 =  ["--B---","--B---","XX----","--AA--","------","------"] 
expt54 = [["--B---","--B---","XX----","-AA---","------","------"]]
expt56 = [["--B---","--B---","-XX---","--AA--","------","------"],["--B---","--B---","XX----","---AA-","------","------"]]
expt55 =  [["G-BB--","--E-D-","XXFF-C","-AA---","------","-ZZZ--"],["GBB---","--E-D-","XXFF-C","--AA--","------","-ZZZ--"],["G-BB--","--E-D-","XXFF-C","--AA--","------","ZZZ---"]]
expt57 = [["G--BB-","--E-D-","XXFF-C","--AA--","------","-ZZZ--"],["G-BB--","--E-D-","XX-FFC","--AA--","------","-ZZZ--"],["G-BB--","--E-D-","XXFF-C","---AA-","------","-ZZZ--"],["G-BB--","--E-D-","XXFF-C","--AA--","------","--ZZZ-"]]
test58 = TestCase (assertEqual "for: test58" []			(moveCarLeftInMaze 'C' start5	[] ))
test54 = TestCase (assertEqual "for: test54" expt54	(moveAllCarsLeft state1  (getCarList state1) ))
test55 = TestCase (assertEqual "for: test55" expt55 (moveAllCarsLeft start5  (sort (getCarList start5)) ))
test56 = TestCase (assertEqual "for: test56" expt56	(moveAllCarsRight state1 (getCarList state1)	))
test57 = TestCase (assertEqual "for: test57" expt57	(moveAllCarsRight start5 (getCarList start5) ))

optlist = [moveAllCarsLeft ,moveAllCarsRight,moveAllCarsUp ,moveAllCarsDown ]
-- for a given start state, show all the list of moves that can be generated as potential next moves.
expt59 = [["--B---","--B---","-XX---","--AA--","------","------"],["--B---","--B---","XX----","---AA-","------","------"],["--B---","--B---","XX----","-AA---","------","------"],["------","--B---","XXB---","--AA--","------","------"]]
expt60 = [["G--BB-","--E-D-","XXFF-C","--AA--","------","-ZZZ--"],["G-BB--","--E-D-","XX-FFC","--AA--","------","-ZZZ--"],["G-BB--","--E-D-","XXFF-C","---AA-","------","-ZZZ--"],["G-BB--","--E-D-","XXFF-C","--AA--","------","--ZZZ-"],["G-BB--","--E-D-","XXFF-C","--AA--","------","ZZZ---"],["G-BB--","--E-D-","XXFF-C","-AA---","------","-ZZZ--"],["GBB---","--E-D-","XXFF-C","--AA--","------","-ZZZ--"]]
test59 = TestCase (assertEqual "for: test59" expt59		(generateNewStates state1 optlist ))
test60 = TestCase (assertEqual "for: test60" expt60		(generateNewStates start5 optlist ))

--start5 = ["G-BB--","--E-D-","XXFF-C","--AA--","------","-ZZZ--"]
start6= ["E-B--F","E-B--F","XXB--F","---A--","---AC-","----CD"]
--["E-B--F"
--,"E-B--F"
--,"XXB--F"
--,"---A--"
--,"---AC-"
--,"----CD"]

--targ = ["------","------","----XX","------","------","------"]
--start5 = ["G-BB--","--E-D-","XXFF-C","--AA--","------","-ZZZ--"]

start7= ["E-B--F","EXB---","EXB---","-XBA--","FXBA-D","F---CD"]
--start6= ["E-B--F","E-B--F","XXB--F","---A--","---AC-","----CD"]

expt68 = ["E----F","E-B--F","XXB--F","--BA--","---AC-","----CD"]
expt61 = ["E-B--F","E-B--F","XXB--F","------","---AC-","---ACD"]
expt64 = ["--B--F","EXB---","EXB---","EXBA--","FXBA-D","F---CD"]
expt65 = ["E----F","EXB---","EXB---","-XBA--","FXBA-D","F-B-CD"]
expt66 = ["E-B---","E-B--F","XXB--F","---A-F","---AC-","----CD"]
expt67 = ["E----F","EXB---","EXB---","-XBA--","FXBA-D","F-B-CD"]
expt69 = ["E-B--F","EXB---","EXB---","-XB---","FXBA-D","F--ACD"]

test61 = TestCase (assertEqual "for: test61" expt61 	(moveCarDown 'A' start6	 ))
test62 = TestCase (assertEqual "for: test62" []			(moveCarDown 'C' start6	 ))
test63 = TestCase (assertEqual "for: test63" []			(moveCarDown 'D' start6	 ))
test64 = TestCase (assertEqual "for: test64" expt64		(moveCarDown 'E' start7	 ))
test65 = TestCase (assertEqual "for: test65" expt65 	(moveCarDown 'B' start7	 ))
test66 = TestCase (assertEqual "for: test66" expt66		(moveCarDown 'F' start6	 ))
test67 = TestCase (assertEqual "for: test67" expt67		(moveCarDown 'B' start7	 ))
test68 = TestCase (assertEqual "for: test68" expt68 	(moveCarDown 'B' start6	 ))
test69 = TestCase (assertEqual "for: test69" expt69		(moveCarDown 'A' start7	 ))
test70 = TestCase (assertEqual "for: test70" []			(moveCarDown 'C' start7	 ))
 
--start7= 
-- ["E-B--F"
-- ,"EXB---"
-- ,"EXB---"
-- ,"-XBA--"
-- ,"FXBA-D"
-- ,"F---CD"]
--start8= 
-- ["E----F"
-- ,"-XB--F"
-- ,"-XB--F"
-- ,"--BA--"
-- ,"--BACD"
-- ,"--BACD"]
start8 = ["E----F","-XB--F","-XB--F","--BA--","--BACD","--BACD"]
expt71 = ["E-B--F","E-B--F","XXBA-F","---A--","----C-","----CD"]
expt72 = ["E-B--F","E-B--F","XXB--F","---AC-","---AC-","-----D"]
expt73 = []
expt74 = []
expt75 = ["E-B--F","-XB--F","-XB--F","--BA--","--BACD","---ACD"]
expt76 = []
expt77 = ["EX---F","-XB--F","--B--F","--BA--","--BACD","--BACD"]
expt78 = ["E----F","-XB--F","-XB--F","--BA-D","--BACD","--BAC-"]
expt79 = ["E-B--F","EXB---","EXBA--","-XBA--","FXB--D","F---CD"]
expt80 = ["E----F","-XB--F","-XB--F","--BAC-","--BACD","--BA-D"]
  
test71 = TestCase (assertEqual "for: test71" expt71	(moveCarUp 'A' start6	 ))
test72 = TestCase (assertEqual "for: test72" expt72	(moveCarUp 'C' start6	 ))
test73 = TestCase (assertEqual "for: test73" expt73	(moveCarUp 'D' start6	 ))
test74 = TestCase (assertEqual "for: test74" expt74	(moveCarUp 'E' start7	 ))
test75 = TestCase (assertEqual "for: test75" expt75	(moveCarUp 'B' start8	 ))
test76 = TestCase (assertEqual "for: test76" expt76	(moveCarUp 'E' start8	 ))
test77 = TestCase (assertEqual "for: test77" expt77	(moveCarUp 'X' start8	 ))
test78 = TestCase (assertEqual "for: test78" expt78	(moveCarUp 'D' start8	 ))
test79 = TestCase (assertEqual "for: test79" expt79	(moveCarUp 'A' start7	 ))
test80 = TestCase (assertEqual "for: test80" expt80	(moveCarUp 'C' start8	 ))



maze81 = ["--B---","--B---","XXB---","--AA--","------","------"]
maze82 = ["--B---","--B---","XX----","--AA--","------","------"]
maze83 = ["--B---","--B-DD","XX----","--AA--","ZZYY--","QQ--PP"]
maze84 = ["------","--B---","XXB--c","--AA-c","-----c","-ddddd"]
maze85 = ["------","--B---","XXB--c","--AA-c","-----c","-ddddd"]  -- 12 states with greedy approach, 52 brute force dfs
maze86 = ["-AB-C-","-AB-CD","XXB-CD","Z---AA","ZQ----","ZQ----"] -- 57 states : no solution
maze87 = ["-AB-C--","-AB-CD-","XXB-CD-","Z---AA-","ZQ-----","ZQ-----"]  -- no solution
-- ["-AB-C--"               "-AB----"
-- ,"-AB-CD-"               "-AB--D-"
-- ,"XXB-CD-"               "XXB--D-"
-- ,"Z---AA-"               "ZAA-C--"
-- ,"ZQ-----"               "ZQ--C--"
-- ,"ZQ-----"]              "ZQ--C--"
maze88 = ["-AB-C--","-AB-CD-","XXB-CD-","Z---AA-","ZQ-----","ZQ-----","KKKKKK-"] -- 139 states : no solution
maze89 = ["C-B---","C-BD--","XXBD--","--AA--","--FF-Z","EE---Z"]  -- no heuristic doesnt find. must be culling in wrong place
--maze90 = [] -- ["C-B---","C-BD--","XXBD-Z","--AA-Z","--FF-Z","EE---Z"]
maze90 = ["C-B---","C-B---","XXB--Z","-----Z","-----Z","AAA--Z"]  -- 283 states: no solution
--maze90 = ["C-B---","C-B---","XXB--Z","-----Z","-----Z","AA---Z"]  -- 451 states: no solution
maze91 =  ["C-B---","C-B---","XXB--Z","-----Z","-----Z","AA----"]  -- 9 states to solution

expt81 = [["--B---","--B---","XXB---","--AA--","------","------"],["--B---","--B---","XXB---","---AA-","------","------"],["------","--B---","XXB---","--BAA-","------","------"],["------","------","XXB---","--BAA-","--B---","------"],["------","------","XX----","--BAA-","--B---","--B---"],["------","------","-XX---","--BAA-","--B---","--B---"],["------","------","--XX--","--BAA-","--B---","--B---"],["------","------","---XX-","--BAA-","--B---","--B---"],["------","------","----XX","--BAA-","--B---","--B---"]]
expt82 = [["--B---","--B---","XX----","--AA--","------","------"],["--B---","--B---","-XX---","--AA--","------","------"],["--B---","--B---","--XX--","--AA--","------","------"],["--B---","--B---","---XX-","--AA--","------","------"],["--B---","--B---","----XX","--AA--","------","------"]]
expt83 = [["--B---","--B-DD","XX----","--AA--","ZZYY--","QQ--PP"],["--B---","--B-DD","-XX---","--AA--","ZZYY--","QQ--PP"],["--B---","--B-DD","--XX--","--AA--","ZZYY--","QQ--PP"],["--B---","--B-DD","---XX-","--AA--","ZZYY--","QQ--PP"],["--B---","--B-DD","----XX","--AA--","ZZYY--","QQ--PP"]]
expt84 = [["------","--B---","XXB--c","--AA-c","-----c","-ddddd"],["--B---","--B---","XX---c","--AA-c","-----c","-ddddd"],["--B---","--B---","-XX--c","--AA-c","-----c","-ddddd"],["--B---","--B---","--XX-c","--AA-c","-----c","-ddddd"],["--B---","--B---","---XXc","--AA-c","-----c","-ddddd"],["------","--B---","--BXXc","--AA-c","-----c","-ddddd"],["------","--B---","--BXXc","---AAc","-----c","-ddddd"],["------","------","--BXXc","--BAAc","-----c","-ddddd"],["------","------","---XXc","--BAAc","--B--c","-ddddd"],["------","------","---XXc","--BAAc","--B--c","ddddd-"],["------","------","---XX-","--BAAc","--B--c","dddddc"],["------","------","----XX","--BAAc","--B--c","dddddc"]]
expt85 = [["------","--B---","XXB--c","--AA-c","-----c","-ddddd"],["--B---","--B---","XX---c","--AA-c","-----c","-ddddd"],["--B---","--B---","-XX--c","--AA-c","-----c","-ddddd"],["--B---","--B---","--XX-c","--AA-c","-----c","-ddddd"],["--B---","--B---","---XXc","--AA-c","-----c","-ddddd"],["------","--B---","--BXXc","--AA-c","-----c","-ddddd"],["------","--B---","--BXXc","---AAc","-----c","-ddddd"],["------","------","--BXXc","--BAAc","-----c","-ddddd"],["------","------","---XXc","--BAAc","--B--c","-ddddd"],["------","------","---XXc","--BAAc","--B--c","ddddd-"],["------","------","---XX-","--BAAc","--B--c","dddddc"],["------","------","----XX","--BAAc","--B--c","dddddc"]]
expt86 = []
expt87 = []
expt88 = []
expt89 = [["C-B---","C-BD--","XXBD--","--AA--","--FF-Z","EE---Z"],["C-BD--","C-BD--","XXB---","--AA--","--FF-Z","EE---Z"],["C-BD--","C-BD--","XXB---","---AA-","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--BAA-","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--B-AA","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--B-AA","---FFZ","EE---Z"],["C--D--","C--D--","XXB---","--B-AA","--BFFZ","EE---Z"],["C--D--","C--D--","XX----","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","-XX---","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","--XX--","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","---XX-","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","----XX","--B-AA","--BFFZ","EEB--Z"]]

expt90 = []

-- this one takes a while - no solution 697 unique states to visit to completion
-- *Main> rushhour ["C-B---","C-BD--","XXBD-Z","--AA-Z","--FF-Z","EE---Z"]

       
test81 = TestCase (assertEqual "for: test81" expt81	(rushhour maze81 ))
test82 = TestCase (assertEqual "for: test82" expt82	(rushhour maze82 ))
test83 = TestCase (assertEqual "for: test83" expt83	(rushhour maze83 ))
test84 = TestCase (assertEqual "for: test84" expt84	(rushhour maze84 ))
test85 = TestCase (assertEqual "for: test85" expt85	(rushhour maze85 ))
test86 = TestCase (assertEqual "for: test86" expt86	(rushhour maze86 ))
test87 = TestCase (assertEqual "for: test87" expt87	(rushhour maze87 ))
test88 = TestCase (assertEqual "for: test88" expt88	(rushhour maze88 ))
test89 = TestCase (assertEqual "for: test89" expt89	(rushhour maze89 ))
test90 = TestCase (assertEqual "for: test90" expt90	(rushhour maze90 ))
test91 = TestCase (assertEqual "for: test90" expt90	(rushhour maze90 ))

egtests = TestList [ 
	 test01,test02,test03,test04
 	,test05,test06,test07,test08,test09,test10
	,test11,test12,test13,test14,test15
	,test16,test17,test18,test19
    ,test20,test21,test22,test23,test24
    ,test25,test26,test27
	,test28,test29,test30,test31,test32
	,test33,test34,test35
	,test36,test37,test38,test39
	,test40,test41,test42,test43,test44,test45,test46,test47
	,test55
	,test54,test56 ,test57,test58
	,test59,test60
	,test68,test61,test62,test63,test64,test65,test66,test67
	,test69,test70-- ,test62,test63,test64,test65,test66,test67
	,test71,test72,test73,test74,test75,test76,test77,test78,test79,test80
	,test81,test82,test83,test84,test85,test86,test87,test88,test89,test90




	]
-- 115 brute force, 9 heuristic
small = ["EE--HF","----HF","XX-G--","-EEG--","--II--","--BACD"]

-- brute force dfs produced this interesting result

-- *Main> rushhour ["C-B---","C-BD--","XXBD--","--AA--","--FF-Z","EE---Z"]
-- gennewstate
-- Duplicate state, visited = 2155  path = : 2148   unexp : 4
-- Duplicate state, visited = 2155  path = : 2148   unexp : 3
-- Duplicate state, visited = 2155  path = : 2148   unexp : 2
-- gennewstate
-- gennewstate
-- Duplicate state, visited = 2157  path = : 2150   unexp : 5
-- gennewstate
-- Duplicate state, visited = 2158  path = : 2151   unexp : 5
-- gennewstate
-- Duplicate state, visited = 2159  path = : 2152   unexp : 6

-- states explored : 2159
-- solution length : 2153

-- vs with heuristic
-- *Main> rushhour ["C-B---","C-BD--","XXBD--","--AA--","--FF-Z","EE---Z"]

-- states explored : 12
-- solution length : 13
-- [["C-B---","C-BD--","XXBD--","--AA--","--FF-Z","EE---Z"],["C-BD--","C-BD--","XXB---","--AA--","--FF-Z","EE---Z"],["C-BD--","C-BD--","XXB---","---AA-","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--BAA-","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--B-AA","--FF-Z","EE---Z"],["C--D--","C-BD--","XXB---","--B-AA","---FFZ","EE---Z"],["C--D--","C--D--","XXB---","--B-AA","--BFFZ","EE---Z"],["C--D--","C--D--","XX----","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","-XX---","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","--XX--","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","---XX-","--B-AA","--BFFZ","EEB--Z"],["C--D--","C--D--","----XX","--B-AA","--BFFZ","EEB--Z"]]
-- *Main> 

	
