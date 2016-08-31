tool

extends Node2D

const MIN_SPEED = 10
const MAX_SPEED = 100

const ASTEROID = preload("res://Asteroid.tscn")

var POINTS = [Vector2(0, -40), Vector2(25, -25), Vector2(40, 0), Vector2(25, 25), Vector2(0, 40), Vector2(-25, 25), Vector2(-40, 0), Vector2(-25, -25)]

var velocity = Vector2(0, 0)
var spin = 0

func _ready():
	velocity = Vector2(rand_range(MIN_SPEED, MAX_SPEED), 0).rotated(rand_range(0, 360))
	spin = deg2rad(rand_range(MIN_SPEED, MAX_SPEED))
	update()
	set_process(true)

func _process(delta):
	set_pos(get_pos() + velocity * delta)
	constrain()
	set_rot(get_rot() + spin * delta)

func constrain():
	var pos = get_pos()
	
	if pos.x < 0:
		pos.x = get_viewport_rect().size.x
	elif pos.x > get_viewport_rect().size.x:
		pos.x = 0
	if pos.y < 0:
		pos.y = get_viewport_rect().size.y
	elif pos.y > get_viewport_rect().size.y:
		pos.y = 0
	
	set_pos(pos)

func split():
	if get_scale().x > 0.5:
		var a = ASTEROID.instance()
		var b = ASTEROID.instance()
		a.set_pos(get_pos() + Vector2(30, 30))
		b.set_pos(get_pos() - Vector2(30, 30))
		a.set_scale(Vector2(get_scale().x / 2, get_scale().y / 2))
		b.set_scale(Vector2(get_scale().x / 2, get_scale().y / 2))
		get_parent().add_child(a, true)
		get_parent().add_child(b, true)
	queue_free()

func _draw():
	for i in range(0, POINTS.size()):
		POINTS[i] += Vector2(rand_range(-5, 5), rand_range(-5, 5))
	for i in range(0, POINTS.size()):
		draw_line(POINTS[i], POINTS[(i + 1) % POINTS.size()], Color(0.5, 0.3, 0.05))

func _hit( area ):
	print(area.get_parent().get_name())
	if area.get_parent().get_name().begins_with("Bullet"):
		split()
