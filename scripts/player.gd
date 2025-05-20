class_name Player extends CharacterBody2D

const _SPEED: float = 200.0

var _health: int

var _animated_sprite: AnimatedSprite2D
var _collision_shape: CollisionShape2D
var _enemy_detection_area: Area2D
var _hurt_box: Area2D


func _ready():
	self._health = 6

	self._animated_sprite = self.find_child("AnimatedSprite2D")
	self._collision_shape = self.find_child("CollisionShape2D")
	self._enemy_detection_area = self.find_child("EnemyDetectionArea")
	self._hurt_box = self.find_child("HurtBoxArea")

	self._hurt_box.body_entered.connect(self._on_hurt_box_area_body_entered)


func _physics_process(_delta: float) -> void:
	for body in self._enemy_detection_area.get_overlapping_bodies():
		if body.collision_layer & 0b100 > 0:
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


func _on_hurt_box_area_body_entered(body: CharacterBody2D) -> void:
	if body.collision_layer & 0b100 > 0 and self._health:
		self._health -= 1

		if not self._health:
			await get_tree().create_timer(3).timeout

			self.get_tree().reload_current_scene()
