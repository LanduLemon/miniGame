extends CharacterBody2D

@export var speed := 200

# 经验与等级系统
var level := 1
var experience := 0
var exp_to_next_level := 5

var ui_label: Label

func _ready():
	# 设置相机跟随
	if not has_node("Camera2D"):
		var camera = Camera2D.new()
		add_child(camera)
		camera.make_current()
	
	# 创建基础 UI
	_setup_ui()

func _setup_ui():
	var canvas = CanvasLayer.new()
	add_child(canvas)
	
	ui_label = Label.new()
	canvas.add_child(ui_label)
	
	# 设置一些基础样式（可选）
	ui_label.position = Vector2(20, 20)
	_update_ui_text()

func _update_ui_text():
	if ui_label:
		ui_label.text = "等级: %d\n经验: %d / %d" % [level, experience, exp_to_next_level]

func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	velocity = input_dir.normalized() * speed
	move_and_slide()
	
	# 检查吞噬逻辑
	_check_collisions()

func _check_collisions():
	# 遍历 CharacterBody2D 的所有碰撞
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# 如果撞到了敌人，就吞掉它
		if collider.has_method("be_eaten"):
			_eat_enemy(collider)

func _eat_enemy(enemy):
	enemy.be_eaten()
	experience += 1
	_update_ui_text()
	print("吞噬成功！经验值: ", experience, "/", exp_to_next_level)
	
	if experience >= exp_to_next_level:
		_level_up()

func _level_up():
	level += 1
	experience = 0
	exp_to_next_level = int(exp_to_next_level * 1.5)
	_update_ui_text()
	
	# 进化效果：体型变大
	scale *= 1.1
	speed += 10
	
	print("升级了！当前等级: ", level)
	print("体型变大，速度提升！")
