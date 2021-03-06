module mod_propag
use FFTW3
use mod_utils 
use mod_init,     only:plan_forward, plan_backward

implicit none

CONTAINS

subroutine propag_1d(wfx,wfp,ngrid,theta_v1,kin_p1,dt)
implicit none
  complex(DP), intent(inout)    :: wfx(:),wfp(:),theta_v1(:),kin_p1(:)
  real(DP), intent(in)          :: dt
  integer, intent(in)           :: ngrid
  integer                       :: i

      ! V(t/2)
      do i=1, ngrid
        wfx(i) = wfx(i)*theta_v1(i)
      end do
      ! FFT -> K
      call dfftw_plan_dft_1d(plan_forward, ngrid, wfx, wfp, FFTW_FORWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_forward, wfx, wfp)
      call dfftw_destroy_plan(plan_forward)

      ! p(t)
      do i=1, ngrid
        wfp(i) = wfp(i)*kin_p1(i)
      end do

      ! FFT -> x
      call dfftw_plan_dft_1d(plan_backward, ngrid, wfp, wfx, FFTW_BACKWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_backward, wfp, wfx)
      call dfftw_destroy_plan(plan_backward)

      ! V(t/2)
      do i=1, ngrid
        wfx(i) = wfx(i)*theta_v1(i)
      end do


end subroutine propag_1d

subroutine propag_2d(wf2x,wf2p,ngrid,theta_v2,kin_p2,dt)
implicit none
  complex(DP), intent(inout)    :: wf2x(:,:),wf2p(:,:),theta_v2(:,:),kin_p2(:,:)
  real(DP), intent(in)          :: dt
  integer, intent(in)           :: ngrid
  integer                       :: i,j

      ! V(t/2)
      do i=1, ngrid
       do j=1, ngrid
        wf2x(i,j) = wf2x(i,j)*theta_v2(i,j)
       end do
      end do
      ! FFT -> K
      call dfftw_plan_dft_2d(plan_forward, ngrid, ngrid, wf2x, wf2p, FFTW_FORWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_forward, wf2x, wf2p)
      call dfftw_destroy_plan(plan_forward)

      ! p(t)
      do i=1, ngrid
        do j=1, ngrid
          wf2p(i,j) = wf2p(i,j)*kin_p2(i,j)
        end do
      end do

      ! FFT -> x
      call dfftw_plan_dft_2d(plan_backward, ngrid, ngrid, wf2p, wf2x, FFTW_BACKWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_backward, wf2p, wf2x)
      call dfftw_destroy_plan(plan_backward)

      ! V(t/2)
      do i=1, ngrid
        do j=1, ngrid
          wf2x(i,j) = wf2x(i,j)*theta_v2(i,j)
        end do
      end do
end subroutine propag_2d

subroutine propag_3d(wf3x,wf3p,ngrid,theta_v3,kin_p3,dt)
implicit none
  complex(DP), intent(inout)    :: wf3x(:,:,:),wf3p(:,:,:),theta_v3(:,:,:),kin_p3(:,:,:)
  real(DP), intent(in)          :: dt
  integer, intent(in)           :: ngrid
  integer                       :: i,j,k

      ! V(t/2)
      do i=1, ngrid
       do j=1, ngrid
         do k=1, ngrid
           wf3x(i,j,k) = wf3x(i,j,k)*theta_v3(i,j,k)
         end do
        end do
      end do
      ! FFT -> K
      call dfftw_plan_dft_3d(plan_forward, ngrid, ngrid, ngrid, wf3x, wf3p, FFTW_FORWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_forward, wf3x, wf3p)
      call dfftw_destroy_plan(plan_forward)

      ! p(t)
      do i=1, ngrid
        do j=1, ngrid
          do k=1, ngrid
            wf3p(i,j,k) = wf3p(i,j,k)*kin_p3(i,j,k)
          end do
        end do
      end do

      ! FFT -> x
      call dfftw_plan_dft_3d(plan_backward, ngrid, ngrid, ngrid, wf3p, wf3x, FFTW_BACKWARD, FFTW_ESTIMATE )
      call dfftw_execute_dft(plan_backward, wf3p, wf3x)
      call dfftw_destroy_plan(plan_backward)

      ! V(t/2)
      do i=1, ngrid
        do j=1, ngrid
          do k=1, ngrid
            wf3x(i,j,k) = wf3x(i,j,k)*theta_v3(i,j,k)
          end do
        end do
      end do

end subroutine propag_3d


end module 
