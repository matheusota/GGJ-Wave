extends Area

onready var _respawn_timer = 0.0
onready var _respawn_timer_limit = 10.0

func _ready():
	connect("body_enter", self, "_body_enter")
	set_fixed_process(true)
	pass

func _body_enter(body):
	if !is_hidden():
		if body.is_in_group("players"):
			body._super_jump = true
			hide()
			get_node("SamplePlayer").play("powerup")

func _fixed_process(delta):
	set_rotation_deg(get_rotation_deg() + Vector3(0.0,1.0,0.0))
	
	if is_hidden():
		_respawn_timer += delta
		if _respawn_timer > _respawn_timer_limit:
			_respawn_timer = 0.0
			show()