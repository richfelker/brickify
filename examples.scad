use <brickify.scad>;

compat = "lego"; // [lego, duplo]
shape = "rectangle"; // [rectangle, oval, triangle, blob, heart, wing, star, text]
height = 6; // [2,3,6]
round_corners = 0; // .1
xscale = 4; // .125
yscale = 2; // .125
text = "C";
no_studs=false;

brickify(std=compat,units="studs",no_studs=no_studs,height=height)
offset(r=round_corners) offset(delta=-round_corners)
scale([xscale,yscale])
{
	if (shape=="rectangle") square(1);
	if (shape=="oval") translate([.5,.5]) circle(d=1);
	if (shape=="triangle") polygon([[0,0],[0,1],[1,0]]);
	if (shape=="blob") scale(1/4) union() {
		translate([1,1]) circle(d=2);
		translate([2,1]) circle(d=2);
		translate([1.5,2]) circle(d=2);
	}
	if (shape=="heart") for (i=[0,1]) hull() {
		translate([.5,.01]) circle(d=.02);
		translate([.3+.4*i,.7]) circle(d=.6);
	}
	if (shape=="wing") scale(1/4) polygon([[0,0],[0,4],[1,4],[4,2],[4,0]]);
	if (shape=="star") scale(.5)
	translate([1.25,1]) for (i=[0:4]) rotate(i*360/5) hull() {
		translate([0,1.1]) circle(d=.25);
		circle(d=1);
	}
	if (shape=="text") offset(delta=.05) text(text=text,font="Liberation Sans:style=Bold",size=1);
}
