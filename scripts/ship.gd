extends CharacterBody3D

@onready var body: CharacterBody3D = %Body
@onready var body_model: Node3D = %BodyModel

@onready var camera_rig: Node3D = %CameraRig

@onready var debug: Debug = $Debug

@export var base_air_speed: float = 5.0
@export var base_air_boost_speed: float = 25.0
var current_air_speed: float = base_air_speed
# @export var air_speed: float = 0.0
@export var rotation_speed: float = 2.0
@export var roll_speed: float = 3.0
@export var mouse_sensitivity: float = 0.1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func move_ship(delta) -> void:
	debug.log("camera_rig tf", camera_rig.transform)
	debug.log("self tf", transform)  # shouldn't be used, just use body transform to find forward
	debug.log("body tf", body.transform)

	# get input
	var roll_input := Input.get_axis("roll_right", "roll_left")
	debug.log("roll", roll_input)
	var throttle_input := Input.get_axis("throttle_down", "throttle_up")
	debug.log("throttle", throttle_input)

	if throttle_input > 0.01:
		current_air_speed = base_air_boost_speed
	else:
		current_air_speed = base_air_speed

	# roll
	# camera_rig.rotate(body_model.basis.z.normalized(), roll_input * delta)
	camera_rig.rotate(camera_rig.basis.z.normalized(), roll_input * roll_speed * delta)

	# Get Euler angles
	# var camera_euler := camera_rig.global_transform.basis.get_euler()
	# var current_euler := body.global_transform.basis.get_euler()

	# Create new quaternions with roll (z) set to 0
	# var camera_no_roll := Quaternion.from_euler(Vector3(camera_euler.x, camera_euler.y, 0))
	# var current_no_roll := Quaternion.from_euler(Vector3(current_euler.x, current_euler.y, 0))

	# Lerp between the roll-free rotations
	# var lerp_quat = current_no_roll.slerp(camera_no_roll, delta * rotation_speed)
	body.global_transform.basis = Basis(camera_rig.basis)


	# update movement based on body direction (NOT self of the whole ship)
	var forward := -body.basis.z
	velocity = forward * current_air_speed

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	move_ship(delta)

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_movement:Vector2 = (event.relative / 300 * PI) * mouse_sensitivity
		debug.log("mousex", event.relative.x)
		debug.log("mousey", event.relative.y)

		camera_rig.rotate(camera_rig.basis.y.normalized(), -mouse_movement.x)  # camera_rig
		camera_rig.rotate(camera_rig.basis.x.normalized(), -mouse_movement.y)  # pitch

		# pitch.rotation.x = clamp(pitch.rotation.x, -TAU/4, TAU/4)
		return

	# TODO: refactor? seems hacky
	# https://docs.godotengine.org/en/stable/tutorials/platform/web/customizing_html5_shell.html#doc-customizing-html5-shell
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
