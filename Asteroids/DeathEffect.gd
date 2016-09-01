
extends CanvasModulate

func _ready():
	pass

func _process(delta):
	set_color(Color(1.0, get_color().g + 0.1, get_color().b + 0.1))
	if get_color().b >= 1.0:
		set_hidden(true)
		set_process(false)

func runEffect():
	set_color(Color(1.0, 0, 0))
	set_hidden(false)
	set_process(true)