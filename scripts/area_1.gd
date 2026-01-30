extends Node2D

@export var dwarfBulborb: PackedScene
@export var swoopingSnitchbug: PackedScene
@export var redPikmin: PackedScene
@export var creepingChrysanthemum:PackedScene

func _ready():
	var pikmin=redPikmin.instantiate()
	pikmin.position=Vector2(0,0)
	add_child(pikmin)
