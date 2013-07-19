patterns = [
    (alpha*A*B + beta*C ,  GEMM(alpha, A, B, beta, C) ,
            True),
    (alpha*A*B + beta*C ,  SYMM(alpha, A, B, beta, C) ,
            Q.symmetric(A) | Q.symmetric(B)),
    (alpha*A*B + beta*C ,  TRMM(alpha, A, B, beta, C) ,
            Q.triangular(A) | Q.triangular(B)),
    ...]
