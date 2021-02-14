extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Menu.tscn"


func _on_SettingsButton_pressed():
	pass # Replace with function body.

func _on_PlayButton_pressed():
	get_tree().change_scene("res://src/scenes/worlds/TestWorld.tscn")
