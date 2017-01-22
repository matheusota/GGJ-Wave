extends Spatial

onready var _texture_vel = 0.3

onready var _global = get_node("/root/global")
onready var _finished = false

onready var elapsed_time = 0
onready var Coin = preload("res://scenes/coin.tscn")

func start():
	# Time
	_global._match_timer = 60
	
	# Configure players
	var conf = _global._player_config
	for i in range(conf.size()):
		if conf[i][0] == false:
			get_node("Players").get_child(i).queue_free()
		else:
			get_node("Players").get_child(i).player_control = conf[i][1]
	
	# Reset score
	_global._players_scores = [0, 0, 0, 0]
	
	# Hud
	get_node("hud").reset()
	pass

func start_match():
	get_tree().call_group(0, "players", "wake")
	set_fixed_process(true)
	get_node("Player_OST").play("game_ost")

func _ready():
#	set_fixed_process(true)
#	_global._player_config = [[true,0],[true,1],[false,0],[false,0]]
	start()
	get_tree().call_group(0, "players", "sleep")
	get_node("hud").connect("start", self, "start_match")
	pass

func _fixed_process(delta):
	# Coin spawning
	elapsed_time += delta
	var rect = get_node("Water").get_region_rect()
	get_node("Water").set_region_rect(Rect2(rect.pos + Vector2(_texture_vel, _texture_vel), rect.size))
	
	if elapsed_time >= 3:
		var new_coin = Coin.instance()
		add_child(new_coin)
		var new_x = rand_range(get_node("Floor").get_translation().x - get_node("Floor").get_scale().x, get_node("Floor").get_translation().x + get_node("Floor").get_scale().x)
		var new_z = rand_range(get_node("Floor").get_translation().z - get_node("Floor").get_scale().z, get_node("Floor").get_translation().z + get_node("Floor").get_scale().z)
		var new_y = 50
		
		new_coin.set_translation(Vector3(new_x, new_y, new_z))
		new_coin.falling = true
		
		elapsed_time = 0
	
	# Update match timer
	if _global._match_timer >= 0:
		_global._match_timer -= delta
	elif _finished == false:
		_finished = true
		get_node("hud").play_timeout()
		get_node("Player_OST").play("whistle")
		get_tree().call_group(0, "players", "sleep")
	pass