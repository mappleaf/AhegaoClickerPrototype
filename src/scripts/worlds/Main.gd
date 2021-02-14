extends Node2D


onready var clicker = $CenterContainer/HBoxContainer/VBoxContainer/Clicker
onready var container = $CenterContainer

var heart = preload("res://src/scenes/Heart.tscn")


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Main.tscn"


func _on_TextureButton_button_down():
	clicker.rect_position += Vector2(0, 10)

func _on_TextureButton_button_up():
	clicker.rect_position -= Vector2(0, 10)

func _on_Clicker_pressed():
	var heartinstance = heart.instance()
	clicker.add_child(heartinstance)
	heartinstance.position = clicker.rect_position + (clicker.rect_size * clicker.rect_scale - Vector2(rand_range((clicker.rect_size.x * clicker.rect_scale.x) / -1.5, (clicker.rect_size.x * clicker.rect_scale.x) / 1.5), rand_range((clicker.rect_size.y * clicker.rect_scale.y) / 1.25, (clicker.rect_size.y * clicker.rect_scale.y) / 3.5))) * container.rect_scale
