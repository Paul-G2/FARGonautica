;===========================================================================
; knowledge.ss : bond-ant program phase one knowledge module
;===========================================================================
; globals:   *quanta*  letter to process in standard form
;            *neighbors* list of neighboring quanta

;-----------------------------( grid knowledge )-----------------------------
; information about the grid : angles, neighbors, etc..

; there are 4 quantum types: horizontal, vertical, forward slash and back
; slash.  the 56 bit representation for a letter uses the four types in that
; order.
(define find-quantum-type
  (lambda (quantum)
    (cond
      ((and (<= 0 quantum)(>= 13 quantum)) 'h)
      ((and (<= 14 quantum)(>= 31 quantum)) 'v)
      ((and (<= 32 quantum)(>= 43 quantum)) 'f)
      ((and (<= 44 quantum)(>= 56 quantum)) 'b)
      (else (error 'find-quantum-type "number ~s has no type" quantum)))))

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; ANGLES
;  Each quantum has 14 possible connecting quanta, 7 "above" and 7 "below".
;  These quanta are numbered 1..14 starting above and moving clockwise.
;                       4 and 11 are straight
;                       3, 5, 10 and 12 are 45 off
;                       2, 6, 9 and 13 are 90 off
;                       1, 7, 8 and 14 are 135 off
; the four types are all different, but they have the same relative offshoot
; angles.
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;list of neighbors of all quanta in the above, below clockwise order.
; this table could be computed, but lookup is faster. 

(set! *neighbors*
  '((0 (- - - 1 45 15 32 44 14 - - - - -))
    (1 (- - - - - 16 33 45 15 32 0 - - -))
    (2 (44 15 33 3 47 18 34 46 17 - - - 14 32))
    (3 (45 16 - - - 19 35 47 18 34 2 44 15 33))
    (4 (46 18 35 5 49 21 36 48 20 - - - 17 34))
    (5 (47 19 - - - 22 37 49 21 36 4 46 18 35))
    (6 (48 21 37 7 51 24 38 50 23 - - - 20 36))
    (7 (49 22 - - - 25 39 51 24 38 6 48 21 37))
    (8 (50 24 39 9 53 27 40 52 26 - - - 23 38))
    (9 (51 25 - - - 28 41 53 27 40 8 50 24 39))
    (10 (52 27 41 11 55 30 42 54 29 - - - 26 40))
    (11 (53 28 - - - 31 43 55 30 42 10 52 27 41))
    (12 (54 30 43 13 - - - - - - - - 29 42))
    (13 (55 31 - - - - - - - - 12 54 30 43))
    (14 (- - - - - 0 44 32 2 46 17 - - -))
    (15 (32 0 - - - 1 45 33 3 47 18 34 2 44))
    (16 (33 1 - - - - - - - - 19 35 3 45))
    (17 (- - - 14 32 2 46 34 4 48 20 - - -))
    (18 (34 2 44 15 33 3 47 35 5 49 21 36 4 46))
    (19 (35 3 45 16 - - - - - - 22 37 5 47))
    (20 (- - - 17 34 4 48 36 6 50 23 - - -))
    (21 (36 4 46 18 35 5 49 37 7 51 24 38 6 48))
    (22 (37 5 47 19 - - - - - - 25 39 7 49))
    (23 (- - - 20 36 6 50 38 8 52 26 - - -))
    (24 (38 6 48 21 37 7 51 39 9 53 27 40 8 50))
    (25 (39 7 49 22 - - - - - - 28 41 9 51))
    (26 (- - - 23 38 8 52 40 10 54 29 - - -))
    (27 (40 8 50 24 39 9 53 41 11 55 30 42 10 52))
    (28 (41 9 51 25 - - - - - - 31 43 11 53))
    (29 (- - - 26 40 10 54 42 12 - - - - -))
    (30 (42 10 52 27 41 11 55 43 13 - - - 12 54))
    (31 (43 11 53 28 - - - - - - - - 13 55))
    (32 (0 - - - 1 45 15 2 46 17 - - - 14))
    (33 (1 - - - - - 16 3 47 18 34 2 44 15))
    (34 (2 44 15 33 3 47 18 4 48 20 - - - 17))
    (35 (3 45 16 - - - 19 5 49 21 36 4 46 18))
    (36 (4 46 18 35 5 49 21 6 50 23 - - - 20))
    (37 (5 47 19 - - - 22 7 51 24 38 6 48 21))
    (38 (6 48 21 37 7 51 24 8 52 26 - - - 23))
    (39 (7 49 22 - - - 25 9 53 27 40 8 50 24))
    (40 (8 50 24 39 9 53 27 10 54 29 - - - 26))
    (41 (9 51 25 - - - 28 11 55 30 42 10 52 27))
    (42 (10 52 27 41 11 55 30 12 - - - - - 29))
    (43 (11 53 28 - - - 31 13 - - - 12 54 30))
    (44 (14 - - - - - 0 15 33 3 47 18 34 2))
    (45 (15 32 0 - - - 1 16 - - - 19 35 3))
    (46 (17 - - - 14 32 2 18 35 5 49 21 36 4))
    (47 (18 34 2 44 15 33 3 19 - - - 22 37 5))
    (48 (20 - - - 17 34 4 21 37 7 51 24 38 6))
    (49 (21 36 4 46 18 35 5 22 - - - 25 39 7))
    (50 (23 - - - 20 36 6 24 39 9 53 27 40 8))
    (51 (24 38 6 48 21 37 7 25 - - - 28 41 9))
    (52 (26 - - - 23 38 8 27 41 11 55 30 42 10))
    (53 (27 40 8 50 24 39 9 28 - - - 31 43 11))
    (54 (29 - - - 26 40 10 30 43 13 - - - 12))
    (55 (30 42 10 52 27 41 11 31 - - - - - 13))))

; Association list for points on the grid.  Point 1 for example is
; associated with quanta 0, 44, and 14.
(set! *point-list* '((1 (0 44 14))
		     (2 (14 32 2 46 17))
		     (3 (17 34 4 48 20))
		     (4 (20 36 6 50 23))
		     (5 (23 38 8 52 26))
		     (6 (26 40 10 54 29))
		     (7 (29 42 12))
		     (8 (1 45 15 32 0))
		     (9 (2 44 15 33 3 47 18 34))
		     (10 (4 46 18 35 5 49 21 36))
		     (11 (6 48 21 37 7 51 24 38))
		     (12 (8 50 24 39 9 53 27 40))
		     (13 (10 52 27 41 11 55 30 42))
		     (14 (12 54 30 43 13))
		     (15 (16 33 1))
		     (16 (16 45 3 35 19))
		     (17 (19 47 5 37 22))
		     (18 (22 49 7 39 25))
		     (19 (25 51 9 41 28))
		     (20 (28 53 11 43 31))
		     (21 (31 55 13))))

; association list of quanta and endpoints
(set! *quanta-endpoints* '((0 (1 8))(1 (8 15))
		    (2 (2 9))(3 (9 16))
		    (4 (3 10))(5 (10 17))
		    (6 (4 11))(7 (11 18))
		    (8 (5 12))(9 (12 19))
		    (10 (6 13))(11 (13 20))
		    (12 (7 14))(13 (14 21))
		    (14 (1 2))(15 (8 9))
		    (16 (15 16))(17 (2 3))
		    (18 (9 10))(19 (16 17))
		    (20 (3 4))(21 (10 11))
		    (22 (17 18))(23 (4 5))
		    (24 (11 12))(25 (18 19))
		    (26 (5 6))(27 (12 13))
		    (28 (19 20))(29 (6 7))
		    (30 (13 14))(31 (20 21))
		    (32 (2 8))(33 (9 15))
		    (34 (3 9))(35 (10 16))
		    (36 (4 10))(37 (11 17))
		    (38 (5 11))(39 (12 18))
		    (40 (6 12))(41 (13 19))
		    (42 (7 13))(43 (14 20))
		    (44 (1 9))(45 (8 16))
		    (46 (2 10))(47 (9 17))
		    (48 (3 11))(49 (10 18))
		    (50 (4 12))(51 (11 19))
		    (52 (5 13))(53 (12 20))
		    (54 (6 14))(55 (13 21))))

; Adjudicator info

; ------------------------------------------------------------------------
; Quanta Lists
; ------------------------------------------------------------------------

; Lists for zones

(set! *topedge-zone* '(0 1))
(set! *topbox-zone* '(0 1 14 32 44 15 33 45 16))
(set! *ascender-zone* '(0 1 2 3 14 32 44 15 33 45 16 17 34 46 18 35 47 19))
(set! *descender-zone*
      '(12 13 29 42 54 30 43 55 31 10 11 26 40 52 27 41 53 28))
(set! *bottombox-zone* '(12 13 29 42 54 30 43 55 31))
(set! *bottomedge-zone* '(12 13))
(set! *rightedge-zone* '(16 19 22 25 28 31))
(set! *leftedge-zone* '(14 17 20 23 26 29))
(set! *vertedges-zone* '(0 1 12 13))
(set! *vertboxes-zone* '(0 1 14 32 44 15 33 45 16 12 13 29 42 54 30 43 55 31))
(set! *topleft-zone* '(0 14 44))
(set! *topright-zone* '(1 16 33))
(set! *bottomleft-zone* '(29 42 54))
(set! *bottomright-zone* '(31 43 55))
(set! *corners-zone* '(0 14 44 1 16 33 29 42 54 31 43 55))

; Lists for orientations

(set! *verticals*
      '(14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31))
(set! *horizontals* '(0 1 2 3 4 5 6 7 8 9 10 11 12 13))
(set! *foreslashes* '(32 33 34 35 36 37 38 39 40 41 42 43))
(set! *backslashes* '(44 45 46 47 48 49 50 51 52 53 54 55))
(set! *rectilinears*
      '(14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
	   0 1 2 3 4 5 6 7 8 9 10 11 12 13))
(set! *diagonals*
      '(32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
	   51 52 53 54 55))

; Lists for angles
; 45-135-angle 90-180-angle done via composite of these

(set! *45-degrees* '((32 0) (32 2) (32 14) (32 15) (44 0) (44 2) (44
14) (44 15) (33 1) (33 3) (33 15) (33 16) (45 1) (45 3) (45 15) (45
16) (34 2) (34 4) (34 17) (34 18) (46 2) (46 4) (46 17) (46 18) (35 3)
(35 5) (35 18) (35 19) (47 3) (47 5) (47 18) (47 19) (36 4) (36 6) (36
20) (36 21) (48 4) (48 6) (48 20) (48 21) (37 5) (37 7) (37 21) (37
22) (49 5) (49 7) (49 21) (49 22) (38 6) (38 8) (38 23) (38 24) (50 6)
(50 8) (50 23) (50 24) (39 7) (39 9) (39 24) (39 25) (51 7) (51 9) (51
24) (51 25) (40 8) (40 10) (40 26) (40 27) (52 8) (52 10) (52 26) (52
27) (41 9) (41 11) (41 27) (41 28) (53 9) (53 11) (53 27) (53 28) (42
10) (42 12) (42 29) (42 30) (54 10) (54 12) (54 29) (54 30) (43 11)
(43 13) (43 30) (43 31) (55 11) (55 13) (55 30) (55 31)))

(set! *90-degrees* '((2 14) (2 15) (2 17) (2 18) (3 15) (3 16) (3 18)
(3 19) (4 17) (4 18) (4 20) (4 21) (5 18) (5 19) (5 21) (5 22) (6 20)
(6 21) (6 23) (6 24) (7 21) (7 22) (7 24) (7 25) (8 23) (8 24) (8 26)
(8 27) (9 24) (9 25) (9 27) (9 28) (10 26) (10 27) (10 29) (10 30) (11
27) (11 28) (11 30) (11 31) (12 29) (12 30) (13 30) (13 31) (0 14) (0
15) (1 15) (1 16) (34 44) (34 47) (34 48) (35 45) (35 46) (35 49) (36
46) (36 49) (36 50) (37 47) (37 48) (37 51) (38 48) (38 51) (38 52)
(39 49) (39 50) (39 53) (40 50) (40 53) (40 54) (41 51) (41 52) (41
55) (42 52) (42 55) (43 53) (43 54) (32 45) (32 46) (33 44) (33 47)))

(set! *135-degrees* '((34 15) (34 3) (34 20) (46 21) (46 5) (46 14)
(35 16) (35 4) (35 21) (47 22) (47 2) (47 15) (36 18) (36 5) (36 23)
(48 24) (48 7) (48 17) (37 19) (37 6) (37 24) (49 25) (49 4) (49 18)
(38 21) (38 7) (38 26) (50 27) (50 9) (50 20) (39 22) (39 8) (39 27)
(51 28) (51 6) (51 21) (40 24) (40 9) (40 29) (52 30) (52 11) (52 23)
(41 25) (41 10) (41 30) (53 31) (53 8) (53 24) (42 27) (42 11) (54 13)
(54 26) (43 28) (43 12) (55 10) (55 27) (32 1) (32 17) (44 3) (44 18)
(33 2) (33 18) (45 0) (45 19)))

(set! *180-degrees* '((17 14) (17 20) (19 16) (19 22) (23 20) (23 26)
(25 22) (25 28) (26 29) (28 31) (0 1) (2 3) (4 5) (6 7) (8 9) (10 11)
(12 13) (33 34) (35 36) (37 38) (39 40) (41 42) (44 47) (46 49) (48
51) (50 53) (52 55) (18 15) (18 21) (24 21) (24 27) (27 30)))

; if any of these triplets are fully filled, then at-most-two is broken
(set! *at-most-two* '((14 17 20)
		      (15 18 21)
		      (16 19 22)
		      (17 20 23)
		      (18 21 24)
		      (19 22 25)
		      (20 23 26)
		      (21 24 27)
		      (22 25 28)
		      (23 26 29)
		      (24 27 30)
		      (25 28 31)))

(set! *horiz-diag-pairs* '((0 1) (2 3) (4 5) (6 7) (8 9) (10 11) (12
13) (33 34) (35 36) (37 38) (39 40) (41 42) (44 47) (46 49) (48 51)
(50 53) (52 55)))

(set! *at-most-three* '((14 17 20 23)
			(15 18 21 24)
			(16 19 22 25)
			(17 20 23 26)
			(18 21 24 27)
			(19 22 25 28)
			(20 23 26 29)
			(21 24 27 30)
			(22 25 28 31)))
