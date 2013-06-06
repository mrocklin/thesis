! Compile with
! mpif90 profile_gemm.f90 -lblas
! mpirun a.out > times.dat


program TimeBlas
    implicit none
include 'mpif.h'
    integer,parameter :: n = 1000
    integer,parameter :: k = 1000
    real*8 :: X(n,n), Y(n,n), times(k)
    integer :: i, j


    do i = 1, k
        call py_f(X, Y, n, times(i))
    end do

    write (*, *) "", times

end program 


subroutine f(X, Y, time_2)
  implicit none
include 'mpif.h'

! ===================== !
! Argument Declarations !
! ===================== !
  real(kind=8), intent(in) :: X(:,:)
  real(kind=8), intent(inout) :: Y(:,:)
  real*8, intent(out) :: time_2

! ===================== !
! Variable Declarations !
! ===================== !
  real*8 :: time_4
  real*8 :: time_3
  integer :: n

  interface
  
  end interface

! ======================== !
! Variable Initializations !
! ======================== !
  n = size(X, 1)

! ========== !
! Statements !
! ========== !
  time_3 = MPI_Wtime()
  call dgemm('N', 'N', n, n, n, 1.00000000000000d+0, &
             X, n, &
             Y, n, 0.0d+0, &
             Y, n)
  time_4 = MPI_Wtime()
  time_2 = time_4 - time_3

  return
end subroutine f

  
subroutine py_f(X, Y, n, time_2)
  implicit none
  integer, intent(in) :: n
  real(kind=8), intent(in) :: X(n,n)
  real(kind=8), intent(inout) :: Y(n,n)
  real*8, intent(out) :: time_2

    interface 
      subroutine f(X,Y,time_2)
        real(kind=8), intent(in) :: X(:,:)
        real(kind=8), intent(inout) :: Y(:,:)
        real*8, intent(out) :: time_2
      end subroutine 
    end interface


  call f(X,Y,time_2)

end subroutine
