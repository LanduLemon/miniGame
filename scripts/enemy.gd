extends CharacterBody2D

@export var move_speed := 50
var move_dir := Vector2.ZERO
var move_timer := 0.0

func _ready():
	_pick_new_direction()

func _physics_process(delta):
	move_timer -= delta
	if move_timer <= 0:
		_pick_new_direction()
	
	velocity = move_dir * move_speed
	move_and_slide()

func _pick_new_direction():
	# 随机选择一个方向
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_timer = randf_range(1, 3) # 每1-3秒换个方向

func be_eaten():
	queue_free()
