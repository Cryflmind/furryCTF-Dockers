<?php if (!defined('THINK_PATH')) exit(); /*a:1:{s:77:"/www/wwwroot/web_question_furryctf/public/../app/admin/view/appv1/appset.html";i:1598701802;}*/ ?>
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
<body style="padding:10px;">
  <div class="tplay-body-div">
    <div style="margin-top: 20px;">
    </div>
    <form class="layui-form" id="admin">
      <div class="layui-form-item">
        <label class="layui-form-label">登录开关</label>
        <div class="layui-input-block">
          <input name="is_login" lay-skin="switch" lay-filter="switchTest" lay-text="ON|OFF" type="checkbox" <?php if($app_config['is_login'] == 1): ?>checked=""<?php endif; ?> value="1">
        </div>
        <div class="layui-form-mid layui-word-aux">APP登录功能开关</div>
      </div>

      <div class="layui-form-item">
        <label class="layui-form-label">登录邀请码</label>
        <div class="layui-input-inline" style="max-width: 400px">
          <input name="yaoqingma" lay-verify="pass" autocomplete="off" class="layui-input" type="text" value="<?php echo $app_config['yaoqingma']; ?>">
        </div>
        <div class="layui-form-mid layui-word-aux">APP登录填写的邀请码（邀请码为空的话，随便填写都可以登录，否则按照设置的邀请码才可以登录）</div>
      </div>
      
      <div class="layui-form-item">
        <div class="layui-input-block">
          <button class="layui-btn" lay-submit lay-filter="admin">立即提交</button>
          <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
      </div>
      
    </form>


    <script src="/static/public/layui/layui.js"></script>
    <script src="/static/public/jquery/jquery.min.js"></script>
    <script>
        var message;
        layui.config({
            base: '/static/admin/js/',
            version: '1.0.1'
        }).use(['app', 'message'], function() {
            var app = layui.app,
                $ = layui.jquery,
                layer = layui.layer;
            //将message设置为全局以便子页面调用
            message = layui.message;
            //主入口
            app.set({
                type: 'iframe'
            }).init();
        });
    </script>
    <script>
      layui.use(['layer', 'form'], function() {
          var layer = layui.layer,
              $ = layui.jquery,
              form = layui.form;
          $(window).on('load', function() {
              form.on('submit(admin)', function(data) {
                  $.ajax({
                      url:"<?php echo url('admin/appv1/appsetpo'); ?>",
                      data:$('#admin').serialize(),
                      type:'post',
                      async: false,
                      success:function(res) {
                        layer.msg(res.msg);
                          if(res.code == 1) {
                            setTimeout(function(){
                              location.href = res.url;
                            },1500) 
                          }
                      }
                  })
                  return false;
              });
          });
      });
    </script>
  </div>
</body>
</html>