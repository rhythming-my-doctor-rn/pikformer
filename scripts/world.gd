extends Node2D

@export var dwarfBulborb: PackedScene
@export var swoopingSnitchbug: PackedScene
@export var Player: PackedScene
@export var cc:PackedScene

func _ready():
	var new_Player=Player.instantiate()
	new_Player.position.x=2560
	new_Player.position.y=5050
	add_child(new_Player)

func _input(event):
	if event.is_action_pressed("click"):
		var new_cc = dwarfBulborb.instantiate()
		new_cc.position = get_global_mouse_position()
		add_child(new_cc)
		
