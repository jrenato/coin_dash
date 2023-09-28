class_name Player extends Area2D

signal pickup(pickup_type: String)
signal hurt

@export var speed: int = 350

var velocity: Vector2 = Vector2.ZERO
var screensize: Vector2 = Vector2(240, 360)

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += velocity * speed * delta

	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	if velocity.length() > 0:
		animated_sprite.play("default")
	else:
		animated_sprite.stop()

	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x > 0


func start() -> void:
	set_process(true)
	position = screensize / 2
	animated_sprite.stop()


func die() -> void:
	set_process(false)
	hide()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")

	if area.is_in_group("timepowerups"):
		area.pickup()
		pickup.emit("timepowerup")

	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
