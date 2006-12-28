subroutine da_get_var_2d_real_cdf(file, var, data, &
                                  i1, i2, time, debug)
 
   !-----------------------------------------------------------------------
   ! Purpose: TBD
   !-----------------------------------------------------------------------
        
   implicit none

#include "netcdf.inc"

   integer, intent(in)  ::  i1, i2, time
   character (len=80), intent(in) :: file
   logical, intent(in) :: debug
   character (len=*), intent(in) :: var
   real, dimension(i1,i2), intent(out) :: data
   real(kind=8), dimension(i1,i2) :: tmp

   integer cdfid, rcode, id_data
   character (len=80) :: varnam
   integer :: ndims, natts, idims(10), istart(10),iend(10), dimids(10)
   integer :: i, ivtype

   cdfid = ncopn(file, NCNOWRIT, rcode)

   if (rcode /= 0) then
      write(unit=*, fmt='(2a)') ' error openiing netcdf file ', trim(file)
      stop
   end if

   id_data = ncvid(cdfid, var, rcode)

   rcode = nf_inq_var(cdfid, id_data, varnam, ivtype, ndims, dimids, natts)

   if (debug) then
      write(unit=*, fmt='(3a,i6)') ' get_var_2d_real_cdf: dims for ',var,' ',ndims
   end if

   do i=1,ndims
      rcode = nf_inq_dimlen(cdfid, dimids(i), idims(i))
      if (debug) then
         write(unit=*, fmt='(a,2i6)') ' dimension ',i,idims(i)
         write(unit=*, fmt='(a,i6)') ' ivtype=', ivtype
         write(unit=*, fmt='(a, a)') ' varnam=', trim(varnam)
      end if
   end do

   ! check the dimensions

   if ((i1 /= idims(1)) .or.  &
       (i2 /= idims(2)) .or.  &
       (time > idims(3))    )  then

      write(6,*) ' error in 2d_var_real read, dimension problem '
      write(6,*) i1, idims(1)
      write(6,*) i2, idims(2)
      write(6,*) time, idims(4)
      write(6,*) ' error stop '
      stop
   end if

   ! get the data
  
   istart(1) = 1
   iend(1) = i1
   istart(2) = 1
   iend(2) = i2
   istart(3) = time
   iend(3) = 1

   if ((ivtype == NF_real) .and. (kind(data) == 4)) then
      call ncvgt(cdfid,id_data,istart,iend,data,rcode)
   else if ((ivtype == NF_DOUBLE) .and. (kind(data) == 8)) then
      call ncvgt(cdfid,id_data,istart,iend,data,rcode)
   else if ((ivtype == NF_DOUBLE) .and. (kind(data) == 4)) then
      call ncvgt(cdfid,id_data,istart,iend,tmp,rcode)
      data = tmp
   else
      write(unit=*, fmt='(a, i6)') &
         'Unrecognizable ivtype:', ivtype
      stop
   end if

   if (debug) then
      write(unit=*, fmt='(a,e24.12)') ' Sample data=', data(1,1)
   end if

   call ncclos(cdfid,rcode)

end subroutine da_get_var_2d_real_cdf

