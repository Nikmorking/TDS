extends Node

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")

var port = 5287
var ip_addr = "127.0.0.1"

@onready var players_container = Global.papa # Путь к вашему узлу для игроков


func set_papa():
	Global.papa = get_tree().root.get_node("Node3D")
	players_container = Global.papa.get_node("cont_players")


func start_host():
	set_papa()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Сервер успешно запущен!")
		# Спавним создателя сервера (его ID всегда равен 1)
		_spawn_player(1)
	else:
		print("Ошибка запуска сервера: ", error)

func start_join():
	set_papa()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip_addr, port)
	get_tree().root.get_node("Node3D")
	if error == OK:
		multiplayer.multiplayer_peer = peer
		Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Подключение к серверу..."
		# Запустим короткий таймер на проверку статуса через 1 секунду
		# Запускаем встроенный таймер ожидания на 5 секунд
		var timeout_timer = get_tree().create_timer(30.0)
		
		# Ждем либо успешного подключения, либо выхода по времени
		while peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING:
			await get_tree().process_frame # Ждем каждый кадр
			
			# Если 5 секунд прошло, а статус все еще "подключение" — это тайм-аут
			if timeout_timer.time_left <= 0:
				Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Клиент: Время ожидания истекло (Тайм-аут!). \nСервер недоступен."
				_handle_connection_failure()
				return
				
		# Дополнительная проверка: если статус после цикла не стал "подключен"
		if peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
			_handle_connection_failure()
	else:
		Global.papa.get_node("Prolog/Camera3D/server/Label").text = "Ошибка инициализации клиента: "

func _on_player_connected(id):
	# Этот код выполняется на сервере, когда заходит новый клиент
	if multiplayer.is_server():
		_spawn_player(id)

func _on_player_disconnected(id):
	if players_container.has_node(str(id)):
		players_container.get_node(str(id)).queue_free()

func _spawn_player(id):
	var player_scene = load("res://scenes/player.tscn") # Укажите точный путь к сцене игрока
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	var sync_node = player_instance.get_node("MultiplayerSynchronizer")
	if sync_node:
		sync_node.set_multiplayer_authority(id)
	player_instance.set_multiplayer_authority(id, true)
	players_container.add_child(player_instance)
	
	# Передаем сетевые права управления владельцу ID

func _on_player_spawned(node: Node):
	# Имя созданного узла — это строка с ID игрока (например "24196863")
	var player_id = node.name.to_int()
	Global.papa.get_node("Prolog/Camera3D/server").hide()
	# Принудительно выставляем права на клиенте в момент рождения узла
	node.set_multiplayer_authority(player_id)
	var sync_node = node.get_node_or_null("MultiplayerSynchronizer")
	if sync_node:
		sync_node.set_multiplayer_authority(player_id)
		
	print("Клиент зафиксировал спавн узла ", node.name, ". Права выданы ID: ", player_id)

func _handle_connection_failure():
	# Полностью сбрасываем сетевой интерфейс, чтобы освободить порты
	multiplayer.multiplayer_peer = null
	
	print("Возврат в главное меню...")
	
	await get_tree().create_timer(5.0).timeout
	# Замените путь на вашу реальную сцену главного меню
	get_tree().change_scene_to_file("res://demo/Main menu.tscn") 
