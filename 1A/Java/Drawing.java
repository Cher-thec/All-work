package figure_v2;

import java.util.ArrayList;
import java.util.Random;

/**
 * @author YoucTagh
 */
public class Drawing {
    private static final double BORNE_MIN = 0;
    private static final double BORNE_MAX = 600;

    private ArrayList<Point> points = new ArrayList<>();
    private ArrayList<Circle> circles = new ArrayList<>();

    public void generatePoints(int nb) {
        Random random = new Random(150);

        for (int i = 0; i < nb; i++) {
            points.add(new Point(
                    BORNE_MIN + random.nextInt((int) (BORNE_MAX - BORNE_MIN)),
                    BORNE_MIN + random.nextInt((int) (BORNE_MAX - BORNE_MIN))));
        }

    }

    public void generateCircles(int r) {
        for (Point point : points) {
            circles.add(new Circle(point, r));
        }
    }

    public static double getMax() {
        return BORNE_MAX;
    }

    public static double getMin() {
        return BORNE_MIN;
    }


    public int nbSuperposition() {
        int count = 0;
        for (int i = 0; i < circles.size(); i++) {
            for (int j = i + 1; j < circles.size(); j++) {
                if (circles.get(i).superpose(circles.get(j))) {
                    count++;
                    System.out.println("==========");
                    circles.get(i).display();
                    System.out.println(" And ");
                    circles.get(j).display();
                    System.out.println("==========");
                }
            }
        }
        return count;
    }

    public ArrayList<Circle> getCircles() {
        return circles;
    }

    public ArrayList<Point> getPoints() {
        return points;
    }

    public static void main(String[] args) {
        Drawing drawing = new Drawing();
        drawing.generatePoints(10);

        for (Point p : drawing.points) {
            p.display();
        }

        drawing.generateCircles(65);

        for (Circle c : drawing.circles) {
            c.display();
        }

        System.out.println("Nombre de superpositions: " + drawing.nbSuperposition());

        Visualisation.run(drawing);
        
    }
}
