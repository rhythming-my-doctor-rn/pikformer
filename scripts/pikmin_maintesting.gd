extends CharacterBody2D

@export var gravity=30
@export var jumpForce=500
@onready var jump=$jump
@onready var movement=$movement
@onready var idleLeft=$idleLeft
@onready var idleRight=$idleRight

var speed=300
var total=0
var lastTotal=0
var lastVelocityx=0
var isJumping=false
var lastXVelo=0
var lastDirection=0
var player_yvelocityfling=0
var player_xvelocityfling=0
var beingFlung=false
var hitDirection=0

func _physics_process(delta):
	#Horizontal Movement
	var hDirection=Input.get_axis("move_left", "move_right")
	
	if hDirection!=0:
		lastDirection=hDirection
	
	velocity.x=speed*hDirection
	if (velocity.x!=0):
		lastXVelo=velocity.x
	
	#Gravity
	if !is_on_floor():
		lastVelocityx=velocity.x
		velocity.y+=gravity
		move_and_slide()
		if velocity.y > 1000:
			velocity.y = 1000
			move_and_slide()
	
	#Jump
	if is_on_floor():
		isJumping=false

	if Input.is_action_pressed("jump")&&is_on_floor():
		speed=0
		total+=delta
		lastTotal=total
		get_tree().root.get_camera_2d().zoom_out()
		
	if(Input.is_action_just_released("jump"))&&is_on_floor():
		speed=300
		isJumping=true
		$totalTimer.start()
	
	if lastTotal>=1&&lastTotal<2&&isJumping:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=2*150*hDirection
			get_tree().root.get_camera_2d().zoom_in1()
			
	if lastTotal>=2&&lastTotal<3&&isJumping:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=3*150*hDirection
			get_tree().root.get_camera_2d().zoom_in2()
			
	if lastTotal>=3&&isJumping:
		if !is_on_floor()&&(velocity.x<0||velocity.x>0):
			velocity.x+=4*150*hDirection
			get_tree().root.get_camera_2d().zoom_in3()
		
	if Input.is_action_just_released("jump")&&is_on_floor()&&(Input.is_action_pressed("move_left")||Input.is_action_pressed("move_right")):
		if lastTotal>=1&&lastTotal<2:
			velocity.y=-jumpForce
		if lastTotal>=2&&lastTotal<3:
			velocity.y=-1.50*jumpForce
		if lastTotal>=3:
			velocity.y=-1.75*jumpForce
			
	if !Input.is_action_pressed("jump")&&is_on_floor():
		get_tree().root.get_camera_2d().zoom_in1()
	
	#Hit Detection
	if beingFlung:
		if player_yvelocityfling!=0:
			velocity.y=player_yvelocityfling
			player_yvelocityfling+=20
		if player_xvelocityfling!=0:
			velocity.x=player_xvelocityfling
		if player_yvelocityfling==0&&is_on_floor():
			beingFlung=false
		
	
	#Swooping Snitchbug
	if GlobalVariables.pikkey_caught==true:
		jump.hide()
		movement.hide()
		idleRight.show()
		
	if GlobalVariables.pikkey_caught==false:
		set_collision_layer_value(3, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(4, true)
		
	if GlobalVariables.pikkey_caught==false&&velocity.x==GlobalVariables.ss_speed/2.0:
		velocity.x=150
		
		
	if GlobalVariables.pikkey_caught==true:
		set_collision_layer_value(3,false)
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, false)
		global_position=Vector2(GlobalVariables.ss_xpos,GlobalVariables.ss_ypos+175)
		velocity.x=GlobalVariables.ss_speed/2.0



	print("y velocity: ",velocity.y)
	print("x velocity: ",velocity.x)
	move_and_slide()

func _on_total_timer_timeout():
	total=0

func _process(_delta):
	
	#Left
	if is_on_floor()&&velocity.y==0 && velocity.x<0:
		jump.hide()
		idleRight.hide()
		idleLeft.hide()
		movement.play("Left")
		movement.show()
		
	#Right
	if is_on_floor()&&velocity.y==0 && velocity.x>0:
		jump.hide()
		idleRight.hide()
		idleLeft.hide()
		movement.play("Right")
		movement.show()
		
	#Idle
	if is_on_floor()&&velocity.x==0&&!Input.is_action_pressed("jump")&&((!Input.is_action_pressed("move_left")&&!Input.is_action_pressed("move_right"))||(Input.is_action_pressed("move_right")&&Input.is_action_pressed("move_left"))):
		jump.hide()
		movement.hide()
		if lastDirection<0:
			idleLeft.show()
		if lastDirection>0:
			idleRight.show()
	
	#Jump
	if Input.is_action_pressed("jump")&&is_on_floor():
		jump.hide()
		movement.hide()
		if lastDirection<0:
			idleLeft.show()
			idleRight.hide()
		if lastDirection>0:
			idleRight.show()
			idleLeft.hide()
			
	if (Input.is_action_just_released("jump")&&lastTotal>=1)||velocity.y!=0:
		idleRight.hide()
		idleLeft.hide()
		movement.hide()
		if lastDirection>0:
			jump.play("jumpRight")
			jump.show()
		if lastDirection<0:
			jump.play("jumpLeft")
			jump.show()

func fling():
	beingFlung=true
	if hitDirection<0:
		player_yvelocityfling=-400
		player_xvelocityfling=400
	if hitDirection>0:
		player_yvelocityfling=-400
		player_xvelocityfling=-400
	
func _on_pikmin_detect_box_entered(area):
	if area.global_position>self.global_position:
		hitDirection=1
	if area.global_position<self.global_position:
		hitDirection=-1
	fling()
