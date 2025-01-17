extends Node3D

@export var spawn_point: Node3D
@export var ship_scene: PackedScene
@export var camera_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(spawn_point, "spawn point must be assigned to main script")
	spawn_player()

func spawn_player() -> void:
	var ship_instance: Ship = ship_scene.instantiate()
	var camera_instance: CameraRig = camera_scene.instantiate()
	
	ship_instance.camera_rig = camera_instance
	camera_instance.track_target = ship_instance

	ship_instance.position = spawn_point.position
	camera_instance.position = spawn_point.position

	add_child(ship_instance)
	add_child(camera_instance)
