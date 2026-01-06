extends Node2D

@export var dwarfBulborb: PackedScene
@export var swoopingSnitchbug: PackedScene
@export var redPikmin: PackedScene
@export var creepingChrysanthemum:PackedScene

func _ready():
	var pikmin=redPikmin.instantiate()
	var db=dwarfBulborb.instantiate()
	var ss=swoopingSnitchbug.instantiate()
	var cc=creepingChrysanthemum.instantiate()
	pikmin.position=Vector2(0,0)
	db.position=Vector2(-500,0)
	ss.position=Vector2(-700, -600)
	add_child(pikmin)
	add_child(db)
	add_child(ss)
