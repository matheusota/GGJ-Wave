extends Node

onready var _players_scores = [0, 0, 0, 0]
onready var _match_timer = 60

onready var _player_config = [] # [{"playing": true/false, "control": 0-3}]

func player_died(player):
	_players_scores[player] = int(_players_scores[player]/2.0)
	emit_signal("player_died", player)
	pass  

func set_player_config(conf):
	_player_config = conf

func add_score(player, score):
	_players_scores[player] += score
	emit_signal("score_update", player)

func _ready():
	add_user_signal("score_update")
	add_user_signal("player_died")
	pass

func change_scene(scn, scn_to):
	var parent = scn.get_parent()
	var Scn_to = load(scn_to)
	var new_scene = Scn_to.instance()
	parent.add_child(new_scene)
	scn.queue_free()