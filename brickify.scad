$fs=.1;

module brickify(
	height=6,
	std="lego",
	maxrows=12,
	maxcols=12,
	units="studs",
	stud_fudge=.2,
	holed_studs=undef,
	no_studs=false,
	spline_zone=1/4,
	small_post_zone=1/4,
	wall_thickness=1.2,
	post_thickness=1,
	roof_thickness=1,
	spline_thickness=1,
	wall_clearance=.1,
	full_splines=true)
{
	unit = std=="duplo" ? 3.2 : 1.6;
	spacing = 5*unit;

	stud_diameter = std=="duplo" ? 9.35 : 4.85;
	stud_height = std=="duplo" ? 4.4 : unit;
	stud_inner_diameter = is_undef(holed_studs)
		? (holed_studs || std=="duplo") ? stud_diameter-1 : 0 : 0;

	large_post_diameter = sqrt(2)*spacing - stud_diameter + .1;
	small_post_diameter = spacing - stud_diameter;

	large_post_inner_diameter = std=="duplo"
		? large_post_diameter - 2*post_thickness
		: stud_diameter + stud_fudge;

	rows = maxrows;
	cols = maxcols;
	epsilon = .01;

	stud_clearance = unit/8;
	hole_height = stud_height + stud_clearance;
	spline_height = full_splines ? height*unit : hole_height;

	module make_walls() {
		difference() {
			offset(r=-wall_clearance) children();
			offset(r=-wall_thickness-wall_clearance) children();
		}
	}

	module large_post_points() {
		for (x=[0:1:rows], y=[0:1:cols]) translate([spacing*x,spacing*y])
		circle(r=epsilon);
	}

	module small_post_points() {
		for (x=[0:.5:rows], y=[0:.5:cols])
		if (round(x+y)!=x+y)
		translate([spacing*x,spacing*y])
		circle(r=epsilon);
	}

	module large_post_outlines() {
		d = large_post_diameter;
		intersection() {
			offset(r=d/2-epsilon)
			intersection() {
				offset(-small_post_zone*spacing+2*epsilon) children();
				large_post_points();
			}
			offset(r=-wall_thickness/2) children();
		}
	}

	module small_post_outlines() {
		d = small_post_diameter;
		difference() {
			intersection() {
				offset(r=d/2-epsilon)
				intersection() {
					offset(-spline_zone*spacing+2*epsilon) children();
					small_post_points();
				}
				offset(r=-wall_thickness/2) children();
			}
			offset(r=d)
			large_post_outlines() children();
		}
	}

	module post_outlines() {
		large_post_outlines() children();
		small_post_outlines() children();
	}

	module make_splines() {
		difference() {
			intersection() {
				union() {
					for (x=[1:rows]) translate([-spline_thickness/2+spacing*(x-1/2),0]) square([spline_thickness, spacing*cols]);
					for (y=[1:cols]) translate([0,-spline_thickness/2+spacing*(y-1/2)]) square([spacing*rows, spline_thickness]);
				}
				offset(r=-wall_clearance) children();
			}
			offset(r=stud_diameter/2-epsilon) post_outlines() children();
			make_holes();
		}
	}

	module make_posts() {
		difference() {
			post_outlines() children();
			offset(r=large_post_inner_diameter/2-epsilon)
			large_post_points() children();
			offset(r=-post_thickness) small_post_outlines() children();
		}
	}

	module make_holes() {
		offset(r=stud_diameter/2-epsilon) stud_points() children();
	}

	module stud_points() {
		for (x=[1:1:rows], y=[1:1:cols])
		translate([spacing*(x-1/2),spacing*(y-1/2)])
		circle(r=epsilon);
	}

	module make_studs() {
		difference() {
			offset(r=(stud_diameter+stud_fudge)/2-epsilon)
			intersection() {
				offset(r=-stud_diameter/2+.1) children();
				stud_points();
			}
			if (stud_inner_diameter > 0)
			offset(r=stud_inner_diameter/2-epsilon)
			stud_points();
		}
	}

	module make_brick() {
		linear_extrude(height=height*unit,convexity=4)
		make_posts(rows=maxrows,cols=maxcols) children(0);

		linear_extrude(height=spline_height,convexity=4)
		make_splines() children(0);

		linear_extrude(height=hole_height,convexity=4)
		difference() {
			make_walls() children(0);
			make_holes();
		}

		translate([0,0,hole_height])
		linear_extrude(height=height*unit-hole_height,convexity=4)
		make_walls() children(0);

		translate([0,0,height*unit-roof_thickness])
		linear_extrude(height=roof_thickness)
		offset(r=-wall_clearance)
		children(0);

		if (!no_studs)
		translate([0,0,height*unit-epsilon])
		linear_extrude(height=stud_height+epsilon)
		make_studs() children(1);

		if ($preview)
		#color("red")
		linear_extrude(height=stud_height)
		make_studs() offset(r=stud_diameter+.1) children(0);
	}

	make_brick() {
		scale(units=="studs" ? spacing : 1) children(0);
		scale(units=="studs" ? spacing : 1) children($children>1 ? 1 : 0);
	}
}
