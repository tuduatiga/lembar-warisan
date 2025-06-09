extends Node2D

@export var score_label: Label
@export var final_menu: FinalMenu

var _score: int = 0
var _score_multiplier: int = 1
var _room_total: int = 0
var _room_cleared: int = 0

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func set_room_total(room_total: int) -> void:
	self._room_total = room_total

func add_score(score: int) -> int:
	self._score += score*self._score_multiplier
	self._score_multiplier += 1

	self.score_label.text = "Skor: " + str(self._score) + " (" + str(self._score_multiplier) + "x)"

	return self._score

func reset_score_multiplier() -> void:
	self._score_multiplier = 1
	self.score_label.text = "Skor: " + str(self._score) + " (" + str(self._score_multiplier) + "x)"

func inc_room_cleared() -> void:
	self._room_cleared += 1

func win() -> void:
	self.final_menu.show_win(self._score, self._score_multiplier, self._room_cleared, self._room_total)

func lose() -> void:
	self.final_menu.show_lose(self._score, self._score_multiplier, self._room_cleared, self._room_total)
