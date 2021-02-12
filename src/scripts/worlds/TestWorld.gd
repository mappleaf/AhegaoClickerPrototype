extends Node2D


export(float, 1, 1000) var perspective_factor = 1.5


var units = {}
var units_assign = {}


onready var unitsHolder = $UnitsHolder

# Corners
onready var botleft = $botleft
onready var topright = $topright
onready var bot = Vector2(topright.position.x / 2, botleft.position.y)
onready var top = Vector2(topright.position.x / 2, topright.position.y)


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/TestWorld.tscn"
	
	# JUST FOR TESTING!!!
	#for i in unitsHolder.get_child_count():
		
		#unitsHolder.get_children()[i].unit_data.pos = unitsHolder.get_children()[i].position
		#append_units(unitsHolder.get_children()[i])
	var test_unit_instance = Global.testUnit.instance()
	unitsHolder.add_child(test_unit_instance)
	test_unit_instance.unit_data.position = Vector2(clamp(rand_range(botleft.position.x, topright.position.x), test_unit_instance.get_absolute_size().x / 2, topright.position.x - test_unit_instance.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y))
	append_units(test_unit_instance)
	
	if Global.units:
		for unit in Global.units.keys():
			append_units(unit)

func _physics_process(_delta) -> void:
	if units:
		for unit in units:
			var ratio = (unit.position.y - botleft.position.y) / (topright.position.y - botleft.position.y)
			var new_scale = interpolate(perspective_factor, 1.0, ratio)
			unit.sync_scale(Vector2(new_scale, new_scale))
			#unit.sync_scale(unit.position.distance_to((Vector2(unit.position.x, bot.y)) / perspective_factor) + 1)
			#print(unit.position.distance_to((Vector2(unit.position.x, bot.y)) / perspective_factor) + 1)


func interpolate(a, b, t):
	return a + (b - a) * t

func append_units(unit) -> void:
	Global.units[unit] = unit.unit_data
	units[unit] = unit.unit_data
	unit.position = unit.unit_data.pos
	var target_pos
	unit._update_target_position(Vector2(clamp(rand_range(botleft.position.x, topright.position.x), unit.get_absolute_size().x / 2, topright.position.x - unit.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y)))

func _send_new_target_position(unit) -> void:
	unit._update_target_position(Vector2(clamp(rand_range(botleft.position.x, topright.position.x), unit.get_absolute_size().x / 2, topright.position.x - unit.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y)))
	Global._update_unit(unit)
