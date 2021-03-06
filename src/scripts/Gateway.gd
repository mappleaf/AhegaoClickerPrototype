extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910
var cert = load("res://src/resources/Certificate/AC_Certificate.crt")

var username
var password
var is_account_new


func _ready() -> void:
	pass

func _process(_delta) -> void:
	if get_custom_multiplayer() == null:
		return
	if !custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func ConnectToServer(_username, _password, _is_account_new) -> void:
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	network.set_dtls_enabled(false)
	network.set_dtls_verify_enabled(false)
	network.set_dtls_certificate(cert)
	
	username = _username
	password = _password
	is_account_new = _is_account_new
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	#network.connect("server_disconnected", self, "_on_server_disconnected")
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func RequestLogin() -> void:
	print("Connecting to gateway to request login...")
	rpc_id(1, "LoginRequest", username, password.sha256_text())
	username = ""
	password = ""

remote func ReturnLoginRequest(result, token) -> void:
	if custom_multiplayer.get_rpc_sender_id() == 1:
		print("Result received")
		if result == true:
			Server.token = token
			Server.ConnectToServer()
		else:
			print("Please provide correct username and password")
			get_tree().get_nodes_in_group("login_button").front().disabled = false
			get_tree().get_nodes_in_group("register_button").front().disabled = false
			
		#network.disconnect("server_disconnected", self, "_on_server_disconnected")
		network.disconnect("connection_failed", self, "_on_connection_failed")
		network.disconnect("connection_succeeded", self, "_on_connection_succeeded")

func RequestRegister() -> void:
	print("Connecting to gateway to request register...")
	rpc_id(1, "RegisterRequest", username, password.sha256_text())
	username = ""
	password = ""

remote func ReturnRegisterRequest(result, message) -> void:
	if custom_multiplayer.get_rpc_sender_id() == 1:
		print("Result received")
		if result == true:
			print("Account created, please log in")
			get_tree().get_nodes_in_group("login_world").front()._on_BackButton_pressed()
		else:
			if message == 1:
				print("Couldn't create account, please retry")
			elif message == 2:
				print("Username already in use")
			get_tree().get_nodes_in_group("confirm_button").front().disabled = false
			get_tree().get_nodes_in_group("back_button").front().disabled = false
#		network.disconnect("server_disconnected", self, "_on_server_disconnected")
		network.disconnect("connection_failed", self, "_on_connection_failed")
		network.disconnect("connection_succeeded", self, "_on_connection_succeeded")


#func _on_server_disconnected() -> void:
#	print("Login server is shut down")
#	get_tree().get_nodes_in_group("confirm_button").front().disabled = false
#	get_tree().get_nodes_in_group("back_button").front().disabled = false
#	get_tree().get_nodes_in_group("login_button").front().disabled = false
#	get_tree().get_nodes_in_group("register_button").front().disabled = false

func _on_connection_failed() -> void:
	print("Failed to connect to login server")
	get_tree().get_nodes_in_group("confirm_button").front().disabled = false
	get_tree().get_nodes_in_group("back_button").front().disabled = false
	get_tree().get_nodes_in_group("login_button").front().disabled = false
	get_tree().get_nodes_in_group("register_button").front().disabled = false
	#get_tree().change_scene("res://src/scenes/worlds/NoConnection.tscn")

func _on_connection_succeeded() -> void:
	print("Succesfully connected to login server")
	if is_account_new == true:
		RequestRegister()
	else:
		RequestLogin()
