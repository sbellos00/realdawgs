package RentIt;

/**
 * Reservation model class
 */
public class Reservation {

    private String apartment;
    private String user;
    private String check_in;
    private String check_out;
    private int numOfNights;

    /**
     * Constructor
     */
    public Reservation(String apartment, String user, String check_in, String check_out, int numOfNights) {
        this.apartment = apartment;
        this.user = user;
        this.check_in = check_in;
        this.check_out = check_out;
        this.numOfNights = numOfNights;
    }

    // Getters
    public String getApartment() {
        return apartment;
    }

    public String getUser() {
        return user;
    }

    public String getCheck_in() {
        return check_in;
    }

    public String getCheck_out() {
        return check_out;
    }

    public int getNumOfNights() {
        return numOfNights;
    }

    // Setters
    public void setApartment(String apartment) {
        this.apartment = apartment;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public void setCheck_in(String check_in) {
        this.check_in = check_in;
    }

    public void setCheck_out(String check_out) {
        this.check_out = check_out;
    }

    public void setNumOfNights(int numOfNights) {
        this.numOfNights = numOfNights;
    }
}
