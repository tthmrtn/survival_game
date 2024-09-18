extends CharacterBody2D

enum SPEEDSTATE {
	WALKING = 40,
	RUNNING = 80,
	BACKWARDS = 20
}

const JUMP_VELOCITY = -200.0

var current_speed = SPEEDSTATE.WALKING

var facing_right : bool = true

var flying : bool = false;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("shift") and current_speed != SPEEDSTATE.BACKWARDS and velocity != Vector2.ZERO:
		current_speed = SPEEDSTATE.RUNNING
		%AnimationTree["parameters/Blend2/blend_amount"] = move_toward(%AnimationTree["parameters/Blend2/blend_amount"],1,0.1)
	if Input.is_action_just_released("shift"):
		if current_speed == SPEEDSTATE.BACKWARDS:
			%AnimationTree["parameters/TimeScale/scale"] = -1
		else:
			current_speed = SPEEDSTATE.WALKING
			%AnimationTree["parameters/TimeScale/scale"] = 2
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a", "d")
	if direction:
		velocity.x = direction * current_speed
		%AnimationTree["parameters/Movement/add_amount"] = 1
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		%AnimationTree["parameters/Movement/add_amount"] = move_toward(%AnimationTree["parameters/Movement/add_amount"], 0, .2)
		
	if facing_right and velocity.x < 0:
		%AnimationTree["parameters/Blend2/blend_amount"] = move_toward(%AnimationTree["parameters/Blend2/blend_amount"],0,0.1)
		current_speed = SPEEDSTATE.BACKWARDS
		%AnimationTree["parameters/TimeScale/scale"] = -1
	elif not facing_right and velocity.x > 0:
		current_speed = SPEEDSTATE.BACKWARDS
		%AnimationTree["parameters/Blend2/blend_amount"] = move_toward(%AnimationTree["parameters/Blend2/blend_amount"],0,0.1)
		%AnimationTree["parameters/TimeScale/scale"] = -1
	elif current_speed != SPEEDSTATE.RUNNING:
		%AnimationTree["parameters/Blend2/blend_amount"] = move_toward(%AnimationTree["parameters/Blend2/blend_amount"],0,0.1)
		current_speed = SPEEDSTATE.WALKING
		%AnimationTree["parameters/TimeScale/scale"] = 2
	%Eye.offset = (get_global_mouse_position() - (position - Vector2(2 * -%visuals.scale.x,14))).normalized() * 0.5 * %visuals.scale
	
	if velocity == Vector2.ZERO:
		%AnimationTree["parameters/Movement/add_amount"] = move_toward(%AnimationTree["parameters/Movement/add_amount"], 0, .2)
		%AnimationTree["parameters/Blend2/blend_amount"] = move_toward(%AnimationTree["parameters/Blend2/blend_amount"],0,0.1)
	
	move_and_slide()



func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			if position > get_global_mouse_position():
				facing_right = false
				%visuals.scale.x = -1
			else:
				facing_right = true
				%visuals.scale.x = 1
	
