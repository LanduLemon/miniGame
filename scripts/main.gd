extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
@export var enemy_count := 10
@export var polar_enemy_count := 5

func _ready():
	# 创建环境区域
	_setup_environment_zones()
	
	# 在玩家周围随机生成一些普通敌人
	for i in range(enemy_count):
		_spawn_enemy("default")
	
	# 在极地边缘生成一些极地生物
	for i in range(polar_enemy_count):
		_spawn_enemy("polar")

func _setup_environment_zones():
	# 创建一个 Area2D 作为极地环境
	var polar_zone = Area2D.new()
	polar_zone.name = "PolarZone"
	polar_zone.set_script(load("res://scripts/environment_zone.gd"))
	polar_zone.env_name = "polar"
	polar_zone.zone_color = Color(0.0, 0.5, 1.0, 0.2)
	add_child(polar_zone)
	
	# 添加碰撞体，定义区域（右半屏幕）
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(600, 648)
	collision.shape = shape
	collision.position = Vector2(850, 324)
	polar_zone.add_child(collision)
	
	# 添加可视化矩形
	var rect = ColorRect.new()
	rect.name = "ColorRect"
	rect.size = Vector2(600, 648)
	rect.position = Vector2(550, 0)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	polar_zone.add_child(rect)

func _spawn_enemy(type: String):
	var enemy = enemy_scene.instantiate()
	enemy.env_type = type
	
	if type == "default":
		# 随机位置（左半屏幕）
		enemy.position = Vector2(randf_range(50, 500), randf_range(50, 600))
	elif type == "polar":
		# 随机位置（极地边缘）
		enemy.position = Vector2(randf_range(500, 600), randf_range(50, 600))
		
	add_child(enemy)
