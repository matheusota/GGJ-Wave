extends Spatial

var _texture_vel = 0.3

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var rect = get_node("Water").get_region_rect()
	get_node("Water").set_region_rect(Rect2(rect.pos + Vector2(_texture_vel, _texture_vel), rect.size))
	pass