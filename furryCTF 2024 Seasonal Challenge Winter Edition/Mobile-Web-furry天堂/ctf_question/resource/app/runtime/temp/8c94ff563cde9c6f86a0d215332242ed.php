<?php if (!defined('THINK_PATH')) exit(); /*a:1:{s:75:"/www/wwwroot/web_question_furryctf/public/../app/admin/view/main/index.html";i:1598701840;}*/ ?>
<!DOCTYPE html>
<html>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>tplay_main  </title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
  <script src="/static/public/echarts/echarts.min.js"></script>
  <link rel="stylesheet" href="/static/public/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="/static/public/font-awesome/css/font-awesome.min.css" media="all">
  <link rel="stylesheet" href="/static/admin/css/admin-1.css" media="all">
<body class="layui-layout-body" style="overflow-y:visible;">
    <div class="layadmin-tabsbody-item layui-show"><div class="layui-fluid">
  <div class="layui-row layui-col-space15">
    <div class="layui-col-md8">
      <div class="layui-row layui-col-space15">
        <div class="layui-col-md6">
          <div class="layui-card">
            <div class="layui-card-header"></div>
            <div class="layui-card-body">

              <div class="layui-carousel layadmin-carousel layadmin-backlog" lay-anim="" lay-indicator="inside" lay-arrow="none" style="width: 100%; height: 280px;">
                <div carousel-item="">
                  <ul class="layui-row layui-col-space10 layui-this">
                    <li class="layui-col-xs6">
                      <a href="<?php echo url('admin/appv1/user'); ?>" lay-href="<?php echo url('admin/appv1/user'); ?>" class="layadmin-backlog-body">
                        <h3>用户</h3>
                        <p><cite><?php echo $web['mobileuser']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a href="<?php echo url('admin/appv1/mobile'); ?>" lay-href="<?php echo url('Admin/Appv1/mobile'); ?>" class="layadmin-backlog-body">
                        <h3>通讯录</h3>
                        <p><cite><?php echo $web['mobile']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a href="<?php echo url('admin/admin/index'); ?>" lay-href="/admin/admin/index.shtml" class="layadmin-backlog-body">
                        <h3>管理员</h3>
                        <p><cite><?php echo $web['user_num']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a href="<?php echo url('admin/appv1/sms'); ?>" lay-href="/admin/appv1/sms.shtml" class="layadmin-backlog-body">
                        <h3>短信数据</h3>
                        <p><cite><?php echo $web['smsnum']; ?></cite></p>
                      </a>
                    </li>
                  </ul>
                </div>
              <button class="layui-icon layui-carousel-arrow" lay-type="sub"></button><button class="layui-icon layui-carousel-arrow" lay-type="add"></button></div>
            </div>
          </div>
        </div>
        <div class="layui-col-md6">
          <div class="layui-card">
            <div class="layui-card-header">待办事项</div>
            <div class="layui-card-body">

              <div class="layui-carousel layadmin-carousel layadmin-backlog" lay-anim="" lay-indicator="inside" lay-arrow="none" style="width: 100%; height: 280px;">
                <div carousel-item="">
                  <ul class="layui-row layui-col-space10 layui-this">
                    <li class="layui-col-xs6">
                      <a lay-href="" class="layadmin-backlog-body">
                        <h3>黑名单</h3>
                        <p><cite><?php echo $web['ip_ban']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a lay-href="" class="layadmin-backlog-body">
                        <h3>待审文章</h3>
                        <p><cite><?php echo $web['status_article']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a lay-href="" class="layadmin-backlog-body">
                        <h3>待审文件</h3>
                        <p><cite><?php echo $web['status_file']; ?></cite></p>
                      </a>
                    </li>
                    <li class="layui-col-xs6">
                      <a lay-href="" class="layadmin-backlog-body">
                        <h3>待处理留言</h3>
                        <p><cite><?php echo $web['look_message']; ?></cite></p>
                      </a>
                    </li>
                  </ul>
                </div>
              <button class="layui-icon layui-carousel-arrow" lay-type="sub"></button><button class="layui-icon layui-carousel-arrow" lay-type="add"></button></div>
            </div>
          </div>
        </div>
        <div class="layui-col-md12">
          <div class="layui-card">
            <div class="layui-card-header">管理员登录</div>
            <div class="layui-card-body" id="main" style="height: 450px;">

            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="layui-col-md4">
    	
      <div class="layui-card">
        <div class="layui-card-header">
          
        </div>
        <div class="layui-card-body layui-text layadmin-text">
          <p>本APP系统产品使用用途仅限于测试实验、研究学习为目的，请勿用于商业途径及非法运营，用户严禁将本产品用于与中国现行法律相违背的一切行为；否则，一切法律责任 及 所有后果均由系统使用方承担，与系统开发者无关，并且系统开发者有权停止一切产品相关服务，特此声明。</p>
        </div>
      </div>    	
    	
      <div class="layui-card">
        <div class="layui-card-header"></div>
        <div class="layui-card-body layui-text">
          <table class="layui-table">
            <colgroup>
              <col width="100">
              <col>
            </colgroup>
            <tbody>
              <tr>
                <td>当前版本</td>
                <td>
                    APPV1 <?php echo $info['tplay']; ?>
                </td>
              </tr>
              <tr>
                <td>基于框架</td>
                <td>
                 layui-v2.2.5 / thinkphp-v<?php echo $info['tp']; ?> 
               </td>
              </tr>
              <tr>
                <td>主要特色</td>
                <td>适配强 / 高颜值 / 清爽 / 简洁</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="layui-card">
        <div class="layui-card-header"></div>
        <div class="layui-card-body layui-text">
          <table class="layui-table">
            <colgroup>
              <col width="200">
              <col>
            </colgroup>
            <tbody>
              <tr>
                <td>操作系统</td>
                <td>
                    <?php echo $info['win']; ?> 
                </td>
              </tr>
              <tr>
                <td>PHP版本</td>
                <td>
                 <?php echo $info['php']; ?> 
               </td>
              </tr>
              <tr>
                <td>运行环境</td>
                <td><?php echo $info['environment']; ?></td>
              </tr>
              <tr>
                <td>上传最大限制</td>
                <td>
                  <?php echo $info['upload_size']; ?>
                </td>
              </tr>
              <tr>
                <td>执行时间限制</td>
                <td>
                  <?php echo $info['execution_time']; ?>
                </td>
              </tr>
              <tr>
                <td>剩余空间大小</td>
                <td>
                  <?php if(!(empty($info['disk']) || (($info['disk'] instanceof \think\Collection || $info['disk'] instanceof \think\Paginator ) && $info['disk']->isEmpty()))): ?><?php echo $info['disk']; else: ?>未知<?php endif; ?>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    </div>
    
  </div>
  </div>
  </div>


<script src="/static/public/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript">
layui.use(['layer','util'],function(){
  var layer = layui.layer;
  var util = layui.util,$ = layui.$;
  $(document).ready(function(){
  	if(getUCookie('GGtimes') != 1){
      layer.open({
        type: 1
        ,title: '系统使用协议'
        ,closeBtn: false
        ,area: '300px;'
        ,shade: 0.8
        ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
        ,btn: ['同意协议', '不同意且退出']
        ,btnAlign: 'c'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<div style="padding: 30px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">本APP系统产品使用用途仅限于测试实验、研究学习为目的，请勿用于商业途径及非法运营，用户严禁将本产品用于与中国现行法律相违背的一切行为；否则，一切法律责任 及 所有后果均由系统使用方承担，与系统开发者无关，并且系统开发者有权停止一切产品相关服务，特此声明。</div>'
        ,success: function(layero){
          var btn = layero.find('.layui-layer-btn');
          btn.find('.layui-layer-btn0').attr({
            target: '_blank'
          });
          btn.find('.layui-layer-btn1').attr({
            href: "<?php echo url('admin/common/logout'); ?>"
          });
        }
      });  		
	  setUCookie('GGtimes',1)
	}
  })
})

function setUCookie(u_name,value){
	var exdate=new Date()
	exdate.setHours(exdate.getHours() + 1); //1小时后过期
	document.cookie=u_name+ "=" +escape(value)+"; expires="+exdate.toGMTString();
}

function getUCookie(u_name){
	if (document.cookie.length>0){ 
		u_start=document.cookie.indexOf(u_name + "=")
	if (u_start!=-1){ 
		u_start=u_start + u_name.length+1
		u_end=document.cookie.indexOf(";",u_start)
		if (u_end==-1) u_end=document.cookie.length
			return unescape(document.cookie.substring(u_start,u_end))
		} 
	}
	return ''
}

var a = "<?php echo $web['date_string']; ?>";
var date = a.split(",");

var b = "<?php echo $web['login_sum']; ?>";
var login_sum = b.split(",");


var myChart = echarts.init(document.getElementById('main'));

option = {
    tooltip: {
        trigger: 'axis',
        position: function (pt) {
            return [pt[0], '10%'];
        }
    },
    grid: {
        top: 50,
        bottom: 70,
        left:40,
        right:50
    },
    toolbox: {
        feature: {
            dataZoom: {
                yAxisIndex: 'none'
            },
            restore: {},
            saveAsImage: {}
        }
    },
    xAxis: {
        type: 'category',
        boundaryGap: false,
        data: date
    },
    yAxis: {
        type: 'value',
        boundaryGap: [0, '100%']
    },
    dataZoom: [{
        type: 'inside',
        start: 0,
        end: 100
    }, {
        start: 0,
        end: 100,
        handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
        handleSize: '100%',
        handleStyle: {
            color: '#fff',
            shadowBlur: 3,
            shadowColor: '#009688',
            shadowOffsetX: 2,
            shadowOffsetY: 2
        }
    }],
    series: [
        {
            name:'管理员登录',
            type:'line',
            smooth:true,
            symbol: 'none',
            sampling: 'average',
            itemStyle: {
                normal: {
                    color: '#009688'
                }
            },
            areaStyle: {
                normal: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                        offset: 0,
                        color: '#009688'
                    }, {
                        offset: 1,
                        color: '#009688'
                    }])
                }
            },
            data: login_sum
        }
    ]
};
myChart.setOption(option);
</script>
</body>
</html>