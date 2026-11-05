extends CharacterBody2D

class_name Player


const MAX_SPEED = 350
const ACC = 3000
const JUMP_SPEED = 700
const GRAVITY = 1500
const KNOCKBACK_SPEED = 700

enum{IDLE, WALK, AIR, SLIDE, DEAD}


var state=IDLE
var can_jump: bool = true
var want_to_jump: bool = false
var is_dead: bool = false

###############GAME LOOP####################
func _physics_process(delta: float) -> void:
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
	

func _slide_state(delta:float)-void:
	pass

func _dead_state(delta:float)->void:
	pass
####### enter STATE funktions #############
func _enter_idle_state() -> void:
	state = IDLE

func _enter_walk_state() -> void:
	state = WALK

func _enter_air_state()->void:
	state = AIR
	want_to_jump = false
	if jumping:
		velocity.y = -JUMP_SPEED
		can_jump = false
	else:
		can_jump = true
		coyote_timer.start()
func _enter_slide_state()->void
	state = DEAD
###############signals################


func _on_coyote_timer_timeout() -> void:
	can_jump=false




func _on_jump_buffer_timeout() -> void:
	want_to_jump=false
