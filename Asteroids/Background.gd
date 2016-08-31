tool

extends Node2D

export(int) var starCount = 300
export(int) var starVariation = 100

const STAR_COLOR = Color(0.6, 0.6, 1.0)
var stars = []

func _ready():
	generate()
	set_process(true)

func generate():
	var xMax = get_viewport_rect().size.x
	var yMax = get_viewport_rect().size.y
	for i in range(starCount + rand_range(-starVariation, starVariation)):
		stars.append(Rect2(Vector2(rand_range(0, xMax), rand_range(0, yMax)), Vector2(1,1)))

func _process(delta):
	update()

func _draw():
	for i in stars:
		var rand = rand_range(0.6, 1.0)
		draw_rect(i, Color(STAR_COLOR.r * rand, STAR_COLOR.g * rand, STAR_COLOR.b * rand))