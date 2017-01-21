extends Spatial

onready var _texture_vel = 0.3

onready var _global = get_node("/root/global")

func start():
	# Configure players
	var conf = _global._player_config
	for i in range(conf):
		if conf[i][0] == false:
			get_node("Players").get_child(i).queue_free()
		else:
			get_node("Players").get_child(i).player_control = conf[i][1]
	
	
	pass

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	# Update match timer
	_global._match_timer -= delta
	
	var rect = get_node("Water").get_region_rect()
	get_node("Water").set_region_rect(Rect2(rect.pos + Vector2(_texture_vel, _texture_vel), rect.size))
	
	pass