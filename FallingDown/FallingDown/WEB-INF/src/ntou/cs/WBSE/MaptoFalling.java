package ntou.cs.WBSE;

public class MaptoFalling {
	private double speed;
	private String[] background;
	private String[] obstacle;

	public MaptoFalling() {
		speed = 0.0;
		background = new String[10];
		obstacle = new String[10];
	}

	public double getSpeed() {
		return speed;
	}

	public void setSpeed(double speed) {
		this.speed = speed;
	}

	public String getBackground(int a) {
		return background[a];
	}

	public void setBackground(String background, int a) {
		this.background[a] = background;
	}

	public String getObstacle(int a) {
		return obstacle[a];
	}

	public void setObstacle(String obstacle, int a) {
		this.obstacle[a] = obstacle;
	}

	@Override
	public String toString() {
		return "Map [speed=" + speed + ", background=" + background[0] + ", obstacle=" + obstacle[0] + "]";
	}

}
