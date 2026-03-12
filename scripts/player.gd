extends CharacterBody2D

@export var speed := 200
var _base_speed := 200.0

# 经验与等级系统
var level := 1
var experience := 0
var exp_to_next_level := 5

# 环境适应性系统
var current_env: String = "default"
var resistances: Dictionary = {
	"polar": 0.0, # 极地环境抗性 (0.0 - 1.0)
	"volcano": 0.0 # 熔岩环境抗性
}

var ui_label: Label

func _ready():
	# 设置基础速度备份，用于惩罚计算
	_base_speed = speed
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
		var res_text = ""
		for res in resistances:
			res_text += "\n%s抗性: %.1f%%" % [res, resistances[res] * 100]
		
		ui_label.text = "等级: %d\n经验: %d / %d\n当前环境: %s%s" % [
			level, experience, exp_to_next_level, current_env, res_text
		]

func _physics_process(_delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	# 计算环境对速度的影响
	var current_speed = _base_speed
	if current_env != "default" and resistances.has(current_env):
		var resistance = resistances[current_env]
		# 如果抗性不足 1.0，则速度按比例降低，最低降为 30%
		var speed_multiplier = lerp(0.3, 1.0, resistance)
		current_speed *= speed_multiplier
	
	velocity = input_dir.normalized() * current_speed
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

func enter_environment(env_name: String):
	current_env = env_name
	print("进入环境: ", env_name)
	_update_ui_text()

func exit_environment(env_name: String):
	if current_env == env_name:
		current_env = "default"
	print("退出环境: ", env_name)
	_update_ui_text()

func gain_resistance(env_name: String, amount: float):
	if resistances.has(env_name):
		resistances[env_name] = clamp(resistances[env_name] + amount, 0.0, 1.0)
		print("获得抗性: ", env_name, " 当前: ", resistances[env_name])
		_update_ui_text()

func _eat_enemy(enemy):
	enemy.be_eaten()
	experience += 1
	
	# 如果是特殊环境生物，获得抗性
	if enemy.has_method("get_env_type"):
		var env_type = enemy.get_env_type()
		gain_resistance(env_type, 0.1) # 吞噬一个获得 10% 抗性
	
	_update_ui_text()
	print("吞噬成功！经验值: ", experience, "/", exp_to_next_level)
	
	if experience >= exp_to_next_level:
		_level_up()

func _level_up():
	level += 1
	experience = 0
	exp_to_next_level = int(exp_to_next_level * 1.5)
	
	# 进化效果：体型变大
	scale *= 1.1
	_base_speed += 10
	
	_update_ui_text()
	print("升级了！当前等级: ", level)
	print("体型变大，速度提升！")
