class_name FinalMenu
extends Control

@export var restart_button: Button
@export var exit_button: Button

@export var final_label: Label
@export var score_label: Label
@export var room_cleared_label: Label
@export var final_score_label: Label


func _ready() -> void:
	self.restart_button.pressed.connect(self._on_restart_button_pressed)
	self.exit_button.pressed.connect(self._on_exit_button_pressed)


func _on_restart_button_pressed() -> void:
	self.get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	self.get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func show_win(score: int, score_multiplier: int, room_cleared: int, room_total: int) -> void:
	self.show()
	self._set_final("MENANG", score, score_multiplier, room_cleared, room_total)


func show_lose(score: int, score_multiplier: int, room_cleared: int, room_total: int) -> void:
	self.show()
	self._set_final("KALAH", score, score_multiplier, room_cleared, room_total)


func _set_final(
	final_text: String, score: int, score_multiplier: int, room_cleared: int, room_total: int
) -> void:
	self.final_label.text = final_text
	self.score_label.text = "Skor: " + str(score) + " (" + str(score_multiplier) + "x)"
	self.room_cleared_label.text = (
		"Ruang Dimurnikan: " + str(room_cleared) + " / " + str(room_total)
	)
	self.final_score_label.text = (
		"Skor Akhir: " + str(round(score * (float(room_cleared) / float(room_total)) * 100) / 100)
	)
