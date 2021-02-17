extends Node2D


export(float, 1, 1000) var perspective_factor = 1.25


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
	#var test_unit_instance = Global.testUnit.instance()
	#unitsHolder.add_child(test_unit_instance)
	#test_unit_instance.unit_data.position = Vector2(clamp(rand_range(botleft.position.x, topright.position.x), test_unit_instance.get_absolute_size().x / 2, topright.position.x - test_unit_instance.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y))
	#append_units(test_unit_instance)
	
	if Global.units_in_room:
		for unit in Global.units_in_room:
			unitsHolder.add_child(Global.units_in_room[unit])
			spawn_unit(Global.units_in_room[unit])

func _physics_process(_delta) -> void:
	if Global.units_in_room:
		for unit in Global.units_in_room:
			var ratio = (Global.units_in_room[unit].position.y - botleft.position.y) / (topright.position.y - botleft.position.y)
			var new_scale = interpolate(perspective_factor, 1.0, ratio)
			Global.units_in_room[unit].sync_scale(Vector2(new_scale, new_scale))
			#unit.sync_scale(unit.position.distance_to((Vector2(unit.position.x, bot.y)) / perspective_factor) + 1)
			#print(unit.position.distance_to((Vector2(unit.position.x, bot.y)) / perspective_factor) + 1)


func interpolate(a, b, t):
	return a + (b - a) * t

func spawn_unit(unit) -> void:
	if unit.unit_data.pos == Vector2.ZERO:
		unit._update_current_position(generate_point(unit.get_absolute_size()))
	else:
		unit._update_current_position(unit.unit_data.pos)
	if unit.unit_data.target_position == Vector2.ZERO:
		unit._update_target_position(generate_point(unit.get_absolute_size()))
	else:
		unit._update_target_position(unit.unit_data.target_position)
# warning-ignore:return_value_discarded
	unit.connect("request_new_position", self, "_send_new_target_position", [unit])

func generate_point(unit_size) -> Vector2:
	return Vector2(clamp(rand_range(botleft.position.x, topright.position.x), unit_size.x / 2, topright.position.x - unit_size.x / 2), rand_range(botleft.position.y, topright.position.y))

#func append_units(unit) -> void:
#	Global.units_in_room[unit] = unit.unit_data
#	unit.position = unit.unit_data.pos
#	unit._update_target_position(generate_point(unit.get_absolute_size()))

func _send_new_target_position(unit) -> void:
	unit._update_target_position(generate_point(unit.get_absolute_size()))
