extends CharacterBody2D

@export var speed: int = 200
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Check for movement input
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize direction to prevent diagonal speed boost
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed  # ✅ Ensure velocity is updated!
		anim.play(get_animation_name(direction))
	else:
		velocity = Vector2.ZERO  # ✅ Ensure stopping works properly
		anim.stop()
		
	move_and_slide()

# ✅ Check for actual collisions
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.get_collider().name)  # ✅ This works!

func get_animation_name(direction: Vector2) -> String:
	if direction.x > 0 and direction.y == 0:
		return "walk_right"
	elif direction.x < 0 and direction.y == 0:
		return "walk_left"
	elif direction.y > 0 and direction.x == 0:
		return "walk_down"
	elif direction.y < 0 and direction.x == 0:
		return "walk_up"
	elif direction.x > 0 and direction.y > 0:
		return "walk_down_right"
	elif direction.x < 0 and direction.y > 0:
		return "walk_down_left"
	elif direction.x > 0 and direction.y < 0:
		return "walk_up_right"
	elif direction.x < 0 and direction.y < 0:
		return "walk_up_left"
	return "walk_down"
