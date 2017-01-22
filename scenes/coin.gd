extends Area

export(bool) var respawnable = false

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
	if is_hidden():
		return
	if body.is_in_group("players"):
		if respawnable:
			get_node("/root/global").add_score(body.player_number, 1)
			hide()
		else:
			get_node("/root/global").add_score(body.player_number, 2)
			queue_free()

func _fixed_process(delta):
	if is_hidden() and respawnable:
		_respawn_timer += delta
		if _respawn_timer > _respawn_timer_limit:
			_respawn_timer = 0.0
			show()
	
	_timer += delta
	if _timer > _timer_limit:
		_timer -= _timer_limit
		get_node("Sprite3D").set_frame((get_node("Sprite3D").get_frame()+1)%get_node("Sprite3D").get_vframes())