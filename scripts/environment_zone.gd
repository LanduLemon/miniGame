extends Area2D

@export var env_name: String = "polar"
@export var zone_color: Color = Color(0.5, 0.8, 1.0, 0.3) # 默认浅蓝色代表极地

func _ready():
	# 自动连接信号
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# 如果有 ColorRect 子节点，设置其颜色
	if has_node("ColorRect"):
		get_node("ColorRect").color = zone_color

func _on_body_entered(body):
	if body.has_method("enter_environment"):
		body.enter_environment(env_name)

func _on_body_exited(body):
	if body.has_method("exit_environment"):
		body.exit_environment(env_name)
