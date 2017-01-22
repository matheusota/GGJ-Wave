extends Control

func coin_up():
	get_node("AnimationPlayer").play("coin_up")

func lost_coins():
	get_node("AnimationPlayer").play("lost_coins")

func _ready():
	
	pass
