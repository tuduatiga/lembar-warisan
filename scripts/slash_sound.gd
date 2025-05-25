extends Node2D

var can_play: bool = true

@onready var slash_1: AudioStreamPlayer2D = self.find_child("Slash1")
@onready var slash_2: AudioStreamPlayer2D = self.find_child("Slash2")
@onready var slash_3: AudioStreamPlayer2D = self.find_child("Slash3")
@onready var timer: Timer = self.find_child("Timer")


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func play_sound():
	if not can_play:
		return

	var chosen_sound: AudioStreamPlayer2D = [slash_1, slash_2, slash_3].pick_random()
	chosen_sound.volume_db = -10.0
	chosen_sound.play()

	can_play = false


func _on_timer_timeout():
	can_play = true
