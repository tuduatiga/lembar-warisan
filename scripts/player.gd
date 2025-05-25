class_name Player extends CharacterBody2D

const _SPEED: float = 200.0

var _health: int

var _animated_sprite: AnimatedSprite2D
var _collision_shape: CollisionShape2D
var _enemy_detection_area: Area2D


func _ready():
	self._health = 6

	self._animated_sprite = self.find_child("AnimatedSprite2D")
	self._collision_shape = self.find_child("CollisionShape2D")
	self._enemy_detection_area = self.find_child("EnemyDetectionArea")


func _physics_process(_delta: float) -> void:
	if not self._health:
		self._animated_sprite.animation = "front_idle"
		self._animated_sprite.stop()

		await self.get_tree().create_timer(3).timeout

		self.get_tree().reload_current_scene()
		return

	for body in self._enemy_detection_area.get_overlapping_bodies():
		if self._is_enemy(body):
			body.set_movement_target(self.global_position)

	self.velocity = (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * self._SPEED)

	if self.velocity.x:
		self._animated_sprite.flip_h = self.velocity.x < 0

	self._animated_sprite.speed_scale = 1 + self.velocity.length() / self._SPEED

	var dir: String = "back" if self.velocity.y < 0 else "front"
	if self.velocity.length_squared() > 0:
		self._animated_sprite.animation = dir + "_walk"
	else:
		self._animated_sprite.animation = dir + "_idle"

	self.move_and_slide()


func _is_enemy(body: CharacterBody2D) -> bool:
	return body.collision_layer & Enums.CollisionLayer.ENEMY > 0


func take_damage(amount: int) -> void:
	if self._health:
		self._health -= amount
