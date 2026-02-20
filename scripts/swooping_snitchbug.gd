#NEVER HAVE MORE THAN ONE AT ONCE

extends CharacterBody2D

@export var speed=200
@onready var pik=null
var canGrabPikmin=true
var pikminCaught=false
var outOfHome=false
var throw=false
var direction=1

func _physics_process(_delta):
	if get_parent().get_parent().get_node("pikmin"):
		pik=get_parent().get_parent().get_node("pikmin")
		
	if pik!=null:
		velocity.x=speed*direction
		
		if outOfHome:
			if get_parent().position.x<self.global_position.x:
				direction=-1
				if velocity.x<0&&!scale.y<0:
					scale*=Vector2(-1,1)
			elif get_parent().position.x>self.global_position.x:
				direction=1
				if velocity.x>0&&scale.y<0:
					scale*=Vector2(-1,1)
		
		print("position: ",position)
		print("gloposit: ",global_position)
		move_and_slide()

func _on_throw_timer_timeout():
	throw=true

func _on_swooping_snitchbug_arms_entered(_body):
	if get_parent().get_parent().get_node("pikmin"):
		pik=get_parent().get_parent().get_node("pikmin")
		
	if pik!=null:
		pikminCaught=true
		$throwTimer.start()
		
		if pikminCaught:
			pik.global_position.x=self.global_position.x
			pik.global_position.y=self.global_position.y+220
			if throw:
				pikminCaught=false
				throw=false
