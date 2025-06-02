extends Node2D

var can_play: bool = true

@onready var hit_flesh_1: AudioStreamPlayer2D = self.find_child("HitFlesh1")
@onready var hit_flesh_2: AudioStreamPlayer2D = self.find_child("HitFlesh2")
@onready var hit_flesh_3: AudioStreamPlayer2D = self.find_child("HitFlesh3")
@onready var hit_flesh_4: AudioStreamPlayer2D = self.find_child("HitFlesh4")
@onready var timer: Timer = self.find_child("Timer")


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func play_hit_sound() -> void:
	if not can_play:
		return

	var chosen_sound: AudioStreamPlayer2D = (
		[hit_flesh_1, hit_flesh_2, hit_flesh_3, hit_flesh_4].pick_random()
	)
	chosen_sound.play()

	can_play = false


func _on_timer_timeout() -> void:
	can_play = true
