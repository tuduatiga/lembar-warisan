class_name HealthComponent extends Node2D

signal damage_taken(health: int)

@export var max_health: int

var health: int
var is_invincible: bool = false

var _health_bar: HealthBar
var _iframe_delay: float


func _ready() -> void:
	self.health = self.max_health
	self._health_bar = self.owner.find_child("HealthBar")
	self._iframe_delay = 1.0 if self.owner.get_groups().has("Player") else 0.5

	if self._health_bar:
		self._health_bar.init(self.health)


func _iframe() -> void:
	self.is_invincible = true
	await get_tree().create_timer(self._iframe_delay).timeout
	self.is_invincible = false


func damage(attack: Attack) -> void:
	if self.is_invincible or self.health <= 0:
		return

	self._iframe()

	self.health -= attack.damage

	if self._health_bar:
		self._health_bar.health = self.health

	damage_taken.emit(self.health)
