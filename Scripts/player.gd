extends CharacterBody3D

@onready var tank_bottom = $visuals/tank_bottom
@onready var cube_003 = $visuals/tank_top/Cube_003
@onready var camera_mount = $camera_mount

const current_speed = 5.0
const jump_velocity = 4.5

const mouse_sens = 0.01
const rotate_tank = 0.01
var mouse_visible = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	# If mouse visible make it invis. again
	if event is InputEventMouseButton and mouse_visible:
		mouse_visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (event is InputEventMouseMotion) and not mouse_visible:
		# Convert to redian to minimize rotation value
		#rotate_y(deg_to_rad(-1 * event.relative.x * mouse_sens))
		camera_mount.rotate_y(deg_to_rad(-1 * event.relative.x * mouse_sens))
		cube_003.rotate_y(deg_to_rad(-1 * event.relative.x * mouse_sens))

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		mouse_visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("ui_left"):
		var current_position = tank_bottom.get_rotation_degrees()
		#print(current_position[0])
		#tank_bottom.rotation_degrees = current_position * Vector3(1, rotate_tank, 1)

	

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = jump_velocity


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
