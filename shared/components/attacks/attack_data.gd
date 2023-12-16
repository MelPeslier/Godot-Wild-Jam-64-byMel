class_name AttackData
extends Node

enum OwnerType {
	ENEMY,
	PLAYER
}

#enum AttackType {
	#NORMAL
#}

@export var owner_type: OwnerType
#@export var attack_types: Array[AttackType]
