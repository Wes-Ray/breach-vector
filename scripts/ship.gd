extends CharacterBody3D
class_name Ship

@export var camera_rig : CameraRig

@export var top_speed := 10.0

@export_category("rotation speed")
@export var pitch_speed := 20.0
@export var yaw_speed := 0.5
@export var roll_speed := 20.0

func _ready() -> void:
	assert(camera_rig, "camera rig must be added before adding to scene")

func _process(delta: float) -> void:
	Logger.log("delta", delta)
	
	rotation.x = lerp_angle(rotation.x, camera_rig.rotation.x, delta * pitch_speed)
	rotation.y = lerp_angle(rotation.y, camera_rig.rotation.y, delta * yaw_speed)
	rotation.z = lerp_angle(rotation.z, camera_rig.rotation.z, delta * roll_speed)

	var forward := basis.z
	var speed := 0.0
	if Input.is_action_pressed("throttle_up"):
		speed = top_speed
	velocity = forward * speed
	move_and_slide()
