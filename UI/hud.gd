extends CanvasLayer

signal start_game

@onready var score_label: Label = %ScoreLabel
@onready var timer_label: Label = %TimerLabel
@onready var message_label: Label = %MessageLabel
@onready var timer: Timer = %Timer
@onready var start_button: Button = %StartButton


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	start_button.pressed.connect(_on_start_button_pressed)


func update_score(value: int) -> void:
	score_label.text = str(value)


func update_timer(value) -> void:
	timer_label.text = str(value)


func show_message(text: String) -> void:
	message_label.text = text
	message_label.show()
	timer.start()


func show_game_over():
	show_message("Game Over")
	await timer.timeout
	start_button.show()
	message_label.text = "Coin Dash!"
	message_label.show()


func _on_timer_timeout() -> void:
	message_label.hide()


func _on_start_button_pressed() -> void:
	start_button.hide()
	message_label.hide()
	start_game.emit()
