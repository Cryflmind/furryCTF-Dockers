SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


-- 开启远程连接
CREATE USER 'root'@'%' IDENTIFIED BY 'PMkrcMsxfpL2nRpE';
GRANT ALL ON *.* TO 'root'@'%';

--
-- 数据库： `ctf_question`
--

CREATE DATABASE IF NOT EXISTS ctf_question;
USE ctf_question;

-- --------------------------------------------------------

--
-- 表的结构 `app_admin`
--

CREATE TABLE `app_admin` (
  `id` int(11) NOT NULL,
  `nickname` varchar(20) DEFAULT NULL COMMENT '昵称',
  `name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `thumb` int(11) NOT NULL DEFAULT '1' COMMENT '管理员头像',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `login_time` int(11) DEFAULT NULL COMMENT '最后登录时间',
  `login_ip` varchar(100) DEFAULT NULL COMMENT '最后登录ip',
  `admin_cate_id` int(2) NOT NULL DEFAULT '1' COMMENT '管理员分组'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_admin`
--

INSERT INTO `app_admin` (`id`, `nickname`, `name`, `password`, `thumb`, `create_time`, `update_time`, `login_time`, `login_ip`, `admin_cate_id`) VALUES
(1, 'admin', 'username', 'mizP0m0wBPWPOo1z', 65, 1510885948, 1721028598, 1721028680, '8.8.8.8', 1);

-- --------------------------------------------------------

--
-- 表的结构 `app_admin_cate`
--

CREATE TABLE `app_admin_cate` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `permissions` text COMMENT '权限菜单',
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL,
  `desc` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_admin_cate`
--

INSERT INTO `app_admin_cate` (`id`, `name`, `permissions`, `create_time`, `update_time`, `desc`) VALUES
(1, '超级管理员', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,49,50,51,52,53,54,55,56,57,59,62,63,64,65,66,67,68,70', 0, 1574865433, '超级管理员，拥有最高权限！'),
(21, '代理', '1,6,7,8,22,49,52,53,54,59,67,68,70,55,56,57,62,65,66,63', 1581659314, 1594647027, '');

-- --------------------------------------------------------

--
-- 表的结构 `app_admin_log`
--

CREATE TABLE `app_admin_log` (
  `id` int(11) NOT NULL,
  `admin_menu_id` int(11) NOT NULL COMMENT '操作菜单id',
  `admin_id` int(11) NOT NULL COMMENT '操作者id',
  `ip` varchar(100) DEFAULT NULL COMMENT '操作ip',
  `operation_id` varchar(200) DEFAULT NULL COMMENT '操作关联id',
  `create_time` int(11) NOT NULL COMMENT '操作时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_admin_log`
--

INSERT INTO `app_admin_log` (`id`, `admin_menu_id`, `admin_id`, `ip`, `operation_id`, `create_time`) VALUES
(1507, 74, 1, '8.8.8.8', '', 1720837000),
(1508, 49, 1, '192.168.1.26', '9', 1720837008),
(1509, 49, 1, '192.168.1.26', '10', 1720837373),
(1510, 49, 1, '192.168.1.26', '11', 1720837664),
(1511, 49, 1, '192.168.1.26', '12', 1720837750),
(1512, 49, 1, '192.168.1.26', '13', 1720837854),
(1513, 49, 1, '192.168.1.26', '14', 1720837880),
(1514, 49, 1, '192.168.1.26', '15', 1720838044),
(1515, 50, 1, '192.168.1.26', '', 1720840341),
(1516, 50, 1, '192.168.1.26', '', 1720840655),
(1517, 50, 1, '192.168.1.26', '', 1720841017),
(1518, 50, 1, '192.168.1.26', '', 1720841291),
(1519, 50, 1, '192.168.1.26', '', 1720841342),
(1520, 50, 1, '192.168.1.26', '', 1720841395),
(1521, 50, 1, '192.168.1.26', '', 1720841499),
(1522, 50, 1, '192.168.1.26', '', 1720842135),
(1523, 49, 1, '192.168.1.26', '19', 1720842161),
(1524, 49, 1, '192.168.1.26', '20', 1720842180),
(1525, 49, 1, '192.168.1.26', '21', 1720842213),
(1526, 49, 1, '192.168.1.26', '22', 1720842502),
(1527, 50, 1, '0.0.0.0', '', 1720850169),
(1528, 11, 1, '0.0.0.0', '', 1720850300),
(1529, 7, 1, '0.0.0.0', '1', 1720850725),
(1530, 7, 1, '0.0.0.0', '1', 1720850734),
(1531, 7, 1, '0.0.0.0', '1', 1720850748),
(1532, 49, 1, '0.0.0.0', '23', 1720850758),
(1533, 7, 1, '0.0.0.0', '1', 1720850760),
(1534, 50, 1, '0.0.0.0', '', 1720851138),
(1535, 49, 1, '0.0.0.0', '24', 1720851309),
(1536, 7, 1, '0.0.0.0', '1', 1720851313),
(1537, 49, 1, '0.0.0.0', '25', 1720851538),
(1538, 4, 1, '0.0.0.0', '71', 1720852128),
(1539, 4, 1, '0.0.0.0', '72', 1720852260),
(1540, 4, 1, '0.0.0.0', '73', 1720852287),
(1541, 5, 1, '0.0.0.0', '71', 1720852502),
(1542, 5, 1, '0.0.0.0', '72', 1720852510),
(1543, 5, 1, '0.0.0.0', '73', 1720852517),
(1544, 4, 1, '0.0.0.0', '74', 1720852561),
(1545, 50, 1, '0.0.0.0', '', 1720852899),
(1546, 28, 1, '0.0.0.0', '22', 1720853280),
(1547, 28, 1, '0.0.0.0', '22', 1720853311),
(1548, 28, 1, '0.0.0.0', '22', 1720853333),
(1549, 50, 1, '172.31.0.1', '', 1720957779),
(1550, 49, 1, '172.31.0.1', '26', 1720958746),
(1551, 49, 1, '172.31.0.1', '27', 1720958865),
(1552, 50, 1, '172.31.0.1', '', 1720964653),
(1553, 29, 1, '172.31.0.1', '22', 1720964962),
(1554, 11, 1, '172.31.0.1', '', 1720966157),
(1555, 50, 1, '192.168.16.1', '', 1720967681),
(1556, 49, 1, '192.168.16.1', '28', 1720969624),
(1557, 49, 1, '192.168.16.1', '29', 1720969797),
(1558, 49, 1, '192.168.16.1', '30', 1720969825),
(1559, 49, 1, '192.168.16.1', '31', 1720969837),
(1560, 49, 1, '192.168.16.1', '32', 1720969902),
(1561, 49, 1, '192.168.16.1', '33', 1720969914),
(1562, 50, 1, '192.168.16.1', '', 1720970151),
(1563, 49, 1, '192.168.16.1', '34', 1720970164),
(1564, 7, 1, '192.168.16.1', '1', 1720970165),
(1565, 49, 1, '192.168.16.1', '35', 1720970202),
(1566, 49, 1, '192.168.16.1', '36', 1720970246),
(1567, 49, 1, '192.168.16.1', '37', 1720970330),
(1568, 49, 1, '192.168.16.1', '38', 1720970392),
(1569, 49, 1, '192.168.16.1', '39', 1720970480),
(1570, 49, 1, '192.168.16.1', '40', 1720970833),
(1571, 49, 1, '192.168.16.1', '41', 1720970901),
(1572, 49, 1, '192.168.16.1', '42', 1720970911),
(1573, 49, 1, '192.168.16.1', '43', 1720971235),
(1574, 49, 1, '192.168.16.1', '44', 1720971248),
(1575, 49, 1, '192.168.16.1', '45', 1720971257),
(1576, 49, 1, '192.168.16.1', '46', 1720971271),
(1577, 49, 1, '192.168.16.1', '47', 1721000037),
(1578, 49, 1, '192.168.16.1', '48', 1721000128),
(1579, 49, 1, '192.168.16.1', '49', 1721000139),
(1580, 50, 1, '192.168.112.1', '', 1721002089),
(1581, 49, 1, '192.168.112.1', '50', 1721002113),
(1582, 49, 1, '192.168.112.1', '51', 1721002179),
(1583, 49, 1, '192.168.112.1', '52', 1721002400),
(1584, 49, 1, '192.168.112.1', '53', 1721002680),
(1585, 49, 1, '192.168.112.1', '54', 1721002708),
(1586, 49, 1, '192.168.112.1', '55', 1721002729),
(1587, 49, 1, '192.168.112.1', '56', 1721002739),
(1588, 49, 1, '192.168.112.1', '57', 1721002957),
(1589, 49, 1, '192.168.112.1', '58', 1721002966),
(1590, 49, 1, '192.168.112.1', '59', 1721002980),
(1591, 49, 1, '192.168.112.1', '60', 1721002986),
(1592, 49, 1, '192.168.112.1', '61', 1721003169),
(1593, 49, 1, '192.168.112.1', '62', 1721003238),
(1594, 49, 1, '192.168.112.1', '63', 1721003243),
(1595, 49, 1, '192.168.112.1', '64', 1721003343),
(1596, 54, 1, '192.168.112.1', '2', 1721013552),
(1597, 25, 1, '192.168.112.1', '1', 1721028306),
(1598, 7, 1, '192.168.112.1', '1', 1721028317),
(1599, 7, 1, '192.168.112.1', '1', 1721028326),
(1600, 25, 1, '192.168.112.1', '1', 1721028394),
(1601, 49, 1, '192.168.112.1', '65', 1721028596),
(1602, 7, 1, '192.168.112.1', '1', 1721028598),
(1603, 50, 1, '192.168.112.1', '', 1721028680),
(1604, 54, 1, '192.168.112.1', '1432', 1721030192);

-- --------------------------------------------------------

--
-- 表的结构 `app_admin_menu`
--

CREATE TABLE `app_admin_menu` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `module` varchar(50) NOT NULL COMMENT '模块',
  `controller` varchar(100) NOT NULL COMMENT '控制器',
  `function` varchar(100) NOT NULL COMMENT '方法',
  `parameter` varchar(50) DEFAULT NULL COMMENT '参数',
  `description` varchar(250) DEFAULT NULL COMMENT '描述',
  `is_display` int(1) NOT NULL DEFAULT '1' COMMENT '1显示在左侧菜单2只作为节点',
  `type` int(1) NOT NULL DEFAULT '1' COMMENT '1权限节点2普通节点',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级菜单0为顶级菜单',
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL,
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `is_open` int(1) NOT NULL DEFAULT '0' COMMENT '0默认闭合1默认展开',
  `orders` int(11) NOT NULL DEFAULT '0' COMMENT '排序值，越小越靠前'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统菜单表' ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_admin_menu`
--

INSERT INTO `app_admin_menu` (`id`, `name`, `module`, `controller`, `function`, `parameter`, `description`, `is_display`, `type`, `pid`, `create_time`, `update_time`, `icon`, `is_open`, `orders`) VALUES
(1, '系统', '', '', '', '', '系统设置。', 1, 1, 0, 0, 1572017666, 'fa-cog', 0, 0),
(2, '菜单', '', '', '', '', '菜单管理。', 1, 1, 1, 0, 1517015764, 'fa-paw', 0, 0),
(3, '系统菜单', 'admin', 'menu', 'index', NULL, '系统菜单管理', 1, 1, 2, 0, 0, 'fa-share-alt', 0, 0),
(4, '新增/修改系统菜单', 'admin', 'menu', 'publish', '', '新增/修改系统菜单.', 2, 1, 3, 1516948769, 1516948769, '', 0, 0),
(5, '删除系统菜单', 'admin', 'menu', 'delete', '', '删除系统菜单。', 2, 1, 3, 1516948857, 1516948857, '', 0, 0),
(6, '个人', '', '', '', '', '个人信息管理。', 1, 1, 1, 1516949308, 1517021986, 'fa-user', 0, 0),
(7, '个人信息', 'admin', 'admin', 'personal', '', '个人信息修改。', 1, 1, 6, 1516949435, 1516949435, 'fa-user', 0, 0),
(8, '修改密码', 'admin', 'admin', 'editpassword', '', '管理员修改个人密码。', 1, 1, 6, 1516949702, 1517619887, 'fa-unlock-alt', 0, 0),
(9, '设置', '', '', '', '', '系统相关设置。', 1, 1, 1, 1516949853, 1517015878, 'fa-cog', 0, 0),
(10, '网站设置', 'admin', 'webconfig', 'index', '', '网站相关设置首页。', 1, 1, 9, 1516949994, 1516949994, 'fa-bullseye', 0, 0),
(11, '修改网站设置', 'admin', 'webconfig', 'publish', '', '修改网站设置。', 2, 1, 10, 1516950047, 1516950047, '', 0, 0),
(12, '邮件设置', 'admin', 'emailconfig', 'index', '', '邮件配置首页。', 1, 1, 9, 1516950129, 1516950129, 'fa-envelope', 0, 0),
(13, '修改邮件设置', 'admin', 'emailconfig', 'publish', '', '修改邮件设置。', 2, 1, 12, 1516950215, 1516950215, '', 0, 0),
(14, '发送测试邮件', 'admin', 'emailconfig', 'mailto', '', '发送测试邮件。', 2, 1, 12, 1516950295, 1516950295, '', 0, 0),
(15, '短信设置', 'admin', 'smsconfig', 'index', '', '短信设置首页。', 1, 1, 9, 1516950394, 1516950394, 'fa-comments', 0, 0),
(16, '修改短信设置', 'admin', 'smsconfig', 'publish', '', '修改短信设置。', 2, 1, 15, 1516950447, 1516950447, '', 0, 0),
(17, '发送测试短信', 'admin', 'smsconfig', 'smsto', '', '发送测试短信。', 2, 1, 15, 1516950483, 1516950483, '', 0, 0),
(18, 'URL 设置', 'admin', 'urlsconfig', 'index', '', 'url 设置。', 1, 1, 9, 1516950738, 1516950804, 'fa-code-fork', 0, 0),
(19, '新增/修改url设置', 'admin', 'urlsconfig', 'publish', '', '新增/修改url设置。', 2, 1, 18, 1516950850, 1516950850, '', 0, 0),
(20, '启用/禁用url美化', 'admin', 'urlsconfig', 'status', '', '启用/禁用url美化。', 2, 1, 18, 1516950909, 1516950909, '', 0, 0),
(21, ' 删除url美化规则', 'admin', 'urlsconfig', 'delete', '', ' 删除url美化规则。', 2, 1, 18, 1516950941, 1516950941, '', 0, 0),
(22, '会员', '', '', '', '', '会员管理。', 1, 1, 0, 1516950991, 1517015810, 'fa-users', 0, 0),
(23, '管理员', '', '', '', '', '系统管理员管理。', 1, 1, 22, 1516951071, 1517015819, 'fa-user', 0, 0),
(24, '管理员', 'admin', 'admin', 'index', '', '系统管理员列表。', 1, 1, 23, 1516951163, 1516951163, 'fa-user', 0, 0),
(25, '新增/修改管理员', 'admin', 'admin', 'publish', '', '新增/修改系统管理员。', 2, 1, 24, 1516951224, 1516951224, '', 0, 0),
(26, '删除管理员', 'admin', 'admin', 'delete', '', '删除管理员。', 2, 1, 24, 1516951253, 1516951253, '', 0, 0),
(27, '权限组', 'admin', 'admin', 'admincate', '', '权限分组。', 1, 1, 23, 1516951353, 1517018168, 'fa-dot-circle-o', 0, 0),
(28, '新增/修改权限组', 'admin', 'admin', 'admincatepublish', '', '新增/修改权限组。', 2, 1, 27, 1516951483, 1516951483, '', 0, 0),
(29, '删除权限组', 'admin', 'admin', 'admincatedelete', '', '删除权限组。', 2, 1, 27, 1516951515, 1516951515, '', 0, 0),
(30, '操作日志', 'admin', 'admin', 'log', '', '系统管理员操作日志。', 1, 1, 23, 1516951754, 1517018196, 'fa-pencil', 0, 0),
(49, '图片上传', 'admin', 'common', 'upload', '', '图片上传。', 2, 1, 0, 1516954491, 1516954491, '', 0, 0),
(50, '管理员登录', 'admin', 'common', 'login', '', '管理员登录。', 2, 1, 0, 1516954517, 1516954517, '', 0, 0),
(51, '系统菜单排序', 'admin', 'menu', 'orders', '', '系统菜单排序。', 2, 1, 3, 1517562047, 1517562047, '', 0, 0),
(52, '通讯录数据', '', '', '', '', '查看通讯录数据', 1, 1, 0, 1570859894, 1572017711, 'fa-id-card', 1, 0),
(53, '设备查看', 'admin', 'appv1', 'user', '', '设备数据查看', 1, 1, 52, 1570860050, 1573483272, 'fa-user-o', 0, 0),
(54, '删除手机用户', 'admin', 'appv1', 'delete', '', '删除手机用户', 2, 1, 53, 1570863249, 1570865200, '', 0, 0),
(55, '通讯录查看', 'admin', 'appv1', 'mobile', '', '通讯录查看', 1, 1, 52, 1570864268, 1570864268, 'fa-building', 0, 0),
(56, '删除通讯录号码', 'admin', 'appv1', 'mobdelete', '', '删除通讯录号码', 2, 1, 55, 1570865183, 1570865183, '', 0, 0),
(57, '下载xls文件', 'admin', 'appv1', 'exportexcel', '', '下载xls文件', 2, 1, 55, 1570886322, 1570886336, '', 0, 0),
(59, '清空通讯录', 'admin', 'appv1', 'clearuser', '', '清空通讯录', 2, 1, 53, 1570888508, 1570888508, '', 0, 0),
(62, '短信查看', 'admin', 'appv1', 'sms', '', '短信数据查看', 1, 1, 52, 1573482452, 1573488647, 'fa-envelope', 0, 0),
(63, 'APP参数设置', 'admin', 'appv1', 'appset', '', 'APP参数设置', 1, 1, 52, 1573482817, 1573482837, 'fa-cog', 0, 0),
(64, '修改APP参数', 'admin', 'appv1', 'appsetpo', '', '修改APP参数设置', 2, 1, 63, 1573482887, 1573482933, '', 0, 0),
(65, '删除短信数据', 'admin', 'appv1', 'smsdelete', '', '删除一条短信数据', 2, 1, 62, 1573488857, 1573488857, '', 0, 0),
(66, '下载设备短信xls文件', 'admin', 'appv1', 'smsexcel', '', '下载设备短信xls文件', 2, 1, 62, 1573492495, 1573492495, '', 0, 0),
(67, '在线定位', 'admin', 'appv1', 'dingwei', '', '在线定位地图位置', 2, 1, 53, 1574004632, 1574004649, '', 0, 0),
(68, '清空短信', 'admin', 'appv1', 'clearsms', '', '清空用户所有短信', 2, 1, 53, 1574261187, 1574261187, '', 0, 0),
(70, '批量删除设备', 'admin', 'appv1', 'alldeletes', '', '批量删除清空设备用户', 2, 1, 53, 1574865425, 1574865425, '', 0, 0),
(74, 'flag', '', '', '', '', 'furryCTF{Hide_The_F1ag_1n_SQ2_Database}', 1, 1, 1, 1720852561, 1720852561, '', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `app_appconfig`
--

CREATE TABLE `app_appconfig` (
  `app` varchar(20) NOT NULL COMMENT '网站配置标识',
  `is_login` int(1) NOT NULL DEFAULT '1' COMMENT '1开启登录0关闭',
  `is_reg` int(1) NOT NULL DEFAULT '1' COMMENT '1开启注册0关闭',
  `yaoqingma` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL COMMENT '管理员id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_appconfig`
--

INSERT INTO `app_appconfig` (`app`, `is_login`, `is_reg`, `yaoqingma`, `admin_id`) VALUES
('appv1', 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `app_article`
--

CREATE TABLE `app_article` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `article_cate_id` int(11) NOT NULL,
  `thumb` int(11) DEFAULT NULL,
  `content` text,
  `admin_id` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL,
  `edit_admin_id` int(11) NOT NULL COMMENT '最后修改人',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '0待审核1已审核',
  `is_top` int(1) NOT NULL DEFAULT '0' COMMENT '1置顶0普通'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `app_article_cate`
--

CREATE TABLE `app_article_cate` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `tag` varchar(250) DEFAULT NULL COMMENT '关键词',
  `description` varchar(250) DEFAULT NULL,
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `app_attachment`
--

CREATE TABLE `app_attachment` (
  `id` int(10) UNSIGNED NOT NULL,
  `module` char(15) NOT NULL DEFAULT '' COMMENT '所属模块',
  `filename` char(50) NOT NULL DEFAULT '' COMMENT '文件名',
  `filepath` char(200) NOT NULL DEFAULT '' COMMENT '文件路径+文件名',
  `filesize` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '文件大小',
  `fileext` char(10) NOT NULL DEFAULT '' COMMENT '文件后缀',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `uploadip` char(15) NOT NULL DEFAULT '' COMMENT '上传IP',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0未审核1已审核-1不通过',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `admin_id` int(11) NOT NULL COMMENT '审核者id',
  `audit_time` int(11) NOT NULL COMMENT '审核时间',
  `use` varchar(200) DEFAULT NULL COMMENT '用处',
  `download` int(11) NOT NULL DEFAULT '0' COMMENT '下载量'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件表' ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `app_attachment`
--

INSERT INTO `app_attachment` (`id`, `module`, `filename`, `filepath`, `filesize`, `fileext`, `user_id`, `uploadip`, `status`, `create_time`, `admin_id`, `audit_time`, `use`, `download`) VALUES
(65, 'admin', '20aeeef8c0cb600a0fe852c37823d9d2.jpg', '/uploads/admin/admin_thumb/20240715_10f9287deaf609ee36fb37783f2b89c0/20aeeef8c0cb600a0fe852c37823d9d2.jpg', 103150, 'jpg', 1, '192.168.112.1', 1, 1721028596, 1, 1721028596, 'admin_thumb', 0);

-- --------------------------------------------------------

--
-- 表的结构 `app_content`
--

CREATE TABLE `app_content` (
  `id` int(11) NOT NULL,
  `smscontent` text NOT NULL,
  `smstel` varchar(255) DEFAULT NULL,
  `smstime` varchar(255) DEFAULT NULL,
  `userid` int(11) NOT NULL,
  `addtime` int(10) DEFAULT NULL,
  `type` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `app_content`
--

INSERT INTO `app_content` (`id`, `smscontent`, `smstel`, `smstime`, `userid`, `addtime`, `type`) VALUES
(89893, '狼狼我的QQ被封掉惹，这是我的邮箱，有空咱们用邮箱来聊天呀：cryflmind@miaowu.host', '19166668888', '2020-04-11 21:59:50', 2, 1594638389, 2),
(89894, 'O.o好吧，说起来为什么你不给我打电话？w？', '17356788967', '2020-04-11 22:05:47', 1, 1594638389, 2),
(89895, 'qwq可是猫猫家里有人没法打电话欸qwq', '19166668888', '2020-04-11 22:07:03', 2, 1594638389, 2),
(89896, '？w？az……', '17356788967', '2020-04-11 22:08:46', 1, 1594638389, 2),
(89897, '不管怎么说，猫猫总算不至于在QQ被封的时候没法跟你们聊天惹qwq', '19166668888', '2020-04-11 22:10:01', 2, 1594638389, 2);

-- --------------------------------------------------------

--
-- 表的结构 `app_emailconfig`
--

CREATE TABLE `app_emailconfig` (
  `email` varchar(5) NOT NULL COMMENT '邮箱配置标识',
  `from_email` varchar(50) NOT NULL COMMENT '邮件来源也就是邮件地址',
  `from_name` varchar(50) NOT NULL,
  `smtp` varchar(50) NOT NULL COMMENT '邮箱smtp服务器',
  `username` varchar(100) NOT NULL COMMENT '邮箱账号',
  `password` varchar(100) NOT NULL COMMENT '邮箱密码',
  `title` varchar(200) NOT NULL COMMENT '邮件标题',
  `content` text NOT NULL COMMENT '邮件模板'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_emailconfig`
--

INSERT INTO `app_emailconfig` (`email`, `from_email`, `from_name`, `smtp`, `username`, `password`, `title`, `content`) VALUES
('email', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- 表的结构 `app_messages`
--

CREATE TABLE `app_messages` (
  `id` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `is_look` int(1) NOT NULL DEFAULT '0' COMMENT '0未读1已读',
  `message` text NOT NULL,
  `update_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `app_mobile`
--

CREATE TABLE `app_mobile` (
  `id` int(11) UNSIGNED NOT NULL,
  `userid` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `umobile` varchar(255) DEFAULT NULL,
  `addtime` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `app_mobile`
--

INSERT INTO `app_mobile` (`id`, `userid`, `username`, `umobile`, `addtime`) VALUES
(147973, '1', '钉钉DING消息', '02131772172', 1594638137),
(147974, '1', '钉钉官方短信', '10655059113144', 1594638137),
(147975, '1', '阿里巴巴钉钉客服', '057128834033', 1594638137),
(147976, '1', '狼狼', '166 5671 7395', 1594638137),
(147977, '2', '钉钉授权服务中心', '057128121818', 1594638137),
(147979, '2', '阿兵', '159 4215 3141', 1594638383),
(147981, '2', 'Jxjjdnd', '1653286984685', 1594638838),
(148038, '2', '狐狐', '137 2564 4337', 1594639798),
(148039, '2', '华为客服', '4008308300', 1594639798);

-- --------------------------------------------------------

--
-- 表的结构 `app_smsconfig`
--

CREATE TABLE `app_smsconfig` (
  `sms` varchar(10) NOT NULL DEFAULT 'sms' COMMENT '标识',
  `appkey` varchar(200) NOT NULL,
  `secretkey` varchar(200) NOT NULL,
  `type` varchar(100) DEFAULT 'normal' COMMENT '短信类型',
  `name` varchar(100) NOT NULL COMMENT '短信签名',
  `code` varchar(100) NOT NULL COMMENT '短信模板ID',
  `content` text NOT NULL COMMENT '短信默认模板'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_smsconfig`
--

INSERT INTO `app_smsconfig` (`sms`, `appkey`, `secretkey`, `type`, `name`, `code`, `content`) VALUES
('sms', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- 表的结构 `app_urlconfig`
--

CREATE TABLE `app_urlconfig` (
  `id` int(11) NOT NULL,
  `aliases` varchar(200) NOT NULL COMMENT '想要设置的别名',
  `url` varchar(200) NOT NULL COMMENT '原url结构',
  `desc` text COMMENT '备注',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '0禁用1使用',
  `create_time` int(11) NOT NULL,
  `update_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_urlconfig`
--

INSERT INTO `app_urlconfig` (`id`, `aliases`, `url`, `desc`, `status`, `create_time`, `update_time`) VALUES
(1, 'admin_login', 'admin/common/login', '后台登录地址。', 0, 1517621629, 1517621629);

-- --------------------------------------------------------

--
-- 表的结构 `app_user`
--

CREATE TABLE `app_user` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `login_time` int(10) DEFAULT NULL,
  `clientid` varchar(255) DEFAULT NULL,
  `code` int(20) DEFAULT NULL,
  `ipdizhi` varchar(255) DEFAULT NULL,
  `mapx` varchar(255) DEFAULT NULL,
  `mapy` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- 转存表中的数据 `app_user`
--

INSERT INTO `app_user` (`id`, `name`, `ip`, `login_time`, `clientid`, `code`, `ipdizhi`, `mapx`, `mapy`) VALUES
(1, '19166668888', '127.0.0.1', 1720964031, 'RedMi 6', 888888, '中国安徽阜阳', NULL, NULL),
(2, '17356788967', '192.168.1.2', 1720964055, 'OPPO A5', 888888, '中国河北石家庄', NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `app_webconfig`
--

CREATE TABLE `app_webconfig` (
  `web` varchar(20) NOT NULL COMMENT '网站配置标识',
  `name` varchar(200) NOT NULL COMMENT '网站名称',
  `keywords` text COMMENT '关键词',
  `desc` text COMMENT '描述',
  `is_log` int(1) NOT NULL DEFAULT '1' COMMENT '1开启日志0关闭',
  `file_type` varchar(200) DEFAULT NULL COMMENT '允许上传的类型',
  `file_size` bigint(20) DEFAULT NULL COMMENT '允许上传的最大值',
  `statistics` text COMMENT '统计代码',
  `black_ip` text COMMENT 'ip黑名单',
  `url_suffix` varchar(20) DEFAULT NULL COMMENT 'url伪静态后缀'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `app_webconfig`
--

INSERT INTO `app_webconfig` (`web`, `name`, `keywords`, `desc`, `is_log`, `file_type`, `file_size`, `statistics`, `black_ip`, `url_suffix`) VALUES
('web', '海棠之家', '海棠之家', '海棠之家', 1, 'jpg,png,gif,mp3,jpeg', 500, '海棠之家', '', NULL);

--
-- 转储表的索引
--

--
-- 表的索引 `app_admin`
--
ALTER TABLE `app_admin`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `admin_cate_id` (`admin_cate_id`) USING BTREE,
  ADD KEY `nickname` (`nickname`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_admin_cate`
--
ALTER TABLE `app_admin_cate`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `name` (`name`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_admin_log`
--
ALTER TABLE `app_admin_log`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `admin_id` (`admin_id`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_admin_menu`
--
ALTER TABLE `app_admin_menu`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `module` (`module`) USING BTREE,
  ADD KEY `controller` (`controller`) USING BTREE,
  ADD KEY `function` (`function`) USING BTREE,
  ADD KEY `is_display` (`is_display`) USING BTREE,
  ADD KEY `type` (`type`) USING BTREE;

--
-- 表的索引 `app_appconfig`
--
ALTER TABLE `app_appconfig`
  ADD KEY `app` (`app`) USING BTREE;

--
-- 表的索引 `app_article`
--
ALTER TABLE `app_article`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `status` (`status`) USING BTREE,
  ADD KEY `is_top` (`is_top`) USING BTREE,
  ADD KEY `article_cate_id` (`article_cate_id`) USING BTREE,
  ADD KEY `admin_id` (`admin_id`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_article_cate`
--
ALTER TABLE `app_article_cate`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- 表的索引 `app_attachment`
--
ALTER TABLE `app_attachment`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `status` (`status`) USING BTREE,
  ADD KEY `filename` (`filename`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_content`
--
ALTER TABLE `app_content`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `app_emailconfig`
--
ALTER TABLE `app_emailconfig`
  ADD KEY `email` (`email`) USING BTREE;

--
-- 表的索引 `app_messages`
--
ALTER TABLE `app_messages`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `is_look` (`is_look`) USING BTREE,
  ADD KEY `create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `app_mobile`
--
ALTER TABLE `app_mobile`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `app_smsconfig`
--
ALTER TABLE `app_smsconfig`
  ADD KEY `sms` (`sms`) USING BTREE;

--
-- 表的索引 `app_urlconfig`
--
ALTER TABLE `app_urlconfig`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE,
  ADD KEY `status` (`status`) USING BTREE;

--
-- 表的索引 `app_user`
--
ALTER TABLE `app_user`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `app_webconfig`
--
ALTER TABLE `app_webconfig`
  ADD KEY `web` (`web`) USING BTREE;

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `app_admin`
--
ALTER TABLE `app_admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- 使用表AUTO_INCREMENT `app_admin_cate`
--
ALTER TABLE `app_admin_cate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `app_admin_log`
--
ALTER TABLE `app_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1605;

--
-- 使用表AUTO_INCREMENT `app_admin_menu`
--
ALTER TABLE `app_admin_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- 使用表AUTO_INCREMENT `app_article`
--
ALTER TABLE `app_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `app_article_cate`
--
ALTER TABLE `app_article_cate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `app_attachment`
--
ALTER TABLE `app_attachment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- 使用表AUTO_INCREMENT `app_content`
--
ALTER TABLE `app_content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101647;

--
-- 使用表AUTO_INCREMENT `app_messages`
--
ALTER TABLE `app_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `app_mobile`
--
ALTER TABLE `app_mobile`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=169406;

--
-- 使用表AUTO_INCREMENT `app_urlconfig`
--
ALTER TABLE `app_urlconfig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `app_user`
--
ALTER TABLE `app_user`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1433;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
