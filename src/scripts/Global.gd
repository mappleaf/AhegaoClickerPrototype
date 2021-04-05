extends Node


#var unit_types = {
#	TEST = "res://src/scenes/units/TestUnit.tscn",
#	TEST2 = "res://src/scenes/units/TestUnit2.tscn"
#}
var unit_types = {}


var current_scene

var units_in_room = {}
var owned_units = {}
var money = 0

var enemies = {}
var enemy = {}
var is_enemy_new = false

var gacha_starting
var gacha_regular
var gacha_special
var stardust

#!!!TESTING!!!
var damage = 10


func _ready() -> void:
	randomize()
	
	# TESTING!!
#	for unit in unit_types.keys():
#		owned_units[unit] = unit_types[unit]
	
	append_units()
	#units_in_room[test_unit] = test_unit.unit_data

func _physics_process(_delta):
	print(owned_units)


func get_owned_units() -> void:
	Server.request_owned_units()

func get_units_in_room() -> void:
	Server.get_units_in_room()

func get_money() -> void:
	Server.get_money()

func get_enemies() -> void:
	Server.get_enemies()

func get_enemy() -> void:
	Server.get_enemy()

func killed_enemy() -> void:
	Server.killed_enemy()

func get_gacha() -> void:
	Server.get_gacha()

func open_gacha(gacha_type) -> void:
	Server.open_gacha(gacha_type)

func get_stardust() -> void:
	Server.get_stardust()



func append_units() -> void:
	var i = 0
	for unit in owned_units:
		if i > 7:
			break
		units_in_room[unit] = owned_units[unit]
		i += 1


func _append_unit(path: String) -> void:
	units_in_room[path] = owned_units[path]
