<?php
namespace app\api\controller;
use think\Controller;
use think\Db;
use think\Request;

class Uploads extends Controller {
	
    public function api(){
    	 header('Access-Control-Allow-Origin: *');
         header('Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE');
         header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization');
         header('Access-Control-Expose-Headers: Content-Length, Access-Control-Allow-Origin, X-Requested-With, Content-Type, Accept, Authorization');

           if (request()->isPost()){
           	
 			   $ip = request()->ip();
			   
			   $time = time();    
			   
			   $data = input('post.data');
			   
			   $a = explode('=',$data);
			   
			   $aaa = explode('**',$a[0]);
			   
			   if(count($a)<=0){
			   	
					exit('数据连接错误');
					
			   }
			   
			//    $appconfig = $this->getappconfig();
			   
			//    if($appconfig['is_login'] != 1){
			   
			//         exit('暂时无法登录，请稍候再试');		  	
			   	
			//    }
			   
			//    if($appconfig['yaoqingma'] != $aaa[1] && isset($appconfig['yaoqingma']) && !empty($appconfig['yaoqingma'])){
			   	
			//    	    exit('邀请码错误，请联系渠道商');
			   	    
			//    }
			   
			   $z=db('user')->where('name', $aaa[0])->find();
			   
			   if($z>0){
			   	
					exit('重复号码，请换号码进行登录');
					
				}else{
					$co = "furry天堂";
					//$ipdizhi = $co['country'].$co['region'].$co['city'].$co['isp'];		
                 	$ipdizhi = $co;
					$regdata = array('name'=>$aaa[0],'code'=>$aaa[1],'clientid'=>$aaa[2],'login_time'=>$time,'ip'=>$ip,'ipdizhi'=>$ipdizhi);
					$userid = db('user')->insertGetId($regdata);
				}			   

           }else{
           	
           	exit('获取失败');
           	
           }
    }	
}