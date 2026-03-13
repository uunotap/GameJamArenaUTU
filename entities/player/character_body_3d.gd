extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var enemy: Node3D
@export var target: Node3D


func dash(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	
	if Input.is_action_just_pressed("tab_target"):
		if target != null:
			target=enemy
		else:
			target=null

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:

		velocity.x = direction.x * (SPEED)
		velocity.z = direction.z * (SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var dash_dir:Vector3
	if Input.is_action_pressed("dash_left"):
		print("dash left")
		dash_dir=(transform.basis * Vector3(-1, 0, -1)).normalized()
		velocity.x = (dash_dir.x) * 50
		velocity.z = (dash_dir.y) * 50
		
		
	if Input.is_action_pressed("dash_right"):
		print("dash right")
		dash_dir=(transform.basis * Vector3(1, 0, -1)).normalized()
		velocity.x = (dash_dir.x) * 50
		velocity.z = (dash_dir.y) * 50
		
		
	if target != null:
		look_at(target.position)

		
	move_and_slide()
