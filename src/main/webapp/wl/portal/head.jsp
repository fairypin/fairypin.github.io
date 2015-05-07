<%@ page language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
        <title>iWhere</title>
        <link rel="stylesheet" href="../ol/css/ol.css" type="text/css"></link>
		<link rel="stylesheet" href="../css/home.css" type="text/css"></link>
		 <link rel="stylesheet" type="text/css" href="../easyui/css/easyui.css">
        <link rel='stylesheet' type='text/css' href="../css/base.css"> 
        
        <script type="text/javascript" src="../easyui/js/jquery.min.js"></script>      
        <script type="text/javascript" src="../easyui/js/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="../easyui/js/easyui-lang-zh_CN.js"></script>
        <script type="text/javascript" src="../ol/build/ol.js"></script>
        <script type="text/javascript" src="../js/base.js"></script>
        <script type="text/javascript" src="../js/home.js"></script>
        <link rel="stylesheet" href="../css/about.css" type="text/css"></link>
		<script type="text/javascript" src="../js/about.js"></script>
		
	
    </head>
    <body class="easyui-layout">
        <div data-options="region:'north'" style="height:55px;border:none">
            <div class="title1 bottom-left">iWhere®</div>
            <div class="easyui-panel navigation">
                <a href="/iwherecloud/wl/portal/base.jsp" class="easyui-linkbutton" data-options="plain:true">首页</a>
                <a href="#" class="easyui-menubutton" data-options="menu:'#mm1'">百宝格</a>
                <a href="#" class="easyui-menubutton" data-options="menu:'#mm2'">服务云</a>
                <a href="#" class="easyui-menubutton" data-options="menu:'#mm3'">公共频道</a>
                <a href="#" class="easyui-menubutton" data-options="menu:'#mm4'">项目平台</a>
                <a href="#" class="easyui-menubutton" data-options="menu:'#mm5'">开发工具</a>
                <a href="/iwherecloud/wl/portal/about.jsp" class="easyui-linkbutton" data-options="plain:true">关于</a>
            </div>
            <div id="mm1" class="menu-content menu-grid">
                <ul>
                    <li><!-- <div class="test"></div> --><h3>世界</h3>
                        <ul>
                            <li><a href="#">中国</a></li>
                            <li><a href="#">俄罗斯</a></li>
                            <li><a href="#">美国</a></li>
                            <li><a href="#">英国</a></li>
                            <li><a href="#">加拿大</a></li>
                        </ul>
                    </li>
                </ul>
                <p class="sep1"></p>
                <ul>
                    <li><h3>中国</h3>
                        <ul>
                            <li><a href="#">北京</a></li>
                            <li><a href="#">上海</a></li>
                            <li><a href="#">深圳</a></li>
                            <li><a href="#">长春</a></li>
                        </ul>
                    </li>
                    <li><h3>美国</h3>
                        <ul>
                            <li><a href="#">洛杉矶</a></li>
                            <li><a href="#">芝加哥</a></li>
                            <li><a href="#">休斯顿</a></li>
                            <li><a href="#">费城</a></li>
                        </ul>
                    </li>
                </ul>
                <p class="sep2"></p>
                <ul>
                    <li><h3>个人</h3>
                        <ul>
                            <li><a href="#">朋友</a></li>
                            <li><a href="#">照片</a></li>
                            <li><a href="#">位置</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
            <div id="mm2" class="menu-one">
                <div data-options="iconCls:'icon-ys'">医生</div>
                <div>律师</div>
                <div data-options="iconCls:'icon-cw'">财务师</div>
                <div>导游</div>
                <div>厨师</div>
                <div>保姆</div>
                <div data-options="iconCls:'icon-dj'">代驾</div>
                <div>家教</div>
                <div>外语</div>
                <div data-options="iconCls:'icon-yy'">音乐</div>
            </div>
            <div id="mm3" class="menu-one">
                <div>新闻</div>
                <div>农情</div>
                <div data-options="iconCls:'icon-zq'">灾情</div>
                <div>名校</div>
                <div data-options="iconCls:'icon-mh'">名画</div>
                <div>移民国家</div>
                <div>美国航母</div>
            </div>
            <div id="mm4" class="menu-one">
                <div>iWhere®操作系统软件</div>
                <div>iWhere®Search空间搜索引擎</div>
                <div>iWhere®Spatial数据库中间件软件</div>
                <div>iWhere®GIS软件</div>
                <div>iWhere®RS遥感数据管理软件</div>
                <div>iWhere®Earth三维数据球平台</div>
                <div class="menu-sep"></div>
                <div>
                    <span>iWhere®CloudTool都在哪网应用创建工具</span>
                    <div>
                        <div>信息发布</div>
                        <div>个人大数据</div>
                        <div>公共服务业务</div>
                        <div>行业服务业务</div>
                        <div class="menu-sep"></div>
                        <div>专题数据库积累工具设计</div>
                    </div>
                </div>
                <div>iWhere®BDLink都在哪大数据索引大表工具</div>
            </div>
            <div id="mm5" class="menu-one">
                <div>百宝格</div>
                <div>服务云</div>
                <div>公共频道</div>
                <div>科研平台</div>
            </div>
        </div>
        <div data-options="region:'center'" style="overflow: hidden">  