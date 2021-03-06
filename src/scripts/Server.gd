extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var token

var decimal_collector: float = 0
var latency = 0
var client_clock = 0
var delta_latency = 0
var latency_array = []


func _physics_process(delta): #0.01667
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00

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

remote func ReturnServerTime(server_time, client_time) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		latency = (OS.get_system_time_msecs() - client_time) / 2
		client_clock = server_time + latency

func DetermineLatency() -> void:
	rpc_id(1, "DetermineLatency", OS.get_system_time_msecs())

remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
	if latency_array.size() >= 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size() - 1, -1, -1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()


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

func get_gacha() -> void:
	rpc_id(1, "get_user_gacha")

func open_gacha(gacha_type) -> void:
	rpc_id(1, "open_gacha", gacha_type)

func get_stardust() -> void:
	rpc_id(1, "get_user_stardust")

func get_weapons() -> void:
	rpc_id(1, "get_user_weapons")


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
	
	rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)
	
	get_unit_types()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/worlds/Menu.tscn")

remote func _return_units_list(list) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.unit_types = list

remote func _return_owned_units(units) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.owned_units = units
		print(Global.owned_units)

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

remote func _return_gacha(gacha_count) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		if Global.gacha_starting and Global.gacha_regular and Global.gacha_special:
			if Global.gacha_starting > gacha_count[0] or Global.gacha_regular > gacha_count[1] or Global.gacha_special > gacha_count[2]:
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://src/scenes/worlds/NoConnection.tscn")
				return
		Global.gacha_starting = gacha_count[0]
		Global.gacha_regular = gacha_count[1]
		Global.gacha_special = gacha_count[2]

remote func _return_stardust(count) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.stardust = count

remote func _return_weapons(weapons) -> void:
	if get_tree().get_rpc_sender_id() == 1:
		Global.weapons = weapons
		print(Global.weapons)
