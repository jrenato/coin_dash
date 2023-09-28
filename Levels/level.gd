extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var playtime: int = 30

var level: int = 1
var score: int = 0
var time_left: int = 0
var screensize: Vector2 = Vector2.ZERO
var playing: bool = false

@onready var player: Player = %Player
@onready var hud: CanvasLayer = %HUD

@onready var game_timer: Timer = %GameTimer
@onready var powerup_timer: Timer = %PowerupTimer

@onready var coin_sound: AudioStreamPlayer = %CoinSound
@onready var end_sound: AudioStreamPlayer = %EndSound
@onready var level_sound: AudioStreamPlayer = %LevelSound
@onready var powerup_sound: AudioStreamPlayer = %PowerupSound



func _ready() -> void:
	game_timer.timeout.connect(_on_game_timer_timeout)
	player.hurt.connect(_on_player_hurt)
	player.pickup.connect(_on_player_pickup)
	hud.start_button.pressed.connect(_on_hud_start_game)
	powerup_timer.timeout.connect(_on_powerup_timer_timeout)

	screensize = get_viewport().get_visible_rect().size
	player.screensize = screensize
	player.hide()


func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		powerup_timer.wait_time = randi_range(5, 10)
		powerup_timer.start()


func new_game() -> void:
	playing = true
	level = 1
	score = 0
	time_left = playtime
	player.start()
	player.show()
	game_timer.start()
	spawn_coins()
	
	hud.update_score(score)
	hud.update_timer(time_left)


func spawn_coins() -> void:
	level_sound.play()

	for i in level + 4:
		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.screensize = screensize
		coin.position = Vector2(randi_range(10, screensize.x - 10), randi_range(10, screensize.y - 10))


func game_over():
	end_sound.play()

	playing = false
	game_timer.stop()
	get_tree().call_group("coins", "queue_free")
	hud.show_game_over()
	player.die()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	hud.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()


func _on_player_pickup(pickup_type: String) -> void:
	match pickup_type:
		"coin":
			coin_sound.play()
			score += 1
			hud.update_score(score)
		"timepowerup":
			powerup_sound.play()
			time_left += 5
			hud.update_timer(time_left)


func _on_hud_start_game() -> void:
	new_game()


func _on_powerup_timer_timeout() -> void:
	var powerup = powerup_scene.instantiate()
	add_child(powerup)
	powerup.screensize = screensize
	powerup.position = Vector2(randi_range(10, screensize.x - 10), randi_range(10, screensize.y - 10))
