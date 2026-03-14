extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


#enum moveState {IDLE, RUN, JUMP, DASH}

#var state:moveState = moveState.IDLE: set = set_state

#func set_state(new_state: int) -> void:
#	pass

@export var enemy: Node3D
var target: bool = true

var is_dashing: bool=false
var can_dash: bool=true


## not currently based around the dude correctly :/
@export var dash_dist:float = 50
func dash(relation :Vector3):
	is_dashing=true
	can_dash=false
	var dash_dir=(transform.basis * relation)
	velocity.x = (dash_dir.x) * dash_dist
	velocity.z = (dash_dir.z) * dash_dist
	move_and_slide()
	await get_tree().create_timer(0.2).timeout
	is_dashing=false
	can_dash=true
	
	# Circle
	# offset = origin - origin
	# radius?
	# tangent
	# velocity = tangent * speed * direction
	
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY







	if Input.is_action_pressed("dash_left") and can_dash:
		dash(Vector3(-1, 0, 0))
	if Input.is_action_pressed("dash_right") and can_dash:
		dash(Vector3(1, 0, 0))		

	##BOILER PLATE
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("udi_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not is_dashing:
		velocity.x = direction.x * (SPEED)
		velocity.z = direction.z * (SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	
	
	if Input.is_action_just_pressed("tab_target"):
		if target:
			target=false
		else:
			target=true


	if target:
		look_at(enemy.position)
	# Alt camera control if we want this to even be a feature

	move_and_slide()
