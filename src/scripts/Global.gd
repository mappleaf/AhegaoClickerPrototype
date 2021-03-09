extends Node


#var unit_types = {
#	TEST = "res://src/scenes/units/TestUnit.tscn",
#	TEST2 = "res://src/scenes/units/TestUnit2.tscn"
#}
var unit_types = {}


var current_scene
var units_in_room = {}
var owned_units = {}


func _ready() -> void:
	randomize()
	
	Server.get_unit_types()
	# TESTING!!
#	for unit in unit_types.keys():
#		owned_units[unit] = unit_types[unit]
	
	var i = 0
	for unit in owned_units:
		if i > 7:
			break
		units_in_room[unit] = load(owned_units[unit]).instance()
		i += 1
	#units_in_room[test_unit] = test_unit.unit_data


func _append_unit(path: String) -> void:
	units_in_room[path] = load(owned_units[path]).instance()

remote func _return_units_list(list) -> void:
	unit_types = list
