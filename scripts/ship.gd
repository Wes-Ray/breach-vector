extends CharacterBody3D
class_name Ship

@export var camera_rig : CameraRig

@export var top_speed := 20.0

@export_category("rotation speed")
@export var pitch_speed := 5.0
@export var yaw_speed := 1.0
@export var roll_speed := 20.0

func _ready() -> void:
	assert(camera_rig, "camera rig must be added before adding to scene")

func _process(delta: float) -> void:
	Logger.log("delta", delta)
	var forward := basis.z
	var roll_ratio :float= abs(sin(rotation.z))
	Logger.log("roll_ratio", roll_ratio)

	var scaled_pitch := (pitch_speed * (1 - roll_ratio)) + (yaw_speed * (roll_ratio))
	var scaled_yaw := (pitch_speed * (roll_ratio)) + (yaw_speed * (1 - roll_ratio))
	
	rotation.x = lerp_angle(rotation.x, camera_rig.rotation.x, delta * scaled_pitch)
	rotation.y = lerp_angle(rotation.y, camera_rig.rotation.y, delta * scaled_yaw)
	rotation.z = lerp_angle(rotation.z, camera_rig.rotation.z, delta * roll_speed)
	
	var speed := 0.0
	if Input.is_action_pressed("throttle_up"):
		speed = top_speed
	velocity = forward * speed
	move_and_slide()

	