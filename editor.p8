pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
dr=split"1,0,0,-1,-1,0,0,1,1,-1,-1,-1,-1,1,1,1"
db=split"-1,0,1,0,0,-1,0,1"





function _init()

 reload(0,0,0x4000,"moonrace.p8")
 logs={}
 t=0
 init_editor(0)
 
end	


--editor
function init_editor(n)
 ents={}
 race_id=n
 map_width=split"32,40,56"[race_id+1]
 map_x=split"0,32,72"[race_id+1]
 
 
 
 
 mp=mke()
 mp.dp=0
 mp.dr=function() 
  local tx=mid(0,wp.x-60,map_width*8-128)
  local ty=mid(0,wp.y-60,256-128)
  if not cmx then 
   cmx=tx
   cmy=ty
  end 
  cmx+=(tx-cmx)*.15
  cmy+=(ty-cmy)*.15
  camera(cmx,cmy)
  map(map_x,0,0,0,map_width,32) 
  --[[
  local wp=first
  local f=function()
		 line(wp.x+3,wp.y+3,wp.next.x+3,wp.next.y+3,13)
   wp=wp.next
  end
  f()
  while wp!=first do f() end
  --]
 end
 
 local sel=function(w)
  wp.sel=false
  wp=w
  wp.sel=true
 end
 
 mp.upd=function() 
  if btn(❎) then
   if btnp(0) then
	   sel(wp.prev)
   elseif btnp(1) then
	   sel(wp.next)
   end   
   if btnp(2) then
    local nwp=mkwp((wp.next.x+wp.x)>>1,(wp.next.y+wp.y)>>1)
    nwp.prev=wp
    nwp.next=wp.next
    nwp.next.prev=nwp   
    wp.next=nwp     
    sel(nwp)
   end   
   if btnp(3) then
    kl(wp)
    wp.prev.next=wp.next
    wp.next.prev=wp.prev
    sel(wp.prev)
    if wp==first then first=wp.prev end
   end
  else
	  for i=0,3 do
	   if btnp(i) then
	    wp.x+=db[1+i*2]
	    wp.y+=db[2+i*2]
	   end
	  end
  end
  
  if btnp(🅾️) then
	  local s=""
	  local w=first
   log("save")
	  while true do
	   s=s..flr(w.x)..","..flr(w.y)..","
	   w=w.next   
    if w==first then
	    break
	   end 
	  end  
	  printh(s,"@clip") 
  end
  
  if btnp(🅾️,1) then
   init_editor((race_id+1)%3)
  end
  
 end

 
 
 local wps={}
 local path=path[race_id+1]
 for i=0,#path/2-1 do 
  local e=mkwp(path[1+i*2],path[2+i*2])
  add(wps,e)
 end
 for i=0,#wps-1 do
  local e=wps[i+1]
  e.index=i+1
  e.prev=wps[(i-1)%#wps+1]
  e.next=wps[(i+1)%#wps+1] 
 end
 wp=wps[1]
 sel(wps[1])
 first=wp
 
 
end



function mkwp(x,y)
 local e=mke(1,x,y) 
 e.dr=function(e,x,y)
  x+=3
  y+=3
	 line(x,y,e.next.x+3,e.next.y+3,13)
  local aa=wpa(e)
  local ab=wpa(e.prev)  
  local pa=ab+hmod(aa-ab,.5)/2+.25
  local dx=cos(pa)*8
  local dy=sin(pa)*8 
  line(x-dx,y-dy,x+dx,y+dy,12)
 end
 return e
end



function hmod(n,k)
 while n>=k do n-=k*2 end
 while n<-k do n+=k*2 end
 return n
end

function wpa(e) 
 local dx=e.next.x-e.x
 local dy=e.next.y-e.y
 return atan2(dx,dy) 
end



function dre(e)
 local fr=e.fr
 local x,y=e.x+e.drx,e.y+e.dry+e.z

 -- sel
 if e.sel and t%4<2 then
  fr+=1
 end
 
 -- draw
 if fr>0 and not e.nfr then
  spr(fr,x,y,e.ww/8,e.hh/8,e.flx)
 end
 if e.dr then e.dr(e,x,y) end
 -- res pal
 pal()
 
end



-->8
-- engine
function mke(fr,x,y)
 local e={
  fr=fr or 0,
  x=x or 0,
  y=y or 0,
  z=z or 0,
  drx=0,dry=0,
  t=0,dp=2,
  vx=0,vy=0,vz=0,we=0,frict=1,
  ww=8,hh=8,
 }
 add(ents,e)
 return e
end



function upe(e)
 e.t=e.t+1
 
 if e.upd then e.upd(e) end
 
 -- phys
 if e.pcol then
  pmov(e)
 else
  e.x+=e.vx
  e.y+=e.vy  
 end
 
 e.vz+=e.we
 e.z+=e.vz
 
 if e.z>0 then
  e.z*=-1
  e.vz*=-.75
 end
 e.vx*=e.frict
 e.vy*=e.frict
 e.vz*=e.frict
 
 -- counters
 for v,n in pairs(e) do
  if sub(v,1,1)=="⧗" then
   n-=1
   e[v]= n>0 and n or nil
  end
 end 
 
 
 --  tweens
 if e.twc then
  local c=min(e.twc+1/e.tws,1)
  cc=e.twcv and e.twcv(c) or c
  e.x=e.sx+(e.ex-e.sx)*cc
  e.y=e.sy+(e.ey-e.sy)*cc
  if e.jmp then
   e.z=sin(c/2)*e.jmp
  end  
  e.twc=c  
  if c==1 then
   e.twc=nil
   e.jmp=nil
   e.twcv=nil
   local f=e.twf
   if f then
    e.twf=nil
    f()
   end
  end
 end 
 
 -- trail
 if e.pid then 
	 if e.thrust or e.⧗boost then 
		 e.trx=e.x-cos(e.an)*4
		 e.try=e.y+e.z-sin(e.an)*4 
	  e.ptr=trail(e.trx,e.try,e.pid,e.ptr)
	  e.ptr.double=e.⧗boost
	 else
	  e.ptr=nil
	 end
	end 
 
 -- burn
 if e.⧗burn then
  local sz=mid(1,e.⧗burn/6,2)
  local e=shockwave(e.x+rand(3)-1,e.y+e.z+rand(3)-1,sz,sz,4,0,0)
  e.mpl=6
 end
 
 -- life
 if e.life then
  e.life-=1
  if e.life<=0 then
   kl(e)
  end 
 end
end

function kl(e)
 del(ents,e)
 if e.nxt then
  local f=e.nxt
  e.nxt=nil
  f()
 end
end

function loop(f,t,nxt)
 local e=mke()
 e.upd=f
 e.nxt=nxt
 e.life=t 
end

function wt(t,f,a,b,c)
 local e=mke()
 e.life=t
 e.nxt=function() f(a,b,c) end
end

function mv(e,dx,dy,n,f)
 mvt(e,e.x+dx,e.y+dy,n,f)
end

function mvt(e,tx,ty,n,f)
 e.sx=e.x
 e.sy=e.y
 e.ex=tx
 e.ey=ty
 e.twc=0
 e.tws=n
 e.twf=f  
 if n<0 then
  dx=e.ex-e.sx
  dy=e.ey-e.sy
  e.tws=-sqrt(dx^2+dy^2)/n
 end
end


function pmov(e,dx,dy)

 if ecol(e) then
  return
 end
 
 local bnc=not dx
 
 if not dx then
  dx,dy=e.vx,e.vy
 end
 
 local clx,cly=false,false 
 e.x+=dx
 while ecol(e) do
  e.x-=sgn(dx)
  clx=true
 end 
 e.y+=dy 
 while ecol(e) do
  e.y-=sgn(dy)
  cly=true
 end

 if bnc then
	 if clx then
	  e.vx*=-.5
	 end
	 if cly then
	  e.vy*=-.5
	 end
 end
end

function ecol(e,dx,dy)
 dx = dx or 0
 dy = dy or 0 
 local k=.25
 local a={-k,-k,-k,k,k,k,k,-k}
 for i=0,3 do
  local x=e.x+a[i*2+1]*(e.ww-1)+dx-3
  local y=e.y+a[i*2+2]*(e.hh-1)+dy-3
  if e.pcol(x,y) then 
   return true 
  end
 end
 return false
end



function _update()
 t=t+1
 foreach(ents,upe)
 
 --log(#ents)
end

function _draw()
 cls(1)


 -- ents
 for i=0,2 do
  dr_ents(i)
 end
 -- inter
 camera()
 dr_ents(10)
 
 -- log
 camera()
 cursor(0,0,8+t%8)
 for l in all(logs) do
  print(l)
 end

end

function log(n)
 add(logs,n)
 if #logs>16 then
  del(logs,logs[1])
 end
end

function dr_ents(n)
 for e in all(ents) do
  if n==1 and e.drs then e.drs(e) end
  if e.dp==n then dre(e) end
 end
end

function mspl(s)
 local s2={}
 for ss in all(split(s,"&")) do
  add(s2,split(ss))
 end
 return s2
end
-->8
-- data
path=mspl[[
129,17,199,17,215,17,228,24,233,38,226,53,212,58,149,58,133,63,128,77,130,122,141,135,160,145,208,144,225,149,231,162,232,211,228,228,215,237,169,234,121,213,99,213,83,229,22,229,13,211,12,185,18,173,32,175,45,181,62,181,73,168,73,154,67,144,51,135,22,79,20,40,25,24,40,17&
105,17,122,17,139,38,139,58,142,81,148,98,155,110,169,116,181,111,191,101,191,75,195,57,232,18,262,16,276,23,278,42,265,60,252,79,247,96,248,136,251,178,254,204,264,220,289,219,301,202,301,178,290,159,268,157,207,157,180,186,171,215,159,226,141,226,130,214,128,168,113,158,96,164,57,210,48,216,34,216,22,213,15,198,20,151,28,137,77,94,86,77,81,61,66,55,23,57,9,43,12,24,24,17,67,17&
228,167,285,167,299,168,309,176,314,194,308,213,290,228,267,228,169,228,134,230,97,233,66,231,43,223,27,206,22,184,24,156,29,128,25,103,17,78,20,54,34,41,51,35,67,37,81,44,91,61,81,84,85,114,113,124,144,129,184,127,206,120,220,92,229,80,247,72,266,82,276,101,294,108,312,96,329,82,343,76,357,85,359,104,359,150,359,197,367,215,381,224,402,225,417,210,422,192,422,96,419,76,413,61,399,44,376,30,325,26,275,26,249,25,214,16,192,11,174,16,162,32,160,67,155,100,152,140,158,159,178,168
]]
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d777d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d777d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000005200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400000945121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003767407631000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000705313353132231311300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001f32521225211251822500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001f04307032000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001340307403133030730313203072031320307203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001340307403133030730313203072031320307203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001347307473133430734313223072231321307213000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400002b05500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001f0702b0702b0402b0302b0222b0120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000131500c030131300c01013120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
