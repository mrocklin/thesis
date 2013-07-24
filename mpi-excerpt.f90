
! Machine 0 excerpt

  call MPI_IRecv( var_11, 4000000, MPI_DOUBLE_PRECISION, &
                  1, 1000, MPI_COMM_WORLD, request_1, ierr_1)
  if (ierr_1 .ne. MPI_SUCCESS) print *, 'MPI_IRecv Failed'
  call Dgemm('N', 'N', 2000, 2000, 2000, 1.0d+0, A, 2000, B, &
             2000, 0.0d+0, var_10, 2000)
  call MPI_WAIT( request_1, status_1, ierr_2)
  if (ierr_2 .ne. MPI_SUCCESS) print *, 'MPI_WAIT Failed'
  call Dgesv(2000, 2000, var_10, 2000, var_7, var_11, 2000, INFO)
  call Dlaswp(2000, var_11, 2000, 1, 2000, var_7, 1)
  
! Machine 1 excerpt

  call Dgemm('N', 'N', 2000, 2000, 2000, 1.0d+0, C, 2000, D, &
             2000, 0.0d+0, var_8, 2000)
  call MPI_ISend( var_8, 4000000, MPI_DOUBLE_PRECISION, 0, 1000,  &
                  MPI_COMM_WORLD, request_2, ierr_3)
  if (ierr_3 .ne. MPI_SUCCESS) print *, 'MPI_ISend Failed'
  call MPI_WAIT( request_2, status_2, ierr_4)
  if (ierr_4 .ne. MPI_SUCCESS) print *, 'MPI_WAIT Failed'
