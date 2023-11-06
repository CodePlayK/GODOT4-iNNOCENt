extends SaveDataCollector
@onready var test = $"../test"

#配置要写入存档的数据
func custom_data():
	dic_save_data["test"]=test.text
	pass
	
#载入存档数据
func load_custom_data():
	test.text=dic_save_data["test"]
	pass
