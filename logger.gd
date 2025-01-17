extends Node

var debug_dict := {}

func log(debug_name: String, value: Variant = "") -> void:
	if not OS.is_debug_build():
		return

	debug_dict[debug_name] = value
