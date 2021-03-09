extends Node2D

onready var sprite = $CenterContainer/Sprite


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Connecting.tscn"

func _physics_process(_delta) -> void:
	sprite.rotation_degrees += 1
