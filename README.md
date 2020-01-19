# Brickify

A simple OpenSCAD module for generation of LEGO/DUPLO compatible
bricks. Unlike other parametric brick generators, this one takes an
arbitrary OpenSCAD 2D object as input and produces a brick of the
matching shape, deriving the necessary outer wall holes, splines,
large and small posts, and studs from the 2D object.

This package is geared towards integration with OpenSCAD tooling and
requires some familiarity with OpenSCAD usage to produce custom
output.


## Simple Usage

The `brickify` module expects the 2D object it operates on to be in
the first quadrant, with units in stud cells. If you prefer absolute
units, you can pass `units="absolute"`. By default, sizes up to 12x12
are supported; the `maxrows` and `maxcols` arguments can be passed to
increase the limits arbitrarily, at the cost of processing time.

As an example, `brickify() square([2,4]);` will produce a full height
(six 1.6mm units) 2x4 LEGO-compatible brick.


## Basic Parameters

- `std` - brick standard, "lego" or "duplo"
- `height` - in logical units (1.6 mm for LEGO, 3.2 mm for DUPLO)

For LEGO, the standard heights are 2 (plate) and 6 (brick). For DUPLO,
they are 3 (half height, matching LEGO brick) 6 (full height, double
LEGO), and 12 (double DUPLO).


## Custom stud layout

When operating on two child objects, the second is used as a stud mask
- studs appear only in positions where they fully fit within the
object. For example,

```
brickify() {
	square([2,4]);
	square([2,2]);
}
```

will produce a 2x4 brick with studs only on one half.


## Additional Parameters

- `holded_studs` - solid or hollow studs; default depends on `std`
- `stud_fudge` - added to nominal stud diameter to adjust for studs
   printing too small (or negative, if too large); default is 0.2
- `maxrows`, `maxcols` - default 12, increase for very large bricks
- `units` - the units in terms of which the child objects are defined,
   either "studs" (default) or "absolute"
- `wall_thickness`, `post_thickness`, `spline_thickness`, and
   `roof_thickness` - each in absolute (mm) units
- `wall_clearance` - absolute amount walls are inset by to fit with
   adjacent bricks; default is standard nominal 0.1 mm
- `full_splines` - set to false for short splines only high enough to
   catch studs; less strength but saves significant print time
- `spline_zone` and `small_post_zone` - control placement of small or
   large posts vs splines; unit is fraction of stud spacing


## Stability

This is a work in progress, and may change in incompatible ways. Peg a
particular revision if consistent, reproducible behavior is needed.
