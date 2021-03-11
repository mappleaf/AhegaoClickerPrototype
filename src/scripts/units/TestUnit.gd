extends KinematicBody2D


enum states {
	MOVING,
	WAITING
}


export(int) var speed = 128
export(int) var acceleration = 500


const MIN_DISTANCE = 15


var velocity = Vector2.ZERO
var state = states.WAITING

var unit_data = {
	type = Global.unit_types.TEST,
	pos = global_position,
	target_position = Vector2.ZERO
}


onready var timer = $Timer
onready var colorRect = $ColorRect
onready var sprite = $Sprite

onready var world = get_tree().get_nodes_in_group("world").front()


signal request_new_position


func _physics_process(_delta):
	if position.distance_to(unit_data.target_position) < MIN_DISTANCE:
		state = states.WAITING
	if state != states.MOVING and timer.time_left == 0:
		velocity = Vector2.ZERO
		timer.start(randi() % 5 + 1)
	elif state == states.MOVING:
		velocity = position.direction_to(unit_data.target_position) * speed
		move()
	
	unit_data.pos = position
	#print(position, " : ", unit_data.target_position, " : ", velocity)
	
	#print(timer.time_left)


func move() -> void:
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func sync_scale(new_scale) -> void:
	scale = new_scale
	#print(colorRect.rect_scale)

func get_absolute_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale


func _update_target_position(new_pos) -> void:
	unit_data.target_position = new_pos
	state = states.MOVING

func _update_current_position(new_pos) -> void:
	position = new_pos


func _on_Timer_timeout() -> void:
	if randi() % 2 == 0:
		emit_signal("request_new_position")
