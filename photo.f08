!--------------------------------------------------------------------
! AOSC 675 Final Project
!--------------------------------------------------------------------
!
! module: photo
!
!> @authors
!> Cory Martin, Sandra Roberts
!
! DESCRIPTION:
!> Module for calculating Photosynthesis
!
! REVISION HISTORY:
! May 2015 - Initial Version
!--------------------------------------------------------------------
module photo
  use input
  implicit none
contains
subroutine calc_photo(S_total,T_surf,GPP) !Probably to include information from user input as well...
  implicit none
  real, intent(in) :: S_total,T_surf
  real, intent(out) :: GPP
  real :: amax = 0.95
  real :: a = -0.025
  real :: b = 1.25
  real :: act_rad = 0.48
  real :: photo_e, NDVI,absorb_e !we have to let the user choose and do an if type statement to determine photo_e and NDIV
  !real :: watt2photon = 4.57 ! multiply watts by this number to get micromoles per second of photons

  NDVI = (S_total*.00044) - 0.075

  IF (NDVI < 0) THEN
    NDVI = 0
  END IF

  !!!! calculate photo_e
  IF ( T_surf <= 273.) THEN
    photo_e = 0
  ELSE
    IF ( S_total <= 350.) THEN
      photo_e = .065
    ELSE
      photo_e = -.000062*S_total + 0.087 ! linear relationship y=mx+b
    END IF
  END IF

  !!! factor in rainfall/soil moisture
  photo_e = photo_e * (mon_precip/15.8)
  absorb_e = amax*(a+b*NDVI)
  GPP = photo_e*absorb_e*act_rad*S_total*(4.57e-6)*(3600)*(12)

  return
end subroutine

end module
