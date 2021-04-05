extends Node2D


onready var stardust_label = $CenterContainer/HBoxContainer/VBoxContainer/StardustLabel


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Shop.tscn"

func _physics_process(_delta):
	stardust_label.text = str("Stardust count: ", Global.stardust)


func _on_TextureButton_pressed():
	Server.request_new_random_unit()


func _on_GachaShopButton_pressed():
	get_tree().change_scene("res://src/scenes/worlds/GachaShop.tscn")
