import com.gtech.iwhere.controller.action.GridsAction;


public class TestGridsAction {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		GridsAction gridsAction = new GridsAction();
		gridsAction.setLayerint(2);
		gridsAction.setLeftupLon(-180);
		gridsAction.setLeftupLat(90);
		gridsAction.setRightdownLon(180);
		gridsAction.setRightdownLat(-90);
		System.out.println(gridsAction.execute());
		
	}

}
