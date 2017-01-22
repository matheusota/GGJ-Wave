extends Area

export(bool) var respawnable = false
var falling = false

onready var _die_timer = 0.0
onready var _die_timer_limit = 1.0

onready var _timer = 0.0
onready var _timer_limit = 0.1

onready var CoinParticles = preload("res://scenes/coin_particles.tscn")

func respawn():
	show()

func _ready():
	set_fixed_process(true)
	add_to_group("coins")
	connect("body_enter", self, "_body_enter")
	pass

func _body_enter(body):
	if is_hidden() or get_node("/root/global")._match_timer < 0:
		return
	if body.is_in_group("players"):
		get_node("/root/global").add_score(body.player_number, 1)
		get_node("SamplePlayer").play("coin")
		hide()
		var particles = CoinParticles.instance()
		get_parent().add_child(particles)
		particles.set_translation(get_translation())
		
	else:
		falling = false

func _fixed_process(delta):
	if is_hidden():
		_die_timer += delta
		if _die_timer > _die_timer_limit:
			queue_free()
	else:
		if falling:
			set_translation(Vector3(get_translation().x, get_translation().y - 0.1, get_translation().z))
			
		_timer += delta
		if _timer > _timer_limit:
			_timer -= _timer_limit
			get_node("Sprite3D").set_frame((get_node("Sprite3D").get_frame()+1)%get_node("Sprite3D").get_vframes())