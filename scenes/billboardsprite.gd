extends Position3D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Billboard").get_material_override().set_texture(FixedMaterial.PARAM_DIFFUSE, get_node("Viewport").get_render_target_texture())
	pass
