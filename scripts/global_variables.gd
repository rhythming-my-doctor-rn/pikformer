extends Node
var player_speed=150
var player_gravity=30
var player_jump_force=500
var player_yvelocityfling=0
var player_xvelocityfling=0
var player_pos
var db_speed=200
var ss_speed=200
var pikkey_caught=false
var ss_xpos
var ss_ypos

func playerhit():
		
	if player_yvelocityfling>0:
		player_yvelocityfling-=10
		
	if player_yvelocityfling<0:
		player_yvelocityfling+=10
