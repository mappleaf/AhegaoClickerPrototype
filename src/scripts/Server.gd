extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909


func _ready() -> void:
	#ConnectToServer()
	pass


func ConnectToServer() -> void:
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("server_disconnected", self, "_on_connection_failed")
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func get_unit_types() -> void:
	rpc_id(1, "send_units_list")


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
