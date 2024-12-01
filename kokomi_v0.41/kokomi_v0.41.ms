/*
更新日志：
v0.41:  2024/9/29
根据新的ue规范 增加了一个可以把颜色变为位图的功能 以及填充粗糙和法线贴图

v0.40:  2024/8/11
增加了光照贴图相关的烘焙效果
并对ui进行大幅度修改
修改了读取文件夹的初始路径 改为历史路径
增加了仅重置缩放的功能

v0.33：
增加了批量修改粗糙度的功能

v0.32:
修复了物理转标准材质会多出材质的问题
但std suface转物理材质仍存在问题 因为出问题的概率不大 暂时没有修复

v0.31:
修改了壳材质处理功能中会导致原材质名称修改的问题

v0.3:
物理材质的normalscale值改回0.3
增加了quexie工具集 缩小贴图  物理材质转标准  标准表面材质转物理
增加了导入从houdini导出的实例信息功能
增加了根据材质球名称重命名贴图的功能

v0.27:
修改自动贴物理材质中normal_scale的值从0.3到4
修改了重置变换保留旋转缩放的规则

v0.26:
新增重置变换但保留旋转缩放信息
删除功能“打平”
对法线修复功能进行完善

v0.25:
增加多维子材质相关处理功能

v0.23：
自动贴图功能，修复ao贴图可能因字段识别导致贴错的问题
修改匹配规则，必须完全满足规则（包括大小写）才能识别
增加对多维子材质的支持
修复对中文版本max的支持

v0.22:
新增自动贴物理材质贴图的功能

v0.21 ： 
增加了部分操作可以撤回的功能，

*/

include "fn_koko.mxs"
include "rollout_koko.mxs"

script_dir = pathConfig.removePathLeaf (getSourceFileName()) --获得脚本的路径

main_rol_widhth = 300 --主界面的宽
main_rol_height = 300 --主界面的高
--设置图片路径
if(script_dir == ((GetDir #userstartupscripts )+"\kokomi"))
then kokomi_filename =(getdir #image)+"/icon/kokomi.jpg" 
else kokomi_filename =script_dir+"/icon/kokomi.jpg"
--设置图标路径
kokoicon_filename =(getdir #image)+"\\icon\\koko_icon.jpg" 


state_rol = 0 -- 这是一个状态值用于记录处于哪个界面 0-表示没有打开任何子菜单


--主界面
rollout main_rollout "kokomi v0.41" width:main_rol_widhth height:main_rol_height
(
	--主界面按钮
	bitmap 'bmp1' "bitmap" pos:[0,0] width:200 height:300 filename:kokomi_filename align:#left
	button 'btn1' "常用功能" pos:[210,0] width:80 height:50
	button 'btn2' "烘焙相关" pos:[210,60] width:80 height:50
	button 'btn3' "材质贴图" pos:[210,120] width:80 height:50
	button 'btn4' "非常用功能" pos:[210,180] width:80 height:50
	button 'btn0' "返回" pos:[210,240] width:80 height:50

	fn clear_other_rollout =
	(
		DestroyDialog cuse_rollout
		DestroyDialog bake_rollout
		DestroyDialog texture_rollout
		DestroyDialog ncuse_rollout
	)

	fn get_2c_pos =
	(
		local pos1 = getDialogPos main_rollout
		pos1[1]+=300
		return pos1
	)
	
	on btn1 pressed  do
	(
		clear_other_rollout()
		pos2 = get_2c_pos()
		createdialog cuse_rollout pos:pos2
		state_rol =1
	)
	on btn2 pressed  do
	(
		clear_other_rollout()
		pos2 = get_2c_pos()
		createdialog bake_rollout pos:pos2
		state_rol =2
	)
	on btn3 pressed  do
	(
		clear_other_rollout()
		pos2 = get_2c_pos()
		createdialog texture_rollout pos:pos2
		state_rol =3
	)
	on btn4 pressed  do
	(
		clear_other_rollout()
		pos2 = get_2c_pos()
		createdialog ncuse_rollout pos:pos2
		state_rol =4
	)
	
	on btn0 pressed  do
	(
		clear_other_rollout()
		state_rol = 0
	)
)


createDialog main_rollout
setDialogPos main_rollout [0,350]  --设置ui到左侧


--图标宏定义
macroScript koko_macros
	category:"kokomi"
	toolTip:"open_koko"
	iconName:"koko_icon.png"
(
	DestroyDialog main_rollout
	CreateDialog main_rollout
	setDialogPos main_rollout [0,350]
)
