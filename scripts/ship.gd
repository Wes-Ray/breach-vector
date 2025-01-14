extends CharacterBody3D

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

var rotation_speed = 0.005

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_LEFT:
		spring_arm_3d.rotate_y(-event.relative.x * rotation_speed)
		spring_arm_3d.rotate_x(-event.relative.y * rotation_speed)
		# rotation.x = clamp(rotation.x, -TAU/4, TAU/4)
