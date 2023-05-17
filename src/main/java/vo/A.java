package vo;

public class A {
	public String getFirstName() {
		return "구디";
	}
	public String getSecondName() {
		return "아카데미";
	}
	public String getFullName() {
		return this.getFirstName() + this.getSecondName();
	}
	
	public static void main(String[] args) {
		A a = new A();
		String name = a.getFullName();
		System.out.println(name);
		String fName = a.getFirstName();
		System.out.println(fName);
	}
}
