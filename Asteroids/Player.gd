
extends Node2D

#Mechanics Attributes
const ACCELERATION = 200
const ROTATION = deg2rad(240)
const MAX_LIVES = 3
const MAX_SPEED = 500
const GUN_COOLDOWN = 0.1

#Scene Attributes
const BULLET = preload("res://Bullet.tscn")
export(NodePath) var bulletList

#Drawing Attributes
const TIP = Vector2(20, 0)
const RIGHT = Vector2(-20, 8)
const LEFT = Vector2(-20, -8)
const MIDDLE = Vector2(-8, 0)
const FLAME_RIGHT = Vector2(-14, 4)
const FLAME_LEFT = Vector2(-14, -4)
const FLAME_TIP = Vector2(-20, 0)
const SHIP_COLOR = Color(1.0, 1.0, 1.0)
const FLAME_COLOR = Color(1.0, 0.5, 0)

#Instance Attributes
var velocity = Vector2(0, 0)
var score = 0
var lives = MAX_LIVES
var accelerating = false
var cooldown = 0

func _ready():
	set_pos(get_viewport_rect().size / 2)
	set_process(true)

func _process(delta):
	rotate(delta)
	accelerate(delta, false)
	move(delta)
	constrain()
	shoot(delta)
	update()

func rotate(delta):
	if Input.is_action_pressed("RotateRight"):
		set_rot(get_rot() - ROTATION * delta)
	elif Input.is_action_pressed("RotateLeft"):
		set_rot(get_rot() + ROTATION * delta)

func accelerate(delta, ignoreInput):
	accelerating = Input.is_action_pressed("Accelerate") or ignoreInput
	
	if not accelerating:
		return
	
	var direction = Vector2(1, 0).rotated(get_rot()) * ACCELERATION
	if (velocity + (direction * delta)).length() < MAX_SPEED:
		velocity += direction * delta

func move(delta):
	set_pos(get_pos() + velocity * delta)

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

func shoot(delta):
	cooldown -= delta
	if cooldown < 0 and Input.is_action_pressed("Shoot"):
		var b = BULLET.instance()
		b.set_pos(get_pos() + TIP.rotated(get_rot()))
		b.set_rot(get_rot())
		get_node(bulletList).add_child(b, true)
		cooldown = GUN_COOLDOWN

func _hit(area):
	if area.get_parent().get_name().begins_with("Asteroid"):
		lives -= 1
		set_pos(get_viewport_rect().size / 2)
		get_parent().get_node("DeathEffect").runEffect()
		velocity = Vector2(0, 0)
		if lives == 0:
			get_tree().reload_current_scene()

func _draw():
	draw_line(TIP, RIGHT, SHIP_COLOR)
	draw_line(RIGHT, MIDDLE, SHIP_COLOR)
	draw_line(MIDDLE, LEFT, SHIP_COLOR)
	draw_line(LEFT, TIP, SHIP_COLOR)
	
	if accelerating:
		var flameTip = FLAME_TIP + Vector2(rand_range(-2, 2), 0)
		draw_line(FLAME_LEFT, flameTip, FLAME_COLOR)
		draw_line(flameTip, FLAME_RIGHT, FLAME_COLOR)

func addScore(score):
	self.score += score
