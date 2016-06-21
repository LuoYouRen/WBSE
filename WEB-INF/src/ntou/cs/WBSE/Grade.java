package ntou.cs.WBSE;

public class Grade {
	
	private User user;
	private int myGrade;
	
	public Grade() {
		this.user = new User();
		this.myGrade = 0;
	}
	
	public Grade(User u, int myGrade) {
		user = u;
		this.myGrade = myGrade;
	}
	
	
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public int getMyGrade() {
		return myGrade;
	}
	public void setMyGrade(int myGrade) {
		this.myGrade = myGrade;
	}
	public String writeFile(){
		return String.format("%s %s %s %d", user.getID(), user.getName(), user.getImageURL(), myGrade);
	}
	
	public String toString(){
		return String.format("ID: %s, Name: %s, Image: %s, Grade: %d\n", user.getID(), user.getName(), user.getImageURL(), myGrade);
	}
	
	
}
