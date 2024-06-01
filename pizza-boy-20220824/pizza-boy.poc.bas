   ;***************************************************************
   ;
   ;  Pizza boy concepts for kid_snz
   ;  Dave C
   ;
   ;  Concepts based on 
   ;
   ;    - "13 Objects With Coordinates and Collision (DPC+)"
   ;      "13 Objects With Coordinates (DPC+)"
   ;       etc
   ;       by Duane Alan Hahn (Random Terrain) et al
   ;    - PIZZBOY_2022_01_18.bas
   ;       by KevKelley 
   ;    - SolhSounds.asm
   ;       by Solh
   ; 
   ;***************************************************************


   includesfile multisprite_pizza.inc
   set kernel multisprite
   set romsize 16k
   set tv ntsc 
   set smartbranching on
 
/*

 Changes so far

 DONE: swap out graphics for kid_snz's 
 DONE: cabs to move up and down and also speed up and slow down?
 DONE: boy's speed slower, like a half speed?
 DONE: randomize pizza locations
 DONE: score to be in three digits with $.
 DONE: color for scores / lives
 DONE: no trees or cones
 DONE: dropoff and pretzel pickup a bit odd
 DONE: pickup locations weird
 POC: random sounds for, pick up pizza, pizza delivered, invulnerable? And I will try to pick ones I like.
 POC: change boy's hit by action, like an attached gif animation? It's like he spins twice.
 POC: collisions with buildings still a little odd?
 POC: add a temporary life icon? I'll play with the design.
 POC: title screen
 POC: background sounds / music
 MVP: 2 channel sound (SohlSound)
 MVP: start timing
 MVP: game over
 POC: clean up objectives
 
 TODO: 

   minikernels
     - clean up bottom of screen / scores / lives

   sound
      - some kind of start music?

   difficulty
     - more randomness?
     - more difficult routes?
     - faster taxis

   asymmetric playfield kernel
     - expose vars for one more tree, barricades and cones
     - need color and multiplayers support
     - need player movement and multiplexing
     - expose vars for collision

 
*/

   ;***************************************************************
   ;
   ;  Variable aliases go here (DIMs).
   ;

   dim lives_centered = 1

   dim _Taxi_0_Dx = a
   dim _Taxi_0_Dy = aa
   dim _Taxi_0_Ax = b
   dim _Taxi_0_Ay = bb
   dim _Taxi_1_Dx = c
   dim _Taxi_1_Dy = cc
   dim _Taxi_1_Ax = dd
   dim _Taxi_1_Ay = ee

   dim _Bicycle_Dx = d
   dim _Bicycle_Dy = e

   dim _PlayerState = f
   dim _Bit0_Has_Pizza = f
   dim _Bit1_Invulnerable = f
   dim _Bit2_Crash = f
   dim _Player_Effect_Time = g

   dim _P5DisplaySprite = h ; splits time between being the pretzel, Dropoff marker, etc..
   dim _P5DisplayTimer = i

   dim _Bicycle_Animation_Frame = j

   dim _Order_Poll_Time = k
   dim _Order_0_Address = l
   dim _Order_0_Time = m

   dim _Pretzel_Address = n
   dim _Pretzel_Time = o

   dim _Player_Invulnerable_Time = p
   dim _Player_Glow_Color = q

   dim _MusicTrack_0 = r
   dim _MusicSequence_0 = s
   dim _MusicTimer_0 = u

   dim _Pizza_Address = v
   dim _Pizza_Progress = ff

   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _Bit0_Reset_Restrainer = t
   dim _Bit1_Joy0_Restrainer = t
   dim _Bit3_Flip_p0 = t

   ;***************************************************************
   ;
   ;  Constants 
   ;

   
   const pfres = 32
   const screenheight=88
         pfheight=1

   const PX_SHIM = 7 ; x coordinates for p1-5 not same as p0 - this is how different
   const PY_SHIM = 2 ; y coordinates for p1-5 not same as p0 - this is how different

   const BK_COLOR = $00
   const PLAYER_COLOR = $ce
   const BUILDING_COLOR = $ae
   const PRETZEL_COLOR = $F6
   const TREE_COLOR = $3F
   const PIZZA_COLOR = $1c
   const TAXI_COLOR = $1e
   const EMOTICON_COLOR = $39
   const DROPOFF_COLOR = $39
   const CRASH_COLOR = $ce
   const BARRICADE_COLOR = $4A
   const CONE_COLOR = $42

   const PLAYER_START_X = 75
   const PLAYER_START_Y = 20
   const PLAYER_LEFT_LIMIT = 1
   const PLAYER_RIGHT_LIMIT = 144
   const PLAYER_TOP_LIMIT = 89
   const PLAYER_BOTTOM_LIMIT = 21
   const PLAYER_HEIGHT = 10
   const PLAYER_WIDTH = 8
   const PLAYER_INVULNERABLE_POLLS = 10
   const PLAYER_CRASH_TIME = 40

   const TAXI_LEFT_LIMIT = 1
   const TAXI_RIGHT_LIMIT = 160
   const TAXI_0_START_Y = 35
   const TAXI_0_Y_MIN = TAXI_0_START_Y - 3
   const TAXI_0_Y_MAX = TAXI_0_START_Y + 5
   const TAXI_1_START_Y = 63
   const TAXI_1_Y_MIN = TAXI_1_START_Y - 3
   const TAXI_1_Y_MAX = TAXI_1_START_Y + 5
   const TAXI_HEIGHT = 6
   const TAXI_WIDTH = 16
   const TAXI_DIV_DX = 12
   const TAXI_DIV_DX_MINUS_1 = TAXI_DIV_DX - 1
   const TAXI_DIV_DY = 12 
   const TAXI_DIV_DY_MINUS_1 = TAXI_DIV_DY - 1

   const PIZZA_X_OFFSET_R = 13
   const PIZZA_X_OFFSET = 3
   const PIZZA_Y_OFFSET = -1
   const PIZZA_HEIGHT = 5
   const PIZZA_WIDTH = 8

   const PRETZEL_HEIGHT = 6
   const PRETZEL_WIDTH = 8

   const OBSTACLE_HEIGHT = 8
   const OBSTACLE_HEIGHT_HALF = 4
   const OBSTACLE_WIDTH = 8
   const OBSTACLE_WIDTH_HALF = 4

   const ORDER_POLL_DURATION = 40
   const ORDER_COOLDOWN_POLLS = 1
   const ORDER_WAIT_POLLS = 30
   const ORDER_WAIT_START = 5

   const PRETZEL_WAIT_START = 5
   const PRETZEL_COOLDOWN_POLLS = 20
   const PRETZEL_WAIT_POLLS = 10

   const DISPLAY_OBJ_NONE = 0
   const DISPLAY_OBJ_PRETZEL = 1
   const DISPLAY_OBJ_EMOTICON_0 = 2
   const DISPLAY_OBJ_DROPOFF_0 = 3

   const DISPLAY_TIMER_DURATION = 10

   const START_LIVES = 3 * 32
   const DELIVERY_SCORE = 10 ; note: BCD

   ; allow the players to overlap the bottoms of buildings
   ; we will push the players back vertically if approaching buildings from the street
   ; horizontally if approaching from the sides
   ; 82
   ;    32 DC? 36 BPS? 72 DC? 76 BPS? 112 DC? 116 T
   ; 68
   ;         < taxi >
   ; 54
   ;16 DC? 20 BPS? 56 DC? 60 BPS? 96 DC? 100 BPS? 136 DC? 140
   ; 40
   ;         < taxi >
   ; 24
   ;   T 32 DC? 36 BPS? 72 DC? 76 BPS? 112 DC? 116
   ; 12
   const STREET_FRONT_0_Y_MIN = 68
   const STREET_FRONT_0_Y_MAX = STREET_FRONT_0_Y_MIN + PLAYER_HEIGHT + 1
   const STREET_ALLEY_0_Y_MAX = STREET_FRONT_0_Y_MAX + 14
   const STREET_FRONT_1_Y_MIN = 40
   const STREET_FRONT_1_Y_MAX = STREET_FRONT_1_Y_MIN + PLAYER_HEIGHT + 1
   const STREET_ALLEY_1_Y_MAX = STREET_FRONT_1_Y_MAX + 14
   const STREET_FRONT_2_Y_MIN = 12
   const STREET_FRONT_2_Y_MAX = STREET_FRONT_2_Y_MIN + PLAYER_HEIGHT + 1
   const STREET_ALLEY_2_Y_MAX = STREET_FRONT_2_Y_MAX + 14

   ; standard volume
   const DEFAULT_VOLUME = $0a

   ; musical notes for frequency data
   const _A3  = 31
   const _B3  = 28
   const _C4  = 26
   const _CS4 = 25
   const _D4  = 23
   const _DS4 = 22
   const _E4  = 21
   const _F4  = 20
   const _FS4 = 18
   const _G4  = 17
   const _A4  = 15
   const _B4  = 14
   const _C5  = 13
   const _CS5 = 12
   const _D5  = 11
   const _E5  = 10

   ;***************************************************************
   ;
   ;  PROGRAM START/RESTART + TITLE SCREEN
   ;
__Start_Restart

   ; use temp5 and temp4 to make a timer for how long to show the title screen
   ; we will start temp4 at 60, when it reaches 0 we subtract 1 from temp5
   temp5 = 2  ; 2 seconds
   temp4 = 60 ; initialize 60 frames

__Title_Screen

   gosub pizza_title bank3 ; draw the title screen
   temp4 = temp4 - 1
   if temp4 then goto __Title_Screen 
   temp4 = 60 ; temp4 reached 0, reset to 60 
   temp5 = temp5 - 1
   if !temp5 then goto __Start_Screen ; temp5 hit zero, exit title
   goto __Title_Screen
   
__Start_Screen
   
   ;***************************************************************
   ;
   ;  Static sprite shapes and colors.
   ;

   ; player0 is the pizza boy, we set player0 shape in the game animation loop

   ; taxi 0  
   player1:
    %01000100
    %11111110
    %10101010
    %01010100
    %01111100
    %00010000
end

   ; taxi 1 
   player2:
    %01000100
    %11111110
    %10101010
    %01010100
    %01111100
    %00010000
end

   ; pizza   
   player3:
    %11111110
    %01011010
    %00111110
    %00010100
    %00001000
end

   lives:
    %00011100
    %00100010
    %01111110
    %00101011
    %11111110
    %00111110
    %00011100      
end

   ;***************************************************************
   ;
   ;  Initial object placement.
   ;

   player0x = PLAYER_START_X : player0y = PLAYER_START_Y
   player1x = TAXI_RIGHT_LIMIT : player1y = TAXI_0_START_Y
   player2x = TAXI_LEFT_LIMIT: player2y = TAXI_1_START_Y
   player3x = 0
   player3y = 0
   player4x = 0
   player4y = 0
   _Pizza_Progress = 0
   _Pizza_Address = 0
   _Order_0_Address = 0

   ;***************************************************************
   ;
   ;  Mute volume of both sound channels.
   ;

   AUDV0 = 0 : AUDV1 = 0


   ;***************************************************************
   ;
   ;  Clears all normal variables and the extra 9 (fastest way).
   ;

   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0


   ;***************************************************************
   ;
   ;  Set repetition restrainer for the reset switch.
   ;  (Holding it down won't make it keep resetting.)
   ;

   lives = lives | START_LIVES
   lifecolor = PLAYER_COLOR
   scorecolor = TREE_COLOR
   score = 0

   _Bit0_Reset_Restrainer{0} = 1

   _P5DisplaySprite = DISPLAY_OBJ_PRETZEL ; which object to display for player 5
   _Order_Poll_Time = ORDER_POLL_DURATION ; how many frames before we check for pizza orders 
   _Order_0_Time = ORDER_WAIT_START ; number of polls to wait before making a new pizza order
   _Pretzel_Time = PRETZEL_WAIT_START ; number of polls to wait before showing pretzel

   ; Taxi 0 accelaration values - will be varied to control taxi movement
   _Taxi_0_Ay = 2
   _Taxi_0_Ax = -8
   
   ; Taxi 1 accelaration values - will be varied to control taxi movement
   _Taxi_1_Ay = -2
   _Taxi_1_Ax = 8

   goto __Bank_2 bank2

   bank 2


__Bank_2

   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
__Main_Loop


   ;```````````````````````````````````````````````````````````````
   ;  Music
   ;

   ; check if a music track is playing
   if !_MusicTrack_0 then goto __Skip_Music ; no track
   if !_MusicSequence_0 then goto __Play_Sequence ; where in the track are we
   if !_MusicTimer_0 then goto __Play_Note ; how long the current note should play

   _MusicTimer_0 = _MusicTimer_0 - 1 ; count down to next note
   if _MusicTimer_0 then goto __Skip_Music ; skip if not at zero yet

   goto __Play_Note

__Play_Sequence

   _MusicSequence_0 = _MusicTrack_0 ; track # is an index into music data

__Play_Note
   ; read note from music data as 4 values
   ; sound to play, frequency, volume, duration

   temp1 = _Data_Music[_MusicSequence_0] ; read next index
   if temp1 = 255 then goto __End_Sequence ; if see a 255, the track is done
   _MusicSequence_0 = _MusicSequence_0 + 1 ; advance 1 
   if temp1 = 0 then goto __Rest_Sequence ; if we see a 0, that means rest
   
   AUDC0 = temp1 ; otherwise use the first value as the sound to play
   AUDC1 = temp1 ; will use the same sound in channel 0 and 1
   
   temp1 = _Data_Music[_MusicSequence_0] ; read next value (frequency)
   _MusicSequence_0 = _MusicSequence_0 + 1 
   temp2 = _Data_Music[_MusicSequence_0] ; read next value (volume)
   _MusicSequence_0 = _MusicSequence_0 + 1

   ; hack: if frequency has bit 5 set will play channel 1 to create harmonic effect
   if !temp1{5} then AUDV1 = 0 : goto __SkipAUDF1 ; check if bit 5 us set
   temp1 = temp1 & $1f ; mask out the bit 5
   AUDF1 = temp1 - 2 ; will play channel 1 at slightly different frequency
   AUDV1 = temp2 ; set channel 1 volume
__SkipAUDF1
   AUDF0 = temp1 ; set channel 0 frequency
   AUDV0 = temp2 ; set channel 1 volume
   _MusicTimer_0 = _Data_Music[_MusicSequence_0] ; set duration of note
   _MusicSequence_0 = _MusicSequence_0 + 1
   
   goto __Skip_Music

__Rest_Sequence
   
   ; resting: zero out volume for channel 0 and 1 
   AUDV0 = 0
   AUDV1 = 0

   _MusicTimer_0 = _Data_Music[_MusicSequence_0] ; set duration of rest
   _MusicSequence_0 = _MusicSequence_0 + 1
   
   goto __Skip_Music

__End_Sequence

   ; track is over - zero music  
   _MusicTrack_0 = 0
   _MusicSequence_0 = 0
   _MusicTimer_0 = 0
   AUDV0 = 0
   AUDV1 = 0

__Skip_Music

   if lives < 32 then goto __Game_Overness bank4

   ;```````````````````````````````````````````````````````````````
   ;  Set Colors
   ;

   COLUBK = BK_COLOR
   COLUPF = BUILDING_COLOR
   COLUP0 = PLAYER_COLOR
   _COLUP1 = TAXI_COLOR
   COLUP2 = TAXI_COLOR
   COLUP3 = PIZZA_COLOR

   ;```````````````````````````````````````````````````````````````
   ;  Player state - control short term effects like player glowing
   ;
   
   if _Player_Effect_Time = 0 then goto __Skip_Player_State_Update ; if player effect time is zero skip

   _Player_Effect_Time = _Player_Effect_Time - 1 
   if _Player_Effect_Time > 0 then goto __Skip_Player_State_Update

   ; remove any effects but preserve the pizza bit
   _PlayerState = _PlayerState & %00000001

__Skip_Player_State_Update

   ;```````````````````````````````````````````````````````````````
   ;  Collision checks
   ;

   ; check if player touched a building
   if !collision(playfield, player0) then goto __Skip_PF_Collision 
   ; check if player has pizza
   if !_Bit0_Has_Pizza{0} then goto __Skip_Pizza_Delivery_Check
   
   ; player has touched a building and has pizza
   ; check if that building is the delivery target
   temp2 = _Data_Dropoff_Y[_Order_0_Address]
   temp1 = temp2 - 4
   temp3 = _Data_Dropoff_X[_Order_0_Address]
   temp4 = temp3 + 8   
   if (player0y - PLAYER_HEIGHT) <= temp2 && player0y >= temp1 && (player0x + PLAYER_WIDTH) >= temp3 && player0x <= temp4 then goto __Pizza_Delivery

   goto __Skip_Pizza_Delivery_Check

__Pizza_Delivery

   ; delivered the pizza, need to update score
   _Bit0_Has_Pizza{0} = 0
   dec temp5 = DELIVERY_SCORE ; for some reason need to use var can't just add BCD 10 to score
   score = score + temp5
   _Order_0_Address = 0
   _Pizza_Address = 0
   _Pizza_Progress = _Pizza_Progress + 1
   _Order_Poll_Time = 0
   _Order_0_Time = ORDER_COOLDOWN_POLLS ; how many polls to wait for next order
   player3x = 0
   player3y = 0
   player4x = 0
   player4y = 0

   _MusicTrack_0 = 51 ; play music track
   _MusicSequence_0 = 51 ; force to play

__Skip_Pizza_Delivery_Check

   ; still processing building touch
   ; the following determines if we need to push the player away from a building they have touched
   ; attempts to deduce which direction to push back based on what part of the screen they are on
   ; also allows some overlap on fronts of buildings
   if player0y > (STREET_ALLEY_0_Y_MAX - 4) then goto __Side_PF_Collision_3A
   if player0y > STREET_FRONT_0_Y_MAX then goto __Side_PF_Collision_3B
   if player0y >= STREET_FRONT_0_Y_MAX then player0y = STREET_FRONT_0_Y_MAX - 1 : goto __Stop_Player_Y   
   if player0y >= STREET_FRONT_0_Y_MIN then goto __Skip_PF_Collision
   if player0y >= STREET_ALLEY_1_Y_MAX then player0y = STREET_ALLEY_1_Y_MAX + 1: goto __Stop_Player_Y
   if player0y > (STREET_ALLEY_1_Y_MAX - 4) then goto __Side_PF_Collision_4A
   if player0y > STREET_FRONT_1_Y_MAX then goto __Side_PF_Collision_4B
   if player0y >= STREET_FRONT_1_Y_MAX then player0y = STREET_FRONT_1_Y_MAX - 1: goto __Stop_Player_Y   
   if player0y >= STREET_FRONT_1_Y_MIN then goto __Skip_PF_Collision
   if player0y >= STREET_ALLEY_2_Y_MAX then player0y = STREET_ALLEY_2_Y_MAX + 1: goto __Stop_Player_Y
   if player0y > (STREET_ALLEY_2_Y_MAX - 4) then goto __Side_PF_Collision_3A
   if player0y > STREET_FRONT_2_Y_MAX then goto __Side_PF_Collision_3B
   if player0y >= STREET_FRONT_2_Y_MAX then player0y = STREET_FRONT_2_Y_MAX - 1: goto __Stop_Player_Y
   
   goto __Skip_PF_Collision

__Stop_Player_Y

   ; player needs to stop moving up/down due to touching a building
   _Bicycle_Dy = 0
   goto __Skip_PF_Collision

__Side_PF_Collision_3A

   ; 3 building block
   ; player at upper part of an alley and needs to be pushed back left/right
   temp4 = player0x / 4
   temp5 = _Data_Alley_3A_X[temp4]
   if temp5 then player0x = temp5
   goto __Stop_Player_X

__Side_PF_Collision_3B

   ; 3 building block
   ; player at bottom part of an alley and needs to be pushed back left/right
   temp4 = player0x / 4
   temp5 = _Data_Alley_3B_X[temp4]
   if temp5 then player0x = temp5
   goto __Stop_Player_X

__Side_PF_Collision_4A

   ; 4 building block
   ; player at upper part of an alley and needs to be pushed back left/right
   temp4 = player0x / 4
   temp5 = _Data_Alley_4A_X[temp4]
   if temp5 then player0x = temp5
   goto __Stop_Player_X

__Side_PF_Collision_4B

   ; 4 building block
   ; player at upper part of an alley and needs to be pushed back left/right
   temp4 = player0x / 4
   temp5 = _Data_Alley_4B_X[temp4]
   if temp5 then player0x = temp5
   goto __Stop_Player_X

__Stop_Player_X

   ; stop player moving left/right
   _Bicycle_Dx = 0
   
__Skip_PF_Collision

   ; if player is currently in a crash don't process collision
   if _Bit2_Crash{2} then goto __Skip_p0_Collision

   ; touched an object
   if !collision(player0, player1) then goto __Skip_p0_Collision

   ; start figuring out which object got hit...

   temp1 = player0y - PY_SHIM
   temp2 = temp1 - PLAYER_HEIGHT
   temp3 = player0x + PX_SHIM
   temp4 = temp3 + PLAYER_WIDTH

   if temp2 <= player1y && temp1 >= (player1y - TAXI_HEIGHT) && temp4 >= player1x && temp3 <= (player1x + TAXI_WIDTH) then goto __Taxi_Hit
   if temp2 <= player2y && temp1 >= (player2y - TAXI_HEIGHT) && temp4 >= player2x && temp3 <= (player2x + TAXI_WIDTH) then goto __Taxi_Hit

   temp5 = _Data_Pretzel_Y[_Pretzel_Address]
   temp6 = _Data_Pretzel_X[_Pretzel_Address]
   
   if temp2 <= temp5 && temp1 >= (temp5 - PRETZEL_HEIGHT) && temp4 >= temp6 && temp3 <= (temp6 + PRETZEL_WIDTH) then goto __Pretzel_Grab

   if temp2 <= player4y && temp1 >= (player4y - OBSTACLE_HEIGHT) && temp4 >= player4x && temp3 <= (player4x + OBSTACLE_WIDTH) then goto __Obstacle_Hit

   if _Bit0_Has_Pizza{0} then goto __Skip_p0_Collision

   if temp2 <= player3y && temp1 >= (player3y - PIZZA_HEIGHT) && temp4 >= player3x && temp3 <= (player3x + PIZZA_WIDTH) then goto __Pizza_Grab

   goto __Skip_p0_Collision

__Taxi_Hit ; hit a taxi

   ; if we are invulnerable don't bother processing 
   if _Bit1_Invulnerable{1} then goto __Skip_p0_Collision

   ; crashed and dropped the pizza
   _PlayerState = %00000100
   _Player_Effect_Time = PLAYER_CRASH_TIME

   player3x = _Data_Pizza_X[_Pizza_Address]
   player3y = _Data_Pizza_Y[_Pizza_Address]
   COLUP0 = CRASH_COLOR

   lives = lives - 32
   if lives > 32 then _MusicTrack_0 = 1 : _MusicSequence_0 = 1 : goto __Skip_p0_Collision
   _MusicTrack_0 = 14 ; play crash tune
   _MusicSequence_0 = 14 ; force to play
   _P5DisplayTimer = _Player_Effect_Time ; use to time reset
   player4x = player0x
   player4y = player0y

   goto __Game_Overness bank4

__Pizza_Grab ; pick up the pizza

   ; touched the pizza
   _Bit0_Has_Pizza{0} = 1

   _MusicTrack_0 = 51 ; play pick up pizza sound
   _MusicSequence_0 = 51
   
   goto __Skip_p0_Collision

__Obstacle_Hit ; hit a tree or barricade

   temp5 = player4y - OBSTACLE_HEIGHT_HALF
   if temp2 > temp5 then player0y = player0y + 1 : _Bicycle_Dy = 0 : goto __Obstacle_Hit_X
   if temp1 < temp5 then player0y = player0y - 1 : _Bicycle_Dy = 0 : goto __Obstacle_Hit_X

__Obstacle_Hit_X ;

   temp5 = player4x + OBSTACLE_WIDTH_HALF
   if temp3 > temp5 then player0x = player0x + 1 : _Bicycle_Dx = 0 : goto __Skip_p0_Collision
   if temp4 < temp5 then player0x = player0x - 1 : _Bicycle_Dx = 0 

   goto __Skip_p0_Collision

__Pretzel_Grab

   ; touched the pretzel
   _Bit1_Invulnerable{1} = 1
   _Pretzel_Address = 0
   _Pretzel_Time = PRETZEL_COOLDOWN_POLLS
   _Player_Invulnerable_Time = PLAYER_INVULNERABLE_POLLS

   _MusicTrack_0 = 130 ; play pretzel music
   _MusicSequence_0 = 130

__Skip_p0_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Player movement code...
   ;

   if _Bit2_Crash{2} then goto __Player_Animate ; if player is crashing don't allow movement

   ; figure out joystick direciton
   if joy0up then if player0y <= PLAYER_TOP_LIMIT then _Bicycle_Dy = _Bicycle_Dy + 4
   if joy0down then if player0y >= PLAYER_BOTTOM_LIMIT then _Bicycle_Dy = _Bicycle_Dy - 4
   if joy0left then if player0x >= PLAYER_LEFT_LIMIT then _Bicycle_Dx = _Bicycle_Dx - 4 : _Bit3_Flip_p0{3} = 0
   if joy0right then if player0x <= PLAYER_RIGHT_LIMIT then _Bicycle_Dx = _Bicycle_Dx + 4 : _Bit3_Flip_p0{3} = 1

   ; if joystick was moved go to animation
   if joy0left || joy0right then _Bicycle_Animation_Frame = _Bicycle_Animation_Frame + 1 : goto __Player_Animate
   if joy0up || joy0down then _Bicycle_Animation_Frame = _Bicycle_Animation_Frame + 1 : goto __Player_Animate

   ; joystick wasn't moved, so stop player movement
   _Bicycle_Dx = 0
   _Bicycle_Dy = 0
   _Bicycle_Animation_Frame = 0 ; at rest

__Player_Animate

   ; adjust player color if they are invulnerable or crashing
   if _Bit1_Invulnerable{1} then COLUP0 = _Player_Glow_Color : _Player_Glow_Color = _Player_Glow_Color + 1
   if _Bit2_Crash{2} then COLUP0 = CRASH_COLOR

   ; update dx. watch out for negative numbers...
   temp4 = 0
__Bicycle_Dx_Update
   if _Bicycle_Dx >= 8 && _Bicycle_Dx < 128 then _Bicycle_Dx = _Bicycle_Dx - 8 : temp4 = temp4 + 1 : goto __Bicycle_Dx_Update
   temp5 = _Bicycle_Dx + 7
   if temp5 >= 128 then _Bicycle_Dx = _Bicycle_Dx + 8 : temp4 = temp4 -1 : goto __Bicycle_Dx_Update
   player0x = player0x + temp4

   ; update dy. watch out for negative numbers...
   temp4 = 0
__Bicycle_Dy_Update
   if _Bicycle_Dy >= 8 && _Bicycle_Dy < 128 then _Bicycle_Dy = _Bicycle_Dy - 8 : temp4 = temp4 + 1 : goto __Bicycle_Dy_Update
   temp5 = _Bicycle_Dy + 7
   if temp5 >= 128 then _Bicycle_Dy = _Bicycle_Dy + 8 : temp4 = temp4 -1 : goto __Bicycle_Dy_Update
   player0y = player0y + temp4

   ; check if player has pizza  
   if !_Bit0_Has_Pizza{0} then goto __Skip_Has_Pizza

   ; player has pizza so position pizza next to player
   player3y = player0y + PIZZA_Y_OFFSET 
   if _Bit3_Flip_p0{3} then player3x = player0x + PIZZA_X_OFFSET_R
   if !_Bit3_Flip_p0{3} then player3x = player0x + PIZZA_X_OFFSET
   
__Skip_Has_Pizza

   ; cycle animations
   if _Bicycle_Animation_Frame = 16 then _Bicycle_Animation_Frame = 1
   if _Bit2_Crash{2} then _Bicycle_Animation_Frame = _Bicycle_Animation_Frame - 1
   if _Bicycle_Animation_Frame > 128 && _Bicycle_Animation_Frame < 240 then _Bicycle_Animation_Frame = 255
 
   ; set player shape based on animation frame

 if _Bicycle_Animation_Frame >= 240 && _Bicycle_Animation_Frame < 244 then  player0:
    %00001110
    %00110110
    %00001100
    %00000110
    %11011110
    %01111100
    %01011010
    %10101101
    %10100101
    %01000010
end
 if _Bicycle_Animation_Frame >= 244 && _Bicycle_Animation_Frame < 248 then  player0:
    %00000000
    %01101000
    %10011000
    %01110010
    %00111010
    %01110101
    %01111111
    %10011011
    %01100000
    %00000000
end
 if _Bicycle_Animation_Frame >= 248 && _Bicycle_Animation_Frame < 252 then  player0:
    %01000010
    %10100101
    %10110101
    %01011010
    %00111110
    %01111011
    %01100000
    %00110000
    %01101100
    %01110000
end
 if _Bicycle_Animation_Frame >= 252 && _Bicycle_Animation_Frame <= 255 then  player0:
    %00000000
    %00000110
    %11011001
    %11111110
    %10101110
    %01011100
    %01001110
    %00011001
    %00010110
    %00000000
end

 if _Bicycle_Animation_Frame = 0  then  player0:
    %01000010
    %10100101
    %10101101
    %01011010
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end

 if _Bicycle_Animation_Frame > 1 && _Bicycle_Animation_Frame < 9 then player0:
    %01100011
    %10100101
    %10101101
    %11011110
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end  

 if _Bicycle_Animation_Frame >= 9 && _Bicycle_Animation_Frame < 16 then  player0:
    %11000110
    %10100101
    %10101101
    %01111011
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end
 ; end player movement
   
   ;```````````````````````````````````````````````````````````````
   ;  Taxi Movement and Sound
   ;

   temp1 = 0 ; we will set temp1 > 0 if we think we need to play a taxi sound

   ; update dx. watch out for negative numbers...

   _Taxi_0_Dx = _Taxi_0_Dx + _Taxi_0_Ax ; add taxi acceleration to taxi velocity 
   temp4 = 0
__Taxi_0_Dx_Update
   if _Taxi_0_Dx >= TAXI_DIV_DX && _Taxi_0_Dx < 128 then _Taxi_0_Dx = _Taxi_0_Dx - TAXI_DIV_DX : temp4 = temp4 + 1 : goto __Taxi_0_Dx_Update
   temp5 = _Taxi_0_Dx + TAXI_DIV_DX_MINUS_1
   if temp5 >= 128 then _Taxi_0_Dx = _Taxi_0_Dx + TAXI_DIV_DX: temp4 = temp4 -1 : goto __Taxi_0_Dx_Update
   player1x = player1x + temp4

   ; check if taxi 0 has scrolled off screen
   if player1x < TAXI_LEFT_LIMIT then player1x = TAXI_RIGHT_LIMIT : temp1 = 1
   if player1x > TAXI_RIGHT_LIMIT then player1x = TAXI_LEFT_LIMIT : temp1 = 1

   ; update dy. watch out for negative numbers...
   _Taxi_0_Dy = _Taxi_0_Dy + _Taxi_0_Ay ; add taxi acceleration to taxi velocity
   temp4 = 0
__Taxi_0_Dy_Update
   if _Taxi_0_Dy >= TAXI_DIV_DY && _Taxi_0_Dy < 128 then _Taxi_0_Dy = _Taxi_0_Dy - TAXI_DIV_DY : temp4 = temp4 + 1 : goto __Taxi_0_Dy_Update
   temp5 = _Taxi_0_Dy + TAXI_DIV_DY_MINUS_1
   if temp5 >= 128 then _Taxi_0_Dy = _Taxi_0_Dy + TAXI_DIV_DY : temp4 = temp4 - 1 : goto __Taxi_0_Dy_Update
   player1y = player1y + temp4

   if player1y < TAXI_0_Y_MIN then player1y = TAXI_0_Y_MIN : _Taxi_0_Ay = -_Taxi_0_Ay
   if player1y > TAXI_0_Y_MAX then player1y = TAXI_0_Y_MAX : _Taxi_0_Ay = -_Taxi_0_Ay

   _Taxi_1_Dx = _Taxi_1_Dx + _Taxi_1_Ax ; add taxi acceleration to taxi velocity 
   temp4 = 0
__Taxi_1_Dx_Update
   if _Taxi_1_Dx >= TAXI_DIV_DX && _Taxi_1_Dx < 128 then _Taxi_1_Dx = _Taxi_1_Dx - TAXI_DIV_DX : temp4 = temp4 + 1 : goto __Taxi_1_Dx_Update
   temp5 = _Taxi_1_Dx + TAXI_DIV_DX_MINUS_1
   if temp5 >= 128 then _Taxi_1_Dx = _Taxi_1_Dx + TAXI_DIV_DX : temp4 = temp4 -1 : goto __Taxi_1_Dx_Update
   player2x = player2x + temp4

   ; check if taxi 1 has scrolled off screen
   if player2x < TAXI_LEFT_LIMIT then player2x = TAXI_RIGHT_LIMIT : temp1 = 2
   if player2x > TAXI_RIGHT_LIMIT then player2x = TAXI_LEFT_LIMIT : temp1 = 2

   ; update dy. watch out for negative numbers...
   _Taxi_1_Dy = _Taxi_1_Dy + _Taxi_1_Ay ; add taxi acceleration to taxi velocity 
   temp4 = 0
__Taxi_1_Dy_Update
   if _Taxi_1_Dy >= TAXI_DIV_DY && _Taxi_1_Dy < 128 then _Taxi_1_Dy = _Taxi_1_Dy - TAXI_DIV_DY : temp4 = temp4 + 1 : goto __Taxi_1_Dy_Update
   temp5 = _Taxi_1_Dy + TAXI_DIV_DY_MINUS_1
   if temp5 >= 128 then _Taxi_1_Dy = _Taxi_1_Dy + TAXI_DIV_DY : temp4 = temp4 - 1 : goto __Taxi_1_Dy_Update
   player2y = player2y + temp4

   if player2y < TAXI_1_Y_MIN then player2y = TAXI_1_Y_MIN : _Taxi_1_Ay = -_Taxi_1_Ay
   if player2y > TAXI_1_Y_MAX then player2y = TAXI_1_Y_MAX : _Taxi_1_Ay = -_Taxi_1_Ay

   ; if no music is playing but temp1 got set we will play a taxi sound
   if !temp1 || _MusicTrack_0 then goto __Skip_Taxi_Sound
   if temp1 = 1  then _MusicTrack_0 = 76 : goto __Skip_Taxi_Sound; play the honk honk
   _MusicTrack_0 = 103

__Skip_Taxi_Sound

   ;```````````````````````````````````````````````````````````````
   ;  P5 Sprite Swapping
   ;  Compensates for only having 6 sprites by switching player5 between different shapes
   ;

   if !_P5DisplaySprite then goto __SkipP5Display

   _P5DisplayTimer = _P5DisplayTimer - 1
   if _P5DisplayTimer > 0 then goto __SkipP5Display

   _P5DisplayTimer = DISPLAY_TIMER_DURATION

   _P5DisplaySprite = _P5DisplaySprite + 1
   if _P5DisplaySprite = DISPLAY_OBJ_PRETZEL && !_Pretzel_Address then _P5DisplaySprite = _P5DisplaySprite + 1
   if _P5DisplaySprite >= DISPLAY_OBJ_EMOTICON_0 && !_Order_0_Address then  _P5DisplaySprite = _P5DisplaySprite + 1
   if _P5DisplaySprite > DISPLAY_OBJ_DROPOFF_0 then _P5DisplaySprite = DISPLAY_OBJ_PRETZEL

   if _P5DisplaySprite = DISPLAY_OBJ_PRETZEL then goto __P5IsPretzel
   if _P5DisplaySprite = DISPLAY_OBJ_EMOTICON_0 then goto __P5IsEmoticon0
   if _P5DisplaySprite = DISPLAY_OBJ_DROPOFF_0 then goto __P5IsDropoff0

   goto __SkipP5Display
    
__P5IsPretzel

   player5:
   ; pretzel
    %00111000
    %01000100
    %10101010
    %10010010
    %10010010
    %01101100
end

   player5x = _Data_Pretzel_X[_Pretzel_Address]
   player5y = _Data_Pretzel_Y[_Pretzel_Address]
   COLUP5 = PRETZEL_COLOR

   goto __SkipP5Display

__P5IsEmoticon0

   player5:
   ; emoticon
    %01000000
    %00000000
    %00110000
    %00111000
    %00011000
end

   player5x = _Data_Emoticon_X[_Order_0_Address]
   player5y = _Data_Emoticon_Y[_Order_0_Address]
   COLUP5 = EMOTICON_COLOR

   goto __SkipP5Display

__P5IsDropoff0

   player5:
   ; dropoff
        %00101000
        %00101000
        %00101000
        %00101000
        %10111000
        %10111000
        %10111000
        %01111100
        %00110010
        %00111001
        %00011000
end

   player5x = _Data_Dropoff_X[_Order_0_Address]
   player5y = _Data_Dropoff_Y[_Order_0_Address]
   COLUP5 = DROPOFF_COLOR

   goto __SkipP5Display


__SkipP5Display

   ;***************************************************************
   ;
   ; Taxi Driving, Pizza Orders And Pretzel Updates
   ; 

/*
DEBUGGING
   if !joy0fire then _Bit1_Joy0_Restrainer{1} = 0
   if _Bit1_Joy0_Restrainer{1} then goto __Skip_Pizza_Order
   if joy0fire then _Bit1_Joy0_Restrainer{1} = 1 :  _Pizza_Address = _Pizza_Address & $03 :  _Pizza_Address = _Pizza_Address + 1 : goto __Choose_Order_0 
__Skip_Pizza_Order
*/
   if _Bit0_Has_Pizza{0} && !_Order_0_Address then goto __Choose_Order_0

   _Order_Poll_Time = _Order_Poll_Time - 1
   if _Order_Poll_Time then goto __Skip_Poll_Updates

   _Order_Poll_Time = ORDER_POLL_DURATION

   _Order_0_Time = _Order_0_Time - 1
   if _Order_0_Time then goto __Skip_Order_0

   if _Pizza_Address then goto __Skip_Order_0

__Choose_Pizza_Start

   _Pizza_Address = _Pizza_Progress & $0f
   _Pizza_Address = _Pizza_Address + 1

   player3x = _Data_Pizza_X[_Pizza_Address]
   player3y = _Data_Pizza_Y[_Pizza_Address]

   goto __Skip_Order_0

__Choose_Order_0

   _Order_0_Address = _Pizza_Address
   _Order_0_Time = ORDER_WAIT_POLLS

   player4x = _Data_Obstacle_X[_Order_0_Address]
   player4y = _Data_Obstacle_Y[_Order_0_Address]
   temp1 = _Data_Obstacle_Shape[_Order_0_Address]
   if temp1 > 0 then goto __Skip_Obstacle_Tree
   
   COLUP4 = TREE_COLOR
   player4:
   ; tree
    %00100000
    %00100000
    %00100000
    %01110000
    %11111000
    %11011000
    %10111000
    %01110000
end
   goto __Skip_Order_0

__Skip_Obstacle_Tree

   if temp1 > 1 then goto __Skip_Obstacle_Cone
   COLUP4 = CONE_COLOR
   player4:
   ; cones
    %11111000
    %01110000
    %01010000
    %00100000
    %00101111
    %00001001
    %00000110
    %00000110
end
   goto __Skip_Order_0

__Skip_Obstacle_Cone

   COLUP4 = BARRICADE_COLOR
   player4:
  ; barricade
    %01000010
    %01000010
    %11111111
    %01000010
    %11101101
    %11011011
    %10110111
end

__Skip_Order_0

   if _Bit1_Invulnerable{1} then goto __Skip_Pretzel_Update

   _Pretzel_Time = _Pretzel_Time - 1
   if _Pretzel_Time then goto __Skip_Pretzel_Update

   _Pretzel_Time = PRETZEL_WAIT_POLLS

   if _Pretzel_Address then _Pretzel_Address = 0 : goto __Skip_Pretzel_Update

   _Pretzel_Address = _Pizza_Address | _Order_0_Address ; select based on objective

__Skip_Pretzel_Update

   if !_Bit1_Invulnerable{1} then goto __Skip_Player_Invulnerable_Update

   _Player_Invulnerable_Time = _Player_Invulnerable_Time - 1
   if _Player_Invulnerable_Time then goto __Skip_Player_Invulnerable_Update

   _Bit1_Invulnerable{1} = 0
   _MusicTrack_0 = 0
   _MusicTimer_0 = 0
   _MusicSequence_0 = 0
   AUDF0 = 0
   AUDV0 = 0
   AUDF1 = 0
   AUDV1 = 0

__Skip_Player_Invulnerable_Update

   temp4 = (rand & $07) + 4
   _Taxi_0_Ax = -temp4
   _Taxi_0_Ay = 0
   if temp4 >= 6 then _Taxi_0_Ay = (rand & $03) - 2

   ; if player1x > player0x && player0y >= STREET_ALLEY_2_Y_MAX && player0y < STREET_FRONT_1_Y_MAX then _Taxi_0_Ax = -16 

__Skip_Steer_Taxi_0

   temp4 = (rand & $07) + 4
   _Taxi_1_Ax = temp4
   _Taxi_1_Ay = 0
   if temp4 >= 6 then _Taxi_1_Ay = (rand & $03) - 2

   if player2x < player0x && player0y >= STREET_ALLEY_1_Y_MAX && player0y < STREET_FRONT_0_Y_MAX then _Taxi_1_Ax = 16
   
__Skip_Steer_Taxi_1

__Skip_Poll_Updates
   

   ;***************************************************************
   ;
   ;  Sets the size of all sprites.
   ;
   ;```````````````````````````````````````````````````````````````
   
   NUSIZ0 = %01110000 ;Boy
   _NUSIZ1 = %00000101 ;Taxi 1
   NUSIZ2 = %00000101 ;Taxi 2
   NUSIZ3 = %00000000 ;Pizza
   NUSIZ4 = %00000000 ;Tree
   NUSIZ5 = %00000000 ;Customer

   ;****************************************************************
   ;
   ;  Flips player0 sprite when necessary.
   ;
   if _Bit3_Flip_p0{3} then REFP0 = 8 
   if _Bit0_Has_Pizza{0} then NUSIZ3 = NUSIZ3 | (_Bit3_Flip_p0 & $04)

   goto __Drawscreen

__Drawscreen

   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen

   ;***************************************************************
   ;
   ;  Reset switch check and end of main loop.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Turns off reset restrainer bit and jumps to beginning of
   ;  main loop if the reset switch is not pressed.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop bank2

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of main loop if the reset switch hasn't
   ;  been released after being pressed.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop bank2

   ;```````````````````````````````````````````````````````````````
   ;  Restarts the program.
   ;
   goto __Start_Restart bank1


   /*    
      Object locations (16 combinations)
    */

   data _Data_Pretzel_X
    0, 123, 146, 26, 146, 44, 66, 26, 123, 146, 146, 84, 123, 26, 44, 84, 146
end
   data _Data_Pretzel_Y
    0, 19, 47, 47, 47, 19, 47, 47, 78, 47, 47, 19, 78, 47, 78, 78, 47
end
   data _Data_Emoticon_X
    0, 30, 95, 148, 110, 30, 70, 110, 148, 30, 70, 110, 30, 110, 30, 110, 134
end
   data _Data_Emoticon_Y
    0, 83, 56, 27, 83, 83, 83, 83, 27, 27, 83, 83, 27, 83, 83, 83, 56
end
   data _Data_Dropoff_X
    0, 22, 87, 142, 102, 22, 62, 102, 142, 22, 62, 102, 22, 102, 22, 102, 126
end
   data _Data_Dropoff_Y
    0, 78, 50, 22, 78, 78, 78, 78, 22, 22, 78, 78, 22, 78, 78, 78, 50
end
   data _Data_Obstacle_X
    0, 26, 66, 122, 66, 26, 106, 106, 66, 42, 66, 66, 26, 106, 82, 106, 26
end
   data _Data_Obstacle_Y
    0, 54, 54, 26, 54, 54, 54, 54, 54, 26, 54, 54, 54, 54, 26, 54, 54
end
   data _Data_Obstacle_Shape
    0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
end
   data _Data_Pizza_X
    0, 66, 84, 106, 44, 123, 123, 146, 44, 26, 84, 44, 66, 84, 66, 146, 44
end
   data _Data_Pizza_Y
    0, 50, 76, 50, 22, 22, 76, 50, 76, 50, 22, 76, 50, 22, 50, 50, 76
end

  /*
    Playfield movement boundary data
    Used to process building collisions
  */

   ;    28 36 - 68 76 - 108 116
   data _Data_Alley_3A_X
   28, 28, 28, 28, 28, 28, 28, 0, 0, 36, 36, 36, 36, 68, 68, 68, 68, 0, 0, 76, 76, 76, 76, 76, 108, 108, 108, 0, 0, 116, 116, 116, 116, 116, 116, 116, 116, 116
end
   ;    32 36 - 72 76 - 112 116
   data _Data_Alley_3B_X
   32, 32, 32, 32, 32, 32, 32, 32, 0, 36, 36, 36, 36, 72, 72, 72, 72, 72, 0, 76, 76, 76, 76, 76, 112, 112, 112, 112, 0, 116, 116, 116, 116, 116, 116, 116, 116, 116
end
   ;12 20 - 52 60 - 92 100 - 132 140
   data _Data_Alley_4A_X
   12, 12, 12, 0, 0, 20, 20, 20, 20, 52, 52, 52, 52, 0, 0, 60, 60, 60, 60, 60, 92, 92, 92, 0, 0, 100, 100, 100, 100, 132, 132, 132, 132, 0, 0, 140, 140, 140
end
   ;16 20 - 56 60 - 96 100 - 136 140
   data _Data_Alley_4B_X
   16, 16, 16, 16, 0, 20, 20, 20, 20, 56, 56, 56, 56, 56, 0, 60, 60, 60, 60, 60, 96, 96, 96, 96, 0, 100, 100, 100, 100, 136, 136, 136, 136, 136, 0, 140, 140, 140
end

   /*
     Music data
     sequences of AUDC/AUDF/AUDV/duration values 
     Seq Index 1 - Toccata and Fugue (short)   (13)
     Seq Index 14 - Toccata and Fugue (longer) (36)
     Seq Index 51 - Pickup (24)
     Seq Index 76 - Honk Honk (26)
     Seq Index 103 - Low Honk (26)
     Seq Index 130 - Charge
   */
   ; the following asm is needed to make sure this array lines up at a memory page boundary
   asm
   align 256
end
   data _Data_Music
   255,
   12, _A4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 4, 12, _A4, DEFAULT_VOLUME, 40, 255,
   12, _A4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 4, 12, _A4, DEFAULT_VOLUME, 40,
       12, _G4, DEFAULT_VOLUME, 4, 12, _F4, DEFAULT_VOLUME, 4, 12, _E4, DEFAULT_VOLUME, 4,
       12, _D4, DEFAULT_VOLUME, 4, 12, _CS4, DEFAULT_VOLUME, 16, 12, _D4, DEFAULT_VOLUME, 32, 255,
   12, 39, $09, 2, 12, 38, $0B, 2, 12, 37, $0E, 2,
       12, 36, $0F, 2, 12, 35, $0E, 2, 12, 34, $0D, 2, 255,
   12, 44, $09, 2, 12, 44, $0B, 2, 12, 44, $0E, 2, 0, 2,
        12, 44, $0E, 2, 12, 44, $0D, 2, 12, 44, $0C, 2, 255,
   12, 47, $09, 2, 12, 47, $0B, 2, 12, 47, $0E, 2, 0, 2,
        12, 47, $0E, 2, 12, 47, $0D, 2, 12, 47, $0C, 2, 255,
   12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1, 
      12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1,
      12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1,
      12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 
      12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1,
      12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1,
      12, _C4, DEFAULT_VOLUME, 11, 0, 1, 12, _C4, DEFAULT_VOLUME, 3, 0, 1,
      12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 12, _G4, DEFAULT_VOLUME, 12, 12, _E4, DEFAULT_VOLUME, 4, 
      12, _C4, DEFAULT_VOLUME, 40, 255
end

 bank 3

 asm
 include "pizza_title.asm"
end

 bank 4    

__Game_Overness

   if _P5DisplayTimer > 0 then _P5DisplayTimer = _P5DisplayTimer - 1 : _Bit1_Joy0_Restrainer{1} = 1

   if !joy0fire then _Bit1_Joy0_Restrainer{1} = 0
   if _Bit1_Joy0_Restrainer{1} then goto __Skip_Check_Reset
   if joy0fire then goto __Start_Restart bank1

__Skip_Check_Reset

   NUSIZ0 = %00000101 ;GA-OV
   NUSIZ3 = %00000101 ;ME-ER
   NUSIZ4 = %00000000 ;boy

   player1x = 0
   player1y = 0
   player2x = 0
   player2y = 0
   player5x = 0
   player5y = 0

   player0y = 54
   player0x = 63
   COLUP0 = BARRICADE_COLOR
   player0:
;  gaov_0:
    %01100010
    %10010101
    %10010101
    %10010101
    %01100101
    %00000000
    %11110101
    %10010101
    %10110111
    %10000101
    %11110111
end

   player3y = 52
   COLUP3 = BARRICADE_COLOR
   player3x = 89
   player3:
;  meer_0:
    %11101001
    %10001001
    %11101110
    %10001001
    %11101111
    %00000000
    %10101011
    %10101010
    %10101011
    %10101010
    %11011011
end

; spinning player

   COLUP4 = PLAYER_COLOR

   ; cycle animations
   if _Bicycle_Animation_Frame = 16 then _Bicycle_Animation_Frame = 1
   _Bicycle_Animation_Frame = _Bicycle_Animation_Frame - 1
   if _Bicycle_Animation_Frame > 128 && _Bicycle_Animation_Frame < 240 then _Bicycle_Animation_Frame = 255
 
   ; set player shape based on animation frame

 if _Bicycle_Animation_Frame >= 240 && _Bicycle_Animation_Frame < 244 then  player4:
    %00001110
    %00110110
    %00001100
    %00000110
    %11011110
    %01111100
    %01011010
    %10101101
    %10100101
    %01000010
end
 if _Bicycle_Animation_Frame >= 244 && _Bicycle_Animation_Frame < 248 then  player4:
    %00000000
    %01101000
    %10011000
    %01110010
    %00111010
    %01110101
    %01111111
    %10011011
    %01100000
    %00000000
end
 if _Bicycle_Animation_Frame >= 248 && _Bicycle_Animation_Frame < 252 then  player4:
    %01000010
    %10100101
    %10110101
    %01011010
    %00111110
    %01111011
    %01100000
    %00110000
    %01101100
    %01110000
end
 if _Bicycle_Animation_Frame >= 252 && _Bicycle_Animation_Frame <= 255 then  player4:
    %00000000
    %00000110
    %11011001
    %11111110
    %10101110
    %01011100
    %01001110
    %00011001
    %00010110
    %00000000
end

 if _Bicycle_Animation_Frame = 0  then  player4:
    %01000010
    %10100101
    %10101101
    %01011010
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end

 if _Bicycle_Animation_Frame > 1 && _Bicycle_Animation_Frame < 9 then player4:
    %01100011
    %10100101
    %10101101
    %11011110
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end  

 if _Bicycle_Animation_Frame >= 9 && _Bicycle_Animation_Frame < 16 then  player4:
    %11000110
    %10100101
    %10101101
    %01111011
    %01111100
    %11011110
    %00000110
    %00001100
    %00110110
    %00001110
end
 ; end player movement

 goto __Drawscreen bank2

    inline 6lives.asm