from distutils.core import setup, Extension
from Cython.Build import cythonize
import numpy

ext = Extension("EdgeEval",
                sources=[
                	"EdgeEval.pyx",
                	"../Util/correspondPixels.cc",
                	"../Util/match.cc",
                	"../CSA++/csa.cc",
                	"../Util/Exception.cc",
                	"../Util/kofn.cc",
                	"../Util/Matrix.cc",
                	"../Util/Random.cc",
                	"../Util/String.cc",
                	"../Util/Timer.cc"
                	],
                include_dirs=[numpy.get_include()],
                language="c++")

setup(name="EdgeEval",
      ext_modules=cythonize(ext))
