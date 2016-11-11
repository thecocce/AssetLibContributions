
#############################################################
# Snake, A Single Script Godot Sample
# Version 1.0 - August 13th, 2016
# Author: Timothy Hornick (@Xydium)
#############################################################

#Inheritance
extends Node2D

#Constants
const BOARD_SIZE = 50
const STARTING_SEGMENTS = 5

const TICK_DURATION  = 0.05

const RECT_DIM = Vector2(10, 10)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const SNAKE_COLOR = Color(1.0, 0.0, 0.0)
const FOOD_COLOR = Color(1.0, 0.5, 0.0)

#Member Variables
var snake
var food
var elapsed = 0

func _process(delta):
	#If enough time has passed to tick the game
	elapsed += delta
	if elapsed > TICK_DURATION:
		elapsed = 0
		#Move the snake to its next position
		snake.move()
		#If the snake went out of bounds or crossed itself, respawn
		if snake.is_dead():
			spawn()
		#If the snake head is on top of food, grow and move the food
		elif snake.pos == food:
			snake.lengthen()
			food()
		#Refresh draw calls to represent new board state
		update()

func _draw():
	#Start with the head
	var segment = snake
	#Until the tail has been reached and drawn
	while segment != null:
		#Draw the segment and get the one behind it
		draw_rect(Rect2(segment.pos * RECT_DIM, RECT_DIM), SNAKE_COLOR)
		segment = segment.back
	#Then draw the food
	draw_rect(Rect2(food * RECT_DIM, RECT_DIM), FOOD_COLOR)

func _ready():
	spawn()
	food()
	set_process(true)

func spawn():
	#Instance a snake in the middle of the board traveling up
	snake = Snake.new(Vector2(BOARD_SIZE / 2, BOARD_SIZE / 2), Vector2(0, -1))
	#Add segments until the sname is STARTING_SEGMENTS long
	for i in range(1, STARTING_SEGMENTS):
		snake.lengthen()

func food():
	#Position the food at a random location on the board
	food = Vector2(randi() % BOARD_SIZE, randi() % BOARD_SIZE)

#Data structure to represent each individual segment
#as well as the entire snake.
#
#Essentially a doubly-linked list.
class Snake:
	var pos
	var dir
	var front
	var back

	func _init(pos, dir):
		self.pos = pos
		self.dir = dir
		self.front = self

	func is_head():
		return front == self

	func is_tail():
		return back == null

	#Determines if the snake is dead, meaning it has
	#either gone out of bounds, or has crossed over itself
	func is_dead():
		var snake = get_head()
		if snake.pos.x >= BOARD_SIZE or snake.pos.x < 0 or snake.pos.y >= BOARD_SIZE or snake.pos.y < 0:
			return true
		var segment = snake.back
		while segment != null:
			if snake.pos == segment.pos:
				return true
			segment = segment.back
		return false

	#Finds the head (first segment) of the snake this segment belongs to
	func get_head():
		var snake = self
		while not snake.is_head():
			snake = snake.front
		return snake

	#Finds the tail (last segment) of the snake this segment belongs to
	func get_tail():
		var snake = self
		while !snake.is_tail():
			snake = snake.back
		return snake

	#Appends the given segment to the end of the linked list
	func lengthen():
		var front = get_tail()
		var next = get_script().new(front.pos - front.dir, front.dir)
		next.front = front
		next.front.back = next

	#Handles all movement for the snake, including input reading
	func move():
		#Read keystates to determine which direction to move this tick
		#while ensuring that the snake does not turn 180, such that
		#the snake cannot go from moving DOWN to moving UP without first
		#moving either LEFT or RIGHT
		var up = Input.is_action_pressed("ui_up") and dir != DOWN
		var down = Input.is_action_pressed("ui_down") and dir != UP
		var left = Input.is_action_pressed("ui_left") and dir != RIGHT
		var right = Input.is_action_pressed("ui_right") and dir != LEFT

		#Start with the head, because this controls which direction
		#the snake will turn if desired by the player
		var segment = get_head()

		#Apply the movement choice to the head
		if up:
			segment.dir = UP
		elif down:
			segment.dir = DOWN
		elif left:
			segment.dir = LEFT
		elif right:
			segment.dir = RIGHT

		#We want to start doing movements from the tail
		#so that the new direction of the head moves down
		#the list one segment per tick
		segment = get_tail()

		#Until we reach the head
		while !segment.is_head():
			#Move the current segment by its current direction
			segment.pos += segment.dir
			#Then copy the direction of the segment in front of it
			segment.dir = segment.front.dir
			#Then move the pointer up the list
			segment = segment.front
		#Finally, move the head
		segment.pos += segment.dir