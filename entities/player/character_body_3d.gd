class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


#enum moveState {IDLE, RUN, JUMP, DASH}

#var state:moveState = moveState.IDLE: set = set_state

#func set_state(new_state: int) -> void:
#pass

@export var hp_max:int = 5
var hp:int = 5: set = set_health
signal health_changed(old_value, new_value)

func set_health(amount: int) -> void:
	#print(amount)
	var old=hp
	if amount>0:
		if amount<=hp_max:
			hp=amount
		else:
			hp=hp_max
	else:
		hp=amount
		if hp<=0:
			hp=0
			#LOSING STATE HERE
	
	emit_signal("health_changed", old, hp)
	



@export var enemy: Node3D
var target: bool = true

var is_dashing: bool=false
var can_dash: bool=true



@export var dash_speed: float = 30.0
@export var dash_duration: float = 0.2

var dash_direction_multiplier: float = 0.0 # 1.0 for right, -1.0 for left

func dash(side: float):
	is_dashing = true
	can_dash = false
	dash_direction_multiplier = side

# After the duration, stop dashing
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false


	await get_tree().create_timer(0.1).timeout 
	can_dash = true




func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY 

# Handle Dash Movement
	if is_dashing and enemy:
		# 1. Get the vector from enemy to player
		var offset = global_position - enemy.global_position

		# 2. Calculate the Tangent (Perpendicular) vector
		var tangent = offset.cross(Vector3.UP).normalized()
		print(global_position.distance_to(enemy.global_position))
		# 3. Apply velocity along that tangent
		velocity = tangent * dash_speed * dash_direction_multiplier

	elif not is_dashing:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	# Handle Input
	if Input.is_action_pressed("dash_left") and can_dash:
		dash(1.0) # Clockwise
	if Input.is_action_pressed("dash_right") and can_dash:
		dash(-1.0) # Counter-Clockwise

# Rotation/Looking
	if target and enemy:
		look_at(enemy.global_position)

	move_and_slide()
