
extends Node2D

signal asteroidDestroyed

const ASTEROID = preload("res://Asteroid.tscn")

export(int) var spawnIntervalSec
export(int) var maxAsteroids

var spawnCooldown = 0

func _ready():
	set_process(true)

func _process(delta):
	tryAutoSpawn(delta)

func tryAutoSpawn(delta):
	spawnCooldown -= delta
	if spawnCooldown < 0 and get_child_count() < maxAsteroids:
		spawnCooldown = spawnIntervalSec
		var playerPos = get_parent().get_node("Player").get_pos()
		var half = get_viewport_rect().size.x / 2
		var asteroidPos = Vector2(rand_range(0, half), rand_range(0, get_viewport_rect().size.y))
		if playerPos.x < half:
			asteroidPos.x += half
		spawnAsteroid(asteroidPos, Vector2(2, 2))

func spawnAsteroid(pos, size):
	var a = ASTEROID.instance()
	a.set_pos(pos)
	a.set_scale(size)
	add_child(a, true)

func asteroidDestroyed():
	emit_signal("asteroidDestroyed")