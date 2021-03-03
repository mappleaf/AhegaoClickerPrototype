extends Node2D

onready var colorRect = $ColorRect


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/GachaShop.tscn"


func _on_TextureButton_pressed():
	colorRect.color = Color(255, 255, 255)

func _on_TextureButton2_pressed():
	colorRect.color = Color(0, 0, 0)
