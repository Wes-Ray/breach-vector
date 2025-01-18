extends Control

@onready var debug_label := %DebugLabel
@onready var menu := %Menu
@onready var crosshair := %Crosshair

func _ready() -> void:
	# keeps this script functioning when paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu.hide()
	pause()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	# 	if Input.is_action_just_pressed("ui_cancel"):
# 		toggle_pause()

# 	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
# 		Logger.log("mouse captured", true)
# 	else:
# 		Logger.log("mouse captured", false)

	print_debug()

func print_debug() -> void:
	var result_str:= ""
	for key: String in Logger.debug_dict.keys():
		result_str += key + " (" + type_string(typeof(Logger.debug_dict[key])) + "): " + str(Logger.debug_dict[key]) + "\n"
	
	debug_label.text = result_str

func toggle_pause() -> void:
	if get_tree().paused:
		unpause()
	else:
		pause()

func pause() -> void:
	menu.show()
	crosshair.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func unpause() -> void:
	menu.hide()
	crosshair.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _on_resume_button_button_up() -> void:
	unpause()

# func _input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
# 		# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# 		unpause()
# 		return

func _on_launch_button_button_up() -> void:
	unpause()
