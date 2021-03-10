extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/List.tscn"


func _on_TextureButton_pressed():
	Global.get_owned_units()
	# TESTING!!!
	var unit_type = Global.owned_units.keys()[randi() % Global.owned_units.size()]
	
	if Global.owned_units.keys().has(unit_type):
		if !Global.units_in_room.keys().has(unit_type):
			Global._append_unit(unit_type)
			Server.send_units_in_room()
		else:
			pass
