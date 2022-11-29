use <catchnhole/catchnhole.scad>;

$fn = 100;

fit = 0.1;
loose_fit = 0.25;

// Width of the printer profile:
d = 30;

// Depth of the printer profile slot:
p_slot_h = 9.2;
// Width of the printer profile:
p_slot_w = 8.14;

bolt = "M4";
bolt_l = 10;
// T-nut width across corners (used for calculation of width of the profile drop-ins):
t_nut_w = 16.7;

// Height of the round part:
c_h = 4;

// Height of the square part, interfacing with the printer profile:
s_h = 5.75;

// Height of a hole sacrificial cover layer (0 means disabled):
hole_covers = 0.2;

module foot () {
  drop_in_w = (d - t_nut_w) / 2;
  slot_w = p_slot_w - fit;
  t_h = s_h + c_h;
  bolt_head_l = bolt_head_length(bolt, kind = "socket_head");
  countersink = 1.25;


  difference () {
    union () {
      hull () {
        cylinder(d = d, h = c_h);
        translate([-d / 2, -d / 2, c_h]) cube([d, d, s_h]);
      }
      translate([-slot_w / 2, -d / 2, t_h]) cube([slot_w, d, p_slot_h]);
    }

    translate([0, 0, t_h]) {
      cylinder(d = t_nut_w + 2 * loose_fit, h = p_slot_h);
    }
    translate([0, 0, t_h]) {
      rotate([180, 0, 0]) {
        bolt(bolt, length = t_h, kind = "socket_head", countersink = countersink);
      }
    }
  }

  if (hole_covers != 0) {
    translate([0, 0, bolt_head_l * countersink])
      cylinder(h = hole_covers, d = bolt_diameter(bolt));
  }
}

foot();
