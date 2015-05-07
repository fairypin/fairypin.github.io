<!doctype html>
<html lang="en">
  <head>
    <link rel="stylesheet" href="../js/openlayers3/css/ol.css" type="text/css">
    <link rel="stylesheet" href="../css/main.css" type="text/css"></link>
    <script type="text/javascript" src="../js/openlayers3/script/ol.js"></script>
    <script type="text/javascript" src="../js/jqueryEasyUI/script/jquery.min.js"></script>
    <script type="text/javascript" src="../js/jqueryEasyUI/script/jquery.easyui.min.js"></script>
   <script type="text/javascript">
     $(document).ready(function(){
   		alert("java0");
   		var osm = new ol.layer.Tile({
	      source: new ol.source.BingMaps({
	        key: 'Ak-dzM4wZjSqTlzveKz5u0d4IQ4bRzVI309GxmkgSVr1ewS6iPSrOvOKhA-CJlm3',
	        imagerySet: 'Aerial'
	      })
	    })
   		alert("java1");
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
	            // use maxZoom 19 to see stretched tiles instead of the BingMaps
	            // "no photos at this zoom level" tiles
	            // maxZoom: 19
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
	  
	    
	    var DIFF = 3;
	    /* window.app = {};
	    var app = window.app;
	    app.geosotLayerControl = function (opt_options) {
	        var options = opt_options || {};
	        
	        var span = document.createElement('span');
	        span.id = "geosot-layer";
	        var zoomlevel = map.getView().getZoom();
	        span.innerHTML = "缃戞牸灞傜骇锛� + (zoomlevel + DIFF);
	      
	        var element = document.createElement('div');
	        element.className = 'geosot-layer';
	        element.appendChild(span);
	        
	        ol.control.Control.call(this, {
	            element: element,
	            target: options.target
	        });
	    };
	    ol.inherits(app.geosotLayerControl, ol.control.Control); */
	    
	    
	    var map = new ol.Map({
	        target: 'map',
	        layers: [
	            new ol.layer.Group({
	                name: "基础底图数据",
	                layers: [osm].concat(arcgislayers).concat(binglayers).concat(stamenlayers)
	            }),
	        ],
	        view: new ol.View({
	            // center: ol.proj.transform([117.194, 39.120], 'EPSG:4326', 'EPSG:3857'),
	            center: ol.proj.transform([80, 20], 'EPSG:4326', 'EPSG:3857'),
	            zoom: 2,
	            minZoom: 1,
	            maxZoom: 19
	        }),
	        logo:false,
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
	    map.addControl(new app.geosotLayerControl());
	    
	    map.getView().on('change:resolution', function() {
	        var zoomlevel = map.getView().getZoom();
	        $("#geosot-layer").html("网格层级：" + (zoomlevel + DIFF));
	    });
		    
	    
	    
	    }
	
   	
   	
    </script>
    <title>OpenLayers 3 example</title>
  </head>
  <body>
  	<div id="map" class="map">
  </body>
</html>