package wsz.topo.action;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.gtech.iwhere.dll.GeoSOTDLL;

public class ScaleAction {
	private String input;
	private int oldlevel;
	private int newlevel;
	
	private String geojson="";
	
	public String getInput(){		
		return input;
	}
	public void setInput(String input){
		this.input = input;
	}
	
	public int getOldlevel(){
		return oldlevel;
	}
	
	public void setOldlevel(int oldlevel){
		this.oldlevel = oldlevel;
	}
	
	public int getNewlevel(){
		return newlevel;
	}
	
	public void setNewlevel(int newlevel){
		this.newlevel = newlevel;
	}
	
	public String getGeojson(){
		return geojson;
	}
	
	public void setGeojson(String geojson) {
		this.geojson = geojson;
	}
	
	public String execute(){
		if(input==null||input.length()==0){
			System.out.println("error");
			return "SUCCESS";
		}
		String[] input_str = input.split(",");
		List<BigDecimal> input_code = new ArrayList<BigDecimal>();
		for (String ip : input_str) {
			input_code.add(new BigDecimal(ip));
		}
		List<BigDecimal> output_code = MultiLevel(input_code, oldlevel, newlevel);//这里bug！
		// 创建features字符串
		StringBuffer features = new StringBuffer();
		//编码转换网格
		for (int i=0;i<output_code.size();i++) {
			//dbLVal左, dbBVal下, dbLMVal右, dbBMVal上
			List<Double> rect = GeoSOTDLL.getCoordinateGeoCode(output_code.get(i),newlevel);
			double minlon = rect.get(0);
			double minlat = rect.get(1);
			double maxlon = rect.get(2);
			double maxlat = rect.get(3);
			// 创建feature
			features.append("{" +
					"	'type':'Feature'," +
					"	'id':"+ output_code.get(i) + "," +
					"   'properties':{'name':'"+ output_code.get(i) +"','level':"+ newlevel +"}," +
					"	'geometry':{" +
					"		'type':'Polygon'," +
					"		'coordinates': [[" +
					"    		[" + minlon + "," + maxlat + "]" + "," + " [" + maxlon + "," + maxlat + "]" + "," +
					"    		[" + maxlon + "," + minlat + "]" + "," + " [" + minlon + "," + minlat + "]" +
 					"    	]]" +
					"	}" +
					"}");
			if (i != output_code.size() - 1) {
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
		
	//	System.out.println("ScaleAction("+input+","+oldlevel+","+newlevel+")="+features);
		
		return "SUCCESS";
	}
	
	//单网格集输入：默认输入网格集、输出网格集分别位于同一层级
	public static final List<BigDecimal> MultiLevel(List<BigDecimal> CodeSerial, int oldLevel, int newLevel){
		try {
			int CodeSerialLength = CodeSerial.size();
			if(CodeSerialLength==0 || oldLevel==newLevel)
				return CodeSerial;
			//向下抽
			else if (newLevel > oldLevel) {
				List<BigDecimal> CodeSerial_output = new ArrayList<BigDecimal>();
				//每个网格求在新层级的子网格集并加入输出集中
				for(int i=0;i<CodeSerialLength;i++){
					String[] sons_str = GeoSOTDLL.SonGrid_str(""+CodeSerial.get(i), oldLevel, newLevel);
					for (String s : sons_str) {
						CodeSerial_output.add(new BigDecimal(s));
					}
				}
				return CodeSerial_output;
			}
			else {//向上抽
				List<BigDecimal> CodeSerial_output = new ArrayList<BigDecimal>();
				//编码集按编码值升序排序
				Collections.sort(CodeSerial);
				//记录父
				BigDecimal fatherInNote = new BigDecimal(GeoSOTDLL.FatherGrid(""+CodeSerial.get(0), oldLevel, newLevel));
				CodeSerial_output.add(fatherInNote);
				if (CodeSerialLength==1) {
					return CodeSerial_output;
				}
				for (BigDecimal c : CodeSerial) {
					//当前父
					BigDecimal father = new BigDecimal(GeoSOTDLL.FatherGrid(""+c, oldLevel, newLevel));
					//位于不同父格
					if(father.compareTo(fatherInNote)!=0){//一定要这么写！不能用！=，最好也不用equals，BigDecimal很特殊
						// 把当前父加入输出集
						CodeSerial_output.add(father);
						//记录父<-当前父
						fatherInNote = father;
					}
				}
				return CodeSerial_output;
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
		
	}
}





