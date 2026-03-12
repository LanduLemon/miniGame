extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
@export var enemy_count := 10

func _ready():
	# 在玩家周围随机生成一些敌人
	for i in range(enemy_count):
		_spawn_enemy()

func _spawn_enemy():
	var enemy = enemy_scene.instantiate()
	# 随机位置，假设屏幕大小为 1152x648
	enemy.position = Vector2(randf_range(0, 1152), randf_range(0, 648))
	add_child(enemy)
