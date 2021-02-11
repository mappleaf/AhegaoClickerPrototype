extends Node2D


export(float, 1, 1000) var perspective_factor = 1.5


var units = []


onready var unitsHolder = $UnitsHolder

# Corners
onready var botleft = $botleft
onready var topright = $topright
onready var bot = Vector2(topright.position.x / 2, botleft.position.y)
onready var top = Vector2(topright.position.x / 2, topright.position.y)


func _ready() -> void:
	for i in unitsHolder.get_child_count():
		append_units(unitsHolder.get_children()[i])

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
	units.append(unit)
	var target_pos
	unit._update_target_position(Vector2(clamp(rand_range(botleft.position.x, topright.position.x), unit.get_absolute_size().x / 2, topright.position.x - unit.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y)))

func _send_new_position(unit) -> void:
	unit._update_target_position(Vector2(clamp(rand_range(botleft.position.x, topright.position.x), unit.get_absolute_size().x / 2, topright.position.x - unit.get_absolute_size().x / 2), rand_range(botleft.position.y, topright.position.y)))
