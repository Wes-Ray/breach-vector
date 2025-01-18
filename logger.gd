extends Node

var debug_dict := {}

func log(debug_name: String, value: Variant = "") -> void:
	debug_dict[debug_name] = value
