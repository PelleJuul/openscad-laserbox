// Edit the `laserbox` module further down to start creating!

// Create a line of fingers.
// w        Width of the side on which the fingers will be added.
// d        The depth of the fingers.
// t        Material thickness.
// n        Number of fingers.
// kerf     The kerf to use.
// isSide   Should be true if this is the side of a side piece.
// isTop... Should be true if this is the top or bottom row of fingers.
module fingers(w, d, t, n, kerf, isSide=false, isTopOrBottom = false)
{
    wt = w / (2 * n + 1);
        
    if (isSide)
    {
        if (isTopOrBottom)
        {
            cube([wt + kerf, d, t]);
            
            for (i = [1:(n-1)])
            {
                translate([2 * wt * i - kerf, 0, 0])
                    cube([wt + 2 * kerf, d, t]);
            }
            
            translate([2 * wt * n - kerf, 0, 0])
                cube([wt + kerf, d, t]);
        }
        else
        {
            translate([d, 0, 0])
            cube([wt + kerf - d, d, t]);
            
            for (i = [1:(n-1)])
            {
                translate([2 * wt * i - kerf, 0, 0])
                    cube([wt + 2 * kerf, d, t]);
            }
            
            translate([2 * wt * n - kerf, 0, 0])
                cube([wt + kerf - d, d, t]);
        }
    }
    else
    {
        for (i = [0:n - 1])
        {
            translate([wt + 2 * wt * i - kerf, 0, 0])
                cube([wt + 2 * kerf, d, t]);
        }
    }
}

// Create a panel for a finger box.
// w        width.
// h        length.
// t        thickness.
// edges    vector specifying the number of edges on each side (t, r, b, l).
// d        finger depth.
// isSide   Should be true if this is a side panel.
// isTop... Should be true if this is a top or bottom panel.
module panel(w, h, t, edges, kerf = 0.12, isSide=false, isTopOrBottom=false)
{
    d = t;
    translate([d, d, 0])
        cube([w - 2 * d, h - 2 * d, t]);
    
    // Top
    translate([0, h - d, 0])
        fingers(w, d, t, edges[0], kerf, !isSide, isTopOrBottom);
    
    // Right
    translate([d, 0, 0])
    rotate([0, 0, 90])
        fingers(h, d, t, edges[1], kerf, isSide);
    
    // Bottom
    fingers(w, d, t, edges[2], kerf, !isSide, isTopOrBottom);
    
    // Left
    translate([w, 0, 0])
    rotate([0, 0, 90])
        fingers(h, d, t, edges[3], kerf, isSide);
}

// Create a finger jointed box for laser cutting.
// l            Box length (x).
// w            Box width (y).
// h            Box height (z).
// t            Material thickness.
// fingerSize   Desired finger/slot size (will be changed slightly).
// kerf         Kerf to use for laser cutting (default to Epilog 60W C02 laser on 3mm MDF).
// laserCut     Lay out the sides ready for laser cutting.
module laserbox(l, w, h, t, fingerSize, kerf = 0.1, laserCut=false)
{
    // Calculate the number of fingers on each side
    nl = floor(l / fingerSize);
    nw = floor(w / fingerSize);
    nh = floor(h / fingerSize);
    
    // The following modules can be edited if you want to add additional features
    // on your box.
    
    module top()
    {
        // The top panel uses kerf=0 to make it easy to remove again.
        color("pink");
            panel(l, w, t, [nl, nw, nl, nw], kerf = 0, isSide = false, isTopOrBottom=true);
    }
    
    module bottom()
    {
        color("pink");
            panel(l, w, t, [nl, nw, nl, nw], kerf = kerf, isSide = false, isTopOrBottom=true);
    }
    
    module left()
    {
        color("blue")
            panel(h, w, t, [nh, nw, nh, nw], kerf = kerf, isSide=true);
    }
    
    module right()
    {
        color("blue")
            panel(h, w, t, [nh, nw, nh, nw], kerf = kerf, isSide=true);
    }
    
    module front()
    {
        color([0.0, 1.0, 0])
        panel(l, h, t, [nl, nh, nl, nh], kerf = kerf, isSide=true);
    }
    
    module back()
    {
        color([0.0, 1.0, 0])
        panel(l, h, t, [nl, nh, nl, nh], kerf = kerf, isSide=true);
    }
    
    if (laserCut)
    {
        top();
        
        translate([l + 1, 0, 0])
            bottom();
        
        translate([2 * (l + 1), 0, 0])
            left();
        
        translate([2 * (l + 1) + h + 1, 0, 0])
            right();
        
        translate([2 * (l + 1) + 2 * (h + 1), 0, 0])
            front();
        
        translate([2 * (l + 1) + 2 * (h + 1) + l + 1, 0, 0])
            back();
    }
    else
    {
        translate([0, 0, h - t])
        top();
    
        bottom();

        translate([l, 0, 0])
        rotate([0, -90, 0])
            left();

        translate([t, 0, 0])
        rotate([0, -90, 0])
            right();
              
        translate([0, t, 0])
        rotate([90, 0, 0])
            front();
        
        translate([0, w, 0])
        rotate([90, 0, 0])
            back();
    }
}

// To get your box ready for laser cutting:
// - Set lasetCut=true below.
// - Uncomment the `projection()` command below and render your box.
// - Choose File > Export > Export as SVG... and save an .svg file.
// - Open the .svg file in Illustrator (or other vector software) and arrange for laser cutting.

// projection()
laserbox(100, 50, 40, 3, 20, kerf=0.1, laserCut=false);