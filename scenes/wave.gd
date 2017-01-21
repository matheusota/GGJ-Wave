extends Position3D

export(float) var velocity = 0.1
export(float) var amplitude = 1.0

func set_amplitude(amp):
	amplitude = amp
	set_scale(Vector3(1.0, amplitude, 1.0))

func _ready():
	set_fixed_process(true)
	set_amplitude(1.0)
	pass

func _fixed_process(delta):
	set_scale(get_scale()+Vector3(velocity, 0.0, velocity))
