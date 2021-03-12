extends Node2D


onready var login_screen = $CenterContainer/Login
onready var register_screen = $CenterContainer/Register

onready var log_username_input = $CenterContainer/Login/LogUsername
onready var log_password_input = $CenterContainer/Login/LogPassword
onready var login_button = $CenterContainer/Login/HBoxContainer/LoginButton
onready var register_button = $CenterContainer/Login/HBoxContainer/RegisterButton

onready var reg_username_input = $CenterContainer/Register/RegUsername
onready var reg_password1_input = $CenterContainer/Register/RegPassword1
onready var reg_password2_input = $CenterContainer/Register/RegPassword2
onready var confirm_button = $CenterContainer/Register/HBoxContainer/ConfirmButton
onready var back_button = $CenterContainer/Register/HBoxContainer/BackButton


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/LoginScreen.tscn"


func _on_LoginButton_pressed() -> void:
	if log_username_input.text == "" or log_password_input.text == "":
		print("Please provide valid login and password")
	else:
		login_button.disabled = true
		register_button.disabled = true
		var username = log_username_input.get_text().to_lower()
		var password = log_password_input.get_text()
		print("Attempting to login...")
		Gateway.ConnectToServer(username, password, false)

func _on_RegisterButton_pressed() -> void:
	login_screen.hide()
	register_screen.show()

func _on_BackButton_pressed():
	login_screen.show()
	register_screen.hide()

func _on_ConfirmButton_pressed():
	if reg_username_input.get_text() == "":
		print("Please provide a valid login")
	elif reg_password1_input.get_text() == "":
		print("Please provide a valid password")
	elif reg_password2_input.get_text() == "":
		print("Please repeat your password")
	elif reg_password1_input.get_text() != reg_password2_input.get_text():
		print("Passwords doesn't match")
	elif reg_password1_input.get_text().length() < 6:
		print("Password must contain at least 6 characters")
	else:
		confirm_button.disabled = true
		back_button.disabled = true
		var username = reg_username_input.get_text().to_lower()
		var password = reg_password1_input.get_text()
		Gateway.ConnectToServer(username, password, true)
