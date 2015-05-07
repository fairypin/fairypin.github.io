package wsz.topo.action;

import java.math.BigDecimal;
import java.util.List;

import com.gtech.iwhere.dll.GeoSOTDLL;

public class TogetherAction {
	private String input;
	private int lev;
	private String geojson="";
	
	public String getInput(){		
		return input;
	}
	public void setInput(String input){
		this.input = input;
	}
	public int getLev(){
		return lev;
	}
	public void setLev(int lev){
		this.lev = lev;
	}
	public String getGeojson(){
		return geojson;
	}	
	public void setGeojson(String geojson) {
		this.geojson = geojson;
	}
	
	public String execute(){
		try {
			String[] input_str = input.split(",");
			List<Code_Level> tGrids = GeoSOTDLL.TogetherGrids(input_str,lev);

			// 创建features字符串
			StringBuffer features = new StringBuffer();
			//编码转换网格
			for (int i=0;i<tGrids.size();i++) {
				//dbLVal左, dbBVal下, dbLMVal右, dbBMVal上
				BigDecimal eachCode = new BigDecimal(tGrids.get(i).code);
				List<Double> rect = GeoSOTDLL.getCoordinateGeoCode(eachCode,tGrids.get(i).level);
				double minlon = rect.get(0);
				double minlat = rect.get(1);
				double maxlon = rect.get(2);
				double maxlat = rect.get(3);
				// 创建feature
				features.append("{" +
						"	'type':'Feature'," +
						"	'id':"+ tGrids.get(i).code + "," +
						"   'properties':{'name':'"+ tGrids.get(i).code +"','level':"+ tGrids.get(i).level +"}," +
						"	'geometry':{" +
						"		'type':'Polygon'," +
						"		'coordinates': [[" +
						"    		[" + minlon + "," + maxlat + "]" + "," + " [" + maxlon + "," + maxlat + "]" + "," +
						"    		[" + maxlon + "," + minlat + "]" + "," + " [" + minlon + "," + minlat + "]" +
	 					"    	]]" +
						"	}" +
						"}");
				if (i != tGrids.size() - 1) {
					features.append(",");
				}
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
			

			return "SUCCESS";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return "SUCCESS";
		}
	}
	
}
