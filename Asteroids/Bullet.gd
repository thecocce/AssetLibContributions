
extends Node2D

const SPEED = 500

var velocity

func _ready():
	velocity = Vector2(SPEED, 0).rotated(get_rot())
	update()
	set_process(true)

func _process(delta):
	set_pos(get_pos() + velocity * delta)
	if get_pos() < Vector2(0, 0) or get_pos() > get_viewport_rect().size:
		queue_free()

func _draw():
	draw_rect(Rect2(Vector2(-2, -1), Vector2(4, 2)), Color(255, 0, 0))