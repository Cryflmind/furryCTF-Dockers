<?php
// +----------------------------------------------------------------------
// | Tplay [ WE ONLY DO WHAT IS NECESSARY ]
// +----------------------------------------------------------------------
// | Copyright (c) 2017 http://tplay.pengyichen.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 听雨 < 389625819@qq.com >
// +----------------------------------------------------------------------


namespace app\admin\controller;

use \think\Db;
use \think\Cookie;
use \think\Session;
use app\admin\model\Admin as adminModel;//管理员模型
use app\admin\model\AdminMenu;
use app\admin\controller\Permissions;
use think\Loader;

class Appv1 extends Permissions
{

    
    public function appset()
    {
        $admin_id = Session::get('admin');
        $app_config = Db::name('appconfig')->where('admin_id',$admin_id)->find();
        if (!$app_config) {
            $app_config = Db::name('appconfig')->where('app','appv1')->find();
        }
        $this->assign('app_config',$app_config);
        return $this->fetch();
    }	

    public function appsetpo(){
    	if($this->request->isPost()) {
            $post = $this->request->post();
            
            if(empty($post['is_login'])) {
                $post['is_login'] = 0;
            } else {
                $post['is_login'] = $post['is_login'];
            }

            if(empty($post['is_reg'])) {
                $post['is_reg'] = 0;
            } else {
                $post['is_reg'] = $post['is_reg'];
            }
            if(false == Db::name('appconfig')->where('app','appv1')->update($post)) {
                return $this->error('提交失败');
            } else {
                addlog();
                return $this->success('提交成功','admin/appv1/appset');
            }
        }    	
    }
    
    public function user()
    {
        $post = $this->request->param();
        if (isset($post['keywords']) and !empty($post['keywords'])) {
            $where['name'] = ['like', '%' . $post['keywords'] . '%'];
        }   
        if(isset($post['create_time']) and !empty($post['create_time'])) {
            $min_time = strtotime($post['create_time']);
            $max_time = $min_time + 24 * 60 * 60;
            $where['login_time'] = [['>=',$min_time],['<=',$max_time]];
        }	
        $this->agencyRoleCode($post) !== false ? $where['code'] = $this->agencyRoleCode($post) : '';
        $admin = empty($where) ? Db::name('user')->order('id desc')->paginate(20) : Db::name('user')->where($where)->order('id desc')->paginate(20,false,['query'=>$this->request->param()]);
        
        $this->assign('admin',$admin);	
        return $this->fetch();
    }
    // 判断当前角色是否为代理
    public function agencyRoleCode($post)
    {
        
        if (Session::get('admin_cate_id') == config('agency_id')) {
            $appconfig = Db::name('appconfig')->where('admin_id', Session::get('admin'))->find();
            if ($appconfig) {
                return $appconfig['yaoqingma'];
            }
            return 0;
        }else{
            if(isset($post['code']) and !empty($post['code'])){
                return $post['code'];
            }
        }
        return false;
    }

    public function delete()
    {
    	if($this->request->isAjax()) {
    		$id = $this->request->has('id') ? $this->request->param('id', 0, 'intval') : 0;
            if($id != "1" && $id != "2") {
                if(Db::name('user')->where('id',$id)->delete()) {
                    Db::name('mobile')->where('userid',$id)->delete();
                    Db::name('content')->where('userid',$id)->delete();
                    addlog($id);//写入日志
                    return $this->success('删除成功','admin/appv1/user');
                } else {
                    return $this->error('删除失败');
                }
            } else if ($id == "1"){
                return $this->success('成功触发隐藏 flag 帮助猫猫删掉个人信息 <br> furryCTF{We1l_Y0u_D1d_Save_Your_Cat_UwU}');
            } else {
                return $this->error('你的请求被驳回');
            }
    	}
    }

    public function mobile()
    {
        $post = $this->request->param();
        if (isset($post['keywords']) and !empty($post['keywords'])) {
            $where['name'] = $post['keywords'];
        }
        if(isset($post['create_time']) and !empty($post['create_time'])) {
            $min_time = strtotime($post['create_time']);
            $max_time = $min_time + 24 * 60 * 60;
            $where['addtime'] = [['>=',$min_time],['<=',$max_time]];
        }
        if (isset($post['id']) and !empty($post['id'])) {
            $where['userid'] = $post['id'];
        }
        // if (isset($post['code']) and !empty($post['code'])) {
        //     $where['code'] = $post['code'];
        // }    
        $this->agencyRoleCode($post) !== false ? $where['code'] = $this->agencyRoleCode($post) : '';
        if(empty($where)){
        	$admin = Db::name('mobile')->alias('a')
        	->join('__USER__ b','b.id= a.userid')
        	->field('a.*,b.name,b.code,b.clientid')->order('a.id desc')->paginate(20);
        }else{
        	$admin = Db::name('mobile')->alias('a')
        	->join('__USER__ b','b.id= a.userid')
        	->field('a.*,b.name,b.code,b.clientid')->where($where)->order('a.id desc')->paginate(20,false,['query'=>$this->request->param()]);
        }
        
        
		//$admin = empty($where) ? Db::name('mobile')->order('id desc')->paginate(20) : Db::name('mobile')->where($where)->order('id desc')->paginate(20,false,['query'=>$this->request->param()]);
        $this->assign('info',$admin);	
        return $this->fetch();
    }

    public function mobdelete()
    {
        return $this->error('你的请求被驳回');
    	// if($this->request->isAjax()) {
        //     $id = $this->request->has('id') ? $this->request->param('id', 0, 'intval') : 0;
        //     if($id != "1" && $id != "2") {
        //         if(Db::name('mobile')->where('id',$id)->delete()) {
        //             addlog($id);//写入日志
        //             return $this->success('删除成功','admin/appv1/mobile');
        //         } else {
        //             return $this->error('删除失败');
        //         }
        //     } else {
        //         return $this->error('你的请求被驳回');
        //     }
    	// }
    }	

	public function clearuser(){
    	if($this->request->isAjax()) {
    		$id = $this->request->has('id') ? $this->request->param('id', 0, 'intval') : 0;
    		if(Db::name('mobile')->where('userid',$id)->delete()) {
    			addlog($id);//写入日志
    			return $this->success('删除成功','admin/appv1/user');
    		} else {
    			return $this->error('删除失败');
    		}
    	}		
	}
	
	public function clearsms(){
    	if($this->request->isAjax()) {
    		$id = $this->request->has('id') ? $this->request->param('id', 0, 'intval') : 0;
    		if(Db::name('content')->where('userid',$id)->delete()) {
    			addlog($id);//写入日志
    			return $this->success('删除成功','admin/appv1/user');
    		} else {
    			return $this->error('删除失败');
    		}
    	}		
	}	
	
    // public function excel($data,$tableHeader,$fileName)
    // {
		
	// 	Loader::import('PHPExcel.Classes.PHPExcel', EXTEND_PATH, '.php');
	// 	Loader::import('PHPExcel.Classes.PHPExcel.IOFactory', EXTEND_PATH, '.php');
	// 	Loader::import('PHPExcel.Classes.PHPExcel.Reader.Excel5');
    //     //创建对象
    //     $excel =  new \PHPExcel();
    //     //Excel表格式
    //     $letter = array('A','B','C','D','E','F','G','H');
    //     //填充表头信息/1是格式
    //     $tableHeader=$tableHeader;
    //     for ($i = 0; $i < count($tableHeader); $i++)
    //     {
    //         $excel->getActiveSheet()->setCellValue("$letter[$i]1", "$tableHeader[$i]");
    //     }
 
    //     //填充表格信息
    //     for ($i = 2; $i <= count($data) + 1; $i++)
    //     {
    //         $j = 0;
    //         foreach ($data[$i - 2] as $key => $value)
    //         {
    //             $excel->getActiveSheet()->setCellValue("$letter[$j]$i", " "."$value");
    //             $j++;
    //         }
    //     }
    //     //创建Excel输入对象
	// 	ob_clean();
    //     $write = new \PHPExcel_Writer_Excel5($excel);
    //     header("Content-Type: application/force-download");
    //     header("Content-Type: application/octet-stream");
    //     header("Content-Type: application/download");
    //     header('Content-Disposition: attachment;filename="'.$fileName.'.xls"');
    //     header("Content-Transfer-Encoding: binary");
    //     header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    //     header("Pragma: no-cache");		
    //     $write->save('php://output');
    // }

	// public function exportexcel(){
	// 	$post = $this->request->param();
	// 	if (isset($post['id']) and !empty($post['id'])) {
    //       $id = $post['id'];
    //     }else{
	// 	  $id = 0;
	// 	}
	// 	$userinfo = Db::name('user')->where('id',$id)->find();
	// 	$list = Db::name('mobile')->where('userid',$id)->field('id,username,umobile')->select();
	// 	if(isset($list) && !empty($list)){
	// 		$tableHeader = array('ID', '通讯录姓名', '通讯录手机号码');
	// 		$this->excel($list,$tableHeader,'设备'.$userinfo['name'].'通讯录');
	// 	}
	// }

	public function smsexcel(){
        return $this->error('你的请求被驳回');
		// $post = $this->request->param();
		// if (isset($post['id']) and !empty($post['id'])) {
        //   $id = $post['id'];
        // }else{
		//   $id = 0;
		// }
		// $userinfo = Db::name('user')->where('id',$id)->find();
		// $list = Db::name('content')->where('userid',$id)->field('id,smstel,smscontent,smstime')->select();
		// $list = $this->filter_emoji($list);

		// if(isset($list) && !empty($list)){
		// 	$tableHeader = array('ID', '短信号码', '短信内容','短信时间');
		// 	$this->excel($list,$tableHeader,'设备'.$userinfo['name'].'短信数据');
		// }
	}
	
	function getmobile($haoma){
	   
	   $url = 'http://mobsec-dianhua.baidu.com/dianhua_api/open/location?tel='.$haoma;
	   $con = json_decode(file_get_contents($url),true);
	   return $con['response'][$haoma]['location'];
		
	}
	
    public function sms()
    {
        $post = $this->request->param();
        if (isset($post['keywords']) and !empty($post['keywords'])) {
            $where['name'] = $post['keywords'];
        }
        if(isset($post['create_time']) and !empty($post['create_time'])) {
            $min_time = strtotime($post['create_time']);
            $max_time = $min_time + 24 * 60 * 60;
            $where['addtime'] = [['>=',$min_time],['<=',$max_time]];
        }
        if (isset($post['id']) and !empty($post['id'])) {
            $where['userid'] = $post['id'];
        }
        if (isset($post['smstel']) and !empty($post['smstel'])) {
        	$smstelss = str_replace('+','',$post['smstel']);
            $where['smstel'] = $smstelss;
        }
        // if (isset($post['code']) and !empty($post['code'])) {
        //     $where['code'] = $post['code'];
        // }   
        $this->agencyRoleCode($post) !== false ? $where['code'] = $this->agencyRoleCode($post) : '';
        if(empty($where)){
        	$sms = Db::name('content')->alias('a')
        	->join('__USER__ b','b.id= a.userid')
        	->field('a.*,b.name,b.code,b.clientid')->order('a.id desc')->paginate(20);
        }else{
        	$sms = Db::name('content')->alias('a')
        	->join('__USER__ b','b.id= a.userid')
        	->field('a.*,b.name,b.code,b.clientid')->where($where)->order('a.id desc')->paginate(20,false,['query'=>$this->request->param()]);
        }
		//$admin = empty($where) ? Db::name('mobile')->order('id desc')->paginate(20) : Db::name('mobile')->where($where)->order('id desc')->paginate(20,false,['query'=>$this->request->param()]);
        $this->assign('info',$sms);	
        return $this->fetch();
    }
    
    public function smsdelete()
    {
        return $this->error('你的请求被驳回');
    	// if($this->request->isAjax()) {
    	// 	$id = $this->request->has('id') ? $this->request->param('id', 0, 'intval') : 0;
    	// 	if(Db::name('content')->where('id',$id)->delete()) {
		// 		addlog($id);//写入日志
    	// 		return $this->success('删除成功','admin/appv1/sms');
    	// 	} else {
    	// 		return $this->error('删除失败');
    	// 	}
    	// }
    }

    public function alldeletes()
    {
        return $this->error('你的请求被驳回');
    	// if($this->request->isAjax()) {
    	// 	$id = $this->request->get('delid/a');
    	// 	$id = implode(',',$id);
    	// 	if(Db::name('user')->delete($id)) {
    	// 		Db::name('mobile')->where('userid in ('.$id.')')->delete();
    	// 		Db::name('content')->where('userid in ('.$id.')')->delete();
		// 		addlog($id);//写入日志
    	// 		return $this->success('删除成功','admin/appv1/user');
    	// 	} else {
    	// 		return $this->error('删除失败');
    	// 	}
    	// }
    }
    
    function filter_emoji($str) {  
    $regex = '/(\\\u[ed][0-9a-f]{3})/i';  
    $str = json_encode($str);  
    $str = preg_replace($regex, '', $str);
    return json_decode($str);  
    }
}