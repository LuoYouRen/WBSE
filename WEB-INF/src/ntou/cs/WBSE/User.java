package ntou.cs.WBSE;

public class User {
	private String ID;
	private String imageURL;
	private String name;
	
	
	public User() {
		ID = "";
		this.imageURL = "";
		this.name = "";
	}
	public User(String iD, String name) {
		ID = iD;
		this.imageURL = "http://graph.facebook.com/" + iD + "/picture?type=normal";
		this.name = name;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getImageURL() {
		return imageURL;
	}
	public void setImageURL(String imageURL) {
		this.imageURL = imageURL;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String toString() {
		return "User [ID=" + ID + ", imageURL=" + imageURL + ", name=" + name
				+ "]";
	}
	
	

}
