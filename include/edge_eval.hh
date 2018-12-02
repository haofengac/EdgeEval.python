#ifndef EDGE_EVAL_H
#define EDGE_EVAL_H

namespace edge_eval {

struct returnVal {
    double* out1;
    double* out2;
    double cost;
    double oc;
};

class EDGE_EVAL
{
  public:
    EDGE_EVAL();
    returnVal correspondPixels(double* bmap1, double* bmap2,
    double _maxDist, double _outlierCost);

}; // EDGE_EVAL

} // namespace edge_eval

#endif
