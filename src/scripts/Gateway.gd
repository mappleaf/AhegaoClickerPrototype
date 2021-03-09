extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910

var username
var password


func _ready() -> void:
	pass

func _process(_delta) -> void:
	if get_custom_multiplayer() == null:
		return
	if !custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func ConnectToServer(_username, _password) -> void:
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("server_disconnected", self, "_on_server_disconnected")
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func RequestLogin() -> void:
	print("Connecting to gateway to request login...")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""

remote func ReturnLoginRequest(result) -> void:
	print("Result received")
	if result == true:
		Server.ConnectToServer()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/scenes/worlds/Connecting.tscn")
	else:
		print("Please provide correct username and password")
		get_tree().get_nodes_in_group("login_button").front().disabled = false
		
	network.disconnect("server_disconnected", self, "_on_server_disconnected")
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")


func _on_server_disconnected() -> void:
	print("Login server is shut down")
	get_tree().get_nodes_in_group("login_button").front().disabled = false

func _on_connection_failed() -> void:
	print("Failed to connect to login server")
	get_tree().get_nodes_in_group("login_button").front().disabled = false
	#get_tree().change_scene("res://src/scenes/worlds/NoConnection.tscn")

func _on_connection_succeeded() -> void:
	print("Succesfully connected to login server")
	RequestLogin()
