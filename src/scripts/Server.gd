extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var token


func _ready() -> void:
	#ConnectToServer()
	pass


func ConnectToServer() -> void:
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("server_disconnected", self, "_on_server_disconnected")
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

remote func FetchToken():
	if get_tree().get_rpc_sender_id() == 1:
		rpc_id(1, "ReturnToken", token)

remote func ReturnTokenVerificationResults(result) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		if result == true:
			print("Succesful token verification")
			# warning-ignore:return_value_discarded
			#get_tree().change_scene("res://src/scenes/worlds/Connecting.tscn")
		else:
			print("Login failed, please try again")
			get_tree().get_nodes_in_group("login_button").front().disabled = false
			get_tree().get_nodes_in_group("register_button").front().disabled = false

func get_unit_types() -> void:
	rpc_id(1, "send_units_list")

func request_owned_units() -> void:
	rpc_id(1, "send_owned_units")

func get_units_in_room() -> void:
	rpc_id(1, "send_units_in_room")

func send_units_in_room() -> void:
	rpc_id(1, "get_units_in_room", Global.units_in_room)

func request_new_random_unit() -> void:
	rpc_id(1, "add_random_unit")

func get_money() -> void:
	rpc_id(1, "get_user_money")

func get_enemies() -> void:
	rpc_id(1, "send_enemies_list")

func get_enemy() -> void:
	rpc_id(1, "send_current_enemy")

func killed_enemy() -> void:
	rpc_id(1, "killed_enemy")


func _on_server_disconnected() -> void:
	print("Server is shut down")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/NoConnection.tscn")

func _on_connection_failed() -> void:
	print("Failed to connect")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/LoginScreen.tscn")

func _on_connection_succeeded() -> void:
	print("Succesfully connected")
	get_unit_types()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Menu.tscn")

remote func _return_units_list(list) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.unit_types = list

remote func _return_owned_units(units) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.owned_units = units

remote func _return_units_in_room(list) -> void:
	if get_tree().get_rpc_sender_id() == 1:
#		for item in list:
#			if !Global.units_in_room.has(item):
#				Global._append_unit(item)
		Global.units_in_room = list

remote func _return_money_count(count) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.money = count

remote func _return_enemies_list(list) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.enemies = list

remote func _return_current_enemy(enemy, is_new) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.enemy = enemy
		Global.is_enemy_new = is_new
