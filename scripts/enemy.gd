extends CharacterBody2D

@export var move_speed := 50
@export var env_type: String = "default" # 敌人所属环境

var move_dir := Vector2.ZERO
var move_timer := 0.0

func _ready():
	_pick_new_direction()
	# 如果是环境生物，改变颜色作为区分
	if env_type == "polar":
		modulate = Color(0.6, 0.8, 1.0) # 浅蓝色
	elif env_type == "volcano":
		modulate = Color(1.0, 0.4, 0.4) # 浅红色

func get_env_type() -> String:
	return env_type

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
