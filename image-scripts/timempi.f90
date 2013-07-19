! mpif90 image-scripts/timempi.f90 -o image-scripts/timempi.out
! mpirun --np 2 --hostfile hostfile image-scripts/timempi.out

program mpi_test
    implicit none
    include 'mpif.h'
    integer :: ierr
    call MPI_Init(ierr)
    call rank_switch()
    call MPI_Finalize(ierr)
    stop
end program mpi_test


subroutine rank_switch()
    implicit none
    include 'mpif.h'

    integer rank, size, ierr

    call MPI_COMM_RANK( MPI_COMM_WORLD, rank, ierr )
    call MPI_COMM_SIZE( MPI_COMM_WORLD, size, ierr )

    if (size .lt. 2)  print *, 'Need 2 processes'

    if (rank .eq. 0)  call sender()
    if (rank .eq. 1)  call recver()
end subroutine rank_switch


subroutine sender()

  

  implicit none

  include 'mpif.h'

! ===================== !
! Argument Declarations !
! ===================== !
  

! ===================== !
! Variable Declarations !
! ===================== !
  integer :: ierr_1, n, fid, i
  integer :: ierr
  real(kind=8), allocatable :: A(:)
  real*8 :: time_1
  real*8 :: time_2
  real*8 :: time_3
  integer, allocatable :: X(:)
  real(kind=8), allocatable :: times(:)
  n = 1e6

! ======================== !
! Variable Initializations !
! ======================== !
  


! ========== !
! Statements !
! ========== !
  
  open(newunit=fid, file="image-scripts/data/sizes.dat", status="old")
  read(fid, *) n
  allocate(X(n))
  allocate(times(n))
  read(fid, *) X
  close(fid)

  allocate(A(maxval(X)))

  do i = 1, n
      call MPI_BARRIER(MPI_COMM_WORLD, ierr)
      time_2 = MPI_Wtime()
      call MPI_SEND( A, X(i), MPI_DOUBLE_PRECISION, 1, 1234, MPI_COMM_WORLD, ierr_1)
      if (ierr_1 .ne. MPI_SUCCESS) print *, 'MPI_SEND Failed'
      time_3 = MPI_Wtime()
      time_1 = time_3 - time_2
      times(i) = time_1
  enddo

  open(newunit=fid, file="image-scripts/data/times_send.dat", status="replace")
  write(fid, *) times
  close(fid)
! ======================= !
! Variable Deconstruction !
! ======================= !
  

  deallocate(A)

  return
end subroutine sender

  



subroutine recver()

  

  implicit none

  include 'mpif.h'

! ===================== !
! Argument Declarations !
! ===================== !
  

! ===================== !
! Variable Declarations !
! ===================== !
  integer :: ierr_2, n, fid, i
  integer :: ierr
  integer, allocatable :: status_1(:)
  real(kind=8), allocatable :: A(:)
  real*8 :: time_4
  real*8 :: time_5
  real*8 :: time_6
  integer, allocatable :: X(:)
  real(kind=8), allocatable :: times(:)

  interface
  
  end interface

! ======================== !
! Variable Initializations !
! ======================== !
  

  allocate(status_1(MPI_STATUS_SIZE))

  open(newunit=fid, file="image-scripts/data/sizes.dat", status="old")
  read(fid, *) n
  allocate(X(n))
  allocate(times(n))
  read(fid, *) X
  close(fid)

  allocate(A(maxval(X)))

  do i = 1, n
      call MPI_BARRIER(MPI_COMM_WORLD, ierr)
      time_5 = MPI_Wtime()
      call MPI_RECV( A, X(i), MPI_DOUBLE_PRECISION, 0, 1234, MPI_COMM_WORLD, status_1, ierr_2)
      if (ierr_2 .ne. MPI_SUCCESS) print *, 'MPI_RECV Failed'
      time_6 = MPI_Wtime()
      time_4 = time_6 - time_5
      times(i) = time_4
  enddo

  open(newunit=fid, file="image-scripts/data/times_recv.dat", status="replace")
  write(fid, *) times
  close(fid)

  deallocate(A)
  deallocate(status_1)

  return
end subroutine recver

  

