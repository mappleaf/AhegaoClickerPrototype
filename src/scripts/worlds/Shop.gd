extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Shop.tscn"


func _on_TextureButton_pressed():
	var unit_type_index = randi() % Global.unit_types.keys().size()
	var unit_type = Global.unit_types.keys()[unit_type_index]
	
	if !Global.owned_units.keys().has(unit_type):
		Global.owned_units[unit_type] = Global.unit_types[unit_type]
	else:
		pass
