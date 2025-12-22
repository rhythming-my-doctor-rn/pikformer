#NEVER HAVE MORE THAN ONE AT ONCE

extends CharacterBody2D

@export var speed=GlobalVariables.ss_speed
@onready var moveysprite=$Alive
var canGrabPikmin=true

func _physics_process(_delta):
	GlobalVariables.ss_xpos=global_position.x
	GlobalVariables.ss_ypos=global_position.y
	velocity.x=speed
	move_and_slide()
	if canGrabPikmin==true:
		$swoopingSnitchbugArms.set_collision_mask_value(3,true)
	if canGrabPikmin==false:
		$swoopingSnitchbugArms.set_collision_mask_value(3,false)

func _on_swooping_snitchbug_grab_box_body_entered(_body):
	if GlobalVariables.pikkey_caught==false:
		self.queue_free()
		get_parent().queue_free()

func _on_throw_timer_timeout():
	GlobalVariables.pikkey_caught=false
	$grabCooldownTimer.start()

func _on_swooping_snitchbug_arms_entered(_body):
	if GlobalVariables.pikkey_caught==false:
		GlobalVariables.pikkey_caught=true
		canGrabPikmin=false
		$throwTimer.start()
		

func _on_ss_home_body_exited(_body):
	speed*=-1
	scale*=Vector2(-1,1)

func _on_grab_cooldown_timer_timeout():
	canGrabPikmin=true
