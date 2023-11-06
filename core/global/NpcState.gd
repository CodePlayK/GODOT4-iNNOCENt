extends Node

var doctor_on_player:bool=false

#bedroom
var bedroom_doctor_position:Vector2
var bedroom_doctor_flip_h:bool

#trainingroom
var trainingroom_doctor_position:Vector2
var trainingroom_doctor_flip_h:bool
var dic_on_player={
	"Npc_Sen":false,
	"Npc_An":false,
	"NPC_Silence":false
}
var dic_dialogue_side_left={
	"Npc_Sen":false,
	"Npc_An":false,
	"NPC_Silence":true
}

enum NPC{
	SEN,
	AN
}
