# distutils: language = c++
# distutils: sources = correspondPixels.cc
import numpy as np
cimport numpy as np

from libcpp.vector cimport vector
from libc.stdlib cimport malloc, free


cdef extern from "edge_eval.hh" namespace "edge_eval":
    cdef struct s_returnVal:
        double* out1
        double* out2
        double cost
        double oc

    ctypedef s_returnVal returnVal

    cdef cppclass Eval:
        returnVal correspondPixels(double* bmap1, double* bmap2, int rows, int cols,
    double maxDist, double outlierCost)
        returnVal correspondPixels(double* bmap1, double* bmap2, int rows, int cols,
    double maxDist)
        returnVal correspondPixels(double* bmap1, double* bmap2, int rows, int cols)

cdef class EdgeEval:

    cdef Eval *_thisptr

    def __cinit__(self):
        self._thisptr = new Eval()
        if self._thisptr == NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef double* numpyToC(self, np.ndarray[double] arr, double* point_to_arr, int N):
        cdef np.ndarray[double, ndim=1, mode="c"] arr_cython = \
                                 np.asarray(arr, dtype = float, order="C")
        if not point_to_arr: raise MemoryError
        try:
            for i in range(N): 
                point_to_arr[i] = arr_cython[i]
        except:
            raise Exception

    cpdef double getCost(self, bmap1, bmap2):
        assert bmap1.shape == bmap2.shape
        rows, cols = bmap1.shape
        bmap1, bmap2 = bmap1.flatten(), bmap2.flatten()
        cdef N = rows * cols
        cdef double* bmap1_c = <double *>malloc(N * sizeof(double))
        self.numpyToC(bmap1, bmap1_c, N)
        cdef double* bmap2_c = <double *>malloc(N * sizeof(double))
        self.numpyToC(bmap2, bmap2_c, N)
        result = self._thisptr.correspondPixels(bmap1_c, bmap2_c, rows, cols).cost
        free (bmap1_c)
        free (bmap2_c)
        return result

    cpdef double getOutlierCost(self, bmap1, bmap2):
        assert bmap1.shape == bmap2.shape
        rows, cols = bmap1.shape
        cdef N = rows * cols
        cdef double* bmap1_c = <double *>malloc(N * sizeof(double))
        self.numpyToC(bmap1, bmap1_c, N)
        cdef double* bmap2_c = <double *>malloc(N * sizeof(double))
        self.numpyToC(bmap2, bmap2_c, N)
        result = self._thisptr.correspondPixels(bmap1_c, bmap2_c, rows, cols).oc
        free (bmap1_c)
        free (bmap2_c)
        return result

