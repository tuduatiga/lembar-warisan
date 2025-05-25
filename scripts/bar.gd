class_name Bar extends StaticBody2D

@export var open = true
@export_enum("front", "right", "left") var dir = "front"
var _sprite: AnimatedSprite2D
var _collision: CollisionShape2D

func _ready() -> void:
	self._sprite = self.find_child("AnimatedSprite2D")
	self._collision = self.find_child("CollisionFront") if self.dir == "front" else self.find_child("CollisionSide")
	self._collision.disabled = false
	self.set_collision_layer_value(4, not self.open)
	self._sprite.animation = self.dir if self.dir == "front" else "side"
	self._sprite.flip_h = self.dir == "left"
	self._collision.position.x *= -1 if self.dir == "left" else 1
	self._sprite.frame = 0 if self.open else max(_sprite.sprite_frames.get_frame_count(self.dir),0)

func _physics_process(_delta: float) -> void:
	self.set_collision_layer_value(4, not self.open)

func to_open() -> void:
	self._sprite.frame = 0
	self.open = true

func to_close() -> void:
	self._sprite.frame = max(self._sprite.sprite_frames.get_frame_count(self._sprite.animation),0)
	self.open = false

func transition_open() -> void:
	self.open = true
	self._sprite.play_backwards()

func transition_close() -> void:
	self.open = false
	self._sprite.play()
