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

var NpcCacheExportNodes:Dictionary={
	
} 
##将导出的node的路径加入缓存中,以在场景复制时正确指向新建对象中的node,而不是原node
##(被复制的场景的唯一名比如NpcSen,有导出node节点的node名,导出的node,用于执行root_node()的Node一般为场景根节点)
##从缓存中获取
func add_to_export_node_cache(root_node:Node,node:Node,export_node:Node):
	if NpcCacheExportNodes.has(root_node.npc_name):
		if NpcCacheExportNodes[root_node.npc_name].has(node.name):
			if NpcCacheExportNodes[root_node.npc_name][node.name].has(export_node.name):
				return
			NpcCacheExportNodes[root_node.npc_name][node.name][export_node.name]=root_node.get_path_to(export_node)
		else :
			NpcCacheExportNodes[root_node.npc_name][node.name]={export_node.name:root_node.get_path_to(export_node)}
	else :
		NpcCacheExportNodes[root_node.npc_name]={node.name:{export_node.name:root_node.get_path_to(export_node)}}

func get_export_node_cache(root_node:Node,node:Node,export_node:Node):
	return NpcCacheExportNodes[root_node.npc_name][node.name][export_node.name]
