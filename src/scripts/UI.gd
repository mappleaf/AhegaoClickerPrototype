extends CanvasLayer


onready var homeButton = $Container/VBoxContainer/HomeButton
onready var roomButton = $Container/VBoxContainer/RoomButton
onready var shopButton = $Container/VBoxContainer/ShopButton
onready var listButton = $Container/VBoxContainer/ListButton

onready var container = $Container


func _process(_delta) -> void:
	match Global.current_scene:
		"res://src/scenes/worlds/Menu.tscn":
			container.hide()
		"res://src/scenes/worlds/NoConnection.tscn":
			container.hide()
		"res://src/scenes/worlds/Connecting.tscn":
			container.hide()
		"res://src/scenes/worlds/LoginScreen.tscn":
			container.hide()
		"res://src/scenes/worlds/Main.tscn":
			container.show()
			homeButton.disabled = true
			roomButton.disabled = false
			shopButton.disabled = false
			listButton.disabled = false
		"res://src/scenes/worlds/TestWorld.tscn":
			container.show()
			homeButton.disabled = false
			roomButton.disabled = true
			shopButton.disabled = false
			listButton.disabled = false
		"res://src/scenes/worlds/Shop.tscn":
			container.show()
			homeButton.disabled = false
			roomButton.disabled = false
			shopButton.disabled = true
			listButton.disabled = false
		"res://src/scenes/worlds/List.tscn":
			container.show()
			homeButton.disabled = false
			roomButton.disabled = false
			shopButton.disabled = false
			listButton.disabled = true


func remove_units_in_room() -> void:
	if Global.units_in_room:
		for unit in Global.units_in_room:
			get_tree().get_nodes_in_group("units_holder").front().remove_child(Global.units_in_room[unit])


func _on_HomeButton_pressed() -> void:
	if get_tree().current_scene.get_path() == "res://src/scenes/worlds/TestWorld.tscn" and get_tree().get_nodes_in_group("units_holder").front().get_child_count() != 0:
		remove_units_in_room()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Main.tscn")

func _on_RoomButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/TestWorld.tscn")

func _on_ShopButton_pressed():
	if get_tree().current_scene.get_path() == "res://src/scenes/worlds/TestWorld.tscn" and get_tree().get_nodes_in_group("units_holder").front().get_child_count() != 0:
		remove_units_in_room()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Shop.tscn")

func _on_ListButton_pressed():
	if get_tree().current_scene.get_path() == "res://src/scenes/worlds/TestWorld.tscn" and get_tree().get_nodes_in_group("units_holder").front().get_child_count() != 0:
		remove_units_in_room()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/List.tscn")
