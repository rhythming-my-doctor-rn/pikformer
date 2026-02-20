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
var yPlayerVelocityFling=0
var xPlayerVelocityFling=0
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
		if yPlayerVelocityFling!=0:
			velocity.y=yPlayerVelocityFling
			yPlayerVelocityFling+=20
		if xPlayerVelocityFling!=0:
			velocity.x=xPlayerVelocityFling
		if yPlayerVelocityFling==0&&is_on_floor():
			beingFlung=false

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
		yPlayerVelocityFling=-400
		xPlayerVelocityFling=400
	if hitDirection>0:
		yPlayerVelocityFling=-400
		xPlayerVelocityFling=-400
	
func _on_pikmin_detect_box_entered(area):
	if area.global_position>self.global_position:
		hitDirection=1
	if area.global_position<self.global_position:
		hitDirection=-1
	fling()
