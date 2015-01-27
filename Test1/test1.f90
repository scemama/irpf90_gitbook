program compute_t
    implicit none
    integer, external :: t
    write(*,*), "t=", t()
end program

integer function t()
    implicit none
    integer, external :: u1, v
    t = u1() + v() + 4
end

integer function w()
    implicit none
    integer :: d1,d2,d3,d4,d5
    call read_data(d1,d2,d3,d4,d5)
    w = d5+3
end

integer function v()
    implicit none
    integer, external :: u2, w
    v = u2() + w() + 2
end

integer function u1()
    implicit none
    integer :: d1,d2,d3,d4,d5
    integer, external :: f_u
    call read_data(d1,d2,d3,d4,d5)
    u1 = f_u(d1,d2)
end

integer function u2()
    implicit none
    integer :: d1,d2,d3,d4,d5
    integer, external :: f_u
    call read_data(d1,d2,d3,d4,d5)
    u2 = f_u(d3,d4)
end

integer function f_u(x,y)
    implicit none
    integer, intent(in)  :: x,y
    f_u = x+y+1
end



subroutine read_data(d1,d2,d3,d4,d5)
    implicit none
    integer, intent(out) :: d1,d2,d3,d4,d5
    print *,  'd1,d2,d3,d4,d5 ?'
    read (*,*) d1,d2,d3,d4,d5
end

