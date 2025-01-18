extends CharacterBody3D
class_name Ship

signal player_crashed

@export var camera_rig : CameraRig

@export var top_speed := 20.

@export_category("rotation speed")
@export var pitch_speed := 3.5
@export var yaw_speed := 1.
@export var roll_speed := 20.

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

	# scaling so large camera rotation difference don't speed up rotations
	var angular_velocity = Vector3(
		sign(rotation_diff.x) * min(abs(rotation_diff.x), 1.0) * pitch_speed,
		sign(rotation_diff.y) * min(abs(rotation_diff.y), 1.0) * yaw_speed,
		sign(rotation_diff.z) * min(abs(rotation_diff.z), 1.0) * roll_speed
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

func _on_collision_area_body_entered(_body: Node3D) -> void:
	# TODO: add explodies
	player_crashed.emit()
	queue_free()