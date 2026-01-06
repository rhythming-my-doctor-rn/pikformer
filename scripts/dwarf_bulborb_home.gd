extends Area2D

func _on_body_entered(body):
	if body==get_parent().get_node("pikmin"):
		get_node("dwarfBulborb").aggro=true
		get_node("dwarfBulborb").prowling=false

func _on_body_exited(body):
	if body==get_parent().get_node("pikmin"):
		get_node("dwarfBulborb").aggro=false
		get_node("dwarfBulborb").prowling=true
