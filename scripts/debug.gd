extends Control
class_name Debug

var debug_dict:= {}

@onready var debug_label := %debug_label

func log(debug_name: String, value: Variant = "") -> void:
	if not OS.is_debug_build():
		return

	debug_dict[debug_name] = value
	
	var result_str:= ""
	for key: String in debug_dict.keys():
		result_str += key + " (" + type_string(typeof(debug_dict[key])) + "): " + str(debug_dict[key]) + "\n"
	
	debug_label.text = result_str

func _on_button_button_up() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
