extends Node

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")

var port = 5287
var ip_addr = "0.0.0.0" # Если "0.0.0.0" — ищем по Broadcast, иначе — подключаемся напрямую по IP

# Настройки для Broadcast (LAN)
var broadcast_port: int = 6767
var udp_peer: PacketPeerUDP = PacketPeerUDP.new()
var broadcast_timer: Timer
var is_listening_lan: bool = false

@onready var players_container = Global.papa # Путь к вашему узлу для игроков


func set_papa():
	Global.papa = get_tree().root.get_node("Node3D")
	players_container = Global.papa.get_node("cont_players")

func _process(_delta):
	if not is_listening_lan:
		return
		
	while udp_peer.get_available_packet_count() > 0:
		var server_ip = udp_peer.get_packet_ip()
		var packet = udp_peer.get_packet()
		var raw_string = packet.get_string_from_utf8()
		
		# --- ЗАПЛАТКА ДЛЯ ЛОКАЛЬНЫХ ТЕСТОВ (ЛОКАЛЬНОЙ ПЕТЛИ) ---
		if server_ip == "":
			server_ip = "127.0.0.1"
		# ------------------------------------------------------
		
		var json = JSON.new()
		if json.parse(raw_string) == OK:
			var data = json.get_data()
			if data.has("port") and data.get("type") == "godot_lan_server":
				_stop_lan_listening()
				ip_addr = server_ip
				port = int(data["port"])
				print("Сервер найден через Broadcast! IP: ", ip_addr, " Порт: ", port)
				_connect_to_server()
				break

func start_host():
	set_papa()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Сервер успешно запущен!")
		
		_start_lan_broadcasting()
		
		_spawn_player(1)
		Global._add_player.rpc_id(1, 1, Global.nickname)
	else:
		print("Ошибка запуска сервера: ", error)

func start_join():
	set_papa()
	
	# Проверяем режим подключения: Broadcast или прямой IP
	if ip_addr == "0.0.0.0":
		Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Поиск серверов в локальной сети..."
		
		udp_peer.close()
		var err = udp_peer.bind(broadcast_port)
		if err == OK:
			is_listening_lan = true
			print("Инициирован поиск LAN (Broadcast)...")
			
			# Тайм-аут поиска на 10 секунд
			await get_tree().create_timer(10.0).timeout
			if is_listening_lan:
				_stop_lan_listening()
				Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Серверы в локальной сети не найдены."
				_handle_connection_failure()
		else:
			print("Не удалось открыть порт для LAN: ", err)
			_handle_connection_failure()
	else:
		# Если IP задан (не 0.0.0.0), то сразу подключаемся напрямую
		print("Прямое подключение к IP: ", ip_addr)
		_connect_to_server()

# Выделенный метод для подключения к конкретному ip_addr и port
func _connect_to_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip_addr, port)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Подключение к серверу %s..." % ip_addr
		
		var timeout_timer = get_tree().create_timer(30.0)
		
		while peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING:
			await get_tree().process_frame
			
			if timeout_timer.time_left <= 0:
				Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Клиент: Время ожидания истекло (Тайм-аут!).\nСервер недоступен."
				_handle_connection_failure()
				return
				
		if peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
			_handle_connection_failure()
	else:
		Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Ошибка инициализации клиента."

func _on_player_connected(id):
	if Global.lobby_ready: 
		multiplayer.multiplayer_peer.disconnect_peer(id)
		return
	if multiplayer.is_server():
		_spawn_player(id)

func _on_player_disconnected(id):
	if players_container.has_node(str(id)):
		players_container.get_node(str(id)).queue_free()

func _spawn_player(id):
	var player_scene = load("res://scenes/player.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	var sync_node = player_instance.get_node("MultiplayerSynchronizer")
	if sync_node:
		sync_node.set_multiplayer_authority(id)
	player_instance.set_multiplayer_authority(id, true)
	players_container.add_child(player_instance)

func _on_player_spawned(node: Node):
	var player_id = node.name.to_int()
	Global.player = node
	Global.papa.get_node("Prolog/Camera3D/server").hide()
	node.set_multiplayer_authority(player_id)
	var sync_node = node.get_node_or_null("MultiplayerSynchronizer")
	if sync_node:
		sync_node.set_multiplayer_authority(player_id)
	print("Клиент зафиксировал спавн узла ", node.name, ". Права выданы ID: ", player_id)

func _handle_connection_failure():
	_stop_lan_listening()
	_stop_lan_broadcasting()
	multiplayer.multiplayer_peer = null
	
	print("Возврат в главное меню...")
	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://demo/Main menu.tscn")


# --- МЕТОДЫ BROADCAST ВЕЩАНИЯ И ОСТАНОВКИ ---

func _start_lan_broadcasting():
	udp_peer.set_broadcast_enabled(true)
	# Явно биндимся к любому порту, разрешая совместное использование адреса
	udp_peer.bind(0)
	
	var server_info = {
		"type": "godot_lan_server",
		"port": port,
		"name": Global.nickname
	}
	var packet_data = JSON.stringify(server_info).to_utf8_buffer()
	
	broadcast_timer = Timer.new()
	broadcast_timer.wait_time = 1.0
	broadcast_timer.autostart = true
	broadcast_timer.timeout.connect(func():
		# 1. Шлем в локальную сеть для других ПК
		udp_peer.set_dest_address("255.255.255.255", broadcast_port)
		udp_peer.put_packet(packet_data)
		
		# 2. Шлем на loopback специально для теста двух окон на одном ПК
		#udp_peer.set_dest_address("127.0.0.1", broadcast_port)
		#udp_peer.put_packet(packet_data)
	)
	add_child(broadcast_timer)
	print("Broadcast запущен (LAN + Localhost) на порту ", broadcast_port)

func _stop_lan_broadcasting():
	if broadcast_timer:
		broadcast_timer.queue_free()
	udp_peer.close()

func _stop_lan_listening():
	is_listening_lan = false
	udp_peer.close()
	is_listening_lan = false
	udp_peer.close()
