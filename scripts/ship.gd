extends CharacterBody3D
class_name Ship

@export var camera_rig : CameraRig

@export var top_speed := 20.0

@export_category("rotation speed")
@export var pitch_speed := 3.5
@export var yaw_speed := 1.0
@export var roll_speed := 20.0

func _ready() -> void:
	assert(camera_rig, "camera rig must be added before adding to scene")

func _process(delta: float) -> void:
	var forward := basis.z

	var cam_tf := camera_rig.global_transform
	var desired_forward := cam_tf.basis.z
	var desired_up := cam_tf.basis.y

	var target_basis := Basis()
	target_basis.z = desired_forward.normalized()
	target_basis.y = desired_up.normalized()
	target_basis.x = target_basis.y.cross(target_basis.z).normalized()
	target_basis = target_basis.orthonormalized()

	var current_to_target := basis.inverse() * target_basis
	var rotation_diff := current_to_target.get_euler()

	var angular_velocity = Vector3(
		rotation_diff.x * pitch_speed,
		rotation_diff.y * yaw_speed,
		rotation_diff.z * roll_speed
	)

	basis = basis.rotated(basis.x, angular_velocity.x * delta)
	basis = basis.rotated(basis.y, angular_velocity.y * delta)
	basis = basis.rotated(basis.z, angular_velocity.z * delta)

	basis = basis.orthonormalized()

	var speed := 0.0
	if Input.is_action_pressed("throttle_up"):
		speed = top_speed
	velocity = forward * speed
	move_and_slide()