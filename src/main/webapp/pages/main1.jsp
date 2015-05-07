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
   		var image = new ol.style.Circle({
  radius: 5,
  fill: null,
  stroke: new ol.style.Stroke({color: 'red', width: 1})
});

var styles = {
  'Point': [new ol.style.Style({
    image: image
  })],
  'LineString': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'green',
      width: 1
    })
  })],
  'MultiLineString': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'green',
      width: 1
    })
  })],
  'MultiPoint': [new ol.style.Style({
    image: image
  })],
  'MultiPolygon': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'yellow',
      width: 1
    }),
    fill: new ol.style.Fill({
      color: 'rgba(255, 255, 0, 0.1)'
    })
  })],
  'Polygon': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'blue',
      lineDash: [4],
      width: 3
    }),
    fill: new ol.style.Fill({
      color: 'rgba(0, 0, 255, 0.1)'
    })
  })],
  'GeometryCollection': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'magenta',
      width: 2
    }),
    fill: new ol.style.Fill({
      color: 'magenta'
    }),
    image: new ol.style.Circle({
      radius: 10,
      fill: null,
      stroke: new ol.style.Stroke({
        color: 'magenta'
      })
    })
  })],
  'Circle': [new ol.style.Style({
    stroke: new ol.style.Stroke({
      color: 'red',
      width: 2
    }),
    fill: new ol.style.Fill({
      color: 'rgba(255,0,0,0.2)'
    })
  })]
};
var vectorSource = new ol.source.GeoJSON(
    /** @type {olx.source.GeoJSONOptions} */ ({
      object: {
        'type': 'FeatureCollection',
        'crs': {
          'type': 'name',
          'properties': {
            'name': 'EPSG:4326'
          }
        },
        'features': [
          {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [0, 0]
            }
          }
        ]
      }
    }));

var vectorLayer = new ol.layer.Vector({
  source: vectorSource,
  style: styleFunction
});
    	var layers = [
		  new ol.layer.Tile({
		    source: new ol.source.TileWMS({
		      url: 'http://demo.boundlessgeo.com/geoserver/wms',
		      params: {
		        'LAYERS': 'ne:NE1_HR_LC_SR_W_DR'
		      }
		    })
		  })
		];
		
		var map = new ol.Map({
		  controls: ol.control.defaults().extend([
		    new ol.control.ScaleLine({
		      units: 'degrees'
		    })
		  ]),
		  layers: layers,
		  target: 'map',
		  view: new ol.View({
		    projection: 'EPSG:4326',
		    center: [0, 0],
		    zoom: 2
		  })
		});
		
		map.addLayer(vectorLayer)
		
	    map.on('moveend', function(){
	    	var zoom = map.getView().getZoom();
        	var extent = map.getView().calculateExtent(map.getSize());     
        	var leftTop = ol.extent.getTopLeft(extent);
        	var rightBottom = ol.extent.getBottomRight(extent);
        	alert(leftTop+","+rightBottom);
	    	$.ajax({
    	 		type:"post",
    	 		url:"getGrids.action",
    	 		data:{
    	 			"leftupLon":leftTop[0],
    	 			"leftupLat":leftTop[1],
    	  			"rightdownLon":rightBottom[0],
    	 			"rightdownLat":rightBottom[1],
    	 			"layerint":"2"
    	 		},
    	 		dataType:"json",
    	 		success:function(data){
    	 			var geojsonFeature = {
					    "type": "Feature",
					    "properties": {
					        "name": "Coors Field",
					        "amenity": "Baseball Stadium",
					        "popupContent": "This is where the Rockies play!"
					    },
					    "geometry": {
					        "type": "Point",
					        "coordinates": [-104.99404, 39.75621]
					    }
					};
    	 			var newlayer = new ol.layer.Vector();
    	 			var source = new ol.source.Vector();
    	 			
    	 			var features;
    	 			source.addFeature(geojsonFeature);
    	 			
    	 			map.addLayer(newlayer);
    	 			/* alert(data);
    	 			var st = {}
    	 			var geojsonFormat = new ol.format.GeoJSON();
    	 			alert(geojsonFormat); */
    	 			/* geojsonFormat.readFeatures(data);
    	 			alert(geojsonFormat); */
    	 		/* 	var newlayer = new ol.layer.Vector();
    	 			var source = new ol.source.Vector();
    	 			
    	 			var features;
    	 			source.addFeatures(features);
    	 			
    	 			map.addLayer(newlayer);
    	 			
    	 			 
    	 			alert(data);*/
    	 		}
    	 	});
    	 	/* if ("map" == map.getTarget()){
    	 		map.setTarget("map1");
    	 	} else {
    	 		map.setTarget("map");
    	 	} */
    	 	
	    
	    
	    });
   	});
    </script>
    <title>OpenLayers 3 example</title>
  </head>
  <body>
    <h2>My Map</h2>
    <div id="map" class="map"></div>
    <div id="map1" class="map"></div>
    
  </body>
</html>