-- Params
raceID = "test1" --export: sent from the central system to set the current race ID
teamName = "DU Racing" -- export: The name of the team racing for
teamColor = "0,0,255" -- export: r,g,b value for the color
testRace = true --export: if set to true this will not emit times but allow the course to be run
testTrackKey = "Hover Kart Track" --export: Active track key, only used for test races
ad = "assets.prod.novaquark.com/100694/37f71083-7b2a-42cc-8728-44119d908ef2.png" --export: Sponsor for this race. default is DU Racing logo
map = "assets.prod.novaquark.com/74927/a28ec69c-1a26-4d85-b579-5acedc3f69c2.png" --export: Image for background on map

-- Organiser Params
-- Current Track Key (the current race key to use for saving waypoints)
organiserMode = false --export: if set to true this will allow new waypoints to be saved and exported
radius = 20 --export: radius /this should nto be left public long term
sponsorText = "Prize Sponsor - 1M " --export: Text by sponsor image.

-- Globals
waypoints = {}
sectionTimes = {} -- stores the times for each section
savedWaypoints = {} -- stores the waypoints when an organiser is plotting a race
currentWaypointIndex = 1 -- keeps track of the current active waypoint index
currentWaypoint = nil -- vec3 of the current waypoint poisition, used for working out distance
startTime = 0 -- start time in ms
endTime = 0 -- end time ms
splitTime = 0 -- current splt time start
lapTime = 0 -- tracks lap time
lapTimes = {} -- tracks all lap times
remainingLaps = 1 -- updated when the waypoints for the track are loaded
totalLaps = 1
trackName = ""
raceStarted = false
messageParts = {} -- multipart messaging table
gTab = "race" --race tracks new test config
gState = "start" -- start, awaiting, ready, set, live, finished, error, organizer, test
gData = json.decode('{"mainMessage": "Loading...", "toast": "Welcome to DU Racing" }')

duRacingLogo =
    '<svg style="width: 100%; height: 100%;" width="815.000000pt" height="493.000000pt" viewBox="0 0 815.000000 493.000000" preserveAspectRatio="xMidYMid meet"> <g transform="translate(0.000000,493.000000) scale(0.100000,-0.100000)" fill="rgba(255,255,255,1)" stroke="none"> <path d="M3190 4824 c0 -11 104 -156 114 -160 16 -5 298 -25 302 -21 3 2 -59 100 -90 144 -1 1 -60 9 -131 18 -72 8 -145 17 -162 19 -18 3 -33 2 -33 0z"/> <path d="M3890 4724 c0 -9 81 -124 88 -124 4 -1 63 -9 132 -20 69 -10 126 -17 128 -15 3 3 -66 115 -71 115 -1 0 -58 11 -127 25 -132 26 -150 28 -150 19z"/> <path d="M4516 4692 c41 -71 45 -73 169 -98 65 -13 119 -23 121 -21 1 1 -12 22 -30 47 -32 44 -34 45 -147 73 -63 15 -118 27 -122 27 -5 0 -1 -13 9 -28z"/> <path d="M1880 4619 c-186 -13 -320 -26 -326 -31 -3 -3 36 -63 85 -134 50 -71 87 -131 83 -135 -4 -3 -34 -11 -67 -18 -33 -7 -138 -31 -234 -53 -109 -25 -177 -36 -183 -30 -5 5 -55 74 -112 153 l-102 144 -44 -3 c-56 -4 -543 -101 -552 -110 -3 -4 52 -88 123 -186 71 -99 126 -183 122 -186 -4 -4 -60 -27 -123 -50 -137 -51 -481 -197 -493 -209 -6 -6 301 -442 359 -510 2 -2 76 44 166 102 192 123 394 240 407 235 5 -1 71 -88 147 -193 75 -104 152 -210 170 -235 l33 -46 -107 -92 c-59 -50 -168 -153 -244 -229 l-136 -138 255 -348 255 -347 65 112 c63 111 250 396 295 451 l23 28 221 -308 c122 -169 227 -317 234 -329 11 -17 5 -39 -43 -165 -60 -154 -143 -417 -172 -539 l-18 -75 348 -475 c191 -261 355 -483 365 -493 16 -17 17 -9 23 160 7 208 30 485 56 666 l17 128 -278 386 c-153 213 -278 390 -278 396 0 29 247 508 269 521 4 3 104 -132 222 -299 118 -167 217 -304 221 -305 4 0 11 12 14 28 13 49 91 254 138 363 l47 106 -175 251 c-97 138 -176 255 -176 260 0 5 61 71 135 146 83 84 133 142 128 149 -3 7 -60 90 -126 185 -112 163 -118 174 -101 187 11 8 79 42 151 77 73 35 133 66 133 70 0 4 -40 67 -90 139 -49 72 -90 134 -90 138 0 4 42 17 93 29 162 36 219 45 225 36 59 -83 152 -225 152 -231 0 -4 -61 -30 -136 -58 -74 -27 -137 -52 -140 -56 -2 -4 41 -73 96 -154 56 -80 103 -151 105 -158 2 -7 -51 -52 -117 -102 -67 -49 -126 -97 -131 -106 -8 -12 21 -61 133 -222 79 -114 146 -207 149 -207 3 1 24 26 46 57 22 31 71 91 108 134 l68 79 -121 178 -121 177 25 20 c14 11 72 47 130 79 l104 59 -91 134 c-74 107 -89 136 -77 143 8 5 69 23 136 41 l123 32 -71 106 c-39 58 -72 107 -73 109 -1 1 -64 -7 -139 -18 -75 -11 -143 -20 -151 -20 -8 0 -48 50 -90 110 l-77 111 -61 -7 c-123 -13 -269 -32 -273 -37 -3 -2 34 -60 80 -128 47 -68 82 -125 78 -126 -4 -1 -74 -23 -157 -49 -82 -26 -157 -48 -166 -51 -19 -5 -216 274 -203 287 9 8 275 60 309 60 52 1 48 15 -30 129 -42 61 -75 112 -73 112 2 1 83 4 180 8 l178 6 -60 90 c-57 85 -62 90 -102 97 -54 8 -338 10 -338 2 0 -3 29 -48 65 -99 36 -52 65 -96 65 -98 0 -2 -39 -7 -87 -11 -111 -8 -297 -28 -301 -32 -3 -2 136 -207 170 -250 6 -8 -19 -18 -84 -34 -51 -13 -143 -38 -205 -55 l-112 -32 -106 151 -106 151 28 7 c41 10 356 58 382 58 17 0 22 4 17 16 -6 17 -156 235 -159 233 -1 -1 -58 -6 -127 -10z m-516 -584 c64 -91 119 -171 122 -178 3 -8 -17 -22 -53 -37 -32 -13 -145 -65 -250 -116 l-193 -92 -128 176 c-70 97 -138 192 -151 209 l-22 33 28 11 c15 6 122 40 238 75 116 36 221 69 235 74 14 5 32 9 41 9 9 1 63 -66 133 -164z m708 -198 l117 -166 -97 -52 c-53 -28 -143 -79 -200 -112 -88 -51 -106 -58 -117 -46 -7 8 -72 97 -144 199 l-131 185 42 19 c73 33 392 145 403 142 6 -1 63 -77 127 -169z m607 -177 c61 -88 111 -162 111 -164 0 -2 -21 -16 -47 -32 -27 -15 -100 -62 -164 -105 l-116 -77 -132 188 c-72 103 -131 190 -131 194 0 3 10 11 23 17 39 21 321 139 334 139 6 0 61 -72 122 -160z m-736 -442 c87 -123 158 -227 158 -231 0 -5 -52 -65 -115 -135 -63 -70 -143 -162 -177 -205 -59 -75 -63 -77 -79 -60 -30 32 -380 523 -380 533 0 18 404 318 430 320 4 0 77 -100 163 -222z m677 -164 c102 -145 148 -219 142 -227 -5 -7 -34 -43 -64 -82 -31 -38 -90 -121 -132 -182 l-76 -113 -185 261 c-102 143 -185 264 -185 269 0 17 320 290 340 290 5 0 77 -97 160 -216z"/> <path d="M5127 4599 c28 -47 41 -55 138 -78 50 -12 98 -24 108 -27 16 -5 14 0 -8 34 -16 24 -37 42 -53 46 -15 3 -66 17 -115 30 l-87 25 17 -30z"/> <path d="M4180 4546 c0 -14 71 -117 83 -121 19 -7 231 -33 236 -29 2 2 -12 28 -31 57 l-36 54 -103 17 c-57 10 -114 20 -126 23 -13 3 -23 2 -23 -1z"/> <path d="M3010 4504 c0 -11 124 -186 135 -190 7 -3 80 -1 163 3 l152 8 -62 93 -61 92 -163 0 c-90 0 -164 -3 -164 -6z"/> <path d="M3706 4463 c9 -16 33 -51 51 -79 l34 -51 136 -6 c76 -4 138 -5 140 -4 1 2 -18 33 -42 70 -28 40 -54 69 -68 72 -29 6 -209 25 -243 25 l-26 0 18 -27z"/> <path d="M4670 4474 c0 -3 12 -23 27 -47 15 -23 28 -43 28 -45 3 -4 219 -41 223 -38 2 3 -8 22 -23 44 -19 28 -36 42 -58 46 -18 4 -69 15 -114 25 -46 10 -83 17 -83 15z"/> <path d="M5079 4293 c24 -45 39 -53 134 -73 55 -12 101 -20 103 -18 2 3 -9 18 -24 35 -22 25 -44 35 -114 52 -107 26 -111 26 -99 4z"/> <path d="M3547 4170 c36 -56 72 -99 78 -96 7 2 59 7 116 11 166 10 158 1 92 100 l-56 85 -149 0 -148 0 67 -100z"/> <path d="M4514 4244 c65 -99 56 -92 121 -99 33 -3 84 -9 114 -12 l54 -6 -23 39 c-40 67 -44 69 -142 83 -51 7 -104 15 -118 18 l-24 6 18 -29z"/> <path d="M5390 4256 c0 -21 37 -57 69 -66 20 -5 66 -18 104 -29 l67 -20 -16 28 c-13 21 -34 32 -102 53 -48 15 -95 30 -104 33 -10 4 -18 4 -18 1z"/> <path d="M6030 4232 c0 -6 6 -14 13 -19 15 -10 157 -52 177 -53 35 -1 -18 29 -89 50 -40 12 -80 24 -87 27 -8 3 -14 0 -14 -5z"/> <path d="M3995 4204 c10 -16 32 -50 49 -75 l30 -46 125 -6 c69 -3 126 -5 128 -3 1 1 -17 32 -42 68 -49 73 -37 69 -225 84 l-84 7 19 -29z"/> <path d="M5733 4177 c9 -14 43 -31 103 -49 106 -33 115 -34 89 -9 -11 10 -62 32 -113 49 -91 30 -93 31 -79 9z"/> <path d="M4990 4175 c0 -11 50 -85 58 -85 7 0 113 -16 170 -26 l33 -5 -27 40 c-15 23 -28 41 -29 41 -2 0 -47 9 -100 20 -109 22 -105 22 -105 15z"/> <path d="M6460 4128 c8 -8 50 -27 93 -42 43 -15 85 -30 94 -33 10 -4 14 -2 10 4 -6 10 -124 59 -187 78 -22 6 -23 5 -10 -7z"/> <path d="M5519 4083 c5 -11 16 -24 23 -30 16 -12 181 -54 187 -47 13 13 -42 45 -109 64 -41 12 -83 24 -93 27 -16 4 -17 2 -8 -14z"/> <path d="M5975 4028 c11 -17 38 -28 105 -44 88 -20 105 -19 76 6 -11 9 -176 60 -194 60 -2 0 4 -10 13 -22z"/> <path d="M4935 4009 c5 -8 21 -33 36 -55 l28 -42 98 -4 c54 -3 100 -4 101 -2 2 1 -10 23 -27 47 -33 48 -31 47 -180 63 -53 6 -63 5 -56 -7z"/> <path d="M4540 4003 c0 -2 21 -35 46 -73 l47 -70 115 0 114 0 -18 28 c-68 106 -63 100 -117 106 -69 7 -187 13 -187 9z"/> <path d="M5236 3951 c11 -18 24 -36 29 -41 11 -9 184 -34 191 -28 1 2 -6 18 -17 35 -17 27 -28 33 -87 42 -37 7 -82 14 -101 18 l-34 6 19 -32z"/> <path d="M3910 3878 c-58 -11 -107 -22 -109 -24 -2 -2 131 -203 155 -233 3 -3 220 66 236 76 4 2 -23 49 -60 103 -77 114 -63 109 -222 78z"/> <path d="M6257 3874 c3 -8 24 -19 47 -25 22 -6 63 -17 90 -25 27 -8 51 -12 54 -10 7 7 -30 23 -115 49 -61 19 -80 21 -76 11z"/> <path d="M5220 3861 c0 -2 12 -23 28 -47 l27 -44 93 0 c50 0 92 2 92 5 0 19 -48 75 -65 76 -11 0 -55 4 -97 7 -43 4 -78 6 -78 3z"/> <path d="M5730 3862 c0 -26 42 -50 102 -56 34 -4 74 -10 87 -13 23 -6 23 -5 7 19 -14 21 -32 28 -99 42 -95 19 -97 19 -97 8z"/> <path d="M4154 3845 c4 -11 96 -154 112 -173 5 -6 229 21 237 28 5 5 -14 42 -42 84 l-52 76 -130 0 c-112 0 -130 -2 -125 -15z"/> <path d="M5990 3821 c0 -5 6 -13 13 -18 15 -12 169 -45 176 -38 11 11 -18 24 -96 44 -93 24 -93 24 -93 12z"/> <path d="M4840 3804 c0 -4 57 -92 84 -130 3 -4 188 15 192 19 8 8 -55 101 -74 109 -20 8 -202 10 -202 2z"/> <path d="M5621 3758 c21 -33 28 -36 113 -51 50 -9 92 -14 94 -12 2 2 -4 14 -12 27 -13 19 -33 28 -94 41 -42 10 -88 20 -101 24 l-23 6 23 -35z"/> <path d="M6750 3777 c16 -16 168 -62 177 -53 3 2 -35 17 -83 32 -49 14 -93 29 -99 32 -5 2 -3 -2 5 -11z"/> <path d="M6020 3703 c1 -27 30 -41 105 -50 44 -6 82 -9 84 -7 13 11 -29 34 -77 44 -31 6 -69 13 -84 16 -16 3 -28 2 -28 -3z"/> <path d="M6240 3656 c8 -7 42 -19 75 -25 33 -6 71 -14 85 -18 19 -4 22 -3 14 6 -11 12 -144 50 -174 51 -12 0 -12 -2 0 -14z"/> <path d="M4587 3641 l-57 -6 51 -80 c28 -44 54 -84 59 -88 9 -10 220 24 220 35 0 5 -21 40 -46 78 l-47 70 -61 -2 c-34 -1 -87 -4 -119 -7z"/> <path d="M5770 3636 c0 -4 7 -18 16 -31 15 -23 22 -25 95 -25 44 0 79 4 79 8 0 28 -30 41 -107 47 -46 4 -83 4 -83 1z"/> <path d="M6040 3622 c0 -20 27 -30 105 -37 71 -7 78 -6 67 7 -7 9 -35 19 -64 22 -28 4 -64 10 -79 13 -17 3 -29 1 -29 -5z"/> <path d="M5419 3576 l31 -44 82 5 c46 3 84 6 85 7 1 1 -9 19 -23 39 l-25 37 -90 0 -90 0 30 -44z"/> <path d="M5170 3574 c0 -17 84 -125 94 -121 7 3 44 8 82 12 38 4 72 9 76 12 4 2 -7 26 -25 53 l-32 50 -97 0 c-54 0 -98 -2 -98 -6z"/> <path d="M6846 3515 c3 -6 33 -17 67 -23 34 -7 73 -15 87 -18 60 -13 -10 16 -82 34 -54 14 -75 16 -72 7z"/> <path d="M3855 3461 c-60 -27 -111 -54 -113 -59 -2 -7 146 -236 194 -300 1 -2 42 25 91 60 49 34 99 70 111 78 l22 15 -85 128 c-47 70 -91 127 -98 127 -6 0 -61 -22 -122 -49z"/> <path d="M5896 3429 c20 -34 21 -34 105 -39 46 -3 85 -5 87 -4 8 5 -20 44 -36 53 -9 5 -53 12 -96 16 l-79 8 19 -34z"/> <path d="M4560 3374 c-30 -9 -72 -20 -92 -25 l-38 -10 76 -113 75 -113 102 43 c56 24 101 48 99 54 -1 6 -28 49 -59 95 -63 95 -63 95 -163 69z"/> <path d="M5245 3348 c-38 -5 -72 -11 -73 -13 -3 -2 80 -133 103 -163 4 -4 179 40 187 47 4 4 -13 37 -37 74 -51 75 -45 73 -180 55z"/> <path d="M6103 2155 c-136 -42 -218 -137 -250 -289 -35 -169 21 -292 153 -332 93 -28 261 -11 339 35 26 15 32 27 47 92 26 118 31 109 -71 109 l-89 0 -21 -62 c-12 -34 -31 -72 -43 -85 -27 -29 -73 -31 -88 -4 -15 29 -12 137 6 231 30 159 79 250 134 250 35 0 40 -13 40 -106 l0 -75 88 3 87 3 18 90 c21 106 22 103 -81 135 -75 23 -204 26 -269 5z"/> <path d="M7635 2156 c-106 -34 -178 -95 -222 -192 -83 -182 -27 -394 115 -434 81 -22 154 -8 208 42 22 19 22 19 32 -11 11 -30 13 -31 70 -31 l59 0 27 133 c14 72 26 138 26 145 0 9 -32 12 -124 12 -69 0 -127 -3 -129 -7 -2 -5 -7 -20 -11 -35 -6 -27 -5 -28 34 -28 46 0 49 -9 25 -68 -24 -55 -53 -82 -91 -82 -49 0 -58 25 -51 134 4 50 16 128 27 174 33 136 73 196 127 190 l28 -3 3 -88 3 -88 82 3 81 3 19 94 c21 108 25 101 -72 131 -73 23 -203 26 -266 6z"/> <path d="M3376 2143 c-9 -32 -126 -589 -126 -602 0 -10 44 -12 198 -9 182 3 201 5 250 27 75 34 144 113 173 198 31 92 32 228 2 294 -41 91 -93 109 -319 109 -156 0 -173 -2 -178 -17z m304 -77 c12 -32 -5 -181 -31 -284 -21 -82 -59 -156 -89 -172 -22 -12 -80 -14 -80 -2 0 4 20 102 45 217 25 116 48 222 51 238 5 25 10 27 50 27 38 0 46 -4 54 -24z"/> <path d="M4005 2148 c-18 -54 -87 -416 -88 -465 -2 -73 17 -107 79 -138 32 -16 59 -20 149 -20 100 0 115 2 168 28 63 31 99 71 121 135 12 32 106 450 106 468 0 2 -20 4 -44 4 -34 0 -46 -4 -50 -17 -2 -10 -24 -110 -47 -223 -55 -268 -77 -309 -170 -310 -52 0 -89 32 -89 76 0 20 20 129 45 243 25 114 45 213 45 219 0 17 -219 17 -225 0z"/> <path d="M4721 1863 c-34 -164 -65 -306 -67 -315 -5 -16 5 -18 104 -18 l109 0 22 103 c11 56 24 117 27 135 4 17 10 32 14 32 4 0 27 -61 50 -135 l44 -136 144 3 143 3 33 75 33 75 90 3 c102 3 103 3 103 -85 0 -74 -1 -73 126 -73 102 0 114 2 113 18 0 9 -14 150 -32 312 l-32 295 -121 3 -120 3 -135 -291 c-74 -159 -136 -290 -139 -290 -3 0 -26 55 -51 123 l-46 122 34 17 c19 10 42 23 51 30 27 23 52 91 52 145 0 44 -5 58 -30 86 -42 49 -83 57 -282 57 l-174 0 -63 -297z m347 215 c15 -15 15 -70 1 -122 -15 -54 -50 -86 -94 -86 -19 0 -35 2 -35 4 0 6 41 189 45 204 5 15 67 16 83 0z m477 -199 l10 -119 -72 0 -71 0 56 125 c31 68 58 122 62 119 3 -3 10 -59 15 -125z"/> <path d="M6555 2148 c-2 -7 -33 -148 -68 -313 l-63 -300 104 -3 c58 -1 106 -1 109 1 4 5 133 601 133 617 0 16 -209 13 -215 -2z"/> <path d="M6855 2148 c-2 -7 -30 -132 -60 -278 -31 -146 -60 -282 -65 -303 l-8 -38 46 3 47 3 45 212 c25 116 47 214 50 216 3 3 25 -76 48 -176 24 -100 48 -199 53 -219 l10 -38 118 0 118 0 62 293 c35 160 65 302 68 315 5 20 2 22 -40 22 -35 0 -47 -4 -51 -17 -2 -10 -24 -109 -47 -221 -24 -111 -46 -199 -50 -195 -5 7 -99 410 -99 428 0 3 -54 5 -120 5 -88 0 -122 -3 -125 -12z"/> </g> </svg>'

-- Functions
function handleTextCommandInput(text)
    print("Command: " .. text, false)

    -- Help
    if text == "help" then
        -- Outputs all commands with a description
        system.print("-==:: DU Racing Command Help ::==-")
        system.print('"add waypoint {ALT+2}" - adds the current position to the track waypoints')
        system.print('"save track [track name]" - saves the stored waypoints to screen')
        system.print('"list tracks" - lists all track keys saved in the databank')
        system.print('"broadcast track [track name]" - broadcasts track to central system')
        system.print('"export track [track name]" - exports the track JSON to the screen')
        system.print('"start {ALT+1}" - starts the test race with the set track key')
        return true
    end

    if text == "add waypoint" then
        if organiserMode == false then
            system.print("Waypoints can only be saved in organizer mode.")
            return false
        end
        return saveWaypoint()
    end
    if text == "countdown" then
        return startCountdown()
    end
    if text == "start" then
        if testRace == false then
            doError("Races can only be started manually when in test mode")
            return false
        end
        return startRace()
    end

    if text:find("save track ") then
        local trackName = string.gsub(text, "save track ", "")
        if trackName == "" then
            system.print("A track name must be used when saving a track. eg 'save track Alioth Loop'")
            return false
        end
        return saveTrack(trackName)
    end

    if text == "list tracks" then
        local keys = json.decode(db.getKeys())
        local out = ""
        for key, value in pairs(keys) do
            if value ~= "activeRace" then
                out = value .. ", " .. out
            end
        end
        return system.print(out)
    end

    if text:find("export track ") then
        local trackName = string.gsub(text, "export track ", "")
        if trackName == "" then
            system.print("A track name must be used when exporting a track. eg 'export track Alioth Loop'")
            return false
        end
        return exportTrack(trackName)
    end

    if text:find("broadcast track ") then
        local trackName = string.gsub(text, "broadcast track ", "")
        if trackName == "" then
            system.print("A track name must be used when broadcasting a track. eg 'broadcast track Alioth Loop'")
            return false
        end
        return broadcastTrack(trackName)
    end

    system.print("I can't... " .. text)
end

-- Message part system functions
function getKeysSortedByValue(tbl, sortFunction)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    table.sort(
        keys,
        function(a, b)
            return sortFunction(tbl[a], tbl[b])
        end
    )

    return keys
end

function getCompleteMessage()
    local sorted =
        getKeysSortedByValue(
        messageParts,
        function(a, b)
            return tonumber(a["index"]) < tonumber(b["index"])
        end
    )
    message = ""
    for _, key in ipairs(sorted) do
        message = message .. messageParts[key]["content"]
    end
    return message
end

function split(str, maxLength)
    local lines = {}

    local partLength = math.ceil(str:len() / maxLength)
    local len = partLength
    local startNum = 1
    local endNum = maxLength
    while partLength > 0 do
        table.insert(lines, string.sub(str, startNum, endNum))
        startNum = startNum + maxLength
        endNum = endNum + maxLength
        partLength = partLength - 1
    end
    return {lines = lines, length = len}
end

function splitBroadcast(action, channel, message)
    local index = 1
    local parts = split(message, 200)
    for _, line in ipairs(parts["lines"]) do
        local jsonStr = json.encode({i = index, len = parts["length"], action = action, content = line})
        local send = string.gsub(jsonStr, '\\"', "|")
        send = string.gsub(send, '"', '\\"')
        emitter.send(channel, send)
        index = index + 1
    end
end

-- calcDistance(vec3 v1, vec3 v2)
-- Returns the distance in metres between 2 vectors
function calcDistance(v1, v2)
    v = {}
    v.x = v1.x - v2.x
    v.y = v1.y - v2.y
    v.z = v1.z - v2.z
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

-- xyzPosition(float x, float y, float z)
-- Returns a waypoint string from the given coordinates
function xyzPosition(x, y, z)
    -- 0,2 for Alioth, although this seems broken it outputs 0,0 and works correctly, when setting the pos as "0,2" for Alioth the waypoint is incorrect
    return "::pos{0,0," .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "}"
end

-- checkWaypoint()
-- returns bool if user is in range of waypoint, triggers nextWaypoint
function checkWaypoint()
    if currentWaypoint == nil then
        return false
    end
    -- This is checked on loop
    pos = vec3(core.getConstructWorldPos())
    dest = vec3(waypoints[currentWaypointIndex])

    distance = calcDistance(pos, dest)

    -- Are we within 20m of our target destination?
    if distance <= radius then
        -- If so, save time, trigger next waypoint
        local t = round(system.getTime() - splitTime)
        table.insert(sectionTimes, t)
        -- reset split time
        splitTime = system.getTime()
        nextWaypoint()
        return true
    end

    return false
end

-- nextWaypoint
-- returns null increments the active index in use of waypoint, sets the vec3 waypoint for user
function nextWaypoint()
    local now = system.getTime()
    -- Queries the databank and set the next waypoint
    print("Waypoint #" .. currentWaypointIndex .. " complete.", true)
    incrementWaypoint()
    nextPoint = waypoints[currentWaypointIndex]
    -- no more waypoints?
    if nextPoint == nil then
        -- display lap time
        local lap = round(now - lapTime)
        table.insert(lapTimes, lap)

        -- check laps
        decrementLaps()

        if remainingLaps == 0 then
            endTime = now
            endRace()
            return true
        end

        -- reset lap start
        lapTime = now
        -- reset the waypoints for next lap
        nextPoint = waypoints[1]
    end
    currentWaypoint = vec3(nextPoint[1], nextPoint[2], nextPoint[3])
    system.setWaypoint(xyzPosition(currentWaypoint.x, currentWaypoint.y, currentWaypoint.z))
end
function decrementLaps()
    remainingLaps = remainingLaps - 1
    print("Lap complete.", true)
end
function incrementWaypoint()
    currentWaypointIndex = currentWaypointIndex + 1
    system.updateData(currentWaypointRef, '{"value":"' .. currentWaypointIndex .. '"}')
    system.updateData(
        currentWaypointBarRef,
        '{"percentage": ' .. math.floor((currentWaypointIndex / #waypoints) * 100) .. "}"
    )
end

function modulus(a, b)
    return a - math.floor(a / b) * b
end

-- Race Countdown
-- Sets the active race which is used to fetch waypoints
-- Triggered from a startline emitter, which waits 3 seconds then emits
-- Countdown 3,2,1 GO (await emit from start system, trigger start race)

-- Start Race
function startRace()
    unit.stopTimer("countGo")
    if raceStarted == false then
        gState = "test"
        gData.mainMessage = ""
        print("GO!", true)
        raceStarted = true
        -- set first waypoint
        currentWaypoint = vec3(waypoints[1][1], waypoints[1][2], waypoints[1][3])
        system.setWaypoint(xyzPosition(currentWaypoint.x, currentWaypoint.y, currentWaypoint.z))

        -- set start time and first split time
        startTime = system.getTime()
        lapTime = startTime
        splitTime = startTime
    end
end

--TODO Counts down from 5 to go. Needs to be able to communicate with tower
-- Suggest refactor on this to use 1 function that decrements a value
function startCountdown()
    unit.setTimer("count3", 1)
    unit.setTimer("count2", 2)
    unit.setTimer("count1", 3)
    unit.setTimer("countSet", 4)
    unit.setTimer("countGo", 5)
end
function countdownReady3()
    unit.stopTimer("count3")
    print("Ready.", true)
end
function countdownReady2()
    unit.stopTimer("count2")
    print("Ready..", true)
end
function countdownReady1()
    unit.stopTimer("count1")
    print("Ready...", true)
end
function countdownSet()
    unit.stopTimer("countSet")
    print("Set...", true)
end
-- End Race
function endRace()
    system.setWaypoint(nil)
     --TODO where do we set final waypoint?

    gData.mainMessage = "Final time " .. round(endTime - startTime) .. " s"

    print("Finished race", true)
    print("Section times:  " .. json.encode(sectionTimes), false)
    print("Lap times:  " .. json.encode(lapTimes), false)
    print("Final time: " .. round(endTime - startTime) .. " s", false)

    -- Emit this data
    if testRace == false then
        emitFinalTimes()
    end
end

function round(n)
    return tonumber(string.format("%.3f", n))
end

function round2(n)
    return tonumber(string.format("%.0f", n))
end
-- Emitter/Receiver functions

-- Clear DB
function clearDB()
    -- Clears the databank of all entries
    db.clear()
end

-- Set Track Waypoints
function setTrackWaypoints(trackKey, trackJson)
    -- Sets the JSON as waypoints for the location
    db.setStringValue(trackKey, trackJson)
end

-- Get Race Track
function getTrackWaypoints(trackKey)
    -- Fetches the waypoints from the DB and decodes them
    local track = db.getStringValue(trackKey)
    -- Sets the number of laps for this track
    track = json.decode(track)
    remainingLaps = track["laps"]
    totalLaps = track["laps"]
    return track["waypoints"]
end

-- Emit final times
function emitFinalTimes()
    -- JSON encode the logged times and emit them to the stadium
    local times = {
        lapTime = round(endTime - startTime),
        raceID = raceID,
        racer = unit.getMasterPlayerId()
    }

    -- TODO: Save these locally for inspection if needed

    -- TODO: this is an important notification, it should be sent on a loop until a confirmation message is returned
    local json = json.encode(times)
    local send = string.gsub(json, '"', '\\"')
    emitter.send("fdu-finish", send)
end

-- Race Organiser Functions

-- Save waypoint
function saveWaypoint()
    -- Saves the current position as a waypoint
    local pos = vec3(core.getConstructWorldPos())
    table.insert(savedWaypoints, {pos.x, pos.y, pos.z})

    -- Output to lua console for debug
    local curr = xyzPosition(pos.x, pos.y, pos.z)
    system.print(curr)
end

-- Save Track
function saveTrack(trackName)
    -- Exports current saved waypoints to JSON
    local track = {name = trackName, laps = 1, waypoints = savedWaypoints}
    if screen ~= nil then
        screen.setHTML(json.encode(track))
        system.print(
            "Track data has been exported to the screen. Edit the HTML to copy it. " ..
                "It has also been broadcast to the central system, you trigger this manually again if needed."
        )
    else
        system.print("Attach a screen to the board to export the JSON.")
    end

    system.print(
        "The data has also been saved to the database, exit organiser mode, " ..
            "set the active track as the name of the saved track and enter test mode to try it out."
    )

    db.setStringValue(trackName, json.encode(track))

    -- Add it as screen HTML so it can be copied as well
    -- TODO: Emits data to central hub
    local send = string.gsub(json.encode(track), '"', '\\"')
    emitter.send("fdu-addtrack", send)
end

-- save broadcasted track
function saveBroadcastedTrack(str)
    local track = json.decode(str)
    db.setStringValue(track["name"], str)
    loadTrack(track["name"])
    print(track["name"] .. " has been loaded")
end

-- load track
function loadTrack(name)
    waypoints = getTrackWaypoints(name)
    if waypoints == nil then
        doError("No track waypoints found in database")
        return false
    end
    system.updateData(currentWaypointRef, '{"value": 1, "unit": "/' .. #waypoints .. '"}')
    trackName = name
end

-- export track
function exportTrack(trackName)
    local track = db.getStringValue(trackName)
    if track == nil then
        doError("ERROR: Track not found")
        return false
    end
    if screen ~= nil then
        screen.setHTML(track)
        return system.print("Track has been exported to the screen HTML")
    end
    return system.print("No screen found.")
end

function toggleTestMode()
    testRace = ~testRace
    if (testRace) then
        enterTestMode()
    else
        exitTestMode()
    end
end

-- broadcast track
function broadcastTrack(trackName)
    local track = db.getStringValue(trackName)
    if track == nil then
        system.print("ERROR: Track not found")
        return false
    end
    splitBroadcast("save-track", "fdu-centralsplit", track)
    return system.print("Track has been broadcasted to central system")
end

--UI stuff
function updateOverlay()
    local html = '<div class="mainWrapper">'
    html = html .. '<div class="mainMessage">' .. gData.mainMessage .. "</div>"
    if (gData.toast ~= "") then
        html = html .. '<div class="toast">' .. gData.toast .. "</div>"
    end
    html =
        html ..
        '<div class="mainArea">' ..
        '<div class="logo">' ..
        duRacingLogo ..
        "</div>" ..
        '<div class="info">' ..
        '<span class="label">Track Name: </span><span class="value">' ..
        trackName ..
        "</span>" ..
        "</div>" ..
        '<div class="info">' ..
        '<span class="label">Team Name: </span><span class="value">' ..
        teamName .. 
        '&nbsp;&nbsp;<span style="magrin-left: 10px;display: inline-block; width: 10px; height: 10px; background: rgb(' .. teamColor .. ');"></span>' ..
        "</span>" ..
        "</div>" ..
        '<div class="info">' ..
        '<span class="label">Track Name: </span><span class="value">' ..
        trackName .. "</span>" .. 
        "</div>" .. 
        "</div>"

    -- disabled due to flicker
    --html = html ..
    --     '<div style="position: absolute; right: 5vw; top: 25vh;width: 10vw; height: 8vh;border:5px solid red;"><img class="map" src="'..map..'"/></div>'..
    --     '<div style="position: absolute; left: 3vw; top: 2vh;width: 10vw;"><img class="ad" src="'..ad..'"/><h2 class"sponsorText">'..sponsorText..'</h2></div>'..
    --     '</div>'
    system.setScreen(styles .. html)
end

function updateScreen()
    doUpdateScreen = false
end

function requestScreenUpdate(doOverlayToo)
    doUpdateScreen = true
    if (doOverlayToo) then
        updateOverlay()
    end
end

function clearOverlay()
    system.destroyWidgetPanel(raceInfoPanel)
end

function initOverlay()
    system.showScreen(1)
    --section: Race Status
    raceInfoPanel = system.createWidgetPanel("Race Status")
    currentWaypointBarRef = addProgressWidget(raceInfoPanel, 1)
    currentWaypointRef = addStaticWidget(raceInfoPanel, "1", "Waypoint", "/3")
    currentLapBarRef = addProgressWidget(raceInfoPanel, math.floor(1 / (totalLaps + 1) * 100))
    currentLapRef = addStaticWidget(raceInfoPanel, "1", "Current Lap", "/" .. totalLaps)

    lapTimeRef = addStaticWidget(raceInfoPanel, "0:00:00.000", "Lap Time", "")
    totalTimeRef = addStaticWidget(raceInfoPanel, "0:00:00.000", "Total Time", "")
    deltaTimeRef = addStaticWidget(raceInfoPanel, "--:--:--.---", "Your Best Lap", "")

    --section: Race Info
    --infoTitleWidget = system.createWidget(raceInfoPanel, "title")
    --infoTitleData = system.createData('{"text":"Race Info"}')
    --system.addDataToWidget(infoTitleData, infoTitleWidget)
--
    --addStaticWidget(raceInfoPanel, "Mos Espa Circuit", "Track Name", "")
    --addStaticWidget(raceInfoPanel, "XS-X-X", "Class", "")
    --addStaticWidget(raceInfoPanel, "0:00:00.000", "Track Record", "")
    --addStaticWidget(raceInfoPanel, "testKey1782", "Race Key", "")
    --addStaticWidget(raceInfoPanel, "37", "Length", "km")
    --addStaticWidget(raceInfoPanel, "Atmos", "Type", "")

    --section: Driver Profile
    --racerTitleWidget = system.createWidget(raceInfoPanel, "title")
    --racerTitleData = system.createData('{"text":"Driver Profile / Config"}')
    --system.addDataToWidget(racerTitleData, racerTitleWidget)

    --addStaticWidget(raceInfoPanel, "Obsidian", "Team Name", "")
    --addStaticWidget(raceInfoPanel, "Red", "Color", "")

    --set up styles
    styles =
        [[

    <style type="text/css">
    .mainWrapper, .glowText{
    	color: #a1ecfb;
      margin: 0 0 20px;
      transition: color 250ms ease-out;
      text-transform: uppercase;
    }
    .mainMessage{
      font-size: 7vh;
      position: absolute; 
      top: 15vh;
      left: 0;
      text-align: center;
      width: 100vw;
    }
    .toast{
      -webkit-animation: cssAnimation 0s ease-in 5s forwards;
      background-color: rgba(2,17,20,0.65);
      border: 1px solid rgb(2, 157, 187);
      font-size: 2vh;
      font-weight: 700;
      color: #a1ecfb;
      display: block;
      padding: 20px;
      animation-fill-mode: forwards;
      position: relative; 
      top: 80vh;
      left: 30vw;
      text-align: center;
      width: 40vw;
    }
    .mainArea {
      position: absolute; 
      left: 2vw; 
      top: 5vh;
      width: 30vw;
      height: 17vh;
      padding: 1vh 1vw;
    }
    .mainArea .logo {
      display: block;
      width: 17vw; 
      height: 17vh;
      background-color: rgba(2,17,20,0.65);
      padding: 2vh 2vw;
    }
    .mainArea .info {
      position: relative;
      display: block;
      padding: 1em 5em 1em 1em;
      overflow: hidden;
      margin: 10px 0;
      width: 17vw;
      border-top: 0;
      border-left: 1px solid rgb(2, 157, 187);
    }
    .mainArea .info:before {
      content : "";
      position: absolute;
      left    : 0;
      bottom  : 0;
      height  : 1px;
      width   : 15vw;
      border-bottom: 1px solid rgb(2, 157, 187);
    }
    .mainArea .info:after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(2,17,20,0.65);
      border: 1px solid rgb(2, 157, 187);
      transform-origin: 100% 0;
      transform: skew(-45deg);
      z-index: -1;
    }
    .mainArea .label {
      display: inline-block;
      width: 6vw;
    }
    .mainArea .value {
      display: inline-block;
      color: #ffffff;
    }
    .ad, .map{
      width: 100%;
    }
    @-webkit-keyframes cssAnimation {
      to {width: 0; height: 0; visibility: hidden;}
    }
      </style>  
  ]]

    requestScreenUpdate(true)
    system.showScreen(1)
end

function toast(message)
    gData.toast = message
    requestScreenUpdate(true)
end

function addProgressWidget(parentPanel, value)
    local tempWidget = system.createWidget(parentPanel, "gauge")
    local tempData = system.createData('{"percentage": ' .. value .. "}")
    system.addDataToWidget(tempData, tempWidget)
    return tempData
end

function addStaticWidget(parentPanel, value, label, unit)
    local tempWidget = system.createWidget(parentPanel, "value")
    local tempData =
        system.createData('{"value": "' .. value .. '","label":"' .. label .. '", "unit": "' .. unit .. '"}')
    system.addDataToWidget(tempData, tempWidget)
    return tempData
end

function updateTime()
    if not raceStarted then
        return
    end
    local now = system.getTime()
    system.updateData(totalTimeRef, '{"value": "' .. formatTime(now - startTime) .. '"}')
    system.updateData(lapTimeRef, '{"value": "' .. formatTime(now - lapTime) .. '"}')
end

function formatTime(seconds)
    local secondsRemaining = seconds
    local hours = math.floor(secondsRemaining / 3600)
    secondsRemaining = modulus(secondsRemaining, 3600)
    local minutes = math.floor(secondsRemaining / 60)
    local seconds = round2(modulus(secondsRemaining, 60))

    return leadingZero(hours) .. ":" .. leadingZero(minutes) .. ":" .. leadingZero(seconds)
end

function leadingZero(num)
    if (num < 10) then
        return "0" .. num
    end
    return num
end

-- Race screen
-- Sets up the race screen
-- Default is welcome screen, with buttons for test race

-- Test screen shows saved races and allows them to be selected
-- Hit the start button to start the countdown, then test starts

-- If we have start time show it on the screen instead of the welcome with split times
-- If we have end time then show final time with split times

-- Activate screen and UI
initOverlay()
if screen ~= nil then
    screen.activate()
end

function setDefaults()
end

function main()
    setDefaults()
    if organiserMode then
        trackName = "TBC"
        newRaceInfoPanel = system.createWidgetPanel("New Race")
        gState = "organiser"
        print("-==:: DU Racing Organiser Mode ::==-", false)
        print(
            [[
    "Travel to waypoints, type 'add waypoint' in lua console or press {ALT+2} to save the current location as a new waypoint. 
    Type 'save track [track name]' to save the track or 'broadcast track [track name]' to add it to the central system."]],
            false
        )
        gData.mainMessage = ""
        toast("Entering Organizer Mode")
    elseif testRace then
        enterTestMode()
    else
        -- emit racer online if we have a race ID
        if raceID ~= "" then
            local startData = {raceID = raceID, racer = unit.getMasterPlayerId()}
            emitter.send("fdu-register", string.gsub(json.encode(startData), '"', '\\"'))
        end
        gState = "awaiting"
        gData.mainMessage = "REGISTERING"
        toast("Registering with mainframe")
    end
end

function enterTestMode()
    print("-==:: DU Racing Test Mode ::==-")
    -- Check they have an active track
    if testTrackKey == "" then
        doError("No test track key has been set")
        return false
    end

    loadTrack(testTrackKey)

    print("Type 'start' in lua console or hit {ALT+1} to start the test race", false)
    gData.mainMessage = "Press ALT+1 to begin. "
    toast("Test mode activated")
end

function exitTestMode()
    print("Exiting Test Mode", true)
end
function setState(newState, newData, clear)
    gState = newState
    if (clear == true) then
        gData = newData
    else
        --todo, only overwrite new data
    end
end

function doError(msg)
    print("ERROR: " .. msg, true)
    gState = "error"
end

--Helper function to wrap system.print().  If second argument is true, it will also call a toast with the same message.
function print(msg, doToast)
    if (doToast) then
        toast(msg)
    end
    return system.print(msg)
end

main()
