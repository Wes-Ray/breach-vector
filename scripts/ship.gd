extends CharacterBody3D

@onready var body: Node3D = %Body
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

	# relative basis for camera and ship
	var ship_basis := body.global_basis
	var camera_basis := camera_rig.global_basis
	var relative_basis := ship_basis.inverse() * camera_basis

	# roll based on a and d 
	# TODO: set up so ship rolls, then camera aligns (or vice versa, perhaps)
	camera_rig.rotate(camera_rig.basis.z.normalized(), roll_input * roll_speed * delta)
	body.rotate(body.basis.z.normalized(), roll_input * roll_speed * delta)


	# yaw towards camera angle (I don't want to scale based on the angle so that the player isn't 
	# incentivized to move their camera a longgg distance just to turn faster)
	# get angle between camera in ship space (not world space)
	var yaw_angle := relative_basis.get_euler().y
	debug.log("yaw", yaw_angle)

	var yaw_threshold := 0.01
	var within_yaw_threshold := yaw_angle > -yaw_threshold and yaw_angle < yaw_threshold
	if within_yaw_threshold:
		debug.log("TEST", "zero")
		pass
	elif yaw_angle > 0:
		debug.log("TEST", "POSITIVE")
		body.rotate(ship_basis.y.normalized(), 0.01)
	else:
		debug.log("TEST", "NEGATIVE")
		body.rotate(ship_basis.y.normalized(), -0.01)
	
	# pitch towards camera angle
	var pitch_angle := relative_basis.get_euler().x
	debug.log("pitch", pitch_angle)

	var pitch_threshold := 0.01
	var within_pitch_threshold := pitch_angle > -pitch_threshold and pitch_angle < pitch_threshold
	if within_pitch_threshold:
		pass
	elif pitch_angle > 0:
		body.rotate(ship_basis.x.normalized(), 0.01)
	else:
		body.rotate(ship_basis.x.normalized(), -0.01)


	# update movement based on body direction (NOT self of the whole ship)
	if throttle_input > 0.01:
		current_air_speed = base_air_boost_speed
	else:
		current_air_speed = base_air_speed

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
