extends CharacterBody3D

@export var move_speed: float = 5.0
@export var look_sensitivity: float = 0.005
@export var gravity: float = -9.8
@export var jump_strength: float = 0.0

var camera: Camera3D
var y_rotation: float = 0.0

func _ready():
	camera = $Camera3D
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Handle camera rotation
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_movement = Input.get_last_mouse_velocity()
		y_rotation -= mouse_movement.x * look_sensitivity
		var x_rotation = mouse_movement.y * look_sensitivity

		# Rotate the player around the Y axis
		rotation_degrees.y = y_rotation

		# Rotate the camera around the X axis, clamped between -90 and 90 degrees
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - x_rotation, -90, 90)

	# Handle player movement
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	# Normalize direction vector to ensure consistent speed in all directions
	direction = direction.normalized() * move_speed

	# Apply gravity
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_strength
	else:
		velocity.y += gravity * delta

	# Apply movement
	velocity.x = direction.x
	velocity.z = direction.z
	move_and_slide()

# Toggle mouse mode with a button press (e.g., 'ui_accept' is typically Enter/Return or Space)
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
