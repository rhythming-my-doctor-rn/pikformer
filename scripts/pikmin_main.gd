extends CharacterBody2D

@export var speed=GlobalVariables.player_speed
@export var gravity=GlobalVariables.player_gravity
@export var jumpForce=GlobalVariables.player_jump_force
@onready var jump=$jump
@onready var movement=$movement
@onready var pos=GlobalVariables.player_pos
var total=0
var lastTotal=0

func falling():
	GlobalVariables.playerhit()
	velocity.y+=gravity
	move_and_slide()
	if velocity.y > 1000:
		velocity.y = 1000
		move_and_slide()

func _physics_process(delta):
	pos=GlobalVariables.player_pos
	#returns -1 for left and 1 for right
	var hDirection=Input.get_axis("move_left", "move_right")
	#defines forward and backward movement
	velocity.x=speed*hDirection
	
	if(GlobalVariables.player_yvelocityfling!=0):
		velocity.y=GlobalVariables.player_yvelocityfling
		move_and_slide()
		
	if(GlobalVariables.player_xvelocityfling!=0):
		velocity.x=GlobalVariables.player_xvelocityfling
		move_and_slide()
		
	falling()
		
	if is_on_floor():
		GlobalVariables.player_xvelocityfling=0
		
	#Left
	if is_on_floor()&&velocity.y==0 && velocity.x<0:
		get_node("jump").hide()
		get_node("idleRight").hide()
		get_node("idleLeft").hide()
		movement.play("Left")
		get_node("movement").show()
		move_and_slide()
	#Right
	if is_on_floor()&&velocity.y==0 && velocity.x>0:
		get_node("jump").hide()
		get_node("idleRight").hide()
		get_node("idleLeft").hide()
		movement.play("Right")
		get_node("movement").show()
		move_and_slide()
	#Jump
	if is_on_floor()&&velocity.x==0&&!Input.is_action_pressed("jump")&&!Input.is_action_pressed("move_left")&&!Input.is_action_pressed("move_right"):
		get_node("jump").hide()
		get_node("movement").hide()
		if (Input.is_action_just_released("move_left")):
			get_node("idleLeft").show()
		if (Input.is_action_just_released("move_right")):
			get_node("idleRight").show()
	
	if Input.is_action_just_released("jump")&&Input.is_action_pressed("move_right")&&lastTotal>=1:
		get_node("idleRight").hide()
		get_node("idleLeft").hide()
		get_node("movement").hide()
		jump.play("jumpRight")
		get_node("jump").show()
		move_and_slide()
		
	if Input.is_action_just_released("jump")&&Input.is_action_pressed("move_left")&&lastTotal>=1:
		get_node("idleRight").hide()
		get_node("idleLeft").hide()
		get_node("movement").hide()
		jump.play("jumpLeft")
		get_node("jump").show()
		move_and_slide()
	

	
	
	
	
	if Input.is_action_pressed("jump")&&is_on_floor():
		#speed=0
		total += delta
		lastTotal=total

		get_tree().root.get_camera_2d().zoom_out()
		
	if(Input.is_action_just_released("jump")):
		speed=GlobalVariables.player_speed
		$totalTimer.start()
	
	if lastTotal>=1&&lastTotal<2:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=2*speed*hDirection
			move_and_slide()
			get_tree().root.get_camera_2d().zoom_in1()
	if lastTotal>=2&&lastTotal<3:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=3*speed*hDirection
			move_and_slide()
			get_tree().root.get_camera_2d().zoom_in2()
	if lastTotal>=3:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=4*speed*hDirection
			move_and_slide()
			get_tree().root.get_camera_2d().zoom_in3()
		
	if Input.is_action_just_released("jump")&&is_on_floor():#&&(Input.is_action_pressed("move_left")||Input.is_action_pressed("move_right")):
		if lastTotal>=1&&lastTotal<2:
			velocity.y=-jumpForce
			move_and_slide()
			
		if lastTotal>=2&&lastTotal<3:
			velocity.y=-1.50*jumpForce
			move_and_slide()
			
		if lastTotal>=3:
			velocity.y=-1.75*jumpForce
			move_and_slide()
			
		
	if !Input.is_action_pressed("jump")&&is_on_floor():
		get_tree().root.get_camera_2d().zoom_in1()
	
	if GlobalVariables.pikkey_caught==true:
		get_node("jump").hide()
		get_node("movement").hide()
		get_node("idleRight").show()
		
	if GlobalVariables.pikkey_caught==false:
		set_collision_layer_value(3, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(4, true)
		
	if GlobalVariables.pikkey_caught==false&&speed==GlobalVariables.ss_speed/2.0:
		velocity.x=GlobalVariables.player_speed
		move_and_slide()
		
	if GlobalVariables.pikkey_caught==true:
		set_collision_layer_value(3,false)
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, false)
		global_position=Vector2(GlobalVariables.ss_xpos,GlobalVariables.ss_ypos+175)
		velocity.x=GlobalVariables.ss_speed/2.0
		move_and_slide()

func _on_total_timer_timeout():
	total=0
