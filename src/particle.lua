
all_particles={}

function update_particles()
    for p in all(all_particles) do
        p.timer+=1
        if p.timer>p.life then del(all_particles,p) end

        --physics
        if p.grav then p.dy+=.5 end
        if p.grow then p.r+=.1 end
        if p.shrink then p.r-=.1 end

        --move
        p.x+=p.dx
        p.y+=p.dy
    end
end

function draw_particles()
    for p in all(all_particles) do
        if p.r<=1 then
            pset(p.x,p.y,p.c)
        else
            circfill(p.x,p.y,p.r,p.c)
        end
    end
end


function explode(x,y,r,num,c,t)
    for i=0, num do
        local _p={
            x=x,
            y=y,
            timer=0,
            life=(t or 30)+rnd(10),
            dx=rnd(2)-1,
            dy=rnd(2)-1,
            grav=false,
            shrink=true,
            grow=false,
            r=r,
            c=c,
        }
        add(all_particles,_p)
    end
end
