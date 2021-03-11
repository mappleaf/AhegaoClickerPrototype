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
	
	# TESTING!!
#	for unit in unit_types.keys():
#		owned_units[unit] = unit_types[unit]
	
	append_units()
	#units_in_room[test_unit] = test_unit.unit_data


func get_owned_units() -> void:
	Server.request_owned_units()

func get_units_in_room() -> void:
	Server.get_units_in_room()



func append_units() -> void:
	var i = 0
	for unit in owned_units:
		if i > 7:
			break
		units_in_room[unit] = owned_units[unit]
		i += 1


func _append_unit(path: String) -> void:
	units_in_room[path] = owned_units[path]
