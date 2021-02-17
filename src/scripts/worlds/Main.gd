extends Node2D


onready var clicker = $CenterContainer/HBoxContainer/VBoxContainer/Clicker
onready var container = $CenterContainer
onready var clickerTimer = $CenterContainer/HBoxContainer/VBoxContainer/Clicker/Timer

onready var comboLabel = $CenterContainer/HBoxContainer/VBoxContainer/ComboLabel

var heart = preload("res://src/scenes/Heart.tscn")
var combo = 0


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Main.tscn"

func _physics_process(_delta) -> void:
	combo = clamp(combo, 0, 100)
	comboLabel.text = "Combo: " + str(combo)


func _on_TextureButton_button_down():
	clicker.rect_position += Vector2(0, 10)

func _on_TextureButton_button_up():
	clicker.rect_position -= Vector2(0, 10)

func _on_Clicker_pressed():
	combo += 1
	var heartinstance = heart.instance()
	clicker.add_child(heartinstance)
	heartinstance.position = clicker.rect_position + (clicker.rect_size * clicker.rect_scale - Vector2(rand_range((clicker.rect_size.x * clicker.rect_scale.x) / -1.5, (clicker.rect_size.x * clicker.rect_scale.x) / 1.5), rand_range((clicker.rect_size.y * clicker.rect_scale.y) / 1.25, (clicker.rect_size.y * clicker.rect_scale.y) / 3.5))) * container.rect_scale

func _on_ClickerTimer_timeout():
	combo -= 1
