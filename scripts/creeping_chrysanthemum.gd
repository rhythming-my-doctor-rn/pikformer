extends CharacterBody2D

var speed=150
var direction=0
var defaultScale=1
var burrowed=true
var outOfHome=false
var ignorePik=false
@onready var pik=get_parent().get_parent().get_node("pikmin")

func _physics_process(_delta):
	if global_position.distance_to(pik.position)<800:
		burrowed=false
	else:
		burrowed=true
		if velocity.x<0&&!scale.y<0:
			scale*=Vector2(-1,1)
		if velocity.x>0&&scale.y<0:
			scale*=Vector2(-1,1)
	
	if !outOfHome&&pik.position.x<self.global_position.x:
		direction=-1
	elif !outOfHome&&pik.position.x>self.global_position.x:
		direction=1
	
	if (outOfHome)||(!outOfHome&&ignorePik):
		if get_parent().position.x<self.global_position.x:
			direction=-1
			velocity.x=speed*direction
			if velocity.x<0&&!scale.y<0:
				scale*=Vector2(-1,1)
			move_and_slide()
		elif get_parent().position.x>self.global_position.x:
			direction=1
			velocity.x=speed*direction
			if velocity.x>0&&scale.y<0:
				scale*=Vector2(-1,1)
			move_and_slide()
		move_and_slide()
		if burrowed&&self.global_position.distance_to(get_parent().position)<5:
			velocity.x=0
			$hidden.show()
			$onthemove.hide()
	
	if !outOfHome&&!ignorePik:
		if burrowed&&self.global_position.distance_to(get_parent().position)<5:
			velocity.x=0
			$hidden.show()
			$onthemove.hide()
		elif !burrowed:
			velocity.x=speed*direction
			if velocity.x<0&&!scale.y<0:
				scale*=Vector2(-1,1)
			if velocity.x>0&&scale.y<0:
				scale*=Vector2(-1,1)
			move_and_slide()
			$hidden.hide()
			$onthemove.show()
		elif burrowed&&self.global_position.x!=get_parent().position.x:
			if get_parent().position.x<self.global_position.x:
				direction=-1
				velocity.x=speed*direction
				move_and_slide()
			elif get_parent().position.x>self.global_position.x:
				direction=1
				velocity.x=speed*direction
				move_and_slide()

func _on_cc_defeat_area_body_entered(_body):
	self.queue_free()
	get_parent().queue_free()
