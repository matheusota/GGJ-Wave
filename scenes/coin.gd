extends Area

export(bool) var respawnable = false
var falling = false

onready var _respawn_timer = 0.0
onready var _respawn_timer_limit = 10.0

onready var _timer = 0.0
onready var _timer_limit = 0.1

func respawn():
	show()

func _ready():
	set_fixed_process(true)
	add_to_group("coins")
	connect("body_enter", self, "_body_enter")
	
	if respawnable:
		get_node("Sprite3D").set_modulate(Color(1.0,0.0,0.1))
	pass

func _body_enter(body):
	if is_hidden() or get_node("/root/global")._match_timer < 0:
		return
	if body.is_in_group("players"):
		if respawnable:
			get_node("/root/global").add_score(body.player_number, 1)
			hide()
		else:
			get_node("/root/global").add_score(body.player_number, 2)
			queue_free()
	else:
		falling = false

func _fixed_process(delta):
	#coin waiting to respawn
	if is_hidden() and respawnable:
		_respawn_timer += delta
		if _respawn_timer > _respawn_timer_limit:
			_respawn_timer = 0.0
			show()
	
	#coin is falling
	if falling:
		set_translation(Vector3(get_translation().x, get_translation().y - 0.1, get_translation().z))
		
	_timer += delta
	if _timer > _timer_limit:
		_timer -= _timer_limit
		get_node("Sprite3D").set_frame((get_node("Sprite3D").get_frame()+1)%get_node("Sprite3D").get_vframes())