package com.gtech.iwhere.dll;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.xvolks.jnative.JNative;
import org.xvolks.jnative.Type;
import org.xvolks.jnative.exceptions.NativeException;
import org.xvolks.jnative.pointers.Pointer;
import org.xvolks.jnative.pointers.memory.MemoryBlockFactory;

import wsz.topo.action.Code_Level;

public class GeoSOTDLL {

	private static final BigInteger INTEGER_MAX = new BigInteger(
			"9223372036854775807");

	private static final BigInteger INTEGER_MOD = new BigInteger(
			"-18446744073709551616");

	private static final String GEOSOT_DLL="geosot.dll";
	// GEOSOT_API void PolygonGridIdentify_str(double dbB[],double dbL[],int
	// pointNum,char geoID_str[]);
	public static final BigDecimal getLayerMaxGeoCode(BigDecimal geonum64,
			long level) {
		//System.out.println("TID:" + Thread.currentThread().getId() + " input :"+ geonum64);
		JNative n = null;
		Pointer pp = null;
		try {
			n = new JNative(GEOSOT_DLL, "GetMaxGridCode");
			n.setRetVal(Type.VOID);
			int i = 0;
			// System.out.println(new
			// BigInteger("9223372036854775807").subtract(new
			// BigInteger("-9223372036854775808")));
			if (geonum64.toBigInteger().subtract(INTEGER_MAX).longValue() > 0) {
				BigInteger temp = geonum64.toBigInteger().add(INTEGER_MOD);
				n.setParameter(i++, Type.LONG, temp.toString());
			} else {
				n.setParameter(i++, Type.LONG, geonum64.toString());
			}
			n.setParameter(i++, Type.INT, String.valueOf(level));
			pp = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, pp);
			n.invoke();
			// return pp.getAsLong(0);
			byte[] temp1 = pp.getMemory();
			byte[] temp2 = new byte[temp1.length + 1];
			for (int j = 0; j < temp1.length; j++) {
				temp2[temp1.length - j] = temp1[j];
			}
			BigInteger rezult = new BigInteger(temp2);
			//System.out.println("TID:" + Thread.currentThread().getId()+ "output:" + rezult.toString());
			return new BigDecimal(rezult);
		} catch (Exception e) {
			return BigDecimal.valueOf(0);
		} finally {

			if (null != pp) {
				try {
					pp.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			// if (n != null)
			// try {
			// JNative.unLoadLibrary(GEOSOT_DLL);
			// } catch (NativeException e) {
			// e.printStackTrace();
			// }
		}
	}	
	
	// GEOSOT_API void RectGridSelect_str(double dbLeftTopB,double
	// dbLeftTopL,double dbRightBottomB,double dbRightBottomL,
	// unsigned char chLayer,char geoID_array[],int &nRow,int &nCol);
	// dbLeftTopB 大纬度；dbLeftTopL 小经度；dbRightBottomB小纬度；dbRightBottomL大经度
	public static final List<BigDecimal> RectGridSelect_str(double dbLeftTopB,
			double dbLeftTopL, double dbRightBottomB, double dbRightBottomL,
			int chLayer) {
		List<BigDecimal> list = new ArrayList<BigDecimal>();
		JNative n = null;
		Pointer pp = null;
		Pointer pp1 = null;
		Pointer pp2 = null;
		try {
			n = new JNative(GEOSOT_DLL, "RectGridSelect_str");
			n.setRetVal(Type.VOID);
			// int i = 0;
			n.setParameter(3, Type.DOUBLE, String.valueOf(dbLeftTopB));
			// System.out.println(Type.INT.getNativeType());
			// System.out.println(Type.DOUBLE.getNativeType());
			n.setParameter(2, Type.DOUBLE, String.valueOf(dbLeftTopL));
			n.setParameter(1, Type.DOUBLE, String.valueOf(dbRightBottomB));
			n.setParameter(0, Type.DOUBLE, String.valueOf(dbRightBottomL));
			n.setParameter(4, Type.INT, String.valueOf(chLayer));
			pp = new Pointer(
					MemoryBlockFactory.createMemoryBlock(4 * 1024 * 1024));
			n.setParameter(5, pp);
			pp1 = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			pp1.setIntAt(0, 5);
			n.setParameter(6, pp1);
			pp2 = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			pp2.setIntAt(0, 5);
			n.setParameter(7, pp2);
			n.invoke();

			// System.out.println(pp.getAsString());
			String geocodes = pp.getAsString();
			String[] temps = geocodes.split(";");
			for (String temp : temps) {
				list.add(new BigDecimal(temp));
			}

			return list;
		} catch (Exception e) {
			return list;
		} finally {
			if (null != pp || null != pp1 || null != pp2) {
				try {
					pp.dispose();
					pp1.dispose();
					pp2.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (n != null)
				try {
					JNative.unLoadLibrary(GEOSOT_DLL);
				} catch (NativeException e) {
					e.printStackTrace();
				}
		}
	}

	// 给定面片编号，获取经纬度。
	public static final List<Double> getCoordinateGeoCode(BigDecimal geonum64,
			long level) {
		//System.out.println("TID:" + Thread.currentThread().getId() + " input :"	+ geonum64);
		JNative n = null;
		Pointer pp = null;
		try {
			n = new JNative(GEOSOT_DLL, "RectFromGridCode");
			n.setRetVal(Type.VOID);
			int i = 0;

			n.setParameter(i++, Type.INT, String.valueOf(level));

			if (geonum64.toBigInteger().subtract(INTEGER_MAX).longValue() > 0) {
				BigInteger temp = geonum64.toBigInteger().add(INTEGER_MOD);
				n.setParameter(i++, Type.LONG, temp.toString());
			} else {
				n.setParameter(i++, Type.LONG, geonum64.toString());
			}

			Pointer dbL = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, dbL);
			Pointer dbB = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, dbB);
			Pointer dbLM = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, dbLM);
			Pointer dbBM = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, dbBM);

			n.invoke();

			double dbLVal = dbL.getAsDouble(0);
			double dbBVal = dbB.getAsDouble(0);
			double dbLMVal = dbLM.getAsDouble(0);
			double dbBMVal = dbBM.getAsDouble(0);

			List<Double> listOfDouble = new ArrayList<Double>();
			listOfDouble.add(dbLVal);
			listOfDouble.add(dbBVal);
			listOfDouble.add(dbLMVal);
			listOfDouble.add(dbBMVal);

			//System.out.println("TID:" + Thread.currentThread().getId()	+ "output:" + listOfDouble.size());
			return listOfDouble;
		} catch (Exception e) {
			return null;
		} finally {

			if (null != pp) {
				try {
					pp.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	// 给定面片编号，获取经纬度。
	public static final String getGeonumsOfScopeInLevel14(double dbLeftTopB,double dbLeftTopL,double dbRightTopB,double dbRightTopL,double dbRightBottomB,double dbRightBottomL,double dbLeftBottomB,double dbLeftBottomL, int chLayer) {
		JNative n = null;
		Pointer pp = null;
		try {
			n = new JNative(GEOSOT_DLL, "QuadrilateralGridSelect_str");
											 
			n.setRetVal(Type.VOID);
			int i = 0;
//			System.out.println("dbLeftTopB:"+dbLeftTopB);
//			System.out.println("dbLeftTopL:"+dbLeftTopL);
//			System.out.println("dbRightTopB:"+dbRightTopB);
//			
//			System.out.println("dbRightTopL:"+dbRightTopL);
//			System.out.println("dbRightBottomB:"+dbRightBottomB);
//			System.out.println("dbRightBottomL:"+dbRightBottomL);
//			System.out.println("dbLeftBottomB:"+dbLeftBottomB);
//			System.out.println("dbLeftBottomL:"+dbLeftBottomL);

			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbLeftTopB));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbLeftTopL));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbRightTopB));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbRightTopL));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbRightBottomB));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbRightBottomL));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbLeftBottomB));
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbLeftBottomL));

			n.setParameter(i++, Type.INT, String.valueOf(chLayer));

			Pointer resultStr = new Pointer(MemoryBlockFactory.createMemoryBlock(100000));
			n.setParameter(i++, resultStr);
			n.invoke();
			//System.out.println("resultStr.getAsString():"+resultStr.getAsString());
			return resultStr.getAsString();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {

			if (null != pp) {
				try {
					pp.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	
	/**
	 * 功能：四边形选择当前层级的网格。
		参数(dbLeftTopB,dbLeftTopL),（dbRightTopB,dbRightTopL）,（dbRightBottomB,dbRightBottomL）,（dbLeftBottomB,dbLeftBottomL）
		分别为四边形的左顶点、右顶点、右底点和右底点的经纬度，单位为度。
		chLayer,为用户操作的网格层级。
		geoID_array,返回矩形选择的所有网格的64位编码字符数组（每个网格编码用';'隔开）*/
	public static final List<BigDecimal> QuadrilateralGridSelect_str(
			double dbLeftTopB,double dbLeftTopL,
			double dbRightTopB,double dbRightTopL,
			double dbRightBottomB,double dbRightBottomL,
			double dbLeftBottomB,double dbLeftBottomL,
			int chLayer ) {
		List<BigDecimal> list = new ArrayList<BigDecimal>();
		JNative n = null;
		Pointer pp = null;
		try {
			n = new JNative(GEOSOT_DLL, "QuadrilateralGridSelect_str");
			n.setRetVal(Type.VOID);

			n.setParameter(7, Type.DOUBLE, String.valueOf(dbLeftTopB));
			n.setParameter(6, Type.DOUBLE, String.valueOf(dbLeftTopL));
			n.setParameter(5, Type.DOUBLE, String.valueOf(dbRightTopB));			
			n.setParameter(4, Type.DOUBLE, String.valueOf(dbRightTopL));			
			n.setParameter(3, Type.DOUBLE, String.valueOf(dbRightBottomB));
			n.setParameter(2, Type.DOUBLE, String.valueOf(dbRightBottomL));
			n.setParameter(1, Type.DOUBLE, String.valueOf(dbLeftBottomB));			
			n.setParameter(0, Type.DOUBLE, String.valueOf(dbLeftBottomL));
			
			
			n.setParameter(8, Type.INT, String.valueOf(chLayer));
			
			pp = new Pointer(
					MemoryBlockFactory.createMemoryBlock(4 * 1024 * 1024));
			n.setParameter(9, pp);
			n.invoke();

			String geocodes = pp.getAsString();
			String[] temps = geocodes.split(";");
			for (String temp : temps) {
				list.add(new BigDecimal(temp));
			}

			return list;
		} catch (Exception e) {
			return list;
		} finally {
			if (null != pp ) {
				try {
					pp.dispose();

				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (n != null)
				try {
					JNative.unLoadLibrary(GEOSOT_DLL);
				} catch (NativeException e) {
					e.printStackTrace();
				}
		}
	}
	
		
	public static String[] SonGrid_str(String geonum, int chLayerInt, int sonLayerInt)
			throws Exception {
		Pointer resultStr = null;
		JNative n = null;
		try {
			n = new JNative(GEOSOT_DLL, "SonGrid_str");
			n.setRetVal(Type.VOID);
			int i = 0;
			n.setParameter(i++, Type.STRING, geonum);
			// 层级
			n.setParameter(i++, Type.INT, String.valueOf(chLayerInt));
			// 子层级
			n.setParameter(i++, Type.INT, String.valueOf(sonLayerInt));
			// 由于 unsigned __int64 &geoID 作为结果需要返回 ，所以定义为一个内存指针，大小为 8 个字节
			resultStr = new Pointer(MemoryBlockFactory.createMemoryBlock(1000));
			n.setParameter(i++, resultStr);

			n.invoke();
			String[] r = resultStr.getAsString().split(";");
			return r;
		} finally {
			if (null != resultStr) {
				try {
					resultStr.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
//			if (n != null)
//				try {
//					JNative.unLoadLibrary(GEOSOT_DLL);
//				} catch (NativeException e) {
//					e.printStackTrace();
//				}
		}
		
	}
	
	public static long PointGridIdentify_D(double dbB, double dbL, int chLayerInt)
			throws Exception {
		JNative n = null;
		Pointer resultStr = null;
		Pointer chLayer = null;
		try {

			n = new JNative(GEOSOT_DLL, "PointGridIdentify_D");
			n.setRetVal(Type.VOID);
			int i = 0;
			// 经度
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbL));
			// 纬度
			n.setParameter(i++, Type.DOUBLE, String.valueOf(dbB));
			// 层级
			chLayer = new Pointer(MemoryBlockFactory.createMemoryBlock(4));
			chLayer.setIntAt(0, chLayerInt);
			n.setParameter(i++, chLayer);
			// 由于 unsigned __int64 &geoID 作为结果需要返回 ，所以定义为一个内存指针，大小为 8 个字节
			resultStr = new Pointer(MemoryBlockFactory.createMemoryBlock(8));
			n.setParameter(i++, resultStr);
			n.invoke();
			
			long r = resultStr.getAsLong(0);
			return r;
		} finally {
			if (null != resultStr) {
				try {
					resultStr.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (null != chLayer) {
				try {
					chLayer.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (n != null)
				try {
					JNative.unLoadLibrary(GEOSOT_DLL);
				} catch (NativeException e) {
					e.printStackTrace();
				}
		}
		
	}
	
	public static double[] DegreeFromGridCode(int chLayer, String geonum)
			throws Exception {
		JNative n = null;
		Pointer dbB = null;
		Pointer dbL = null;
		try {
			n = new JNative(GEOSOT_DLL, "DegreeFromGridCode");
			n.setRetVal(Type.VOID);

			int i = 0;
			// 层级
			n.setParameter(i++, Type.INT, String.valueOf(chLayer));
			// 编码
			BigDecimal geonum64 = new BigDecimal(geonum);
			if (geonum64.toBigInteger().subtract(INTEGER_MAX).longValue() > 0) {
				BigInteger temp = geonum64.toBigInteger().add(INTEGER_MOD);
				n.setParameter(i++, Type.LONG, temp.toString());
			} else {
				n.setParameter(i++, Type.LONG, geonum64.toString());
			}
			// 纬度
			dbB = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbB);
			// 经度
			dbL = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbL);
			n.invoke();

			double[] result = new double[] { dbB.getAsDouble(0), dbL.getAsDouble(0) };
			return result;
		} finally {
			if (null != dbB) {
				try {
					dbB.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (null != dbL) {
				try {
					dbL.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (n != null)
				try {
					JNative.unLoadLibrary(GEOSOT_DLL);
				} catch (NativeException e) {
					e.printStackTrace();
				}
		}
	}
	
	public static double[] RectFromGridCode(int chLayer, String geonum)
			throws Exception {
		JNative n = null;
		Pointer dbB = null;
		Pointer dbL = null;
		Pointer dbLM = null;
		Pointer dbBM = null;
		try {
			n = new JNative(GEOSOT_DLL, "RectFromGridCode");
			n.setRetVal(Type.VOID);

			int i = 0;
			// 层级
			n.setParameter(i++, Type.INT, String.valueOf(chLayer));
			// 编码
			BigDecimal geonum64 = new BigDecimal(geonum);
			if (geonum64.toBigInteger().subtract(INTEGER_MAX).longValue() > 0) {
				BigInteger temp = geonum64.toBigInteger().add(INTEGER_MOD);
				n.setParameter(i++, Type.LONG, temp.toString());
			} else {
				n.setParameter(i++, Type.LONG, geonum64.toString());
			}
			// 纬度
			dbB = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbB);
			// 经度
			dbL = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbL);
			// 纬度
			dbLM = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbLM);
			// 经度
			dbBM = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, dbBM);
			n.invoke();
			
			double[] result = new double[] { dbB.getAsDouble(0),
					dbL.getAsDouble(0), dbLM.getAsDouble(0), dbBM.getAsDouble(0) };
			return result;
		} finally {
			if (null != dbB) {
				try {
					dbB.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (null != dbL) {
				try {
					dbL.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (null != dbLM) {
				try {
					dbB.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (null != dbBM) {
				try {
					dbL.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
			if (n != null)
				try {
					JNative.unLoadLibrary(GEOSOT_DLL);
				} catch (NativeException e) {
					e.printStackTrace();
				}
		}

		
	}
	
	public static long FatherGrid(String geonum, int chLayer, int chLayerFather)
			throws Exception {
		JNative n = null;
		Pointer fatherID = null;
		try {
			n = new JNative(GEOSOT_DLL, "FatherGrid");
			n.setRetVal(Type.VOID);
			int i = 0;
			// 编码
			BigDecimal geonum64 = new BigDecimal(geonum);//wk原来写死了
			if (geonum64.toBigInteger().subtract(INTEGER_MAX).longValue() > 0) {
				BigInteger temp = geonum64.toBigInteger().add(INTEGER_MOD);
				n.setParameter(i++, Type.LONG, temp.toString());
			} else {
				n.setParameter(i++, Type.LONG, geonum64.toString());
			}
			// 层级
			n.setParameter(i++, Type.INT, String.valueOf(chLayer));
			// 父层级
			n.setParameter(i++, Type.INT, String.valueOf(chLayerFather));
			// 父网格号 fatherID
			fatherID = new Pointer(MemoryBlockFactory.createMemoryBlock(100));
			n.setParameter(i++, fatherID);

			n.invoke();
			
			long r = fatherID.getAsLong(0);
			return r;
		} finally {
			if (null != fatherID) {
				try {
					fatherID.dispose();
				} catch (NativeException e) {
					e.printStackTrace();
				}
			}
//			if (n != null)
//				try {
//					JNative.unLoadLibrary(GEOSOT_DLL);
//				} catch (NativeException e) {
//					e.printStackTrace();
//				}
		}
	}	
		
	//15.5.5 wsz 网格聚合
	public static List<Code_Level> TogetherGrids(String[] geonum, int chLayerInt)
			throws Exception {
		Pointer inCodePtr=null, outCodePtr=null, outLevelPtr = null,outputCount;
		JNative n = null;
		try {
			n = new JNative(GEOSOT_DLL, "TogetherGrids");
			n.setRetVal(Type.VOID);
			int i = 0;
			
			//输入编码数组指针
			int inputCount = geonum.length;
			inCodePtr = new Pointer(MemoryBlockFactory.createMemoryBlock(4 * inputCount));
			for(int id=0;id<inputCount;id++){
				inCodePtr.setLongAt(4*id, Long.parseLong(geonum[id]));
			}
			n.setParameter(i++, inCodePtr);			
			//输入当前层级
			n.setParameter(i++, chLayerInt);
			//输入编码数
			n.setParameter(i++, inputCount);
			//输出编码数组指针
			outCodePtr = new Pointer(MemoryBlockFactory.createMemoryBlock(4 * inputCount));
			n.setParameter(i++, outCodePtr);
			//输出层级数组指针
			outLevelPtr = new Pointer(MemoryBlockFactory.createMemoryBlock(4 * inputCount));
			n.setParameter(i++, outLevelPtr);
			//输出编码数
			outputCount = new Pointer(MemoryBlockFactory.createMemoryBlock(4));
			n.setParameter(i++, outputCount);
			
			n.invoke();
			int oCount = outputCount.getAsInt(0);
			String[] oCode  = outCodePtr.getAsString().split(";");
			String[] oLevel = outLevelPtr.getAsString().split(";");
			List<Code_Level> list = new ArrayList<Code_Level>();
			for(int od = 0;od<oCode.length;od++){
				Code_Level cl = new Code_Level(oCode[od],Integer.parseInt(oLevel[od]));
				list.add(cl);
				System.out.println(cl.code+","+cl.level);
			}
			return list;
		} finally {		
		}
		
		
	}

	public static void main(String[] args) {
//		String tt = GeoSOTDLL.getGeonumsOfScopeInLevel14(112.41703101548005, 24.103294403983494, 114.86746972510014, 24.103294403983494, 114.86746972510014, 22.086733088334423, 112.41703101548005, 22.086733088334423, 14);
//		String[] y = tt.split(";");
//		System.out.println("tt:"+y);
		
		
		// BigDecimal b = new BigDecimal("10502394331027996672");
		// BigDecimal DD = getLayerMaxGeoCode(b, 5);
		// List<BigDecimal> list =RectGridSelect_str(-10.003408266986, -180.0,
		// -19.822410769785, -168.170246565015, 5);
		// List<BigDecimal> list = RectGridSelect_str(-10.555555,
		// -179.08755,-19.087855, -168.07878, 5);
		// List<BigDecimal> fg = RectGridSelect_str(-10, -179, -19, -168, 10);
		// int ii = 0;
		// List<BigDecimal> list4 =
		// RectGridSelect_str(-168.07878,-19.087855,-179.08755, -10.555555, 5);
		
//		List<BigDecimal> tt = GeoSOTDLL.QuadrilateralGridSelect_str(64, 128, 64, 160, 32, 160, 32, 128,6);//(23.57720486203489,119.55528125166893,23.57720486203489,119.59304675459862,23.544475849777392,119.59304675459862,23.544475849777392,119.55528125166893,14);
//		String[] y = tt.toString().split(";");
		//System.out.println(tt);
		
/*		BigDecimal a1 = new BigDecimal("430515976878948352");
		BigDecimal a2 = new BigDecimal("430727083111481344");
		BigDecimal a3 = new BigDecimal("430938189344014336");
		try {
			long fa1 = FatherGrid(a1+"", 9, 8);
			long fa2 = FatherGrid(a2+"", 9, 8);
			long fa3 = FatherGrid(a3+"", 9, 8);
			System.out.println("father="+fa1+'\n'+fa2+'\n'+fa3);
			
			String[] son1= SonGrid_str(a1+"", 9, 10);
			for (String string : son1) {
				System.out.println("son1="+string);
			}
			String[] son2= SonGrid_str(a2+"", 9, 10);
			for (String string : son2) {
				System.out.println("son2="+string);
			}
			String[] son3= SonGrid_str(a3+"", 9, 10);
			for (String string : son3) {
				System.out.println("son3="+string);
			}							
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}*/
		

	}	
	


}
