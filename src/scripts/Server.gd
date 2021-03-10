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
	rpc_id(1, "ReturnToken", token)

remote func ReturnTokenVerificationResults(result) -> void:
	if result == true:
		print("Succesful token verification")
		# warning-ignore:return_value_discarded
		#get_tree().change_scene("res://src/scenes/worlds/Connecting.tscn")
	else:
		print("Login failed, please try again")
		get_tree().get_nodes_in_group("login_button").front().disabled = false

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
	Global.unit_types = list

remote func _return_owned_units(units) -> void:
	Global.owned_units = units

remote func _return_units_in_room(list) -> void:
#	for item in list:
#		if !Global.units_in_room.has(item):
#			Global._append_unit(item)
	Global.units_in_room = list
