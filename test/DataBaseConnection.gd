extends Node2D
var db:SQLite
const db_name="user://data/TEST_1"
const table_name="test_1"
const verbosity_level : int = SQLite.QUIET  
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.db_test.connect(_test)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _test_query():
	db=SQLite.new()
	db.path=db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var select_condition = "id = 0"
	var selected_array = db.select_rows(table_name, select_condition, ["*"])
	Debug.dprint(selected_array)
	db.close_db()
	pass
func _test_create_db():
	db=SQLite.new()
	db.path=db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var table_dict : Dictionary = Dictionary()
	table_dict["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
	table_dict["name"] = {"data_type":"text", "not_null": true}
	table_dict["position"] = {"data_type":"text", "not_null": true}
	db.create_table("player",table_dict)
	db.close_db()
	pass
func _test_insert():
	db=SQLite.new()
	db.path=db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var row_dict : Dictionary = Dictionary()
	row_dict["name"]="玩家1"
	row_dict["position"]="100,100"
	db.insert_row(table_name, row_dict)
	db.close_db()
	pass
func _test():
	db=SQLite.new()
	db.path=db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var row_dict : Dictionary = Dictionary()
	db.update_rows(table_name, "id = 1", {"name": "玩家2","position":"200,200"})
	db.close_db()
	pass
