extends Node
	
	
var dic_sprite_talk_position={
}
var dic_sprite_talk_color={
	"NA":"61878c",
	"安":"cc4f57",
	"森":"557fc1",
}

var dic_dialogue_pole={
	"NA":"DNA",
	"0_0_0":"D0_0_0"
}
var dic_ruin_car={
	"NA":"DNA",
	"0_0_0":"D0_0_0"
}
var dic_ruin_subway={
	"NA":"DNA",
	"0_0_0":"D0_0_0"
}
var dic_npc_sen={
	"NA":"DNA",
	"0_0_0":"D0_0_0"
}
var dic_npc_an={
	"NA":"DNA",
	"0_0_0":"D0_0_0"
}

var dic_dialogue_position={
	
}

var dic_dialogue_obj_index={
	"pole":dic_dialogue_pole,
	"ruincar":dic_ruin_car,
	"ruinsubway":dic_ruin_subway,
	"npcsen":dic_npc_sen,
	"npcsen2":dic_npc_sen,
	"npcan":dic_npc_an
}

func get_current_cutscene_dialogue_line(obj_name):
	if !dic_dialogue_obj_index.has(obj_name):
		Debug.dprinterr("未在台词字典中找到[%s]" %obj_name)
		return
	var dialogue_dic:Dictionary=dic_dialogue_obj_index[obj_name]
	if !dialogue_dic.has(CutsceneState.current_cutscene):
		Debug.dprinterr("未在[%s]的台词字典中找到[%s]场景" %[obj_name,CutsceneState.current_cutscene])
		var all_cutscene:Array=CutsceneState.dic_cutscenes.keys()
		var obj_all_cutscene:Array=dialogue_dic.keys()
		var current_cutscene_index:int=all_cutscene.find(CutsceneState.current_cutscene)
		for i in current_cutscene_index+1:
			if obj_all_cutscene.has(all_cutscene[current_cutscene_index-i]):
				Debug.dprintinfo("[%s]在台词字典中找到上一个有台词的场景[%s]" %[obj_name,all_cutscene[current_cutscene_index-i]])
				return dialogue_dic[all_cutscene[current_cutscene_index-i]]
	else:
		return dialogue_dic[CutsceneState.current_cutscene]
