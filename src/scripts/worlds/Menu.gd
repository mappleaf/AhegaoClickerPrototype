extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Menu.tscn"
	Global.get_owned_units()


func _on_SettingsButton_pressed():
	pass # Replace with function body.

func _on_PlayButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/TestWorld.tscn")
