extends Area2D

var screensize: Vector2 = Vector2.ZERO

@onready var shadow_sprite: Sprite2D = %ShadowSprite2D
@onready var animated_sprite: AnimatedSprite2D = %CoinAnimatedSprite2D
@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func pickup() -> void:
	area_entered.connect(_on_area_entered)
	# Disable the collision on the next physics iteration
	collision_shape.set_deferred("disabled", true)
	
	shadow_sprite.hide()

	var tween: Tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)

	await tween.finished

	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles") or area.is_in_group("coins"):
		position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
