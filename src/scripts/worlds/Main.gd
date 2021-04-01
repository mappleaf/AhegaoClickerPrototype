extends Node2D


const MIN_FREQ = 20
const MAX_FREQ = 20000


onready var clicker = $CenterContainer/HBoxContainer/VBoxContainer/Clicker
onready var container = $CenterContainer
onready var clickerTimer = $CenterContainer/HBoxContainer/VBoxContainer/Clicker/Timer
onready var girl = $Girl

onready var comboLabel = $CenterContainer/HBoxContainer/VBoxContainer/ComboLabel
onready var healthBar = $CenterContainer/HBoxContainer/VBoxContainer/EnemyHealth

onready var heart_forbeat = $Girl/Heart
onready var heartbeat = $Heartbeat
onready var heartbeatTimer = $HeartbeatTimer


var heart = preload("res://src/scenes/Heart.tscn")
var combo = 0


func _ready() -> void:
	Global.current_scene = "res://src/scenes/worlds/Main.tscn"
	clicker.texture_normal = load(Global.enemy.texture_location)
	healthBar.max_value = Global.enemy.max_health
	healthBar.value = Global.enemy.health
	update_enemy()

func _process(_delta) -> void:
	heart_forbeat.scale.x = lerp(heart_forbeat.scale.x, 0.25, 0.05)
	heart_forbeat.scale.y = lerp(heart_forbeat.scale.y, 0.25, 0.05)

func _physics_process(_delta) -> void:
	combo = clamp(combo, 0, 100)
	comboLabel.text = "Combo: " + str(combo)
	
	clicker.texture_normal = load(Global.enemy.texture_location)
	healthBar.max_value = Global.enemy.max_health
	healthBar.value = Global.enemy.health
	
	if Global.enemy.health <= 0 and Global.is_enemy_new == true:
		update_enemy()
	
	if Global.enemy.health <= 0:
		Global.killed_enemy()


func update_enemy() -> void:
	print("Update enemy")
	healthBar.value = Global.enemy.max_health
	Global.is_enemy_new = false


func _on_TextureButton_button_down():
	clicker.rect_position += Vector2(0, 10)

func _on_TextureButton_button_up():
	clicker.rect_position -= Vector2(0, 10)

func _on_Clicker_pressed():
	combo += 1
	
	if Global.enemy.health >= 0:
		Global.enemy.health = max(Global.enemy.health - Global.damage, 0)
	
	var heartinstance = heart.instance()
	girl.add_child(heartinstance)
	heartinstance.position = girl.global_position + (girl.scale - Vector2(rand_range((girl.position.x * girl.scale.x) / -1.5, (girl.position.x * girl.scale.x) / 1.5), rand_range((girl.position.y * girl.scale.y) / 1.25, (girl.position.y * girl.scale.y) / 3.5))) * container.rect_scale

func _on_ClickerTimer_timeout():
	combo -= 1

func _on_HeartbeatTimer_timeout():
	heartbeat.play()
	if combo == 0:
		heartbeatTimer.start(1.25)
	elif combo / 10 < 0.1:
		heartbeatTimer.start(1.25)
	else:
		heartbeatTimer.start(1.5 / (combo / 10.0))
	heart_forbeat.scale.x = 0.5
	heart_forbeat.scale.y = 0.5
