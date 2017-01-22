extends Position3D

export(float) var velocity = 0.1
export(float) var gravity = 0.03
export(float) var amplitude = 1.0

onready var _wait_for_deletion = 0

func set_amplitude(amp):
	amplitude = amp
	set_scale(Vector3(1.0, amplitude, 1.0))

func _ready():
	set_fixed_process(true)
	set_amplitude(1.0)
	add_to_group("waves")
	pass

func _fixed_process(delta):
	if _wait_for_deletion == 0:
		set_scale(get_scale()+Vector3(velocity,0.0,velocity))
		set_translation(get_translation()+Vector3(0.0,-gravity,0.0))
		if(get_translation().y  < -0.16 * get_scale().y):
#		if(get_scale().x > 20):
			hide()
			get_node("WaveMesh/StaticBody").set_layer_mask_bit(0, false)
			get_node("WaveMesh/StaticBody").set_collision_mask_bit(0, false)
			_wait_for_deletion = 1
	else:
		_wait_for_deletion+=1
		if _wait_for_deletion >= 5:
			queue_free()