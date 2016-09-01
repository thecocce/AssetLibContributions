
extends Control

export(NodePath) var playerPath

onready var player = get_node(playerPath)

func _ready():
	set_process(true)

func _process(delta):
	get_node("Lives").set_text("Lives: " + str(player.lives))
	get_node("Score").set_text("Score: " + str(player.score))