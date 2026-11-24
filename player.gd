extends CharacterBody2D

class_name Player


const MAX_SPEED = 100000
const ACC = 1000
const JUMP_SPEED = 400
const GRAVITY = 1000
const KNOCKBACK_SPEED = 700


enum{IDLE, WALK, AIR, SLIDE, DEAD}

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer


var state=IDLE
var friction = 1000
var can_jump: bool = true
var want_to_jump: bool = false
var is_dead: bool = false
var sliding: bool = false
var SLIDE_SPEED = 2000
var speed = 1


###############GAME LOOP####################
func _physics_process(delta: float) -> void:
	print(velocity)
	match state: # kollar vad man gör och sänder vilka regler ska reagera
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		AIR:
			_air_state(delta)
		SLIDE:
			_slide_state(delta)
		DEAD:
			_dead_state(delta)

########### help function #################
func _update_direction(input_x: float) -> void:
	if input_x < 0:
		sprite.flip_h = true
	elif input_x > 0:
		sprite.flip_h = false

func _movement(input_x: float, delta: float) -> void:
	if input_x != 0 and velocity.x<700 and velocity.x>-700:
		#Rörelse åt höger eller vänster
		velocity.x = move_toward(velocity.x, input_x * MAX_SPEED, ACC*delta)
	else:
		#ingen input -> stanna
		velocity.x = move_toward(velocity.x, 0, ACC*delta)
	velocity.y += GRAVITY*delta #Lägger till gravitation i y-led
	move_and_slide() #utför rörelse enligt velocity-vektor


############STATE funktioner###############
func _idle_state(delta:float)->void:
	#1 check inputs
	if Input.is_action_just_pressed("Jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if not is_on_floor():
		_enter_air_state(false)
	elif velocity.length() != 0:
		_enter_walk_state()

func _walk_state(delta:float)->void:
	#1 check inputs
	if Input.is_action_just_pressed("Jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("Move left", "Move right")
	
	if Input.is_action_just_pressed("Slide"):
		_enter_slide_state()
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if not is_on_floor():
		_enter_air_state(false)
	elif velocity.length() == 0:
		_enter_idle_state()
	


func _air_state(delta:float)->void:
	#1 get inputs
	if Input.is_action_just_pressed("Jump") and can_jump:
		can_jump = false
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_pressed("Jump") and not can_jump:
		want_to_jump = true
		jump_buffer.start()
	var input_x = Input.get_axis("Move left", "Move right")
	
	#2. Utföra rörelse
	_update_direction(input_x)
	_movement(input_x, delta)
	#3. kontroll om rörelse lett till state-förädring
	if is_on_floor() and want_to_jump:
		_enter_air_state(true)
	elif is_on_floor() and velocity.length() > 0:
		_enter_walk_state()
	elif is_on_floor():
		_enter_idle_state()
	
func _slide_state(delta: float) -> void:
	var angle = get_floor_angle()
	var normal= get_floor_normal()
	var dir = 1
	if angle==0:
		sliding=false
		_enter_walk_state()
	if normal.x!=0:#player explodeor somthing om den är på 0
		dir=normal.x/abs(normal.x)#direction of slope 1 =höger -1 =vänster
	if sliding:
		var slide_direction = Vector2(cos(angle),sin(angle))
		speed=SLIDE_SPEED*sin(angle+0.5)
		velocity.x=slide_direction.x*speed*dir
		velocity.y=slide_direction.y*speed
		print("Angle: ", rad_to_deg(angle))
		move_and_slide()
	if Input.is_action_just_released("Slide"):
			sliding=false
			_enter_walk_state()




func _dead_state(delta:float)->void:
	pass
####### enter STATE funktions #############
func _enter_idle_state() -> void:
	state = IDLE

func _enter_walk_state() -> void:
	state = WALK

func _enter_air_state(jumping:bool)->void:
	state = AIR
	want_to_jump = false
	if jumping:
		velocity.y = -JUMP_SPEED
		can_jump = false
	else:
		can_jump = true
		coyote_timer.start()

func _enter_slide_state()->void:
	state = SLIDE
	sliding=true

func _enter_dead_state(dir:Vector2)->void:
	pass
###############signals################


func _on_coyote_timer_timeout() -> void:
	can_jump=false


func _on_jump_buffer_timeout() -> void:
	want_to_jump=false
