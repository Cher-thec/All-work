package figure_v2;

/**
 * @author YoucTagh
 */
public class Circle {
    private Point centre;
    private double rayon;

    public Circle(Point p, double r) {
        centre = p;
        if (r < 0) 
        	r = -r;
        
       
       /* 
            new Circle(this);
        } else if (centre.getX() + r > Drawing.getMax()) {
            new Circle(this);
        } else if (centre.getY() + r > Drawing.getMax()) {
            new Circle(this);
        } else if (centre.getX() - r < Drawing.getMin()) {
            new Circle(this);
        } else if (centre.getY() - r < Drawing.getMin()) {
            new Circle(this);
        } else {
            rayon = r;
        }
        */
    }

	
    public Point getCentre() {
        return centre;
    }


    public double getRayon() {
        return rayon;
    }

    public boolean superpose(Circle c) {
        return centre.distance(c.getCentre()) < (rayon + c.getRayon());
    }

    public void display() {
        System.out.print("le cercle a pour rayon " + rayon + ", son centre est ");
        centre.display();
    }

    public boolean inDisque(Point p) {
        return centre.distance(p) <= rayon;
    }

}
