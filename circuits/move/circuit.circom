pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/mimcsponge.circom";

template MoveByPath() {

    signal input ax;
    signal input ay;
    signal input bx;
    signal input by;
    signal input cx;
    signal input cy;

    signal input energy;
    signal output x_root;
    signal output y_root;
    /*
    check isNotTriangle
    (by-ay)*(cx-ax) == (cy-ay)*(bx-ax)
    */
    signal productLeft;
    productLeft <== (by-ay)*(cx-ax);
    signal productRight;
    productRight <== (cy-ay)*(bx-ax);

    component IsNotTriangle = IsEqual();
    IsNotTriangle.in[0] <== productLeft;
    IsNotTriangle.in[1] <== productRight;
    assert(IsNotTriangle.out == 0);


    // verify that the move distances (A → B ) is within the energy bounds.
    signal XSqare_ab;
    XSqare_ab <== (ax - bx) * (ax - bx);
    signal YSqare_ab;
    YSqare_ab <== (ay - by) * (ay - by);

    component Line_ab = LessThan(63);

    Line_ab.in[0] <== XSqare_ab + YSqare_ab;
    Line_ab.in[1] <== energy * energy;
    assert(Line_ab.out == 1);

    // verify that the move distances (B → C ) is within the energy bounds.
    signal XSqare_bc;
    XSqare_bc <== (cx - bx) * (cx - bx);
    signal YSqare_bc;
    YSqare_bc <== (cy - by) * (cy - by);

    component Line_bc = LessThan(63);

    Line_bc.in[0] <== XSqare_bc + YSqare_bc;
    Line_bc.in[1] <== energy * energy;
    assert(Line_bc.out == 1);

    // verify that the move distances (C → A ) is within the energy bounds.
    // signal XSqare_ca = (cx - ax) * (cx - ax);
    // signal YSqare_ca = (cy - ay) * (cy - ay);

    // component Line_ca = lessThan(63);

    // Line_ca.in[0] = XSqare_ca + YSqare_ca;
    // Line_ca.in[1] = energy * energy;
    // assert(line_ca.out === 1);

    // generate pathproof for position(x,y)

    component xProof =  MiMCSponge(2, 220, 1);
    xProof.ins[0] <-- ax;
    xProof.ins[1] <-- bx;
    xProof.k <== 0;

    component xProofRoot =  MiMCSponge(2, 220, 1);
    xProofRoot.ins[0] <-- xProof.outs[0];
    xProofRoot.ins[1] <-- cx;
    xProofRoot.k <== 0;

    component yProof =  MiMCSponge(2, 220, 1);
    yProof.ins[0] <-- ay;
    yProof.ins[1] <-- by;
    yProof.k <== 0;

    component yProofRoot =  MiMCSponge(2, 220, 1);
    yProofRoot.ins[0] <-- yProof.outs[0];
    yProofRoot.ins[1] <-- cy;
    yProofRoot.k <== 0;

    x_root <-- xProofRoot.outs[0];
    y_root <-- yProofRoot.outs[0];
}



component main = MoveByPath();