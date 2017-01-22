extends Control

onready var _global = get_node("/root/global")
onready var _time = 60

func reset():
	for i in range(_global._player_config.size()):
		if _global._player_config[i][0] == false:
			get_node("players").get_child(i).hide()

func go():
	emit_signal("start")

func play_timeout():
	get_node("AnimationPlayer").play("timeout")

func room_close():
	get_node("timeout").hide()
	get_node("AnimationPlayer").play("room_close")

func finished_animation():
	_global.change_scene(get_parent(), "res://scenes/end_screen.tscn")

func _ready():
	set_fixed_process(true)
	_global.connect("score_update", self, "_score_updated")
	_global.connect("player_died", self, "_player_died")
	get_node("AnimationPlayer").play("counter")
	add_user_signal("start")
	pass

func _score_updated(player):
	get_node("players").get_child(player).get_node("ScoreLabel").set_text("x " + str(_global._players_scores[player]))
	get_node("players").get_child(player).coin_up()

func _player_died(player):
	get_node("players").get_child(player).get_node("ScoreLabel").set_text("x " + str(_global._players_scores[player]))
	get_node("players").get_child(player).lost_coins()

func _fixed_process(delta):
	var c_time = ceil(float(_global._match_timer))
	if c_time != _time:
		_time = c_time
		get_node("timer/Label").set_text(str(_time))
	pass