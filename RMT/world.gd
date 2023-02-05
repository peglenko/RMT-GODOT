extends Node

var playerEmail = Global.email

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar

const Player = preload("res://player.tscn")
const PORT = 55557
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_host_button_pressed():
	main_menu.hide()
	hud.show()
	print(playerEmail)
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player) # will run everytime someone connects and will spawn player for clients
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	#upnp_setup()


func _on_join_button_pressed():
	main_menu.hide()
	hud.show()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer


func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)
		
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		
func update_health_bar(health_value):
	health_bar.value = health_value
	


func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)
		
		
#func upnp_setup():
	#var upnp = UPNP.new()
	#var discover_result = upnp.discover()
	
	#print(discover_result)
	#if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
	#	upnp.add_port_mapping(PORT)
	#else:
	#	print(upnp.get_gateway(), upnp)
	#print("Success! Join Address: ", upnp.query_external_address())
	
	#var map_result = upnp.add_port_mapping(55556)
	#assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP PORT MAPPING FAILED") #auto port-forwarding with upnp
	#print(map_result)
