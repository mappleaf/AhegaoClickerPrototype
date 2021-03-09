extends Node2D


onready var username_input = $CenterContainer/HBoxContainer/VBoxContainer/Username
onready var password_input = $CenterContainer/HBoxContainer/VBoxContainer/Password
onready var login_button = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/LoginButton
onready var register_button = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/RegisterButton


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/LoginScreen.tscn"


func _on_LoginButton_pressed() -> void:
	if username_input.text == "" or password_input.text == "":
		print("Please provide valid login and password")
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		print("Attempting to login...")
		Gateway.ConnectToServer(username, password)

func _on_RegisterButton_pressed() -> void:
	pass # Replace with function body.
