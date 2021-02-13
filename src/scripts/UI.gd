extends CanvasLayer


onready var homeButton = $VBoxContainer/HomeButton
onready var roomButton = $VBoxContainer/RoomButton


func _process(_delta) -> void:
	match Global.current_scene:
		"res://src/scenes/worlds/Main.tscn":
			homeButton.disabled = true
			roomButton.disabled = false
		"res://src/scenes/worlds/TestWorld.tscn":
			homeButton.disabled = false
			roomButton.disabled = true


func _on_HomeButton_pressed() -> void:
	for unit in Global.units:
		get_tree().get_nodes_in_group("units_holder").front().remove_child(unit)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Main.tscn")

func _on_RoomButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/TestWorld.tscn")
