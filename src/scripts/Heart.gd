extends Node2D

export(int) var lifetime = 5


onready var spriteDefault = $Default
onready var spriteAhe = $Ahe
onready var timer = $Timer


var allow_fade = false
var a = modulate.a
#var target_rotation = 0.0
var rotation_direction = round(rand_range(-1, 1))


func _ready() -> void:
	timer.start(lifetime)
	rotation_degrees = rand_range(-35, 35)
	
	while(rotation_direction == 0):
		rotation_direction = round(rand_range(-1, 1))
	
	if randi() % 10 == 0:
		spriteDefault.hide()
		spriteAhe.show()
		scale *= 4


func _physics_process(delta) -> void:
	position -= Vector2(0, 2)
	
#	if target_rotation < rotation_degrees:
#		rotation_degrees += 1
#		if target_rotation >= rotation_degrees:
#			target_rotation = rand_range(-35, 35)
#	elif target_rotation > rotation_degrees:
#		rotation_degrees -= 1
#		if target_rotation <= rotation_degrees:
#			target_rotation = rand_range(-35, 35)
#	elif target_rotation == rotation_degrees:
#		target_rotation = rand_range(-35, 35)
	
	#rotation_degrees = lerp(rotation_degrees, target_rotation, 0.1)
	
	rotation_degrees = lerp(rotation_degrees, rotation_degrees + rotation_direction, delta * 100)
	if abs(rotation_degrees) >= 35:
		rotation_direction = -rotation_direction
	
	if allow_fade:
		a -= 0.05
		modulate = Color(modulate.r, modulate.g, modulate.b, a)
		if a <= 0:
			queue_free()


func _on_Timer_timeout():
	allow_fade = true
