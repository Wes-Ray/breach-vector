extends Control
class_name HUD

@onready var debug_label := %DebugLabel
@onready var status_label := %StatusLabel
@onready var menu := %Menu
@onready var crosshair := %Crosshair
@onready var launch_button := %LaunchButton
@onready var debug_node := $Debug

func _ready() -> void:
	# keeps this script functioning when paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu.hide()

	if not OS.is_debug_build():
		debug_node.hide()

func _process(_delta: float) -> void:
	update_debug_label()

	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

	# for browser, pause automatically if mouse capture is lost (if user presses escape the browser forces it)
	# TODO: set up full screen toggle as well
	# TODO: figure out some sort of countdown timer for when rapidly pressing the launch button
	# 	    right now, if the launch button is pressed soon after pressing esc, the browser won't let go
	#       of the mouse input. There may be another workaround to avoid this restriction.
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Logger.log("mouse captured", false)
		if not get_tree().paused:
			pause()
	else:
		Logger.log("mouse captured", true)

func update_debug_label() -> void:
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

func _on_launch_button_button_up() -> void:
	unpause()

func _on_restart_button_button_up() -> void:
	get_tree().reload_current_scene()

func on_player_crashed() -> void:
	Logger.log("player crashed", true)
	status_label.text = "[color=red]CRASHED[/color]"
	launch_button.hide()	
	pause()
