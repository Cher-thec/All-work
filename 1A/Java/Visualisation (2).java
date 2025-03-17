package figure_v2;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.Ellipse2D;


/**
 * @author YoucTagh
 */
public class Visualisation extends JFrame {

    private static final long serialVersionUID = 1L;

    public static void run(Drawing drawing) {
    	SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {
                // TODO Auto-generated method stub
                new Visualisation(drawing);
            }
        });
    }
    
    
    public Visualisation(Drawing drawing) {

        setSize(new Dimension((int) Drawing.getMax() + 17, (int) (Drawing.getMax() + 40)));
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);

        JPanel p = new JPanel() {
            @Override
            public void paintComponent(Graphics g) {
                Graphics2D g2 = (Graphics2D) g;
                for (Circle circle : drawing.getCircles()) {
                    Shape circleShape = new Ellipse2D.Double(
                            circle.getCentre().getX() - circle.getRayon(),
                            circle.getCentre().getY() - circle.getRayon(),
                            circle.getRayon() * 2, circle.getRayon() * 2);
                    g2.draw(circleShape);
                }
            }
        };
        setTitle("Visualisation");

        Dimension dimension = Toolkit.getDefaultToolkit().getScreenSize();
        int x = (int) ((dimension.getWidth() - getWidth()) / 2);
        int y = (int) ((dimension.getHeight() - getHeight()) / 2);
        setLocation(x, y);

        this.getContentPane().add(p);
    }

}
