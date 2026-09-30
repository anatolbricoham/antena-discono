// =====================================================================
//  Piezas imprimibles 3D para la discono casera 80-1300 MHz
//  Paramétrico (OpenSCAD). Elige la pieza con PART y exporta a STL.
//  Material recomendado: PETG o ASA (exterior, resistente UV)
// =====================================================================
PART = "todas";   // spacer | jig_cono | jig_disco | galga30 | anillo | tapa_disco | puntas | acople | tapon | todas

etiqueta = "DISCONO";  // texto grabado en el aislante

// ---------- Medidas de la antena (coinciden con la guía) ----------
rod_d        = 4.0;    // varilla de aluminio
rod_clear    = 0.35;   // holgura de impresión para la varilla
cone_hub_d   = 40;     // buje del cono (barra de aluminio Ø40)
cone_hub_h   = 25;
cone_hole_z  = 8;      // centro de los agujeros radiales, medido desde la cara superior
cone_hole_depth = 12;
disc_hub_d   = 50;     // buje del disco (barra de aluminio Ø50)
disc_hub_h   = 12;
disc_hole_depth = 15;
gap          = 12;     // separación disco-cono = grosor del aislante
bolt_r       = 12;     // tornillos de nailon M4 del aislante
tube_od      = 32;     // tubo soporte (PVC o aluminio)
tube_id      = 28.4;   // interior del tubo
coax_d       = 8;      // paso del coaxial en el tapón (RG-58 5, H-155 5.4, RG-213 10.3)
ring_r       = 90;     // radio del anillo separador (centro de las varillas)
cone_angle   = 30;     // ángulo de las varillas del cono respecto al eje
tol          = 0.4;    // holgura general de encaje
$fn = 96;

// ---------- utilidades ----------
module radial_holes(n, r0, z, d, len) {
    for (i = [0:n-1]) rotate([0,0,i*360/n])
        translate([r0, 0, z]) rotate([0,90,0]) cylinder(d=d, h=len, center=true);
}
module txt(s, size=5, h=0.8) { linear_extrude(h) text(s, size=size, halign="center", valign="center", font="Liberation Sans:style=Bold"); }

// 1) Separador aislante Ø40 x 12 (sustituye al taco de PVC/nailon). Imprimir al 100 %.
module spacer() {
    difference() {
        union() {
            cylinder(d=cone_hub_d, h=gap);
            // labio de centrado que encaja en el buje del disco (rebaje opcional)
        }
        translate([0,0,-1]) cylinder(d=6.5, h=gap+2);                 // vivo del coaxial
        for (s=[-1,1]) translate([s*bolt_r,0,-1]) cylinder(d=4.3, h=gap+2); // tornillos nailon M4
        translate([0, -14, gap-0.6]) txt(etiqueta, 3.2, 1);
    }
}

// 2) y 3) Plantillas de taladrado: se encajan sobre la barra de aluminio y guían
//    los 8 agujeros radiales (4,2 mm), los 8 de los prisioneros (3,3 mm) y el central.
module drill_jig(bar_d, hole_z, hole_depth, center_d, label) {
    wall = 10; top = 6; skirt = hole_z + 10;
    pr = bar_d/2 - hole_depth/2;          // radio de los prisioneros
    difference() {
        cylinder(d=bar_d + 2*wall, h=skirt + top);
        translate([0,0,-1]) cylinder(d=bar_d + tol, h=skirt + 1);          // encaje en la barra
        // agujeros radiales guía (centro a hole_z por debajo de la cara superior de la barra)
        radial_holes(8, bar_d/2 + wall/2, skirt - hole_z, 4.2, wall + 2);
        // guías verticales de los prisioneros M4 (broca 3,3)
        for (i=[0:7]) rotate([0,0,i*45]) translate([pr,0,skirt-1]) cylinder(d=3.4, h=top+2);
        // guía central
        translate([0,0,skirt-1]) cylinder(d=center_d, h=top+2);
        // marca de orientación
        translate([bar_d/2 + wall - 1.5, 0, skirt + top/2]) rotate([0,90,0]) cylinder(d=3, h=3, center=true);
        translate([0, -(bar_d/2 + 5), skirt + top - 0.6]) txt(label, 3.5, 1);
    }
}

// 4) Galga de 30°: se apoya en el mástil para doblar las 8 varillas del cono igual.
module galga30() {
    L = 150;
    difference() {
        linear_extrude(3) polygon([[0,0],[0,L],[L*tan(cone_angle),0]]);
        translate([12, 30, 2.2]) linear_extrude(1) text("30°", size=10, font="Liberation Sans:style=Bold");
        translate([6, 10, 2.2]) linear_extrude(1) text("apoyar en el mástil", size=4);
    }
    // tope que abraza el tubo/mástil
    translate([-3,0,0]) cube([3, L, 10]);
}

// 5) Anillo separador del cono: mantiene las 8 varillas a 45° y a 30°.
//    Las varillas entran a presión por una ranura exterior; brida opcional.
module anillo() {
    boss = 14; th = 10;
    difference() {
        union() {
            difference() { cylinder(r=ring_r + 6, h=th); translate([0,0,-1]) cylinder(r=ring_r - 6, h=th+2); }
            for (i=[0:7]) rotate([0,0,i*45]) translate([ring_r,0,0]) cylinder(d=boss, h=th);
        }
        for (i=[0:7]) rotate([0,0,i*45]) translate([ring_r,0,th/2]) {
            rotate([0,-cone_angle,0]) cylinder(d=rod_d + rod_clear, h=40, center=true);    // agujero inclinado
            rotate([0,-cone_angle,0]) translate([4,0,0]) cube([8, rod_d*0.85, 40], center=true); // ranura de clipado
            translate([0, 0, 0]) rotate([90,0,0]) translate([-4.5,0,0]) cylinder(d=3.2, h=boss+2, center=true); // brida
        }
    }
}

// 6) Tapa antilluvia del buje del disco (Ø50 x 12) con 8 ranuras para las varillas.
module tapa_disco() {
    wall = 2.4; inner_h = disc_hub_h + 4; id = disc_hub_d + tol + 0.2;
    difference() {
        cylinder(d=id + 2*wall, h=inner_h + wall);
        translate([0,0,-1]) cylinder(d=id, h=inner_h + 1);
        // ranuras desde el borde abierto hasta el centro de la varilla + radio
        for (i=[0:7]) rotate([0,0,i*45]) translate([id/2, 0, -1])
            translate([0,-(rod_d+0.6)/2,0]) cube([wall+2, rod_d+0.6, disc_hub_h/2 + rod_d/2 + 1.5]);
    }
}

// 7) Puntas protectoras de las varillas (16 uds): evitan pinchazos y el agua dentro.
module punta() {
    $fn = 40;
    difference() {
        union() { cylinder(d=9, h=10); translate([0,0,10]) sphere(d=9); }
        translate([0,0,-1]) cylinder(d=rod_d + rod_clear, h=11);
    }
}
module puntas() { for (x=[0:3], y=[0:3]) translate([x*13, y*13, 0]) punta(); }

// 8) Acople buje del cono -> tubo soporte Ø32 (el conector N queda dentro).
module acople() {
    h_sock = 30; plate = 8; d = tube_od + 2*6;
    difference() {
        cylinder(d=d, h=h_sock + plate);
        translate([0,0,-1]) cylinder(d=tube_od + tol, h=h_sock + 1);                // encaje del tubo
        translate([0,0,h_sock-1]) cylinder(d=21, h=plate+2);                        // cuerpo del conector y clavija
        for (a=[0,180]) rotate([0,0,a]) translate([16,0,h_sock-1]) cylinder(d=4.3, h=plate+2);   // M4 al buje
        for (a=[0,180]) rotate([0,0,a]) translate([16,0,h_sock+plate-3.5]) cylinder(d=8, h=4);   // alojamiento cabeza
        for (a=[90,270]) rotate([0,0,a]) translate([0,0,h_sock/2]) rotate([0,90,0]) cylinder(d=4.3, h=d, center=false); // tornillos al tubo
    }
}

// 9) Tapón inferior del tubo con paso del coaxial y drenaje.
module tapon() {
    difference() {
        union() { cylinder(d=tube_id - 0.3, h=15); translate([0,0,-3]) cylinder(d=tube_od + 4, h=3); }
        translate([0,0,-5]) cylinder(d=coax_d, h=25);
        translate([8,0,-5]) cylinder(d=3, h=25);    // drenaje
    }
}

// ---------- selector ----------
if (PART == "spacer")     spacer();
if (PART == "jig_cono")   drill_jig(cone_hub_d, cone_hole_z, cone_hole_depth, 6.2, "CONO");
if (PART == "jig_disco")  drill_jig(disc_hub_d, disc_hub_h/2, disc_hole_depth, 3.4, "DISCO");
if (PART == "galga30")    galga30();
if (PART == "anillo")     anillo();
if (PART == "tapa_disco") tapa_disco();
if (PART == "puntas")     puntas();
if (PART == "acople")     acople();
if (PART == "tapon")      tapon();
if (PART == "todas") {
    translate([0,0,0])      spacer();
    translate([70,0,0])     drill_jig(cone_hub_d, cone_hole_z, cone_hole_depth, 6.2, "CONO");
    translate([155,0,0])    drill_jig(disc_hub_d, disc_hub_h/2, disc_hole_depth, 3.4, "DISCO");
    translate([0,70,0])     tapa_disco();
    translate([70,70,0])    acople();
    translate([140,60,3])   tapon();
    translate([180,50,0])   puntas();
    translate([0,140,0])    galga30();
    translate([200,300,0])  anillo();
}
