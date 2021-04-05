extends Node2D

onready var colorRect = $ColorRect
onready var gacha_count_label = $Control/OpenGacha/GachaCount

var current_gacha = "gacha_starting"


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/GachaShop.tscn"
	gacha_count_label.text = str(Global.gacha_starting)

func _physics_process(_delta):
	match current_gacha:
		"gacha_starting":
			gacha_count_label.text = str(Global.gacha_starting)
		"gacha_regular":
			gacha_count_label.text = str(Global.gacha_regular)
		"gacha_special":
			gacha_count_label.text = str(Global.gacha_special)


func _on_Gacha_Starting_pressed():
	Global.get_gacha()
	colorRect.color = Color(1, 1, 1)
	current_gacha = "gacha_starting"
	gacha_count_label.text = str(Global.gacha_starting)

func _on_Gacha_Regular_pressed():
	Global.get_gacha()
	colorRect.color = Color(0, 0, 0)
	current_gacha = "gacha_regular"
	gacha_count_label.text = str(Global.gacha_regular)

func _on_Gacha_Special_pressed():
	Global.get_gacha()
	colorRect.color = Color(1, 0, 0)
	current_gacha = "gacha_special"
	gacha_count_label.text = str(Global.gacha_special)

func _on_OpenGacha_pressed():
	Global.get_gacha()
	Global.open_gacha(current_gacha)
