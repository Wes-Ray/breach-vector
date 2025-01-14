extends CharacterBody3D

@onready var yaw: Node3D = %Yaw
@onready var pitch: Node3D = %Pitch

var rotation_speed = 0.005

func _input(event:InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
		
	var mouse_movement:Vector2 = event.relative / 300 * PI
	yaw.rotate_y(-mouse_movement.x )
	pitch.rotate_x(mouse_movement.y)

	pitch.rotation.x = clamp(pitch.rotation.x, -TAU/4, TAU/4)
