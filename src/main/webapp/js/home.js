$(document).ready(function(){
	
    /*
     * 地图数据
     */
    var osm = new ol.layer.Tile({
    	name:"index测试数据源",
        extent:[-180,-90,180,90],
	    source: new ol.source.TileWMS({
	      url: 'http://demo.boundlessgeo.com/geoserver/wms',
	      params: {
	        'LAYERS': 'ne:NE1_HR_LC_SR_W_DR'
	      }
	    })
	 });
    
	  var osm2 = new ol.layer.Vector({
		  name:"geoserver矢量数据源",
		  source: new ol.source.GeoJSON({
			  projection: 'EPSG:4326',
			  url: 'http://localhost:8080/geoserver/maptest_shp/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=maptest_shp:ZJregion&maxFeatures=3000&outputFormat=json'
		  })
	  });
	  
	  var osm3 = new ol.layer.Tile({
		  name:"geoserver栅格数据源",
		  extent:[118.11799537238385,24.52935941715673,118.13769719056566,24.54906123533855],
		  source: new ol.source.TileWMS({			  
			  url: 'http://localhost:8080/geoserver/maptest_shp/wms',
			  params: {
				  'layers': 'maptest_shp:plane'
			  }
		  })
	  });
    
    var i, ii;
    var arcgisstyles = [	
      'World_Imagery',
      'World_Physical_Map',
      'World_Shaded_Relief',
      'World_Street_Map',
      'World_Terrain_Base',
      'World_Topo_Map',
    ];
    var arcgislayers = [];    
    for (i = 0, ii = arcgisstyles.length; i < ii; ++i) {
      arcgislayers.push( new ol.layer.Tile({
          name: "ArcGIS: " + arcgisstyles[i],
          visible: false,
          source: new ol.source.XYZ({                 
                url: 'http://server.arcgisonline.com/ArcGIS/rest/services/' +
                    arcgisstyles[i] + '/MapServer/tile/{z}/{y}/{x}',
                wrapX: false
            })
        }));
    }
    
    var bingstyles = [
      'Road',
      'Aerial',
      'AerialWithLabels',
      // 'collinsBart',
      // 'ordnanceSurvey'
    ];
    var binglayers = [];    
    for (i = 0, ii = bingstyles.length; i < ii; ++i) {
      binglayers.push(new ol.layer.Tile({
        name: "BingMap: " + bingstyles[i],
        visible: false,
        preload: Infinity,
        source: new ol.source.BingMaps({
            key: 'Ak-dzM4wZjSqTlzveKz5u0d4IQ4bRzVI309GxmkgSVr1ewS6iPSrOvOKhA-CJlm3',
            imagerySet: bingstyles[i]
            // use maxZoom 19 to see stretched tiles instead of the BingMaps
            // "no photos at this zoom level" tiles
            // maxZoom: 19
        })
      }));
    }
    
    var stamenstyles = [
        "watercolor",
        'terrain-labels',
        'toner',
    ]
    var stamenlayers = [];    
    for (i = 0, ii = stamenstyles.length; i < ii; ++i) {
      stamenlayers.push( new ol.layer.Tile({
          name: "StamenMap: " + stamenstyles[i],
          visible: false,
          source: new ol.source.Stamen({
                layer: stamenstyles[i]
          })
        }));
    }
    
    var styles = {
  		  'Polygon': [new ol.style.Style({
  		    stroke: new ol.style.Stroke({
  		      color: 'gray',
  		      /* lineDash: [4], */
  		      width: 0.5
  		    }),
  		    fill: new ol.style.Fill({
  		      color: 'rgba(0, 0, 255, 0.0)'
  		    })
  		  })]
  		};
	
	
	var styleFunction = function(feature, resolution) {
	  return styles[feature.getGeometry().getType()];
	};				
		
    /*
     * 基础控件
     */ 
    var mousePositionControl = new ol.control.MousePosition({
        coordinateFormat: ol.coordinate.createStringXY(4),
        projection: 'EPSG:4326',
        // comment the following two lines to have the mouse position
        // be placed within the map.
        className: 'custom-mouse-position',
        target: document.getElementById('mouse-position'),
        undefinedHTML: '&nbsp;'
    }); 
    var zoomslider = new ol.control.ZoomSlider(); 
    var scaleLine = new ol.control.ScaleLine({
          units: 'metric'
    });
    
    
    /*
     * 层级控件
    */
    var DIFF = 3;//网格层级 = 地图层级+DIFF
    window.app = {};
    var app = window.app;
    app.geosotLayerControl = function (opt_options) {
        var options = opt_options || {};
        
        var span = document.createElement('span');
        span.id = "geosot-layer";
        var zoomlevel = map.getView().getZoom();
        span.innerHTML = "网格层级：" + (zoomlevel + DIFF);
      
        var element = document.createElement('div');
        element.className = 'geosot-layer';
        element.appendChild(span);
        
        ol.control.Control.call(this, {
            element: element,
            target: options.target
        });
    };
    ol.inherits(app.geosotLayerControl, ol.control.Control);
   
   
   /*
    * 创建地图
    */
    var map = new ol.Map({
        target: 'map',
        layers: [
            new ol.layer.Group({
                name: "基础底图数据",
                //layers: [osm].concat(arcgislayers).concat(binglayers).concat(stamenlayers)
                layers: [osm].concat(osm2).concat(osm3)
            }),
        ],
        view: new ol.View({
            // center: ol.proj.transform([117.194, 39.120], 'EPSG:4326', 'EPSG:3857'),
            projection:'EPSG:4326',
            //center: ol.proj.transform([80, 20], 'EPSG:4326', 'EPSG:3857'),
            
//            center:[80, 20],
//            zoom: 3,
//            minZoom: 2,
//            maxZoom: 19            
            center:[118.12, 24.53],//my raster
            zoom: 10,
            minZoom: 2,
            maxZoom: 19
        }),
        //logo:false,
        controls: ol.control.defaults({
                attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
                collapsible: false
            })
        }).extend([mousePositionControl, zoomslider, scaleLine,
            new ol.control.ZoomToExtent({
              extent: [
                -2.0037507067161843E7, -1.997186888040859E7,
                2.0037507067161843E7, 1.9971868880408563E7
              ]
            })
        ])
    });       
    
    var vectorLayer = new ol.layer.Vector({
    	name:"GeoSOT网格",
    	style: styleFunction
	});
    map.addLayer(vectorLayer);
    
    var DIFF = 3;
    map.getView().on('change:resolution', function() {
    	var zoomlevel = map.getView().getZoom();
    	$("#geosot-layer").html("网格层级:"+ (zoomlevel + DIFF));
    });
    map.addControl(new app.geosotLayerControl());
    
     /*
     * 捕捉地图显示变化的事件，鼠标弹起时传回当前可见区域的经纬度范围、层级（分辨率），传回后台
     * 后台根据传回的经纬度范围，计算当前需要显示的网格集合，生成geojson文件，传回前端
     */
//    var gridLayer = new ol.layer.Vector({
//        name: "GeoSOT网格",
//        style: new ol.style.Style({
//            stroke: new ol.style.Stroke({
//              color: 'black',
//              width: 0.5
//            })
//          })
//    });
//    map.addLayer(gridLayer);
    
    var friend_styleCache = [];
    var friend_styleFunc =  function(feature, resolution) {
            var text = resolution < 80000 ? feature.getProperties().total : '';
            if ((!friend_styleCache[text])) {
                friend_styleCache[text] = [new ol.style.Style({
                     stroke: new ol.style.Stroke({
                      color: "black",
                      width: 1
                    }),
                     fill: new ol.style.Fill({
                      color: 'rgba(253,141,60,0.7)'
                    }),
                    text : new ol.style.Text({
                        font : '16px Calibri,sans-serif',
                        text : text,
                        fill : new ol.style.Fill({
                            color : '#000'
                        }),
                        stroke : new ol.style.Stroke({
                            color : '#fff',
                            width : 4
                        })
                    }),
                    zIndex : 999
                })];
            }
            return friend_styleCache[text];
    }
    var friendLayer = new ol.layer.Vector({
        name: "好友分布",
        visible: false,
        style: friend_styleFunc
    });
    map.addLayer(friendLayer);
    
    var news_styleCache = [];
    var news_styleFunc =  function(feature, resolution) {
            var data = feature.getProperties().data;
            var s = '';
            data.forEach(function(value){
                    if (s != '') 
                        s += ';';
                    s = s + value['title'];
                })
            var text = resolution < 80000 ? s.substring(0, 20) + '...': '';
            if ((!news_styleCache[text])) {
                news_styleCache[text] = [new ol.style.Style({
                     stroke: new ol.style.Stroke({
                      color: "black",
                      width: 1
                    }),
                     fill: new ol.style.Fill({
                      color: 'rgba(53,141,60,0.7)'
                    }),
                    text : new ol.style.Text({
                        font : '8px Calibri,sans-serif',
                        text : text,
                        fill : new ol.style.Fill({
                            color : '#000'
                        }),
                        stroke : new ol.style.Stroke({
                            color : '#fff',
                            width : 4
                        })
                    }),
                    zIndex : 999
                })];
            }
            return news_styleCache[text];
    }
    var newsLayer = new ol.layer.Vector({
        name: "新闻",
        visible: false,
        style: news_styleFunc
    });
    map.addLayer(newsLayer);
    
    function wrapLon(value) {
      // var worlds = Math.floor((value + 180) / 360);
      // return value - (worlds * 360);
      var value;
      if(value>180)
        value = 180;
      else if(value<-180)
        value = -180;
      return value;
    }
    
    map.on('moveend', function(){
    	var zoom = map.getView().getZoom();
    	var extent = map.getView().calculateExtent(map.getSize()); 
    	//var extent = osm.getExtent();     
    	//alert(extent);
    	var leftTop = ol.extent.getTopLeft(extent);
    	var rightBottom = ol.extent.getBottomRight(extent);
    	//alert(leftTop+","+rightBottom);
    	$.ajax({type:"post",
	 			url:"getGrids.action",
    	 		data:{
    	 			"leftupLon":leftTop[0],
    	 			"leftupLat":leftTop[1],
    	  			"rightdownLon":rightBottom[0],
    	 			"rightdownLat":rightBottom[1],
    	 			"layerint":map.getView().getZoom() + 3
    	 		},
	 			dataType:"json",
    			success:function(data){
    				//alert(data);
					var json = eval('(' + data + ')'); 
    				vectorSource = new ol.source.GeoJSON(({'object': json}));
    				vectorLayer.setSource(vectorSource);
    			}

    	});

    });    
   
    //交互：点击事件
    var select = new ol.interaction.Select({
    	layers:[vectorLayer],
    	style: new ol.style.Style({
    		stroke: new ol.style.Stroke({
    			color: 'orange',
    			width: 3
    		})
    	})
    });
    map.addInteraction(select);
    var vectorSource;   
    //右侧折叠工具栏
    $("#map-tab").tabs({
        width:450,
        height:$("#map").height()-30,
        onSelect: function(title,index){
               $("#map-tab").width(450);
        }
    });
    $('#tab-collapse-btn').bind('click', function(){
        if($("#map-tab").width()==80) {
            $("#map-tab").width(450);
            $('#tab-collapse-btn').linkbutton({
                iconCls: 'icon-arrow-right'
            });
        }            
        else {
            $("#map-tab").width(80);
            $('#tab-collapse-btn').linkbutton({
                iconCls: 'icon-arrow-left'
            });
        }
    }); 
    setTimeout(function() {
        $("#map-tab").width(80);
        $("#resultTbl").datagrid({
            height:$("#map").height()-85
        });
    }, 200); 
    
    //随着窗口的放大缩小，重置地图和右侧折叠工具栏，需要设置延迟
    window.onresize = function()
    {
        setTimeout(function() {
           map.updateSize();
           }, 200);
        setTimeout(function() {
           $("#map-tab").tabs({
                height:$("#map").height()-30
            });
           $("#resultTbl").datagrid({
                height:$("#map").height()-85
            });
           }, 300);
    };
    
    //拉框选择网格
    var dragBox;
    dragBox = new ol.interaction.DragBox({
        condition: ol.events.condition.shiftKeyOnly,
        style: new ol.style.Style({
        	stroke: new ol.style.Stroke({
        		color: 'yellow',
        		width: 3
        	}),
        	fill: new ol.style.Fill({
        		color:'rgba(255,255,255,0.3)'
        	})
        })
    });
//    $("#dragbox-query").click(function(){
//        map.addInteraction(dragBox);
//    });    
    map.addInteraction(dragBox);
    
    dragBox.on('boxstart', function(e) {
        selectedFeatures.clear();
    });
    
    var selectedFeatures = select.getFeatures();
    dragBox.on('boxend', function(e) {
		  // features that intersect the box are added to the collection of
		  // selected features, and their names are displayed in the "info"
		  // div
		  var info = [];
		  var extent = dragBox.getGeometry().getExtent();
		  vectorSource.forEachFeatureIntersectingExtent(extent, function(feature) {    
			  var selectedFeatures = [];
			  selectedFeatures.push(feature);
			  info.push(feature.get('id'));
			  alert(feature.get('name'));
			  
			  var fstyle = new ol.style.Style({
				  stroke: new ol.style.Stroke({
					  color: 'black',
					  /* lineDash: [4], */
					  width: 0.5
				  }),
				  fill: new ol.style.Fill({
					  color: 'rgba(0, 0, 255, 0.5)'
				  })
			  });
			  feature.setStyle(fstyle);    
		    //feature。setStyle(null);
		  });
		  
		  if (info.length > 0) {
		    alert('网格数='+info.length);
		  }
		  
		});

 
    
    /*
     * 网格数据 
     */
    columns = [[
        {field:'name',      title:'名字',     width:'100',align:'left'},
        {field:'addr',      title:'地址',     width:'100', align:'left'},
        {field:'phone',     title:'手机',     width:'70', align:'left'},
        {field:'tel',       title:'电话',     width:'50', align:'left'},
        {field:'geocode',   title:'编码',     hidden:'true'},
    ]];
    var comOption = {
            method:'GET',
            columns:columns,
            autoRowHeight: true,
            singleSelect:true,
            rownumbers : true,
            pagination: true,
            pagePosition:'bottom',
            pageSize: 15, 
            pageList: [15, 25, 50, 100, 200]
    };
 	
   $("#query-btn").click(function(){
       $("#resultTbl").datagrid($.extend({}, comOption, {
            url:"query/geocodes/",
            queryParams: {
                geocodes: function(){
                    length = selectedFeatures.getLength();
                    s='';
                    for(i=0; i<length; i++) {
                        if (s != '') 
                            s += ';';
                        s += selectedFeatures.item(i).getId();
                    };
                    return s;
                }
            }       
        }));
    });
    $("#query-btn").click();
    

    /**
     * Popup
     */
    var container = document.getElementById('popup');
    var content = document.getElementById('popup-content');
    var closer = document.getElementById('popup-closer');
    closer.onclick = function() {
        container.style.display = 'none';
        closer.blur();
        return false;
    };
    
    var popup = new ol.Overlay({
        element: container
    });
    map.addOverlay(popup);
    
   /*
     * 图层管理 
     */
    //生成html                    
    function createLayerControl(layerNo, layer) {
        var li, visibleLabel;
        li = $("<li></li>").attr("id", "layer" + layerNo); 
        visibleLabel = $("<label class='checkbox'></label>").attr("for", "visible" + layerNo);
        visibleLabel.append($('<input class="visible" type="checkbox"/>').attr("id", "visible" + layerNo));
        visibleLabel.append(layer.get("name"));
        li.append(visibleLabel);
        return li;
    }
    var layertree = $("#layertree");
    var ul = $("<ul></ul>");
    map.getLayers().forEach(function(layer, i) {      
        li = createLayerControl(i, layer);        
        if (layer instanceof ol.layer.Group) {
            subul = $("<ul></ul>");
            layer.getLayers().forEach(function(sublayer, j) {
                subul.append(createLayerControl(''+i+j ,sublayer));
            });
            li.append(subul);
        }
        ul.append(li);
    });
    layertree.append(ul);
    //绑定
    function bindInputs(layerid, layer) {
      new ol.dom.Input($(layerid + ' .visible')[0])
          .bindTo('checked', layer, 'visible');
    }
    map.getLayers().forEach(function(layer, i) {
      bindInputs('#layer' + i, layer);
      if (layer instanceof ol.layer.Group) {
        layer.getLayers().forEach(function(sublayer, j) {
          bindInputs('#layer' + i + j, sublayer);
        });
      }
    });
    // $('#layertree li > label').click(function() {
       // $(this).siblings('ul').toggle();
    // }).siblings('ul').hide();


    /*
     * 数据编辑
     */
    $("#edit-layers").combobox({
        textField: 'name',
        valueField: 'value',
        data: [{
            name: '新闻',
            value: 'newsLayer'
        }]
    });
    $("#edit-layers").combobox("setValue","newsLayer");
    var edit = false;
    var editlayer = "";
    $("#edit-btn").click(function(){
        if(edit) {
            edit = false;    
            $("#edit-btn").linkbutton({
                text: "开始编辑",
                iconCls: 'icon-edit'
            });
            $("#edit-tooltip").html("编辑图层结束");
            $(document).bind('contextmenu',function(e){
                $('#map-rightmenu').menu('hide');
            });
        }
        else{
            editlayer = $("#edit-layers").combobox("getValue");
            var comboData = $("#edit-layers").combobox("getData");
            var editlayers = [];
            comboData.forEach(function(v){editlayers.push(v['value'])});
            if(editlayers.indexOf(editlayer) == -1){
                $("#edit-tooltip").html("图层不存在，请重新选择！");
                return;
            }  
                          
            edit = true;    
            $("#edit-btn").linkbutton({
                text: "结束编辑",
                iconCls: 'icon-close'
            });
            $("#edit-tooltip").html("正在编辑图层："+ $("#edit-layers").combobox("getText"));
            $(document).bind('contextmenu',function(e){
                e.preventDefault();
                $('#map-rightmenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            });            
        }
    });
    //js时间格式
    function DateFormat(date, format) {
        if(format === undefined){
            format = date;
            date = new Date();
        }
        var map = {
            "M": date.getMonth() + 1, //月份 
            "d": date.getDate(), //日 
            "h": date.getHours(), //小时 
            "m": date.getMinutes(), //分 
            "s": date.getSeconds(), //秒 
            "q": Math.floor((date.getMonth() + 3) / 3), //季度 
            "S": date.getMilliseconds() //毫秒 
        };
        format = format.replace(/([yMdhmsqS])+/g, function(all, t){
            var v = map[t];
            if(v !== undefined){
                if(all.length > 1){
                    v = '0' + v;
                    v = v.substr(v.length-2);
                }
                return v;
            }
            else if(t === 'y'){
                return (date.getFullYear() + '').substr(4 - all.length);
            }
            return all;
        });
        return format;
    }
    $("#map-rightmenu-add").click(function(){
        length = selectedFeatures.getLength();
        if(length==0) {
            alert("请在图层管理中打开GeoSOT网格图层并选择一个网格!");
            return;
        }
        if(length>1) {
            alert("只能选择一个网格!");
            return;
        }
        if(editlayer=="newsLayer") {
            $.ajax({
               url: "newsLayer/addform/",
               type: "GET",
               success: function(data, textStatus) {
                   $('#addTbl').html(data);
                   $('#map-dlg').dialog('setTitle',"添加新闻");
                   //补上默认
                   $("#id_publish_time").val(DateFormat(new Date(), 'yyyy-MM-dd hh:mm:ss'));
                   $("#id_geocode").val(selectedFeatures.item(0).getId());
                   
                   $('#map-dlg').dialog('open');
               },
               error: function(){
                   alert("error");
               }
            });
        }
    });
    $("#submit-btn").click(function(){
        formdata = {};
        $("#addTbl input").toArray().forEach(function(v){formdata[v.id.substring(3)] = v.value});
        if(editlayer=="newsLayer") {
            $.ajax({
               url: "newsLayer/postform/",
               type: "POST",
               data: {form:JSON.stringify(formdata)},
               success: function(data, textStatus) {
                  if(data['status'] == "success"){
                      $('#map-dlg').dialog('close');
                      alert("添加成功！");
                  }
                  else {
                      $('#addTbl').html(data['form']);
                  }                  
               },
               error: function(){
                   alert("error");
               }
            });
        }
    });
    
    /*
     * 鼠标左击事件处理
     */
     map.on('click', function(evt) {
        //好友分布popup
        var coordinate = evt.coordinate;
        var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
            coordinate, 'EPSG:3857', 'EPSG:4326'));
    
        popup.setPosition(coordinate);
        container.style.display = 'none';
        
        var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
            if(layer.get("name") == "好友分布")
                if(layer.getVisible())
                    return feature;            
        });
        if(feature) {
            data = feature.getProperties().data;
            s = '';
            data.forEach(function(value){s = s + "<li>" + value['name'] + "</li>";})
            content.innerHTML = '<ul>' + s + '在这里!</ul>';
            container.style.display = 'block'; 
        }
        
        
        var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
            if(layer.get("name") == "新闻")
                if(layer.getVisible())
                    return feature;    
        });
        if(feature) {
            data = feature.getProperties().data;
            s = '';
            data.forEach(function(value){s = s + "<li><a href='" +value['source_url'] +"' target='_blank'>" +value['title'] + "</a></li>";})
            content.innerHTML = '<ul>' + s + '</ul>';
            container.style.display = 'block'; 
        }
           
    });
    
    
            
            
});