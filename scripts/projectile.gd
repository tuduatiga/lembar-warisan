class_name Projectile
extends Node2D

const SPEED = 150.0

@export var texture: Texture2D

var direction: Vector2 = Vector2.ZERO

@onready var _sprite: Sprite2D = self.find_child("Sprite2D")
@onready var _hitbox: HitboxComponent = self.find_child("HitboxComponent")


func _ready() -> void:
	if self.texture:
		self._sprite.texture = self.texture

	self._hitbox.body_hit.connect(_on_body_hit)
	self._hitbox.area_hit.connect(_on_area_hit)


func with_texture(p_texture: Texture2D) -> Projectile:
	self.texture = p_texture
	return self


func with_modulate(p_modulate: Color) -> Projectile:
	self._sprite.modulate = p_modulate
	return self


func spawn(proprietor: Node2D) -> Projectile:
	proprietor.get_tree().root.get_child(1).add_child(self)
	self._hitbox.proprietor = proprietor
	self.direction = (self.get_global_mouse_position() - proprietor.global_position).normalized()
	self._sprite.rotate(self.direction.angle())
	self.global_position = proprietor.global_position + self.direction * 10
	return self


func spawn_with_direction(proprietor: Node2D, p_direction: Vector2) -> Projectile:
	proprietor.get_tree().root.get_child(1).add_child(self)
	self._hitbox.proprietor = proprietor
	self.direction = p_direction
	self._sprite.rotate(self.direction.angle())
	self.global_position = proprietor.global_position + self.direction * 10
	return self


func _physics_process(delta: float) -> void:
	self.position += self.direction * self.SPEED * delta


func _on_area_hit(area: Area2D):
	if self._hitbox.proprietor:
		if self._hitbox.proprietor.is_in_group("Player") and area.is_in_group("Enemy"):
			self.queue_free()
		if self._hitbox.proprietor.is_in_group("Enemy") and area.is_in_group("Player"):
			self.queue_free()
	else:
		if area.is_in_group("Enemy"):
			self.queue_free()


func _on_body_hit(body):
	if self._hitbox.proprietor:
		if self._hitbox.proprietor == body:
			return
	self.queue_free()
