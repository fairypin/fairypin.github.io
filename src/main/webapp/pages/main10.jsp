<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="../js/openlayers3/css/ol.css" type="text/css">
    <link rel="stylesheet" href="../css/main.css" type="text/css"></link>
    <script type="text/javascript" src="../js/openlayers3/script/ol.js"></script>
    <script type="text/javascript" src="../js/jqueryEasyUI/script/jquery.min.js"></script>
    <script type="text/javascript" src="../js/jqueryEasyUI/script/jquery.easyui.min.js"></script>
    <script type="text/javascript">
   	$(document).ready(function(){
   		var styles = {
		  'Polygon': [new ol.style.Style({
		    stroke: new ol.style.Stroke({
		      color: 'black',
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
		
		
		
		
	
	    var osm = new ol.layer.Tile({
	        extent:[-180,-90,180,90],
		    source: new ol.source.TileWMS({
		      url: 'http://demo.boundlessgeo.com/geoserver/wms',
		      params: {
		        'LAYERS': 'ne:NE1_HR_LC_SR_W_DR'
		      }
		    })
		  })
	    var arcgisstyles = [
	        'World_Imagery',
	        'World_Physical_Map',
	        'World_Shaded_Relief',
	        'World_Street_Map',
	        'World_Terrain_Base',
	        'World_Topo_Map'
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
	      'AerialWithLabels'
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
	        })
	      }));
	    }
	    var stamenstyles = [
	        "watercolor",
	        'terrain-labels',
	        'toner'
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
	                //layers: [osm].concat(arcgislayers).concat(binglayers).concat(stamenlayers)
	                layers: [osm]
	            }),
	        ],
	        view: new ol.View({
	            // center: ol.proj.transform([117.194, 39.120], 'EPSG:4326', 'EPSG:3857'),
	            projection:'EPSG:4326',
	            //center: ol.proj.transform([80, 20], 'EPSG:4326', 'EPSG:3857'),
	            center:[80, 20],
	            zoom: 3,
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
						  /* source: vectorSource, */
						  style: styleFunction
						});
	    	 			map.addLayer(vectorLayer);  
		var DIFF = 3;
		map.getView().on('change:resolution', function() {
	        var zoomlevel = map.getView().getZoom();
	        $("#geosot-layer").html("网格层级1111:"+ (zoomlevel + DIFF));
	    });
	    
	 /* var select = new ol.interaction.Select({
        layers:[vectorLayer],
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({
              color: 'orange',
              width: 3
            })
          })
        });
    map.addInteraction(select); */
    	var vectorSource;
    	var dragBox = new ol.interaction.DragBox({
    		layers:[vectorLayer],
		  condition: ol.events.condition.shiftKeyOnly,
		  style: new ol.style.Style({
		    stroke: new ol.style.Stroke({
		      color: 'orange'
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
		    
			var selectedFeatures = [];
			selectedFeatures.push(feature);
		    info.push(feature.get('id'));
		    alert(feature.get('name'));
		  });
		  if (info.length > 0) {
		    alert(info.length);
		  }
		});
		
		
		var popup = new ol.Overlay({
		  element: document.getElementById('popup')
		});
		popup.setPosition(coordinate);
		map.addOverlay(popup);
	    
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
        				
        				var container = document.getElementById('popup');
						var content = document.getElementById('popup-content');
						var closer = document.getElementById('popup-closer');
        				
        				
        				popup = document.createElement();
        				var popup = new ol.Overlay({
						  element: document.getElementById('1')
						});
						popup.setPosition(coordinate);
						map.addOverlay(popup);
        			}

        	});
	    
	    
	       
	    
	    
	    });    
	    
	    
	    
	   function createPopupElement(ovarygeonum,coordinate,content){
	   
	   		var container = $("<div id='"+geonum+"-container' class='ol-popup'></div>"); 
	   		var closer = $("<a href='#' id='"+geonum+"-closer' class='ol-popup-closer'></a>"); 
	   		var content = $("<div id='"+geonum+"-content'></div>"); 
	   		
	   
	   
	   }
	    
	    
   	});
    </script>
    <title>OpenLayers 3 example</title>
  </head>
  <body>
    <h2>My Map</h2>
    <div id="map" class="map"></div>
    <div id="geosot-layer"></div>
    
  </body>
</html>