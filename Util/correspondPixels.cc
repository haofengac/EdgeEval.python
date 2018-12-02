#include <string.h>
#include "Matrix.hh"
#include "csa.hh"
#include "match.hh"
#include "edge_eval.hh"

extern "C" {

edge_eval::returnVal edge_eval::Eval::correspondPixels (
    double* bmap1, double* bmap2, int rows, int cols,
    double maxDist, double outlierCost)
{
    // do the computation
    double idiag = sqrt( rows*rows + cols*cols );
    double oc = outlierCost*maxDist*idiag;
    Matrix m1, m2;
    double cost = matchEdgeMaps(
        Matrix(rows,cols,bmap1), Matrix(rows,cols,bmap2),
        maxDist*idiag, oc,
        m1, m2);
    
    // set output arguments
    double *out1 = new double[rows*cols];
    double *out2 = new double[rows*cols];
    memcpy(out1,m1.data(),m1.numel()*sizeof(double));
    memcpy(out2,m2.data(),m2.numel()*sizeof(double));

    edge_eval::returnVal retval;
    retval.out1 = out1;
    retval.out2 = out2;
    retval.cost = cost;
    retval.oc = oc;
    return retval;
}

}; // extern "C"
