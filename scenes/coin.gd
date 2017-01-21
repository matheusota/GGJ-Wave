extends Area

onready var _timer = 0.0
onready var _timer_limit = 0.1

func respawn():
	show()

func _ready():
	set_fixed_process(true)
	add_to_group("coins")
	connect("body_enter", self, "_body_enter")
	pass

func _body_enter(body):
	if is_hidden():
		return
	if body.is_in_group("players"):
		get_node("/root/global").add_score(body.player_number, 1)
		hide()

func _fixed_process(delta):
	_timer += delta
	if _timer > _timer_limit:
		_timer -= _timer_limit
		get_node("Sprite3D").set_frame((get_node("Sprite3D").get_frame()+1)%get_node("Sprite3D").get_vframes())