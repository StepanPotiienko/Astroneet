extends CharacterBody3D

@onready var head = $Head


# Movement settings
@export var current_speed: float = 5.0
const walking_speed: float = 5.0
const sprinting_speed: float = 8.0

@export var jump_velocity: float = 4.5

@export var lerp_speed: float = 10.0

var direction: Vector3 = Vector3.ZERO


# Camera settings
@export var mouse_sensitivity: float = 0.1;


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Executes on the start of the game (like Start() method in Unity)
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Handles the input (well no duh).
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


# Like FixedUpdate() in Unity.
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity


	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	
	
	if direction:
		if Input.is_action_pressed("shfit"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
		
		velocity.x = direction.x * current_speed 
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
