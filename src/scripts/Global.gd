extends Node


var current_scene
var units = {}


# TESTING!!!
var testUnit = load("res://src/scenes/units/TestUnit.tscn")


func _ready() -> void:
	randomize()


func _update_unit(unit) -> void:
	units[unit] = unit.unit_data
