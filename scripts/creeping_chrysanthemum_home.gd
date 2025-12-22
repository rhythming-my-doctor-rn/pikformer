extends Area2D

func _on_body_entered(body):
	if body==$"creepingChrysanthemum":
		get_node("creepingChrysanthemum").outOfHome=false
	if body==get_parent().get_node("pikmin"):
		get_node("creepingChrysanthemum").ignorePik=false

func _on_body_exited(body):
	if body==$"creepingChrysanthemum":
		get_node("creepingChrysanthemum").outOfHome=true
		get_node("creepingChrysanthemum").ignorePik=true
