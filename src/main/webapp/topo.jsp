<!doctype html>
<%@ page language="java" pageEncoding="utf-8" %>
<html>
  <head>
    <link rel="stylesheet" href="js/openlayers3/css/ol.css" type="text/css">
    <link rel="stylesheet" href="css/main.css" type="text/css"></link>
	<link rel="stylesheet" href="css/home.css" type="text/css"></link>
	<link rel="stylesheet" type="text/css" href="easyui/css/easyui.css">
    <link rel='stylesheet' type='text/css' href="css/base.css"> 
           
    <script type="text/javascript" src="js/openlayers3/script/ol.js"></script>
    <script type="text/javascript" src="js/jqueryEasyUI/script/jquery.min.js"></script>
    <script type="text/javascript" src="js/jqueryEasyUI/script/jquery.easyui.min.js"></script>    
    <script type="text/javascript" src="easyui/js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
   	$(document).ready(function(){
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
		
		 
		var iconStyle = new ol.style.Style({
		  image: new ol.style.Icon(({
		     anchorOrigin:'bottom-right',
		    anchor: [0.5, 46],
		    anchorXUnits: 'fraction',
		    anchorYUnits: 'pixels',
		    opacity: 0.75,
		    src: '../img/icon.png'
		  }))
		});
		
		var iconFeature = new ol.Feature({
		  geometry: new ol.geom.Point([108, 25]),
		  name: 'Null Island',
		  population: 4000,
		  rainfall: 500
		});
		
		iconFeature.setStyle(iconStyle);
		
		
		var styleFunction = function(feature, resolution) {
		  return styles[feature.getGeometry().getType()];
		};
				
		
	
 		var raster = new ol.layer.Tile({
	    	name:"4326栅格源",
	        extent:[-180,-90,180,90],
		    source: new ol.source.TileWMS({
		      url: 'http://demo.boundlessgeo.com/geoserver/wms',
		      params: {
		        'LAYERS': 'ne:ne'//'ne:NE1_HR_LC_SR_W_DR'
		      }
		    })
	 	});	
	 	
	 	var zhejiangArea = new ol.layer.Vector({
		  name:"浙江面矢量",
		  source: new ol.source.GeoJSON({
			  projection: 'EPSG:4326',
			  url: 'http://localhost:8080/geoserver/maptest_shp/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=maptest_shp:zhejiang_area&maxFeatures=3000&outputFormat=json'
		  })
	  	});	 	
	  	
	  	var beijingLines = 	new ol.layer.Vector({
		  name:"北京线矢量",
		  source: new ol.source.GeoJSON({
			  projection: 'EPSG:4326',
			  url: 'http://localhost:8080/geoserver/maptest_shp/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=maptest_shp:Beijing_Lines&maxFeatures=5000&outputFormat=json'
		  })
	  	});	 	
	   	    
	   	var zhengzhouArea = new ol.layer.Vector({
		  name:"郑州面矢量",
		  source: new ol.source.GeoJSON({
			  projection: 'EPSG:4326',
			  url: 'http://localhost:8080/geoserver/maptest_shp/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=maptest_shp:ZhengZhou_Areas&maxFeatures=3000&outputFormat=json'
		  })
	  	});	 	
	  	
	  	
	    //鼠标单击坐标显示
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
	    
	    var map = new ol.Map({
	        target: 'map',
	        layers: [
	            new ol.layer.Group({
	                name: "基础底图数据",
	                layers: [raster,zhejiangArea,beijingLines, zhengzhouArea]
	            }),
	        ],
	        view: new ol.View({
	            projection:'EPSG:4326',
	            center:[120, 29],//浙江
	            //center:[115.9,39.7],//北京
	            zoom: 8,//和oldlevel一起变
	            minZoom: 2,
	            maxZoom: 27
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
	    
	    //网格层	    
    	var vectorSource;
    	
	    var vectorLayer = new ol.layer.Vector({
		  /* source: vectorSource, */
		  style: styleFunction
		});
		map.addLayer(vectorLayer);
				
// 		var resultSource = new ol.source.Vector({
// 		  features: [iconFeature]		  
// 		});
		
		//高亮表达网格层
		var resultLayer = new ol.layer.Vector({
		  //source: resultSource
		  style: new ol.style.Style({
			    stroke: new ol.style.Stroke({
			      	color: 'red',			      
		       	  	lineDash: [5,5], 
			      	width: 2
			    }),
			    fill: new ol.style.Fill({
			    	color: 'rgba(100, 0, 0, 0.5)'
			    })
		  	})
		}); 		
		map.addLayer(resultLayer);  
		
		//备注网格层，用于显示中间结果
		var errorLayer = new ol.layer.Vector({
		  	style: new ol.style.Style({
			    stroke: new ol.style.Stroke({
			      	color: 'green',			      
		       	  	lineDash: [5,5], 
			      	width: 2
			    })
		  	})
		}); 		
		map.addLayer(errorLayer);  
		  
		
	    //添加层级控件
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
	    map.addControl(new app.geosotLayerControl());
	    	    	    
	    //更新网格层级	   
	  // var selectedSets = new Array();
	   var gridLayer = oldLevel;
	    var oldLevel=8+DIFF;
	    
		map.getView().on('change:resolution', function() {
	        var zoomlevel = map.getView().getZoom();
	        gridLayer = zoomlevel + DIFF;
	        $("#geosot-layer").html("网格层级："+ gridLayer);
	        
	        //必要的更新，否则会在上一次的层级上表达
	       var extent = map.getView().calculateExtent(map.getSize());
        	var leftTop = ol.extent.getTopLeft(extent);
        	var rightBottom = ol.extent.getBottomRight(extent);
        	$.ajax({type:"post",
    	 			url:"getGrids.action",
	    	 		data:{
	    	 			"leftupLon":leftTop[0],
	    	 			"leftupLat":leftTop[1],
	    	  			"rightdownLon":rightBottom[0],
	    	 			"rightdownLat":rightBottom[1],
	    	 			"layerint": map.getView().getZoom() + DIFF
	    	 		},
    	 			dataType:"json",
        			success:function(data){
						var json = eval('(' + data + ')'); 
        				vectorSource = new ol.source.GeoJSON(({'object': json}));
        				vectorLayer.setSource(vectorSource);        				
        			}
        	});
        	//以网格集表示
        	//description(false);
        /* 
	       selectedSets.length=0;//清空数组        	  	
	        var selected = selectedSets;//显示选择的网格
	       var params = selected.join(",");
	        //执行函数ScaleAction	        	        
        	$.ajax({type:"post",
    	 			url:"changeScale.action",
	    	 		data:{
	    	 			"input":params,
	    	 			"oldlevel": oldLevel,
	    	 			"newlevel": gridLayer
	    	 		},
    	 			dataType:"json",
        			success:function(data){
						var json = eval('(' + data + ')'); 
        				resultSource = new ol.source.GeoJSON(({'object': json}));
        				resultLayer.setSource(resultSource);//在java有bug
        			}
        	});
        	oldLevel = map.getView().getZoom() + DIFF;  */ 
	    });
	    
	    var getRandomColor = function(){  
	      return '#'+Math.floor(Math.random()*16777215).toString(16);  
	    };
	    
	    var thiscolor = getRandomColor();
	    
	    //15.4.30 从feature Id 算出颜色
	    function colorById(id){
	    	return '#'+Math.floor(id*16777215).toString(16);  
	    }
	    
	    //单选网格 
		var select = new ol.interaction.Select({
	        layers:[zhejiangArea, beijingLines, zhengzhouArea],//[vectorLayer,resultLayer],//修改选择层
	        style: new ol.style.Style({
	            stroke: new ol.style.Stroke({
	              color: 'orange',
	              width: 3
	            }),
	        
	        }),
	        //怎么实现单击时shift若未按下则清空选择
// 	        condition: function (mapBrowserEvent) {
//                 if (mapBrowserEvent.type == 'singleclick') {
//                     return map.forEachFeatureAtPixel(mapBrowserEvent.pixel, function () {
//                         boxGrids=[];                     
//                         return true;
//                     });
//                 } 
//                 return false;
//             }
	    });	    
	    map.addInteraction(select);   
	    var selectedFeatures = select.getFeatures();

    	//框选网格
    	var dragBox = new ol.interaction.DragBox({
    		layers:[vectorLayer],
			condition: ol.events.condition.shiftKeyOnly,
			style: new ol.style.Style({
			    stroke: new ol.style.Stroke({
			      color: 'orange',
			      width: 3 
			    })
		  	})
		});		
		map.addInteraction(dragBox);		
		dragBox.on('boxend', function(e) {
			  // features that intersect the box are added to the collection of
			  // selected features, and their names are displayed in the "info"
			  // div
			  var info = [];
			  var extent = dragBox.getGeometry().getExtent();	  		  
			  vectorSource.forEachFeatureIntersectingExtent(extent, function(feature) {	
				    info.push(feature.get('id'));
				    //alert(feature.get('name'));
				    selectedFeatures.push(feature);//！！
				    //修改框选颜色
				   	var fstyle = new ol.style.Style({
					    stroke: new ol.style.Stroke({
					      color: 'orange',
					      width: 3 
					    })
				  	});			
					feature.setStyle(fstyle);
			  });		  
			  if (info.length > 0) {
			  //  alert(info.length+":"+"\n"+totalGrids);
			  }		  
		});
		
		
	    //移动停止，更新界面网格
	    map.on('moveend', function(){	    	
        	var extent = map.getView().calculateExtent(map.getSize());
        	var leftTop = ol.extent.getTopLeft(extent);
        	var rightBottom = ol.extent.getBottomRight(extent);
        	$.ajax({type:"post",
    	 			url:"getGrids.action",
	    	 		data:{
	    	 			"leftupLon":leftTop[0],
	    	 			"leftupLat":leftTop[1],
	    	  			"rightdownLon":rightBottom[0],
	    	 			"rightdownLat":rightBottom[1],
	    	 			"layerint": map.getView().getZoom() + DIFF
	    	 		},
    	 			dataType:"json",
        			success:function(data){
						var json = eval('(' + data + ')'); 
        				vectorSource = new ol.source.GeoJSON(({'object': json}));
        				vectorLayer.setSource(vectorSource);        				
        			}
        	});
        	//description();
        	distinction();
	    });
	        	    
	    //2015.4.28 以网格集表达地物
	    function description(){
	    	//以highestlevel层级所有网格表达，与feature相交则加入输出集，输出集可以进行进一步聚合
	    	var output="";
	    	var gridcount=0;
	    	
	    	var highlight = new ol.source.Vector();
	    	
        	//getFeatures()返回的是ol.collection，不是Array！
        	selectedFeatures.forEach(function(singleFeat) {   
				//singleFeat.setStyle(fstyle);				
				//单一地物创建vector
				var newvec = new ol.source.Vector({
					features:[singleFeat],projection:'EPSG:4326'//这是一个array！不加[]会报括号错误！
				});		
				var feature_extent = singleFeat.getGeometry().getExtent();
				
				var inextent = new Array();
				//extent中的所有网格的feature集
				vectorSource.forEachFeatureIntersectingExtent(feature_extent, function(feature){
					inextent.push(feature);
				});				
				
				inextent.forEach(function(singleGrid){
					var singleExtent = singleGrid.getGeometry().getExtent();
					//判断是否与每个网格相交
					newvec.forEachFeatureIntersectingExtent(singleExtent,function(feature){
						//singleGrid.setStyle(fstyle);
						var id = singleGrid.getId();
						var existence = highlight.getFeatureById(id);
						if(existence==null){//有重复则跳过
							highlight.addFeature(singleGrid);
							var singleCode = singleGrid.get('name');	 
		            		//selectedSets.push(singleCode);
		            		gridcount++;
		            		output += singleCode+'\n';
						}
					});
				});	
												
        	});  
        	console.log("第"+gridLayer+"层网格集"+gridcount+": \n"+output);       	
        	//thiscolor = getRandomColor();
        	//清空
        	//selectedFeatures.clear();
        	resultLayer.setSource(highlight);
	    }
	    
	    //15.4.28 wsz 不同地物的网格集之间不可相交,高亮相交部分
	    var tooSmallLevel = 2;
	    var refine = 1;//加细表达
	    function distinction(){	    
	    	var output="";
	    	var gridcount=0;
	    	//高亮的最后结果
	    	var highlight = new ol.source.Vector();
	    	//比较粗的网格Feature数组			
			var inextentVec = new ol.source.Vector();
	    	
        	//getFeatures()->Vector
        	var selectedVectors = new ol.source.Vector();
        	selectedVectors.addFeatures(selectedFeatures.getArray()); //getFeatures()返回的是ol.collection，不是Array！
        	//对所有选择地物粗算表达网格集
        	selectedFeatures.forEach(function(singleFeat) {				
				var feature_extent = singleFeat.getGeometry().getExtent();	
				//extent中的所有网格的feature集
				vectorSource.forEachFeatureIntersectingExtent(feature_extent, function(feature){
					var id1 = feature.getId();
					var existence1 = inextentVec.getFeatureById(id1);
					if(existence1==null){
						inextentVec.addFeature(feature);
					}
				});
				
				//随机值作为ID，修改颜色
				var newrand = Math.random();
				singleFeat.setId(newrand);				
			});
			//可能死循环
			while(inextentVec.getFeatures().length>2){
			
			inextentVec.forEachFeature(function(singleGrid){
				var singleExtent = singleGrid.getGeometry().getExtent();
				//判断是否与每个网格相交					
				var countIntersect=0;
				selectedVectors.forEachFeatureIntersectingExtent(singleExtent,function(intersectFeat){
					countIntersect++;
				});	
				      	        
				var thislev = singleGrid.get('level');				
			    var thiscode = singleGrid.get('name');
			    
				//若交于不止一个地物，则出栈，四个子网格入栈
				if(countIntersect>1&&(thislev-gridLayer)<tooSmallLevel){
					//降一级
		        	$.ajax({type:"post",
	    	 			url:"changeScale.action",
	    	 			async:false,//这个必须加，不加会死机
		    	 		data:{
		    	 			"input":thiscode,
		    	 			"oldlevel": thislev,
		    	 			"newlevel": thislev+1
		    	 		},
	    	 			dataType:"json",
	        			success:function(data){        				
	        				//这里可能在java有bug
							//console.log(thiscode+":【"+singleExtent+"】");				
							var json = eval('(' + data + ')'); 
	        				//删除父格
	        				inextentVec.removeFeature(singleGrid);
	        				newsons = new ol.source.GeoJSON(({'object': json}));
	        				//加入子格	        				
	        				inextentVec.addFeatures(newsons.getFeatures());	        				
							//console.log("加三个="+inextentVec.getFeatures().length);				
	        			}
		        	});
				}
				else if(countIntersect==1){//只与一个地物相交						
					selectedVectors.forEachFeatureIntersectingExtent(singleExtent,function(feature){
						var id = singleGrid.getId();
						var existence = highlight.getFeatureById(id);
						if(existence==null){//有重复则跳过
							//随机颜色赋值
							var colorid = feature.getId();
							var newcolor = colorById(colorid);							
							var tstyle= new ol.style.Style({
								stroke: new ol.style.Stroke({
							      	color: 'red',			      
						       	  	lineDash: [5,5], 
							      	width: 2
							    }),
							    fill: new ol.style.Fill({
							    	color: newcolor
							    })
					        });
							//细化refine层级
				        	$.ajax({type:"post",
			    	 			url:"changeScale.action",
			    	 			async:false,//这个必须加，不加会死机
				    	 		data:{
				    	 			"input":thiscode,
				    	 			"oldlevel": thislev,
				    	 			"newlevel": thislev+refine
				    	 		},
			    	 			dataType:"json",
			        			success:function(data){			
									var json = eval('(' + data + ')'); 
			        				//删除父格
			        				inextentVec.removeFeature(singleGrid);
			        				newsons = new ol.source.GeoJSON(({'object': json}));	
									newsons_f = newsons.getFeatures();
									newsons_f.forEach(function(feat){
										highlight.addFeature(feat);
										feat.setStyle(tstyle);
										gridcount++;										
		            					output += feat.get('name')+'\n';
									});	
			        			}
				        	});	//ajax					
						}//跳过重复
					});//每个方格
				}
				else if((thislev-gridLayer)>=tooSmallLevel){//太小了
					selectedVectors.forEachFeatureIntersectingExtent(singleExtent,function(feature){
						var id = singleGrid.getId();
						var existence = highlight.getFeatureById(id);
						if(existence==null){//有重复则跳过
							//随机颜色赋值
					        var toosmallstyle = new ol.style.Style({
								stroke: new ol.style.Stroke({
							      	color: 'red',			      
						       	  	lineDash: [5,5], 
							      	width: 2
							    }),
							    fill: new ol.style.Fill({
							    	color: 'yellow'
							    })
					        });
							singleGrid.setStyle(toosmallstyle);
							
							highlight.addFeature(singleGrid);
		            		gridcount++;
		            		output += thiscode+'\n';
		            		//删除父格
	        				inextentVec.removeFeature(singleGrid);
							//console.log("显示一个="+inextentVec.getFeatures().length);	
						}
					});
				}
				else{//无关格子 不要忘记删啊！
	        		inextentVec.removeFeature(singleGrid);
			//console.log("去掉一个="+inextentVec.getFeatures().length);	
				}			
				
			});
        	}//while          	
        	
			//console.log("待显示feature数="+inextentVec.getFeatures().length);
        	//console.log(":)第"+gridLayer+"层网格集"+gridcount+": \n"+output);
        	resultLayer.setSource(highlight);
        	errorLayer.setSource(inextentVec);
        	
	    }
	        
	    //15.4.28 wsz 聚合网格
	    function together(){
	    }
	    
	    //15.4.15 测试
	    $(function(){   	    
	        $('#addSet').bind('click', function(){  	      
				var name = "";
	        	var selectedVectors = new ol.source.Vector();
	        	selectedVectors.addFeatures(selectedFeatures.getArray()); //getFeatures()返回的是ol.collection，不是Array！
	        	//对所有选择地物粗算表达网格集
	        	selectedFeatures.forEach(function(singleFeat) {				
					var feature_extent = singleFeat.getGeometry().getExtent();	
					//extent中的所有网格的feature集
					vectorSource.forEachFeatureIntersectingExtent(feature_extent, function(feature){
		    			var nm = feature.get('name');
						name=name+nm+",";
					});								
				});
				alert(name);
				
       			$.ajax({type:"post",
    	 			url:"together.action",
    	 			//async:false,//这个必须加，不加会死机
	    	 		data:{
	    	 			"input":name,
	    	 			"lev": gridLayer
	    	 		},
    	 			dataType:"json",
        			success:function(data){        				
        				//这里可能在java有bug
						console.log(data);				
						var json = eval('(' + data + ')'); 
        				newsons = new ol.source.GeoJSON(({'object': json}));        				
        				resultLayer.setSource(newsons);	 
        			}
	        	});
        		//输出 
        		
    		});  
		});  
	    
	    $(function(){   	    
	        $('#compute').bind('click', function(){   
        		alert('compute!');           		
				selectedFeatures.clear();
        		
    		});   
		});
		
   	});
    </script>
       
  <title>尺度变换测试</title>
  </head>
  
  
  <body>
  	<style type="text/css">
    	h1 {text-align: center}
    </style>    
    <h1>测试页</h1>
    <div id="map" class="map" style="width: 1000px;height: 650px"
   			></div>    
    <div class="center">
       <a id="addSet" 	href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" style="width:80px;">添加地物</a> 
          <!-- &nbsp;&nbsp;&nbsp;&nbsp;        -->
       <br><br>
       <table id="inTbl" class="easyui-treegrid" style="width:400px;height:200px">  
    		<thead>  
	        <tr>  
	            <th data-options="field:'id',width:100">ID</th>  
	            <th data-options="field:'code',width:300">GeoSOT Code</th>  
	        </tr>  
    		</thead>  
       </table>
       
		<table id="inTable" border="1">
		<tr>
			<th>GridSet ID</th>
			<th>Grid Code</th>
		</tr>		
		</table>
		
       <br>
       <a id="compute"	href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:120px">生成输出网格集</a> 
       <br><br>
       <table id="outTbl" class="easyui-treegrid" style="width:400px;height:200px">  
    		<thead>  
	        <tr>  
	            <th data-options="field:'id',width:100">ID</th>  
	            <th data-options="field:'code',width:300">GeoSOT Code</th>  
	        </tr>  
    		</thead>  
       </table>  
       
       <table id="outTable" border="1">
		<tr>
			<th>GridSet ID</th>
			<th>Grid Code</th>
		</tr>		
		</table>
       
    </div>
    
     


    </div>  
  </body>
</html>