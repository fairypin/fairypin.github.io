package com.gtech.iwhere.controller.action;

import java.math.BigDecimal;
import java.util.List;

import com.gtech.iwhere.dll.GeoSOTDLL;


public class GridsAction {
	/* 左上经度*/
	double leftupLon = 0;
	/* 左上纬度*/
	double leftupLat = 0;
	/* 右下经度*/
	double rightdownLon = 0;
	/* 右下纬度*/
	double rightdownLat = 0;
	/* 层级*/
	int layerint = 0;
	/* 结果字符串*/
	String geojson = "";
	
	/*
	 * 取得指定层级拉框区域对应的编码
	 * */
	public String execute(){
		// 判断范围
		if (leftupLat > 90){
			leftupLat = 90;
		}
		if (rightdownLat < -90){
			rightdownLat = -90;
		}
		if (leftupLon < -180){
			leftupLon = -180;
		}
		if (rightdownLon > 180){
			rightdownLon = 180;
		}
		// 获取网格编码
		List<BigDecimal> geonumlst = GeoSOTDLL.RectGridSelect_str(leftupLat, leftupLon, rightdownLat, rightdownLon, layerint);
		// 创建features字符串
		StringBuffer features = new StringBuffer();
		for (int i = 0; i < geonumlst.size(); i++){
			// feature
			StringBuffer feature = new StringBuffer();
			// 网格编码
			BigDecimal getnumB = geonumlst.get(i);
			// 该网格编码对应的四角点坐标
			List<Double> gridPosition = GeoSOTDLL.getCoordinateGeoCode(getnumB,layerint);
			// 最大经度
			Double maxlon = gridPosition.get(2);
			// 最小经度
			Double minlon = gridPosition.get(0);
			// 最大纬度
			Double maxlat = gridPosition.get(3);
			// 最小纬度
			Double minlat = gridPosition.get(1);
			// 创建feature
			feature.append("{" +
					"	'type':'Feature'," +
					"	'id':"+ getnumB.toPlainString() + "," +
					"   'properties':{'name':'"+ getnumB.toPlainString()  +"','level':"+ layerint +"}," +
					"	'geometry':{" +
					"		'type':'Polygon'," +
					"		'coordinates': [[" +
					"    		[" + minlon + "," + maxlat + "]" + "," + " [" + maxlon + "," + maxlat + "]" + "," +
					"    		[" + maxlon + "," + minlat + "]" + "," + " [" + minlon + "," + minlat + "]" +
 					"    	]]" +
					"	}" +
					"}");
			if (i != geonumlst.size()-1){
				feature.append(",");
			}
			features.append(feature);
		}
		
		geojson = "{" +
				"'type':'FeatureCollection'," +
				"'crs':{" +
				"   'type': 'name'," +
				"   'properties':{" +
				"		'name':'EPSG:4326'" +
				"    }" +
				" }," +
				"'features':[" + features +
				"]}";
		
		
		//System.out.println(geojson);
		
		return "SUCCESS";
	}
	
	/*
	 * 取得指定层级拉框区域对应的编码
	 * */
	/*public String execute1(){
		// 获取网格编码
		List<BigDecimal> geonumlst = GeoSOTDLL.RectGridSelect_str(leftupLat, leftupLon, rightdownLat, rightdownLon, layerint);
		// 创建features字符串
		StringBuffer features = new StringBuffer();
		for (int i = 0; i < geonumlst.size(); i++){
			// feature
			StringBuffer feature = new StringBuffer();
			// 网格编码
			BigDecimal getnumB = geonumlst.get(i);
			// 该网格编码对应的四角点坐标
			List<Double> gridPosition = GeoSOTDLL.getCoordinateGeoCode(getnumB,layerint);
			// 最大经度
			Double maxlon = gridPosition.get(0);
			// 最小经度
			Double minlon = gridPosition.get(0);
			// 最大纬度
			Double maxlat = gridPosition.get(0);
			// 最小纬度
			Double minlat = gridPosition.get(0);
			// 创建feature
			feature.append("{" +
					"	'type':'Feature'," +
					"	'id':"+ getnumB.toPlainString() + "," +
					"	'geometry': { " +
					"		'type':'Polygon'," +
					"		'coordinates': [[" +
					"    		[" + minlon + "," + maxlat + "]" + "," + " [" + maxlon + "," + maxlat + "]" +
					"    		[" + maxlon + "," + minlat + "]" + "," + " [" + minlon + "," + minlat + "]" +
 					"    	]]" +
					"	}" +
					"}");
			if (i != geonumlst.size()-1){
				feature.append(",");
			}
			features.append(feature);
		}
		
		geojson = "{" +
				"'type':'FeatureCollection'," +
				"'crs':{" +
				"   'type'='name'" +
				"   'properties':{" +
				"		'name':'EPSG:4326'" +
				"    }" +
				" }," +
				"'features':[" + features +
				"]}";
		
		
	//	System.out.println(geojson);
		
		return "SUCCESS";
	}*/

	public double getLeftupLon() {
		return leftupLon;
	}

	public void setLeftupLon(double leftupLon) {
		this.leftupLon = leftupLon;
	}

	public double getLeftupLat() {
		return leftupLat;
	}

	public void setLeftupLat(double leftupLat) {
		this.leftupLat = leftupLat;
	}

	public double getRightdownLon() {
		return rightdownLon;
	}

	public void setRightdownLon(double rightdownLon) {
		this.rightdownLon = rightdownLon;
	}

	public double getRightdownLat() {
		return rightdownLat;
	}

	public void setRightdownLat(double rightdownLat) {
		this.rightdownLat = rightdownLat;
	}

	public int getLayerint() {
		return layerint;
	}

	public void setLayerint(int layerint) {
		this.layerint = layerint;
	}

	public String getGeojson() {
		return geojson;
	}

	public void setGeojson(String geojson) {
		this.geojson = geojson;
	}


}
