extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/NoConnection.tscn"


func _on_TextureButton_pressed():
	get_tree().quit()
