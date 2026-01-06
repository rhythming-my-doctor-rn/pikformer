extends CharacterBody2D

@export var speed=200
@onready var moveysprite=$Alive
@onready var pik=get_parent().get_parent().get_node("pikmin")
var aggro=false
var prowling=true
var aggro_timer_ended=false
var detect_timer_started=false
var direction=1



func _physics_process(_delta):
	if prowling:
		eating()
	if aggro:
		aggroed()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			if collision.get_collider().name=="pikmin":
				if direction>0:
					GlobalVariables.player_yvelocityfling=-250
					GlobalVariables.player_xvelocityfling=250
				if direction<0:
					GlobalVariables.player_yvelocityfling=-250
					GlobalVariables.player_xvelocityfling=-250


func _on_dwarf_bulborb_defeat_box_body_entered(_body):
	self.queue_free()
	get_parent().queue_free()

func eating():
	aggro_timer_ended=false
	if self.global_position.distance_to(get_parent().position)<=5:
		velocity.x=0
		move_and_slide()
	else:
		if get_parent().position.x<self.global_position.x:
			direction=-1
		
		elif get_parent().position.x>self.global_position.x:
			direction=1
		velocity.x=speed*direction
		move_and_slide()
		if velocity.x<0&&scale.y>0:
			scale*=Vector2(-1,1)
		elif velocity.x>0&&scale.y<0:
			scale*=Vector2(-1,1)

func aggroed():
	if !detect_timer_started:
		$movementTimer.start()
		detect_timer_started=true
	if aggro_timer_ended:
		if pik.position.x<self.global_position.x:
			direction=-1
		
		elif pik.position.x>self.global_position.x:
			direction=1
		
		velocity.x=speed*direction
		move_and_slide()
		if velocity.x<0&&scale.y>0:
			scale*=Vector2(-1,1)
		elif velocity.x>0&&scale.y<0:
			scale*=Vector2(-1,1)

func _on_movement_timer_timeout():
	aggro_timer_ended=true
	detect_timer_started=false
