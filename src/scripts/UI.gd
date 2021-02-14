extends CanvasLayer


onready var homeButton = $Container/VBoxContainer/HomeButton
onready var roomButton = $Container/VBoxContainer/RoomButton
onready var container = $Container


func _process(_delta) -> void:
	match Global.current_scene:
		"res://src/scenes/worlds/Menu.tscn":
			container.hide()
		"res://src/scenes/worlds/Main.tscn":
			container.show()
			homeButton.disabled = true
			roomButton.disabled = false
		"res://src/scenes/worlds/TestWorld.tscn":
			container.show()
			homeButton.disabled = false
			roomButton.disabled = true


func _on_HomeButton_pressed() -> void:
	for unit in Global.units:
		unit.unit_data.pos = unit.position
		get_tree().get_nodes_in_group("units_holder").front().remove_child(unit)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Main.tscn")

func _on_RoomButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/TestWorld.tscn")
