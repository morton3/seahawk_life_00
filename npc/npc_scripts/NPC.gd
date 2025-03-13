extends CharacterBody2D

@export var speed: int = 50
@export var wait_time: float = 2.0  # Time the NPC stops before switching direction

@onready var anim = $AnimatedSprite2D
var directions = [Vector2.UP, Vector2.DOWN]  # NPC only moves up and down
var current_direction_index = 0  # 0 = up, 1 = down
var move_timer = 0
var is_waiting = false  # Whether NPC is in a stopping phase

func _process(delta):
	move_timer -= delta

	if move_timer <= 0:
		if is_waiting:
			# Switch to the next direction after waiting
			current_direction_index = 1 - current_direction_index  # Toggle between 0 (up) and 1 (down)
			is_waiting = false
			move_timer = randf_range(2, 3)  # Time moving before stopping
		else:
			# Stop moving and wait
			is_waiting = true
			velocity = Vector2.ZERO  # Stop movement
			play_idle_animation()
			move_timer = wait_time  # Time spent waiting

	if not is_waiting:
		velocity = directions[current_direction_index] * speed
		move_and_slide()
		play_walk_animation(directions[current_direction_index])

func play_walk_animation(direction: Vector2):
	if direction == Vector2.UP:
		anim.play("walk_up")
	elif direction == Vector2.DOWN:
		anim.play("walk_down")

func play_idle_animation():
	if current_direction_index == 0:
		anim.play("idle_up")
	else:
		anim.play("idle_down")
