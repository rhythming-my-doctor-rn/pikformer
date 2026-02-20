extends Area2D

func _on_body_entered(body):
	if body==$"swoopingSnitchbug":
		get_node("swoopingSnitchbug").outOfHome=false

func _on_body_exited(body):
	if body==$"swoopingSnitchbug":
		get_node("swoopingSnitchbug").outOfHome=true
