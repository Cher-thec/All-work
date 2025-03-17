package figure_v2;

/**
 * @author YoucTagh
 */
public class MainFigure {

    /*
     * Par hypothèse : BORNE_MIN = 0
     * et BORNE_MAX = 100
     */

    public static void main(String[] args) {
        Point p1 = new Point(2, 7);
        Point p2 = new Point(5, 2);
        Point p3 = new Point(20, 50);
        Point p4 = new Point(90, 90);
        Circle c1 = new Circle(p1,- 10);
        Circle c2 = new Circle(p2,150);
        Circle c3 = new Circle(p3,20);
        Circle c4 = new Circle(p4,50);

        // rayon negatif
        System.out.print("rayon négatif :"); 
        c1.display();
        // trop grand
        System.out.println("rayon trop grand :");
        c2.display();
        c3.display();
        // trop grand
        c4.display();

        Point p5 = new Point(30, 40);

        // p5 est dans le disque formé par c3 mais pas p1
        System.out.println("p5 est dans le disque que forme c3 ? " + c3.inDisque(p5));
        System.out.println("p1 est dans le disque que forme c3 ? " + c3.inDisque(p1));


        Circle c5 = new Circle(p5,20);

        // c3 et c5 se superpose, mais pas c3 et c1
        System.out.println("c3 et c1 se superposent ? " + c3.superpose(c1));
        System.out.println("c3 et c5 se superposent ? " + c3.superpose(c5));
    }
}