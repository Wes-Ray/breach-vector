extends Node3D
class_name CameraRig

@export var track_target : Ship
@export var mouse_sensitivity := 0.1
@export var track_target_speed := 10.0
@export var roll_speed := 5.0

func _ready() -> void:
    assert(track_target, "there must be a track target assigned before entering scene")

func _process(delta: float) -> void:
    position = position.lerp(track_target.position, delta * track_target_speed)

    # roll camera
    var roll_input := Input.get_axis("roll_left", "roll_right")
    rotate(basis.z.normalized(), roll_input * delta * roll_speed)  # roll


func _input(event: InputEvent) -> void:

    #
    # TODO: temp, move this to the menu later
    #
    # https://docs.godotengine.org/en/stable/tutorials/platform/web/customizing_html5_shell.html#doc-customizing-html5-shell
    if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
        return

    if not event is InputEventMouseMotion:
        return
    
    var mouse_movement:Vector2 = (event.relative / 300 * PI) * mouse_sensitivity
    
    rotate(basis.y.normalized(), -mouse_movement.x)  # yaw
    rotate(basis.x.normalized(), mouse_movement.y)  # pitch

