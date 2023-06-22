use <catchnhole/catchnhole.scad>;

$fn = 100;

/* [ Fits ] */
fit = 0.1;
loose_fit = 0.25;

/* [ Preset ] */
// Presets for easy foot generation:
preset = "custom";  // ["3030", "2020", "prusa-i3", "custom"]

// These are the defaults for a Prusa i3 feet:

/* [ Custom profile ] */
// Width of the printer profile:
d = 30;

// Depth of the printer profile slot:
slot_d = 9.2;
// Width of the printer profile:
slot_w = 8.14;

// What bolt to use for fastening the foot to the profile:
bolt = "M4";
// How much to countersink the bolt (1 at a minimum)
countersink = 1.25;
// T-nut width across corners (used for calculation of width of the profile drop-ins):
t_nut_w = 16.7;

// Height of the round part:
c_h = 4;

// Height of the square part, interfacing with the printer profile:
s_h = 5.75;

// Height of a hole sacrificial cover layer (0 means disabled):
hole_cover = 0.2;

module foot (
  d,                // Width of the extrusion (30 for 3030, 20 for 2020)
  slot_w,           // Width of the extrusion's slot (8.14 for 3030, 6.2 for 2020)
  slot_d,           // Depth of the extrusion's slot (9.2 for 3030, 6.1 for 2020)
  bolt,             // What bolt to use for fastening the foot to the profile
  countersink,      // How much to countersink the bolt (1 at a minimum)
  t_nut_w,          // T-nut width across corners (used for calculation of width of the
                    // profile drop-ins)
  c_h,              // Height of the round part
  s_h,              // Height of the square part
  hole_cover = 0.2  // Height of a hole sacrificial cover layer (0 means disabled):
) {
  drop_in_w = (d - t_nut_w) / 2;
  slot_w_fit = slot_w - fit;
  t_h = s_h + c_h;
  bolt_head_l = bolt_head_length(bolt, kind = "socket_head");

  difference() {
    union() {
      hull() {
        cylinder(d = d, h = c_h);
        translate([ -d / 2, -d / 2, c_h ]) cube([ d, d, s_h ]);
      }
      translate([ -slot_w_fit / 2, -d / 2, t_h ]) cube([ slot_w, d, slot_d ]);
    }

    translate([ 0, 0, t_h ]) {
      cylinder(d = t_nut_w + 2 * loose_fit, h = slot_d);
    }
    translate([ 0, 0, t_h ]) {
      rotate([ 180, 0, 0 ]) {
        bolt(bolt, length = t_h, kind = "socket_head", countersink = countersink);
      }
    }
  }

  if (hole_cover != 0) {
    translate([ 0, 0, bolt_head_l * countersink ])
      cylinder(h = hole_cover, d = bolt_diameter(bolt));
  }
}

module foot_prusa_i3 (bolt = "M4", hole_cover = 0.2) {
  foot_3030(countersink = 1.25, c_h = 4, s_h = 5.75, bolt = bolt, hole_cover = hole_cover);
}

module foot_3030 (c_h = 4, s_h = 4, bolt = "M4", countersink = 1.1, hole_cover = 0.2) {
  foot(
    d = 30, slot_w = 8.14, slot_d = 9.2, bolt = bolt, countersink = countersink,
    t_nut_w = 16.7, c_h = c_h, s_h = s_h, hole_cover = hole_cover
  );
}

module foot_2020 (c_h = 4, s_h = 4, bolt = "M4", countersink = 1.1, hole_cover = 0.2) {
  foot(
    d = 20, slot_w = 6.2, slot_d = 6.1, bolt = bolt, countersink = countersink,
    t_nut_w = 11.5, c_h = c_h, s_h = s_h, hole_cover = hole_cover
  );
}

if (preset == "3030")
  foot_3030();
else if (preset == "2020")
  foot_2020();
else if (preset == "prusa-i3")
  foot_prusa_i3();
else
  foot(d, slot_w, slot_d, bolt, countersink, t_nut_w, c_h, s_h, hole_cover);
