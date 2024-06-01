;; Bear (0)
GFX_Bear
	.byte 18	; height
	.byte 1		; # of frames
	.byte %00000111 ; |     XXX|
	.byte %00000111 ; |     XXX|
	.byte %11100110 ; |XXX  XX |
	.byte %11100110 ; |XXX  XX |
	.byte %01111110 ; | XXXXXX |
	.byte %01111110 ; | XXXXXX |
	.byte %01111100 ; | XXXXX  |
	.byte %01111010 ; | XXXX X |
	.byte %00111011 ; |  XXX XX|
	.byte %00111101 ; |  XXXX X|
	.byte %01111111 ; | XXXXXXX|
	.byte %11111111 ; |XXXXXXXX|
	.byte %11111110 ; |XXXXXXX |
	.byte %10011100 ; |X  XXX  |
	.byte %10100010 ; |X X   X |
	.byte %10110110 ; |X XX XX |
	.byte %10101010 ; |X X X X |
	.byte %00011100 ; |   XXX  |
	.byte %00010100 ; |   X X  |

;; Snake (1)
GFX_Snake
	.byte 5		; height
	.byte 1		; # of frames
	.byte %00001000 ; |    X   |
	.byte %11011101 ; |XX XXX X|
	.byte %01110110 ; | XXX XX |
	.byte %00100011 ; |  X   XX|
	.byte %00000010 ; |      X |

;; Lynx (2)
GFX_Lynx
	.byte 11	; height
	.byte 1		; # of frames
	.byte %10010101 ; |X  X X X|
	.byte %10010101 ; |X  X X X|
	.byte %11010010 ; |XX X  X |
	.byte %11100110 ; |XXX  XX |
	.byte %01111100 ; | XXXXX  |
	.byte %01111010 ; | XXXX X |
	.byte %01111111 ; | XXXXXXX|
	.byte %00111010 ; |  XXX X |
	.byte %01000101 ; | X   X X|
	.byte %10000111 ; |X    XXX|
	.byte %00000101 ; |     X X|

;; Deer_frame_01 (3)
GFX_Deer01
	.byte 8
	.byte 2		; # of frames
	.byte %01000101 ; | X   X X|
	.byte %10101010 ; |X X X X |
	.byte %01011100 ; | X XXX  |
	.byte %00111110 ; |  XXXXX |
	.byte %00101101 ; |  X XX X|
	.byte %11100000 ; |XXX     |
	.byte %01100000 ; | XX     |
	.byte %01010000 ; | X X    |
;; Deer_frame_02
GFX_Deer02
	.byte 8
	.byte %00010100 ; |   X X  |
	.byte %00101010 ; |  X X X |
	.byte %01011101 ; | X XXX X|
	.byte %00111110 ; |  XXXXX |
	.byte %00111100 ; |  XXXX  |
	.byte %11100000 ; |XXX     |
	.byte %01100000 ; | XX     |
	.byte %01010000 ; | X X    |

;; Bird_frame_01 (4)
GFX_Bird
	.byte 7
	.byte 2		; # of frames
	.byte %11000000 ; |XX      |
	.byte %01100000 ; | XX     |
	.byte %00110000 ; |  XX    |
	.byte %01111000 ; | XXXX   |
	.byte %11111100 ; |XXXXXX  |
	.byte %00000111 ; |     XXX|
	.byte %00000010 ; |      X |
;; Bird_frame_02
	.byte 7
	.byte %01000000 ; | X      |
	.byte %00110000 ; |  XX    |
	.byte %01111000 ; | XXXX   |
	.byte %11111100 ; |XXXXXX  |
	.byte %00110110 ; |  XX XX |
	.byte %11100100 ; |XXX  X  |
	.byte %00000000 ; |        |

;; Fish_frame_01 (5)
GFX_Fish01
	.byte 10
	.byte 2		; # of frames
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %11001100 ; |XX  XX  |
	.byte %11011110 ; |XX XXXX |
	.byte %00111111 ; |  XXXXXX|
	.byte %00111101 ; |  XXXX X|
	.byte %11011110 ; |XX XXXX |
	.byte %11001100 ; |XX  XX  |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
;; Fish_frame_02
GFX_Fish02
	.byte 10
	.byte %10000000 ; |X       |
	.byte %11000000 ; |XX      |
	.byte %01001100 ; | X  XX  |
	.byte %01011110 ; | X XXXX |
	.byte %00111111 ; |  XXXXXX|
	.byte %00111101 ; |  XXXX X|
	.byte %01011110 ; | X XXXX |
	.byte %01001100 ; | X  XX  |
	.byte %11000000 ; |XX      |
	.byte %10000000 ; |X       |

;; Tree_01 (6)
GFX_Tree1
	.byte 13
	.byte 1		; # of frames
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %11111110 ; |XXXXXXX |
	.byte %01111100 ; | XXXXX  |
	.byte %00111000 ; |  XXX   |
	.byte %11111110 ; |XXXXXXX |
	.byte %01111100 ; | XXXXX  |
	.byte %00111000 ; |  XXX   |
	.byte %01111100 ; | XXXXX  |
	.byte %00111000 ; |  XXX   |
	.byte %00111000 ; |  XXX   |
	.byte %00010000 ; |   X    |

;; Tree_02A (7)
GFX_Tree2
	.byte 17
	.byte 1		; # of frames
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %00111000 ; |  XXX   |
	.byte %01011100 ; | X XXX  |
	.byte %01111100 ; | XXXXX  |
	.byte %01110100 ; | XXX X  |
	.byte %11111110 ; |XXXXXXX |
	.byte %11111100 ; |XXXXXX  |
	.byte %10111010 ; |X XXX X |
	.byte %11101110 ; |XXX XXX |
	.byte %11111110 ; |XXXXXXX |
	.byte %01110100 ; | XXX X  |
	.byte %01011100 ; | X XXX  |
	.byte %00111100 ; |  XXXX  |
	.byte %00010000 ; |   X    |

;; Tree_03 (8)
GFX_Tree3
	.byte 19
	.byte 1		; # of frames
	.byte %00001000 ; |    X   |
	.byte %00001000 ; |    X   |
	.byte %00001000 ; |    X   |
	.byte %00011100 ; |   XXX  |
	.byte %01111110 ; | XXXXXX |
	.byte %01111110 ; | XXXXXX |
	.byte %10001001 ; |X   X  X|
	.byte %00001000 ; |    X   |
	.byte %00111110 ; |  XXXXX |
	.byte %01111110 ; | XXXXXX |
	.byte %01001001 ; | X  X  X|
	.byte %00001100 ; |    XX  |
	.byte %00011100 ; |   XXX  |
	.byte %00011110 ; |   XXXX |
	.byte %00101010 ; |  X X X |
	.byte %00001001 ; |    X  X|
	.byte %00011100 ; |   XXX  |
	.byte %00101010 ; |  X X X |
	.byte %00001000 ; |    X   |
	.byte %00001000 ; |    X   |

;; House_01 (9)
GFX_House
	.byte 8
	.byte 1		; # of frames
	.byte %01011100 ; | X XXX  |
	.byte %01011100 ; | X XXX  |
	.byte %01010100 ; | X X X  |
	.byte %01111100 ; | XXXXX  |
	.byte %11111110 ; |XXXXXXX |
	.byte %01111100 ; | XXXXX  |
	.byte %00111000 ; |  XXX   |
	.byte %00010000 ; |   X    |

;; Building_01 (10)
GFX_Building1
	.byte 9
	.byte 1		; # of frames
	.byte %01001100 ; | X  XX  |
	.byte %01001100 ; | X  XX  |
	.byte %01111100 ; | XXXXX  |
	.byte %01110100 ; | XXX X  |
	.byte %01011100 ; | X XXX  |
	.byte %01111100 ; | XXXXX  |
	.byte %11110110 ; |XXXX XX |
	.byte %11111110 ; |XXXXXXX |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |

;; Building_02 (11)
GFX_Building2
	.byte 13
	.byte 1		; # of frames
	.byte %11111110 ; |XXXXXXX |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %10101010 ; |X X X X |
	.byte %11111110 ; |XXXXXXX |
	.byte %10111010 ; |X XXX X |
	.byte %11010110 ; |XX X XX |
	.byte %01101100 ; | XX XX  |
	.byte %00111000 ; |  XXX   |
	.byte %00010000 ; |   X    |

;; Apple (12)
GFX_Apple
	.byte 7
	.byte 1		; # of frames
	.byte %00111000 ; |  XXX   |
	.byte %01111100 ; | XXXXX  |
	.byte %11111110 ; |XXXXXXX |
	.byte %11111110 ; |XXXXXXX |
	.byte %01111100 ; | XXXXX  |
	.byte %00010000 ; |   X    |
	.byte %00001000 ; |    X   |
