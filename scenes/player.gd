extends RigidBody

export(int) var player_number = 0
export(int) var player_control = 0

export(int) var jump_speed = 10
onready var _super_jump = false
onready var _super_jump_speed = 1000
onready var SuperJumpParticles = preload("res://scenes/super_jump_particles.tscn")
onready var FallParticles = preload("res://scenes/fall_particles.tscn")

onready var _initial_pos = get_translation()

export var view_sensitivity = 0.3
export var yaw = 0
export var pitch = 0
const walk_speed = 8
const max_accel = 1
const air_accel = 0.5

onready var _outside_water = false
onready var _water_height = get_parent().get_parent().get_node("Water").get_translation().y
onready var _jump_height = 0.1
onready var _jump_max_height = 0.0
onready var _reach_jump_max = false
onready var Wave = preload("res://scenes/wave.tscn")

onready var _sprite_timer = 0.0
onready var _sprite_timer_limit = 0.05
onready var _sprite_state = 0 # 0 - up, 1 - right, 2 - down, 3 - left
onready var _sprite_stop = false

onready var _sleep = false

func sleep():
	_sleep = true

func wake():
	_sleep = false

func respawn():
	set_translation(_initial_pos)
	_jump_max_height = 0.0
	if _sleep == false:
		get_node("/root/global").player_died(player_number)
		get_node("SamplePlayer").play("lost_coins")

func _integrate_forces(state):
	#var aim = get_node("yaw").get_global_transform().basis
	var aim = get_viewport().get_camera().get_global_transform().basis
	var aim_yaw = get_node("yaw").get_global_transform().basis
	aim[2].y = 0
	aim[2] = aim[2].normalized()
	aim[0].y = 0
	aim[0] = aim[0].normalized()
	var direction = Vector3()
	
	_sprite_stop = true
	if _sleep == false:
		#if Input.is_key_pressed(InputMap.get_action_list("move_forwards")[player_control].scancode):
		if Input.is_action_pressed("move_forwards" + str(player_control)):
			direction -= aim[2]
			_sprite_stop = false
		#if Input.is_key_pressed(InputMap.get_action_list("move_backwards")[player_control].scancode):
		if Input.is_action_pressed("move_backwards" + str(player_control)):
			direction += aim[2]
			_sprite_state = 2
			_sprite_stop = false
		#if Input.is_key_pressed(InputMap.get_action_list("move_left")[player_control].scancode):
		if Input.is_action_pressed("move_left" + str(player_control)):
			direction -= aim[0]
			_sprite_state = 3
			_sprite_stop = false
			get_node("Sprite3D").set_flip_h(false)
		#if Input.is_key_pressed(InputMap.get_action_list("move_right")[player_control].scancode):
		if Input.is_action_pressed("move_right" + str(player_control)):
			direction += aim[0]
			_sprite_state = 1
			_sprite_stop = false
			get_node("Sprite3D").set_flip_h(true)
	direction = direction.normalized()
	var ray = get_node("ray")
	if ray.is_colliding():
		if get_node("Sprite3D").get_frame() == 4:
			get_node("Sprite3D").set_frame(0)
		_jump_max_height = get_translation().y
		var up = state.get_total_gravity().normalized()
		var normal = ray.get_collision_normal()
		var floor_velocity = Vector3()
		var object = ray.get_collider()
		var wr = weakref(object)
		if object and object extends RigidBody or object extends StaticBody:
			var point = ray.get_collision_point() - object.get_translation()
			var floor_angular_vel = Vector3()
			if object extends RigidBody:
				floor_velocity = object.get_linear_velocity()
				floor_angular_vel = object.get_angular_velocity()
			elif object extends StaticBody:
				floor_velocity = object.get_constant_linear_velocity()
				floor_angular_vel = object.get_constant_angular_velocity()
			# Surely there should be a function to convert euler angles to a 3x3 matrix
			var transform = Matrix3(Vector3(1, 0, 0), floor_angular_vel.x)
			transform = transform.rotated(Vector3(0, 1, 0), floor_angular_vel.y)
			transform = transform.rotated(Vector3(0, 0, 1), floor_angular_vel.z)
			floor_velocity += transform.xform_inv(point) - point
			yaw = fmod(yaw + rad2deg(floor_angular_vel.y) * state.get_step(), 360)
			get_node("yaw").set_rotation(Vector3(0, deg2rad(yaw), 0))
		var speed = walk_speed
		var diff = floor_velocity + direction * walk_speed - state.get_linear_velocity()
		var vertdiff = aim_yaw[1] * diff.dot(aim_yaw[1])
		diff -= vertdiff
		diff = diff.normalized() * clamp(diff.length(), 0, max_accel / state.get_step())
		diff += vertdiff
		#apply_impulse(Vector3(), (direction * walk_speed - state.get_linear_velocity()) * get_mass())
		# ===== BOOOGIE WONDERLAND ======
		apply_impulse(Vector3(), diff * get_mass())
		#if Input.is_key_pressed(InputMap.get_action_list("jump")[player_control].scancode):
		if Input.is_action_pressed("jump" + str(player_control)) and _sleep == false:
			_reach_jump_max = false
			get_node("SamplePlayer").play("jump")
			
			if(_super_jump):
				var particles = SuperJumpParticles.instance()
				get_parent().add_child(particles)
				particles.set_translation(get_translation())
				apply_impulse(Vector3(), normal * _super_jump_speed * get_mass())
#				apply_impulse(Vector3(), -Vector3(diff.x, 0, diff.z) * get_mass())
				_super_jump = false
			else:
				apply_impulse(Vector3(), normal * jump_speed * get_mass())
#				apply_impulse(Vector3(), -Vector3(diff.x, 0, diff.z) * get_mass())
			get_node("Sprite3D").set_frame(4)
	else:
		if _reach_jump_max == false and get_linear_velocity().y < 0:
			_reach_jump_max = true
			_jump_max_height = get_translation().y
		
		# CORRIGI O BUG DO PULO SABENDO
		var diff = direction * walk_speed - state.get_linear_velocity()
		var vertdiff = aim_yaw[1] * diff.dot(aim_yaw[1])
		diff -= vertdiff
		diff = Vector3(diff.x, 0, diff.z)
		diff = diff.normalized() * clamp(diff.length(), 0, max_accel / state.get_step())
		apply_impulse(Vector3(), diff * get_mass())
		
	state.integrate_forces()

func _ready():
	add_to_group("players")
	set_fixed_process(true)
	if player_number == 1:
		get_node("Sprite3D").set_texture(preload("res://assets/sprite_player2.tex"))
	if player_number == 2:
		get_node("Sprite3D").set_texture(preload("res://assets/sprite_player3.tex"))
	if player_number == 3:
		get_node("Sprite3D").set_texture(preload("res://assets/sprite_player4.tex"))
	
func _fixed_process(delta):
	# Check if died
	var ref = get_parent().get_parent().get_node("Floor")
	if ref:
		if not (get_translation().y - ref.get_translation().y > 0) and get_translation().distance_to(ref.get_translation()) > 25:
			respawn()
			
	# Jump MECHANICS
	if get_translation().y > _jump_height:
		_outside_water = true
	if get_translation().y < _jump_height and _outside_water:
		_outside_water = false
		var new_wave = Wave.instance()
		get_parent().add_child(new_wave)
		new_wave.set_amplitude(_jump_max_height * 4.0)
		new_wave.set_translation(Vector3(get_translation().x, _water_height, get_translation().z))
#		var fall_particles = FallParticles.instance()
#		get_parent().add_child(fall_particles)
#		fall_particles.set_translation(get_translation())
		get_node("SamplePlayer").play("splash")
	
	# Sprite
	if(_sprite_stop == false) and get_node("Sprite3D").get_frame() != 4:
		_sprite_timer += delta
		if _sprite_timer > _sprite_timer_limit:
			_sprite_timer -= _sprite_timer_limit
			get_node("Sprite3D").set_frame((get_node("Sprite3D").get_frame()+1)%4)