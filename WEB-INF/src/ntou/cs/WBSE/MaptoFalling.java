package ntou.cs.WBSE;

public class MaptoFalling {
	private double speed;
	private String background;
	private String obstacle;

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

	public String getBackground() {
		return background;
	}

	public void setBackground(String background) {
		this.background = background;
	}

	public String getObstacle() {
		return obstacle;
	}

	public void setObstacle(String obstacle) {
		this.obstacle = obstacle;
	}

	@Override
	public String toString() {
		return "Map [speed=" + speed + ", background=" + background + ", obstacle=" + obstacle + "]";
	}

}
