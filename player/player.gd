extends CharacterBody2D

# ------ Import Nodes ------ #
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer

# ------ Player Values ------ #
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var ACCELERATION = 400.0
@export var AIR_ACCELERATION = 1000.0
@export var FRICTION = 400.0

# ------ Vars Used in Code ------ #
var doubleJump = false
var wasOnFloor = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ------ Physics Function, Updates Every Frame ------ #
func _physics_process(delta):
	# ------ Get Direction of Movement ------ #
	var inputDirection = Input.get_axis("ui_left", "ui_right")
	
	# ------ Movement ------ #
	handleMovement(inputDirection, delta)
	
	# ------ Before Movement Values ------ #
	wasOnFloor = is_on_floor()
	
	# ------ Apply All Physics ------ #
	move_and_slide()
	
	# ------ Coyote Timer ------ #
	if wasOnFloor and not is_on_floor() and velocity.y >= 0:
		coyote_jump_timer.start()
	
	# ------ Update Animations ------ #
	updateAnimations(inputDirection)
	
# ------ Handle Movement & Inputs ------ #
func handleMovement(inputDirection, delta):
	# ------ Check Values ------ #
	var on_floor = is_on_floor()
	var jump_pressed = Input.is_action_pressed("ui_accept")
	var jump_released = Input.is_action_just_released("ui_accept")
	var jump_just_pressed = Input.is_action_just_pressed("ui_accept")

	# ------ Handle Jumping ------ #
	if on_floor: 
		doubleJump = true

	if on_floor or coyote_jump_timer.time_left > 0.0:
		if jump_pressed:
			velocity.y = JUMP_VELOCITY
			coyote_jump_timer.stop()
	elif not on_floor:
		if jump_released and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
		if jump_just_pressed and doubleJump:
			velocity.y = JUMP_VELOCITY * 0.8
			doubleJump = false

	# ------ Handle Gravity ------ #
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# ------ Left/Right Movement ------ #
	if inputDirection != 0 and on_floor:
		velocity.x = move_toward(velocity.x, SPEED * inputDirection, ACCELERATION * delta)
	elif inputDirection == 0 and on_floor:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	elif inputDirection != 0 and !on_floor:
		velocity.x = move_toward(velocity.x, SPEED * inputDirection, AIR_ACCELERATION * delta)

# ------ Updates Animations ------ #
func updateAnimations(inputDirection):
	# ------ Running / Idle Animations ------ #
	if inputDirection != 0:
		animated_sprite_2d.flip_h = (inputDirection < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("default")
	
	# ------ Jumping Animation ------ #
#	if !is_on_floor():
#		animated_sprite_2d.play("jump")
