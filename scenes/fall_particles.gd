extends Particles

onready var _timer = 0.0
onready var _timer_limit = 0.04

func _ready():
	set_fixed_process(true)
	set_emitting(true)
	pass

func _fixed_process(delta):
	_timer += delta
	if (_timer > _timer_limit):
		set_emitting(false)
	if (_timer > 1.0):
		queue_free()