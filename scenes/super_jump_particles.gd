extends Particles

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	set_translation(get_translation()+Vector3(0.0,0.6,0.0))
	if get_translation().y > 20:
		queue_free()