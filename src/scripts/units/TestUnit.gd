extends KinematicBody2D


enum states {
	MOVING,
	WAITING
}


export(int) var speed = 128
export(int) var acceleration = 500


var velocity = Vector2.ZERO
var state = states.WAITING

var unit_data = {
	pos = position,
	target_position = Vector2.ZERO
}

var reached_pos = false
var timer_called = false


onready var timer = $Timer
onready var colorRect = $ColorRect
onready var sprite = $Sprite

onready var world = get_tree().get_nodes_in_group("world").front()


signal request_new_position


func _ready() -> void:
	connect("request_new_position", world, "_send_new_target_position", [self])

func _physics_process(delta):
	if position.distance_to(unit_data.target_position) < 10 and !timer_called:
		state = states.WAITING
	if state != states.MOVING and !timer_called:
		velocity = Vector2.ZERO
		timer.start(randi() % 5 + 1)
		timer_called = true
	elif state == states.MOVING:
		velocity = position.direction_to(unit_data.target_position) * speed
		move()
	#print(position, " : ", target_pos, " : ", velocity)
	
	#print(timer.time_left)


func move() -> void:
	move_and_slide(velocity)

func sync_scale(new_scale) -> void:
	scale = new_scale
	#print(colorRect.rect_scale)

func get_absolute_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale


func _update_target_position(new_pos) -> void:
	unit_data.target_position = new_pos
	state = states.MOVING
	Global._update_unit(self)

func _update_current_position(new_pos) -> void:
	position = new_pos


func _on_Timer_timeout() -> void:
	if randi() % 2 == 0:
		emit_signal("request_new_position")
	timer_called = false
