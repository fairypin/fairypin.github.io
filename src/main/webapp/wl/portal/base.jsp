<%@ page language="java" pageEncoding="utf-8" %>
<%@ include file="head.jsp" %>


 	<div id="map">
        <div id="popup" class="ol-popup">
            <a href="#" id="popup-closer" class="ol-popup-closer"></a>
            <div id="popup-content"></div>
        </div>
    </div>
    <div id="map-rightmenu" class="easyui-menu" style="width:120px;">
        <div data-options="iconCls:'icon-add'" id="map-rightmenu-add" >添加</div>
        <!-- <div data-options="iconCls:'icon-scan'" onclick="javascript:alert('scan')">浏览</div> -->
        <!-- <div class="menu-sep"></div>
        <div>Exit</div> -->
    </div>
    <div id="map-dlg" class="easyui-dialog" title="添加" data-options="iconCls:'icon-add',closed:true,"
         style="width:450px;height:auto;padding:10px">
        <table id="addTbl" >    
        </table>
        <a href="#" id="submit-btn" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="float:right;">提交</a>
    </div>
    <div id="map-tab" class="easyui-tabs" data-options="tools:'#tab-tools',tabPosition:'left',headerWidth:80,tabWidth:80,tabHeight:30" style="position: absolute; top:0px;right:0px;">
        <div title="图层管理" style="padding:5px;">
            <div id="layertree">
              
            </div>
        </div>
        <div title="数据编辑" style="padding:5px;">
            <table style="width:100%; padding:5px;">
                <tr>
                    <td>编辑图层：</td>
                    <td>
                        <select class="easyui-combobox" id="edit-layers" style="width:150px;">
                        </select>
                    </td>
                    <td><a href="#" id="edit-btn" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" >开始编辑</a></td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="2" id="edit-tooltip"></td>
                </tr>
            </table>
            <table>{{form.as_table}}</table>
        </div>
        <div title="网格查询" style="overflow:auto;padding:5px;">
            <div class="top-center">
                <a id="dragbox-query" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-rectselect'" style="width:80px;">拉框选择</a> 
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href="#" id="query-btn" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a> 
            </div>
            <table id="resultTbl" style="width:auto;height:500px">
            </table>  
        </div>
    </div>
    <div id="tab-tools"> 
        <a href="javascript:void(0)" id="tab-collapse-btn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-arrow-right'"></a>
    </div>  

<%@ include file="foot.jsp" %>
