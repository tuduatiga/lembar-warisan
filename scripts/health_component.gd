class_name HealthComponent extends Node2D

signal damage_taken(health: int)

@export var max_health: int

var health: int
var _health_bar: HealthBar


func _ready() -> void:
	self.health = self.max_health
	self._health_bar = self.owner.find_child("HealthBar")

	if self._health_bar:
		self._health_bar.init(self.health)


func damage(attack: Attack) -> void:
	if self.health <= 0:
		return

	self.health -= attack.damage

	if self._health_bar:
		self._health_bar.health = self.health

	damage_taken.emit(self.health)
