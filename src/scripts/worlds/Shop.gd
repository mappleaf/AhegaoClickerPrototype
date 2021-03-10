extends Node2D


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Shop.tscn"


func _on_TextureButton_pressed():
	Server.request_new_random_unit()


func _on_GachaShopButton_pressed():
	get_tree().change_scene("res://src/scenes/worlds/GachaShop.tscn")
