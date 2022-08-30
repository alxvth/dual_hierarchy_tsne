/*
 * MIT License
 *
 * Copyright (c) 2021 Mark van de Ruit (Delft University of Technology)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#pragma once
#ifdef USE_FAISS

#include "dh/types.hpp"
#include "dh/util/enum.hpp"
#include "dh/util/cu/interop.cuh"

namespace dh::util {
  class KNN {
  public:
    KNN();
    KNN(const float * dataPtr, GLuint distancesBuffer, GLuint indicesBuffer, uint n, uint k, uint d);
    ~KNN();

    // Copy constr/assignment is explicitly deleted (no copying handles)
    KNN(const KNN&) = delete;
    KNN& operator=(const KNN&) = delete;

    // Move constr/operator moves handles
    KNN(KNN&&) noexcept;
    KNN& operator=(KNN&&) noexcept;

    // Perform KNN computation, storing results in provided buffers
    void comp();

    bool isInit() const { return _isInit; }

  private:
    enum class BufferType {
      eDistances,
      eIndices,

      Length
    };

    bool _isInit;
    uint _n, _k, _d;
    const float* _dataPtr;
    EnumArray<BufferType, CUGLInteropBuffer> _interopBuffers;

  public:
    // std::swap impl
    friend void swap(KNN& a, KNN& b) noexcept {
      using std::swap;
      swap(a._isInit, b._isInit);
      swap(a._n, b._n);
      swap(a._k, b._k);
      swap(a._d, b._d);
      swap(a._dataPtr, b._dataPtr);
      swap(a._interopBuffers, b._interopBuffers);
    }
  };
} // dh::util

#endif // USE_FAISS
