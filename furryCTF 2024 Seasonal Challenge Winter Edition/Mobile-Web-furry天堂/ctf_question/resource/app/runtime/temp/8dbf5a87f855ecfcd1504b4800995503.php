<?php if (!defined('THINK_PATH')) exit(); /*a:1:{s:48:"/app/public/../app/admin/view/appv1/dingwei.html";i:1598701802;}*/ ?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>layui  </title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet" href="/static/public/layui/css/layui.css"  media="all">
  <link rel="stylesheet" href="/static/public/font-awesome/css/font-awesome.min.css" media="all" />
  <link rel="stylesheet" href="/static/admin/css/admin.css"  media="all">
</head>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=lnTdedpeCtGGX5OUwWzULoOh"></script>
	<style type="text/css">
		body, html,#allmap {
			width: 100%;height: 100%;
			overflow: hidden;margin:0;
			font-family:"微软雅黑";
		}
	</style>
<body style="padding:10px;">
	<div id="allmap"></div>
	<div id="map-address0" style="display:none">
	</div>	
</body>
<script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("allmap");    // 创建Map实例
	map.centerAndZoom(new BMap.Point(<?php echo $dingweiid['mapx']; ?>,<?php echo $dingweiid['mapy']; ?>),15);  // 初始化地图,设置中心点坐标和地图级别
	//添加地图类型控件
	map.addControl(new BMap.MapTypeControl({
		mapTypes:[
            BMAP_NORMAL_MAP,
            BMAP_HYBRID_MAP
        ]}));	             			
	map.setCurrentCity("北京");          // 设置地图显示的城市 此项是必须设置的
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放

	
	// 用经纬度设置地图中心点
	var longitude = <?php echo $dingweiid['mapx']; ?>;
	var latitude = <?php echo $dingweiid['mapy']; ?>;
	if( longitude!=null && latitude != null){
		map.clearOverlays(); 
		var new_point = new BMap.Point(longitude,latitude);
		var infoWindow = new BMap.InfoWindow(document.getElementById("map-address0").innerHTML);
		var marker = new BMap.Marker(new_point);  // 创建标注
        var opts = {
      position : new_point,    // 指定文本标注所在的地理位置
      offset   : new BMap.Size(30, -30)    //设置文本偏移量
    }
        var label = new BMap.Label("设备名称：<?php echo $dingweiid['clientid']; ?> 登录手机:<?php echo $dingweiid['name']; ?>", opts);  // 创建文本标注对象
        label.setStyle({
             color : "red",
             fontSize : "12px",
             height : "20px",
             lineHeight : "20px",
             fontFamily:"微软雅黑"
         });
		//点击标注显示信息
		marker.addEventListener("click", function(){          
		    this.openInfoWindow(infoWindow);
		});
        map.addOverlay(label); 		
		map.addOverlay(marker);              // 将标注添加到地图中
		map.panTo(new_point);      
	}
</script>
</html>