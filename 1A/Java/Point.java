package figure_v2;

/**
 * @author YoucTagh
 */
public class Point {
    private double x, y;

    private static int latestId = 0;
    private int id = 0;

    Point(double x, double y) {
        latestId++;
        id = latestId;
        if (Point.inLimit(x, y)) {
            this.x = x;
            this.y = y;
        } else {
            this.x = 0;
            this.y = 0;
        }
    }

    public void display() {
        System.out.println("le point " + id + " est en position (" + x + "," + y + ")");
    }

    public double distance(Point p) {
        return Math.sqrt(Math.pow(x - p.x, 2) + Math.pow(y - p.y, 2));
    }

    public void setX(double x) {
        if (inLimit(x, this.y))
            this.x = x;
        else{
            this.x = 0;
        }
    }

    public void setY(double y) {
        if (inLimit(this.x, y))
            this.y = y;
        else{
            this.y = 0;
        }
    }

    public boolean equals(Point p) {
        return (x == p.x && y == p.y);
    }

    public static boolean inLimit(double x, double y) {
        return (x >= Drawing.getMin() && x <= Drawing.getMax()) &&
                (y >= Drawing.getMin() && y <= Drawing.getMax());
    }

    public static boolean inLimit(Point p) {
        return inLimit(p.getX(), p.getY());
    }

    public boolean deplace(double dx, double dy) {
        if (inLimit(x + dx, y + dy)) {
            x += dx;
            y += dy;
            return true;
        }
        return false;
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public int getId() {
        return id;
    }

    public static int getLatestId() {
        return latestId;
    }


}

